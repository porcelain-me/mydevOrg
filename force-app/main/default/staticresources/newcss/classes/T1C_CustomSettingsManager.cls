// 08/06/2012 : MG : Created this class.
// 08/21/2012 : Added default query limits
// 08/23/2012 : Added rebuildRecommendationsPoolInterval property.
// 09/24/2012 : UV : added interestNotFoundMessage
// 12/17/2012 : MG : Added a new constant RECENT_ACTIVITY_BASE_URL (line# 30) (CRMGPS-3087)
//12/24/2012  UV : created  method createSettignsForT1C_FunctionalRolesForBroadcaster
// 01/17/2013 : MG : Created method createDefaultPreferencesCustomSettings()
// 20 Nov 2013 :    Dinesh M:   Inserted entry for Is_T1C_ContactCoverageAdditionalInfo_On__c and Is_T1C_TeamContactCoverage_Trigger_On__c
public class T1C_CustomSettingsManager {   
    // default values for all the custom settings
    // Module Access Control settings - default  
    public final static  boolean t1_Cubeface_InterestManagement = false; 
    public final static  boolean t1_Cubeface_RecentActivity = false;
    public final static  boolean t1_Cubeface_Recommendations = false;
    public final static  boolean t1_SmartEmail = false;  
    // session Expiration exception message - default
    public final static String sessionExpiredException = 'Your current session has expired! Please login again to continue.';
    public final static String interestNotFoundMessage = 'Selected interest has been deleted.';
    public final static String smartFilterSearchException = 'Please reduce number of topics';
    // query limits - default
    public static final Integer INTEREST_QUERY_LIMIT = 1000;
    public static final Integer MAX_LIMIT = 9999;
    public static final Integer MAX_LIMIT_UI = 999;
    public static final Integer MAX_COLLECTION_LIMIT = 999;
    public static final Integer TYPE_AHEAD_SEARCH_LIMIT = 5;
    public static final Integer QUICK_ADD_SEARCH_LIMIT = 10;
    public static final Integer rebuildRecommendationsPoolInterval = 3000;   
    public static final Integer Contact_Search_Limit = 5000; 
    public static final Integer Contact_Batch_Limit = 200; 
    public static final Integer HEAP_SIZE_BUFFER = 20000;
    public static final Integer SCRIPT_STATEMENT_BUFFER = 20000; 
    // 12/17/2012 : MG : Use Base URL for recent activity (CRMGPS-3087)
    public static final String RECENT_ACTIVITY_BASE_URL = 'https://dd865c2n1.ms.com:25138';
    public static final String LAUNCH_BROADCASTER_URL = 'http://crm-rtam-web-prod-na.ms.com/eqr/rtam/webapp/broadcaster.jsp';
    public static final Integer OVERRIDE_ATTRIBUTE_USER_BATCH_LIMIT = 75;
    public static final String OVERRIDE_ATTRIBUTE_USER_BATCH_EXCEPTION = 'Operation does not support batch update of more than 75 records, please reduce the batch size';
    public static final String LOGIN_AS_EXCEPTION = 'You are not authorized to use this functionality as there is not any user list view associated with your functional role in custom setting T1C_FunctionalRoleUserListViewMapping.';
    
    public static void setAllTriggerOn() { 
        // This method sets all values to true in Trigger_Switch__c setting
        GPSTrigger_Switch__c dSwitch = GPSTrigger_Switch__c.getInstance();
        if(dSwitch != null && dSwitch.Id != null) {
        	dSwitch.is_AccountSetTargetListMember_trigger_On__c = true; 
        	dSwitch.Is_AddDoNotSendToEmailAddress_Trigger_On__c = true;
        	dSwitch.Is_CampaignRqstNotifyTrigger_On_Task__c = true;
        	dSwitch.Is_CampFeedItemFeedback_Trigger_On__c = true;
        	dSwitch.Is_CMAssignManagement_Trigger_On__c = true;
        	dSwitch.Is_CMResponseManagement_Trigger_On__c = true;
        	dSwitch.Is_CTMManagement_Trigger_On__c = true;
        	dSwitch.Is_EmployeeTeamSharing_On__c = true;
        	dSwitch.Is_SetTargetListSendsEmail_Trigger_On__c = true;
        	dSwitch.Is_Set_TLM_EligibleForEmail_On__c = true;
        	dSwitch.Is_ContactLanguageSync_Trigger_On__c = true;
        	dSwitch.Is_SyncResearchTeamWithTeam_On__c = true;
        	dSwitch.Is_syncUserFromGPSEmp_Trigger_On__c = true;
        	dSwitch.Is_TrueVotesOnVote_Trigger_On__c = true;
        	dSwitch.Is_UpdateAllTargetMember_On__c = true;
        	dSwitch.Is_UpdateDListItemActiveFlag_Trigger_On__c = true;
        	dSwitch.Is_UpdateEmailEligibleByRemoveReason_On__c = true;
        	dSwitch.Is_UpdateTargetListMembersExclusion_On__c = true;
        	dSwitch.Is_ValdteCMSDplcateForCamp_Trigger_On__c = true;
        	
        	
            update dSwitch;
            
        } else {
            dSwitch = new GPSTrigger_Switch__c(Name = 'Default',SetupOwnerId=UserInfo.getOrganizationId() );
            dSwitch.is_AccountSetTargetListMember_trigger_On__c = true; 
            dSwitch.Is_AddDoNotSendToEmailAddress_Trigger_On__c = true;
            dSwitch.Is_CampaignRqstNotifyTrigger_On_Task__c = true;
            dSwitch.Is_CampFeedItemFeedback_Trigger_On__c = true;
            dSwitch.Is_CMAssignManagement_Trigger_On__c = true;
            dSwitch.Is_CMResponseManagement_Trigger_On__c = true;
            dSwitch.Is_CTMManagement_Trigger_On__c = true;
            dSwitch.Is_EmployeeTeamSharing_On__c = true;
            dSwitch.Is_SetTargetListSendsEmail_Trigger_On__c = true;
            dSwitch.Is_Set_TLM_EligibleForEmail_On__c = true;
            dSwitch.Is_ContactLanguageSync_Trigger_On__c = true;
            dSwitch.Is_SyncResearchTeamWithTeam_On__c = true;
            dSwitch.Is_syncUserFromGPSEmp_Trigger_On__c = true;
            dSwitch.Is_TrueVotesOnVote_Trigger_On__c = true;
            dSwitch.Is_UpdateAllTargetMember_On__c = true;
            dSwitch.Is_UpdateDListItemActiveFlag_Trigger_On__c = true;
            dSwitch.Is_UpdateEmailEligibleByRemoveReason_On__c = true;
            dSwitch.Is_UpdateTargetListMembersExclusion_On__c = true;
            dSwitch.Is_ValdteCMSDplcateForCamp_Trigger_On__c = true;
                             
            insert dSwitch;
        }
    }
    
