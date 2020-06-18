global class WV_ArchiveEligibleEmployees implements Database.Batchable<sObject>{
   public String query;
   
   global Database.QueryLocator start(Database.batchableContext batchableContext)
   { 
       query='select id,Eligibility__c,Eligibility__r.Scheme__c from  Eligible_Employees__c where Eligibility__r.Scheme__c=null';
       return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext batchableContext, List<Eligible_Employees__c> scope)  
   {
      if(scope != null && scope.size() >0){  
           Database.delete(scope);
           scope.clear();
       }
   }
   global void finish(Database.BatchableContext batchableContext){
   
   }
}