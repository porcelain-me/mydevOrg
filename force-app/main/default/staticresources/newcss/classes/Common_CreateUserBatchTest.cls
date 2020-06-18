// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for Common_CreateUserBatch Batch class
//
// 21 Jan 2014 Manisha Gupta Original
//
@isTest
private class Common_CreateUserBatchTest {
    
    static testmethod void createUserTest(){
        
        User tempUser = DG_TestClassUtilities.getSystemAdminTempUser();
        
        system.runAs(tempUser){
            Test.StartTest();
            insert DG_TestClassUtilities.createEmployeeAcknowledgementSettingRecord();
            set<String> setEmpIds = new set<String>();
            List<Employee__c> listEmp = DG_TestClassUtilities.createBulkEmployee(0, 4);
            insert listEmp;
            for(Employee__c emp : listEmp){
                setEmpIds.add(emp.Emp_Id__c);
            }
            Common_CreateUserBatch batchInstance = new Common_CreateUserBatch();
            batchInstance.start(null);
            batchInstance.execute(null, ListEmp);
            batchInstance.finish(null);
            batchInstance.execute(null);
            
            
            list<User> listUser = [Select Id from User where Emp_Id__c in :setEmpIds];
            
            system.assertEquals(listEmp.size(), listUser.size());
            
            for(User usr : listUser){
                usr.isActive = true;
            }
            
            update listUser;
            
            for(Employee__c emp : listEmp){
                emp.Status__c = 'Terminated';
            }
            
            update listEmp;
            
            
            
            
            batchInstance.execute(null, ListEmp);
            
            for(User u : [Select Id, isActive from User where Emp_Id__c in :setEmpIds]){
                system.assert(!u.isActive);
            }
            
            for(User usr : listUser){
                usr.isActive = false;
            }
            
            update listUser;
            
            for(Employee__c emp : listEmp){
                emp.Status__c = 'Active';
            }
            
            update listEmp;
            
            
            
            
            batchInstance.execute(null, ListEmp);
            
            for(User u : [Select Id, isActive from User where Emp_Id__c in :setEmpIds]){
                //system.assert(u.isActive);
            }
            
            
            
            Test.StopTest();
            
        }
        
    }
    
    
    static testmethod void createUserTest_NoCustomSetting(){
        
        User tempUser = DG_TestClassUtilities.getSystemAdminTempUser();
        system.runAs(tempUser){
            Test.StartTest();
            insert DG_TestClassUtilities.createEmployeeAcknowledgementSettingRecord();
            set<String> setEmpIds = new set<String>();
            List<Employee__c> listEmp = DG_TestClassUtilities.createBulkEmployee(0, 100);
            insert listEmp;
            for(Employee__c emp : listEmp){
                setEmpIds.add(emp.Emp_Id__c);
            }
            Common_CreateUserBatch batchInstance = new Common_CreateUserBatch();
            batchInstance.start(null);
            batchInstance.execute(null, ListEmp);
            batchInstance.finish(null);
            batchInstance.execute(null);
            Test.StopTest();
            
            Integer createdUserCount = [Select count() from User where Emp_Id__c in :setEmpIds];
            
            system.assertEquals(listEmp.size(), createdUserCount);
            
        }
        
    }
    
}