// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test Class for DG_DocusignAPI_Call controller
//
// 16 Jan 2014 Manisha Gupta Original
//

@isTest
private class DG_DocusignAPI_CallTest {
    
    static List__c testList;
    static Template__c testTemplate;
    
    static testmethod void initiateBatchProcessTest(){
        Test.StartTest();
        createTestData(true, false);
        Test.setCurrentPage(Page.DG_DocusignAPI_Call);
        apexPages.currentPage().getParameters().put('sourceId', testList.Id);
        DG_DocusignAPI_Call controller = new DG_DocusignAPI_Call();
        controller.initiateBatchProcess();
        Test.StopTest();
        
        testList = [Select Signature_Submittor__c, DocuSign_Status__c, Sent_For_Signature_Date__c, Is_Sent_for_Signature__c 
                    from List__c 
                    where id = :testList.Id];
        system.assertEquals(userInfo.getUserId(), testList.Signature_Submittor__c);
        system.assertEquals('Ready', testList.DocuSign_Status__c);
        system.assertEquals(true, testList.Is_Sent_for_Signature__c);
    }
    
    static testmethod void initiateBatchProcessTest_AlreadySent(){
        Test.StartTest();
        createTestData(true, true);
        Test.setCurrentPage(Page.DG_DocusignAPI_Call);
        apexPages.currentPage().getParameters().put('sourceId', testList.Id);
        DG_DocusignAPI_Call controller = new DG_DocusignAPI_Call();
        controller.initiateBatchProcess();
        system.assertEquals(true, controller.isError);
        Test.StopTest();
    }
    
    static testmethod void initiateBatchProcessTest_NoAttachment(){
        Test.StartTest();
        createTestData(false, false);
        Test.setCurrentPage(Page.DG_DocusignAPI_Call);
        apexPages.currentPage().getParameters().put('sourceId', testList.Id);
        DG_DocusignAPI_Call controller = new DG_DocusignAPI_Call();
        controller.initiateBatchProcess();
        system.assertEquals(true, controller.isError);
        Test.StopTest();
    }
    
    
    static void createTestData(boolean createAttachment, boolean isAlreadySent){
        testList = DG_TestClassUtilities.createListRecord('test List');
        if(isAlreadySent){
            testList.Is_Sent_for_Signature__c = true;
        }
        insert testList;
        testTemplate = DG_TestClassUtilities.createTemplateRecord();
        
        insert testTemplate;
        if(createAttachment){
            Attachment attach = new Attachment(Name = 'test doc', body = blob.valueOf('test document body'), parentId = testTemplate.Id);
            insert attach;
        }
        
        List_Template__c listTemplate = DG_TestClassUtilities.createListTemplateRecord(testList.Id, testTemplate.Id);
        insert listTemplate;
        
        
    }
}