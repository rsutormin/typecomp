package Bio::KBase::KIDL::JSONSchema;

=head1 NAME

JSONSchema

=head1 DESCRIPTION

Module that wraps methods which take a parsed set of KIDL types and returns a JSON schema
encoding of the types with a variety of options.  Two methods are exposed:


my $json_schemas = to_json_schema($available_type_table,$options)
   Given a set of types parsed by the KIDL compiler, generate JSON schema documents
   for each type included in the type table (ignoring built-in scalar types and UnspecifiedObject
   types.  The input $available_type_table is a hash structure which can be pulled from
   the parser object as: "$parser->YYData->{cached_type_tables}"
   
   The JSON Schema document is generated in JSON Schema V4.  All types are expanded per document,
   so each document can be used independently to validate a Json instance.  The JSON Schema
   is returned with all keys sorted, and additional KBase annotations are added to the JSON
   Schema document.
   
write_json_schemas_to_file($json_schemas,$output_dir)
   Given a set of json schemas produced from 'to_json_schema', output the schemas to file in
   the specified $output_dir.
          
=head1 AUTHORS

Michael Sneddon (LBL, mwsneddon@lbl.gov)

=cut


use strict;
use warnings;
use Data::Dumper;
use JSON;
use POSIX;
use File::Path 'make_path';
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(to_json_schema write_json_schemas_to_file);

#
# usage: my $json_schemas = to_json_schema($available_type_table)
# see discription of this method at the top of the file
#
sub to_json_schema
{
    my($available_type_table) = @_; #note: external setting of options is no longer supported.
    
    
    my $json = JSON->new->canonical->allow_blessed;
    
    # set default options here if they were not set
    my $options = {};
    if(!exists($options->{jsonschema_version})) {
        $options->{jsonschema_version} = 4;
    }
    if(!exists($options->{use_kb_annotations})) {
        $options->{use_kb_annotations} = 1;
    }
    if(!exists($options->{omit_comments})) {
        $options->{omit_comments} = 1;
    }
    if(!exists($options->{use_references})) {
        $options->{use_references} = 0;
    }
    
    my $json_schemas = {};
    while (my($module_name, $types) = each %{$available_type_table})
    {
	while (my($type_name, $type) = each %{$types}) {
	    # we do not generate json schemas for built-in scalars or UnspecifiedObjects, so we skip
            next if ($type->isa("Bio::KBase::KIDL::KBT::Scalar"));
            next if ($type->isa("Bio::KBase::KIDL::KBT::UnspecifiedObject"));
	    
	    if (!exists($json_schemas->{$module_name})) {
		$json_schemas->{$module_name} = {};
	    }
	    
	    # OLD method:
	    #my $schema = '';
            #my $spacer = "    ";
	    #$schema .= "{\n";
	    # we cannot put in a link to a default reference schema, because with annotations our schemas are not default
	    # and objects will not validate.  We should define a schema standard for ourselves...
            #if($options->{jsonschema_version}==3) {
            #    #$schema .= $spacer."\"\$schema\":\"http://json-schema.org/draft-03/schema#\",\n";
            #} elsif($options->{jsonschema_version}==4) {
            #    #$schema .= $spacer."\"\$schema\":\"http://json-schema.org/draft-04/schema#\",\n";
            #}
            #$schema .= $spacer."\"id\":\"".$type->{name}."\",\n";
            #my $comment = extract_comment_from_type($type,$options);
            #$schema .= $spacer."\"description\":\"".$comment."\",\n";
            my $is_top_level = 1;
            #$schema .= get_json_schema_type_string($type,$spacer,$options,$is_top_level);
            #$schema .= map_type_to_json_schema($type,$spacer,$options);
            #$schema .= "}\n";
            
	    # New method:
	    my $schemaDocument = {};
	    $schemaDocument->{id} = $type->{name};
	    $schemaDocument->{description} = $type->{comment};
	    add_json_schema_type_info($schemaDocument,$type,$options,$is_top_level);
	    add_json_schema_definition($schemaDocument,$type,$options);
	    
            $json_schemas->{$module_name}->{$type->{name}} = $json->pretty->encode($schemaDocument); #$schema;
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
            open($out, '>'.$filepath);
            print $out $schema;
            close($out);
        }
    }
    return;
}


##############################################################
##  METHODS BELOW ARE PRIVATE
##############################################################



#
# Given a type, print the JSON schema content of this type given the $options
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

sub add_json_schema_definition {
    my($schemaDocument,$type,$options) = @_;
    
    # get the base type, this defines the structure of the JSON Schema element
    my ($base_type,$depth) = resolve_typedef($type);
    
    if ($base_type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
        #scalar primitives do not require further tags
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::UnspecifiedObject')) {
        #UndefinedObjects do not require further tags
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::List')) {
	$schemaDocument->{items} = {};
	add_json_schema_type_info(  $schemaDocument->{items},$base_type->element_type,$options,0);
	add_json_schema_definition( $schemaDocument->{items},$base_type->element_type,$options);
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
	$schemaDocument->{additionalProperties} = {};
	add_json_schema_type_info(  $schemaDocument->{additionalProperties},$base_type->value_type,$options,0);
	add_json_schema_definition( $schemaDocument->{additionalProperties},$base_type->value_type,$options);
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
        my @subtypes = @{$base_type->element_types};
	$schemaDocument->{maxItems} = scalar(@subtypes);
	$schemaDocument->{minItems} = scalar(@subtypes);
	$schemaDocument->{items} = [];
	foreach my $subtype (@subtypes) {
	    my $item = {};
	    add_json_schema_type_info(  $item,$subtype,$options,0);
	    add_json_schema_definition( $item,$subtype,$options);
	    push($schemaDocument->{items},$item);
	}
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::Struct')) {
	$schemaDocument->{properties} = {};
	$schemaDocument->{additionalProperties} = JSON::true;
	
        # get the info on this type
	my @items = @{$base_type->items};
	my @subtypes = map { $_->item_type } @items;
	my @names = map { $_->name } @items;
        my $optional_fields = get_optional_fields_map($type);
        
	for (my $i = 0; $i < @subtypes; $i++) {
	    $schemaDocument->{properties}->{$names[$i]} = {};
	    add_json_schema_type_info(  $schemaDocument->{properties}->{$names[$i]}, $subtypes[$i],$options,0);
	    add_json_schema_definition( $schemaDocument->{properties}->{$names[$i]}, $subtypes[$i],$options);
	}
        
	# always use JSON Schema V4...
	my $requiredList = [];
	for (my $i = 0; $i < @subtypes; $i++) {
            if(!exists($optional_fields->{$names[$i]})) {
		push($requiredList,$names[$i]);
	    }
        }
	if (scalar(@$requiredList) > 0 ) {
	    $schemaDocument->{required} = $requiredList;
	}
	
	return;
    }
    else
    {
	die "ERROR in map_type_to_json_schema, could not identify type:\n".Dumper($type);
    }
}


sub map_type_to_json_schema
{
    my($type,$spacer,$options) = @_;

    # get the base type, this defines the structure of the JSON Schema element
    my ($base_type,$depth) = resolve_typedef($type);
    
    # we check if we are using references or not- if we are we only put in a link 
    if ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        if($options->{use_references}) {
            my $schema = "";
            $schema .= $spacer."\"\$ref\": ";
            $schema .= "\"../".$type->module."/".$type->name.".json\"\n";
            return $schema;
        }
    }
    
    if ($base_type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
        #scalar primitives do not require further tags
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::UnspecifiedObject')) {
        #UndefinedObjects do not require further tags
        return "\n";
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::List')) {
        my $schema = ",\n";
        $schema .= $spacer."\"items\": {\n";
        $schema .= get_json_schema_type_string($base_type->element_type,$spacer."    ",$options,0);
	my $list_element_schema = map_type_to_json_schema($base_type->element_type,$spacer."    ",$options);
        if($list_element_schema ne "") { $schema .= $list_element_schema; } else { $schema .= "\n"; }
        $schema .= $spacer."}\n";
	return $schema;
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
        my $schema = ",\n";
        $schema .= $spacer."\"additionalProperties\": {\n";
        $schema .= get_json_schema_type_string($base_type->value_type,$spacer."    ",$options,0);
        
        #NOTE: key types are ignored because they are always strings in JSON.  We assume that the typecompiler
        #will catch cases where a non-string type is used
        my $map_value_schema = map_type_to_json_schema($base_type->value_type,$spacer."    ",$options);
        if($map_value_schema ne "") { $schema .= $map_value_schema; } else { $schema .= "\n"; }
        $schema .= $spacer."}\n";
	return $schema;
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
        my $schema = ",\n";
    
        my @subtypes = @{$base_type->element_types};
        $schema .= $spacer."\"maxItems\":".scalar(@subtypes).",\n";
        $schema .= $spacer."\"minItems\":".scalar(@subtypes).",\n";
        $schema .= $spacer."\"items\": [\n";
        
	my $first=0;
	foreach my $subtype (@subtypes) {
	    if($first==0) {$first=1} else { $schema .= ",\n"}
	    $schema .= $spacer."    {\n";
            $schema .= get_json_schema_type_string($subtype,$spacer."        ",$options,0);
            my $tuple_element_schema = map_type_to_json_schema($subtype,$spacer."        ",$options);
            if($tuple_element_schema ne "") { $schema .= $tuple_element_schema; } else { $schema .= "\n"; }
            $schema .= $spacer."    }";
	}
        $schema .= "\n".$spacer."]\n";
	return $schema;
    }
    elsif ($base_type->isa('Bio::KBase::KIDL::KBT::Struct')) {
        my $schema = ",\n";
        $schema .= $spacer."\"properties\": {\n";
        
        # get the info on this type
	my @items = @{$base_type->items};
	my @subtypes = map { $_->item_type } @items;
	my @names = map { $_->name } @items;
        my $optional_fields = get_optional_fields_map($type);
        
	for (my $i = 0; $i < @subtypes; $i++) {
            $schema .= ",\n" unless ($i==0);
	    $schema .= $spacer."    ";
            $schema .= "\"".$names[$i]."\": {\n";
            my $subtype = $subtypes[$i];
            if($options->{jsonschema_version}==3) {
                if(exists($optional_fields->{$names[$i]})) {
                    $schema .= $spacer."        \"required\":false,\n";
                } else {
                    $schema .= $spacer."        \"required\":true,\n";
                }
            }
            $schema .= get_json_schema_type_string($subtype,$spacer."        ",$options,0);
            my $struct_field_type = map_type_to_json_schema($subtype,$spacer."        ",$options);
            if($struct_field_type ne "") { $schema .= $struct_field_type; } else { $schema .= "\n"; }
            $schema .= $spacer."    }";
	}
        
	$schema .= "\n".$spacer."},\n";
        $schema .= $spacer."\"additionalProperties\":true";
        my $required_string = ''; my $n_required = 0; 
        if($options->{jsonschema_version}==4) {
            $required_string .= ",\n".$spacer."\"required\":[";
            for (my $i = 0; $i < @subtypes; $i++) {
                if(!exists($optional_fields->{$names[$i]})) {
                    $required_string .= "," unless ($n_required==0);
                    $required_string .= "\"".$names[$i]."\"";
                    $n_required++;
                }
            }
            $required_string .= "]";
        }
        #annoying that the required array must be non-empty!!! so we have to check!
        if($n_required>0) { $schema .= $required_string; }
        
        $schema .= "\n";
	return $schema;
    }
    else
    {
	die "ERROR in map_type_to_json_schema, could not identify type:\n".Dumper($type);
    }
    
}





