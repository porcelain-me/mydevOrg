// 10/03/2011 RJ: ORIGINAL  
//                Manager class that contains the bussiness logic on campaign member object for reassignment process                 
//  10/26/2011 PG: Added logic to insertinto Campaign_notification for no. of reassigned contacts.  
//
public without sharing class CM_CampaignMembersReassignmentManager {
   public Id campaignId{get;set;}
   public List<Id> contactIds{get;set;}
   public Id userId{get;set;}
   public String searchString{get;set;}
   
   public List<CM_Campaigns_WS.CampaignParticipantWrapper> searchCampaignParticipants(){
     // To search user object for get list of campaign participants.
     return CM_CampaignMembersReassignmentManager.searchCampaignParticipants(campaignId, searchString); 
   }// end of searchCampaignParticipants()
   
   public CM_Campaigns_WS.CustomMessage reassignMember(){
     // To reassign contact to campaign member object
     return CM_CampaignMembersReassignmentManager.reassignMember(campaignId, contactIds, userId); 
   }// end of reassignMember(Id campaignId, List<Id> contactIds)
   
   public static List<CM_Campaigns_WS.CampaignParticipantWrapper> searchCampaignParticipants(Id campaignId, String searchString){
     // To search user object for get list of campaign participants.     
     List<CM_Campaigns_WS.CampaignParticipantWrapper> campaignParticipantWrapperList = new List<CM_Campaigns_WS.CampaignParticipantWrapper>();       
     
    
     List<Campaign_Team_Member__c> cTMList = new List<Campaign_Team_Member__c>(); 
     
     
     cTMList = CM_CampaignDataUtil.searchCampaignParticipants(campaignId, searchString);
     
     for(Campaign_Team_Member__c cTM : cTMList) {
      if(cTM.User__r.Id <> Userinfo.getUserId()) {
        campaignParticipantWrapperList.add(new CM_Campaigns_WS.CampaignParticipantWrapper(cTM));
      }
     }        
     return campaignParticipantWrapperList;
    
     
    
        
   }// end of searchCampaignParticipants(campaignId)
   
   public static CM_Campaigns_WS.CustomMessage reassignMember(Id campaignId, List<Id> contactIds, Id userId){
     // To reassign contact to campaign member object
     
      //get the list of CMA of current user contacts and reassign CMA for current user to the selected user
     List<Campaign_Member_Assignment__c> campaignMemberAssignMentListToBeRemovedForCurrentUser = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(campaignId, contactIds);
     // get the list of selected user CMA for selected contactids and remove them
     List<Campaign_Member_Assignment__c> campaignMemberAssignMentListToBeRemovedForSelectedUser = CM_CampaignDataUtil.getCampaignMemberAssignmentforUser(campaignId, contactIds, userId);
     // get the list of selected user CMA for selected contactids and remove them
     List<Campaign_Member_Assignment__c> campaignMemberAssignMentListToBeInserted = new List<Campaign_Member_Assignment__c>();
     
     Set<Id> contactIdSet = new Set<Id>();
     // To remove duplicate contactids passign from flex controller.
     for(Id contactId : contactIds){
         if(!contactIdSet.contains(contactId)){  
         contactIdSet.add(contactId);
         }
     }
     
     for(Id contactId : contactIdSet){       
       Campaign_Member_Assignment__c cMA = CM_CampaignDataUtil.getCampaignMemberAssignmentInstance(false, campaignId, userId, contactId, true);       
       campaignMemberAssignMentListToBeInserted.add(cMA);       
     }
     
     System.debug('____________contactIds______________' + contactIds);
     System.debug('____________CURRENT USER ID______________' + UserInfo.getUserId());
     System.debug('____________Passed USER ID______________' + userId);
     try{
        
         if(campaignMemberAssignMentListToBeRemovedForCurrentUser.size() > 0){
             delete campaignMemberAssignMentListToBeRemovedForCurrentUser;
         }
         
         if(campaignMemberAssignMentListToBeRemovedForSelectedUser.size() > 0){
           delete campaignMemberAssignMentListToBeRemovedForSelectedUser;
       }
       
       if(campaignMemberAssignMentListToBeInserted.size() > 0){
         insert campaignMemberAssignMentListToBeInserted;
       }
         
     }catch(Exception ex){
         throw new CM_CustomException(CM_CampaignDataUtil.CommonException, 'reassignMember', ex.getMessage());
     }
     
  // call campaign_Notification manager to Insert no.of Reassigned Contacts to send an Email 
     If (contactIdSet.size() > 0 ){  
       CM_CampaignNotificationManager.insertCampaignNotificationOnMemReassignment(campaignId, userId, contactIdSet.size());
     }
     
     return new CM_Campaigns_WS.CustomMessage(contactIdSet.size() + ' ' + (contactIdSet.size() > 1 ? 'Contacts' : 'Contact') + ' has been reassigned. ');
   }// end of reassignMember(Id campaignId, List<Id> contactIds)
}