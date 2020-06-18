global class DG_UpdateEmployeeBatch implements Database.Batchable<SObject>, System.Schedulable{  
	
	String queryStr = 'Select Id, Emp_Id__c from Employee__c where User__c = null and Emp_Id__c <> null' ;
	
	global Database.QueryLocator start(Database.BatchableContext c) {
		
    	
    	return Database.getQueryLocator(queryStr); 
    }
    
    global void execute(Database.BatchableContext c, List<Employee__c> empList){
    	map<String,Employee__c> mapEmpIdEmp = new map<String,Employee__c>();
    	list<Employee__c> listEmpToUpdate = new list<Employee__c>();
    	for(Employee__c emp : empList){
    		mapEmpIdEmp.put(emp.Emp_Id__c, emp);
    	}
    	Employee__c emp;
    	for(User usr : [Select Id, Emp_Id__c from User where Emp_Id__c IN : mapEmpIdEmp.keySet()]){
    		emp = mapEmpIdEmp.get(usr.Emp_Id__c);
    		emp.User__c = usr.Id;
    		listEmpToUpdate.add(emp);
    	}
    	
    	if(!listEmpToUpdate.isEmpty()){
    		Database.saveResult[] listSR = database.update(listEmpToUpdate);
    		for(database.saveResult sr : listSR){
    			system.debug('Error while updating emloyees-----' + sr.getErrors());
    		} 
    	}
    }
    
    global void finish(Database.BatchableContext c){
    	
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new DG_UpdateEmployeeBatch(), 200);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    }
}