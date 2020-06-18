//  
//  10/11/2011 RJ: ORIGINAL 
//                 Manager class for CampaignMemberAssignmentManagement.trigger  for manipulating cTMs
// 12/27/2011 UV : added insertDuplicateCampaignMemberTeamMembers() for insert duplicate CMs and team Member by the data loader page
// SPRINT 42     : Coverage(92%)
public class CM_CampaignTeamMemberManager {
    private final static String All = 'All';      
	 private final static String Edit = 'Edit';
	 private final static String Read = 'Read';   
	 
   private static String getHigherAccessLevel(Campaign_Member__c cM1, Campaign_Team_Member__c cM2){
   	 // To get higher access level available for a ctm to set
     if(cM1.System_Campaign_Team_Member_Access_Level__c == All || cM2.Campaign_Access_Level__c == All){
       return All;
     }
     
     if(cM1.System_Campaign_Team_Member_Access_Level__c == Edit || cM2.Campaign_Access_Level__c == Edit){
       return Edit;
     }
     
     if(cM1.System_Campaign_Team_Member_Access_Level__c == Read || cM2.Campaign_Access_Level__c == Read){
       return Read;
     }
     
     return All;
   }// end of getHigherAccessLevel(CampaignMember cM1, Campaign_Team_Member__c cM2)
   
   
   private static void sortCampaignMemberListOnAccessLevelDesc(List<Campaign_Member__c> cMList){
   	   // sort campaign member list in memory (required to get the highest level of access CTM as the first item in the list)
       for(Integer index =0 ;index<cMList.size();index++){
        for(Integer nextIndex = index+1; nextIndex < cMList.size();nextIndex++){           
             if(cMList[index].System_Campaign_Team_Member_Access_Level__c > cMList[nextIndex].System_Campaign_Team_Member_Access_Level__c){ 
                Campaign_Member__c tmp = cMList[index];   
                cMList.set(index,cMList[nextIndex]);
                cMList.set(nextIndex,tmp);
             }            
         }         
       }
   }// end of sortCampaignMemberListOnAccessLevelDesc(List<CampaignMember> cMList)
   
   
   public static void insertCampaignTeamMembers(List<Campaign_Member__c> insertedCampaignMembers){
      // This function is used to insert CMT records forcefully when CM is inserted      
      List<Campaign_Team_Member__c> cTMListToInsert = new List<Campaign_Team_Member__c>();
      List<Campaign_Team_Member__c> cTMListToUpdate = new List<Campaign_Team_Member__c>();
      Map<String, Campaign_Team_Member__c> existingCTMMap = new Map<String, Campaign_Team_Member__c>();      
      Map<String, List<Campaign_Member__c>> insertedCampaignMemberMap = new Map<String, List<Campaign_Member__c>>();
      Set<Id> userIds = new Set<Id>();
      Set<Id> campaignIds = new Set<Id>();
      
      if(insertedCampaignMembers.size() > 0){
      	// get the set of userIds and campaignIds
      	for(Campaign_Member__c cM : insertedCampaignMembers){
      		if(cM.Force_Create_CTM__c == true && (cM.System_Campaign_Team_Member_Access_Level__c   <> null || cM.System_Campaign_Team_Member_Access_Level__c   <> '') && cM.System_Assigned_To__c <> null && (cM.System_Campaign_Team_Member_Role__c <> null || cM.System_Campaign_Team_Member_Role__c <> '')){
      	    if(!userIds.contains(cM.System_Assigned_To__c)){
      	    	userIds.add(cM.System_Assigned_To__c);
      	    }
      	    
      	    if(!campaignIds.contains(cM.Campaign__c)){
      	    	campaignIds.add(cM.Campaign__c);
      	    }
      	    
      	                         
	          if(!insertedCampaignMemberMap.containsKey(cM.Campaign__c + '|' + cM.System_Assigned_To__c + '|' + cM.System_Campaign_Team_Member_Role__c)){
	            List<Campaign_Member__c> cmList = new List<Campaign_Member__c>();
	            cmList.add(cM);
	            insertedCampaignMemberMap.put(cM.Campaign__c + '|' + cM.System_Assigned_To__c + '|' + cM.System_Campaign_Team_Member_Role__c, cmList);
	          }else{
	            List<Campaign_Member__c> cMemberList = insertedCampaignMemberMap.get(cM.Campaign__c + '|' + cM.System_Assigned_To__c + '|' + cM.System_Campaign_Team_Member_Role__c);
	            cMemberList.add(cM);    
	          }            
	          	
      		}
      	} 
      	// create a map of existing ctms in db for current userids and campaignids
      	if(userIds.size() > 0){
      		List<Campaign_Team_Member__c> lstExistingCTM = CM_CampaignDataUtil.getCampaignTeamMemberList(userIds, campaignIds); 
      		for(Campaign_Team_Member__c cTM : lstExistingCTM){      			
      			existingCTMMap.put(cTM.Campaign__c + '|' + cTM.User__c + '|' + cTM.Role__c, cTM);
      		}
      	}
      	
      	
        // create a list of cTM to insert and update
        for(String key : insertedCampaignMemberMap.keySet()){
        	 
        	 List<Campaign_Member__c> cMList = insertedCampaignMemberMap.get(key);
        	 
        	 sortCampaignMemberListOnAccessLevelDesc(cMList); 
        	 Campaign_Member__c cM = cMList[0];  
        	 System.debug('ME IN' + cM.System_Campaign_Team_Member_Access_Level__c);
        	 if(!existingCTMMap.containsKey(cM.Campaign__c + '|' + cM.System_Assigned_To__c + '|' + cM.System_Campaign_Team_Member_Role__c)){
             cTMListToInsert.add(CM_CampaignDataUtil.getCampaignTeamMemberInstance(cM.Campaign__c, cM.System_Campaign_Team_Member_Access_Level__c, cM.System_Campaign_Team_Member_Role__c, cM.System_Assigned_To__c));
        	 }else{
        	 	  Campaign_Team_Member__c cTM = existingCTMMap.get(cM.Campaign__c + '|' + cM.System_Assigned_To__c + '|' + cM.System_Campaign_Team_Member_Role__c);
        	 	  cTM.Campaign_Access_Level__c = getHigherAccessLevel(cM, cTM);
        	 	  cTMListToUpdate.add(cTM);
        	 }  
        }
                 
        if(cTMListToInsert.size() > 0){
          Database.Saveresult[] lsr = Database.insert(cTMListToInsert, false);
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to insert campaign Team member record due to following exception:' + err.getMessage());                
            }            
          }
        }
        
