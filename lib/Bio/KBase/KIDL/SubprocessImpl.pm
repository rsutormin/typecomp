package Bio::KBase::KIDL::SubprocessImpl;

#
# Implement a method using a subprocess invocation.
#

use strict;
use File::Temp;
use File::Slurp;
use JSON::XS;
use IPC::Run;

use base 'Exporter';

our @EXPORT_OK = qw(execute_with_subprocess);

sub execute_with_subprocess
{
    my($command_base, $inputs, $outputs) = @_;

    my %input_map;
    my %output_map;

    my %filenames;
    
    my $coder = JSON::XS->new->ascii->pretty->allow_nonref;

    for my $input_name (keys %$inputs)
    {
	my $temp = File::Temp->new();
	print $temp $coder->encode($inputs->{$input_name});
	close($temp);
	$filenames{$input_name} = $temp->filename;
	$input_map{$input_name} = $temp;
    }
    for my $output_name (keys %$outputs)
    {
	my $temp = File::Temp->new();
	close($temp);
	$filenames{$output_name} = $temp->filename;
	$outputs{$ouput_name} = $temp;
    }

    my $cmd = $command_base;
    $cmd =~ s/%([a-zA-Z0-9_]+)/\'$filenames{$1}\'/g;

    my $res = system($cmd);
    if ($_res != 0)
    {
	die "Error $_res running command: $_cmd";
    }

[% FOR return IN method.returns %]
    {
	my $_name = q([% return.name %]);
	my $_temp = $_outputs{$_name};
	my $_file = $_temp->filename;
	my $_txtref = read_file($_file, scalar_ref => 1);
	if (!ref($_txtref))
	{
	    die "Error executing script: output file $_name not found";
	}
	$[% return.name %] = $_coder->decode($$_txtref);
    }
[% END %]

