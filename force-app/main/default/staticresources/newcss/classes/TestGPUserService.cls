@isTest
private class TestGPUserService {

    static testmethod void test1(){

        //TestGPData.createData(); 
        GP_Master_Settings__c settings = new GP_Master_Settings__c(Name='Settings');
        insert settings;
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
        Employee__c e = new Employee__c(first_name__c = 'Mark'
                                        ,last_Name__c = 'Moser'
                                        ,name = 'Mark Moser'
                                        ,emp_id__c = u.emp_id__c 
                                        ,email__c = 'mark.moser@morganstanley.com'
                                        ,Level_Dsc_Job__c = 'Contingent'
                                        );

        insert e;
        
        Employee__c d = new Employee__c(first_name__c = 'Mark'
                                        ,last_Name__c = 'Moser2'
                                        ,name = 'Mark Moser2'
                                        ,emp_id__c = '59JRB2'
                                        ,email__c = 'mark.moser@morganstanley.com'
                                        ,Level_Dsc_Job__c = 'Contingent'
                                        );
        insert d;
        
        Employee_Delegate__c ed = new Employee_Delegate__c (application__c = 'Global Parking', employee__c = e.id, delegate__c = d.id,status__c = 'Approved');      
        
        insert ed;
        
        Test.startTest();

        GP_UserService.approveDelegation('{"id":"' + ed.id + '"}');
        GP_UserService.removeDelegate('{"id":"' + ed.id + '"}');
        
        GP_UserService.getDelegates();
        
        GP_UserService.getMyDelegates();
        
        GP_UserService.requestDelegate('{"msid":"' + u.emp_id__c + '"}');
        
        GP_UserService.getRequestsForDelegation();
        
        

        GP_UserService.searchEmployees('{"searchTerm":"Moser"}');
                
        Test.stopTest();
        
        
    }

    static testmethod void test2(){

        //TestGPData.createData(); 
        GP_Master_Settings__c settings = new GP_Master_Settings__c(Name='Settings');
        insert settings;
        
        User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
        Employee__c e = new Employee__c(first_name__c = 'Mark'
                                        ,last_Name__c = 'Moser'
                                        ,name = 'Mark Moser'
                                        ,emp_id__c = '59JRB'
                                        ,email__c = 'mark.moser@morganstanley.com'
                                        ,Level_Dsc_Job__c = 'Contingent'
                                        );

        insert e;
        
        Employee__c d = new Employee__c(first_name__c = 'Mark'
                                        ,last_Name__c = 'Moser2'
                                        ,name = 'Mark Moser2'
                                        ,emp_id__c = '59JRB2'
                                        ,email__c = 'mark.moser@morganstanley.com'
                                        ,Level_Dsc_Job__c = 'Contingent'
                                        );
        insert d;
        
        Employee_Delegate__c ed = new Employee_Delegate__c (application__c = 'Global Parking', employee__c = e.id, delegate__c = d.id,status__c = 'Submitted');
        insert ed;
        
        Test.startTest();
        
        GP_UserService.rejectDelegation('{"id":"' + ed.id + '"}');
        
        
        Test.stopTest();
        
        
    }
}