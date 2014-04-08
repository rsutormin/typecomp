#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use File::Temp;
use Data::Dumper;
use File::Slurp;
use File::Basename;
use File::Spec;
use Cwd;
use File::Path 'make_path';
use Getopt::Long;

use Bio::KBase::KIDL::typedoc;
use Bio::KBase::KIDL::KBT;

use Bio::KBase::KIDL::AnnotationParser qw(assemble_annotations);


my $DESCRIPTION =
"
NAME
      kidl-get-stats -- check spec file for basic KBase API standards

SYNOPSIS
      kidl-check-spec [OPTIONS] [SPEC_FILES ... ]

DESCRIPTION
      Given a spec file(s) in KIDL, parse the file(s) and compute statistics such
      as number of functions, number of types, length of file, etc.  Stats are
      computed per Module, and aggregated over all modules included.
      
      Valid option flags are:

      -h, --help
            diplay this help message, ignore all arguments

AUTHORS
      Michael Sneddon (mwsneddon\@lbl.gov)

";

my $help = '';
my $erxml = '';
my $ignorewarnings = '';
my $opt = GetOptions (
        "help" => \$help
        );
if($help) {
     print $DESCRIPTION;
     exit 0;
}

#retrieve or update the URL
my $n_args = $#ARGV+1;
if($n_args==0) {
    print STDERR "No spec file specified.  Run with --help for usage.\n";
    exit 1;
}

my @spec_files = @ARGV;

my $include_path;
# check the environment for an include path variable, if it is defined append it to the
# path given as an argument so that paths given as args are searched first.
my $KB_TYPECOMP_PATH = "KB_TYPECOMP_PATH";
if(exists($ENV{$KB_TYPECOMP_PATH})) {
    if($include_path) {
        $include_path .= ":".$ENV{$KB_TYPECOMP_PATH};
    } else {
        $include_path = $ENV{$KB_TYPECOMP_PATH};
    }
}
#parse the include path string into a ref to a list of include paths
my $include_paths = [];
if($include_path) {
    #print STDERR "Include path: '".$include_path ."'\n";
    my @include_path_list = split(/:/,$include_path);
    $include_paths = \@include_path_list;
}

# instatiate a YAPP parser with the typedoc grammer
my $parser = typedoc->new();


#
# Read and parse all the given documents. We collect all documents
# that comprise each service, and process the services as units.
#
my $errors_found=0;
my $error_msg = '';
my $parsed_data = {}; # formally this was a hash named %services, now it is a ref to that same hash structure;


# a hash of abs path of included files, to mark the files we include
my $resolved_includes = { };

for my $spec_file (@spec_files)
{
    # extract the file name and absolute path to the enclosing folder
    my $filename = basename($spec_file);
    my $abs_filecontainer = File::Spec->rel2abs(dirname($spec_file));
    my $full_file_path = File::Spec->rel2abs($spec_file);
    
    # only continue if the file exists
    if(-f $full_file_path) {
        
        $resolved_includes->{File::Spec->rel2abs($spec_file)} = 1;
        
        # actually do the parse
        my ($modules,$spec_errors_found,$spec_error_msg)
            = parse_spec($filename,$abs_filecontainer,$parser,$include_paths,$resolved_includes);
        
        # handle errors if found
        if($spec_errors_found) {
            $error_msg .= $spec_error_msg;
            $errors_found += $spec_errors_found;
        } else {
        
            # no errors to report, so save the module info...
            # we have to assemble a list of all the types that are available to this module
            my $available_type_table = $parser->YYData->{cached_type_tables};
            my $type_info = assemble_types($parser);  #type_info is now a hash with module names as keys, and lists as before
            
            for my $mod (@$modules)
            {
                my $mod_name = $mod->module_name;
                my $serv_name = $mod->service_name;
                # print STDERR "$filename: module $mod_name service $serv_name\n";
                push(@{$parsed_data->{$serv_name}}, [$mod, $type_info->{$mod_name}, $available_type_table->{$mod_name}]);
            }
        }
        
    } else {
        $error_msg .= "Cannot read spec file: '$filename'\n";
        $errors_found ++;
    }
}


if($errors_found > 0) {
    print STDERR $error_msg;
    exit(1);
}

my $available_type_table = $parser->YYData->{cached_type_tables};


################################
# parse and assemble annotations
my $annotation_options = {ignore_warnings=>0};
assemble_annotations($parsed_data, $available_type_table, $annotation_options);


################################
# Generate the client/server files
my $need_auth = check_for_authentication($parsed_data);

