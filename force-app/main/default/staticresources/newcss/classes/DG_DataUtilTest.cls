// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_DataUtil class
//
// 16 Jan 2014 Manisha Gupta Original
// 04 Feb 2014 Jitendra Kothari Added coverage to new changes 
//
@isTest
private class DG_DataUtilTest {
	static testmethod void dataUtilTest(){
		User testUser = DG_TestClassUtilities.getSystemAdminTempUser();
		system.runAS(testUser){
			List__c testList = DG_TestClassUtilities.createListRecord('Test List');
			testList.Enable_for_Acknowledgement__c = true;
			testList.Document_Display_Name__c ='test';
			insert testList;
			list<Employee__c> testEmpList = DG_TestClassUtilities.createBulkEmployee(0, 100);
			testEmpList[0].User__c = userInfo.getUserId();
			insert testEmpList;
			
			list<List_Employee__c> testListEmpList = DG_TestClassUtilities.createListEmployee(testList.Id, testEmpList, 'Created');	
			insert testListEmpList;
			
		 	Template__c testTemplate = DG_TestClassUtilities.createTemplateRecord();
		 	testTemplate.Template_Type__c = DG_DataUtil.PDF;
		 	insert testTemplate;
		 	
		 	List_Employee_Template__c testListEmpTemp = DG_TestClassUtilities.createListEmployeeTemplateRecord(testListEmpList[0], testTemplate); 
		 	insert testListEmpTemp; 

			
			list<Employee__c> empList = DG_DataUtil.getEmployeeForUser(userInfo.getUserId());
			system.assert(empList.size() <> 0);
			
			empList = DG_DataUtil.getEmployees(new set<Id>{empList[0].Id});
			
			system.assert(empList.size() <> 0);
			
			testList = DG_DataUtil.getListDetails(testList.Id);
			system.assert(testList <> null);
			
			testList.Docusign_Status__c = 'Ready';
			update testList;
			
			testList = DG_Datautil.getListDetailsAvailableForSignature();
			system.assert(testList <> null);
			
			List<List_Employee__c> listEmpList = DG_DataUtil.getListEmployeeRecordsOnEmp(empList[0].Id);
			system.assert(listEmpList.size() == 1);
			
			listEmpList = DG_DataUtil.getListEmployees(testList.Id);
			system.assertEquals(testEmpList.size(), listEmpList.size());
			
			listEmpList = DG_DataUtil.getListEmployeesOnEmpId(testList.Id, empList[0].emp_Id__c);
			system.assert(listEmpList.size() == 1);
			
			listEmpList = DG_DataUtil.getListEmployeesOnListIds(new set<Id>{testList.Id});
			system.assert(listEmpList.size() == testEmpList.size());
			
			list<List_Employee_Template__c> listListEmpTemp = DG_DataUtil.getListEmpTemplatesOnListEmployees(new set<Id>{testListEmpList[0].Id});
			system.assert(listListEmpTemp.size() == 1);
			
			list<List_Employee__c> listListEmp = DG_DataUtil.getListIdOnListEmployees(new set<Id>{testListEmpList[0].Id});
			system.assert(listListEmp.size() == 1);
			
			List<List_Template__c> listTemplate = DG_DataUtil.getListTemplate(testList.Id);
			system.assert(listTemplate.size() == 0);
			
			List<Template__c> listTemp = DG_DataUtil.getTemplates(new set<Id>{testTemplate.Id});
			system.assert(listTemp.size() == 1);
			
			list<Attachment> listAttach = DG_DataUtil.getTemplateAttachment(new set<Id>{testTemplate.Id});
			system.assert(listAttach.size() == 0);
			
			List<List__c> listRecords = DG_DataUtil.getReadyListRecords();
			system.assert(listRecords.size() == 1);
			
			List<List_Template__c> listTemplates = DG_DataUtil.getListTemplateOnType(testList.Id, testTemplate.Template_Type__c);
			system.assert(listTemplates.size()==0);
			
			listTemplates = DG_DataUtil.getListTemplate(new set<Id>{testList.Id});
			system.assert(listTemplates.size()==0);
			
			listTemplates = DG_DataUtil.getListTemplate(testlist.Id);
			system.assert(listTemplates.size()==0);
			
			
			boolean result = DG_DataUtil.checkIfBatchIsAlreadySubmitted('Test class');
            system.assert(!result);
            
            result = DG_DataUtil.checkIfBatchJobScheduled('Test class');
            system.assert(!result);
            
            listEmpList = DG_DataUtil.getListEmployeesOnEmpRecordId(testList.Id, empList[0].Id);
            system.assert(listEmpList.size() == 1);
            
            listEmpList = DG_DataUtil.getListEmployeesForError(listEmpList[0].Id);
            system.assert(listEmpList.size() == 0);
            
            empList = DG_DataUtil.getEmployeesOnEmpId(empList[0].Emp_Id__c);
            system.assert(empList.size() == 1);
            
            List<OrgWideEmailAddress> owaList = DG_DataUtil.getOrgWideEmaillAddresses('Test Email');
            system.assert(owaList.size() == 0);
            
            List<List__c> temp = DG_DataUtil.getListDetailsOnId(testList.Id);
            system.assert(temp.size() == 1);
            
            List<User> userList = DG_DataUtil.getUserDetail(UserInfo.getUserId());
            system.assert(userList.size() == 1);
            
            Integer resultCount = DG_DataUtil.getListWithName('Test List');
            system.assert(resultCount == 1);
            
            /*temp = DG_DataUtil.getListWithNames(new Set<String>{'Test List'});
            system.assert(temp.size() == 1);*/
            
            listEmpList = DG_DataUtil.getListEmployeesFromParentList('All', testlist.Id, '', 1);
            system.assert(listEmpList.size() == 1);
            
            listEmpList = DG_DataUtil.getListEmployeesFromParentList('Test', testlist.Id, '', 1);
            system.assert(listEmpList.size() == 0);
		}
	}
	
}