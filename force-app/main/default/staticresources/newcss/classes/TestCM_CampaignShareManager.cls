//  10/17/2011 RJ: ORIGINAL 
//                 Test class for CM_CampaignShareManager.cls

@isTest
private class TestCM_CampaignShareManager {
  static Campaign__c camp;
  static Campaign__c camp2;
  static User usr;
  static List<Id> campaignMemberToBeRemoved;
  static Integer LIST_SIZE = 50;
  static List<Id> contactIds;
  static List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment; 
  static List<User> usrList;
  static{
      // temp user
     //usr =   CM_TestClassUtilities.getTempUser();
     usr = getTempUser();
  }
  static list<Campaign_Member__c> listMembers;
  static List<GPSContact__c> listContacts;
  static List<GPSAccount__c> listAccounts;
  
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
  
  /******************Start Test Classefor CM_CampaignTeamMemberManager by Sudarshan K. for JIRA-4537*********************/
  
  static testMethod void insertDuplicateCampaignTeamMemberMangerTest(){
    T1C_CustomSettingsManager.setAllTriggerOn();
    System.runAs(usr){
        Test.startTest();
        createDataForForceCreate(true);
        List<Campaign_Member__c> lstUpdateCM = new List<Campaign_Member__c>();
        
        listMembers[0].System_Campaign_Team_Member_Access_Level__c = 'All';
        listMembers[1].System_Campaign_Team_Member_Access_Level__c = 'Edit';
        listMembers[2].System_Campaign_Team_Member_Access_Level__c = 'Read';
        lstUpdateCM.add(listMembers[0]);
        lstUpdateCM.add(listMembers[1]);
        lstUpdateCM.add(listMembers[2]);
        update lstUpdateCM;
        
        CM_CampaignTeamMemberManager.insertCampaignTeamMembers(listMembers);
        
        set<Id> cmIds = new set<Id>();
        for(Campaign_Member__c cM : listMembers){
        	cmIds.add(cM.Id);
        }
        List<Campaign_Member__c> insertduplicateCamapignMemberList = [SELECT Id, GPSContact__c, Force_Create_CMA__c, Campaign__c, Campaign__r.External_Id__c, Campaign_Score__c, Force_Create_CTM__c, System_Assigned_by_Admin__c, System_Assigned_To__c, System_Assigned_To__r.Emp_Id__c, System_Campaign_Team_Member_Access_Level__c, System_Campaign_Team_Member_Role__c FROM Campaign_Member__c WHERE Id IN: cmIds];
        CM_CampaignTeamMemberManager.insertDuplicateCampaignMemberTeamMembers(insertduplicateCamapignMemberList);
        
        Test.stopTest();
    }
  }
  
    
  /*******************End Test Class for CM_CampaignTeamMemberManager******************************************/  
  
