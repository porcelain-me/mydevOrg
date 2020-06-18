/**************************************************************************************
* Name            : TestIIFanClubController
* Date            : 03 Dec,2010
* Description     : For code coverage of IIFanClub 
* Author          : Parth Tamhaney
* Modified        : 10 Dec,2010 Kapil Choudhary Upadeted test class according to changes in class.
                  : 20 Jan,2011 Kapil Choudhary Upadeted test class according to changes in class [PR-07995].
                  : 15 Mar,2011 Urminder added Unique_VR_Key__c unique key to voter Recommendations. (line# 460)
                  : 09 Jan,2013 Urminder : move instance of new contact to common_contactUtil.
***************************************************************************************/

@isTest
private class TestIIFanClubController {
    static Region__c regionNA;
    static Region__c regionAP;
    static Team__c team1;
    static Team__c team2;
    static Team__c team3;
    static List<Candidate_Information__c> firstteamCandidate = new List<Candidate_Information__c>();
    static List<Candidate_Information__c> secondteamCandidate = new List<Candidate_Information__c>();
    static List<Candidate_Information__c> thirdteamCandidate = new List<Candidate_Information__c>();
    static List<Voter_Recommendation__c> listVoters = new List<Voter_Recommendation__c>();
    static Fan_Club_Setup__c newFanClub;
    static Fan_Club_Setup__c newFanClub1;  
    
