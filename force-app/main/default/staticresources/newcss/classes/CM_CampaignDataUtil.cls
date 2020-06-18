// 09/28/2011 RJ: ORIGINAL  
//                Data Retrieval unit for Campaigns Webservice methods and controller methods                  
//   
// 09/28/2011 UV: Modified : Added new method getCampaignMemberStatus()
// 09/28/2011 RJ: Added new method getCampaignMembersforCurrentUser()
// 09/29/2011 UV: Added new methods getIncomingRequestsForCurrentUser() and getContactMap()
// 10/01/2011 UV: Added new method getSearchCampaignMembersContacts()
// 10/07/2011 UV: Added nested Query in method getContactMap() for priority Contact
// 10/12/2011 RJ: Modifed getContactMap method and added c.Account.PSL_by_Role__c, c.Account.PSL_by_Role_Abbreviated__c in query
// 10/12/2011 UV: Added new methods getRequestDetail and getNewRequest 
// 10/25/2011 RJ: Modified getRequestStatusSelectOptions and getRequestTypeSelectOptions method to populate picklist values from custom settings and not from object schema describe results
// 10/25/2011 AV: Modified getCampaignDefaultAssignee to add field Require_Focus_Call_Request_Verification__c (will be used in getApplicationCOnfiguration)
//                    Changed name of the method to getCampaignPropoerties
// 11/02/2011 RJ: Modified getSearchContacts and added Account_Name__c and Active_Flag__c conditions in the query
//                Made Account_Name__c field indexed in contact object
// 11/10/2011 UV : modified method getCampaignMemberAssignment() to add new field in the query to get the reassigned user name (line #380-422)
// SPRINT 41  RJ : A new method added to the class for getting the phone numbers in array format for a campaign member method name: getContactPhoneList lines modified:  #1083 - 1132 (coverage 93%)
// 02/24/2012 UV : Added a new Method getCampaignMemberAssignmentforAllUserOtherThenCurrentUser() (line# 1155-1165)
//03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.  
public with sharing class CM_CampaignDataUtil {
    
    private static CM_LIMIT_SETTINGS__c settings = CM_LIMIT_SETTINGS__c.getInstance();
    private static CM_CUSTOM_MESSAGE_SETTINGS__c customMessageSettings = CM_CUSTOM_MESSAGE_SETTINGS__c.getInstance();
    private static CM_GENERALSETTINGS__c generalSettings = CM_GENERALSETTINGS__c.getInstance();
    
    // properties
    private static final String TASK_RECORDTYPE_NAME = generalSettings.TASK_RECORDTYPE_NAME__c <> null ? generalSettings.TASK_RECORDTYPE_NAME__c : CM_TestClassUtilities.TASK_RECORDTYPE_NAME;
    private static Id TASK_RECORDTYPE_ID;
  
    private static final String TASK_STATUSES = generalSettings.Task_Statuses__c <> null ? generalSettings.Task_Statuses__c : CM_TestClassUtilities.TaskStatuses;
    private static final String TASK_TYPES = generalSettings.Task_Types__c <> null ? generalSettings.Task_Types__c : CM_TestClassUtilities.TaskTypes;
    
    
    public static final Integer CAMPAIGN_MEMBER_LIST_LIMIT = settings.CAMPAIGN_MEMBER_LIST_LIMIT__c <> null ? settings.CAMPAIGN_MEMBER_LIST_LIMIT__c.intValue() : CM_TestClassUtilities.CAMPAIGN_MEMBER_LIST_LIMIT;
    public static final Integer SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT = settings.SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT__c <> null ? settings.SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT__c.intValue() : CM_TestClassUtilities.SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT; 
    public static final Integer SEARCH_CAMPAIGN_USERS_LIMIT = settings.SEARCH_CAMPAIGN_USERS_LIMIT__c <> null ? settings.SEARCH_CAMPAIGN_USERS_LIMIT__c.intValue() : CM_TestClassUtilities.SEARCH_CAMPAIGN_USERS_LIMIT;
    public static final Integer MAX_COLLECTION_LIMIT = settings.MAX_COLLECTION_LIMIT__c <> null ? settings.MAX_COLLECTION_LIMIT__c.intValue() : CM_TestClassUtilities.MAX_COLLECTION_LIMIT; 
    public final static Integer CBM_LIMIT = settings.CBM_LIMIT__c <> null ? settings.CBM_LIMIT__c.intValue() : CM_TestClassUtilities.CBM_LIMIT;
    
    public static final boolean IS_SEND_NOTIFICATION_MAIL = generalSettings.IS_SEND_NOTIFICATION_MAIL__c <> null ? generalSettings.IS_SEND_NOTIFICATION_MAIL__c : CM_TestClassUtilities.IS_SEND_NOTIFICATION_MAIL; // this property will allow us to control the sending of email notification to assignee.
    
    
    public static final String CampaignRequestRecordTypeException = customMessageSettings.CampaignRequestRecordTypeException__c <> null ? customMessageSettings.CampaignRequestRecordTypeException__c : CM_TestClassUtilities.CampaignRequestRecordTypeException;
    public static final String CommonException = customMessageSettings.CommonException__c <> null ? customMessageSettings.CommonException__c : CM_TestClassUtilities.CommonException;
    public static final String SelectCampaignMemberException = customMessageSettings.SelectCampaignMemberException__c <> null ? customMessageSettings.SelectCampaignMemberException__c : CM_TestClassUtilities.SelectCampaignMemberException;
    public static final String SelectRequestException = customMessageSettings.SelectRequestException__c <> null ? customMessageSettings.SelectRequestException__c : CM_TestClassUtilities.SelectRequestException;
    public static final String LoginExpiredException = customMessageSettings.LoginExpiredException__c <> null ? customMessageSettings.LoginExpiredException__c : CM_TestClassUtilities.LoginExpiredException; 
    public static final String CampaignInActiveException = customMessageSettings.CampaignInActiveException__c <> null ? customMessageSettings.CampaignInActiveException__c : CM_TestClassUtilities.CampaignInActiveException;
    private static User curentLogUser{get;set;}
    
    public static Map<Id,List<GroupMember>> groupMembersMap;
    
    
    public static String getTaskRecordTypeName(){
         // get the record type of task for campaigns 
         return TASK_RECORDTYPE_NAME;        
    }// end of getTaskRecordTypeName()
    
    //AV 20111105: added to refactor RT retrieval from inside methods. 
    //TODO: Next step is 1) see if we can get RT Id without soql query 2) possibly extract all RT related code into a common class, and ensure veryone uses it.
    public static Id getTaskRecordTypeId(){
       if(TASK_RECORDTYPE_ID == null){

           for(RecordType rt : [select id from RecordType where DeveloperName = :getTaskRecordTypeName() Limit 1]) {
            TASK_RECORDTYPE_ID = rt.Id;
           }
        
           if(TASK_RECORDTYPE_ID <> null)
                return TASK_RECORDTYPE_ID;
           else
                throw new CM_CustomException(CM_CampaignDataUtil.CampaignRequestRecordTypeException, 'RecordType');
       }
       else
           return TASK_RECORDTYPE_ID;
        
    }
    
    // 03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.  
    /*public static Campaign getCampaignProperties(Id campaignId){
        List<Campaign> campList = [Select c.Default_Task_Assignee__r.FirstName, c.Default_Task_Assignee__r.LastName, 
        c.Default_Task_Assignee__r.Id, c.Default_Task_Assignee__c, 
        c.Require_Focus_Call_Request_Verification__c From Campaign c where c.Id = : campaignId];*/
    
    public static Campaign__c getCampaignProperties(Id campaignId){
        List<Campaign__c> campList = [Select c.Default_Task_Assignee__r.FirstName, c.Default_Task_Assignee__r.Preferred_Name__c, c.Default_Task_Assignee__r.LastName, 
        c.Default_Task_Assignee__r.Id, c.Default_Task_Assignee__c, 
        c.Require_Focus_Call_Request_Verification__c From Campaign__c c where c.Id = : campaignId];
        
        if(campList.size() > 0){
            return campList[0];
        }
        
        return null;
    }
    
    
      public static Campaign__Share getCampaignShareInstance(Id userId, Id campaignId, String campaignAccessLevel){
        Campaign__Share cS = new Campaign__Share(
         UserOrGroupId = userId,
         ParentId = campaignId, 
         AccessLevel = campaignAccessLevel);
        return cS;
    }
    
    public static Campaign_Member_Assignment__c getCampaignMemberAssignmentInstance(boolean isAssignedByAdmin, Id campaignId, Id userId, Id contactId, boolean isReassigned){

    Campaign_Member_Assignment__c cMA = new Campaign_Member_Assignment__c(
       Assigned_by_Admin__c = isAssignedByAdmin,
       Assigned_To__c = userId,
       Campaign__c = campaignId,
       GPSContact__c = contactId,
       Reassigned__c = isReassigned,
       Reassigned_By__c = isReassigned == true ? userId : null
    );
    
    return cMA;
  }
  public static Task getNewRequestInstance(String contactId, String Action, String campaignId,  
                            String assignedToUserId, String comments, Date dueDate, boolean isSpokenToContact) {
    //
    
    list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	     }
    
    //
    
    Task newRequest = new Task(
      RecordtypeId = getTaskRecordTypeId(),
      GPS_Contact__c = contactId,
      Type = Action,
      WhatId = campaignId,
      Subject = Action,
      OwnerId = assignedToUserId,      
      Description = comments,
      ActivityDate = dueDate,
      Status = 'Pending');
        
        return newRequest;
  }
    
    
  public static Campaign_Member__c getCampaignMemberInstance(Id contactId, Id campaignId){
     Campaign_Member__c cM = getCampaignMemberInstance(contactId, campaignId, null);          
     return cM;     
  }
  
  public static Campaign_Member__c getCampaignMemberInstance(Id contactId, Id campaignId, Id userId){
  	
  	String status = [select Name from CampaignMemberStatus__c where Campaign__c = :campaignId and isDefault__c = true].Name;
  	
  	//Added on 06-Oct-2017 for logged-in user
  	
  	list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	     }
	     
	 ///
  	
     Campaign_Member__c cM = new Campaign_Member__c(
            GPSContact__c = contactId,
            Campaign__c = campaignId,
            Reason__c = '',
            Campaign_Score__c = 0,
           // System_Assigned_To__c = (userId == null ? UserInfo.getUserID() : userId),
            System_Assigned_To__c = (userId == null ? loggedInUserid : userId),
            Force_Create_CMA__c = true,
            Status__c = status
          );
          
     return cM;
  }
  
  
  public static Campaign_Team_Member__c getCampaignTeamMemberInstance(Id campaignId, String accessLevel, String role, Id userId){
    Campaign_Team_Member__c cTM = new Campaign_Team_Member__c(
      Campaign__c = campaignId,
      Campaign_Access_Level__c = accessLevel,
      Role__c = role,
      User__c = userId        
    );
    
    return cTM;
  }
  //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.    
  //public static void copyCampaignMemberFieldsToCMA(Campaign_Member_Assignment__c cma, CampaignMember cm){
  public static void copyCampaignMemberFieldsToCMA(Campaign_Member_Assignment__c cma, Campaign_Member__c cm){
     //cma.Responded__c = cm.HasResponded;
     cma.Responded__c = cm.HasResponded__c;
     //cma.Responded_By__c = cm.HasResponded == true ? cm.lastModifiedById : null;
     cma.Responded_By__c = cm.HasResponded__c == true ? cm.lastModifiedById : null;
     //cma.Campaign_Status__c = cm.Status;
     cma.Campaign_Status__c = cm.Status__c;
     cma.Campaign_Score__c = cm.Campaign_Score__c;
     cma.Reason__c = cm.Reason__c;     
  }  
    
       
  public static User getCurrentUser(){
        // get the current user    
      for(User usr :[Select Emp_ID__c, u.Name ,FirstName, Preferred_Name__c, LastName
                     ,Email From User u where id=:Userinfo.getUserId() limit 1]){
             return usr;
      }
      return null;
  }
    
    
    public static List<Distribution_List__c> getAllDistributionLists(){
     // This function returns the list of distribution list records which the current user 
     // has previlige to see.     
     Set<Id> distributionIds = new Set<Id>();
     Integer queryLimit = CM_CampaignDataUtil.MAX_COLLECTION_LIMIT;  
     //Custom Log-In functionality Changes from CurrentUser to CurrentLogUser     
     //User curentUser = CM_CampaignDataUtil.getCurrentUser();
     User curentUser = CM_CampaignDataUtil.getCurrentLogUser();   
	 List<Distribution_List_Access_Owner__c > lstDListOwner = [Select d.Distribution_List__c 
                                                         From Distribution_List_Access_Owner__c d
                                                         Where d.GPSEmployee__r.MS_ID__c = : curentUser.Emp_ID__c
                                                         AND d.Active_Flag__c = true                                                          
                                                         limit : queryLimit];
     for(Distribution_List_Access_Owner__c dListOwner: lstDListOwner){
      distributionIds.add(dListOwner.Distribution_List__c);                             
     } 
     List<Distribution_List__c > lstDList =   [Select d.Name, d.Id 
                                 From Distribution_List__c d 
                                 where (d.OwnerId = : UserInfo.getUserId() OR id in :distributionIds)
                                 and d.Active_Flag__c = true order by d.Name asc
                                 Limit :queryLimit];
     
     return lstDList;
  }// end of getAllDistributionLists()
   
   
  public static List<DistributionListItem__c> getDistributorListItems(String distributionListId, String selectedCampaignId){
      Integer queryLimit = CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT;     
      // This function returns list of distribution list items of a selected distribution list id.
      List<DistributionListItem__c> dLItemList = [Select d.GPSContact__c, d.GPSContact__r.Name 
      From DistributionListItem__c d where d.DistributionList__c = : distributionListId 
      and d.Active_Flag__c = true limit: queryLimit];     
      return dLItemList;    
  }// end of getDistributorListItems(string distributionListId)
    
    
    public static String replaceSpecialCharacters(String inputVal){
        inputVal = String.escapeSingleQuotes(inputVal);
        inputVal = inputVal.replaceAll('\\(','\\(');
        inputVal = inputVal.replaceAll('\\)','\\)');    
        inputVal = inputVal.replaceAll('\\%', '\\\\%');
    
    return inputVal;
    }
    
    public static List<SelectOption> getCampaignMemberStatusSelectOptions(){
        //This method is used to get all the values in picklist that are used to filter the Tasks by their status
        transient List<SelectOption> lstSelectOption = new List<SelectOption>();
        Schema.DescribeFieldResult field = Campaign_Member__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> sourcePicklist = field.getPicklistValues();     
                 
        for(PicklistEntry pickListEnt : sourcePicklist){
                SelectOption opt = new SelectOption(pickListEnt.getValue(), pickListEnt.getLabel());
                lstSelectOption.add(opt);                                
        }     
        return lstSelectOption;
  }
  
 /***** Start Code : Campaign Migration -  CampaignMemberStatus__c custom object instead of standard object. Modified by Sudarshan K. 04/03/2016*******/
  public static List<CampaignMemberStatus__c> getCampaignMemberStatus(String campaignId){
        //This method is used to get all the values in picklist that are used to filter the Tasks by their status
        transient List<String> campaignMemberStatuses = new List<String>();
        List<CampaignMemberStatus__c> cMStatusList = [Select c.Name From CampaignMemberStatus__c c where 
                                                   c.Campaign__c = : campaignId order by c.Name asc];
        
        return cMStatusList;
  }
  /****************************End Code **********************************/ 
   
    public static List<SelectOption> getRequestStatusSelectOptions(){
        //This method is used to get all the values in picklist that are used to filter the Tasks by their status
        transient List<SelectOption> lstSelectOption = new List<SelectOption>();
        //Schema.DescribeFieldResult field = Task.Status.getDescribe();
        //List<Schema.PicklistEntry> sourcePicklist = field.getPicklistValues();
        
        String[] taskStatusArray = TASK_STATUSES.split(';');
        
        for(String taskStatus : taskStatusArray){
            SelectOption opt = new SelectOption(taskStatus, taskStatus);
          lstSelectOption.add(opt);
        }     
                
        //for(PicklistEntry pickListEnt : sourcePicklist){
        //        SelectOption opt = new SelectOption(pickListEnt.getValue(), pickListEnt.getLabel());
        //        lstSelectOption.add(opt);                                
        //}  
           
        return lstSelectOption;
  }
    
    public static List<SelectOption> getRequestTypeSelectOptions(){
        //This method is used to get all the values in picklist that are used to filter the Tasks by their status
        transient List<SelectOption> lstSelectOption = new List<SelectOption>();
        //Schema.DescribeFieldResult field = Task.Type.getDescribe();
        //List<Schema.PicklistEntry> sourcePicklist = field.getPicklistValues();     
                 
        //for(PicklistEntry pickListEnt : sourcePicklist){
        //        SelectOption opt = new SelectOption(pickListEnt.getValue(), pickListEnt.getLabel());
        //       lstSelectOption.add(opt);                                
        //} 
        
        String[] taskTypeArray = TASK_TYPES.split(';');
        
        for(String taskType : taskTypeArray){
                SelectOption opt = new SelectOption(taskType, taskType);
               lstSelectOption.add(opt);                                
        } 
            
        return lstSelectOption;
  }
    
    public static List<SelectOption> getRequestPrioritySelectOptions(){
        //This method is used to get all the values in picklist that are used to filter the Tasks by their status
        transient List<SelectOption> lstSelectOption = new List<SelectOption>();
        Schema.DescribeFieldResult field = Task.Priority.getDescribe();
        List<Schema.PicklistEntry> sourcePicklist = field.getPicklistValues();     
                 
        for(PicklistEntry pickListEnt : sourcePicklist){
                SelectOption opt = new SelectOption(pickListEnt.getValue(), pickListEnt.getLabel());
                lstSelectOption.add(opt);                                
        }     
        return lstSelectOption;
  }
    
    
    
    public static Task getRequestDetail(String requestId) {
        List<Task> requestList = new List<Task>(); 
        requestList = [select CreatedDate, CreatedBy.FirstName, CreatedBy.Preferred_Name__c, CreatedBy.LastName, CreatedById, IsClosed, GPS_Contact__c, Type, WhatId, Subject, OwnerId, Description, Assignee_Feedback__c, ActivityDate, Status,
                        Owner.FirstName, Owner.LastName, What.Name 
                        from Task where Id = : requestId limit 1];
        
        system.debug('getRequestDetail');
        
        if(requestList.size() > 0){
            return requestList[0];  
        }else{    
             throw new CM_CustomException(CM_CampaignDataUtil.SelectRequestException, 'Task'); 
        }
        return null;
    }//end of getRequestDetail(String requestId)
    
  public static Campaign_Member__c getSelectedCampaignMember(Id campaignMemberId){
    Set<Id> campaignMemberIds = new Set<Id>();
    campaignMemberIds.add(campaignMemberId);
    
    List<Campaign_Member__c> campaignMemberList  = CM_CampaignDataUtil.getSelectedCampaignMember(campaignMemberIds);
                                                 
    if(campaignMemberList.size() > 0){
      return campaignMemberList[0];  
    }else{    
        
      throw new CM_CustomException(CM_CampaignDataUtil.SelectCampaignMemberException, 'CampaignMember'); 
    }
    
    return null;
     
  }
  
  public static List<Campaign_Member__c> getSelectedCampaignMember(Set<Id> campaignMemberIds){
    List<Campaign_Member__c> campaignMemberList  =[Select c.HasResponded__c, c.Campaign__r.End_Date__c, c.Campaign__r.CreatedBy.LastName, c.Campaign__r.CreatedBy.Preferred_Name__c, c.Campaign__r.CreatedBy.FirstName,c.Campaign__r.CreatedById, c.Campaign__r.Name, c.Campaign__c, c.Id, c.GPSContact__c, c.Campaign_Score__c, c.GPSContact__r.GPSAccount__r.Name, c.GPSContact__r.GPSAccount__r.Id, c.GPSContact__r.FirstName__c,
                                                 c.GPSContact__r.LastName__c, c.GPSContact__r.Email__c, c.Status__c, c.Reason__c,c.GPSContact__r.Prefer_Business_Phone__c, c.GPSContact__r.Prefer_Mobile_Phone__c,
                                                 c.GPSContact__r.Phone__c,c.GPSContact__r.Mobile__c, c.GPSContact__r.HomePhone__c  from Campaign_Member__c c
                                                 where c.Id IN :campaignMemberIds];
                                                 
    if(campaignMemberList.size() > 0){
      return campaignMemberList;  
    }else{    
      throw new CM_CustomException(CM_CampaignDataUtil.SelectCampaignMemberException, 'CampaignMember'); 
    } 
    return null;
  }
  
  //FIXME: AV: Question: Why is this method not filtering the task query by Recordtype?
  public static Task getPendingRequests(Id campaignId, Id contactId){
    
    List<Task> taskList = new List<Task>();
        
    taskList = [Select t.IsClosed, t.Status, t.Owner.FirstName, t.Owner.LastName, t.OwnerId, t.CreatedBy.FirstName, t.CreatedBy.Preferred_Name__c, t.CreatedBy.LastName, t.CreatedById 
                  From Task t
                  where t.RecordTypeId = :getTaskRecordTypeId() and t.GPS_Contact__c =: contactId and t.WhatId = : campaignId 
                        and t.CreatedById =: UserInfo.getUserId()]; 
    
    return taskList.size() > 0 ? taskList[0] : null;
  }
  
    /**
     * This method is used to get the status of the all the requests for the selected campaign 
     * CampaignId -  This is Id of the selected campaign whose requests status have to get 
     * ContactIdSet - This is Collection is Ids Of Contacts. The Request should be related to these Contacts.  
     **/   
    public static Map<Id,Task> getCampaignMemberStatus(Id CampaignId , Set<Id> ContactIdSet) {
        // This function is used to create a map of request status of each contact in the set.
        // CampaignId - salesforce id of campaign object record
        // contactIds - set of salesforce contact object ids
        
        Map<Id,Task> campaignMemberStatusMap = new Map<Id,Task>();

        for(Task tsk : [Select IsClosed, Id, Status, GPS_Contact__c  from Task where  
                            RecordTypeId = :getTaskRecordTypeId() AND GPS_Contact__c IN :ContactIdSet AND WhatId = :CampaignId order by LastModifiedDate DESC]){
            if(!campaignMemberStatusMap.containsKey(tsk.GPS_Contact__c)) {               
                campaignMemberStatusMap.put(tsk.GPS_Contact__c,tsk);
            }
        }

        return campaignMemberStatusMap;
    }// end of getCampaignMemberStatus(Id CampaignId , Set<Id> ContactIdSet)
    
    
    private static List<Campaign_Member_Assignment__c> getCampaignMemberAssignment(Id campaignId, List<Id> contactIds, boolean forCurrentUser, Id userId){
    // get list of campaign member assignment for a campaign and for a user
    // campaign id - selected campaign id
    // contactIds - a set of selected contactIds 
    // forCurrentUser - check that search is general or for current user
    // 11/10/2011 UV : modified  : add new field in the query to get the reassigned user name
    User currentUser = CM_CampaignDataUtil.getCurrentLogUser();
    List<Campaign_Member_Assignment__c> cMAList = new List<Campaign_Member_Assignment__c>();    
    if(contactIds <> null && forCurrentUser == true){
        cMAList = [Select Assigned_by_Admin__c,Assigned_To__c, Reassigned_By__c, Reassigned_By__r.FirstName, Reassigned_By__r.Preferred_Name__c, Reassigned_By__r.LastName,
                                               Campaign__c,Composite_Primary_Key__c, 
                                               GPSContact__c, Reassigned__c from Campaign_Member_Assignment__c
                                               where Assigned_To__c = : currentUser.Id and Campaign__c = : campaignId and GPSContact__c in : contactIds];
                                               
        return cMAList;                                       
    }else if(forCurrentUser == true && campaignId <> null){
        cMAList = [Select Assigned_by_Admin__c,Assigned_To__c, Reassigned_By__c, Reassigned_By__r.FirstName, Reassigned_By__r.Preferred_Name__c, Reassigned_By__r.LastName,
                                               Campaign__c,Composite_Primary_Key__c, 
                                               GPSContact__c, Reassigned__c from Campaign_Member_Assignment__c
                                               where Assigned_To__c = : currentUser.Id and Campaign__c = : campaignId];
        return cMAList;                                       
    }else if(forCurrentUser == false && userId == null){
          
          cMAList = [Select Assigned_by_Admin__c,Assigned_To__c, Reassigned_By__c, Reassigned_By__r.FirstName, Reassigned_By__r.Preferred_Name__c, Reassigned_By__r.LastName,
                                               Campaign__c,Composite_Primary_Key__c, 
                                               GPSContact__c, Reassigned__c from Campaign_Member_Assignment__c
                                               where Campaign__c = : campaignId];
                                              
        return cMAList;
    }else if (forCurrentUser == false && userId <> null && contactIds == null){
          cMAList = [Select Assigned_by_Admin__c,Assigned_To__c, Reassigned_By__c, Reassigned_By__r.FirstName, Reassigned_By__r.Preferred_Name__c, Reassigned_By__r.LastName,
                                               Campaign__c,Composite_Primary_Key__c, 
                                               GPSContact__c, Reassigned__c from Campaign_Member_Assignment__c
                                               where Assigned_To__c = : userId and Campaign__c = : campaignId];
        return cMAList;                                       
    }else if (forCurrentUser == false && userId <> null && contactIds <> null){
        cMAList = [Select Assigned_by_Admin__c,Assigned_To__c, Reassigned_By__c, Reassigned_By__r.FirstName, Reassigned_By__r.Preferred_Name__c, Reassigned_By__r.LastName,
                                               Campaign__c,Composite_Primary_Key__c, 
                                               GPSContact__c, Reassigned__c from Campaign_Member_Assignment__c
                                               where Assigned_To__c = : userId and Campaign__c = : campaignId and GPSContact__c in : contactIds];
        return cMAList;                                       
    }                                            
    return cMAList;
  }// end of getCampaignMemberAssignment(Id campaignId)
    
    public static List<Campaign_Member_Assignment__c> getCampaignMemberAssignmentforUser(Id campaignId, List<Id> contactIds, Id userId){
        // get list of campaign member assignment for a campaign and for a user
    // campaign id - selected campaign id
    // contactIds - a set of selected contactIds 
    // userId - user id
    
    return CM_CampaignDataUtil.getCampaignMemberAssignment(campaignId, contactIds, false, userId);    
    
    }// end of getCampaignMemberAssignmentforUser(Id campaignId, List<Id> contactIds, Id userId)
    
    
    public static List<Campaign_Member_Assignment__c> getCampaignMemberAssignmentforCurrentUser(Id campaignId, List<Id> contactIds){
    // get list of campaign member assignment for a campaign and for a user
    // campaign id - selected campaign id
    // contactIds - a set of selected contactIds 
    return CM_CampaignDataUtil.getCampaignMemberAssignment(campaignId, contactIds, true, null);    
  }// end of getCampaignMemberAssignmentforCurrentUser(Id campaignId)
  
    
    public static List<Campaign_Member_Assignment__c> getCampaignMemberAssignmentforCurrentUser(Id campaignId){
        // get list of campaign member assignment for a campaign and for a user
        // campaignId - selected campaign id 
        return CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(campaignId, null);
    }// end of getCampaignMemberAssignmentforCurrentUser(Id campaignId)

  public static List<Campaign_Member_Assignment__c> getCampaignMemberAssignmentforAllUser(Id campaignId){
    // get list of campaign member assignment for a campaign and for a user
    // campaignId - selected campaign id 
     return CM_CampaignDataUtil.getCampaignMemberAssignment(campaignId, null, false, null);    
  }// end of getCampaignMemberAssignmentforCurrentUser(Id campaignId)
    
    public static List<Campaign_Member_Assignment__c> getCampaignMemberAssignmentforAllUser(Id campaignId, Set<Id> contactIds){
    // get list of campaign member assignment for a campaign and for a user
    // campaignId - selected campaign id 
    // contactIds - set of contact ids
     List<Campaign_Member_Assignment__c> cMAList = [Select id from Campaign_Member_Assignment__c 
                                                    where Campaign__c = : campaignId and GPSContact__c in : contactIds];
     return cMAList;   
  }// end of getCampaignMemberAssignmentforCurrentUser(Id campaignId)
    
    public static List<Campaign_Member__c> getCampaignMembersforCurrentUser(Id campaignId){
        return CM_CampaignDataUtil.getCampaignMembersforCurrentUser(campaignId, null);
    }
    
    public static List<Campaign_Member__c> getCampaignMembersforCurrentUser(Id campaignId, Set<Id> contactIds){
           // Get list of CampaignMembers for current user:
           // campaignId - salesforce id of campaign object record
           // contactIds - set of contact ids                          
           List<Campaign_Member_Assignment__c> cMAList = new List<Campaign_Member_Assignment__c>();
           
           if(contactIds == null){
               contactIds = new Set<Id>();
               cMAList = CM_CampaignDataUtil.getCampaignMemberAssignmentforCurrentUser(campaignId);     
               
               for(Campaign_Member_Assignment__c cMA : cMAList){
                 contactIds.add(cMA.GPSContact__c);
               }
           }
           
           List<Campaign_Member__c> campaignMemberList  =[Select  c.HasResponded__c, c.GPSContact__c, c.Campaign__r.End_Date__c, c.Campaign__r.CreatedById, c.Campaign__r.Name, c.Campaign__c, c.Id, c.GPSContact__r.Id, c.Campaign_Score__c, c.GPSContact__r.GPSAccount__r.Name, c.GPSContact__r.GPSAccount__r.Id, c.GPSContact__r.FirstName__c,
                                                 c.GPSContact__r.LastName__c, c.GPSContact__r.Email__c, c.Status__c, c.Reason__c,c.GPSContact__r.Prefer_Business_Phone__c, c.GPSContact__r.Prefer_Mobile_Phone__c,
                                                 c.GPSContact__r.Phone__c,c.GPSContact__r.Mobile__c, c.GPSContact__r.HomePhone__c  from Campaign_Member__c c
                                                 where c.Campaign__c = : campaignId and c.GPSContact__c in : contactIds order by GPSContact__r.LastName__c ASC LIMIT : CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT];
                                                 
       return campaignMemberList;                
    }// end of getCampaignMembersforCurrentUser(Id campaignId)
    
    public static List<Campaign_Member__c> getAllCampaignMembers(Id campaignId){
          List<Campaign_Member__c> campaignMemberList  = CM_CampaignDataUtil.getCampaignMembersList(null, campaignId);                                                 
      return campaignMemberList; 
    }
    
    public static Campaign_Member__c getCampaignMemberDetail(String campaignMemberId) {
        List<Id> campaignMemberIds = new List<Id>();
        List<Campaign_Member__c> CMList = new  List<Campaign_Member__c>(); 
        campaignMemberIds.add(campaignMemberId);
        CMList = CM_CampaignDataUtil.getCampaignMembersList(campaignMemberIds);
        if(CMList.size() > 0) {
            return CMList[0];
        }
        return null;
    }
    public static List<Campaign_Member__c> getCampaignMembersList(List<Id> campaignMemberIds){
     return CM_CampaignDataUtil.getCampaignMembersList(campaignMemberIds, null);  
  }
  
  
  public static List<Campaign_Member__c> getCampaignMembersList(List<Id> contactIds, Id campaignId){
     List<Campaign_Member__c> campaignMemberList = new List<Campaign_Member__c>();     
     if(campaignId == null && contactIds <> null){
        
        campaignMemberList = [Select Id, GPSContact__r.Id, Campaign__r.Id from Campaign_Member__c where Id in : contactIds LIMIT : CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT];
        return campaignMemberList;
              
     }else if(campaignId <> null && contactIds == null){
        
        campaignMemberList = [Select Id, Campaign__r.Id, GPSContact__r.Id from Campaign_Member__c where
                              Campaign__r.Id = : campaignId LIMIT : CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT];
        return campaignMemberList;
                
     }else{
        
       campaignMemberList = [Select Id, Campaign__r.Id, GPSContact__r.Id from Campaign_Member__c where
                                                GPSContact__r.Id in : contactIds and Campaign__r.Id = : campaignId LIMIT : CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT];
       return campaignMemberList;
       
     }
     return null;
  }
  
  
  public static List<Task> getIncomingRequestsForCurrentUser(Id campaignId, Id requestId){
    //Get List of tasks for current user
    // campaignId - salesforce id of campaign object record
    List<Task> taskList = new List<Task>();
    Map<Id,Task> contactMap = new Map<Id,Task>();   
    
    
    taskList = [select IsClosed, Id, Status, GPS_Contact__c 
                    from Task 
                    where WhatId = : campaignId AND IsClosed = false AND ownerId =: Userinfo.getUserId() 
                        and CreatedById =: UserInfo.getUserId() and id = : requestId];
      // To check that we have list of task for unique contacts/ no duplicate contacts are allowed.
    for(task tsk : taskList) {
      if(!contactMap.containsKey(tsk.GPS_Contact__c)) {
         contactMap.put(tsk.GPS_Contact__c,tsk);
      }
    }
    
    return contactMap.values();
    
  }//end of getIncomingRequestsForCurrentUser(Id campaignId)
  
    
    public static List<Task> getIncomingRequestsForCurrentUser(Id campaignId){
        //Get List of tasks for current user
        // campaignId - salesforce id of campaign object record
        List<Task> taskList = new List<Task>();
        Map<Id,Task> contactMap = new Map<Id,Task>();       
        list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	     }
        taskList = [select IsClosed, Id, Status, GPS_Contact__c from Task where RecordTypeId = :getTaskRecordtypeId() and GPS_Contact__c <> null and WhatId = : campaignId AND IsClosed = false AND ownerId =: loggedInUserid  order by LastModifiedDate DESC];
        // To check that we have list of task for unique contacts/ no duplicate contacts are allowed.
        for(task tsk : taskList) {
            if(!contactMap.containsKey(tsk.GPS_Contact__c)) {
                contactMap.put(tsk.GPS_Contact__c,tsk);
            }
        }
        return contactMap.values();
        
    }//end of getIncomingRequestsForCurrentUser(Id campaignId)
    
    
    public static User getCurrentLogUser(){
        list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c != '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	        }
        } else{
        	 loggedInUserid = Userinfo.getUserId();
        }
        
        for(User u :[Select Id, UserRole.Name, u.TimeZoneSidKey,u.Profile.Name, u.ProfileId,Emp_ID__c, u.Name ,FirstName, Preferred_Name__c, LastName
                     ,Email From User u where id=:loggedInUserid limit 1]){
             curentLogUser = u;
       }
       return curentLogUser;
    }
    
    public static Map<Id, GPSContact__c> getContactMap(Set<Id> contactIds, Id campaignId){
        //get map of contact with required details from contact object
        // contactIds - set of salesforce contact object ids
        User currentUser = CM_CampaignDataUtil.getCurrentLogUser();
        String thisUserMSId = currentUser.Emp_ID__c;
        
        //TODO: Review the update. Made by Andrey to address a bug (inactive contacts were sent as nulls to RequestWrapper and it failed to initialize)
        //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.  
        /*Map<Id, Contact> contactMap = new Map<Id, Contact>([Select (Select Campaign_Score__c From CampaignMembers where CampaignId = : campaignId limit 1),(Select Id from Priority_Contacts__r where MS_Id__c = :thisUserMSId and Relationship_Type__c = 'P' AND Active_Flag__c = true LIMIT 1),
           c.Id,c.Prefer_Mobile_Phone__c, c.Prefer_Business_Phone__c, c.PreferMobile_Phone__c, c.PreferBusiness_Phone__c,
           c.Phone, c.OtherPhone, c.Name, c.MobilePhone, c.Is_Priority_Contact__c, c.HomePhone, c.Email, c.AssistantPhone, 
           c.Account.Name,c.FirstName,c.LastName  
            From Contact c 
            where Id IN :contactIds /*and c.Active_Flag__c = true*/ //LIMIT : CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT]);*/
      
       Map<Id, GPSContact__c> contactMap = new Map<Id, GPSContact__c>([Select (Select Campaign_Score__c From Campaign_Member__r where Campaign__c = : campaignId limit 1),(Select Id from Priority_Contacts__r where MS_Id__c = :thisUserMSId and Relationship_Type__c = 'P' AND Active_Flag__c = true LIMIT 1),
           c.Id,c.Prefer_Mobile_Phone__c, c.Prefer_Business_Phone__c, 
           c.Phone__c, c.Name, c.Mobile__c, c.Is_Priority_Contact__c, c.HomePhone__c, c.Email__c,
           c.GPSAccount__r.Name, c.FirstName__c, c.LastName__c  
            From GPSContact__c c 
            where Id IN :contactIds /*and c.Active_Flag__c = true*/ LIMIT : CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT]);      
      
      if(contactMap.size() > 0) {
            return contactMap;
      }
        return null;
    } //end of getContactList(Set<Id> contactIds)
    
    
    
    
    
    public static List<GPSContact__c> getSearchContacts(String searchString) {
        //get the list of the contacts to be search for quick add
        //campaignMemberContactIds - Set of the contactIds already aadded in the campaign member list
        // searchString - Name of the Account/Contact to be searched
        String searchCondition = '';
        List<GPSContact__c> contactList = new List<GPSContact__c>();
        List<String> searchNameList = new List<String>();
        
        searchString = CM_CampaignDataUtil.replaceSpecialCharacters(searchString);
                
        searchNameList = searchString.split('\\s+');
        
        // To get the exact match first in the list
        if(searchNameList.size() == 2){
             String equalCondition = '((FirstName__c = \'' + searchNameList[0] + '\' and LastName__c = \'' + searchNameList[1] + '\' )';
             equalCondition += ' OR (FirstName__c = \'' + searchNameList[1] + '\' and LastName__c = \'' + searchNameList[0] + '\' ))'; 
             String query = 'select FirstName__c, LastName__c, Id, GPSAccount__r.Name from GPSContact__c where  ' +
            ' ' + equalCondition  +' and Active_Flag__c = true LIMIT ' + CM_CampaignDataUtil.SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT + '';
       //getting the list of the contacts for quick add
       contactList.addAll((List<GPSContact__c>) Database.Query(query));
        }
        
        // then add other matches to the list
        for(String  s : searchNameList) {
            String startsWith = s + '%';
            String startsWithAndContains = '% ' + s;
            searchCondition += ' FirstName__c like \'' + startsWith + '\' OR LastName__c like \'' + startsWith + '\' OR Account_Name__c like \'' + startsWith + '\' OR Account_Name__c like \'' + startsWithAndContains + '\' OR ';
        } 
        searchCondition  = searchCondition.substring(0,searchCondition.lastIndexOf(' OR ') );
        
        String query = 'select FirstName__c, LastName__c, Id, GPSAccount__r.Name from GPSContact__c where ' +
                        ' (' + searchCondition  +') and Active_Flag__c = true and Id not in : contactList LIMIT ' + CM_CampaignDataUtil.SEARCH_CAMPAIGN_MEMBERS_CONTACTS_LIMIT + '';
        //getting the list of the contacts for quick add
        contactList.addAll((List<GPSContact__c>) Database.Query(query));
        
        return contactList;
    }
    
    public static List<Campaign_Team_Member__c> getCampaignParticipants(Id campaignId){
         return CM_CampaignDataUtil.searchCampaignParticipants(campaignId, null);         
    }
    
    public static List<AggregateResult> searchCampaignParticipantsByGrouping(Id campaignId, String searchString){     
     // To get the list of campaign participant users for  a campaign and on search string    
     List<AggregateResult> lstCTM = new List<AggregateResult>();
     String searchCondition = '';
     List<String> searchNameList = new List<String>();
     
     searchString = CM_CampaignDataUtil.replaceSpecialCharacters(searchString);          
     searchNameList = searchString.split('\\s+');
     
     if(searchNameList.size() == 2){
         String equalCondition = '((User__r.Preferred_Name__c = \'' + searchNameList[0] + '\' and User__r.LastName = \'' + searchNameList[1] + '\' )';
         equalCondition += ' OR (User__r.Preferred_Name__c = \'' + searchNameList[1] + '\' and User__r.LastName = \'' + searchNameList[0] + '\' ))'; 
         
         String query = 'Select  c.User__r.CompanyName companyName, c.User__r.Name userName, c.User__r.FirstName firstName, c.User__r.Preferred_Name__c preferredName, c.User__r.LastName lastName, c.User__r.Id userId From Campaign_Team_Member__c c group by c.User__r.CompanyName, c.User__r.Name, c.User__r.FirstName, c.User__r.Preferred_Name__c, c.User__r.LastName, c.User__r.Id, c.Campaign__c,c.User__r.isActive ' +
              'having c.Campaign__c = :campaignId AND c.User__r.isActive = true AND ' + equalCondition  +' order by User__r.LastName ASC LIMIT 1';
         
         lstCTM.addAll((List<AggregateResult>) Database.Query(query));
     }
     
     for(String  s : searchNameList) {
        String startsWith = s + '%';
        String startsWithAndContains = '% ' + s;
        searchCondition += ' User__r.Preferred_Name__c like \'' + startsWith + '\' OR User__r.LastName like \'' + startsWith + '\' OR User__r.Preferred_Name__c like \'' + startsWithAndContains + '\' OR User__r.LastName like \'' + startsWithAndContains + '\' OR ';
     } 
     searchCondition  = searchCondition.substring(0,searchCondition.lastIndexOf(' OR ') ); 
     
     String query = 'Select  c.User__r.CompanyName companyName, c.User__r.Name userName, c.User__r.FirstName firstName, c.User__r.Preferred_Name__c preferredName, c.User__r.LastName lastName, c.User__r.Id userId From Campaign_Team_Member__c c group by c.User__r.CompanyName, c.User__r.Name, c.User__r.FirstName, c.User__r.Preferred_Name__c, c.User__r.LastName, c.User__r.Id, c.Campaign__c,c.User__r.isActive ' +
            'having c.Campaign__c = :campaignId AND c.User__r.isActive = true AND (' + searchCondition  +')  order by User__r.LastName ASC LIMIT ' + CM_CampaignDataUtil.SEARCH_CAMPAIGN_USERS_LIMIT + '';
     
             
     lstCTM.addAll((List<AggregateResult>) Database.Query(query));
         
     return lstCTM;
  }
    
    
    public static List<Campaign_Team_Member__c> searchCampaignParticipants(Id campaignId, String searchString){      
     // To get the list of campaign participant users for  a campaign and on search string      
         List<Campaign_Team_Member__c> lstCTM = new List<Campaign_Team_Member__c>();
     String searchCondition = '';
     List<String> searchNameList = new List<String>();
     
         if(searchString == null){
                return [Select c.User__r.CompanyName, c.User__r.Name, c.User__r.FirstName, c.User__r.Preferred_Name__c,
          c.User__r.LastName, c.User__r.Id, c.User__c, c.Role__c, c.Name, c.Campaign__c, 
          c.Campaign_Access_Level__c From Campaign_Team_Member__c c where c.Campaign__c = : campaignId 
          and c.User__r.isActive = true and c.Role__c = 'Participant'];         
         }
         
       searchString = CM_CampaignDataUtil.replaceSpecialCharacters(searchString);
            
       searchNameList = searchString.split('\\s+');
       if(searchNameList.size() == 2){
           String equalCondition = '((User__r.Preferred_Name__c = \'' + searchNameList[0] + '\' and User__r.LastName = \'' + searchNameList[1] + '\' )';
           equalCondition += ' OR (User__r.Preferred_Name__c = \'' + searchNameList[1] + '\' and User__r.LastName = \'' + searchNameList[0] + '\' ))'; 
           
           String query = 'Select c.User__r.CompanyName, c.User__r.Name, c.User__r.FirstName, c.User__r.Preferred_Name__c, c.User__r.LastName, c.User__r.Id, c.User__c From Campaign_Team_Member__c c where c.Campaign__c = : campaignId and c.User__r.isActive = true ' +
                ' AND ' + equalCondition  +' order by User__r.LastName ASC LIMIT 1';
           
           lstCTM.addAll((List<Campaign_Team_Member__c>) Database.Query(query));
       }
       
       for(String  s : searchNameList) {
          String startsWith = s + '%';
          String startsWithAndContains = '% ' + s;
          searchCondition += ' User__r.Preferred_Name__c like \'' + startsWith + '\' OR User__r.LastName like \'' + startsWith + '\' OR User__r.Preferred_Name__c like \'' + startsWithAndContains + '\' OR User__r.LastName like \'' + startsWithAndContains + '\' OR ';
       } 
       searchCondition  = searchCondition.substring(0,searchCondition.lastIndexOf(' OR ') ); 
         
         String query = 'Select c.User__r.CompanyName, c.User__r.Name, c.User__r.FirstName, c.User__r.Preferred_Name__c, c.User__r.LastName, c.User__r.Id, c.User__c From Campaign_Team_Member__c c where c.Campaign__c = : campaignId and c.User__r.isActive = true ' +
            ' AND (' + searchCondition  +') and Id not in : lstCTM order by User__r.LastName ASC LIMIT ' + CM_CampaignDataUtil.SEARCH_CAMPAIGN_USERS_LIMIT + '';
         
                         
         lstCTM.addAll((List<Campaign_Team_Member__c>) Database.Query(query));
         
         Map<Id, Campaign_Team_Member__c> cTMMap = new Map<Id, Campaign_Team_Member__c>();
     
     for(Campaign_Team_Member__c cTM : lstCTM){
       if(!cTMMap.containsKey(cTM.User__r.Id)){
          cTMMap.put(cTM.User__r.Id, cTM);
       }
     }
                 
         return cTMMap.values();
    }
    
    public static List<Campaign_Team_Member__c> getCampaignTeamMemberImportedList(Id userId, Id campaignId){
    return [Select c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c
                                                where c.User__c = :userId and c.Campaign__c = : campaignId and c.Imported_Target_List__c = true order by 
                                                c.Campaign__c, c.Campaign_Access_Level__c DESC];                                                
                                                // USED DESC BECAUSE IN SALESFORCE ORDER BY SOME PICKLIST WORKS DIFFERENTLY
  }
   //12/27/2011 UV : addded this method 
   public static List<Campaign_Team_Member__c> getCampaignTeamMemberList(Set<String> userIds, Set<String> campaignIds){
        return [Select c.Campaign__r.External_Id__c, c.User__r.Emp_ID__c, c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c
                                                where c.User__r.Emp_ID__c in :userIds and c.Campaign__r.External_Id__c in : campaignIds order by 
                                                c.Campaign__c, c.Campaign_Access_Level__c DESC];                                                
                                                // USED DESC BECAUSE IN SALESFORCE ORDER BY SOME PICKLIST WORKS DIFFERENTLY
    }
    
    public static List<Campaign_Team_Member__c> getCampaignTeamMemberList(Set<Id> userIds, Set<Id> campaignIds){
        return [Select c.Imported_Target_List__c, c.User__c, c.Campaign_Access_Level__c, c.Campaign__c, c.Role__c, Composite_Key__c From Campaign_Team_Member__c c
                                                where c.User__c in :userIds and c.Campaign__c in : campaignIds order by 
                                                c.Campaign__c, c.Campaign_Access_Level__c DESC];                                                
                                                // USED DESC BECAUSE IN SALESFORCE ORDER BY SOME PICKLIST WORKS DIFFERENTLY
    }

  public static List<Campaign_Team_Member__c> getCampaignTeamMemberList(Set<Id> userIds, Id campaignId){
    Set<Id> campaignIds = new Set<Id>();
    campaignIds.add(campaignId);
    return CM_CampaignDataUtil.getCampaignTeamMemberList(userIds, campaignIds);         
  }
  
  public static List<Campaign_Team_Member__c> getCampaignTeamMemberList(Id userId, Id campaignId){
    Set<Id> userIds = new Set<Id>();
    userIds.add(userId);    
    return CM_CampaignDataUtil.getCampaignTeamMemberList(userIds, campaignId);                                                
  }
    
    //03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
    //public static List<CampaignShare> getManualCampaignShareList(Set<Id> userIds, Id campaignId){
    public static List<Campaign__Share> getManualCampaignShareList(Set<Id> userIds, Id campaignId){
        Set<Id> campaignIds = new Set<Id>();
        campaignIds.add(campaignId);        
        return CM_CampaignDataUtil.getManualCampaignShareList(userIds, campaignIds);
    }
    
    //03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
    //public static List<CampaignShare> getManualCampaignShareList(Set<Id> userIds, Set<Id> campaignIds){
    public static List<Campaign__Share> getManualCampaignShareList(Set<Id> userIds, Set<Id> campaignIds){
    //03/04/2016 AT: Moving to Platform Licenses, replacing CampaignShare standard object with Campaign__Share custom objects.
    /*return [Select c.UserOrGroupId, c.RowCause, c.CampaignId, 
                                            c.CampaignAccessLevel From CampaignShare c where c.RowCause = : Schema.CampaignShare.RowCause.Manual and 
                                            c.UserOrGroupId in : userIds and c.CampaignId in : campaignIds order by c.CampaignId, c.CampaignAccessLevel DESC];*/
    return [Select c.UserOrGroupId, c.RowCause, c.ParentId, 
                                            c.AccessLevel From Campaign__Share c where c.RowCause = : Schema.Campaign__Share.RowCause.Manual and 
                                            c.UserOrGroupId in : userIds and c.ParentId in : campaignIds order by c.ParentId, c.AccessLevel DESC];                                
                                            // USED DESC BECAUSE IN SALESFORCE ORDER BY SOME PICKLIST WORKS DIFFERENTLY
  }
  public static List<String> getCampignMemberStatus(String campaignId) {
    // To get the list of campaign member statuses for a selected campaign
    // campaignId - campaign record salesforce id  
    List<String> campignMemberStatuses = new List<String>();
    //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.  
    /*for(CampaignMember cm : [Select status from CampaignMember where CampaignId = :campaignId]) {
        campignMemberStatuses.add(cm.Status);
    }*/
    
    for(Campaign_Member__c cm : [Select status__c from Campaign_Member__c where Campaign__c = :campaignId]) {
        campignMemberStatuses.add(cm.Status__c);
    }
    return campignMemberStatuses;
  }
  
  
  
  // data utilities for CM_CampaignNotificationManager
  public static List<RecordType> getTaskActiveRecordTypes(){
    // To get the list of active record types associated with 'Task' object.
    
    List<RecordType> taskRecordTypes = new List<RecordType>();
     
    taskRecordTypes = [Select DeveloperName, Id From RecordType where sObjectType='Task' and isActive=true];
    
    if(taskRecordTypes.size() == 0){
        throw new CM_CustomException(CM_CampaignDataUtil.CampaignRequestRecordTypeException, 'RecordType');
    }
    
    return taskRecordTypes;
  }
  
  public static List<GPSContact__c> getAccountIdsOfContacts(Set<Id> contactMemberIdSet){
    // This function return associated account ids in contact list 
    // contactMemberIdSet - set of contact Ids 
    List<GPSContact__c> contactList = new List<GPSContact__c>();
    
    contactList = [Select Id, GPSAccount__c From GPSContact__c where id in :contactMemberIdSet];
    
    return contactList;
  }
  public static RecordType getRecordTypeOnObjectAndDeveloperName(String sObjectType, String DeveloperName){
    // This function returns record type for given sObjectType and DeveloperName.
    List<RecordType> taskRecordTypes = new List<RecordType>();
    
    taskRecordTypes = [Select Id, DeveloperName 
                        From RecordType 
                                             where sObjectType =: sObjectType and 
                                             isActive=true and DeveloperName = :DeveloperName LIMIT 1];
     
    
    if(taskRecordTypes.size() == 0){
        throw new CM_CustomException('No Record Type exists for sObject :' + sObjectType + ' and  DeveloperName:' + DeveloperName, 'RecordType');
    }
    
    return taskRecordTypes[0];     
  }
  
 /* Commented by Sudarshan K. 17th Feb 2016 while campaign migration
  public static App__c getAppIdOnCodeName(String CODE_NAME){
    // This function gives the app object's app.id on code name
    // CODE_NAME: code name of an app.
    
    List<App__c> apps = new List<App__c>();
    apps = [Select a.CodeName__c, a.Id 
            From App__c a 
            where a.CodeName__c = :CODE_NAME Limit 1];
    
    if(apps.size() == 0){
         throw new CM_CustomException('No record exists for CodeName :' + CODE_NAME, 'App__c');         
    } 
    
    return apps[0];       
    
  }*/
  
  // data utilities for CM_Metrics
  public static List<Campaign__c> getCampaignRollUpValues(Id campaignId){
    // This function returns list of campaign rollup field values
    // campaignId - campaign record salesforce id   
    return [Select  c.Total_Feedback_Items__c, c.NumberOfResponses__c
            From Campaign__c c 
            where c.id = : campaignId limit 1];
  }
  
  public static List<Campaign_Member_Assignment__c> getContactIdsOnCMAForCampaign(Id userId, Id campaignId){  
    // This function return CMA contact ids list for a campaign and user
    // campaignId - campaign record salesforce id  
    // userId - salesforce user id
     
   return  [Select GPSContact__c 
     from Campaign_Member_Assignment__c 
     where GPSContact__c <> null and Assigned_To__c = : UserId 
     and Campaign__c = : campaignId];
  }
  
  public static Integer getCampaignResponsesCount(Id campaignId, Set<Id> contactIds){
    // This function return the count of a campign responses for a campaign and selected campaign members
    // campaignId - campaign record salesforce id 
    // contactIds - ids of campaign member for a campaign 
    Integer responses = 0;
    //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.  
    /*responses = [Select count() 
                 from CampaignMember 
                 where CampaignId = : campaignId and HasResponded = true 
                 and ContactId in : contactIds];*/
    responses = [Select count() 
                 from Campaign_Member__c 
                 where Campaign__c = : campaignId and HasResponded__c = true 
                 and GPSContact__c in : contactIds];
    return responses;
  }
  
  
  public static Integer getIncomingRequestsCount(Id campaignId, Id UserId){
    // This function return the count of incoming requests for given user and campaign
    // campaignId - campaign record salesforce id  
    // userId - salesforce user id
    Integer incomingRequests = 0;
    
    incomingRequests = [Select count()  
                                                From Task t 
                                                where t.WhatId = : campaignId and t.IsClosed = false 
                               and t.ownerId =: UserId and 
                               t.RecordtypeId = :CM_CampaignDataUtil.getTaskRecordTypeId()];
                               
    return incomingRequests;                            
                               
  }                             
  
  
  public static Integer getPendingRequestsCount(Id campaignId, Id UserId){
     // This function returns the count of pending requests for given user and campaign
     // campaignId - campaign record salesforce id  
     // userId - salesforce user id
     Integer pendingRequests = 0;
     
     pendingRequests = [Select count()  
                                             From Task t 
                                             where t.WhatId = : campaignId and t.IsClosed = false 
                                             and t.CreatedById =: UserId 
                                             and t.RecordtypeId = :CM_CampaignDataUtil.getTaskRecordTypeId()];
                                             
                                             
            return pendingRequests;                              
    
  }
  
  // data utilities for campaign milestones
  public static List<Campaign_Milestone__c> getCampaignMilestones(Id campaignId){
  // This function returns the details of campaign milestones for a campaign
  // campaignId - campaign record salesforce id 
    return [select Name, Description__c, Date__c 
            from Campaign_Milestone__c 
            where Campaign__c = :campaignId order by Date__c desc];    
  } 
  
  // data utilities for campaign materials.
  public static List<Attachment> getCampaignMaterials(Id campaignId, Integer showCount){
  // This method returns all the attachment names ordering by their created date(Returns campaign materials) 
  // campaignId - campaign record salesforce id 
  // showCount - no of records to be retrieved
    
    if(showCount == null){
        return [Select Name from Attachment where parentId = :campaignId order by createddate asc];
    } else{
      return [Select Name from Attachment where parentId = :campaignId order by createddate asc limit :showCount];
    } 
    
  }  
 /** 
 UV : commented this code as currently it is not implemented
  public static Set<Id> getSharedUserIdsForCampaign(Id campaignId) {
     //method to get the User maually shared with campaign 
     // campaignId - Id of the campaign which is shared 
    Set<Id> userIds = new Set<Id>();
    Set<Id> groupIds = new Set<Id>();
    // query all the share records 
    List<CampaignShare> sharedUsersList = [Select c.UserOrGroupId, c.CampaignId From CampaignShare c where CampaignId = :campaignId];
    // seprates on the basis of user and groups
    for(CampaignShare cs : sharedUsersList) {
        if(cs.UserOrGroupId <> null && String.valueOf(cs.UserOrGroupId).startsWith('00G')) {
            groupIds.add(cs.UserOrGroupId);
        } else if (cs.UserOrGroupId <> null && String.valueOf(cs.UserOrGroupId).startsWith('005')) {
            userIds.add(cs.UserOrGroupId);
        }
    }
    userIds.addAll(CM_CampaignDataUtil.getUsersFromGroup(groupIds,userIds));
    return userIds;
  } //end of getSharedUserIdsForCampaign(Id campaignId) 

   private static Set<Id> getUsersFromGroup(Set<Id> groupIds, Set<Id> userIds){
        // Recirsive Method to get all the members that exixts in the group shared with campaign
        // groupIds  - Ids of the group which is shared with campaign
        //  userIds  - this parameters will maintain the ids of the users shared with camapign by group or role 
        Set<Id> userRoleIds = new Set<Id>();
        List<User> userList = new List<User>();
        List<Group> grpList = new List<Group>();
        List<GroupMember> GMList = [select GroupId,UserOrGroupId,Group.Type 
                                        from GroupMember 
                                        where GroupId IN :groupIds];
                                        
        // if the campaign is shared with group
        if(GMList.size() > 0) { 
            groupIds = new Set<Id>();
            for(GroupMember gm : GMList) {
              if(gm.UserOrGroupId <> null && String.valueOf(gm.UserOrGroupId).startsWith('00G')) {
                groupIds.add(gm.UserOrGroupId);
              } else if (gm.UserOrGroupId <> null && String.valueOf(gm.UserOrGroupId).startsWith('005')) {
                userIds.add(gm.UserOrGroupId);
              }
             
            }
            // Recursive call is nested group is exists
            if(groupIds.size() > 0) {
              userIds.addAll(CM_CampaignDataUtil.getUsersFromGroup(groupIds,userIds));
            }
        } else if(groupIds.size() > 0) { // if campaign is shared with role
            grpList = [select type, relatedId 
                                    from group 
                                    where id IN : groupIds];
            for(Group gp :grpList) {
                if(gp.relatedId <> null)
                userRoleIds.add(gp.relatedId);
            }
        }
        // as capaign is shared with all users with same role 
        userRoleIds.add(userInfo.getUserRoleId());
        System.debug('____________userRoleIds___________' + userRoleIds);
        // get all users which can have access on the role basis sharing
        if(userRoleIds.size() > 0) {
            userLIst = [select id from user where UserRoleId IN :userRoleIds and isActive = true];
            for(User usr : userList) {
                userIds.add(usr.id);
            }
        }
        return userIds;
      }// end of getUsersFromGroup(Set<Id> groupIds, Set<Id> userIds)*/
     
      
  
  //public static List<Campaign> getFilteredCampaignsList(String Status, String Region){
    //// 03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.
    public static List<Campaign__c> getFilteredCampaignsList(String Status, String Region){  
      // This method is used to get the filtered campaigns by their status and region passed as parameter values. 
      // As in this method webservice is used because it is faster that SOQL QUERIES thats why it is used on the Campaigns page 
      // to filter the campaigns. 
      //List<Campaign> lstCampaigns = new List<Campaign>();03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.
       // Added code for custom login as functionality 
            list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
            String loggedInUserid = '';
            boolean isAdminProfile = false;
            if(!loggedin.isEmpty()){
	            if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c != '' ){
	                loggedInUserid = loggedin[0].Login_As_User__c;
	            } else{
	                loggedInUserid = Userinfo.getUserId();
	                //isAdminProfile = true;
	            }
            }
            else{
            	loggedInUserid = Userinfo.getUserId();
            	 //isAdminProfile = true;
            }
            List<User> lstUser = [SELECT Id, UserName,Profile.Name FROM User WHERE IsActive = true AND Id = :loggedInUserId];
            if(!lstUser.isEmpty()){
                /*if(lstUser[0].Profile.Name =='System Administrator Classic' || lstUser[0].Profile.Name =='System Administrator' )
                {
                    isAdminProfile = true;
                }*/
                    loggedInUserId = lstUser[0].Id;
                  
            }else{
                loggedInUserId = System.Userinfo.getUserId();
                //isAdminProfile = true;
            }
            
            list<PermissionSetAssignment> listPermision = new list<PermissionSetAssignment>();
	        listPermision = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE Assignee.Id =:loggedInUserId];
	        
	        for(PermissionSetAssignment usrper : listPermision){
	            if(usrper.PermissionSet.Name == 'Campaign_Admin'){
	                isAdminProfile = true;     
	                break;
	            }   
	        }
          List<Campaign__c> lstCampaigns = new List<Campaign__c>();
          List<Campaign__c> camplist  = new List<Campaign__c>();
          Integer CBM_LIMIT_LOCAL = CM_CampaignDataUtil.CBM_LIMIT;
          String whereQuery = '';
        
          if(Region <> 'All'){
              whereQuery = ' AND Region__c = \'' + Region + '\'';  
          }
        // 03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.
          /*if(Status <> 'All'){
              whereQuery += ' AND Status = \'' + Status + '\'';  
          }*/
          
           if(Status <> 'All'){
              whereQuery += ' AND Status__c = \'' + Status + '\'';  
          }
        
          Id userId = Userinfo.getUserId();
          // 03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.                               
          /*lstCampaigns = (List<Campaign>)Database.query('Select c.Status, c.Region__c, c.Name, c.IsActive, c.Id From Campaign c where c.Status <> \'Hidden\'' + 
                                         ' and c.IsActive = true ' +  whereQuery + ' order by c.Name ' + 
                                         ' asc limit : CBM_LIMIT_LOCAL' );*/
          
          lstCampaigns = (List<Campaign__c>)Database.query('Select c.Status__c, c.Region__c, c.Name, c.Active__c, c.Id From Campaign__c c where c.Status__c <> \'Hidden\'' + 
                                         ' and c.Active__c = true ' +  whereQuery + ' order by c.Name ' + 
                                         ' asc limit : CBM_LIMIT_LOCAL' );
                                     
          map<Id, Campaign__c> campaignMap = new map<Id, Campaign__c>();
          
          campaignMap.putAll(lstCampaigns);
          
          if(isAdminProfile){
            
            camplist = lstCampaigns;
                
          } else{
            for(Campaign__share camShare : [Select Id, ParentId From Campaign__share WHERE IsDeleted = false AND UserOrGroupId =: loggedInUserId]){
            			if(campaignMap.containsKey(camShare.ParentId))
                        camplist.add(campaignMap.get(camShare.ParentId));
              }
         }
        
                                                                   
      //return lstCampaigns;
      return camplist;
  }
  
  
  public static List<Campaign_Team_Member__c> getCampaignMembersAutoFollowingCampaign(List<Campaign_Team_Member__c> ctmList){
    
    Set<Id> campaignIds = new Set<Id>();   
    Set<Id> campaignAutoFollowingIds = new Set<Id>();
    List<Campaign_Team_Member__c> autoFollowingCTMList = new List<Campaign_Team_Member__c>();
    
    
     
    for(Campaign_Team_Member__c ctm : ctmList){       
      if(!campaignIds.contains(ctm.Campaign__c)){
        campaignIds.add(ctm.Campaign__c);
      }      
    }
   
    List<Campaign__c> campaignList = [Select Id from Campaign__c where id in : campaignIds and
                          Auto_Subscribe_Participant_To_Campaign__c = true LIMIT : CM_CampaignDataUtil.CAMPAIGN_MEMBER_LIST_LIMIT];
                          
    
    for(Campaign__c camp : campaignList){
        campaignAutoFollowingIds.add(camp.id);      
    }
    
    
    for(Campaign_Team_Member__c ctm : ctmList){       
      if(campaignAutoFollowingIds.contains(ctm.Campaign__c)){
        autoFollowingCTMList.add(ctm);
      }      
    }    
    
    return autoFollowingCTMList;
  }
  
  public static List<Campaign_Notification__c> getCampaignNotificationListOnTaskId(Set<String> tskIdList) {
    
    List<Campaign_Notification__c> cnList = new List<Campaign_Notification__c>();
    cnList = [select status__c,InActiveDate__c,IsActive__c, taskId__c
                 from Campaign_Notification__c
                 where InActiveDate__c = null AND IsActive__c = true AND taskId__c IN :tskIdList];
    return cnList;
  }
  
  public static List<CM_Campaigns_WS.PhoneNumber> getContactPhoneList(GPSContact__c contactMember){
        List<CM_Campaigns_WS.PhoneNumber> contactPhone = new List<CM_Campaigns_WS.PhoneNumber>();      
       // List<String> phoneTypes = new List<String>{'Prefer_Business_Phone', 'Prefer_Mobile_Phone', 'Contact_Phone', 'Mobile_Phone', 'Assistant_Phone', 'Home_Phone', 'Other_Phone', 'Default_Phone'};
        List<String> phoneTypes = new List<String>{'Prefer_Business_Phone', 'Prefer_Mobile_Phone', 'Contact_Phone', 'Mobile_Phone', 'Home_Phone', 'Default_Phone'};  
        Set<String> phoneNumberSet = new Set<String>();
        contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[5], ''));
                         
        // set other phone numbers in array
        // pref business phone
        if(contactMember.Prefer_Business_Phone__c != null && contactMember.Prefer_Business_Phone__c != '' && !phoneNumberSet.contains(contactMember.Prefer_Business_Phone__c)){
            contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[0], contactMember.Prefer_Business_Phone__c));
            phoneNumberSet.add(contactMember.Prefer_Business_Phone__c);
        }
        // pref mobile phone
        if(contactMember.Prefer_Mobile_Phone__c != null && contactMember.Prefer_Mobile_Phone__c != '' && !phoneNumberSet.contains(contactMember.Prefer_Mobile_Phone__c)){
            contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[1], contactMember.Prefer_Mobile_Phone__c));
            phoneNumberSet.add(contactMember.Prefer_Mobile_Phone__c);
        }
        // contact phone
        if(contactMember.Phone__c != null && contactMember.Phone__c != '' && !phoneNumberSet.contains(contactMember.Phone__c)){
            contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[2], contactMember.Phone__c));
            phoneNumberSet.add(contactMember.Phone__c);
        }
        // mobile phone
        if(contactMember.Mobile__c != null && contactMember.Mobile__c != '' && !phoneNumberSet.contains(contactMember.Mobile__c)){
            contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[3], contactMember.Mobile__c));
            phoneNumberSet.add(contactMember.Mobile__c);
        }
        // assist phone
        /*if(contactMember.AssistantPhone != null && contactMember.AssistantPhone != '' && !phoneNumberSet.contains(contactMember.AssistantPhone)){
            contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[4], contactMember.AssistantPhone));
            phoneNumberSet.add(contactMember.AssistantPhone);
        }*/
        // home phone
        if(contactMember.HomePhone__c != null && contactMember.HomePhone__c != '' && !phoneNumberSet.contains(contactMember.HomePhone__c)){
            contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[4], contactMember.HomePhone__c));
            phoneNumberSet.add(contactMember.HomePhone__c);
        }
        // other phone
       /* if(contactMember.OtherPhone != null && contactMember.OtherPhone != '' && !phoneNumberSet.contains(contactMember.OtherPhone)){
            contactPhone.add(new CM_Campaigns_WS.PhoneNumber(phoneTypes[6], contactMember.OtherPhone));
            phoneNumberSet.add(contactMember.OtherPhone);
        }*/
        
        // default phone        
        if(contactPhone.size() > 1){
          contactPhone.set(0, new CM_Campaigns_WS.PhoneNumber(phoneTypes[5], contactPhone[1].phoneNumber));
        }
        
        return contactPhone;
       //return null;
   }
   //12/26/2011 UV: Added this method to get campaign Members from external id of campaign and TN_Contact_Key__c of contacts
   //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.  
   /*public static List<CampaignMember> getCampaignMemberList(set<String> campaignIds, Set<String> contactIds) {
    List<CampaignMember> cmList = new List<CampaignMember>();
    cmList = [select Status, Campaign.External_Id__c,Contact.TN_Contact_Key__c,System_Assigned_To__r.Emp_ID__c,Force_Create_CMA__c,Campaign_Score__c,System_Campaign_Team_Member_Role__c,
                Force_Create_CTM__c, System_Assigned_by_Admin__c,Reason__c,System_Campaign_Team_Member_Access_Level__c
                from CampaignMember
                where Campaign.External_Id__c IN :campaignIds 
                AND Contact.TN_Contact_Key__c IN :contactIds];*/
                
    public static List<Campaign_Member__c> getCampaignMemberList(set<String> campaignIds, Set<String> contactIds) {
    List<Campaign_Member__c> cmList = new List<Campaign_Member__c>();
    cmList = [select Status__c, Campaign__r.External_Id__c,GPSContact__r.TN_Contact_Key__c,System_Assigned_To__r.Emp_ID__c,Force_Create_CMA__c,Campaign_Score__c,System_Campaign_Team_Member_Role__c,
                Force_Create_CTM__c, System_Assigned_by_Admin__c,Reason__c,System_Campaign_Team_Member_Access_Level__c
                from Campaign_Member__c
                where Campaign__r.External_Id__c IN :campaignIds 
                AND GPSContact__r.TN_Contact_Key__c IN :contactIds];
    return cmList;
   }
   
   //12/26/2011 UV: Added this method to get campaign Members Assignment from external id of campaign and TN_Contact_Key__c of contacts and MSID of User 
   public static List<Campaign_Member_Assignment__c> getcampaignMemberAssignmentList(Set<String> campaignIds, Set<String> userIds, Set<String> contactIds) {
     List<Campaign_Member_Assignment__c> cmaList = new List<Campaign_Member_Assignment__c>();
     cmaList = [select Campaign__r.External_Id__c ,Assigned_To__r.Emp_ID__c,GPSContact__r.TN_Contact_Key__c 
                    from Campaign_Member_Assignment__c
                    where Campaign__r.External_Id__c IN :campaignIds AND Assigned_To__r.Emp_ID__c IN : userIds
                    AND GPSContact__r.TN_Contact_Key__c IN :contactIds];   
     return cmaList;
   }
  
  //2/24/2012 UV : added this method to get the CMA for all other users except then current user [Jira story - 1526]
  public static List<Campaign_Member_Assignment__c> getCampaignMemberAssignmentforAllUserOtherThenCurrentUser(Id campaignId, List<Id> contactIds){
    // get list of campaign member assignment for a campaign and for all other users except then current user
    // campaignId - selected campaign id 
    // contactIds - List of contact ids
    List<Campaign_Member_Assignment__c> cMAList = [Select id, Campaign__c, GPSContact__c 
                                                        from Campaign_Member_Assignment__c 
                                                        where Campaign__c = : campaignId and GPSContact__c in : contactIds AND Assigned_To__c != :Userinfo.getUserId()];
     return cMAList;   
  }// end of getCampaignMemberAssignmentforAllUserOtherThenCurrentUser(Id campaignId)
  
  
  
  //3/15/2012 UV : added this method to get all the CMA for CM [Jira story - 1612]
  public static List<Campaign_Member_Assignment__c> getAllCampaignMemberAssignmentList(Set<Id> contactIds, Set<Id> CampaignIds) {
         
     Integer LIMIT_QUERY = Limits.getLimitQueryRows() - Limits.getQueryRows(); 
     List<Campaign_Member_Assignment__c> cmaList = new List<Campaign_Member_Assignment__c>();
     
     cmaList = [select id, Campaign_Score__c, Reason__c, Responded__c, Responded_By__c, Campaign_Status__c, Campaign__c, GPSContact__c 
                        from Campaign_Member_Assignment__c
                        where GPSContact__c IN :contactIds AND Campaign__c IN : campaignIds limit :LIMIT_QUERY];
    return cmaList;             
   } //end of getAllCampaignMemberAssignmentList()
   
   //3/15/2012 UV : added this method to get all the CM for differentCampaigns [Jira story - 1612]
   //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.  
   /*public static List<CampaignMember> getAllCampaignMemberList(Set<Id> contactIds, Set<Id> CampaignIds) {
         
     List<CampaignMember> cmList = new List<CampaignMember>();
     
     cmList = [select id, CampaignId, ContactId, Reason__c, HasResponded, LastModifiedById, Status, Campaign_Score__c
                        from CampaignMember
                        where ContactId IN :contactIds AND CampaignId IN :campaignIds];*/
                        
    public static List<Campaign_Member__c> getAllCampaignMemberList(Set<Id> contactIds, Set<Id> CampaignIds) {
         
     List<Campaign_Member__c> cmList = new List<Campaign_Member__c>();
     
     cmList = [select id, Campaign__c, GPSContact__c, Reason__c, HasResponded__c, LastModifiedById, Status__c, Campaign_Score__c
                        from Campaign_Member__c
                        where GPSContact__c IN :contactIds AND Campaign__c IN :campaignIds];
    
    return cmList;              
   } //end of getAllCampaignMemberList()
   
     // This Method identifies the Sobject type from the parent Id and return the Sobject Name
    public static String getSobjectTypeName(String recordId){
        Map<String, String> keyPrefixMap = new Map<String, String>{};
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        string SobjectTypeName ='';
        Set<String> keyPrefixSet = gd.keySet();
        for(String sObj : keyPrefixSet){
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            String tempName = r.getName();
            String tempPrefix = r.getKeyPrefix();
            if(tempPrefix<> null && recordId.startsWith(tempPrefix)){
               SobjectTypeName = tempName;
                break;
            }}
        return SobjectTypeName;
    }
    
   public static void syncWithGpsEmp(GPSEmployee__c emp, User usr, set<string> assignment, Map<string,Campaign_Permission_Sets__c> permissions){
        //emp.First_Name__c = usr.FirstName;
        //emp.Last_Name__c = usr.LastName;
        //emp.Email__c = usr.Email;
        //emp.MS_ID__c = usr.Emp_Id__c;
        //emp.MS_User_Id__c = usr.Short_Id__c;
        system.debug('sync method caled');
        system.debug('All Assignments='+assignment);
        emp.User__c = usr.Id;
        // if there are no permission sets assigned or custom setting is null then skip the sync up for permissions.
        if(permissions!=null && !permissions.isEmpty()){
        	
        	/*for(PermissionSetAssignment pma:assignment ){
        		
        		string fieldname=permissions.get(pma.PermissionSet.Name).Employee_Field_Api_Name__c;
        	
        		emp.put(fieldname,true);
        	
        	} */
        	//  iterate over custom setting and employee fields
        	//  and if user's permissions set assignment matches with name in custom setting then mark that flag as true.
        	// if there are no permissions assigned then mark all flags to false.
        	for(string s: permissions.keyset()){
        		system.debug('permission--'+s);
        		if(assignment!=null && !assignment.isEmpty() && assignment.contains(s)){
        			system.debug('Is Assignment Detected='+assignment.contains(s));
        			emp.put(permissions.get(s).Employee_Field_Api_Name__c,true);
        			system.debug('Field Updated='+permissions.get(s).Employee_Field_Api_Name__c + '  to= '+ emp.get(permissions.get(s).Employee_Field_Api_Name__c));
        		}
        		else {
        			
        			emp.put(permissions.get(s).Employee_Field_Api_Name__c,false);
        			
        		}
        		
        		
        	}     	
        }  
      
        //emp.Name = usr.Name;
        //Jira-4881 - Removed dependency from Users Active status 
        //emp.Active_Flag__c = usr.IsActive;
    }
    
    @future
    // update user's permissions from gps employee.
    public static void processRecords(string insertObjects, string deleteObjects){
    	
    		system.debug('process records method called');
    		
    		List<PermissionSetAssignment> dpsa= (List<PermissionSetAssignment>)Json.deserialize(deleteObjects,List<PermissionSetAssignment>.class);
    		
    		if(dpsa.size()>0)
    		
    		delete dpsa;
    	
    	    		
	    	List<PermissionSetAssignment> psa= (List<PermissionSetAssignment>)Json.deserialize(insertObjects,List<PermissionSetAssignment>.class);
	    	
	    	if(psa.size()>0)
	    	
	    	insert psa;    	
    	
    }
}