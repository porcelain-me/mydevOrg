// 09/28/2011 UV: ORIGINAL  
//                Test class for CM_CampaignMemberManager                
// 01/3/2013 : UV : move new contact instance in Common_ContactUtil Class. 
@isTest
private class TestCM_CampaignMemberManager {

    static Campaign__c camp;
    static Campaign__c camp2;
    static User usr;
    static List<Id> campaignMemberToBeRemoved;
    static Integer LIST_SIZE = 50;
    static List<Id> contactIds;
    static List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment; 
    static list<Campaign_Member__c> listMembers;
    
    static{
        // temp user
       //usr =   CM_TestClassUtilities.getTempUser();
       usr =   TestCM_CampaignMemberManager.getTempUser();
    }
    
     static User getTempUser(){
        Profile p = [select id from Profile where Name = 'System Administrator'];
        
        User u = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, 
                                // T1C_User_Short_ID__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test1', isActive = true);
        return u;
    }
    
    static testMethod void CampaignMembersTest() {
       //T1C_CustomSettingsManager.setAllTriggerOn();
       System.runAs(usr) {
           Test.startTest();
           createData();
           list<CM_Campaigns_WS.CampaignMemberWrapper> memberWrapperList = CM_CampaignMemberManager.getCampaignMembersforCurrentUser(camp.Id);
           System.assertEquals(LIST_SIZE,memberWrapperList.size(),'Members in this Campaign should be equals to LIST_SIZE');
           
           CM_CampaignMemberManager controller = new CM_CampaignMemberManager();
           controller.campaignId = camp2.Id;
           list<CM_Campaigns_WS.CampaignMemberWrapper> campMemberList = controller.getCampaignMembersforCurrentUser();
           System.assertEquals((LIST_SIZE/2),campMemberList.size(),'Members in this Campaign should be equals to (LIST_SIZE/2)');
           Test.stopTest();
       }
       
    }
    
    static testMethod void removeCampaignMembersforCurrentUserTest(){
        //T1C_CustomSettingsManager.setAllTriggerOn();
         System.runAs(usr) {
           Test.startTest();
           createData(); 
           CM_CampaignMemberManager controller = new CM_CampaignMemberManager();
           controller.campaignId = camp2.Id;
           
           list<CM_Campaigns_WS.CampaignMemberWrapper> campMemberList = controller.getCampaignMembersforCurrentUser();
           System.assertEquals((LIST_SIZE/2),campMemberList.size(),'Members in this Campaign should be equals to (LIST_SIZE/2)');
           
           campaignMemberToBeRemoved = new List<Id>();
           campaignMemberToBeRemoved.add(campMemberList[campMemberList.size() - 1].Contactid);
           campaignMemberToBeRemoved.add(campMemberList[campMemberList.size() - 2].Contactid);
           
           controller.contactIds = campaignMemberToBeRemoved;
           
           CM_Campaigns_WS.CustomMessage cM = controller.removeCampaignMembersforCurrentUser();
           System.assertEquals(cM.message, '2 Contacts has been removed. ', 'message should match');
           
           campMemberList = controller.getCampaignMembersforCurrentUser();
           System.assertEquals((LIST_SIZE/2) - 2,campMemberList.size(),'Members in this Campaign member list should be reduced by 2 numbers');
           
           Test.stopTest();
       }
    }
    static testMethod void getSelectedCampaignMemberWrapperTest() {
        //T1C_CustomSettingsManager.setAllTriggerOn();
        System.runAs(usr) {
            Test.startTest();
            createData();
            
            List<CM_Campaigns_WS.CampaignMemberWrapper>  lstCampMemberWrapper = CM_CampaignMemberManager.getSelectedCampaignMemberWrapper(camp.Id, contactIds);
            System.assertEquals(LIST_SIZE, lstCampMemberWrapper.size(),'List Size should match');
            Test.stopTest();
        }
    }
    static testMethod void getCampaignMemberDetailTest() {
        //T1C_CustomSettingsManager.setAllTriggerOn();
        System.runAs(usr) {
            Test.startTest();
            createData();
            CM_Campaigns_WS.CampaignMemberWrapper cmw = CM_CampaignMemberManager.getCampaignMemberDetail(listMembers[0].Id);
            System.assertEquals(camp.Id, cmw.campaignId, 'campaign Id should match');
            Test.stopTest();
        }
    }
    static void createData() {
            T1C_CustomSettingsManager.createChatterSetting();
            T1C_CustomSettingsManager.setAllTriggerOn();
            CM_TestClassUtilities.SetCamapignLimitSettings();
            //insert Campaign
            camp = new Campaign__c();
            camp.Name = 'Test Campaign_001';
            camp.Status__c = 'Active';
            camp.Region__c = 'EU';
            camp.External_Id__c = 'ID_001';
            insert camp;
            
            camp2 = new Campaign__c();
            camp2.Name = 'Test Campaign_002';
            camp2.Status__c = 'Active';
            camp2.Region__c = 'All';
            camp2.External_Id__c = 'ID_002';
            insert camp2;
            
            List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();        
            GPSAccount__c acc1= new GPSAccount__c();
            acc1.name = 'acc1';
            acc1.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss');
            //acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
            acc1.Active_Flag__c = true;
            listAccounts.add(acc1);     
              
            insert listAccounts;
          
          
            //Create test contacts
            
            List<GPSContact__c> listContacts = new List<GPSContact__c>();
            //inserting Contacts
            for(Integer i = 0;i < LIST_SIZE;i++) {
                GPSContact__c con = new GPSContact__c();
                String accId = listAccounts[0].id;
                con = Common_ContactUtil.createContact(i, accId);
                listContacts.add(con);
            }
            insert listContacts;
            listMembers = new list<Campaign_Member__c>(); 
            lstCampaignMembersAssignment = new List<Campaign_Member_Assignment__c>();
            
            contactIds = new List<Id>();
            for(Integer i = 0;i < LIST_SIZE;i++) {
                Campaign_Member__c cm = new Campaign_Member__c();            
                cm.Campaign__c = camp.Id; 
                cm.GPSContact__c =  listContacts[i].Id;
                cm.Status__c = 'Pending';
                contactIds.add(listContacts[i].Id);
                listMembers.add(cm);
                
                Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
                       Assigned_by_Admin__c = true,
                       Assigned_To__c = Userinfo.getUserId(),
                       Campaign__c = camp.Id,
                       GPSContact__c = listContacts[i].Id,
                       Reassigned__c = false
                    );
                    
                    lstCampaignMembersAssignment.add(cMA);
                
            }
            
            
            for(Integer i = 0;i < (LIST_SIZE/2);i++) {
                Campaign_Member__c cm2 = new Campaign_Member__c();              
                cm2.Campaign__c = camp2.Id; 
                cm2.GPSContact__c = listContacts[i].Id;
                cm2.Status__c = 'Pending';
                listMembers.add(cm2);
                
                
                Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
                 Assigned_by_Admin__c = true,
                 Assigned_To__c = Userinfo.getUserId(),
                 Campaign__c = camp2.Id,
                 GPSContact__c = listContacts[i].Id,
                 Reassigned__c = false
              );
              
              lstCampaignMembersAssignment.add(cMA);
                
            }
            
            
            insert listMembers;
            insert lstCampaignMembersAssignment;
            
            
    }
}