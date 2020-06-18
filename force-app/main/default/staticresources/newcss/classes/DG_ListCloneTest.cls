// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_DataUtil class
//
// 13 Jan 2014 Manisha Gupta Original
//
@isTest
private class DG_ListCloneTest {
	
	static List__c testList;
	static List<Employee__c> testEmpList;
	static List<List_Employee__c> testListEmpList;
	static Template__c testTemplate;
	static List_Template__c testListTemplate;
	
	static testmethod void testListClone_allRecords(){
		Test.StartTest();
		createTestData('All');
		Test.setCurrentPage(Page.DG_ListClone);
		ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testList);
		DG_ListClone controller = new DG_ListClone(stdController);
		controller.clonedList.clone_List_For__c = 'All Records';
		controller.clonedList.Name = 'Test List';
		controller.clonedList.Document_Display_Name__c ='test';
		controller.cloneRecord();
		Id clonedListId = controller.clonedList.Id;		
        system.assertEquals(null, clonedListId, 'Cloned list Id must be null');
        
        controller.clonedList.Name = 'New Test List';	
        controller.clonedList.Document_Display_Name__c ='teste';
		controller.cloneRecord();
		clonedListId = controller.clonedList.Id;
        controller.navigateToClonedListRecord();
        DG_ListClone.cloneListEmployees('', controller.clonedList.Id, testList.Id, 'All');
		Test.StopTest();
		
		Integer clonedListEmployeeCount = [Select count() from List_Employee__c where List__c = :clonedListId];
		system.assertEquals(true, clonedListId <> null, 'Cloned list Id must not be null');
		
		system.assertEquals(testListEmpList.size(), clonedListEmployeeCount, 'Cloned list employee record count must match');
	}
	
	
	static testmethod void testListClone_failedRecords(){
		Test.StartTest();
		createTestData('Failed');
		Test.setCurrentPage(Page.DG_ListClone);
		ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testList);
		DG_ListClone controller = new DG_ListClone(stdController);
		controller.clonedList.clone_List_For__c = 'Error Records';
		controller.cloneRecord();
		Id clonedListId = controller.clonedList.Id;
		controller.navigateToClonedListRecord();
		DG_ListClone.cloneListEmployees('', controller.clonedList.Id, testList.Id, 'Failed');
		Test.StopTest();
		
		Integer clonedListEmployeeCount = [Select count() from List_Employee__c where List__c = :clonedListId];
		system.assertEquals(true, clonedListId <> null, 'Cloned list Id must not be null');
		
		system.assertEquals(testListEmpList.size(), clonedListEmployeeCount, 'Cloned list employee record count must match');
	}
	
	static testmethod void testListClone_declinedRecords(){
		Test.StartTest();
		createTestData('Declined');
		Test.setCurrentPage(Page.DG_ListClone);
		ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testList);
		DG_ListClone controller = new DG_ListClone(stdController);
		controller.clonedList.clone_List_For__c = 'Decline Records';
		controller.cloneRecord();
		Id clonedListId = controller.clonedList.Id;
		controller.navigateToClonedListRecord();
		DG_ListClone.cloneListEmployees('', controller.clonedList.Id, testList.Id, 'Declined');
		Test.StopTest();
		
		Integer clonedListEmployeeCount = [Select count() from List_Employee__c where List__c = :clonedListId];
		system.assertEquals(true, clonedListId <> null, 'Cloned list Id must not be null');
		
		system.assertEquals(testListEmpList.size(), clonedListEmployeeCount, 'Cloned list employee record count must match');
	}
	
	static testmethod void testListClone_deleteClonedListRecord(){
		Test.StartTest();
		createTestData('Declined');
		Test.setCurrentPage(Page.DG_ListClone);
		ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testList);
		DG_ListClone controller = new DG_ListClone(stdController);
		controller.clonedList.clone_List_For__c = 'Decline Records';
		controller.cloneRecord();
		Id clonedListId = controller.clonedList.Id;
		controller.deleteClonedListRecord();
		Test.StopTest();
		
		List<List__c> clonedList = [Select Id from List__c where Id = :clonedListId];
		system.assertEquals(0, clonedList.size(), 'List has been deleted');
		
	}
		
	
	static void createTestData(String status){
		testList = DG_TestClassUtilities.createListRecord('Test List');
		insert testList;
		testEmpList = DG_TestClassUtilities.createBulkEmployee(0, 100);
		insert testEmpList;
		if(status == 'All'){
			testListEmpList = DG_TestClassUtilities.createListEmployee(testList.Id, testEmpList, 'Created');	
		}else{
			testListEmpList = DG_TestClassUtilities.createListEmployee(testList.Id, testEmpList, status);
		}
		
		insert testListEmpList;
		
	 	testTemplate = DG_TestClassUtilities.createTemplateRecord();
	 	insert testTemplate;
	 	
	 	testListTemplate = DG_TestClassUtilities.createListTemplateRecord(testList.Id, testTemplate.Id);
	 	insert testListTemplate;
		
		
	}
}