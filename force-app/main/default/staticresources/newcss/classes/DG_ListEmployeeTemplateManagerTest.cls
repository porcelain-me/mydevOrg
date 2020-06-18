// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_ListEmployeeTemplateManager class
//
// 05 Feb 2014 Rahul Agrawal Original
//
@isTest(seeAllData = false)
private class DG_ListEmployeeTemplateManagerTest {
    
    static List__c listRecord;
    static User sysUser;
    static List<List_Employee__c> lstEmployee;
    static list<List_Template__c> lstTemplate;
    
    
    static testMethod void handleListEmployeeTriggerTest() {
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        DG_TestClassUtilities.setAllTriggerOn(sysUser.Id);
        System.runAs(sysUser){
        	Test.StartTest();
            createTestData(false);
            DG_ListEmployeeTemplateManager.handleListEmployeeTrigger(lstEmployee, true, false, false, false, true);
            DG_ListEmployeeTemplateManager.handleTemplateTrigger(lstTemplate, true, false, false, false, true);
            Test.stopTest();
        }
    }
    
    /*static testMethod void handleListTemplateTriggerTest() {
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            Test.StartTest();
            createTestData(true);
            Test.stopTest();
        }
    }*/
    
    /*static testMethod void handleListTriggerTest() {
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        List<List__c> listCorrectRecords = new List<List__c>();
        List<List__c> listRecordsWithSameName = new List<List__c>();
        List<List__c> listRecordsWithExistingName = new List<List__c>();
        for(Integer i = 1; i < 5 ; i++){
        	listCorrectRecords.add(DG_TestClassUtilities.createListRecord('Test List' + i));
        }
        for(Integer i = 1; i < 5 ; i++){
            listRecordsWithSameName.add(DG_TestClassUtilities.createListRecord('Test List'));
        }
        for(Integer i = 1; i < 5 ; i++){
            listRecordsWithExistingName.add(DG_TestClassUtilities.createListRecord('Test List' + i));
        }
        System.runAs(sysUser){
            Test.StartTest();
            insert listCorrectRecords;
            try{
                insert listRecordsWithSameName;
            }catch(DMLException ex){
            	System.assert(ex.getMessage().contains('List Name already exists in current set of records.'));
            }
            try{
                insert listRecordsWithExistingName;
            }catch(DMLException ex){
                System.assert(ex.getMessage().contains('List Name already exists.'));
            }
            Test.stopTest();
        }
    }*/
    
    static void createTestData(boolean insertListTemplateAfterListEmployee){
        listRecord = DG_TestClassUtilities.createListRecord('test List');
        listRecord.DocuSign_Status__c = 'Ready';
        listRecord.Enable_for_Acknowledgement__c = true;
        listRecord.Document_Display_Name__c ='test';
        insert listRecord;
        
        Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
        testTemplate.Template_Type__c = DG_DataUtil.PDF;
        insert testTemplate;
        
        if(!insertListTemplateAfterListEmployee){
            lstTemplate = new List<List_Template__c>{DG_TestClassUtilities.createListTemplateRecord(listRecord.Id, testTemplate.Id)};
	        insert lstTemplate;
        }
        
        list<Employee__c> listEmployee = DG_TestClassUtilities.createBulkEmployee(123455, 123456);
        insert listEmployee;
        
        lstEmployee = DG_TestClassUtilities.createListEmployee(listRecord.Id, listEmployee, 'Created');
        insert lstEmployee;
        sysUser.Emp_Id__c = listEmployee[0].Emp_Id__c;
        update sysUser;
        
        if(insertListTemplateAfterListEmployee){
            lstTemplate = new List<List_Template__c>{DG_TestClassUtilities.createListTemplateRecord(listRecord.Id, testTemplate.Id)};
            insert lstTemplate;
        }
    }
}