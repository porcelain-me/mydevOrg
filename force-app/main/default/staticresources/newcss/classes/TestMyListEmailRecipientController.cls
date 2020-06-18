/**************************************************************************************
Name            :       TestMyListEmailRecipientController
Created By      :       Appirio Offshore(Deshraj Kumawat)
Created On      :       April 12, 2010
Description     :       For Code coverage of MyListEmailRecipientController
Related PR      :       PR-04313
Last Updated    :       08 Sep 2010    Kapil Choudhary   Code Added to Boost Up Code Coverage for 
                                       RemoveEmailOnly and removeMembersFromList funcionality
                        14 Sep 2010    Chetan Garg  Updating Test Class
                        20 Sep 2010    Chetan Garg  Updating Test Class and Asserts  
                        21 Sep 2010    Kapil Choudhary Update Test Class For Pagination Removel
                        04 Oct 2010    Chetan Garg  Updating Test Class and Asserts 
                        25 Nov 2010      Parth Tamhaney     Removed use of Existing User. Used Temp User
                    
***************************************************************************************/
@isTest
private class TestMyListEmailRecipientController {
    
    static User testUser;
    static Target_List__c targetList;
    static Target_List__c targetList2;
    static List<Target_List_Member__c> members;
    static List<iiCampaign__c> campaings = new List<iiCampaign__c>();
    static List<Candidate_Information__c> listConInfo;
    // Commented By Aditya : JIRA 4438 : To change Version to 24.0
    /*
     private static User getTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Global'];

        User tempUser = new User(alias = 'newUser', email='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            emailencodingkey='UTF-8', lastname='Testing',
            languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='TU' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
            UserRoleId = r.id,
            MSID__c = DateTime.now().format('ddyyhhmmss'));
    
        return tempUser;        
   }
   
   */
    
