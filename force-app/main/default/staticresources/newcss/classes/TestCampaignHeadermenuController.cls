@isTest
private class TestCampaignHeadermenuController{
    /*
     User usr and method getTempUser design copied from TestDataUtil
    */
    public final static String CAMPAIGN_URL = '/apex/campaigns';
    public final static String IIFan_URL = '/apex/iifanclub';
    public final static String IICampaign_URL = '/apex/myiilist';
    public final static String LoginAs_URL = '/apex/CampaignUserLoginAsView';   
    public final static String SetUp_URL = '/apex/SFDCSetup';   
    private static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        //UserRole rle = [SELECT Id FROM UserRole WHERE name='Campaign User'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', ProfileId = p.Id,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          Short_Id__c = 'testSEFR',Emp_Id__c = 'TESTSEFR', isActive = true);
        
        insert tempUser;
        
        
        
        return tempUser;        
   }
   
    static User usr;
    static GPSEmployee__c e;
    static{
       // temp user
       usr =  getTempUser();//DataUtil.getTestUserWithRole();
    }
   public static void createData() {
        e = new GPSEmployee__c();
        e.Name = 'test';
        e.Division__c = 'Research';
        e.MS_ID__c = 'TESTSEFR';
        e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.IsUseMyContactList__c = True;
        e.Active_Flag__c = true;
        e.Chatter_Disclaimer_Acknowledged__c = false;
        insert e;   
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'GPS_Campaign_Permission_Set'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = usr.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
    }
    
    public static void createData1() {
        e = new GPSEmployee__c();
        e.Name = 'test';
        e.Division__c = 'Research';
        e.MS_ID__c = 'TESTSEFR';
        e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.IsUseMyContactList__c = True;
        e.Active_Flag__c = true;
        e.Chatter_Disclaimer_Acknowledged__c = false;
        insert e;   
        
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'IIFanClub_Permission_Set'];
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = usr.Id;
        psa1.PermissionSetId = ps1.Id;
        insert psa1;
    }
    
    public static void createData2() {
        e = new GPSEmployee__c();
        e.Name = 'test';
        e.Division__c = 'Research';
        e.MS_ID__c = 'TESTSEFR';
        e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.IsUseMyContactList__c = True;
        e.Active_Flag__c = true;
        e.Chatter_Disclaimer_Acknowledged__c = false;
        insert e;   
        
        PermissionSet ps2 = [SELECT Id FROM PermissionSet WHERE Name = 'IICampaign_Permission_Set'];
        PermissionSetAssignment psa2 = new PermissionSetAssignment();
        psa2.AssigneeId = usr.Id;
        psa2.PermissionSetId = ps2.Id;
        insert psa2;
    }
    
    public static void createData3() {
        e = new GPSEmployee__c();
        e.Name = 'test';
        e.Division__c = 'Research';
        e.MS_ID__c = 'TESTSEFR';
        e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.IsUseMyContactList__c = True;
        e.Active_Flag__c = true;
        e.Chatter_Disclaimer_Acknowledged__c = false;
        insert e;   
        
        PermissionSet ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'Campaign_Admin'];
        PermissionSetAssignment psa3 = new PermissionSetAssignment();
        psa3.AssigneeId = usr.Id;
        psa3.PermissionSetId = ps3.Id;
        insert psa3;
    }
    public static void createData4() {
        e = new GPSEmployee__c();
        e.Name = 'test';
        e.Division__c = 'Research';
        e.MS_ID__c = 'TESTSEFR';
        e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.IsUseMyContactList__c = True;
        e.Active_Flag__c = true;
        e.Chatter_Disclaimer_Acknowledged__c = false;
        insert e;   
        
        PermissionSet ps4 = [SELECT Id FROM PermissionSet WHERE Name = 'Login_As_Permission_Set'];
        PermissionSetAssignment psa4 = new PermissionSetAssignment();
        psa4.AssigneeId = usr.Id;
        psa4.PermissionSetId = ps4.Id;
        insert psa4;
    }
    
    static testmethod void CampaignHeadermenuController_test() {
        System.runAs(usr){
        Test.startTest();
        createData();
        CampaignHeadermenuController CHM = new CampaignHeadermenuController();
        pageReference p = CHM.redirect();
        System.assertEquals(CAMPAIGN_URL,p.getUrl());
        
        CHM.tabRedirect();
        
        ApexPages.currentPage().getParameters().put('UId', usr.Id);
        CampaignHeadermenuController chmc = new CampaignHeadermenuController();
        chmc.tabRedirect();
        chmc.redirect();
        Test.stopTest();
    }
    }
    
    static testmethod void CampaignHeadermenuController_test1() {
        System.runAs(usr){
        Test.startTest();
        createData1();
        CampaignHeadermenuController CHM = new CampaignHeadermenuController();
        pageReference p = CHM.redirect();
        System.assertEquals(IIFan_URL,p.getUrl());
        
        CHM.tabRedirect();
        
        ApexPages.currentPage().getParameters().put('pagename', 'IIFanClub');
        ApexPages.currentPage().getParameters().put('UId', usr.Id);
        CampaignHeadermenuController chmc = new CampaignHeadermenuController();
        chmc.tabRedirect();
        chmc.redirect();
        Test.stopTest();
    }
    }
    static testmethod void CampaignHeadermenuController_test2() {
        System.runAs(usr){
        Test.startTest();
        createData2();
        CampaignHeadermenuController CHM = new CampaignHeadermenuController();
        pageReference p = CHM.redirect();
        System.assertEquals(IICampaign_URL,p.getUrl());
        CHM.tabRedirect();
        
        ApexPages.currentPage().getParameters().put('pagename', 'IICampaigns');
        ApexPages.currentPage().getParameters().put('UId', usr.Id);
        CampaignHeadermenuController chmc = new CampaignHeadermenuController();
        chmc.tabRedirect();
        chmc.redirect();
        Test.stopTest();        
        }
    }
    
    static testmethod void CampaignHeadermenuController_test3() {
        System.runAs(usr){
        Test.startTest();
        createData3();
        CampaignHeadermenuController CHM = new CampaignHeadermenuController();
        ApexPages.currentPage().getParameters().put('pagename', 'GPSCampaigns');
        pageReference p = CHM.redirect();
        
        System.assertEquals(SetUp_URL,p.getUrl());
        CHM.tabRedirect();
        Test.stopTest();
    }
    }
    static testmethod void CampaignHeadermenuController_test4() {
        System.runAs(usr){
        Test.startTest();
        createData4();
        CampaignHeadermenuController CHM = new CampaignHeadermenuController();
        ApexPages.currentPage().getParameters().put('pagename', 'CampaignUserLoginAsView');
        pageReference p = CHM.redirect();
        System.assertEquals(LoginAs_URL,p.getUrl());
        CHM.tabRedirect();
        Test.stopTest();
    }
    }
    
    static testmethod void CampaignHeadermenuController_test5(){
     User adminuser = [Select Id, profile.Name from User where profile.Name = 'System Administrator' AND isActive= true limit 1];
     system.runAs(adminuser ){
        Test.startTest();
        CampaignHeadermenuController CHM = new CampaignHeadermenuController();
        ApexPages.currentPage().getParameters().put('pagename', 'GPSCampaigns');
        pageReference p = CHM.redirect();
        System.assertEquals(CAMPAIGN_URL,p.getUrl());
        CHM.tabRedirect();
        Test.stopTest();
     }
    }
    
    static testmethod void CampaignHeadermenuController_test6(){

        GPSCampaignsLoginAs__c loginrecord = new GPSCampaignsLoginAs__c();

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'GPS_Campaign_Permission_Set'];
        String loginAsUser= [select AssigneeId from PermissionSetAssignment where PermissionSetId = :ps.Id limit 1].AssigneeId;       

        loginrecord.Current_User__c = UserInfo.getUserId();
        loginrecord.Login_As_User__c = loginAsUser;
        
        insert loginrecord;
        
        Test.startTest();
        CampaignHeadermenuController CHM = new CampaignHeadermenuController();
        CHM.oboUser = loginAsUser;
        CHM.removeRecordGPSCampaignLogIn();
        Test.stopTest();

    }
}