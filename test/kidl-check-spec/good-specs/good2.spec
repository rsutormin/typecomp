
#include <good1.spec>

/*
some other test module
*/
module GoodSpecTwo {

    /*
    some description
    */
    funcdef get_MyStructure() returns (GoodSpec.MyStructure);
    
    
    
    /*
    some description
    */
    funcdef do_this_and_that(string stuff, string that) returns (int junk, string);
};