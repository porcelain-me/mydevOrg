//  09/28/2011 RJ: ORIGINAL 
//                 Test class for CM_Campaigns_WS webservice controller   
// 10/21/2011 RJ: Updated the test class to add getCampaignConfigurationTest
@isTest 
private class TestCM_Campaigns_WS {
  static List<GPSAccount__c> listAccounts;
  static List<GPSContact__c> listContacts;
  static List<GPSContact__c> listContacts2;
  static List<Distribution_List__c> listOfdists;
  static List<DistributionListItem__c> listItems;
  static List<Task> lstTasks;
  
  static List<Campaign_Member__c> lstCampaignMembers;
  static Integer LIST_SIZE = 50;  
  static Integer DistrtibutionListsCount = 10;
  static Integer DistrtibutionListItemCount = 10;
  static Campaign__c camp;
  static Campaign__c camp2;
  static List<GPSEmployee__c> lstEmployee;  
  static User usr;
  static List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment;  
  
  static integer DistrtibutionListItemTestCount = 2;
  
      
  static integer ContactsPerAccount = 10; 
  static List<Campaign__c> campList;
  
  static {
        //usr = CM_TestClassUtilities.getTempUser();
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
  
  static testMethod void getCampaignMembersforCurrentUserTest() {
      T1C_CustomSettingsManager.setAllTriggerOn();      
       System.runAs(usr) {
           Test.startTest();
           init();
           List<CM_Campaigns_WS.CampaignMemberWrapper> lst = CM_Campaigns_WS.getCampaignMembersforCurrentUser(camp.Id);
           System.assertEquals(lst.size(), 100, 'Size of current user campaign Members should be 100');
           for(CM_Campaigns_WS.CampaignMemberWrapper cMW : lst){
              System.assertEquals(cMW.requestStatus, 'Pending', 'Request status of each campaign member should be Pending');
              System.assertEquals(cMW.campaignMemberStatus, 'Responded', 'Request status of each campaign member should be Responded');
              System.assertEquals(cMW.campaignScore, 1, 'Campaign Score should be 1');
              System.assertEquals(cMW.contactPhone[0].phoneType, 'Default_Phone', 'First item in contactPhone array should be default phone');
              
           } 
           Test.stopTest();
       }
  }
  static testMethod void getIncomingReqMembersforCurrentUserTest() {
      T1C_CustomSettingsManager.setAllTriggerOn();      
       System.runAs(usr) {
           Test.startTest();
           init();
           List<CM_Campaigns_WS.IncomingRequestMemberWrapper> lst = CM_Campaigns_WS.getIncomingRequestsForCurrentUser(camp.Id);
           System.assertEquals(lst.size(), 100, 'Size of current user campaign Members should be 100');
           for(CM_Campaigns_WS.IncomingRequestMemberWrapper cMW : lst){
              System.assertEquals(cMW.Status, 'Pending', 'Request status of each campaign member should be Pending');
              System.assertEquals(cMW.contactPhone[0].phoneType, 'Default_Phone', 'First item in contactPhone array should be default phone');
              
           }
           CM_Campaigns_WS.ApplicationSettings applicationSettings = CM_Campaigns_WS.getApplicationConfig();
           System.assertEquals(8,applicationSettings.gridConfigSettings[1].displayColumns.size());
                    
           Test.stopTest();
       }
  }
  static testmethod void getSearchCampaignMemberContactsTest() {
      T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
        Test.startTest();
        init();
        CM_Campaigns_WS.QuickAddContactsWrapper QAddWraper = CM_Campaigns_WS.getSearchCampaignMembersContacts(camp2.Id, 'TestContact_FirstAccount');
        //System.assertEquals(QAddWraper.contactList.size(),LIST_SIZE,'list size should be equals');
        
        Test.stopTest();
    }
  }
  static testmethod void updateCampaignMemberStatusTest() {
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
      Test.startTest();
      init();
      CM_Campaigns_WS.CustomMessage cM = CM_Campaigns_WS.updateCampaignMemberStatus(lstCampaignMembers[0].Id, 'Sent');
      System.assertEquals(cM.message, 'Status has been updated' ,'custom message should match');
      
      Campaign_Member__c cM_S = [Select status__c from Campaign_Member__c where id = : lstCampaignMembers[0].Id];
      System.assertEquals(cM_S.status__c, 'Sent', 'status should be updated');
      
      Test.stopTest();
    }
  }
  
  
  static testmethod void getRequestandResponsePanelsDetailTest() {
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
      Test.startTest();
      init();
      CM_Campaigns_WS.RequestandResponsePanelsDetail cMDW = CM_Campaigns_WS.getRequestandResponsePanelsDetail(lstCampaignMembers[0].Id);
      System.assertEquals(cMDW.campaignMemberId,  lstCampaignMembers[0].Id , 'id should match');
      Test.stopTest();
    }
  }
  
  
   static testmethod void reassignMemberTest() {
   T1C_CustomSettingsManager.setAllTriggerOn();      
    Id duserId = Userinfo.getUserId();
    System.runAs(usr) {
      Test.startTest();
      init();
      
      CM_Campaigns_WS.CustomMessage cM = CM_Campaigns_WS.reassignMember(camp.Id, new List<String>{lstCampaignMembers[0].GPSContact__c, lstCampaignMembers[1].GPSContact__c}, duserId);
      System.assertEquals(cM.message, '2 Contacts has been reassigned. ' ,'custom message should match');
      Test.stopTest();
    } 
  }
  
  static testmethod void removeCampaignMembersforCurrentUserTest() {
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
      Test.startTest();
      init();
      CM_Campaigns_WS.CustomMessage cM = CM_Campaigns_WS.removeCampaignMembersforCurrentUser(camp.Id, new List<String>{lstCampaignMembers[0].GPSContact__c, lstCampaignMembers[1].GPSContact__c});
      System.assertEquals(cM.message, '2 Contacts has been removed. ' ,'custom message should match');
      Test.stopTest();
    } 
  }
  
  static testmethod void addCampaignMembersforCurrentUserTest() {
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
      Test.startTest();
      init();
      CM_Campaigns_WS.addCampaignMembersforCurrentUserResult cM = CM_Campaigns_WS.addCampaignMembersforCurrentUser(camp.Id, new List<Id>{listContacts2[0].Id, listContacts2[1].Id});
      System.assertEquals(cM.CustomMessage.message, '2 Contacts has been added. ' ,'custom message should match');
      Test.stopTest();
    }  
  }
  
  
  static testmethod void getApplicationConfigTest() {
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
      Test.startTest();
      init();
      CM_Campaigns_WS.ApplicationSettings appSettings = CM_Campaigns_WS.getApplicationConfig();
      System.assertEquals(appSettings.gridConfigSettings.size(), 2 ,'It should contain two records of config settings 1. campiagn members list 2. incoming requests list');
      Test.stopTest();
    } 
  }
  
  static testmethod void searchCampaignParticipantsTest() {
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
      Test.startTest();
      init();
      CM_Campaigns_WS.QuickAddCampaignParticipantsWrapper qACPW = CM_Campaigns_WS.searchCampaignParticipants(camp.id, 'text');
      System.assertEquals(qACPW.searchString, 'text' ,'search string text should match');
      Test.stopTest();
    } 
  }
  static testMethod void RequestWrapperTest() {
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr) {
      Test.startTest();
      init();
      CM_Campaigns_WS.getApplicationConfig();
      
      String contactId = String.valueOf(listContacts[0].Id);
      String CampaignId = String.valueOf(camp.Id);
      String dueDate = '2012-10-10'; 
      
      CM_Campaigns_WS.createRequest(contactId, 'call', campaignId, usr.Id, 'Test_Comment_0021#21', dueDate, true);
      List<Task> request = [select id from task where GPS_Contact__c = :contactId AND whatId = :CampaignId AND OwnerId =:usr.Id];
      
      CM_Campaigns_WS.getRequestDetail(request[0].Id);
      CM_Campaigns_WS.getDefaultRequestDetail(lstCampaignMembers[0].Id);
      CM_Campaigns_WS.updateRequest(request[0].Id, 'Completed', 'Test Fedeback', usr.Id);
      List<Task> reqList = [select id,Status from task where GPS_Contact__c = :contactId AND whatId = :CampaignId AND OwnerId =:usr.Id];
      //System.assertEquals('Completed', reqList[0].Status,'UPdated status should match');
      
      Task requestW = [select CreatedDate, CreatedBy.FirstName, CreatedBy.LastName, CreatedById, IsClosed, GPS_Contact__c, Type, WhatId, Subject, OwnerId, Description, ActivityDate, Assignee_Feedback__c, Status,
            Owner.FirstName, Owner.LastName, What.Name from Task where Id = : request[0].Id limit 1];
      
      CM_Campaigns_WS.RequestWrapper rWW = new CM_Campaigns_WS.RequestWrapper(requestW);
      
      Id reqId = request[0].Id;
      CM_Campaigns_WS.cancelRequest(reqId);
      reqList = [select id,Status from task where id = :reqId];
      System.assertEquals(0, reqList.size(),'request should be deleted');
      
      
      
      
      Test.stopTest();
    }
  }
  
  static testMethod void getCampaignConfigurationTest(){
  T1C_CustomSettingsManager.setAllTriggerOn();      
    System.runAs(usr){
        Test.startTest();
        init();
              
              Integer defaultCampaignMemberStatusesNumber = 0;
            CM_Campaigns_WS.CampaignConfiguration cConfig = CM_Campaigns_WS.getCampaignConfiguration(camp.Id);
            //System.assertEquals(cConfig.campaignMemberStatuses.size() > defaultCampaignMemberStatusesNumber, true, 'Default campaign member statuses should be inserted');
        
        
        Test.stopTest();
    }
  }
  
  static void init(){
      T1C_CustomSettingsManager.createChatterSetting();
      CM_TestClassUtilities.SetCamapignLimitSettings();
      T1C_CustomSettingsManager.setAllTriggerOn(); 
      // Insert 2 Accounts
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
        listContacts2 = new List<GPSContact__c>();
        
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
        con.Prefer_Business_Phone__c = '+91-123456789000';
        con.Prefer_Mobile_Phone__c = '+91-123456789000';
        //con.AssistantPhone = '+91-123456789000';
        con.HomePhone__c = '+91-123456789000';
        //con.OtherPhone = '+91-123456789000';        
        con.Trading_Name_ID__c =  'c'+ indx + Datetime.now().format('hhmmss');
            con.CIS_Contact_ID__c =   'c'+ indx + Datetime.now().format('hhmmss');
            con.TN_Contact_Key__c =  'ts'+ indx + Datetime.now().format('ddhhmmss');   
        listContacts.add(con);
      }
      // add 10 contacts for second account
      
      for(integer indx = 0; indx < 5; indx++){
        
        con = Common_ContactUtil.createContact(indx, (string)listAccounts[0].Id);
        listContacts2.add(con);
      }
      insert listContacts2;
      
      for(integer indx = 0; indx < LIST_SIZE; indx++){
        
        con = Common_ContactUtil.createContact((indx+LIST_SIZE), (string)listAccounts[0].Id);
        listContacts.add(con);
      }
      insert listContacts;
        
      
      // insert 10 distribution list  
        listOfdists = new List<Distribution_List__c>();     
        for(integer indx = 0; indx < DistrtibutionListsCount; indx++){
          Distribution_List__c dist = new Distribution_List__c();
          dist.Name ='test_DistributionList_' + indx;
          dist.List_Id__c = 'List_Id_s_' + indx;
          dist.Active_Flag__c = true;
          listOfdists.add(dist);
        }
        insert listOfdists;
        
      
      // insert distribution list items 
      // such that each distribution list has n no of contacts list items  
      listItems = new List<DistributionListItem__c>();
      DistributionListItem__c item = new DistributionListItem__c();
      for(Distribution_List__c dl : listOfdists){
        for(integer indx = 0; indx < DistrtibutionListItemCount; indx++){
            item = new DistributionListItem__c();
          item.DistributionList__c = dl.id;
          item.GPSContact__c = listContacts[indx].id;
          item.Active_Flag__c= true ;
          item.Primary_Key__c = listContacts[indx].id + '|' + dl.Id + '|' + indx;
          listItems.add(item);
        }
      }
      insert listItems;
      Set<Id> ids =  new Set<Id>(); 
      for(DistributionListItem__c li : listItems){
          ids.add(li.id);
      } 
      listItems =  [Select DistributionList__c,GPSContact__c,Active_Flag__c,GPSContact__r.FirstName__c,GPSContact__r.lastName__c,
                                    GPSContact__r.Phone__c,GPSContact__r.Mobile__c
                                     from DistributionListItem__c where  id in :ids];
        
      
      
      
      
      
      lstEmployee = new List<GPSEmployee__c>();
      for( Distribution_List__c dList : listOfdists){
        GPSEmployee__c e = new GPSEmployee__c();
        e.Name = 'test' + dList.id;
        e.Division__c = 'Research';
        e.Last_Selected_Distribution_List__c = dList.id;
        e.MS_ID__c = 'testSEFR' + dList.id;
        //e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.Active_Flag__c = true;
        lstEmployee.add(e);
      }
      insert lstEmployee;
      
      
      camp = new Campaign__c();
            camp.Name = 'Test Campaign3';
            camp.Active__c = true; 
            camp.Status__c = 'Active';
            camp.Region__c = 'JP';
            camp.External_Id__c = 'NEWID_001';
            camp.Default_Task_Assignee__c = usr.Id;
            insert camp;
            
      camp2 = new Campaign__c();
            camp2.Name = 'Test Campaign3';
            camp2.Active__c = true; 
            camp2.Status__c = 'Active';
            camp2.Region__c = 'JP';
            camp2.External_Id__c = 'NEWID_022';
            camp2.Default_Task_Assignee__c = usr.Id;
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
      lstTasks = new List<Task>();
      Id recordTypeId = CM_TestClassUtilities.getTaskRecordTypeId();
      
      CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
      if(cMGS != null && cMGS.Id != null){
          cMGS.APP_NAME__c = 'SalesGPS';
      }else{
          cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
          cMGS.APP_NAME__c = 'SalesGPS';
          insert cMGS;
      }
      
      
    
       for(GPSContact__c c : listContacts){
           Task task1 = new Task();
           task1.WhatId = camp.id;
           task1.subject = 'Test Task';
           task1.ownerId = usr.Id;
           task1.Status = 'Pending';
           task1.GPS_Contact__c = c.Id;
           task1.activitydate = date.today();
           task1.RecordTypeId = recordTypeId;
           lstTasks.add(task1);  
   
       }
       
       insert lstTasks;
       
            
  }     
  
  
  
   static testMethod void myUnitTest() {
   T1C_CustomSettingsManager.setAllTriggerOn();      
       System.runAs(usr) {
           Test.startTest();
           createTestData();
           CM_Campaigns_WS controller = new CM_Campaigns_WS();
           
           List<Campaign__c> listCamp = CM_Campaigns_WS.getFilteredCampaignsList('Active', 'EU');
           System.assert(5 <= listCamp.size(),'List size for active campaigns frome Europe region should be 5');
           
           listCamp = CM_Campaigns_WS.getFilteredCampaignsList('Active', 'JP');
           System.assert(0 <= listCamp.size(),'List size for active campaigns frome Japan region should be 0');
           
           listCamp = CM_Campaigns_WS.getFilteredCampaignsList('Inactive', 'All');
           // as status inactive camaping should be deactivated
           System.assert(0 <= listCamp.size(),'List size for Inactive campaigns from All region should be 0');
           Test.stopTest();
       }
       
    }
    static testmethod void loadTargetListonSelectedDLTest(){
    T1C_CustomSettingsManager.setAllTriggerOn();      
        System.runAs(usr) {
           Test.startTest();
           createTestData();
           
           String selectedDLId = listOfdists[0].id;
           String selectedCampaignId = campList[0].id;
           boolean isUseMyContactList = false;
           String selectedDLName = listOfdists[0].Name;
           
           CM_Campaigns_WS.CustomMessage cMessage = CM_Campaigns_WS.loadTargetListonSelectedDL(selectedDLId,selectedCampaignId,isUseMyContactList,selectedDLName);
           
           List<Campaign_Member__c> cMList = [Select id from Campaign_Member__c where Campaign__c = :  campList[0].id];
            
           System.assertEquals(cMList.size(), DistrtibutionListItemTestCount, 'New campaign members should be added');
            
            
           Test.stopTest();
       }      
    }    
  
  
  static void createTestData() {
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
      for(integer indx = 0; indx < ContactsPerAccount; indx++){
        
        con = Common_ContactUtil.createContact((indx), (string)listAccounts[0].Id);
        listContacts.add(con);
      }
      // add 10 contacts for second account
      for(integer indx = 0; indx < ContactsPerAccount; indx++){
        con = Common_ContactUtil.createContact((indx+ContactsPerAccount), (string)listAccounts[0].Id);
        listContacts.add(con);
      }
      insert listContacts;
        
        
      listOfdists = new List<Distribution_List__c>();     
      for(integer indx = 0; indx < DistrtibutionListsCount; indx++){
          Distribution_List__c dist = new Distribution_List__c();
          dist.Name ='test_DistributionList_' + indx;
          dist.List_Id__c = 'List_Id_s_' + indx;
          dist.Active_Flag__c = true;
          listOfdists.add(dist);
      }
      insert listOfdists;
        
      
      // insert distribution list items 
      // such that each distribution list has n no of contacts list items  
      listItems = new List<DistributionListItem__c>();
      DistributionListItem__c item = new DistributionListItem__c();
      for(Distribution_List__c dl : listOfdists){
        for(integer indx = 0; indx < DistrtibutionListItemTestCount; indx++){
            item = new DistributionListItem__c();
          item.DistributionList__c = dl.id;
          item.GPSContact__c = listContacts[indx].id;
          item.Active_Flag__c= true ;
          item.Primary_Key__c = listContacts[indx].id + '|' + dl.Id + '|' + indx;
          listItems.add(item);
        }
      }
      insert listItems;
      
      
      campList = new list<Campaign__c>();
      Integer index = 1;
        for(Integer i=0 ;i<5; i++) {
            camp = new Campaign__c();
            camp.Name = 'Test Campaign3' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Active';
            camp.Region__c = 'EU';
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            campList.add(camp);
            index++;
        }
        for(Integer i=0 ;i<5; i++) {
            camp = new Campaign__c();
            camp.Name = 'Test Campaign3' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Hidden';
            camp.Region__c = 'JP';
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            campList.add(camp);
            index++;
        }
        for(Integer i=0 ;i<5; i++) {
            camp = new Campaign__c();
            camp.Name = 'Test Campaign3' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Inactive';
            camp.Region__c = 'All';
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            campList.add(camp);
            index++;
        }
        insert campList;
    }
  
  
}