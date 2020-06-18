/***
* 
*   (c) 2009 Appirio, Inc.
*
*   Test Class for IIDataHelper 
*
*   03 March 2011     Chetan Garg       Original
*
**/
@isTest
private class TestIIDataHelper {
    
 static Region__c regionNA;
 static Team__c team1;
 static Team__c team3;
 static Candidate_Information__c firstteamCandidate = new Candidate_Information__c();
 static List<Priority_Contacts__c> listPriorityContacts = new List<Priority_Contacts__c>();
 
 private static testmethod void testgetAllPriorityContacts(){
    createTestData();
    List<Priority_Contacts__c> testPriorityContacts = IIDataHelper.getAllPriorityContacts(firstteamCandidate.MSID__c);
    
    system.assertEquals(testPriorityContacts.size(), listPriorityContacts.size(), 'Priority Cotnact size should be same with inserted records');
 }
 
  private static void createTestData(){
  	TestClassUtilities.setAllTriggerOn();
    List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();
        
    GPSAccount__c acc1 = new GPSAccount__c();
    acc1.name = 'acc1';
    acc1.Trading_Name_ID__c = 't1'+ Datetime.now().format('ddhhmmss');
    //acc1.Client_Type__c = 't1'+ Datetime.now().format('ddhhmmss');   
    acc1.Active_Flag__c = true;
    listAccounts.add(acc1);
    
    insert listAccounts;
    
    List<GPSContact__c> listContacts = new List<GPSContact__c>();
        
    for(GPSAccount__c acc : listAccounts){
        for(Integer indx = 0; indx < 51; indx++){
            GPSContact__c con = new GPSContact__c(); 
            con.firstName__c = 'con'+indx+'-';
            con.lastName__c = acc.name;
            con.GPSAccount__c = acc.id;
            con.Trading_Name_ID__c =  'c'+ indx + Datetime.now().format('hhmmss');
            con.CIS_Contact_ID__c =   'c'+ indx + Datetime.now().format('hhmmss');
            con.TN_Contact_Key__c =  'ts'+ indx + Datetime.now().format('ddhhmmss');
            listContacts.add(con);
        }
    }
    
    insert listContacts;
    
    List<Region__c> listRegions = new List<Region__c>();
    regionNA = new Region__c();
    regionNA.name = 'North America';
    regionNA.RegionID__c = 'NA';           
    insert listRegions;
    
    List<Team__c> listTeams = new List<Team__c>();
    team1 = new Team__c();
    team1.Name = 'Team1';
    team1.RegionID__c = regionNA.RegionID__c;
    team1.Team_Region__c = regionNA.id;
    //team1.Fan_Club_Setup__c = newFanClub.id;
    listTeams.add(team1);
    insert listTeams;
    for(Team__c tm : listTeams){
        System.assert(tm.id != null);
    }
    
    //Creating test Candidate_Information__c 
    List<Candidate_Information__c> listCandidates = new List<Candidate_Information__c>();    
    firstteamCandidate = new Candidate_Information__c();
    firstteamCandidate.Team_Name__c = team1.Name;
    firstteamCandidate.Candidate_Name__c = 'candidate1';
    firstteamCandidate.MSID__c = 'testSEFR';
    listCandidates.add(firstteamCandidate);
    insert listCandidates;
    
    GPSEmployee__c currentEmployee = new GPSEmployee__c();
    currentEmployee.Name = 'test';
    currentEmployee.Division__c = 'Research';
    currentEmployee.MS_ID__c = 'testSEFR';
    currentEmployee.User__c = usr.Id;
    currentEmployee.Is_Producer_Employee__c = true;
    currentEmployee.Active_Flag__c = true;
    insert currentEmployee;
    
    
    for(GPSContact__c con : listContacts){
        
        listPriorityContacts.add(new Priority_Contacts__c(Trading_Name_Id__c = con.TN_Contact_Key__c,
                GPSContact__c = con.id, CIS_Contact_Id__c = con.CIS_Contact_ID__c,
                GPSEmployee__c = currentEmployee.id, Relationship_Type__c = 'P' ));
    }
    insert listPriorityContacts;
    
    
  } 
    
  private static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          UserRoleId = r.id ,Emp_Id__c = 'testSEFR');
  
    return tempUser;        
   }
   
    static User usr;
    static{
        
        // temp user
       usr =  getTempUser();//DataUtil.getTestUserWithRole();
        
   } 
}