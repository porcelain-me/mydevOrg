//  
//   (c) 2010 Appirio, Inc.
//
//   MyiiListController (Controller class for MyiiListpage)
//   Displays the Names and Accounts of the logged-in user's Target List
//
//   16 Mar 2010   Chetan Garg      Original (PR-04048).
//   26 Jul 2010   Chetan Garg      Ability to change the user on the MyiiList Page (PR-05523).
//                                  New Columns for MyiiList Page (PR-05522).
//                                  Removing 1 or many Target Members (PR-05524).
//   27 Jul 2010   Chetan Garg      Users to reassign target list members (contacts) and checkboxes.(PR-05520).   
//   29 Jul 2010   Kapil Choudhary  Adding some fields in query string for Target_List__c.[PR-05602]
//   01 Aug 2010   Kapil Choudhary  Added a Function updateReassignedViewedByUser [PR-05620].
//   03 Aug 2010   Chetan Garg      SET Reassigned_Date__c = NOW() when target list member is reassigned.
//   03 Aug 2010   Parth Tamhaney   Changes to fetch top 3 Voter recomemndations and show the more... link
//   05 Aug 2010   Kapil Choudhary  Added a line of code in query string for sorting  [PR-05715].
//   10 Aug 2010   John Gorup       Changed list in isAdminProfiles
//   12 Aug 2010   Chetan Garg      Changed the isAdminProfiles to use the custom setting: MyiiList Admin Profiles  
//   12 Aug 2010   Kapil Choudhary  Adding, Reassigning  a contact according to Login As User in target list. [PR-05772]
//   19 Aug 2010   Kapil Choudhary  Added three fields in query for target list to make the key milestone labels configurable. [PR-05901]
//   20 Aug 2010   Kapil Choudhary  Added a where condition. [PR-05924]
//   21 Aug 2010   Kapil Choudhary  Add a function "getUserCampaignsList" for user's current target list to display their list of contacts to call about the campaign.[PR-05948]
//   25 Aug 2010   Kapil Choudhary  Email Only Client functionality Implemented  [PR-05946]
//   01 Sep 2010   Kapil Choudhary  To view sample Email pdf  Attachment on iiCampaign object, created a function getSampleEmailPDF()  [PR-06048]
//   03 Sep 2010   Kapil Choudhary  Create a class and implement functionality to show Login as Functionality an Green Bar away.[PR-06072]
//   07 Sep 2010   Kapil Choudhary  Update RefreshList method for EmailOnly grid section
//   07 Sep 2010   Parth Tamhaney   Changes for 
//                                              Setting iilanguage (added changeContactIILanguage())
//                                              Removing EmailOnly Target List Member(Updated removeMembersFromList())
//   14 Sep 2010   Chetan Garg     Changes for 
//                                      PR-06202: Default Sort Order - Account Asc, Contact.firstName asc                
//                                      PR-06189: Make iiLanguage configurable
//                                      PR-06192: Make columns sortable on the myiilist page
//   15 Sep 2010   Chetan Garg   Changes for 
//                                      PR-06225: Add the "list" the contact is on.
//   15 Sep 2010   Kapil Choudhary  added a function "removeCallOnly" on tab "Clients to Call' for button called "Move to Email Only List'
//                                      PR-06223
//
//   15 Sep 2010    Parth Tamhaney   Changes for PR-06228 (Improvements when changing campaigns)
//                                  -Added new property String xls_userTargetListId {get;set;} for Export functionality- to pass targetListId to Export functionality
//                                  -Added Lines 151,154,326,329 to set value of xls_userTargetListId.
//                                  -Updated getExportList() to chk if  userTargetListId == 'null'  Lines 741
//                                  -Updated  GetAnalystList() to reset  AnalystOptions (Line 362)
//                                  -Updated populateTargetListUserList() to reset  listOfMyMembers ,isEmailOnlyOn ,reset Sorting,isFirst,ContactCalledPertange , ContactCalled ,xls_userTargetListId
//                                      Lines(275-280) 
//   16 Sep 2010   Chetan Garg     Use List assignment instead of Looping; Lines : 288
//   20 Sep 2010   Kapil Choudhary Added two fiels in query string PR-06264 
//   21 Sep 2010   Chetan Garg     Refactored code and remove unused methods
//                                 (PR-06273): Performance on switching tabs to contacts to call and Email only contacts.    
//   22 Sep 2010  Kapil Choudhary   Added three fields in query string.[PR-06322]
//   24 Sep 2010  Kapil Choudhary   Made Chnages in wrapper class for Additional contact list.[PR-06325]
//   01 Oct 2010  Kapil Choudhary   Added condition On switching regions so that current user's list is not pulled up. [PR-06476]
//   04 Oct 2010  Chetan Garg       PR-06528: Make the View II Campaign Launch Presentation Configurable
//                                  PR-06529: Make a "Talking Points" link, configurable   
//
//   28 Oct 2010  Kapil Choudhary   Divided the function "reassignMembersToList" in to two parts for reassign contact for email only tab. [PR-06854]
//   29 Oct 2010  Kapil Choudhary   Added a function "changeEmailEligibility" for [PR-06865]; 
//  08 NoV 2010  ParthT             PR-07002 (Get "Contact has been Called" working like other options )
//                                  Lines 444 and 478- added Contact_has_been_called__c,User_Who_Called_the_Contact__r.FirstName,User_Who_Called_the_Contact__r.LastName to query       
//  09 Nov 2010  ParthT             Set Eligible_for_email__c for Reassignments 
//                                  Added isEmailOptionEditable field to MemberWrapper class and set it to true if account is in exclusion list 
//  22 Nov 2010  Kapil Choudhary    Added a clause in query for [PR-07217]
//  06 Dec 2010  Kapil Choudhary    Updated for When Target List II Group = "Research", Email? column read-only [PR-07371]
//  10 Dec,2010  Kapil Choudhary    Updated for Inactivate Voter Recommendations instead of deleting [PR-07419].
//  14 Dec,2010  Parth Tamhaney     Updated fillListOfMembers to Show COntacts with Non deleted Voter Recommendations (for export only)
//  15 Dec,2010  Parth Tamhaney     Changed Logic in Export to exclude contacts with deleted Voter recommendations
//  12/15/2010   ParthT         PR-07489 - Hide "Move to email only list" Button and Email List Tab if    targetlist.Sends_Email__c = 'No'   
//  12/16/2010   ParthT         Merged Code for Paging.  
//  12/17/2010   ParthT         removed extra loop in  buildWrapperMembers (line 727)
// 12/31/2010    Chetan Garg    PR-07703 - Morgan Stanley - II - Pagination requirement refinement with use cases
//
// 01/04/2011    ParthT         Added missing Export functionality in case when Analyst is selected (anslyst<> null) in fillListOfMembers() 
//                                  lines 581-621       
//
//5 Jan 2011 ParthT:  Changes to show contacts with deleted Voter recommendations   (changes in fillListOfMembers() )
//01/05/2011   Chetan Garg    PR-07767 - A few issues with Key Milestones and Campaign Resources & wireframe
//                            PR-07770 - Move this code from hotfix to GPSQA7 (other owner actions)
//                            PR-07768 - Exclude ANY document from the resources = "important_news"
//                            PR-07771 - Move this code from hotfix to GPSQA7 (important_news)    
//
//17/01/2011     Kapil Choudhary Updated getVoterCount() function to get # of of_Non_II_Friendly_Non_Closed__c which is modified outside from this controller (i.e. MyListVoteController). 
// 07/07/2001    Andrey Volosevich
//                  JIRA CRMGPS-185: Added new field Campaign_Summary_Header__c to queries at lines: 199, 420, 448                                      
//11/27/2012    Jitendra:   CRMGPS-2884 II Campaign - Voting Panel Enhancement
//03/15/2013    Jitendra:   CRMGPS-2884 Update the Email Tab to reflect Recommended Analysts
//13/04/2015 VM : Included the 'Number of Contacts called' and '% Contacts called' in the 'How am i doing' section , Changed target list queries to include fields.
//08/06/2015 : Changed the Current List code to share list with other users.
//Jira 4499  VM : Changed the code of changetargetlist  method and getUserCampaignsList method for campaign emhamcements
/*For JIRA-4815 replaced UserInfo.getUserId() with String loggedInUserId by Sudarshan K. on 2nd May 2016*/
public class MyiiListController {   
	/**********Login-As custom functionality by Sudarshan K. 02nd May 2016 Start Code******/
	public boolean isDiffUserLogin { get; set; }  
	public String loggedInUserId { get; set; }	
	/************************End Code***********************************/
    public MyListEmailRecipientController emailOnlyController {get;set;}
    public boolean isEmailOnlyOn{get;set;}
    //Hold List of Target members of Logged-in User's Target List
    public List<MemberWrapper> listOfMyMembers {get;set;}
    public String selectedId {get;set;}
    public String selectedContactId {get;set;}  
    public String selectedLang {get;set;} 
    
    //  4 Jan 2011   Chetan Garg    PR-07743 - Hotfix: Add Important_News.jpeg to the myiiList page
    //Warning message on iiList     
    public String warningImageUrl {get;set;}
    public String warningDocUrl {get;set;}
    
    //Help Documents
    public List<HelpDocument> helpDocuments {get;set;}
    /*
    public Boolean status {get;set;}
    */
    public String reason {get;set;}  
    public Target_List__c userTargetList {get;set;}
    private List<SelectOption> analystOptions;
    public String selectedAnalyst {get;set;}    
    public List<SelectOption> getAnalysts() {            
            return analystOptions;
    }
    public Integer ContactCalled {get;set;}
    public Decimal ContactCalledPertange  {get;set;}
    public Decimal ContactedNumber { get; set; }
    public Decimal ContactedPercentage { get;  set; }
    
  //14 december 2010
    public Integer RECORD_PAGE_SIZE = 25;
    public ApexPages.StandardSetController listTargetMemberSet{get;set;}
    public Integer CurrentPageNumber {get;set;}
    public String currentpagesize {get;set;}
    public List<Target_List_Member__c> listCurrentPageTargetListMember;
   //public List<Integer> pageIndexNumber {get;set;}//24-Jan-2011
    public List<String> pageIndexNumber {get;set;}//24-Jan-2011
    public List<String> ShowRecordsOnPage {get;set;}
    
    //21 december 2010
    //public iiCampaign_Milestone__c mostactivemilestone {get;set;}
    public MilestoneWrapper mostactivemilestone {get;set;}
    
    //public List<iiCampaign_Milestone__c> lstMilestone {get;set;}
    public List<MilestoneWrapper> lstMilestoneWrapper {get;set;}
    public String mostactivemilestoneId {get;set;}
    public Integer daysLeft {get;set;}
    
