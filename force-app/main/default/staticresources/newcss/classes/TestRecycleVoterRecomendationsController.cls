/**************************************************************************************
* Name            : TestRecycleVoterRecomendationsController
* Date            : 28 Jan,2011
* Description     : Test class for RecycleVoterRecomendationsController 
* Author          : Parth Tamhaney
* Modified :
*           02/22/2011   Urminder :  updated TestClass line(line# 317,311)
*           03/07/2011   Urminder :  Inserting Emplyee and Priority Contacts (line# 445).
*           03/15/2011   Urminder :  added Unique_VR_Key__c unique key to voter Recommendations.  (line# 507)
*           12/28/2011   Urmidner  - updated this class to unique MSID for employee and Trading_Name_ID__c for contact
*           01/09/2013   Urminder  - moved instance of new contact to Common_ContactUtil 
***************************************************************************************/
@isTest
private class TestRecycleVoterRecomendationsController {
    //initialising variables
    static User testUser;
    static String testUser2;
    static Target_List__c targetList;
    static Target_List__c targetList2;
    static Target_List__c targetList3;
    static List<Target_List_Member__c> members;
    static List<Candidate_Information__c> listConInfo;
    static List<iiCampaign__c> campaings = new List<iiCampaign__c>();
    static Candidate_Information__c candInfo;
    static Integer noOfVoterRecommendations = 54;
    static Integer newPageSize = 10;
    
    //creating new User
    //Commented and Added By Aditya : JIRA 4438 : To Improve the performance of test Class
    /*
    private static User getTempUser(){
        
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Global'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id);
    
        return tempUser;    
        
   } */
   
