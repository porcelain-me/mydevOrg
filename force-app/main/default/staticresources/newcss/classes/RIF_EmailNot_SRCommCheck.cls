global class RIF_EmailNot_SRCommCheck implements Database.Batchable<sObject>{ 
   private final String  query;
   global RIF_EmailNot_SRCommCheck(String q){
       query=q;
   
   }
   //List <Messaging.SingleEmailMessage> emailObjList=new List <Messaging.SingleEmailMessage>();
     


   global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
   }


   global void execute(Database.BatchableContext BC, 
                       List<Severance_And_Release__c> scope){
      
     //RIF_Util_Test.sendRIFReminderEmails((sr__c)scope);
     List<EmailTemplate> RIFReminderEmailTemplate=[select id,developername from emailtemplate where developername='RIF_Reminder_to_HR_on_CommunicationList'];
     if(RIFReminderEmailTemplate != null && RIFReminderEmailTemplate.size() >0){
            RIF_Util_Test.sendRIFReminderEmails(scope,RIFReminderEmailTemplate[0].Id);  
     }  
   }
   
   

   global void finish(Database.BatchableContext BC){
      
   }
}