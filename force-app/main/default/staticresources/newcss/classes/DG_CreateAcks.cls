public with sharing class DG_CreateAcks {
 	/****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
    List__c l {get;set;}
    
    public DG_CreateAcks(ApexPages.StandardController controller) {    	
    	
    	
    	l = (List__c)controller.getRecord();
  		
    }
    
    public PageReference runBatch(){
    	
    	
    	id batchId = Database.executeBatch(new DG_BatchCreateAcks(l.id), 50);  
     	
    	PageReference p = new PageReference('/' + l.id);
        p.setRedirect(true);
        return p;  
    }
}