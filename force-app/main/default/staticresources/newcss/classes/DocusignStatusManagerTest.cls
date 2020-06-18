@isTest(SeeAllData = false)
private class DocusignStatusManagerTest {
    private static User sysUser;
    private static dsfs__DocuSign_Status__c ds;
    private static FFAP_Agreement__c faAgreement;
    private static List<List_Employee__c> testListEmpList;
    private static testmethod void testDocusignStatus(){
        sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();            
            insert ds;
            ds = [SELECT Id, FFAP_Record__c from dsfs__DocuSign_Status__c where Id =: ds.Id];
            System.assertEquals(faAgreement.Id, ds.FFAP_Record__c);
            Test.stopTest();
        }
    }
    private static void createData(){
    	//Employee
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        empList.add(emp1);
        insert empList;
        
        //
        faAgreement = FFAP_TestClassUtilities.createAgreement(emp1.Id);
        insert faAgreement;

        ds = FFAP_TestClassUtilities.createDocusignStatusRecord(emp1.Id, null);
    }
    
    private static testmethod void testDocusignStatusForDG(){
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createDGData();
            Test.startTest();            
            
            ds.dsfs__Envelope_Status__c = DG_DataUtil.DECLINED;
            update ds;
            
            testListEmpList = DG_DataUtil.getListIdOnListEmployees(new set<id>{testListEmpList[0].Id});
            
            System.assertEquals(testListEmpList[0].Status__c, DG_DataUtil.DECLINED);
            
            Test.stopTest();
        }
    }
    private static void createDGData(){
        List__c testList = DG_TestClassUtilities.createListRecord('Test List');
        insert testList;
        List<Employee__c> testEmpList = DG_TestClassUtilities.createBulkEmployee(0, 1);
        insert testEmpList;
        
        testListEmpList = DG_TestClassUtilities.createListEmployee(testList.Id, testEmpList, '');        
        insert testListEmpList;
        
        ds = DG_TestClassUtilities.createDocusignStatusRecord(testListEmpList.get(0).Id);
        insert ds;
    }
}