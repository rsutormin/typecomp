

#include <../MyInclude.types>

module B {
    typedef string b1;
    typedef int b2;
    
    typedef structure {
        b1 b1string;
    } BigB;
};





/*  blah




*/
module MyService:MyModule {

/*asdf*/

/*

*/
typedef string myString;
    
    typedef B.b1 yourString;
    
    typedef B.BigB myB;
    
    
    funcdef getSomething(yourString B) returns (int);
    
};