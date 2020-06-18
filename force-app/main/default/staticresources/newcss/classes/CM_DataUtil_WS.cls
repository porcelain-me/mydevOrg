/**
  09/14/2011: RJ: Original: Added as data retrieval unit for Focus call campaigns application
  09/28/2011: UV: added condition final variables if no instance define for custom setting(CM_LIMIT_SETTINGS) line(#10-15)
  02/03/2012 : RJ: Modified to include a new method(getCampaign) to return campaignwrapper object
  10/11/2012: Jitendra CRMGPS-2504 Make the Target List Import Selection Sticky 
  18/03/2016:Replaced Employee__c with GPSEmployee__c by Swapnd
**/
public with sharing class CM_DataUtil_WS {
    
    // Added below params from CM_TestClassUtilities while Campaing Migration Activity to remove dependancy.
    // by Sudarshan K. on 17th Feb 2016
    private final static Integer CM_CBM_LIMIT = 1000;
    private final static Integer CM_Summary_Length = 350;
    private final static Integer CM_NO_OF_ATTACHMENTS = 2;
    private final static Integer CM_Attachment_Name_Length = 60;
    private final static Integer CM_Milestone_Description_Length = 75;
    private final static String CM_No_Campaigns_Error_Message = 'There are no campaigns available!';
      
     private static CM_LIMIT_SETTINGS__c settings = CM_LIMIT_SETTINGS__c.getInstance();
     
     public final static Integer CBM_LIMIT = settings.CBM_LIMIT__c <> null ? settings.CBM_LIMIT__c.intValue() : CM_CBM_LIMIT;
     public final static Integer SUMMARY_LENGTH = settings.Summary_Length__c <> null ? settings.Summary_Length__c.intValue() : CM_Summary_Length;
     public final static Integer NO_OF_ATTACHMENTS = settings.NO_OF_ATTACHMENTS__c <> null ? settings.NO_OF_ATTACHMENTS__c.intValue() : CM_NO_OF_ATTACHMENTS;
     public final static Integer ATTACHMENT_LENGTH = settings.Attachment_Name_Length__c <> null ? settings.Attachment_Name_Length__c.intValue() : CM_Attachment_Name_Length;
     public final static Integer MILESTONE_DESC_LENGTH = settings.Milestone_Description_Length__c <> null ? settings.Milestone_Description_Length__c.intValue() : CM_Milestone_Description_Length;
     public final static String No_Campaigns_Error_Message = settings.No_Campaigns_Error_Message__c <> null ? settings.No_Campaigns_Error_Message__c : CM_No_Campaigns_Error_Message;
     //Login-As Custom functionality
     public static String loggedInUserId { get; set; }
     public  static String loggedInUserName { get; set; }
    
     private static User curentUser{get;set;}     
     // public properties
     public final static String DEFAULT_CAMPAIGN_STATUS_SELECTION = 'Active';
     public final static String DEFAULT_REGION_SELECTION = 'All';
     public static boolean isAdminProfile = false;
     
     static {
        //system.debug('ApexPages.currentPage()'+ApexPages.currentPage());
      /***** Login-As custom functionality by swapna Start Code***/
      //if(ApexPages.currentPage() != null){
        if(ApexPages.currentPage().getParameters().get('UId') != null && ApexPages.currentPage().getParameters().get('UId') != ''){
            loggedInUserId = ApexPages.currentPage().getParameters().get('UId');
            List<User> lstUser = [SELECT Id, UserName,Profile.Name FROM User WHERE IsActive = true AND Id = :loggedInUserId];
            if(!lstUser.isEmpty()){
                /*if(lstUser[0].Profile.Name =='System Administrator Classic' || lstUser[0].Profile.Name =='System Administrator' )
                {
                    isAdminProfile = true;
                }*/
                loggedInUserId = lstUser[0].Id;
                loggedInUserName = lstUser[0].UserName;
            }else{
                loggedInUserId = System.Userinfo.getUserId();
                loggedInUserName = System.UserInfo.getUserName();
                //isAdminProfile = true;
            }
        }else{
            loggedInUserId = System.Userinfo.getUserId();
            loggedInUserName = System.UserInfo.getUserName();
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
        /*}
        else{
            loggedInUserId = System.Userinfo.getUserId();
            loggedInUserName = System.UserInfo.getUserName();
            isAdminProfile = true;
        }*/
        /************* End Code *********/ 
         // query the current user data
       for(User u :[Select UserRole.Name, u.TimeZoneSidKey,u.Profile.Name, u.ProfileId,Emp_ID__c, u.Name ,FirstName,LastName
                     ,Email From User u where id=:loggedInUserId limit 1]){
             curentUser = u;
       }
   
     }     
     public static User getCurrentUser(){
        // get the current user    
      return curentUser;
     }
     
     public static GPSEmployee__c getCurrentUserEmployee() {
          //This method is used to get the employee whose User is current user or MSID same as current user and employee is active.
        GPSEmployee__c currentEmployee;
        //10/11/2012: Jitendra CRMGPS-2504 fetched Last_Selected_Distribution_List__c, IsUseMyContactList__c alongwith query 
        //After Campaing Migration Instead of Active_Flag__c using Inactive__c field: Modified by Sudarshan K. 26th Feb 2016
        for(GPSEmployee__c emp : [Select Name, Last_Campaign_Viewed__c, Last_Selected_Distribution_List__c, IsUseMyContactList__c  from GPSEmployee__c where Active_Flag__c = true and (User__c = : Userinfo.getUserId() or MS_ID__c =:curentUser.Emp_ID__c)]){
              currentEmployee = emp;
        }
        return currentEmployee;
     }
     

     public static List<CampaignWrapper> getDefaultCampaignsList(){
         //This is used as get all the campaigns that are shown initially on the Campaigns page.
      List<CampaignWrapper> lstCampaigns = new List<CampaignWrapper>();      
      lstCampaigns = getCampaignsListOnStatusAndRegion(DEFAULT_CAMPAIGN_STATUS_SELECTION, DEFAULT_REGION_SELECTION);
      return lstCampaigns;  
     }
    
     
     public static List<CampaignWrapper> getActiveAndInactiveCampaigns(){
         //This is used as get all the campaings except than hidden from all regions.
         List<CampaignWrapper> lstCampaigns = new List<CampaignWrapper>();         
         lstCampaigns = getCampaignsListOnStatusAndRegion('All', 'All');
      return lstCampaigns;                               
     }
     
     public static Id getMostRecentActiveCampaign(){
          List<Campaign__c> mostRecentCampaign = new List<Campaign__c>();     
          Id userId = Userinfo.getUserId();
          
          map<Id, Campaign__c> campaignMap = new map<Id, Campaign__c>([Select Id From Campaign__c where Status__c <> 'Hidden' and Active__c = true and Status__c = 'Active' order by LastModifiedDate desc]);
          
          if(isAdminProfile){
              mostRecentCampaign = campaignMap.values();
             
           }
           else{
                for(Campaign__share camShare : [Select Id, ParentId From Campaign__share WHERE IsDeleted = false AND UserOrGroupId =: curentUser.Id]){
                		if(campaignMap.get(camShare.ParentId) != null)
                        mostRecentCampaign.add(campaignMap.get(camShare.ParentId));
                    }
           }
           system.debug('mostRecentCampaign'+mostRecentCampaign);  
           if(mostRecentCampaign.size() > 0) {
                return mostRecentCampaign[0].Id;    
           }
           return null;
    }
  
     
    public static List<SelectOption> getStatusSelectOptions(){
        //This method is used to get all the values in picklist that are used to filter the campaigns by their status
        transient List<SelectOption> lstSelectOption = new List<SelectOption>();
        Schema.DescribeFieldResult field = Campaign__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> sourcePicklist = field.getPicklistValues();     
        lstSelectOption.add(new SelectOption('All', 'All'));                
        for(PicklistEntry pickListEnt : sourcePicklist){
            if(pickListEnt.getValue().toLowerCase() <> 'hidden' && pickListEnt.getLabel().toLowerCase() <> 'inactive'){
                SelectOption opt = new SelectOption(pickListEnt.getValue(), pickListEnt.getLabel());
                lstSelectOption.add(opt);
            }                    
        }     
        return lstSelectOption;
    }
  
    
    public static List<SelectOption> getRegionSelectOptions(){
         //This method is used to get all the values in picklist that are used to filter the campaigns by their Region
         transient List<SelectOption> lstSelectOption = new List<SelectOption>();
         Schema.DescribeFieldResult field = Campaign__c.Region__c.getDescribe();
         List<Schema.PicklistEntry> sourcePicklist = field.getPicklistValues();     
         lstSelectOption.add(new SelectOption('All', 'All Regions'));                
         for(PicklistEntry pickListEnt : sourcePicklist){
            SelectOption opt = new SelectOption(pickListEnt.getValue(), pickListEnt.getLabel());
            lstSelectOption.add(opt);                           
         }     
        return lstSelectOption;
    }
   
    
    public static List<CampaignWrapper> getCampaignsListOnStatusAndRegion(String Status, String Region){
         //This method is used to get the filtered campaigns by their status and region passed as parameter values.
        List<CampaignWrapper> lstCampaigns = new List<CampaignWrapper>();
        Integer CBM_LIMIT_LOCAL = CBM_LIMIT;
        List<Campaign__c> camplist =  new list<Campaign__c>();
        
        String whereQuery = '';
        String regions = '';
        String stats = '';
        if(Region <> 'All'){
            whereQuery = ' AND Region__c = \'' + Region + '\'';
            regions = Region;  
        }
        
    
        if(Status <> 'All'){
            whereQuery += ' AND Status__c = \'' + Status + '\'';  
            stats = Status;
        }
        
      
        Id userId = Userinfo.getUserId();
        
        List<Campaign__c> campLists = Database.query('Select c.Status__c, c.Region__c, c.Name, c.Active__c, c.Id From Campaign__c c where c.Status__c <> \'Hidden\'' + 
                                     ' and c.Active__c = true ' +  whereQuery + ' order by c.Name ' + 
                                     ' asc limit : CBM_LIMIT_LOCAL' );
        
        map<Id, Campaign__c> campaignMap = new map<Id, Campaign__c>();
        
        campaignMap.putAll(campLists);
        
        //map<Id, Campaign__c> campaignMap = new map<Id, Campaign__c>([Select c.Status__c, c.Region__c, c.Name, c.Active__c, c.Id From Campaign__c c where c.Status__c <> 'Hidden' and c.Active__c = true and Region__c =:regions and Status__c =: stats order by c.Name asc limit : CBM_LIMIT_LOCAL]);
                                        
      /*for(Campaign__c c : (List<Campaign__c>)Database.query('Select c.Status__c, c.Region__c, c.Name, c.Active__c, c.Id From Campaign__c c where c.Status__c <> \'Hidden\'' + 
                                     ' and c.Active__c = true ' +  whereQuery + ' order by c.Name ' + 
                                     ' asc limit : CBM_LIMIT_LOCAL' )){
        lstCampaigns.add(new CampaignWrapper(c.Status__c, c.Region__c, c.Name, c.Active__c, c.Id));
      }  */
        system.debug('isAdminProfile ---'+isAdminProfile );
        if(isAdminProfile){
            
            camplist = campaignMap.values();
                
        } else{
            for(Campaign__share camShare : [Select Id, ParentId From Campaign__share WHERE IsDeleted = false AND UserOrGroupId =: curentUser.Id]){
            			if(campaignMap.containsKey(camShare.ParentId))
                        camplist.add(campaignMap.get(camShare.ParentId));
              }
        }
        system.debug('lstCampaigns'+camplist);
        for(Campaign__c c : camplist) {
            lstCampaigns.add(new CampaignWrapper(c.Status__c, c.Region__c, c.Name, c.Active__c, c.Id));
        }  
        system.debug('lstCampaigns'+lstCampaigns);                           
        return lstCampaigns;
    }
   
    public static CampaignWrapper getCurrentCampaign(Id campaignId){
        //This method is used to get the campaign values from the database using the camoaignId passed in the parameter.
      if(campaignId <> null) {
	      List<Campaign__c> campaignList = [Select c.Allow_Target_List_Import__c, c.Active__c, c.Structured_Feedback__c, c.Show_Campaign_Metrics__c, c.Name, c.Feedback_View__c, c.Feedback_Role__c, c.Feedback_Region__c, c.Feedback_Account_Type__c, 
	                                      c.Campaign_Summary__c, c.Call_Certification__c From Campaign__c c where c.Id =: campaignId and c.Status__c <> 'Hidden' and c.Active__c = true limit 1];
	                                     
	      if(campaignList.size() > 0){
	        return new CampaignWrapper(campaignList[0]);
	      }
      } 
      return null;                                   
    }
 
    public static CampaignWrapper getCampaign(Id campaignId){
    	  // 02/03/2012 : RJ
    	  // This method is used to get the campaign values from the database 
    	  // using the camoaignId passed in the parameter.
    	  // irrespective of its status
      if(campaignId <> null) {
        List<Campaign__c> campaignList = [Select c.Allow_Target_List_Import__c, c.Active__c, c.Structured_Feedback__c, c.Show_Campaign_Metrics__c, c.Name, c.Feedback_View__c, c.Feedback_Role__c, c.Feedback_Region__c, c.Feedback_Account_Type__c, 
                                        c.Campaign_Summary__c, c.Call_Certification__c From Campaign__c c where c.Id =: campaignId limit 1];
                                       
        if(campaignList.size() > 0){
          return new CampaignWrapper(campaignList[0]);
        }
      } 
      return null; 
    }
 
        
    public class CampaignWrapper{
        public Id Id{get;set;}      
        public boolean Structured_Feedback{get;set;} 
        public boolean Show_Campaign_Metrics{get;set;} 
        public String Name{get;set;} 
        public String Feedback_View{get;set;} 
        public String Feedback_Role{get;set;} 
        public String Feedback_Region{get;set;} 
        public String Feedback_Account_Type{get;set;}  
	      public String Campaign_Summary{get;set;} 
	      public boolean Call_Certification{get;set;} 
	      public String Status{get;set;}
	      public String Region{get;set;}
	      public boolean IsActive{get;set;}
	      public boolean allowTargetListImport{get;set;}
	      public CampaignWrapper(Campaign__c c){
	        this.Id = c.Id;
	        this.Structured_Feedback = c.Structured_Feedback__c; 
          this.Show_Campaign_Metrics = c.Show_Campaign_Metrics__c; 
          this.Name = c.Name; 
          this.Feedback_View = c.Feedback_View__c == null ? '' : c.Feedback_View__c; 
          this.Feedback_Role = c.Feedback_Role__c == null ? '' : c.Feedback_Role__c; 
          this.Feedback_Region = c.Feedback_Region__c == null ? '' : c.Feedback_Region__c; 
          this.Feedback_Account_Type = c.Feedback_Account_Type__c == null ? '' : c.Feedback_Account_Type__c; 
          this.Campaign_Summary = c.Campaign_Summary__c == null ? '' : c.Campaign_Summary__c; 
          this.Call_Certification = c.Call_Certification__c == null ? false : c.Call_Certification__c;
          this.allowTargetListImport = c.Allow_Target_List_Import__c;
	      }      
	      
	      public CampaignWrapper(String Status, String Region, String Name, boolean IsActive, Id Id){
	        this.Status = Status == null ? '' : Status;
	        this.Region = Region == null ? '' : Region;
	        this.Name = Name;
	        this.IsActive = IsActive;
	        this.Id = Id;
	      }      
      
    }
         
}