/**************************************************************************************
* Name            : IIFanClubController
* Date            : 29 Nov,2010
* Description     : Controller for tab IIFanClub (Copied from iiCampaignController)
* Author          : Parth Tamhaney
* Modified :

* 11 oct 2010   :  Chetan Garg     Added logic in removeVoterRec() to check before deletion [PR-06651].
                                       Added logic to create Analust Buddy and delete Analyst Buddy [PR-06648].
* 14 oct 2010   :  Kapil Choudhary Logic added for  exporting excel according to sorting on page [PR-06689] 
* 19 oct 2010   :  Kapil Choudhary Replace "with sharing" key word with "without sharing" for base class.       
* 10 dec 2010   :  Kapil Choudhary updated for Inactivate Voter Recommendations instead of deleting [PR-07419].
* 23 dec 2010   :  Parth Tamhaney  Made chanes for Paging options
* 20 Jan 2011   :  Kapil Choudhary Logic added to the dropdown should show record count instead of page nos(1-25, 26-50, 51-63) [PR-07995].
* 09 Feb 2011   :  Urminder    Remove Team_uses_Analyst_Buddies__c from query (line# 121,188,276,320,781,121)
* 15 Feb 2011   :  Kapil Choudhary Created function keepQueryLocatorAlive for [PR-08267]
* 08-March-2011 :  Kapil Choudhary Updated Previous() function for Modified rows exist in the records collection and press Previous Command Link [PR-08589].
* 09-March-2011 :  Chetan Garg   (PR-08587)Removed unused variables and make transient, Fix the Bach size issue when sort on Priority Column for big list (more than 2000 records) 
* 10-March-2011 :  Svatka Simpson - updated line 213 - Priority_Contacts__c pricon to only include priority contacts with relationship type = P
* 11 March 2011    Svatka Simpson    Adding Pure_MSID__c to Candidate query and replacing the priorioty contact where clause to match on this instead of MSID
* 12 Jan 2015    : Smita S - Jira 4490 removed selectedTeamId.substring from query and put a check on seletedTeamID length before using substring method
* 15 May 2015    : Smita S - Jira 4534 retrun if the selectedCandidate is null in rerenderContacts() called during autorefresh functionality
*
***************************************************************************************/

