

/* some test module */
module MyServ:GoodSpec {

    /*
    define a bunch of standard types
    */
    typedef string mystring;
    /* comment */
    typedef mystring my_better_string;
    
    /* comment */
    typedef int myint;
    
    /* comment */
    typedef float my_float;
    
    /* comment */
    typedef list <myint> my_int_list;
    
    /* comment */
    typedef mapping <mystring,my_float> my_mapping;
    
    /* comment */
    typedef tuple <string,int,float> my_tuple;
    
    /*
    define a valid structure
    */
    typedef structure {
        string nsame;
        int value;
    } MyStructure;
    
    
    /*
    define some lists that reference that structure
    */
    typedef list <MyStructure> my_list_of_MyStructure;


    /* comment */
    typedef list <MyStructure> my_list_of_MyStructures;
    
    /* comment */
    typedef mapping <string,MyStructure> mapping_of_MyStructure;

    /* comment */
    typedef mapping <string,MyStructure> mapping_of_MyStructures;

};

