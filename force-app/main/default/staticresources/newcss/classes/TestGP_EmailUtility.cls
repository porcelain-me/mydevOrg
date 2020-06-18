@isTest
public class TestGP_EmailUtility{
    
   
    
    static testmethod void myTest1(){
        TestGPData.createData(); 
        
        Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'London'];
        
        Employee__c e = new Employee__c(first_name__c = 'Mark'
        ,last_Name__c = 'Moser'
        ,name = 'Mark Moser'
        ,emp_id__c = '59JRB'
        ,email__c = 'mark.moser@morganstanley.com'
        ,Level_Dsc_Job__c = 'Contingent');
                    
        insert e;    
          
        List<Parking_Lot_Request__c >  parkingList = new List<Parking_Lot_Request__c >();  
            
            Parking_Lot_Request__c r1 = new Parking_Lot_Request__c();
            r1.requestee__c = e.id;
            r1.type__c = 'Parking Space';
            r1.status__c = 'New';
            r1.vehicle_type__c = 'Car';
            r1.rate_type__c = 'Monthly';
            r1.parking_lot_Region__c = reg.id;
            r1.method_of_payment__c = 'Monthly';
            r1.start_date__c = date.today().addMonths(1);
            r1.no_charge__c = false;
            r1.expectant_mother__c = false;
            parkingList.add(r1);
             
            
            Parking_Lot_Request__c r2 = new Parking_Lot_Request__c();
            r2.requestee__c = e.id;
            r2.type__c = 'Parking Space';
            r2.status__c = 'Cancelled';
            r2.vehicle_type__c = 'Car';
            r2.rate_type__c = 'Monthly';
            r2.parking_lot_Region__c = reg.id;
            r2.method_of_payment__c = 'Monthly';
            r2.start_date__c = date.today().addMonths(1);
            r2.no_charge__c = false;
            r2.expectant_mother__c = false;
            parkingList.add(r2);
            
            
            Parking_Lot_Request__c r3 = new Parking_Lot_Request__c();
            r3.requestee__c = e.id;
            r3.type__c = 'Cancellation';
            r3.status__c = 'New' ;
            r3.vehicle_type__c = 'Car';
            r3.rate_type__c = 'Monthly';
            r3.parking_lot_Region__c = reg.id;
            r3.method_of_payment__c = 'Monthly';
            r3.start_date__c = date.today().addMonths(1);
            r3.no_charge__c = false;
            r3.expectant_mother__c = false;
            parkingList.add(r3);
            
            Parking_Lot_Request__c r4 = new Parking_Lot_Request__c();
            r4.requestee__c = e.id;
            r4.type__c = 'Parking Space';
            r4.status__c = 'Assigned';
            r4.vehicle_type__c = 'Car';
            r4.rate_type__c = 'Monthly';
            r4.parking_lot_Region__c = reg.id;
            r4.method_of_payment__c = 'Monthly';
            r4.start_date__c = date.today().addMonths(1);
            r4.no_charge__c = false;
            r4.expectant_mother__c = false;
            insert r4;
            
            Parking_Lot_Request__c r5 = new Parking_Lot_Request__c();
            r5.Related_Parking_Lot_Request__c = r4.id;
            r5.requestee__c = e.id;
            r5.type__c = 'Replacement Pass';
            r5.status__c = 'New' ;
            r5.vehicle_type__c = 'Car';
            r5.rate_type__c = 'Monthly';
            r5.parking_lot_Region__c = reg.id;
            r5.method_of_payment__c = 'Monthly';
            r5.start_date__c = date.today().addMonths(1);
            r5.no_charge__c = false;
            r5.expectant_mother__c = false;
            parkingList.add(r5);
            
            Parking_Lot_Request__c r6 = new Parking_Lot_Request__c();
            r6.Related_Parking_Lot_Request__c = r4.id;
            r6.requestee__c = e.id;
            r6.type__c = 'Weekend Parking';
            r6.status__c = 'New' ;
            r6.vehicle_type__c = 'Car';
            r6.rate_type__c = 'Monthly';
            r6.parking_lot_Region__c = reg.id;
            r6.method_of_payment__c = 'Monthly';
            r6.start_date__c = date.today().addMonths(1);
            r6.no_charge__c = false;
            r6.expectant_mother__c = false;
            parkingList.add(r6);
            
            
            
            
        insert parkingList;
        Map<ID, Parking_Lot_Request__c > parkingmap = new Map<ID, Parking_Lot_Request__c >();
        for(Parking_Lot_Request__c  p :parkingList){
            parkingmap.put(p.id,p);
        }
        Test.startTest();
            GP_EmailUtility.SendMailforInsert(parkingList,parkingmap); 
              
