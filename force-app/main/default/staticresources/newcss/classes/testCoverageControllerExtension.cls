@isTest
public class testCoverageControllerExtension {

	 static testMethod void test1()
	{
		MSET_Account__c c = new MSET_Account__c(Name='test',TNL_ID__c='TNLjhfd');
		Database.SaveResult sr = Database.insert(c);
		PageReference pg= new PageReference('/apex/CoverageUpdate?id1='+sr.id);
		Test.setCurrentPage(pg);
		
		ApexPages.StandardController stdController = new ApexPages.StandardController(new MSET_Account__c()); 
		CoverageControllerExtension cextn = new CoverageControllerExtension(stdController);
		cextn.sendEmail();
		cextn.cancelButton();
		cextn.getPageTitle();
		cextn.getPrimaryCapacity();
		cextn.getRegionList();
		cextn.senEmailCoverageNotification();	
	}
}