# recursively get a map with keys being the names of optional fields for a particular typedef of a structure;
# optional fields are always added, you can never mark a previously optional field as required (yet).
sub get_optional_fields_map {
    my ($type) = @_;
    my $full_map = {}; # it's a map so that we don't add duplicates...
    if ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
	# first add what we have here...
	if (exists($type->{annotations}->{optional})) {
	    my $field_list = $type->{annotations}->{optional};
	    foreach my $f (@$field_list) {
		$full_map->{$f} = 1;
	    }
	}
	# recurse down the typedef and pickup any additional fields
	my $sub_map = get_optional_fields_map($type->{alias_type});
	foreach my $f (keys %$sub_map) {
	    $full_map->{$f} = 1;
	}
    }
    # in the updated annotation parser (as of 10/2013) optionals are not attached to Structs directly, but
    # only attached to typedefs; as such, we should pull any optional annotations from here, but we leave
    # in this bit of code (commented out in case things change again...
    #elsif ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
    #	if (exists($type->{annotations}->{optional})) {
    #	    my $field_list = $type->{annotations}->{optional};
    #	    foreach my $f (@$field_list) {
    #		$full_map->{$f} = 1;
    #	    }
    #	}
    #}
    return $full_map;
}


#
sub add_json_schema_type_info {
     my($schemaDocument,$type,$options,$is_top_level) = @_;
     
     $schemaDocument->{type} = map_type_to_json_schema_typename($type,$options);
     
     if ($options->{use_kb_annotations}) {
	$schemaDocument->{'original-type'} = map_type_to_KIDL_typename($type,$options);
	my $idrefs = get_kb_id_ref_tag($type,$options);
        if($idrefs) {
	    $schemaDocument->{"id-reference"}->{'id-type'} = $idrefs->{type};
	    if ($idrefs->{type} eq 'ws') {
		$schemaDocument->{"id-reference"}->{'valid-typedef-names'} = $idrefs->{valid_typedef_names};
	    } elsif ($idrefs->{type} eq 'external') {
		$schemaDocument->{"id-reference"}->{'sources'} = $idrefs->{sources};
	    }
	}
	my $range = get_range_annotation($type,$options);
	if ($range) {
	    foreach my $key ( keys %$range ) {
		$schemaDocument->{$key} = $range->{$key};
	    }
	}
	
	
	# only top level objects get assigned workspace searchable tags and workspace metadata tags
        if($is_top_level == 1) {
            my $ws_searchable_fields = get_searchable_ws_subset_tag($type,$options,'fields');
            my $ws_searchable_keys   = get_searchable_ws_subset_tag($type,$options,'keys');
	    if($ws_searchable_fields || $ws_searchable_keys) {
		$schemaDocument->{'searchable-ws-subset'}->{'fields'} = $ws_searchable_fields;
		$schemaDocument->{'searchable-ws-subset'}->{'keys'}   = $ws_searchable_keys;
	    }
	    
            my $ws_metadata = get_metadata_ws_tag($type,$options);
	    if ($ws_metadata) {
		$schemaDocument->{'metadata-ws'} = $ws_metadata;
	    }
        }
     }
}


