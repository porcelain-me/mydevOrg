global class WV_ArchiveCustomdata implements Database.Batchable<sObject>{
   public String query;
   
   global Database.QueryLocator start(Database.batchableContext batchableContext)
   { 
       query='select id,File_Upload__c,File_Upload__r.Scheme__c from  Wav_Custom_data__c where File_Upload__r.Scheme__c=null';
       return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext batchableContext, List<Wav_Custom_data__c> scope)  
   {
      if(scope != null && scope.size() >0){  
           system.debug('********'+scope.size());
           Database.delete(scope);
           scope.clear();
       }
   }
   global void finish(Database.BatchableContext batchableContext){
   
   }
}