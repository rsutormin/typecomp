use Module::Build;

# requires contain all those modules in use statements
# in the compile_typespec.pl script and in the use
# statements in lib/Bio/KBase/KIDL/*.pm

my $build = Module::Build->new
  (
   module_name        => 'Bio::KBase::KIDL::KBT',
   license            => 'mit',
   dist_abstract      => 'This is the kbase type compiler',
   dist_author        => ['Bob Olson'],
   create_makefile_pl => 'traditional',
   script_files       => ['scripts/compile_dbd_to_typespec.pl',
			  'scripts/compile_typespec.pl',
			  'scripts/gen_java_client.pl',
   			 ],
   requires => {
		Lingua::EN::Inflect    => '0',
		Data::Dumper           => '0',
		Template               => '0',
		File::Slurp	       => '0',	
		File::Basename         => '0',
		File::Path             => '0',
		Getopt::Long           => '0',
		Parse::Yapp::Driver    => '0',
		Devel::StackTrace      => '0',
		File::Spec             => '0',
		Moose		       => '0',
	       },
  );

unshift @{$build->build_elements}, 'installdeps'
$build->add_build_element('tt');
$build->create_build_script;