    static testMethod void myUnitTest() {
        createTestData();
       
        PageReference pageRef = Page.IIFanClub;
        Test.setCurrentPage(pageRef);
        IIFanClubController controller = new IIFanClubController();
        
        //Standard Set controller is null;
        System.assertEquals(false,controller.hasNext);
        System.assertEquals(false,controller.hasPrevious);
        System.assertEquals(true,controller.isFirst);
        System.assertEquals(true,controller.isLast);
        System.assertEquals(0,controller.recordStartNumber);
        System.assertEquals(0,controller.recordEndNumber);
        
        //Select second Team 
        controller.selectedTeamName = '';
        controller.selectedTeamId = team2.Id;
        controller.prepareCandidateOpts();
        System.assertEquals(secondteamCandidate.size(),controller.getCandidates().size());
        System.assertEquals(team2.Name,controller.selectedTeamName);
        System.assertEquals(secondteamCandidate[0].Id,controller.selectedCandidate);
        System.assertEquals(secondteamCandidate[0].Candidate_Name__c,controller.selectedCandidateName);
        System.assertEquals(controller.helpDocuments.size(),1);
        for(Team__c team : [select Fan_Club_Setup__r.Use_Analyst_Buddies__c from Team__c where id = :team2.id]) {
            System.assertEquals(team.Fan_Club_Setup__r.Use_Analyst_Buddies__c,controller.teamUsesAnalystBuddies);
        }
        
        
        
        //Select Third Team 
        controller.selectedTeamName = '';
        controller.selectedTeamId = team3.Id;
        controller.prepareCandidateOpts();
        System.assertEquals(thirdteamCandidate.size(),controller.getCandidates().size());
       
        System.assertEquals(team3.Name,controller.selectedTeamName);
        for(Team__c team : [select Fan_Club_Setup__r.Use_Analyst_Buddies__c from Team__c where id = :team3.id]) {
            System.assertEquals(team.Fan_Club_Setup__r.Use_Analyst_Buddies__c,controller.teamUsesAnalystBuddies);
        }
        //This Team does not have any candidate ; we expect ""
        System.assertEquals('',controller.selectedCandidateName);
        
        //helpurl "http://gpshelp" is defined in controller
        System.assertEquals('http://gpshelp',controller.getHelpUrl());
        //page name "II Campaign" is defined in controller
        System.assertEquals('IIFanClub',controller.getPage());
        
        //System.assertNotEquals(null,controller.getTeamsPulldownController());
        
         
        
        controller.getHelpUrl();
        controller.getPage();
        
        
        //controller.getTeamsPulldownController();
        
        /*************Sudarshan K. on 16th May 2016 Start Code*********************
        ************Code Coverage for TeamsPulldownController Class****************/
        TeamsPulldownController teamPullDownController = new TeamsPulldownController();
        teamPullDownController.getTeamId();
        teamPullDownController.getUsername();
        teamPullDownController.getShowReports();
        teamPullDownController.getShowSetup();
        //teamPullDownController.setSelectedTeam();
        
        /*****************End Code****************************************/
        
        
        //Select first Team 
        controller.selectedTeamName = '';
        controller.selectedTeamId = team1.Id;
        controller.prepareCandidateOpts();
        System.assertEquals(firstteamCandidate.size(),controller.getCandidates().size());
        System.assertEquals(team1.Name,controller.selectedTeamName);
        
        System.assertEquals(firstteamCandidate[0].Id,controller.selectedCandidate);
        System.assertEquals(firstteamCandidate[0].Candidate_Name__c,controller.selectedCandidateName);
        for(Team__c team : [select Fan_Club_Setup__r.Use_Analyst_Buddies__c from Team__c where id = :team1.id]) {
            System.assertEquals(team.Fan_Club_Setup__r.Use_Analyst_Buddies__c,controller.teamUsesAnalystBuddies);
        }
        
        
        //controller.RECORD_PAGE_SIZE = 2;
        controller.gotoPageRange = '1-50';
        controller.updateCandidateContacts();
        controller.goToPage();
        //Page 1 ; total Page 3 ; Page size 2 ; Result Size 2
        System.assertEquals(true,controller.hasNext);
        System.assertEquals(false,controller.hasPrevious);
        System.assertEquals(true,controller.isFirst);
        System.assertEquals(false,controller.isLast);
        
        System.assertEquals(1,controller.CurrentPageNumber);
        System.assertEquals(listVoters.size(),controller.TotalRecords);
        System.assertEquals(2,controller.TotalPage);
        System.assertEquals(1,controller.recordStartNumber);
        System.assertEquals(50,controller.recordEndNumber);
        
        
        controller.sortContacts();
        //Page 1 ; total Page 3 ; Page size 2 ; Result Size 2
       System.assertEquals(true,controller.hasNext);
        System.assertEquals(false,controller.hasPrevious);
        System.assertEquals(true,controller.isFirst);
        System.assertEquals(false,controller.isLast);
        
        System.assertEquals(1,controller.CurrentPageNumber);
        System.assertEquals(listVoters.size(),controller.TotalRecords);
        System.assertEquals(2,controller.TotalPage);
        System.assertEquals(1,controller.recordStartNumber);
        System.assertEquals(50,controller.recordEndNumber);
        
        
        //Go TO Next Page
        controller.next();
        //Page 2 ; total Page 3 ; Page size 2 ; Result Size 2
        System.assertEquals(false,controller.hasNext);
        System.assertEquals(true,controller.hasPrevious);
        System.assertEquals(false,controller.isFirst);
        System.assertEquals(true,controller.isLast);
        
        System.assertEquals(2,controller.CurrentPageNumber);
        System.assertEquals(listVoters.size(),controller.TotalRecords);
        System.assertEquals(2,controller.TotalPage);
        System.assertEquals(51,controller.recordStartNumber);
        System.assertEquals(51,controller.recordEndNumber);
        
        //Go to First Page
        //controller.gotoPageNumber = 1; 
        controller.goToPage();
        //Page 1 ; total Page 3 ; Page size 2 ; Result Size 2
       System.assertEquals(true,controller.hasNext);
        System.assertEquals(false,controller.hasPrevious);
        System.assertEquals(true,controller.isFirst);
        System.assertEquals(false,controller.isLast);
        
        System.assertEquals(1,controller.CurrentPageNumber);
        System.assertEquals(listVoters.size(),controller.TotalRecords);
        System.assertEquals(2,controller.TotalPage);
        System.assertEquals(1,controller.recordStartNumber);
        System.assertEquals(50,controller.recordEndNumber);
                
        //Go to Last Page
        controller.last();
        //Page 3 ; total Page 3 ; Page size 2 ; Result Size 2
       System.assertEquals(false,controller.hasNext);
        System.assertEquals(true,controller.hasPrevious);
        System.assertEquals(false,controller.isFirst);
        System.assertEquals(true,controller.isLast);
        
        System.assertEquals(2,controller.CurrentPageNumber);
        System.assertEquals(listVoters.size(),controller.TotalRecords);
        System.assertEquals(2,controller.TotalPage);
        System.assertEquals(51,controller.recordStartNumber);
        System.assertEquals(51,controller.recordEndNumber);
        
        
        
        //Go To Previos Page
        controller.previous();
        //Page 2 ; total Page 3 ; Page size 2 ; Result Size 2
        System.assertEquals(true,controller.hasNext);
        System.assertEquals(false,controller.hasPrevious);
        System.assertEquals(true,controller.isFirst);
        System.assertEquals(false,controller.isLast);
        
        System.assertEquals(1,controller.CurrentPageNumber);
        System.assertEquals(listVoters.size(),controller.TotalRecords);
        System.assertEquals(2,controller.TotalPage);
        System.assertEquals(1,controller.recordStartNumber);
        System.assertEquals(50,controller.recordEndNumber);
        
        
        //Go To first Page
        controller.first();
        //Page 1 ; total Page 3 ; Page size 2 ; Result Size 2
         System.assertEquals(true,controller.hasNext);
        System.assertEquals(false,controller.hasPrevious);
        System.assertEquals(true,controller.isFirst);
        System.assertEquals(false,controller.isLast);
        
        System.assertEquals(1,controller.CurrentPageNumber);
        System.assertEquals(listVoters.size(),controller.TotalRecords);
        System.assertEquals(2,controller.TotalPage);
        System.assertEquals(1,controller.recordStartNumber);
        System.assertEquals(50,controller.recordEndNumber);
       
        //Remove Voter Recommendation 
        controller.voterRecomId = listVoters[0].id;
        controller.removeVoterRec();
      //  listVoters.remove(0);   
        System.assertEquals(false,controller.hasNext);
        System.assertEquals(false,controller.hasPrevious);
        System.assertEquals(true,controller.isFirst);
        System.assertEquals(true,controller.isLast);
        System.assertEquals(1,controller.CurrentPageNumber);

        // test case changed for active flag testing 
        
        For(Voter_Recommendation__c voter : [select Active_Flag__c,User_Who_Inactivated__c from Voter_Recommendation__c where id = :listVoters[0].id ]) {
            System.assertEquals(voter.Active_Flag__c,false);
            System.assertEquals(voter.User_Who_Inactivated__c,UserInfo.getUserId());    
            
        }
        System.assertEquals(listVoters[1].Active_Flag__c,true);        
        System.assertEquals(1,controller.TotalPage);
        System.assertEquals(1,controller.recordStartNumber);
        System.assertEquals(50,controller.recordEndNumber);
        
        
        //Test - Set Analyst Buddy
        Boolean isAnalystBuddy = true;
        controller.voterRecomId = listVoters[0].id;
        controller.isAnalystBuddy = isAnalystBuddy;
        controller.setAnalystBuddy();
        
            //System.assertEquals(isAnalystBuddy,controller.listContactInfo[0].Is_Analyst_Buddy__c);
        
        List<Analyst_Buddy__c> analystBuddy = [Select GPSContact__c from Analyst_Buddy__c where GPSContact__c =:controller.listContactInfo[0].GPSContact__c  limit 1];
        System.assertEquals(0,analystBuddy.size());
        
        //Test - remove Analyst Buddy
        isAnalystBuddy = false;
        controller.voterRecomId = listVoters[0].id;
        controller.isAnalystBuddy = isAnalystBuddy;
        controller.setAnalystBuddy();
        System.assertEquals(isAnalystBuddy,controller.listContactInfo[0].Is_Analyst_Buddy__c);
        analystBuddy = [Select GPSContact__c from Analyst_Buddy__c where GPSContact__c =:controller.listContactInfo[0].GPSContact__c  limit 1];
        System.assertEquals(0,analystBuddy.size());
        
        
        
        Apexpages.currentPage().getParameters().put('candidateId',firstteamCandidate[0].id);
        controller.getExportList();
        controller.getVoterCandidates();        
        System.assertEquals(listVoters.size()-1,controller.listContactInfo.size());
        
        Apexpages.currentPage().getParameters().put('teamName',team1.Name);
        Apexpages.currentPage().getParameters().put('candidateId',firstteamCandidate[0].id);
        
        Apexpages.currentPage().getParameters().put('sortOn','account');
        Apexpages.currentPage().getParameters().put('sortOrder','1');
        
        
        controller.getCandidateList(); 
        System.assertEquals(listVoters.size()-1,controller.listContactInfo.size());
        System.assertEquals(firstteamCandidate[0].id,controller.selectedCandidate);
        System.assertEquals(team1.Name,controller.selectedTeamName);
        
        controller.currentpagesize = '25';
        controller.updateNewPagesize();
        controller.strSelectedVoterRecs = '';
        for(Voter_Recommendation__c voter : listVoters) {
            controller.strSelectedVoterRecs = voter.id + ';';
        }
        controller.removeSelectedVoterRec();
        For(Voter_Recommendation__c voter : [select Active_Flag__c,User_Who_Inactivated__c from Voter_Recommendation__c where id = :listVoters[0].id ]) {
            System.assertEquals(voter.Active_Flag__c,false);
            System.assertEquals(voter.User_Who_Inactivated__c,UserInfo.getUserId());    
            
        }
        
        controller.sortAsPriority();
        
    }
    
