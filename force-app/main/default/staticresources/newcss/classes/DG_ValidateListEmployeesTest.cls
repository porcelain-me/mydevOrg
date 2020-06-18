// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test Class for Validate employee details related to List Employee.
//
// 24 Jan 2014 Jitendra Kothari Original
//

@isTest(SeeAllData = false)
private class DG_ValidateListEmployeesTest {
    private static User sysUser;
    private static List<List_Employee__c> testListEmpList;
    private static testmethod void testValidateBatch(){
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            
            Test.startTest();
            createData();            
            DG_ValidateListEmployees validateBatch = new DG_ValidateListEmployees();
            validateBatch.start(null);
            validateBatch.execute(null, testListEmpList);
            validateBatch.finish(null);
            Test.stopTest();
        }
    }
    private static void createData(){
        
        List__c listRecord = DG_TestClassUtilities.createListRecord('test List');
        listRecord.DocuSign_Status__c = 'Ready';
        listRecord.Document_Display_Name__c = 'test';
        insert listRecord;
        
        list<Employee__c> listEmployee = DG_TestClassUtilities.createBulkEmployee(0, 1);
        listEmployee.get(0).Status__c = 'InActive';
        insert listEmployee;
        
        testListEmpList = DG_TestClassUtilities.createListEmployee(listRecord.Id, listEmployee, 'Created');
        insert testListEmpList; 
        
        insert DG_TestClassUtilities.createBulkDocusignSettingRecord();      
    }
}