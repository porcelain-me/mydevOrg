global class GP_AssignmentExpiration implements Database.Batchable<SObject>, System.Schedulable{
	
	String queryStr = 'Select Id from Parking_Lot_Space_Assignment__c';
	
	global Database.QueryLocator start(Database.BatchableContext c) {
		
    	
    	return Database.getQueryLocator(queryStr); 
    }
    
    global void execute(Database.BatchableContext c, List<Parking_Lot_Space_Assignment__c> aList){
    	/* go thru all the assignments and execute an udpate; the trigger figures out if the space status should */
    	/* change based on end date*/
    	
    	List<Parking_Lot_Space_Assignment__c> uList = new List<Parking_Lot_Space_Assignment__c>();
    	
    	for(Parking_Lot_Space_Assignment__c a:aList)
    		uList.add(a);
    	
    	
    	update uList;
    }
    
    global void finish(Database.BatchableContext c){
    	
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new GP_AssignmentExpiration(), 1000);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    }
}