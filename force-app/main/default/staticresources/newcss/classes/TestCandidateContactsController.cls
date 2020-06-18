/**************************************************************************************
//Name            : TestCandidateContactsController
//Date            : 30 March,2010
//Description     : Test class for CandidateContactsController
//Author          : Vinod Jain
// Last Updated   : Kapil Choudhary 19 oct 2010 Check class for Full SandBox Error [PR-06744]
*   03/07/2011      Urminder : Inserting Emplyee and Priority Contacts (line# 182)
*   03/15/2011      Urminder :  added Unique_VR_Key__c unique key to voter Recommendations. (line# 251)
*   01/09/2013 :    Urminder : move instance of new contact to common_contactUtil. 
***************************************************************************************/

@isTest
private class TestCandidateContactsController {

    static Region__c regionNA;
    static Region__c regionAP;
    static Team__c team1;
    static Team__c team2;
    public static Candidate_Information__c candidate1;
    static User testUser2;
    
    private static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Global'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id);
    
        return tempUser;        
   }
    
    static testMethod void myUnitTest() {
        
      
        
       createTestData();
        

        ApexPages.currentPage().getParameters().put('candidateId',candidate1.id);
        CandidateContactsController controller = new CandidateContactsController();
        System.assertequals(getVoterCount(candidate1.id),5);
        
        System.assertNotequals(null,controller.listContactWrapToSave);
        //Search and add a selected contact
        controller.searchText = 'con';
        controller.doSearch();
        //controller.listContactWrappers.get(0).isSelected = true;
        controller.addCon();
        controller.SaveContacts();
        System.assertNotequals(getVoterCount(candidate1.id),null);
        System.assertequals(controller.result,'');
        
        //try to add contact without any selection
        controller.resetParams();
        controller.addCon();
        controller.SaveContacts();
        System.assertNotequals(getVoterCount(candidate1.id),null);
        
        
        //Search and add a new and an existing contact
        controller.resetParams();
        controller.searchText = 'con';
        controller.doSearch();
        controller.listContactWrappers.get(0).isSelected = true;
        controller.listContactWrappers.get(1).isSelected = true;
        controller.listContactWrappers.get(5).isSelected = true;
        controller.addCon();
//        System.assert(controller.result != '');
        controller.SaveContacts();
//        System.assertNotEquals(getVoterCount(candidate1.id), null);
        controller.removeFromSavedList();
        
        
        
        controller.searchText = 'con';
        controller.doSearch();
        controller.first();
        controller.last();
        controller.previous();
        controller.next();
        controller.getRecordByPageNo();
        boolean bool = controller.hasNext;
        bool = controller.hasPrevious;
        bool = controller.isFirst;
        bool = controller.isLast;
        controller.sortContacts();
        controller.returnToStep1();
        
     }
     
    private static Integer getVoterCount(String candidateId){
        return [Select count() From Voter_Recommendation__c Where Candidate_Information__c = :candidateId
                 and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))];
    }
    
    public static void createTestData(){
        TestClassUtilities.setAllTriggerOn();
        //Create test accounts
        List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();
        
        GPSAccount__c acc1 = new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'TN-007';
        //acc1.Client_Type__c = 'Internal';
        listAccounts.add(acc1);
        
        GPSAccount__c acc2 = new GPSAccount__c();
        acc2.name = 'acc2';
        acc2.Trading_Name_ID__c = 'TN-008';
        //acc2.Client_Type__c = 'Internal';
        listAccounts.add(acc2);
        
        insert listAccounts;
        for(GPSAccount__c acc : listAccounts){
            System.assert(acc.id != null);
        }
        
        //Create test contacts
        GPSContact__c con;
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        Integer cnt = 0;
        for(GPSAccount__c acc : listAccounts){
            for(Integer indx = 0; indx < 10; indx++){
                con = new GPSContact__c();
                con = Common_ContactUtil.createContact(acc.id, cnt++);
                listContacts.add(con);
            }
        }
        
        
        insert listContacts;
        List<String> listconId = new List<String>(); 
        for(GPSContact__c cons : listContacts){
            System.assert(cons.id != null);
            listconId.add(cons.id);
        }
        
        test.setFixedSearchResults(listconId);
                
        //Preparing test regions
        List<Region__c> listRegions = new List<Region__c>(); 
        
        regionNA = new Region__c();
        regionNA.name = 'North America';
        regionNA.RegionID__c = 'NA';
        listRegions.add(regionNA);
        
        regionAP = new Region__c();
        regionAP.name = 'Asia Pacific';
        regionAP.RegionID__c = 'AP';
        listRegions.add(regionAP);
        
        insert listRegions;
        for(Region__c rgn : listRegions){
            System.assert(rgn.id != null);
        }
        
        //Preparing test Teams
        List<Team__c> listTeams = new List<Team__c>();
        team1 = new Team__c();
        team1.Name = 'Team1';
        team1.RegionID__c = regionNA.RegionID__c;
        team1.Team_Region__c = regionNA.id;
        listTeams.add(team1);
        
        team2 = new Team__c();
        team2.Name = 'Team2';
        team2.RegionID__c = regionAP.RegionID__c;
        team2.Team_Region__c = regionAP.id;
        listTeams.add(team2);
        
        insert listTeams;
        for(Team__c tm : listTeams){
            System.assert(tm.id != null);
        }
        
          //creating Employee
        GPSEmployee__c testEmp = new GPSEmployee__c();
        testEmp.Name = 'TestEmployee';
        testEmp.MS_ID__c = '1235';
        testEmp.Team_Id__c = team2.id;
        //testEmp.User__c = dUser.id;
        insert testEmp;
        
        //creating priority Contacts
        List<Priority_Contacts__c> listPriCon = new List<Priority_Contacts__c>();
        Integer total = 0;
        for(GPSContact__c contacts : listContacts) {
            if(total == 1) { 
                break;
            } else {
                total++;
                Priority_Contacts__c testPriCon  = new Priority_Contacts__c();
                testPriCon.MS_Id__c = '12345';
                testPriCon.GPSContact__c = contacts.id;
                testPriCon.GPSEmployee__c = testEmp.id;
                testPriCon.Active_Flag__c = true;
                listPriCon.add(testPriCon);
            }
        }
        insert listPriCon;
        
        //Creating test Candidate_Information__c 
        //###Two candidates in each team###
        List<Candidate_Information__c> listCandidates = new List<Candidate_Information__c>();
        
        candidate1 = new Candidate_Information__c();
        candidate1.Team_Name__c = team1.Name;
        candidate1.Candidate_Name__c = 'candidate1';
        candidate1.MSID__c = '12345';
        listCandidates.add(candidate1);
        
        Candidate_Information__c candidate2 = new Candidate_Information__c();
        candidate2.Team_Name__c = team1.Name;
        candidate2.Candidate_Name__c = 'candidate2';
        listCandidates.add(candidate2);
        
        Candidate_Information__c candidate3 = new Candidate_Information__c();
        candidate3.Team_Name__c = team2.Name;
        candidate3.Candidate_Name__c = 'candidate3';
        listCandidates.add(candidate3);
        
        Candidate_Information__c candidate4 = new Candidate_Information__c();
        candidate4.Team_Name__c = team2.Name;
        candidate4.Candidate_Name__c = 'candidate4';
        listCandidates.add(candidate4);
        
        insert listCandidates;
        for(Candidate_Information__c cand : listCandidates){
            System.assert(cand.id != null);
            //System.debug('###candidate id:'+cand.id);
        }
        
        //Create test Voter_Recommendation__c. 
        //###5 voters for each candidate###
        integer count = 1;
        Voter_Recommendation__c voter;
        List<Voter_Recommendation__c> listVoters = new List<Voter_Recommendation__c>();
        for(Candidate_Information__c candidate : listCandidates){
            //System.debug('###candidate id:'+candidate.id);
            for(Integer indx = 1; indx <= 5; indx++){
                voter = new Voter_Recommendation__c();
                voter.Candidate_Information__c = candidate.id;
               //03/15/2011   Urminder :  added Unique_VR_Key__c unique key to voter Recommendations. 
                voter.Unique_VR_Key__c = 'Unique' + indx + count + datetime.now();
                voter.GPSContact__c = listContacts.get(count*5 - indx).id;
                listVoters.add(voter);
                //System.debug('###indx:'+ (count*5 - indx));
            }
            count++;
        }
        insert listVoters;
        
        for(Voter_Recommendation__c vote : listVoters){
            System.assert(vote.id != null);
        }
    }
}