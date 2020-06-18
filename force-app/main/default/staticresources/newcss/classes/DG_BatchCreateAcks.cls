/**************************************************************************************
* Doc Acknowledgement Batch Creation
*
* Change Log:
*
*	MRM 1/27/16 - Created class
*
****************************************************************************************/
global class DG_BatchCreateAcks implements Database.Batchable<SObject>, System.Schedulable{
	
	
	String queryStr = 'Select employee__c from List_Employee__c ';
	String ListID;
	
	global DG_BatchCreateAcks(String listID) { 
        
        this.listID = listID; 
        
        List__c l = [select id from List__c where id = :listID];
    	
    	l.document_acknowledgement_status__c = 'Processing';
    	
    	
    	List<List_Employee_Template__c> dList = [select id from List_Employee_Template__c 
    											where list_employee__r.list__c = :listId
    											and Document_Accepted_On__c = null and Document_Declined_On__c = null];
    											
    											
    	update l;
    	
    	if (!dList.isEmpty())
    		delete dList; 
    		
    }
	
	global Database.QueryLocator start(Database.BatchableContext c) { 
		
    	queryStr += ' where List__c = ' + '\'' + listID + '\'';
    	return Database.getQueryLocator(queryStr); 
   
    }
    
    
    /**************************************************************************************************
    *
    *
    * EXECUTE
    *
    *
    ****************************************************************************************************/
    
    global void execute(Database.BatchableContext c, List<List_Employee__c> eList){
    	
    	
    	
    	List<List_Template__c> lTemplate = [select id, template__c from List_Template__c where list__c = :listID];
    	
    	set<String> templateIdSet = new Set<String>();
    	
    	List<List_Employee_Template__c> iList = new list<List_Employee_Template__c>();
    		
    	for (List_Employee__c e:eList){
    	
    		for(List_Template__c t: lTemplate){
    			List_Employee_Template__c let = new List_Employee_Template__c (list_employee__c = e.id, template__c = t.template__c);
    			iList.add(let);
    		}
    		
    		e.is_sent_for_signature__c = true;
    		e.status__c = 'Sent';
    	}
    	
		if (!iList.isEmpty())
			insert iList;    	 
    	
    	
    	update eList;
    }
    
    global void finish(Database.BatchableContext c){
	    	
		List__c l = [select id from List__c where id = :listID];
    	
    	l.document_acknowledgement_status__c = 'Complete';
    	
    	update l;
    	
    }
    
    global void execute(SchedulableContext sc){
       
    }
}