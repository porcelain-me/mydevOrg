//  
//  10/11/2011 RJ: ORIGINAL 
//                 Manager class for CampaignMemberAssignmentManagement.trigger for manipulation of campaign member assignment object  
//
// 12/26/2011 UV : added insertDuplicateCampaignMemberAssignments() method to insert duplicate campaign Members by data loader page
// SPRINT 42  RJ : coverage (91%)
//03/14/2012 UV : added this method updateCampaignMemberAssignments to update the realted CMAs from CMs.
public without sharing class CM_CampaignMemberAssignmentManager {   
   
    public static void deleteCampaignMemberAssignments(List<Campaign_Member__c> deletedCampaignMembers){
      // This function is used to cascade delete all the campaign member assignment records on delete of its parent campaign member
      Id campaignId = null;
      Set<Id> contactIds = new Set<Id>();      
      if(deletedCampaignMembers.size() > 0){
        campaignId = deletedCampaignMembers[0].Campaign__c;      
          for(Campaign_Member__c cM : deletedCampaignMembers){
            contactIds.add(cM.GPSContact__c);
          }
          List<Campaign_Member_Assignment__c> cMAListToDelete = CM_CampaignDataUtil.getCampaignMemberAssignmentforAllUser(campaignId, contactIds);
          if(cMAListToDelete.size() > 0){
            Database.DeleteResult[] ldR = Database.delete(cMAListToDelete, false);
            // Process the delete results
          for(Database.DeleteResult dr : ldR){
            if(!dr.isSuccess()){
                Database.Error err = dr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to insert campaign member assignment record due to following exception:' + err.getMessage());                
            }            
          } 
          }      
      }     
   }// end of deleteCampaignMemberAssignments(List<CampaignMember> deletedCampaignMembers) 
 
   
   public static void insertDuplicateCampaignMemberAssignments(List<Campaign_Member__c> insertedCampaignMembers){
      // This function is used to insert CMA records forcefully when CM is inserted
      List<Campaign_Member_Assignment__c> cMAListToInsert = new List<Campaign_Member_Assignment__c>();
      List<Campaign_Member_Assignment__c> cMAListToUpdate = new List<Campaign_Member_Assignment__c>();
      
      Set<Id> cmaIdSet = new Set<Id>();
      Set<String> campaignIds = new Set<String>();
      Set<String> userIds = new Set<String>();
      Set<String> contactIds = new Set<String>();
      
      if(insertedCampaignMembers.size() > 0){
        for(Campaign_Member__c cM : insertedCampaignMembers){
            if(cM.Force_Create_CMA__c == true && (cM.System_Assigned_To__c <> null || cM.System_Assigned_To__r.Emp_Id__c <> null)){
                campaignIds.add(cM.Campaign__r.External_Id__c.trim());
                userIds.add(cM.System_Assigned_To__r.Emp_Id__c.trim());
                contactIds.add(cM.GPSContact__r.TN_Contact_Key__c.trim());
            }
        }
        Map<String,Campaign_Member_Assignment__c> cmaMap = new Map<String,Campaign_Member_Assignment__c>();
        /* 12/27/2011  UV : Moved this query to CM_CampaignDataUtil
        List<Campaign_Member_Assignment__c> cmaList = [select Campaign__r.External_Id__c ,Assigned_To__r.Emp_Id__c,Contact__r.TN_Contact_Key__c 
                                                        from Campaign_Member_Assignment__c
                                                        where Campaign__r.External_Id__c IN :campaignIds AND Assigned_To__r.Emp_Id__c IN : userIds
                                                        AND Contact__r.TN_Contact_Key__c IN :contactIds];
                                                        
        */
        List<Campaign_Member_Assignment__c> cmaList = CM_CampaignDataUtil.getcampaignMemberAssignmentList(campaignIds, userIds, contactIds);                                                        
        for(Campaign_Member_Assignment__c cma : cmaList) {
            String key = cma.Campaign__r.External_Id__c + '|' + cma.GPSContact__r.TN_Contact_Key__c + '|' + cma.Assigned_To__r.Emp_Id__c; 
            System.debug('=============key for map========' + key);
            cmaMap.put(key, cma);
        }
        for(Campaign_Member__c cM : insertedCampaignMembers){
          if(cM.Force_Create_CMA__c == true && (cM.System_Assigned_To__c <> null || cM.System_Assigned_To__r.Emp_Id__c <> null)){
             String key = cm.Campaign__r.External_Id__c.trim() + '|' + cm.GPSContact__r.TN_Contact_Key__c.trim() + '|' + cm.System_Assigned_To__r.Emp_Id__c.trim();
             boolean isAssignedByAdmin = (cM.System_Assigned_by_Admin__c == null ? false : cM.System_Assigned_by_Admin__c);
             //Campaign_Member_Assignment__c.
             System.debug('===========isAssignedByAdmin========' + isAssignedByAdmin);  
             Campaign_Member_Assignment__c cMA;
             if(cmaMap.containsKey(key)) {
                 cMA = new Campaign_Member_Assignment__c(
                   Id = cmaMap.get(key).Id,
                   Assigned_by_Admin__c = isAssignedByAdmin
                 );
             if(!cmaIdSet.contains(cMA.Id)) {
                cMAListToUpdate.add(cMA);
                cmaIdSet.add(cMA.id);
             }
            } else {
                  Campaign__c camp = new Campaign__c( External_Id__c = cM.Campaign__r.External_Id__c);
                 // for mapping contact on tn contact key
                 GPSContact__c con = new GPSContact__c( TN_Contact_Key__c = cM.GPSContact__r.TN_Contact_Key__c);
                 User usr = new User( Emp_Id__c = cM.System_Assigned_To__r.Emp_Id__c);                  
                 
                 cMA = new Campaign_Member_Assignment__c(
                   
                   Assigned_by_Admin__c = isAssignedByAdmin,
                   
                   Assigned_To__r = usr,
                   
                   Campaign__r = camp,
                   
                   GPSContact__r = con,
                   
                   Reassigned__c = false,
                   
                   Reassigned_By__c = null
                   
                 );
             cMAListToInsert.add(cMA);
             }  
             CM_CustomException.logWarningMessage('cMAListToInsertSize:' + cMAListToInsert.size());
          }
        }
        if(cMAListToInsert.size() > 0){
          // The false parameter allows for partial processing if multiple records are passed  
          Database.SaveResult[] lsr = Database.insert(cMAListToInsert, false);        
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to insert campaign member assignment record due to following exception:' + err.getMessage());                
            }            
          }          
        }
        System.debug('======================UPDATE=========' + cMAListToUpdate);
        if(cMAListToUpdate.size() > 0) {
          // The false parameter allows for partial processing if multiple records are passed  
          Database.SaveResult[] lsr = Database.update(cMAListToUpdate, false);        
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to update campaign member assignment record due to following exception:' + err.getMessage());                
            }            
          }          
        
        }     
      }
   }//end of insertDuplicateCampaignMemberAssignments(List<CampaignMember> insertedCampaignMembers)  
   
   
   
   
   
   
   public static void insertCampaignMemberAssignments(List<Campaign_Member__c> insertedCampaignMembers){
      // This function is used to insert CMA records forcefully when CM is inserted
      List<Campaign_Member_Assignment__c> cMAListToInsert = new List<Campaign_Member_Assignment__c>();
      if(insertedCampaignMembers.size() > 0){           
        for(Campaign_Member__c cM : insertedCampaignMembers){
            if(cM.Force_Create_CMA__c == true && cM.System_Assigned_To__c <> null){
             cMAListToInsert.add(CM_CampaignDataUtil.getCampaignMemberAssignmentInstance((cM.System_Assigned_by_Admin__c == null ? false : cM.System_Assigned_by_Admin__c), cM.Campaign__c, cM.System_Assigned_To__c, cM.GPSContact__c, false));
             CM_CustomException.logWarningMessage('cMAListToInsertSize:' + cMAListToInsert.size());
            }
        }
        if(cMAListToInsert.size() > 0){
            // The false parameter allows for partial processing if multiple records are passed  
            Database.SaveResult[] lsr = Database.insert(cMAListToInsert, false);        
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];                
                CM_CustomException.logWarningMessage('Unable to insert campaign member assignment record due to following exception:' + err.getMessage());                
            }            
          }          
        }     
      }
   }//end of insertCampaignMemberAssignments(List<CampaignMember> insertedCampaignMembers) 
   
   
   
   //03/14/2012 UV : added this method to update the realted CMAs from CMs. 
   public static void updateCampaignMemberAssignments(List<Campaign_Member__c> updatedCampaignMembers, Map<Id,Campaign_Member__c> oldMap) {
        Integer LIMIT_DML = Limits.getLimitDMLRows() - Limits.getDmlRows();         
        String separator = '|';
        String ERROR_MESSAGE = 'Error: Following Campaign Member Assignment Records left unsynchronised:';
        String NEW_LINE = '<br/>';
        Set<Id> campaignIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        List<Campaign_Member_Assignment__c> cmaList = new List<Campaign_Member_Assignment__c>();
        Map<String, Campaign_Member__c> cmMap = new Map<String,Campaign_Member__c>();  
        List<Campaign_Member_Assignment__c> updatedCMAList = new List<Campaign_Member_Assignment__c>();
        List<Campaign_Member_Assignment__c> updatedCMAListLimited = new List<Campaign_Member_Assignment__c>();
        
        // Create set of unique campaign ids and contact ids
        // Create the map of CampaignMember with unique key combination of campaign id and contactid
        for(Campaign_Member__c cm : updatedCampaignMembers) {
            String key = cm.Campaign__c + separator + cm.GPSContact__c;
            cmMap.put(key,cm);
            campaignIds.add(cm.Campaign__c);
            contactIds.add(cm.GPSContact__c);               
        }

      // Get all the existing campaign member assignments for selected contacts and campaigns limiting the query to available limit of query rows
      cmaList = CM_CampaignDataUtil.getAllCampaignMemberAssignmentList(contactIds, CampaignIds);
        
        for(Campaign_Member_Assignment__c cma :  cmaList) {
            String key = cma.Campaign__c + separator + cma.GPSContact__c;
            Campaign_Member__c cm;
            //CampaignMember oldCM;
            if(cmMap.ContainsKey(key)) {
                cm  = cmMap.get(key);
                CM_CampaignDataUtil.copyCampaignMemberFieldsToCMA(cma, cm);             
                updatedCMAList.add(cma);
            }    
      }
      if(updatedCMAList.size() > 0) {
        if(updatedCMAList.size() < LIMIT_DML) {
            update updatedCMAList;
        } else {
            for(Integer indx = 0 ; indx < LIMIT_DML; indx++) {
                updatedCMAListLimited.add(updatedCMAList[indx]);
            }
            update updatedCMAListLimited;
            
            
            for(Integer jindx = LIMIT_DML; jindx < updatedCMAList.size(); jindx++){
                ERROR_MESSAGE += NEW_LINE + '' + updatedCMAList[jindx] + ': Campaign Member Assignment record is not synchronised.';
            }
            CM_CustomException.logWarningMessage(ERROR_MESSAGE);
        }   
      }             
   } 
  
}