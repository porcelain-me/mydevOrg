/******************************************************************************************
* Global Parking Traffic Cop
*
* This will route the stadard edit/view buttons to the custom request processing page
*
* ChangeLog:
*
*   9/18/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public without sharing class GP_RequestController { 
    
    public Parking_Lot_Request__c r {get;set;} 
    
    
    /****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
    public GP_RequestController(ApexPages.StandardController controller) {
    	
    	r = (Parking_Lot_Request__c) controller.getRecord();
    	
    	r = [select parking_lot_region__c from Parking_Lot_Request__c where id =  :r.id];
    	    
    }
    /******************************************************************************************
    * ROUTE   
    *
    *******************************************************************************************/
    public PageReference route(){
       
        PageReference p = new PageReference('/apex/gp_assignment?rid=' + r.parking_lot_region__c + '&id=' + r.id);
        p.setRedirect(true);
        return p;  
		       
    }	
}