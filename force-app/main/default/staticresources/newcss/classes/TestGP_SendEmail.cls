@isTest
public class TestGP_SendEmail {
    static testMethod void myTest (){
        
        TestGPData.createData(); 
        
        Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'London'];
         
        EmailTemplate e= [SELECT id FROM EmailTemplate WHERE developerName = 'GP_Email_1_Request_Submitted'];
        Map<ID,String> EmailToAddressesmap = new Map<ID,String>();
        Map<ID,String> EmailCCAddressesmap = new Map<ID,String>();
        Map<ID,ID> Parkingrequestmap = new Map<ID,ID>();
        Map<ID,String>delegatemap = new Map<ID,String>();
        Employee__c emp1 = new Employee__c(first_name__c = 'Sachin'
        ,last_Name__c = 'Tendulkar'
        ,name = 'Sachin Tendulkar'
        ,emp_id__c = '2929'
        ,email__c = 'sachin.tendulkar@morganstanley.com'
        ,Level_Dsc_Job__c = 'Contingent');
                    
        insert emp1; 
        
        Employee__c emp2 = new Employee__c(first_name__c = 'Virat'
        ,last_Name__c = 'Kohli'
        ,name = 'Virat Kohli'    
        ,emp_id__c = '3636'
        ,email__c = 'virat.kohli@morganstanley.com'
        ,Level_Dsc_Job__c = 'Contingent');
                    
        insert emp2;  
        
         Employee_Delegate__c ed = new Employee_Delegate__c (application__c = 'Global Parking', employee__c = emp1.id, delegate__c = emp2.id,status__c = 'Approved');
         insert ed; 
         
         //TestGPData.createData(); 
        
        // Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'London'];
         
         Parking_Lot_Request__c r4 = new Parking_Lot_Request__c();
            r4.requestee__c = emp1.id;
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
            
         EmailToAddressesmap.put(r4.id,emp1.email__c);  
         EmailCCAddressesmap.put(r4.id,emp2.email__c);
         Parkingrequestmap.put(r4.id,r4.id);
         delegatemap.put(ed.employee__c,emp2.email__c); 
         
         GP_SendEmail.sendEmail(e.id,EmailToAddressesmap,EmailCCAddressesmap,Parkingrequestmap);
         GP_SendEmail.sendEmailForInvoiceAndDispute(e.id,EmailToAddressesmap,EmailCCAddressesmap,Parkingrequestmap);
         GP_SendEmail.sendEmail(e.id,EmailToAddressesmap,Parkingrequestmap); 
         GP_SendEmail.sendEmail(e.id,EmailToAddressesmap,EmailCCAddressesmap,delegatemap);  
    }
}