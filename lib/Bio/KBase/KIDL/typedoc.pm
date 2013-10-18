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
                      'UnspecifiedObject' => Bio::KBase::KIDL::KBT::UnspecifiedObject->new(),
			);

our $auth_default = 'none';

our @kidl_keywords = qw(funcdef
    		        typedef
			module
			list
			mapping
			structure
			nullable
			returns
			authentication
			tuple
			async);
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
		DEFAULT => -9,
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
		DEFAULT => -10
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
		DEFAULT => -7
	},
	{#State 10
		DEFAULT => -5,
		GOTOS => {
			'@2-4' => 12
		}
	},
	{#State 11
		ACTIONS => {
			'IDENT' => 13
		}
	},
	{#State 12
		ACTIONS => {
			"{" => 14
		}
	},
	{#State 13
		DEFAULT => -8
	},
	{#State 14
		DEFAULT => -11,
		GOTOS => {
			'module_components' => 15
		}
	},
	{#State 15
		ACTIONS => {
			"}" => 17,
			'AUTHENTICATION' => 16,
			'ASYNC' => 23,
			"use" => 24,
			'DOC_COMMENT' => 19,
			'TYPEDEF' => 25
		},
		DEFAULT => -28,
		GOTOS => {
			'async_flag' => 22,
			'module_component' => 18,
			'funcdef' => 21,
			'auth_type' => 20,
			'typedef' => 26,
			'module_component_with_doc' => 27
		}
	},
	{#State 16
		ACTIONS => {
			'IDENT' => 28
		}
	},
	{#State 17
		ACTIONS => {
			";" => 29
		}
	},
	{#State 18
		DEFAULT => -13
	},
	{#State 19
		ACTIONS => {
			'AUTHENTICATION' => 16,
			'ASYNC' => 23,
			"use" => 24,
			'TYPEDEF' => 25
		},
		DEFAULT => -28,
		GOTOS => {
			'async_flag' => 22,
			'module_component' => 30,
			'funcdef' => 21,
			'auth_type' => 20,
			'typedef' => 26
		}
	},
	{#State 20
		ACTIONS => {
			";" => 31
		}
	},
	{#State 21
		DEFAULT => -16
	},
	{#State 22
		ACTIONS => {
			'FUNCDEF' => 32
		}
	},
	{#State 23
		DEFAULT => -29
	},
	{#State 24
		ACTIONS => {
			"module" => 33
		}
	},
	{#State 25
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'structure' => 39,
			'type' => 42,
			'tuple' => 41,
			'list' => 44
		}
	},
	{#State 26
		DEFAULT => -15
	},
	{#State 27
		DEFAULT => -12
	},
	{#State 28
		DEFAULT => -19
	},
	{#State 29
		DEFAULT => -6
	},
	{#State 30
		DEFAULT => -14
	},
	{#State 31
		DEFAULT => -18
	},
	{#State 32
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 45,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'structure' => 39,
			'type' => 46,
			'tuple' => 41,
			'list' => 44
		}
	},
	{#State 33
		ACTIONS => {
			'ident' => 47
		}
	},
	{#State 34
		DEFAULT => -35
	},
	{#State 35
		DEFAULT => -36
	},
	{#State 36
		ACTIONS => {
			"<" => 48
		}
	},
	{#State 37
		ACTIONS => {
			"." => 49
		},
		DEFAULT => -41
	},
	{#State 38
		ACTIONS => {
			"<" => 50
		}
	},
	{#State 39
		DEFAULT => -37
	},
	{#State 40
		ACTIONS => {
			"<" => 51
		}
	},
	{#State 41
		DEFAULT => -39
	},
	{#State 42
		ACTIONS => {
			'IDENT' => 52
		}
	},
	{#State 43
		ACTIONS => {
			"{" => 53
		}
	},
	{#State 44
		DEFAULT => -38
	},
	{#State 45
		ACTIONS => {
			'IDENT' => -41,
			"." => 49
		},
		DEFAULT => -22,
		GOTOS => {
			'@4-3' => 54
		}
	},
	{#State 46
		ACTIONS => {
			'IDENT' => 55
		}
	},
	{#State 47
		ACTIONS => {
			";" => 56
		}
	},
	{#State 48
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'tuple_types' => 57,
			'structure' => 39,
			'tuple_type' => 58,
			'tuple' => 41,
			'type' => 59,
			'list' => 44
		}
	},
	{#State 49
		ACTIONS => {
			'IDENT' => 60
		}
	},
	{#State 50
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'tuple_type' => 61,
			'structure' => 39,
			'tuple' => 41,
			'type' => 59,
			'list' => 44
		}
	},
	{#State 51
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'structure' => 39,
			'type' => 62,
			'tuple' => 41,
			'list' => 44
		}
	},
	{#State 52
		DEFAULT => -20,
		GOTOS => {
			'@3-3' => 63
		}
	},
	{#State 53
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'structure' => 39,
			'tuple' => 41,
			'type' => 66,
			'struct_items' => 65,
			'struct_item' => 64,
			'list' => 44
		}
	},
	{#State 54
		ACTIONS => {
			"(" => 67
		}
	},
	{#State 55
		DEFAULT => -24,
		GOTOS => {
			'@5-4' => 68
		}
	},
	{#State 56
		DEFAULT => -17
	},
	{#State 57
		ACTIONS => {
			"," => 69,
			">" => 70
		}
	},
	{#State 58
		DEFAULT => -50
	},
	{#State 59
		ACTIONS => {
			'IDENT' => 71
		},
		DEFAULT => -52
	},
	{#State 60
		DEFAULT => -40
	},
	{#State 61
		ACTIONS => {
			"," => 72
		}
	},
	{#State 62
		ACTIONS => {
			">" => 73
		}
	},
	{#State 63
		ACTIONS => {
			";" => 74
		}
	},
	{#State 64
		DEFAULT => -44
	},
	{#State 65
		ACTIONS => {
			"}" => 75,
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'structure' => 39,
			'tuple' => 41,
			'type' => 66,
			'struct_item' => 76,
			'list' => 44
		}
	},
	{#State 66
		ACTIONS => {
			'IDENT' => 77
		}
	},
	{#State 67
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'IDENT' => 37,
			'MAPPING' => 38,
			'LIST' => 40,
			'STRUCTURE' => 43
		},
		DEFAULT => -30,
		GOTOS => {
			'funcdef_param' => 79,
			'mapping' => 35,
			'structure' => 39,
			'funcdef_params' => 78,
			'type' => 80,
			'tuple' => 41,
			'list' => 44
		}
	},
	{#State 68
		ACTIONS => {
			"(" => 81
		}
	},
	{#State 69
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'tuple_type' => 82,
			'structure' => 39,
			'tuple' => 41,
			'type' => 59,
			'list' => 44
		}
	},
	{#State 70
		DEFAULT => -49
	},
	{#State 71
		DEFAULT => -53
	},
	{#State 72
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'mapping' => 35,
			'tuple_type' => 83,
			'structure' => 39,
			'tuple' => 41,
			'type' => 59,
			'list' => 44
		}
	},
	{#State 73
		DEFAULT => -48
	},
	{#State 74
		DEFAULT => -21
	},
	{#State 75
		DEFAULT => -43
	},
	{#State 76
		DEFAULT => -45
	},
	{#State 77
		ACTIONS => {
			'NULLABLE' => 85,
			";" => 84
		}
	},
	{#State 78
		ACTIONS => {
			"," => 86,
			")" => 87
		}
	},
	{#State 79
		DEFAULT => -31
	},
	{#State 80
		ACTIONS => {
			'IDENT' => 88
		},
		DEFAULT => -34
	},
	{#State 81
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'IDENT' => 37,
			'MAPPING' => 38,
			'LIST' => 40,
			'STRUCTURE' => 43
		},
		DEFAULT => -30,
		GOTOS => {
			'funcdef_param' => 79,
			'mapping' => 35,
			'structure' => 39,
			'funcdef_params' => 89,
			'type' => 80,
			'tuple' => 41,
			'list' => 44
		}
	},
	{#State 82
		DEFAULT => -51
	},
	{#State 83
		ACTIONS => {
			">" => 90
		}
	},
	{#State 84
		DEFAULT => -46
	},
	{#State 85
		ACTIONS => {
			";" => 91
		}
	},
	{#State 86
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'LIST' => 40,
			'IDENT' => 37,
			'MAPPING' => 38,
			'STRUCTURE' => 43
		},
		GOTOS => {
			'funcdef_param' => 92,
			'mapping' => 35,
			'structure' => 39,
			'type' => 80,
			'tuple' => 41,
			'list' => 44
		}
	},
	{#State 87
		ACTIONS => {
			'RETURNS' => 93
		}
	},
	{#State 88
		DEFAULT => -33
	},
	{#State 89
		ACTIONS => {
			"," => 86,
			")" => 94
		}
	},
	{#State 90
		DEFAULT => -42
	},
	{#State 91
		DEFAULT => -47
	},
	{#State 92
		DEFAULT => -32
	},
	{#State 93
		ACTIONS => {
			"(" => 95
		}
	},
	{#State 94
		ACTIONS => {
			'AUTHENTICATION' => 16
		},
		DEFAULT => -26,
		GOTOS => {
			'auth_param' => 97,
			'auth_type' => 96
		}
	},
	{#State 95
		ACTIONS => {
			'TYPENAME' => 34,
			'TUPLE' => 36,
			'IDENT' => 37,
			'MAPPING' => 38,
			'LIST' => 40,
			'STRUCTURE' => 43
		},
		DEFAULT => -30,
		GOTOS => {
			'funcdef_param' => 79,
			'mapping' => 35,
			'structure' => 39,
			'funcdef_params' => 98,
			'type' => 80,
			'tuple' => 41,
			'list' => 44
		}
	},
	{#State 96
		DEFAULT => -27
	},
	{#State 97
		ACTIONS => {
			";" => 99
		}
	},
	{#State 98
		ACTIONS => {
			"," => 86,
			")" => 100
		}
	},
	{#State 99
		DEFAULT => -25
	},
	{#State 100
		ACTIONS => {
			'AUTHENTICATION' => 16
		},
		DEFAULT => -26,
		GOTOS => {
			'auth_param' => 101,
			'auth_type' => 96
		}
	},
	{#State 101
		ACTIONS => {
			";" => 102
		}
	},
	{#State 102
		DEFAULT => -23
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
#line 122 "typedoc.yp"
{ [] }
	],
	[#Rule 3
		 'module_list', 2,
sub
#line 123 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 4
		 '@1-2', 0,
sub
#line 126 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 5
		 '@2-4', 0,
sub
#line 126 "typedoc.yp"
{ $_[0]->set_active_module($_[4]->[1]) }
	],
	[#Rule 6
		 'module', 9,
sub
#line 127 "typedoc.yp"
{
			my $module = Bio::KBase::KIDL::KBT::DefineModule->new(options => $_[1],
					       @{$_[4]},
					       module_components => $_[7],
					       comment => $_[3]);
			$_[0]->clear_symbol_table($module->module_name);
			$module;
		    }
	],
	[#Rule 7
		 'mod_name_def', 1,
sub
#line 137 "typedoc.yp"
{ [ module_name => $_[1], service_name => $_[1] ] }
	],
	[#Rule 8
		 'mod_name_def', 3,
sub
#line 138 "typedoc.yp"
{ [ module_name => $_[3], service_name => $_[1] ] }
	],
	[#Rule 9
		 'module_opts', 0,
sub
#line 141 "typedoc.yp"
{ [] }
	],
	[#Rule 10
		 'module_opts', 2,
sub
#line 142 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 11
		 'module_components', 0,
sub
#line 145 "typedoc.yp"
{ [] }
	],
	[#Rule 12
		 'module_components', 2,
sub
#line 146 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 13
		 'module_component_with_doc', 1, undef
	],
	[#Rule 14
		 'module_component_with_doc', 2,
sub
#line 151 "typedoc.yp"
{ $_[2]->comment($_[1]); $_[2] }
	],
	[#Rule 15
		 'module_component', 1, undef
	],
	[#Rule 16
		 'module_component', 1, undef
	],
	[#Rule 17
		 'module_component', 4, undef
	],
	[#Rule 18
		 'module_component', 2,
sub
#line 158 "typedoc.yp"
{ $auth_default = $_[1]; 'auth_default' . $_[1] }
	],
	[#Rule 19
		 'auth_type', 2,
sub
#line 161 "typedoc.yp"
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
	[#Rule 20
		 '@3-3', 0,
sub
#line 182 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 21
		 'typedef', 5,
sub
#line 182 "typedoc.yp"
{ $_[0]->define_type($_[2], $_[3], $_[4]); }
	],
	[#Rule 22
		 '@4-3', 0,
sub
#line 185 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 23
		 'funcdef', 13,
sub
#line 186 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Funcdef->new(return_type => $_[10], name => $_[3], parameters => $_[6],
			      comment => $_[4], async => $_[1], authentication => $_[12] ); }
	],
	[#Rule 24
		 '@5-4', 0,
sub
#line 188 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 25
		 'funcdef', 10,
sub
#line 189 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Funcdef->new(return_type => [$_[3]], name => $_[4], parameters => $_[7],
			      comment => $_[5], async => $_[1], authentication => $_[9]); }
	],
	[#Rule 26
		 'auth_param', 0,
sub
#line 193 "typedoc.yp"
{ $auth_default }
	],
	[#Rule 27
		 'auth_param', 1, undef
	],
	[#Rule 28
		 'async_flag', 0,
sub
#line 197 "typedoc.yp"
{ 0 }
	],
	[#Rule 29
		 'async_flag', 1,
sub
#line 198 "typedoc.yp"
{ 1 }
	],
	[#Rule 30
		 'funcdef_params', 0,
sub
#line 201 "typedoc.yp"
{ [] }
	],
	[#Rule 31
		 'funcdef_params', 1,
sub
#line 202 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 32
		 'funcdef_params', 3,
sub
#line 203 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 33
		 'funcdef_param', 2,
sub
#line 206 "typedoc.yp"
{ { type => $_[1], name => $_[2] } }
	],
	[#Rule 34
		 'funcdef_param', 1,
sub
#line 207 "typedoc.yp"
{ { type => $_[1] } }
	],
	[#Rule 35
		 'type', 1, undef
	],
	[#Rule 36
		 'type', 1, undef
	],
	[#Rule 37
		 'type', 1, undef
	],
	[#Rule 38
		 'type', 1, undef
	],
	[#Rule 39
		 'type', 1, undef
	],
	[#Rule 40
		 'type', 3,
sub
#line 216 "typedoc.yp"
{
		    my $type = $_[0]->lookup_type($_[3],$_[1]);
		    if (!defined($type))
		    {
		        $_[0]->emit_error("Attempt to use undefined type '$_[3]' from module '$_[1]'");
		    }
		    $type
		}
	],
	[#Rule 41
		 'type', 1,
sub
#line 224 "typedoc.yp"
{ my $type = $_[0]->lookup_type($_[1]);
			if (!defined($type))
			{
			    $_[0]->emit_error("Attempt to use undefined type '$_[1]'");
			}
			$type }
	],
	[#Rule 42
		 'mapping', 6,
sub
#line 232 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Mapping->new(key_type => $_[3]->[0], value_type=> $_[5]->[0]); }
	],
	[#Rule 43
		 'structure', 4,
sub
#line 235 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Struct->new(items => $_[3]); }
	],
	[#Rule 44
		 'struct_items', 1,
sub
#line 238 "typedoc.yp"
{ [$_[1]] }
	],
	[#Rule 45
		 'struct_items', 2,
sub
#line 239 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 46
		 'struct_item', 3,
sub
#line 242 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 0); }
	],
	[#Rule 47
		 'struct_item', 4,
sub
#line 243 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 1); }
	],
	[#Rule 48
		 'list', 4,
sub
#line 246 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::List->new(element_type => $_[3]); }
	],
	[#Rule 49
		 'tuple', 4,
sub
#line 249 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Tuple->new(element_types => [ map { $_->[0] } @{$_[3]}],
							    element_names => [ map { $_->[1] } @{$_[3]}] ); }
	],
	[#Rule 50
		 'tuple_types', 1,
sub
#line 253 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 51
		 'tuple_types', 3,
sub
#line 254 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 52
		 'tuple_type', 1,
sub
#line 257 "typedoc.yp"
{ [ $_[1], undef ] }
	],
	[#Rule 53
		 'tuple_type', 2,
sub
#line 258 "typedoc.yp"
{ [ $_[1], $_[2] ] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 261 "typedoc.yp"
 

sub define_type
{
    my($self, $old_type, $new_type, $comment) = @_;
    my $active_module = $self->YYData->{active_module};
    my $def = Bio::KBase::KIDL::KBT::Typedef->new(name => $new_type, module => $active_module, alias_type => $old_type, comment => $comment);
    push(@{$self->YYData->{type_list}}, $def);
    $self->YYData->{type_table}->{$new_type} = $def;
    #
    # Try to name the typedefed type if it is a tuple or struct.
    #
    if($old_type) {
        if ($old_type->isa('Bio::KBase::KIDL::KBT::Struct') || $old_type->isa('Bio::KBase::KIDL::KBT::Tuple'))
        {
            $old_type->name_type($new_type);
            if ($comment)
            {
                $old_type->comment($comment);
            }
        }
        # we need to associate a module to this struct for producing json schema that can have java package information
        if ($old_type->isa('Bio::KBase::KIDL::KBT::Struct'))
        {
            $old_type->set_module($active_module);
        }
    }
    return $def;
}

# used to return the ACTIVE type list
sub types
{
    my($self) = @_;
    return $self->YYData->{type_list} || [];
}

# used to return type definitions for a specific module
sub moduletypes
{
    my($self,$module_name) = @_;
    return $self->YYData->{cached_type_lists}->{$module_name} || [];
}
sub modulelist
{
    my($self) = @_;
    return $self->YYData->{module_list};
}

sub lookup_type
{
    my($self, $name, $src_module) = @_;
    
    print "Looking up $name\n";
    
    # if we are trying to lookup a type in an external module, then we have to
    # look in the right place
    if($src_module) {
	return $self->YYData->{cached_type_tables}->{$src_module}->{$name};
    }
    
    return $self->YYData->{type_table}->{$name};
}



#
#  provide the text string of data and a filename
#
sub parse
{
    my($self, $data, $filename) = @_;

    $self->set_active_file($data, $filename);
    my $res = $self->YYParse(yylex => \&Lexer, yyerror => \&Error);
    return ($res, $self->YYData->{error_count}, $self->YYData->{error_msg});;
}



sub set_active_file #previously named init_state
{
    my($self, $data, $filename) = @_;

    
    #
    # Initialize type table to just the builtins.
    #
    $self->YYData->{type_table} = { %builtin_types };
    $self->YYData->{INPUT} = $data;
    $self->YYData->{active_module} = '';
    $self->YYData->{line_number} = 1;
    $self->YYData->{filename} = $filename;
    $self->YYData->{error_count} = 0;
    $self->YYData->{error_msg} = '';
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
    
    # error messages are now sent up so that errors in the same file are grouped together
    $data->{error_msg} .= "$file:$line: $message (next token is '$token')\n";
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
	    elsif (s/^(funcdef|typedef|module|list|mapping|structure|nullable|returns|authentication|tuple|async)\b//)
	    {
		return (uc($1), $1);
	    }
	    elsif (s/^([A-Za-z][A-Za-z0-9_]*)//)
	    {
		my $str = $1;
		if ($builtin_types{$str})
		{
		    my $type = $data->{type_table}->{$str};
		    return('TYPENAME', $type);
		}
		#elsif ($kidl_keywords{$str})
		#{
		#    return(uc($str), $str);
		#}
		#elsif ($kidl_reserved{$str})
		#{
		#    $parser->emit_warning("Use of reserved word '$str'");
		#    return('IDENT', $str);
		#}
		else
		{
		    return('IDENT', $str);
		}
	    }
	    elsif (s,^/\*(.*?)\*/,,s)
	    {
		my $com = $1;
                # we pull in the entire comment, so we need to account for newlines in the comment
                $data->{line_number}++ while($com =~ m/\n/g);
                
		if ($com =~ /^\*/)
		{
		    #
		    # It was a /** comment which is a doc-block. Return that as a token.
		    #
                    # What is this used for? -mike
		    return('DOC_COMMENT', $com);
		}
                
		my @lines = split(/\n/, $com);
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



#
# as soon as we start reading a module, set it as the active module
#
sub set_active_module {
    my ($self,$module_name) = @_;
    
    # check that this module hasn't been defined already, if it has emit an error
    foreach my $m (@{$self->YYData->{module_list}}) {
        if($m eq $module_name) {
            $self->emit_error("Duplicate definition of Module '$module_name' not allowed.");
            last;
        }
    }
    # remember that we parsed this module and set it to active
    push(@{$self->YYData->{module_list}}, $module_name);
    #print STDERR "\tdebug: setting active module to $module_name\n";
    $self->YYData->{active_module} = $module_name;
}

#
# Once a module has been parsed, clear the active type table and save
# the parsed types from the parsed module for future lookups
#
sub clear_symbol_table
{
    my($self,$module_name) = @_;
    #print STDERR "\tdebug: finished parse of '$module_name' clearing symbol table\n";

    # cache the objects so we can look them up later    
    $self->YYData->{cached_type_tables}->{$module_name} = $self->YYData->{type_table};
    $self->YYData->{cached_type_lists}->{$module_name}  = $self->YYData->{type_list};
    
    # clear the type table and list, and make sure the active module is inactivated
    $self->YYData->{type_table} = { %builtin_types };
    $self->YYData->{type_list} = [];
    $self->YYData->{active_module} = '';
}


sub clear_symbol_table_cache
{
    my($self) = @_;
    
    undef %{$self->YYData->{cached_type_tables}};
    undef %{$self->YYData->{cached_type_tables}};
}


1;
