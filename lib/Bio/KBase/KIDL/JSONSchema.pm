package Bio::KBase::KIDL::JSONSchema;

=head1 NAME

JSONSchema

=head1 DESCRIPTION

Module that wraps methods which take a parsed set of KIDL types and returns a JSON schema
encoding of the types with a variety of options.  Two methods are exposed:


my $json_schemas = to_json_schema($type_table,$options)
   Given a set of types parsed by the KIDL compiler, generate JSON schema documents
   for each type included in the type table.  The input $type_table is a hash
   structure generated as output from the method 'assemble_types', which is currently
   found in the 'compile_typespec' script.  $options is a hash with string valued
   keys and string values.  The method returns a hash where keys are module names, and
   values are a hash where keys are type names and values are the JSON schema document
   string.  (e.g. $json_schemas has this structure: {ModuleName => { TypeName => JsonSchemaString }})
   
   valid options in the options hash are:
      "jsonschema_version"=>3|4
          this indicates whether to use jsonschema v3 or v4 when specifying required fields; by
          default all fields in a KIDL structure are required unless flagged as optional using
          KIDL type annotations; default schema version is '3'
      "use_references"=>1|0
          if this flag is set to a true value, references are used to other json schemas, which
          provides a way to identify when typedefs or composition of types in a structure are
          used; by default, this is off and all references are expanded thus producing a
          completely self-contained JSON Schema document that is useful for JSON validation
      "use_kb_annotations"=>1|0
          if this flag is set to a true value, some KBase specific information is included in
          the JSON Schema
      "omit_comments"=>1|0
          if this flag is set to a true value, comments are not copied to the 'description' field
          of the JSON Schema document; by default, this is off and all comments associated to
          types as defined in KIDL are included in the JSON Schema document
      "specify_java_types"=>[java_package]
          if this flag is set, the java type information is included in the JSON Schema; the value
          of this option is interpreted as the fully resolved java package that should be used, and
          must include the trailing dot; kbase path should be set as: "gov.doe.kbase."  Note that
          module names are automatically used as part of the path (e.g. classes are:
          gov.doe.kbase.ModuleName.TypeName)
          see also jsonschema2pojo (http://code.google.com/p/jsonschema2pojo/wiki/Reference)




write_json_schemas_to_file($json_schemas,$output_dir,$options)
   Given a set of json schemas produced from 'to_json_schema', output the schemas to file in
   the specified $output_dir.  The method also accepts an $options hash with string keys and
   string values, although currently there are no supported options available
          
          
=head1 AUTHORS

Michael Sneddon (LBL, mwsneddon@lbl.gov)

=cut


use strict;
use warnings;
use Data::Dumper;
use File::Path 'make_path';
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(to_json_schema write_json_schemas_to_file);

#
# usage: my $json_schemas = to_json_schema($type_table,$options)
# see discription of this method at the top of the file
#
sub to_json_schema
{
    my($type_table, $options) = @_;
    
    # set default options here if they were not set
    if(!exists($options->{jsonschema_version})) {
        $options->{jsonschema_version} = 3;
    }
    
    
    my $json_schemas = {};
    while (my($module_name, $types) = each %{$type_table})
    {
        $json_schemas->{$module_name} = {};
        foreach my $type (@{$types})
        {
            my $schema = '';
            my $spacer = "    ";
            
            $schema .= "{\n";
            if($options->{jsonschema_version}==3) {
                $schema .= $spacer."\"\$schema\":\"http://json-schema.org/draft-03/schema#\",\n";
            } elsif($options->{jsonschema_version}==4) {
                $schema .= $spacer."\"\$schema\":\"http://json-schema.org/draft-04/schema#\",\n";
            }
            $schema .= $spacer."\"id\":\"".$type->{name}."\",\n";
            my $comment = extract_comment_from_type($type,$options);
            $schema .= $spacer."\"description\":\"".$comment."\",\n";
            $schema .= get_json_schema_type_string($type->{ref},$spacer,$options);
            $schema .= map_type_to_json_schema($type->{ref},$spacer,$options);
            $schema .= "}\n";
            
            $json_schemas->{$module_name}->{$type->{name}} = $schema;
        }
    }
    return $json_schemas;
}




#
# usage: write_json_schemas_to_file($json_schemas,$output_dir,$options)
# see discription of this method at the top of the file
#
sub write_json_schemas_to_file
{
    my($json_schemas,$output_dir,$options) = @_;

    while ( my ($module_name, $type_hash) = each %{$json_schemas} ) {
    
        # make sure a directory exists for each module
        make_path($output_dir . "/jsonschema/" . $module_name);
            
        # loop over each type and dump the scema
        while ( my ($type_name, $schema) = each %{$type_hash} ) {
            my $filepath = $output_dir . "/jsonschema/" . $module_name . "/" . $type_name . ".json";
            my $out;
            open($out, '>>'.$filepath);
            print $out $schema;
            close($out);
        }
    }
    return;
}


##############################################################
##  METHODS BELOW ARE NOT CURRENTLY PUBLICLY ACCESSABLE
##############################################################



#
# Given a ref to a type, print the JSON schema content of this type given the $options
# and a spacer which provides the indentation level
#
#  $content = map_type_to_json_schema($type,$spacer,$options)
#     $content is a string that contains the json schema content of the object (not including the 'type' specification)
#     $type is a ref to a $type parsed from a typespec and processed by the 'assemble_types' method
#     $spacer is a string containing any characters (generally spaces) to appear before the line
#          and is mostly used to provide nice formatting
#     $options is a ref to a hash with string keys and string values used to pass options
#          to this method; currently no optional parameters are supported
#
sub map_type_to_json_schema
{
    my($type,$spacer,$options) = @_;

    if ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        if($options->{use_references}) {
            my $schema = "";
            $schema .= $spacer."\"\$ref\": ";
            $schema .= "\"../".$type->module."/".$type->name.".json\"\n";
            return $schema;
        }
        # we recurse to evaluate the type if we need to dereference typedefs
        return map_type_to_json_schema($type->alias_type,$spacer,$options);
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
        #scalar primitives do not require further tags
        return "\n";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::UnspecifiedObject'))
    {
        #UndefinedObjects do not require further tags
        return "\n";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::List')) {
        my $schema = ",\n";
        $schema .= $spacer."\"items\": {\n";
        $schema .= get_json_schema_type_string($type->element_type,$spacer."    ",$options);
	my $list_element_schema = map_type_to_json_schema($type->element_type,$spacer."    ",$options);
        if($list_element_schema ne "") { $schema .= $list_element_schema; } else { $schema .= "\n"; }
        $schema .= $spacer."}\n";
	return $schema;
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
        my $schema = ",\n";
        $schema .= $spacer."\"additionalProperties\": {\n";
        $schema .= get_json_schema_type_string($type->value_type,$spacer."    ",$options);
        
        #NOTE: key types are ignored because they are always strings in JSON.  We assume that the typecompiler
        #will catch cases where a non-string type is used
        my $map_value_schema = map_type_to_json_schema($type->value_type,$spacer."    ",$options);
        if($map_value_schema ne "") { $schema .= $map_value_schema; } else { $schema .= "\n"; }
        $schema .= $spacer."}\n";
	return $schema;
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
        my $schema = ",\n";
    
        my @subtypes = @{$type->element_types};
        $schema .= $spacer."\"maxItems\":".scalar(@subtypes).",\n";
        $schema .= $spacer."\"minItems\":".scalar(@subtypes).",\n";
        $schema .= $spacer."\"items\": [\n";
        
	my $first=0;
	foreach my $subtype (@subtypes) {
	    if($first==0) {$first=1} else { $schema .= ",\n"}
	    $schema .= $spacer."    {\n";
            $schema .= get_json_schema_type_string($subtype,$spacer."        ",$options);
            my $tuple_element_schema = map_type_to_json_schema($subtype,$spacer."        ",$options);
            if($tuple_element_schema ne "") { $schema .= $tuple_element_schema; } else { $schema .= "\n"; }
            $schema .= $spacer."    }";
	}
        $schema .= "\n".$spacer."]\n";
	return $schema;
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
        my $schema = ",\n";
        $schema .= $spacer."\"properties\": {\n";
        
	my @items = @{$type->items};
	my @subtypes = map { $_->item_type } @items;
	my @names = map { $_->name } @items;
        
	for (my $i = 0; $i < @subtypes; $i++) {
            $schema .= ",\n" unless ($i==0);
	    $schema .= $spacer."    ";
            $schema .= "\"".$names[$i]."\": {\n";
            my $type = $subtypes[$i];
            if($options->{jsonschema_version}==3) {
                $schema .= $spacer."        \"required\":true,\n";
            }
            $schema .= get_json_schema_type_string($type,$spacer."        ",$options);
            my $struct_field_type = map_type_to_json_schema($type,$spacer."        ",$options);
            if($struct_field_type ne "") { $schema .= $struct_field_type; } else { $schema .= "\n"; }
            $schema .= $spacer."    }";
	}
        
	$schema .= "\n".$spacer."},\n";
        $schema .= $spacer."\"additionalProperties\":true";
        if($options->{jsonschema_version}==4) {
            $schema .= ",\n".$spacer."\"required\":[";
            for (my $i = 0; $i < @subtypes; $i++) {
                $schema .= "," unless ($i==0);
                $schema .= "\"".$names[$i]."\"";
            }
            $schema .= "]";
        }
        $schema .= "\n";
	return $schema;
    }
    else
    {
	die "ERROR in map_type_to_json_schema, could not identify type:\n".Dumper($type);
    }
    
}



#
#  $string = get_json_schema_type_string($type,$spacer,$options)
#     $string is a string that defines the type in the json schema (e.g. "type":"object")
#          and uses the method map_type_to_json_schema_typename
#     $type is a ref to a $type parsed from a typespec and saved to
#     $spacer is a string containing any characters (generally spaces) to appear before the line
#          and is mostly used to provide nice formatting
#     $options is a ref to a hash with string keys and string values used to pass options
#          to this method; currently no optional parameters are supported
#
sub get_json_schema_type_string {
    my($type,$spacer,$options) = @_;
    # if we use references, then typedefs should not print a type, but will only have a reference
    if($options->{use_references}) {
        if ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
            return "";
        }
    }
    my $type_string = $spacer."\"type\":\"" . map_type_to_json_schema_typename($type,$options) . "\"";
    if($options->{use_kb_annotations}) {
        $type_string   .= "\n".$spacer."\"kb-type\":\"".map_type_to_KIDL_typename($type,$options)."\"";
    }
    return $type_string;
}



