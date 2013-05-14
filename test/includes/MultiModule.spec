


module A {

    typedef string a1;
    typedef int a2;
    
};


module B {
    typedef string b1;
    typedef int b2;
};


module MyModule {

    typedef string myString;
    
    typedef B.b1 yourString;
    
    
    
    
    
    
    /* note that this used to work, but now does not because symbol table actually gets cleared after each module is parsed */
    /* typedef b1 myB1String; */
    
};