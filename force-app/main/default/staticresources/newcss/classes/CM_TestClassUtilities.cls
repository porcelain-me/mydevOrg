/***********************************************************
Class Name - CM_TestClassUtilities 
Author - Urminder Vohra [Appiro-Offshore]
Created Date - 9/21/2011
Decsription - this class is used to intialise custom settings and as a helper to all test classes
 CBM_LIMIT = 1000;
          SUMMARY_LENGTH = 350;
          NO_OF_ATTACHMENTS = 2;
          ATTACHMENT_LENGTH = 60;
          MILESTONE_DESC_LENGTH = 75;
          No_Campaigns_Error_Message = 'There are no campaigns available!';
Modified:
02/28/2012 UV : added a new string which is link for the beta feedback on the campaigns page.(line#[57-58])
04/09/2013 MG : Updated to create sharing for temp user for Apps to resolve test class failures.
Modified by Sudarshan K. on 24th Feb 2016 while Campaign Migration
Now this Class will support only Campaign components.
***********************************************************/
public with sharing class CM_TestClassUtilities {
    public final static Integer CBM_LIMIT = 1000;
    public final static Integer Summary_Length = 350;
    public final static Integer NO_OF_ATTACHMENTS = 2;
    public final static Integer Attachment_Name_Length = 60;
    public final static Integer Milestone_Description_Length = 75;
    public final static String No_Campaigns_Error_Message = 'You currently have no GPS Campaigns available at this time!';
    
    public final static Integer Header_Attachments_Default_Value = 2;
    public final static Integer Header_Milestones_Default_Value = 2;
    public final static Integer Header_Summary_Default_Value = 200;
    
    public final static String TASK_RECORDTYPE_NAME = 'Campaign_Request';
    public final static String CN_REQUEST_RECORD_TYPE = 'Request_Notification';
    public final static String CN_REASSIGN_RECORD_TYPE = 'Campaign_Mbr_Reassignment';
    public final static Integer CAMPAIGN_MEMBER_LIST_LIMIT = 10000;
    public final static Integer SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT = 1000;
    public final static Integer SEARCH_CAMPAIGN_USERS_LIMIT = 1000;
    public final static Integer MAX_COLLECTION_LIMIT = 1000;
    
    public final static boolean IS_SEND_NOTIFICATION_MAIL = false;
    
    
    public final static String CampaignRequestRecordTypeException = 'No Record Type with Developer Name: Campaign_Request Exist';
    public final static String CommonException = 'Unable to perform the requested operation. If the issue persists, please contact your system administrator';
    public final static String SelectCampaignMemberException = 'Campaign Member record does not exist';
    public final static String SelectRequestException = 'Selected request does not exist';
    
    public final static String LoginExpiredException = 'Your current session has expired! Please login again to continue.';
    public final static String CampaignInActiveException = 'Selected Campaign is no longer active or does not exists';
    
    
    public final static String TaskStatuses = 'Pending;Completed;Rejected';
    public final static String TaskTypes = 'Call;Voicemail';
    
    public final static String CAMPAIGN_URL = '/apex/CamapignHomeComponentRedirect';

    public final static String betaFeedbackLink='http://gpshelp/';
    public final static String Beta_FeedbackLink = 'http://gpshelp/';
    
    public final static Date Delete_CN_Batch_Exec_Date = Date.Today() - 7;
    
    //03/30/2012 UV : Added this default source for Exception as source in batch log object  
    public final static String Default_Source_For_Exception = 'GPS-CAMPAIGNS';
    
      // Following Method Added by Aditya : Jira 4438 : to Improve Test class performance : To get Admin User
    public static List<User> getAdminUser(){
        //TestClassUtilities.setAllTriggerOn();
        //T1C_CustomSettingsManager.setAllTriggerOn();
        List<Profile> testUserProfile = [SELECT Id FROM Profile WHERE name='All MS Employee' ];
        User adminUser = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = testUserProfile[0].Id,                                 
                                 timezonesidkey = 'America/Los_Angeles', username = 'T'+String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','')+Integer.valueOf(math.rint(math.random()*1000000))+ '@morganstanley.com',
                                 Emp_Id__c = 'test1', isActive = true);
        insert adminUser;
        //List<User> testUsrList = [select id,Emp_Id__c,Alias,Email from user where ProfileID =:testUserProfile[0].ID and isActive = true and Id =: adminUser.Id]; 
        return new List<User>{adminUser};
    }
    
    //creating a temp user to use in the test classes
    public static User getTempUser(){
        
        Profile p = [SELECT Id FROM Profile WHERE name='All MS Employee'];
        UserRole r = [SELECT Id FROM UserRole WHERE name='Campaign User'];

        User tempUser = new User(alias = 'newUser', email='TU1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TU1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          UserRoleId = r.id ,Emp_Id__c = 'TMS_1');
        
        insert tempUser;
        
        return tempUser;        
   }
   
     public static void setCamapignLimitSettings() { 
       
	  /*******************************************************************
	  INSERTING OR UPDATING CUSTOM SETTINGS ORG DEFAULTS
	  ********************************************************************/
	 
	  CM_LIMIT_SETTINGS__c settings = CM_LIMIT_SETTINGS__c.getInstance();
        
        if(settings == null || settings.id == null) {
            settings = new CM_LIMIT_SETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
            settings.CBM_LIMIT__c = CBM_LIMIT;
            settings.Summary_Length__c = Summary_Length;
            settings.NO_OF_ATTACHMENTS__c = NO_OF_ATTACHMENTS;
            settings.Attachment_Name_Length__c = Attachment_Name_Length; 
            settings.Milestone_Description_Length__c = Milestone_Description_Length;
            settings.No_Campaigns_Error_Message__c = No_Campaigns_Error_Message;
            
            settings.SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT__c = SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT; 
            settings.SEARCH_CAMPAIGN_USERS_LIMIT__c = SEARCH_CAMPAIGN_USERS_LIMIT;
            settings.CAMPAIGN_MEMBER_LIST_LIMIT__c = CAMPAIGN_MEMBER_LIST_LIMIT;
            settings.MAX_COLLECTION_LIMIT__c = MAX_COLLECTION_LIMIT;
                        
            insert settings;
       }
       
       CM_GENERALSETTINGS__c cMGS = CM_GENERALSETTINGS__c.getInstance();
       if(cMGS == null || cMGS.id == null){
         cMGS = new CM_GENERALSETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
         cMGS.IS_SEND_NOTIFICATION_MAIL__c = IS_SEND_NOTIFICATION_MAIL;
         cMGS.TASK_RECORDTYPE_NAME__c = TASK_RECORDTYPE_NAME;
         cMGS.CN_REQUEST_RECORD_TYPE__c = CN_REQUEST_RECORD_TYPE;
         cMGS.CN_REASSIGN_RECORD_TYPE__c = CN_REASSIGN_RECORD_TYPE;
         cMGS.Task_Statuses__c = TaskStatuses;
         cMGS.Task_Types__c = TaskTypes;
         cMGS.CAMPAIGN_URL__c = CAMPAIGN_URL; 
         cMGS.Delete_CN_Batch_Exec_Date__c = Delete_CN_Batch_Exec_Date;
         // 02/01/2012  RJ: 
         //cMGS.GPSRedirect_URL__c = GPSRedirect_URL;
         //03/30/2012 UV : added this new field in custom setting
         cMGS.Default_Source_For_Exception__c = Default_Source_For_Exception;
         insert cMGS; 
       }
       
       CM_CUSTOM_MESSAGE_SETTINGS__c cCMS = CM_CUSTOM_MESSAGE_SETTINGS__c.getInstance();
       if(cCMS == null || cCMS.id == null){
         cCMS = new CM_CUSTOM_MESSAGE_SETTINGS__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
         cCMS.CampaignRequestRecordTypeException__c = CampaignRequestRecordTypeException;
         cCMS.CommonException__c = CommonException;
         cCMS.SelectCampaignMemberException__c = SelectCampaignMemberException;
         cCMS.SelectRequestException__c = SelectRequestException;
         cCMS.LoginExpiredException__c = LoginExpiredException;
         cCMS.CampaignInActiveException__c  = CampaignInActiveException;
         insert cCMS;
       }
       
       
       Common_EmailSettings__c emailSettings = Common_EmailSettings__c.getInstance();
       if(emailSettings == null || emailSettings.id == null){
         emailSettings = new Common_EmailSettings__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId());
         emailSettings.Campaigns_BetaFeedbackLink__c = Beta_FeedbackLink;
         insert emailSettings;
       }
       
	    GPSTrigger_Switch__c dSwitch = GPSTrigger_Switch__c.getInstance();
	    if(dSwitch != null && dSwitch.Id <> null) {
	      dSwitch.Is_CampaignRqstNotifyTrigger_On_Task__c = true;
	      update dSwitch;
	    } else {
	       dSwitch = new GPSTrigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getUserId() );
	       dSwitch.Is_CampaignRqstNotifyTrigger_On_Task__c = true;
	       insert dSwitch;
	    }
	    
	    Chatter_Settings__c chatterSet  =  Chatter_Settings__c.getInstance('Default');
	    if(chatterSet == null)
	    {
	    	chatterSet = new Chatter_Settings__c();
			chatterSet.Name = 'Default';
			chatterSet.Number_of_Days__c=2;
			chatterSet.Number_of_Private_Group_memberships__c=500;
			chatterSet.Allow_Chatter_Posts_and_Comments__c=true;
			chatterSet.Allow_Content_Post__c=false;
			chatterSet.Allow_Link_Post__c=false;
			chatterSet.Content_Post_Error_Message__c='You cannot insert Content Post at this time.';		
			chatterSet.Enable_Archiving__c=true;		
			chatterSet.Error_Message__c='You cannot insert new Chatter Posts or Comments at this time.';		
			chatterSet.Link_Post_Error_Message__c='You cannot insert new Chatter Posts or Comments at this time.';		
			insert chatterSet;
	    }	    
               
    }
    
    public  static Id getTaskRecordTypeId() {
        String recordTypeName = CM_CampaignDataUtil.getTaskRecordTypeName();
        RecordType rt = [select id from RecordType where DeveloperName = :recordTypeName];
        if(rt <> null) {
            return rt.Id;
        }
        return null;
   }
    
}