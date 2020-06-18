/***********************************************************
Class Name - TestCM_Milestones 
Author - Urminder Vohra [Appiro-Offshore]
Created Date - 9/21/2011

***********************************************************/ 
@isTest
private class TestCM_Milestones {

    static Campaign__c camp;
    static User usr;
    
   
   static{
        // temp user
       //usr =   CM_TestClassUtilities.getTempUser();
       usr = getTempUser();
    }
    
    static User getTempUser(){
    
        Profile p = [select id from Profile where Name = 'All MS Employee'];
        
        User u = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, 
                                 Short_Id__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 Emp_Id__c = 'test1', isActive = true);
        return u;
     }  
    
    static testMethod void myUnitTest() {
        T1C_CustomSettingsManager.setAllTriggerOn(); 
       System.runAs(usr) {
           Test.startTest();
           createData();
           CM_Milestones controller = new CM_Milestones();
           controller.milestoneParentId = camp.id;
           controller.init();
           //as two milestones are there so next milestone is not null
           System.assertNotEquals(controller.nextMilestone , null,'As two milestones are there so next milestone should not be null');
           //all milestones are 2
           System.assertEquals(controller.milestoneList.size() , 2 , 'Total milestones should be equals to 2');
           Test.stopTest();
       }
       
    }
    static void createData() {
            T1C_CustomSettingsManager.createChatterSetting(); 
            CM_TestClassUtilities.SetCamapignLimitSettings();
            camp = new Campaign__c();
            camp.Name = 'Test Campaign';
            camp.Status__c = 'Active';
            camp.Region__c = 'EU';
            camp.External_Id__c = 'ID_001';
            insert camp;
            
               
            // Creating Task for showing in Activity History Section
           Campaign_Milestone__c milestone = new Campaign_Milestone__c();
           milestone.Campaign__c = camp.Id;
           milestone.Name = 'First Milestone';
           milestone.Date__c = date.today();
           milestone.Description__c = 'Test description';
           insert milestone;
           
           Campaign_Milestone__c nextMilestone = new Campaign_Milestone__c();
           nextMilestone.Campaign__c = camp.Id;
           nextMilestone.Name = 'Next Milestone';
           nextMilestone.Date__c = date.today().addDays(1);
           nextMilestone.Description__c = 'Test description2';
           insert nextMilestone;
            
    }
}