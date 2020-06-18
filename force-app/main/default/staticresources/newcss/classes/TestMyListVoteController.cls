/**************************************************************************************
Name            :       TestMyListVoteController
Created By      :       Appirio Offshore(Deshraj Kumawat)
Created On      :       April 9, 2010
Description     :       For Code coverage of MyListVoteController
Related PR      :       PR-04313
Moidified           :       9 Sep 2010       Parth Tamhaney     Used DataUtil.getTestUserWithRole() 
                            04 Oct 2010                         Updating Test classes 
                            02 Nov 2010      Kapil Choudhary    Updated Test Classes
                            25 Nov 2010      Parth Tamhaney     Removed use of Existing User. Used Temp User
                            15 Mar 2011      Urminder           added Unique_VR_Key__c unique key to voter Recommendations.(line# 207)
                            11 May 2011      Kapil Choudhary    Class Updated for MSID__c changes [PR-09374]
                            11/27/2012       Jitendra:   CRMGPS-2884 II Campaign - Voting Panel Enhancement
                            01/09/2013 :     MG : updated for CIS_Contact_ID__c field primary key on contact chages. use Common_ContactUtil class to create contact.
                            04 July 2013     RP : CRMGPS 4215 Remove already recommended analysts/ analyst teams from UI
***************************************************************************************/

@isTest
private class TestMyListVoteController {
    
    static User testUser;
    static list<Target_List__c> targetList;
    static List<Target_List_Member__c> targetListMember;
    static List<iiCampaign__c> campList;
    
    static List<Candidate_Information__c> listCandidates;
    static List<Candidate_Sector__c> listSectors;
    static List<Voter_Recommendation__c> listVoterRecom;
     // Commented By Aditya : JIRA 4438 : To change Version to 24.0
    /*
     private static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Global'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id,MSID__c = DateTime.now().format('ddyyhhmmss'));
    
        return tempUser;        
   }
   */ 
    static testMethod void myListVoteTest() 
    {   
       // Commented By Aditya : JIRA 4438 : To change Version to 24.0  
         
       // testUser =  getTempUser();
       // Added By Aditya : JIRA 4438 : To change Version to 24.0 
       Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
       testUser = [SELECT Id FROM USER WHERE profileID =: p.id and ISACTIVE = true limit 1];  
        system.debug('===Test User=== ' + testUser);
        System.runAs(testUser) {
            createData();
       
            Test.startTest();
            system.debug('========Test Start===========');
            
            
            MyListVoteController controller;
            for(Target_List_Member__c tlm: targetListMember)
            {
                PageReference pageRef = Page.MyiiList;
                pageRef.getParameters().put('id', tlm.Id);
                
                Test.setCurrentPage(pageRef);
                controller = new MyListVoteController();
                //Test controller member id , it should be targetListMember.Id
                System.assertEquals(tlm.Id, controller.tMember.Id,'Test controller member id , it should be targetListMember.Id');
                System.assertEquals(tlm.Id, controller.tMember.Id);
                //Test controller member id properties , it should be false
                System.assertEquals(false,controller.tMember.Called_about_II__c,'Test controller member id properties , it should be false');
                //Test controller member id properties , it should be false
                System.assertEquals(false,controller.tMember.Voted_in_II_Campaign__c,'Test controller member id properties , it should be false');
                //Test controller Candidate Sector , should not be blank
                //System.assertNotEquals(0,controller.listOfCandidateWrapper.size(),'Test controller Candidate Sector , should not be blank');
                
             //    System.assert(controller.setOfDeletedVoterRec.size()>0);
                
                controller.listOfCandidateWrapper[0].isSelected = true;
                
                controller.tMember.Called_about_II__c = true;
                controller.tMember.Contact_would_not_reveal_vote__c = true;
                controller.not_II_Friendly = true;
                controller.newLanguagePref = 'English';
                controller.insertVote();
               
                //Test Member's Status , should be Confirmed vote
                System.assertEquals('Confirmed vote', controller.tMember.Target_List_Status__c,'Test Members Status , should be Confirmed vote');
                //Test Member Last Vote , should be current user
                System.assertEquals(testUser.Id, controller.tMember.User_who_confirmed_Vote_Last__c,'Test Member Last Vote , should be current user');
                
                controller.tMember.Called_about_II__c = false;
                controller.leftVoicemail = true;
                controller.blanketVote = false;
                controller.tMember.Contact_would_not_reveal_vote__c = false;
                
                controller.newLanguagePref = 'Japanese';
                controller.insertVote();
                
                controller = new MyListVoteController();
                controller.listOfCandidateWrapper[0].isSelected = false;
                controller.listOfCandidateWrapper[0].isDeleted = true;
                controller.listOfCandidateWrapper[0].isVoterRecommend = true;
                 controller.listOfCandidateWrapper[0].isVoterRecommendAlready=false;
                 //11/27/2012    Jitendra:   CRMGPS-2884
                 controller.tMember.Ballot_Received__c = true;
                 controller.tMember.Contact_has_been_called__c = true;
                controller.insertVote();
                //11/27/2012    Jitendra:   CRMGPS-2884
                System.assertEquals(true, controller.tMember.Blanket_Voter__c,'If Ballot Received and Contact has been called is true then Blanket voter should be true');
                //04 July 2013 RP : CRMGPS 4215 Remove already recommended analysts/ analyst teams from UI
                controller.listOfCandidateWrapper[0].isRemovedVote = true ;
                controller.listOfCandidateWrapper[0].isVoterRecommend = true ;
                controller.listOfCandidateWrapper[0].isVoterRecommendAlready = true ;
                controller.insertVote() ;
            }
             //System.debug('=====set==========='+controller.setOfDeletedVoterRec);
           
            System.assert(controller.setOfDeletedVoterRec.size()>0);
            
            Test.stopTest();    
        }
    }
    
