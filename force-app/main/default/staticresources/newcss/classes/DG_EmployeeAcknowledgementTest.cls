// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_EmployeeAcknowledgement class
//
// 21 Jan 2014 Manisha Gupta Original
//
@isTest
private class DG_EmployeeAcknowledgementTest {

	static List_Employee_Template__c testListEmpTemp;
	
	static testmethod void EmployeeAcknowledgementTest(){
		User testUser = DG_TestClassUtilities.getDGTempUser();
		system.runAs(testUser){
			Test.StartTest();
			createTestData();
			Test.setCurrentPage(Page.DG_EmployeeAcknowledgement);
			DG_EmployeeAcknowledgement controller = new DG_EmployeeAcknowledgement();
			
			ApexPages.CurrentPage().getParameters().put('listEmpTempId', testListEmpTemp.Id);
			controller = new DG_EmployeeAcknowledgement();
			
			Attachment doc = DG_TestClassUtilities.createAttachmentRecord(testListEmpTemp.Template__c);
	 		insert doc;
			controller = new DG_EmployeeAcknowledgement();
			controller.updateLastViewedOn();
			testListEmpTemp = [Select List_Employee__c, Template__c, Template__r.Name, Document_Declined_On__c, 
														   Document_Accepted_On__c , Document_Last_Viewed_On__c
														   from List_Employee_Template__c 
														   where Id = :testListEmpTemp.Id];
			system.assert(testListEmpTemp.Document_Last_Viewed_On__c <> Null);
			system.assert(testListEmpTemp.Document_Accepted_On__c == Null);
			system.assert(testListEmpTemp.Document_Declined_On__c == Null);
			
			// test accept
			controller.accept();
			testListEmpTemp = [Select List_Employee__c, Template__c, Template__r.Name, Document_Declined_On__c, 
														   Document_Accepted_On__c , Document_Last_Viewed_On__c
														   from List_Employee_Template__c 
														   where Id = :testListEmpTemp.Id];
			system.assert(testListEmpTemp.Document_Last_Viewed_On__c <> Null);
			system.assert(testListEmpTemp.Document_Accepted_On__c <> Null);
			system.assert(testListEmpTemp.Document_Declined_On__c == Null);
			
			controller.decline();
			testListEmpTemp = [Select List_Employee__c, Template__c, Template__r.Name, Document_Declined_On__c, 
														   Document_Accepted_On__c , Document_Last_Viewed_On__c
														   from List_Employee_Template__c 
														   where Id = :testListEmpTemp.Id];
			system.assert(testListEmpTemp.Document_Last_Viewed_On__c <> Null);
			system.assert(testListEmpTemp.Document_Accepted_On__c == Null);
			system.assert(testListEmpTemp.Document_Declined_On__c <> Null);
			Test.StopTest();
		}
	}
	
	static void createTestData(){
		List__c testList = DG_TestClassUtilities.createListRecord('Test List');
		insert testList;
		list<Employee__c> testEmpList = DG_TestClassUtilities.createBulkEmployee(0, 100);
		insert testEmpList;
		
		list<List_Employee__c> testListEmpList = DG_TestClassUtilities.createListEmployee(testList.Id, testEmpList, 'Created');	
		insert testListEmpList;
		
	 	Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
	 	insert testTemplate;
	 	
	 	testListEmpTemp = DG_TestClassUtilities.createListEmployeeTemplateRecord(testListEmpList[0], testTemplate); 
	 	insert testListEmpTemp; 
		
		
	}
}