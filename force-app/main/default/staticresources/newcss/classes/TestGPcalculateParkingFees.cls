@isTest()
public class TestGPcalculateParkingFees {

    static testmethod void test1(){

        TestGPData.createData(); 
        
        List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
        List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
        system.debug('space list is: ' + spaceList);
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :rList[0].id limit 1 ];
        
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
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
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = rList[0].id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        GP_calculateParkingFees f = new GP_calculateParkingFees(r.id, 'Budapest', date.parse('06/01/2016'), date.parse('06/30/2016'));
        
        GP_calculateParkingFees.returnFeeInfo result = new GP_calculateParkingFees.returnFeeInfo(null,null,null,null);
        
        result = f.getFeeBudapest(string.valueOf(pl.id), 'VP - Vice President', 'Monthly', 'Car', string.valueOf(r.id), r, null, false);       
    }   
    
    static testmethod void test2(){

        TestGPData.createData(); 
        
        List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'London'];
        List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
        system.debug('space list is: ' + spaceList);
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :rList[0].id limit 1 ];
        
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
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
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = rList[0].id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        Parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = rList[0].id );
        insert ir;
        
        GP_calculateParkingFees f = new GP_calculateParkingFees(r.id, 'Budapest', date.parse('06/01/2016'), date.parse('06/30/2016'));
        
        GP_calculateParkingFees.returnFeeInfo result = new GP_calculateParkingFees.returnFeeInfo(null,null,null,null);
        
        result = f.getFee(false, string.valueOf(pl.id), 'VP - Vice President', 'Monthly', 'Car', string.valueOf(ir.id), r, null);       
    }
    
    static testmethod void test3(){

        TestGPData.createData(); 
        
        List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'London'];
        List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
        system.debug('space list is: ' + spaceList);
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :rList[0].id limit 1 ];
        
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
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
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = rList[0].id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        Parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = rList[0].id );
        insert ir;
        
        GP_calculateParkingFees f = new GP_calculateParkingFees(r.id, 'Budapest', date.parse('06/01/2016'), date.parse('06/30/2016'));
        
        GP_calculateParkingFees.returnFeeInfo result = new GP_calculateParkingFees.returnFeeInfo(null,null,null,null);
        
        result = f.getFee(false, string.valueOf(pl.id), 'VP - Vice President', 'Monthly', 'Car2', string.valueOf(ir.id), r, null);      
    }   
    
    static testmethod void test4(){

        TestGPData.createData(); 
        
        List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
        List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
        system.debug('space list is: ' + spaceList);
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :rList[0].id limit 1 ];
        
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
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
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = rList[0].id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        
        Parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = rList[0].id );
        insert ir;
        
        GP_calculateParkingFees f = new GP_calculateParkingFees(r.id, 'Budapest', date.parse('06/01/2016'), date.parse('06/30/2016'));
        
        GP_calculateParkingFees.returnFeeInfo result = new GP_calculateParkingFees.returnFeeInfo(null,null,null,null);
        
        result = f.getFeeBudapest(string.valueOf(pl.id), 'VP - Vice President', 'Monthly', 'Car2', string.valueOf(ir.id), r, null, false);     
    }   
        
        
    static testmethod void test6(){

        TestGPData.createData(); 
        
        List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
        List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
        system.debug('space list is: ' + spaceList);
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :rList[0].id and name = 'Millenium III' limit 1 ];
        
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
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
        r.rate_type__c = 'Hourly';
        r.parking_lot_Region__c = rList[0].id;
        r.method_of_payment__c = 'Consumption';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        
        parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = rList[0].id );
        insert ir;
        
        Parking_Lot_Assignment_Fees_Due__c invoice = new Parking_Lot_Assignment_Fees_Due__c(Parking_Invoice_Run__c = ir.id);
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :pl.id and space_type__c = 'Car' 
            and status__c = 'Available' ];
        
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
        
        tu.in__c = dt;
        tu.out__c = dt.addHours(8);
        
        insert tu;
        List<Parking_Lot_Space_Assignment_Time_Used__c> tuList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        tuList.add(tu);
        
        GP_calculateParkingFees f = new GP_calculateParkingFees(r.id, 'Budapest', date.parse('06/01/2016'), date.parse('06/30/2016'));
        
        GP_calculateParkingFees.returnFeeInfo result = new GP_calculateParkingFees.returnFeeInfo(null,null,null,null);
        
        result = f.getFeeBudapest(string.valueOf(pl.id), 'VP - Vice President', 'Hourly', 'Car', string.valueOf(ir.id), r, tuList, true);     
    }   
    
    static testmethod void test7(){

        TestGPData.createData(); 
        
        List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
        List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
        system.debug('space list is: ' + spaceList);
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :rList[0].id and name = 'Millenium III' limit 1 ];
        
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
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
        r.rate_type__c = 'Hourly';
        r.parking_lot_Region__c = rList[0].id;
        r.method_of_payment__c = 'Consumption';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        
        parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = rList[0].id );
        insert ir;
        
        Parking_Lot_Assignment_Fees_Due__c invoice = new Parking_Lot_Assignment_Fees_Due__c(Parking_Invoice_Run__c = ir.id);
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :pl.id and space_type__c = 'Car' 
            and status__c = 'Available' ];
        
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
        
        tu.in__c = dt;
        tu.out__c = dt.addHours(8);
        tu.resolved__c = true;
        insert tu;
        List<Parking_Lot_Space_Assignment_Time_Used__c> tuList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        tuList.add(tu);
        
        GP_calculateParkingFees f = new GP_calculateParkingFees(r.id, 'Budapest', date.parse('06/01/2016'), date.parse('06/30/2016'));
        
        GP_calculateParkingFees.returnFeeInfo result = new GP_calculateParkingFees.returnFeeInfo(null,null,null,null);
        
        result = f.getFeeBudapest(string.valueOf(pl.id), 'VP - Vice President', 'Hourly', 'Car', string.valueOf(ir.id), r, tuList, false);     
    }
    
        
    static testmethod void test8(){

        TestGPData.createData(); 
        
        List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Glasgow'];
        List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
        system.debug('space list is: ' + spaceList);
        
        Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :rList[0].id limit 1 ];
        
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
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
        r.rate_type__c = 'Monthly';
        r.parking_lot_Region__c = rList[0].id;
        r.method_of_payment__c = 'Monthly';
        r.start_date__c = date.today().addMonths(1);
        r.no_charge__c = false;
        r.expectant_mother__c = false;
        insert r;
        
        Parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = rList[0].id );
        insert ir;
        
        Parking_Lot_Assignment_Fees_Due__c invoice = new Parking_Lot_Assignment_Fees_Due__c(Parking_Invoice_Run__c = ir.id);
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :pl.id and space_type__c = 'Car' 
            and status__c = 'Available' ];
        
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
        
        tu.in__c = dt;
        tu.out__c = dt.addHours(8);
        tu.resolved__c = true;
        insert tu;
        
        List<Parking_Lot_Space_Assignment_Time_Used__c> tuList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        tuList.add(tu);
        GP_calculateParkingFees f = new GP_calculateParkingFees(r.id, 'Glasgow', date.parse('06/01/2016'), date.parse('06/30/2016'));
        
        GP_calculateParkingFees.returnFeeInfo result = new GP_calculateParkingFees.returnFeeInfo(null,null,null,null);
        
        result = f.getFee(false, string.valueOf(pl.id), 'VP - Vice President', 'Hourly', 'Car', string.valueOf(ir.id), r, tuList);      
    }       
}