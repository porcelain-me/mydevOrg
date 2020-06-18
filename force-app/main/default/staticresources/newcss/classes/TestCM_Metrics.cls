/***********************************************************
Class Name - TestCM_Metrics 
Author - Urminder Vohra [Appiro-Offshore]
Created Date - 9/21/2011

***********************************************************/
@isTest
private class TestCM_Metrics { 
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
           CM_Metrics controller = new CM_Metrics();
           controller.campaignId = camp.Id;
           controller.init();
           //System.assertEquals(5,controller.feedbackPosts,'Total number of feedback for this campaign should be 5');
           //as records created by this user so owner is this user
           System.assertEquals(2,controller.incomingRequests,'incomingRequests should be equals to Tasks having ownerId as current User');
           //as records created by this user so createdby is this user
           System.assertEquals(2,controller.pendingRequests,'pendingRequests should be equals to Tasks createdBy current User');
           Test.stopTest();
       }
       
    }
    static void createData() {
            T1C_CustomSettingsManager.createChatterSetting();    
            CM_TestClassUtilities.SetCamapignLimitSettings();
            T1C_CustomSettingsManager.setAllTriggerOn();
            Id recordTypeId = CM_TestClassUtilities.getTaskRecordTypeId();
            camp = new Campaign__c();
            camp.Name = 'Test Campaign';
            camp.Status__c = 'Active';
            camp.Region__c = 'EU';
            camp.External_Id__c = 'ID_0012';
            insert camp;
            
            CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
          if(cMGS != null && cMGS.Id != null){
              cMGS.APP_NAME__c = 'SalesGPS';
          }else{
              cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
              cMGS.APP_NAME__c = 'SalesGPS';
              insert cMGS;
          }
          
               
            // Creating Task for showing in Activity History Section
           Task task1 = new Task();
           task1.WhatId = camp.id;
           task1.subject = 'Test Task';
           task1.ownerId = usr.Id;
           task1.status = 'Not Started';
           task1.activitydate = date.today();
           task1.RecordTypeId = recordTypeId;
           insert task1;
           
           Task task2 = new Task();
           task2.WhatId = camp.id;
           task2.subject = 'Test Task2';
           task2.status = 'Not Started';
           task2.activitydate = date.today();
           task2.RecordTypeId = recordTypeId;
           insert task2;
                             	
            
    }
}