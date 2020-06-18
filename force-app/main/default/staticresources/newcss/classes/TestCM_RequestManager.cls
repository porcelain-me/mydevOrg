// 10/12/2011 : UV  ORIGINAL
//                      Test class for CM_RequestManager
//
//
@isTest
private class TestCM_RequestManager {
   static User usr;
   static Campaign__c camp;
   static GPSContact__c con;
   static Campaign_Member__c cM;
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
    
    static testMethod void createRequestTest(){
        T1C_CustomSettingsManager.setAllTriggerOn(); 
        System.runAs(usr) {
            Test.startTest();
            createData();
            CM_RequestManager controller = new CM_RequestManager();
            controller.campaignId = camp.Id; 
            controller.contactId = con.Id;
            controller.Action = 'Call';
            controller.comments = 'Test Comment';
            //controller.relatedToSubject = 'New Subject Name';
            controller.dueDateString = '2010-10-10';
            controller.assignedToUserId = Userinfo.getUserId();
            controller.isSpokenToContact = true;
            
            CM_Campaigns_WS.Request createdReq = controller.createRequest(); 
            System.assertEquals(createdReq.customMessage.message , 'The request is created.','Request should be created');
            
            Id conId = con.Id;
            Id campId = camp.Id;
            
            Task request = [select id from task where GPS_Contact__c = :conId AND whatId = :campId AND OwnerId =:Userinfo.getUserId()];
            controller.requestId  = request.Id;
            CM_Campaigns_WS.RequestWrapper requestDetail = controller.getRequestDetail();
            
            System.assertEquals(requestDetail.campaignId, camp.Id,'Campaign Id should match');
            System.assertEquals(requestDetail.contactId, con.Id,'Contact Id should match');
            System.assertEquals(requestDetail.assignedTouserId, Userinfo.getUserId(),'User Id should match');
            System.assertEquals(requestDetail.relatedTo, camp.Name,'Subject Name should match');
            System.assertEquals(requestDetail.requestType, 'Call','Action Name should match');
            
            controller.campaignMemberId = cM.Id;
            CM_Campaigns_WS.RequestWrapper cm2 = controller.getDefaultRequestDetail();
            System.assertEquals(cm2.relatedTo,'Test Campaign3','Camapign Name should match');
            Test.stopTest();
        }
    }
    static testMethod void updateRequestTest() {
        T1C_CustomSettingsManager.setAllTriggerOn(); 
        System.runAs(usr) {
            Test.startTest();
            
            createData();
            CM_RequestManager controller = new CM_RequestManager();
            controller.campaignId = camp.Id;
            controller.contactId = con.Id;
            controller.Action = 'Call';
            controller.comments = 'Test Comment';
        //  controller.relatedToSubject = 'New Subject Name';
            controller.dueDateString = '2010-10-10';
            controller.assignedToUserId = Userinfo.getUserId();
            controller.isSpokenToContact = true;
            
            CM_Campaigns_WS.Request createdReq = controller.createRequest();
            Task request = [select id from task where GPS_Contact__c = :con.Id AND whatId = :camp.Id AND OwnerId =:Userinfo.getUserId()];
            
            controller.requestId = request.Id;
            controller.Feedback = 'New Test Feedback';
            controller.Status = 'Completed';
            
            CM_Campaigns_WS.CustomMessage successMessage = controller.updateRequest(); 
            System.assertEquals(successMessage.message, 'The request is updated.','The task should be update');
            
            Test.stopTest();
        }
    }
    static testMethod void cancelRequestTest() {
        T1C_CustomSettingsManager.setAllTriggerOn(); 
        System.runAs(usr) {
            Test.startTest();
            
            createData();
            CM_RequestManager controller = new CM_RequestManager();
            controller.campaignId = camp.Id;
            controller.contactId = con.Id;
            controller.Action = 'Call';
            controller.comments = 'Test Comment';
        //  controller.relatedToSubject = 'New Subject Name';
            controller.dueDateString = '2010-10-10';
            controller.assignedToUserId = Userinfo.getUserId();
            controller.isSpokenToContact = true;
            
            CM_Campaigns_WS.Request createdReq = controller.createRequest();
            Task request = [select id from task where GPS_Contact__c = :con.Id AND whatId = :camp.Id AND OwnerId =:Userinfo.getUserId()];
            System.assertNotEquals(request,null,'Task should exists');
            //to delete the task
            controller.requestId = request.Id;
            CM_Campaigns_WS.CustomMessage successMessage = controller.cancelRequest(); 
            System.assertEquals(successMessage.message, 'The request is deleted.','The task should be deleted');
            
            request = null;
            for(Task req : [select id from task where GPS_Contact__c = :con.Id AND whatId = :camp.Id AND OwnerId =:Userinfo.getUserId()]) {
                request = req;
            }
            System.assertEquals(request,null,'Task should not exists');
            
            Test.stopTest();
        }
    }
    static void createData() {
        T1C_CustomSettingsManager.createChatterSetting(); 
            CM_TestClassUtilities.SetCamapignLimitSettings();
            T1C_CustomSettingsManager.setAllTriggerOn(); 
            
        camp = new Campaign__c();
        camp.Name = 'Test Campaign3';
        camp.Active__c = true; 
        camp.Status__c = 'Active';
        camp.Region__c = 'JP';
        camp.External_Id__c = 'Test_12345';
        insert camp;
        
        List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'ts1'+ Datetime.now().format('ddhhmmss');
        //acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
        acc1.Active_Flag__c = true;
        listAccounts.add(acc1);     
        GPSAccount__c acc2 = new GPSAccount__c();
        acc2.name = 'acc2';
        acc2.Trading_Name_ID__c = 'ts2'+ Datetime.now().format('ddhhmmss');
        //acc2.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');
        acc2.Active_Flag__c = true;   
        listAccounts.add(acc2);     
        insert listAccounts;
      
        //Create test contacts
      
        con = new GPSContact__c(); 
        con.firstName__c = 'TestContact_FirstAccount_001';
        con.lastName__c = listAccounts[0].name;
        con.GPSAccount__c = listAccounts[0].id;
        con.Phone__c = '+91-123456789000';
        con.Email__c = 'abc@morganstanley.com';
        con.Phone__c = '+91-123456789000';
        con.Mobile__c = '+91-123456789000';
        con.Prefer_Business_Phone__c = '+91-123456789000';
        con.Prefer_Mobile_Phone__c = '+91-123456789000';
        con.HomePhone__c = '+91-123456789000';
        //con.OtherPhone = '+91-123456789000';
        con.Language_Preference__c = 'English Only';
        con.Prefer_Business_Phone__c = '+91-123456789000';
        con.Prefer_Mobile_Phone__c = '+91-123456789000';
        //con.AssistantPhone = '+91-123456789000';
        //con.HomePhone = '+91-123456789000';
        //con.OtherPhone = '+91-123456789000';        
        con.Trading_Name_ID__c =  'c'+ Datetime.now().format('hhmmss');
        con.CIS_Contact_ID__c =   'c'+ Datetime.now().format('hhmmss');
        con.TN_Contact_Key__c =  'ts'+ Datetime.now().format('ddhhmmss');
        insert con;
        
        
        cM = new Campaign_Member__c(Campaign__c = camp.Id, GPSContact__c = con.Id, Campaign_Score__c = 1, Status__c = 'Responded', Reason__c = 'Reason_001' );
        
        Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
               Assigned_by_Admin__c = true,
               Assigned_To__c = usr.Id,
               Campaign__c = camp.Id,
               GPSContact__c = con.Id,
               Reassigned__c = false
            );
        
      
      insert cM;  
      insert cMA;
      
      CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
          if(cMGS != null && cMGS.Id != null){
              cMGS.APP_NAME__c = 'SalesGPS';
          }else{
              cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
              cMGS.APP_NAME__c = 'SalesGPS';
              insert cMGS;
          }
          
    }
}