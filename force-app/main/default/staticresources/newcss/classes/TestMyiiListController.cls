/**************************************************************************************
Name            :       TestMyiiListController
Created By      :       Appirio Offshore(Deshraj Kumawat)
Created On      :       April 9, 2010
Description     :       For Code coverage of MyiiListController
Related PR      :       PR-04313
Modified        :       Sept 08, 2010  Parth Tamhaney  Use DataUtil.getTestUserWithRole() to get existing user
                        14 Sep 2010    Chetan Garg     Updating Test Class
                        16 Sep 2010    Kapil Choudhary Updating Test Class
                        04 Oct 2010    Chetan Garg     Updating Test Class
                        29 Oct 2010    Kapil Choudhary Updated  Test Class
                        25 Nov 2010    Parth Tamhaney  Removed CreateUser() and Created Temp User for testing
                        29 No 2010    Chetan Garg      Used TestClassUtilities.createMyiiListAdminProfiles();
                        30 Nov 2010    Rahul Jain      Updated to resolve:
                                                       System.DmlException: Insert failed. First exception on row 0; first error: MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object (or vice versa): User, original object: MyiiListAdminProfiles__c:
                        15 Mar 2011   Urminder         added Unique_VR_Key__c unique key to voter Recommendations (line# 553)      
                        20 April 2011 Kapil Choudhary  Split  myiiListTest to myiiListTest2 to conquer too many soql queries exception.
                        21 April 2011 Kapil Choudhary  Remove Function for exporttoexcel() 
                        11 May   2011 Urminder         Added MSID in the User [PR-09374]
                        09 Jan   2013 Urminder         move new contact instance to Common_ContactUtil                           
***************************************************************************************/

@isTest
private class TestMyiiListController {
    
    static User testUser;
    static User testUser2; 
    static Target_List__c targetList;
    static Target_List__c targetList2;
    static Target_List__c targetList3;
    static List<Target_List_Member__c> members;
    static List<Candidate_Information__c> listConInfo;
    static List<iiCampaign__c> campaings = new List<iiCampaign__c>();
    static Attachment attach;
   
