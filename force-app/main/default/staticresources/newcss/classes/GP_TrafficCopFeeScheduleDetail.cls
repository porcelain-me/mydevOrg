/******************************************************************************************
* Global Parking Traffic Fee Schedule Detail
*
* This will remove the need for record selection
*
* ChangeLog:
*
*  8/4/16 - Created by Abhijeet Tripathy
*   
*   
*******************************************************************************************/
public with sharing class GP_TrafficCopFeeScheduleDetail{

public Parking_Lot_Fee_Schedule_Details__c p {get;set;}
String retURL;
 

/****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
   public GP_TrafficCopFeeScheduleDetail(ApexPages.StandardController controller) {
        
        system.debug('in traffic cop');
        
        p = (Parking_Lot_Fee_Schedule_Details__c) controller.getRecord();  
    
   }
   
   public pageReference route(){
    
        system.debug('route');
        
        string fee=  ApexPages.currentPage().getParameters().get('fee');
        
    
        Parking_Lot_Fee_Schedule__c l = [select name, recordTypeId from Parking_Lot_Fee_Schedule__c where id = :fee];
        
        RecordType r = [select developerName from RecordType where id = :l.recordTypeId];
        
        RecordType r2 = [select id from RecordType where sobjectType = 'Parking_Lot_Fee_Schedule_Details__c' and developername = :r.developername];
       ///https://morganstanleyhr----dev-cs16-my-salesforce-com.ccg-dev.ms.com/a36/e?CF00Nf00000014Cf2=Monthly&CF00Nf00000014Cf2_lkid=a37f0000001lvPH&retURL=%2Fa37f0000001lvPH&RecordType=012f00000008x17&ent=01If00000005EbQ 
         PageReference p = new PageReference('/' + System.Label.GP_Fee_Schedule_Detail_Prefix + '/e?RecordType=' + r2.id + '&' + System.Label.GP_Fee_Schedule_Detail_Field + '=' + l.name + '&retURL=/' + fee);
       
         p.setRedirect(true);
         return p; 
        
     }   
        
   
}