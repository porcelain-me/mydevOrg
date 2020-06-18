/***********************************************************
Class Name - TestCampaignsController 
Author - Urminder Vohra [Appiro-Offshore]
Created Date - 9/15/2011


***********************************************************/
// 10/13/2011 RJ: Modified and added new test methods for import client tracker list dialog functionality
// 02/28/2012 UV: modified defaultValuesTest() method. Added new assert. 
@isTest
private class TestCampaignsController {
    static List<GPSAccount__c> listAccounts;
    static List<GPSContact__c> listContacts;
    static List<Campaign__c> campList;
    static User usr;
    static User usr1;
    static List<Distribution_List__c> listOfdists;
    static List<DistributionListItem__c> listItems;
    static integer DistrtibutionListsCount = 10;
    static integer DistrtibutionListItemCount = 2;    
    static integer ContactsPerAccount = 10; 
    
   static{ 
        // temp user
       //usr =  CM_TestClassUtilities.getTempUser();
       usr = getTempUser();
       usr1 = getTempUser1();
       }
       
     static User getTempUser(){
    
        Profile p = [select id from Profile where Name = 'System Administrator'];
        
        User u = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, 
                                 // T1C_User_Short_ID__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test1', isActive = true );
        return u;
     }  
    
    static User getTempUser1(){
    
        Profile p1 = [select id from Profile where Name = 'All MS Employee'];
        
        User u1 = new User(alias = 'test1', email = 'T12' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p1.id, 
                                 // T1C_User_Short_ID__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 //FIRMWIDE_ID__c = 'test1_test',
                                 Emp_Id__c = 'test11', isActive = true );
        return u1;
     }    
    
    
    static testMethod void defaultValuesTest() {
        T1C_CustomSettingsManager.setAllTriggerOn(); 
        System.runAs(usr1) {
            Test.startTest();
            createData();
            CampaignsController controller = new CampaignsController();
            // by default only ative campaigns are fetched with status active/completed
            System.assert(10 <= controller.campaignsList.size());
            controller.selectedCampaignId = campList[0].id;
            controller.updateLastViewedCampaign();            
            controller.updateStructuredFeedbackValues(controller.selectedCampaign);
            System.assertEquals(controller.feedbackView.size(), 3, 'List should be containing 3 values');
            //02/28/2012 UV : added this new assert for the beta feedback link
            System.assertEquals(controller.betaFeedbackLink, CM_TestClassUtilities.Beta_FeedbackLink,'Link should match');
            controller.refreshChatter();
            Test.stopTest();
        }
        
    }
    
    static testMethod void loadAccessibleDistributionListsTest(){
        T1C_CustomSettingsManager.setAllTriggerOn(); 
        System.runAs(usr) {
            Test.startTest();
            createData();
            CampaignsController controller = new CampaignsController();
            // by default only ative campaigns are fetched with status active/completed
            controller.loadAccessibleDistributionLists();
            //6/7/2012 UV : update the assest value DistrtibutionListsCount as default value is also added in the list 
            System.assertEquals(controller.lstDistributionList.size(), DistrtibutionListsCount + 1, 'User should have access to all the distribution list items inserted');
            
            controller.currentEmpLastSelectedDistributionList = listOfdists[0].Id;            
            //controller.updateDistributionList();
            controller.currentEmpIsUseMyContactList = true;
            controller.updateEmployeeDetail();
            
            GPSEmployee__c emp = [SELECT Last_Selected_Distribution_List__c, IsUseMyContactList__c FROM GPSEmployee__c WHERE User__c = :usr.Id limit 1];
            
            System.assertEquals(controller.currentEmpLastSelectedDistributionList, emp.Last_Selected_Distribution_List__c, 'Employee should have distribution list as last selected DL.');
            System.assertEquals(controller.currentEmpIsUseMyContactList, emp.IsUseMyContactList__c, 'Employee should have true value as my GPSContact__c checkbox was true.');
            
            controller.pageAction();
            System.assertEquals(controller.allowTargetListImport, false, 'Because Allow_Target_List_Import__c is not checked it should return false');
            
            Test.stopTest();
        }
    }    
    
    /*static testMethod void loadAccessibleDistributionListsForSingleListItemTest(){ 
      System.runAs(usr) {
            Test.startTest();
            createData();
            List<Distribution_List__c> listOfdistsToRemove = new List<Distribution_List__c>();
            integer index = 1;
            for(Distribution_List__c dL : listOfdists){
                if(index <> 1){
                 listOfdistsToRemove.add(dL);
                }
                index++;
            }            
            delete listOfdistsToRemove;
            
            campList[0].Allow_Target_List_Import__c = true; 
            update campList[0];
            
            CampaignsController controller = new CampaignsController();                        
            controller.pageAction();
            System.assertEquals(controller.allowTargetListImport, false, 'Because Allow_Target_List_Import__c is checked but it should return false because the list is already loaded');
            
            List<CampaignMember> cMList = [Select id from CampaignMember where CampaignId = :  campList[0].id];
            
            System.assertEquals(cMList.size(), DistrtibutionListItemCount, 'New Campaign__c members should be added');
            
            Test.stopTest(); 
        }
    } */
    
    static testMethod void pageTest(){
        T1C_CustomSettingsManager.setAllTriggerOn(); 
      System.runAs(usr) {
            Test.startTest();            
            createData();  
            
            CampaignsController controller = new CampaignsController();
            System.assert(10 <= controller.campaignsList.size());
            
            campList[0].Allow_Target_List_Import__c = true;
            update campList[0];
            
            controller.selectedCampaignId = campList[0].id;
            controller.updateLastViewedCampaign(); 
            // by default only ative campaigns are fetched with status active/completed  
            //6/7/2012 UV : update the assest value DistrtibutionListsCount as default value is also added in the list          
            System.assertEquals(controller.lstDistributionList.size(), DistrtibutionListsCount + 1, 'User should have access to all the distribution list items inserted');
                        
            controller.pageAction();
            System.assertEquals(controller.allowTargetListImport, true, 'Because Allow_Target_List_Import__c is checked it should return false');            
            Test.stopTest();
        }
    } 
    
