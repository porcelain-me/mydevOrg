global class UpdateBCP implements Schedulable {
   global void execute(SchedulableContext SC) {

     Datetime obj1 = System.now();
     Datetime obj2 = obj1.addMinutes(-65); 
          
     List<AccountContactRole__c> accountContactRole = [SELECT MSET_Contact__c FROM AccountContactRole__c where  CreatedDate >=:obj2 ];
     for(AccountContactRole__c a : accountContactRole)
     {
       MSET_Contact__c contact = [SELECT NCMContactLists__c FROM MSET_Contact__c where  Id =: a.MSET_Contact__c];
       if(contact!= null)
       {
        if ((contact.NCMContactLists__c == null ))
        {
             contact.NCMContactLists__c = 'BCP Notification';
             update contact;
        }
        else
        {
           if(contact.NCMContactLists__c.indexOf('BCP Notification')==-1)
           {  
             contact.NCMContactLists__c =contact.NCMContactLists__c+ ';BCP Notification';
             update contact;
           }  
        }
       }
      } 
  }
}