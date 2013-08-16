#!/usr/bin/env perl
#
#  Runs a test of kidl-check-spec (which indirectly tests the type compiler as well).
#
#  author:  msneddon
#  created: 8/16/2013

use strict;
use warnings;
use Data::Dumper;

use Test::More;

my $n_tests;

# perform the good tests, which are spec files that should pass the API check
opendir my $gooddir, "good-specs" or die "Can't run tests!  Cannot open directory: $!";
my @goodfiles = readdir $gooddir;
closedir $gooddir;

foreach my $spec (@goodfiles) {
    next if $spec eq '.';
    next if $spec eq '..';
    next if $spec !~ m/\.spec$/;
    
    my $check_command = "kidl-check-spec good-specs/$spec 2>&1";
    my $check_output = `$check_command`;
    
    # exit code should be zero for all good tests
    my $exit_code = $? >> 8;
    ok($exit_code == 0, "check of spec '$spec' must pass");
    if ($exit_code != 0) { print STDERR "output was:\n".$check_output."\n"; }
    
    $n_tests++;
}


# perform the bad tests, which are spec files that should fail the API check
opendir my $baddir, "bad-specs" or die "Can't run tests!  Cannot open directory: $!";
my @badfiles = readdir $baddir;
closedir $baddir;

foreach my $spec (@badfiles) {
    next if $spec eq '.';
    next if $spec eq '..';
    next if $spec !~ m/\.spec$/;
    
    my $check_command = "kidl-check-spec bad-specs/$spec 2>&1";
    my $check_output = `$check_command`;
    
    # exit code should be zero for all good tests
    my $exit_code = $? >> 8;
    ok($exit_code == 1, "check of spec '$spec' must fail");
    
    $n_tests++;
}


done_testing($n_tests);