    public static void createData() {
        T1C_CustomSettingsManager.createChatterSetting(); 
      CM_TestClassUtilities.setCamapignLimitSettings();
      T1C_CustomSettingsManager.setAllTriggerOn(); 
      
      listAccounts = new List<GPSAccount__c>();        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'ts1'+ Datetime.now().format('ddhhmmss');
       // acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
        acc1.Active_Flag__c = true;
        listAccounts.add(acc1);     
        GPSAccount__c acc2 = new GPSAccount__c();
        acc2.name = 'acc2';
        acc2.Trading_Name_ID__c = 'ts2'+ Datetime.now().format('ddhhmmss');
        //acc2.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');
        acc2.Active_Flag__c = true;   
        listAccounts.add(acc2);     
        insert listAccounts;
      
      
      
      
        
        //Create test contacts
        GPSContact__c con;
        listContacts = new List<GPSContact__c>();
        
      // add 10 contacts for first GPSAccount__c
      for(integer indx = 0; indx < ContactsPerAccount; indx++){
        con = new GPSContact__c(); 
        con.FirstName__c = 'TestContact_FirstAccount_' + indx;
        con.LastName__c = listAccounts[0].name;
        con.Account_Name__c = listAccounts[0].id;
        con.Phone__c = '+91-123456789000';
        con.Mobile__c = '+91-123456789000';
        con.Language_Preference__c = 'English Only';
        con.Trading_Name_ID__c =  'c'+ indx + Datetime.now().format('hhmmss');
            con.CIS_Contact_ID__c =   'c'+ indx + Datetime.now().format('hhmmss');
            con.TN_Contact_Key__c =  'ts'+ indx + Datetime.now().format('ddhhmmss');
        listContacts.add(con);
      }
      // add 10 contacts for second GPSAccount__c
      for(integer indx = 0; indx < ContactsPerAccount; indx++){
       //Swapna Comment listContacts.add(Common_ContactUtil.createContact(listAccounts[0].id, indx, 'English Only'));
      }
      insert listContacts;
        
        
      listOfdists = new List<Distribution_List__c>();     
      for(integer indx = 0; indx < DistrtibutionListsCount; indx++){
          Distribution_List__c dist = new Distribution_List__c();
          dist.Name ='test_DistributionList_' + indx;
          dist.List_Id__c = 'List_Ids@' + indx;
          dist.Active_Flag__c = true;
          listOfdists.add(dist);
      }
      insert listOfdists;
        
      
      // insert distribution list items 
      // such that each distribution list has n no of contacts list items  
      listItems = new List<DistributionListItem__c>();
      DistributionListItem__c item = new DistributionListItem__c();
      for(Distribution_List__c dl : listOfdists){
        for(integer indx = 0; indx < DistrtibutionListItemCount; indx++){
            item = new DistributionListItem__c();
          item.DistributionList__c = dl.id;
          item.GPSContact__c = listContacts[indx].id;
          item.Active_Flag__c= true ;
          item.Primary_Key__c = listContacts[indx].id + '|' + dl.Id + '|' + indx;
          listItems.add(item);
        }
      }
      insert listItems;
      
        
        GPSEmployee__c e = new GPSEmployee__c();
        e.Name = 'test';
        e.Division__c = 'Research';
        e.MS_ID__c = 'TESTSEFR';
        e.User__c = usr.Id;
        e.Is_Producer_Employee__c = true;
        e.Last_Selected_Distribution_List__c = listOfdists[0].id; 
        e.IsUseMyContactList__c = True;
        e.Active_Flag__c = true;
        insert e;
        
        
        campList = new List<Campaign__c>();
        Integer index = 1;
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign2' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Active';
            camp.Region__c = 'EU';
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            camp.Feedback_View__c = 'HF;AP';
            camp.Feedback_Role__c = 'HF;AP';
            camp.Feedback_Region__c = 'HF;AP';
            camp.Feedback_Account_Type__c = 'HF;AP';            
            campList.add(camp);
            index++;
        }
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign3' + i;
            camp.Active__c = true; 
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            camp.Status__c = 'Active';
            camp.Region__c = 'JP';
            campList.add(camp);
            index++;
        }
        
       
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign__c' + i;
            camp.Active__c = true; 
            camp.Status__c = 'Inactive';
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            camp.Region__c = 'NA';
            campList.add(camp);
            index++;
        }
        
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign__c' + i;
            camp.Active__c = true; 
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            camp.Status__c = 'Hidden';
            camp.Region__c = 'LA';
            campList.add(camp);
            index++;
        }
        
        for(Integer i=0 ;i<5; i++) {
            Campaign__c camp = new Campaign__c();
            camp.Name = 'Test Campaign__c' + i;
            camp.Active__c = true; 
            camp.External_Id__c = index + String.valueOf(Math.random().intValue());
            camp.Status__c = 'Completed';
            camp.Region__c = 'LA';
            campList.add(camp);
            index++;
        }
        
        insert campList;
        Campaign_Team_Member__c ctm = new Campaign_Team_Member__c();
        ctm.Campaign__c = campList[0].Id;
        ctm.Campaign_Access_Level__c = 'Write';
        ctm.User__c = usr.Id;
        insert ctm;
    }
}