// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test Class for DG_DocusignSentForSignature batch job.
//
// 29 Jan 2014 Rahul Agrawal Original
//

@isTest
private class DG_DocusignSentForSignatureTest {

    static List__c listRecord;
    static list<List_Employee__c> lstEmployee;
    static testmethod void start_test(){
        User sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            Test.StartTest();
            createTestData();
            DG_DocusignSentForSignature ds = new DG_DocusignSentForSignature();
            ds.start(null);
            lstEmployee = DG_DataUtil.getListEmployees(listRecord.Id);
            ds.execute(null, lstEmployee);
            ds.finish(null);
            ds.execute(null);
            Test.StopTest();
        }
    }
    
    static void createTestData(){
        listRecord = DG_TestClassUtilities.createListRecord('test List');
        listRecord.DocuSign_Status__c = 'Ready';
        insert listRecord;
        
        Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
        insert testTemplate;
        Attachment attach = new Attachment(Name = 'test doc', body = blob.valueOf('test document body'), parentId = testTemplate.Id);
        insert attach;
        
        List_Template__c listTemplate = DG_TestClassUtilities.createListTemplateRecord(listRecord.Id, testTemplate.Id);
        insert listTemplate;
        
        list<Employee__c> listEmployee = DG_TestClassUtilities.createBulkEmployee(0, 1);
        insert listEmployee;
        lstEmployee = DG_TestClassUtilities.createListEmployee(listRecord.Id, listEmployee, 'Created');
        insert lstEmployee;
        
        Bulk_Docusign_Settings__c bulkDocusignSetting = DG_TestClassUtilities.createBulkDocusignSettingRecord();
        bulkDocusignSetting.Docusign_API_Limit_Hourly__c = 100;
        bulkDocusignSetting.SFDC_Callout_Limit_Per_Batch__c = 10;
        insert bulkDocusignSetting;
        
        dsfs__DocuSignAccountConfiguration__c accountConfig = new dsfs__DocuSignAccountConfiguration__c(dsfs__AccountId__c ='TESTACCOUNTID', dsfs__DSProSFUsername__c = 'TESTUSERID', dsfs__DSProSFPassword__c = 'TESTPASSWORD');
        accountConfig.dsfs__EmailBody__c = 'TEST EMAIL BODY.';
        insert accountConfig;
    }
}