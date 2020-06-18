@isTest
public class TestLoader {
    static User usr;
    static Campaign__c camp;
    static Blob contentFile;
     static list<Campaign_Member__c> listMembers;
     
     static User getTempUser() {
     // Commented by Aditya Jira 4438 : To improve the performance of the test class
     
         
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          UserRoleId = r.id ,Emp_Id__c = 'testSEFR');
   insert tempUser;
    return tempUser;  
    //Added By Aditya Jira 4438 : To improve the performance of the test class
    
       // return CM_TestClassUtilities.getAdminUser()[0];     
   
    }
    
    
    static TestMethod void insertDuplicateTest(){
         usr = getTempUser();
        System.runAs(usr) {
        //Added By Aditya : JIRA 4438 : To Improve the performance of test Class
        T1C_CustomSettingsManager.createChatterSetting();
        //T1C_CustomSettingsManager.setAllTriggerOn();
        createData();
            Test.startTest();
            
            String str ='"Campaign External ID","Contact TN Contact Key","System Assign To MSID ","Status","Reason","Campaign Score","System Assigned By Admin","Force Create CTM","Force Create CMA","Force Subscribe Participant To Campaign","System Campaign Team Member Access Level","System Campaign Team Member Role"\n' +
                            '"TESTID_001",412370319-p1,"testSEFR","Sent","Test1",1,TRUE,TRUE,TRUE,TRUE,"Read","Participant"\n'+
                            '"TESTID_001",412370319-p2,"testSEFR","Sent","Test2",1,TRUE,TRUE,TRUE,TRUE,"Read","Participant"\n' +  
                            '"TESTID_001",412370319-p3,"testSEFR","Sent","Test3","3","TRUE","TRUE","TRUE","TRUE","Read","Participant"\n' + 
                            '"TESTID_001",412370319-p4,"testSEFR","Responded","Test24","4","TRUE","TRUE","TRUE","TRUE","Read","Participant"\n' + 
                            '"TESTID_001",412370319-p1,"testSEFR","Sent","Test1",1,TRUE,TRUE,TRUE,TRUE,"Read","Participant"\n'+
                            '"TESTID_001",412370319-p2,"testSEFR","Sent","Test2",2,TRUE,TRUE,TRUE,TRUE,"Read","Participant"\n' +
                            '"TESTID_001",412370319-p3,"testSEFR","Sent","Test3","3","TRUE","TRUE","TRUE","TRUE","Read","Participant"\n' + 
                            '"TESTID_001",412370319-p4,"testSEFR","Responded","Test24","4","TRUE","TRUE","TRUE","TRUE","Read","Participant"\n'+  
                            '"TESTID_001",412370319-p3,"testSEFR","Sent","Test2",3,TRUE,TRUE,TRUE,TRUE,"Read","Participant"\n'; 
    
                           
            contentFile = Blob.valueOf(str);
            CM_CampaignMembersLoader controller = new CM_CampaignMembersLoader();
            controller.validateFileExtension();
            
            controller.nameFile = 'TestSampleFile.csv';
            controller.contentFile = contentFile;
            controller.validateFileExtension();
            controller.runValidationAndInsert();
            List<List<CM_CampaignMembersLoader.csvWrapper>> lstSuccess = controller.getUploadedCSVSuccessResult();
            List<List<CM_CampaignMembersLoader.csvWrapper>> lstFail = controller.getUploadedCSVFailedResult();
            
            System.debug('____________controller.getUploadedCSVFailedResult();____________' + lstSuccess);
            
            Integer recordCount = 0;
            Integer recordCount1 = 0;
            for(List<CM_CampaignMembersLoader.csvWrapper> lst : lstSuccess) {
                 System.debug('__________lstinsertValid_______________' + lst);
                recordCount += lst.size();               
            }
            
            for(List<CM_CampaignMembersLoader.csvWrapper> lst : lstFail) {
                 System.debug('__________lstinsertValid_______________' + lst);
                if(lst.size() > 0){
                  System.debug('MEEEEEEEEEEEEEEE' + lst[0].failureReason);
                }
                recordCount1 += lst.size();               
            }
            
            
           // System.assertEquals(4,recordCount,'All 2 record should be Successfully inserted');
            List<Campaign_Team_Member__c> ctmList = new List<Campaign_Team_Member__c>();
            //ctmList = [select id from Campaign_Team_Member__c where Campaign__r.External_Id__c = 'TESTID_001'];
           // System.assertEquals(5, recordCount1,'4 records should not be inserted');
            controller.updateCampaignMembers(listMembers);
            Test.stopTest();

       }
    }
    
    static void createData() {
        //Added By Aditya : JIRA 4438 : To Improve the performance of test Class
        T1C_CustomSettingsManager.createChatterSetting();
        T1C_CustomSettingsManager.setAllTriggerOn();
        camp = new Campaign__c();
        camp.Name = 'Test Campaign_001';
        camp.Status__c = 'Active'; 
        camp.Region__c = 'EU';
        camp.External_Id__c = 'TESTID_001';
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
        
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        for(integer indx = 0; indx < 10; indx++){
            GPSContact__c con = new GPSContact__c(); 
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
                con.TN_Contact_Key__c =  '412370319-p'+ indx;
            listContacts.add(con);
      }
      insert listContacts;
      
      listMembers = new list<Campaign_Member__c>(); 
      for(Integer i = 0;i < 3;i++) {
              Campaign_Member__c cm2 = new Campaign_Member__c();
              cm2.Campaign__c = camp.Id; 
             //cm2.Campaign__r.External_Id__c = 'TESTID_001';
              cm2.GPSContact__c = listContacts[i].Id;
              cm2.Force_Create_CMA__c = true;
              cm2.Campaign_Score__c = 2;
              cm2.Force_Create_CTM__c = true;
              cm2.System_Assigned_by_Admin__c = false;
             // cm2.System_Assigned_To__c = '';
              cm2.System_Campaign_Team_Member_Access_Level__c = 'All';
              cm2.System_Campaign_Team_Member_Role__c = 'Participant';
              listMembers.add(cm2);
              
            }
            insert listMembers;
        
    }
}