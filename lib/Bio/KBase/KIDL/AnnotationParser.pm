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
    
    # handle the comment just like we would if we were reading from file
    for (split /^/, $raw_comment) {
        my $line = $_;
        chomp($line);
        print "[]'".$line."'\n";
        
        #trim whitespace
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        print "[1]'".$line."'\n";
                
        #detect if we think this is an annotation (if it start with '@')
        if($line=~/^@/) {
            $line =~ s/^@//; #drop the leading '@' symbol
            my @tokens = split(/\s+/,$line);
            my $n_tokens = scalar(@tokens);
            
            #make sure we've got some tokens parsed
            if($n_tokens>0) {
                my $flag = shift(@tokens);
                
                print "FLAG:'".$flag."\n";
                process_annotation($annotations,$flag,\@tokens,$type,$options);
            }
            
            
            print Dumper(@tokens)."\n";
                     
        }
        
                
    }
    #give back what we hath found
    return $annotations;
}



sub parse_all_types_for_annotations
{
    my($type_table, $options) = @_;
    
    while (my($module_name, $types) = each %{$type_table})
    {
        foreach my $type (@{$types})
        {
            print "-----".$type->{name}."\n";
            print $type->{comment}."\n---\n";
            
            # parse to retrieve the annotations
            my $annotations = parse_comment_for_annotations($type->{comment},$type,$options);
            
            # save annotations with the base typed object
            $type->{ref}->{annotations} = $annotations;
            
            
            print Dumper($annotations)."\n";
        }
    }
    
    
    print Dumper($type_table)."\n";
    return;
}



sub process_annotation {
    my($annotations, $flag, $values, $type, $options) = @_;
    
    # optional [field_name] [field_name] ...
    #    this flag indicates that the specified field name or names are optional, used primarily to allow
    #    optional fields during json schema based validation
    if($flag eq 'optional') {
        # first make sure we are pointint to a structure, otherwise @optional makes no sense
        if(!$type->{ref}->isa('Bio::KBase::KIDL::KBT::Struct')) {
            print STDERR "ANNOTATION WARNING: annotation '\@optional' does nothing for non-structure types.\n";
            print STDERR "  \@optional annotation was defined for type '".$type->{module}.".".$type->{name}."', which is not a structure.\n";
            print STDERR "  Note that optional fields can ONLY be defined where the structure was originally\n";
            print STDERR "  defined, and NOT in a typedef that resolves to a structure.\n";
            return;
        }
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
                print STDERR "ANNOTATION WARNING: annotation '\@optional' for structure '".$type->{module}.".".$type->{name}."' indicated\n";
                print STDERR "  a field named '$field', but no such field exists in the structure, so this constraint was ignored.\n";
                next;
            }
            # don't add it twice, and report that we found it already
            foreach my $marked_optional_field (@{$annotations->{$flag}}) {
                if($marked_optional_field eq $field) {
                    print STDERR "ANNOTATION WARNING: annotation '\@optional' for structure '".$type->{module}.".".$type->{name}."' has\n";
                    print STDERR "  marked a field named '$field' multiple times.\n";
                    next;
                }
            }
            # if we got here, we are good. push it to the list
            push(@{$annotations->{$flag}},$field);
        }
    }
    
    
}


sub resolve_typedef {
    my($type) = @_;
    while($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
        $type = $type->{alias_type};
    }
    return $type;
}




