// copyright 2010 Appirio
//
// 10/12/2010    Chetan Garg : ORIGINAL 
// 11/25/2010    ParthT     : Removed use of TestUser
// 12 Jan 2011   Kapil Choudhary Test class updated for PR-07915
// 09 jan 2013   Urminder : move instance of new contact to common_contactUtil.
//

@isTest
private class TestConvertAnalystBuddiesController {
    
    static Team__c team1;
    static List<Candidate_Information__c> listCandidates;
    static List<Analyst_Buddy__c> buddies;
    static list<Target_List__c> targetList;
    static List<iiCampaign__c> campList;
    static List<GPSContact__c> listContacts;
    
    static testMethod void myUnitTest() {
          TestClassUtilities.setAllTriggerOn();
          createTestData();
          
          Apexpages.Standardcontroller stdCon = new Apexpages.Standardcontroller(campList[0]);
          ConvertAnalystBuddiesController convertAnalyst = new ConvertAnalystBuddiesController(stdCon);
          
          system.assertEquals(campList[0].id, convertAnalyst.currentCampaign.id);
          system.assertEquals(listCandidates.size(), convertAnalyst.listCandidateItems.size());
          
          
          Integer buddyCount = listContacts.size();
          
          for(ConvertAnalystBuddiesController.CandidateItem item : convertAnalyst.listCandidateItems){
            if(item.candidate.id == listCandidates[3].id){
                system.assertEquals(false, item.isSelected);
                system.assertEquals(true, item.isDisabled);                                                 
            }else{
                system.assertEquals(true, item.isSelected);
                system.assertEquals(false, item.isDisabled);                
            } 
            system.assertEquals(buddyCount, item.cntUnconvertedBuddies);
          }
          
          //Convert Analyst Buddy to Target List Members
          convertAnalyst.convertAnalystBuddies();
          
          Integer targetListSize = targetList.size();
          targetList = [Select id ,(Select GPSContact__c, Eligible_for_email__c From Target_List_Members__r)  FROM Target_List__c where ID IN : targetList];
          
          system.assertEquals(targetListSize, targetList.size());
          for(Target_List__c tl : targetList){
            system.assertEquals(buddyCount, tl.Target_List_Members__r.size());
            for(Target_List_Member__c member : tl.Target_List_Members__r){
              system.assertEquals(true, member.Eligible_for_email__c);  
            }
          }
          
          Integer totalbuddies = buddies.size();
          
          buddies = [Select a.Status__c, a.Candidate_Information_Analyst__c From Analyst_Buddy__c a where id in :buddies ];
          system.assertEquals(totalbuddies, buddies.size());
          for(Analyst_Buddy__c buddy : buddies){
            if(buddy.Candidate_Information_Analyst__c == listCandidates[3].id){
                system.assertNotEquals('Converted', buddy.Status__c);                                               
            }else{
                system.assertEquals('Converted', buddy.Status__c);                  
            } 
          }
        
    }
    
    public static void createTestData(){
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
        listContacts = new List<GPSContact__c>();
        Integer cnt =0;
        for(GPSAccount__c acc : listAccounts){
            for(Integer indx = 0; indx < 20; indx++){
                con = new GPSContact__c();
                con = Common_ContactUtil.createContact(acc.Id, cnt++); 
                listContacts.add(con);
            }
        }
        insert listContacts;
        
        //Preparing test Teams
        team1 = new Team__c();
        team1.Name = 'Team1';
        insert team1;
        
         campList = new List<iiCampaign__c>();
         
         iiCampaign__c camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TESTCAMP';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         camp.Synch_Target_List_Member_Statuses__c = true;
         campList.add(camp);
         
         insert campList;
        
        targetList = new List<Target_List__c>();
         
        Target_List__c testList = new Target_List__c();
        testList.User__c = UserInfo.getUserId(); //testUser.Id;
        testList.iiCampaign__c= camp.id;
        testList.MSID__c = 'tid-1';
        testList.Authorized__c = true;        
        targetList.add(testList);
        
        testList = new Target_List__c();
        testList.User__c = UserInfo.getUserId(); //testUser.Id;
        testList.iiCampaign__c= camp.id;
        testList.MSID__c = 'tid-2';
        testList.Authorized__c = true;        
        targetList.add(testList);
        
        testList = new Target_List__c();
        testList.User__c = UserInfo.getUserId(); //testUser.Id;
        testList.iiCampaign__c= camp.id;
        testList.MSID__c = 'tid-3';
        testList.Authorized__c = true;        
        targetList.add(testList);        
        insert targetList;
        
        //Creating test Candidate_Information__c
        listCandidates = new List<Candidate_Information__c>();
        
        
        Candidate_Information__c candidate1 = new Candidate_Information__c();
        candidate1.Team_Name__c = team1.Name;
        candidate1.Candidate_Name__c = 'candidate1';
        candidate1.MSID__c = 'tid-1';
        candidate1.iiCampaign__c= camp.id;
        listCandidates.add(candidate1);
        
        Candidate_Information__c candidate2 = new Candidate_Information__c();
        candidate2.Team_Name__c = team1.Name;
        candidate2.Candidate_Name__c = 'candidate2';
        candidate2.MSID__c = 'tid-2';
        candidate2.iiCampaign__c= camp.id;
        listCandidates.add(candidate2);
        
        Candidate_Information__c candidate3 = new Candidate_Information__c();
        candidate3.Team_Name__c = team1.Name;
        candidate3.Candidate_Name__c = 'candidate3';
        candidate3.MSID__c = 'tid-3';
        candidate3.iiCampaign__c= camp.id;
        listCandidates.add(candidate3);
        
        Candidate_Information__c candidate4 = new Candidate_Information__c();
        candidate4.Team_Name__c = team1.Name;
        candidate4.Candidate_Name__c = 'candidate4';
        candidate4.MSID__c = 'TESTCAMPtid-4';
        candidate4.iiCampaign__c= camp.id;
        listCandidates.add(candidate4);
        
        insert listCandidates;
        
        buddies = new List<Analyst_Buddy__c>();
        
        for(Candidate_Information__c candidate : listCandidates){           
            for(GPSContact__c contact : listContacts){
                Analyst_Buddy__c newBuddy = new Analyst_Buddy__c();
                newBuddy.Candidate_Information_Analyst__c = candidate.id;
                newBuddy.GPSContact__c = contact.id;
                buddies.add(newBuddy);
            }
        }
        
        insert buddies;
    }    
}