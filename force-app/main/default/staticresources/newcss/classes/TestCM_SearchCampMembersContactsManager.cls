//10/01/2011 UV : ORGINAL
//                  Test Class for CM_SearchCampaignMembersContactsManager
//
//
//01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on contact chages. use Common_ContactUtil class to create contact.
@isTest
private class TestCM_SearchCampMembersContactsManager {

    static Campaign__c camp;
    static Campaign__c camp2;
    static User usr;
    static Integer LIST_SIZE = 50;
    static List<Id> contactIds;
    static List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment;  
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
    
    static testMethod void getSearchCampaignMembersContactsTest() {
        T1C_CustomSettingsManager.setAllTriggerOn();      
       System.runAs(usr) {
           Test.startTest();
           createData();
           CM_SearchCampaignMembersContactsManager controller = new CM_SearchCampaignMembersContactsManager();
           controller.campaignId = camp2.Id;
           //controller.searchString = 'TestContact_FirstAccount_001';
           controller.searchString = Common_ContactUtil.firstName; 
           List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper> contactWrapperList = controller.getSearchCampaignMembersContacts();
           System.assertEquals(LIST_SIZE, contactWrapperList.size(),'Conatcts List size should be half of the LIST_SIZE');
           integer indx = 0;
           for(CM_Campaigns_WS.SearchCampaignMembersContactsWrapper sCMCW : contactWrapperList){
            if(sCMCW.isCampaignMember){
                indx++;
            }
           }
           //02/24/2012 UV : updated the assert as now isCampaignMember would be CMA for another user 
           System.assertEquals(0, indx, 'There should be no CMA created for any other user');
           Test.stopTest();
       }
       
    }
    
    static testMethod void addCampaignMembersforCurrentUserTest() {
        T1C_CustomSettingsManager.setAllTriggerOn();      
       System.runAs(usr) {
           Test.startTest();
           createData();
           CM_SearchCampaignMembersContactsManager controller = new CM_SearchCampaignMembersContactsManager();
           controller.campaignId = camp2.Id;
           controller.contactIds = contactIds;
           controller.searchString = 'TestContact_FirstAccount_001';
           CM_Campaigns_WS.addCampaignMembersforCurrentUserResult cM = controller.addCampaignMembersforCurrentUser();
           System.assertEquals(cM.CustomMessage.message , '2 Contacts has been added. ', 'Message should match');
           
           List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper> contactWrapperList = controller.getSearchCampaignMembersContacts();
           integer indx = 0;
           for(CM_Campaigns_WS.SearchCampaignMembersContactsWrapper sCMCW : contactWrapperList){
            if(sCMCW.isCampaignMember){
                indx++;
            }
           }
           //02/24/2012 UV : updated the assert as now isCampaignMember would be CMA for another user
           System.assertEquals(0, indx, 'There should be no CMA created for any other user');
           
           Test.stopTest();
       }
       
    }
    
    static void createData() {
            T1C_CustomSettingsManager.createChatterSetting();
            CM_TestClassUtilities.SetCamapignLimitSettings();
            T1C_CustomSettingsManager.setAllTriggerOn(); 
            //insert Campaign
            camp = new Campaign__c();
            camp.Name = 'Test Campaign_001';
            camp.Status__c = 'Active';
            camp.Region__c = 'EU';
            camp.External_Id__c = '112323';
            insert camp;
            
            camp2 = new Campaign__c();
            camp2.Name = 'Test Campaign_002';
            camp2.Status__c = 'Active';
            camp2.Region__c = 'All';
            camp2.External_Id__c = '112';
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
            //01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on contact chages. use Common_ContactUtil class to create contact.
            for(Integer i = 0;i < LIST_SIZE;i++) {
                GPSContact__c con = common_ContactUtil.createContact(listAccounts[0].id,i,'English Only');
                //con.firstName= 'TestContact_FirstAccount_001';
                listContacts.add(con);
            }
        insert listContacts;
        
        
        list<Campaign_Member__c> listMembers = new list<Campaign_Member__c>(); 
        lstCampaignMembersAssignment = new List<Campaign_Member_Assignment__c>();
        // for campaign 1
        for(Integer i = 0;i < LIST_SIZE;i++) {
                Campaign_Member__c cm = new Campaign_Member__c();                
                cm.Campaign__c = camp.Id; 
                cm.GPSContact__c =  listContacts[i].Id;
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
        // for campaign 2
        for(Integer i = 0;i < (LIST_SIZE/2);i++) {
                Campaign_Member__c cm2 = new Campaign_Member__c();                
                cm2.Campaign__c = camp2.Id; 
                cm2.GPSContact__c = listContacts[i].Id;
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
        
        
        contactIds = new List<Id>();
        contactIds.add(listContacts[(LIST_SIZE/2) + 1].Id);
        contactIds.add(listContacts[(LIST_SIZE/2) + 2].Id);    
            
    }
}