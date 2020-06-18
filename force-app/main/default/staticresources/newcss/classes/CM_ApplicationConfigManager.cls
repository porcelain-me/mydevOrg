//  09/30/2011 RJ: ORIGINAL
//                 Application configuration manager for flex components
//  10/21/2011 RJ: Removed campaignMemberStatus picklist entries from getApplicationConfigSettings method
//  10/21/2011 RJ: Added new method for returning campaignMemberStatuses on campaign.
//  10/26/2011 AV: changed method getCampaignDefaultAssignee to getCamapignProperties and because thsi methos now gets additional campaign fields
//  11/22/2011 UV :  updated  method getCampaignConfiguration() to show defaultTab as incoming request if any incoming request is present.(line# 117-126)
public class CM_ApplicationConfigManager {
    // properties
    private static final String scoreColumnName = 'SCORE';
    private static final String accountColumnName = 'ACCOUNT';
    private static final String contactColumnName = 'CONTACT';
    private static final String emailColumnName = 'EMAIL';
    private static final String phoneColumnName = 'PHONE';
    private static final String statusColumnName = 'STATUS';
    private static final String priColumnName = 'PRI';
    private static final String tierColumnName = 'TIER';
    
  private static final List<String> allColumnsForCampaignMembers = new List<String>{scoreColumnName, accountColumnName, contactColumnName, emailColumnName, phoneColumnName, statusColumnName};
  private static final List<String> allColumnsForIncomingRequest = new List<String>{scoreColumnName, priColumnName, tierColumnName, accountColumnName, contactColumnName, emailColumnName, phoneColumnName, statusColumnName};
  //public List<CM_Campaigns_WS.GridConfig> getApplicationConfig_Instance(){
  //    return CM_ApplicationConfigManager.getApplicationConfig();
  //}
 
