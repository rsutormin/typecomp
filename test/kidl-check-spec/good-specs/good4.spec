

/*
some other test module
*/
module GoodSpecFour {

    /*
    this function is bad style, but should be ignored because it has the @deprecated flag
    @deprecated
    */
    funcdef GetThings() returns (string things);
    
    /*
    @deprecated GoodSpec.new_method
    */
    funcdef do_This_and_That(string stuff, string that) returns (int junk, string);
    
    
    /*
    @deprecated
    */
    typedef string BadNameForString;
    
    
    /*
    @deprecated GoodSpec.NewType
    */
    typedef structure {
        string name;
    } old_type;
    
};