    public static void createTestData(){
        TestClassUtilities.setAllTriggerOn();
        //Added By Aditya : JIRA 4438 : To Improve the performance of test Class
        T1C_CustomSettingsManager.createChatterSetting();
        //Create test accounts
        List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();
        
        GPSAccount__c acc1 = new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 't1'+ Datetime.now().format('ddhhmmss');
        //acc1.Client_Type__c = 't1'+ Datetime.now().format('ddhhmmss');   
        acc1.Active_Flag__c = true;
        listAccounts.add(acc1);
        
        GPSAccount__c acc2 = new GPSAccount__c();
        acc2.name = 'acc2';
        acc2.Trading_Name_ID__c = 't2'+ Datetime.now().format('ddhhmmss');
        //acc2.Client_Type__c = 't2'+ Datetime.now().format('ddhhmmss');   
        acc2.Active_Flag__c = true;
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
            for(Integer indx = 0; indx < 51; indx++){
                con = new GPSContact__c(); 
                con = Common_ContactUtil.createContact(acc.Id, cnt++);
                listContacts.add(con);
            }
        }
        
        insert listContacts; 
        for(GPSContact__c cons : listContacts){
            System.assert(cons.id != null);
        }
                
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
        
        //creating fan_club_setup
        List<Fan_Club_Setup__c> fanList = new List<Fan_Club_Setup__c>();
        
