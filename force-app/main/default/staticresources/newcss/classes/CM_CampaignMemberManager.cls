// 09/28/2011 RJ: ORIGINAL  
//                Manager class that contains the bussiness logic on campaign member object                  
//   
// 11/10/2011 UV :  modified methods getSelectedCampaignMemberWrapper() and getCampaignMembersforCurrentUser() 
//					modified to add the reassigned user name (line #65-80, #113-127)  
// 12/20/2011 RJ :  modified populateContactPhone method #132 - 135 (coverage 89%)
// 					
public without sharing class CM_CampaignMemberManager {
	 // properties
	 public Id campaignId{get;set;}
	 public List<Id> contactIds{get;set;}   
	 public String campaignMemberId{get;set;}
	  
   public List<CM_Campaigns_WS.CampaignMemberWrapper> getCampaignMembersforCurrentUser(){
   	  // Instance method to get the list of campaign members for current user 
      List<CM_Campaigns_WS.CampaignMemberWrapper> campaignMemberList  = CM_CampaignMemberManager.getCampaignMembersforCurrentUser(campaignId); 
      return campaignMemberList;
   }// getCampaignMembersforCurrentUser()
   
   public CM_Campaigns_WS.CustomMessage removeCampaignMembersforCurrentUser(){
      // Instance method to remove campaign members for current user using argument campaigMemberIds list
      return CM_CampaignMemberManager.removeCampaignMembersforCurrentUser(campaignId, contactIds); 
   }// end of removeCampaignMembersforCurrentUser(Id campaignId, List<Id> campaignMemberIds)   
   
   
   public List<CM_Campaigns_WS.CampaignMemberWrapper> getSelectedCampaignMemberWrapper(){
   	  // Instance method to get list of selected campaign members on contactids.
  	  return CM_CampaignMemberManager.getSelectedCampaignMemberWrapper(campaignId, contactIds);
   }// end of getSelectedCampaignMemberWrapper()
   
   
   public CM_Campaigns_WS.CampaignMemberWrapper getCampaignMemberDetail(){
   	// Instance method to get selected campaign member wrapper on campaignMember id.
   	  return CM_CampaignMemberManager.getCampaignMemberDetail(campaignMemberId);
   }// end of getCampaignMemberDetail
   
   
   public static List<CM_Campaigns_WS.CampaignMemberWrapper> getCampaignMembersforCurrentUser(Id campaignId){
   	  // overloaded, static method to get the list of campaign members in wrapper pattern for current user.    	
   	  Map<Id, Task> requestStatusMap = new Map<Id, Task>();
   	  Map<Id, Campaign_Member_Assignment__c> campaignMemberAssignmentMap = new Map<Id, Campaign_Member_Assignment__c>();
      Set<Id> contactIds = new Set<Id>();
      List<Campaign_Member__c> campaignMemberList  = new List<Campaign_Member__c>();
      List<Campaign_Member_Assignment__c> cMAList = new List<Campaign_Member_Assignment__c>();      
      List<CM_Campaigns_WS.CampaignMemberWrapper> campaignMemberWrapperList = new List<CM_Campaigns_WS.CampaignMemberWrapper>();
      
      cMAList = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(campaignId);
      
      // create set of contactids and map of assignment members
      for(Campaign_Member_Assignment__c cMA : cMAList){
      	contactIds.add(cMA.GPSContact__c);  
      	campaignMemberAssignmentMap.put(cMA.GPSContact__c, cMA); 
      }
   
      // get campaign meber list for current user and for current campaign
      campaignMemberList  = CM_CampaignDataUtil.getCampaignMembersforCurrentUser(campaignId, contactIds);
      
      // get the map of contactid and status
      requestStatusMap = CM_CampaignDataUtil.getCampaignMemberStatus(campaignId, contactIds);
      
      
      
      // create list of campaign member wrapper obect by campaign member object            
      for(Campaign_Member__c cM: campaignMemberList){
      	 boolean assignedByCampaignAdmin = campaignMemberAssignmentMap.containsKey(cM.GPSContact__r.Id) ? campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Assigned_by_Admin__c : false;
         boolean reassigned = campaignMemberAssignmentMap.containsKey(cM.GPSContact__r.Id) ? campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned__c : false;
         // UV : added to get the name of reassigned user         
         String reassignedUserName = '';
         if(campaignMemberAssignmentMap.containsKey(cM.GPSContact__r.Id) && campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__c <> null) {
           reassignedUserName = campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.LastName != null ? campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.LastName : '';
           reassignedUserName += campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.Preferred_Name__c != null ? ', ' + campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.Preferred_Name__c : '';
         }
                 
         campaignMemberWrapperList.add(new CM_Campaigns_WS.CampaignMemberWrapper(
            cM, 
            requestStatusMap.get(cM.GPSContact__r.Id),
            assignedByCampaignAdmin,
            reassigned,
            reassignedUserName
            ));       
                
      }  
   	  
   	  return campaignMemberWrapperList;
   }// getCampaignMembersforCurrentUser(Id campaignId)
   
   
   public static List<CM_Campaigns_WS.CampaignMemberWrapper> getSelectedCampaignMemberWrapper(Id campaignId,List<Id> contactIds){
    	// overloaded, static method to get the list of campaign members on contactids only    	
   	  Map<Id, Task> requestStatusMap = new Map<Id, Task>();
   	  Map<Id, Campaign_Member_Assignment__c> campaignMemberAssignmentMap = new Map<Id, Campaign_Member_Assignment__c>();      
      List<Campaign_Member__c> campaignMemberList  = new List<Campaign_Member__c>();
      List<Campaign_Member_Assignment__c> cMAList = new List<Campaign_Member_Assignment__c>();      
      List<CM_Campaigns_WS.CampaignMemberWrapper> campaignMemberWrapperList = new List<CM_Campaigns_WS.CampaignMemberWrapper>();
      Set<Id> contactIdsSet = new Set<Id>();
      contactIdsSet.addAll(contactIds);
           
      // get campaign meber list for current user and for current campaign
      campaignMemberList  = CM_CampaignDataUtil.getCampaignMembersforCurrentUser(campaignId, contactIdsSet);
      
      cMAList = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(campaignId, contactIds);
      
      for(Campaign_Member_Assignment__c cMA : cMAList){
      	campaignMemberAssignmentMap.put(cMA.GPSContact__c, cMA); 
      }
           
      // get the map of contactid and status
      requestStatusMap = CM_CampaignDataUtil.getCampaignMemberStatus(campaignId, contactIdsSet);
       system.debug('requestStatusMap='+requestStatusMap.size());
       system.debug('requestStatusMap='+requestStatusMap);
      // create list of campaign member wrapper obect by campaign member object            
      for(Campaign_Member__c cM: campaignMemberList){
      	 boolean assignedByCampaignAdmin = campaignMemberAssignmentMap.containsKey(cM.GPSContact__r.Id) ? campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Assigned_by_Admin__c : false;
         boolean reassigned = campaignMemberAssignmentMap.containsKey(cM.GPSContact__r.Id) ? campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned__c : false;
     	   // UV : added to get the name of reassigned user     	 
         String reassignedUserName = '';
         if(campaignMemberAssignmentMap.containsKey(cM.GPSContact__r.Id) && campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__c <> null) {
           reassignedUserName = campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.LastName != null ? campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.LastName : '';
           reassignedUserName += campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.Preferred_Name__c != null ? ', ' + campaignMemberAssignmentMap.get(cM.GPSContact__r.Id).Reassigned_By__r.Preferred_Name__c : '';
         }
         system.debug('initializingcampaignMemberWrapperList');   
         campaignMemberWrapperList.add(new CM_Campaigns_WS.CampaignMemberWrapper(
            cM, 
            requestStatusMap.get(cM.GPSContact__r.Id),
            assignedByCampaignAdmin,
            reassigned,
            reassignedUserName
            ));
                     
      }  
   	  return campaignMemberWrapperList;
   }// getSelectedCampaignMemberWrapper(Id campaignId,List<Id> contactIds)
   
   public static List<CM_Campaigns_WS.PhoneNumber> populateContactPhone(Campaign_Member__c campM){
   	// populate contact phone 
   	
   	system.debug('populateContactPhone');
   	    return CM_CampaignDataUtil.getContactPhoneList(campM.GPSContact__r);
   	    //return null;
   }// end of populateContactPhone
   
   
   public static CM_Campaigns_WS.CustomMessage removeCampaignMembersforCurrentUser(Id campaignId, List<Id> contactIds){
      // static method to remove campaign members for current user using argument campaigMemberIds list
      List<Campaign_Member_Assignment__c> campaignMemberAssignmentList = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(campaignId, contactIds);
      Integer LIST_SIZE = campaignMemberAssignmentList.size();
      try{
        if(campaignMemberAssignmentList.size() > 0){
          delete campaignMemberAssignmentList;
        }
      }catch(Exception ex){
        throw new CM_CustomException(CM_CampaignDataUtil.CommonException, 'removeCampaignMembersforCurrentUser', ex.getMessage());
      }
      return new CM_Campaigns_WS.CustomMessage(LIST_SIZE + ' ' + (LIST_SIZE > 1 ? 'Contacts' : 'Contact') + ' has been removed. ');
   }// end of removeCampaignMembersforCurrentUser(Id campaignId, List<Id> campaignMemberIds)
   
   
   public static CM_Campaigns_WS.CampaignMemberWrapper getCampaignMemberDetail(String campaignMemberId) {
   		// this method is used to get the details of the CM
   		//campaignMemberId - Campaign Member`s Id
   		Id campaignId;
   		List<Id> contactIds = new List<Id>();
   		List<CM_Campaigns_WS.CampaignMemberWrapper> CMWrapList = new List<CM_Campaigns_WS.CampaignMemberWrapper>();
   		
   		Campaign_Member__c cm = CM_CampaignDataUtil.getCampaignMemberDetail(campaignMemberId);
   		campaignId = cm.Campaign__c;
   		contactIds.add(cm.GPSContact__r.Id);
   		CMWrapList = CM_CampaignMemberManager.getSelectedCampaignMemberWrapper(campaignId, contactIds);
   		if(CMWrapList.size() > 0) {
   			return CMWrapList[0];
   		}	
   		return null;
   }//end of getCampaignMemberDetail(String campaignMemberId)
   
   
}