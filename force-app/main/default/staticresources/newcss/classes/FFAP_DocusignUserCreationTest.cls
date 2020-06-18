@isTest(seeAllData = false)
private class FFAP_DocusignUserCreationTest {
    private static User sysUser;
    private static List<Employee__c> empListWithOneEmployee;
    private static List<Employee__c> empListWithTenEmployee;
    private static testmethod void testDocusignUserCreation(){ 
    	sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();
            FFAP_DocusignUserCreation userCreation = new FFAP_DocusignUserCreation();           
            
            userCreation.start(null);
            FFAP_TestClassUtilities.createDocusignTemplate();
            
            userCreation.start(null);
            FFAP_TestClassUtilities.createDocusignRecord();
            
            userCreation.start(null);
            userCreation.execute(null, empListWithOneEmployee);            
            
            userCreation.execute(null, empListWithTenEmployee);
            userCreation.empWrapList.add(new FFAP_DocusignUserCreation.EmployeeWrapper(empListWithOneEmployee.get(0), 'TESTERRORCODE', 'TESTERRORDESC'));            
            userCreation.finish(null);
            userCreation.execute(null);
            Test.stopTest();
        }
    }
    private static void createData(){
    	FFAP_TestClassUtilities.setAllTriggerOn(sysUser.Id);
    	//Employee
        List<Employee__c> empList = new List<Employee__c>();
        empListWithOneEmployee = new List<Employee__c>();
        empListWithTenEmployee = new List<Employee__c>();
        Employee__c emp;
        for(Integer i = 1; i < 13; i++){
            emp = FFAP_TestClassUtilities.createTestEmployee(i, 'TEST00' + i, '600097', '3', '1', '2');
            if(i == 1){
            	emp.City_Home__c = null;
            	empListWithOneEmployee.add(emp);
            }else{
            	empListWithTenEmployee.add(emp);
            }
            empList.add(emp);
        }
        insert empList;
    }
}