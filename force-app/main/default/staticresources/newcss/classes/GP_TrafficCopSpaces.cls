/******************************************************************************************
* Global Parking Traffic Spaces
*
* This will remove the need for record selection
*
* ChangeLog:
*
*  8/4/16 - Created by Abhijeet Tripathy
*   
*   
*******************************************************************************************/
public with sharing class GP_TrafficCopSpaces{

public Parking_Lot_Space__c p {get;set;}
String retURL;
 

/****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
   public GP_TrafficCopSpaces(ApexPages.StandardController controller) {
        
        system.debug('in traffic cop');
        
        p = (Parking_Lot_Space__c) controller.getRecord();  
    
        
        
    
         
   }
   
   public pageReference route(){
    
        string garage=  ApexPages.currentPage().getParameters().get('garage');
    
        Parking_Lot__c l = [select name, recordTypeId from Parking_Lot__c where id = :garage];
        
        RecordType r = [select developerName from RecordType where id = :l.recordTypeId];
        
        RecordType r2 = [select id from RecordType where sobjectType = 'Parking_Lot_Space__c' and developername = :r.developername];
        
        PageReference p = new PageReference('/' + System.Label.GP_Parking_Space_Prefix + '/e?RecordType=' + r2.id + '&' + System.Label.GP_Parking_Location_Field + '=' + l.name + '&retURL=/' + garage);
        //PageReference p = new PageReference('/a33/e?RecordType=' + r2.id + '&CF00Nf000000150dW_lkid=' + l.id + '&CF00Nf000000150dW=' + l.name + '&retURL=/' + garage);
        p.setRedirect(true);
         return p;  
        
     }   
        
   
}