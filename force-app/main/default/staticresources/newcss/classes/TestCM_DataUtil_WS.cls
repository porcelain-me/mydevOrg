/***********************************************************
Class Name - TestCM_DataUtil_WS 
Author - Urminder Vohra [Appiro-Offshore] 
Created Date - 9/16/2011

***********************************************************/
@isTest
private class TestCM_DataUtil_WS {
     static User usr;
     static List<Campaign__c> campList;
     static Campaign__c testCamp;
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
     
    static testMethod void dataUtilTest() {
         T1C_CustomSettingsManager.setAllTriggerOn();      
        System.runAs(usr) {
            Test.startTest();
            createData();
            
            CM_DataUtil_WS.getStatusSelectOptions();
            CM_DataUtil_WS.getRegionSelectOptions();
            
            //get default campaign from CM_DataUtil_WS class as by default values
            list<CM_DataUtil_WS.CampaignWrapper> defaultCampaigns = CM_DataUtil_WS.getDefaultCampaignsList(); 
            System.assert(11 <= defaultCampaigns.size(),'For the Current User`s profile default campaigns should be greater than or equals to 11');
            //get Active & Inactive Campaigns
            list<CM_DataUtil_WS.CampaignWrapper> activeInactiveCampaigns = CM_DataUtil_WS.getActiveAndInactiveCampaigns();
            System.assert(11 <= activeInactiveCampaigns.size(),'For the Current User`s profile Active campaigns should be greater than or equals to 11');
            
            //get the campaign details by passing the campaign id
            CM_DataUtil_WS.CampaignWrapper fetchedCamp = CM_DataUtil_WS.getCurrentCampaign(testCamp.Id);
            System.assertEquals('New Campaign6', fetchedCamp.Name,'this campaign should be equals to the test campaign inserted');
            //get selected filter campaign 
           // System.assertEquals(1 , CM_DataUtil_WS.getFilteredCampaignsList('Active','EU').size());
            //getting the current user
            User currentUser = CM_DataUtil_WS.getCurrentUser();
            System.assertEquals(usr.id , currentUser.Id,'User Id should be equals to current user`s Id');
            //getting current user`s employee
            CM_DataUtil_WS.getCurrentUserEmployee();
            
            Campaign__c newCamp = [select Id from Campaign__c where Id = :testCamp.Id];
           
            update newCamp;
            
            CM_DataUtil_WS.getCurrentCampaign(null);
            Id upadatedCampId  = CM_DataUtil_WS.getMostRecentActiveCampaign();
            //System.assertEquals(testCamp.Id,upadatedCampId,'Last updated should be testCampaign');
            Test.stopTest();
        }
    }
    
    static testMethod void selectedCampaignInactiveTest() {
         T1C_CustomSettingsManager.setAllTriggerOn();      
        System.runAs(usr) {
            Test.startTest();
            createData();
            
            CM_DataUtil_WS.CampaignWrapper camp = CM_DataUtil_WS.getCurrentCampaign(testCamp.Id);
            System.assertNotEquals(camp, null,'campaign should not be null');                        
            
            testCamp.Status__c = 'Inactive';
            update testCamp;
            
            camp = CM_DataUtil_WS.getCurrentCampaign(testCamp.Id);
            System.assertEquals(camp, null,'campaign should be null');
            
            Test.stopTest();
        }
    }
    public static void createData() {
        T1C_CustomSettingsManager.createChatterSetting();
        CM_TestClassUtilities.SetCamapignLimitSettings();
        
        campList = new List<Campaign__c>();
        
       /* for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Inactive';
            camp.Region__c = 'EU';
            camp.External_Id__c = 'ID_001' + i;
            campList.add(camp);
        }*/
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign2' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Active';
            camp.Region__c = 'JP';
            camp.External_Id__c = 'ID_022' + i;
            campList.add(camp);
        }
        
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign3' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Active';
            camp.Region__c = 'NA';
            camp.External_Id__c = 'ID_033' + i;
            campList.add(camp);
        }
        
       /* for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign4' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Hidden';
            camp.Region__c = 'LA';
            camp.External_Id__c = 'ID_044' + i;
            campList.add(camp);
        }*/
        
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign5' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Completed';
            camp.Region__c = 'LA';
            camp.External_Id__c = 'ID_055' + i;
            campList.add(camp);
        }
        
         testCamp = new Campaign__c();
         testCamp.Name = 'New Campaign6';
         testcamp.Active__c = true;
         //testCamp.Description__c = 'Test Desc';
         testCamp.Status__c = 'Active';
         testCamp.Region__c = 'EU';
         testCamp.External_Id__c = 'ID_066';
         campList.add(testCamp);
        
        
        insert campList;
        
    }
}