        newFanClub = new Fan_Club_Setup__c();
        newFanClub.Use_Analyst_Buddies__c = true;
        fanList.add(newFanClub);
        
        newFanClub1 = new Fan_Club_Setup__c();
        newFanClub1.Use_Analyst_Buddies__c = false;
        fanList.add(newFanClub1);        
        
        insert fanList;
        
        //creating new Attachment
        Attachment attach = new Attachment();
        attach.Name = 'newAttachment';
        Blob   body =Blob.valueOf('121121');
        attach.body = body;
        attach.parentid = newFanClub1.id;
        insert attach;
        
        //Preparing test Teams
        List<Team__c> listTeams = new List<Team__c>();
        team1 = new Team__c();
        team1.Name = 'Team1';
        team1.RegionID__c = regionNA.RegionID__c;
        team1.Team_Region__c = regionNA.id;
        team1.Fan_Club_Setup__c = newFanClub.id;
        listTeams.add(team1);
        
        team2 = new Team__c();
        team2.Name = 'Team2';
        team2.RegionID__c = regionAP.RegionID__c;
        team2.Team_Region__c = regionAP.id;
        team2.Fan_Club_Setup__c = newFanClub1.id;
        
        listTeams.add(team2);
        
        team3 = new Team__c();
        team3.Name = 'team3';
        team3.RegionID__c = regionNA.RegionID__c;
        team3.Team_Region__c = regionNA.id;
        team3.Fan_Club_Setup__c = newFanClub.id;
        listTeams.add(team3);
        