    public List<CampaignHeader> listCampaigns {get;set;}
    public List<Target_List__c> listTargetListUsers {get;set;}
    public Boolean isAdminProfiles {get;set;}
    public integer unviewedCount {get;set;}
    public List<Target_List__c> listUserCampaigns {get;set;}
    public Attachment sampleEmailPDf {get;set;}//sample_email.pdf
    public Attachment talking_pointspdf {get;set;}//talking_points.pdf
    public Attachment campaign_presentationpps {get;set;}//campaign_presentation.pps
    public string currentcampaign{get;set;}
    public string currentusername{get;set;}
    public String xls_userTargetListId {get;set;}
    public List<Target_List_Member__c> otherlistmember{get;set;}
    public boolean emailEditable {get;set;}
    
    public String  gotoPageRange  {get;set;}//24-Jan-2011
    public static Integer MAX_LIMIT = 9999; 
    /**
     For sorting
    **/
    
   public String sortOrder {get; set;} // '1'-'ASC'; '2'-'DESC'
   public String sortOn {get; set;} // Contact ,Account
   
   public list<String> listTargetId {get; set;}
    
   private Map<String,String> SORTING_ORDER_MAP = new Map<String,String>{'1'=>'ASC','2'=>'DESC'};
   private Map<String,String> SORT_BY_MAP = new Map<String,String>{'Default' => 'GPSContact__r.GPSAccount__r.Name, GPSContact__r.FirstName__c,GPSContact__r.LastName__c ',
                                                              'Contact'=>'GPSContact__r.Name ',
                                                              'Account'=>'GPSContact__r.GPSAccount__r.Name ',
                                                              'Lang' => 'GPSContact__r.II_Language__c',
                                                              'Reassigned' => 'Reassigned_By_Preferred_Name__c ',
                                                              'EmailEligible' => 'Eligible_for_email__c'};
   public boolean showHeaderTabs {get;set;}
   public String iTrakUserName {get;set;}
    
