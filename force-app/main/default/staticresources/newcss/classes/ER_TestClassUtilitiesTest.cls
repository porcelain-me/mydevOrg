/*
08/23/2013 : RA : ORIGINAL
Description : Test class for ER_TestClassUtilites Class.
*/

@istest
private class ER_TestClassUtilitiesTest {

    static testMethod void TestForTestClassUtilities() {
        User u = ER_TestClassUtilities.getSystemAdminTempUser();
        system.runAs(u) {
            Employee__c emp = ER_TestClassUtilities.createTestEmployee(1, 'UK', 'test', 'MS', 'Test', 'test');
            
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            insert testCase;
            
            Parties_Involved__c party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id);
            insert party;
            
            
            Attachment file = ER_TestClassUtilities.createTestTextAttachment(0, testCase.Id);
            insert file;
            
            ER_TestClassUtilities.createTestResolution(testCase.Id, party.Id);
            ER_TestClassUtilities.createTestRelatedCases(testCase.Id, testCase.Id);
            //ER_TestClassUtilities.createTestCaseNote(testCase.Id, party.Id);
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOFF();
            
        }
    }
    
    static testMethod void TestForTestClassUtilitiescompliance() {
        User u = ER_TestClassUtilities.getComplianceTempUser();
        system.runAs(u) {
            Employee__c emp = ER_TestClassUtilities.createTestEmployee(1, 'UK', 'test', 'MS', 'Test', 'test');
            
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            insert testCase;
            
            Parties_Involved__c party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id);
            insert party;
            
            
            Attachment file = ER_TestClassUtilities.createTestTextAttachment(0, testCase.Id);
            insert file;
            
            ER_TestClassUtilities.createTestResolution(testCase.Id, party.Id);
            ER_TestClassUtilities.createTestRelatedCases(testCase.Id, testCase.Id);
            //ER_TestClassUtilities.createTestCaseNote(testCase.Id, party.Id);
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOFF();
            
        }
    }

static testMethod void TestForTestClassUtilitiesHRtemp() {
        User u = ER_TestClassUtilities.getHRTempUser();
        system.runAs(u) {
            Employee__c emp = ER_TestClassUtilities.createTestEmployee(1, 'UK', 'test', 'MS', 'Test', 'test');
            
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            insert testCase;
            
            Parties_Involved__c party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id);
            insert party;
            
            
            Attachment file = ER_TestClassUtilities.createTestTextAttachment(0, testCase.Id);
            insert file;
            
            ER_TestClassUtilities.createTestResolution(testCase.Id, party.Id);
            ER_TestClassUtilities.createTestRelatedCases(testCase.Id, testCase.Id);
            //ER_TestClassUtilities.createTestCaseNote(testCase.Id, party.Id);
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOFF();
            
        }
    } 

static testMethod void TestForTestClassUtilitiesNonSysAdmin() {
        User u = ER_TestClassUtilities.getNonSystemAdminUser();
        system.runAs(u) {
            Employee__c emp = ER_TestClassUtilities.createTestEmployee(1, 'UK', 'test', 'MS', 'Test', 'test');
            
            Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
            insert department;
            
            Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
            insert testCase;
            
            Parties_Involved__c party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id);
            insert party;
            
            
            Attachment file = ER_TestClassUtilities.createTestTextAttachment(0, testCase.Id);
            insert file;
            
            ER_TestClassUtilities.createTestResolution(testCase.Id, party.Id);
            ER_TestClassUtilities.createTestRelatedCases(testCase.Id, testCase.Id);
            //ER_TestClassUtilities.createTestCaseNote(testCase.Id, party.Id);
            ER_TestClassUtilities.setAllTriggerOn();
            ER_TestClassUtilities.setERPermissionsOFF();
            
        }
    }
}