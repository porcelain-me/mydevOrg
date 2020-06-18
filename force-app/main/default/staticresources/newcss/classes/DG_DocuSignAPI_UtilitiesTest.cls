// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_DocuSignAPI_Utilities
//
// 29 Jan 2014 Manisha Gupta Original
//
@isTest
private class DG_DocuSignAPI_UtilitiesTest { 

	static testmethod void checkDocumentsAndSendForSignatureTest(){
		User testUser = DG_TestClassUtilities.getSystemAdminTempUser();
		system.runAs(testUser){
			Test.StartTest();
			List__c testList = DG_TestClassUtilities.createListRecord('test List');
			testList.Action_Required_By_Date__c = Date.today().addDays(10);
			testList.Email_Subject__c = '[First Name][Last Name] [Name]';
			
			testList.Email_Body__c = 'Test Email Body';
			for(Integer i = 0; i < 100; i++){
				testList.Email_Body__c += ' Test Email Body';
			}
			insert testList;
			
			List<Employee__c> empList = DG_TestClassUtilities.createBulkEmployee(0,10);
			insert empList;
			
			list<List_Employee__c> listListEmp = DG_TestClassUtilities.createListEmployee(testList.Id, empList, 'Created');
			insert listListEmp;
			system.debug('------------------' + listListEmp);
			Template__c template = DG_TestClassUtilities.createTemplateRecord();
			insert template;
			
			List_Template__c listTemp = DG_TestClassUtilities.createListTemplateRecord(testList.Id, template.Id);
			insert listTemp;
			
			Attachment doc = DG_TestClassUtilities.createAttachmentRecord(template.Id);
			doc.Name = 'Test doc.doc';
			insert doc;
			listListEmp = [select Id, Is_Sent_for_Signature__c, List__c, Employee__c, 
		                    list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name, list__r.Email_Body__c,
		                    list__r.Email_Subject__c, list__r.Action_Required_By_Date__c,
		                    Employee__r.Email__c, Employee__r.Emp_id__c, Employee__r.Name, Employee__r.Status__c, 
		                    Employee__r.Docusign_GUID__c, Employee__r.First_Name__c, Employee__r.Last_name__c
		                	from List_Employee__c
		                	where List__c = :testList.Id
		                    and status__c <> 'Sent'];
			DG_DocuSignAPI_Utilities controller = new DG_DocuSignAPI_Utilities(listListEmp, new List<Attachment>{doc});
			String resultString = controller.checkDocumentsAndSendForSignature();
			
            System.assertEquals('Docusign Account is not configured. Please ask your System Administrator to configure.', resultString);            
            
            FFAP_TestClassUtilities.createDocusignRecord();
            resultString = controller.checkDocumentsAndSendForSignature();
            
            System.assertEquals(FFAP_DataUtil.SUCCESS, resultString);
			Test.StopTest();
		}
	}
	
	
	static testmethod void checkDocumentsAndSendForSignatureTest1(){
		User testUser = DG_TestClassUtilities.getSystemAdminTempUser();
		system.runAs(testUser){
			Test.StartTest();
			List__c testList = DG_TestClassUtilities.createListRecord('test List');
			testList.Action_Required_By_Date__c = null;
			testList.Email_Subject__c = null;
			
			testList.Email_Body__c = null;
			insert testList;
			
			List<Employee__c> empList = DG_TestClassUtilities.createBulkEmployee(0,10);
			insert empList;
			
			list<List_Employee__c> listListEmp = DG_TestClassUtilities.createListEmployee(testList.Id, empList, 'Created');
			insert listListEmp;
			system.debug('------------------' + listListEmp);
			Template__c template = DG_TestClassUtilities.createTemplateRecord();
			insert template;
			
			List_Template__c listTemp = DG_TestClassUtilities.createListTemplateRecord(testList.Id, template.Id);
			insert listTemp;
			
			Attachment doc = DG_TestClassUtilities.createAttachmentRecord(template.Id);
			doc.Name = 'Test doc';
			insert doc;
			listListEmp = [select Id, Is_Sent_for_Signature__c, List__c, Employee__c, 
		                    list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name, list__r.Email_Body__c,
		                    list__r.Email_Subject__c, list__r.Action_Required_By_Date__c,
		                    Employee__r.Email__c, Employee__r.Emp_id__c, Employee__r.Name, Employee__r.Status__c, 
		                    Employee__r.Docusign_GUID__c, Employee__r.First_Name__c, Employee__r.Last_name__c
		                	from List_Employee__c
		                	where List__c = :testList.Id
		                    and status__c <> 'Sent'];
			DG_DocuSignAPI_Utilities controller = new DG_DocuSignAPI_Utilities(listListEmp, new List<Attachment>{doc});
			String resultString = controller.checkDocumentsAndSendForSignature();
			
            System.assertEquals('Docusign Account is not configured. Please ask your System Administrator to configure.', resultString);            
            
            FFAP_TestClassUtilities.createDocusignRecord();
            resultString = controller.checkDocumentsAndSendForSignature();
            
            System.assertEquals(FFAP_DataUtil.SUCCESS, resultString);
			Test.StopTest();
		}
	}
}