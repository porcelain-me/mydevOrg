/******************************************************************************************
* Global Parking Open Enrollment Controller
*
* This will submit the open enrollment close process
*
* ChangeLog:
*
*   8/11/16- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public without sharing class GP_OpenEnrollement { 
    
    public Parking_Lot_Region__c r {get;set;} 
    public List<Parking_Lot_Request__c> rList {get;set;}
    public List<Parking_Enrollment_Batch__c> bList {get;set;}
       
    
    /****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
    public GP_OpenEnrollement(ApexPages.StandardController controller) {
    	
       
    	r = (Parking_Lot_Region__c) controller.getRecord();  
    	
    	r = [select name
    			,enrollment_period_start_Date__c
    			,enrollment_period_end_date__c
    		 from Parking_Lot_Region__c where id = :r.id];
    	
    	rList= new List<Parking_Lot_Request__c>([select 
    				 requestee__c
    				,Requestee_Global_Parking_Level__c	
    				,Parking_Lot__c
    				,Vehicle_Type__c
    				,Assigned_Method_of_Payment__c
    				,Enrollment_Period_Payment_Method__c
    				from Parking_Lot_Request__c
    				where parking_lot_Region__c = :r.id
    				and enrollment_period_payment_method__c <> null
    				and type__c = 'Parking Space'
    				and Status__c = 'Assigned'
    				order by parking_lot__c, requestee__c
    				]);
    				
    	bList = new List<Parking_Enrollment_Batch__c>(
    			[select 
    			  name
    			 ,status__c
    			 ,total_processed__c
    			 ,message__c
    			 ,createddate
    			 ,createdbyid
    			 from 
    			 Parking_Enrollment_Batch__c
    			 where parking_location__c = :r.id
    			
    			 order by createddate desc
    			 limit 5
    			 ]);			
    					
    				
    }
    
    /******************************************************************************************
    * SUBMIT   
    *
    *******************************************************************************************/
    public PageReference submit(){
    	
    	update r;
    	
    	List<Parking_Enrollment_Batch__c> bList = [select status__c from Parking_Enrollment_Batch__c where parking_location__c = :r.id and  status__c = 'Running'];
    	if (!bList.isEmpty()){
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There is a pending job that has not completed, can not request a new run at this time!');
            ApexPages.addMessage(myMsg);
            return null;
    	}
    	
    	if (r.enrollment_period_end_date__c >= date.today()){
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Enrollments cannot be processed until after the enrollment period end date!');
            ApexPages.addMessage(myMsg);
            return null;
    	}
    	
    	if (rList.isEmpty()){
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There are no enrollments to process!');
            ApexPages.addMessage(myMsg);
            return null;
    	}
    	
    	Parking_Enrollment_Batch__c b = new Parking_Enrollment_Batch__c (Parking_Location__c = r.id, total_processed__c = 0, status__c = 'Submitted');
    	insert b;
    	
        id batchId = Database.executeBatch(new GP_AnnualEnrollment(r.id,b.id), 1000);  
       
       
        PageReference p = new PageReference('/apex/gp_OpenEnrollment?id=' + r.id);
        p.setRedirect(true);
        return p;  
		       
    }
    
    /******************************************************************************************
    * SAVE   
    *
    *******************************************************************************************/
    public PageReference save(){
    	
    	
    	if (r.enrollment_period_start_date__c >= r.enrollment_period_end_Date__c){
    		r.enrollment_period_start_date__c.addError('Start date must be less than the end date!');
    		return null;
    	}
    	
    	
        update r;
        
        PageReference p = new PageReference('/apex/gp_OpenEnrollment?id=' + r.id);
        p.setRedirect(true);
        return p;  
		       
    }
   
   	/******************************************************************************************
    * EXIT   
    *
    *******************************************************************************************/
    public PageReference exit(){
   
        PageReference p = new PageReference('/' + r.id);
        p.setRedirect(true);
        return p;  
       
    }
    
	
}