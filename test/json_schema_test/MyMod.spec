




module MyMod {


    typedef string fid;
    typedef fid myfid;
    
    
    typedef structure {
        string name;
        string id;
        string sequence;
        list <fid> features;
    } Genome;
    
    
    
    typedef structure {
        string name;
        int some_math;
    } Model;
    
    
    typedef mapping <fid,mapping<fid,fid>> genome2Model;
    
};