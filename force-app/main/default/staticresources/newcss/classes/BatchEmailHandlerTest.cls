@isTest(SeeAllData = false)
private class BatchEmailHandlerTest {
    private static User sysUser;
    private static Employee__c emp1;
    private static testmethod void testEmailHandler(){
        sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();
            /*FFAP_Email_Handler emailHandler = new FFAP_Email_Handler();
            Messaging.InboundEmail email = new Messaging.InboundEmail();
            emailHandler.handleInboundEmail(email, null);
            
            email.subject = FFAP_DataUtil.EMAIL_SUBJECT_START + 'NOEMP';
            emailHandler.handleInboundEmail(email, null);            
            
            email.subject = FFAP_DataUtil.EMAIL_SUBJECT_START + emp1.Emp_Id__c;
            emailHandler.handleInboundEmail(email, null);*/
            
            Test.stopTest();
        }
    }
    private static void createData(){
        //Docusign Data
        FFAP_TestClassUtilities.createDocusignRecord();
        FFAP_TestClassUtilities.createDocusignTemplate();
        //Employee
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST002', '600097', 'Branch Manager', 'TestJobLevelDesc', 'TestJobLevel');
        emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        empList.add(emp1);
        empList.add(emp2);
        insert empList;
        
        emp1.Manager__c = emp2.Id;
        update emp1;
    }
}