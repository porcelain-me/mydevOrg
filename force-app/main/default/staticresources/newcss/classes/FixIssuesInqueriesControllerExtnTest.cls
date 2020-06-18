@isTest()
public class FixIssuesInqueriesControllerExtnTest {
	
	
	public static testMethod void test_1()
	{
		PageReference pageRef = Page.Fix_Issues_Inqueries;
		Test.setCurrentPageReference(pageRef);
	
		FIX_Issues_Inquiries__c testFI_1 = new FIX_Issues_Inquiries__c();
		ApexPages.StandardController fi_cont = new ApexPages.StandardController(testFI_1);
		FIX_Issues_Inquiries__c firequest = (FIX_Issues_Inquiries__c) fi_cont.getRecord();
		insert firequest;	
	}
	
	

}