global class TouchAllGPSEmployee implements Database.Batchable<SObject>,Schedulable {


// Batch Apex job to "touch" all Employee records.  This is done primarily for the purpose of getting
// triggers to fire, 
//
// To run this job, enter the following into a System Log anonymous Apex window:
//
//   Database.executeBatch(new TouchAllGPSEmployee(), 200);
//

//    


 global void execute(SchedulableContext sc) {
 	
 	database.executeBatch(new TouchAllGPSEmployee(), 200);
 	
 	
 }
 
  global Database.QueryLocator start(Database.BatchableContext c) {
    return Database.getQueryLocator('SELECT Id FROM GPSEmployee__c');
  }
  
  global void execute(Database.BatchableContext c, List<Sobject> objects) {
  	//Organization O=[Select isSandbox from organization limit 1 ];
    //if (UserInfo.getOrganizationId() != Constants.ProductionOrgId) {
    //if (o.isSandbox) {    
      List<GPSEmployee__c> emp = new List<GPSEmployee__c>();
      for (SObject s : objects) {
        emp.add((GPSEmployee__c)s);
      }
      update emp;
    //}
  }
  
  global void finish(Database.BatchableContext c) {
  }
  
}