  public static List<CM_Campaigns_WS.GridConfig> getApplicationConfig(){
    // This function is used to get the application configuration settings and return the wrapper list by specific names
    
    List<CM_Campaigns_WS.GridConfig> gridConfigList = new List<CM_Campaigns_WS.GridConfig>();   
    List<CM_Campaigns_WS.GridColumn> gCListCampMembers = new List<CM_Campaigns_WS.GridColumn>();
    List<CM_Campaigns_WS.GridColumn> gCListIncomingReqests = new List<CM_Campaigns_WS.GridColumn>();
    
    // Check if user is analyst 
    if(Common_EmployeeHelper.getInstance().isUserAnalyst()){ 
    
        // populate column names for campaign members               
        for(String columnName : allColumnsForCampaignMembers){
            CM_Campaigns_WS.GridColumn gCCampMember = new CM_Campaigns_WS.GridColumn(columnName, true);
            gCListCampMembers.add(gCCampMember);
        }
        // create an entry for campaign members
        gridConfigList.add(new CM_Campaigns_WS.GridConfig('CampaignMembers', gCListCampMembers));
        
        // populate column names for incoming requests
        for(String columnName : allColumnsForIncomingRequest){
        CM_Campaigns_WS.GridColumn gCCampMember = new CM_Campaigns_WS.GridColumn(columnName, true);
        gCListIncomingReqests.add(gCCampMember);
      }      
        // create an entry for Incoming Requests
        gridConfigList.add(new CM_Campaigns_WS.GridConfig('IncomingRequests', gCListIncomingReqests));
    
    }else{
        
        // populate column names for campaign members
        for(String columnName : allColumnsForCampaignMembers){
        CM_Campaigns_WS.GridColumn gCCampMember = new CM_Campaigns_WS.GridColumn(columnName, true);
        gCListCampMembers.add(gCCampMember);
      }
      // create an entry for campaign members
      gridConfigList.add(new CM_Campaigns_WS.GridConfig('CampaignMembers', gCListCampMembers));
      
      // populate column names for incoming requests
      for(String columnName : allColumnsForIncomingRequest){
        CM_Campaigns_WS.GridColumn gCCampMember;
        if(columnName <> priColumnName && columnName <> tierColumnName){
          gCCampMember = new CM_Campaigns_WS.GridColumn(columnName, true);         
        }else{
            gCCampMember = new CM_Campaigns_WS.GridColumn(columnName, false);
        }
        gCListIncomingReqests.add(gCCampMember);
      }
      
      // create an entry for Incoming Requests
      gridConfigList.add(new CM_Campaigns_WS.GridConfig('IncomingRequests', gCListIncomingReqests));
    }
    
    return gridConfigList;      
  }// end of getApplicationConfig()
  
  
  public static List<CM_Campaigns_WS.ApplicationConfigSettings> getApplicationConfigSettings(){
     // This funtion is used to get the list of config settings  required by flex for Request
     List<CM_Campaigns_WS.ApplicationConfigSettings> appConfigSettings = new List<CM_Campaigns_WS.ApplicationConfigSettings>();      
     List<CM_Campaigns_WS.ApplicationConfigPickListEntry> pickList = new List<CM_Campaigns_WS.ApplicationConfigPickListEntry>();
     
     // Request status
     for(Selectoption sO : CM_CampaignDataUtil.getRequestStatusSelectOptions()){
        pickList.add(new CM_Campaigns_WS.ApplicationConfigPickListEntry(sO.getLabel(), sO.getValue()));
     }
     
     appConfigSettings.add(new CM_Campaigns_WS.ApplicationConfigSettings('RequestStatus', pickList));
     
     // Request Type
     pickList = new List<CM_Campaigns_WS.ApplicationConfigPickListEntry>();
     
     for(Selectoption sO : CM_CampaignDataUtil.getRequestTypeSelectOptions()){
        pickList.add(new CM_Campaigns_WS.ApplicationConfigPickListEntry(sO.getLabel(), sO.getValue()));
     }
     
     appConfigSettings.add(new CM_Campaigns_WS.ApplicationConfigSettings('RequestType', pickList));
     
     // Request Priority
     pickList = new List<CM_Campaigns_WS.ApplicationConfigPickListEntry>();
     
     for(Selectoption sO : CM_CampaignDataUtil.getRequestPrioritySelectOptions()){
        pickList.add(new CM_Campaigns_WS.ApplicationConfigPickListEntry(sO.getLabel(), sO.getValue()));
     }
     
     appConfigSettings.add(new CM_Campaigns_WS.ApplicationConfigSettings('RequestPriority', pickList));
    
         
     return appConfigSettings;
  }
  //  11/22/2011 UV :  updated  method to show defaultTab as incoming request if any incoming request is present.
  public static CM_Campaigns_WS.CampaignConfiguration getCampaignConfiguration(String campaignId) {
    // To return the list of campaign member statuses list for each campaign and defaultAssignee of a campaign
    List<CampaignMemberStatus__c> campaignMemberStatusesList = CM_CampaignDataUtil.getCampaignMemberStatus(campaignId);
    ////03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.  
    //Campaign camp = CM_CampaignDataUtil.getCampaignProperties(campaignId);
    Campaign__c camp = CM_CampaignDataUtil.getCampaignProperties(campaignId);
    Integer incomingRequests = 0; 
    String defaultTab = Label.CM_TargetList;
    List<String> cMSList = new List<String>();      
    for(CampaignMemberStatus__c cMS : campaignMemberStatusesList){
        cMSList.add(cMS.Name);
    }   
    incomingRequests = CM_CampaignDataUtil.getIncomingRequestsCount(campaignId, UserInfo.getUserId());
    defaultTab = incomingRequests > 0 ? Label.CM_IncomingRequests : Label.CM_TargetList;
    return new CM_Campaigns_WS.CampaignConfiguration(cMSList, camp,defaultTab);
    
    
   
  }// end of getCampaignConfiguration(String campaignId)
  
}