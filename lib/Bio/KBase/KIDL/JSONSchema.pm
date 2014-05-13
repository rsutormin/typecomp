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
use Math::BigInt;
use Math::BigFloat;
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
    if(!exists($options->{use_kb_annotations})) {
        $options->{use_kb_annotations} = 1;
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
	    
            my $is_top_level = 1;
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
     
     my ($resolved_type,$depth) = resolve_typedef($type);
     my $isInt = 0;
     if (defined($resolved_type->{scalar_type})) {
	if($resolved_type->{scalar_type} eq 'int') {
	    $isInt = 1;
	}
     }
     
     if (defined($type->{annotations}->{range})) {
	my $r = $type->{annotations}->{range};
	my $rangeForJsonSchema = {};
	if (defined($r->{minimum})) {
	    # note: possible loss of precision here!  TODO: extend to properly handle bigints and bigfloats
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
	    # note: possible loss of precision here!  TODO: extend to properly handle bigints and bigfloats
	    $rangeForJsonSchema->{maximum} =$r->{maximum}+0;
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


