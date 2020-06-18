//modified
// 11/02/2011 UV :  Added a new method insertCampaignNotificationOnMemReassignmentTest() (line #57)
// 31- Oct -2013 Aditya : Production Issue: Quick Calls Interactions are not appearing
@isTest
private class TestCampaignRequestNotification {

static Campaign__c camp;
    static User usr;
    static Integer LIST_SIZE = 2;
    static List<Id> contactIds;
    static List<User> usrList;
    static List<GPSContact__c> listContacts;
    static List<task> tklist;
    static List<Campaign_Notification__c> cnList;
    final static string TASK_RECORDTYPE_NAME = 'Campaign_Request';
    final static string CN_Request_Record_Type = 'Request_Notification';
    final static boolean IS_SEND_NOTIFICATION_MAIL = false;
    /*
    static{
        // temp user
       usr =   CM_TestClassUtilities.getTempUser();
    }*/
    
     // 31- Oct -2013 Aditya : Production Issue: Quick Calls Interactions are not appearing
    static{
		User currentUser = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        System.runAs(currentUser){
	        // temp user
	      	usr =   TestCampaignRequestNotification.getTempUser();
        }
    }
    
    // 31- Oct -2013 Aditya : Production Issue: Quick Calls Interactions are not appearing created following method
    
    public static User getTempUser(){
       
	        TestCampaignRequestNotification.switchOFF();
	        
	        //Profile p = [SELECT Id FROM UserRole WHERE name='Campaign User'];
	        Profile p2 = [SELECT Id FROM Profile WHERE name='All MS Employee'];
	
	        User tempUser = new User(alias = 'test1Uer', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
	                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
	                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p2.Id, 
	                                 Short_Id__c = 'winLogT30',
	                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
	                                 Emp_Id__c = '10050', isActive = true);
	        
	        insert tempUser;
	        
	        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'GPS_Campaign_Permission_Set'];
	        PermissionSetAssignment psa = new PermissionSetAssignment();
	        psa.AssigneeId = tempUser.Id;
	        psa.PermissionSetId = ps.Id;
	        insert psa;
        
        return tempUser;
        }
        
        // 31- Oct -2013 Aditya : Production Issue: Quick Calls Interactions are not appearing created following method
        
        public static void switchOFF(){
        	
	        TestClassUtilities.setAllTriggerOn();

	        T1C_CustomSettingsManager.createChatterSetting();

	      
        }
static testMethod void InsertCampaignNotificationTest() { 
     
         System.runAs(usr){
         Test.startTest();
         CM_TestClassUtilities.SetCamapignLimitSettings();
         createData();
         
         tkList = [Select id from task where WhatId = :camp.id ];
         cnList = [Select id, Campaign__c, GPSContact__c from Campaign_Notification__c where campaign__c = : camp.id];
         
         System.assertEquals(tkList.size(), cnList.size(), 'List of Tasks should be equal to campaign Notifications');
         
         Test.stopTest();       
       }       
    }
static testMethod void deleteRequestTest() {
    // System.runAs(usr){
         Test.startTest();
         CM_TestClassUtilities.SetCamapignLimitSettings();
         createData();
         Integer listSize;
         tkList = [Select id from task where WhatId = :camp.id ];
         cnList = [Select id, Campaign__c, GPSContact__c from Campaign_Notification__c where campaign__c = : camp.id];
         listSize = cnList.size();
         
         System.assertEquals(tkList.size(), cnList.size(), 'List of Tasks should be equal to campaign Notifications');
         
         delete tkList;
         
         tkList = [Select id from task where WhatId = :camp.id ];
         System.assertEquals(tkList.size(), 0, 'Task is deleted. List size should be zero');
         
         cnList = [Select id, Campaign__c, GPSContact__c,Status__c from Campaign_Notification__c where campaign__c = : camp.id];
         System.assertEquals(cnList.size(), (listSize * 2), 'List size should match'); 
         for(Campaign_Notification__c cn : cnList) {
            //System.assertEquals(cn.status__c, 'Canceled', 'Status should be canceled');
         }
         
         Test.stopTest();       
      // }       
      
}

