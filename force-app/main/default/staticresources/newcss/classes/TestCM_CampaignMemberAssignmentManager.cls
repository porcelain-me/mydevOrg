//
//  10/11/2011 RJ: ORIGINAL
//                 Test class for CM_CampaignMemberAssignmentManager.cls 
//01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on contact chages. use Common_ContactUtil class to create contact.
//
@isTest
private class TestCM_CampaignMemberAssignmentManager {
    static Campaign__c camp;
    static Campaign__c camp2;
    static User usr;
    static List<Id> campaignMemberToBeRemoved;
    static Integer LIST_SIZE = 50;
    static List<Id> contactIds;
    static list<Campaign_Member__c> listMembers; 
    static{
        // temp user
       usr =   CM_TestClassUtilities.getTempUser();
    }
    public static User getSysAdminTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          UserRoleId = r.id ,Emp_Id__c='testADMIN');
  
    return tempUser;        
   }
    /*static testMethod void deleteCampaignMemberAssignmentsTest() {        
       System.runAs(usr){
         Test.startTest();
         createData();
         
         CM_CampaignMemberAssignmentManager.insertCampaignMemberAssignments(listMembers);
         List<Campaign_Member__c> cmList = [Select id, Campaign__c, GPSContact__c from Campaign_Member__c where Campaign__c = : camp.id];
         List<Campaign_Member_Assignment__c> cmAList = [Select id from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         
         System.assertEquals(cmList.size(), cmAList.size(), 'List of campaign members should be equal to campaign member assignment');
         
         CM_CampaignMemberAssignmentManager.deleteCampaignMemberAssignments(cmList);
         
         
         cmAList = [Select id from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         
         System.assertEquals(cmAList.size(), 0,'There should be no CMA items now for this campaign as we have deleted all the campaign members');         
          
         Test.stopTest();       
       }       
    }*/
    static testMethod void insertDuplicateCampaignMemberAssignmentsTest() {
        User adminUser = getSysAdminTempUser();
        
        
        System.runAs(adminUser){
        createData();
         Test.startTest();
         
         List<Campaign_Member__c> cmList = [Select id, Campaign__c, GPSContact__c,System_Assigned_To__c,System_Assigned_To__r.Emp_Id__c from Campaign_Member__c where Campaign__c = : camp.id];
         List<Campaign_Member_Assignment__c> cmAList = [Select id from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         
         System.debug('1#*:'+cmList.size());
         System.debug('2#*:'+cmAList.size());
         System.assertEquals(cmList.size(), cmAList.size(), 'List of campaign members should be equal to campaign member assignment');
         Set<id> userIds = new Set<Id>();
        for(Campaign_Member__c cm : cmList) {
            userIds.add(cm.System_Assigned_To__c);
        }
        List<User> usrList = [Select u.Id, u.IsActive,Emp_Id__c From User u where u.IsActive = true AND Emp_Id__c = 'testADMIN' AND u.Id NOT IN : userIds];
        Integer i = 0;  
        for(Campaign_Member__c cm : cmList) {
            cm.System_Assigned_To__c =   usrList[0].ID ; 
         }
         update cmList;
         
         cmList = [Select id, Campaign__c, GPSContact__c,System_Assigned_To__c,System_Assigned_To__r.Emp_Id__c,Force_Create_CMA__c
                        ,GPSContact__r.TN_Contact_Key__c,Campaign__r.External_Id__c,System_Assigned_by_Admin__c
                         from Campaign_Member__c where Campaign__c = : camp.id];
         
         System.debug('__________ex___' + cmList[0].System_Assigned_To__r.Emp_Id__c);
         CM_CampaignMemberAssignmentManager.insertDuplicateCampaignMemberAssignments(cmList);
         cmAList = [Select id from Campaign_Member_Assignment__c where Campaign__c = : camp.id];
         System.debug('3#*:'+cmList.size());
         System.debug('4#*:'+cmAList.size());
         System.assertEquals(100, cmAList.size(), 'List size should be equal to campaign member assignment');
         
         for(Campaign_Member__c cm : cmList) {
            cm.System_Assigned_by_Admin__c =   true; 
         }
         update cmList;
         
         cmList = [Select id, Campaign__c, GPSContact__c,System_Assigned_To__c,System_Assigned_To__r.Emp_Id__c,Force_Create_CMA__c
                        ,GPSContact__r.TN_Contact_Key__c,Campaign__r.External_Id__c,System_Assigned_by_Admin__c
                         from Campaign_Member__c where Campaign__c = : camp.id];
         
         CM_CampaignMemberAssignmentManager.insertDuplicateCampaignMemberAssignments(cmList);
         Test.stopTest();
        }
    }    
    static void createData() {
        //TestClassUtilities.setAllTriggerOn();
        GPSTrigger_Switch__c dSwitch = new GPSTrigger_Switch__c(SetupOwnerId=UserInfo.getUserID());
        dSwitch.Is_CMAssignManagement_Trigger_On__c = true;
        insert dSwitch;
        
        GPSTrigger_Switch__c testSwitch = GPSTrigger_Switch__c.getInstance();
        
        System.debug('testSwitch:'+testSwitch);
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
        // 01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on contact chages. use Common_ContactUtil class to create contact.
          GPSContact__c con ;
          if(Math.mod(i, 2) == 0){
              con = common_ContactUtil.createContact(i,listAccounts[0].id);
          }else{
              con = common_ContactUtil.createContact(listAccounts[0].id,i,'English Only');
          }
          listContacts.add(con);
          
        }
            insert listContacts;
            listMembers = new list<Campaign_Member__c>(); 
            List<User> usrList = [Select u.Id, u.IsActive , Emp_Id__c From User u where u.IsActive = true limit 2];
            
            
            for(Integer i = 0;i < LIST_SIZE;i++) {
              Campaign_Member__c cm2 = new Campaign_Member__c();
              cm2.Campaign__c = camp.Id; 
              cm2.GPSContact__c = listContacts[i].Id;
              cm2.Force_Create_CMA__c = true;
              cm2.Campaign_Score__c = 2;
              cm2.Force_Create_CTM__c = true;
              cm2.System_Assigned_by_Admin__c = false;
              cm2.System_Assigned_To__c = (usrList.size() == 2 ?  usrList[0].Id : usr.Id);
              cm2.System_Campaign_Team_Member_Access_Level__c = 'All';
              cm2.System_Campaign_Team_Member_Role__c = 'Participant';
              listMembers.add(cm2);
              
            }
            
            
            for(Integer i = 0;i < (LIST_SIZE/2);i++) {
              Campaign_Member__c cm2 = new Campaign_Member__c();
              cm2.Campaign__c = camp2.Id; 
              cm2.GPSContact__c = listContacts[i].Id;
              cm2.Force_Create_CMA__c = true;
              cm2.Campaign_Score__c = 2;
              cm2.Force_Create_CTM__c = true;
              cm2.System_Assigned_by_Admin__c = false;
              cm2.System_Assigned_To__c = (usrList.size() == 2 ?  usrList[0].Id : usr.Id);
              cm2.System_Campaign_Team_Member_Access_Level__c = 'All';
              cm2.System_Campaign_Team_Member_Role__c = 'Participant';
              listMembers.add(cm2);
              
            }
            
            
            insert listMembers;
            
            
            
    }
}