# compute stats
my $module_stats = {};
foreach my $service_name (keys %$parsed_data) {
     
     #loop over each module
     my $data = $parsed_data->{$service_name};
     foreach my $module (@$data) {
          my $stats = {
                       string  => 0,
                       int     => 0,
                       float   => 0,
                       list    => 0,
                       map     => 0,
                       tuple   => 0,
                       struct  => 0,
                       funcdef => 0,
                       funcdef_auth_required => 0,
                       funcdef_auth_optional => 0
                       };
          
          # go through the types
          my $module_components = $module->[1];
          foreach my $c (@$module_components) {
               my $name = $c->{name};
               my $type = $c->{ref};
               my $comment = $c->{comment};
                
               # skip if it is a deprecated method
               #next if(defined $type->{annotations}->{deprecated});
                
               #resolve to the base type
               while ($type->isa('Bio::KBase::KIDL::KBT::Typedef')) {
                    $type = $type->{alias_type};
               }
                
               if ($type->isa('Bio::KBase::KIDL::KBT::Scalar')) {
                    if ($type->{scalar_type} eq 'string') { $stats->{string}++; }
                    elsif ($type->{scalar_type} eq 'int') { $stats->{int}++; }
                    elsif ($type->{float} eq 'float') { $stats->{float}++; }
                    #if(!defined($comment) || $comment eq '') { }
               }
                
               if ($type->isa('Bio::KBase::KIDL::KBT::List')) {
                    $stats->{list}++;
               }
                
               if ($type->isa('Bio::KBase::KIDL::KBT::Mapping')) {
                    $stats->{map}++;
               }
                
               if ($type->isa('Bio::KBase::KIDL::KBT::Tuple')) {
                    $stats->{tuple}++;
               }
                
               if ($type->isa('Bio::KBase::KIDL::KBT::Struct')) {
                    $stats->{struct}++;
               }
               if ($type->isa('Bio::KBase::KIDL::KBT::Funcdef')) {
                    $stats->{funcdef}++;
               }
               
#               bless( {
#                                                       'parameters' => [
#                                                                         {
#                                                                           'name' => 'abundance_data',
#                                                                           'type' => $VAR1->[0][0]{'module_components'}[37]
#                                                                         },
#                                                                         {
#                                                                           'name' => 'filter_params',
#                                                                           'type' => $VAR1->[0][0]{'module_components'}[38]
#                                                                         }
#                                                                       ],
#                                                       'return_type' => [
#                                                                          {
#                                                                            'name' => 'abundance_data_processed',
#                                                                            'type' => $VAR1->[0][0]{'module_components'}[37]
#                                                                          }
#                                                                        ],
#                                                       'comment' => 'ORDER OF OPERATIONS:
#1) using normalization scope, defines whether process should occur per column or globally over every column
#2) using normalization type, normalize by dividing values by the option indicated
#3) apply normalization post process if set (ie take log of the result)
#4) apply the cutoff_value threshold to all records, eliminating any that are not above the specified threshold
#5) apply the cutoff_number_of_records (always applies per_column!!!), discarding any record that are not in the top N record values for that column
#
#- if a value is not a valid number, it is ignored',
#                                                       'async' => 0,
#                                                       'name' => 'filter_abundance_profile',
#                                                       'authentication' => 'none',
#                                                       'annotations' => {
#                                                                          'unknown_annotations' => {}
#                                                                        }
#                                                     }, 'Bio::KBase::KIDL::KBT::Funcdef' ),

               
          }
          
          
          # go through the functions
          my $other_components = $module->[0]->module_components;
          foreach my $c (@$other_components) {
               if ($c->isa('Bio::KBase::KIDL::KBT::Funcdef')) {
                    $stats->{funcdef}++;
                    if($c->{authentication} eq 'required') {
                         $stats->{funcdef_auth_required}++;
                    }
                    elsif($c->{authentication} eq 'optional') {
                         $stats->{funcdef_auth_optional}++;
                    }
               }
          }
          $module_stats->{$service_name}->{$module->[0]->module_name} = $stats;
     }
}

my $summary = {};
foreach my $service (keys(%$module_stats)) {
     my $module = $module_stats->{$service};
     foreach my $module_name (keys(%$module)) {
          my $module_stats = $module->{$module_name};
          foreach my $stat_name (keys(%$module_stats)) {
               my $value = $module_stats->{$stat_name};
               if (defined($summary->{$stat_name})) {
                    $summary->{$stat_name} += $value;
               } else {
                    $summary->{$stat_name} = $value;
               }
          }
     }
}

$Data::Dumper::Indent = 3;
$Data::Dumper::Pair = ' : ';
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Varname = "module_stats";
print Dumper($module_stats);
$Data::Dumper::Varname = "total_stats";
print Dumper($summary);

exit(0);






