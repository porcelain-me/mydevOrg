// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_EAOptOutEmailHandler class
//
// 04 Feb 2014 Jitendra Kothari Original
//
@isTest(SeeAllData = false)
private class DG_EAOptOutEmailHandlerTest {
    private static Employee__c emp1;
    private static List__c listRecord;
    private static Attachment attach;
    private static list<List_Employee__c> testListEmpList;
    private static testmethod void testEmailHandler(){
    	User sysUser = DG_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();
            
            DG_EAOptOutEmailHandler emailHandler = new DG_EAOptOutEmailHandler();
            Messaging.InboundEmail email = new Messaging.InboundEmail();
            email.fromAddress = emp1.Email__c;
            
            Messaging.InboundEmailResult result = emailHandler.handleInboundEmail(email, null);
            
            result = emailHandler.handleInboundEmail(email, null);
            System.assertEquals(false, result.success, 'Error must be thrown.');
            
            email.subject = DG_EAOptOutEmailHandler.EMAIL_SUBJECT_START + 'NOLIST';
            email.plainTextBody = 'Test body';
            result = emailHandler.handleInboundEmail(email, null);            
            System.assertEquals(false, result.success, 'Error must be thrown.');
            
            email.subject = DG_EAOptOutEmailHandler.EMAIL_SUBJECT_START + 'NOLIST';
            email.plainTextBody = emp1.Emp_Id__c;
            result = emailHandler.handleInboundEmail(email, null);
            System.assertEquals(false, result.success, 'Error must be thrown.');
            
            email.subject = DG_EAOptOutEmailHandler.EMAIL_SUBJECT_START + listRecord.Id;
            email.plainTextBody = emp1.Emp_Id__c;
            result = emailHandler.handleInboundEmail(email, null);
            System.assertEquals(false, result.success, 'Error must be thrown.');
            
            insert testListEmpList;            
            result = emailHandler.handleInboundEmail(email, null);
            System.assertEquals(false, result.success, 'Error must be thrown.');
            
            insert attach;            
            result = emailHandler.handleInboundEmail(email, null);            
            System.assertEquals(true, result.success, 'No Error must be thrown');
            
            result = emailHandler.handleInboundEmail(email, null);
            System.assertEquals(false, result.success, 'Error must be thrown.');
            
            Test.stopTest();
        }
    }
    private static void createData(){
    	listRecord = DG_TestClassUtilities.createListRecord('Test List');
		insert listRecord;
		
		list<Employee__c> testEmpList = DG_TestClassUtilities.createBulkEmployee(0, 1);
		testEmpList[0].User__c = UserInfo.getUserId();
		insert testEmpList;
		emp1 = testEmpList.get(0);
		            
		testListEmpList = DG_TestClassUtilities.createListEmployee(listRecord.Id, testEmpList, 'Created'); 
		            
		Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
		testTemplate.Template_Type__c = DG_DataUtil.INITIAL;
		insert testTemplate;
		
        attach = new Attachment(Name = 'test doc', body = blob.valueOf('test document body'), parentId = testTemplate.Id);
        
        insert DG_TestClassUtilities.createListTemplateRecord(listRecord.Id, testTemplate.Id);
        
        FFAP_TestClassUtilities.createDocusignRecord();		
    }
}