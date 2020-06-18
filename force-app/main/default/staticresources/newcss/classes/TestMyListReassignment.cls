// 
//   (c) 2010 Appirio, Inc.
//
//   TestMyListReassignment (Test class for MyListReassignmentController
//
//   27 Jul 2010   Chetan Garg          Original (R-05520). 
//   9 Sep 2010    Parth Tamhaney       Used DataUtil.getTestUserWithRole() 
//   14 Sep 2010   Chetan Garg          Updating Test Class
//  26 Nov 2010    Parth Tamhaney       Removed use of Existing User. Used Temp User

@isTest
private class TestMyListReassignment {

    static User testUser;
    static Target_List__c targetList1;
    static Target_List__c targetList2;
    
      private static User getTempUser(){
      //Commented and Added By Aditya : JIRA 4438 : To Improve the performance of test Class
      /*
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Global'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id
            ,MSID__c = DateTime.now().format('ddyyhhmmss'));
    
        return tempUser;      
        */ 
        User tempUser = CM_TestClassUtilities.getAdminUser()[0];
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IICampaign_Permission_Set'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = tempUser.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
         
        return tempUser;
   }
    
    static testMethod void myUnitTest() 
    {
        // temp user
       testUser =  getTempUser();
        
        System.runAs(testUser) 
        {
            createTestData();
       
            Test.startTest();
            
            Apexpages.currentPage().getParameters().put('list',targetList1.Id);
            Apexpages.currentPage().getParameters().put('listType','Test');
            MyListReassignmentController con = new MyListReassignmentController();
            con.searchText='r';
            con.doSearch();
            con.first();
            con.last();
            con.action='previous';
            con.previous();
            con.next();
            con.currentPage =1;
            con.getRecordByPageNo();
            Boolean isPage = con.hasNext ;
            isPage = con.hasPrevious  ;
            isPage = con.isFirst;
            isPage = con.isLast;
            
            Apexpages.currentPage().getParameters().remove('list');
            con = new MyListReassignmentController();
            system.assertEquals(con.hasPrevious, false);
            system.assertEquals(con.isFirst, false);
            system.assertEquals(con.isLast, false);
            system.assertEquals(con.hasNext, false);
            
            Test.stopTest();
        }
    }
    
     public static void createTestData()
     {      
        TestClassUtilities.setAllTriggerOn(); 
        //Added By Aditya : JIRA 4438 : To Improve the performance of test Class
        T1C_CustomSettingsManager.createChatterSetting();      
        iiCampaign__c  camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='Save Tiger';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         camp.Synch_Target_List_Member_Statuses__c = true;
         insert camp;
        
         //Preparing test target list
        List<Target_List__c> listTargetList = new List<Target_List__c>(); 
        
        targetList1 = new Target_List__c();
        targetList1.MSID__c = '12345';
        targetList1.User__c = testUser.Id;
        targetList1.iiCampaign__c = camp.id;
        targetList1.Authorized__c = true;
        listTargetList.add(targetList1);
        
        targetList2 = new Target_List__c();
        targetList2.MSID__c = 'T23454';
        targetList2.iiCampaign__c = camp.id;
        targetList2.User__c = testUser.Id;
        targetList2.Authorized__c = true;
        listTargetList.add(targetList2);
        
        Target_List__c tlist ;
        
        
        
        for(Integer i =0;i<50;i++){
            tlist = new Target_List__c();
            tlist.MSID__c = '12345';
            tlist.User__c = testUser.Id;
            tlist.iiCampaign__c = camp.id;
            tlist.Authorized__c = true;
            listTargetList.add(tlist);
        }
        insert listTargetList; 
        
    }
}