    static testMethod void testRecycleBin() {
      testUser2 = Userinfo.getUserId();
       
           //creating dummy data for this test class.
           List<Voter_Recommendation__c> delVoters = createData(testUser2);
           ApexPages.currentPage().getParameters().put('UId', testUser2);
           RecycleVoterRecommendationsController controller = new RecycleVoterRecommendationsController();
           
           
             
           //by default the page size is 25.      
           //default page sorting in ascending order on the basis on Accounts. 
             controller.sortOrderClause = 'Account__c';
             controller.sortOrder = '1';
             controller.sortContacts();
             //setting record page size is 25
             controller.currentPageSize = '25' ; 
             controller.setPageSize();
             
            //page =1
            //records per page  = 25;
            //total records = 54;
            //total pages = 3
            
            // checking total records in Recycle Bin
            System.assertEquals(noOfVoterRecommendations,controller.deletedVoterRecomendations.getResultSize());
            //checking wheather next page Exists.
            System.assertEquals(true,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(false,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(true,controller.isFirst);
            //checking current page is last page
            System.assertEquals(false,controller.isLast);
            //checking total no of pages 
            System.assertEquals(3,controller.TotalPage);
            //in current page records are starts from record number  
            System.assertEquals(1,controller.recordStartNumber);
            
            
            //changing the record page size to 10
            //page =1
            //records per page  =10;
            //total records = 54;
            //total pages = 6
            controller.currentPageSize = String.valueOf(newPageSize);
            controller.RECORD_PAGE_SIZE = newPageSize;
            controller.updateNewPagesize();
            //checking next page Exists.
            System.assertEquals(true,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(false,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(true,controller.isFirst);
            //checking current page is last page
            System.assertEquals(false,controller.isLast);
            //checking total no of pages 
            System.assertEquals(6,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals(1,controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals(newPageSize,controller.recordEndNumber);
            
            
            //page =2
            //records per page  =10;
            //total records = 54;
            //total pages = 6
            controller.next();
            //checking next page Exists.
            System.assertEquals(true,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(true,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(false,controller.isFirst);
            //checking current page is last page
            System.assertEquals(false,controller.isLast);
            //checking total no of pages 
            System.assertEquals(6,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals((newPageSize + 1),controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals((newPageSize * 2),controller.recordEndNumber);
            
            
            controller.last();
            //page = 6
            //records per page  = 10;
            //total records = 54;
            //total pages = 6
            //checking next page Exists.
            System.assertEquals(false,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(true,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(false,controller.isFirst);
            //checking current page is last page
            System.assertEquals(true,controller.isLast);
            //checking total no of pages 
            System.assertEquals(6,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals(((5 * newPageSize) + 1),controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals(noOfVoterRecommendations,controller.recordEndNumber);
            
            
            controller.previous();
             //page =5
            //records per page  =10;
            //total records = 54;
            //total pages = 6
             //checking next page Exists.
            System.assertEquals(true,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(true,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(false,controller.isFirst);
            //checking current page is last page
            System.assertEquals(false,controller.isLast);
            //checking total no of pages 
            System.assertEquals(6,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals((4*newPageSize + 1),controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals((newPageSize * 5),controller.recordEndNumber);
            
            
            
           
             //GOTO page =3
            //records per page  =10;
            //total records = 54;
            //total pages = 6
            controller.gotoPageRange = '21-30';
            controller.goToPage();
            //checking next page Exists.
            System.assertEquals(true,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(true,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(false,controller.isFirst);
            //checking current page is last page
            System.assertEquals(false,controller.isLast);
            //checking total no of pages 
            System.assertEquals(6,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals(21,controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals(30,controller.recordEndNumber);
            
            
            
            
            controller.first();
             //page =1
            //records per page  =10;
            //total records = 54;
            //total pages = 6
          
            //checking next page Exists.
            System.assertEquals(true,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(false,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(true,controller.isFirst);
            //checking current page is last page
            System.assertEquals(false,controller.isLast);
            //checking total no of pages 
            System.assertEquals(6,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals(1,controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals(newPageSize,controller.recordEndNumber);
            
            
            
            //changing page size to 50 records per page
            
            newPageSize = 50;
            controller.currentPageSize = String.valueOf(newPageSize);
            controller.setPageSize();
            System.assertEquals(controller.RECORD_PAGE_SIZE,newPageSize);
            controller.updateNewPagesize();
            
            //page =1
            //records per page  =50;
            //total records = 54;
            //total pages = 2
            
             //checking next page Exists.
            System.assertEquals(true,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(false,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(true,controller.isFirst);
            //checking current page is last page
            System.assertEquals(false,controller.isLast);
            //checking total no of pages 
            System.assertEquals(2,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals(1,controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals(newPageSize,controller.recordEndNumber);
           
            
             //changing page size to 100 records per page
            newPageSize = 100;
            controller.currentPageSize = String.valueOf(newPageSize);
            controller.setPageSize();
            System.assertEquals(controller.RECORD_PAGE_SIZE,newPageSize);
            controller.updateNewPagesize();
            
            //page =1
            //records per page  =100;
            //total records = 54;
            //total pages = 1
            
            //checking next page Exists.
            System.assertEquals(false,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(false,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(true,controller.isFirst);
            //checking current page is last page
            System.assertEquals(true,controller.isLast);
            //checking total no of pages 
            System.assertEquals(1,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals(1,controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals(noOfVoterRecommendations,controller.recordEndNumber);
            
            
             //setting the page size equals no of records
             
             controller.currentPageSize = String.valueOf(noOfVoterRecommendations);
             controller.RECORD_PAGE_SIZE = noOfVoterRecommendations;
            //controller.setPageSize();
            controller.updateNewPagesize();
           
            
            
            //page =1
            //records per page  = no of records = 54
            //total records = 54
            //total pages = 1
            
             //checking next page Exists.
            System.assertEquals(false,controller.hasNext);
            //checking wheather previous page Exists.
            System.assertEquals(false,controller.hasPrevious);
            //checking current page is first page  
            System.assertEquals(true,controller.isFirst);
            //checking current page is last page
            System.assertEquals(true,controller.isLast);
            //checking total no of pages 
            System.assertEquals(1,controller.TotalPage);
            //checking in current page records are starts from record number  
            System.assertEquals(1,controller.recordStartNumber);
            //checking in current page last record number
            System.assertEquals(noOfVoterRecommendations,controller.recordEndNumber);
            
            
           //restoring 10 deleted VoterRecomendations
           //controller.voterIds = '';
            Integer count = 0 ;
            for(RecycleVoterRecommendationsController.VoterRecommendation voter : controller.lstVoterRecommendations) {
                voter.toRestore = true;
                count++;
                if(count == 10)
                    break;
            }
            controller.restoreVoterRecommendations();
            controller.sortASPriority();
            controller.sortOrderClause = 'Contact_First_Name__c';
            //setting sorting order
            controller.sortOrder = '2';
            //sort contacts
            controller.sortContacts();
            controller.sortASPriority();
            //as 10 deleted recommendatrions are restored so list size is reduced by 10 now. 
            System.assertEquals(noOfVoterRecommendations - 10,controller.deletedVoterRecomendations.getResultSize());
            
            
            
            
            
            //restoring all deleted VoterRecomendations
           //controller.voterIds = '';
            for(RecycleVoterRecommendationsController.VoterRecommendation voter : controller.lstVoterRecommendations) {
                voter.toRestore = true;
            }
            controller.restoreVoterRecommendations();
            
            controller.sortOrderClause = 'Contact_First_Name__c';
            //setting sorting order
            controller.sortOrder = '2';
            //sort contacts
            controller.sortContacts();
            //as all deleted recommendatrions are restored so list is empty now. 
            System.assertEquals(0,controller.deletedVoterRecomendations.getResultSize());
            //checking current page is last page
            System.assertEquals(true,controller.isLast);
            
            ApexPages.currentPage().getParameters().put('sortOrder', '2');
            RecycleVoterRecommendationsController controller2 = new RecycleVoterRecommendationsController();
            RecycleVoterRecommendationsController.VoterRecommendation wrapObj = new RecycleVoterRecommendationsController.VoterRecommendation();
            
        } 
    
    
    
    //creating dummy data for this test class
    static  List<Voter_Recommendation__c> createData(String dUser) {
         TestClassUtilities.setAllTriggerOn();
         List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();
        
        //creating 4 Acounts
        
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
        
        GPSAccount__c acc3 = new GPSAccount__c();
        acc3.name = 'acc3';
        acc3.Trading_Name_ID__c = 'TN-009';
        //acc3.Client_Type__c = 'Internal';
        listAccounts.add(acc3);
        
        GPSAccount__c acc4 = new GPSAccount__c();
        acc4.name = 'acc4';
        acc4.Trading_Name_ID__c = 'TN-0010';
        //acc4.Client_Type__c = 'Internal';
        listAccounts.add(acc4);
        
        insert listAccounts;
        
        //Create test contacts
        GPSContact__c con;
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        Integer cnt =0;
        for(GPSAccount__c acc : listAccounts){
            con = new GPSContact__c(); 
            con = Common_ContactUtil.createContact(acc.Id, cnt++);
            listContacts.add(con);
        }
        
        insert listContacts; 
        
        
        
        
         //Create Campaigns
         iiCampaign__c camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         campaings.add(camp);
         
         iiCampaign__c camp2 = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS2';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         campaings.add(camp2);
          
         insert campaings;
        //Create Target Lists
        List<Target_List__c> targetLists = new List<Target_List__c>();
        targetList = new Target_List__c();
        targetList.User__c = dUser;
        targetList.Authorized__c = true;
        targetList.iiCampaign__c = camp.id;
        targetLists.add(targetList);
        
        targetList2 =  new Target_List__c();
        targetList2.User__c = dUser;
        targetList2.Authorized__c = true;
        targetList2.iiCampaign__c = camp.id;
        targetLists.add(targetList2);
        
        targetList3 =  new Target_List__c();
        targetList3.User__c = dUser;
        targetList3.Authorized__c = true;
        targetList3.iiCampaign__c =  campaings[1].Id;
        //targetList.iiCampaign__c = camp.id;
        targetLists.add(targetList3);
    
        insert targetLists;
        
        //Create Team 
        Team__c testTeam = new Team__c();
        testTeam.Name = 'TestTEAM';
        insert testTeam;
        //03/07/2011 Urminder : Inserting Emplyee and Priority Contacts.
        //creating Employee
        GPSEmployee__c testEmp = new GPSEmployee__c();
        testEmp.Name = 'TestEmployee';
        testEmp.MS_ID__c = '12345012';
        testEmp.Team_Id__c = testTeam.id;
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
                testPriCon.MS_Id__c = '12345012';
                testPriCon.GPSContact__c = contacts.id;
                testPriCon.GPSEmployee__c = testEmp.id;
                testPriCon.Active_Flag__c = true;
                listPriCon.add(testPriCon);
            }
        }
        insert listPriCon;
        
        //Create test Candidate Information
        listConInfo = new List<Candidate_Information__c>();
        
        
            candInfo = new Candidate_Information__c();
            candInfo.Candidate_Name__c = 'TestCandidate1';
            candInfo.Team_Name__c = 'TestTEAM';
            candInfo.MSID__c = '12345';
            candinfo.iiCampaign__c = camp.Id;
            listConInfo.add(candInfo);
            
           /* candInfo = new Candidate_Information__c();
            candInfo.Candidate_Name__c = 'TestCandidate' + index + 10;
            candinfo.iiCampaign__c = camp2.Id;
            listConInfo.add(candInfo);
            */
        
        insert listConInfo;
       
        ApexPages.currentPage().getParameters().put('candidateId', candInfo.id);
        ApexPages.currentPage().getParameters().put('sortOn', 'account');
        ApexPages.currentPage().getParameters().put('sortOrder', '1');
       
        
        //Create test Voter Recommendation
        List<Voter_Recommendation__c> listVoterRecom  = new List<Voter_Recommendation__c>();
        
       for(Integer index = 0; index < noOfVoterRecommendations; index++) {
        
            Voter_Recommendation__c voterRecomm  = new Voter_Recommendation__c();
            voterRecomm.Candidate_Information__c = candInfo.Id;
            voterRecomm.GPSContact__c = listContacts[0].id;
            voterRecomm.Active_Flag__c = false;
            voterRecomm.User_Who_Inactivated__c = dUser;
          //03/15/2011   Urminder :  added Unique_VR_Key__c unique key to voter Recommendations.
            voterRecomm.Unique_VR_Key__c = 'TestUnique' + index + DateTime.now();
            listVoterRecom.add(voterRecomm);
            
        }
        insert listVoterRecom;
        
        return listVoterRecom;
        
    
        
    }
}