        Test.stopTest(); 
    }
    
    
    static testmethod void myTest2(){
        TestGPData.createData(); 
        Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'London'];
        Employee__c e = new Employee__c(first_name__c = 'Mark'
        ,last_Name__c = 'Moser'
        ,name = 'Mark Moser'
        ,emp_id__c = '59JRB'
        ,email__c = 'mark.moser@morganstanley.com'
        ,Level_Dsc_Job__c = 'Contingent');
                    
        insert e;
        List<Parking_Lot_Request__c >  parkingList = new List<Parking_Lot_Request__c >();  
            
            Parking_Lot_Request__c r1 = new Parking_Lot_Request__c();
            r1.requestee__c = e.id;
            r1.type__c = 'Parking Space';
            r1.status__c = 'Assigned';
            r1.vehicle_type__c = 'Car';
            r1.rate_type__c = 'Monthly';
            r1.parking_lot_Region__c = reg.id;
            r1.method_of_payment__c = 'Monthly';
            r1.start_date__c = date.today().addMonths(1);
            r1.no_charge__c = false;
            r1.expectant_mother__c = false;
            parkingList.add(r1);
            
            Parking_Lot_Request__c r2 = new Parking_Lot_Request__c();
            r2.requestee__c = e.id;
            r2.type__c = 'Cancellation';
            r2.status__c = 'Complete';
            r2.vehicle_type__c = 'Car';
            r2.rate_type__c = 'Monthly';
            r2.parking_lot_Region__c = reg.id;
            r2.method_of_payment__c = 'Monthly';
            r2.start_date__c = date.today().addMonths(1);
            r2.no_charge__c = false;
            r2.expectant_mother__c = false;
            parkingList.add(r2);
            
            Parking_Lot_Request__c r3 = new Parking_Lot_Request__c();
            r3.requestee__c = e.id;
            r3.type__c = 'Cancellation';
            r3.status__c = 'Rejected' ;
            r3.vehicle_type__c = 'Car';
            r3.rate_type__c = 'Monthly';
            r3.parking_lot_Region__c = reg.id;
            r3.method_of_payment__c = 'Monthly';
            r3.start_date__c = date.today().addMonths(1);
            r3.no_charge__c = false;
            r3.expectant_mother__c = false;
            parkingList.add(r3);
            
            
            Parking_Lot_Request__c r4 = new Parking_Lot_Request__c();
            r4.requestee__c = e.id;
            r4.type__c = 'Parking Space';
            r4.status__c = 'Assigned';
            r4.vehicle_type__c = 'Car';
            r4.rate_type__c = 'Monthly';
            r4.parking_lot_Region__c = reg.id;
            r4.method_of_payment__c = 'Monthly';
            r4.start_date__c = date.today().addMonths(1);
            r4.no_charge__c = false;
            r4.expectant_mother__c = false;
            insert r4;
            
            Parking_Lot_Request__c r5 = new Parking_Lot_Request__c();
            r5.Related_Parking_Lot_Request__c = r4.id;
            r5.requestee__c = e.id;
            r5.type__c = 'Replacement Pass';
            r5.status__c = 'Assigned' ;
            r5.vehicle_type__c = 'Car';
            r5.rate_type__c = 'Monthly';
            r5.parking_lot_Region__c = reg.id;
            r5.method_of_payment__c = 'Monthly';
            r5.start_date__c = date.today().addMonths(1);
            r5.no_charge__c = false;
            r5.expectant_mother__c = false;
            parkingList.add(r5);
            
            Parking_Lot_Request__c r6 = new Parking_Lot_Request__c();
            r6.Related_Parking_Lot_Request__c = r4.id;
            r6.requestee__c = e.id;
            r6.type__c = 'Weekend Parking';
            r6.status__c = 'Confirmed' ;
            r6.vehicle_type__c = 'Car';
            r6.rate_type__c = 'Monthly';
            r6.parking_lot_Region__c = reg.id;
            r6.method_of_payment__c = 'Monthly';
            r6.start_date__c = date.today().addMonths(1);
            r6.no_charge__c = false;
            r6.expectant_mother__c = false;
            parkingList.add(r6);
           

         
        insert parkingList;
        Map<ID, Parking_Lot_Request__c > parkingmap = new Map<ID, Parking_Lot_Request__c >();
        for(Parking_Lot_Request__c  p :parkingList){
            parkingmap.put(p.id,p);
        }
        Test.startTest();
            GP_EmailUtility.SendMailforUpdate(parkingList,parkingmap,parkingmap);    
        Test.stopTest(); 
    }
    
    
    static testMethod void myTest3(){
    TestGPData.createData(); 
    Set<id> newvehicles = new Set<id>();
    Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'London'];
    Parking_Lot_Region__c reg1 = [select id from Parking_Lot_Region__c where name = 'Tokyo'];
        Employee__c e = new Employee__c(first_name__c = 'Mark'
                    ,last_Name__c = 'Moser'
                    ,name = 'Mark Moser'
                    ,emp_id__c = '59JRB'
                    ,email__c = 'mark.moser@morganstanley.com'
                    ,Level_Dsc_Job__c = 'Contingent'
                    );
        insert e;
        List<Employee_Vehicle__c> vehiclelist = new List<Employee_Vehicle__c>();
        Employee_Vehicle__c v = new Employee_Vehicle__c();
        v.color__c = 'Blue';
        v.employee__c = e.id;
        v.make_model__c = 'Ford Escort';
        v.state__c = 'PA';
        v.status__c  = 'Active';
        v.type__c = 'Car';
        v.registration_number__c = '2625';
        vehiclelist.add(v);
        
        Employee_Vehicle__c v1 = new Employee_Vehicle__c();
        v1.color__c = 'Blue';
        v1.employee__c = e.id;
        v1.make_model__c = 'Ford Endeavour';
        v1.state__c = 'PA';
        v1.status__c  = 'Active';
        v1.type__c = 'Car';
        v1.registration_number__c = '2929';
        vehiclelist.add(v1);
        
        
        
        
        
        
        insert vehiclelist;
        
        Parking_Lot_Request__c r = new Parking_Lot_Request__c();
        r.requestee__c = e.id;
        r.type__c = 'Parking Space';
        r.vehicle_type__c = 'Car';
        r.status__c = 'Assigned';
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = reg.id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today();
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        Parking_Lot_Request__c r1 = new Parking_Lot_Request__c();
        r1.requestee__c = e.id;
        r1.type__c = 'Parking Space';
        r1.vehicle_type__c = 'Car';
        r1.status__c = 'Assigned';
        r1.rate_type__c = 'Monthly';
        r1.parking_lot_Region__c = reg1.id;
        r1.method_of_payment__c = 'Monthly';
        r1.start_date__c = date.today();
        r1.no_charge__c = false;
        r1.expectant_mother__c = false;
        insert r1;
        
        List<Parking_Lot_Request_Vehicles__c> parkinglotrequestvehicle = new List<Parking_Lot_Request_Vehicles__c>();
        
            Parking_Lot_Request_Vehicles__c rv = new Parking_Lot_Request_Vehicles__c();
            rv.employee_vehicle__c = v.id;
            rv.parking_lot_Request__c = r.id;
            parkinglotrequestvehicle.add(rv);
            
            Parking_Lot_Request_Vehicles__c rv1 = new Parking_Lot_Request_Vehicles__c();
            rv1.employee_vehicle__c = v1.id;
            rv1.parking_lot_Request__c = r1.id;
            parkinglotrequestvehicle.add(rv1);
        
        insert parkinglotrequestvehicle;
        
        for(Employee_Vehicle__c ev :vehiclelist){
            newvehicles.add(ev.id);
        }
        
        Map<ID,Employee_Vehicle__c > triggernewmap = new Map<ID,Employee_Vehicle__c >();
        Map<ID,Employee_Vehicle__c > triggeroldmap =  new Map<ID,Employee_Vehicle__c >();
        
        
        for(Employee_Vehicle__c ev : vehiclelist){
            triggeroldmap.put(ev.id,ev);
            
        }
        
        for(Employee_Vehicle__c ev : vehiclelist){
            triggernewmap.put(ev.id,ev);
            triggernewmap.get(ev.id).registration_number__c = '3636';   
        }
        update triggernewmap.values();
        
        Test.startTest();
            GP_EmailUtility.mailforvehicle(vehiclelist,triggernewmap,triggeroldmap);
            GP_EmailUtility.mailforvehicleaddition(newvehicles);
            
        Test.stopTest();
    }

    static testMethod void myTest4(){
        TestGPData.createData(); 
        
        Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'London'];
        Employee__c e = new Employee__c(first_name__c = 'Mark'
                    ,last_Name__c = 'Moser'
                    ,name = 'Mark Moser'
                    ,emp_id__c = '59JRB'
                    ,email__c = 'mark.moser@morganstanley.com'
                   
                    ,Level_Dsc_Job__c = 'Contingent'
                    );
        insert e;
    
        Parking_Lot_Request__c r = new Parking_Lot_Request__c();
        r.requestee__c = e.id;
        r.type__c = 'Parking Space';
        r.vehicle_type__c = 'Car';
        r.status__c = 'Assigned';
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = reg.id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        Parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = reg.id, Send_Email_TO__c = 'CO - Contractor');
        insert ir;
        
        Parking_Lot_Assignment_Fees_Due__c invoice = new Parking_Lot_Assignment_Fees_Due__c(Parking_Invoice_Run__c = ir.id, amount_billed__c = 100.00, amount_paid__c = 1.00,Conductor_Sent__c = false, Status__c = 'Invoiced');
        
        List<Parking_Lot_Assignment_Fees_Due__c> feesduelist = new List<Parking_Lot_Assignment_Fees_Due__c>();
        feesduelist.add(invoice);
        
        insert feesduelist;
        System.debug('*********COnductor Sent For Invoice Fess Due List********: '+feesduelist);
        Map<ID,Parking_Lot_Assignment_Fees_Due__c> triggermap = new Map<ID,Parking_Lot_Assignment_Fees_Due__c>();
        Map<ID,Parking_Lot_Assignment_Fees_Due__c> triggermapold = new Map<ID,Parking_Lot_Assignment_Fees_Due__c>();
        for(Parking_Lot_Assignment_Fees_Due__c pld : feesduelist){
            triggermapold.put(pld.id,pld);
            
        }
        System.debug('*********Value Of COnductor Sent in Trigger Old Map '+triggermapold);  
        for(Parking_Lot_Assignment_Fees_Due__c pld : feesduelist){
            triggermap.put(pld.id,pld);
            triggermap.get(pld.id).Conductor_Sent__c = true;
                    
        }
        System.debug('*********Value Of COnductor Sent in Trigger New Map '+triggermap);
        update triggermap.values();
        System.debug('**After Update*******Value Of COnductor Sent in Trigger Old Map '+triggermapold);  
        System.debug('**After Update*******Value Of COnductor Sent in Trigger New Map '+triggermap);
        System.debug('**After Update*******Value Of COnductor Sent in Invoice Fess Due List '+feesduelist);    
         Employee__c d = new Employee__c(first_name__c = 'Mark'
                    ,last_Name__c = 'Moser2'
                    ,name = 'Mark Moser2'
                    ,emp_id__c = '59JRB2'
                    ,email__c = 'mark.moser@morganstanley.com'
                    ,Level_Dsc_Job__c = 'Contingent'
                    );
        insert d;
        Employee_Delegate__c ed = new Employee_Delegate__c (application__c = 'Global Parking', employee__c = e.id, delegate__c = d.id,status__c = 'Approved');    
        List<Employee_Delegate__c > delegatelist = new List<Employee_Delegate__c >();
        delegatelist.add(ed);
        insert delegatelist ;
        
        Map<ID,Employee_Delegate__c > delegatemap = new Map<ID,Employee_Delegate__c >();
        
        for(Employee_Delegate__c edl : delegatelist ){
            delegatemap.put(edl.id , edl); 
        }
        
        Test.startTest();
        GP_EmailUtility.mailforparkingcharges(feesduelist,triggermap,triggermapold);
        GP_EmailUtility.SendMailforDelegateRequest(delegatelist , delegatemap);
        GP_EmailUtility.SendMailforDelegateApproval(delegatelist , delegatemap);
        Test.stopTest();
    }
    
    static testMethod void myTest5(){
        TestGPData.createData(); 
        
        Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'London'];
        Employee__c e = new Employee__c(first_name__c = 'Mark'
                    ,last_Name__c = 'Moser'
                    ,name = 'Mark Moser'
                    ,emp_id__c = '59JRB'
                    ,email__c = 'mark.moser@morganstanley.com'
                    ,Level_Dsc_Job__c = 'Contingent'
                    );
        insert e;
    
        Parking_Lot_Request__c r = new Parking_Lot_Request__c();
        r.requestee__c = e.id;
        r.type__c = 'Parking Space';
        r.vehicle_type__c = 'Car';
        r.status__c = 'Assigned';
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = reg.id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        Parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = reg.id, Send_Email_TO__c = 'CO - Contractor');
        insert ir;
        
        Parking_Lot_Assignment_Fees_Due__c invoice = new Parking_Lot_Assignment_Fees_Due__c(Parking_Invoice_Run__c = ir.id, amount_billed__c = 100.00, amount_paid__c = 1.00,Conductor_Sent__c = true, Status__c = 'Revised Invoice');
        Parking_Lot_Assignment_Fees_Due__c invoicefordisputeprocessed = new Parking_Lot_Assignment_Fees_Due__c(Parking_Invoice_Run__c = ir.id, amount_billed__c = 100.00, amount_paid__c = 1.00,Conductor_Sent__c = false, Status__c = 'Revised Invoice');
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :reg.id limit 1 ];
    
    
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :pl.id and space_type__c = 'Car' 
          and status__c = 'Available'  ];
        
        Parking_Lot_Space_Assignment__c sa = new Parking_Lot_Space_Assignment__c();
        sa.employee__c = e.id;
        sa.parking_lot_Request__c = r.id;
        sa.parking_lot_space__c = pList[0].id;
        sa.method_of_payment__c = 'Hourly';
        sa.Assignment_Start_DATE__C = date.today().addMonths(1);
        sa.Assignment_end_DATE__C = date.today().addMonths(24);
        sa.parking_pass_id__c = '100asdasdf';
        insert sa;
        
        Parking_Lot_Space_Assignment_Time_Used__c tu = new Parking_Lot_Space_Assignment_Time_Used__c();
        Date myDate = date.today().addMonths(1);
        Time myTime = Time.newInstance(3, 3, 3, 0);
        DateTime dt = DateTime.newInstance(myDate, myTime);
        tu.invoice__c = invoice.id;
        tu.parking_Lot_Space_Assignment__c= sa.id;
        tu.Disputed__c = false ;
        tu.in__c = dt;
        tu.out__c = dt.addHours(8);
        tu.resolved__c = true;
        
        
        List<Parking_Lot_Space_Assignment_Time_Used__c> spaceused = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        
        spaceused.add(tu);
        insert spaceused;
        
        Map<ID,Parking_Lot_Space_Assignment_Time_Used__c> disputenewmap  = new Map<ID,Parking_Lot_Space_Assignment_Time_Used__c>();
        Map<ID,Parking_Lot_Space_Assignment_Time_Used__c> disputeoldmap = new Map<ID,Parking_Lot_Space_Assignment_Time_Used__c>();
        
        for(Parking_Lot_Space_Assignment_Time_Used__c pt : spaceused){
            disputeoldmap.put(pt.id,pt);
        }
        
        for(Parking_Lot_Space_Assignment_Time_Used__c pt : spaceused){
            disputenewmap.put(pt.id,pt);
            disputenewmap.get(pt.id).Disputed__c = true;
        }
        
        update disputenewmap.values();
        
        
        List<Parking_Lot_Assignment_Fees_Due__c> feesduelist = new List<Parking_Lot_Assignment_Fees_Due__c>();
        feesduelist.add(invoice);
        
        insert feesduelist;
        Map<ID,Parking_Lot_Assignment_Fees_Due__c> triggermap = new Map<ID,Parking_Lot_Assignment_Fees_Due__c>();
        Map<ID,Parking_Lot_Assignment_Fees_Due__c> triggermapold = new Map<ID,Parking_Lot_Assignment_Fees_Due__c>();
        for(Parking_Lot_Assignment_Fees_Due__c pld : feesduelist){
            triggermapold.put(pld.id,pld);
            
        }
        
        for(Parking_Lot_Assignment_Fees_Due__c pld : feesduelist){
            triggermap.put(pld.id,pld);
            triggermap.get(pld.id).Conductor_Sent__c = true;
                    
        }

        update triggermap.values(); 
         
        
        Test.startTest();
        
        GP_EmailUtility.mailforparkingDispute (spaceused,disputenewmap,disputeoldmap);
        GP_EmailUtility.mailforparkingDisputeprocessed (feesduelist,triggermap,triggermapold);
        
        Test.stopTest();
    }

        
}