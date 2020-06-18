//
//09/29/2011 UV: ORIGINAL  
//                Test Class for CM_IncomingRequestManager              
//   
//
@isTest
private class TestCM_IncomingRequestManager {
    static Campaign__c camp;
    static Campaign__c camp2;
    static User usr;
    static Integer LIST_SIZE = 50;
    static List<GPSAccount__c> listAccounts;
    static List<GPSContact__c> listContacts;
    static List<Campaign_Member__c> lstCampaignMembers;
    static List<Task> lstTasks;
static List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment;  
    
    static{
        // temp user
      // usr =   CM_TestClassUtilities.getTempUser();
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
    
    static testMethod void IncomingReqMemberTest() {
         T1C_CustomSettingsManager.setAllTriggerOn(); 
       System.runAs(usr) {
           Test.startTest();
           createData();
           CM_IncomingRequestManager controller = new CM_IncomingRequestManager();
           controller.campaignId = camp2.Id;
           List<CM_Campaigns_WS.IncomingRequestMemberWrapper> IncomingReqMemberList = controller.getIncomingRequestsForCurrentUser();
           System.assertEquals(LIST_SIZE/2,IncomingReqMemberList.size(),'Members should be equals to half of the LIST_SIZE'); 
           
           List<CM_Campaigns_WS.IncomingRequestMemberWrapper> IncomingRequestMemberList = new list<CM_Campaigns_WS.IncomingRequestMemberWrapper>();
           IncomingRequestMemberList = CM_IncomingRequestManager.getIncomingRequestsForCurrentUser(camp.Id);
           System.assertEquals(LIST_SIZE,IncomingRequestMemberList.size(),'Members should be equals to LIST_SIZE');
           
           controller.campaignId = camp.Id;
           controller.requestId = lstTasks[LIST_SIZE-1].Id;
           CM_Campaigns_WS.IncomingRequestMemberWrapper rmw = controller.getIncomingRequest();
           List<task> taskList = [select Id,Status,WhoId,IsClosed,ownerId,WhatId,CreatedById from Task where id = : controller.requestId];
           System.debug('_____'+controller.requestId + '___________________'+camp.Id+'____'+taskList);
           System.assertEquals(rmw.status , 'Pending','Status should be matched');
           Test.stopTest();
       }
       
    }
    static void createData() {
         T1C_CustomSettingsManager.createChatterSetting(); 
          CM_TestClassUtilities.SetCamapignLimitSettings();
          T1C_CustomSettingsManager.setAllTriggerOn(); 
          
          listAccounts = new List<GPSAccount__c>();        
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
        GPSContact__c con;
        listContacts = new List<GPSContact__c>();
        
      // add 10 contacts for first account
      for(integer indx = 0; indx < LIST_SIZE; indx++){
        con = new GPSContact__c(); 
        con.firstName__c = 'TestContact_FirstAccount_' + indx;
        con.lastName__c = listAccounts[0].name;
        con.GPSAccount__c = listAccounts[0].id;
        con.Phone__c = '+91-123456789000';
        con.Email__c = 'abc@morganstanley.com';
        con.Mobile__c = '+91-123456789000';
        con.Language_Preference__c = 'English Only';
        if(Math.mod(indx, 2) == 0){
         con.Prefer_Business_Phone__c = '+91-123456789000';
         con.Prefer_Mobile_Phone__c = '+91-123456789000';
         //con.AssistantPhone = '+91-123456789000';
         con.HomePhone__c = '+91-123456789000';
        }
        //con.OtherPhone = '+91-123456789000';        
        con.Trading_Name_ID__c =  'c'+ indx + Datetime.now().format('hhmmss');
            con.CIS_Contact_ID__c =   'c'+ indx + Datetime.now().format('hhmmss');
            con.TN_Contact_Key__c =  'ts'+ indx + Datetime.now().format('ddhhmmss');
        listContacts.add(con);
      }
     
      insert listContacts;
           
      
        camp = new Campaign__c();
        camp.Name = 'Test Campaign3';
        camp.Active__c = true; 
        camp.Status__c = 'Active';
        camp.Region__c = 'JP';
        camp.External_Id__c = 'ID_001';
        insert camp;
            
        camp2 = new Campaign__c();
        camp2.Name = 'Test Campaign_New2';
        camp2.Active__c = true; 
        camp2.Status__c = 'Active';
        camp2.Region__c = 'All';
        camp2.External_Id__c = 'ID_002';
        insert camp2;
            
      lstCampaignMembers = new List<Campaign_Member__c>();
      lstCampaignMembersAssignment = new List<Campaign_Member_Assignment__c>();
      Integer index = 1;
      for(GPSContact__c c : listContacts){
        Campaign_Member__c cM = new Campaign_Member__c(Campaign__c = camp.Id, GPSContact__c = c.Id, Campaign_Score__c = 1, Status__c = 'Responded', Reason__c = 'Reason' + index);
        lstCampaignMembers.add(cM);
        index++;
        
          Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
           Assigned_by_Admin__c = true,
           Assigned_To__c = usr.Id,
           Campaign__c = camp.Id,
           GPSContact__c = c.Id,
           Reassigned__c = false
        );
        
        lstCampaignMembersAssignment.add(cMA);
      }      
      
      insert lstCampaignMembers;  
      insert lstCampaignMembersAssignment;
      
      Id recordTypeId = CM_TestClassUtilities.getTaskRecordTypeId();
      lstTasks = new List<Task>();
      
      CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
      if(cMGS != null && cMGS.Id != null){
          cMGS.APP_NAME__c = 'SalesGPS';
      }else{
          cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
          cMGS.APP_NAME__c = 'SalesGPS';
          insert cMGS;
      }
      
      //listInterest = new list<Interest__c>();
       for(GPSContact__c c : listContacts){
           Task task1 = new Task();
           task1.WhatId = camp.id;
           task1.subject = 'Test Task';
           task1.ownerId = usr.Id;
           task1.Status = 'Pending';
           task1.GPS_Contact__c = c.Id;
           task1.RecordTypeId = recordTypeId;
           task1.activitydate = date.today();
           lstTasks.add(task1);
       }
        for(integer indx = 0; indx < LIST_SIZE/2; indx++){
           Task task2 = new Task();
           task2.WhatId = camp2.id;
           task2.subject = 'Test Task 2' + indx;
           task2.ownerId = usr.Id;
           task2.Status = 'Pending';
           task2.GPS_Contact__c = listContacts[indx].Id;
           task2.RecordTypeId = recordTypeId;
           task2.activitydate = date.today().addDays(1);
           
           lstTasks.add(task2);  
       }
       
       insert lstTasks;
       //insert listInterest;
            
  }     
}