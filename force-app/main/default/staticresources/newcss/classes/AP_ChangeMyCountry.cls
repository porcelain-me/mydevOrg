public without sharing class AP_ChangeMyCountry { 
    
    public Employee__c e {get;set;}
    /****************************
    *CUSTOM CONTROLLER
    *
    ****************************/
    public AP_ChangeMyCountry() {
    	
    	User u  = [select emp_id__c from User where id=:UserInfo.getUserId()];
    	
    	e = [select id, job_country_job__c from Employee__c where emp_id__c = :u.emp_id__c];
    	
    }
    
   	/******************************************************************************************
    * SAVE  
    *
    *******************************************************************************************/
    
    public PageReference save(){
		
        update e;
      
       	PageReference p = new PageReference('/apex/ap_changeMyCountry?id=' + e.id);
       	p.setRedirect(true);
       	return p; 
      
    }
   
   
   
    
	
}