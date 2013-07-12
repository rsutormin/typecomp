package Bio::KBase::KIDL::AnnotationParser;

=head1 NAME

JSONSchema

=head1 DESCRIPTION

Module that wraps methods which take a parsed set of KIDL types and processes embedded
comments to extract annotations.  Annotations are then appended to the type table so
that they can be accessed downstream by modules like JSONSchema that may use some
annotations to set constraints on fields.

      
=head1 AUTHORS

Michael Sneddon (LBL, mwsneddon@lbl.gov)

=cut


use strict;
use warnings;
use Data::Dumper;
use File::Path 'make_path';
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(parse_comment_for_annotations parse_all_types_for_annotations);






sub parse_comment_for_annotations
{
    my($raw_comment, $type, $options) = @_;
    
    my $annotations = {};  
    my $n_total_warnings = 0;
    my $total_warning_mssg = '';
    
    # handle the comment just like we would if we were reading from file
    for (split /^/, $raw_comment) {
        my $line = $_;
        chomp($line);
        #print "[]'".$line."'\n";
        
        #trim whitespace
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #print "[1]'".$line."'\n";
                
        #detect if we think this is an annotation (if it start with '@')
        if($line=~/^@/) {
            $line =~ s/^@//; #drop the leading '@' symbol
            my @tokens = split(/\s+/,$line);
            my $n_tokens = scalar(@tokens);
            
            #make sure we've got some tokens parsed
            if($n_tokens>0) {
                my $flag = shift(@tokens);
                
                #print "FLAG:'".$flag."\n";
                my ($n_warnings, $warning_mssg) = process_annotation($annotations,$flag,\@tokens,$type,$options);
                $n_total_warnings+=$n_warnings;
                $total_warning_mssg .= $warning_mssg;
                
             
            }
            
            
            #print Dumper(@tokens)."\n";
                     
        }
        
                
    }
    #give back what we hath found
    return ($annotations,$n_total_warnings,$total_warning_mssg);
}



sub parse_all_types_for_annotations
{
    my($type_table, $options) = @_;
    
    my $n_total_warnings = 0;
    my $total_warning_mssg = '';
    while (my($module_name, $types) = each %{$type_table})
    {
        foreach my $type (@{$types})
        {
            #print "-----".$type->{name}."\n";
            #print $type->{comment}."\n---\n";
            
            # parse to retrieve the annotations, taking note of warnings that get passed back up
            my ($annotations,$n_warnings, $warning_mssg) = parse_comment_for_annotations($type->{comment},$type,$options);
            $n_total_warnings+=$n_warnings;
            $total_warning_mssg .= $warning_mssg;
            
            # save annotations with the base typed object
            $type->{ref}->{annotations} = $annotations;
            
           # print Dumper($annotations)."\n";
        }
    }
    
    
    #print Dumper($type_table)."\n";
    
    if($n_total_warnings > 0) {
        print "total annotation warnings: ".$n_total_warnings."\n";
        print $total_warning_mssg."\n";
    }
    return;
}


