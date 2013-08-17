


module MyServ:GoodSpec {

    /*
    define a bunch of standard types
    */
    typedef string mystring;
    typedef string my_Blah;
    typedef mystring my_better_string;
    typedef int myint;
    typedef float my_float;
    
    typedef list <myint> my_int_list;
    typedef mapping <mystring,my_float> my_mapping;
    
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

    typedef list <MyStructure> my_list_of_MyStructures;
    
    typedef mapping <string,MyStructure> mapping_of_MyStructure;

    typedef mapping <string,MyStructure> mapping_of_MyStructures;

};

