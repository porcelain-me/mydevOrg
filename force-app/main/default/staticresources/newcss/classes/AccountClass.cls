public with sharing class AccountClass{
public Account a;
public AccountClass(){

  a=new Account();
}
   
public pagereference  save(){
   
   
            insert a;
        
        
          
          PageReference pr=new PageReference(('https://ap1.salesforce.com/'+a.Id));
      return pr;
  
}
}