  static testMethod void insertCampaignShareRecordsTest(){
      T1C_CustomSettingsManager.setAllTriggerOn();
    System.runAs(usr){
         Test.startTest();
         createDataForForceCreate(false);
         
         List<Campaign_Member_Assignment__c> cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         List<Campaign_Team_Member__c> ctMList = [Select c.Id, c.Campaign__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         System.assertEquals(ctMList.size(), 0 , 'There should be no ctm records created becasuse create force ctm field is unchecked');
           
           
         for(Campaign_Member__c cM : listMembers){
          cM.Force_Create_CTM__c = true;  
          cM.Force_Create_CMA__c = true;
         }
         
         
         update listMembers;
          
         CM_CampaignTeamMemberManager.insertCampaignTeamMembers(listMembers);          
        
         
         cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         ctMList = [Select c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         if(usrList.size() == 2){
           System.assertEquals(ctMList.size(), 2, 'There should be 2 records inserted in to the campaign team member object for this campaign');  
         }else{
           System.assertEquals(ctMList.size(), 1, 'There should be 1 records inserted in to the campaign team member object for this campaign'); 
         }
          
         CM_CampaignShareManager.insertCampaignShareRecords(ctMList);
         
         List<CampaignShare> campShareList = [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                                c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual 
                                                and c.CampaignId = : camp.id order by c.CampaignId, c.CampaignAccessLevel DESC];
                    
           
           
           if(usrList.size() == 2){
             System.assertEquals(campShareList.size(), 0, 'There should be 2 users inserted in Campaign Share object for manual sharing');  
           }else{
             System.assertEquals(campShareList.size(), 0, 'Returns 0 because There should be only 1 user inserted in to the campaign share object for this campaign as full access as he is the owner of campaign so no manual sharign records allowed for the owner'); 
           }
           
           
         Test.stopTest();
    }     
  }
  
  static testMethod void updateCampaignShareRecordsTest(){
        T1C_CustomSettingsManager.setAllTriggerOn();
    System.runAs(usr){
         Test.startTest();
         createDataForForceCreate(false);
         
         List<Campaign_Member_Assignment__c> cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         List<Campaign_Team_Member__c> ctMList = [Select c.Id, c.Campaign__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         System.assertEquals(ctMList.size(), 0 , 'There should be no ctm records created becasuse create force ctm field is unchecked');
         
         
         for(Campaign_Member__c cM : listMembers){
          cM.Force_Create_CTM__c = true;
           cM.Force_Create_CMA__c = true;
         }
         
         update listMembers;
          
         CM_CampaignTeamMemberManager.insertCampaignTeamMembers(listMembers);          
        
         
         cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         ctMList = [Select c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         if(usrList.size() == 2){
           System.assertEquals(ctMList.size(), 2, 'There should be 2 records inserted in to the campaign team member object for this campaign');  
         }else{
           System.assertEquals(ctMList.size(), 1, 'There should be 1 records inserted in to the campaign team member object for this campaign'); 
         }
         
         List<CampaignShare> campShareList = [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                                c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual 
                                                and c.CampaignId = : camp.id order by c.CampaignId, c.CampaignAccessLevel DESC];
                    
         Map<Id, Campaign_Team_Member__c> mapCTM = new Map<Id, Campaign_Team_Member__c>();
         
         
         for(Campaign_Team_Member__c cTM : ctMList){
             mapCTM.put(cTM.Id, cTM);
         } 
           
           
         if(usrList.size() == 2){
           System.assertEquals(campShareList.size(), 0, 'There should be 2 users inserted in Campaign Share object for manual sharing');  
         }else{
           System.assertEquals(campShareList.size(), 0, 'Returns 0 because There should be only 1 user inserted in to the campaign share object for this campaign as full access as he is the owner of campaign so no manual sharign records allowed for the owner'); 
         }
         
         for(Campaign_Team_Member__c cTM : ctMList){
             cTM.Campaign_Access_Level__c = 'Read';
         } 
         
         update ctMList;
         
         Map<Id, Campaign_Team_Member__c> mapNewCTM = new Map<Id, Campaign_Team_Member__c>();
         
         
         for(Campaign_Team_Member__c cTM : ctMList){
             mapNewCTM.put(cTM.Id, cTM);
         }
         
         CM_CampaignShareManager.updateCampaignShareRecords(mapCTM, mapNewCTM);
         
         
         campShareList = [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                                c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual 
                                                and c.CampaignId = : camp.id order by c.CampaignId, c.CampaignAccessLevel DESC];
         
         for(CampaignShare cS : campShareList){
             System.assertEquals(cS.CampaignAccessLevel, 'Read', 'Manual sharing should be degraded to Read only mode');
         }  
           
         Test.stopTest();
    }     
  }
  
  
  static testMethod void deleteCampaignShareRecordsTest(){
        T1C_CustomSettingsManager.setAllTriggerOn();
    System.runAs(usr){
         Test.startTest();
         createDataForForceCreate(false);
         
         List<Campaign_Member_Assignment__c> cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         List<Campaign_Team_Member__c> ctMList = [Select c.Id, c.Campaign__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         System.assertEquals(ctMList.size(), 0 , 'There should be no ctm records created becasuse create force ctm field is unchecked');
         
         
         for(Campaign_Member__c cM : listMembers){
          cM.Force_Create_CTM__c = true;  
           cM.Force_Create_CMA__c = true;
         }
         
         update listMembers;
          
         CM_CampaignTeamMemberManager.insertCampaignTeamMembers(listMembers);          
        
         
         cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         ctMList = [Select c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         if(usrList.size() == 2){
           System.assertEquals(ctMList.size(), 2, 'There should be 2 records inserted in to the campaign team member object for this campaign');  
         }else{
           System.assertEquals(ctMList.size(), 1, 'There should be 1 records inserted in to the campaign team member object for this campaign'); 
         }
         
         List<CampaignShare> campShareList = [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                                c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual 
                                                and c.CampaignId = : camp.id order by c.CampaignId, c.CampaignAccessLevel DESC];
           
         if(usrList.size() == 2){
           System.assertEquals(campShareList.size(), 0, 'There should be 2 users inserted in Campaign Share object for manual sharing');  
         }else{
           System.assertEquals(campShareList.size(), 0, 'Returns 0 because There should be only 1 user inserted in to the campaign share object for this campaign as full access as he is the owner of campaign so no manual sharign records allowed for the owner'); 
         }
         
         
         
         delete ctMList;
         
        
         
         CM_CampaignShareManager.deleteCampaignShareRecords(ctMList);
         
         
         
         campShareList = [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                                c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual 
                                                and c.CampaignId = : camp.id order by c.CampaignId, c.CampaignAccessLevel DESC];
         
         System.assertEquals(campShareList.size(), 0, 'All manual sharing record of this campaign should be deleted');
           
           
         Test.stopTest();
    }     
  }
  
  
   static testMethod void undeleteCampaignShareRecordsTest(){
         T1C_CustomSettingsManager.setAllTriggerOn();
    System.runAs(usr){
         Test.startTest();
         createDataForForceCreate(false);
         
         List<Campaign_Member_Assignment__c> cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         List<Campaign_Team_Member__c> ctMList = [Select c.Id, c.Campaign__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         System.assertEquals(ctMList.size(), 0 , 'There should be no ctm records created becasuse create force ctm field is unchecked');
         
         
         for(Campaign_Member__c cM : listMembers){
          cM.Force_Create_CTM__c = true;   
           cM.Force_Create_CMA__c = true;
         }
         
         update listMembers;
          
         CM_CampaignTeamMemberManager.insertCampaignTeamMembers(listMembers);          
        
         
         cmAList = [Select id, Assigned_To__c from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         //System.assertEquals(cmAList.size(), LIST_SIZE, 'There should be 50 records inserted in to the campaign member assignemtn object for this campaign');
         
         ctMList = [Select c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c where Campaign__c = : camp.id];
         
         if(usrList.size() == 2){
           System.assertEquals(ctMList.size(), 2, 'There should be 2 records inserted in to the campaign team member object for this campaign');  
         }else{
           System.assertEquals(ctMList.size(), 1, 'There should be 1 records inserted in to the campaign team member object for this campaign'); 
         }
         
         List<CampaignShare> campShareList = [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                                c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual 
                                                and c.CampaignId = : camp.id order by c.CampaignId, c.CampaignAccessLevel DESC];
           
         if(usrList.size() == 2){
           System.assertEquals(campShareList.size(), 0, 'There should be 2 users inserted in Campaign Share object for manual sharing');  
         }else{
           System.assertEquals(campShareList.size(), 0, 'Returns 0 because There should be only 1 user inserted in to the campaign share object for this campaign as full access as he is the owner of campaign so no manual sharign records allowed for the owner'); 
         }
         
         
         
         delete ctMList;
         
        
         
         CM_CampaignShareManager.deleteCampaignShareRecords(ctMList);
         
         
         
         campShareList = [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                                c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual 
                                                and c.CampaignId = : camp.id order by c.CampaignId, c.CampaignAccessLevel DESC];
         
         System.assertEquals(campShareList.size(), 0, 'All manual sharing record of this campaign should be deleted');
         
         undelete ctMList;
         
         CM_CampaignShareManager.undeleteCampaignShareRecords(ctMList);
         
         if(usrList.size() == 2){
           System.assertEquals(ctMList.size(), 2, 'There should be 2 records inserted in to the campaign team member object for this campaign');  
         }else{
           System.assertEquals(ctMList.size(), 1, 'There should be 1 records inserted in to the campaign team member object for this campaign'); 
         }
           
           
         Test.stopTest();
    }     
  }
  
  static void createDataForForceCreate(boolean forceCreateCTM) {
      T1C_CustomSettingsManager.createChatterSetting();
        CM_TestClassUtilities.SetCamapignLimitSettings();
        T1C_CustomSettingsManager.setAllTriggerOn();
        //insert Campaign
        camp = new Campaign__c();
        camp.Name = 'Test Campaign_001';
        camp.Status__c = 'Active';
        camp.Region__c = 'EU';
        camp.External_Id__c = '1234';
        insert camp;
        
        camp2 = new Campaign__c();
        camp2.Name = 'Test Campaign_002';
        camp2.Status__c = 'Active';
        camp2.Region__c = 'All';
        camp2.External_Id__c = '1235';
        insert camp2;
        
        
        usrList = [Select u.Id, u.IsActive, u.Emp_Id__c From User u where u.IsActive = true and Emp_Id__c != null limit 2];
        
            
        listAccounts = new List<GPSAccount__c>();        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss');
        //acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
        acc1.Active_Flag__c = true;
        listAccounts.add(acc1);     
          
        insert listAccounts;
      
      
        //Create test contacts
        
        listContacts = new List<GPSContact__c>();
        //inserting Contacts
        for(Integer i = 0;i < LIST_SIZE;i++) {
          listContacts.add(Common_ContactUtil.createContact(i, (string)listAccounts[0].id));
        }
            insert listContacts;
            listMembers = new list<Campaign_Member__c>();
            
            contactIds = new List<Id>();
            for(Integer i = 0;i < LIST_SIZE;i++) {
              Campaign_Member__c cm = new Campaign_Member__c();            
              cm.Campaign__c = camp.Id; 
              cm.GPSContact__c =  listContacts[i].Id;
              cm.Force_Create_CMA__c = true;
              cm.Campaign_Score__c = i;
              cm.Force_Create_CTM__c = forceCreateCTM;
              cm.System_Assigned_by_Admin__c = false;
              cm.System_Assigned_To__c = (usrList.size() == 2 ?  (Math.mod(i, 2) == 0 ? usrList[0].Id : usrList[1].Id) : usr.Id);
              cm.System_Campaign_Team_Member_Access_Level__c = (usrList.size() == 2 ?  (Math.mod(i, 2) == 0 ? 'Edit' : 'Read') : 'Edit');
              cm.System_Campaign_Team_Member_Role__c = 'Participant';
              contactIds.add(listContacts[i].Id);
              listMembers.add(cm);
            }
            
            
            for(Integer i = 0;i < (LIST_SIZE/2);i++) {
              Campaign_Member__c cm2 = new Campaign_Member__c();              
              cm2.Campaign__c = camp2.Id; 
              cm2.GPSContact__c = listContacts[i].Id;
              cm2.Force_Create_CMA__c = true;
              cm2.Campaign_Score__c = i;
              cm2.Force_Create_CTM__c = forceCreateCTM;
              cm2.System_Assigned_by_Admin__c = false;
              cm2.System_Assigned_To__c = (usrList.size() == 2 ?  (Math.mod(i, 2) == 0 ? usrList[0].Id : usrList[1].Id) : usr.Id);
              cm2.System_Campaign_Team_Member_Access_Level__c = (usrList.size() == 2 ?  (Math.mod(i, 2) == 0 ? 'Edit' : 'Read') : 'Edit');
              cm2.System_Campaign_Team_Member_Role__c = 'Participant';
              listMembers.add(cm2);              
            }            
            
            insert listMembers;
            
            
            
    }
}