sub get_range_annotation {
     my($type,$options) = @_;
     
     my $resolved_type = resolve_typedef($type);
     
     my $isInt = 1;
     if (defined($type->{scalar_type})) {
	if($type->{scalar_type} eq 'int') {
	    $isInt = 1;
	}
     }
     
     if (defined($type->{annotations}->{range})) {
	my $r = $type->{annotations}->{range};
	my $rangeForJsonSchema = {};
	if (defined($r->{minimum})) {
	    $rangeForJsonSchema->{minimum} = $r->{minimum}+0;
	    if ($isInt) {
		$rangeForJsonSchema->{minimum} = floor($rangeForJsonSchema->{minimum});
	    }
	    
	    if (defined($r->{exclusiveMinimum})) {
		if($r->{exclusiveMinimum}==1) {
		    $rangeForJsonSchema->{exclusiveMinimum}=JSON::true;
		}
	    }
	    
	}
	if (defined($r->{maximum})) {
	    $rangeForJsonSchema->{maximum} = $r->{maximum}+0;
	    if ($isInt) {
		$rangeForJsonSchema->{maximum} = ceil($rangeForJsonSchema->{maximum});
	    }
	    if (defined($r->{exclusiveMaximum})) {
		if($r->{exclusiveMaximum}==1) {
		    $rangeForJsonSchema->{exclusiveMaximum}=JSON::true;
		}
	    }
	}
	return $rangeForJsonSchema;
     }
     return;
}


