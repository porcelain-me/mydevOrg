@isTest(SeeAllData = false)
private class FFAP_DocusignAPI_UtilitiesTest {
    private static User ffapUser;
    private static Employee__c emp1;
    private static FFAP_Agreement__c faAgreement;
    private static JPN_Change__c jpnChange;
    private static testmethod void testDocusignAPI(){
        ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            FFAP_DocusignAPI_Utilities utilities = new FFAP_DocusignAPI_Utilities(faAgreement.Id, 'TESTPACKAGE');
            String resultString = utilities.checkDocumentsAndSendForSignature();
            System.assertEquals('Docusign Account is not configured. Please ask your System Administrator to configure.', resultString);            
            
            FFAP_TestClassUtilities.createDocusignRecord();
            resultString = utilities.checkDocumentsAndSendForSignature();
            System.assertEquals('No Document is generated for this package for signing through Docusign.', resultString);
            
            createDocumentRecipient();            
            resultString = utilities.checkDocumentsAndSendForSignature();
            List<String> errors = resultString.split('\n');
            System.assertEquals(false, errors.isEmpty());
            //System.assertEquals(2, errors.size());
            String empName = '(' + emp1.Name + ' - ' + emp1.Emp_Id__c + ')';
            //System.assertEquals('Employee' + empName+ ' is not Active.', errors[0]);
            //System.assertEquals('Docusign Account for ' + 'Employee' + empName + ' is not created yet.', errors[1]);
            
            emp1.Status__c = 'Active';
            emp1.DocuSign_GUID__c = 'docusign-account-1';
            update emp1;
            resultString = utilities.checkDocumentsAndSendForSignature();
            System.assertEquals('Document is not generated yet. Please wait for few minutes.', resultString);
            
            createAttachment();
            resultString = utilities.checkDocumentsAndSendForSignature();
            System.assertEquals(FFAP_DataUtil.SUCCESS, resultString);            
            
            utilities = new FFAP_DocusignAPI_Utilities(jpnChange.Id, 'TESTPACKAGE');
            resultString = utilities.checkDocumentsAndSendForSignature();
            System.assertEquals(FFAP_DataUtil.SUCCESS, resultString);
            Test.stopTest();
        }
    }
    private static void createData(){
        //Employee
        List<Employee__c> empList = new List<Employee__c>();        
        emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        emp1.Status__c = 'Inactive';
        emp1.DocuSign_GUID__c = null;
        empList.add(emp1);
        insert empList;
        
        //FA Agreement
        faAgreement = FFAP_TestClassUtilities.createAgreement(emp1.Id);                
        insert faAgreement;
        
        //JPN Change
        jpnChange = FFAP_TestClassUtilities.createJPNChange('FA', FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.MODIFICATION_RECORDTYPE), emp1.Id);
        insert jpnChange;        
    }
    private static void createAttachment(){
    	List<Attachment> attachList = new List<Attachment>();
        attachList.add(FFAP_TestClassUtilities.createAttachment('TESTAGREEMENTDOCUMENT.doc', faAgreement.Id));
        attachList.add(FFAP_TestClassUtilities.createAttachment('TESTJPNCHANGEDOCUMENT.doc', jpnChange.Id));
        insert attachList;
    }
    private static void createDocumentRecipient(){
        List<FFAP_Document_Recipient__c> docRecipientList = new List<FFAP_Document_Recipient__c>();
        docRecipientList.add(FFAP_TestClassUtilities.createDocRecipient('TESTAGREEMENTDOCUMENT.doc', faAgreement.Id, emp1.Id, 1));
        docRecipientList.add(FFAP_TestClassUtilities.createDocRecipient('TESTJPNCHANGEDOCUMENT.doc', jpnChange.Id, emp1.Id, 1));
        insert docRecipientList;
    }  
}