

#include <../MyInclude.types>


module MyMod {


    typedef string fid;
    
    
    /* my version of a fid */
    typedef fid myfid;
    
    
    /* this is a genome */
    typedef structure {
        string name;
        string id;
        string sequence;
        list <mapping<fid,int>> features;
        int more_math;
        mapping <fid,fid> stuff;
    } Genome;
    
    /* this is a model */
    typedef structure {
        string name;
        myfid some_math;
        mapping<string,Genome> genomes;
    } Model;
    
    
    typedef tuple <fid,Genome,list<int>,Model> stupid_tuple;
    
    typedef mapping <fid,mapping<fid,fid>> genome2Model;
    
};