    static void createData(){
        TestClassUtilities.setAllTriggerOn();
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
        
        //Create test contacts
        GPSContact__c con;
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        Integer cnt =0;
        for(GPSAccount__c acc : listAccounts){
            // 01/09/2013 : MG : updated for CIS_Contact_ID__c field primary key on contact chages. use Common_ContactUtil class to create contact.
            con = Common_ContactUtil.createContact(acc.Id, cnt++);
            
            listContacts.add(con);
        }
        
        insert listContacts;
         
         campList = new List<iiCampaign__c>();
         
         iiCampaign__c camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         camp.Synch_Target_List_Member_Statuses__c = true;
         camp.Campaign_is_Multilingual__c = true;
         campList.add(camp);
         
         
         iiCampaign__c camp1 = new iiCampaign__c();
         camp1.Campaign_Name__c  ='TEST CAMPAINGS';
         camp1.Start_Date__c = Date.today();
         camp1.Active_Flag__c = true;
         camp1.Synch_Target_List_Member_Statuses__c = false;
         campList.add(camp1);
         
         database.insert(campList);
         
        listCandidates = new List<Candidate_Information__c>();
        
        Candidate_Information__c candidate1 = new Candidate_Information__c();
        candidate1.Candidate_Name__c = 'candidate1';
       // candidate1.Promotion_Text__c = 'Test Promotion Text';
        candidate1.iiCampaign__c = campList[0].id;
        listCandidates.add(candidate1);
        
        Candidate_Information__c candidate2 = new Candidate_Information__c();
        candidate2.Candidate_Name__c = 'candidate2';
       // candidate2.Promotion_Text__c = 'Test Promotion Text';
        candidate2.iiCampaign__c = campList[0].id;
        listCandidates.add(candidate2);
        
        Candidate_Information__c candidate3 = new Candidate_Information__c();
        candidate3.Candidate_Name__c = 'candidate3';
       // candidate3.Promotion_Text__c = 'Test Promotion Text';
        candidate3.iiCampaign__c = campList[1].id;
        listCandidates.add(candidate3);
        
        Candidate_Information__c candidate4 = new Candidate_Information__c();
        candidate4.Candidate_Name__c = 'candidate4';
       // candidate4.Promotion_Text__c = 'Test Promotion Text';
        candidate4.iiCampaign__c = campList[1].id;
        listCandidates.add(candidate4);
        
        insert listCandidates;
        
        for(Candidate_Information__c cand : listCandidates){
            System.assert(cand.id != null);
            //System.debug('###candidate id:'+cand.id);
        }
        
        //Create test Voter Recommendation
        listVoterRecom  = new List<Voter_Recommendation__c>();
        integer index = 0;
        for (Candidate_Information__c cand : listCandidates)
        {
            Voter_Recommendation__c voterRecomm  = new Voter_Recommendation__c();
            voterRecomm.Candidate_Information__c = cand.Id;
            //03/15/2011   Urminder :  added Unique_VR_Key__c unique key to voter Recommendations.
            voterRecomm.Unique_VR_Key__c = 'TestUnique' + index + Datetime.now();
            if(index>1)
                voterRecomm.GPSContact__c = listContacts[0].id;
            else
                voterRecomm.GPSContact__c = listContacts[1].id;
            voterRecomm.Why__c = 'Test Why text';
            if(index==3) {
                voterRecomm.Active_Flag__c = false;
                voterRecomm.User_Who_Inactivated__c = testUser.Id;
            }
            listVoterRecom.add(voterRecomm);
            index = index + 1;
        }
        insert listVoterRecom;
        
        //Create test Voter Recommendation
        listSectors = new List<Candidate_Sector__c>();
        
        for (Candidate_Information__c cand : listCandidates)
        {
            Candidate_Sector__c sector  = new Candidate_Sector__c();
            sector.Candidate_Information__c = cand.Id;
          //  sector.Promotion_Text__c = 'Test Promotion Text';
            listSectors.add(sector);
        }
        insert listSectors;
        // Added By Aditya : JIRA 4438 : To change Version to 24.0 
       Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
       testUser = [SELECT Id FROM USER WHERE profileID =: p.id and ISACTIVE = true limit 1]; 
        
        targetList = new List<Target_List__c>();
        
         
        Target_List__c targetList1 = new Target_List__c();
        targetList1.User__c = testUser.Id;
        targetList1.iiCampaign__c= campList[0].id;
        targetList1.Authorized__c = true;
        
        targetList.add(targetList1);
        
        targetList1 = new Target_List__c();
        targetList1.User__c = testUser.Id;
        targetList1.iiCampaign__c= campList[1].id;
        targetList1.Authorized__c = true;
        
        targetList.add(targetList1);
        
        Database.insert(targetList);
        
        targetListMember  = new List<Target_List_Member__c>();
        User testUserRole = testUser;//DataUtil.getTestUserWithoutRole();
        Target_List_Member__c targetListMember1 = new Target_List_Member__c();
        targetListMember1.Target_List__c = targetList[0].id;
        targetListMember1.Target_List_Member_Key__c = '123';
        targetListMember1.GPSContact__c = listContacts[0].id;
        targetListMember1.User_Who_Called_the_Contact__c = testUserRole.Id;
        targetListMember1.user_who_confirmed_ballot_received__c = testUserRole.Id;
        targetListMember1.User_Who_Confirmed_Non_II_Friendly__c = testUserRole.Id;
        targetListMember1.User_who_left_Voicemail_del__c = testUserRole.Id;
        targetListMember1.Not_II_Friendly__c = true;
        targetListMember1.Blanket_Voter__c = true;
        targetListMember1.Contact_has_been_called__c = true;
        targetListMember1.Contact_would_not_reveal_vote__c = true;
        targetListMember.Add(targetListMember1);
        
        targetListMember1 = new Target_List_Member__c();
        targetListMember1.Target_List__c = targetList[0].id;
        targetListMember1.Target_List_Member_Key__c = '123';
        targetListMember1.GPSContact__c = listContacts[0].id;
        
        insert targetListMember1;
        
        targetListMember1 = new Target_List_Member__c();
        targetListMember1.Target_List__c = targetList[1].id;
        targetListMember1.Target_List_Member_Key__c = '123';
        targetListMember1.GPSContact__c = listContacts[0].id;
        targetListMember1.Removed_Reason__c = 'Email Only';
        targetListMember1.Blanket_Voter__c = false;
        
        targetListMember.Add(targetListMember1);
        
        targetListMember1 = new Target_List_Member__c();
        targetListMember1.Target_List__c = targetList[1].id;
        targetListMember1.Target_List_Member_Key__c = '123';
        targetListMember1.GPSContact__c = listContacts[0].id;
        targetListMember1.Removed_Reason__c = 'Email Only';
        
        
        insert targetListMember1;
        
    
        
        database.insert(targetListMember);
        
        for(Target_List_Member__c tlm : targetListMember){
            System.assert(tlm.id != null);
            System.debug('###TargetListMember id:'+tlm.id);
        }
    }
    
    
    
}