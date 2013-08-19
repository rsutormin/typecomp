#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use File::Temp;
use Data::Dumper;
use XML::Dumper;
use XML::LibXML;
use Bio::KBase::KIDL::Lint qw(check_for_standards);

my $DESCRIPTION =
"
NAME
      kidl-check-spec -- check spec file for basic KBase API standards

SYNOPSIS
      kidl-check-spec [OPTIONS] [SPEC_FILE_NAME]

DESCRIPTION
      Given a spec file in KIDL, check if basic KBase API standards are
      met, and print a summary to standard error.  This command returns
      0 if all was ok, 0 if simple warnings are encountered, and 1 if
      standard API requirements are not met or if the spec could not be
      analyzed for whatever reason.

      Current KBase API Standards and Conventions are described here:
      https://docs.google.com/document/d/1bwXes9-f99Hr8EknQ8nrL0UfYpB0rlYVKsSxvE9uCXA/edit?usp=sharing

      Valid option flags are:

      -h, --help
            diplay this help message, ignore all arguments

      -e [XMLFILE], --erxml [XMLFILE]
            if given, recognizes entity/relationship names from the given
            xml file, and does not report errors if these names are used
            in CamelCase for function/parameter/type names.
     
      --ignore-warnings
            if given, warning messages are not displayed (but are still counted).

AUTHORS
      Michael Sneddon (mwsneddon\@lbl.gov)

";

my $help = '';
my $erxml = '';
my $ignorewarnings = '';
my $opt = GetOptions (
        "help" => \$help,
        "erxml=s" => \$erxml,
        "ignore-warnings" => \$ignorewarnings,
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
} elsif($n_args>1) {
    print STDERR "Too many input arguments.  Run with --help for usage.\n";
    exit 1;
}

# create a place to shove typecomp output
my $outputdir = File::Temp->newdir(".kidl-check-XXXX");
my $outputdirname = $outputdir->dirname;

# call the typecompiler
my $system_command = "compile_typespec -xml parsedump.xml '$ARGV[0]' $outputdir 2>&1";
my $tc_output = `$system_command`;
my $exit_code = $? >> 8;
if ( $exit_code != 0 ) {
    print STDERR "\ncompile_typespec failed to run successfully!\n";
    print STDERR "full command run was: '$system_command'\n\n";
    print STDERR "compile_typespec output was:\n==================\n";
    print STDERR $tc_output;
    print STDERR "==================\n\n";
    print STDERR "Unable to check API standards if compile errors exist.\n\n";
    exit 1;
}

#read in the xml file containing the ER model to save entity / relationship names
my $er_name_list = {};
if ($erxml) {
     eval {
          my $dom = XML::LibXML->load_xml(location => $erxml);
          my $root = $dom->documentElement();
          # parse the entity names
          my @entities_tag = $root->getChildrenByTagName('Entities');
          foreach my $e (@entities_tag) {
               my @entities_list = $e->getChildrenByTagName('Entity');
               foreach my $entity (@entities_list) {
                    my $entity_name = $entity->getAttribute('name');
                    if ($entity_name) {
                         $er_name_list->{$entity_name}=1;
                         $er_name_list->{$entity_name.'s'}=1;
                    } else {
                         print STDERR "\nUnable to check API standards; XML file ($erxml) could not be read.\n";
                         print STDERR "Error was: \nMalformed ERDB XML file, could not find Entity tag with name attribute.\n\n";
                         exit 1;
                    }
               }
          }
          
          # parse the relationship names
          my @relationships_tag = $root->getChildrenByTagName('Relationships');
          foreach my $r (@relationships_tag) {
               my @relationship_list = $r->getChildrenByTagName('Relationship');
               foreach my $relationship (@relationship_list) {
                    my $relationship_name = $relationship->getAttribute('name');
                    my $relationship_converse = $relationship->getAttribute('converse');
                    if ($relationship_name && $relationship_converse) {
                         $er_name_list->{$relationship_name}=1;
                         $er_name_list->{$relationship_name.'s'}=1;
                         $er_name_list->{$relationship_converse}=1;
                         $er_name_list->{$relationship_converse.'s'}=1;
                    } else {
                         print STDERR "\nUnable to check API standards; XML file ($erxml) could not be read.\n";
                         print STDERR "Error was: \nMalformed ERDB XML file, could not find Relationship tag with name and converse attributes.\n\n";
                         exit 1;
                    }
               }
          }
     };
     if($@) {
          print STDERR "\nUnable to check API standards; XML file ($erxml) could not be read.\n";
          print STDERR "Error was: \n$@\n\n";
          exit 1;
     }
     
}

#make sure a dump of the xml data was generated
unless(-e "$outputdir/parsedump.xml") {
     print STDERR "Unable to check API standards; no XML dump genererated.\n\n";
     print STDERR "Are you sure you have rebuilt the latest version of the typecompiler?\n\n";
     exit 1;
}

# perform the actual check
my $dumper=XML::Dumper->new;
my $parsed_data = $dumper->xml2pl("$outputdir/parsedump.xml");
my ($err_mssg, $warn_mssg) = check_for_standards($parsed_data,$er_name_list);

# print errors and warnings
foreach my $mssg (@$err_mssg) {
     print STDERR "[ERROR]: $mssg.\n";
}
unless($ignorewarnings) {
     foreach my $mssg (@$warn_mssg) {
         print STDERR "[warning]: $mssg.\n";
     }
}


# decide how to exit
if (scalar @$err_mssg > 0) {
     print STDERR "\nYour KIDL spec does not meet the KBase API standard requirements.\n";
     print STDERR "  " . scalar(@$err_mssg) . " Errors encountered.\n";
     print STDERR "  " . scalar(@$warn_mssg) . " Warnings encountered.";
     if($ignorewarnings) { print STDERR " (not shown because --ignore-warnings flag is on) "; }
     print STDERR "\n\n";
     exit 1;
}
if (scalar @$warn_mssg > 0) {
     print STDERR "\nYour KIDL spec passes all requirements, but a few things can be improved.\n";
     print STDERR "  " . scalar(@$err_mssg) . " Errors encountered.\n";
     print STDERR "  " . scalar(@$warn_mssg) . " Warnings encountered.";
     if($ignorewarnings) { print STDERR " (not shown because --ignore-warnings flag is on) "; }
     print STDERR "\n\n";
     exit 0;
}

# all looks good
print STDERR "Relax. Your KIDL spec looks good to me.\n\n";
exit 0;



