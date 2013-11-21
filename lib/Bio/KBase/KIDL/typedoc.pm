####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package typedoc;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 4 "typedoc.yp"

    use Devel::StackTrace;
    use Bio::KBase::KIDL::KBT;
    use Data::Dumper;
    use File::Spec;

our @valid_authentication_values = qw(required optional none);    
our %valid_authentication_value = map { $_ => 1 } @valid_authentication_values;

our %builtin_types = ('int' => Bio::KBase::KIDL::KBT::Scalar->new(scalar_type => 'int'),
		      'string' => Bio::KBase::KIDL::KBT::Scalar->new(scalar_type => 'string'),
		      'float' => Bio::KBase::KIDL::KBT::Scalar->new(scalar_type => 'float'),
#		      'bool' => Bio::KBase::KIDL::KBT::Scalar->new(scalar_type => 'bool'),
    );

our $auth_default = 'none';

our @kidl_keywords = qw(
			async
			authentication
			funcdef
			implemented_by
			list
			mapping
			module
			nullable
			returns
			structure
			tuple
			typedef
);
our %kidl_keywords = map { $_ => 1 } @kidl_keywords;

our @kidl_reserved = qw(abstract
			and
			as
			assert
			bool
			break
			byte
			case
			catch
			char
			class
			const
			continue
			debugger
			def
			default
			del
			delete
			do
			double
			elif
			else
			enum
			except
			exec
			extends
			final
			finally
			float
			for
			from
			function
			global
			goto
			if
			implements
			import
			in
			instanceof
			int
			interface
			is
			lambda
			let
			long
			native
			new
			not
			or
			package
			pass
			print
			private
			protected
			public
			raise
			return
			short
			static
			strictfp
			super
			switch
			synchronized
			this
			throw
			throws
			transient
			try
			typeof
			var
			void
			volatile
			while
			with
			yield
			none
			required
			optional
			);
our %kidl_reserved = map { $_ => 1 } @kidl_reserved;


sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		DEFAULT => -2,
		GOTOS => {
			'module_list' => 1,
			'start' => 2
		}
	},
	{#State 1
		ACTIONS => {
			'' => -1
		},
		DEFAULT => -8,
		GOTOS => {
			'module_opts' => 3,
			'module' => 4
		}
	},
	{#State 2
		ACTIONS => {
			'' => 5
		}
	},
	{#State 3
		ACTIONS => {
			'MODULE' => 6,
			'module_opt' => 7
		}
	},
	{#State 4
		DEFAULT => -3
	},
	{#State 5
		DEFAULT => 0
	},
	{#State 6
		DEFAULT => -4,
		GOTOS => {
			'@1-2' => 8
		}
	},
	{#State 7
		DEFAULT => -9
	},
	{#State 8
		ACTIONS => {
			'IDENT' => 9
		},
		GOTOS => {
			'mod_name_def' => 10
		}
	},
	{#State 9
		ACTIONS => {
			":" => 11
		},
		DEFAULT => -6
	},
	{#State 10
		ACTIONS => {
			"{" => 12
		}
	},
	{#State 11
		ACTIONS => {
			'IDENT' => 13
		}
	},
	{#State 12
		DEFAULT => -10,
		GOTOS => {
			'module_components' => 14
		}
	},
	{#State 13
		DEFAULT => -7
	},
	{#State 14
		ACTIONS => {
			"}" => 16,
			'AUTHENTICATION' => 15,
			'DOC_COMMENT' => 18,
			'ASYNC' => 23,
			"use" => 24,
			'TYPEDEF' => 25,
			"[" => 27
		},
		DEFAULT => -43,
		GOTOS => {
			'async_flag' => 22,
			'module_component' => 17,
			'funcdef' => 21,
			'auth_type' => 20,
			'attribute_expr' => 19,
			'typedef' => 26,
			'module_component_with_doc' => 28
		}
	},
	{#State 15
		ACTIONS => {
			'IDENT' => 29
		}
	},
	{#State 16
		ACTIONS => {
			";" => 30
		}
	},
	{#State 17
		DEFAULT => -12
	},
	{#State 18
		ACTIONS => {
			'AUTHENTICATION' => 15,
			'ASYNC' => 23,
			"use" => 24,
			'TYPEDEF' => 25,
			"[" => 27
		},
		DEFAULT => -43,
		GOTOS => {
			'async_flag' => 22,
			'module_component' => 31,
			'funcdef' => 21,
			'auth_type' => 20,
			'attribute_expr' => 19,
			'typedef' => 26
		}
	},
	{#State 19
		DEFAULT => -18
	},
	{#State 20
		ACTIONS => {
			";" => 32
		}
	},
	{#State 21
		DEFAULT => -15
	},
	{#State 22
		ACTIONS => {
			'FUNCDEF' => 33
		}
	},
	{#State 23
		DEFAULT => -44
	},
	{#State 24
		ACTIONS => {
			"module" => 34
		}
	},
	{#State 25
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'structure' => 40,
			'type' => 43,
			'tuple' => 42,
			'list' => 45
		}
	},
	{#State 26
		DEFAULT => -14
	},
	{#State 27
		ACTIONS => {
			'IDENT' => 46
		},
		DEFAULT => -20,
		GOTOS => {
			'attribute' => 48,
			'attribute_list' => 47
		}
	},
	{#State 28
		DEFAULT => -11
	},
	{#State 29
		DEFAULT => -32
	},
	{#State 30
		DEFAULT => -5
	},
	{#State 31
		DEFAULT => -13
	},
	{#State 32
		DEFAULT => -17
	},
	{#State 33
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 49,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'structure' => 40,
			'type' => 50,
			'tuple' => 42,
			'list' => 45
		}
	},
	{#State 34
		ACTIONS => {
			'ident' => 51
		}
	},
	{#State 35
		DEFAULT => -50
	},
	{#State 36
		DEFAULT => -51
	},
	{#State 37
		ACTIONS => {
			"<" => 52
		}
	},
	{#State 38
		DEFAULT => -55
	},
	{#State 39
		ACTIONS => {
			"<" => 53
		}
	},
	{#State 40
		DEFAULT => -52
	},
	{#State 41
		ACTIONS => {
			"<" => 54
		}
	},
	{#State 42
		DEFAULT => -54
	},
	{#State 43
		ACTIONS => {
			'IDENT' => 55
		}
	},
	{#State 44
		ACTIONS => {
			"{" => 56
		}
	},
	{#State 45
		DEFAULT => -53
	},
	{#State 46
		ACTIONS => {
			"(" => 57
		},
		DEFAULT => -23
	},
	{#State 47
		ACTIONS => {
			"," => 58,
			"]" => 59
		}
	},
	{#State 48
		DEFAULT => -21
	},
	{#State 49
		ACTIONS => {
			'IDENT' => -55
		},
		DEFAULT => -35,
		GOTOS => {
			'@3-3' => 60
		}
	},
	{#State 50
		ACTIONS => {
			'IDENT' => 61
		}
	},
	{#State 51
		ACTIONS => {
			";" => 62
		}
	},
	{#State 52
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'tuple_types' => 63,
			'structure' => 40,
			'tuple_type' => 64,
			'tuple' => 42,
			'type' => 65,
			'list' => 45
		}
	},
	{#State 53
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'tuple_type' => 66,
			'structure' => 40,
			'tuple' => 42,
			'type' => 65,
			'list' => 45
		}
	},
	{#State 54
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'structure' => 40,
			'type' => 67,
			'tuple' => 42,
			'list' => 45
		}
	},
	{#State 55
		DEFAULT => -33,
		GOTOS => {
			'@2-3' => 68
		}
	},
	{#State 56
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'structure' => 40,
			'tuple' => 42,
			'type' => 71,
			'struct_items' => 70,
			'struct_item' => 69,
			'list' => 45
		}
	},
	{#State 57
		ACTIONS => {
			'IDENT' => 73,
			'DQSTRING' => 72,
			'NUMBER' => 77,
			'SQSTRING' => 74
		},
		DEFAULT => -25,
		GOTOS => {
			'attribute_param' => 75,
			'attribute_params' => 76
		}
	},
	{#State 58
		ACTIONS => {
			'IDENT' => 46
		},
		GOTOS => {
			'attribute' => 78
		}
	},
	{#State 59
		DEFAULT => -19
	},
	{#State 60
		ACTIONS => {
			"(" => 79
		}
	},
	{#State 61
		DEFAULT => -37,
		GOTOS => {
			'@4-4' => 80
		}
	},
	{#State 62
		DEFAULT => -16
	},
	{#State 63
		ACTIONS => {
			"," => 81,
			">" => 82
		}
	},
	{#State 64
		DEFAULT => -64
	},
	{#State 65
		ACTIONS => {
			'IDENT' => 83
		},
		DEFAULT => -66
	},
	{#State 66
		ACTIONS => {
			"," => 84
		}
	},
	{#State 67
		ACTIONS => {
			">" => 85
		}
	},
	{#State 68
		ACTIONS => {
			";" => 86
		}
	},
	{#State 69
		DEFAULT => -58
	},
	{#State 70
		ACTIONS => {
			"}" => 87,
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'structure' => 40,
			'tuple' => 42,
			'type' => 71,
			'struct_item' => 88,
			'list' => 45
		}
	},
	{#State 71
		ACTIONS => {
			'IDENT' => 89
		}
	},
	{#State 72
		DEFAULT => -30
	},
	{#State 73
		DEFAULT => -28
	},
	{#State 74
		DEFAULT => -29
	},
	{#State 75
		DEFAULT => -26
	},
	{#State 76
		ACTIONS => {
			"," => 90,
			")" => 91
		}
	},
	{#State 77
		DEFAULT => -31
	},
	{#State 78
		DEFAULT => -22
	},
	{#State 79
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'IDENT' => 38,
			'MAPPING' => 39,
			'LIST' => 41,
			'STRUCTURE' => 44
		},
		DEFAULT => -45,
		GOTOS => {
			'funcdef_param' => 93,
			'mapping' => 36,
			'structure' => 40,
			'funcdef_params' => 92,
			'type' => 94,
			'tuple' => 42,
			'list' => 45
		}
	},
	{#State 80
		ACTIONS => {
			"(" => 95
		}
	},
	{#State 81
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'tuple_type' => 96,
			'structure' => 40,
			'tuple' => 42,
			'type' => 65,
			'list' => 45
		}
	},
	{#State 82
		DEFAULT => -63
	},
	{#State 83
		DEFAULT => -67
	},
	{#State 84
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'mapping' => 36,
			'tuple_type' => 97,
			'structure' => 40,
			'tuple' => 42,
			'type' => 65,
			'list' => 45
		}
	},
	{#State 85
		DEFAULT => -62
	},
	{#State 86
		DEFAULT => -34
	},
	{#State 87
		DEFAULT => -57
	},
	{#State 88
		DEFAULT => -59
	},
	{#State 89
		ACTIONS => {
			'NULLABLE' => 99,
			";" => 98
		}
	},
	{#State 90
		ACTIONS => {
			'IDENT' => 73,
			'DQSTRING' => 72,
			'NUMBER' => 77,
			'SQSTRING' => 74
		},
		GOTOS => {
			'attribute_param' => 100
		}
	},
	{#State 91
		DEFAULT => -24
	},
	{#State 92
		ACTIONS => {
			"," => 101,
			")" => 102
		}
	},
	{#State 93
		DEFAULT => -46
	},
	{#State 94
		ACTIONS => {
			'IDENT' => 103
		},
		DEFAULT => -49
	},
	{#State 95
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'IDENT' => 38,
			'MAPPING' => 39,
			'LIST' => 41,
			'STRUCTURE' => 44
		},
		DEFAULT => -45,
		GOTOS => {
			'funcdef_param' => 93,
			'mapping' => 36,
			'structure' => 40,
			'funcdef_params' => 104,
			'type' => 94,
			'tuple' => 42,
			'list' => 45
		}
	},
	{#State 96
		DEFAULT => -65
	},
	{#State 97
		ACTIONS => {
			">" => 105
		}
	},
	{#State 98
		DEFAULT => -60
	},
	{#State 99
		ACTIONS => {
			";" => 106
		}
	},
	{#State 100
		DEFAULT => -27
	},
	{#State 101
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'LIST' => 41,
			'IDENT' => 38,
			'MAPPING' => 39,
			'STRUCTURE' => 44
		},
		GOTOS => {
			'funcdef_param' => 107,
			'mapping' => 36,
			'structure' => 40,
			'type' => 94,
			'tuple' => 42,
			'list' => 45
		}
	},
	{#State 102
		ACTIONS => {
			'RETURNS' => 108
		}
	},
	{#State 103
		DEFAULT => -48
	},
	{#State 104
		ACTIONS => {
			"," => 101,
			")" => 109
		}
	},
	{#State 105
		DEFAULT => -56
	},
	{#State 106
		DEFAULT => -61
	},
	{#State 107
		DEFAULT => -47
	},
	{#State 108
		ACTIONS => {
			"(" => 110
		}
	},
	{#State 109
		ACTIONS => {
			'AUTHENTICATION' => 15
		},
		DEFAULT => -41,
		GOTOS => {
			'auth_param' => 112,
			'auth_type' => 111
		}
	},
	{#State 110
		ACTIONS => {
			'TYPENAME' => 35,
			'TUPLE' => 37,
			'IDENT' => 38,
			'MAPPING' => 39,
			'LIST' => 41,
			'STRUCTURE' => 44
		},
		DEFAULT => -45,
		GOTOS => {
			'funcdef_param' => 93,
			'mapping' => 36,
			'structure' => 40,
			'funcdef_params' => 113,
			'type' => 94,
			'tuple' => 42,
			'list' => 45
		}
	},
	{#State 111
		DEFAULT => -42
	},
	{#State 112
		ACTIONS => {
			'IMPLEMENTED_BY' => 114
		},
		DEFAULT => -39,
		GOTOS => {
			'opt_implementation' => 115
		}
	},
	{#State 113
		ACTIONS => {
			"," => 101,
			")" => 116
		}
	},
	{#State 114
		ACTIONS => {
			"(" => 117
		}
	},
	{#State 115
		ACTIONS => {
			";" => 118
		}
	},
	{#State 116
		ACTIONS => {
			'AUTHENTICATION' => 15
		},
		DEFAULT => -41,
		GOTOS => {
			'auth_param' => 119,
			'auth_type' => 111
		}
	},
	{#State 117
		ACTIONS => {
			'DQSTRING' => 120
		}
	},
	{#State 118
		DEFAULT => -38
	},
	{#State 119
		ACTIONS => {
			'IMPLEMENTED_BY' => 114
		},
		DEFAULT => -39,
		GOTOS => {
			'opt_implementation' => 121
		}
	},
	{#State 120
		ACTIONS => {
			")" => 122
		}
	},
	{#State 121
		ACTIONS => {
			";" => 123
		}
	},
	{#State 122
		DEFAULT => -40
	},
	{#State 123
		DEFAULT => -36
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'start', 1, undef
	],
	[#Rule 2
		 'module_list', 0,
sub
#line 125 "typedoc.yp"
{ [] }
	],
	[#Rule 3
		 'module_list', 2,
sub
#line 126 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 4
		 '@1-2', 0,
sub
#line 129 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 5
		 'module', 8,
sub
#line 129 "typedoc.yp"
{
    Bio::KBase::KIDL::KBT::DefineModule->new(options => $_[1],
			   @{$_[4]},
			   module_components => $_[6],
		           comment => $_[3]);
    }
	],
	[#Rule 6
		 'mod_name_def', 1,
sub
#line 137 "typedoc.yp"
{ [ module_name => $_[1], service_name => $_[1] ] }
	],
	[#Rule 7
		 'mod_name_def', 3,
sub
#line 138 "typedoc.yp"
{ [ module_name => $_[3], service_name => $_[1] ] }
	],
	[#Rule 8
		 'module_opts', 0,
sub
#line 141 "typedoc.yp"
{ [] }
	],
	[#Rule 9
		 'module_opts', 2,
sub
#line 142 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 10
		 'module_components', 0,
sub
#line 145 "typedoc.yp"
{ [] }
	],
	[#Rule 11
		 'module_components', 2,
sub
#line 146 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 12
		 'module_component_with_doc', 1, undef
	],
	[#Rule 13
		 'module_component_with_doc', 2,
sub
#line 151 "typedoc.yp"
{ $_[2]->comment($_[1]); $_[2] }
	],
	[#Rule 14
		 'module_component', 1, undef
	],
	[#Rule 15
		 'module_component', 1, undef
	],
	[#Rule 16
		 'module_component', 4, undef
	],
	[#Rule 17
		 'module_component', 2,
sub
#line 158 "typedoc.yp"
{ $auth_default = $_[1]; 'auth_default' . $_[1] }
	],
	[#Rule 18
		 'module_component', 1,
sub
#line 159 "typedoc.yp"
{ push(@{$_[0]->{cur_attribute}}, @{$_[1]}); }
	],
	[#Rule 19
		 'attribute_expr', 3,
sub
#line 162 "typedoc.yp"
{ $_[2] }
	],
	[#Rule 20
		 'attribute_list', 0,
sub
#line 165 "typedoc.yp"
{ [] }
	],
	[#Rule 21
		 'attribute_list', 1,
sub
#line 166 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 22
		 'attribute_list', 3,
sub
#line 167 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 23
		 'attribute', 1,
sub
#line 170 "typedoc.yp"
{ [$_[1], []] }
	],
	[#Rule 24
		 'attribute', 4,
sub
#line 171 "typedoc.yp"
{ [$_[1], $_[3] ] }
	],
	[#Rule 25
		 'attribute_params', 0,
sub
#line 174 "typedoc.yp"
{ [] }
	],
	[#Rule 26
		 'attribute_params', 1,
sub
#line 175 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 27
		 'attribute_params', 3,
sub
#line 176 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 28
		 'attribute_param', 1, undef
	],
	[#Rule 29
		 'attribute_param', 1, undef
	],
	[#Rule 30
		 'attribute_param', 1, undef
	],
	[#Rule 31
		 'attribute_param', 1, undef
	],
	[#Rule 32
		 'auth_type', 2,
sub
#line 185 "typedoc.yp"
{ 
			       if ($valid_authentication_value{$_[2]}) 
			       {
				   $_[2];
			       }
			       else
			       {
				   $_[0]->emit_error("Invalid authentication type '" . $_[2] . "'. Valid types are " . join(" ", map { "'$_'" } @valid_authentication_values));
				   "none";
			       }
			   }
	],
	[#Rule 33
		 '@2-3', 0,
sub
#line 206 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 34
		 'typedef', 5,
sub
#line 206 "typedoc.yp"
{ $_[0]->define_type($_[2], $_[3], $_[4]); }
	],
	[#Rule 35
		 '@3-3', 0,
sub
#line 209 "typedoc.yp"
{ [ $_[0]->get_comment(), $_[0]->get_attribute() ] }
	],
	[#Rule 36
		 'funcdef', 14,
sub
#line 211 "typedoc.yp"
{
			    my $func;

			    eval { $func = Bio::KBase::KIDL::KBT::Funcdef->new(return_type => $_[10], name => $_[3],
					parameters => $_[6],
					comment => $_[4]->[0], 
					attribute => $_[4]->[1], 
					async => $_[1], authentication => $_[12],
					implemented_by => $_[13] );
			    };
			    if ($@)
			    {
				$_[0]->emit_error($@);
			    }
			    $func;
			}
	],
	[#Rule 37
		 '@4-4', 0,
sub
#line 227 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 38
		 'funcdef', 11,
sub
#line 228 "typedoc.yp"
{
			    my $func;
			    eval {
				$func = Bio::KBase::KIDL::KBT::Funcdef->new(return_type => [$_[3]], name => $_[4],
					parameters => $_[7],
					comment => $_[5], async => $_[1], authentication => $_[9],
					implemented_by => $_[10]);
			    };
			    if ($@)
			    {
				$_[0]->emit_error($@);
			    }
			    $func;
			}
	],
	[#Rule 39
		 'opt_implementation', 0,
sub
#line 245 "typedoc.yp"
{ [] }
	],
	[#Rule 40
		 'opt_implementation', 4,
sub
#line 246 "typedoc.yp"
{ [ $_[3] ] }
	],
	[#Rule 41
		 'auth_param', 0,
sub
#line 249 "typedoc.yp"
{ $auth_default }
	],
	[#Rule 42
		 'auth_param', 1, undef
	],
	[#Rule 43
		 'async_flag', 0,
sub
#line 253 "typedoc.yp"
{ 0 }
	],
	[#Rule 44
		 'async_flag', 1,
sub
#line 254 "typedoc.yp"
{ 1 }
	],
	[#Rule 45
		 'funcdef_params', 0,
sub
#line 257 "typedoc.yp"
{ [] }
	],
	[#Rule 46
		 'funcdef_params', 1,
sub
#line 258 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 47
		 'funcdef_params', 3,
sub
#line 259 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 48
		 'funcdef_param', 2,
sub
#line 262 "typedoc.yp"
{ { type => $_[1], name => $_[2] } }
	],
	[#Rule 49
		 'funcdef_param', 1,
sub
#line 263 "typedoc.yp"
{ { type => $_[1] } }
	],
	[#Rule 50
		 'type', 1, undef
	],
	[#Rule 51
		 'type', 1, undef
	],
	[#Rule 52
		 'type', 1, undef
	],
	[#Rule 53
		 'type', 1, undef
	],
	[#Rule 54
		 'type', 1, undef
	],
	[#Rule 55
		 'type', 1,
sub
#line 272 "typedoc.yp"
{ my $type = $_[0]->lookup_type($_[1]);
			if (!defined($type))
			{
			    $_[0]->emit_error("Attempt to use undefined type '$_[1]'");
			}
			$type }
	],
	[#Rule 56
		 'mapping', 6,
sub
#line 280 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Mapping->new(key_type => $_[3]->[0], value_type=> $_[5]->[0]); }
	],
	[#Rule 57
		 'structure', 4,
sub
#line 283 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Struct->new(items => $_[3]); }
	],
	[#Rule 58
		 'struct_items', 1,
sub
#line 286 "typedoc.yp"
{ [$_[1]] }
	],
	[#Rule 59
		 'struct_items', 2,
sub
#line 287 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 60
		 'struct_item', 3,
sub
#line 290 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 0); }
	],
	[#Rule 61
		 'struct_item', 4,
sub
#line 291 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 1); }
	],
	[#Rule 62
		 'list', 4,
sub
#line 294 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::List->new(element_type => $_[3]); }
	],
	[#Rule 63
		 'tuple', 4,
sub
#line 297 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Tuple->new(element_types => [ map { $_->[0] } @{$_[3]}],
							    element_names => [ map { $_->[1] } @{$_[3]}] ); }
	],
	[#Rule 64
		 'tuple_types', 1,
sub
#line 301 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 65
		 'tuple_types', 3,
sub
#line 302 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 66
		 'tuple_type', 1,
sub
#line 305 "typedoc.yp"
{ [ $_[1], undef ] }
	],
	[#Rule 67
		 'tuple_type', 2,
sub
#line 306 "typedoc.yp"
{ [ $_[1], $_[2] ] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 309 "typedoc.yp"
 

sub define_type
{
    my($self, $old_type, $new_type, $comment) = @_;
    my $def = Bio::KBase::KIDL::KBT::Typedef->new(name => $new_type, alias_type => $old_type, comment => $comment);
    push(@{$self->YYData->{type_list}}, $def);
    $self->YYData->{type_table}->{$new_type} = $def;
    #
    # Try to name the typedefed type if it is a tuple or struct.
    #
    if ($old_type->isa('Bio::KBase::KIDL::KBT::Struct') || $old_type->isa('Bio::KBase::KIDL::KBT::Tuple'))
    {
	$old_type->name_type($new_type);
	if ($comment)
	{
	    $old_type->comment($comment);
	}
    }
    return $def;
}

sub types
{
    my($self) = @_;
    return $self->YYData->{type_list} || [];
}

sub lookup_type
{
    my($self, $name) = @_;
    return $self->YYData->{type_table}->{$name};
}


sub parse
{
    my($self, $data, $filename) = @_;

    $self->init_state($data, $filename);
    my $res = $self->YYParse(yylex => \&Lexer, yyerror => \&Error);

    return ($res, $self->YYData->{error_count});;
}

sub init_state
{
    my($self, $data, $filename) = @_;

    #
    # Initialize type table to just the builtins.
    #
    $self->YYData->{type_table} = { %builtin_types };
    $self->YYData->{INPUT} = $data;
    $self->YYData->{line_number} = 1;
    $self->YYData->{filename} = $filename;
    $self->YYData->{error_count} = 0;
}


sub Error {
    my($parser) = @_;
    
    my $data = $parser->YYData;

    my $error = $data->{ERRMSG} || "Syntax error";

    $parser->emit_error($error);
}

sub emit_error {
    my($parser, $message) = @_;
    
    my $data = $parser->YYData;

    my $line = $data->{line_number};
    my $file = $data->{filename};

    my $token = $parser->YYCurtok;
    my $tval = $parser->YYCurval;

    if ($token eq 'IDENT')
    {
	$token = $tval;
    }
    

    print STDERR "$file:$line: $message (next token is '$token')\n";
    $data->{error_count}++;
}

sub emit_warning {
    my($parser, $message) = @_;
    
    my $data = $parser->YYData;

    my $line = $data->{line_number};
    my $file = $data->{filename};

    my $token = $parser->YYCurtok;
    my $tval = $parser->YYCurval;

    if ($token eq 'IDENT')
    {
	$token = $tval;
    }
    my $twarn = $token ? " next token is '$token'" : "";

    warn "Warning: $file:$line: $message$twarn\n";
}

sub Lexer {
    my($parser)=shift;

    my $data = $parser->YYData;
    my $bufptr = \$data->{INPUT};

    for ($$bufptr)
    {
	while ($_ ne '')
	{
	    # print "Top: '$_'\n";
	    next if (s/^[ \t]+//);
	    if (s/^\n//)
	    {
		$data->{line_number}++;
		next;
	    }
	    
	    if ($_ eq '')
	    {
		return ('', undef);
	    }
	    elsif (s/^([-+]?([0-9]*\.[0-9]+|[0-9]+))//)
	    {
	        my $str = $1;
		return('NUMBER', $str);
	    }
	    elsif (s/^"((?:[^\\"]|\\.)*)"//)
	    {
		my $str = $1;
		return('DQSTRING', $str);
	    }
	    elsif (s/^'((?:[^\\']|\\.)*)'//)
	    {
		my $str = $1;
		return('SQSTRING', $str);
	    }
	    elsif (s/^([A-Za-z][A-Za-z0-9_]*)//)
	    {
		my $str = $1;
		if ($builtin_types{$str})
		{
		    my $type = $data->{type_table}->{$str};
		    return('TYPENAME', $type);
		}
		elsif ($kidl_keywords{$str})
		{
		    return(uc($str), $str);
		}
		elsif ($kidl_reserved{$str})
		{
		    $parser->emit_warning("Use of reserved word '$str'");
		    return('IDENT', $str);
		}
		else
		{
		    return('IDENT', $str);
		}
	    }
	    elsif (s,^/\*(.*?)\*/,,s)
	    {
		my $com = $1;
		if ($com =~ /^\*/)
		{
		    #
		    # It was a /** comment which is a doc-block. Return that as a token.
		    #
		    return('DOC_COMMENT', $com);
		}

		my @lines = split(/\n/, $com);
		$data->{line_number} += @lines - 1;
		$lines[0] =~ s/^\s*//;
		my @new = ($lines[0]);
		shift @lines;
		if (@lines)
		{
		    my $l = $lines[0];
		    $l =~ s/\t/        /g;
		    my($init_ws) = $l =~ /^(\s+)/;
		    my $x = length($init_ws);
		    # print "x=$x '$lines[0]'\n";
		    for my $l (@lines)
		    {
			$l =~ s/\t/        /g;
			$l =~ s/^\s{$x}//;
			push(@new, $l);
		    }
		}
		#$parser->{cur_comment} = $com;
		$parser->{cur_comment} = join("\n", @new);
		
		# Else just elide.
	    }
	    elsif (s/^(.)//s)
	    {
		return($1,$1);
	    }
	}
    }
}

#
# Return the current comment if there is one. Always
# clear the current comment.
#
sub get_comment
{
    my($self) = @_;
    my $ret = $self->{cur_comment};
    $self->{cur_comment} = "";
    $ret =~ s/^\s+//;
    $ret =~ s/\s+$//;
    return $ret;
}
    
sub get_attribute
{
    my($self) = @_;
    my $ret = delete $self->{cur_attribute};
    $ret ||= [];
    return $ret;
}
    

1;