#
#  $typename = map_type_to_json_schema_typename($type,$options)
#     $typename is a string that contains the json schema type of the object
#     $type is a ref to a $type parsed from a typespec and processed by the 'assemble_types' method
#     $options is a ref to a hash with string keys and string values used to pass options
#          to this method; currently no optional parameters are supported
#
sub map_type_to_json_schema_typename {
    my($type,$options) = @_;
    if ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        return map_type_to_json_schema_typename($type->alias_type,$options);
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
        if($type->scalar_type eq 'string') { return 'string'; }
        if($type->scalar_type eq 'int') { return 'integer'; }
        if($type->scalar_type eq 'float') { return 'number'; }
        if($type->scalar_type eq 'bool') { return 'boolean'; }
	die "ERROR in get_json_schema_type_name:\n".Dumper($type);
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::UnspecifiedObject')) {
        return "object";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::List')) {
	return "array";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
	return "object";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
	return "array";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
	return "object"
    }
    else {
	die "ERROR in map_type_to_json_schema_typename, could not identify type:\n".Dumper($type);
    }
}


#
#  $typename = map_type_to_KIDL_typename($type,$options)
#     $typename is a string that contains the KIDL type of the object (e.g. list, mapping, tuple, ...)
#     $type is a ref to a $type parsed from a typespec and processed by the 'assemble_types' method
#     $options is a ref to a hash with string keys and string values used to pass options
#          to this method; currently no optional parameters are supported
#
sub map_type_to_KIDL_typename {
    my($type,$options) = @_;
    if ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        return map_type_to_KIDL_typename($type->alias_type,$options);
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
        if($type->scalar_type eq 'string') { return 'string'; }
        if($type->scalar_type eq 'int') { return 'int'; }
        if($type->scalar_type eq 'float') { return 'float'; }
        if($type->scalar_type eq 'bool') { return 'bool'; }
	die "ERROR in get_json_schema_type_name:\n".Dumper($type);
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::UnspecifiedObject')) {
        return "UnspecifiedObject";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::List')) {
	return "list";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
	return "mapping";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
	return "tuple";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
	return "structure"
    }
    else {
	die "ERROR in map_type_to_KIDL_typename, could not identify type:\n".Dumper($type);
    }
}




#
#  $string = extract_comment_from_type($type,$options)
#     $string is a string that contains constraints that are associated with the type as specified
#          through KIDL type annotations
#     $type is a ref to a $type parsed from a typespec and processed by the 'assemble_types' method
#     $options is a ref to a hash with string keys and string values used to pass options
#          to this method; currently no optional parameters are supported
#
sub map_type_to_json_schema_constraints {
    my($type,$options) = @_;
    return '';
}



#
#  $comments = extract_comment_from_type($type,$options)
#     $comments is a string that contains the comments for the type properly escaped so it can
#          go right into a JSON document
#     $type is a ref to a $type parsed from a typespec and processed by the 'assemble_types' method
#     $options is a ref to a hash with string keys and string values used to pass options
#          to this method; currently no optional parameters are supported
#
sub extract_comment_from_type
{
    my($type,$options) = @_;
    if($options->{omit_comments}) {
        return '';
    }
    
    my $comment = $type->{comment};
    # escape all backslashes so that our json document is valid
    $comment =~ s/\\/\\\\/g;
    # escape all double quotes so that our json document is valid
    $comment =~ s/"/\\"/g;
    
    #todo: recurse down typedefs to get all the comments recursively...
    
    return $comment;
}






