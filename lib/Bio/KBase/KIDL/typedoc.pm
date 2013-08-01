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
		      'bool' => Bio::KBase::KIDL::KBT::Scalar->new(scalar_type => 'bool'),
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
			none
			required
			optional
			tuple
			async);
our %kidl_keywords = map { $_ => 1 } @kidl_keywords;

our @kidl_reserved = qw(abstract
			and
			as
			assert
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
			'ASYNC' => 22,
			"use" => 23,
			'DOC_COMMENT' => 18,
			'TYPEDEF' => 24
		},
		DEFAULT => -30,
		GOTOS => {
			'async_flag' => 21,
			'module_component' => 17,
			'funcdef' => 20,
			'auth_type' => 19,
			'typedef' => 25,
			'module_component_with_doc' => 26
		}
	},
	{#State 15
		ACTIONS => {
			'REQUIRED' => 27,
			'NONE' => 28,
			'OPTIONAL' => 30
		},
		GOTOS => {
			'auth_kind' => 29
		}
	},
	{#State 16
		ACTIONS => {
			";" => 31
		}
	},
	{#State 17
		DEFAULT => -12
	},
	{#State 18
		ACTIONS => {
			'AUTHENTICATION' => 15,
			'ASYNC' => 22,
			"use" => 23,
			'TYPEDEF' => 24
		},
		DEFAULT => -30,
		GOTOS => {
			'async_flag' => 21,
			'module_component' => 32,
			'funcdef' => 20,
			'auth_type' => 19,
			'typedef' => 25
		}
	},
	{#State 19
		ACTIONS => {
			";" => 33
		}
	},
	{#State 20
		DEFAULT => -15
	},
	{#State 21
		ACTIONS => {
			'FUNCDEF' => 34
		}
	},
	{#State 22
		DEFAULT => -31
	},
	{#State 23
		ACTIONS => {
			"module" => 35
		}
	},
	{#State 24
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'structure' => 41,
			'type' => 44,
			'tuple' => 43,
			'list' => 46
		}
	},
	{#State 25
		DEFAULT => -14
	},
	{#State 26
		DEFAULT => -11
	},
	{#State 27
		DEFAULT => -20
	},
	{#State 28
		DEFAULT => -19
	},
	{#State 29
		DEFAULT => -18
	},
	{#State 30
		DEFAULT => -21
	},
	{#State 31
		DEFAULT => -5
	},
	{#State 32
		DEFAULT => -13
	},
	{#State 33
		DEFAULT => -17
	},
	{#State 34
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 47,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'structure' => 41,
			'type' => 48,
			'tuple' => 43,
			'list' => 46
		}
	},
	{#State 35
		ACTIONS => {
			'ident' => 49
		}
	},
	{#State 36
		DEFAULT => -37
	},
	{#State 37
		DEFAULT => -38
	},
	{#State 38
		ACTIONS => {
			"<" => 50
		}
	},
	{#State 39
		DEFAULT => -42
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
			"<" => 52
		}
	},
	{#State 43
		DEFAULT => -41
	},
	{#State 44
		ACTIONS => {
			'IDENT' => 53
		}
	},
	{#State 45
		ACTIONS => {
			"{" => 54
		}
	},
	{#State 46
		DEFAULT => -40
	},
	{#State 47
		ACTIONS => {
			'IDENT' => -42
		},
		DEFAULT => -24,
		GOTOS => {
			'@3-3' => 55
		}
	},
	{#State 48
		ACTIONS => {
			'IDENT' => 56
		}
	},
	{#State 49
		ACTIONS => {
			";" => 57
		}
	},
	{#State 50
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'tuple_types' => 58,
			'structure' => 41,
			'tuple_type' => 59,
			'tuple' => 43,
			'type' => 60,
			'list' => 46
		}
	},
	{#State 51
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'tuple_type' => 61,
			'structure' => 41,
			'tuple' => 43,
			'type' => 60,
			'list' => 46
		}
	},
	{#State 52
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'structure' => 41,
			'type' => 62,
			'tuple' => 43,
			'list' => 46
		}
	},
	{#State 53
		DEFAULT => -22,
		GOTOS => {
			'@2-3' => 63
		}
	},
	{#State 54
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'structure' => 41,
			'tuple' => 43,
			'type' => 66,
			'struct_items' => 65,
			'struct_item' => 64,
			'list' => 46
		}
	},
	{#State 55
		ACTIONS => {
			"(" => 67
		}
	},
	{#State 56
		DEFAULT => -26,
		GOTOS => {
			'@4-4' => 68
		}
	},
	{#State 57
		DEFAULT => -16
	},
	{#State 58
		ACTIONS => {
			"," => 69,
			">" => 70
		}
	},
	{#State 59
		DEFAULT => -51
	},
	{#State 60
		ACTIONS => {
			'IDENT' => 71
		},
		DEFAULT => -53
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
		DEFAULT => -45
	},
	{#State 65
		ACTIONS => {
			"}" => 75,
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'structure' => 41,
			'tuple' => 43,
			'type' => 66,
			'struct_item' => 76,
			'list' => 46
		}
	},
	{#State 66
		ACTIONS => {
			'IDENT' => 77
		}
	},
	{#State 67
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'IDENT' => 39,
			'MAPPING' => 40,
			'LIST' => 42,
			'STRUCTURE' => 45
		},
		DEFAULT => -32,
		GOTOS => {
			'funcdef_param' => 79,
			'mapping' => 37,
			'structure' => 41,
			'funcdef_params' => 78,
			'type' => 80,
			'tuple' => 43,
			'list' => 46
		}
	},
	{#State 68
		ACTIONS => {
			"(" => 81
		}
	},
	{#State 69
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'tuple_type' => 82,
			'structure' => 41,
			'tuple' => 43,
			'type' => 60,
			'list' => 46
		}
	},
	{#State 70
		DEFAULT => -50
	},
	{#State 71
		DEFAULT => -54
	},
	{#State 72
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'mapping' => 37,
			'tuple_type' => 83,
			'structure' => 41,
			'tuple' => 43,
			'type' => 60,
			'list' => 46
		}
	},
	{#State 73
		DEFAULT => -49
	},
	{#State 74
		DEFAULT => -23
	},
	{#State 75
		DEFAULT => -44
	},
	{#State 76
		DEFAULT => -46
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
		DEFAULT => -33
	},
	{#State 80
		ACTIONS => {
			'IDENT' => 88
		},
		DEFAULT => -36
	},
	{#State 81
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'IDENT' => 39,
			'MAPPING' => 40,
			'LIST' => 42,
			'STRUCTURE' => 45
		},
		DEFAULT => -32,
		GOTOS => {
			'funcdef_param' => 79,
			'mapping' => 37,
			'structure' => 41,
			'funcdef_params' => 89,
			'type' => 80,
			'tuple' => 43,
			'list' => 46
		}
	},
	{#State 82
		DEFAULT => -52
	},
	{#State 83
		ACTIONS => {
			">" => 90
		}
	},
	{#State 84
		DEFAULT => -47
	},
	{#State 85
		ACTIONS => {
			";" => 91
		}
	},
	{#State 86
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'LIST' => 42,
			'IDENT' => 39,
			'MAPPING' => 40,
			'STRUCTURE' => 45
		},
		GOTOS => {
			'funcdef_param' => 92,
			'mapping' => 37,
			'structure' => 41,
			'type' => 80,
			'tuple' => 43,
			'list' => 46
		}
	},
	{#State 87
		ACTIONS => {
			'RETURNS' => 93
		}
	},
	{#State 88
		DEFAULT => -35
	},
	{#State 89
		ACTIONS => {
			"," => 86,
			")" => 94
		}
	},
	{#State 90
		DEFAULT => -43
	},
	{#State 91
		DEFAULT => -48
	},
	{#State 92
		DEFAULT => -34
	},
	{#State 93
		ACTIONS => {
			"(" => 95
		}
	},
	{#State 94
		ACTIONS => {
			'AUTHENTICATION' => 15
		},
		DEFAULT => -28,
		GOTOS => {
			'auth_param' => 97,
			'auth_type' => 96
		}
	},
	{#State 95
		ACTIONS => {
			'TYPENAME' => 36,
			'TUPLE' => 38,
			'IDENT' => 39,
			'MAPPING' => 40,
			'LIST' => 42,
			'STRUCTURE' => 45
		},
		DEFAULT => -32,
		GOTOS => {
			'funcdef_param' => 79,
			'mapping' => 37,
			'structure' => 41,
			'funcdef_params' => 98,
			'type' => 80,
			'tuple' => 43,
			'list' => 46
		}
	},
	{#State 96
		DEFAULT => -29
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
		DEFAULT => -27
	},
	{#State 100
		ACTIONS => {
			'AUTHENTICATION' => 15
		},
		DEFAULT => -28,
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
		DEFAULT => -25
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
#line 121 "typedoc.yp"
{ [] }
	],
	[#Rule 3
		 'module_list', 2,
sub
#line 122 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 4
		 '@1-2', 0,
sub
#line 125 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 5
		 'module', 8,
sub
#line 125 "typedoc.yp"
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
#line 133 "typedoc.yp"
{ [ module_name => $_[1], service_name => $_[1] ] }
	],
	[#Rule 7
		 'mod_name_def', 3,
sub
#line 134 "typedoc.yp"
{ [ module_name => $_[3], service_name => $_[1] ] }
	],
	[#Rule 8
		 'module_opts', 0,
sub
#line 137 "typedoc.yp"
{ [] }
	],
	[#Rule 9
		 'module_opts', 2,
sub
#line 138 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 10
		 'module_components', 0,
sub
#line 141 "typedoc.yp"
{ [] }
	],
	[#Rule 11
		 'module_components', 2,
sub
#line 142 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 12
		 'module_component_with_doc', 1, undef
	],
	[#Rule 13
		 'module_component_with_doc', 2,
sub
#line 147 "typedoc.yp"
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
#line 154 "typedoc.yp"
{ $auth_default = $_[1]; 'auth_default' . $_[1] }
	],
	[#Rule 18
		 'auth_type', 2,
sub
#line 157 "typedoc.yp"
{ lc($_[2]); }
	],
	[#Rule 19
		 'auth_kind', 1, undef
	],
	[#Rule 20
		 'auth_kind', 1, undef
	],
	[#Rule 21
		 'auth_kind', 1, undef
	],
	[#Rule 22
		 '@2-3', 0,
sub
#line 165 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 23
		 'typedef', 5,
sub
#line 165 "typedoc.yp"
{ $_[0]->define_type($_[2], $_[3], $_[4]); }
	],
	[#Rule 24
		 '@3-3', 0,
sub
#line 168 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 25
		 'funcdef', 13,
sub
#line 169 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Funcdef->new(return_type => $_[10], name => $_[3], parameters => $_[6],
			      comment => $_[4], async => $_[1], authentication => $_[12] ); }
	],
	[#Rule 26
		 '@4-4', 0,
sub
#line 171 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 27
		 'funcdef', 10,
sub
#line 172 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Funcdef->new(return_type => [$_[3]], name => $_[4], parameters => $_[7],
			      comment => $_[5], async => $_[1], authentication => $_[9]); }
	],
	[#Rule 28
		 'auth_param', 0,
sub
#line 176 "typedoc.yp"
{ $auth_default }
	],
	[#Rule 29
		 'auth_param', 1, undef
	],
	[#Rule 30
		 'async_flag', 0,
sub
#line 180 "typedoc.yp"
{ 0 }
	],
	[#Rule 31
		 'async_flag', 1,
sub
#line 181 "typedoc.yp"
{ 1 }
	],
	[#Rule 32
		 'funcdef_params', 0,
sub
#line 184 "typedoc.yp"
{ [] }
	],
	[#Rule 33
		 'funcdef_params', 1,
sub
#line 185 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 34
		 'funcdef_params', 3,
sub
#line 186 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 35
		 'funcdef_param', 2,
sub
#line 189 "typedoc.yp"
{ { type => $_[1], name => $_[2] } }
	],
	[#Rule 36
		 'funcdef_param', 1,
sub
#line 190 "typedoc.yp"
{ { type => $_[1] } }
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
		 'type', 1, undef
	],
	[#Rule 41
		 'type', 1, undef
	],
	[#Rule 42
		 'type', 1,
sub
#line 199 "typedoc.yp"
{ my $type = $_[0]->lookup_type($_[1]);
			if (!defined($type))
			{
			    $_[0]->emit_error("Attempt to use undefined type '$_[1]'");
			}
			$type }
	],
	[#Rule 43
		 'mapping', 6,
sub
#line 207 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Mapping->new(key_type => $_[3]->[0], value_type=> $_[5]->[0]); }
	],
	[#Rule 44
		 'structure', 4,
sub
#line 210 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Struct->new(items => $_[3]); }
	],
	[#Rule 45
		 'struct_items', 1,
sub
#line 213 "typedoc.yp"
{ [$_[1]] }
	],
	[#Rule 46
		 'struct_items', 2,
sub
#line 214 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 47
		 'struct_item', 3,
sub
#line 217 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 0); }
	],
	[#Rule 48
		 'struct_item', 4,
sub
#line 218 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 1); }
	],
	[#Rule 49
		 'list', 4,
sub
#line 221 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::List->new(element_type => $_[3]); }
	],
	[#Rule 50
		 'tuple', 4,
sub
#line 224 "typedoc.yp"
{ Bio::KBase::KIDL::KBT::Tuple->new(element_types => [ map { $_->[0] } @{$_[3]}],
							    element_names => [ map { $_->[1] } @{$_[3]}] ); }
	],
	[#Rule 51
		 'tuple_types', 1,
sub
#line 228 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 52
		 'tuple_types', 3,
sub
#line 229 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 53
		 'tuple_type', 1,
sub
#line 232 "typedoc.yp"
{ [ $_[1], undef ] }
	],
	[#Rule 54
		 'tuple_type', 2,
sub
#line 233 "typedoc.yp"
{ [ $_[1], $_[2] ] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 236 "typedoc.yp"
 

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
    

1;
