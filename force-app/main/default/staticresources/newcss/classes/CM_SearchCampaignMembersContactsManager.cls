// 10/01/2011 UV : ORIGINAL
//          Manager class that contains the bussiness logic on search Contacts for quick add
//
// 10/04/2011 RJ : Modified for showing all the contacts and with new properties to the wrapper
// 10/14/2011 RJ : Removed the insertion of campaignMemberAssignmentToBeAddedForCurrentUser now as the code is now moved to trigger
// 11/01/2011 RJ : Modifed getSearchCampaignMembersContacts method for performance enhancement. Modified line 38 - 59
// 02/24/2012 UV : Modified getSearchCampaignMembersContacts() method for "ON ANOTHER LIST ISSUE" [Jira story - 1526] (line# 37-39, 53-55, 63-67)
public without sharing class CM_SearchCampaignMembersContactsManager {
 
   // properties
   public String searchString{get;set;}
   public Id campaignId{get;set;} 
   public List<Id> contactIds{get;set;}
  
      
   public List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper> getSearchCampaignMembersContacts(){
      // Instance method to get the list of campaign members for current user 
      return CM_SearchCampaignMembersContactsManager.getSearchCampaignMembersContacts(campaignId, searchString);
   }// getSearchCampaignMembersContacts() 
     
   public CM_Campaigns_WS.addCampaignMembersforCurrentUserResult addCampaignMembersforCurrentUser(){
    // Instance method to add campaign members for current user using argument contactIds list     
      return  CM_SearchCampaignMembersContactsManager.addCampaignMembersforCurrentUser(campaignId, contactIds);
   }// end of  addCampaignMembersforCurrentUser()
   
    
   // BELOW WEBSERVICE STATIC METHODS
   // ---------------------------------------
   public static List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper> getSearchCampaignMembersContacts(Id campaignId, String searchString){
      List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper> contactWrapperList = new List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper>();
      Map<String, Campaign_Member_Assignment__c> campaignMemberAssignmentMap = new Map<String, Campaign_Member_Assignment__c>();
      Set<Id> existingMemberSet = new Set<Id>();
      List<Campaign_Member_Assignment__c> campaignMemberAssignmentList = new List<Campaign_Member_Assignment__c>();
      List<GPSContact__c> contactList = new List<GPSContact__c>();
      List<Id> contactIds = new List<Id>();
      
      // 2/24/2012 UV : updated the CM list to CMA list [Jira story 1526]
      //List<CampaignMember> cMList = new List<CampaignMember>();
      List<Campaign_Member_Assignment__c> cMAList = new List<Campaign_Member_Assignment__c>();
      
      // get the list of the contacts searched
      contactList = CM_CampaignDataUtil.getSearchContacts(searchString);
      
      // create a list of searched contacts
      for(GPSContact__c con: contactList){
        contactIds.add(con.Id);
      }
       
      // get searched contact assigments
      campaignMemberAssignmentList = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(campaignId, contactIds);
      // get searched contact campaign member 
      
      // 2/24/2012 UV : commented CM fetch and added CMA fetct for all other user except then current user [Jira story 1526]
      //cMList = CM_CampaignDataUtil.getCampaignMembersList(contactIds, campaignId);
      cMAList = CM_CampaignDataUtil.getCampaignMemberAssignmentforAllUserOtherThenCurrentUser(campaignId, contactIds);
      
      // create map user based
      for(Campaign_Member_Assignment__c cMA : campaignMemberAssignmentList) {
        campaignMemberAssignmentMap.put(cMA.GPSContact__c + ':' + cMA.Assigned_To__c, cMA);
      }
      
      // create set of campaign member contacts
      // 2/24/2012 UV : remove loop itration on CM and itrate the loop for CMA  [Jira story 1526]
      //for(CampaignMember cM : cMList){
      for(Campaign_Member_Assignment__c cMA : cMAList){	
        existingMemberSet.add(cMA.GPSContact__c);
      }
      
      // create list of campaign member contact wrapper object by contact object      
      for(GPSContact__c con: contactList){          
        boolean isCampaignMember = existingMemberSet.contains(con.Id);
        boolean isAssignedtoCurrentUser = campaignMemberAssignmentMap.containsKey(con.Id + ':' + UserInfo.getUserID());       
        contactWrapperList.add(new CM_Campaigns_WS.SearchCampaignMembersContactsWrapper(con, isCampaignMember, isAssignedtoCurrentUser));             
      }  
      
      return contactWrapperList;
   }//end of  getSearchCampaignMembersContacts(Id campaignId, String searchString)
   
  
   public static CM_Campaigns_WS.addCampaignMembersforCurrentUserResult addCampaignMembersforCurrentUser(Id campaignId, List<Id> contactIds){
      // Static method to add campaign members for current user using argument contactIds list     
      List<Campaign_Member__c> campaignMemberList = new List<Campaign_Member__c>();       
      List<Campaign_Member__c> existingCampMemberList = CM_CampaignDataUtil.getCampaignMembersList(contactIds, campaignId);
      Set<Id> existingContactIds = new Set<Id>();
      List<Campaign_Member_Assignment__c> campaignMemberAssignmentToBeAddedForCurrentUser = new List<Campaign_Member_Assignment__c>();
      List<CM_Campaigns_WS.CampaignMemberWrapper> campaignMemberWrapperList = new List<CM_Campaigns_WS.CampaignMemberWrapper>();
      String customMessage = '';
      // check if there is already a campaign member for a contact
      for(Campaign_Member__c cM : existingCampMemberList){
        existingContactIds.add(cM.GPSContact__r.Id);
      }
            
      for(String contactId : contactIds){
        // create a list of campaign members those does not exists in current campaign
        if(!existingContactIds.contains(contactId)){ 
          campaignMemberList.add(CM_CampaignDataUtil.getCampaignMemberInstance(contactId, campaignId));
        }else{
          // create list of campaign member assignment to be added if the contact is not in the list already as well as it is already a campaign member
          campaignMemberAssignmentToBeAddedForCurrentUser.add(CM_CampaignDataUtil.getCampaignMemberAssignmentInstance(false, campaignId, UserInfo.getUserID(), contactId, false));
        }
      }
      try{  
        if(campaignMemberList.size() > 0){
          insert campaignMemberList;          
        }
        
        if(campaignMemberAssignmentToBeAddedForCurrentUser.size() > 0){
          insert campaignMemberAssignmentToBeAddedForCurrentUser;
        }
        System.debug('______________campaignMemberList_______________' + campaignMemberList);
        campaignMemberWrapperList = CM_CampaignMemberManager.getSelectedCampaignMemberWrapper(campaignId, contactIds);      
          customMessage = (contactIds.size() + ' ' + (contactIds.size() > 1 ? 'Contacts' : 'Contact') + ' has been added. ');
      }catch(Exception ex){
        throw new CM_CustomException(CM_CampaignDataUtil.CommonException, 'addCampaignMembersforCurrentUser', ex.getMessage());   
      }
      
      CM_Campaigns_WS.addCampaignMembersforCurrentUserResult result = new CM_Campaigns_WS.addCampaignMembersforCurrentUserResult(customMessage,campaignMemberWrapperList);
      //return 
      return result;    
       
   }// end of addCampaignMembersforCurrentUser(Id campaignId, List<String> contactIds)    
    
   
}