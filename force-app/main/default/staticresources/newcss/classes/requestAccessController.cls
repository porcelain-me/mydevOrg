public with sharing class requestAccessController {

     


public Request_Access__c ra;
public requestAccessController(){

  ra=new Request_Access__c ();
}
   
public pagereference  save(){
   
               insert ra;
               
          
          PageReference pr=new PageReference(('https://ap1.salesforce.com/'+ra.Id));
      return pr;
}
}