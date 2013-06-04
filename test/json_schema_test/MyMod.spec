




module MyMod {


    typedef string fid;
    typedef fid myfid;
    
    
    typedef structure {
        string name;
        string id;
        string sequence;
        list <mapping<fid,int>> features;
        int more_math;
        mapping <fid,fid> stuff;
    } Genome;
    
    
    
    typedef structure {
        string name;
        myfid some_math;
        mapping<string,Genome> genomes;
    } Model;
    
    
    typedef mapping <fid,mapping<fid,fid>> genome2Model;
    
};