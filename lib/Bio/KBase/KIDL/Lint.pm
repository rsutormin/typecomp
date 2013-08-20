package Bio::KBase::KIDL::Lint;



=head1 NAME

Lint

=head1 DESCRIPTION

Module that provides a LINT for the KIDL Languge, the main purpose being to
check that a module conforms to KBase API standards.

=head1 AUTHORS

Michael Sneddon (LBL, mwsneddon@lbl.gov)

=cut


use strict;
use warnings;
use Data::Dumper;
use Bio::KBase::KIDL::KBT;
use File::Path 'make_path';
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(check_for_standards);



#
#  input: $all_data_from_xml, $valid_names
#    $all_data_from_xml - the large typedef hash that contains the parsed typespec
#    $valid_names - a hash listing the names of Entities,Relationships, or other
#                   words that are permitted to be in CamelCase in func/type names
#
#  output: $err_mssg, $warn_mssg
#     $err_mssg  - ref to a list of strings of error messages.  Size 0 if no errors
#     $warn_mssg - ref to a list of strings of warning messages.  Size 0 if no warnings
#
#
sub check_for_standards {
    my ($all_data_from_xml,$valid_names) = @_;
    
    my $parsed_data = $all_data_from_xml->{parsed_data};
    my $all_types_table = $all_data_from_xml->{type_table};
    #print Dumper($all_types_table)."\n";
    
    my $err_mssg = [];
    my $warn_mssg = [];
    
    # add plurals to the list of valid names
    foreach my $key (keys $valid_names) {
        $valid_names->{$key."s"} = 1;
    }
    
    # First, we assemble a list of all typed object names, which requires a traversal over everything
    my $valid_typed_object_names = {};
    foreach my $module_name (keys %$all_types_table) {
        #loop over each module
        my $types = $all_types_table->{$module_name};
        
        foreach my $type_name (keys %$types) {
            my $type = $types->{$type_name};
            while ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
                $type = $type->{alias_type};
            }
            if ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
                $valid_typed_object_names->{$type_name} = 1;
                # allow plurals
                $valid_typed_object_names->{$type_name."s"} = 1;
            }
        }
    }
    
    # merge the hashes into our list of valid names (prob a better perl 1-liner for this...)
    foreach my $key (keys %$valid_typed_object_names) {
        $valid_names->{$key} = 1;
    }
    #print Dumper($valid_names)."\n";
    
    # do the actual check of all names of typedefs
    foreach my $service_name (keys %$parsed_data) {
        #loop over each module
        my $data = $parsed_data->{$service_name};
        foreach my $module (@$data) {
            my $module_components = $module->[1];
            foreach my $c (@$module_components) {
                my $name = $c->{name};
                my $type = $c->{ref};
                my $comment = $c->{comment};
                
                # skip if it is a deprecated method
                next if(defined $type->{annotations}->{deprecated});
                
                #resolve to the base type
                while ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
                    $type = $type->{alias_type};
                }
                
                if ($type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
                    my ($e,$w) = validate_lowercase_with_underscore($name,$valid_names, $type->{scalar_type}."s");
                    push @$err_mssg, "$e" if ($e);
                    push @$warn_mssg, "$w" if ($w);
                    
                    #scalars should have comments.  double check that
                    if(!defined($comment) || $comment eq '') { push @$warn_mssg, "'$name' missing descriptive comment. All ".$type->{scalar_type}."s should have documentation"; }
                }
                
                if ($type->isa('Bio::KBase::KIDL::KBT::List')) {
                    my ($e,$w) = validate_lowercase_with_underscore($name,$valid_names,"lists");
                    push @$err_mssg, "$e" if ($e);
                    push @$warn_mssg, "$w" if ($w);
                    
                    #lists should have comments.  double check that
                    if(!defined($comment) || $comment eq '') { push @$warn_mssg, "'$name' missing descriptive comment. All lists should have documentation"; }
                }
                
                if ($type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
                    my ($e,$w) = validate_lowercase_with_underscore($name,$valid_names,"mappings");
                    push @$err_mssg, "$e" if ($e);
                    push @$warn_mssg, "$w" if ($w);
                    
                    #mappings should have comments.  double check that
                    if(!defined($comment) || $comment eq '') { push @$warn_mssg, "'$name' missing descriptive comment. All mappings should have documentation"; }
                }
                
                if ($type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
                    my ($e,$w) = validate_lowercase_with_underscore($name,$valid_names,"tuple");
                    push @$err_mssg, "$e" if ($e);
                    push @$warn_mssg, "$w" if ($w);
                    
                    #mappings should have comments.  double check that
                    if(!defined($comment) || $comment eq '') { push @$warn_mssg, "'$name' missing descriptive comment. All tuples should have documentation"; }
                }
                
                if ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
                    my ($e,$w) = validate_CamelCase($name,"TypedObjects");
                    push @$err_mssg, "$e" if ($e);
                    push @$warn_mssg, "$w" if ($w);
                    
                    # for structures, we have to validate fields as well
                    foreach my $field (@{$type->{items}}) {
                        my ($e,$w) = validate_lowercase_with_underscore($field->{name},$valid_names,"field names of typed object '$name'");
                        push @$err_mssg, "$e" if ($e);
                        push @$warn_mssg, "$w" if ($w);
                    }
                    
                    #structures (and typedefs of structures) require comments.  double check that
                    if(!defined($comment) || $comment eq '') { push @$err_mssg, "'$name' missing descriptive comment. All TypedObject definitions require good documentation"; }
                }
            }
        }
    }
    
    
    # don't forget about our funcdef friends
    foreach my $service_name (keys %$parsed_data) {
        #loop over each module
        my $data = $parsed_data->{$service_name};
        foreach my $module (@$data) {
            my $module_components = $module->[0]->module_components;
            foreach my $func (@$module_components) {
                if ($func->isa('Bio::KBase::KIDL::KBT::Funcdef')) {
                    
                    my $name = $func->{name};
                    my $comment = $func->{comment};
                    
                    # skip if it is a deprecated method
                    next if(defined $func->{annotations}->{deprecated});
                    
                    my ($e,$w) = validate_lowercase_with_underscore($name,$valid_names,"funcdefs");
                    push @$err_mssg, "$e" if ($e);
                    push @$warn_mssg, "$w" if ($w);
                    foreach my $p (@{$func->{parameters}}) {
                        next if (!defined $p->{name});
                        my ($e,$w) = validate_lowercase_with_underscore($p->{name},$valid_names,"parameter names of function '$name'");
                        push @$err_mssg, "$e" if ($e);
                        push @$warn_mssg, "$w" if ($w);
                    }
                    foreach my $r (@{$func->{return_type}}) {
                        next if (!defined $r->{name});
                        my ($e,$w) = validate_lowercase_with_underscore($r->{name},$valid_names,"return value names of function '$name'");
                        push @$err_mssg, "$e" if ($e);
                        push @$warn_mssg, "$w" if ($w);
                    }
                    
                    #functions require comments.  double check that
                    if(!defined($comment) || $comment eq '') { push @$err_mssg, "'$name' missing descriptive comment. All function definitions require good documentation"; }
                }
                
            }
        }
    }
    
    #check module names as well
    foreach my $service_name (keys %$parsed_data) {
        #loop over each module
        my $data = $parsed_data->{$service_name};
        foreach my $module (@$data) {
            my $module_name = $module->[0]->{module_name};
            my $comment     = $module->[0]->{comment};
            
            # modules require documentation!!!
            if(!defined($comment) || $comment eq '') { push @$err_mssg, "'$module_name' missing descriptive comment. All Module definitions require good documentation"; }
            
            # Module names are always warnings!
            my ($e,$w) = validate_CamelCase($module_name,"module names");
            push @$warn_mssg, "$e" if ($e);
            push @$warn_mssg, "$w" if ($w);
            
            # check for names that start with KB, KBase, or end in service Service
            if($module_name =~ m/^KB/i) {
                 push @$warn_mssg, "'$module_name' is bad style, module names should not start with KB or KBase";
            }
            if($module_name =~ m/service$/i) {
                 push @$warn_mssg, "'$module_name' is bad style, module names should not end with the word Service";
            }
            
        }
    }
    
    return ($err_mssg,$warn_mssg);
}




