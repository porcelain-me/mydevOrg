// 10/03/2011 UV : ORIGINAL
//                  Test class for CM_CampaignMembersReassignmentManager class
// 11/10/2011 UV : updated userSearchTest() to add reassigned user name testing line(#74-84)
//
@isTest
private class TestCM_CampMembersReassignmentManager {
    static List<GPSAccount__c> listAccounts;
    static List<GPSContact__c> listContacts;
    static List<Campaign_Member__c> lstCampaignMembers;
    static List<Id> ContactIds;
     static Integer LIST_SIZE = 50;  
     static Campaign__c camp;
     static Campaign__c camp2;   
     static User usr;
     static Id currentUserId;
     static List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment;  
     static{
         T1C_CustomSettingsManager.setAllTriggerOn(); 
         User usrtest = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        // temp user
        system.runAs(usrtest){
           usr =   CM_TestClassUtilities.getTempUser();
        }
    }
    
    static testMethod void userSearchTest() {
          
          currentUserId = Userinfo.getUserId();
          List<User> userList = [Select id from User where isActive = true and id <>:userInfo.getUserId() limit 5];
          System.runAs(usr) {
            Test.startTest();
              createData();
              
              CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
              if(cMGS != null && cMGS.Id != null){
                  cMGS.APP_NAME__c = 'SalesTestGPS';
              }else{
                  cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
                  cMGS.APP_NAME__c = 'SalesTestGPS';
                  insert cMGS;
              }
           
              List<Campaign_Team_Member__c> ctmList = new List<Campaign_Team_Member__c>();
                Campaign_Team_Member__c ctm;
                
                ctm = new Campaign_Team_Member__c();
                ctm.Campaign__c = camp.Id;
                ctm.User__c = userInfo.getUserId();
                ctm.Role__c = 'Participant';
                ctmList.add(ctm);
                
               
                        
                for(User usr1 : userList){
                   ctm = new Campaign_Team_Member__c();
                   ctm.Campaign__c = camp2.Id;
                   ctm.User__c = usr1.id;
                   ctm.Role__c = 'Participant';
                   ctmList.add(ctm);
                }
                        
                insert ctmList;
              
              CM_CampaignMembersReassignmentManager controller = new CM_CampaignMembersReassignmentManager();
              
              controller.campaignId = camp2.Id;
              controller.searchString = '';
              List<CM_Campaigns_WS.CampaignParticipantWrapper> participantsList = controller.searchCampaignParticipants();
              System.assertEquals(ctmList.size() - 1, participantsList.size(),'list size should be same as this campaign is shared with another user');
              //campaign member before resassign
              List<Campaign_Member__c> campaignMemberList  = CM_CampaignDataUtil.getCampaignMembersforCurrentUser(camp.Id); 
              System.assertEquals(LIST_SIZE , campaignMemberList.size(),'List size should be equal before resassign');
              
              controller.userId = userList.size() > 0 ? userList[0].Id : usr.Id;
              controller.contactIds = ContactIds;
              controller.reassignMember();
              //get campaign members after resassign all members
                          
              
              controller.campaignId = camp.Id;
              participantsList = controller.searchCampaignParticipants();
              System.assertEquals(0,participantsList.size(),'list size should be 0 as this campaign is not shared with another user');
              
              
              Test.stopTest();
          }
          if(userList.size() > 0) {
            System.runAs(usr) {
              List<CM_Campaigns_WS.CampaignMemberWrapper> campaignMemberList  = CM_CampaignMemberManager.getCampaignMembersforCurrentUser(camp.Id); 
              System.assertEquals(LIST_SIZE , campaignMemberList.size(),'List size should be equal before resassign');
              for(CM_Campaigns_WS.CampaignMemberWrapper cm : campaignMemberList) {
                String userName = usr.LastName ;
                userName += usr.FirstName <> null ? ', ' + usr.FirstName : '';
                //System.assertEquals(userName,cm.assignedByUserFullName,'User Name should match');
              }       
            }
          }
    }
    static void createData() {
        //T1C_CustomSettingsManager.setAllTriggerOn();  
        T1C_CustomSettingsManager.createChatterSetting();  
        CM_TestClassUtilities.SetCamapignLimitSettings();
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
        con.FirstName__c = 'TestContact_FirstAccount_' + indx;
        con.LastName__c = listAccounts[0].name;
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
      
      insert listContacts;
        camp = new Campaign__c();
        camp.Name = 'Test Campaign3';
        camp.Active__c = true; 
        camp.Status__c = 'Active';
        camp.Region__c = 'JP';
        camp.External_Id__c = 'Id_001';
        insert camp;
        
        
        camp2 = new Campaign__c();
        camp2.Name = 'Test Campaign002';
        camp2.Active__c = true; 
        camp2.Status__c = 'Active';
        camp2.Region__c = 'All';
        camp2.External_Id__c = 'Id_002';
        insert camp2;
        // share a campaign with other user     
        //CampaignShare cs = new CampaignShare();
        //cs.CampaignId = camp.Id;
        //cs.UserOrGroupId = currentUserId;
        //cs.CampaignAccessLevel = 'Read';
        //insert cs;
        
        lstCampaignMembers = new List<Campaign_Member__c>();
        lstCampaignMembersAssignment = new List<Campaign_Member_Assignment__c>();
        
      Integer index = 1;
      ContactIds = new List<Id>();
      for(GPSContact__c c : listContacts){
        Campaign_Member__c cM = new Campaign_Member__c(Campaign__c = camp.Id, GPSContact__c = c.Id, Campaign_Score__c = 1, Status__c = 'Responded', Reason__c = 'Reason' + index);
        lstCampaignMembers.add(cM);
        index++;
        ContactIds.add(c.Id);
        
          Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
           Assigned_by_Admin__c = true,
           Assigned_To__c = usr.id,
           Campaign__c = camp.Id,
           GPSContact__c = c.Id,
           Reassigned__c = false
        );
        
        lstCampaignMembersAssignment.add(cMA);
        
      }      
      
      insert lstCampaignMembers;  
      insert lstCampaignMembersAssignment;
  
    }
}