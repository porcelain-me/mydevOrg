@isTest(SeeAllData = false)
private class FFAP_DocusignAPI_CallTest {
    private static User ffapUser;
    private static Employee__c emp1;
    private static FFAP_Agreement__c faAgreement;
    private static testmethod void testDocusignAPI(){
        ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            
            Test.setCurrentPage(Page.FFAP_DocusignAPI_Call);
            ApexPages.currentPage().getParameters().put('sourceId', faAgreement.Id);  
            ApexPages.currentPage().getParameters().put('docType', 'TESTPACKAGE');
            FFAP_DocusignAPI_Call docusignPage = new FFAP_DocusignAPI_Call();
            docusignPage.updateRecords();
            System.assertEquals(true, docusignPage.isError, 'Error should be thorwn.');
            System.assertEquals(true, docusignPage.isCompleted, 'Process should not be completed.');
            
            FFAP_TestClassUtilities.createDocusignRecord();
            docusignPage.updateRecords();
            System.assertEquals(false, docusignPage.isError, 'Error should not be thorwn.');
            System.assertEquals(true, docusignPage.isCompleted, 'Process should be completed.');
            
            Test.stopTest();
        }
    }
    private static void createData(){
        //Employee
        List<Employee__c> empList = new List<Employee__c>();        
        emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        empList.add(emp1);
        insert empList;
        
        //FA Agreement
        faAgreement = FFAP_TestClassUtilities.createAgreement(emp1.Id);
        insert faAgreement;
        
        List<FFAP_Document_Recipient__c> docRecipientList = new List<FFAP_Document_Recipient__c>();
        docRecipientList.add(FFAP_TestClassUtilities.createDocRecipient('TESTDOCUMENT.doc', faAgreement.Id, emp1.Id, 1));
        insert docRecipientList;
        
        List<Attachment> attachList = new List<Attachment>();
        attachList.add(FFAP_TestClassUtilities.createAttachment('TESTDOCUMENT.doc', faAgreement.Id));
        insert attachList;
    }
}