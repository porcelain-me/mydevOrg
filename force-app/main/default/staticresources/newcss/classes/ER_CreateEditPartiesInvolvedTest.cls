/*
08/07/2013 : Jitendra : ORIGINAL
Description : Test class for ER_CreateEditPartiesInvolved Class.
*/

@isTest
private class ER_CreateEditPartiesInvolvedTest {
    static testmethod void testGetPartiesInvolvedFiles(){
        User thisUser = ER_TestClassUtilities.getComplianceTempUser();
        
        system.runAs(thisUser) {
	        Test.StartTest();
	        
	        ER_TestClassUtilities.setAllTriggerOn();
	        
	        Org_Codes__c department = ER_TestClassUtilities.createTestOrgCode('Department', 'Test Department');
	        insert department;
	        
	        Case__c testCase = ER_TestClassUtilities.createTestCase(0, department.Id);
	        insert testCase;
	        Parties_Involved__c party = ER_TestClassUtilities.createTestPartiesInvolved_External(0, testCase.Id);
	        insert party;
	        Employee__c emp = ER_TestClassUtilities.createTestEmployee(1, 'USA', '123#1', 'MSSB', 'Managing Director', '1');
	        emp.Login_Id_Directory__c = 'empTest1';
	        insert emp;
	        
	        RecordType rt = [Select Id from RecordType where Name='Compliance' limit 1];
	        
	        Test.setCurrentPage(Page.ER_CreateEditPartiesInvolved);
	        ApexPages.currentPage().getParameters().put('_lkid', testCase.Id);  
	        ApexPages.currentPage().getParameters().put('id', null);
	        ApexPages.StandardController piStdController = new ApexPages.StandardController(new Parties_Involved__c());
	        
	        ER_CreateEditPartiesInvolved controller = new ER_CreateEditPartiesInvolved(piStdController);
	        controller.cancel();
	        controller.partiesInvolved.Person__c = null;
	        controller.getEmployeeDetails();
	        
	        controller.partiesInvolved.Person__c = emp.Id;
	        controller.getEmployeeDetails();
	        controller.saveData();
	        
	        ApexPages.currentPage().getParameters().put('id', party.Id); 
	        ApexPages.currentPage().getParameters().put('_lkid', testCase.Id);
	        if(rt <> null){
	        	ApexPages.currentPage().getParameters().put('RecordType', rt.Id);
	        }
	        piStdController = new ApexPages.StandardController(party);
	        controller = new ER_CreateEditPartiesInvolved(piStdController);
	        controller.cancel();
	        try{
	            controller.partiesInvolved.Is_Person_External__c = true;
	            controller.saveData();
	        }catch(DMLException ex){
	            
	        }
	        Test.StopTest();
        }
    }
}