#
#  supported annotations:
#
#     optional [field_name] [field_name]
#
#     id_reference [type_name]
#
#  returns ($n_warnings, $warning_mssg)
sub process_annotation {
    my($annotations, $flag, $values, $type, $options) = @_;
    
    my $n_warnings = 0;
    my $warning_mssg = '';
    
    
    # optional [field_name] [field_name] ...
    #    this flag indicates that the specified field name or names are optional, used primarily to allow
    #    optional fields during json schema based validation
    if($flag eq 'optional') {
        # first make sure we are pointint to a structure, otherwise @optional makes no sense
        if(!$type->{ref}->isa('Bio::KBase::KIDL::KBT::Struct')) {
            $warning_mssg .= "ANNOTATION WARNING: annotation '\@$flag' does nothing for non-structure types.\n";
            $warning_mssg .= "\@$flag annotation was defined for type '".$type->{module}.".".$type->{name}."', which is not a structure.\n";
            $warning_mssg .= "Note that $flag fields can ONLY be defined where the structure was originally\n";
            $warning_mssg .= "  defined, and NOT in a typedef that resolves to a structure.\n";
            $n_warnings++;
        } else {
            # we are sure that we have a structure, so get a list of field names
            my @items = @{$type->{ref}->items};
            my @subtypes = map { $_->item_type } @items;
            my @field_names = map { $_->name } @items;
            my %field_lookup_table = map { $_ => 1 } @field_names;
            
            # create the annotation object   
            if(!defined($annotations->{$flag})) { $annotations->{$flag} = []; }
            foreach my $field (@{$values}) {
                # do simple checking to see if the field exists
                if(!exists($field_lookup_table{$field})) {
                    $warning_mssg .= "ANNOTATION WARNING: annotation '\@$flag' for structure '".$type->{module}.".".$type->{name}."' indicated\n";
                    $warning_mssg .= "  a field named '$field', but no such field exists in the structure, so this constraint was ignored.\n";
                    $n_warnings++;
                    next;
                }
                # don't add it twice, and report that we found it already
                foreach my $marked_optional_field (@{$annotations->{$flag}}) {
                    if($marked_optional_field eq $field) {
                        $warning_mssg .= "ANNOTATION WARNING: annotation '\@$flag' for structure '".$type->{module}.".".$type->{name}."' has\n";
                        $warning_mssg .= "  marked a field named '$field' multiple times.\n";
                        $n_warnings++;
                        next;
                    }
                }
                # if we got here, we are good. push it to the list
                push(@{$annotations->{$flag}},$field);
            }
        }
    }
    
    
    # id_reference [type_name] [type_name] ....
    #    this annotation, if set, indicates that a typedef which resolves to a string is not just any string, but
    #    an ID that references another typed object of the given type.  The type name must be fully resolved, as
    #    in ModuleName.TypeName.  This feature is used in validation of workspace objects, so generally these ids
    #    must map to another typed object in a workspace. If multiple type_names are given, then each type is valid
    #    typenames do NOT include the version of the type definition, which must be checked on the application side.
    #    If no type names are given, then any type is valid.
    elsif($flag eq 'id_reference') {
        
        # first, we make sure that this maps to a typedef which maps to a string
        my $is_typedef_that_maps_to_string;
        if($type->{ref}->isa('Bio::KBase::KIDL::KBT::Typedef')) {
            my $base_type = $type->{ref};
            while($base_type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
                $base_type = $base_type->{alias_type};
            }
            if($base_type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
                if($base_type->{'scalar_type'} eq 'string') {
                    $is_typedef_that_maps_to_string = 1;
                }
            } 
        }
        
        #second, we ensure that an id hasn't been set already
        if(exists($annotations->{$flag})) {
            $warning_mssg .= "ANNOTATION WARNING: annotation '\@$flag' can only be declared once per typedef.\n";
            $warning_mssg .= "  typedef '".$type->{module}.".".$type->{name}."' had multiple declarations of \@$flag\n";
            $n_warnings++;
        }
        
        #ok, set the annotation if we can
        if($is_typedef_that_maps_to_string) {
            # double check that the type name is fully qualified, meaning we can parse out a ModuleName and a TypeName
            my $valid_id_types = {};
            foreach my $typename (@{$values}) {
                if(scalar(split(/\./,$typename)) == 2) {
                    # don't add duplicates
                    if(!exists($valid_id_types->{$typename})) {
                        $valid_id_types->{$typename}=1;
                    }
                } else {
                    $warning_mssg .= "ANNOTATION WARNING: annotation '\@$flag' must have a fully qualified type name (ie ModuleName.TypeName).\n";
                    $warning_mssg .= "  \@$flag annotation was defined for typedef '".$type->{module}.".".$type->{name}."' and said it is an\n";
                    $warning_mssg .= "  ID for a typed object named '$typename'.  This annotation therefore has no effect.\n";
                    $n_warnings++;
                }
            }
            push(@{$annotations->{$flag}},keys(%{$valid_id_types}));
        } else {
            $warning_mssg .= "ANNOTATION WARNING: annotation '\@$flag' can only be applied to typedefs that resolve to a string.\n";
            $warning_mssg .= "  \@$flag annotation was defined for type '".$type->{module}.".".$type->{name}."', which is not a typedef\n";
            $warning_mssg .= "  that resolves to a 'string' base type.  This annotation therefore has no effect.\n";
            $n_warnings++;
        }
    }
    
    
    
    return ($n_warnings, $warning_mssg);
}


sub resolve_typedef {
    my($type) = @_;
    while($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        $type = $type->{alias_type};
    }
    return $type;
}




