/*
*  Autor : Chetan Garg
*  Created On: Nov 29, 2010
*  Purpose : Create Test Data and Test Custom Settings
*  Modified : 
*           4/4/2012    ParthT  Added Method createPurgeSetting()
*                               Updated Method setAllTriggerOn(). 
*                               Added Missing options Is_ArchiveCampaignUpdates_Trigger_On__c,  Is_InterestUpdate_Trigger_On__c, Is_CDMUpdate_Trigger_On__c 
*/
@isTest(SeeAllData=false)
public class TestClassUtilities {
  
	   public static void setAllTriggerOn() { 
			GPSTrigger_Switch__c dSwitch = GPSTrigger_Switch__c.getInstance();             
			if(dSwitch != null && dSwitch.id <> NULL) {
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
			//dSwitch.Is_SyncGPSEmployee_trigger_On__c = true;
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
			//dSwitch.Is_SyncGPSEmployee_trigger_On__c = true;
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


	  //MyiiListAdminProfiles__c
	   // Name = 'System Administrator'
	   // MyiiList_Admin_Profile__c = 'System Administrator'
	   public static void createMyiiListAdminProfiles(){
		 MyiiListAdminProfiles__c adminProfile =  MyiiListAdminProfiles__c.getInstance('System Administrator');
		 if(adminProfile == null || adminProfile.id == null){
			adminProfile = new MyiiListAdminProfiles__c(Name='System Administrator', MyiiList_Admin_Profile__c = 'System Administrator');
			insert adminProfile;
		 }
		 else{
			adminProfile.MyiiList_Admin_Profile__c = 'System Administrator' ;
			update adminProfile;
		 }
	   }
   
    }