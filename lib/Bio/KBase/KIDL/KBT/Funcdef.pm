package Bio::KBase::KIDL::KBT::Funcdef;

use Moose;
use Data::Dumper;

has 'return_type' => (is => 'rw');
has 'name' => (isa => 'Str', is => 'rw');
has 'async' => (isa => 'Bool', is => 'rw', default => 0);
has 'doc' => (isa => 'Str', is => 'rw');
has 'parameters' => (isa => 'ArrayRef', is => 'rw');
has 'comment' => (isa => 'Maybe[Str]', is => 'rw');
has 'attribute' => (isa => 'ArrayRef', is => 'rw', default => sub { [] }, lazy => 1);
has 'client_implemented' => (isa => 'Bool', is => 'rw', default => 0);
has 'hidden' => (isa => 'Bool', is => 'rw', default => 0);
has 'authentication' => (isa => 'Maybe[Str]', is => 'rw');
has 'implemented_by' => (isa => 'Maybe[ArrayRef[Str]]', is => 'rw');

sub BUILD
{
    my($self) = @_;

    #
    # Process attributes.
    #

    for my $attr (@{$self->attribute})
    {
	my $name = $attr->[0];
	my @params = @{$attr->[1]};

	if ($name eq 'hidden')
	{
	    if ($self->client_implemented)
	    {
		die "A method cannot be both hidden and client_implemented\n";
	    }
	    $self->hidden(1);
	}
	elsif ($name eq 'client_implemented')
	{
	    if ($self->hidden)
	    {
		die "A method cannot be both hidden and client_implemented\n";
	    }
	    $self->client_implemented(1);
	}
    }
    
}


sub as_string
{
    my($self) = @_;
    return join(" ", "funcdef", $self->return_type->as_string, $self->name,
		'(', join(", ", map { $_->{type}->as_string } @{$self->parameters}), ')') . ";";
}

1;