    static testMethod void emailRecipientTest() 
    {  
        // Added By Aditya : JIRA 4438 : To change Version to 24.0 
       Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
       testUser = [SELECT Id FROM USER WHERE profileID =: p.id and ISACTIVE = true limit 1]; 
       // temp user
       // Commented By Aditya : JIRA 4438 : To change Version to 24.0
       //testUser =  getTempUser();//DataUtil.getTestUserWithRole();
          
        System.runAs(testUser) {
            
            
            //Test if Show_Email_Only == false then list should not be returned
            MyListEmailRecipientController controller = new MyListEmailRecipientController();
            createData(testUser,controller);
            //TotalPage Should 0
            system.assertEquals(0,controller.TotalPage);
            //Sort field should be default
            system.assertEquals('Default',controller.sortOn,'Sort field should be default');
            //Sort Order should be 1
            system.assertEquals('1',controller.sortOrder,'Sort Order should be 1');
            //Sort field should be default
            system.assertEquals('Default',controller.sortOn,'Sort field should be default');
            //List of My Target List should not be null
            system.assertNotEquals(null,controller.listOfMyTarget,'List of My Target List should not be null');
            //Target List should not be null
            system.assertNotEquals(null,controller.userTargetList,'Target List should not be null');  
             
            
            controller.userTargetList = targetList2;
            controller.getEmailOnlyTargetMembers();
            //Sort field should be default
            system.assertEquals('Default',controller.sortOn,'Sort field should be default');
            //Sort Order should be 1
            system.assertEquals('1',controller.sortOrder,'Sort Order should be 1');
            //Sort field should be default
            system.assertEquals('Default',controller.sortOn,'Sort field should be default');
            //There is no Email Only Members ;List size should be zero
            system.assertEquals(0,controller.listOfMyTarget.size(),'There is no Email Only Members ;List size should be zero');
            
            
            controller.userTargetList = targetList;
            controller.getEmailOnlyTargetMembers();
            //Sort field should be default
            system.assertEquals('Default',controller.sortOn,'Sort field should be default');
            //Sort Order should be 1
            system.assertEquals('1',controller.sortOrder,'Sort Order should be 1');
            //Sort field should be default
            system.assertEquals('Default',controller.sortOn,'Sort field should be default');
            //There is 5 Email Only Members ;List size should be 5
            system.assertEquals(5,controller.listOfMyTarget.size(),'There is 5 Email Only Members ;List size should be 5');
            
            controller.selectedContactId = members[0].GPSContact__c;
            controller.selectedLang ='English';
            controller.changeContactIILanguage();           
            GPSContact__c con = [Select id,II_Language__c from GPSContact__c where id=: members[0].GPSContact__c limit 1];          
            for(MyListEmailRecipientController.memberWrapper wrapper : controller.listOfMyTarget){
                if(wrapper.listMember.GPSContact__c == con.id){
                    //This cotnact have iiLanguage English
                    System.assertEquals('English',con.II_Language__c,'This cotnact have iiLanguage English');
                }
            }
            
            
            
            controller.sortTargetListMembers();
            System.assert(controller.userTargetList != null);
            //List of My Target List should not be null
            system.assertNotEquals(null,controller.listOfMyTarget,'List of My Target List should not be null');
            //There is 5 Email Only Members ;List size should be 5
            system.assertEquals(5,controller.listOfMyTarget.size(),'There is 5 Email Only Members ;List size should be 5');
            
            
            controller.listOfMyTarget[0].isSelected = true;
            controller.RemoveEmailOnly();
            controller.getEmailOnlyTargetMembers();
            //Email only record list size should be 4 , as we removed one 
            System.assertEquals(4, controller.listOfMyTarget.size(),'Email only record list size should be 4');
            
            
            for(MyListEmailRecipientController.memberWrapper wrapper : controller.listOfMyTarget){
                wrapper.isSelected = true;
            }
            controller.reason = 'This contact does not vote for II.';
        controller.removeMembersFromList();
            //There is no Email Only Members ;List size should be zero
            //system.assertEquals(0,controller.listOfMyTarget.size(),'There is no Email Only Members ;List size should be zero');
            
            controller.updateReassignedViewedByUser();  
        }
    }
     static testMethod void emailRecipientTest2() 
    {   
        // Added By Aditya : JIRA 4438 : To change Version to 24.0
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        testUser = [SELECT Id FROM USER WHERE profileID =: p.id and ISACTIVE = true limit 1]; 
         // Commented By Aditya : JIRA 4438 : To change Version to 24.0
        //testUser =  getTempUser();//DataUtil.getTestUserWithRole();
          
        System.runAs(testUser) {
      
       MyListEmailRecipientController newobj = new MyListEmailRecipientController();
       createData(testUser,newObj);
       
     
         
         
        newobj.userTargetList = targetList;
        newobj.getEmailOnlyTargetMembers();
        
         newobj.RECORD_PAGE_SIZE = 1;
         newobj.updateNewPagesize();
         
          
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
         
         System.assertEquals(1,newobj.CurrentPageNumber);
         //System.assertEquals(members.size(), newobj.TotalRecords);
        
         System.assertEquals(1,newobj.recordStartNumber);
         System.assertEquals(1,newobj.TotalPage);
         System.assertEquals(5 , newobj.recordEndNumber);
         
        newobj.next();
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        System.assertEquals(5,newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
       //System.assertEquals(4 , newobj.recordEndNumber);
         
        newobj.previous(); 
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        System.assertEquals(5, newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
       // System.assertEquals(4 , newobj.recordEndNumber);
         
         
        newobj.gotoPageNumber = 1;
        newobj.gotoPageRange = '1-1';
        newobj.goToPage();
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
       // System.assert(members.size() <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        //System.assert(4 <= newobj.recordEndNumber);
        
        newobj.first();
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
       //System.assert(members.size() <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        //System.assert(4 <= newobj.recordEndNumber);
        
        newobj.last();
        System.assertEquals(false,newobj.hasNext);
        System.assertEquals(false,newobj.hasPrevious);
        System.assertEquals(true,newobj.isFirst);
        System.assertEquals(true,newobj.isLast);
        System.assertEquals(1,newobj.CurrentPageNumber);
        //System.assert(members.size() <= newobj.TotalRecords);
        System.assertEquals(1,newobj.recordStartNumber);
        System.assertEquals(1,newobj.TotalPage);
        //System.assert(4 <= newobj.recordEndNumber);
        
        newobj.RECORD_PAGE_SIZE = 100;
         newobj.updateNewPagesize();
        
        } 
         
    } 
    
    
    static void createData(User dUser,MyListEmailRecipientController controller){
        TestClassUtilities.setAllTriggerOn();
        List<iiCampaign__c> testCampaings = new List<iiCampaign__c>();
        iiCampaign__c camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         camp.Show_Email_Only_Page__c = true;
         testCampaings.add(camp);
         
         camp = new iiCampaign__c();
         camp.Campaign_Name__c  ='TEST CAMPAINGS';
         camp.Start_Date__c = Date.today();
         camp.Active_Flag__c = true;
         camp.Show_Email_Only_Page__c = false;
         testCampaings.add(camp);
         
         insert testCampaings;
         
         
         
        List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();
        
        GPSAccount__c acc1 = new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss');
        //acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
        acc1.Active_Flag__c = true;
        listAccounts.add(acc1);
        
        insert listAccounts;
        
        
        //Create test contacts
        GPSContact__c con;
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        
        for(Integer i = 0; i < 10 ; i++){
            con = new GPSContact__c(); 
            con.firstName__c = 'TestContact';
            con.lastName__c = 'Test'+ i;
            con.GPSAccount__c = listAccounts[0].id;
            con.Trading_Name_ID__c =  'c'+ i + Datetime.now().format('hhmmss');
            con.CIS_Contact_ID__c =   'c'+ i + Datetime.now().format('hhmmss');
            con.TN_Contact_Key__c =  'ts'+ i + Datetime.now().format('ddhhmmss');
            listContacts.add(con);
        }
        
        insert listContacts;
        
        for(GPSContact__c cont : listContacts){
            System.assert(cont.id != null);
        }
        // Added By Aditya : JIRA 4438 : To change Version to 24.0
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        testUser = [SELECT Id FROM USER WHERE profileID =: p.id and ISACTIVE = true limit 1]; 
        List<Target_List__c> targets = new List<Target_List__c>();
        targetList = new Target_List__c();
        targetList.User__c = testUser.Id;
        targetList.Authorized__c = true;
        targetList.iiCampaign__c = testCampaings[0].id;
        targetList.User__c = dUser.id;
        targets.add(targetList);
        
        
        targetList2 = new Target_List__c();
        targetList2.User__c = testUser.Id;
        targetList2.Authorized__c = true;
        targetList2.iiCampaign__c = testCampaings[0].id;
        targetList2.User__c = dUser.id;
        targets.add(targetList2);
        
        insert targets;
        
        controller.userTargetList = targetList2;
        
        targetList.iiCampaign__r = testCampaings[0];
        targetList2.iiCampaign__r = testCampaings[1];
        
        Target_List_Member__c targetListMember;
        
        members = new List<Target_List_Member__c>();
        for(Integer i = 0; i < 5; i++) {
             targetListMember = new Target_List_Member__c();
             targetListMember.Target_List__c = targetList.id;
             targetListMember.Target_List_Member_Key__c = '123';
             targetListMember.Removed_Reason__c = 'Email Only';
             targetListMember.GPSContact__c = listContacts[i].Id;
             targetListMember.User_who_left_Voicemail_del__c = dUser.id;
             
            targetListMember.User_who_confirmed_Vote_Last__c = dUser.id;
            targetListMember.user_who_confirmed_ballot_received__c = dUser.Id;
            targetListMember.User_Who_Called_the_Contact__c = dUser.Id;
             targetListMember.Viewed_by_User__c = false;
             members.add(targetListMember);
             
        }
        
        targetListMember = new Target_List_Member__c();
        targetListMember.Target_List__c = targetList2.id;
        targetListMember.Target_List_Member_Key__c = '123';
        targetListMember.Removed_Reason__c = 'Email Only';
        targetListMember.GPSContact__c = listContacts[0].Id;
        targetListMember.Viewed_by_User__c = false;
        targetListMember.User_who_left_Voicemail_del__c = dUser.id;
        targetListMember.User_who_confirmed_Vote_Last__c = dUser.id;
        targetListMember.user_who_confirmed_ballot_received__c = dUser.Id;
        targetListMember.User_Who_Called_the_Contact__c = dUser.Id;
        
        members.add(targetListMember);
        insert members;
    }
    
   
    
    
}