static testMethod void InsertCampaignNotificationTaskIdTest() {        
         System.runAs(usr){
           Test.startTest();
         
            CM_TestClassUtilities.SetCamapignLimitSettings();
            T1C_CustomSettingsManager.setAllTriggerOn();
            usrList = [Select u.Id, u.IsActive From User u where u.IsActive = true AND Id != :userinfo.getUserId() limit 2];
            Campaign__c camp2 = new Campaign__c();
            camp2.Name = 'Test Campaign_001';
            camp2.Status__c = 'Active';
            camp2.Region__c = 'ALL';
            camp2.External_Id__c = '1234';
            insert camp2;
            
            GPSAccount__c acc2= new GPSAccount__c();
            acc2.name = 'acc1';
            acc2.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss');
            //acc2.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
            acc2.Active_Flag__c = true;
            insert acc2;
         
            GPSContact__c con = Common_ContactUtil.createContact(0, (string)acc2.id); 
            insert con;
            
            // 31- Oct -2013 Aditya : Production Issue: Quick Calls Interactions are not appearing 
        
            //CIA_Interaction_Setting__c customSettingData =  CIA_Interaction_Setting__c.getInstance();
	        /*if(customSettingData == null || customSettingData.id==null ){
	            customSettingData = new CIA_Interaction_Setting__c(Name = '0');
	            insert customSettingData; 
	        }*/
            
            List<RecordType> rtypes = [Select DeveloperName, Id From RecordType where sObjectType='Task' and isActive=true and DeveloperName = :CM_TestClassUtilities.TASK_RECORDTYPE_NAME];
            if(rtypes.size() > 0 && rtypes[0].DeveloperName == CM_TestClassUtilities.TASK_RECORDTYPE_NAME){
        
            //create a task
            datetime t = System.now();
            date d = Date.newInstance(t.year(),t.month(),t.day());
             Task tsk = new Task();
              tsk.GPS_Contact__c  = con.Id;
              tsk.Type   = 'Call'; 
              tsk.WhatId = camp2.id;       
              tsk.OwnerId = usrList[1].Id;   
              tsk.Status  = 'Pending';       
              tsk.Description = 'Test request task ';   
              tsk.ActivityDate = d;
              tsk.Assignee_Feedback__c = '';
              tsk.RecordTypeId = rtypes[0].id;
             // Insert tsk;
              Insert tsk;
          
         } 
      
         
         tkList = [Select id from task where WhatId = :camp2.id ];
         cnList = [Select id, Campaign__c, GPSContact__c,TaskID__c from Campaign_Notification__c where campaign__c = : camp2.id];
         
         System.assertEquals(tkList[0].Id,cnList[0].TaskId__c,'Task Id should match');
         
         Test.stopTest();       
              
        }
    }

static testMethod void UpdateCampaignNotificationTest() {        
         //System.runAs(usr){
         Test.startTest();
         CM_TestClassUtilities.SetCamapignLimitSettings();
         createData();
         tkList = [Select id, status, GPS_Contact__c, WhatId, RecordTypeId, WhoId from task where WhatId = :camp.id ];
          system.debug('Task List is:'+tkList);   
         for(Integer i = 0;i < tkList.size();i++) {
           tkList[i].status = 'Completed';
           }
           system.debug('after updating task list'+tkList);
          Update tkList;                 
       // }
         
         tkList = [Select id from task where WhatId = :camp.id and status = 'Completed'];
         cnList = [Select id, Campaign__c, GPSContact__c from Campaign_Notification__c where campaign__c = : camp.id and status__c = 'Completed'];
         
         //System.assertEquals(tkList.size() * 2, cnList.size(), 'List of Tasks should be equal to campaign Notifications');
         Test.stopTest();       

       }       
    
static testMethod void insertCampaignNotificationOnMemReassignmentTest() {
  System.runAs(usr){
        Test.startTest();
        CM_TestClassUtilities.SetCamapignLimitSettings();
        createData();
        User testUser = [select id from User where isActive = true limit 1];    
        CM_CampaignNotificationManager.insertCampaignNotificationOnMemReassignment(camp.Id, testUser.Id, LIST_SIZE);    Test.stopTest();  
        }
   }
