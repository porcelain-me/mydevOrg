//modified
//11/02/2011 UV : insert CTM in createData Method
@isTest
private class TestCM_LoadTargetListOnDL {
    static List<Distribution_List__c > lstDList;
    static List<Distribution_List__c > lstUserDList;
    static Campaign__c camp;
    static Integer SIZE_OF_ITEMS = 5;
    static User usr;
    
    static {
        //usr = CM_TestClassUtilities.getTempUser();
        usr = getTempUser();
    }
    
    static User getTempUser(){
  
        Profile p = [select id from Profile where Name = 'All MS Employee'];
        
        User u = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, 
                                 Short_Id__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 Emp_Id__c = 'test1', isActive = true);
        return u;
    }  
    
    static testMethod void loadTargetlistTest() { 
        T1C_CustomSettingsManager.setAllTriggerOn();      
        System.runAs(usr) {
            Test.startTest();
            createData();
            CM_LoadTargetListOnDL controller = new CM_LoadTargetListOnDL();
            System.assertEquals(SIZE_OF_ITEMS, controller.lstDistributionList.size() ,'Total Distribution List size shoulb be equals to SIZE_OF_ITEMS(5)');
            
            controller.selectedDLId = lstDList[0].Id;
            controller.selectedCampaignId = camp.Id;
            
            list<DistributionListItem__c> distItemList = controller.getDistributorListItems(lstDList[0].Id, camp.Id);
            System.assertEquals(SIZE_OF_ITEMS,distItemList.size(),'Items in this Distribution should be equals to SIZE_OF_ITEMS Inserted');
            controller.loadTargetListonSelectedDL();
            
            List<DistributionListItem__c> dLItemList = [Select d.GPSContact__c, d.GPSContact__r.Name From DistributionListItem__c d where d.GPSContact__c <> null and d.DistributionList__c = : controller.selectedDLId and d.Active_Flag__c = true];
            List<Campaign_Member__c> lstCampMembers = [Select id from Campaign_Member__c where Campaign__c =: camp.Id];
            
            System.assertEquals(dLItemList.size(), lstCampMembers.size(), 'Campaign Member and Distribution List Items size should match');         
            
            Test.stopTest();
            
        }
    }
    
    static testMethod void loadTargetlistTest1() {
        T1C_CustomSettingsManager.setAllTriggerOn();      
         System.runAs(usr) {
          Test.startTest();
          createData();
          CM_LoadTargetListOnDL controller = new CM_LoadTargetListOnDL();
          System.assertEquals(SIZE_OF_ITEMS, controller.lstDistributionList.size());
          
          controller.selectedDLId = lstDList[0].Id;
          controller.selectedCampaignId = camp.Id;
          List<DistributionListItem__c> lstDistItems = controller.getDistributorListItems(lstDList[0].Id, camp.Id);
          List<Campaign_Member__c> lstCampaignMember = controller.loadTargetListonSelectedDL(lstDList[0].id,camp.Id);
          
          System.assertEquals(lstDistItems.size() ,lstCampaignMember.size(), 'List sizes should match');
          System.assertEquals(SIZE_OF_ITEMS,lstDistItems.size(),'Size of the Items should be equals to SIZE_OF_ITEMS Defined ');
          Test.stopTest();
        }
        
    }
    
    static testMethod void loadTargetListonSelectedDLTest() {
        T1C_CustomSettingsManager.setAllTriggerOn();      
         System.runAs(usr) {
          Test.startTest();
          createData();
          CM_LoadTargetListOnDL controller = new CM_LoadTargetListOnDL();
          System.assertEquals(SIZE_OF_ITEMS, controller.lstDistributionList.size());
          
          controller.selectedDLId = lstDList[0].Id;
          controller.selectedCampaignId = camp.Id;
          List<DistributionListItem__c> lstDistItems = controller.getDistributorListItems(lstDList[0].Id, camp.Id);
          List<Campaign_Member__c> lstCampaignMember = controller.loadTargetListonSelectedDL(lstDList[0].id, camp.Id, false, lstDList[0].name);
          
          System.assertEquals(lstDistItems.size() ,lstCampaignMember.size(), 'List sizes should match');
          System.assertEquals(SIZE_OF_ITEMS,lstDistItems.size(),'Size of the Items should be equals to SIZE_OF_ITEMS Defined ');
          
          lstCampaignMember = controller.loadTargetListonSelectedDL(lstDList[0].id, camp.Id, false, lstDList[0].name);
          
          System.assertEquals(0 ,lstCampaignMember.size(), 'There should be 0 campaign members inserted now as they are already there for the current user');
          
          
          Test.stopTest();
        }
        
    }
    
    static testMethod void loadTargetListonSelectedDLMyContactsTest() {
        T1C_CustomSettingsManager.setAllTriggerOn();      
         System.runAs(usr) {
          Test.startTest();
          createData();
          CM_LoadTargetListOnDL controller = new CM_LoadTargetListOnDL();
          System.assertEquals(SIZE_OF_ITEMS, controller.lstDistributionList.size());
          
          controller.selectedDLId = lstDList[0].Id;
          controller.selectedCampaignId = camp.Id;
          List<DistributionListItem__c> lstDistItems = controller.getDistributorListItems(lstDList[0].Id, camp.Id);
          List<Campaign_Member__c> lstCampaignMember = controller.loadTargetListonSelectedDL(lstDList[0].id, camp.Id, true, lstDList[0].name);
          
          System.assertEquals(SIZE_OF_ITEMS ,lstCampaignMember.size(), 'My Contacts campaign member should get inserted');
          
          Test.stopTest();
        }
        
    }
    
    //insert
    static void insertEmployee() {
        List<GPSEmployee__c> lstEmployee = new List<GPSEmployee__c>();
          for(Integer i = 0; i>SIZE_OF_ITEMS; i++){
            GPSEmployee__c e = new GPSEmployee__c();
            e.Name = 'test' + i;
            e.Division__c = 'Research';
          
            e.MS_ID__c = 'testSEFR';
            //e.User__c = usr.Id;
            e.Is_Producer_Employee__c = true;
            e.Active_Flag__c = true;
            lstEmployee.add(e);
          }
          insert lstEmployee;
    }
    static void createData() {
        T1C_CustomSettingsManager.createChatterSetting();
         CM_TestClassUtilities.SetCamapignLimitSettings();
         T1C_CustomSettingsManager.setAllTriggerOn();
         
            camp = new Campaign__c();
            camp.Name = 'Test Campaign3';
            camp.Active__c = true; 
            camp.Status__c = 'Active';
            camp.External_Id__c = '1234';
            camp.Region__c = 'JP';
            insert camp;
         
         
         
         
         // Insert 2 Accounts
      List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'ts1'+ Datetime.now().format('ddhhmmss');
        //acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
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
        List<GPSContact__c> listContacts = new List<GPSContact__c>();
        
      // add 10 contacts for first account
      for(integer indx = 0; indx < SIZE_OF_ITEMS; indx++){
        con = new GPSContact__c(); 
        con.firstName__c = 'TestContact_FirstAccount_' + indx;
        con.lastName__c = listAccounts[0].name;
        con.GPSAccount__c = listAccounts[0].id;
        con.Phone__c = '+91-123456789000';
        con.Mobile__c = '+91-123456789000';
        con.Language_Preference__c = 'English Only';
        con.Trading_Name_ID__c =  'c'+ indx + Datetime.now().format('hhmmss');
            con.CIS_Contact_ID__c =   'c'+ indx + Datetime.now().format('hhmmss');
            con.TN_Contact_Key__c =  'ts'+ indx + Datetime.now().format('ddhhmmss');
        listContacts.add(con);
      }
      // add 10 contacts for second account
      for(integer indx = 0; indx < SIZE_OF_ITEMS; indx++){
        listContacts.add(Common_ContactUtil.createContact((string)listAccounts[0].Id, indx, 'English Only'));
      }
      insert listContacts;
         
         
        lstDList = new List<Distribution_List__c>();     
         lstUserDList = new List<Distribution_List__c>();
         for(integer indx = 0; indx < SIZE_OF_ITEMS; indx++){
              Distribution_List__c dist = new Distribution_List__c();
              dist.Name ='test_DistributionList_' + indx;
              dist.List_Id__c = 'List_Id__' + indx;
              dist.Active_Flag__c = true;
              lstDList.add(dist);
              
              dist = new Distribution_List__c();
              dist.Name ='test_DistributionList_' + indx + '~' + usr.Emp_Id__c;
              dist.List_Id__c = 'List_Ids_' + indx;
              dist.Active_Flag__c = true;
              lstUserDList.add(dist);
              
        }
        insert lstDList;
        insert lstUserDList;
        
        List<DistributionListItem__c> listItems = new List<DistributionListItem__c>();
        List<DistributionListItem__c> listUserDistItems = new List<DistributionListItem__c>();
        
        DistributionListItem__c item = new DistributionListItem__c();
        for(Distribution_List__c dl : lstDList){
            for(integer indx = 0; indx < SIZE_OF_ITEMS; indx++){
              item = new DistributionListItem__c();
              item.DistributionList__c = dl.id;
              item.GPSContact__c = listContacts[indx].id;
              item.Active_Flag__c= true ;
              //02/02/2012 UV : added this primary key
              item.Primary_Key__c = listContacts[indx].id + '|' + dl.Id + '|' + indx; 
              listItems.add(item);
            }
         }
        insert listItems; 
        
        for(Distribution_List__c dl : lstUserDList){
            for(integer indx = 0; indx < SIZE_OF_ITEMS; indx++){
              item = new DistributionListItem__c();
              item.DistributionList__c = dl.id;
              item.GPSContact__c = listContacts[indx].id;
              item.Active_Flag__c= true ;
              //02/02/2012 UV : added this primary key
              item.Primary_Key__c = listContacts[indx].id + '|' + dl.Id + '|' + indx;
              listUserDistItems.add(item);
            }
         }
        insert listUserDistItems; 
        list<Campaign_Team_Member__c> ctmList = new List<Campaign_Team_Member__c>();
            
        Campaign_Team_Member__c ctm = new Campaign_Team_Member__c();
        ctm.Campaign__c = camp.Id;
        ctm.User__c = usr.Id;
        ctmList.add(ctm);
    
        insert ctmList;
        Distribution_List_Access_Owner__c dListOwner = new Distribution_List_Access_Owner__c();
        //dListOwner.Name = 'Test Owner'; 
        dListOwner.Active_Flag__c = true;
        dListOwner.Primary_Key__c = lstDList[0].Id + '|';
        dListOwner.Distribution_List__c = lstDList[0].Id;
        insert dListOwner; 
    }
}