        insert listTeams;
        for(Team__c tm : listTeams){
            System.assert(tm.id != null);
        }
        
        //creating Employee
        GPSEmployee__c testEmp = new GPSEmployee__c();
        testEmp.Name = 'TestEmployee';
        testEmp.MS_ID__c = '1245';
        testEmp.Team_Id__c = team1.id;
        //testEmp.User__c = dUser.id;
        insert testEmp;
        
        //creating priority Contacts
        List<Priority_Contacts__c> listPriCon = new List<Priority_Contacts__c>();
        Integer total = 0;
        for(GPSContact__c contacts : listContacts) {
            if(total == 2) { 
                break;
            } else {
                total++;
                Priority_Contacts__c testPriCon  = new Priority_Contacts__c();
                testPriCon.MS_Id__c = '12345';
                testPriCon.GPSContact__c = contacts.id;
                testPriCon.GPSEmployee__c = testEmp.id;
                testPriCon.Active_Flag__c = true;
                testPriCon.Relationship_Type__c = 'P';
                listPriCon.add(testPriCon);
            }
        }
        insert listPriCon;
        
        //Creating test Candidate_Information__c 
        //###Two candidates in each team###
        List<Candidate_Information__c> listCandidates = new List<Candidate_Information__c>();
        
        Candidate_Information__c candidate1 = new Candidate_Information__c();
        candidate1.Team_Name__c = team1.Name;
        candidate1.Candidate_Name__c = 'candidate1';
        listCandidates.add(candidate1);
        firstteamCandidate.add(candidate1);
        
        Candidate_Information__c candidate2 = new Candidate_Information__c();
        candidate2.Team_Name__c = team1.Name;
        candidate2.Candidate_Name__c = 'candidate2';
        listCandidates.add(candidate2);
        firstteamCandidate.add(candidate2);
        
        Candidate_Information__c candidate3 = new Candidate_Information__c();
        candidate3.Team_Name__c = team2.Name;
        candidate3.Candidate_Name__c = 'candidate3';
        listCandidates.add(candidate3);
        secondteamCandidate.add(candidate3);
        
        insert listCandidates;
        for(Candidate_Information__c cand : listCandidates){
            System.assert(cand.id != null);
            //System.debug('###candidate id:'+cand.id);
        }
        
        //Create test Voter_Recommendation__c. 
        //###5 voters for each candidate###
        integer count = 1;
        Voter_Recommendation__c voter;
        
        //for(Candidate_Information__c candidate : firstteamCandidate){
            //System.debug('###candidate id:'+candidate.id);
            for(Integer indx = 1; indx <= 51; indx++){
                voter = new Voter_Recommendation__c();
                voter.Candidate_Information__c = candidate1.id;
                voter.GPSContact__c = listContacts.get(indx).id;
                voter.Active_Flag__c = true;
        //03/15/2011   Urminder :  added Unique_VR_Key__c unique key to voter Recommendations.
                voter.Unique_VR_Key__c = 'TestUnique' + indx + Datetime.now();
                listVoters.add(voter);
                //System.debug('###indx:'+ (count*5 - indx));
            }
            //count++;
        //}
        insert listVoters;
        
        for(Voter_Recommendation__c vote : listVoters){
            System.assert(vote.id != null);
        }
    }
}