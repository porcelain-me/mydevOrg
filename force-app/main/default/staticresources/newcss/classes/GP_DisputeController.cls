/******************************************************************************************
* Global Parking Dispute Controller   
*
* Disputes are by processed by region.  This controller is used to process outstanding disputes
*
* ChangeLog:
*
*   9/22/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public with sharing class GP_DisputeController { 
    
    public Parking_Lot_Region__c reg {get;set;} 
    public List<Parking_Lot_Space_Assignment_Time_Used__c> disputeList {get;set;}
	String regId;
    /****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
    public GP_DisputeController(ApexPages.StandardController controller) {
    	
    	reg = (Parking_Lot_Region__c) controller.getRecord();
    	reg = [select name from Parking_Lot_Region__c where id = :reg.id];
    	regId = string.valueOf(reg.id).substring(0,15);
    	
    	
    	disputeList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
    	
    	loadDisputeList();
    	
    	  
  		
    }
    
    /******************************************************************************************
    * LOAD DISPUTE   
    *
    *******************************************************************************************/
    
    public void loadDisputeList(){
        
         
       		disputeList = [Select p.SystemModstamp
    				  , p.Parking_Lot_Space_Assignment__c
    				  , p.Parking_Lot_RegionId__c 
    				  , p.Out__c
    				  , p.Parking_Lot_Space_Assignment__r.Employee__c
    				  , p.Name
    				  , p.Minutes__c
    				  , p.LastModifiedDate
    				  , p.LastModifiedById
    				  , p.IsDeleted
    				  , p.In__c
    				  , p.resolution_in__c
    				  , p.resolution_out__c
    				  , p.resolution_duration__c
    				  , p.Id
    				  , p.Hours__c
    				  , p.Duration_Text__c
    				  , p.Duration_Numeric__c
    				  , p.Disputed__c
    				  , p.Dispute_Comments__c
    				  , p.Days__c
    				  , p.CurrencyIsoCode
    				  , p.CreatedDate
    				  , p.CreatedById
    				 
    				
    				 
    				  , p.Billed__c 
    				  , p.resolved__c
    				  , p.resolved_comments__c
    				  
  					  From Parking_Lot_Space_Assignment_Time_Used__c p
  					  where parking_Lot_regionId__c = :regId
  					  and p.disputed__c = true
  					  and p.resolved__c = false
  					  order by createddate];
  				
  			for (Parking_Lot_Space_Assignment_Time_Used__c t:disputeList){
  				if (t.resolution_in__c == null)
  					t.resolution_in__c = t.in__c;
  				if (t.resolution_out__c == null)
  					t.resolution_out__c = t.out__c;
  			}	
       
    }   
    
	/******************************************************************************************
    * EXIT   
    *
    *******************************************************************************************/
    
    public PageReference exit(){
        
         
       	PageReference p;
        p = new PageReference('/apex/gp_submitinvoicebatch?id=' + reg.id);
        p.setRedirect(true);
        return p;  
       
    }   
    /******************************************************************************************
    * SAVE   
    *
    *******************************************************************************************/
    
    public PageReference save2(){
        
        if (!disputeList.isEmpty())
        	update disputeList;
        
        
        loadDisputeLIst();
        
       	return null;
       
    }
}