@isTest(SeeAllData=true)
public class GP_EmailUtilityTest{

     
/*
    static TestMethod void myTest (){
        List<Parking_Lot_Request__c> prequest1 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Parking Space' AND status__c = 'New' limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap1 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Parking Space' AND status__c = 'New' limit 1]);
        
        List<Parking_Lot_Request__c> prequest2 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Parking Space' AND status__c = 'Cancelled' limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap2 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Parking Space' AND status__c = 'Cancelled' limit 1]);

        List<Parking_Lot_Request__c> prequest3 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Cancellation' AND status__c = 'New' AND expectant_mother__c = false limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap3 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Cancellation' AND status__c = 'New' AND  expectant_mother__c = false limit 1]);

        
        List<Parking_Lot_Request__c> prequest4 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Replacement Pass' AND status__c = 'New' AND expectant_mother__c = false limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap4 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Replacement Pass' AND status__c = 'New' AND  expectant_mother__c = false limit 1]);

        List<Parking_Lot_Request__c> prequest5 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Overnight Parking'  AND status__c = 'New' AND expectant_mother__c = false limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap5 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Overnight Parking' AND status__c = 'New' AND  expectant_mother__c = false limit 1]);
        
        
        List<Parking_Lot_Request__c> prequest6 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Parking Space' AND status__c = 'Assigned' limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap6 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Parking Space' AND status__c = 'Assigned' limit 1]);
        
        List<Parking_Lot_Request__c> prequest7 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Cancellation' AND status__c = 'Complete' limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap7 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Cancellation' AND status__c = 'Complete' limit 1]);

        List<Parking_Lot_Request__c> prequest8 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Cancellation' AND status__c = 'Rejected' AND expectant_mother__c = false limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap8 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Cancellation' AND status__c = 'Rejected' AND  expectant_mother__c = false limit 1]);

        
        List<Parking_Lot_Request__c> prequest9 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Replacement Pass' AND status__c = 'Assigned' AND expectant_mother__c = false limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap9 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Replacement Pass' AND status__c = 'Assigned' AND  expectant_mother__c = false limit 1]);

        List<Parking_Lot_Request__c> prequest10 = new List<Parking_Lot_Request__c>([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Overnight Parking'  AND status__c = 'Confirmed' AND expectant_mother__c = false limit 1]);
        Map<ID,Parking_Lot_Request__c > prequestmap10 = new Map<ID,Parking_Lot_Request__c > ([SELECT id,name ,expectant_mother__c,Requestee__c,Requestee__r.Email__c,type__c,status__c  from Parking_Lot_Request__c where type__c = 'Overnight Parking' AND status__c = 'Confirmed' AND  expectant_mother__c = false limit 1]);

        
        Test.startTest();    
        GP_EmailUtility.SendMailforInsert(prequest1 , prequestmap1 );
        GP_EmailUtility.SendMailforInsert(prequest2 , prequestmap2 );
        GP_EmailUtility.SendMailforInsert(prequest3 , prequestmap3);
        GP_EmailUtility.SendMailforInsert(prequest4 , prequestmap4);
        GP_EmailUtility.SendMailforInsert(prequest5 , prequestmap5);
        
        GP_EmailUtility.SendMailforUpdate(prequest6 , prequestmap6 );
        GP_EmailUtility.SendMailforUpdate(prequest7 , prequestmap7 );
        GP_EmailUtility.SendMailforUpdate(prequest8 , prequestmap8);
        GP_EmailUtility.SendMailforUpdate(prequest9 , prequestmap9);
        GP_EmailUtility.SendMailforUpdate(prequest10 , prequestmap10);
        
        
        
        GP_EmailUtility.mailforvehicleaddition();
        GP_EmailUtility.mailforparkingcharges();
        GP_EmailUtility.mailforparkingDispute();
        GP_EmailUtility.mailforparkingDisputeprocessed();
        GP_EmailUtility.SendMailforDelegateRequest();
        GP_EmailUtility.SendMailforDelegateApproval();
        Test.stopTest();
        }*/
        