public without sharing class IIFanClubController {
    
   
    public  transient  List<List<VoterRecommendation>> lstofwrapperVoterRecommendation2D {get;set;}
    public    List<VoterRecommendation> lstwrapperVoterRecommendation{get;set;}
    public Set<Id> setPriCon = new Set<Id>();
    public Fan_Club_Setup__c fanClubSetup {get;set;}
    public List<HelpDocument> helpDocuments {get;set;}
    
    public List<Selectoption> teams {get;set;}
    /**********Login-As custom functionality by Sudarshan K. 02nd May 2016 Start Code******/
	public String loggedInUserId { get; set; }
	public String loggedInUserName { get; set; }
	/************************End Code***********************************/
        
    public integer TotalPriContact {get;set;}
    public Integer RECORD_PAGE_SIZE =25;    
    private List<SelectOption> candidates = new List<SelectOption>();
    public ApexPages.StandardSetController listVoterRecomendations{get;set;}
    public String selectedCandidate{get;set;}
    private String helpUrl = 'http://gpshelp';
    public String selectedTeamName {get;set;} 
    public String selectedTeamId {get;set;}
    public Boolean teamUsesAnalystBuddies {get;set;}
    public transient List<Voter_Recommendation__c> listContactInfo;
    public String voterRecomId{get;set;}
    public Boolean isAnalystBuddy {get;set;}
    private String page='IIFanClub';
    public Integer CurrentPageNumber {get;set;}
    public List<String> ShowRecordsOnPage {get;set;}
    public String currentpagesize {get;set;}
    
    public String strSelectedVoterRecs {get;set;}
    
    private Boolean isExport{get;set;}
    public String sortOrder {get; set;} // '1'-'ASC'; '2'-'DESC'
    public String sortOn {get; set;} // Contact Name, Account Name, Removed Reason, Voted in II Campaign, Votes Status
  
    //private Map<String,String> SORTING_ON = new Map<String,String>{'contact'=>'Contact__r.LastName','account'=>'Contact__r.Account.Name'};
    //private Set<String> SORTING_ON = new Set<String>{'contact','account','analyst'};
    private static Map<String,String> SORTING_ORDER = new Map<String,String>{'1'=>'ASC','2'=>'DESC nulls last '};    
    private static Map<String,String> SORTING_ON = new Map<String,String>{'contact'=>'GPSContact__r.Name #ord#',
                                                              'account'=>'GPSContact__r.GPSAccount__r.Name #ord#',                                                               
                                                              'analystbuddy'=>'Is_Analyst_Buddy__c #ord#',
                                                              'location'=>'GPSContact__r.Mailing_State_Desc__c #ord#,GPSContact__r.MailingCity__c #ord#,GPSContact__r.MailingCountry__c #ord#'};
                                                              
    private static Map<String,String> SORTING_ON_SUB_CLAUSE = new Map<String,String>{'contact'=>'GPSContact__r.GPSAccount__r.Name',
                                                              'account'=>'GPSContact__r.Name',                                                               
                                                              'analystbuddy'=>'GPSContact__r.Name,GPSContact__r.GPSAccount__r.Name'};                                                          
                                                              
    public String sortingImg{get;set;}
    //private Map<String,String> SORTING_ORDERS = new Map<String,String>{'1'=>'ASC','2'=>'DESC'};
    //private Map<String,String> SORTING_IMG = new Map<String,String>{'ASC'=>'arrow_under_transp.gif','DESC'=>'arrow_over_transp.gif'}; 
    
    // Converted From Int to String To Define Page Range
    //public List<Integer> pageIndexNumber {get;set;} 19-Jan-2011
      public List<String> pageIndexNumber {get;set;}
      
    //public String sortOrder{get;set;}
    
    public String  gotoPageRange  {get;set;}
    public String getPage(){
        return page; 
    }
    
    public String getHelpUrl(){
        return helpUrl; 
    }
    
    // The candidates for the VF page candidates dropdown
    public List<SelectOption> getCandidates(){
        return candidates;
    }
    
    public boolean showError {get;set;}
    public boolean showHeaderTabs {get;set;}
    
    public String iTrakUserName {get;set;}
      
    public IIFanClubController(){
    	
    	//IE9 Visualforce hack
        String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        if(browserType != null && browserType.contains('MSIE')){
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        }
        //Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        
        BuddiesCount = 0;
        TotalPriContact =0;
        isExport = false;
          lstofwrapperVoterRecommendation2D = new List<List<VoterRecommendation>> ();
          
          lstwrapperVoterRecommendation = new List<VoterRecommendation>();
          setPriCon = new Set<Id>();
          gotoPageRange ='';        
        fanClubSetup = new Fan_Club_Setup__c();
        helpDocuments  = new List<helpDocument>();
        ShowRecordsOnPage = new String[]{'25','50','100'};
        
        currentpagesize = ShowRecordsOnPage[0];
        
        iTrakUserName = UserInfo.getUserName();
        
        /**********Login-As custom functionality by Sudarshan K. 02nd May 2016 Start Code******/
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
        
        /********************************End Code******************************************/
        
        showHeaderTabs = true;
        if(ApexPages.currentPage().getParameters().get('showheadertabs') != null){
        	if (ApexPages.currentPage().getParameters().get('showheadertabs') == 'false'){
        		showHeaderTabs = false;
        	}        	
        }
        
        TeamsPulldownController teamsPulldownController = new TeamsPulldownController(loggedInUserId);
        teams = teamsPulldownController.getTeams();
        selectedTeamId = teamsPulldownController.getSelectedTeam();
        sortOn = 'account';//default sorting on account.Name
        sortOrder = '1';
        listContactInfo = new List<Voter_Recommendation__c>();
        selectedCandidateName= '';
        
        //pageIndexNumber = new List<Integer>();19-Jan-2011
        pageIndexNumber = new List<String>();
       
       // helpDocuments = new List<HelpDocument>();
        
        listVoterRecomendations = null;
        CurrentPageNumber = 0;
      //  fanClubSetup = new Fan_Club_Setup__c(); 
       //Kapil: Change for Fan club Setup
      // Id teamId = teamsPulldownController.getTeamId();
       currentpagesize = '25';
       //Smita S : Jira 4490 : Put a check on selected team id.Use showError variable to display error messae
       if(selectedTeamId == null || selectedTeamId == ''){
            showError = true;
       }    
       else if(selectedTeamId.length() > 18){
            showError = false;
            selectedTeamId = selectedTeamId.substring(0,18);
       }        
       List<Team__c> teams = [Select Name, Fan_Club_Setup__r.Header_Text_2__c, 
                                Fan_Club_Setup__r.header_Text_1__c, Fan_Club_Setup__r.Sub_Text_1__c 
                                ,Fan_Club_Setup__r.II_Help_Email__c, Fan_Club_Setup__r.II_Help_Email_Text__c
                                ,Fan_Club_Setup__r.II_Help_Email_Subject__c, Fan_Club_Setup__r.Sub_Text_2__c
                                ,Fan_Club_Setup__r.Use_Analyst_Buddies__c,Fan_Club_Setup__r.Analyst_Buddy_Help_Text__c
                                ,Fan_Club_Setup__r.Users_can_export_to_Excel__c,Fan_Club_Setup__r.Users_can_Remove_contacts__c, 
                                Fan_Club_Setup__r.Users_can_Add_a_Contact__c
                              from Team__c where id = :selectedTeamId]; 
     /* 
      System.debug('=============header1======================='+ teams[0].Fan_Club_Setup__r.header_Text_1__c); 
      System.debug('=============header2======================='+ teams[0].Fan_Club_Setup__r.Header_Text_2__c); 
      System.debug('=============subText1======================='+ teams[0].Fan_Club_Setup__r.Sub_Text_1__c); 
      System.debug('=============subText2======================='+ teams[0].Fan_Club_Setup__r.Sub_Text_2__c); 
      System.debug('=============help Text======================='+ teams[0].Fan_Club_Setup__r.Analyst_Buddy_Help_Text__c); 
  */
      if(teams.size()>0){
        fanClubSetup = teams[0].Fan_Club_Setup__r;
        if(teams[0].Fan_Club_Setup__c != null){
            for(Attachment attachment : [Select Id, Name From Attachment where parentId = :teams[0].Fan_Club_Setup__c ]){
                helpDocuments.add(new HelpDocument(attachment));
            }
        }
       
       /* fanClubSetup = 
        labelHeader1 = teams[0].Fan_Club_Setup__r.header_Text_1__c;
        labelHeader2 = teams[0].Fan_Club_Setup__r.header_Text_2__c;
        subText1 = teams[0].Fan_Club_Setup__r.Sub_Text_1__c;
        subText2 = teams[0].Fan_Club_Setup__r.Sub_Text_2__c;
        HelpText = teams[0].Fan_Club_Setup__r.Analyst_Buddy_Help_Text__c;
        */
        
      }
      else { showError = true;} 
      
      
    
        /*List<String> teamids = selectedTeamId.split(';');
        String teamId =teamids[0];
        
        selectedTeamName = [select Name from Team__c where id = :teamId].name;
        prepareCandidateOpts();
        updateCandidateContacts();*/
                
    }
    
    Public Integer BuddiesCount = 0;
    public Integer totalAnalystBuddies{get{return (BuddiesCount);}set;} 
    private void getAnalystBuddyCount(){
        BuddiesCount = 0;
        String  soql = 'Select count() From Voter_Recommendation__c Where Candidate_Information__c =  :selectedCandidate  and Is_Analyst_Buddy__c = true ' + 
                        ' and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))';
        BuddiesCount = Database.countQuery(soql);
        System.debug('_________________totalAnalystBuddies__' + BuddiesCount);
    }
    
    
     public void getExportList()
        {
        isExport = true;
        system.debug('#getExportList-----start----');
        String selectedCandidateId = Apexpages.currentPage().getParameters().get('candidateId');
        if(selectedCandidateId != '')
         {
                selectedCandidate = selectedCandidateId;
                
                List<Voter_Recommendation__c> lstVR = [Select Id, GPSContact__r.Name, GPSContact__r.GPSAccount__r.Name,GPSContact__r.Id,Why__c, GPSContact__c,Candidate_Information__c ,Is_Analyst_Buddy__c, GPSContact__r.MailingCity__c, GPSContact__r.Mailing_State_Desc__c, GPSContact__r.MailingCountry__c From Voter_Recommendation__c  Where  Candidate_Information__c = :selectedCandidateId and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))];
                if((lstVR != null) && (lstVR.size()>0))
                rerenderContacts(0);
                
         } 
       
      }
    public void sortAsPriority() {
        Integer currentPage = listVoterRecomendations.getPageNumber();
        /*
        String soql = 'Select Id, Contact__r.Name, Contact__r.Account.Name,Contact__r.Id,Why__c, GPSContact__c,Candidate_Information__c ,Is_Analyst_Buddy__c, Contact__r.MailingCity, Contact__r.MailingStateDesc__c, Contact__r.MailingCountry From Voter_Recommendation__c ' + 
                        ' Where  Candidate_Information__c =  :selectedCandidate ' +
                        ' and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) ' ;
         */               
       // Database.Querylocator  dbqueryLocator = Database.getQueryLocator(soql);
        //listVoterRecomendations = new ApexPages.StandardSetController(dbqueryLocator);
        
        Candidate_Information__c candidateInfo;
        for(Candidate_Information__c canInfo : [Select id , MSID__c, Pure_MSID__c,Current_Page_Size__c from Candidate_Information__c where id =:selectedCandidate limit 1]){
          candidateInfo = canInfo;
          
        }
          setPriCon = new Set<Id>();
          for(Priority_Contacts__c pricon :[Select p.MS_Id__c, p.GPSEmployee__r.MS_ID__c, p.GPSEmployee__c, p.GPSContact__c From Priority_Contacts__c p
                                                where Relationship_Type__c = 'P' AND (p.GPSEmployee__r.MS_ID__c =:candidateInfo.Pure_MSID__c or GPSEmployee__r.User__r.Emp_ID__c =:candidateInfo.Pure_MSID__c) limit 10000])
              {
                           setPriCon.add(pricon.GPSContact__c);
              }
    
        //listVoterRecomendations.setPageSize(listVoterRecomendations.getResultSize());
        List<Voter_Recommendation__c> tempPriorityVoterList = new  List<Voter_Recommendation__c>();
        List<Voter_Recommendation__c> tempNonPriorityVoterList = new  List<Voter_Recommendation__c>();
        
        for(Voter_Recommendation__c voter : [Select Id, GPSContact__r.Name, GPSContact__r.GPSAccount__r.Name,GPSContact__r.Id,Why__c, GPSContact__c,Candidate_Information__c ,Is_Analyst_Buddy__c, GPSContact__r.MailingCity__c, GPSContact__r.Mailing_State_Desc__c, GPSContact__r.MailingCountry__c 
                                             From Voter_Recommendation__c  
                                             Where  Candidate_Information__c =  :selectedCandidate 
                                             and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))]){//listVoterRecomendations.getRecords()) {
            if(setPriCon.contains(voter.GPSContact__c)) {
                tempPriorityVoterList.add(voter);
            }else{
                tempNonPriorityVoterList.add(voter);
            }
        }
        /*listVoterRecomendations.setPageSize();
        listVoterRecomendations.setPageNumber(currentPage);*/
        
        List<Voter_Recommendation__c> lstSorted = new  List<Voter_Recommendation__c>();
        if(sortOrder == '1') {
            lstSorted.addAll(tempPriorityVoterList);
            lstSorted.addAll(tempNonPriorityVoterList);
            
        } else {
            lstSorted.addAll(tempNonPriorityVoterList);
            lstSorted.addAll(tempPriorityVoterList);
        }
        listVoterRecomendations = new Apexpages.Standardsetcontroller(lstSorted);
        listVoterRecomendations.setPageSize(RECORD_PAGE_SIZE);
        listVoterRecomendations.setPageNumber(CurrentPageNumber);
        updateWrapperList();
     }
    
    
    
    
    
    public String candidateName {get;set;}
    public Team__c candidateTeam {get;set;}
     public List<Priority_Contacts__c> lstPriCon {get;set;}
    
    public void getCandidateList(){
        system.debug('#getCandidateList-----start----');
        String selectedCandidate = Apexpages.currentPage().getParameters().get('candidateId');
        listContactInfo = new List<Voter_Recommendation__c>();
        lstwrapperVoterRecommendation = new List<VoterRecommendation>();
         lstofwrapperVoterRecommendation2D = new List<List<VoterRecommendation>> ();
         
        String soql;
        
        // For Exporting Excel according to sorting on page [PR-06689]
        
        String selectedTeamName = '';
        String candidateMsId = '';
            for(Candidate_Information__c candidate : [Select MSID__c, Pure_MSID__c, Team_Name__c From Candidate_Information__c c Where id=:selectedCandidate ]){
                selectedTeamName = candidate.Team_Name__c;
                candidateMsId = candidate.Pure_MSID__c;
            }
            
            lstPriCon = IIDataHelper.getAllPriorityContacts(candidateMsId);
            setPriCon = new Set<Id>();
            for(Priority_Contacts__c pricon :lstPriCon){
                setPriCon.add(pricon.GPSContact__c);
            }
           for(Team__c team : [Select Team_Region__r.Name,Fan_Club_Setup__c,Fan_Club_Setup__r.Use_Analyst_Buddies__c
                                                FROM Team__c 
                                                where Name =:selectedTeamName limit 1]){
            candidateTeam = team; 
                                                                                 
                }
           
                 
          sortOn = Apexpages.currentPage().getParameters().get('sortOn');
          sortOrder = Apexpages.currentPage().getParameters().get('sortOrder');
        if(selectedCandidate!=null && selectedCandidate!=''){
               String sortingOn = SORTING_ON.get('account');
                 String sortingBy = SORTING_ORDER.get('1');
                
                
                    
                if(SORTING_ON.containsKey(sortOn)){
                    sortingOn = SORTING_ON.get(sortOn);
                }
                
                if(SORTING_ORDER.containskey(sortOrder)){
                    sortingBy = SORTING_ORDER.get(sortOrder);
                }
                
                String sortOrderClause = sortingOn + ' ';// + sortingBy;
                //SortingOn.replace('#ord#',sortingBy);
                
                if(SORTING_ON_SUB_CLAUSE.containsKey(sortOn)){
                    sortOrderClause = sortOrderClause + ' ,' + SORTING_ON_SUB_CLAUSE.get(sortOn);
                }
                sortOrderClause = sortOrderClause.replaceAll('#ord#',sortingBy );
            soql = 'Select Id,Candidate_Information__r.Candidate_Name__c, GPSContact__r.Name, GPSContact__r.GPSAccount__r.Name,GPSContact__r.Id,Why__c, GPSContact__c,Candidate_Information__c ,Is_Analyst_Buddy__c, ' + 
                    'GPSContact__r.MailingCity__c, GPSContact__r.Mailing_State_Desc__c, GPSContact__r.MailingCountry__c  From Voter_Recommendation__c' +
                    ' Where Candidate_Information__c = :selectedCandidate '+
                    ' and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) ' +
                    ' Order By ' + sortOrderClause ;
                    
                    
            system.debug('###soql:'+soql);
            
               listContactInfo = (List<Voter_Recommendation__c>)Database.query(soql);
               
            if(listContactInfo.size() > 0){
              candidateName = listContactInfo[0].Candidate_Information__r.Candidate_Name__c;    
            } 
            
            lstwrapperVoterRecommendation = new List<VoterRecommendation>();
            for(Voter_Recommendation__c voterecom : listContactInfo){
                
                lstwrapperVoterRecommendation.add(new VoterRecommendation( voterecom,setPriCon.contains(voterecom.GPSContact__c)));
             }
             
             if(sortOn == 'priority'){
                sortAsPriority();
             }
        }
        system.debug('#getCandidateList-----end----');
        TotalPriContact = getPriContactCount();
    }
    
    public Integer gotoPageNumber {get;set;}
    
    public void goToPage(){
         system.debug('________________next mehtod start__________');
         system.debug('pageIndexNumber'+pageIndexNumber);
         system.debug('gotoPageRangeeeee'+gotoPageRange);
        integer currentpagesizeint = double.valueOf(currentpagesize).intValue(); 
        integer rangelastdigit = double.valueOf(gotoPageRange.substring(gotoPageRange.lastIndexOf('-')+1)).intValue();
        integer rangefirstdigit = double.valueOf(gotoPageRange.substring(0,gotoPageRange.lastIndexOf('-'))).intValue();
        if(rangelastdigit == listVoterRecomendations.getResultSize()){
            rangelastdigit = rangelastdigit +(currentpagesizeint-((rangelastdigit-rangefirstdigit)+1));
        }
        gotoPageNumber = (rangelastdigit)/currentpagesizeint;//19-Jan-2011
        system.debug('gotoPageNumberrrrrrrrrr'+gotoPageNumber);
        try{
          listVoterRecomendations.setPageNumber(gotoPageNumber);          
        }catch(System.Visualforceexception ex){
            rerenderContacts(gotoPageNumber);
        }          
        updateContactsList();
    }
    public Pagereference updateCandidateContacts(){
        sortOn ='account';
        sortOrder = '1';
        rerenderContacts(0);
        return null;
    }
    public String selectedCandidateName {get;set;} 
    public Pagereference prepareCandidateOpts(){
      fanClubSetup = new Fan_Club_Setup__c();
      helpDocuments = new List<HelpDocument>();
        ///////////////////
        if(selectedTeamId != null && selectedTeamId != ''){
            List<String> teamids = selectedTeamId.split(';');
            String teamId =teamids[0];
            teamUsesAnalystBuddies = false;
            
            for(Team__c team : [Select Fan_Club_Setup__c,Name, Fan_Club_Setup__r.Header_Text_2__c, 
                                Fan_Club_Setup__r.header_Text_1__c, Fan_Club_Setup__r.Sub_Text_1__c 
                                ,Fan_Club_Setup__r.II_Help_Email__c, Fan_Club_Setup__r.II_Help_Email_Text__c
                                ,Fan_Club_Setup__r.II_Help_Email_Subject__c, Fan_Club_Setup__r.Sub_Text_2__c
                                ,Fan_Club_Setup__r.Use_Analyst_Buddies__c,Fan_Club_Setup__r.Analyst_Buddy_Help_Text__c,
                                Fan_Club_Setup__r.Users_can_export_to_Excel__c,Fan_Club_Setup__r.Users_can_Remove_contacts__c, 
                                Fan_Club_Setup__r.Users_can_Add_a_Contact__c  
                                from Team__c where id =:teamId limit 1]){
              teamUsesAnalystBuddies =  team.Fan_Club_Setup__r.Use_Analyst_Buddies__c;
              selectedTeamName = team.Name;
                 fanClubSetup = team.Fan_Club_Setup__r;
             
                
              /*
                    labelHeader1 = team.Fan_Club_Setup__r.header_Text_1__c;
                    labelHeader2 = team.Fan_Club_Setup__r.header_Text_2__c;
                    subText1 = team.Fan_Club_Setup__r.Sub_Text_1__c;
                    subText2 = team.Fan_Club_Setup__r.Sub_Text_2__c;
                    HelpText = team.Fan_Club_Setup__r.Analyst_Buddy_Help_Text__c;
                    */
                   System.debug('======flag=================='+teamUsesAnalystBuddies+selectedTeamName);
                
            }
            System.debug('========================'+loggedInUserId);
          
          if(fanClubSetup == null){
                fanClubSetup = new Fan_Club_Setup__c();
               
           } else {
                  
                for(Attachment attach : [Select id , Name FROM Attachment Where parentId =: fanClubSetup.id]){
                    
                    helpDocuments.add(new HelpDocument(attach));  
                }
            }
        }
        
        //prepareCandidateOpts();
        //updateCandidateContacts();
        ////////////////////
        sortOn = 'account';//default sorting on account.Name
        sortOrder = '1';
        candidates = new List<Selectoption>();
        System.debug('###selectedTeamName:'+selectedTeamName);
        for(Candidate_Information__c candidate : [Select id, Candidate_Name__c, Current_Page_Size__c
                                                    From Candidate_Information__c 
                                                    Where Team_Name__c = : selectedTeamName Order By Candidate_Name__c ASC]){
            candidates.add(new SelectOption(candidate.Id, candidate.Candidate_Name__c));
             
        }
        
        if(candidates.size() > 0){
            selectedCandidate = candidates[0].getValue();
            selectedCandidateName = candidates[0].getLabel();
        }else{
            selectedCandidateName ='';
        }
        
        
       
        return null;
    }
    
    public Pagereference rerenderContacts(Integer currentPage){
        if(currentPage == null){
            currentPage = 0;
        }
        CurrentPageNumber = currentPage;
        String sortingOn = SORTING_ON.get('account');
        String sortingBy = SORTING_ORDER.get('1');
        
        
            
        if(SORTING_ON.containsKey(sortOn)){
            sortingOn = SORTING_ON.get(sortOn);
        }
        
        if(SORTING_ORDER.containskey(sortOrder)){
            sortingBy = SORTING_ORDER.get(sortOrder);
        }
        
        String sortOrderClause = sortingOn + ' ' ;//+ sortingBy;
        
        if(SORTING_ON_SUB_CLAUSE.containsKey(sortOn)){
            sortOrderClause = sortOrderClause + ' ,' + SORTING_ON_SUB_CLAUSE.get(sortOn);
        }
        sortOrderClause = sortOrderClause.replaceAll('#ord#',sortingBy);
        system.debug('###selectedCandidate:'+selectedCandidate);
        if(selectedCandidate == null || selectedCandidate == '')
            return null;
        listContactInfo = new List<Voter_Recommendation__c>();
        
        Candidate_Information__c candidateInfo ;
        
        for(Candidate_Information__c canInfo : [Select id , MSID__c, Pure_MSID__c, Current_Page_Size__c from Candidate_Information__c where id =:selectedCandidate limit 1]){
          candidateInfo = canInfo;
          if(candidateInfo.Current_Page_Size__c == null){
             candidateInfo.Current_Page_Size__c = 'Show 50'; 
          }  
        }
        
        String soql;
        if(selectedCandidate!=null && selectedCandidate!=''){           
                soql = 'Select Id, GPSContact__r.Name, GPSContact__r.GPSAccount__r.Name,GPSContact__r.Id,Why__c, GPSContact__c,Candidate_Information__c ,Is_Analyst_Buddy__c, GPSContact__r.MailingCity__c, GPSContact__r.Mailing_State_Desc__c, GPSContact__r.MailingCountry__c From Voter_Recommendation__c ' + 
                        ' Where  Candidate_Information__c =  :selectedCandidate ' +
                        ' and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) ' +
                        ' Order By ' + sortOrderClause ;
        }
        system.debug('###soql:'+soql);
        lstwrapperVoterRecommendation.clear();
               setPriCon = new Set<Id>();
         lstPriCon = new List<Priority_Contacts__c>();
              if(candidateInfo != null)
               {      
                      setPriCon = new Set<Id>();
                      lstPriCon = new List<Priority_Contacts__c>();
                      
                      for(Priority_Contacts__c pricon :[Select p.MS_Id__c, p.GPSEmployee__r.MS_ID__c, p.GPSEmployee__c, p.GPSContact__c From Priority_Contacts__c p
                                                        where  (p.GPSEmployee__r.MS_ID__c =:candidateInfo.Pure_MSID__c or GPSEmployee__r.User__r.Emp_ID__c =:candidateInfo.Pure_MSID__c )
                                                                        AND Relationship_Type__c = 'P'
                                                                        and GPSContact__c in (Select  GPSContact__c From Voter_Recommendation__c Where  Candidate_Information__c =  :selectedCandidate and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) ) ])
                                      {
                                                   setPriCon.add(pricon.GPSContact__c);
                                      }
                        system.debug('setPriCon'+setPriCon);
                                                    
               }
        
         Database.Querylocator dbqueryLocator = Database.getQueryLocator(soql);
        
         if(candidateInfo != null && isExport)  {
            lstofwrapperVoterRecommendation2D = new List<List<VoterRecommendation>> ();
                lstwrapperVoterRecommendation.clear();
                Boolean isAdded;
                for(Voter_Recommendation__c voterecom : database.query(soql))
                  {
                      isAdded = false;                                  
                      lstwrapperVoterRecommendation.add(new VoterRecommendation(voterecom,setPriCon.contains(voterecom.GPSContact__c)));
                      if(lstwrapperVoterRecommendation.size()==1000) //limit of vf repeat components
                       {
                          lstofwrapperVoterRecommendation2D.add(lstwrapperVoterRecommendation);
                          lstwrapperVoterRecommendation = new List<VoterRecommendation>();
                          isAdded = true; 
                       }
                    }
                if(!isAdded) {
                    lstofwrapperVoterRecommendation2D.add(lstwrapperVoterRecommendation);
                    }
                
                    system.debug('lstofwrapperVoterRecommendation2D.size()'+lstofwrapperVoterRecommendation2D.size());
                    system.debug('lstwrapperVoterRecommendation.size()'+lstwrapperVoterRecommendation.size());
                    return null;
                
               }
         isExport = false;
        listVoterRecomendations = new ApexPages.StandardSetController(dbqueryLocator);
        if(candidateInfo!= null){
            if(candidateInfo.Current_Page_Size__c == 'Show 25' ){
                RECORD_PAGE_SIZE = 25 ;
                currentpagesize = '25';
            }else if(candidateInfo.Current_Page_Size__c == 'Show 50' ){
                                     RECORD_PAGE_SIZE = 50 ;
                                 currentpagesize = '50';
                 }else if(candidateInfo.Current_Page_Size__c == 'Show 100'){
                     RECORD_PAGE_SIZE = 100;
                     currentpagesize = '100';
                 }/*else{
                     RECORD_PAGE_SIZE = listVoterRecomendations.getResultSize();
                     currentpagesize = 'All';
                 }*/
        } 
        
        setpagesize();
        
        listVoterRecomendations.setPageSize(RECORD_PAGE_SIZE);
        System.debug('===============record size========='+RECORD_PAGE_SIZE);
        listVoterRecomendations.setPageNumber(currentPage);
        system.debug('###listVoterRecomendations.size:'+listVoterRecomendations.getResultSize());
        
        //pageIndexNumber = new List<Integer>(); 19-Jan-2011
        pageIndexNumber = new List<String>();
        updateContactsList();  
        
        getAnalystBuddyCount();
        for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
            //pageIndexNumber.add(index+1); 19-Jan-2011
           
           if(index+1 == TotalPage){
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(listVoterRecomendations.getResultSize()));
            }
            else{
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
            }
            
            startrange = endrange+1;
            endrange = endrange+RECORD_PAGE_SIZE;
         }
         system.debug('lstwrapperVoterRecommendation.size()'+lstwrapperVoterRecommendation.size());
        return null;
    }
    
   
   public void setpagesize()
    {
         if(currentpagesize == '25')
          {
            RECORD_PAGE_SIZE = 25;
          }
         else  if(currentpagesize == '50')
          {
            RECORD_PAGE_SIZE = 50;
          }
         else if(currentpagesize == '100')
          {
            RECORD_PAGE_SIZE = 100;
          }
        /*else
          {
            RECORD_PAGE_SIZE = listVoterRecomendations.getResultSize();
            
          }
          */
    }
   
   public integer getPriContactCount()
    {
        return Database.countQuery( 'Select count() From Voter_Recommendation__c ' + 
                        ' Where  Candidate_Information__c =  :selectedCandidate ' +
                        ' and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null)) AND GPSContact__c IN :setPriCon');
    }
   
    public void updateNewPagesize()
     {
          integer oldpageno=1;
          setpagesize();
          /*if(listVoterRecomendations != null)
           {
             oldpageno =listVoterRecomendations.getPageNumber();
           }
         */
         
          try{
            listVoterRecomendations.setPageSize(RECORD_PAGE_SIZE);                          
            listVoterRecomendations.setPageNumber(oldpageno);
          }catch (System.Visualforceexception ex){
             rerenderContacts(1);
          }

          listVoterRecomendations.setPageSize(RECORD_PAGE_SIZE);
          listVoterRecomendations.setPageNumber(oldpageno);
          
        pageIndexNumber.clear();
                /*//19-Jan-2011
                for(Integer index = 0 ; index < TotalPage; index++){
                pageIndexNumber.add(index+1);
           }*/
           for(Integer index = 0,startrange=1,endrange=RECORD_PAGE_SIZE; index < TotalPage; index++){
            //pageIndexNumber.add(index+1); 19-Jan-2011
           
           if(index+1 == TotalPage){
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(listVoterRecomendations.getResultSize()));
            }
            else{
                pageIndexNumber.add(String.valueOf(startrange)+'-'+String.valueOf(endrange));
            }
            
            startrange = endrange+1;
            endrange = endrange+RECORD_PAGE_SIZE;
         }
           CurrentPageNumber = oldpageno;
           
           //Update Target List page Size
           Candidate_Information__c candidateInfoToUpdate = new Candidate_Information__c(id = selectedCandidate );
           if(RECORD_PAGE_SIZE == 25 ){
             candidateInfoToUpdate.Current_Page_Size__c = 'Show 25';
           }else if(RECORD_PAGE_SIZE == 50 ){
             candidateInfoToUpdate.Current_Page_Size__c = 'Show 50';
           }else if(RECORD_PAGE_SIZE == 100){
             candidateInfoToUpdate.Current_Page_Size__c = 'Show 100';
           }
           /*else{
              candidateInfoToUpdate.Current_Page_Size__c = 'Show All';
           }*/
           
           update candidateInfoToUpdate;
           updateContactsList();
           
    }
    
    public void updateContactsList(){
         if(sortOn == 'priority') {
            CurrentPageNumber = listVoterRecomendations.getPageNumber();
            sortAsPriority();
        } else {
            listContactInfo = (List<Voter_Recommendation__c>)listVoterRecomendations.getRecords();
            CurrentPageNumber = listVoterRecomendations.getPageNumber();
            updateWrapperList();
         }
     }
  
        //28- Feb -2011
   public void updateWrapperList()
   {
        system.debug('setPriCon'+setPriCon.size());
        lstwrapperVoterRecommendation.clear();
        for(Voter_Recommendation__c voterecom : (List<Voter_Recommendation__c>)listVoterRecomendations.getRecords())
         {
               lstwrapperVoterRecommendation.add(new VoterRecommendation( voterecom,setPriCon.contains(voterecom.GPSContact__c)));
                
         }
    TotalPriContact = getPriContactCount();
   }
    public Pagereference sortContacts(){
        rerenderContacts(CurrentPageNumber);
        return null;
    }
    
    public Pagereference removeVoterRec(){
        System.debug('###voterRecomId:'+voterRecomId);
        Voter_Recommendation__c voterRec ;
        for(Voter_Recommendation__c voter : [Select Id,Candidate_Information__c,GPSContact__c, Is_Analyst_Buddy__c,Active_Flag__c,User_Who_Inactivated__c From Voter_Recommendation__c Where id = :voterRecomId]){
            voterRec = voter;
        }
        System.debug('###voterRec:'+voterRec);
        if (voterRec != null ){
          if(voterRec.Is_Analyst_Buddy__c == true){
            List<Analyst_Buddy__c> buddies = [Select id From Analyst_Buddy__c
                                             Where GPSContact__c = : voterRec.GPSContact__c 
                                             AND Candidate_Information_Analyst__c =:voterRec.Candidate_Information__c ];
                                             
            delete buddies;                          
          } 
          //set active flag
          
          //delete voterRec;
                  
            voterRec.Active_Flag__c = false;
            voterRec.User_Who_Inactivated__c = loggedInUserId;
            update voterRec;
          
         
          rerenderContacts(CurrentPageNumber);
        }
        return null;
    }
    
    /*
        This method removes all selected Voter recommendations
    */
     public Pagereference removeSelectedVoterRec(){
        System.debug('###strSelectedVoterRecs:'+ strSelectedVoterRecs);
        String[] selectedVRs = strSelectedVoterRecs.split(';');
        Set<String> selectedIds = new   Set<String>();
         selectedIds.addAll(selectedVRs);
         if(selectedIds.contains('')){
            selectedIds.remove('');
         }
          if(selectedIds.contains(null)){
            selectedIds.remove(null);
         }
         
        List<Voter_Recommendation__c > lstVRs = [Select Id,Candidate_Information__c,GPSContact__c, Is_Analyst_Buddy__c,Active_Flag__c,User_Who_Inactivated__c From Voter_Recommendation__c Where id in :selectedIds];
       
        Set<String> contactIds = new   Set<String>(); 
        Set<String> candidateIds = new   Set<String>();
        
        Map<string,Voter_Recommendation__c> mapForAnalystBuddies = new Map<string,Voter_Recommendation__c>();
        for(Voter_Recommendation__c voterRec : lstVRs){
             if(voterRec.Is_Analyst_Buddy__c == true){
                contactIds.add( voterRec.GPSContact__c );
                candidateIds.add(voterRec.Candidate_Information__c);
                mapForAnalystBuddies.put(voterRec.GPSContact__c + ';' + voterRec.Candidate_Information__c,voterRec);
                                
             }
            voterRec.Is_Analyst_Buddy__c = false;
            voterRec.Active_Flag__c = false;
            voterRec.User_Who_Inactivated__c = loggedInUserId;
        } 
        
         List<Analyst_Buddy__c> buddiesTodelete = new  List<Analyst_Buddy__c>();
        List<Analyst_Buddy__c> buddies = [Select id,GPSContact__c,Candidate_Information_Analyst__c From Analyst_Buddy__c
                                             Where GPSContact__c in :contactIds
                                             AND Candidate_Information_Analyst__c in :candidateIds ];
        for(Analyst_Buddy__c bud :buddies ){
            if(mapForAnalystBuddies.containsKey(bud.GPSContact__c + ';' + bud.Candidate_Information_Analyst__c )){
                buddiesTodelete.add(bud);
            }
        }
        
        System.debug('###buddiesTodelete:'+ buddiesTodelete.size()); 
        if(buddiesTodelete.size()>0){                                     
            delete buddiesTodelete;      
        }                    
          
        update lstVRs;
          
        
        rerenderContacts(CurrentPageNumber);
        TotalPriContact = getpricontactcount();
        return null;
    }
  
  //Set If contac is Analyst Buddy   
  public Pagereference setAnalystBuddy(){
    if(voterRecomId != '' && voterRecomId != null){
      Voter_Recommendation__c voterRec;
       Voter_Recommendation__c voterRecToUpdate = new Voter_Recommendation__c(Id=voterRecomId);
      // Get Voter Recommendation from list
      
       //28-Feb-2011
              /*for(Voter_Recommendation__c voter : listContactInfo){
                if(voter.id == voterRecomId){
                  voterRec = voter; 
                  break;
                }
              }*/
      
      //28-Feb-2011
      for(VoterRecommendation voter : lstwrapperVoterRecommendation){
        if(voter.id == voterRecomId){
          voterRec = voter.voterRecom; 
          system.debug('setAnalystBuddy()^^^');
          break;
        }
      }
      if(voterRec != null){
        voterRec.Is_Analyst_Buddy__c = isAnalystBuddy;
        voterRecToUpdate.Is_Analyst_Buddy__c = isAnalystBuddy;
        //create a new analyst Buddy
        Analyst_Buddy__c newBuddy = new Analyst_Buddy__c(Candidate_Information_Analyst__c = voterRec.Candidate_Information__c,GPSContact__c = voterRec.GPSContact__c);
        //Get already created analsyt buddy fot the contact
        List<Analyst_Buddy__c> buddies = [Select id From Analyst_Buddy__c
                                        Where GPSContact__c = : voterRec.GPSContact__c 
                                        AND Candidate_Information_Analyst__c =:voterRec.Candidate_Information__c ];
          
        //Set Analyst Buddy 
        if(isAnalystBuddy == true){
          if(buddies.size() == 0){
            buddies.add(newBuddy);
            insert buddies; 
          }
                           
          
          
        }else{
          //Remove Analyst Buddy    
          if(buddies.size() > 0){
            delete buddies; 
          }
          
        }
        //update voter recommendation
        //update voterRec;
        update voterRecToUpdate;
        rerenderContacts(CurrentPageNumber);
        //getAnalystBuddyCount();          
      }   
    }
    
    return null;
  }  
    
    
    public void first() {
      listVoterRecomendations.first();
      updateContactsList();
    }
    
    public void last() {
        listVoterRecomendations.last();
        updateContactsList();
    }
    
    
    public void previous() {
       //8-March-2011 Modified rows exist in the records collection and press Previous Command Link [PR-08589] 
        try{
          listVoterRecomendations.save();
          listVoterRecomendations.previous();
        }catch (System.Visualforceexception ex){
             rerenderContacts(CurrentPageNumber);
        }
        
        updateContactsList();
    }
    public void next() {
        system.debug('________________next mehtod start__________'+listVoterRecomendations);
        system.debug('________________next mehtod start__________');        
        try{
          listVoterRecomendations.next();
        }catch (System.Visualforceexception ex){
             rerenderContacts(CurrentPageNumber);
        }   
        system.debug('________________next mehtod end__________');
        updateContactsList();
    }
    public Boolean hasNext {
        get{
          if(listVoterRecomendations == null) return false;
          return listVoterRecomendations.getHasNext();
        }
        set;
    }
    
     public Boolean hasPrevious {
        get {
            if(listVoterRecomendations == null) return false;
            return listVoterRecomendations.getHasPrevious();
        }
        set;
    }
     public Boolean isFirst{
        get{
           if(listVoterRecomendations == null) return true;
           return (listVoterRecomendations.getPageNumber() == 1);
        }
        set;
   }
    
    
   public Integer recordStartNumber{
       get{
           if(listVoterRecomendations == null) return 0;
           system.debug('recordStartNumberrrrrrrrrrrr'+ ((CurrentPageNumber -1) * RECORD_PAGE_SIZE) +1);
           system.debug('CurrentPageNumberrrrrrrrrrrrr'+ CurrentPageNumber);
           system.debug('RECORD_PAGE_SIZErrrrrrrrrrrr'+  RECORD_PAGE_SIZE);
           return ((CurrentPageNumber -1) * RECORD_PAGE_SIZE) +1;
        }
   }
   
   public Integer recordEndNumber{
       get{
           if(listVoterRecomendations == null) return 0;
           if(isLast == true){
             return TotalRecords;
           }else{
             return CurrentPageNumber * RECORD_PAGE_SIZE;
           }
        }
   } 
    
    
    
    public Integer TotalPage{
        get{
            if(listVoterRecomendations == null) return 0;
            Integer resultSize = listVoterRecomendations.getResultSize();
            Integer pageSize = listVoterRecomendations.getPageSize();
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
            if(listVoterRecomendations == null) return 0;
            return listVoterRecomendations.getResultSize();
        }
    }
    
     public Boolean isLast{
        get {
            if(listVoterRecomendations == null) return true;
            Integer resultSize = listVoterRecomendations.getResultSize();
            Integer pageSize = listVoterRecomendations.getPageSize();
            Integer totalPages = resultSize/pageSize;
            if(resultSize == 0){
                return true;
            }
            if(pageSize*totalPages == resultSize){
                return listVoterRecomendations.getPageNumber() == totalPages;
            }else{
                return listVoterRecomendations.getPageNumber() == totalPages + 1;
            }
        }
        set;
    }
    
  //On Page action bind ContactList
  //@@ Download as Excel 
  public PageReference getVoterCandidates(){
    selectedCandidate = Apexpages.currentPage().getParameters().get('candidateId');
    listContactInfo = new List<Voter_Recommendation__c>();
    String soql;
    if(selectedCandidate!=null && selectedCandidate!=''){
      soql = 'Select Id, GPSContact__r.Name, GPSContact__r.GPSAccount__r.Name,GPSContact__r.Id,Why__c, GPSContact__c,Candidate_Information__c, Is_Analyst_Buddy__c,  ' + 
            'GPSContact__r.MailingCity__c, GPSContact__r.Mailing_State_Desc__c, GPSContact__r.MailingCountry__c From Voter_Recommendation__c' +
            ' Where Candidate_Information__c = :selectedCandidate ' +
             ' and  (Active_Flag__c = true or ( Active_Flag__c = false and User_Who_Inactivated__c = null))' +
             ' Order By GPSContact__r.GPSAccount__r.Name ASC,GPSContact__r.FirstName__c ASC';
      system.debug('###soql:'+soql);
      for(List<Sobject> objList : Database.query(soql)){
        listContactInfo.addAll((List<Voter_Recommendation__c>)objList);
      }
      System.debug('==========='+listContactInfo);   
      updateWrapperList();
         
    }
    
    return null;
  }      
  
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
  
   public void fillCandidatesDropDown(){     
    
   } 
   
    public PageReference keepQueryLocatorAlive() 
    {
       system.debug('Action Poller'+datetime.now());
        rerenderContacts(CurrentPageNumber);
       return null;
       
    }


public class VoterRecommendation
  {
     public boolean isPriorityContact {get;set;}
     public Voter_Recommendation__c voterRecom {get;set;}
     public String id {get;set;} 
     public VoterRecommendation(Voter_Recommendation__c voteRe , boolean isconpri)
      {
          voterRecom = new Voter_Recommendation__c();
         isPriorityContact = false;
         voterRecom = voteRe;
         isPriorityContact = isconpri;
         id = voteRe.id;
         system.debug('isconpri^^^'+isconpri);
         
      }
     
  }
 
/**
    
    public class ContactInfoWrapper{
        public String contactName{get;set;}
        public String contactID{get;set;}
        public String accountName{get;set;}
        public String voterRecID{get;set;}
        public String why{get;set;}
        
        public ContactInfoWrapper(String contactName, String contactID,String accountName,String voterRecID,String why){
            this.contactName = contactName;
            this.contactId = contactId;
            this.accountName = accountName;
            this.voterRecId = voterRecId;
            this.why = why;
        }
    }
    **/
}