sub get_json_schema_type_string {
    my($type,$spacer,$options,$is_top_level) = @_;
    # if we use references, then typedefs should not print a type, but will only have a reference
    if($options->{use_references}) {
        if ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
            return "";
        }
    }
    my $type_string = $spacer."\"type\":\"" . map_type_to_json_schema_typename($type,$options) . "\"";
    
    # if they asked for it, bind this type to a java class but only if we can resolve a type name and module name (which all structs and typedefs have)
    #if($options->{specify_java_types}) {
    #    if(defined($type->{name}) && defined($type->{module})) {
    #        $type_string   .= "\n".$spacer."\"javaType\":\"".$options->{specify_java_types}.$type->{module}.".".$type->{name}."\"";
    #    }
    #}
    # if they asked for it, output valid kb_annotations associated to the object
    if($options->{use_kb_annotations}) {
        # specify what kind of kbase type it is (helpful for distinguishing between objects and mappings) 
        $type_string .= ",\n".$spacer."\"original-type\":\"".map_type_to_KIDL_typename($type,$options)."\"";
	
        # tag things that are marked as id references
        my $idrefs = get_kb_id_ref_tag($type,$options);
        if($idrefs) {
            $type_string .= ",\n".$spacer."\"id-reference\": {";
	    $type_string .= "\n" .$spacer."   \"id-type\":\"".$idrefs->{type}."\"";
	    if ($idrefs->{type} eq 'ws') {
		$type_string .= ",\n" .$spacer."   \"valid-typedef-names\": [";
		for (my $i = 0; $i < scalar(@{$idrefs->{valid_typedef_names}}); $i++) {
		    $type_string .= "," unless ($i==0);
		    $type_string .= "\"".$idrefs->{valid_typedef_names}->[$i]."\"";
		}
		$type_string .= "]";
	    } elsif ($idrefs->{type} eq 'external') {
		$type_string .= ",\n" .$spacer."   \"sources\": [";
		for (my $i = 0; $i < scalar(@{$idrefs->{sources}}); $i++) {
		    $type_string .= "," unless ($i==0);
		    $type_string .= "\"".$idrefs->{sources}->[$i]."\"";
		}
		$type_string .= "]";
	    }
            $type_string .= "\n" .$spacer."}";
        }
        # only top level objects get assigned workspace searchable tags
        if($is_top_level == 1) {
            my $ws_searchable_fields = get_searchable_ws_subset_tag($type,$options,'fields');
            my $ws_searchable_keys   = get_searchable_ws_subset_tag($type,$options,'keys');
            if($ws_searchable_fields || $ws_searchable_keys) {
		
		$type_string .= ",\n".$spacer."\"searchable-ws-subset\": {";
		$type_string .= "\n".$spacer."    \"fields\": {";
		if ($ws_searchable_fields) {
		    $type_string .= get_searchable_ws_subset_json_schema($ws_searchable_fields,$spacer."        ");
		}
		$type_string .= "\n".$spacer."    }";
		$type_string .= ",\n".$spacer."    \"keys\": {";
		if ($ws_searchable_keys) {
		    $type_string .= get_searchable_ws_subset_json_schema($ws_searchable_keys,$spacer."        ");
		}
		$type_string .= "\n".$spacer."    }";
		$type_string .= "\n".$spacer."}";
            }
	    
            my $ws_metadata = get_metadata_ws_tag($type,$options);
	    if ($ws_metadata) {
		$type_string .= ",\n".$spacer."\"metadata-ws\": {";
		my $first_meta = 1;
		foreach my $md (keys(%$ws_metadata)) {
		    if ($first_meta) { $first_meta = 0; }
		    else {$type_string .= ','}
		    
		    $type_string .= "\n".$spacer."    \"$md\":\"$ws_metadata->{$md}\"";
		}
		$type_string .= "\n".$spacer."}";
	    }
        }
    }
    return $type_string;
}

