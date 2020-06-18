/******************************************************************************************
* Global Parking Traffic Cop Garage
*
* This will remove the need for record selection
*
* ChangeLog:
*
*  8/1//16 - Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public with sharing class GP_TrafficCopGarage {

public Parking_Lot__c p {get;set;}
String retURL;
 

/****************************
*STANDARD CONTROLLER 
*
****************************/
    public GP_TrafficCopGarage (ApexPages.StandardController controller) {
    	
    	
    	p = (Parking_Lot__c) controller.getRecord();  
    	 
   }
   
   public pageReference route(){
   	
   		system.debug('route');
   		
   		string region =  ApexPages.currentPage().getParameters().get('region');
   		
   		Parking_Lot_Region__c l = [select name, recordTypeId from Parking_Lot_Region__c  where id = :region];
   		
   		RecordType r = [select developerName from RecordType where id = :l.recordTypeId];
   		
   		RecordType r2 = [select id from RecordType where sobjectType = 'Parking_Lot__c' and developername = :r.developername];
   		
   		// PageReference p = new PageReference('/' + System.Label.GP_Parking_Space_Prefix + '/e?RecordType=' + r2.id + '&' + System.Label.GP_Parking_Location_Field + '=' + l.name + '&retURL=/' + garage);
       
   		//a33/e?RecordType=012f00000008wyD&=CF00Nf000000150dW_lkid=a3Cf00000001heu&CF00Nf000000150dW=Budapest
   		PageReference p = new PageReference('/' + System.label.GP_Parking_Garage_Prefix + '/e?RecordType=' + r2.id + '&CF00Nf000000150dW_lkid=' + l.id + '&' + System.Label.GP_Location_Field + '=' + l.name + '&retURL=/' + region);
       	p.setRedirect(true);
       	return p; 
   		
   		
   		
   }
}