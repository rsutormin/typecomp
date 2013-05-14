package Bio::KBase::KIDL::KBT::Typedef;

use Moose;
use Data::Dumper;
use Lingua::EN::Inflect 'A';

has 'alias_type' => (is => 'rw');
has 'name' => (isa => 'Str', is => 'rw');
has 'module' => (isa => 'Str', is => 'rw');
has 'comment' => (isa => 'Str', is => 'rw');

sub as_string
{
    my($self) = @_;
#    return join(" ", "typedef", $self->alias_type->as_string, $self->name) . ";";
    return $self->alias_type->as_string;
}

sub get_validation_code
{
    my($self) = @_;
    return $self->alias_type->get_validation_code;
}

sub get_validation_routine
{
    my($self, $var) = @_;
    return $self->alias_type->get_validation_routine($var);
}

sub english
{
    my($self) = @_;
    
    return A($self->name);
}

# now returns a list of lists, with typenames and source modules
sub subtypes
{
    my($self, $seen) = @_;
    my $out = [];

    if (!$seen->{$self->module."'".$self->name})
    {
        
	push(@$out, [$self->module, $self->name]);
	$seen->{$self->module."'".$self->name} = 1;
    }
    
    push(@$out, @{$self->alias_type->subtypes($seen)});

    return $out;
}

#sub subtypes
#{
#    my($self, $seen) = @_;
#    my $out = [];
#
#    if (!$seen->{$self->name})
#    {
#	push(@$out, $self->name);
#	$seen->{$self->name} = 1;
#    }
#    
#    push(@$out, @{$self->alias_type->subtypes($seen)});
#
#    return $out;
#}

1;
