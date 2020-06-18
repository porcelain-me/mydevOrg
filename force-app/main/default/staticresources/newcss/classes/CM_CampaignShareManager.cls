//  
//  10/14/2011 RJ: ORIGINAL 
//                 Manager class for CampaignTeamMemberManagement.trigger for manipulation of Campaign Share object  
//
//03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
public class CM_CampaignShareManager {	
	private final static integer	DBINSERT = 0;
	private final static integer DBUPDATE = 1;
	private final static integer DBDELETE = 2;
    
	
		
  public static void insertCampaignShareRecords(List<Campaign_Team_Member__c> insertedCampaignTeamMembers){
  	// To insert campaign share record respectively for all inserted CTMs
  	CM_CampaignShareManager.populateCampaignShareRecords(insertedCampaignTeamMembers, DBINSERT);	  
  }// end of insertCampaignShareRecords(List<Campaign_Team_Member__c> insertedCampaignTeamMembers)
  
  
  public static void updateCampaignShareRecords(Map<Id, Campaign_Team_Member__c> oldCampaignTeamMembersMap, Map<Id, Campaign_Team_Member__c> updatedCampaignTeamMembersMap){
     // To update campaign share records only when there is any update to Campaign Access Level.
     List<Campaign_Team_Member__c> updatedCampaignTeamMembers = new List<Campaign_Team_Member__c>();
     
     for(Campaign_Team_Member__c cTM : updatedCampaignTeamMembersMap.values()){
         if(cTM.Campaign_Access_Level__c <> oldCampaignTeamMembersMap.get(cTM.id).Campaign_Access_Level__c){
         	  updatedCampaignTeamMembers.add(cTM);         	           	  
         }	  	 
     }     
     CM_CampaignShareManager.populateCampaignShareRecords(updatedCampaignTeamMembers, DBUPDATE);  
  }//end of updateCampaignShareRecords(Map<Id, Campaign_Team_Member__c> oldCampaignTeamMembersMap, Map<Id, Campaign_Team_Member__c> updatedCampaignTeamMembersMap)
  
  
  