sub validate_lowercase_with_underscore {
    my ($name,$valid_names, $type_name) = @_;
    my $err_mssg;
    my $warn_mssg;
    
   # print "Validating $name\n";
    
    # drop underscrores
    my @tokens = split("_",$name);
    
    my $isFirst = 1;
    foreach my $token (@tokens) {
        # first token should never be capitalized
        if(defined $isFirst) {
            undef $isFirst;
            if($token =~ m/^[A-Z]/) {
                $err_mssg = "'$name' is bad style, $type_name cannot start with a capital letter, must be lower_case_with_underscores";
                next;
            }
        }
        # token starts with an uppercase, we assume the rest is UpperCamelCase
        if($token =~ m/^[A-Z]/) {
            my $foundMatchingObjectName;
            # check if camel case is an entity or defined TypedObject
            if(!exists $valid_names->{$token}) {
                $err_mssg = "'$name' is bad style, $type_name must be lower_case_with_underscores";
            }
        }
        # token has at least one internal uppercase, we assume it is in lowerCamelCase, and
        # that is never valid
        if($token =~ m/^[a-z].*[A-Z]+/) {
            $err_mssg = "'$name' is bad style, $type_name must be lower_case_with_underscores";
        }
    }
    return ($err_mssg, $warn_mssg);
}



sub validate_CamelCase {
    my ($name, $type_name) = @_;
    my $err_mssg;
    my $warn_mssg;
    
    #print "Validating $name\n";
    
    # name does not start with uppercase, then we're no good
    if($name !~ m/^[A-Z]/) {
        $err_mssg = "'$name' is bad style, $type_name must be UpperCamelCase without under_scores";
    } elsif($name =~ m/_/) {
        $err_mssg = "'$name' is bad style, $type_name must be UpperCamelCase without under_scores";
    }
    
    return ($err_mssg, $warn_mssg);
}