# get a string of the json schema representation of the parsed path tree used to specify
# '@searchable ws_subset' fields and keys
sub get_searchable_ws_subset_json_schema {
    my ($parsed_path,$spacer) = @_;
    my $str = ''; my $isFirst = 1;
    if (scalar(keys(%$parsed_path)) == 0) {
	return "";
    }
    
    foreach my $field_name (keys(%$parsed_path)) {
	if (!$isFirst) { $str .= ","; } else { $isFirst = 0; }
	$str .= "\n".$spacer."\"$field_name\": {";
	$str .= get_searchable_ws_subset_json_schema($parsed_path->{$field_name},$spacer."    ");
	$str .= "\n".$spacer."}";
    }
    return $str;
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


# NOTE: probably we can replace some of this with the to_string method of KBT classes....
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
        if($type->scalar_type eq 'string') { return 'kidl-string'; }
        if($type->scalar_type eq 'int') { return 'kidl-int'; }
        if($type->scalar_type eq 'float') { return 'kidl-float'; }
        if($type->scalar_type eq 'bool') { return 'kidl-bool'; }
	die "ERROR in get_json_schema_type_name:\n".Dumper($type);
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::UnspecifiedObject')) {
        return "kidl-UnspecifiedObject";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::List')) {
	return "kidl-list";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
	return "kidl-mapping";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
	return "kidl-tuple";
    }
    elsif ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
	return "kidl-structure"
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
# function to check if typedef of a string or key of a mapping should be marked as a reference
# my $id_refs = get_kb_id_ref_tag($type,$options)
#
#   $id_refs is undef if no id_reference annotation was set for the base string or key of the mapping
#   $id_refs is {type=>[ID_TYPE],...} if @id was set and an ID_TYPE was specified, other keys may be
#      defined depending on the type of ID reference.
#
sub get_kb_id_ref_tag {
    my($type,$options) = @_;
    if($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        # at the first point where id_reference is defined, we pass back up the annotation;  this ensures that
        # the annotation always overrides previous definitions.
        if(defined($type->{annotations}->{id})) {
            return $type->{annotations}->{id};
        }
        return get_kb_id_ref_tag($type->{alias_type},$options);
    } elsif($type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
        if($type->{scalar_type} eq 'string') {
            if(defined($type->{annotations}->{id})) {
                return $type->{annotations}->{id};
            }
        }
    } elsif($type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
        return get_kb_id_ref_tag($type->{key_type},$options);
    }
    return;
}