  private static void populateCampaignShareRecords(List<Campaign_Team_Member__c> campaignTeamMembers, Integer typeOfAction){
  	 Set<Id> userIds = new Set<Id>();
     Set<Id> campaignIds = new Set<Id>();
     Map<Id, String> accessLevelMap = new Map<Id, String>();
     //03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
     /*List<CampaignShare> campaignShareToInsert = new List<CampaignShare>();
     List<CampaignShare> campaignShareToUpdate = new List<CampaignShare>();
     List<CampaignShare> campaignShareToDelete = new List<CampaignShare>();*/
     List<Campaign__Share> campaignShareToInsert = new List<Campaign__Share>();
     List<Campaign__Share> campaignShareToUpdate = new List<Campaign__Share>();
     List<Campaign__Share> campaignShareToDelete = new List<Campaign__Share>();
     //Map<String, CampaignShare> campaignShareMap = new Map<String, CampaignShare>();
     Map<String, Campaign__Share> campaignShareMap = new Map<String, Campaign__Share>();
     List<Campaign_Team_Member__c> lstCTM = new  List<Campaign_Team_Member__c>();
     //List<CampaignShare> lstCampShare = new List<CampaignShare>();
     
     List<Campaign__Share> lstCampShare = new List<Campaign__Share>();
     
     if(campaignTeamMembers.size() > 0){        
        for(Campaign_Team_Member__c cTM : campaignTeamMembers){
        	if(!userIds.contains(cTM.User__c)){
            userIds.add(cTM.User__c);
        	}
        	if(!campaignIds.contains(cTM.Campaign__c)){
        		campaignIds.add(cTM.Campaign__c);
        	}
        }
         
        //get the list of inserted/updated/deleted/undeleted campaign team members
        lstCTM = CM_CampaignDataUtil.getCampaignTeamMemberList(userIds, campaignIds);
        //get the list of all campaign share records for userIds and campaignIds
        lstCampShare = CM_CampaignDataUtil.getManualCampaignShareList(userIds, campaignIds);        
        // create a map of campaign share record(manually shared) with unique composite keys with campaignId and userId
        //03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
                
        //for(CampaignShare cS : lstCampShare){
        for(Campaign__Share cS : lstCampShare){
          //campaignShareMap.put(cS.CampaignId + '|' + cS.UserOrGroupId, cS);
          
          campaignShareMap.put(cS.ParentId + '|' + cS.UserOrGroupId, cS);
        }
        // prepare a map of user with its highest access level
        for(Campaign_Team_Member__c cTM : lstCTM){
           if(!accessLevelMap.containsKey(cTM.User__c)){    
             accessLevelMap.put(cTM.User__c, cTM.Campaign_Access_Level__c);
             System.debug('ACCESS LEVEL:' + accessLevelMap.get(cTM.User__c));
           }
        }
        // iterate manipulated campaign team members
        for(Campaign_Team_Member__c cTM : campaignTeamMembers){
        	//check if Force_Create_Sharing__c is enable or not for this share record
         
	          if(campaignShareMap.containsKey(cTM.Campaign__c + '|' + cTM.User__c)){
	          	if(accessLevelMap.get(cTM.User__c) <> null){
	          	//03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
	              //CampaignShare cS = campaignShareMap.get(cTM.Campaign__c + '|' + cTM.User__c);
	              Campaign__Share cS = campaignShareMap.get(cTM.Campaign__c + '|' + cTM.User__c);
	              // RIGHT NOW WE CAN ONLY SET ALL AS EDIT IN CAMPAIGN SHARE RECORDS AS ALL ACCESS CAN ONLY BE GIVEN USING MANAGED SHARING
	              //03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
	              //cS.CampaignAccessLevel = accessLevelMap.get(cTM.User__c) == 'All' ? 'Edit' : accessLevelMap.get(cTM.User__c);
	              cS.AccessLevel = accessLevelMap.get(cTM.User__c) == 'All' ? 'Edit' : accessLevelMap.get(cTM.User__c);
	              campaignShareToUpdate.add(cS);            
	          	}else if(typeofAction == DBDELETE && accessLevelMap.get(cTM.User__c) == null){
	          		////03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
	          		//CampaignShare cS = campaignShareMap.get(cTM.Campaign__c + '|' + cTM.User__c);
	          		Campaign__Share cS = campaignShareMap.get(cTM.Campaign__c + '|' + cTM.User__c);
	          		campaignShareToDelete.add(cS);
	          	}
	          }else{
	          	if(typeOfAction == DBINSERT){
	          		// RIGHT NOW WE CAN ONLY SET ALL AS EDIT IN CAMPAIGN SHARE RECORDS AS ALL ACCESS CAN ONLY BE GIVEN USING MANAGED SHARING
	              campaignShareToInsert.add(CM_CampaignDataUtil.getCampaignShareInstance(cTM.User__c, cTM.Campaign__c, accessLevelMap.get(cTM.User__c) == 'All' ? 'Edit' : accessLevelMap.get(cTM.User__c)));
	          	}           
	          }
          }
        
        if(campaignShareToInsert.size() > 0 && typeOfAction == DBINSERT){
          Database.SaveResult[] lsr = database.insert(campaignShareToInsert, false);
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to insert campaign share record due to following exception:' + err.getMessage());                
            }            
          } 
        }               
        if(campaignShareToUpdate.size() > 0){
          Database.Saveresult[] lsr = database.update(campaignShareToUpdate, false);
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to update campaign share record due to following exception:' + err.getMessage());                
            }            
          }
        }
        
        if(campaignShareToDelete.size() > 0 && typeofAction == DBDELETE){
          Database.DeleteResult[] ldR = database.delete(campaignShareToDelete, false);
          // Process the delete results
          for(Database.DeleteResult dr : ldR){
            if(!dr.isSuccess()){
                Database.Error err = dr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to delete campaign share record due to following exception:' + err.getMessage());                
            }            
          }
        }        
     }
  }
  
  
  public static void deleteCampaignShareRecords(List<Campaign_Team_Member__c> deletedCampaignTeamMembers){
  	 // TO Delete all the campaign share record associated with the deleted CTMS
     CM_CampaignShareManager.populateCampaignShareRecords(deletedCampaignTeamMembers, DBDELETE); 
  }// end of deleteCampaignShareRecords(List<Campaign_Team_Member__c> deletedCampaignTeamMembers)
  
  public static void undeleteCampaignShareRecords(List<Campaign_Team_Member__c> undeletedCampaignTeamMembers){
  	 // To undelete campaign share record when ctm is undeleted.  	 
  	 CM_CampaignShareManager.populateCampaignShareRecords(undeletedCampaignTeamMembers, DBINSERT); 
  }// end of undeleteCampaignShareRecords(List<Campaign_Team_Member__c> undeletedCampaignTeamMembers)
  
}