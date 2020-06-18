// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_TestClassUtilities class
//
// 16 Jan 2014 Manisha Gupta Original
//
@isTest
private class DG_TestClassUtilitiesTest {
	
	static testmethod void createBulkEmployeeTest(){
		Test.StartTest();
		list<Employee__c> empList = DG_TestClassUtilities.createBulkEmployee(0, 100);
		system.assertEquals(100, empList.size());
		Test.StopTest();
	}
	
	static testmethod void createListRecordTest(){
		Test.StartTest();
		List__c testList = DG_TestClassUtilities.createListRecord('Test List');
		testList.Document_Display_Name__c = 'test';
		system.assertEquals('Test List', testList.Name);
		Test.StopTest();		
	}
	
	static testmethod void createListEmployeeTest(){
		Test.StartTest();
		list<Employee__c> empList = DG_TestClassUtilities.createBulkEmployee(0, 100);
		insert empList;
		
		List__c testList = DG_TestClassUtilities.createListRecord('Test List');
		testList.Document_Display_Name__c	= 'test';
		insert testList;
		
		List<List_Employee__c> testListEmp = DG_TestClassUtilities.createListEmployee(testList.Id, empList, 'Failed');
		system.assertEquals(empList.size(), testListEmp.size());
		
		Test.StopTest();
	}
	
	
	static testmethod void createTemplateRecordTest(){
		Test.StartTest();
		Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
		
		system.assertEquals(true, testTemplate <> Null);
		Test.StopTest();
	}
	
	static testmethod void createListTemplateRecordTest(){
		Test.StartTest();
		List__c testList = DG_TestClassUtilities.createListRecord('test List');
		testList.Document_Display_Name__c	= 'test';
		insert testList;
		Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
		insert testTemplate;
		List_Template__c testListTemplate = DG_TestClassUtilities.createListTemplateRecord(testList.Id, testTemplate.Id);
		system.assertEquals(true, testListTemplate <> Null);
		Test.StopTest();
	}
}