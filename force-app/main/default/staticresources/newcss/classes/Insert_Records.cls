public with sharing class Insert_Records {

public string test {get; set;}

    public void save(){
    test = 'a;b;c;d;';
    
    List<string> teststring = test.split('\\;');
    
    System.debug('a**************'+teststring[0]+'b!!!!!!!!!!!!!'+teststring[1]);
    
        
}

}