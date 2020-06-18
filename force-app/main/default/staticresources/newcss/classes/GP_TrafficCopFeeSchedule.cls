/******************************************************************************************
* Global Parking Traffic Fee Schedule
*
* This will remove the need for record selection
*
* ChangeLog:
*
*  8/3/16 - Created by Abhijeet Tripathy
*   
*   
*******************************************************************************************/
public with sharing class GP_TrafficCopFeeSchedule {

public Parking_Lot_Fee_Schedule__c p {get;set;}
String retURL;
 

/****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
   public GP_TrafficCopFeeSchedule (ApexPages.StandardController controller) {
        
        system.debug('in traffic cop');
        
        p = (Parking_Lot_Fee_Schedule__c) controller.getRecord();  
    
         
   }
   
   public pageReference route(){
    
        system.debug('route');
        
        string garage=  ApexPages.currentPage().getParameters().get('garage');   
        
        Parking_Lot__c l = [select name, recordTypeId from Parking_Lot__c where id = :garage];
        
        RecordType r = [select developerName from RecordType where id = :l.recordTypeId];
        
        RecordType r2 = [select id from RecordType where sobjectType = 'Parking_Lot_Fee_Schedule__c' and developername = :r.developername];
        
        
        //SObjectType objToken = Schema.getGlobalDescribe().get('Parking_Lot_Fee_Schedule__c');
        
        //PageReference p = new PageReference('/a37/e?RecordType=' + r2.id + '&CF00Nf00000014Cei=' + l.name+ '&CF00Nf000000150dW=' + l.name + '&retURL=/' + l.name);
        PageReference p = new PageReference('/' + System.Label.GP_Fee_Schedule_Prefix + '/e?RecordType=' + r2.id + '&' + System.Label.GP_Fee_Schedule_Field + '=' + l.name + '&retURL=/' + garage);
          
        p.setRedirect(true);
         return p; 
        
     }   
        
   
}