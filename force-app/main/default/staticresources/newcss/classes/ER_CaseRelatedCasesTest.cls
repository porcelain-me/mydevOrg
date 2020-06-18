// 09/19/2013 : MG : Test Class for ER_CaseRelatedCases Class.
@isTest
private class ER_CaseRelatedCasesTest {
	static testmethod void caseRelatedCasesTest(){
		
		User testUser = ER_TestClassUtilities.getHRTempUser();
		system.runas(testUser){
			Test.StartTest();
			Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'test Department');
			insert department;
			List<Case__c> listCases = new List<Case__c>(); 
			listCases.add(ER_TestClassUtilities.createTestCase(0, department.Id));
			listCases.add(ER_TestClassUtilities.createTestCase(1, department.Id));
			insert listCases;
			
			Related_Cases__c relatedCase = ER_TestClassUtilities.createTestRelatedCases(listCases[0].Id, listCases[1].Id);
			insert relatedCase;
			
			ApexPages.StandardController caseStd = new ApexPages.Standardcontroller(listCases[0]);
			
			ER_CaseRelatedCases controller = new ER_CaseRelatedCases(caseStd);
			system.assertEquals(1, controller.getRelatedCasesList().size());
			
			caseStd = new ApexPages.Standardcontroller(listCases[1]);
			
			controller = new ER_CaseRelatedCases(caseStd);
			system.assertEquals(1, controller.getRelatedCasesList().size());
			
			controller.relatedCaseIdToDelete = relatedCase.Id;
			controller.deleteRelatedCase();
			
			system.assertEquals(0, controller.getRelatedCasesList().size());
			
			Test.StopTest();
		}
		
	}
}