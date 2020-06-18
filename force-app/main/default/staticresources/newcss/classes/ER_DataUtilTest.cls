//
//
//08/23/2013 : MG : Test class for ER_DataUtil.cls
//
//
@isTest
private class ER_DataUtilTest {

    static testmethod void getCaseStatus_Test(){
        User thisUser = ER_TestClassUtilities.getSystemAdminTempUser();
        
        system.runAs(thisUser) {
	        Test.startTest();
	        
	        List<Case__c> listCases = ER_DataUtil.getCaseStatus(new list<String>());
	        system.assertEquals(0, listCases.size());
	        
	        Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Super Division', 'Test Super Division'); 
	        insert department;
	        Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
	        insert testCase;
	        
	        listCases = ER_DataUtil.getCaseStatus(new list<String>{testCase.Id});
	        system.assertEquals(1, listCases.size());
	        
	        Case__c cs = ER_DataUtil.getCaseDetails(testCase.Id);
	        system.assertEquals(true, cs <> null);
	        Test.stopTest();
        }
    }
    
    static testmethod void getPartiesInvoled_getPartiesInvoledDetails_Test(){
        User thisUser = ER_TestClassUtilities.getSystemAdminTempUser();
        
        system.runAs(thisUser) {
	        Test.StartTest();
	        
	        List<Parties_Involved__c> listPartieInvolved = ER_DataUtil.getPartiesInvoled(new List<String>());
	        system.assertEquals(0, listPartieInvolved.size());
	        
	        listPartieInvolved = ER_DataUtil.getPartiesInvoledDetails(new List<String>());
	        system.assertEquals(0, listPartieInvolved.size());
	        
	        Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Super Division', 'Test Super Division'); 
	        insert department;
	        Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
	        insert testCase;
	        
	        Parties_Involved__c partyInvolved = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id);
	        insert partyInvolved;
	        
	        listPartieInvolved = ER_DataUtil.getPartiesInvoled(new List<String>{partyInvolved.Id});
	        system.assertEquals(1, listPartieInvolved.size());
	        
	        listPartieInvolved = ER_DataUtil.getPartiesInvoledDetails(new List<String>{partyInvolved.Id});
	        system.assertEquals(1, listPartieInvolved.size());
	        
	        Test.StopTest();
        }
    }
    
    /*static testmethod void getSystemGeneratedPartiesInvolvedIdsOnCaseIdsTest(){
    	User thisUser = ER_TestClassUtilities.getSystemAdminTempUser();
        
        system.runAs(thisUser) {
	        Test.StartTest();
	        Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Super Division', 'Test Super Division'); 
	        insert department;
	        Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
	        insert testCase;
	        
	        Set<Id> partyIds = ER_DataUtil.getSystemGeneratedPartiesInvolvedIdsOnCaseIds(new list<String>{testcase.id});
	        system.assertEquals(1, partyIds.size());
	        Test.StopTest();
        }
    }*/
    
    static testmethod void getEmployeeTest(){
    	User thisUser = ER_TestClassUtilities.getSystemAdminTempUser();
        
        system.runAs(thisUser) {
	    	Test.StartTest();
	    	Employee__c emp = ER_TestClassUtilities.createTestEmployee(0, 'USA', 'SSB', 'MSSB', 'Managing Direcotor', '00');
	    	insert emp;
	    	List<Employee__c> empList = ER_DataUtil.getEmployee(emp.Id);
	    	system.assertEquals(1, empList.size());
	    	Test.StopTest();
        }
    }
    
    static testmethod void getRelatedCasesOnCaseIdTest(){
    	User thisUser = ER_TestClassUtilities.getSystemAdminTempUser();
        
        system.runAs(thisUser) {
	        Test.startTest();
	        
	        Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'test Department');
			insert department;
			
	        List<Case__c> listCases = new List<Case__c>(); 
			listCases.add(ER_TestClassUtilities.createTestCase(0, department.Id));
			listCases.add(ER_TestClassUtilities.createTestCase(1, department.Id));
			insert listCases;
			
			Related_Cases__c relatedCase = ER_TestClassUtilities.createTestRelatedCases(listCases[0].Id, listCases[1].Id);
			insert relatedCase;
			
			List<Related_Cases__c> listRC = ER_DataUtil.getRelatedCasesOnCaseId(listCases[0].Id);
			system.assertEquals(1, listRC.size());
	        
	        Test.StopTest();
        }
    }
    
}