// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_EmployeeAcknowledgementHome class
//
// 22 Jan 2014 Manisha Gupta Original
//
@isTest
private class DG_EmployeeAcknowledgementHomeTest { 

	static List<List_Employee_Template__c> pendingListEmpTemp;
	static list<List_Employee_Template__c> acceptedListEmpTemp;
	static list<List_Employee_Template__c> declinedListEmpTemp;
	
	static testmethod void testEmpAcknowledgementHome_NoEmployeeForUser(){
		User testUser = DG_TestClassUtilities.createSystemDataDGUser();
		system.runAs(testUser){
			Test.StartTest();
			DG_EmployeeAcknowledgementHome controller = new DG_EmployeeAcknowledgementHome();
			Test.StopTest();
			
		}
	}
	
	static testmethod void testEmpAcknowledgementHome_WithEmployeeForUser(){
		User testUser = DG_TestClassUtilities.createSystemDataDGUser();
		system.runAs(testUser){
			Test.StartTest();
			createTestData();
			DG_EmployeeAcknowledgementHome controller = new DG_EmployeeAcknowledgementHome();
			Test.StopTest();
			
		}
	}
	
	static void createTestData(){
		
		
		List__c testList = DG_TestClassUtilities.createListRecord('Test List');
		testList.Enable_for_Acknowledgement__c = true;
		testList.Document_Display_Name__c = 'test';
		insert testList;
		list<Employee__c> testEmpList = DG_TestClassUtilities.createBulkEmployee(0, 1);
		testEmpList[0].User__c = userInfo.getUserId();
		insert testEmpList;
		
		list<List_Employee__c> testListEmpList = DG_TestClassUtilities.createListEmployee(testList.Id, testEmpList, 'Created');	
		insert testListEmpList;
		
	 	Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
	 	testTemplate.template_Type__c = DG_DataUtil.PDF;
	 	insert testTemplate;
	 	
	 	List_Employee_Template__c testListEmpTemp;
	 	pendingListEmpTemp = new list<List_Employee_Template__c>();
	 	acceptedListEmpTemp = new list<List_Employee_Template__c>();
	 	declinedListEmpTemp = new list<List_Employee_Template__c>();
	 	for(Integer i = 0 ; i<10; i++){
	 		testListEmpTemp = DG_TestClassUtilities.createListEmployeeTemplateRecord(testListEmpList[0], testTemplate); 
	 		pendingListEmpTemp.add(testListEmpTemp);
	 		
	 		testListEmpTemp = DG_TestClassUtilities.createListEmployeeTemplateRecord(testListEmpList[0], testTemplate); 
	 		testListEmpTemp.Document_Accepted_On__c = dateTime.now();
	 		acceptedListEmpTemp.add(testListEmpTemp);
	 		
	 		testListEmpTemp = DG_TestClassUtilities.createListEmployeeTemplateRecord(testListEmpList[0], testTemplate); 
	 		testListEmpTemp.Document_Declined_On__c = dateTime.now();
	 		declinedListEmpTemp.add(testListEmpTemp);
	 	}
	 	
	 	insert pendingListEmpTemp;
	 	insert acceptedListEmpTemp;
	 	insert declinedListEmpTemp;
		
	}
}