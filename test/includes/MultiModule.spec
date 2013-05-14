


module A {

    typedef string a1;
    typedef int a2;
    
    
};


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
    
    
    /* note that this used to work, but now does not because symbol table actually gets cleared after each module is parsed */
    /* typedef b1 myB1String; */
    
};