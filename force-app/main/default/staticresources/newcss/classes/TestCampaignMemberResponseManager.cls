//
//  3/15/2012 UV: ORIGINAL
//                 Test class for CampaignMemberResponseManagement.trigger 
//
//01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on GPSContact__c chages. use Common_ContactUtil class to create GPSContact__c.
//4 June 2013        Dinesh Moundekar    :CRMGPS-4187 Inserted @isTest
@isTest
private class TestCampaignMemberResponseManager {
        static Campaign__c camp;
    static Campaign__c camp2;
    static Integer LIST_SIZE = 50;
    static User usr;
    static List<GPSContact__c> listContacts;
    static{
         //Commented and Added By Aditya : JIRA 4438 : To Improve the performance of test Class
           usr = getAdminUser()[0];
        // temp user
       // usr =   CM_TestClassUtilities.getTempUser();
    }
    
    
    static testMethod void campaignMemberResponseTest() {
        System.runAs(usr) {
            Test.startTest();
            createData();
            List<Campaign_Member__c> cmList = [Select id, Campaign__c, GPSContact__c from Campaign_Member__c where Campaign__c = : camp.id];
            System.assertEquals(cmList.size(), LIST_SIZE, 'List of Campaign__c members should be equal to list size');
            
            list<Campaign_Member_Assignment__c> cmAList = [Select id from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
            //as currently no CMAs are created for the CMs.
            System.assertEquals(0, cmAList.size(), 'List size of Campaign__c members assignment should be equal to zero');
            
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
            insert lstCampaignMembersAssignment;
            
            cmAList = [Select id,Responded__c, Reason__c,Responded_By__c, Campaign_Score__c, Campaign_Status__c  from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
            //as currently no CMAs are created for the CMs.
            System.assertEquals(LIST_SIZE/2, cmAList.size(), 'List of Campaign__c members assignment should be equal to half of list size');
            for(Campaign_Member_Assignment__c cma : cmaList) {
                System.assert(cma.Responded__c,'User has Response for the CM. Response should be true');
                System.assertEquals(cma.Campaign_Status__c,'Responded' , 'Status should be updated to responed');
                System.assertEquals(cma.Reason__c,'Test Reason' , 'Reason should be updated to New_Updated_Reason');
                System.assertEquals(cma.Responded_By__c,Userinfo.getUserId() , 'user Ids should be match');
                System.assertEquals(cma.Campaign_Score__c,45,' The Score should match');
         }
        Test.stopTest();
        }
    }
    
    public static List<User> getAdminUser(){
        //TestClassUtilities.setAllTriggerOn();
       // T1C_CustomSettingsManager.setAllTriggerOn();
        List<Profile> testUserProfile = [SELECT Id FROM Profile WHERE name='System Administrator' ];
        User adminUser = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = testUserProfile[0].Id,                                 
                                 timezonesidkey = 'America/Los_Angeles', username = 'T'+String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','')+Integer.valueOf(math.rint(math.random()*1000000))+ '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test1', isActive = true);
        insert adminUser;
        List<User> testUsrList = [select id,Emp_Id__c,Alias,Email from user where ProfileID =:testUserProfile[0].ID and isActive = true ]; 
        return testUsrList;
    }
    
    static void createData() {
        CM_TestClassUtilities.SetCamapignLimitSettings();
        //Added By Aditya : JIRA 4438 : To Improve the performance of test Class
        T1C_CustomSettingsManager.createChatterSetting();
        T1C_CustomSettingsManager.setAllTriggerOn();
        //insert Campaign__c
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
          //01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on GPSContact__c chages. use Common_ContactUtil class to create GPSContact__c.
          GPSContact__c con ;
          
          if(Math.mod(i, 2) == 0){
              con = common_ContactUtil.createContact(i,listAccounts[0].id);
          }else{
              con = common_ContactUtil.createContact(listAccounts[0].id,i,'English Only');
          }
          listContacts.add(con);
          
        }
            insert listContacts;
            list<Campaign_Member__c > listMembers = new list<Campaign_Member__c >(); 
            
            List<Id> contactIds = new List<Id>();
            for(Integer i = 0;i < LIST_SIZE;i++) {
              Campaign_Member__c     cm = new Campaign_Member__c    ();            
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