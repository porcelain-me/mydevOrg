// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_CreateDSEN class
//
// 28 Jan 2014 Rahul Agrawal Original
//
@isTest(SeeAllData=false)
private class DG_CreateDSEN_Test {

    static List__c listRecord;
    static User sysUser;
    static list<Employee__c> listEmployee;
    static list<List_Employee__c> lstEmployee;
    
    static testMethod void unitTest() {
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            Test.StartTest();
            createTestData(true);
            apexPages.currentPage().getParameters().put('lid', listRecord.Id);
	        DG_CreateDSEN controller = new DG_CreateDSEN();
	        controller.initiateProcess();
	        
	        listEmployee[0].EMP_Id__c = 'Test@34';
	        update lstEmployee;
	        controller.initiateProcess();
	        
            Test.StopTest();
        }
    }
    
    static testMethod void unitTest_ListIdNull() {
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            Test.StartTest();
            createTestData(true);
	        DG_CreateDSEN controller = new DG_CreateDSEN();
	        //controller.initiateProcess();
            Test.StopTest();
        }
    }
    
    static testMethod void unitTest_InvalidEmployee() {
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            Test.StartTest();
            createTestData(true);
	        DG_CreateDSEN controller = new DG_CreateDSEN();
	        apexPages.currentPage().getParameters().put('lid', listRecord.Id);
	        listEmployee[0].Email__c = null;
	        update listEmployee;
	        controller.initiateProcess();
	        
	        sysUser.Emp_Id__c = 'TEST@34';
        	update sysUser;
        	controller = new DG_CreateDSEN();
	        controller.initiateProcess();
	        
            Test.StopTest();
        }
    }
    
    static testMethod void unitTest_WithoutAttcahment() {
        sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            Test.StartTest();
            createTestData(false);
            apexPages.currentPage().getParameters().put('lid', listRecord.Id);
            DG_CreateDSEN controller = new DG_CreateDSEN();
            controller.initiateProcess();
            Test.StopTest();
            
        }
    }
    
    static void createTestData(boolean insertAttachment){
        listRecord = DG_TestClassUtilities.createListRecord('test List');
        listRecord.DocuSign_Status__c = 'Ready';
        listRecord.Document_Display_Name__c = 'test';
        //listRecord.Enable_for_Acknowledgement__c = true;
        insert listRecord;
        
        Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
        //testTemplate.Template_Type__c = DG_DataUtil.PDF;
        insert testTemplate;
        
        if(insertAttachment){
            Attachment attach = new Attachment(Name = 'test doc', body = blob.valueOf('test document body'), parentId = testTemplate.Id);
            insert attach;
        }
        
        List_Template__c listTemplate = DG_TestClassUtilities.createListTemplateRecord(listRecord.Id, testTemplate.Id);
        insert listTemplate;
        
        listEmployee = DG_TestClassUtilities.createBulkEmployee(123455, 123456);
        insert listEmployee;
        
        lstEmployee = DG_TestClassUtilities.createListEmployee(listRecord.Id, listEmployee, 'Created');
        insert lstEmployee;
        sysUser.Emp_Id__c = listEmployee[0].Emp_Id__c;
        update sysUser;
        
        Bulk_Docusign_Settings__c bulkDocusignSetting = DG_TestClassUtilities.createBulkDocusignSettingRecord();
        bulkDocusignSetting.Docusign_API_Limit_Hourly__c = 100;
        bulkDocusignSetting.SFDC_Callout_Limit_Per_Batch__c = 10;
        insert bulkDocusignSetting;
    }
}