     static TestMethod void myTest1(){
         
         List<Parking_Lot_Request_Vehicles__c> requestVehicleTokyo =  [Select ID,name,Employee_Vehicle__c,Parking_Lot_Request__c  From Parking_Lot_Request_Vehicles__c where  Parking_Lot_Request__r.Parking_Lot_Region__r.Name = 'Tokyo' limit 1];
        List<Parking_Lot_Request_Vehicles__c> requestVehicleLondon =  [Select ID,name,Employee_Vehicle__c,Parking_Lot_Request__c   From Parking_Lot_Request_Vehicles__c where  Parking_Lot_Request__r.Parking_Lot_Region__r.Name = 'London' limit 1]; 
        
        SET<ID> tokyovehicleid  = new SET<ID>();
        SET<ID> londonvehicleid = new SET<ID>();
        
        System.debug('********requestVehicleTokyo ********'+requestVehicleTokyo);
        System.debug('********requestVehicleLondon ********'+requestVehicleLondon);
        for(Parking_Lot_Request_Vehicles__c obj : requestVehicleTokyo ){
            System.debug('********obj.Employee_Vehicle__c********'+obj.Employee_Vehicle__c);
            tokyovehicleid.add(obj.Employee_Vehicle__c);
        }
        
        for(Parking_Lot_Request_Vehicles__c obj : requestVehicleLondon ){
            londonvehicleid.add(obj.Employee_Vehicle__c);
        }
        
        List<Employee_Vehicle__c> vehicleListTokyo = [Select id, name , registration_number__c from Employee_Vehicle__c where id in:tokyovehicleid];
        List<Employee_Vehicle__c> vehicleListLondon = [Select id, name , registration_number__c from Employee_Vehicle__c where id in:londonvehicleid];
        
        Map<ID,Employee_Vehicle__c> triggernewmaptokyo = new Map<ID,Employee_Vehicle__c>(); 
        Map<ID,Employee_Vehicle__c> triggeroldmaptokyo = new Map<ID,Employee_Vehicle__c>();
        
        Map<ID,Employee_Vehicle__c> triggernewmapLondon = new Map<ID,Employee_Vehicle__c>(); 
        Map<ID,Employee_Vehicle__c> triggeroldmapLondon = new Map<ID,Employee_Vehicle__c>();
        
        for(Employee_Vehicle__c obj :vehicleListTokyo ) {
            triggernewmaptokyo.put(obj.id,obj);    
        }
        
        for(ID key :triggernewmaptokyo.keyset()){
            System.debug('*********************Value of Registration Before Update*****'+triggernewmaptokyo.get(key).registration_number__c);
        }
        
        for(Employee_Vehicle__c obj :vehicleListTokyo ){
            triggeroldmaptokyo.put(obj.id,obj);
        }
        
        for(ID key :triggeroldmaptokyo.keyset()){
            System.debug('*********************Value of Registration Before Update Old Map*****'+triggeroldmaptokyo.get(key).registration_number__c);
        }
        
        for(ID key :triggernewmaptokyo.keyset()){
            triggernewmaptokyo.get(key).registration_number__c = 'OR 02 BY 2625';
        }
        
        for(ID key :triggernewmaptokyo.keyset()){
            System.debug('*********************Value of Registration After Update*****'+triggernewmaptokyo.get(key).registration_number__c);
        }
        
        
        for(Employee_Vehicle__c obj :vehicleListLondon ) {
            triggernewmapLondon.put(obj.id,obj);    
        }
        
        for(Employee_Vehicle__c obj :vehicleListLondon ){
            triggeroldmapLondon.put(obj.id,obj);
        }
        
        for(ID key :triggernewmapLondon.keyset()){
            triggernewmapLondon.get(key).registration_number__c = 'OR 02 BY 2625';
        } 
        
         
         Test.startTest();
         
         for(ID key :triggernewmaptokyo.keyset()){
            System.debug('*********************Value of Registration New Map*****'+triggernewmaptokyo.get(key).registration_number__c);
         }
         
         for(ID key :triggeroldmaptokyo.keyset()){
            System.debug('*********************Value of Registration Old Map*****'+triggeroldmaptokyo.get(key).registration_number__c);
         }         
             GP_EmailUtility.mailforvehicle(vehicleListTokyo ,triggernewmaptokyo , triggeroldmaptokyo );
             //GP_EmailUtility.mailforvehicle(vehicleListLondon , triggernewmapLondon , triggeroldmapLondon);
         Test.stopTest();   
     }  
}