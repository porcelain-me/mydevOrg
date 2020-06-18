// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for DG_UtilityClass
//
// 29 Jan 2014 Manisha Gupta Original
//
@isTest
private class DG_UtilityClassTest {

	static testmethod void replaceMergeTextTest(){
		User testUser = DG_TestClassUtilities.getDGTempUser();
		system.runAs(testUser){
			Test.StartTest();
			List<Employee__c> empList = DG_TestClassUtilities.createBulkEmployee(0, 1);
			empList[0].First_Name__c = 'Test';
			empList[0].Last_Name__c = 'Name';
			empList[0].Name = 'Test Name';
			insert empList;
			String replacedText = DG_UtilityClass.replaceMergeText('[First Name][Last Name][Name]', empList[0]);
			system.assert(replacedText == 'TestNameTest Name');
			
			Test.StopTest();
			
		}
	}
	 
	static testmethod void sendCompletedEmailToUserTest(){
		User testUser = DG_TestClassUtilities.getDGTempUser();
		system.runAs(testUser){
			Test.StartTest();
			List__c testList = DG_TestClassUtilities.createListRecord('test list Name');
			testList.Signature_Submittor__c = userInfo.getUserId();
			insert testList;
			
			DG_TestClassUtilities.setAllTriggerOn(userInfo.getuserId());
			DG_UtilityClass.sendCompletedEmailToUser(testList);
			Test.StopTest();
		}
	}
	
	static testmethod void scheduleBatchSentForSignatureTest(){
		User testUser = DG_TestClassUtilities.getDGTempUser();
		system.runAs(testUser){
			Test.StartTest();
			insert DG_TestClassUtilities.createBulkDocusignSettingRecord();
			DG_UtilityClass.scheduleBatchSentForSignature(1, 0);
			DG_UtilityClass.scheduleBatchSentForSignatureForHour(1);
			DG_UtilityClass.scheduleBatchSentForSignatureForMinute(1);
			Test.StopTest();
		}
	}
	
	/*static testmethod void scheduleBatchUserUpdateTest(){
        User testUser = DG_TestClassUtilities.getDGTempUser();
        system.runAs(testUser){
            Test.StartTest();
            insert DG_TestClassUtilities.createBulkDocusignSettingRecord();
            //DG_UtilityClass.scheduleBatchUserUpdate(1, 0, Datetime.now());
            Test.StopTest();
        }
    }*/
	
	static testmethod void populateStatusTest(){
		User testUser = DG_TestClassUtilities.getDGTempUser();
		system.runAs(testUser){
			Test.StartTest();
			DG_UtilityClass.populateStatus(new List_Employee__c(), 'Sent', 'test Error Message');
			Test.StopTest();
		}
	}
}