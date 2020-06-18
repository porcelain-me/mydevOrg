@isTest
public class TestCampaignUserLoginAsViewController {
	
	static testmethod void LoginAsViewTest(){
		Test.startTest();
		List<Profile> testUserProfile = [SELECT Id FROM Profile WHERE name='All MS Employee' ];
        User adminUser = new User(alias = 'test', email = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = testUserProfile[0].Id,                                 
                                 timezonesidkey = 'America/Los_Angeles', username = 'T'+String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','')+Integer.valueOf(math.rint(math.random()*1000000))+ '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test1', isActive = true);
        insert adminUser;
        
        User oboUser = new User(alias = 'test2', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing1',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = testUserProfile[0].Id,                                 
                                 timezonesidkey = 'America/Los_Angeles', username = 'T'+String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','')+Integer.valueOf(math.rint(math.random()*1000000))+ '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test2', isActive = true);
        insert oboUser;
        
        
		List<PermissionSet> lstPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE Name IN ('GPS_Campaign_Permission_Set','IIFanClub_Permission_Set','IICampaign_Permission_Set')];
		
		if(lstPermissionSet.size() > 0){
			PermissionSetAssignment obj = new PermissionSetAssignment(AssigneeId = adminUser.Id, PermissionSetId = lstPermissionSet[0].Id);
			insert obj;
		}
		system.runAs(adminUser){
			CampaignUserLoginAsViewController loginAs = new CampaignUserLoginAsViewController();
			CampaignUserLoginAsViewController.createRecordofGPSCampaignLoggedIn(oboUser.Id);
		}
		
		
		
		
		Test.stopTest();	
	}
	
	
}