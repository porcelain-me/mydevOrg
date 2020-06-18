public with sharing class RandomContactFactory { 
    Public static List<Contact> generateRandomContacts(Integer a, string b ){
        List<Contact> conlist = new List <Contact>();
        for(Integer i=0;i<a;i++){
            Contact con = New Contact(FirstName ='Test'+i,LastName =b);
            conlist.add(con);}
        //Insert Conlist;
     system.debug('test'+conlist);
        Return conlist;        
    }

}