//
//09/29/2011 UV: ORIGINAL  
//                Manager class that contains the bussiness logic on Incoming Request tab data                  
//   
// 12/20/2011 RJ :  modified populateContactPhone method #75 - 78 (coverage 94%)
public class CM_IncomingRequestManager {
   // properties
   public Id campaignId{get;set;}
     public Id requestId{get;set;}
     
     public List<CM_Campaigns_WS.IncomingRequestMemberWrapper> getIncomingRequestsForCurrentUser(){
          // Instance method to list of incoming request members 
          List<CM_Campaigns_WS.IncomingRequestMemberWrapper> IncomingReqMemberList = new List<CM_Campaigns_WS.IncomingRequestMemberWrapper>();
          IncomingReqMemberList = CM_IncomingRequestManager.getIncomingRequestsForCurrentUser(campaignId);
          
          return IncomingReqMemberList;
     }// end of getIncomingRequestsForCurrentUser
     
     
     public CM_Campaigns_WS.IncomingRequestMemberWrapper getIncomingRequest(){
      // Instance method to get incoming request of selected request id and campaign Id
      return CM_IncomingRequestManager.getIncomingRequest(campaignId, requestId);
   }// end of getIncomingRequestsForCurrentUser
   
   
    
   public static List<CM_Campaigns_WS.IncomingRequestMemberWrapper> getIncomingRequestsForCurrentUser(Id campaignId){
      // overloaded, static method to get the list of incoming request members in wrapper pattern for current user.
      Set<id> contactIds = new Set<Id>();
      Map<Id,GPSContact__c> ContactMap = new Map<Id,GPSContact__c>();
      List<CM_Campaigns_WS.IncomingRequestMemberWrapper> IncomingReqMemberList = new List<CM_Campaigns_WS.IncomingRequestMemberWrapper>();
      List<Task> taskList = new List<Task>();
      
      taskList = CM_CampaignDataUtil.getIncomingRequestsForCurrentUser(campaignId);
      for(Task tsk : taskList) {
        contactIds.add(tsk.GPS_Contact__c);
      }
      // getting contact map with all details of contact 
      contactMap = CM_CampaignDataUtil.getContactMap(contactIds, campaignId);
       // create list of incoming request member wrapper 
      for(Task tsk : taskList) {
        GPSContact__c tskContact = contactMap.get(tsk.GPS_Contact__c);
      
        IncomingReqMemberList.add(new CM_Campaigns_WS.IncomingRequestMemberWrapper(tsk, tskContact));
      }
      if(IncomingReqMemberList.size() > 0) {
        return IncomingReqMemberList;
      }
      return null; 
   }// end of getIncomingRequestsForCurrentUser(Id campaignId)
  
   public static CM_Campaigns_WS.IncomingRequestMemberWrapper getIncomingRequest(Id campaignId, Id requestId){
      // overloaded, static method to get incoming request of selected request id and campaign Id
      Set<Id> contactIds = new Set<Id>();
      Map<Id,GPSContact__c> ContactMap = new Map<Id,GPSContact__c>();
      List<CM_Campaigns_WS.IncomingRequestMemberWrapper> IncomingReqMemberList = new List<CM_Campaigns_WS.IncomingRequestMemberWrapper>();
      List<Task> taskList = new List<Task>();
      
      taskList = CM_CampaignDataUtil.getIncomingRequestsForCurrentUser(campaignId, requestId);
      
      for(Task tsk : taskList) {
        contactIds.add(tsk.GPS_Contact__c);
      }
      // getting contact map with all details of contact 
      contactMap = CM_CampaignDataUtil.getContactMap(contactIds, campaignId);
      
      // if request doesnot exist return null otherwise return created incoming request.  
      for(Task tsk : taskList) {
        GPSContact__c tskContact = contactMap.get(tsk.GPS_Contact__c);
        return new CM_Campaigns_WS.IncomingRequestMemberWrapper(tsk, tskContact);
      }      
      return null; 
   }// end of getIncomingRequestsForCurrentUser(Id campaignId)
    
   public static List<CM_Campaigns_WS.PhoneNumber> populateContactPhone(GPSContact__c contactMember){ 
        // populate contact phone 
        
       return CM_CampaignDataUtil.getContactPhoneList(contactMember);
    }// end of populateContactPhone  
     
}