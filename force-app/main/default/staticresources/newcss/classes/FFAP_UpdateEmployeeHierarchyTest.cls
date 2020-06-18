@isTest(seeAllData = false)
private class FFAP_UpdateEmployeeHierarchyTest {
    private static User sysUser;
    private static List<Employee__c> empList;
    private static testmethod void testEmployeeHierarchy(){        
        sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();
            FFAP_UpdateEmployeeHierarchy updateEmp = new FFAP_UpdateEmployeeHierarchy();
            System.assertEquals(5, updateEmp.allValidTypes.size(), 'Total Job Title should be 5.');
            System.assertEquals(1, updateEmp.bmTypes.size(), 'Total Job Title should be 1.');
            System.assertEquals(1, updateEmp.cmTypes.size(), 'Total Job Title should be 1.');
            System.assertEquals(1, updateEmp.rdTypes.size(), 'Total Job Title should be 1.');
            updateEmp.start(null);            
            updateEmp.execute(null, empList);
            
            Employee__c emp = [Select Id, Manager__c, Complex_Manager__c, Regional_Director__c From Employee__c where Id =: empList[0].Id limit 1];
            //System.assertEquals(empList[0].Id, emp.Manager__c);
            System.assertEquals(empList[1].Id, emp.Complex_Manager__c);
            System.assertEquals(empList[2].Id, emp.Regional_Director__c);
           
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
        Employee__c emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST003', '600097', '3', '1', '2');//Branch Manager
        Employee__c emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST005', '600185', '3', '1', '2');//Complex Manager
        Employee__c emp3 = FFAP_TestClassUtilities.createTestEmployee(3, 'TEST004', '600896', '3', '1', '2');//Regional Director
        empList.add(emp1);
        empList.add(emp2);
        empList.add(emp3);
        insert empList;
    }
}