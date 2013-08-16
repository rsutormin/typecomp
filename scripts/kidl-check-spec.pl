#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

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
      standard API requirements are not met.
      
      Current KBase API Standards and Conventions are described here:
      https://docs.google.com/document/d/1bwXes9-f99Hr8EknQ8nrL0UfYpB0rlYVKsSxvE9uCXA/edit?usp=sharing
      
      Valid option flags are:
      
      -h, --help
            diplay this help message, ignore all arguments
            
      -e [XMLFILE], --erxml [XMLFILE]
            if given, recognizes entity/relationship names from the given
            xml file, and does not report errors if these names are used
            in CamelCase for function/parameter/type names.
      
AUTHORS
      Michael Sneddon (mwsneddon\@lbl.gov)
      
";

my $help = '';
my $erxml = '';
my $opt = GetOptions (
        "help" => \$help,
        "erxml" => \$erxml,
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

print STDERR "not checking anything yet.\n";
exit 0;



