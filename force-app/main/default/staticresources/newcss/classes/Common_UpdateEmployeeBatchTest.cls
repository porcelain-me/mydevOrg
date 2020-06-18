// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for Common_UpdateEmployeeBatch Batch class
//
// 23 Jan 2014 Manisha Gupta Original
//
@isTest
private class Common_UpdateEmployeeBatchTest {
    
    static testmethod void updateEmployeeTest(){
        User tempUser = DG_TestClassUtilities.getSystemAdminTempUser();
        system.runAs(tempUser){
            Test.StartTest();
            List<Employee__c> listEmp = DG_TestClassUtilities.createBulkEmployee(0, 10);
            insert listEmp;
            List<User> listUser = new list<User>();
            User newUser;
            integer count = 0;
            for(Employee__c emp : listEMp){
                newUser = DG_TestClassUtilities.getDGTempUser();
                newUser.Emp_Id__c = emp.Emp_id__c;
                newUser.userName = newUser.userName + count++;
                listUser.add(newUser);
            }
            
            insert listUser;
            
            
            Common_UpdateEmployeeBatch batchInstance = new Common_UpdateEmployeeBatch();
            batchInstance.start(null);
            batchInstance.execute(null, ListEmp);
            batchInstance.finish(null);
            batchInstance.execute(null);
            Test.StopTest();
            
            for(Employee__c emp : [Select User__c from Employee__c where Id in : listEmp]){
                system.assert(emp.User__c <> null);
            }
        }
    }
}