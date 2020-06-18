/**
  09/14/2011: UV : Original: Controller for campaigns page 
  02/03/2012: RJ: Updated the constructor to add a logic for displaying the campaign on the basis of the url parameter cid.
  02/28/2012: UV: added new string which is link for the beta feedback on the campaigns page (line#(36-39))
  07/06/2012: UV: added this default value to the lstDistributionList and updated condition for check list size[line# 156 , 146-150]
  //6/25/2012 UV : update the default value add only in case list is not empty.(line# 161)
  10/11/2012: RA CRMGPS-2503 Update Tracker List Auto-Import Behavior.
  10/11/2012: Jitendra CRMGPS-2504 Make the Target List Import Selection Sticky  
  18/03/2016:Replaced Employee__c with GPSEmployee__c by Swapnd
**/
public with sharing class CampaignsController {
    // Properties defination
    public String SessionId { get { return UserInfo.getSessionId(); } } 
    public String loginExpiredMessage{get{ return CM_CampaignDataUtil.LoginExpiredException; }}
    public String campaignInActiveException{get{return CM_CampaignDataUtil.CampaignInActiveException; }}
    public List<CM_DataUtil_WS.CampaignWrapper> campaignsList{get;set;}
    public CM_DataUtil_WS.CampaignWrapper selectedCampaign{get;set;}
    public String selectedCampaignId{get;set;}
    public List<SelectOption> statusOptions{get;set;}
    public List<SelectOption> regionOptions{get;set;}
    public String selectedStatus{get;set;}
    public String selectedRegion{get;set;}
    public Integer summaryLength { get{ return CM_DataUtil_WS.SUMMARY_LENGTH; }}
    public Integer NO_OF_Attachments { get{ return CM_DataUtil_WS.NO_OF_ATTACHMENTS;}}
    public Integer MILESTONE_DESC_LENGTH{get{return CM_DataUtil_WS.MILESTONE_DESC_LENGTH;}}
    private GPSEmployee__c currentEmployee;
    public List<String> feedbackView{get;set;}
    public List<String> feedbackRole{get;set;}
    public List<String> feedbackRegion{get;set;}
    public List<String> feedbackAccount{get;set;}
    public String noCampaignsErrorMessage{get{return CM_DataUtil_WS.No_Campaigns_Error_Message;}} 
    public boolean renderPage{get;set;}
    public boolean renderDetails{get;set;}
    public List<SelectOption> lstDistributionList{get;set;}
    public boolean allowTargetListImport{get;set;}
    private CM_LoadTargetListOnDL  loadTargetListComponent{get;set;}
     /**********Login-As custom functionality by Swapnd Start Code******/
    public String loggedInUserId { get; set; }
    public String loggedInUserName { get; set; }
    /************************End Code***********************************/   
    private String cId{
        get{ return ApexPages.currentPage().getParameters().get('cid'); }
    }
    //10/11/2012: Jitendra CRMGPS-2504
    public boolean currentEmpIsUseMyContactList{get; set;}
    public string currentEmpLastSelectedDistributionList{get; set;}
    public boolean showHeaderTabs {get;set;}
    public String iTrakUserName { get; set; }
    
    //02/28/2012 UV : added for the beta feedback link in the ccampaigns page
    private static Common_EmailSettings__c emailSettings = Common_EmailSettings__c.getInstance();
    public String betaFeedbackLink{get{return emailSettings.Campaigns_BetaFeedbackLink__c <> null ? emailSettings.Campaigns_BetaFeedbackLink__c : CM_TestClassUtilities.Beta_FeedbackLink;}}
     
    public CampaignsController(){
    	//IE9 Visualforce hack   
    	String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        if(browserType != null && browserType.contains('MSIE')){
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        }
        
        iTrakUserName = UserInfo.getUserName();
        
        /**********Login-As custom functionality by swapna Deshpande Start Code******/
        if(ApexPages.currentPage().getParameters().get('UId') != null){
            loggedInUserId = ApexPages.currentPage().getParameters().get('UId');
            List<User> lstUser = [SELECT Id, UserName FROM User WHERE IsActive = true AND Id = :loggedInUserId];
            if(!lstUser.isEmpty()){
                loggedInUserId = lstUser[0].Id;
                loggedInUserName = lstUser[0].UserName;
            }else{
                loggedInUserId = System.Userinfo.getUserId();
                loggedInUserName = System.UserInfo.getUserName();
            }
        }else{
            loggedInUserId = System.Userinfo.getUserId();
            loggedInUserName = System.UserInfo.getUserName();             
        }   
        
        system.debug('loggedInUserId=='+loggedInUserId);
        /********************************End Code******************************************/
        
        showHeaderTabs = true;
        if(ApexPages.currentPage().getParameters().get('showheadertabs') != null){
        	if (ApexPages.currentPage().getParameters().get('showheadertabs') == 'false'){
        		showHeaderTabs = false;
        	}        	
        }
        
    	//Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=11');    
      // constructor       
      renderPage = true;
      renderDetails = true;
      campaignsList = new List<CM_DataUtil_WS.CampaignWrapper>();
      statusOptions = new List<SelectOption>();
      regionOptions = new List<SelectOption>();
      //getting all the status filters from DataUtil class
      statusOptions = CM_DataUtil_WS.getStatusSelectOptions();
      //getting all the region filters from DataUtil class
      regionOptions = CM_DataUtil_WS.getRegionSelectOptions();
      // setting default filter options
      selectedStatus = CM_DataUtil_WS.DEFAULT_CAMPAIGN_STATUS_SELECTION;
      selectedRegion = CM_DataUtil_WS.DEFAULT_REGION_SELECTION;
      // getting default list of campaigns as per default filters.
      campaignsList = CM_DataUtil_WS.getDefaultCampaignsList();
      allowTargetListImport = false;
      //10/11/2012: Jitendra CRMGPS-2504
      currentEmpIsUseMyContactList = false;
      currentEmpLastSelectedDistributionList = '';            
      if(campaignsList.size() > 0){
          // getting the current employee that is using Campaings Application
          currentEmployee = CM_DataUtil_WS.getCurrentUserEmployee();
          //10/11/2012: Jitendra CRMGPS-2504
          if(currentEmployee <> NULL){
              currentEmpIsUseMyContactList = currentEmployee.IsUseMyContactList__c;           
              if(currentEmployee.Last_Selected_Distribution_List__c <> NULL) currentEmpLastSelectedDistributionList = currentEmployee.Last_Selected_Distribution_List__c;
          }
          System.debug('_____Name________' + campaignsList[0].Name);
          // to make the campaings sticky, getting last selected campaign by employee         
          if(currentEmployee <> null && currentEmployee.Last_Campaign_Viewed__c <> null) {
              selectedCampaignId = currentEmployee.Last_Campaign_Viewed__c;
          } else if(campaignsList.size() > 0) { 
            // in case employee doesnt have any last selected campaign then most recent campign is selected
                selectedCampaignId = CM_DataUtil_WS.getMostRecentActiveCampaign();
          }
          
          if(cId <> null){
            selectedCampaignId = cId;              
          }                    
            
          selectedCampaign = CM_DataUtil_WS.getCurrentCampaign(selectedCampaignId);   
                   
          // In case if the last view campaign is now hidden it will not be fetched by the query and now 
          // we have to again set the last viewed campaign as the recent active campaign.
          if(selectedCampaign == null && cId == null){
             selectedCampaignId = CM_DataUtil_WS.getMostRecentActiveCampaign();              
             selectedCampaign = CM_DataUtil_WS.getCurrentCampaign(selectedCampaignId);                                  
          }
          
          if(selectedCampaign == null && cId == null) {
                renderPage = false;             
                
          }else if(selectedCampaign == null && cId <> null){  
              renderDetails = false;                    
              selectedCampaign = CM_DataUtil_WS.getCampaign(selectedCampaignId);
              loadAccessibleDistributionLists();
              
          }else{
            updateStructuredFeedbackValues(selectedCampaign);
            loadAccessibleDistributionLists();
            //setAllowTargetListImport(selectedCampaign);
          }
      }else{
        renderPage = false;
      }
   } // END of Constructor
   
   public void pageAction(){
      if(selectedCampaign <> null){
        setAllowTargetListImport(selectedCampaign);
      }
   }
      
   public Pagereference updateLastViewedCampaign() {
      //This method is used as a action function and gets called when new campaign is selected in CBM menu.    
      System.debug('_____________selectedCampaignId__' + selectedCampaignId);
      renderDetails = true;
      if(currentEmployee <> null) {
        currentEmployee.Last_Campaign_Viewed__c = selectedCampaignId;
        update currentEmployee;
      }
      selectedCampaign = CM_DataUtil_WS.getCurrentCampaign(selectedCampaignId);  
      if(selectedCampaign <> null) {
        updateStructuredFeedbackValues(selectedCampaign);
        setAllowTargetListImport(selectedCampaign);
      }else{
          // In case if the last view campaign is now hidden/inactive it will not be fetched by the query and now 
          // do not show the details and just show the inactive message          
          renderDetails = false;                              
      }
      System.debug('_____________renderDetails__' + renderDetails);
      return null;
   } // End of updateLastViewedCampaign()
   
   public void setAllowTargetListImport(CM_DataUtil_WS.CampaignWrapper selectedCampaign){
      boolean isImported = true;      
      List<Campaign_Team_Member__c> cTMList = CM_CampaignDataUtil.getCampaignTeamMemberList(loggedInUserId, selectedCampaign.Id);
      List<Campaign_Team_Member__c> cTMImportedList = new List<Campaign_Team_Member__c>();
      for(Campaign_Team_Member__c cTM : cTMList){
        if(cTM.Imported_Target_List__c == true){
            cTMImportedList.add(cTM);
        }
      }
      if(cTMImportedList.size() == 0){
        isImported = false;
      }
      if(cTMList.size() == 0){
        isImported = true;
      }       
      //System.debug('cTMList:' + cTMList.size() + ',selectedAllow:' + selectedCampaign.allowTargetListImport + ',isImported:' + isImported + ',lstDistSize:' + lstDistributionList.size());  
      allowTargetListImport = false;        
      //6/7/2012 UV : updated this methos to check list size for 2 as default value is added
      //10/11/2012: RA CRMGPS-2503
      if(selectedCampaign.allowTargetListImport == true && lstDistributionList.size() > 1 && !isImported){
        allowTargetListImport = true;
      }/*else if(selectedCampaign.allowTargetListImport == true && lstDistributionList.size() == 2 && loadTargetListComponent <> null && !isImported){
        loadTargetListComponent.loadTargetListonSelectedDL(lstDistributionList[1].getValue(), selectedCampaign.Id, false, lstDistributionList[1].getLabel());
      }*/
   }
   
   public void loadAccessibleDistributionLists(){
      // This function is used to load the distribution lists 
      loadTargetListComponent = new CM_LoadTargetListOnDL();
      lstDistributionList = loadTargetListComponent.lstDistributionList;
      //6/7/2012 UV : added this default value to the lstDistributionList
     //6/25/2012 UV : update the default value add only in case list is not empty.
      if(!lstDistributionList.isEmpty()) {
        lstDistributionList.add(0, new SelectOption('',Label.CM_PleaseSelectListTrackerImport));
      }
      
      
   }// end of loadAccessibleDistributionLists()
   
   public void updateStructuredFeedbackValues(CM_DataUtil_WS.CampaignWrapper selectedCampaign){
      //This function is used to update StructuredFeedback values for chatter component
      feedbackView = new List<String>();
      feedbackRole = new List<String>();
      feedbackRegion = new List<String>();
      feedbackAccount = new List<String>();
       
      feedbackView.add('- View -');
      feedbackRole.add('- Role -');
      feedbackRegion.add('- Region -');
      feedbackAccount.add('- Acct Type -');
       
          if(selectedCampaign.Feedback_View <> null && selectedCampaign.Feedback_View <> ''){
            feedbackView.addAll(selectedCampaign.Feedback_View.split(';'));
          }
          
          if(selectedCampaign.Feedback_Role <> null && selectedCampaign.Feedback_Role <> ''){
            feedbackRole.addAll(selectedCampaign.Feedback_Role.split(';'));
          }
          
          if(selectedCampaign.Feedback_Region <> null && selectedCampaign.Feedback_Region <> ''){
            feedbackRegion.addAll(selectedCampaign.Feedback_Region.split(';'));
          }
          
          if(selectedCampaign.Feedback_Account_Type <> null && selectedCampaign.Feedback_Account_Type <> ''){
            feedbackAccount.addAll(selectedCampaign.Feedback_Account_Type.split(';'));
          }      
      
   }
   
   public void refreshChatter(){
     // This function is used to manually refresh the chatter component. 
     // do nothing      
   }
   
  //10/11/2012: Jitendra CRMGPS-2504 Change the Selection of Distibution List
  /*public void updateDistributionList(){
    // Bind selected distribution id to the user's mapped employee
    if (currentEmployee <> null && currentEmpLastSelectedDistributionList <> NULL && currentEmpLastSelectedDistributionList.trim() <> ''){
        currentEmployee.Last_Selected_Distribution_List__c = currentEmpLastSelectedDistributionList;                   
        update currentEmployee;
    }
  }*/
  public void updateEmployeeDetail(){
    if (currentEmployee <> null){
      currentEmployee.IsUseMyContactList__c = currentEmpIsUseMyContactList;
      currentEmployee.Last_Selected_Distribution_List__c = currentEmpLastSelectedDistributionList;
      update currentEmployee;
    }
  }
  
  @RemoteAction
  public static List<String> redirect(String Uid)
  {  	
  	//Verify if a previous Login As session is active for the current user and clear the session
  	 if((Uid == null)||(Uid == '')){
    	
    	List<GPSCampaignsLoginAs__c> loggedUserList =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =:UserInfo.getUserId() and Login_As_User__c != null limit 1];
    	
    	if(loggedUserList.size() > 0){
    		User u = [select Name from User where Id = :loggedUserList[0].Login_As_User__c];
    		
    		List<String> UserDetails =new List<String>();
    		UserDetails.add(loggedUserList[0].Login_As_User__c);
    		UserDetails.add(u.Name);
    		
    		return UserDetails;				
    	}
    	
  	 }
  	 return null;      
  }
  
}