#######################################################################################################
#   usage:
#   parse_spec($filename, $abs_filecontainer, $parser, $include_paths, $resolved_includes, $return_data)
#   
#   $return_data = 1 if you want the parsed data returned, 0 if you don't need the parsed data yet.
#
sub parse_spec {
    my ($filename, $abs_filecontainer, $parser, $include_paths, $resolved_includes) = @_;
    
    # reconstruct the full path so we can open the file and resolve includes
    my @directories = File::Spec->splitdir( $abs_filecontainer );
    my $abs_filepath = File::Spec->catfile( @directories, $filename );
    
    # read the file looking for include directives
    my $fileHandle;
    open($fileHandle, "<", $abs_filepath);
    if(!$fileHandle) {
        print STDERR "FAILURE - cannot open '.$abs_filepath.' \n$!\n";
        exit(1);  # we should probably exit more gracefully...
    }
    
    # read the file to grab the content and resolve includes
    my $content = '';
    my $line_number = 0;
    my $error_message = '';
    my $errors_found = 0;
    while (my $line = <$fileHandle>) {
        chomp($line);
        $line_number++;
        
        # for now, just search for a '#' flag in a very simple way
        # (note that this ignores where in the file it is defined!!)
        if($line =~ /^#include /) {
            my ($included_filename, $abs_included_filecontainer, $include_error_msg) =
                    resolve_include_location($line,$abs_filecontainer,$include_paths,$resolved_includes);
            if($include_error_msg) {
                $error_message .= "$filename:$line_number: ".$include_error_msg;
                $errors_found = 1;
            } elsif ($included_filename) {
                # if we have a filename and no error message, then recurse down and parse the included file
                my ($throw_away_parsed_data,$returned_errors_found,$returned_error_message) =
                        parse_spec($included_filename,$abs_included_filecontainer,$parser,$include_paths,$resolved_includes);
                
                # remember any errors that were found
                if($returned_errors_found) {
                    $error_message .= $returned_error_message;
                    $error_message .= "$filename:$line_number: Error(s) found in included file: '$included_filename'\n\tIncluded from: '$abs_included_filecontainer'\n";;
                    $errors_found = 1;
                }
            }
            # since there was a #include detected and processed at this point, remove it from the content
            $content .= "\n";
        } else {
            # remember the content otherwise
            $content .= $line."\n";
        }
    }
    # we could possibly exit here if we detect errors in the included file...
    # but we don't now so that we generate a complete list of syntax errors
    #if(!$errors_found) { }
    
    # we can finally parse the file content
    #print STDERR "\n\tdebug: reading file $filename\n";
    my($modules, $errors_found_from_parse, $parse_error_msg) = $parser->parse($content, $filename);
        
    # if there are errors in the parse, add them to our error list
    if ($errors_found_from_parse) {
        $errors_found += $errors_found_from_parse;
        $error_message .= $parse_error_msg;
    }
        
    # store a summary of the errors from this file if errors were found
    if($errors_found > 0) {
        $error_message .= "\n$errors_found error(s) were found in file '$filename'\n\n";
    }
    
    return ($modules,$errors_found,$error_message);
}


