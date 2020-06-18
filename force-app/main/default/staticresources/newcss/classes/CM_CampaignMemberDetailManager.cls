// 10/03/2011 RJ: ORIGINAL  
//                Manager class that contains the bussiness logic for campaign member detail functions           
//   
//
public without sharing class CM_CampaignMemberDetailManager {
	public Id campaignMemberId{get;set;}
	public String status{get;set;}
	
	public CM_Campaigns_WS.RequestandResponsePanelsDetail getRequestandResponsePanelsDetail(){
		// To get the details for a campaign member.
		return CM_CampaignMemberDetailManager.getRequestandResponsePanelsDetail(campaignMemberId);
	}// end of getRequestandResponsePanelsDetail()
	
  public CM_Campaigns_WS.CustomMessage updateCampaignMemberStatus(){
  	//Instance method to update status of campaign member 
  	return CM_CampaignMemberDetailManager.updateCampaignMemberStatus(campaignMemberId, status);
  }// end of updateCampaignMemberStatus(Id campaignMemberId, String status)


  public static CM_Campaigns_WS.RequestandResponsePanelsDetail getRequestandResponsePanelsDetail(Id campaignMemberId){
  	  // To get the details for a campaign member.
  	 Campaign_Member__c cM = CM_CampaignDataUtil.getSelectedCampaignMember(campaignMemberId);
  	  Task tsk = CM_CampaignDataUtil.getPendingRequests(cM.Campaign__c, cM.GPSContact__c);
  	return new CM_Campaigns_WS.RequestandResponsePanelsDetail(cM, tsk);
  	
  }// end  of getRequestandResponsePanelsDetail(Id campaignMemberId)

  public static CM_Campaigns_WS.CustomMessage updateCampaignMemberStatus(Id campaignMemberId, String status){
    //Static method to update the status of campaign member
    try{    
    	System.debug('campaignMemberId:' + campaignMemberId);
    	System.debug('Status:' + status); 
    	status = status.trim();
    	boolean hasResponded = false;
    	Id Campaignid = [SELECT Campaign__c FROM Campaign_Member__c where Id=:campaignMemberId].Campaign__c;
    	List<CampaignMemberStatus__c> lstCMS = [SELECT Id, HasResponded__c FROM CampaignMemberStatus__c WHERE Name = :status and Campaign__c =:Campaignid]; 
      	Campaign_Member__c cM = new Campaign_Member__c( Id = campaignMemberId, status__c = status, HasResponded__c = lstCMS[0].HasResponded__c);
      		
      update cM;
    }catch(Exception ex){    	
    	throw new CM_CustomException(CM_CampaignDataUtil.CommonException, 'updateCampaignMemberStatus', ex.getMessage());
    }    
    return new CM_Campaigns_WS.CustomMessage('Status has been updated'); 	
  }// end of updateCampaignMemberStatus(Id campaignMemberId, String status)
  
}