// 09/28/2011 RJ: ORIGINAL - Single Webservice Facade class for all the webservice methods
//                           that needed by the flex controller to communicate.
// 09/30/2011 RJ: Added new webservice method getApplicationConfig 
// 10/11/2011 RJ: Modified to resolve issue in getCampaignMemberDetail method; System.NullPointerException: Attempt to de-reference a null object
// 10/20/2011 RJ: Added hasResponded and assignedByUserFullName properties in campaignMemberWrapper.
// 10/25/2011 RJ: Added isClosed property in RequestandResponsePanelsDetail and RequestWrapper interfaces
// 10/26/2011 AV: Added campaignRequireocusCallRequestVerification property to CampaignCOnfiguration global class and updated the 
//                    CamapignConfiguration class constructor to tak in the new parameter             
// 11/02/2011 RJ: Added check for Account as null in the code
// 11/08/2011 RJ: Included 2 webservice methods getFilteredCampaignsList and loadTargetListonSelectedDL from CM_Webservice class
//                To have all the webservice methods in a single facade class irrespective to its usability to flex or not
// 11/10/2011 UV : updated constructor CampaignMemberWrapper() to add assignedByUserFullName (line #166,194)       
// 02/28/2012 RJ : Update consturctor RequestWrapper to populate requestDueDate property with System.Today date.
// 03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.      
global with sharing class CM_Campaigns_WS { 
              
    //webservice static List<Campaign> getFilteredCampaignsList(String Status, String Region){
    // TempComment
    webservice static List<Campaign__c> getFilteredCampaignsList(String Status, String Region){
    	//03/04/2016 AT: Moving to Platform Licenses, replacing Campaign standard object with custom object.  
       // This method is used to get the filtered campaigns by their status and region passed as parameter values. 
       // As in this method webservice is used because it is faster that SOQL QUERIES thats why it is used on the Campaigns page 
       // to filter the campaigns.      
       return CM_CampaignDataUtil.getFilteredCampaignsList(Status, Region);      
      
    }
   
    webservice static CustomMessage loadTargetListonSelectedDL(String selectedDLId, String selectedCampaignId, boolean isUseMyContactList, String selectedDLName){
         CM_LoadTargetListOnDL lTLOD = new CM_LoadTargetListOnDL();
         
         List<Campaign_Member__c> cMList = lTLOD.loadTargetListonSelectedDL(selectedDLId, selectedCampaignId, isUseMyContactList, selectedDLName);
                    
         return new CustomMessage(cMList.size() + (cMList.size() > 1 ? ' Contacts ' : ' Contact ') + 'has been added.');
    }
  
  
    webservice static CustomMessage updateCampaignMemberStatus(Id campaignMemberId, String status){
      // To update the campaign member status from the response panel/ campaign member detail panel.
      return CM_CampaignMemberDetailManager.updateCampaignMemberStatus(campaignMemberId, status);   
    }// end of updateCampaignMemberStatus(Id campaignMemberId, String status)
    
    // TempComment
   webservice static RequestandResponsePanelsDetail getRequestandResponsePanelsDetail(Id campaignMemberId){
        // get the details for selected campaign Member
        return CM_CampaignMemberDetailManager.getRequestandResponsePanelsDetail(campaignMemberId);
    }// end of getRequestandResponsePanelsDetail(Id campaignMemberId) 
    
    webservice static CustomMessage reassignMember(Id campaignId, List<Id> contactIds, Id userId){
        // To reassign the searched and selected user as campaign member to current campaign.
        return CM_CampaignMembersReassignmentManager.reassignMember(campaignId, contactIds, userId);        
    }// end of reassignMember(Id campaignId, List<Id> contactIds)
    
    webservice static QuickAddCampaignParticipantsWrapper searchCampaignParticipants(Id campaignId, String searchString){
     // To search user object for get list of campaign participants.
       return new QuickAddCampaignParticipantsWrapper(searchString, CM_CampaignMembersReassignmentManager.searchCampaignParticipants(campaignId, searchString));
       //return null; 
   }// end of searchCampaignParticipants(campaignId)
    
    webservice static CustomMessage removeCampaignMembersforCurrentUser(Id campaignId, List<Id> contactIds){
        // will remove the list of campaignmembers assigned to current user.
        return CM_CampaignMemberManager.removeCampaignMembersforCurrentUser(campaignId, contactIds);
        
    }// end of removeCampaignMembersforCurrentUser(Id campaignId, List<Id> campaignMemberIds)
    
    webservice static addCampaignMembersforCurrentUserResult addCampaignMembersforCurrentUser(Id campaignId, List<Id> contactIds){
        // will add the list of contacts assigned to current user as campaign member
        return CM_SearchCampaignMembersContactsManager.addCampaignMembersforCurrentUser(campaignId, contactIds);
        //return null;        
    }// end of addCampaignMembersforCurrentUser(Id campaignId, List<String> contactIds)
    // TempComment
    webservice static ApplicationSettings getApplicationConfig(){
        // get the list of Grid configuration settings 
        return new ApplicationSettings(CM_ApplicationConfigManager.getApplicationConfigSettings(), CM_ApplicationConfigManager.getApplicationConfig());      
    }// end of getApplicationConfig()
    
    webservice static List<CampaignMemberWrapper> getCampaignMembersforCurrentUser(Id campaignId){
          // get the list of campaignMembers for current user in wrapper pattern
          // campaignId - salesforce id of campaign object record
         return CM_CampaignMemberManager.getCampaignMembersforCurrentUser(campaignId);
    }// end of getCampaignMembersforCurrentUser(Id campaignId)

  webservice static List<IncomingRequestMemberWrapper> getIncomingRequestsForCurrentUser(Id campaignId){
      // get the list of requests for current user in wrapper pattern
      // campaignId - salesforce id of campaign object record
     return CM_IncomingRequestManager.getIncomingRequestsForCurrentUser(campaignId);
     
  }// end of getIncomingRequestsForCurrentUser(Id campaignId)
  
  
  webservice static QuickAddContactsWrapper getSearchCampaignMembersContacts(Id campaignId, String searchString) {
        //get the list of the contacts to be search for quick add
        //campaignId - selectedCampaignId
        //searchString - Contact/Account Name to be searched
    return new QuickAddContactsWrapper(searchString, CM_SearchCampaignMembersContactsManager.getSearchCampaignMembersContacts(campaignId, searchString));    
  } // end of getSearchCampaignMembersContacts(String searchString,Id campaignId)
  
  
  webservice static Request createRequest(String contactId, String Action, String campaignId, 
                            String assignedToUserId, String comments, String dueDateString, boolean isSpokenToContact) {
  //to create a new request
   return CM_RequestManager.createRequest(contactId, Action, campaignId, assignedToUserId, comments, dueDateString, isSpokenToContact);
   
  }//end of createRequest(String contactId, String Action,........)
  
  webservice static RequestWrapper getRequestDetail(String requestId) {
    //get the details of the request
    // requestId = id of the task to fetch the details
   return  CM_RequestManager.getRequestDetail(requestId);
   
  }//end of RequestWrapper getRequestDetail(String requestId) 
  
  webservice static RequestWrapper getDefaultRequestDetail(String campaignMemberId){
    // campaignMemberId - id of campaign member
    return CM_RequestManager.getDefaultRequestDetail(campaignMemberId);
    
  }// end of getDefaultRequestDetail(String campaignMemberId)
  
  webservice static CustomMessage updateRequest(Id TaskId, String Status, String Feedback, Id assignedToUser) {
    return CM_RequestManager.updateRequest(TaskId, Status, Feedback, assignedToUser);
    
  }// end of updateRequest(Id TaskId, String Status, String Feedback, Id assignedToUser) 
  
  webservice static CustomMessage cancelRequest(Id TaskId) {
    //to delete a request
  return  CM_RequestManager.cancelRequest(TaskId);
   
  }//end of cancelRequest(Id requestId)
 //TempComment
  webservice static CampaignConfiguration getCampaignConfiguration(String campaignId) {
      // this method return the campaignMemberStatuses List (For Response panel - RESPONSE Picklist)
      return CM_ApplicationConfigManager.getCampaignConfiguration(campaignId);
      
  }// getCampaignConfiguration(String campaignId)
  webservice static CampaignMemberWrapper getCampaignMemberDetail(String campaignMemberId) {
   return CM_CampaignMemberManager.getCampaignMemberDetail(campaignMemberId);
   
  }
 
  // FOR CAMPAIGN MEMBER - TARGET LIST
  
    global class CampaignMemberWrapper{
            webservice String campaignId{get;set;}          
            webservice String campaignMemberId{get;set;}            
            webservice String contactId{get;set;}           
            webservice Integer campaignScore{get;set;}
            webservice String accountName{get;set;}
            webservice String accountId{get;set;}
            webservice String contactFullName{get;set;}
            webservice String contactFirstName{get;set;}
            webservice String contactLastName{get;set;}
            webservice String contactEmail{get;set;}
            webservice List<CM_Campaigns_WS.PhoneNumber> contactPhone{get;set;} //first member of the array will be default AND preferred number            
            webservice String campaignMemberStatus{get;set;}            
            webservice String requestStatus{get;set;}
            webservice String reason{get;set;}
            webservice String requestId{get;set;}
            webservice Boolean assignedByCampaignAdmin{get;set;}
            webservice Boolean reassigned{get;set;}
            webservice Boolean hasResponded{get;set;}
            webservice String assignedByUserFullName{get;set;}
           // 11/10/2011 UV : updated this constructor to add assignedByUserFullName
            public CampaignMemberWrapper(Campaign_Member__c campM, Task request, boolean assignedByCampaignAdmin, boolean reassigned,String assignedByUserFullName){
                // campM - CampaignMember salesforce object record
                // requestStatus - request status. 
               
                if(request <> null){
                  this.requestId = request.Id;
                  this.requestStatus = request.Status == null ? '' : request.Status;
                }else{
                   this.requestId = '';
                   this.requestStatus = '';                   
                }
                this.hasResponded = false;
                this.campaignId = campM.campaign__c;
                this.campaignMemberId = campM.Id;
                this.contactId = campM.GPSContact__r.Id; 
                this.campaignScore = campM.Campaign_Score__c == null ? 0 : campM.Campaign_Score__c.intValue();
                //this.accountName = campM.Contact.Account <> null ? campM.Contact.Account.Name : '';
                this.accountName = campM.GPSContact__r.GPSAccount__c == null ? '' : campM.GPSContact__r.GPSAccount__r.Name;
                //this.accountId = campM.Contact.Account != null ? campM.Contact.Account.Id : '';
                this.accountId = campM.GPSContact__r.GPSAccount__c == null ? '' : campM.GPSContact__r.GPSAccount__r.Id;
                
                this.contactFullName = (campM.GPSContact__r.LastName__c != null ? campM.GPSContact__r.LastName__c : '')  + (campM.GPSContact__r.FirstName__c != null ? ', ' + campM.GPSContact__r.FirstName__c : '');
                this.contactFirstName = campM.GPSContact__r.FirstName__c == null ? '' : campM.GPSContact__r.FirstName__c;
                this.contactLastName = campM.GPSContact__r.LastName__c == null ? '' : campM.GPSContact__r.LastName__c;
                this.contactEmail = campM.GPSContact__r.Email__c == null ? '' : campM.GPSContact__r.Email__c;
                this.campaignMemberStatus = campM.Status__c;
                this.reason = campM.Reason__c == null ? '' : campM.Reason__c;                
                this.contactPhone = new List<CM_Campaigns_WS.PhoneNumber>();
                this.hasResponded = campM.HasResponded__c;
                this.assignedByCampaignAdmin = assignedByCampaignAdmin;
                this.reassigned = reassigned;               
                this.assignedByUserFullName = assignedByUserFullName;
                this.contactPhone.addAll(CM_CampaignMemberManager.populateContactPhone(campM));
                
                
            }
            
  }

    global class PhoneNumber{
     webservice String phoneNumber{get;set;}
     webservice String phoneType{get;set;}     
     public PhoneNumber(String phoneType, String phoneNumber){
          this.phoneNumber = phoneNumber == null ? '' : phoneNumber;
          this.phoneType = phoneType;
     }
  }

  
  // FOR INCOMING REQUEST LIST 
  global class IncomingRequestMemberWrapper {
      webservice String contactId{get;set;}
      webservice String taskId{get;set;}
        webservice Boolean contactPriority{get;set;}
        webservice String contactTier{get;set;}
        webservice String contactTierHoverText{get;set;}
        webservice String accountName{get;set;}
        webservice String contactFullName{get;set;}
        webservice String contactFirstName{get;set;}
        webservice String contactLastName{get;set;}
        webservice String contactEmail{get;set;}
        webservice String status{get;set;}
        webservice Integer starRating{get;set;}         
        webservice List<CM_Campaigns_WS.PhoneNumber> contactPhone{get;set;}
        
        public IncomingRequestMemberWrapper(Task tsk, GPSContact__c contactMember) {
              this.contactId = contactMember.Id;
              this.taskId = tsk.Id;
                
               this.starRating = (contactMember.Campaign_Member__r.size() > 0 ? (contactMember.Campaign_Member__r[0].Campaign_Score__c == null ?  0 : contactMember.Campaign_Member__r[0].Campaign_Score__c.intValue()) : 0);
                /**** Start Code Commented while campaign Migration. Not using Tier column any more. Sudarshan K. 1st March 2016
                this.contactTier = contactMember.Account == null || contactMember.Account.PSL_by_Role_Abbreviated__c == null ? '' : contactMember.Account.PSL_by_Role_Abbreviated__c;
                this.contactTierHoverText = contactMember.Account == null || contactMember.Account.PSL_by_Role__c == null ? '' : contactMember.Account.PSL_by_Role__c;
                End Code**********************/
                
                this.contactPriority = contactMember.Priority_Contacts__r.size() > 0 ? true : false;
                   
                this.contactFullName = (contactMember.LastName__c != null ? contactMember.LastName__c : '')  + (contactMember.FirstName__c != null ? ', ' + contactMember.FirstName__c : '');
                this.contactFirstName = contactMember.FirstName__c == null ? '' : contactMember.FirstName__c;
                this.contactLastName = contactMember.LastName__c == null ? '' : contactMember.LastName__c;
                this.contactEmail = contactMember.Email__c == null ? '' : contactMember.Email__c;
                this.accountName = contactMember.GPSAccount__c == null ? '' : contactMember.GPSAccount__r.Name;
                            
                this.status = tsk.Status;
                this.contactPhone = new List<CM_Campaigns_WS.PhoneNumber>();
              
                this.contactPhone.addAll(CM_IncomingRequestManager.populateContactPhone(contactMember));
        }
  }
  
  // for all campaign application settings
  global class ApplicationSettings{
    webservice List<ApplicationConfigSettings> applicationConfigSettings{get;private set;}
    webservice List<GridConfig> gridConfigSettings{get;private set;}
    webservice String loginExpiredException{get;private set;}
    public ApplicationSettings(List<ApplicationConfigSettings> applicationConfigSettings, List<GridConfig> gridConfigSettings){
       this.gridConfigSettings = gridConfigSettings;
       this.applicationConfigSettings = applicationConfigSettings;
       this.loginExpiredException = CM_CampaignDataUtil.LoginExpiredException;
    }
  }
  
  //For Application Config Settings
  global class ApplicationConfigSettings{
    webservice String Name{get;private set;}
    webservice List<CM_Campaigns_WS.ApplicationConfigPickListEntry> pickList{get;private set;}
    public ApplicationConfigSettings(String Name, List<CM_Campaigns_WS.ApplicationConfigPickListEntry> pickList){
       this.Name = Name;
       this.pickList = pickList;
    } 
  }
  
  global class ApplicationConfigPickListEntry{
    webservice String label{get;private set;}
    webservice String value{get;private set;}
    public ApplicationConfigPickListEntry(String label, String value){
      this.label = label;
      this.value = value;
    } 
  }
  
  // FOR GRID CONFIGURATIONS
  global class GridConfig{
     webservice String Name{get; private set;} 
     webservice List<CM_Campaigns_WS.GridColumn> displayColumns {get; private set;} //array of column names to display on the this screen
     public GridConfig(String Name, List<CM_Campaigns_WS.GridColumn> displayColumns){
           this.Name = Name;
           this.displayColumns = displayColumns;
     }
  }  
  
  global class GridColumn{
    webservice String Name{get; private set;}
    webservice Boolean isVisible{get;private set;}
    public GridColumn(String Name, boolean isVisible){
        this.Name = Name;
        this.isVisible = isVisible;
    }
  }
  
  // FOR QUICK ADD SEARCH ALL CONTACTS
  global class QuickAddContactsWrapper{
    webservice String searchString{get;set;}
    webservice List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper> contactList{get;set;}
    public QuickAddContactsWrapper(String searchString, List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper> contactList){
        this.searchString = searchString;
        this.contactList = contactList == null ? new List<CM_Campaigns_WS.SearchCampaignMembersContactsWrapper>() : contactList;
    }
  }
  
    
  global class SearchCampaignMembersContactsWrapper{
     webservice String contactFirstName{get;set;}
     webservice String contactLastName{get;set;}
     webservice String contactFullName{get;set;}
     webservice String accountName{get;set;}
     webservice String contactId{get;set;}  
     webservice boolean isCampaignMember{get;set;}
     webservice boolean isAssignedtoCurrentUser{get;set;}
            
        public SearchCampaignMembersContactsWrapper(GPSContact__c contactMember, boolean isCampaignMember, boolean isAssignedtoCurrentUser) {
            this.contactId = contactMember.Id;
            this.contactFirstName = contactMember.FirstName__c;
            this.contactLastName = contactMember.LastName__c;
            this.accountName = contactMember.GPSAccount__c == null ? '' : contactMember.GPSAccount__r.Name;            
            this.contactFullName = (contactMember.LastName__c != null ? contactMember.LastName__c : '')  + (contactMember.FirstName__c != null ? ', ' + contactMember.FirstName__c : '');
            this.isCampaignMember = isCampaignMember;
            this.isAssignedtoCurrentUser = isAssignedtoCurrentUser;
        }
    }
  
  
  // FOR CUSTOM MESSAGE TO BE PASSED TO FLEX FOR ANY ADD, REMOVE, REASSIGN etc actions
  global class CustomMessage{
    webservice String message{get;set;}
    public CustomMessage(String message){
        this.message = message;
    }   
  }
  
  global class addCampaignMembersforCurrentUserResult {
      webservice CustomMessage customMessage{get;set;}
      webservice List<CM_Campaigns_WS.CampaignMemberWrapper> savedRecords{get;set;}
      
      public addCampaignMembersforCurrentUserResult (String customMessage,List<CM_Campaigns_WS.CampaignMemberWrapper> savedRecords) {
        this.customMessage = new CustomMessage(customMessage);
        this.savedRecords = savedRecords;
      }
}

 // FOR CAMPAIGN REASSIGN SEARCH PARTICIPANTS
  global class QuickAddCampaignParticipantsWrapper{
    webservice String searchString{get;set;}
    webservice List<CM_Campaigns_WS.CampaignParticipantWrapper> campaignParticipants{get;set;}
    public QuickAddCampaignParticipantsWrapper(String searchString, List<CM_Campaigns_WS.CampaignParticipantWrapper> campaignParticipants){
        this.searchString = searchString;
        this.campaignParticipants = campaignParticipants == null ? new List<CM_Campaigns_WS.CampaignParticipantWrapper>() : campaignParticipants;
    }
  }

  global class CampaignParticipantWrapper{
    webservice String userId{get;set;}
    webservice String userFirstName{get;set;}
    webservice String userLastName{get;set;}
    webservice String userFullName{get;set;}
    webservice String userCompanyName{get;set;}
    public CampaignParticipantWrapper(Campaign_Team_Member__c cTM){
      this.userId = cTM.User__r.Id;
      this.userFirstName = cTM.User__r.Preferred_Name__c == null ? '' : cTM.User__r.Preferred_Name__c;
      this.userLastName = cTM.User__r.LastName == null ? '' : cTM.User__r.LastName;
      this.userFullName = (cTM.User__r.LastName != null ? cTM.User__r.LastName : '')  + (cTM.User__r.Preferred_Name__c != null ? ', ' + cTM.User__r.Preferred_Name__c : '');
      this.userCompanyName = cTM.User__r.CompanyName == null ? '' : cTM.User__r.CompanyName;
    }
    
     public CampaignParticipantWrapper(AggregateResult aR){
      this.userId = String.valueOf(aR.get('userId'));
      this.userFirstName = aR.get('preferredName') == null ? '' : String.valueOf(aR.get('firstName'));
      this.userLastName = aR.get('lastName') == null ? '' : String.valueOf(aR.get('lastName'));
      this.userFullName = (aR.get('lastName') != null ? String.valueOf(aR.get('lastName')) : '')  + (aR.get('preferredName') != null ? ', ' + String.valueOf(aR.get('preferredName')) : '');
      this.userCompanyName = aR.get('companyName') == null ? '' : String.valueOf(aR.get('companyName'));
    }
       
  }



 // FOR CAMPAIGN MEMBER DETAIL
  global class RequestandResponsePanelsDetail{
    webservice String requestId{get;set;} 
    webservice String campaignMemberId{get;set;}
    webservice String contactId{get;set;}
    webservice String contactFullName{get;set;}
    webservice String contactAccountName{get;set;}      
    webservice String campaignMemberStatus{get;set;}
    webservice String reason{get;set;}
    webservice String requestUserToId{get;set;}
    webservice String requestUserToFullName{get;set;}
    webservice String requestStatus{get;set;}
    webservice String requestUserFromId{get;set;}
    webservice String requestUserFromFullName{get;set;}
    webservice boolean isClosed{get;set;}
    
    public RequestandResponsePanelsDetail(Campaign_Member__c campM, Task tsk){
          this.campaignMemberId = campM.Id;
          this.contactFullName = (campM.GPSContact__r.LastName__c != null ? campM.GPSContact__r.LastName__c : '')  + (campM.GPSContact__r.FirstName__c != null ? ', ' + campM.GPSContact__r.FirstName__c : '');
        this.contactId = campM.GPSContact__r.Id;
        this.campaignMemberStatus = campM.Status__c == null ? '' : campM.Status__c;
        this.reason = campM.Reason__c == null ? '' : campM.Reason__c;  
        this.contactAccountName = campM.GPSContact__r.GPSAccount__c == null ? '' : campM.GPSContact__r.GPSAccount__r.Name;
        // if request is already created for this campaign member then input the request information
        if(tsk <> null){
          this.requestId = tsk.Id;      
          this.requestUserToId = tsk.OwnerId;
          
          User u = [select Preferred_Name__c from User where Id = :tsk.OwnerId];
          
          this.requestUserToFullName = (tsk.Owner.LastName != null ? tsk.Owner.LastName : '')  + (u.Preferred_Name__c != null ? ', ' + u.Preferred_Name__c : '');         
          this.requestStatus = tsk.Status == null ? '' : tsk.Status;          
          this.requestUserFromId = tsk.CreatedById;
          this.requestUserFromFullName = (tsk.CreatedBy.LastName != null ? tsk.CreatedBy.LastName : '')  + (tsk.CreatedBy.Preferred_Name__c != null ? ', ' + tsk.CreatedBy.Preferred_Name__c : '');
          this.isClosed = tsk.isClosed;       
        }else{
          // if there is no request; (or user comes to create request first time)
          this.requestId = null;      
            this.requestUserToId = null;
            this.requestUserToFullName = '';          
            this.requestStatus = 'New';          
            this.requestUserFromId = null;
            this.requestUserFromFullName = '';
            this.isClosed = false;
        }  
    }
  }
  
  // Request Wrapper
  global class RequestWrapper{
      webservice String requestId{get;private set;}
      webservice String campaignMemberId{get;set;}
      webservice String contactId{get;set;}
      webservice String contactFirstName{get;set;}
      webservice String contactLastName{get;set;}
      webservice String contactFullName{get;set;}
      webservice String contactAccountName{get;set;}
      webservice String requestType{get;set;}
      webservice String campaignId{get;set;}
      webservice String relatedTo{get;set;}
      webservice String assignedToUserId{get;set;}
      webservice String assignedToUserFirstName{get;set;}
      webservice String assignedToUserLastName{get;set;}
      webservice String assignedToUserFullName{get;set;}
      
      webservice String assignedFromUserId{get;set;}
      webservice String assignedFromUserFullName{get;set;}
      webservice DateTime  assignedDateTime{get;set;}
      
      webservice String requestStatus{get;set;}
      webservice String requestComments{get;set;}   
      webservice Date requestDueDate{get;set;}   
      webservice boolean isSpokenToContact{get;set;}
      webservice List<CM_Campaigns_WS.PhoneNumber> contactPhone{get;set;}
      webservice String requestFeedback{get;set;}
      webservice boolean isClosed{get;set;}
      
      public RequestWrapper(Campaign_Member__c campM, User usr){
        this.assignedFromUserId = '';
        this.assignedFromUserFullName = '';
        this.assignedDateTime = System.now();
        
         
        this.isClosed = false;
        this.contactId = campM.GPSContact__r.Id;
        this.contactFirstName = campM.GPSContact__r.FirstName__c == null ? '' : campM.GPSContact__r.FirstName__c;
        this.contactLastName = campM.GPSContact__r.LastName__c == null ? '' : campM.GPSContact__r.LastName__c;
        this.contactFullName = (campM.GPSContact__r.LastName__c != null ? campM.GPSContact__r.LastName__c : '')  + (campM.GPSContact__r.FirstName__c != null ? ', ' + campM.GPSContact__r.FirstName__c : '');
        this.contactAccountName = campM.GPSContact__r.GPSAccount__c == null ? '' : campM.GPSContact__r.GPSAccount__r.Name;
        
        this.campaignId = campM.Campaign__c;
        this.relatedTo = campM.Campaign__r.Name; 
        
        this.assignedToUserId = usr.Id;
        this.assignedToUserFirstName = usr.Preferred_Name__c == null ? '' : usr.Preferred_Name__c;
        this.assignedToUserLastName = usr.LastName == null ? '' : usr.LastName;
        this.assignedToUserFullName = (usr.LastName != null ? usr.LastName : '')  + (usr.Preferred_Name__c != null ? ', ' + usr.Preferred_Name__c : '');
        
        //this.requestDueDate = campM.Campaign.EndDate;
        this.requestDueDate = System.Today();
        this.requestFeedback = '';
        this.requestComments = '';
          
      }
      
      public RequestWrapper(Campaign_Member__c campM, Task tsk){
        this.assignedFromUserId = '';
        this.assignedFromUserFullName = '';
        
        this.isClosed = tsk.isClosed;
        this.contactId = tsk.GPS_Contact__c;
        this.contactFirstName = campM.GPSContact__r.FirstName__c == null ? '' : campM.GPSContact__r.FirstName__c;
        this.contactLastName = campM.GPSContact__r.LastName__c == null ? '' : campM.GPSContact__r.LastName__c;
        this.contactFullName = (campM.GPSContact__r.LastName__c != null ? campM.GPSContact__r.LastName__c : '')  + (campM.GPSContact__r.FirstName__c != null ? ', ' + campM.GPSContact__r.FirstName__c : '');
        this.contactAccountName = campM.GPSContact__r.GPSAccount__c == null ? '' : campM.GPSContact__r.GPSAccount__r.Name;
        
        this.requestId = tsk.Id;
        this.requestType = tsk.Type;
        this.campaignId = tsk.WhatId;
        this.relatedTo = tsk.What.Name;
        
        this.assignedToUserId = tsk.OwnerId;
        
        User u;
        if(tsk.OwnerId != null)
        u = [select Preferred_Name__c from User where Id = :tsk.OwnerId];
        
        this.assignedToUserFirstName = tsk.OwnerId == null ? '' : u.Preferred_Name__c;
        this.assignedToUserLastName = tsk.OwnerId == null ? '' : tsk.Owner.LastName;
        this.assignedToUserFullName = (tsk.OwnerId == null ? '' : tsk.Owner.LastName)  + (tsk.Owner.FirstName == null ? '' : ', ' + u.Preferred_Name__c);
        
        this.requestStatus = tsk.Status == null ? '' : tsk.Status;
        this.requestComments = tsk.Description == null ? '' : tsk.Description;
        this.requestDueDate = tsk.ActivityDate;
        this.isSpokenToContact = false;
        this.requestFeedback = tsk.Assignee_Feedback__c == null ? '' : tsk.Assignee_Feedback__c;
        
        
        this.campaignMemberId = campM.Id;
        
        this.contactPhone = new List<CM_Campaigns_WS.PhoneNumber>();
        this.contactPhone.addAll(CM_RequestManager.populateContactPhone(campM));
        
        this.assignedFromUserId = tsk.CreatedById;
        this.assignedFromUserFullName = (tsk.CreatedBy.LastName != null ? tsk.CreatedBy.LastName : '')  + (tsk.CreatedBy.Preferred_Name__c != null ? ', ' + tsk.CreatedBy.Preferred_Name__c : '');
        this.assignedDateTime = tsk.CreatedDate;
        
      }
       public RequestWrapper(Task tsk){
       	
       	Task t = [select CreatedBy.Preferred_Name__c from Task where Id = :tsk.Id];
       	
        this.assignedFromUserId = '';
        this.assignedFromUserFullName = '';
        
        this.isClosed = tsk.isClosed;
        this.contactId = tsk.GPS_Contact__c;
        this.requestId = tsk.Id;
        this.campaignId = tsk.WhatId;
        this.relatedTo = tsk.What.Name;
        this.requestType = tsk.Type;
        
        this.assignedToUserId = tsk.OwnerId;
        
        User u;
        if(tsk.OwnerId != null)
        u = [select Preferred_Name__c from User where Id = :tsk.OwnerId];
        
        this.assignedToUserFirstName = tsk.OwnerId == null ? '' : u.Preferred_Name__c;
        this.assignedToUserLastName = tsk.OwnerId == null ? '' : tsk.Owner.LastName;
        this.assignedToUserFullName = (tsk.OwnerId == null ? '' : tsk.Owner.LastName)  + (u.Preferred_Name__c == null ? '' : ', ' + u.Preferred_Name__c);
        
        this.requestStatus = tsk.Status == null ? '' : tsk.Status;
        this.requestComments = tsk.Description == null ? '' : tsk.Description;
        this.requestDueDate = tsk.ActivityDate;
        this.requestFeedback = '';    
        
        
        this.assignedFromUserId = tsk.CreatedById;
        this.assignedFromUserFullName = (tsk.CreatedBy.LastName != null ? tsk.CreatedBy.LastName : '')  + (t.CreatedBy.Preferred_Name__c != null ? ', ' + t.CreatedBy.Preferred_Name__c : '');
        this.assignedDateTime = tsk.CreatedDate;
      }
  }
  
  
  global class Request {
    webservice CM_Campaigns_WS.RequestWrapper request{get;set;}
    webservice CM_Campaigns_WS.IncomingRequestMemberWrapper incomingRequest{get;set;}
    webservice CM_Campaigns_WS.CustomMessage customMessage{get;set;}
    public Request(CM_Campaigns_WS.RequestWrapper request, CM_Campaigns_WS.CustomMessage customMessage, CM_Campaigns_WS.IncomingRequestMemberWrapper incomingRequest) {
      this.request = request; 
      this.customMessage = customMessage; 
      this.incomingRequest = incomingRequest;
    }
  }
   
 global class CampaignConfiguration {
   webservice List<String> campaignMemberStatuses{get;set;}   
   webservice Boolean campaignRequireFocusCallRequestVerification{get;set;}
   webservice String defaultAssigneeId{get;set;}
   webservice String defaultAssigneeFullName{get;set;} 
   webservice String defaultTab{get;set;}
   ////03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.  
   //public CampaignConfiguration(List<String> campaignMemberStatuses, Campaign camp,String defaultTab) {
   public CampaignConfiguration(List<String> campaignMemberStatuses, Campaign__c camp,String defaultTab) {
    this.campaignMemberStatuses = campaignMemberStatuses;
    this.campaignRequireFocusCallRequestVerification = false;
    this.defaultAssigneeId = '';
    this.defaultAssigneeFullName = '';
    
    if(camp <> null){
      this.campaignRequireFocusCallRequestVerification = camp.Require_Focus_Call_Request_Verification__c; 
      this.defaultTab = defaultTab;
      if(camp.Default_Task_Assignee__c <> null){
         this.defaultAssigneeId = camp.Default_Task_Assignee__r.Id;
         this.defaultAssigneeFullName = (camp.Default_Task_Assignee__r.LastName != null ? camp.Default_Task_Assignee__r.LastName : '')  + (camp.Default_Task_Assignee__r.Preferred_Name__c != null ? ', ' + camp.Default_Task_Assignee__r.Preferred_Name__c : '');      
      }
    }
    
   }
 }
}