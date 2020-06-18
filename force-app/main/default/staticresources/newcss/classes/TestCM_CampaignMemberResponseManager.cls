// 03/16/2012 UV : ORIGINAL
//                      Test class for the manager class CM_CampaignMemberResponseManager
// 02/28/2013 UV : moved new contact instance to common_contactUtil class.
@isTest
private class TestCM_CampaignMemberResponseManager {
    static Campaign__c camp;
    static Campaign__c camp2;
    static Integer LIST_SIZE = 50;
    static User usr;
    static List<GPSContact__c> listContacts;
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
    
    static testMethod void CampaignMemberResponseTest() {
        T1C_CustomSettingsManager.setAllTriggerOn();
        System.runAs(usr) {
            Test.startTest();
            createData();
            List<Campaign_Member__c> cmList = [Select id, Campaign__c, GPSContact__c from Campaign_Member__c where Campaign__c = : camp.id];
            System.assertEquals(cmList.size(), LIST_SIZE, 'List of campaign members should be equal to list size');
            
            list<Campaign_Member_Assignment__c> cmAList = [Select id from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
            //as currently no CMAs are created for the CMs.
            System.assertEquals(0, cmAList.size(), 'List size of campaign members assignment should be equal to zero');
            
            List<Campaign_Member_Assignment__c> lstCampaignMembersAssignment = new List<Campaign_Member_Assignment__c>();
            for(Integer i = 0;i < (LIST_SIZE/2);i++) {
              Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
                 Assigned_by_Admin__c = true,
                 Assigned_To__c = Userinfo.getUserId(),
                 Campaign__c = camp.Id,
                 GPSContact__c = listContacts[i].Id,
                 Reassigned__c = false
              );
              
              lstCampaignMembersAssignment.add(cMA);
              
            }
            CM_CampaignMemberResponseManager.updateCampaignMemberAssignments(lstCampaignMembersAssignment);
            
            for(Campaign_Member_Assignment__c cma : lstCampaignMembersAssignment) {
                System.assert(cma.Responded__c,'User has Response for the CM. Response should be true');
                System.assertEquals(cma.Campaign_Status__c,'Responded' , 'Status should be updated to responed');
                System.assertEquals(cma.Reason__c,'Test Reason' , 'Reason should be updated to New_Updated_Reason');
                System.assertEquals(cma.Responded_By__c,Userinfo.getUserId() , 'user Ids should be match');
                System.assertEquals(cma.Campaign_Score__c,45,' The Score should match');
         }
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
        camp.External_Id__c = '1234';
        insert camp;
        
        camp2 = new Campaign__c();
        camp2.Name = 'Test Campaign_002';
        camp2.Status__c = 'Active';
        camp2.Region__c = 'All';
        camp2.External_Id__c = '1235';
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
        
        listContacts = new List<GPSContact__c>();
        //inserting Contacts
        for(Integer i = 0;i < LIST_SIZE;i++) {
          GPSContact__c con = new GPSContact__c();
          con = Common_ContactUtil.createContact(i, listAccounts[0].id); 
          listContacts.add(con);
          
        }
            insert listContacts;
            list<Campaign_Member__c> listMembers = new list<Campaign_Member__c>(); 
            
            List<Id> contactIds = new List<Id>();
            for(Integer i = 0;i < LIST_SIZE;i++) {
              Campaign_Member__c cm = new Campaign_Member__c();            
              cm.Campaign__c = camp.Id; 
              cm.GPSContact__c =  listContacts[i].Id;
              cm.Status__c = 'Responded';
              cm.Campaign_Score__c = 45;
              cm.Reason__c = 'Test Reason';
              cm.HasResponded__c = true;
              contactIds.add(listContacts[i].Id);
              listMembers.add(cm);
            }
            
            for(Integer i = 0;i < (LIST_SIZE/2);i++) {
              Campaign_Member__c cm2 = new Campaign_Member__c();              
              cm2.Campaign__c = camp2.Id;
              cm2.GPSContact__c = listContacts[i].Id;
              listMembers.add(cm2);
            }
            insert listMembers;
    }
    
}