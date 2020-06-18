@isTest
private class TestCampaignMemberStatusController {
    static Campaign__c camp;
    static Campaign__c camp2;
    static Integer LIST_SIZE = 10;
    static User usr;
    static List<GPSContact__c> listContacts;
    static{
         //Commented and Added By Aditya : JIRA 4438 : To Improve the performance of test Class
           //usr = getAdminUser()[0];
        // temp user
       // usr =   CM_TestClassUtilities.getTempUser();
    }

private static testmethod void testaddRow(){
    // System.runAs() {
        Test.startTest();
        createData();
        Apexpages.currentPage().getParameters().put('cid', camp.id);
        
        CampaignMemberStatusController statuscon = new CampaignMemberStatusController();
        system.assertEquals(statuscon.memberStatuses[0].Name , 'Sent');
        
        CampaignMemberStatus__c newstatus= new CampaignMemberStatus__c();
        newstatus.Name = 'test';
        newstatus.HasResponded__c = false;
        newstatus.IsDefault__c = false;
        CampaignMemberStatusController cms =  new CampaignMemberStatusController();
        cms.addRow();
        Test.stopTest();
    // }
}


private static testmethod void testeditMember(){
    // System.runAs() {
        Test.startTest();
        createData();
        Apexpages.currentPage().getParameters().put('cid', camp.id);
        
        CampaignMemberStatusController statuscon = new CampaignMemberStatusController();
        system.assertEquals(statuscon.memberStatuses[0].Name , 'Sent');
        
        CampaignMemberStatus__c newstatus= new CampaignMemberStatus__c();
        newstatus.Name = 'test';
        newstatus.HasResponded__c = false;
        newstatus.IsDefault__c = false;
        CampaignMemberStatusController cms =  new CampaignMemberStatusController();
        cms.editMember();
        Test.stopTest();
    // }
}
private static testmethod void testCanceleditMember(){
    // System.runAs() {
        Test.startTest();
        createData();
        Apexpages.currentPage().getParameters().put('cid', camp.id);
        
        CampaignMemberStatusController statuscon = new CampaignMemberStatusController();
        system.assertEquals(statuscon.memberStatuses[0].Name , 'Sent');
        
        CampaignMemberStatus__c newstatus= new CampaignMemberStatus__c();
        newstatus.Name = 'test';
        newstatus.HasResponded__c = false;
        newstatus.IsDefault__c = false;
        CampaignMemberStatusController cms =  new CampaignMemberStatusController();
        cms.CanceleditMember();
        Test.stopTest();
    // }
}
private static testmethod void testReplaceMember(){
    // System.runAs() {
        Test.startTest();
        createData();
        Apexpages.currentPage().getParameters().put('cid', camp.id);
        
        CampaignMemberStatusController statuscon = new CampaignMemberStatusController();
        system.assertEquals(statuscon.memberStatuses[0].Name , 'Sent');
        
        CampaignMemberStatus__c newstatus= new CampaignMemberStatus__c();
        newstatus.Name = 'test';
        newstatus.HasResponded__c = false;
        newstatus.IsDefault__c = false;
        CampaignMemberStatusController cms =  new CampaignMemberStatusController();
        cms.ReplaceMember();
        Test.stopTest();
    // }
}
private static testmethod void saveAndReturn(){
    //System.runAs(usr) {
        Test.startTest();
        createData();
        list<CampaignMemberStatus__c>memberStatuses = [SELECT Name, Campaign__c, Campaign__r.Name, Active__c, HasResponded__c, IsDefault__c, Status__c, Type__c FROM CampaignMemberStatus__c WHERE Campaign__c =: camp.Id];
        list<Campaign_Member__c>CampaignMem =[SELECT Name, Campaign__c , Status__c, HasResponded__c FROM Campaign_Member__c WHERE Campaign__c =: camp.Id];
        ApexPages.currentPage().getParameters().put('cid',camp.Id);
        CampaignMemberStatusController cms =  new CampaignMemberStatusController();
        cms.saveAndReturn();
        
        System.assertEquals(10, CampaignMem.size(), 'List size of Campaign members assignment should be equal to ten');
        System.assertEquals(2, memberStatuses.size(), 'List size of Campaign Status assignment should be equal to 2');
        Test.stopTest();
    //}
}

private static testmethod void SaveReplace(){
        Test.startTest();
        createData();
        list<CampaignMemberStatus__c>memberStatuses = [SELECT Name, Campaign__c, Campaign__r.Name, Active__c, HasResponded__c, IsDefault__c, Status__c, Type__c FROM CampaignMemberStatus__c WHERE Campaign__c =: camp.Id];
        list<Campaign_Member__c>CampaignMem =[SELECT Name, Campaign__c , Status__c, HasResponded__c FROM Campaign_Member__c WHERE Campaign__c =: camp.Id];
        ApexPages.currentPage().getParameters().put('Cid',camp.Id);
        CampaignMemberStatusController cms =  new CampaignMemberStatusController();
        cms.SaveReplace();
        
        System.assertEquals(10, CampaignMem.size(), 'List size of Campaign members assignment should be equal to ten');
        System.assertEquals(2, memberStatuses.size(), 'List size of Campaign Status assignment should be equal to 2');
        Test.stopTest();
}

public static List<User> getAdminUser(){
       
        List<Profile> testUserProfile = [SELECT Id FROM Profile WHERE name='All MS Employee' ];
        User adminUser = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = testUserProfile[0].Id,                                 
                                 timezonesidkey = 'America/Los_Angeles', username = 'T'+String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','')+Integer.valueOf(math.rint(math.random()*1000000))+ '@morganstanley.com',
                                 Emp_Id__c = 'test1', isActive = true);
        insert adminUser;
        List<User> testUsrList = [select id,Emp_Id__c,Alias,Email from user where ProfileID =:testUserProfile[0].ID and isActive = true ]; 
        return testUsrList;
    }
static void createData() {
        
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
    
    private static testmethod void testStatusValue()
    {
        createData();
        Apexpages.currentPage().getParameters().put('cid', camp.id);
        CampaignMemberStatusController cmp = new CampaignMemberStatusController();
        cmp.getStatusValues();
        //.getStatusValues();
        //List<SelectOption> options = new List<SelectOption>();
        
    }
}