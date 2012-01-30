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
		DEFAULT => -6,
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
		DEFAULT => -8
	},
	{#State 7
		DEFAULT => -4,
		GOTOS => {
			'@1-2' => 9
		}
	},
	{#State 8
		DEFAULT => -7
	},
	{#State 9
		ACTIONS => {
			'IDENT' => 10
		}
	},
	{#State 10
		ACTIONS => {
			"{" => 11
		}
	},
	{#State 11
		DEFAULT => -9,
		GOTOS => {
			'module_components' => 12
		}
	},
	{#State 12
		ACTIONS => {
			"}" => 13,
			"use" => 18,
			'DOC_COMMENT' => 15,
			'TYPEDEF' => 19,
			'FUNCDEF' => 17
		},
		GOTOS => {
			'module_component' => 14,
			'funcdef' => 16,
			'typedef' => 20,
			'module_component_with_doc' => 21
		}
	},
	{#State 13
		ACTIONS => {
			";" => 22
		}
	},
	{#State 14
		DEFAULT => -11
	},
	{#State 15
		ACTIONS => {
			"use" => 18,
			'TYPEDEF' => 19,
			'FUNCDEF' => 17
		},
		GOTOS => {
			'module_component' => 23,
			'funcdef' => 16,
			'typedef' => 20
		}
	},
	{#State 16
		DEFAULT => -14
	},
	{#State 17
		ACTIONS => {
			'IDENT' => -18
		},
		DEFAULT => -20,
		GOTOS => {
			'@4-1' => 24,
			'@3-1' => 25
		}
	},
	{#State 18
		ACTIONS => {
			"module" => 26
		}
	},
	{#State 19
		DEFAULT => -16,
		GOTOS => {
			'@2-1' => 27
		}
	},
	{#State 20
		DEFAULT => -13
	},
	{#State 21
		DEFAULT => -10
	},
	{#State 22
		DEFAULT => -5
	},
	{#State 23
		DEFAULT => -12
	},
	{#State 24
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'structure' => 32,
			'type' => 35,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 25
		ACTIONS => {
			'IDENT' => 38
		}
	},
	{#State 26
		ACTIONS => {
			'ident' => 39
		}
	},
	{#State 27
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'structure' => 32,
			'type' => 40,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 28
		DEFAULT => -27
	},
	{#State 29
		DEFAULT => -28
	},
	{#State 30
		ACTIONS => {
			"<" => 41
		}
	},
	{#State 31
		ACTIONS => {
			"<" => 42
		}
	},
	{#State 32
		DEFAULT => -29
	},
	{#State 33
		ACTIONS => {
			"<" => 43
		}
	},
	{#State 34
		DEFAULT => -31
	},
	{#State 35
		ACTIONS => {
			'IDENT' => 44
		}
	},
	{#State 36
		ACTIONS => {
			"{" => 45
		}
	},
	{#State 37
		DEFAULT => -30
	},
	{#State 38
		ACTIONS => {
			"(" => 46
		}
	},
	{#State 39
		ACTIONS => {
			";" => 47
		}
	},
	{#State 40
		ACTIONS => {
			'IDENT' => 48
		}
	},
	{#State 41
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'tuple_types' => 49,
			'structure' => 32,
			'tuple_type' => 50,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 42
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'tuple_type' => 52,
			'structure' => 32,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 43
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'structure' => 32,
			'type' => 53,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 44
		ACTIONS => {
			"(" => 54
		}
	},
	{#State 45
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'structure' => 32,
			'tuple' => 34,
			'type' => 57,
			'struct_items' => 56,
			'struct_item' => 55,
			'list' => 37
		}
	},
	{#State 46
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'MAPPING' => 31,
			'LIST' => 33,
			'STRUCTURE' => 36
		},
		DEFAULT => -22,
		GOTOS => {
			'funcdef_param' => 59,
			'mapping' => 29,
			'structure' => 32,
			'funcdef_params' => 58,
			'type' => 60,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 47
		DEFAULT => -15
	},
	{#State 48
		ACTIONS => {
			";" => 61
		}
	},
	{#State 49
		ACTIONS => {
			"," => 62,
			">" => 63
		}
	},
	{#State 50
		DEFAULT => -40
	},
	{#State 51
		ACTIONS => {
			'IDENT' => 64
		},
		DEFAULT => -42
	},
	{#State 52
		ACTIONS => {
			"," => 65
		}
	},
	{#State 53
		ACTIONS => {
			">" => 66
		}
	},
	{#State 54
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'MAPPING' => 31,
			'LIST' => 33,
			'STRUCTURE' => 36
		},
		DEFAULT => -22,
		GOTOS => {
			'funcdef_param' => 59,
			'mapping' => 29,
			'structure' => 32,
			'funcdef_params' => 67,
			'type' => 60,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 55
		DEFAULT => -34
	},
	{#State 56
		ACTIONS => {
			"}" => 68,
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'structure' => 32,
			'tuple' => 34,
			'type' => 57,
			'struct_item' => 69,
			'list' => 37
		}
	},
	{#State 57
		ACTIONS => {
			'IDENT' => 70
		}
	},
	{#State 58
		ACTIONS => {
			"," => 71,
			")" => 72
		}
	},
	{#State 59
		DEFAULT => -23
	},
	{#State 60
		ACTIONS => {
			'IDENT' => 73
		},
		DEFAULT => -26
	},
	{#State 61
		DEFAULT => -17
	},
	{#State 62
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'tuple_type' => 74,
			'structure' => 32,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 63
		DEFAULT => -39
	},
	{#State 64
		DEFAULT => -43
	},
	{#State 65
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'mapping' => 29,
			'tuple_type' => 75,
			'structure' => 32,
			'tuple' => 34,
			'type' => 51,
			'list' => 37
		}
	},
	{#State 66
		DEFAULT => -38
	},
	{#State 67
		ACTIONS => {
			"," => 71,
			")" => 76
		}
	},
	{#State 68
		DEFAULT => -33
	},
	{#State 69
		DEFAULT => -35
	},
	{#State 70
		ACTIONS => {
			'NULLABLE' => 78,
			";" => 77
		}
	},
	{#State 71
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'LIST' => 33,
			'MAPPING' => 31,
			'STRUCTURE' => 36
		},
		GOTOS => {
			'funcdef_param' => 79,
			'mapping' => 29,
			'structure' => 32,
			'type' => 60,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 72
		ACTIONS => {
			'RETURNS' => 80
		}
	},
	{#State 73
		DEFAULT => -25
	},
	{#State 74
		DEFAULT => -41
	},
	{#State 75
		ACTIONS => {
			">" => 81
		}
	},
	{#State 76
		ACTIONS => {
			";" => 82
		}
	},
	{#State 77
		DEFAULT => -36
	},
	{#State 78
		ACTIONS => {
			";" => 83
		}
	},
	{#State 79
		DEFAULT => -24
	},
	{#State 80
		ACTIONS => {
			"(" => 84
		}
	},
	{#State 81
		DEFAULT => -32
	},
	{#State 82
		DEFAULT => -21
	},
	{#State 83
		DEFAULT => -37
	},
	{#State 84
		ACTIONS => {
			'TYPENAME' => 28,
			'TUPLE' => 30,
			'MAPPING' => 31,
			'LIST' => 33,
			'STRUCTURE' => 36
		},
		DEFAULT => -22,
		GOTOS => {
			'funcdef_param' => 59,
			'mapping' => 29,
			'structure' => 32,
			'funcdef_params' => 85,
			'type' => 60,
			'tuple' => 34,
			'list' => 37
		}
	},
	{#State 85
		ACTIONS => {
			"," => 71,
			")" => 86
		}
	},
	{#State 86
		ACTIONS => {
			";" => 87
		}
	},
	{#State 87
		DEFAULT => -19
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
			   module_name => $_[4],
			   module_components => $_[6],
		           comment => $_[3]);
    }
	],
	[#Rule 6
		 'module_opts', 0,
sub
#line 36 "typedoc.yp"
{ [] }
	],
	[#Rule 7
		 'module_opts', 2,
sub
#line 37 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 8
		 'module_opt', 1, undef
	],
	[#Rule 9
		 'module_components', 0,
sub
#line 44 "typedoc.yp"
{ [] }
	],
	[#Rule 10
		 'module_components', 2,
sub
#line 45 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 11
		 'module_component_with_doc', 1, undef
	],
	[#Rule 12
		 'module_component_with_doc', 2,
sub
#line 50 "typedoc.yp"
{ $_[2]->comment($_[1]); $_[2] }
	],
	[#Rule 13
		 'module_component', 1, undef
	],
	[#Rule 14
		 'module_component', 1, undef
	],
	[#Rule 15
		 'module_component', 4, undef
	],
	[#Rule 16
		 '@2-1', 0,
sub
#line 59 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 17
		 'typedef', 5,
sub
#line 59 "typedoc.yp"
{ $_[0]->define_type($_[3], $_[4], $_[2]); }
	],
	[#Rule 18
		 '@3-1', 0,
sub
#line 62 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 19
		 'funcdef', 11,
sub
#line 63 "typedoc.yp"
{ KBT::Funcdef->new(return_type => $_[9], name => $_[3], parameters => $_[5],
			      comment => $_[2]); }
	],
	[#Rule 20
		 '@4-1', 0,
sub
#line 65 "typedoc.yp"
{ $_[0]->get_comment() }
	],
	[#Rule 21
		 'funcdef', 8,
sub
#line 66 "typedoc.yp"
{ KBT::Funcdef->new(return_type => [$_[3]], name => $_[4], parameters => $_[6],
			      comment => $_[2]); }
	],
	[#Rule 22
		 'funcdef_params', 0,
sub
#line 70 "typedoc.yp"
{ [] }
	],
	[#Rule 23
		 'funcdef_params', 1,
sub
#line 71 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 24
		 'funcdef_params', 3,
sub
#line 72 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 25
		 'funcdef_param', 2,
sub
#line 75 "typedoc.yp"
{ { type => $_[1], name => $_[2] } }
	],
	[#Rule 26
		 'funcdef_param', 1,
sub
#line 76 "typedoc.yp"
{ { type => $_[1] } }
	],
	[#Rule 27
		 'type', 1, undef
	],
	[#Rule 28
		 'type', 1, undef
	],
	[#Rule 29
		 'type', 1, undef
	],
	[#Rule 30
		 'type', 1, undef
	],
	[#Rule 31
		 'type', 1, undef
	],
	[#Rule 32
		 'mapping', 6,
sub
#line 87 "typedoc.yp"
{ KBT::Mapping->new(key_type => $_[3], value_type=> $_[5]); }
	],
	[#Rule 33
		 'structure', 4,
sub
#line 90 "typedoc.yp"
{ KBT::Struct->new(items => $_[3]); }
	],
	[#Rule 34
		 'struct_items', 1,
sub
#line 93 "typedoc.yp"
{ [$_[1]] }
	],
	[#Rule 35
		 'struct_items', 2,
sub
#line 94 "typedoc.yp"
{ [ @{$_[1]}, $_[2] ] }
	],
	[#Rule 36
		 'struct_item', 3,
sub
#line 97 "typedoc.yp"
{ KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 0); }
	],
	[#Rule 37
		 'struct_item', 4,
sub
#line 98 "typedoc.yp"
{ KBT::StructItem->new(item_type => $_[1], name => $_[2], nullable => 1); }
	],
	[#Rule 38
		 'list', 4,
sub
#line 101 "typedoc.yp"
{ KBT::List->new(element_type => $_[3]); }
	],
	[#Rule 39
		 'tuple', 4,
sub
#line 104 "typedoc.yp"
{ KBT::Tuple->new(element_types => $_[3]); }
	],
	[#Rule 40
		 'tuple_types', 1,
sub
#line 107 "typedoc.yp"
{ [ $_[1] ] }
	],
	[#Rule 41
		 'tuple_types', 3,
sub
#line 108 "typedoc.yp"
{ [ @{$_[1]}, $_[3] ] }
	],
	[#Rule 42
		 'tuple_type', 1, undef
	],
	[#Rule 43
		 'tuple_type', 2,
sub
#line 112 "typedoc.yp"
{ $_[1] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 115 "typedoc.yp"
 

sub define_type
{
    my($self, $old_type, $new_type, $comment) = @_;
    my $def = KBT::Typedef->new(name => $new_type, alias_type => $old_type, comment => $comment);
    push(@{$self->YYData->{type_list}}, $def);
    $self->YYData->{type_table}->{$new_type} = $def;
    return $def;
}

sub types
{
    my($self) = @_;
    return $self->YYData->{type_list};
}

sub lookup_type
{
    my($self, $name) = @_;
    return $self->YYData->{type_table}->{$name};
}


sub parse
{
    my($self, $data) = @_;

    #
    # Initialize type table to just the builtins.
    #
    $self->YYData->{type_table} = { %builtin_types };

    $self->YYData->{INPUT} = $data;

    my $res = $self->YYParse(yylex => \&Lexer, yyerror => \&Error);

    return $res;
}


sub Error {
    my($parser) = @_;
    
    my $data = $parser->YYData;
    my $bufptr = \$data->{INPUT};

    my $ctx = substr($$bufptr, 0, 100);

    if ($data->{ERRMSG})
    {
        print $data->{ERRMSG};
	print "$ctx\n";
        delete $data->{ERRMSG};
        return;
    }
    else
    {
	print "Syntax error.\n";
	print "$ctx\n";
    }
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
	    s/^[ \t\n]+//;

	    
	    if ($_ eq '')
	    {
		return ('', undef);
	    }
	    elsif (s/^(funcdef|typedef|module|list|mapping|structure|nullable|returns|authenticated|tuple)\b//)
	    {
		return (uc($1), $1);
	    }
	    elsif (s/^([A-Za-z][A-Za-z0-9_]*)//)
	    {
		#print "Check builtin $1 " . Dumper($data->{type_table});
		
		if (my $type = $data->{type_table}->{$1})
		{
		    return('TYPENAME', $type);
		}
		else
		{
		    return('IDENT',$1);
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
