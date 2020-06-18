// 09/30/2011 RJ: ORIGINAL
//                Test class for CM_ApplicationConfigManager Class.
// 10/21/2011 RJ: Updated the test class to add getCampaignConfigurationTest
@isTest
private class TestCM_ApplicationConfigManager {
       
      static User usr;    
      static {
            // Commented and Added following lines by Aditya To improve test Class performance Jira : 4438.
            //usr = CM_TestClassUtilities.getTempUser();
            usr = CM_TestClassUtilities.getAdminUser()[0];
      }

    
    static testMethod void getApplicationConfigForAnalystTest() {
         
        System.runAs(usr){
        // Added following lines by Aditya To improve test Class performance Jira : 4438.
            T1C_CustomSettingsManager.setAllTriggerOn();
            T1C_CustomSettingsManager.createChatterSetting(); 
            Test.startTest();
            // Analyst Employee..
          GPSEmployee__c e = new GPSEmployee__c();
            e.Name = 'test';
            e.Division__c = 'Research';
            e.MS_ID__c = 'testSEFR';        
            e.Is_Producer_Employee__c = true;
            e.Active_Flag__c = true;
            insert e;
          List<CM_Campaigns_WS.GridConfig> lst = CM_ApplicationConfigManager.getApplicationConfig();
          System.assertEquals(lst.size(), 2, 'There should be 2 items in the list');
          System.assertEquals(lst[0].Name, 'CampaignMembers', 'First Item should be config for CampaignMembers list');
          System.assertEquals(lst[1].Name, 'IncomingRequests', 'Second Item should be config for CampaignMembers list');
          
          
          
          Test.stopTest();
        }
    }
    
    static testMethod void getApplicationConfigForNonAnalystTest() {
        
        System.runAs(usr){
        // Added following lines by Aditya To improve test Class performance Jira : 4438.
            T1C_CustomSettingsManager.setAllTriggerOn();
            T1C_CustomSettingsManager.createChatterSetting(); 
          Test.startTest();
          // Non Analyst Employee
          GPSEmployee__c e = new GPSEmployee__c();
          e.Name = 'test';
          e.Division__c = 'Nothing';
          e.MS_ID__c = 'testSEFR';        
          e.Is_Producer_Employee__c = false;
          e.Active_Flag__c = true;
          insert e;
          List<CM_Campaigns_WS.GridConfig> lst = CM_ApplicationConfigManager.getApplicationConfig();
          System.assertEquals(lst.size(), 2, 'There should be 2 items in the list');
          System.assertEquals(lst[0].Name, 'CampaignMembers', 'First Item should be config for CampaignMembers list');
          System.assertEquals(lst[1].Name, 'IncomingRequests', 'Second Item should be config for CampaignMembers list');
          
          
          
          Test.stopTest();
        }
    }
    static testMethod void getApplicationConfigSettingsTest() {
        System.runAs(usr) {
            Test.startTest();
            List<CM_Campaigns_WS.ApplicationConfigSettings> settingsList = CM_ApplicationConfigManager.getApplicationConfigSettings();
            Test.stopTest();
        }
    }
    
    
    static testMethod void getCampaignConfigurationTest(){
        // Commented by Aditya To improve test Class performance Jira : 4438.
        // List<User> usrList = [select id from User where isActive = true And ID <>:Userinfo.getUserId()];
        List<User> usrList = CM_TestClassUtilities.getAdminUser();
        System.runAs(usr){
           // Added following lines by Aditya To improve test Class performance Jira : 4438.
            T1C_CustomSettingsManager.setAllTriggerOn();
            T1C_CustomSettingsManager.createChatterSetting(); 
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign3';
            //camp.IsActive = true; 
            camp.Status__c = 'Active';
            camp.Region__c = 'JP';
            camp.External_Id__c = 'Test_12345';
            camp.Default_Task_Assignee__c = usr.Id;
            insert camp;
            
            Integer defaultCampaignMemberStatusesNumber = 0;
            CM_Campaigns_WS.CampaignConfiguration cConfig = CM_ApplicationConfigManager.getCampaignConfiguration(camp.Id);
            //System.assertEquals(cConfig.campaignMemberStatuses.size() > defaultCampaignMemberStatusesNumber, true, 'Default campaign member statuses should be inserted');
            //System.assertEquals('Target List',cConfig.defaultTab,'Default TAb should be Target List');
            
           
            
             
        }
    }
    
    
    
}