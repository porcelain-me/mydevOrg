//
//  07/19/2013 RJ: Test class for ER_SearchCases controller
//
//
//
//
@isTest
private class ER_SearchCasesTest {
	
	static testmethod void searchCasesTest_NoAccess(){
		User thisUser = ER_TestClassUtilities.getSystemAdminTempUser();
        system.runAs(thisUser){
        	Test.startTest();
        	ER_TestClassUtilities.createSearchPermissions(false, false);
        	ER_SearchCases searchCase = new ER_SearchCases();
        	searchCase.validatePermission();
        	system.assertEquals(false, searchCase.isCompliance);
        	system.assertEquals(false, searchCase.isHR);
        	Test.StopTest();
        }
	}
    static testMethod void searchCasesTest_Compliance() {
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        system.runAs(thisUser){
        	Test.startTest();
        	ER_TestClassUtilities.createSearchPermissions(true, false);
        	Employee__c emp = ER_TestClassUtilities.createTestEmployee(0, 'USA', 'SSB', 'MSSB', 'Managing Director', '00');
        	insert emp;
        	Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'SSB');
	    	insert department;
        	Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
        	testCase.Investigator__c = emp.Id;
        	testCase.Discipline_Type__c = 'Other';
        	testCase.Category__c = 'test';
        	insert testCase;
        	
        	Parties_Involved__c party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id); 
        	party.Role__c = 'Subject Of Complaint/Issue';
        	insert party;
        	
        	ER_SearchCases searchCase = new ER_SearchCases();
        	searchCase.validatePermission();
        	system.assertEquals(true, searchCase.isCompliance);
        	system.assertEquals(false, searchCase.isHR);
        	
        	searchCase.searchCases();
        	system.assertEquals(0,searchCase.listCases.size());
        	
        	searchCase.rCases.Related_Case__c = testCase.Id;
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.rCases.Related_Case__c = null;
        	searchCase.PartyInvolved.Party_Name__c = 'Test';
        	searchCase.PartyInvolved.Role__c = 'Subject Of Complaint/Issue';
        	searchCase.val = 'external';
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.PartyInvolved.Party_Name__c = null;
        	searchCase.erCase.Subject__c = 'test';
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.erCase.Subject__c = null;
        	searchCase.erCase.Status__c = 'open';
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.erCase.Status__c = null;
        	searchCase.erCase.OwnerId = userInfo.getUserId();
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.erCase.OwnerId = null;
        	searchCase.erCase.investigator__c = emp.Id;
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.erCase.Investigator__c = null;
        	searchCase.erCase.Discipline_Type__c = 'Other';
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.erCase.Discipline_Type__c = null;
        	searchCase.erCase.Reported_Date__c = Date.today();
        	// no result will be returned as both reported start date and end date are required.
        	searchCase.searchCases();
        	system.assertEquals(0,searchCase.listCases.size());
        	searchCase.erCase1.Reported_Date__c = Date.today().addDays(1);
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	Test.stopTest();
        	
        }
    }
    static testMethod void searchCasesTest_HR() {
	    User thisUser = ER_TestClassUtilities.getHRTempUser();
	    system.runAs(thisUser){
	    	Test.startTest();
	    	ER_TestClassUtilities.createSearchPermissions(false, true);
	    	Employee__c emp = ER_TestClassUtilities.createTestEmployee(0, 'USA', 'SSB', 'MSSB', 'Managing Director', '00');
	    	insert emp;
	    	Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'SSB');
	    	insert department;
	    	Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
	    	testCase.Investigator__c = emp.Id;
	    	testCase.Discipline_Type__c = 'Other';
	    	testCase.EEO_Issue__c = 'test';
	    	testCase.Category__c = 'test';
	    	insert testCase;
	    	Parties_Involved__c party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id); 
        	party.Role__c = 'Person Raising Issue';
        	insert party;
	    	ER_SearchCases searchCase = new ER_SearchCases();
	    	searchCase.validatePermission();
	    	system.assertEquals(false, searchCase.isCompliance);
	    	system.assertEquals(true, searchCase.isHR);
	    	
	    	searchCase.searchCases();
	    	system.assertEquals(0,searchCase.listCases.size());
	    	
	    	searchCase.rCases.Related_Case__c = testCase.Id;
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.rCases.Related_Case__c = null;
	    	searchCase.erCase.department__c = department.Id;
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.department__c = null;
        	searchCase.PartyInvolved.Party_Name__c = 'Test';
        	searchCase.val = 'external';
        	searchCase.PartyInvolved.Role__c = 'Any';
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
        	
        	searchCase.PartyInvolved.Party_Name__c = null;
        	searchCase.erCase.Subject__c = 'test';
        	searchCase.searchCases();
        	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.Subject__c = null;
	    	searchCase.erCase.Status__c = 'open';
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.Status__c = null;
	    	searchCase.erCase.OwnerId = userInfo.getUserId();
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.OwnerId = null;
	    	searchCase.erCase.EEO_Issue__c = 'test';
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.EEO_Issue__c = null;
	    	searchCase.erCase.Discipline_Type__c = 'Other';
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.Discipline_Type__c = null;
	    	searchCase.erCase.Category__c = 'test';
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.Status__c = null;
	    	searchCase.erCase.Reported_Date__c = Date.today().addDays(-1);
	    	searchCase.searchCases();
	    	system.assertEquals(0,searchCase.listCases.size());// no result will be returned as both incident start date and end date are required.
	    	searchCase.erCase1.Reported_Date__c = Date.today().addDays(1);
	    	searchCase.searchCases();
	    	system.assertEquals(1,searchCase.listCases.size());
	    	
	    	searchCase.erCase.Status__c = null;
            searchCase.erCase.Incident_Date__c = Date.today().addDays(-1);
            searchCase.searchCases();
            system.assertEquals(0,searchCase.listCases.size());// no result will be returned as both incident start date and end date are required.
            searchCase.erCase1.Incident_Date__c = Date.today().addDays(1);
            searchCase.searchCases();
            system.assertEquals(1,searchCase.listCases.size());
	    	
	    	Pagereference pg = searchCase.exportResults();
	    	system.assertEquals(true, pg!=null);
	    	Test.stopTest();
	    	
	    }
    }
}