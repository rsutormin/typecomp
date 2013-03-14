use ExtUtils::MakeMaker;

WriteMakefile (
	NAME	=> 'Bio::Kbase::KIDL::KBT',
	# VERSION_FROM	=> 'lib/Bio/KBase/KIDL/KBT/KBT.pm',
	VERSION	=> '1.0',
	AUTHOR	=> 'Robert Olson',
	EXE_FILES	=> [],
	PREREQ_PM => {
		Lingua::EN::Inflect    => '0',
                Data::Dumper           => '0',
                Template               => '0',
                File::Slurp            => '0',
                File::Basename         => '0',
                File::Path             => '0',
                Getopt::Long           => '0',
                Parse::Yapp::Driver    => '0',
                Devel::StackTrace      => '0',
                File::Spec             => '0',
                Moose                  => '0',
	},
	LICENSE	=> 'mit',
);
