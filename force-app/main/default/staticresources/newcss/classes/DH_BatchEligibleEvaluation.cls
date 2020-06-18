global class DH_BatchEligibleEvaluation implements Database.Batchable<SObject>, System.Schedulable{
	
	String queryStr = 'Select Id from Employee__c';
	
	global Database.QueryLocator start(Database.BatchableContext c) {
		
    	
    	return Database.getQueryLocator(queryStr); 
    }
    
    global void execute(Database.BatchableContext c, List<Employee__c> empList){
    	
    	List<Employee__c> employeeList = new List<Employee__c>();
    	
    	for(Employee__c e:empList)
    		employeeList.add(e);
    	
    	
    	update employeeList;
    }
    
    global void finish(Database.BatchableContext c){
    	
    }
    
    global void execute(SchedulableContext sc){
       if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new DH_BatchEligibleEvaluation(), 1000);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    }
}