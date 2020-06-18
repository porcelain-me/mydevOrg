/***********************************************************
Class Name - TestCM_Materials 
Author - Urminder Vohra [Appiro-Offshore]
Created Date - 9/21/2011

***********************************************************/
@isTest
private class TestCM_Materials {
    static Campaign__c camp;
    static User usr;
    static Integer TOTAL_ATTACHMENTS = 5;
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
           CM_Materials controller = new CM_Materials();
           controller.campaignId = camp.Id;
           controller.showCount = CM_DataUtil_WS.NO_OF_ATTACHMENTS;
          //getting all attachments
           controller.init();
           //in attachmentList attachments are equals to showCount 
           System.assertEquals(controller.attachmentList.size() ,controller.showCount,'Attacments shown on the page should be equals to the showCount');
           //all attachments
           System.assertEquals(controller.allAttachmentList.size() ,TOTAL_ATTACHMENTS , 'Total Number of attachments should be equals to TOTAL_ATTACHMENTS');
           Test.stopTest();
       }
       
    }
    static void createData() {
        T1C_CustomSettingsManager.createChatterSetting();    
        CM_TestClassUtilities.SetCamapignLimitSettings();
        T1C_CustomSettingsManager.setAllTriggerOn();
        
            camp = new Campaign__c();
            camp.Name = 'Test Campaign';
            camp.Status__c = 'Active';
            camp.Region__c = 'EU';
            camp.External_Id__c = 'ID_001';
            insert camp;
            
           //inserting new Attachment
         for(integer i = 0 ; i< TOTAL_ATTACHMENTS ; i++) {
          Attachment attach = new Attachment();
          attach.Name = 'sample_file ' + i + '.pdf';
          Blob body =Blob.valueOf('testData');
          attach.body = body;
          attach.parentid =  camp.id; 
          insert attach;
        }
            
    }
}