package Bio::KBase::KIDL::KBT::UnspecifiedObject;
use Moose;

#  we need a way in KBase to return data as an unspecified type, particularly
#  to support the workspace service method which may save/retrieve data in any
#  possible type.  e.g save_object(UnspecifiedObject o, string type_name)
#  or get_object(string id) returns (MetaData d, UnspecifiedObject o)


sub as_string
{
    my($self) = @_;
    return "UnspecifiedObject";
}

sub english
{
    my($self) = @_;
    return "an UnspecifiedObject, which can hold any non-null object";
}

sub get_validation_code
{
    # perform absolutely no type checking
    return '';
}

sub get_validation_routine
{
    # perform absolutely no type checking, but do make sure the method was set to something 
    my($self, $var) = @_;
    return "defined $var";
}



sub subtypes
{
    return [];
}

1;