    public MyiiListController(){
        //IE9 Visualforce hack   
    	String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        if(browserType != null && browserType.contains('MSIE')){
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        }
          gotoPageRange = '';//24-Jan-2011
        //  4 Jan 2011   Chetan Garg    PR-07743 - Hotfix: Add Important_News.jpeg to the myiiList page
        //Warning Content
        warningImageUrl = warningDocUrl = '';
        helpDocuments  = new List<helpDocument>();
        emailOnlyController = new MyListEmailRecipientController();
        isEmailOnlyOn = false;
        resetSorting();
        unviewedCount =0;
        isEmailOnlyOn =false;
        //analystOptions = new List<SelectOption>();
        //analystOptions.add(new SelectOption('','-Select an Analyst Team-'));
        ContactCalledPertange = ContactCalled =  0;
        ContactedPercentage = ContactedNumber = 0;
        userTargetList = new Target_List__c();
        listUserCampaigns = new List<Target_List__c>();
         //14 Dec 2010
        listTargetMemberSet = null;
        currentpagesize = '25';
        CurrentPageNumber =0;
        listCurrentPageTargetListMember = new List<Target_List_Member__c>(); 
        //pageIndexNumber = new List<Integer>(); 24-Jan-2011
        pageIndexNumber = new List<String>(); //24-Jan-2011
        ShowRecordsOnPage = new String[]{'25','50','100'};
        
        currentpagesize = ShowRecordsOnPage[0];
        
        // 21 december 2010
        lstMilestoneWrapper = null;
        mostactivemilestoneId = '';
        
        iTrakUserName = UserInfo.getUserName();
        
        /**********Login-As custom functionality by Sudarshan K. 02nd May 2016 Start Code******/
        if(ApexPages.currentPage().getParameters().get('UId') != null){
        	loggedInUserId = ApexPages.currentPage().getParameters().get('UId');
        	List<User> lstUser = [SELECT Id FROM User WHERE IsActive = true AND Id = :loggedInUserId];
        	if(!lstUser.isEmpty()){
        		loggedInUserId = lstUser[0].Id;        		
        		isDiffUserLogin = true;
        	}else{
        		loggedInUserId = System.Userinfo.getUserId();        		
        		isDiffUserLogin = false;
        	}
        }else{
        	loggedInUserId = System.Userinfo.getUserId();        	
        	isDiffUserLogin = false;
        }	
        
        /********************************End Code******************************************/
        
        showHeaderTabs = true;
        if(ApexPages.currentPage().getParameters().get('showheadertabs') != null){
        	if (ApexPages.currentPage().getParameters().get('showheadertabs') == 'false'){
        		showHeaderTabs = false;
        	}        	
        }
        
        //Get  isAutorized
        for (Target_List__c targetList : [Select t.User__c, t.Id, t.Authorized__c ,t.iiCampaign__r.II_Voting_closes__c, iiCampaign__r.Campaign_Name__c,
                                          t.iiCampaign__r.II_Delivers_Ballots__c, t.iiCampaign__r.Campaign_Kicks_Off__c,User__r.Name,Preferred_User__c,
                                          t.iiCampaign__r.Why_do_we_care_about_II__c, t.iiCampaign__r.Campaign_Summary_Header__c, t.iiCampaign__r.Step_2_Title__c,
                                          t.iiCampaign__r.Step_2_Text__c,t.iiCampaign__r.Step_1_Title__c,
                                          t.iiCampaign__r.Step_1_Text__c,t.iiCampaign__r.Show_List_Statistics__c,
                                          t.iiCampaign__r.Users_can_add_contacts__c,t.iiCampaign__r.Users_can_Reassign_Contacts__c,
                                          t.iiCampaign__r.Users_can_Remove_Contacts__c, t.iiCampaign__r.Users_can_export_list_to_Excel__c,
                                          t.iiCampaign__r.User_can_see_Sample_Email_button__c,t.iiCampaign__r.Users_can_filter_list_by_recommendation__c,
                                          t.iiCampaign__c ,Number_of_Target_Members__c,iiCampaign__r.Show_Email_Only_Page__c,iiCampaign__r.Users_can_set_if_contacts_get_email__c,
                                          t.iiCampaign__r.Campaign_Milestone_1__c,t.iiCampaign__r.Campaign_Milestone_2__c
                                          ,t.iiCampaign__r.Campaign_Milestone_3__c,iiCampaign__r.Campaign_is_Multilingual__c,t.iiCampaign__r.Users_can_control_email_only_list__c,
                                          t.iiCampaign__r.What_is_the_Clients_to_Call_List__c,t.iiCampaign__r.What_is_the_Email_Only_Clients_List__c,
                                          t.iiCampaign__r.Campaign_Presentation_Link_Text__c , t.iiCampaign__r.Show_Campaign_Presentation__c,
                                          t.iiCampaign__r.Talking_Points_Link_Text__c,t.iiCampaign__r.Show_Talking_Points_Link__c,t.II_Group__c,                     
                                          t.iiCampaign__r.Email_only_Contacts_Tab_Text__c, t.iiCampaign__r.Contacts_to_Call_Tab_Text__c,t.iiCampaign__r.Email_Help_Text__c,t.iiCampaign__r.Show_Not_II_Friendly__c
                                          ,t.iiCampaign__r.II_Help_Email__c,t.iiCampaign__r.II_Help_Email_Subject__c,t.Sends_Email__c,Current_Page_Size__c
                                          ,iiCampaign__r.Show_Important_News__c,t.II_Friendly_Call_Members__c,of_Non_II_Friendly_Non_Closed__c 
                                          ,iiCampaign__r.Recommendation_Text__c , t.Number_of_Contacted_Members__c , t.Contacted__c  
                                          From Target_List__c t 
                                          where User__c =: loggedInUserId
                                          /* Commented for JIRA-4815 by Sudarshan K. on 2nd May 2016
                                          where User__c =: System.Userinfo.getUserId()*/ 
                                          and t.iiCampaign__r.Active_Flag__c = true
                                          Order by iiCampaign__r.Start_Date__c desc  limit 1]){
            
            userTargetList  = targetList;
           
               System.debug('==========GetUserId = :'+ System.Userinfo.getUserId() );
               //System.debug('==========TargetList = :'+ targetList.Sends_Email__c );
               System.debug('==========TargetList = :'+ usertargetList );
        }
        
           
        //Login As functionlity for Administartor
         getAdminProfiles();
         //isAdminProfiles = false;
         if(isAdminProfiles){
             populateCampaignList();
             if(listCampaigns.size() > 0){
                currentcampaign = listCampaigns[0].displayName;
                selectedCampaign = listCampaigns[0].headerId;
                populateTargetListUserList();
                system.debug('-------currentcampaign-------'+currentcampaign);
                system.debug('-------selectedCampaign-------'+selectedCampaign);
             }  
         }else{
             getUserCampaignsList();
             
             if(listCampaigns.size() > 0){
                
                currentcampaign = listCampaigns[0].displayName;
                selectedCampaign = listCampaigns[0].headerId;
                //populateTargetListUserList();
                listTargetListUsers = [Select User__c,iiCampaign__c, User__r.Name,Preferred_User__c,id,Sends_Email__c,Current_Page_Size__c
                                   From Target_List__c t
                                   Where Authorized__c = true and id in : listTargetId and iiCampaign_Name__c = :currentcampaign];
                                   
                                   
                system.debug('listTargetListUsers-------------------' + listTargetListUsers);                                 
                system.debug('-------currentcampaignNew-------'+currentcampaign);
                system.debug('-------selectedCampaignNew-------'+selectedCampaign);
                
             } else { 
                             
            if(userTargetList.id != null){
                 currentcampaign = userTargetList.iiCampaign__r.Campaign_Name__c;
                 selectedCampaign = userTargetList.iiCampaign__c;
            } 
             
         }
             getSampleEmailPDF(selectedCampaign);
         }
         system.debug('-------currentcampaign-------'+currentcampaign);
         system.debug('-------selectedCampaign-------'+selectedCampaign);
        
        /* commented this for jira-4815 by Sudarshan K. on 2nd May 2016
        selectedTargetListUsers = System.Userinfo.getUserId();*/
        selectedTargetListUsers = loggedInUserId;
        System.debug('==========UserTargetList = :'+ userTargetList );
        if(userTargetList.id == null){
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'MyiiList does not exist'));
              xls_userTargetListId = 'null';
              return;
        }else{
            xls_userTargetListId = userTargetList.Id;
        }
       
        listOfMyMembers = new List<MemberWrapper>();
        
        if(userTargetList.Authorized__c){
            GetAnalystList();
            fetchTargetListMembers();
        }
        otherlistmember = new List<Target_List_Member__c>();

       //21 december 2010
       setMilestone(selectedCampaign); 
    }
    
    private void setMilestone(String campaignId){
          daysLeft = -1; 
        mostactivemilestone = null;
        //lstMilestone = new List<iiCampaign_Milestone__c>();
        lstMilestoneWrapper = new List<MilestoneWrapper>();
        system.debug('_____________________userTargetList.iiCampaign__c_________'+userTargetList.iiCampaign__c);
        if(campaignId != null && campaignId !='')
         {
             for(iiCampaign_Milestone__c milestone :[Select i.iiCampaign__c, i.Title__c, i.Name, i.Milestone__c, i.Id, i.Due_date__c,Is_Active__c 
                                                                                             From iiCampaign_Milestone__c i 
                                                                                             where i.iiCampaign__c =:campaignId
                                                                                             Order by  Due_date__c asc 
                                                                                             limit :MAX_LIMIT] ){
                if( milestone.Due_date__c >=date.today() && mostactivemilestone == null){
                        daysLeft = date.today().daysBetween(milestone.Due_date__c);                         
                        mostactivemilestoneId = milestone.id;
                        //mostactivemilestone = milestone;
                        mostactivemilestone = new MilestoneWrapper(milestone);
                 }
                 //lstMilestoneWrapper.add(milestone);
                 lstMilestoneWrapper.add(new MilestoneWrapper(milestone));
              }
         }
         system.debug('_____________________lstMilestoneWrapper_________'+lstMilestoneWrapper.size());
    }
    
    //Populate current Campaign PDF Attachment
    private void getSampleEmailPDF(String campaignId){
         warningImageUrl = warningDocUrl = '';
        helpDocuments = new List<HelpDocument>();
        sampleEmailPDf = talking_pointspdf = campaign_presentationpps = null;
        system.debug('===========campaignId======>'+campaignId);
        
        Set<String> attachmentExcludedInHelpDocs = new Set<String>{'important_news.jpg','important_news.doc'};
        for( Attachment attach : [Select Id ,Name
                                  From Attachment 
                                  where ParentId =:campaignId]){
          if(attach.Name == 'sample_email.pdf'){
            sampleEmailPDf = attach;    
          }else if (attach.Name == 'talking_points.pdf'){
            talking_pointspdf  = attach;
          }else if (attach.Name == 'campaign_presentation.pps'){
            campaign_presentationpps  = attach;
         }else if(attach.Name == 'important_news.jpg'){
            warningImageUrl = attach.id;
          }else if (attach.Name == 'important_news.doc'){
            warningDocUrl = attach.id; 
          }   
          
          if(!attachmentExcludedInHelpDocs.contains(attach.Name)){
                helpDocuments.add(new HelpDocument(attach));
          } 
          System.debug('===============helpDocAdded==========='+attach.Name);
                
      }
      
      system.debug('===========helpDocuments======>'+isAdminProfiles);
    }
    
    //Changed by Chetan Garg on 08/12/2010 Fetch Admin Profile from CUSTOM SETTING MyiiList Admin Profiles 
    private void getAdminProfiles(){
        Set<String> adminProfiles = new Set<String>();
        for(MyiiListAdminProfiles__c adminProfile : MyiiListAdminProfiles__c.getAll().values() ){
          adminProfiles.add(adminProfile.MyiiList_Admin_Profile__c);
        }
        isAdminProfiles = false;
        
        System.debug('======Admin Profiles========'+ adminProfiles);
        list<PermissionSetAssignment> listPermision = new list<PermissionSetAssignment>();
        listPermision = [select PermissionSet.Name from PermissionSetAssignment where Assignee.Id =:loggedInUserId];
        for(PermissionSetAssignment usrper : listPermision){
            system.debug('=============usr.profile.Name==========='+usrper.PermissionSet.Name);
            if(adminProfiles.contains(usrper.PermissionSet.Name)){
                isAdminProfiles = true;     
                //currentusername= '';
            }   
        }
        
        for(User usr : [Select u.name,u.Profile.Name, u.ProfileId From User u where id =:loggedInUserId ]){
            system.debug('=============usr.profile.Name==========='+usr.profile.Name);
            if(adminProfiles.contains(usr.profile.Name)){
                isAdminProfiles = true;     
                //currentusername= '';
            }   
        }
        
    }
    
    //[PR-05948] 21 Aug 2010
    public void getUserCampaignsList(){
      listUserCampaigns = new List<Target_List__c>();
      listCampaigns = new List<CampaignHeader>();
      list<CampaignHeader> listNewCampaigns = new list<CampaignHeader>();
      Set<String> campaignName = new Set<String>();
      listTargetId = new List<String>();
      System.debug('===========getUserCampaignsList====');
      for (Target_List__c targetList : [Select iiCampaign__c,iiCampaign__r.Campaign_Name__c,id,Sends_Email__c,Current_Page_Size__c
                                    From Target_List__c t 
                                    where User__c =: loggedInUserId 
                                    and iiCampaign__r.Active_Flag__c = true
                                    Order by iiCampaign__r.Start_Date__c desc ]){
        
         System.debug('===========getUserCampaignsList===='+targetList.Sends_Email__c);
         listCampaigns.add(new CampaignHeader(targetList.id,targetList.iiCampaign__r.Campaign_Name__c));
         campaignName.add(targetList.iiCampaign__r.Campaign_Name__c);
         //listNewCampaigns.add(new CampaignHeader(targetList.id,targetList.iiCampaign__r.Campaign_Name__c));
         listTargetId.add(targetList.id);
      }
      
      //Jira 4499  VM : Added the below code to fetch campaign for the user to whom list is shared
      for (Target_List_Share__c  targetListShare : [Select Target_List__c ,Shared_with__c ,Target_List__r.iiCampaign__r.Campaign_Name__c,id
                                    From Target_List_Share__c t 
                                    where Shared_with__c =: loggedInUserId and Target_List__r.iiCampaign__r.Active_Flag__c = true 
                                    Order by Target_List__r.iiCampaign__r.Active_Flag__c desc ]){
        
         //System.debug('===========getUserCampaignsList===='+targetList.Sends_Email__c);

             if(listCampaigns.isempty()){
                
                listCampaigns.add(new CampaignHeader(targetListShare.Target_List__c,targetListShare.Target_List__r.iiCampaign__r.Campaign_Name__c));
                campaignName.add(targetListShare.Target_List__r.iiCampaign__r.Campaign_Name__c);
                //listTargetId.add(targetListShare.Target_List__c);
                
             } else {
                
                if(!campaignName.contains(targetListShare.Target_List__r.iiCampaign__r.Campaign_Name__c)){
                
                    listCampaigns.add(new CampaignHeader(targetListShare.Target_List__c,targetListShare.Target_List__r.iiCampaign__r.Campaign_Name__c));
                    campaignName.add(targetListShare.Target_List__r.iiCampaign__r.Campaign_Name__c);
                    system.debug('listNewCampaigns**'+listNewCampaigns) ; 
                    //listTargetId.add(targetListShare.Target_List__c);
                }
             
                     
          } 
          
          listTargetId.add(targetListShare.Target_List__c);
                      
          
          
          
          }
          
          
               
    }
    private void populateCampaignList(){
        listCampaigns = new List<CampaignHeader>();
        listTargetListUsers = new List<Target_List__c>();
        //Check Profile
        if(isAdminProfiles){
           // listCampaigns.add( new Selectoption('','- Select a Campaign')); 
            for (iiCampaign__c camp : [Select id, Campaign_Name__c, Name
                                       From iiCampaign__c
                                       Where Active_Flag__c = true and Campaign_Name__c != null
                                       Order by Campaign_Name__c]){
                listCampaigns.add(new CampaignHeader(camp.id,camp.Campaign_Name__c));
            }
        }
    }
    
    public String selectedCampaign {get;set;}
    public String selectedTargetListUsers {get;set;}
    
    
    public void populateTargetListUserList(){ 
        

    
        system.debug('inside populateTargetListUserList ***');
          listTargetMemberSet = null;
        //Modified by Chetan Garg ; Sep 16 2010 ; Use List assignment instead of Looping
        listTargetListUsers = [Select User__c, User__r.Name, Preferred_User__c, id,Sends_Email__c,Current_Page_Size__c
                                   From Target_List__c t
                                   Where Authorized__c = true 
                                   and iiCampaign__c= :selectedCampaign Order by Preferred_User__c];
                             
        //System.debug('================falg>>>'+listTargetListUsers[0].Sends_Email__c);
        getSampleEmailPDF(selectedCampaign);  
        listOfMyMembers = new List<MemberWrapper>();
        emailOnlyController = new MyListEmailRecipientController();
        emailOnlyController.listOfMyTarget.clear();
        unviewedCount = 0;
        analystOptions = new List<SelectOption>();
        userTargetList = new Target_List__c();
          resetSorting();
        ContactCalledPertange = ContactCalled =  0;
        ContactedPercentage = ContactedNumber = 0;
        xls_userTargetListId = 'null';
        
        String currentUserListId = null;
        currentusername = '';
        for(Target_List__c tList : listTargetListUsers){
            if(tList.User__c == loggedInUserId){
                currentusername = tList.Preferred_User__c; 
                currentUserListId = tList.id;
                userTargetList.Sends_Email__c = tList.Sends_Email__c;
                break;
            }
        }
        
        if(currentUserListId != null){
            selectedTargetListUsers = currentUserListId;
            changeTargetList();
        }else{
            //Set Campaings details for this list
            for(iiCampaign__c camp : [Select II_Delivers_Ballots__c, Campaign_Kicks_Off__c, Campaign_Name__c,
                                          Why_do_we_care_about_II__c, Campaign_Summary_Header__c, Step_2_Title__c,
                                          Step_2_Text__c,Step_1_Title__c,II_Voting_closes__c,
                                          Step_1_Text__c,Show_List_Statistics__c,
                                          Users_can_add_contacts__c,Users_can_Reassign_Contacts__c,
                                          User_can_see_Sample_Email_button__c,Users_can_export_list_to_Excel__c,
                                          Users_can_Remove_Contacts__c,Users_can_filter_list_by_recommendation__c,
                                          Show_Email_Only_Page__c,
                                          Campaign_Milestone_1__c,Campaign_Milestone_2__c
                                          ,Campaign_Milestone_3__c,Campaign_is_Multilingual__c,Users_can_control_email_only_list__c,
                                          What_is_the_Clients_to_Call_List__c,What_is_the_Email_Only_Clients_List__c,
                                          Campaign_Presentation_Link_Text__c , Show_Campaign_Presentation__c,
                                          Talking_Points_Link_Text__c,Show_Talking_Points_Link__c,
                                          Email_only_Contacts_Tab_Text__c,Contacts_to_Call_Tab_Text__c,Email_Help_Text__c,Show_Not_II_Friendly__c
                                          ,II_Help_Email__c, II_Help_Email_Subject__c
                                          ,Show_Important_News__c, Recommendation_Text__c
                                          From iiCampaign__c where id =:selectedCampaign  limit 1 ]  ){
              userTargetList.iiCampaign__r = camp;
            }
            
        }
        
        setMilestone(selectedCampaign);
            
             System.debug('======flag======'+userTargetList.Sends_Email__c);
    }
    
    private List<Target_List__c> getTargetList(String listid){
        List<Target_List__c> newTargetList = [Select t.User__c, t.Id, t.Authorized__c ,t.iiCampaign__r.II_Voting_closes__c,User__r.Name,Preferred_User__c, 
                                          t.iiCampaign__r.II_Delivers_Ballots__c, t.iiCampaign__r.Campaign_Kicks_Off__c, iiCampaign__r.Campaign_Name__c,
                                          t.iiCampaign__r.Why_do_we_care_about_II__c, t.iiCampaign__r.Campaign_Summary_Header__c, t.iiCampaign__r.Step_2_Title__c,
                                          t.iiCampaign__r.Step_2_Text__c,t.iiCampaign__r.Step_1_Title__c,
                                          t.iiCampaign__r.Step_1_Text__c,t.iiCampaign__r.Show_List_Statistics__c,
                                          t.iiCampaign__r.Users_can_add_contacts__c,t.iiCampaign__r.Users_can_Reassign_Contacts__c,
                                          t.iiCampaign__r.User_can_see_Sample_Email_button__c,t.iiCampaign__r.Users_can_export_list_to_Excel__c,
                                          t.iiCampaign__r.Users_can_Remove_Contacts__c,t.iiCampaign__r.Users_can_filter_list_by_recommendation__c,
                                          t.iiCampaign__c ,Number_of_Target_Members__c,iiCampaign__r.Show_Email_Only_Page__c,iiCampaign__r.Users_can_set_if_contacts_get_email__c,
                                          t.iiCampaign__r.Campaign_Milestone_1__c,t.iiCampaign__r.Campaign_Milestone_2__c
                                          ,t.iiCampaign__r.Campaign_Milestone_3__c,iiCampaign__r.Campaign_is_Multilingual__c,t.iiCampaign__r.Users_can_control_email_only_list__c,
                                          t.iiCampaign__r.What_is_the_Clients_to_Call_List__c,t.iiCampaign__r.What_is_the_Email_Only_Clients_List__c,
                                          t.iiCampaign__r.Campaign_Presentation_Link_Text__c , t.iiCampaign__r.Show_Campaign_Presentation__c,
                                          t.iiCampaign__r.Talking_Points_Link_Text__c,t.iiCampaign__r.Show_Talking_Points_Link__c,t.II_Group__c,
                                          t.iiCampaign__r.Email_only_Contacts_Tab_Text__c, t.iiCampaign__r.Contacts_to_Call_Tab_Text__c,t.iiCampaign__r.Email_Help_Text__c,t.iiCampaign__r.Show_Not_II_Friendly__c
                                          ,t.iiCampaign__r.II_Help_Email__c,t.iiCampaign__r.II_Help_Email_Subject__c,t.Sends_Email__c,Current_Page_Size__c
                                          ,iiCampaign__r.Show_Important_News__c, II_Friendly_Call_Members__c,of_Non_II_Friendly_Non_Closed__c , t.Number_of_Contacted_Members__c
                                          ,iiCampaign__r.Recommendation_Text__c , t.Contacted__c
                                          From Target_List__c t 
                                          where id =: listid limit 1 ];
           
               return newTargetList;
    }
    
    public void changeTargetList(){
        
        //Jira 4499  VM - Added whole IF section for non-admin profiles to populate the user to whom the list is shared
        getAdminProfiles();
         //isAdminProfiles = false;
        if(!isAdminProfiles){
            Set<String> listTargetIdNew = new set<String>();
                
            for (Target_List__c targetList : [Select iiCampaign__c,iiCampaign__r.Campaign_Name__c,id,Sends_Email__c,Current_Page_Size__c
                                            From Target_List__c t 
                                            where User__c =: loggedInUserId
                                            and iiCampaign__r.Active_Flag__c = true
                                            Order by iiCampaign__r.Start_Date__c desc]){
                  listTargetIdNew.add(targetList.id);                 
                                            
            }       
            
            for (Target_List_Share__c  targetListShare : [Select Target_List__c ,Shared_with__c ,Target_List__r.iiCampaign__r.Campaign_Name__c,id
                                        From Target_List_Share__c t 
                                        where Shared_with__c =: loggedInUserId and Target_List__r.iiCampaign__r.Active_Flag__c = true 
                                        Order by Target_List__r.iiCampaign__r.Active_Flag__c desc ]){
                  listTargetIdNew.add(targetListShare.Target_List__c);                      
            }
                
            listTargetListUsers = [Select User__c,iiCampaign__c, User__r.Name, Preferred_User__c, id,Sends_Email__c,Current_Page_Size__c
                           From Target_List__c t
                           Where Authorized__c = true and id in : listTargetIdNew and iiCampaign_Name__c = :currentcampaign];                                   
        }
        resetSorting();
        system.debug('***************changeTargetList*******************');
        List<Target_List__c> targetLists =  getTargetList(selectedTargetListUsers);
        system.debug('___________________changeTargetList.targetLists count___________'+targetLists.size());
        for (Target_List__c targetList :targetLists){
            userTargetList  = targetList;
        }
        //getUserCampaignsList();
        system.debug('***************userTargetList*******************'+selectedTargetListUsers);
        system.debug('***************userTargetList*******************'+userTargetList);
        if(userTargetList.id == null){
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'MyiiList does not exist'));
             xls_userTargetListId = 'null';
             return;
        }else{system.debug('***************userTargetList*******************'+userTargetList);
             getSampleEmailPDF(userTargetList.iiCampaign__c);
             xls_userTargetListId = userTargetList.Id;
             system.debug('***************userTargetList.id*******************'+userTargetList.Id);
        }
         
        selectedAnalyst = '';
        
        listOfMyMembers = new List<MemberWrapper>();
        
        system.debug('***************listOfMyMembers*******************'+listOfMyMembers);
        if(userTargetList.Authorized__c){            
            GetAnalystList();
            fetchTargetListMembers();
        } 
        
        currentusername = userTargetList.Preferred_User__c;
        system.debug('***************GetMemberList*******************'+listOfMyMembers);
        system.debug('***************END changeTargetList*******************');
    }
    
    private void getVoterCount(){
        ContactCalled = [Select count() 
                        FROM Target_List_Member__c 
                        WHERE  Target_List__c = : userTargetList.id
                        AND (
                          (Contact_would_not_reveal_vote__c = true) 
                          OR 
                          (Voted_in_II_Campaign__c = true)                                                
                        )           
                        AND (Removed_Reason__c = null) ]; 
        
        // This query is required to get updated # of of_Non_II_Friendly_Non_Closed__c which is modified outside from this controller (i.e. MyListVoteController).
         Integer nonclosed = 0;
        for(Target_List__c  tl :[select id,of_Non_II_Friendly_Non_Closed__c, Number_of_Contacted_Members__c, Contacted__c from Target_List__c where id=:userTargetList.id]){
             nonclosed = tl.of_Non_II_Friendly_Non_Closed__c.intValue();
             ContactedPercentage = tl.Contacted__c;
             ContactedNumber = tl.Number_of_Contacted_Members__c;
         }
         
        system.debug('***************contacts called*******************'+ContactCalled);
       
        if(userTargetList.of_Non_II_Friendly_Non_Closed__c != NULL) {
                        
         // ContactCalled = ContactCalled + userTargetList.of_Non_II_Friendly_Non_Closed__c.intValue(); 
          ContactCalled = ContactCalled + nonclosed;
         }        
        
        
        //To Avoid Devide by Zero Error
        if(userTargetList.Number_of_Target_Members__c != null && userTargetList.Number_of_Target_Members__c != 0){                      
            ContactCalledPertange =ContactCalled*100/userTargetList.Number_of_Target_Members__c;                
        }
    }
    
    private void GetAnalystList(){
      analystOptions = new List<SelectOption>();
      analystOptions.add(new SelectOption('','-Clear Selected Recommendation-'));
        for (Candidate_Information__c candidate : [Select c.Id, c.Candidate_Name__c 
                                                   From Candidate_Information__c c 
                                                   where c.Candidate_Name__c != null and iiCampaign__c = : userTargetList.iiCampaign__c 
                                                   order by c.Candidate_Name__c
                                                   limit 1000]){
             analystOptions.add(new SelectOption(candidate.id,candidate.Candidate_Name__c));
        }
    }
    
    
    public Map<Id,List<String>> fillListOfOtherMembers(Set<Id> setTargetListmembers){
        Map<Id,List<String>> mapOfAdditionalMembers = new Map<Id,List<String>>();
        //Get Tab label by iiCampaign's Setting
        String clientToCallSuffix = (userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c != null 
                                        && userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c != '' )? 
                                    userTargetList.iiCampaign__r.Contacts_to_Call_Tab_Text__c : 'Contacts to Call';
        String emailOnlySuffix = (userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c != null 
                                        && userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c != '' )? 
                                    userTargetList.iiCampaign__r.Email_only_Contacts_Tab_Text__c : 'Email Only Contacts';
        
     //12/20/10 Chetan Garg; PR-07536 - AP: Show actions of other Target List Member owners
        for(Target_List_Member__c member : [select GPSContact__c,removed_reason__c ,Target_List__r.User__r.Name,Target_List__r.Preferred_User__c,Target_List__r.User__c,User_who_left_Voicemail_del__c
                                            ,user_who_confirmed_ballot_received__c,User_Who_Called_the_Contact__c,User_who_confirmed_Vote_Last__c, Activity_Logged__c,
                                            Target_List__r.iiCampaign__r.Call_2_Text__c //11/27/2012    Jitendra:   CRMGPS-2884
                                            from Target_List_Member__c 
                                            where Target_List__r.iiCampaign__r.Id =:userTargetList.iiCampaign__c 
                                            and Target_List__c <>: userTargetList.id 
                                            and (removed_reason__c = null or removed_reason__c ='Email Only') 
                                            and GPSContact__c in :setTargetListmembers limit :MAX_LIMIT]){
                String listType = (member.removed_reason__c == null ? clientToCallSuffix : emailOnlySuffix);                                                                 
                String memberName = member.Target_List__r.Preferred_User__c + '<span class="gray"> - '  + listType + '</span>';                                                                      
                  List<String> setmembers = new List<String>();                                                                                 
                if(mapOfAdditionalMembers.containsKey(member.GPSContact__c)){
                    setmembers = mapOfAdditionalMembers.get(member.GPSContact__c);
                }                                                           
                
                //12/20/10 Chetan Garg; PR-07536 - AP: Show actions of other Target List Member owners                
                if(member.Target_List__r.User__c == member.User_who_left_Voicemail_del__c){
                  memberName +='<br/><span class="additional-detail">Warm-up Call</span>';    
                }
                
                if(member.Target_List__r.User__c == member.user_who_confirmed_ballot_received__c && member.Target_List__r.iiCampaign__r.Call_2_Text__c != null ){
                  //memberName +='<br/><span class="additional-detail">Ballot Received</span>'; //11/27/2012    Jitendra:   CRMGPS-2884
                  memberName +='<br/><span class="additional-detail">'+ member.Target_List__r.iiCampaign__r.Call_2_Text__c +' Completed</span>';//11/27/2012    Jitendra:   CRMGPS-2884
                }
                
                if(member.Target_List__r.User__c == member.User_Who_Called_the_Contact__c){
                  memberName +='<br/><span class="additional-detail">Called Contact</span>';  
                }
                
                if(member.Target_List__r.User__c == member.User_who_confirmed_Vote_Last__c){
                  memberName +='<br/><span class="additional-detail">Confirmed vote</span>';  
                }
                setmembers.add(memberName);
                mapOfAdditionalMembers.put(member.GPSContact__c , setmembers);
          }
        
        return mapOfAdditionalMembers;                                                                          
    }
    
    
    
    //populate Target List member list 
    //Param @selectedAnalyst - Selected Analyst name
    //Param @userTargetListId - Target List Id
    //Param @includeEmailOnlyList - if true include member who have removed reason = 'Email Only'
    private void fillListOfMembers(String selectedAnalyst,string userTargetListId , Boolean includeEmailOnlyList ,boolean forExport){
        system.debug('calling fillListOfMembers from GetMemberList From GOTOPAGE() Catch Block~~~~~');
        unviewedCount = 0;
        Set<ID> setOfContactIds = new Set<ID>();
        Set<ID> setOfmemberIds = new Set<ID>();
        Set<ID> setOfAccountIds = new Set<ID>();
        
        //5 Jan 2011 ParthT:  Changes to show contacts with deleted Voter recommendations
        //Set<ID> setOfDeletedContactIds = new Set<ID>();
        
        listOfMyMembers = new List<MemberWrapper>();
        String whereCondition  =  'Removed_Reason__c = null';
        if(includeEmailOnlyList == true){
            whereCondition  +=  ' OR Removed_Reason__c = \'Email Only\' ';
        }
        
        
                  String   query; 
        //If Contact is added then Refresh Target List 
        if(selectedAnalyst == null || selectedAnalyst ==''){
            system.debug('selectedAnalyst Null Block~~~~~'+selectedAnalyst);
            //14 Dec,2010  Parth Tamhaney       Updated fillListOfMembers to Show COntacts with Non deleted Voter Recommendations  (for export only)
            //15 Dec,2010  Parth Tamhaney   Get Deleted Voter Recommendations and add to set of contacts to exclude
             //Get deleted Voter Recommendations 
            //5 Jan 2011 ParthT:  Changes to keep contacts with deleted Voter recommendations
            /*if(forExport ){
                 for(Voter_Recommendation__c voter : [Select v.Contact__c 
                                                     From Voter_Recommendation__c v
                                                     where  v.Use_Recommendations_in_Campaign__c <> 'No' and
                                                     v.Candidate_Information__r.iiCampaign__c =:userTargetList.iiCampaign__c
                                                     and  (Active_Flag__c = false and User_Who_Inactivated__c <> null) ]){
                    setOfDeletedContactIds.add(voter.Contact__c);                                  
                 }     
            }*/
             
            //Get Logged-in User Target List Members
            query = 'Select id, t.GPSContact__r.Name,t.GPSContact__r.II_Language__c,t.GPSContact__r.GPSAccount__c,t.GPSContact__c ' + 
                           ' ,t.Name, t.Activity_Logged__c, Viewed_by_User__c,t.GPSContact__r.GPSAccount__r.Name,Called_about_II__c,Contact_would_not_reveal_vote__c ' +
                           ' ,Target_List_Status__c,Voted_in_II_Campaign__c, User_who_confirmed_Vote_Last__c,t.Eligible_for_email__c, Removed_Reason__c , '+  
                           ' User_who_confirmed_Vote_Last__r.firstname,User_who_confirmed_Vote_Last__r.Preferred_Name__c, User_who_confirmed_Vote_Last__r.lastname ,Reassigned_By__r.Name,Reassigned_By__r.Preferred_Name__c,Reassigned_By__r.LastName,'+
                           ' t.User_who_left_Voicemail_del__c ,t.User_who_left_Voicemail_del__r.FirstName,t.User_who_left_Voicemail_del__r.Preferred_Name__c, t.User_who_left_Voicemail_del__r.LastName '+
                           ' ,t.GPSContact__r.II_Company__c,t.Not_II_Friendly__c, GPSContact__r.RecordType.Name ' +
                           ' ,Ballot_Received__c,user_who_confirmed_ballot_received__r.FirstName,user_who_confirmed_ballot_received__r.Preferred_Name__c,user_who_confirmed_ballot_received__r.LastName ' +
                           ' ,User_Who_Confirmed_Non_II_Friendly__r.FirstName,User_Who_Confirmed_Non_II_Friendly__r.Preferred_Name__c,User_Who_Confirmed_Non_II_Friendly__r.LastName '+      
                           ' ,t.Target_List__r.iiCampaign__r.Call_2_Text__c'+//11/27/2012    Jitendra:   CRMGPS-2884                               
                           ' ,Contact_has_been_called__c,User_Who_Called_the_Contact__r.FirstName,User_Who_Called_the_Contact__r.Preferred_Name__c,User_Who_Called_the_Contact__r.LastName '+
                           ' From Target_List_Member__c t ' +
                           ' Where ( ' + whereCondition + ') and t.Target_List__c = : userTargetListId ' ;
            //14 Dec,2010  Parth Tamhaney       Updated fillListOfMembers to Show COntacts with Non deleted Voter Recommendations (for export only)
             //15 Dec,2010  Parth Tamhaney   Made selection "Not in"
            //5 Jan 2011 ParthT:  Changes to keep contacts with deleted Voter recommendations
             /*if(forExport ){
                query += '  and t.Contact__c NOT IN : setOfDeletedContactIds ' ;
             }*/
             query += '  order by '+ SORT_BY_MAP.get(sortOn) + ' ' + SORTING_ORDER_MAP.get(sortOrder) + ' NULLS last';
                    system.debug('___________TARGET LIST MEMBER SOQL : ' + query);                         
        }else{  
            system.debug('selectedAnalyst Not Null ELSE PART~~~~~'+selectedAnalyst);
            //04 Jan,2011  Parth Tamhaney   Get Deleted Voter Recommendations and add to set of contacts to exclude
             //Get deleted Voter Recommendations 
            //5 Jan 2011 ParthT:  Changes to keep contacts with deleted Voter recommendations
            /*if(forExport ){
                 for(Voter_Recommendation__c voter : [Select v.Contact__c 
                                                     From Voter_Recommendation__c v
                                                     where v.Candidate_Information__c = : selectedAnalyst and
                                                     v.Use_Recommendations_in_Campaign__c <> 'No' and
                                                     v.Candidate_Information__r.iiCampaign__c =:userTargetList.iiCampaign__c
                                                     and  (Active_Flag__c = false and User_Who_Inactivated__c <> null) ]){
                    setOfDeletedContactIds.add(voter.Contact__c);                                  
                 }     
            } */  
            for(Voter_Recommendation__c voter : [Select v.GPSContact__c 
                                                 From Voter_Recommendation__c v
                                                 where v.Candidate_Information__c = : selectedAnalyst and
                                                 v.Use_Recommendations_in_Campaign__c <> 'No' and
                                                 v.Candidate_Information__r.iiCampaign__c =:userTargetList.iiCampaign__c
                                                 and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) ]){
                setOfContactIds.add(voter.GPSContact__c);                                  
             }          
            //Get Logged-in User Target List Members by Selected Analyst
              query = 'Select id, t.GPSContact__r.Name,t.GPSContact__r.II_Language__c,t.GPSContact__r.GPSAccount__c,t.GPSContact__c ' + 
                           ' ,t.Name,t.Activity_Logged__c,Viewed_by_User__c,t.GPSContact__r.GPSAccount__r.Name,Called_about_II__c,Contact_would_not_reveal_vote__c ' +
                           ' ,Target_List_Status__c,Voted_in_II_Campaign__c, User_who_confirmed_Vote_Last__c,Removed_Reason__c , '+  
                           ' User_who_confirmed_Vote_Last__r.firstname, User_who_confirmed_Vote_Last__r.Preferred_Name__c, User_who_confirmed_Vote_Last__r.lastname ,Reassigned_By__r.Name,Reassigned_By__r.Preferred_Name__c,Reassigned_By__r.LastName,t.Eligible_for_email__c, '+ 
                           ' t.User_who_left_Voicemail_del__c ,t.Not_II_Friendly__c,t.User_who_left_Voicemail_del__r.FirstName, t.User_who_left_Voicemail_del__r.Preferred_Name__c, t.User_who_left_Voicemail_del__r.LastName '+
                           ' ,t.GPSContact__r.II_Company__c, GPSContact__r.RecordType.Name ' +        
                           ' ,Ballot_Received__c,user_who_confirmed_ballot_received__r.FirstName,user_who_confirmed_ballot_received__r.Preferred_Name__c, user_who_confirmed_ballot_received__r.LastName ' +
                           ' ,User_Who_Confirmed_Non_II_Friendly__r.FirstName, User_Who_Confirmed_Non_II_Friendly__r.Preferred_Name__c, User_Who_Confirmed_Non_II_Friendly__r.LastName '+
                           ' ,t.Target_List__r.iiCampaign__r.Call_2_Text__c'+//11/27/2012    Jitendra:   CRMGPS-2884
                           ' ,Contact_has_been_called__c,User_Who_Called_the_Contact__r.FirstName,User_Who_Called_the_Contact__r.Preferred_Name__c,User_Who_Called_the_Contact__r.LastName '+                             
                           ' From Target_List_Member__c t ' +
                           ' Where ( ' + whereCondition + ') and t.Target_List__c = : userTargetListId AND GPSContact__c IN :setOfContactIds ';
                           //'  order by '+ SORT_BY_MAP.get(sortOn) + ' ' + SORTING_ORDER_MAP.get(sortOrder) + ' NULLS last'; 
               //04 Jan,2011  Parth Tamhaney     Made selection "Not in"
             //5 Jan 2011 ParthT:  Changes to keep contacts with deleted Voter recommendations
             /*if(forExport ){
                query += '  and t.Contact__c NOT IN : setOfDeletedContactIds ' ;
             }*/
              query += '  order by '+ SORT_BY_MAP.get(sortOn) + ' ' + SORTING_ORDER_MAP.get(sortOrder) + ' NULLS last';
                    system.debug('___________TARGET LIST MEMBER SOQL : ' + query);                   
           
        }
        
        if(forExport == true){
               for(Sobject obj : Database.query(query)){     
                    Target_List_Member__c member = (Target_List_Member__c)obj;   
                    listOfMyMembers.add(new MemberWrapper(false,member));
                    setOfmemberIds.add(member.GPSContact__c );
                    system.debug('__===========Eligible for mail========__:'+member.Eligible_for_email__c);  
                    //OR Removed_Reason__c ='Reassigned'
                    if(!member.Viewed_by_User__c ){
                        unviewedCount++;
                    }
                    setOfAccountIds.add(member.GPSContact__r.GPSAccount__c);
                            
              }
                        
                    //11/09/2010 ParthT: Get  exclusions
                Set<ID> setOfAccountsExcluded = new Set<ID>();
                for(Exclusion__c excl : [Select Id,GPSAccount__c
                                                          From Exclusion__c t
                                                          Where GPSAccount__c in :setOfAccountIds
                                                          AND iiCampaign__c =: selectedCampaign]){
                                                            
                    
                    setOfAccountsExcluded.add(excl.GPSAccount__c);
                  }
               
                //Get Top 3 voterRecommendations
                 Map<id,GPSContact__c> mapContactVoterRecommendations = new Map<id,GPSContact__c>([ Select id, 
                                                                                                (Select Candidate_Name__c From Voter_Recommendations__r 
                                                                                                where Candidate_Information__r.iiCampaign__c =:userTargetList.iiCampaign__c
                                                                                                and Use_Recommendations_in_Campaign__c <> 'No'
                                                                                                and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) 
                                                                                                 order by Candidate_Name__c  limit 4) 
                                                                                        From GPSContact__c c
                                                                                        where id in :setOfmemberIds]);
                                                                       
                
               Map<Id,List<String>> mapOfAdditionalMembers = fillListOfOtherMembers(setOfmemberIds);
                
               for(MemberWrapper wrapper : listofMyMembers){
                  GPSContact__c con = mapContactVoterRecommendations.get(wrapper.listMember.GPSContact__c);
                  if(con <> null){
                    wrapper.voterRecommendations = con.Voter_Recommendations__r;
                    if(wrapper.voterRecommendations.size()> 3){
                        wrapper.showMore = true;
                        wrapper.voterRecommendations.remove(3);
                     }
                  } 
                  
                  // populate Additional member information
                  List<String> additionaldetail = mapOfAdditionalMembers.get(wrapper.listMember.GPSContact__c);
                  if(additionaldetail != null){
                    wrapper.additionaldetail = additionaldetail;
                  }
                  //11/09/2010 ParthT: Set Email exclusion on wrapper item
                  if(setOfAccountsExcluded.contains(wrapper.listMember.GPSContact__r.GPSAccount__c)){
                     wrapper.isEmailOptionEditable = false;
                  }
                 
                 //making email field non editable for Research group
                   if(userTargetList.II_Group__c == 'Research') {
                            wrapper.isEmailOptionEditable = false;
                            emailEditable = false;
                      } else {
                       
                       emailEditable = true;
                     }
                        
                 
               }
        }else{
                        system.debug('ELSE PART NOT FOR EXPORT~~~~~'+selectedAnalyst);
                        // 14 Dec 2010
                         Database.Querylocator  dbqueryLocator = Database.getQueryLocator(query);
                         listTargetMemberSet = new ApexPages.StandardSetController(dbqueryLocator);
                         system.debug('___________listTargetMemberSet.getResultSize()()():- '+listTargetMemberSet.getResultSize());
                         if(userTargetList.Current_Page_Size__c == null){
                            userTargetList.Current_Page_Size__c = 'Show 25';
                         }  
                         if(userTargetList.Current_Page_Size__c == 'Show 25' ){
                                         RECORD_PAGE_SIZE = 25 ;
                                         currentpagesize = '25';
                                 }else if(userTargetList.Current_Page_Size__c == 'Show 50' ){
                                         RECORD_PAGE_SIZE = 50 ;
                                         currentpagesize = '50';
                                 }else if(userTargetList.Current_Page_Size__c == 'Show 100'){
                                     RECORD_PAGE_SIZE = 100;
                                     currentpagesize = '100';
                                 }/*else{
                                     RECORD_PAGE_SIZE = listTargetMemberSet.getResultSize();
                                     currentpagesize = 'All';
                                 }*/
             
                         if(listTargetMemberSet != null){
                                setpagesize();
                                setcurrentpageno(CurrentPageNumber);
                            }
                         listTargetMemberSet.setPageSize(RECORD_PAGE_SIZE);
                         listTargetMemberSet.setPageNumber(CurrentPageNumber);
                         updateContactsList();
                                     buildWrapperMembers();
                         
                       
                         
        }

                
    }
    
 public void updateContactsList()
    {
        listCurrentPageTargetListMember = (List<Target_List_Member__c>)listTargetMemberSet.getRecords();
        CurrentPageNumber = listTargetMemberSet.getPageNumber();
        //pageIndexNumber = new List<integer>(); 24-Jan-2011
        pageIndexNumber = new List<String>(); //24-Jan-2011
        /*//24-Jan-2011
        for(Integer index = 0 ; index < TotalPage; index++){
            pageIndexNumber.add(index+1);
        }*/
        for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
                       
           if(index+1 == TotalPage){
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(listTargetMemberSet.getResultSize()));
            }
            else{
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
            }
            
            startrange = endrange+1;
            endrange = endrange+RECORD_PAGE_SIZE;
         }
        
    }
    
    public void updateNewPagesize()
     {
          integer oldpageno=1;
          setpagesize();
          try
           {
                      listTargetMemberSet.setPageSize(RECORD_PAGE_SIZE);
                      system.debug('______updateNewPagesize____listTargetMemberSet.getPageSize()_______'+listTargetMemberSet.getPageSize());
                      listTargetMemberSet.setPageNumber(1);
                      pageIndexNumber.clear();
           }
          catch(System.Visualforceexception ex)
           {
             GetMemberList();
             listTargetMemberSet.setPageNumber(gotoPageNumber);
           }
           
                      //24-Jan-2011 
                      /*for(Integer index = 0 ; index < TotalPage; index++){
                            pageIndexNumber.add(index+1);
                       }*/
                       
                       for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
                                   
                       if(index+1 == TotalPage){
                            pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(listTargetMemberSet.getResultSize()));
                        }
                        else{
                            pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
                        }
                        
                        startrange = endrange+1;
                        endrange = endrange+RECORD_PAGE_SIZE;
                     }
                        CurrentPageNumber = 1;
                       //Update Target List page Size
                        if(RECORD_PAGE_SIZE == 25){
                         userTargetList.Current_Page_Size__c = 'Show 25';
                       }else if(RECORD_PAGE_SIZE == 50 ){
                         userTargetList.Current_Page_Size__c = 'Show 50';
                       }else if(RECORD_PAGE_SIZE == 100){
                         userTargetList.Current_Page_Size__c = 'Show 100';
                       }
                       update userTargetList;   
                 updateContactsList();
           buildWrapperMembers();
    }
    
    //Build Wrapper Members For Current Page.
    public void buildWrapperMembers()
    {
        listOfMyMembers = new List<MemberWrapper>();
        unviewedCount = 0;
      Set<ID> setOfContactIds = new Set<ID>();
      Set<ID> setOfmemberIds = new Set<ID>();
        Set<ID> setOfAccountIds = new Set<ID>();
        
        
        for(Target_List_Member__c member:listCurrentPageTargetListMember){
                listOfMyMembers.add(new MemberWrapper(false,member));
                setOfmemberIds.add(member.GPSContact__c );
                system.debug('__===========Eligible for mail========__:'+member.Eligible_for_email__c);
                //OR Removed_Reason__c ='Reassigned'
                if(!member.Viewed_by_User__c ){
                        unviewedCount++;
                    }
                setOfAccountIds.add(member.GPSContact__r.GPSAccount__c);
            
            }           
        
        
            //11/09/2010 ParthT: Get  exclusions
        Set<ID> setOfAccountsExcluded = new Set<ID>();
        for(Exclusion__c excl : [Select Id,GPSAccount__c
                                                  From Exclusion__c t
                                                  Where GPSAccount__c in :setOfAccountIds
                                                  AND iiCampaign__c =: selectedCampaign]){
                                                    
            
            setOfAccountsExcluded.add(excl.GPSAccount__c);
          }
       
        //Get Top 3 voterRecommendations
         Map<id,GPSContact__c> mapContactVoterRecommendations = new Map<id,GPSContact__c>([ Select id, 
                                                                                        (Select Candidate_Name__c From Voter_Recommendations__r 
                                                                                        where Candidate_Information__r.iiCampaign__c =:userTargetList.iiCampaign__c
                                                                                        and Use_Recommendations_in_Campaign__c <> 'No'
                                                                                        and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) 
                                                                                         order by Candidate_Name__c  limit 4) 
                                                                                From GPSContact__c c
                                                                                where id in :setOfmemberIds]);
                                                               
        
       Map<Id,List<String>> mapOfAdditionalMembers = fillListOfOtherMembers(setOfmemberIds);
        
       for(MemberWrapper wrapper : listofMyMembers){
          GPSContact__c con = mapContactVoterRecommendations.get(wrapper.listMember.GPSContact__c);
          if(con <> null){
            wrapper.voterRecommendations = con.Voter_Recommendations__r;
            if(wrapper.voterRecommendations.size()> 3){
                wrapper.showMore = true;
                wrapper.voterRecommendations.remove(3);
             }
          } 
          
          // populate Additional member information
          List<String> additionaldetail = mapOfAdditionalMembers.get(wrapper.listMember.GPSContact__c);
          if(additionaldetail != null){
            wrapper.additionaldetail = additionaldetail;
          }
          //11/09/2010 ParthT: Set Email exclusion on wrapper item
          if(setOfAccountsExcluded.contains(wrapper.listMember.GPSContact__r.GPSAccount__c)){
             wrapper.isEmailOptionEditable = false;
          }
         
         //making email field non editable for Research group
           if(userTargetList.II_Group__c == 'Research') {
                    wrapper.isEmailOptionEditable = false;
                    emailEditable = false;
              } else {
               
               emailEditable = true;
             }
                
         
       }
    }
    public void setcurrentpageno(integer pageno)
     {
         if(pageno==0)
           {
            pageno =1;
           }
         CurrentPageNumber =pageno;
     }
    public void setpagesize()
    {
        if(currentpagesize == '25')
          {
            RECORD_PAGE_SIZE = 25;
          }
         else if(currentpagesize == '50')
          {
            RECORD_PAGE_SIZE = 50;
          }
         else if(currentpagesize == '100')
          {
            RECORD_PAGE_SIZE = 100;
          }/*
        else
          {
            RECORD_PAGE_SIZE = listTargetMemberSet.getResultSize();
            
          }*/
    }
    
   public Integer gotoPageNumber {get;set;}
   
   public void goToPage(){
        if(gotoPageRange == null || gotoPageRange == ''){
            updateNewPagesize();
            return;
        }
        system.debug('________________next mehtod start__________');
        //24-Jan-2011
        try 
         {
                system.debug('Start Try Block~~~~~');
                integer currentpagesizeint = double.valueOf(currentpagesize).intValue(); 
                integer rangelastdigit = double.valueOf(gotoPageRange.substring(gotoPageRange.lastIndexOf('-')+1)).intValue();
                integer rangefirstdigit = double.valueOf(gotoPageRange.substring(0,gotoPageRange.lastIndexOf('-'))).intValue();
                if(rangelastdigit == listTargetMemberSet.getResultSize()){
                    rangelastdigit = rangelastdigit +(currentpagesizeint-((rangelastdigit-rangefirstdigit)+1));
                }
                gotoPageNumber = (rangelastdigit)/currentpagesizeint;// End Of 24-Jan-2011
                
                if(this.TotalPage >= gotoPageNumber){
                    listTargetMemberSet.setPageNumber(gotoPageNumber);
                }else{
                    listTargetMemberSet.setPageNumber(1);
                }        
                system.debug('End Try Block~~~~~');
         }
        catch(System.Visualforceexception ex)
        {
            system.debug('In Catch Block~~~~~');
            GetMemberList();
            listTargetMemberSet.setPageNumber(gotoPageNumber);
        }
            updateContactsList();
                buildWrapperMembers();
    }
   
   public void first() {
      listTargetMemberSet.first();
      updateContactsList();
      buildWrapperMembers();
    }
    
    public void last() {
        listTargetMemberSet.last();
        updateContactsList();
        buildWrapperMembers();
    }
    public void previous() {
        try
         {
                listTargetMemberSet.previous();
         }
         catch(System.Visualforceexception ex)
         {
            GetMemberList();
            listTargetMemberSet.setPageNumber(gotoPageNumber);
         }
                updateContactsList();
                buildWrapperMembers();
    }
    public void next() {
        system.debug('________________next mehtod start__________'+listTargetMemberSet);
        system.debug('________________next mehtod start__________');
        try
         {
              listTargetMemberSet.next();
         }
        
         catch(System.Visualforceexception ex)
         {
             GetMemberList();
             listTargetMemberSet.setPageNumber(gotoPageNumber);
         }
        system.debug('________________next mehtod end__________');
        updateContactsList();
        buildWrapperMembers();
    }
    public Boolean hasNext {
        get{
          if(listTargetMemberSet == null) return false;
          return listTargetMemberSet.getHasNext();
        }
        set;
    }
    
     public Boolean hasPrevious {
        get {
            if(listTargetMemberSet == null) return false;
            return listTargetMemberSet.getHasPrevious();
        }
        set;
    }
     public Boolean isFirst{
        get{
           if(listTargetMemberSet == null) return true;
           return (listTargetMemberSet.getPageNumber() == 1);
        }
        set;
   }
    
    
   public Integer recordStartNumber{
       get{
           if(listTargetMemberSet == null) return 0;
           return ((CurrentPageNumber -1) * RECORD_PAGE_SIZE) +1;
        }
   }
   
   public Integer recordEndNumber{
       get{
           if(listTargetMemberSet == null) return 0;
           if(isLast == true){
             return TotalRecords;
           }else{
             return CurrentPageNumber * RECORD_PAGE_SIZE;
           }
        }
   } 
    
    
    
    public Integer TotalPage{
        get{
            if(listTargetMemberSet == null) return 0;
            Integer resultSize = listTargetMemberSet.getResultSize();
            Integer pageSize = listTargetMemberSet.getPageSize();
            system.debug('_______My list________TotalPage_____________pageSize'+ pageSize);
            system.debug('_______My list________TotalPage_____________resultSize'+ resultSize);
            if(pageSize == 0 || resultSize == 0) return 0;
            Integer totalPages = resultSize/pageSize;
            if(pageSize*totalPages == resultSize){
                return totalPages;
            }else{
                return totalPages + 1;
            }
        }
    }
    
    
    public Integer TotalRecords{
        get{
            if(listTargetMemberSet == null) return 0;
            return listTargetMemberSet.getResultSize();
        }
    }
    
     public Boolean isLast{
        get {
            if(listTargetMemberSet == null) return true;
            Integer resultSize = listTargetMemberSet.getResultSize();
            Integer pageSize = listTargetMemberSet.getPageSize();
            Integer totalPages = resultSize/pageSize;
            if(resultSize == 0){
                return true;
            }
            if(pageSize*totalPages == resultSize){
                return listTargetMemberSet.getPageNumber() == totalPages;
            }else{
                return listTargetMemberSet.getPageNumber() == totalPages + 1;
            }
        }
        set;
    }



    //Populate ClienttoCall List and EmailOnlyList
    public void fetchTargetListMembers(){
      system.debug('___________________fetchTargetListMembers.targetLists count___________'+userTargetList.id);
      List<Target_List__c> targetLists =  getTargetList(userTargetList.id);
      system.debug('___________________fetchTargetListMembers.targetLists count___________'+targetLists.size());
      for (Target_List__c targetList :targetLists){
        userTargetList  = targetList;
      }
      system.debug('___________________fetchTargetListMembers.TargetList count___________'+userTargetList.Number_of_Target_Members__c);
      GetMemberList();
      
      if(userTargetList.Sends_Email__c == 'Yes'){
        emailOnlyController = new MyListEmailRecipientController();
        emailOnlyController.userTargetList = userTargetList;
        emailOnlyController.getEmailOnlyTargetMembers();
      }
    }
    
    private void GetMemberList(){
        system.debug('calling GetMemberList From GOTOPAGE() Catch Block~~~~~');
        fillListOfMembers( selectedAnalyst, userTargetList.id,false,false);
        //Update section "How am I doing"
        getVoterCount();
    }
    
    // Set Authorized 
    public Pagereference setAuthorized(){
        try{
            userTargetList.Authorized__c =  true;
            update userTargetList;
            fetchTargetListMembers(); 
            GetAnalystList();            
            return null;
         }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));      
        }
        return null;
    }
    
    // Referesh List with the All Contact
    public PageReference refershList(){
        selectedAnalyst ='';
        GetMemberList();
        return null;
    }
    
    // Referesh Email Only List with the All Contact
    public PageReference refreshEmailOnlyList(){
        emailOnlyController.selectedAnalyst = '';
        emailOnlyController.GetMemberList();
        return null;
    }
    
    // Filter Email Only Target List Member by Selected Analyst
    public Pagereference GetListMemberBySelectedAnalystEmailOnly(){     
        emailOnlyController.GetMemberList();
        return null;
    }
    
    // Referesh List with the All Contact
    public PageReference refreshWithFilter(){
        GetMemberList();
        return null;
    }
    
    
    //ChangeLanguage
    public Pagereference changeContactIILanguage(){
        system.debug('updateRemoveReason-->');
        system.debug('#selectedId -->'+selectedContactId );
        system.debug('#reason-->'+selectedLang);
        if(selectedContactId != null && selectedContactId != ''){
            GPSContact__c selectedMember= new GPSContact__c(id = selectedContactId);
            selectedMember.II_Language__c = selectedLang;
            update selectedMember;
        }
        selectedContactId = selectedLang= '';  
        GetMemberList(); 
        return null;
    }
    
    //Change Email Eligibility
    public String selectedTargetListMemberId {get;set;}
    public String EmailEligibility {get;set;}
    
    public PageReference changeEmailEligibility() {
        if(selectedTargetListMemberId !=null && selectedTargetListMemberId !='')
          {
            Target_List_Member__c tlMember = new Target_List_Member__c(id=selectedTargetListMemberId);
            tlMember.Eligible_for_email__c = EmailEligibility == 'Yes'?true:false;
            update tlMember;
          }
         selectedTargetListMemberId = EmailEligibility ='';
         GetMemberList();
        return null;
    }

    
    
    
    // Remove Contacts : update Remove Reason in the Target List Member 
    public Pagereference removeMembersFromList(){
        system.debug('updateRemoveReason-->');
        system.debug('#reason-->'+reason);
        List<Target_List_Member__c> membersToUpdate = new List<Target_List_Member__c>();
        if(reason != null && reason != ''){
            if(isEmailOnlyOn){
                emailOnlyController.reason = reason;
                return emailOnlyController.removeMembersFromList();
            }else{
                for(MemberWrapper wrapper : listOfMyMembers){
                    if(wrapper.isSelected == true ){
                        //, Viewed_by_User__c= true
                        membersToUpdate.add( new Target_List_Member__c(id = wrapper.listMember.id,Removed_Reason__c = reason ,Viewed_by_User__c= true,Reassigned_By__c = null));
                    }
                } 
                update membersToUpdate;
                reason ='';
                selectedId ='';   
                //Get  Target_List__c
                List<Target_List__c> targetLists =  getTargetList(userTargetList.id);
                for (Target_List__c targetList :targetLists){
                   userTargetList  = targetList;
                }
                GetMemberList();
            }  
        }
        return null;
    }
    
   
  // Remove Contacts : update Remove Reason in the Target List Member to move for Email Only Client 
   public Pagereference removeCallOnly(){
    List<Target_List_Member__c> membersToUpdate = new List<Target_List_Member__c>();   
    for(MemberWrapper wrapper : listOfMyMembers){
      if(wrapper.isSelected == true ){
        membersToUpdate.add( new Target_List_Member__c(id = wrapper.listMember.id,Removed_Reason__c = 'Email Only' ,Viewed_by_User__c= true,Reassigned_By__c = null));
      }
    }
               
    if(membersToUpdate.size() > 0){  
       update membersToUpdate;
    }
    reason = selectedId ='';
    fetchTargetListMembers();
    return null;        
   }
   
     // Remove Contacts : update Remove Reason in the Target List Member 
    public Pagereference updateReassignedViewedByUser(){
         List<Target_List_Member__c> memberToUpdate = new List<Target_List_Member__c>();
        for(MemberWrapper member :listOfMyMembers){  
            if(!member.listMember.Viewed_by_User__c)           
                 member.listMember.Viewed_by_User__c= true;
                memberToUpdate.add( member.listMember);
        }
        if(memberToUpdate.size()>0){
            update memberToUpdate;        
         }
         unviewedCount = 0;
        //GetMemberList();
        return null;
    }
    
    
    public void reassignMembersToList(){
        String reassignedByUser = UserTargetList.User__c;
          Reassignment__c reassign = new Reassignment__c();
          reassign.From__c = userTargetList.Id;
          reassign.Reassign_To__c = selectedId;
          reassign.User__c = reassignedByUser;//Userinfo.getUserId(); Changed on 12 Aug 2010 For PR-05772
          insert reassign;
          List<Reassignment_Item__c> listReassignItems = new List<Reassignment_Item__c>();
          Set<Id> contactIds = new Set<Id>();
          List<Target_List_Member__c> listOfMemberToUpsert = new List<Target_List_Member__c>();
          //Set Removed Reason for that Target List Member Record for that Contact on that Target List.
          //for(TargetListMember member : targetListMembers){
          //for Contact To call List 
          //09 Nov 2010  ParthT         Set Eligible_for_email__c for Reassignments 
          //Map to hold Reassigned Target_List_Member__c
          Map<id,Target_List_Member__c> mapReassignedMembers = new Map<id,Target_List_Member__c>();
          if(isEmailOnlyOn == false){
            MemberWrapper member ;
              for(Integer i=listOfMyMembers.size()-1; i >= 0; i--) {
                member = listOfMyMembers.get(i);
               
                if(member.isSelected){
                    //09 Nov 2010  ParthT       Add reassigned member to map 
                   mapReassignedMembers.put(member.listMember.GPSContact__c,member.listMember);    
                  if(selectedId != userTargetList.Id){
                    member.listMember.Removed_Reason__c = 'Reassigned';
                    member.listMember.Viewed_by_User__c= true;
                    contactIds.add(member.listMember.GPSContact__c);
                  }else{
                    member.listMember.Removed_Reason__c = null;
                  }
                  listOfMemberToUpsert.add(member.listMember);
                  
                  
                  Reassignment_Item__c ri = new Reassignment_Item__c();
                  ri.GPSContact__c = member.listMember.GPSContact__c;
                  ri.Reassignment__c = reassign.id;             
                  listReassignItems.add(ri);
                  
                  //member.isReassign = false;
                  listOfMyMembers.remove(i);
                }
              }
          }else{
            //Else Email only List
            MyListEmailRecipientController.memberWrapper member ;
              for(Integer i=emailOnlyController.listOfMyTarget.size()-1; i >= 0; i--) {
                member = emailOnlyController.listOfMyTarget.get(i);
                
                if(member.isSelected){
                    //09 Nov 2010  ParthT       Add reassigned member to map
                  mapReassignedMembers.put(member.listMember.GPSContact__c,member.listMember);
                  if(selectedId != userTargetList.Id){
                    member.listMember.Removed_Reason__c = 'Reassigned';
                    member.listMember.Viewed_by_User__c= true;
                    contactIds.add(member.listMember.GPSContact__c);
                  }else{
                    member.listMember.Removed_Reason__c = 'Email Only';
                  }
                  listOfMemberToUpsert.add(member.listMember);
                  
                  
                  Reassignment_Item__c ri = new Reassignment_Item__c();
                  ri.GPSContact__c = member.listMember.GPSContact__c;
                  ri.Reassignment__c = reassign.id;             
                  listReassignItems.add(ri);
                  
                  //member.isReassign = false;
                  emailOnlyController.listOfMyTarget.remove(i);
                }
              }
          }
          
          
          //If that contact IS on the list, CLEAR OUT the any Removed Reason for   
          //that Target List Member Record for that Contact on that Target List.
          for(Target_List_Member__c listmember : [Select id,Removed_Reason__c,GPSContact__c, t.GPSContact__r.II_Language__c,Target_List__c
                              FROM  Target_List_Member__c t
                            Where t.Target_List__c =: selectedId
                            AND GPSContact__c IN :contactIds]){
          
          contactIds.remove(listmember.GPSContact__c);
          listmember.Removed_Reason__c = (isEmailOnlyOn == false) ? null : 'Email Only';
          listmember.Reassigned_By__c = reassignedByUser; //Userinfo.getUserId(); Changed on 12 Aug 2010 For PR-05772
          listmember.Viewed_by_User__c = false;
          listmember.Reassigned_Date__c = System.now();
          
          listOfMemberToUpsert.add(listmember);                    
        }
          
          //If that contact is NOT on the list, do an insert on the Target List Member object related to the target list.
          if(contactIds.size() > 0){
             for(Id conId : contactIds){
                       Target_List_Member__c targetMember= new Target_List_Member__c();
                       targetMember.Target_List__c = selectedId;
                       targetMember.GPSContact__c = conId;
                       targetMember.Reassigned_By__c = reassignedByUser;//Userinfo.getUserId(); Changed on 12 Aug 2010 For PR-05772
                       targetMember.Viewed_by_User__c = false;
                       targetMember.Reassigned_Date__c = System.now();
                       targetMember.Removed_Reason__c = (isEmailOnlyOn == false) ? null : 'Email Only';
                       //09 Nov 2010  ParthT        Set Eligible_for_email__c from selected reassigned member 
                       if(mapReassignedMembers.containsKey(conId)){
                            targetMember.Eligible_for_email__c = mapReassignedMembers.get(conId).Eligible_for_email__c;
                       }
                       listOfMemberToUpsert.add(targetMember);                       
                       system.debug('#targetMember-->' + targetMember);
              }
          }
          system.debug('#listOfMemberToUpsert-->' + listOfMemberToUpsert);
          upsert listOfMemberToUpsert;
          insert listReassignItems;
          
          //Get  Target_List__c
            List<Target_List__c> targetLists =  getTargetList(selectedTargetListUsers);
            for (Target_List__c targetList :targetLists){
                userTargetList  = targetList;
            }
            fetchTargetListMembers();
    }
    
    
    // Filter Target List Member by Selected Analyst
    public Pagereference GetListMemberBySelectedAnalyst(){     
        GetMemberList();
        return null;
    }
    
   public void removeEmailOnly(){
     emailOnlyController.RemoveEmailOnly();
     fetchTargetListMembers();
   } 
    
    
    public class MemberWrapper{
        public List<String> additionaldetail {get;set;}
        public Boolean isSelected {get;set;}
        public Target_List_Member__c listMember {get;set;}
        public Boolean isEmailOptionEditable {get;set;}
        
        
        Public List<Voter_Recommendation__c> voterRecommendations{get;set;}
        public boolean showMore{get;set;}
                
        public MemberWrapper(Boolean isSelected , Target_List_Member__c listMember){
            this.isSelected = isSelected;
            this.listMember = listMember;
            this.additionaldetail = new List<String>();
            showMore=false;
            isEmailOptionEditable = true;
           
        }
    }
    
    /////////////////////////////////////////////
    // Export List functionlity 
    ///////////////////////////////////////////////
   public string selectedAnalystTeamName{get;set;} 
   public string selectedCampaignName{get;set;} 
   public string selectedUserName{get;set;} 
   public boolean renderCampaign{get;set;}   
     
     //Function for export
      public void getExportList(){
        system.debug('_________________getExportList ____________________');
        String selectedAnalyst = Apexpages.currentPage().getParameters().get('Analyst');
        string userTargetListId = Apexpages.currentPage().getParameters().get('userTargetListId');
        string CampaignId = Apexpages.currentPage().getParameters().get('CampaignId');
        string teamName = Apexpages.currentPage().getParameters().get('teamName');
        renderCampaign = false;
        
        if(ApexPages.currentPage().getParameters().get('sortOn') != null && 
            ApexPages.currentPage().getParameters().get('sortOn')!= ''){
            sortOn = ApexPages.currentPage().getParameters().get('sortOn'); 
        }
        
        if(ApexPages.currentPage().getParameters().get('sortOrder') != null && 
            ApexPages.currentPage().getParameters().get('sortOrder')!= ''){
            sortOrder = ApexPages.currentPage().getParameters().get('sortOrder');   
        }
        
        if(userTargetListId <> null && userTargetListId <>''){
            
            for (Target_List__c targetList : [Select User__c, User__r.Name,Preferred_User__c,id,
                                        iiCampaign__r.Campaign_is_Multilingual__c,
                                        iiCampaign__r.Users_can_set_if_contacts_get_email__c,
                                        iiCampaign__r.Contacts_to_Call_Tab_Text__c,
                                        iiCampaign__r.Email_only_Contacts_Tab_Text__c,II_Group__c,Sends_Email__c,Current_Page_Size__c,
                                        iiCampaign__r.Show_Important_News__c,
                                        iiCampaign__r.Recommendation_Text__c                                         
                                       From Target_List__c t
                                       Where id = :userTargetListId]){
                selectedUserName = targetList.Preferred_User__c;   
                userTargetList =  targetList;                          
            }
            
         }
         
        
        if(userTargetListId == 'null' ){
             listOfMyMembers = new List<MemberWrapper>(); 
        }else{
            fillListOfMembers( selectedAnalyst, userTargetListId,true,true);
        }
        
         
        
         
         
         if(CampaignId <> null && CampaignId <>''){
            renderCampaign = true;
           for (iiCampaign__c camp : [Select id, Campaign_Name__c, Name  
                                       From iiCampaign__c
                                       Where id= :CampaignId]){
               selectedCampaignName =camp.Campaign_Name__c;                                
            }
        }
  
      
        
        if(selectedAnalyst <> null && selectedAnalyst <>''){
             for (Candidate_Information__c candidate : [Select c.Id, c.Candidate_Name__c From Candidate_Information__c c where id= :selectedAnalyst]){
                selectedAnalystTeamName = candidate.Candidate_Name__c;
            }
        }
       
       
    }
    
    
    /////////////////////////////////////////////
    ///// Email Only Clients Controller [PR-05946]
    ///////////////////////////////////////////////
        
     public void showEmailOnlyClients(){
       emailOnlyController = new MyListEmailRecipientController();
       emailOnlyController.userTargetList = this.userTargetList;
       emailOnlyController.getEmailOnlyTargetMembers();
    }
    private void resetSorting(){
     sortOn = 'Default';
     sortOrder = '1';
    }
    
    public void sortListMembers(){
      GetMemberList();
    }
    
   ////[PR-06072]
    public class CampaignHeader{
        public String headerId {get;set;}
        public String displayName{get;set;}
        
        public CampaignHeader(String headerId,String displayName){
            this.displayName =  displayName;
            this.headerId =  headerId;
        }
    }
  
  //Help Document class  
  public class HelpDocument{
     public String doctitle {get;set;}
     public String docId {get;set;}
    
     public HelpDocument(Attachment attachment){
       docId = attachment.id;
      //Edited to check index of '.'
       if(attachment.Name.contains('.')) {
          doctitle = attachment.Name.substring(0, attachment.Name.indexOf('.')); 
        } else {
          doctitle = attachment.Name;
         }
     }
  }
  
  // Wrapper Class For Milestone
  public class MilestoneWrapper
   {
     
     public string titleDate {get;set;}
     public iiCampaign_Milestone__c memberMilestone{get;set;}
     public String trimmedMileStone {
        get{
            if(memberMilestone.Title__c == null){
                return '';
            }else if(memberMilestone.Title__c.length() > 25){
                return memberMilestone.Title__c.subString(0,25) + '...';
            }else{
                return this.memberMilestone.Title__c;
            }
        }
     }
     public MilestoneWrapper()
      {
         titleDate='';
      }
     public  MilestoneWrapper(iiCampaign_Milestone__c member )
     {
         memberMilestone = member;
          DateTime dt= DateTime.newInstance(member.due_date__c, Time.newInstance(0, 0, 0,0)) ;
          titleDate = dt.format('MMM dd');
     }
   }  
    
    public PageReference keepQueryLocatorAlive() 
    {
       system.debug('Action Poller'+datetime.now());
       GetMemberList();
       // goToPage();
       return null;
    }
}