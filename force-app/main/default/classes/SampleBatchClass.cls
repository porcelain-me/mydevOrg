global class SampleBatchClass implements Database.Batchable<sobject> {
     
     global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator('Select Id, Name From Account ');
     }
     global void execute(Database.BatchableContext BC, List<Account>  scope){
          for(Account a: scope){
               a.Name += ' Delhi'; 
          }
         system.debug('Scope is updated'+scope); 
         update scope;
     }
     global void finish(Database.BatchableContext BC){}
}