#######################################################################################################
# Given a line in a spec file that starts with '#include', resolve the include location and return
# the filename and absolute path to the folder containing the file, or an error.
#
#  $line = the line that starts with #include
#  $abs_current_dir = the absolute current directory of the file containing this include directive
#  $path_list = a ref to a list of possible paths to check for files
#  $resolved_includes = a ref to a hash with keys storing absolute path strings of includes
#                       that have already been resolved, so that we don't parse the same file twice;
#                       values in the hash mean nothing, but are set to 1.
#
#  Returns: ($filename, $abs_filecontainer, $error_msg)
#    if an error was encountered, $error_msg will be defined and set to a message string
#    if no error was encountered and $filename and $abs_filecontainer are not empty strings, then
#         the resolved include was a success and the file exists
#    if $filename is an empty string, and error_msg is undef, then the include was properly resolved,
#         but the file has already been processed so there is nothing to do.
#
sub resolve_include_location
{
    my ($line,$abs_current_dir,$path_list,$resolved_includes) = @_;
    
    my $error_msg;
    
    $line =~ s/^#include //; #drop the #include directive token
    $line =~ s/\s+$//; #trim trailing whitespace
    
    $line =~ s/\s*+;$//; #drop trailing semicolon if it was added
    
    # C style includes??  is this what we want??
    # split on '<' should produce exactly two tokens, first of which we can throw away
    my $include_name = ''; my $include_version = '';
    my @post_tokens = split /</,$line;
    unless (scalar(@post_tokens)==2) {
        $error_msg = "malformed include statement, cannot understand: '$line'\n";
        return ('','',$error_msg);
    }
    # now split on '>', which should also give exactly one token 
    my @pre_tokens = split />/,$post_tokens[1];
    if(scalar(@pre_tokens)==1) {
        $include_name = $pre_tokens[0];
    } else {
        $error_msg = "malformed include statement, cannot understand: '$line'\n";
        return ('','',$error_msg);
    }
    
    
    my $filename; my $abs_filecontainer;
    # handle cases where 1) path is absolute, 2) path is relative, 3) path is relative to an included base path
    if ( File::Spec->file_name_is_absolute( $include_name ) ) {
        # make sure it exists
        #print STDERR "\tdebug: checking absolute path: $include_name\n";
        if (-e $include_name) {
            #check if we've hit it before
            if(!exists($resolved_includes->{$include_name})) {
                $resolved_includes->{$include_name}='1';
                # the parsed include path is absolute, so ignore the current directory
                $filename = basename($include_name);
                $abs_filecontainer = File::Spec->rel2abs(dirname($include_name));
            } else {
                $filename = ''; $abs_filecontainer = '';
            }
        } else {
            $error_msg = "Absolute location of an include file does not exist\n";
            $error_msg = "The path you provided was '$include_name'\n";
        }
    } else {
    
        # path is relative, so first check relative to current directory
        $filename = basename($include_name);
        my @current_dirs  = File::Spec->splitdir( $abs_current_dir );
        my @relative_dirs = File::Spec->splitdir( dirname($include_name) );
        
        my @possible_path_dirs = (@current_dirs,@relative_dirs);
        my $possible_path = File::Spec->catfile( @possible_path_dirs, $filename );
        
        # if the relative path from the current directory exists, use this first
        #print STDERR "\tdebug: checking for: $possible_path\n";
	my $found_it;
        if (-e $possible_path) {
            #check if we've hit it before
            if(!exists($resolved_includes->{$possible_path})) {
                $resolved_includes->{$possible_path}='1';
                $abs_filecontainer = dirname($possible_path);
            } else {
		# we've already parsed it, so we can safely return without looking anywhere else!
                $filename = ''; $abs_filecontainer = '';
		$found_it=1;
            } 
        }
        
        # abs_filecontainer will be undef if we couldn't find the file relative to the current directory
        if(!$abs_filecontainer && !$found_it) {
            # if this file doesn't exist, then look through every location on our path (in order!)
            # note that we assume path_list contains absolute paths
            foreach my $include_path (@{$path_list}) {
            
                # get a string of the full absolute path to the possible file location
                my @include_path_dirs = File::Spec->splitdir( $include_path );
                @possible_path_dirs = (@include_path_dirs,@relative_dirs); #relative_dirs was parsed from the include line
                $possible_path = File::Spec->catfile( @possible_path_dirs, $filename );

                # check if a file exists here
                #print STDERR "\tdebug: checking for: $possible_path\n";
                if (-e $possible_path) {
                    if(!exists($resolved_includes->{$possible_path})) {
                        $resolved_includes->{$possible_path}='1';
                        $abs_filecontainer = dirname($possible_path);
                        last;
                    } else {
                        $filename = ''; $abs_filecontainer = '';
			$found_it=1;
                    }
                }
            }
        }
        
        # if we still could not find the abs_filecontainer, then we must abort
        if(!$abs_filecontainer && !$found_it) {
            $error_msg = "Could not resolve include of file '$include_name'.  Is your include path properly set?\n";
        }
    }
    return ($filename, $abs_filecontainer, $error_msg);
}

sub get_type_names
{
    my($type) = @_;
    
    my $typedef = $type->as_string();
    $typedef =~ m/^\s*(\w+)\s*(?:[<{].+)?$/; #this is a bit hacky, maybe add a method to each type - should ask Bob
    my $baretype = $1;
    return $typedef, $baretype;
}


sub assemble_types
{
    my($parser) = @_;

    my $all_types = {};
    for my $mod_name (@{$parser->modulelist()})
    {
        my $types = [];
    
        for my $type (@{$parser->moduletypes($mod_name)})
        {
            my $name = $type->name;
            my $ref = $type->alias_type;
            my $eng = $ref->english(0);
            push(@$types, {
                name => $name,
                module=> $mod_name,
                ref => $ref,
                english => $eng,
                comment => $type->comment,
                });
        }
        
        $all_types->{$mod_name} = $types;
    }
    return $all_types;
}




sub check_for_authentication
{
    my($services) = @_;
    my $out = {};

 SVC:
    while (my($service, $modules) = each %$services)
    {
	$out->{$service}->{$_} = 0 foreach qw(required optional none);;
        for my $module_ent (@$modules)
        {
            my($module, $type_info, $type_table) = @$module_ent;
            for my $comp (@{$module->module_components})
            {
                next unless $comp->isa('Bio::KBase::KIDL::KBT::Funcdef');
		$out->{$service}->{$comp->authentication}++;
            }
        }
    }
    return $out;
}