static testMethod void triggerSwitchOffTest() {
  System.runAs(usr){
        Test.startTest();
        GPSTrigger_Switch__c dSwitch = GPSTrigger_Switch__c.getInstance();
        if(dSwitch != null && dSwitch.Id <> null) {
          dSwitch.Is_CampaignRqstNotifyTrigger_On_Task__c = false;
          
          update dSwitch;
        } else {
           dSwitch = new GPSTrigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
           dSwitch.Is_CampaignRqstNotifyTrigger_On_Task__c = false;
           insert dSwitch;
        }
        
        /*createData();
        
        tkList = [Select id from task where WhatId = :camp.id ];
        
        System.assertEquals(tkList.size(),LIST_SIZE,'List Size should be matched');
        
        cnList = [Select id, Campaign__c,GPSContact__c from Campaign_Notification__c where campaign__c = : camp.id];
        System.assertEquals(cnList.size(),0,'No CN Records should be created');*/
         
        Test.stopTest();  
        }
   }
static void createData() {
          
        //   CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
        // if(cMGS == null){    
         //  cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
         //  cMGS.IS_SEND_NOTIFICATION_MAIL__c = IS_SEND_NOTIFICATION_MAIL;    
         //  cMGS.TASK_RECORDTYPE_NAME__c = TASK_RECORDTYPE_NAME; 
          // cMGS.CN_Request_Record_Type__c = CN_Request_Record_Type;
           // }
           CM_TestClassUtilities.SetCamapignLimitSettings();
          // T1C_CustomSettingsManager.setAllTriggerOn();
       
       TestCampaignRequestNotification.switchOFF();   // 31- Oct -2013 Aditya : Production Issue: Quick Calls Interactions are not appearing 
       usrList = [Select u.Id, u.IsActive From User u where u.IsActive = true limit 2];
       
	system.debug('##################################'+CM_GENERALSETTINGS__c.getInstance());
           
        //insert Campaign
        camp = new Campaign__c();
        camp.Name = 'Test Campaign_001';
        camp.Status__c = 'Active';
        camp.Region__c = 'ALL';
        camp.External_Id__c = '1234';
        insert camp;
        
        List<GPSAccount__c> listAccounts = new List<GPSAccount__c>();        
        GPSAccount__c acc1= new GPSAccount__c();
        acc1.name = 'acc1';
        acc1.Trading_Name_ID__c = 'tst'+ Datetime.now().format('ddhhmmss');
        //acc1.Client_Type__c = 'tst'+ Datetime.now().format('ddhhmmss');   
        acc1.Active_Flag__c = true;
        listAccounts.add(acc1);     
          
        insert listAccounts;
      
      
        //Create test contacts
        
        listContacts = new List<GPSContact__c>();
        //inserting Contacts
        for(Integer i = 0;i < LIST_SIZE;i++) {
          listContacts.add(Common_ContactUtil.createContact(i, (string)listAccounts[0].id));
          
        }
            insert listContacts;
      
        List<RecordType> rtypes = [Select DeveloperName, Id From RecordType where sObjectType='Task' and isActive=true and DeveloperName = :CM_TestClassUtilities.TASK_RECORDTYPE_NAME];
        if(rtypes.size() > 0 && rtypes[0].DeveloperName == CM_TestClassUtilities.TASK_RECORDTYPE_NAME){
        system.debug(camp+'List of contacts'+listContacts+'record types'+rtypes);
            //create a task
            datetime t = System.now();
            date d = Date.newInstance(t.year(),t.month(),t.day());
            List<Task> taskList = new List<Task>();
            for(Integer i = 0;i < LIST_SIZE;i++) {
              Task tsk = new Task();
              tsk.GPS_Contact__c  = listContacts[0].id;
              tsk.Type   = 'Call'; 
              tsk.WhatId = camp.id;       
              tsk.OwnerId = usrList[1].Id;   
              tsk.Status  = 'Pending';       
              tsk.Description = 'Test request task ';   
              tsk.ActivityDate = d;
              tsk.Assignee_Feedback__c = '';
              tsk.RecordTypeId = rtypes[0].id;
              taskList.add(tsk);
              }
             // Insert tsk;
              Insert taskList;
          
         } 
      }
}