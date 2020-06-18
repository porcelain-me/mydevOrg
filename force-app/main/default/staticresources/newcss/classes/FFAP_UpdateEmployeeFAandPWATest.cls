// 11/09/2013 Jaipal : Original
 

@isTest(seeAllData = false)
private class FFAP_UpdateEmployeeFAandPWATest {
    private static User sysUser;
    private static List<Employee__c> empList;
    private static testmethod void testEmployeeHierarchy(){        
        sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();
            FFAP_UpdateEmployeeFAandPWA updateEmp = new FFAP_UpdateEmployeeFAandPWA();
             
            System.assertEquals(1, updateEmp.faTypes.size(), 'Total Job Title should be 1.');
            System.assertEquals(1, updateEmp.pwaTypes.size(), 'Total Job Title should be 1.');
            updateEmp.start(null);            
            updateEmp.execute(null, empList);
            
            Employee__c emp = [Select Id, FFAP_Is_FA__c From Employee__c where Id =: empList[0].Id limit 1];
           
            System.assertEquals(true, emp.FFAP_Is_FA__c);
            emp = [Select Id, FFAP_Is_PWA__c From Employee__c where Id =: empList[1].Id limit 1];
            System.assertEquals(true, emp.FFAP_Is_PWA__c);
            
            updateEmp.finish(null);
            updateEmp.execute(null);
            Test.stopTest();
        }
    }
    private static void createData(){
    	FFAP_TestClassUtilities.setAllTriggerOn(sysUser.Id);
        FFAP_TestClassUtilities.createFFAPJobTitle();
        //Employee
        empList = new List<Employee__c>();
        Employee__c emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600585', '3', '1', '2');//Financial Advsior
        Employee__c emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST002', '600836', '3', '1', '2');//Private Wealth Advisor
         
        empList.add(emp1);
        empList.add(emp2);
        insert empList;
    }
}