    public static void createChatterSetting() {
        // this methods Chatter_Settings__c field Allow_Chatter_Posts_and_Comments__c to true.
        Chatter_Settings__c dSwitch2 = Chatter_Settings__c.getInstance('Default');
        if(dSwitch2 != null && dSwitch2.Id != null) {
            dSwitch2.Allow_Chatter_Posts_and_Comments__c = true;
            dSwitch2.Enable_Archiving__c = true ; // Added By Aditya Jira 4438 : To improve test class performance.
            dSwitch2.Allow_Chatter_Posts_and_Comments__c = true; // Added By Aditya Jira 4438 : To improve test class performance.
            update dSwitch2;
        }
        else {
            dSwitch2 = new Chatter_Settings__c();
            dSwitch2.Name = 'Default';
            dSwitch2.Allow_Chatter_Posts_and_Comments__c = true;
            dSwitch2.Enable_Archiving__c = true ; // Added By Aditya Jira 4438 : To improve test class performance.
            dSwitch2.Allow_Chatter_Posts_and_Comments__c = true; // Added By Aditya Jira 4438 : To improve test class performance.
            insert dSwitch2;
        }
    }
    
    public static void createPermissionsetsetting(){
    	
    	Map<String,string> permissions= new Map<string,string>{'Campaign_Admin' =>'GPS_Campaign_Admin__c',
    	
    															'GPS_Campaign_Permission_Set'=> 'GPS_Campaign__c',
    															
    															'IICampaign_Admin'	=>	'iiCampaign_Admin__c',
    															
    															'IICampaign_Permission_Set'	=> 'iiCampaign__c',
    															
    															'IIFanClub_Admin'=>	'iiFanclub_Admin__c',
    															
    															'IIFanClub_Permission_Set'=>'iiFanclub__c',
    															
    															'Login_As_Permission_Set'=>'Login_As__c'};
    	
    	List<Campaign_Permission_Sets__c> perms= Campaign_Permission_Sets__c.getAll().Values();
    	
    	List<PermissionSet> pma= new List<PermissionSet>();
    	
    	pma=[Select Id,Name from permissionset where Name in:permissions.keyset()];
    	
    	if(perms!=null && !perms.isEmpty()){
    		
    		integer i=0;
    		
    		for(permissionset tempP:pma){    			
    			    		
	    		perms[i].Name=tempP.Name;
	    		
	    		perms[i].Employee_Field_Api_Name__c=permissions.get(tempP.Name);
	    		
	    		perms[i].Permission_Set_Id__c=tempP.id;   			
    			
    			i++;
    		}
    		update perms;		
    		
    	}
    	
    	else{
    		
    		perms= new List<Campaign_Permission_Sets__c>();
    		    		
    		for(permissionset tempP:pma){ 
    			
    			Campaign_Permission_Sets__c csp=new Campaign_Permission_Sets__c();   			
    			    		
	    		csp.Name=tempP.Name;
	    		
	    		csp.Employee_Field_Api_Name__c=permissions.get(tempP.Name);
	    		
	    		csp.Permission_Set_Id__c=tempP.id;   			
    			
    			perms.add(csp);
    		}
    		
    		insert perms;
    		
    	}
    	
    	
    }
    
  
}