#
# function to check what part of the object should be marked as ws searchable (if any)
# my $ws_searchable = get_kb_ws_searchable_tag($type,$options, $keyword)
#
#   $ws_searchable is undef if no elements were set to be workspace searchable
#   $ws_searchable is a ref to a hash  containing the parsed set of searchable
#       fields if @searchable ws_subset annotation was set
#   $keyword is set to 'fields' or 'keys', depending on what you want
#   $options is key/value set of options, none are supported as of now.
#
sub get_searchable_ws_subset_tag {
    my($type,$options,$keyword) = @_;
    if($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        # at the first point where a declaration is found, we grab the keyword.  This ensures we
	# can always override the searchable tag on typedefs of structures
	if(defined($type->{annotations}->{searchable_ws_subset}->{$keyword})) {
            return $type->{annotations}->{searchable_ws_subset}->{$keyword};
        }
	# otherwise, we go down to the next one...
        return get_searchable_ws_subset_tag($type->{alias_type},$options,$keyword);
    } elsif($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
        if(defined($type->{annotations}->{searchable_ws_subset}->{$keyword})) {
            return $type->{annotations}->{searchable_ws_subset}->{$keyword};
        }
    }
    return;
}

#
# function to check what part of the object should be marked as ws searchable (if any)
# my $ws_searchable = get_kb_ws_searchable_tag($type,$options, $keyword)
#
#   $ws_searchable is undef if no elements were set to be workspace searchable
#   $ws_searchable is a ref to a hash  containing the parsed set of searchable
#       fields if @searchable ws_subset annotation was set
#   $keyword is set to 'fields' or 'keys', depending on what you want
#   $options is key/value set of options, none are supported as of now.
#
sub get_metadata_ws_tag {
    my($type,$options) = @_;
    if($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        # at the first point where a declaration is found, we grab the keyword.  This ensures we
	# can always override the searchable tag on typedefs of structures
	if(defined($type->{annotations}->{metadata}->{ws})) {
            return $type->{annotations}->{metadata}->{ws};
        }
	# otherwise, we go down to the next one...
        return get_metadata_ws_tag($type->{alias_type},$options);
    } elsif($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
        if(defined($type->{annotations}->{metadata}->{ws})) {
            return $type->{annotations}->{metadata}->{ws};
        }
    }
    return;
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
    if (!exists($type->{comment})) {
	return '';
    }
    
    #todo: recurse down typedefs to get all the comments recursively...
    my $comment = $type->{comment};
    
    # escape all backslashes so that our json document is valid
    $comment =~ s/\\/\\\\/g;
    # escape all double quotes so that our json document is valid
    $comment =~ s/"/\\"/g;
    
    # we can't have newlines in a JSON document, so replace them with literal slash n
    $comment =~ s/\n/\\n/g;
    
    return $comment;
}

#  recursive loop to get the base type of a typedef
sub resolve_typedef {
    my($type) = @_;
    my $depth = 0;
    my $base_type = $type;
    while($base_type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        $base_type = $base_type->{alias_type};
        $depth++;
    }
    return ($base_type, $depth);
}