     private static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];
        
        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing', Emp_Id__c = 'MSID_1234',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id, isActive = true);
        insert  tempUser; 
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IICampaign_Permission_Set'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = tempUser.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        return tempUser;        
   }
    
    private static User getTempUser2(){
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];
        
        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing', Emp_Id__c = 'MSID_1234',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id, isActive = true);
      
        return tempUser;  
           
   }
  
   
    static testMethod void myiiListTest1() 
    {
        //testUser =  DataUtil.getTestUserWithRole();
       // CreateUser();
       User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        testUser2 = getTempUser();
        TestClassUtilities.setAllTriggerOn();
        }
        System.runAs(testUser2) {
            //TestClassUtilities.createMyiiListAdminProfiles();
            
            System.debug('=============myiiListTest.CreateData()===========');
            createData(testUser2);
            MyiiListController controller = new MyiiListController();
            System.debug('______________USER________'+Userinfo.getUserId());
            controller.selectedTargetListUsers = targetList.id;            
            controller.changeTargetList();
            
            controller.GetListMemberBySelectedAnalyst();
            
            System.assert(controller.getAnalysts().size() > 0);
            
            controller.selectedAnalyst = listConInfo[0].Id;
            controller.GetListMemberBySelectedAnalyst();  
            controller.sortListMembers();
            controller.selectedLang = 'English';
            controller.selectedContactId = members[0].GPSContact__c;
            controller.changeContactIILanguage();
            Test.startTest();
            controller.getUserCampaignsList();
            controller.showEmailOnlyClients();
            controller.isEmailOnlyOn  = true;
            controller.refershList();
            controller.removeEmailOnly();
            controller.keepQueryLocatorAlive();
            controller.currentpagesize = '50';
            controller.selectedTargetListUsers = targetList2.id;            
            controller.changeTargetList();
            Test.stopTest();
           // controller.goToPage();
        }
    }
    
    static testMethod void myiiListTest() 
    {   
      User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       TestClassUtilities.setAllTriggerOn();
       //TestClassUtilities.createMyiiListAdminProfiles();
        }
          System.debug('===================Current user================'+ System.Userinfo.getUserId());
          System.debug('================testuser==============='+ testUser);
        System.runAs(testUser) {
            
            //TestClassUtilities.createMyiiListAdminProfiles();
            System.debug('=============myiiListTest.CreateData()===========');
            createData(testUser);
            Test.startTest();
            MyiiListController controller = new MyiiListController();
            controller.isAdminProfiles = false;
            //User Target List should not be null
             System.debug('===============userTargetList=============='+ controller.userTargetList);
            System.assertNotEquals(null,controller.userTargetList,'User Target List should not be null' );
            controller.selectedTargetListUsers = targetList.id;            
            controller.changeTargetList();
            //User Target List User should be current User 
            System.assertEquals(controller.userTargetList.User__c, testUser.Id,'User Target List User should be current User ');
            //This Target list should have Authorized true
            System.assertEquals(true, controller.userTargetList.Authorized__c,'This Target list should have Authorized true');
            //This Target list should have Target list member
            System.assertNotEquals(0, controller.userTargetList.Number_of_Target_Members__c,'This Target list should have Target list member');
            //This Target list should have Target list member
            System.assertNotEquals(0, controller.listOfMyMembers.size(),'This Target list should have Target list member');
            
            
            controller.setAuthorized();
            //This Target list should have Authorized true
            System.assertEquals(true, controller.userTargetList.Authorized__c,'This Target list should have Authorized true');
            
            controller.refershList();
            controller.refreshWithFilter();
            controller.selectedId  = members[0].id;
            controller.reason ='';
            //controller.updateRemoveReason();
            controller.GetListMemberBySelectedAnalyst();
            System.assert(controller.getAnalysts().size() > 0);
            test.stopTest();
        }
        
        
       
         
    }
    
    //  20 April 2011 : Spilted myiiListTest() into myiiListTest
    static testMethod void myiiListTest2() 
    {   User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       //TestClassUtilities.createMyiiListAdminProfiles();
       TestClassUtilities.setAllTriggerOn();
        }
          System.debug('===================Current user================'+ System.Userinfo.getUserId());
          System.debug('================testuser==============='+ testUser);
          System.runAs(testUser) {
            
           // TestClassUtilities.createMyiiListAdminProfiles();
            System.debug('=============myiiListTest.CreateData()===========');
            createData(testUser);
            Test.startTest();
            MyiiListController controller = new MyiiListController();
            controller.isAdminProfiles = false;
            //User Target List should not be null
             System.debug('===============userTargetList=============='+ controller.userTargetList);
            System.assertNotEquals(null,controller.userTargetList,'User Target List should not be null' );
            controller.selectedTargetListUsers = targetList.id;  
             controller.changeTargetList();
           
            controller.selectedAnalyst = listConInfo[0].Id;
            controller.GetListMemberBySelectedAnalyst();  
            controller.sortListMembers();
            controller.selectedLang = 'English';
            controller.selectedContactId = members[0].GPSContact__c;
            controller.changeContactIILanguage();
            controller.getUserCampaignsList();
            controller.showEmailOnlyClients();
            controller.isEmailOnlyOn  = true;
            controller.refershList();
            controller.removeEmailOnly();
            
            Apexpages.currentPage().getParameters().put('Analyst','');
            Apexpages.currentPage().getParameters().put('userTargetListId',targetList.id);
            Apexpages.currentPage().getParameters().put('CampaignId',targetList.iiCampaign__c);
            Apexpages.currentPage().getParameters().put('teamName','');
           // controller.getExportList();
           test.stopTest();
        }
        
        
       
         
    }
   
   
     static testMethod void testExport() 
    {   
        User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       //TestClassUtilities.createMyiiListAdminProfiles();
       TestClassUtilities.setAllTriggerOn();
        }
        
          System.debug('===================Current user================'+ System.Userinfo.getUserId());
          System.debug('================testuser==============='+ testUser);
        System.runAs(testUser) {
              TestClassUtilities.createMyiiListAdminProfiles();
            System.debug('=============myiiListTest.CreateData()===========');
            createData(testUser);
            test.startTest();
            MyiiListController controller = new MyiiListController();
            controller.isAdminProfiles = false;
            //User Target List should not be null
             System.debug('===============userTargetList=============='+ controller.userTargetList);
            System.assertNotEquals(null,controller.userTargetList,'User Target List should not be null' );
            controller.selectedTargetListUsers = targetList.id;            
            controller.changeTargetList();
            //User Target List User should be current User 
            System.assertEquals(controller.userTargetList.User__c, testUser.Id,'User Target List User should be current User ');
            //This Target list should have Authorized true
            System.assertEquals(true, controller.userTargetList.Authorized__c,'This Target list should have Authorized true');
            //This Target list should have Target list member
            System.assertNotEquals(0, controller.userTargetList.Number_of_Target_Members__c,'This Target list should have Target list member');
            //This Target list should have Target list member
            System.assertNotEquals(0, controller.listOfMyMembers.size(),'This Target list should have Target list member');
            
            
            controller.setAuthorized();
            //This Target list should have Authorized true
            System.assertEquals(true, controller.userTargetList.Authorized__c,'This Target list should have Authorized true');
            
            controller.refershList();
            controller.refreshWithFilter();
            controller.selectedId  = members[0].id;
            controller.reason ='';
            //controller.updateRemoveReason();
            controller.GetListMemberBySelectedAnalyst();
            
            System.assert(controller.getAnalysts().size() > 0);
            
            controller.selectedAnalyst = listConInfo[0].Id;
            controller.GetListMemberBySelectedAnalyst();  
                       
            Apexpages.currentPage().getParameters().put('Analyst','');
            Apexpages.currentPage().getParameters().put('userTargetListId',targetList.id);
            Apexpages.currentPage().getParameters().put('CampaignId',targetList.iiCampaign__c);
            Apexpages.currentPage().getParameters().put('teamName','');
            test.stopTest();
        }
            
           
         
    }
    
    static testMethod void myiiListEmailOnly()
    {
        
         User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       //TestClassUtilities.createMyiiListAdminProfiles();
       TestClassUtilities.setAllTriggerOn();
        }
          System.runAs(testUser) 
          {
             TestClassUtilities.createMyiiListAdminProfiles();
              createData(testUser);
            members[2].Removed_Reason__c = 'Email Only';
            members[3].Removed_Reason__c = null;
            update members;
            test.startTest();
          
            MyiiListController controller = new MyiiListController(); 
            controller.selectedTargetListUsers =targetList.id;            
             controller.setAuthorized();
            controller.changeTargetList();
           
            //non email only clients
            //This list have only 3 client to Call records
            system.assertEquals(3,controller.listofMyMembers.size(),'This list have only 3 client to Call records');
            
            controller.showEmailOnlyClients();
            //email only client
            //This list have only 1 Email only records
            system.assertEquals(1,controller.emailOnlyController.listOfMyTarget.size(),'This list have only 1 Email only records');
           
            controller.listOfMyMembers[0].isSelected = true;
            //move contact to Email only list
            controller.removeCallOnly();
            //Removed a Client to call member ; This list have only 2 client to Call records
            system.assertEquals(2,controller.listofMyMembers.size(),'Removed a Client to call member ; This list have only 2 client to Call records');
            
            //Conatct added to Email only List
            controller.showEmailOnlyClients();
            //Removed a Client to call member ; This list have only 2 client to Call records
            system.assertEquals(2,controller.listofMyMembers.size(),'Removed a Client to call member ; This list have only 2 client to Call records');
            System.debug('___________size before ________'+controller.emailOnlyController.listOfMyTarget.size());
            controller.listOfMyMembers[0].isSelected = true;
            //controller.removeCallOnly();
            controller.showEmailOnlyClients();
            controller.emailOnlyController.listOfMyTarget[0].isSelected = true;
            controller.selectedId = targetList2.id;
            controller.isEmailOnlyOn  = true ;
            //controller.reassignMembersToList();
            System.debug('___________size after ________'+controller.emailOnlyController.listOfMyTarget.size());
            test.stopTest();
         }
    }
    static testMethod void test3() {
        
         User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       //TestClassUtilities.createMyiiListAdminProfiles();
       TestClassUtilities.setAllTriggerOn();
        }
          System.runAs(testUser) 
          {
             TestClassUtilities.createMyiiListAdminProfiles();
              createData(testUser);
              test.startTest();
            members[2].Removed_Reason__c = 'Email Only';
            members[3].Removed_Reason__c = null;
            update members;
        
          
            MyiiListController controller = new MyiiListController(); 
            controller.selectedTargetListUsers =targetList.id;            
             controller.setAuthorized();
            controller.changeTargetList();
           
            //non email only clients
            //This list have only 3 client to Call records
            system.assertEquals(3,controller.listofMyMembers.size(),'This list have only 3 client to Call records');
            
            controller.showEmailOnlyClients();
            //email only client
            //This list have only 1 Email only records
            system.assertEquals(1,controller.emailOnlyController.listOfMyTarget.size(),'This list have only 1 Email only records');
           
            
            controller.emailOnlyController.listOfMyTarget[0].isSelected = true;
            controller.selectedId = targetList2.id;
            controller.isEmailOnlyOn  = true ;
            controller.reassignMembersToList();
            System.debug('___________size after ________'+controller.emailOnlyController.listOfMyTarget.size());
            test.stopTest();
         }
    } 
    static testMethod void myiiListTestReassign() 
    {   
        
        User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       //TestClassUtilities.createMyiiListAdminProfiles();
       TestClassUtilities.setAllTriggerOn();
        }
        System.runAs(testUser) {
              TestClassUtilities.createMyiiListAdminProfiles();
            createData(testUser);
            Test.startTest();
            MyiiListController controller = new MyiiListController();
            
           
            //User Target List should not be null
            System.assertNotEquals(null,controller.userTargetList,'User Target List should not be null' );
            controller.selectedTargetListUsers = targetList.id;            
            controller.changeTargetList();
            //User Target List User should be current User 
            System.assertEquals(controller.userTargetList.User__c, testUser.Id,'User Target List User should be current User ');
            //This Target list should have Authorized true
            System.assertEquals(true, controller.userTargetList.Authorized__c,'This Target list should have Authorized true');
            //This Target list should have Target list member
            System.assertNotEquals(0, controller.userTargetList.Number_of_Target_Members__c,'This Target list should have Target list member');
            //This Target list should have Target list member
            System.assertNotEquals(0, controller.listOfMyMembers.size(),'This Target list should have Target list member');
            
            
            controller.setAuthorized();
            //This Target list should have Authorized true
            System.assertEquals(true, controller.userTargetList.Authorized__c,'This Target list should have Authorized true');
            
            controller.listOfMyMembers[0].isSelected = true;
            controller.selectedId = targetList2.id;
            controller.reassignMembersToList();         
            
            controller.selectedTargetListMemberId = members[0].Id;
            // Set Email Eligibility To No
            controller.EmailEligibility ='No';
            //It Updates The Target List Member Eligible_for_email__c to false;
            controller.changeEmailEligibility();
            
            
            Test.stopTest();
        }
    }
    
    
    static testMethod void test2(){
        User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       //TestClassUtilities.createMyiiListAdminProfiles();
       TestClassUtilities.setAllTriggerOn();
        }
        System.runAs(testUser) {
            TestClassUtilities.createMyiiListAdminProfiles();
            
            createData(testUser);
            
            Test.startTest();
            
            MyiiListController controller = new MyiiListController();
            
            controller.selectedTargetListUsers = targetList2.id;            
            controller.changeTargetList();
            //Change current Target list ; select target List2
            System.assertEquals(targetList2.id,controller.userTargetList.id,'Change current Target list ; select target List2');
            //This list does not have any reassigned contacts , unviewed count should be zero
            //System.assertEquals(1,controller.unviewedCount,'This list does not have any reassigned contacts , unviewed count should be zero');
            
            //Test.startTest();
            controller.refershList();
            //Selected Analyst is blank
            System.assertEquals('', controller.selectedAnalyst,'Selected Analyst is blank');
                        
            controller.updateReassignedViewedByUser();
            //This list does not have any reassigned contacts , unviewed count should be zero
            System.assertEquals(0,controller.unviewedCount,'This list does not have any reassigned contacts , unviewed count should be zero');
            
            //controller.listOfMyMembers[0].isSelected = true;
            controller.reason ='test';
            
            controller.removeMembersFromList();  
            
            
            controller.selectedCampaign = String.ValueOf(campaings[0]);
            controller.populateTargetListUserList();   
            
            MyiiListController.MilestoneWrapper milestone = new MyiiListController.MilestoneWrapper();
            
            Test.stopTest();
        }
        
    }
    
    static testMethod void myiiListTestReassign2() 
    {   
         MyiiListController newobj = new MyiiListController();
         newobj.isEmailOnlyOn  = true;
        
         newobj.refershList();
         newobj.isAdminProfiles = true;   
         MyListEmailRecipientController emailRecipient = new MyListEmailRecipientController();
         
            MyListEmailRecipientController.memberWrapper emailonlymember = new MyListEmailRecipientController.memberWrapper(true,new Target_List_Member__c());
            
            emailRecipient.listOfMyTarget.add(emailonlymember);
           
             MyListEmailRecipientController.memberWrapper emailonlymember2 = new MyListEmailRecipientController.memberWrapper(true,new Target_List_Member__c());
             emailRecipient.listOfMyTarget.add(emailonlymember2);
             newobj.emailOnlyController = emailRecipient;
            System.debug('=====================listSize======='+ newobj.emailOnlyController.listOfMyTarget.size());
         
         
         User usr = [SELECT Id From User WHERE Id =: UserInfo.getUserId() Limit 1];
       system.runAs(usr){
        // Get user
       testUser = getTempUser(); //DataUtil.getTestUserWithRole();
       //TestClassUtilities.createMyiiListAdminProfiles();
       TestClassUtilities.setAllTriggerOn();
        }
         System.runAs(testUser) {
         
         TestClassUtilities.createMyiiListAdminProfiles();
         createData(testUser);
         Test.startTest();
         newobj.userTargetList = targetList2;
         newobj.refershList();
         newobj.selectedTargetListUsers = targetList.id;            
         newobj.changeTargetList();
          
         newobj.setAuthorized();
                  
         newobj.listOfMyMembers[0].isSelected = true;
         newobj.selectedId = targetList2.id;
          //emailRecipient.listOfMyTarget[0].isSelected = true;  
         System.debug('=====================listSizeEnd======='+emailRecipient.listOfMyTarget); 
         newobj.reassignMembersToList();
         newobj.RECORD_PAGE_SIZE = 1;
         newobj.updateNewPagesize();
         newobj.refershList();
          
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
         
         System.assertEquals(1,newobj.CurrentPageNumber);
         System.debug(members.size() + '===================' + newobj.TotalRecords);
         System.assert(4 <= newobj.TotalRecords);
        
         System.assertEquals(1,newobj.recordStartNumber);
         System.assertEquals(1,newobj.TotalPage);
         System.assert(4 <= newobj.recordEndNumber);
         
        newobj.next();
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        System.assert(4 <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        System.assert(4 <= newobj.recordEndNumber);
         
        newobj.previous(); 
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        System.assert(4 <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        System.assert(4 <= newobj.recordEndNumber);
         
         
        newobj.gotoPageNumber = 1; 
        newobj.gotoPageRange = '1-1';
        newobj.goToPage();
        
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        System.assert(4 <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        System.assert(4 <= newobj.recordEndNumber);
        
        newobj.first();
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        System.assert(4 <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        System.assert(4 <= newobj.recordEndNumber);
        
        newobj.last();
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        System.assert(4 <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        System.assert(4 <= newobj.recordEndNumber);
        Test.stopTest();
         
         }
       }   
    
        
       
    static void createData(User dUser){
        //T1C_CustomSettingsManager.setAllTriggerOn();
        T1C_CustomSettingsManager.createChatterSetting();
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
        
        GPSAccount__c acc3 = new GPSAccount__c();
        acc3.name = 'acc3';
        acc3.Trading_Name_ID__c = 'TN-009';
        //acc3.Client_Type__c = 'Internal';
        listAccounts.add(acc3);
        
        GPSAccount__c acc4 = new GPSAccount__c();
        acc4.name = 'acc4';
        acc4.Trading_Name_ID__c = 'TN-010';
        //acc4.Client_Type__c = 'Internal';
        listAccounts.add(acc4);
        
        insert listAccounts;
        
        //Create test contacts
        GPSContact__c con;
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        Integer indx = 0;
        for(GPSAccount__c acc : listAccounts){
            con = new GPSContact__c();
            con = Common_ContactUtil.createContact(acc.id, indx); 
            listContacts.add(con);
            indx++;
        }
        
        insert listContacts; 
        
        
        
        
         
         iiCampaign__c camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         campaings.add(camp);
         
         iiCampaign__c camp2 = new iiCampaign__c();
         camp2.Campaign_Name__c  ='TEST CAMPAINGS2';
         camp2.Start_Date__c = Date.today();
         camp2.Active_Flag__c = true;
         campaings.add(camp2);
          
         insert campaings;
        
        
        List<Target_List__c> targetLists = new List<Target_List__c>();
        targetList = new Target_List__c();
        targetList.User__c = dUser.Id;
        targetList.Authorized__c = true;
        targetList.iiCampaign__c = camp.id;
        targetLists.add(targetList);
        
        targetList2 =  new Target_List__c();
        targetList2.User__c = dUser.Id;
        targetList2.Authorized__c = true;
        targetList2.iiCampaign__c = camp.id;
        targetLists.add(targetList2);
        
        targetList3 =  new Target_List__c();
        targetList3.User__c = dUser.Id;
        targetList3.Authorized__c = true;
        targetList3.iiCampaign__c =  campaings[1].Id;
        targetLists.add(targetList3);
        
        
        Target_List__c otherOwnerTargetList = new Target_List__c();
        otherOwnerTargetList.User__c = dUser.Id;
        otherOwnerTargetList.Authorized__c = true;
        otherOwnerTargetList.iiCampaign__c = camp.id;
        targetLists.add(otherOwnerTargetList);
    
        insert targetLists;
        system.debug('__________USER_____'+dUser.Id);
        //Create test Candidate Information
        listConInfo = new List<Candidate_Information__c>();
        
        Candidate_Information__c candInfo = new Candidate_Information__c();
        candInfo.Candidate_Name__c = 'Candidate1';
        candinfo.iiCampaign__c = camp.Id;
        listConInfo.add(candInfo);
        
        candInfo = new Candidate_Information__c();
        candInfo.Candidate_Name__c = 'Candidate2';
        candinfo.iiCampaign__c = camp2.Id;
        listConInfo.add(candInfo);
        
        insert listConInfo;
        
        for(Candidate_Information__c cr : listConInfo){
            System.assert(cr.id != null);
        }
        
        //Create test Voter Recommendation
        List<Voter_Recommendation__c> listVoterRecom  = new List<Voter_Recommendation__c>();
        indx = 0;
        for (Candidate_Information__c cand : listConInfo)
        {
            Voter_Recommendation__c voterRecomm  = new Voter_Recommendation__c();
            voterRecomm.Candidate_Information__c = cand.Id;
            voterRecomm.GPSContact__c = listContacts[0].id;
            //03/15/2011  Urminder : added Unique_VR_Key__c unique key to voter Recommendation 
            voterRecomm.Unique_VR_Key__c = 'testUnique' + indx + Datetime.now();
            listVoterRecom.add(voterRecomm);
            indx++;
        }
        insert listVoterRecom;
        
        
        members = new List<Target_List_Member__c>(); 
        Target_List_Member__c targetListMember;
        integer index = 0;
        for(GPSContact__c cont : listContacts) {
            targetListMember = new Target_List_Member__c();
            if(index <= 1)
                targetListMember.Target_List__c = targetList.id;
            else
                targetListMember.Target_List__c = targetList2.id;
            targetListMember.Target_List_Member_Key__c = '123';
            targetListMember.GPSContact__c = cont.Id;
            //targetListMember.Removed_Reason__c = 'Email Only';
            targetListMember.Viewed_by_User__c = true;
            members.add(targetListMember);
        }
        
        for(GPSContact__c cont : listContacts) {
            targetListMember = new Target_List_Member__c();
            targetListMember.Target_List__c = otherOwnerTargetList.id;
            targetListMember.Target_List_Member_Key__c = '123';
            targetListMember.GPSContact__c = cont.Id;
            targetListMember.User_who_left_Voicemail_del__c = dUser.id;
            targetListMember.user_who_confirmed_ballot_received__c = dUser.id;
            targetListMember.User_Who_Called_the_Contact__c = dUser.id;
            targetListMember.User_who_confirmed_Vote_Last__c = duser.Id;
            //targetListMember.Removed_Reason__c = 'Email Only';
            members.add(targetListMember);
        }
        
        System.debug('============size========'+members.size());  
        insert members;
        
         //creating new Attachment
        attach = new Attachment();
        attach.Name = 'sample_email.pdf';
        Blob   body =Blob.valueOf('121121');
        attach.body = body;
        attach.parentid = camp.id;
        insert attach;
         
        Apexpages.currentPage().getParameters().put('sortOrder','1');
        Apexpages.currentPage().getParameters().put('sortOn','Account');
        
        iiCampaign_Milestone__c milestone = new iiCampaign_Milestone__c();
        milestone.Due_date__c = Date.today() + 1;
        milestone.iiCampaign__c = camp.id;
        milestone.Milestone__c = 'TestMilestone';
        insert milestone;
        
    }
    
    
}