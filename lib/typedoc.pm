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
    use KBT;
    use Data::Dumper;
    use File::Spec;

our %builtin_types = ('int' => KBT::Scalar->new(scalar_type => 'int'),
		      'string' => KBT::Scalar->new(scalar_type => 'string'),
		      'float' => KBT::Scalar->new(scalar_type => 'float'),
    );




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
			'MODULE' => 7,
			'AUTHENTICATED' => 6
		},
		GOTOS => {
			'module_opt' => 8
		}
	},
	{#State 4
		DEFAULT => -3
	},
	{#State 5
		DEFAULT => 0
	},
	{#State 6
		DEFAULT => -10
	},
	{#State 7
		DEFAULT => -4,
		GOTOS => {
			'@1-2' => 9
		}
	},
	{#State 8
		DEFAULT => -9
	},
	{#State 9
		ACTIONS => {
			'IDENT' => 10
		},
		GOTOS => {
			'mod_name_def' => 11
		}
	},
	{#State 10
		ACTIONS => {
			":" => 12
		},
		DEFAULT => -6
	},
	{#State 11
		ACTIONS => {
			"{" => 13
		}
	},
	{#State 12
		ACTIONS => {
			'IDENT' => 14
		}
	},
	{#State 13
		DEFAULT => -11,
		GOTOS => {
			'module_components' => 15
		}
	},
	{#State 14
		DEFAULT => -7
	},
	{#State 15
		ACTIONS => {
			"}" => 16,
			'ASYNC' => 21,
			"use" => 22,
			'DOC_COMMENT' => 18,
			'TYPEDEF' => 23
		},
		DEFAULT => -24,
		GOTOS => {
			'async_flag' => 20,
			'module_component' => 17,
			'funcdef' => 19,
			'typedef' => 24,
			'module_component_with_doc' => 25
		}
	},
	{#State 16
		ACTIONS => {
			";" => 26
		}
	},
	{#State 17
		DEFAULT => -13
	},
	{#State 18
		ACTIONS => {
			'ASYNC' => 21,
			"use" => 22,
			'TYPEDEF' => 23
		},
		DEFAULT => -24,
		GOTOS => {
			'async_flag' => 20,
			'module_component' => 27,
			'funcdef' => 19,
			'typedef' => 24
		}
	},
	{#State 19
		DEFAULT => -16
	},
	{#State 20
		ACTIONS => {
			'FUNCDEF' => 28
		}
	},
	{#State 21
		DEFAULT => -25
	},
	{#State 22
		ACTIONS => {
			"module" => 29
		}
	},
	{#State 23
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'structure' => 35,
			'type' => 38,
			'tuple' => 37,
			'list' => 40
		}
	},
	{#State 24
		DEFAULT => -15
	},
	{#State 25
		DEFAULT => -12
	},
	{#State 26
		DEFAULT => -5
	},
	{#State 27
		DEFAULT => -14
	},
	{#State 28
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 41,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'structure' => 35,
			'type' => 42,
			'tuple' => 37,
			'list' => 40
		}
	},
	{#State 29
		ACTIONS => {
			'ident' => 43
		}
	},
	{#State 30
		DEFAULT => -31
	},
	{#State 31
		DEFAULT => -32
	},
	{#State 32
		ACTIONS => {
			"<" => 44
		}
	},
	{#State 33
		DEFAULT => -36
	},
	{#State 34
		ACTIONS => {
			"<" => 45
		}
	},
	{#State 35
		DEFAULT => -33
	},
	{#State 36
		ACTIONS => {
			"<" => 46
		}
	},
	{#State 37
		DEFAULT => -35
	},
	{#State 38
		ACTIONS => {
			'IDENT' => 47
		}
	},
	{#State 39
		ACTIONS => {
			"{" => 48
		}
	},
	{#State 40
		DEFAULT => -34
	},
	{#State 41
		ACTIONS => {
			'IDENT' => -36
		},
		DEFAULT => -20,
		GOTOS => {
			'@3-3' => 49
		}
	},
	{#State 42
		ACTIONS => {
			'IDENT' => 50
		}
	},
	{#State 43
		ACTIONS => {
			";" => 51
		}
	},
	{#State 44
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'tuple_types' => 52,
			'structure' => 35,
			'tuple_type' => 53,
			'tuple' => 37,
			'type' => 54,
			'list' => 40
		}
	},
	{#State 45
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'tuple_type' => 55,
			'structure' => 35,
			'tuple' => 37,
			'type' => 54,
			'list' => 40
		}
	},
	{#State 46
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'structure' => 35,
			'type' => 56,
			'tuple' => 37,
			'list' => 40
		}
	},
	{#State 47
		DEFAULT => -18,
		GOTOS => {
			'@2-3' => 57
		}
	},
	{#State 48
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'structure' => 35,
			'tuple' => 37,
			'type' => 60,
			'struct_items' => 59,
			'struct_item' => 58,
			'list' => 40
		}
	},
	{#State 49
		ACTIONS => {
			"(" => 61
		}
	},
	{#State 50
		DEFAULT => -22,
		GOTOS => {
			'@4-4' => 62
		}
	},
	{#State 51
		DEFAULT => -17
	},
	{#State 52
		ACTIONS => {
			"," => 63,
			">" => 64
		}
	},
	{#State 53
		DEFAULT => -45
	},
	{#State 54
		ACTIONS => {
			'IDENT' => 65
		},
		DEFAULT => -47
	},
	{#State 55
		ACTIONS => {
			"," => 66
		}
	},
	{#State 56
		ACTIONS => {
			">" => 67
		}
	},
	{#State 57
		ACTIONS => {
			";" => 68
		}
	},
	{#State 58
		DEFAULT => -39
	},
	{#State 59
		ACTIONS => {
			"}" => 69,
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'structure' => 35,
			'tuple' => 37,
			'type' => 60,
			'struct_item' => 70,
			'list' => 40
		}
	},
	{#State 60
		ACTIONS => {
			'IDENT' => 71
		}
	},
	{#State 61
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'IDENT' => 33,
			'MAPPING' => 34,
			'LIST' => 36,
			'STRUCTURE' => 39
		},
		DEFAULT => -26,
		GOTOS => {
			'funcdef_param' => 73,
			'mapping' => 31,
			'structure' => 35,
			'funcdef_params' => 72,
			'type' => 74,
			'tuple' => 37,
			'list' => 40
		}
	},
	{#State 62
		ACTIONS => {
			"(" => 75
		}
	},
	{#State 63
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'tuple_type' => 76,
			'structure' => 35,
			'tuple' => 37,
			'type' => 54,
			'list' => 40
		}
	},
	{#State 64
		DEFAULT => -44
	},
	{#State 65
		DEFAULT => -48
	},
	{#State 66
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'mapping' => 31,
			'tuple_type' => 77,
			'structure' => 35,
			'tuple' => 37,
			'type' => 54,
			'list' => 40
		}
	},
	{#State 67
		DEFAULT => -43
	},
	{#State 68
		DEFAULT => -19
	},
	{#State 69
		DEFAULT => -38
	},
	{#State 70
		DEFAULT => -40
	},
	{#State 71
		ACTIONS => {
			'NULLABLE' => 79,
			";" => 78
		}
	},
	{#State 72
		ACTIONS => {
			"," => 80,
			")" => 81
		}
	},
	{#State 73
		DEFAULT => -27
	},
	{#State 74
		ACTIONS => {
			'IDENT' => 82
		},
		DEFAULT => -30
	},
	{#State 75
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'IDENT' => 33,
			'MAPPING' => 34,
			'LIST' => 36,
			'STRUCTURE' => 39
		},
		DEFAULT => -26,
		GOTOS => {
			'funcdef_param' => 73,
			'mapping' => 31,
			'structure' => 35,
			'funcdef_params' => 83,
			'type' => 74,
			'tuple' => 37,
			'list' => 40
		}
	},
	{#State 76
		DEFAULT => -46
	},
	{#State 77
		ACTIONS => {
			">" => 84
		}
	},
	{#State 78
		DEFAULT => -41
	},
	{#State 79
		ACTIONS => {
			";" => 85
		}
	},
	{#State 80
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'LIST' => 36,
			'IDENT' => 33,
			'MAPPING' => 34,
			'STRUCTURE' => 39
		},
		GOTOS => {
			'funcdef_param' => 86,
			'mapping' => 31,
			'structure' => 35,
			'type' => 74,
			'tuple' => 37,
			'list' => 40
		}
	},
	{#State 81
		ACTIONS => {
			'RETURNS' => 87
		}
	},
	{#State 82
		DEFAULT => -29
	},
	{#State 83
		ACTIONS => {
			"," => 80,
			")" => 88
		}
	},
	{#State 84
		DEFAULT => -37
	},
	{#State 85
		DEFAULT => -42
	},
	{#State 86
		DEFAULT => -28
	},
	{#State 87
		ACTIONS => {
			"(" => 89
		}
	},
	{#State 88
		ACTIONS => {
			";" => 90
		}
	},
	{#State 89
		ACTIONS => {
			'TYPENAME' => 30,
			'TUPLE' => 32,
			'IDENT' => 33,
			'MAPPING' => 34,
			'LIST' => 36,
			'STRUCTURE' => 39
		},
		DEFAULT => -26,
		GOTOS => {
			'funcdef_param' => 73,
			'mapping' => 31,
			'structure' => 35,
			'funcdef_params' => 91,
			'type' => 74,
			'tuple' => 37,
			'list' => 40
		}
	},
	{#State 90
		DEFAULT => -23
	},
	{#State 91
		ACTIONS => {
			"," => 80,
			")" => 92
		}
	},
	{#State 92
		ACTIONS => {
			";" => 93
		}
	},
	{#State 93
		DEFAULT => -21
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
#line 24 "typedoc.yp"
{ [] }
	],
	[#Rule 3
		 'module_list', 2,
sub
#line 25 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 4
		 '@1-2', 0,
sub
#line 28 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 5
		 'module', 8,
sub
#line 28 "typedoc.yp"
{
    KBT::DefineModule->new(options => $_[1],
			   @{$_[4]},
			   module_components => $_[6],
		           comment => $_[3]);
    }
	],
	[#Rule 6
		 'mod_name_def', 1,
sub
#line 36 "typedoc.yp"
{ [ module_name => $_[1], service_name => $_[1] ] }
	],
	[#Rule 7
		 'mod_name_def', 3,
sub
#line 37 "typedoc.yp"
{ [ module_name => $_[3], service_name => $_[1] ] }
	],
	[#Rule 8
		 'module_opts', 0,
sub
#line 40 "typedoc.yp"
{ [] }
	],
	[#Rule 9
		 'module_opts', 2,
sub
#line 41 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 10
		 'module_opt', 1, undef
	],
	[#Rule 11
		 'module_components', 0,
sub
#line 48 "typedoc.yp"
{ [] }
	],
	[#Rule 12
		 'module_components', 2,
sub
#line 49 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 13
		 'module_component_with_doc', 1, undef
	],
	[#Rule 14
		 'module_component_with_doc', 2,
sub
#line 54 "typedoc.yp"
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
		 '@2-3', 0,
sub
#line 63 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 19
		 'typedef', 5,
sub
#line 63 "typedoc.yp"
{ $_[0]->define_type($_[2], $_[3], $_[4]); }
	],
	[#Rule 20
		 '@3-3', 0,
sub
#line 66 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 21
		 'funcdef', 12,
sub
#line 67 "typedoc.yp"
{ KBT::Funcdef->new(return_type => $_[10], name => $_[3], parameters => $_[6],
			      comment => $_[4], async => $_[1] ); }
	],
	[#Rule 22
		 '@4-4', 0,
sub
#line 69 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 23
		 'funcdef', 9,
sub
#line 70 "typedoc.yp"
{ KBT::Funcdef->new(return_type => [$_[3]], name => $_[4], parameters => $_[7],
			      comment => $_[5], async => $_[1]); }
	],
	[#Rule 24
		 'async_flag', 0,
sub
#line 74 "typedoc.yp"
{ 0 }
	],
	[#Rule 25
		 'async_flag', 1,
sub
#line 75 "typedoc.yp"
{ 1 }
	],
	[#Rule 26
		 'funcdef_params', 0,
sub
#line 78 "typedoc.yp"
{ [] }
	],
	[#Rule 27
		 'funcdef_params', 1,
sub
#line 79 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 28
		 'funcdef_params', 3,
sub
#line 80 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 29
		 'funcdef_param', 2,
sub
#line 83 "typedoc.yp"
{ { type => $_[1], name => $_[2] } }
	],
	[#Rule 30
		 'funcdef_param', 1,
sub
#line 84 "typedoc.yp"
{ { type => $_[1] } }
	],
	[#Rule 31
		 'type', 1, undef
	],
	[#Rule 32
		 'type', 1, undef
	],
	[#Rule 33
		 'type', 1, undef
	],
	[#Rule 34
		 'type', 1, undef
	],
	[#Rule 35
		 'type', 1, undef
	],
	[#Rule 36
		 'type', 1,
sub
#line 93 "typedoc.yp"
{ my $type = $_[0]->lookup_type($_[1]);
			if (!defined($type))
			{
			    $_[0]->emit_error("Attempt to use undefined type '$_[1]'");
			}
			$type }
	],
	[#Rule 37
		 'mapping', 6,
sub
#line 101 "typedoc.yp"
{ KBT::Mapping->new(key_type => $_[3]->[0], value_type=> $_[5]->[0]); }
	],
	[#Rule 38
		 'structure', 4,
sub
#line 104 "typedoc.yp"
{ KBT::Struct->new(items => $_[3]); }
	],
	[#Rule 39
		 'struct_items', 1,
sub
#line 107 "typedoc.yp"
{ [$_[1]] }
	],
	[#Rule 40
		 'struct_items', 2,
sub
#line 108 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 41
		 'struct_item', 3,
sub
#line 111 "typedoc.yp"
{ KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 0); }
	],
	[#Rule 42
		 'struct_item', 4,
sub
#line 112 "typedoc.yp"
{ KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 1); }
	],
	[#Rule 43
		 'list', 4,
sub
#line 115 "typedoc.yp"
{ KBT::List->new(element_type => $_[3]); }
	],
	[#Rule 44
		 'tuple', 4,
sub
#line 118 "typedoc.yp"
{ KBT::Tuple->new(element_types => [ map { $_->[0] } @{$_[3]}],
							    element_names => [ map { $_->[1] } @{$_[3]}] ); }
	],
	[#Rule 45
		 'tuple_types', 1,
sub
#line 122 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 46
		 'tuple_types', 3,
sub
#line 123 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 47
		 'tuple_type', 1,
sub
#line 126 "typedoc.yp"
{ [ $_[1], undef ] }
	],
	[#Rule 48
		 'tuple_type', 2,
sub
#line 127 "typedoc.yp"
{ [ $_[1], $_[2] ] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 130 "typedoc.yp"
 

sub define_type
{
    my($self, $old_type, $new_type, $comment) = @_;
    my $def = KBT::Typedef->new(name => $new_type, alias_type => $old_type, comment => $comment);
    push(@{$self->YYData->{type_list}}, $def);
    $self->YYData->{type_table}->{$new_type} = $def;
    #
    # Try to name the typedefed type if it is a tuple or struct.
    #
    if ($old_type->isa('KBT::Struct') || $old_type->isa('KBT::Tuple'))
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
	    elsif (s/^(funcdef|typedef|module|list|mapping|structure|nullable|returns|authenticated|tuple|async)\b//)
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
