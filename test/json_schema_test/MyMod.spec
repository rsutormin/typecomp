

#include <../MyInclude.types>


module MyMod {


    typedef string fid;
    
    
    /* my version of a fid */
    typedef fid myfid;
    
    
    /* this is a genome
    
    @optional more_math
    @optional id features more_math
    @optional name sequence someCrazyThings stuff
    */
    typedef structure {
        string name;
        string id;
        string sequence;
        list <mapping<fid,int>> features;
        int more_math;
        UnspecifiedObject someCrazyThings;
        mapping <fid,fid> stuff;
    } Genome;
    
    /*
    
    */
    typedef Genome MyGenome;
    
    /* this is a model */
    typedef structure {
        string name;
        myfid some_math;
        mapping<string,Genome> genomes;
    } Model;
    
    
    typedef tuple <fid,Genome,list<int>,Model> stupid_tuple;
    
    typedef mapping <fid,mapping<fid,fid>> genome2Model;
    
};