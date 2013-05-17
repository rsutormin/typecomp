

#include <../MyInclude.types>




module B {
    typedef string b1;
    typedef int b2;
    
    typedef structure {
        A.a1 a1string;
        b1 b1string;
    } BigB;
};




module MyModule {

    typedef string myString;
    
    typedef B.b1 yourString;
    
    
    typedef list<A.a1> myListOfAThings;
    
    
    funcdef getSomething(yourString B, A.a2 AString) returns (myListOfAThings);
    
};