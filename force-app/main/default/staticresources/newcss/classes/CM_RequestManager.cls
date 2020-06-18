// 10/12/2011 UV : ORIGINAL
//					Manager class that contains the bussiness logic to create new request
//
// 10/22/2011 UV : Updated return type of createRequest()
// 10/18/2011 RJ : Updated createRequest method to parse the date string in yyyy-mm-dd format.
// 12/20/2011 RJ :  modified populateContactPhone method #92 - 95 (coverage 91%)
public without sharing class CM_RequestManager {
	
	 // properties
	 public String campaignId{get;set;}
	 public String contactId{get;set;}
	 public String Action{get;set;}
	 public String comments{get;set;}
	// public String relatedToSubject{get;set;}
	 public String dueDateString{get;set;}
	 public String assignedToUserId{get;set;}
	 public boolean isSpokenToContact{get;set;}
	 public String campaignMemberId{get;set;}
	 public String requestId{get;set;}//task Id
	 
	 public String Status{get;set;}
	 public String Feedback{get;set;}
	 
	 public CM_Campaigns_WS.Request createRequest() {
	 	//Instance method to create new request
	 	return CM_RequestManager.createRequest(contactId, Action, campaignId, assignedToUserId, comments, dueDateString, isSpokenToContact);
	 }// end of createrequest()
	   
	 public CM_Campaigns_WS.RequestWrapper getRequestDetail() {
	 	//Instance method to get the details of the request
	 	return CM_RequestManager.getRequestDetail(requestId);
	 	
	 }//end of getRequestDetail()
	 
	 public CM_Campaigns_WS.RequestWrapper getDefaultRequestDetail(){
	 	return CM_RequestManager.getDefaultRequestDetail(campaignMemberId);
	 }//end of getDefaultRequestDetail()
	 
	 public CM_Campaigns_WS.CustomMessage updateRequest() {
	 	//Instance method to get the update the request
	 	System.debug('UPDATE REQUEST:' + requestId + ':' + Status + ':' +  Feedback + ':' + assignedToUserId);
	 	return CM_RequestManager.updateRequest(requestId, Status, Feedback, assignedToUserId);
	 } //end of updateRequest()
	 
	 public CM_Campaigns_WS.CustomMessage cancelRequest() {
	 	//Instance method to cancel a request
	 	return CM_RequestManager.cancelRequest(requestId);
	 }//end of cancelRequest
	  
	 // BELOW WEBSERVICE STATIC METHODS
   // ---------------------------------------
   public static CM_Campaigns_WS.RequestWrapper getDefaultRequestDetail(String campaignMemberId){
   	  Campaign_Member__c cM = CM_CampaignDataUtil.getSelectedCampaignMember(campaignMemberId);   	  
   	  return new CM_Campaigns_WS.RequestWrapper(cM, CM_CampaignDataUtil.getCurrentUser());
   }
   
	 public static CM_Campaigns_WS.Request createRequest(String contactId, String Action, String campaignId, 
	 													String assignedToUserId, String comments, String dueDateString, boolean isSpokenToContact) {	 	  
		 	String message = '';		 	
		 	//10/18/2011 RJ: to parse the date string in yyyy-mm-dd format.
		 	Date dueDate = date.valueOf(dueDateString);
		 	Task newRequest = CM_CampaignDataUtil.getNewRequestInstance(contactId, Action, campaignId, assignedToUserId, comments, dueDate, isSpokenToContact);
		 	try {
		 		Database.DMLOptions dlo = new Database.DMLOptions();
	      dlo.EmailHeader.triggerUserEmail = CM_CampaignDataUtil.IS_SEND_NOTIFICATION_MAIL;  // this property will allow us to control the sending of email notification to assignee.
	    	database.insert(newRequest, dlo);
		 		message = 'The request is created.';
		 	}
		 	catch(Exception ex) {
		 		throw new CM_CustomException(CM_CampaignDataUtil.CommonException, 'createRequest', ex.getMessage()); 	 
		 	}
		 	
		 	CM_Campaigns_WS.RequestWrapper reqWrap = CM_RequestManager.getRequestDetail(newRequest.Id);
		 	CM_Campaigns_WS.IncomingRequestMemberWrapper iReqWrap = CM_IncomingRequestManager.getIncomingRequest(campaignId, newRequest.Id);		 	 
		  return new CM_Campaigns_WS.Request(reqWrap,new CM_Campaigns_WS.CustomMessage(message), iReqWrap);		  
	 }//end of createrequest(String contactId,String Action, String campaignId,.....)
	 
	public static CM_Campaigns_WS.RequestWrapper getRequestDetail(String requestId) {
		 	// static menthod to get the details of the request
		 	CM_Campaigns_WS.RequestWrapper requestWrapper;
		 	Set<Id> contactIds = new Set<Id>();
		 	List<Campaign_Member__c> lstCampMember = new List<Campaign_Member__c>();
		 	Task request = CM_CampaignDataUtil.getRequestDetail(requestId);	 	
		 	contactIds.add(request.GPS_Contact__c);	 	
		 	lstCampMember = CM_CampaignDataUtil.getCampaignMembersforCurrentUser(request.WhatId, contactIds);	 	
		 	if(request <> null && lstCampMember.size() > 0) {
		 		requestWrapper = new CM_Campaigns_WS.RequestWrapper(lstCampMember[0], request); 
		 	}	 	
		 	return requestWrapper;
	 }//end of getRequestDetail(String requestId)
	 
	 
	 public static List<CM_Campaigns_WS.PhoneNumber> populateContactPhone(Campaign_Member__c campM){	
	 	// populate contact phone 
   	    return CM_CampaignDataUtil.getContactPhoneList(campM.GPSContact__r);
   	 }
   
   
   public static CM_Campaigns_WS.CustomMessage updateRequest(Id TaskId, String Status, String Feedback, Id assignedToUser){
   	   System.debug('UPDATE REQUEST:' + TaskId + ':' + Status + ':' +  Feedback + ':' + assignedToUser);
	   	 String message = '';
	   	 Task request = CM_CampaignDataUtil.getRequestDetail(TaskId);
	   	 //update the fields in task
	   	 request.Status = Status;
	   	 request.Assignee_Feedback__c = Feedback;
	   	 request.OwnerId = assignedToUser;
	   	 System.debug('____BEFORE updated_______' + request);
	   	 System.debug('____updated OWNER_______' + assignedToUser);
	   	 try {
			Database.DMLOptions dlo = new Database.DMLOptions();
		    dlo.EmailHeader.triggerUserEmail = CM_CampaignDataUtil.IS_SEND_NOTIFICATION_MAIL;  // this property will allow us to control the sending of email notification to assignee.
		    database.update(request, dlo);
		    message = 'The request is updated.';
		}
		
		catch(Exception ex) {
			throw new CM_CustomException(CM_CampaignDataUtil.CommonException, 'updateRequest', ex.getMessage()); 	 
		}
		System.debug('____updated_______' + request);
		return new CM_Campaigns_WS.CustomMessage(message);
   }
   
   
   public static CM_Campaigns_WS.CustomMessage cancelRequest(Id requestId) {
      // This function is used to cancel the request from the flex ui.		
   		String message = '';
   		Task request = CM_CampaignDataUtil.getRequestDetail(requestId);
   		
   		 try {
   		 	//delete with DMLOprions doesnot exist
			  //Database.DMLOptions dlo = new Database.DMLOptions();
		    //dlo.EmailHeader.triggerUserEmail = CM_CampaignDataUtil.IS_SEND_NOTIFICATION_MAIL;  // this property will allow us to control the sending of email notification to assignee.
		    //database.delete(request, dlo); 
		    database.delete(request);
		    message = 'The request is deleted.';
		}
		catch(Exception ex) {
			throw new CM_CustomException(CM_CampaignDataUtil.CommonException, 'cancelRequest', ex.getMessage()); 	 
		}
		return new CM_Campaigns_WS.CustomMessage(message);
   }
}