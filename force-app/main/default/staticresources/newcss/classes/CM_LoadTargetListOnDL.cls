//  
//  09/22/2011 RJ: Created ORIGINAL
//                 // Controller to copy DIstribusion_List_Items__c (Target List COntacts) onto CampaignMember object.
// 10/14/2011 RJ : Removed the insertion of campaignMemberAssignmentToBeAddedForCurrentUser now as the code is now moved to trigger
public without sharing class CM_LoadTargetListOnDL {
     public static final Integer MAX_COLLECTION_LIMIT = 10000;
   public String selectedDLId{get;set;}
   public String selectedCampaignId{get;set;}
   public List<SelectOption> lstDistributionList{get;set;}   
   private Map<String, Id> mapMyContactsDistributionListId = new Map<String, Id>();
   
   public CM_LoadTargetListOnDL(){
      // Constructor
      lstDistributionList = new List<SelectOption>();
      for(Distribution_List__c dL : getAllDistributionLists()){         
        if(dL.Name.indexOf('~') == -1){  // "my contacts" filtering ( Exclude Distribution list containing ~)         
          lstDistributionList.add(new SelectOption(dL.Id, dL.Name));
        }else{
          mapMyContactsDistributionListId.put(dL.Name, dL.Id);
        }
      }
      
   }// end of constructor
   
    
   public List<Distribution_List__c> getAllDistributionLists(){
     // This function returns the list of distribution list records which the current user 
     // has previlige to see.
     return CM_CampaignDataUtil.getAllDistributionLists();
  }// end of getAllDistributionLists()
   
   
  public List<DistributionListItem__c> getDistributorListItems(string distributionListId, String selectedCampaignId){
      // This function returns list of distribution list items of a selected distribution list id.       
      return CM_CampaignDataUtil.getDistributorListItems(distributionListId, selectedCampaignId);    
  }// end of getDistributorListItems(string distributionListId)
  
  
  
  public void loadTargetListonSelectedDL(){
     // This function inserts campaign members of selected campaigns out of selected distribution list items.
     loadTargetListonSelectedDL(selectedDLId, selectedCampaignId);
  }// end of loadTargetListonSelectedDL()
  
  public List<Campaign_Member__c> loadTargetListonSelectedDL(String selectedDLId, String selectedCampaignId, boolean isUseMyContactList, String selectedDLName){
    this.selectedDLId = selectedDLId;   
    //User curentUser = CM_DataUtil_WS.getCurrentUser();
    User curentUser = CM_CampaignDataUtil.getCurrentLogUser();
    if(isUseMyContactList == true && mapMyContactsDistributionListId.containsKey(selectedDLName + '~' + curentUser.Emp_ID__c)){
         this.selectedDLId = mapMyContactsDistributionListId.get(selectedDLName + '~' + curentUser.Emp_ID__c);
    }   
    return loadTargetListonSelectedDL(this.selectedDLId, selectedCampaignId);       
  }
  
  public List<Campaign_Member__c> loadTargetListonSelectedDL(String selectedDLId, String selectedCampaignId){
     // This function inserts and returns inserted campaign members of selected campaigns out of selected distribution list items.
     if(selectedDLId <> null && selectedCampaignId <> null){
        List<DistributionListItem__c> dLItemList = getDistributorListItems(selectedDLId, selectedCampaignId);
        List<Campaign_Member__c> campaignMemberList = new List<Campaign_Member__c>();        
        List<Campaign_Member__c> cMList = CM_CampaignDataUtil.getAllCampaignMembers(selectedCampaignId);
        List<Campaign_Member_Assignment__c> campaignMemberAssignmentToBeAddedForCurrentUser = new List<Campaign_Member_Assignment__c>();
        
          Set<Id> contactIds = new Set<Id>();
          Set<Id> cMAContactIds = new Set<Id>();
          
          for(Campaign_Member__c cM : cMList){
            contactIds.add(cM.GPSContact__r.Id);
          }
          
        for(DistributionListItem__c dLI : dLItemList){
            if(!contactIds.contains(dLI.GPSContact__c)){
                // if campaign member does not exists then we dont need to explicitly insert the CMA record for the current user
              Campaign_Member__c cM = CM_CampaignDataUtil.getCampaignMemberInstance(dLI.GPSContact__c, selectedCampaignId);             
              campaignMemberList.add(cM);
            }else{
                // but if campaign member already exists in the list for some other user then we have to manage the insertion of new cMA for current user.
            cMAContactIds.add(dLI.GPSContact__c);          
            }           
        }
        
        // Managing the insertion of new CMA for current user that missed to get inserted through trigger 
        // because CM record already exists in the database we just have to insert CMA for current user. 
        if(cMAContactIds.size() > 0){
            List<Id> contactIdList = new List<Id>();
            contactIdList.addAll(cMAContactIds);     
            
            // get the list of all the existing cMA records for current user        
          List<Campaign_Member_Assignment__c> campaignMemberAssignmentAlreadyAddedForCurrentUser = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(selectedCampaignId, contactIdList);
          
          // remove those records from the set that already added in the cMA List 
          for(Campaign_Member_Assignment__c cMA : campaignMemberAssignmentAlreadyAddedForCurrentUser){
            if(cmAContactIds.contains(cMA.GPSContact__c)){
              cmAContactIds.remove(cMA.GPSContact__c); 
            }
          }          
          // prepare a  list of cMA to be inserted          
          for(Id contactId : cmAContactIds){
            campaignMemberAssignmentToBeAddedForCurrentUser.add(CM_CampaignDataUtil.getCampaignMemberAssignmentInstance(false, selectedCampaignId, UserInfo.getUserID(), contactId, false));
          }        
        }
        
        if(campaignMemberList.size() > 0){
          Database.SaveResult[] lsr = Database.insert(campaignMemberList, false);     
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){ 
                  Database.Error err = sr.getErrors()[0];              
                CM_CustomException.logWarningMessage('Unable to insert campaign member record due to following exception:' + err.getMessage());                
            }            
          }     
        }
        
        if(campaignMemberAssignmentToBeAddedForCurrentUser.size() > 0){         
          Database.SaveResult[] lsr = Database.insert(campaignMemberAssignmentToBeAddedForCurrentUser, false);
          // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){ 
                Database.Error err = sr.getErrors()[0];              
                CM_CustomException.logWarningMessage('Unable to insert campaign member assignment record due to following exception:' + err.getMessage());                
            }            
          }  
        }
                
        List<Campaign_Team_Member__c> cTMList = CM_CampaignDataUtil.getCampaignTeamMemberList(UserInfo.getUserID(), selectedCampaignId);        
        for(Campaign_Team_Member__c cTM : cTMList){
            cTM.Imported_Target_List__c = true;
        }
        if(cTMList.size() > 0){        
          Database.SaveResult[] lsr = Database.update(cTMList, false);
           // Process the save results
          for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){ 
                Database.Error err = sr.getErrors()[0];              
                CM_CustomException.logWarningMessage('Unable to insert campaign team member record due to following exception:' + err.getMessage());                
            }            
          }
        }
        return campaignMemberList;
     }
     
     
     
     return null;
  }// end of loadTargetListonSelectedDL(String selectedDLId, String selectedCampaignId)
   
}