        if(cTMListToUpdate.size() > 0){
          Database.Saveresult[] lsr = Database.update(cTMListToUpdate, false);
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to update campaign Team member record due to following exception:' + err.getMessage());                
            }            
          }
        }
              
      } 
   } //end of insertCampaignTeamMembers(List<CampaignMember> insertedCampaignMembers)
   
   
   
   
   
   
   			 

public static void insertDuplicateCampaignMemberTeamMembers(List<Campaign_Member__c> insertedCampaignMembers){
      // This function is used to insert CMT records forcefully when CM is inserted      
      List<Campaign_Team_Member__c> cTMListToInsert = new List<Campaign_Team_Member__c>();
      List<Campaign_Team_Member__c> cTMListToUpdate = new List<Campaign_Team_Member__c>();
      Map<String, Campaign_Team_Member__c> existingCTMMap = new Map<String, Campaign_Team_Member__c>();      
      Map<String, List<Campaign_Member__c>> insertedCampaignMemberMap = new Map<String, List<Campaign_Member__c>>();
      Set<String> userIds = new Set<String>();
      Set<String> campaignIds = new Set<String>();
      
      if(insertedCampaignMembers.size() > 0){
      	// get the set of userIds and campaignIds
      	for(Campaign_Member__c cM : insertedCampaignMembers){
      		if(cM.Force_Create_CTM__c == true && (cM.System_Campaign_Team_Member_Access_Level__c   <> null || cM.System_Campaign_Team_Member_Access_Level__c   <> '') && (cM.System_Assigned_To__c <> null || cM.System_Assigned_To__r.Emp_Id__c <> null) && (cM.System_Campaign_Team_Member_Role__c <> null || cM.System_Campaign_Team_Member_Role__c <> '')){
      	    if(!userIds.contains(cM.System_Assigned_To__r.Emp_Id__c)){
      	    	System.debug('__________________' + cM.System_Assigned_To__r.Emp_Id__c);
      	    	userIds.add(String.valueOf(cM.System_Assigned_To__r.Emp_Id__c).trim());
      	    }
      	    
      	    if(!campaignIds.contains(cM.Campaign__r.External_Id__c)){
      	    	campaignIds.add(cM.Campaign__r.External_Id__c.trim());
      	    }
      	    
      	      string key = cM.Campaign__r.External_Id__c.trim() + '|' + cM.System_Assigned_To__r.Emp_Id__c.trim() + '|' + cM.System_Campaign_Team_Member_Role__c.trim();
			  
	          if(!insertedCampaignMemberMap.containsKey(key)){
	            List<Campaign_Member__c> cmList = new List<Campaign_Member__c>();
	            cmList.add(cM);
	            insertedCampaignMemberMap.put(key, cmList);
	          }else{
	            List<Campaign_Member__c> cMemberList = insertedCampaignMemberMap.get(key);
	            cMemberList.add(cM);    
	          }            
	          	
      		}
      	} 
      	// create a map of existing ctms in db for current userids and campaignids
      	if(userIds.size() > 0){
      		System.debug('UserIds:' + userIds);
      		System.debug('CampaignIds:' + campaignIds);
      		 
		    // TO DO: NEED TO CHANGE THIS METHOD FOR USER MSIDS
      		List<Campaign_Team_Member__c> lstExistingCTM = CM_CampaignDataUtil.getCampaignTeamMemberList(userIds, campaignIds); 
      		for(Campaign_Team_Member__c cTM : lstExistingCTM){      			
			    String key = cTM.Campaign__r.External_Id__c.trim() + '|' + cTM.User__r.Emp_Id__c.trim() + '|' + cTM.Role__c.trim();
      			existingCTMMap.put(key, cTM);
      		}
      	}
      	
      	
        System.debug('insertedCampaigMemberMap:' + insertedCampaignMemberMap);
        // create a list of cTM to insert and update
        for(String iCM : insertedCampaignMemberMap.keySet()){
        	 List<Campaign_Member__c> cMList = insertedCampaignMemberMap.get(iCM); 
        	 sortCampaignMemberListOnAccessLevelDesc(cMList); 
        	 Campaign_Member__c cM = cMList[0];  
        	 System.debug('ME IN' + cM.System_Campaign_Team_Member_Access_Level__c);
			 
			 String key = cM.Campaign__r.External_Id__c.trim() + '|' + cM.System_Assigned_To__r.Emp_Id__c.trim() + '|' + cM.System_Campaign_Team_Member_Role__c.trim();
			 
        	 if(!existingCTMMap.containsKey(key)){
			 
			    Campaign__c camp = new Campaign__c( External_Id__c = cM.Campaign__r.External_Id__c);
             
        	    User usr = new User( Emp_Id__c = cM.System_Assigned_To__r.Emp_Id__c);    
			 
			    Campaign_Team_Member__c cTM = new Campaign_Team_Member__c(
				  Campaign__r = camp,
				  Campaign_Access_Level__c = cM.System_Campaign_Team_Member_Access_Level__c,
				  Role__c = cM.System_Campaign_Team_Member_Role__c,
				  User__r = usr        
				); 
			    
			    cTMListToInsert.add(cTM);
			    
			 }else{
        	 	  Campaign_Team_Member__c cTM = existingCTMMap.get(key);
        	 	  cTM.Campaign_Access_Level__c = getHigherAccessLevel(cM, cTM);
        	 	  cTMListToUpdate.add(cTM);
        	 }  
        }
         System.debug('___________________cTMListToInsert____________' + cTMListToInsert);        
        if(cTMListToInsert.size() > 0){
          Database.Saveresult[] lsr = Database.insert(cTMListToInsert, false);
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to insert campaign Team member record due to following exception:' + err.getMessage());                
            }            
          }
        }
          System.debug('___________________cTMListToUpdate____________' + cTMListToUpdate);
        if(cTMListToUpdate.size() > 0){
          Database.Saveresult[] lsr = Database.update(cTMListToUpdate, false);
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to update campaign Team member record due to following exception:' + err.getMessage());                
            }            
          }
        }
              
      } 
   } //end of insertCampaignTeamMembers(List<CampaignMember> insertedCampaignMembers)
   
   
   /*
   12/27/2011 UV : moved this method to CM_campaignDataUtil
    public static List<Campaign_Team_Member__c> getCampaignTeamMemberList(Set<String> userIds, Set<String> campaignIds){
        return [Select c.Campaign__r.External_Id__c, c.User__r.Emp_Id__c, c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c
                                                where c.User__r.Emp_Id__c in :userIds and c.Campaign__r.External_Id__c in : campaignIds order by 
                                                c.Campaign__c, c.Campaign_Access_Level__c DESC];                                                
                                                // USED DESC BECAUSE IN SALESFORCE ORDER BY SOME PICKLIST WORKS DIFFERENTLY
    }
   */
   
   
   
    
}