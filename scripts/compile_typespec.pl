use typedoc;
use strict;
use POSIX;
use Data::Dumper;
use Template;
use File::Slurp;
use KBT;

@ARGV == 2 or die "Usage: $0 typespec output-dir\n";

my $spec_file = shift;
my $dir = shift;

my $parser = typedoc->new();

my $txt = read_file($spec_file) or die "Cannot read $spec_file: $!";
my $modules = $parser->parse($txt);

for my $module (@$modules)
{
    write_stubs($module, $dir);
}

sub write_stubs
{
    my($module, $dir) = @_;

    my $tmpl = Template->new( { OUTPUT_PATH => $dir,
				ABSOLUTE => 1,
			      });

    my %module_options = map { $_ => 1 } @{$module->options};

    my $doc = $module->comment;
    $doc =~ s/^\s*\*\s?//mg;
    
    my $client_package_name = $module->module_name . "Client";
    my $server_package_name = $module->module_name . "Server";
    my $impl_package_name = $module->module_name . "Impl";

    my %saved_stub;
    my $saved_header;
    my $saved_const;

    my $impl_file = "$dir/$impl_package_name.pm";
    if (open(my $fh, "<", $impl_file))
    {
	#
	# Collect old client implementation code.
	#
	my $cur_rtn;
	my $cur_hdr;
	my $cur_const;
	while (<$fh>)
	{
	    if (/^\s*\#BEGIN\s+(\S+)/)
	    {
		$cur_rtn = $1;
	    }
	    elsif (/^\s*\#END\s+(\S+)/)
	    {
		undef $cur_rtn;
	    }
	    elsif ($cur_rtn)
	    {
		$saved_stub{$cur_rtn} .= $_;
	    }
	    elsif (/^\s*\#BEGIN_HEADER\s*$/)
	    {
		$cur_hdr = 1;
	    }
	    elsif (/^\s*\#END_HEADER\s*$/)
	    {
		$cur_hdr = 0;
	    }
	    elsif (/^\s*\#BEGIN_CONSTRUCTOR\s*$/)
	    {
		$cur_const = 1;
	    }
	    elsif (/^\s*\#END_CONSTRUCTOR\s*$/)
	    {
		$cur_const = 0;
	    }
	    elsif ($cur_hdr)
	    {
		$saved_header .= $_;
	    }
	    elsif ($cur_const)
	    {
		$saved_const .= $_;
	    }
	}
	close($fh);
    }

    my $type_info = assemble_types($parser);
	
    my $methods = [];

    my $vars = {
	client_package_name => $client_package_name,
	server_package_name => $server_package_name,
	impl_package_name => $impl_package_name,
	module_name => $module->module_name,
	module => $module,
	module_doc => $doc,
	methods => $methods,
	types => $type_info,
	module_options => \%module_options,
	module_header => $saved_header,
	module_constructor => $saved_const,
    };

    for my $comp (@{$module->module_components})
    {
	next unless $comp->isa('KBT::Funcdef');

	my $params = $comp->parameters;
	my @args;
	my %ncount;

	for my $i (0..$#$params)
	{
	    my $p = $params->[$i];

	    my $name;
	    if ($p->{name})
	    {
		$name = $p->{name};
	    }
	    else
	    {
		#
		# if we didn't pass in a name, and if
		# this parameter is a typedef, use the type name.
		#
		if (ref($p->{type}) && $p->{type}->can('alias_type'))
		{
		    $name = $p->{type}->name;
		}
		else
		{
		    $name = "arg_" . ($i + 1);
		}
	    }
	    push(@args, $name);
	    $ncount{$name}++;
	}

	#
	# Scan args for duplicates and disambiguate.
	#
	for my $argi (0..$#args)
	{
	    if ($ncount{$args[$argi]} > 1)
	    {
		$args[$argi] .= "_" . ($argi + 1);
	    }
	}
	#
	# Generate english type descriptions.
	#
	my %types_seen;
	my $typenames = [];
	my @english;
	
	for my $argi (0..$#args)
	{
	    my $name = $args[$argi];
	    my $p = $params->[$argi];
	    my $type = $p->{type};
	    my $eng = $type->english(1);
	    my $tn = $type->subtypes(\%types_seen);
	    # print "arg $argi $type subtypes @$tn\n";
	    push(@$typenames, @$tn);
	    push(@english, "\$$name is $eng");
	}

	my $args = join(", ", @args);
	my $arg_vars = join(", ", map { "\$$_" } @args);

	my $returns = $comp->return_type;
	
	my @rets;

	if (@$returns == 1)
	{
	    my $p = $returns->[0];
	    my $name = $p->{name} // "return";
	    push(@rets, $name);
	    my $tn = $p->{type}->subtypes(\%types_seen);
	    push(@$typenames, @$tn);
	    my $eng = $p->{type}->english(1);
	    push(@english, "\$$name is $eng");
	}
	else
	{
	    for my $i (0..$#$returns)
	    {
		my $p = $returns->[$i];
		my $name = $p->{name} // "return_" . ($i + 1);
		push(@rets, $name);
		my $tn = $p->{type}->subtypes(\%types_seen);
		push(@$typenames, @$tn);
		my $eng = $p->{type}->english(1);
		push(@english, "\$$name is $eng");
	    }
	}
	my $rets = join(", ", @rets);
	my $ret_vars = join(", ", map { "\$$_" } @rets);

	for my $tn (@$typenames)
	{
	    my $type = $parser->lookup_type($tn);

	    push(@english, "$tn is " . $type->alias_type->english(1));
	}
	
	my $doc = $comp->comment;
	$doc =~ s/^\s*\*\s?//mg;

	chomp @english;

	my $meth = {
	    name => $comp->name,
	    arg_doc => [grep { !/^\s*$/ } @english],
	    doc => $doc,
	    args => $args,
	    arg_vars => $arg_vars,
	    rets => $rets,
	    ret_vars => $ret_vars,
	    arg_count => scalar @args,
	    user_code => $saved_stub{$comp->name},
	};
	push(@$methods, $meth);
    }
    
    my $tmpl_dir = KBT->install_path;

    $tmpl->process("$tmpl_dir/client_stub.tt", $vars, "$client_package_name.pm") || die Template->error;
    $tmpl->process("$tmpl_dir/server_stub.tt", $vars, "$server_package_name.pm") || die Template->error;
    $tmpl->process("$tmpl_dir/psgi_stub.tt", $vars, $module->module_name . ".psgi") || die Template->error;

    if (-f $impl_file)
    {
	my $ts = strftime("%Y-%m-%d-%H-%M-%S", localtime);
	my $bak = "$dir/$impl_package_name.pm.bak-$ts";
	rename($impl_file, $bak);
    }
    $tmpl->process("$tmpl_dir/impl_stub.tt", $vars, "$impl_package_name.pm") || die Template->error;
	
}

sub assemble_types
{
    my($parser) = @_;

    my $types = [];

    for my $type (@{$parser->types()})
    {
	my $name = $type->name;
	my $ref = $type->alias_type;
	my $eng = $ref->english(0);
	push(@$types, {
	    name => $name,
	    ref => $ref,
	    english => $eng,
	    comment => $type->comment,
	     });
    }
    return $types;
}
