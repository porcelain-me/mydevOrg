// Description : Test Class for ER_CaseManager.cls
// 10/04/2013 : MG : Test failure fixes for ER Changes.
// 10/23/2013 : MG : Removed test case for Category validation.
@isTest
private class ER_CaseManagerTest {
    static testMethod void Test_handleTrigger_HR() {       
        User thisUser = ER_TestClassUtilities.getHRTempUser();
        
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOff();
            
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
        
            Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            
            try{
                testCase.Category__c = null;
                testCase.Status__c = 'Closed';
                insert testCase;
            }catch(Exception ex){
                System.Assert(ex.getMessage().contains(Label.ER_CaseStatusOpenForHR));
            }
            
            testCase.Status__c = 'Open';
            insert testCase;
            System.AssertNotEquals(NULL, testCase.Id, 'Case should be inserted.');
            
            List<Parties_Involved__c> listPIs = [Select Id from Parties_Involved__c where Case__c = : testCase.Id];
            System.AssertEquals(0, listPIs.size(), 'No PI record should exist for Case');
            
            Test.StopTest();
        }
    }   
    
    static testMethod void Test_handleTrigger_Compliance() {       
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        
        system.runAs(thisUser) {
            Test.StartTest();
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOff();
            
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
        
            Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            
            try{
	            testCase.Category__c = null;
	            testCase.Status__c = 'Closed';
	            insert testCase; 
            }catch(exception ex){
            	System.Assert(ex.getMessage().contains(Label.ER_CaseCanNotCreateWithClosed));
            }        
            testCase.Status__c = 'Closed with Follow-up';
            insert testCase;
            
            system.assertEquals('Closed with Follow-up', testCase.Status__c);
            
            System.AssertNotEquals(NULL, testCase.Id, 'Case should be inserted.');
            
            
            List<Parties_Involved__c> listPIs = [Select Id from Parties_Involved__c where Case__c = : testCase.Id];
            System.AssertEquals(0, listPIs.size(), 'No PI record should exist for Case');
            
            Test.StopTest();
        }
    }   
}