/******************************************************************************************
* Xsell Opporunity Controller
*
* ChangeLog:
*
*   9/29/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public with sharing class XS_Opportunity {

    public String nomineeName { get; set; }

    public String submitterName { get; set; }
    
    public string header{get;set;}
    public List<Cross_Sell__c> xList {get;set;}
    public string crossSellId {get;set;}
    
    public Boolean isSuperUser{get;set;}
    public Boolean isPrivateDelegateUser{get;set;}
    public Boolean isPublicDelegateUser{get;set;}
    public Boolean isPrivateNormalUser{get;set;}
    
    public List<Employee__c> beneficiaryList{get;set;}
    public Cross_Sell__c x {get;set;}
    
    public PermissionSetAssignment PSASuperUser;
    public PermissionSetAssignment PSAPrivateDelegateUser;
    public PermissionSetAssignment PSAPrivateNormalUser;
    public PermissionSetAssignment psaPublicDelegateUser;
    
    // Added by Avinash on 15/09/2016 - Used for export and constructor 
    public Profile loggedInProfile;
    public List<Id> XSellIdList;
    public Id loggedInUserId;
    public Id loggedInProfileId;
    public PermissionSetAssignment psaOtherUser;
    // Added by Avinash on 15/09/2016 - Used for export and constructor
    
    public List<PermissionSetAssignment> PSASuperUserList;
    public List<PermissionSetAssignment> PSAPrivateDelegateUserList;
    public List<PermissionSetAssignment> PSAPrivateNormalUserList;
    public List<PermissionSetAssignment> psaPublicDelegateUserList;
    
    public String userName{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    
    public Boolean xSellCount{get;set;}
    public Boolean applicationAccess{get;set;}
    public String toDelete{get;set;}
    
    public List<Wrapper> wrapperList{get;set;}
    public map<string, string> noteMap = new map<string,string>();
    
    public String regExp = '\r\n';
    
    public String errorMessage1{get;set;}
    public String strStatusAdvSearch {get; set;}
    public String strCreatedStartDtAdvSearch {get; set;}
    public String strCreatedEndAdvSearch {get; set;}
    public String strSubmitterSearch {get; set;}
    public String strNomineeSearch {get; set;}
    public String strInputSearch {get;set;}
    public Boolean isAdvancedSearch {get;set;}
    public Boolean showNoDataFound {get;set;}
    private integer offSetCounter = 0;  //keeps track of the offset
    private integer list_size = 4; //sets the page size or number of rows
    public integer total_size ; //used to show user the total size of the list
    public string startDateN {get; set;}
    public string endDateN{get; set;}
    public string flagCheckStart {get; set;}
    public string flagCheckEnd {get; set;}
    public String TotalRequests { get; set; }
    public list<Cross_Sell__c> requestList {get;set;}
    public List<Cross_Sell__c> searchList;
    
    /**********************************************************************************
         * CONSTRUCTOR 
         *
         **********************************************************************************/
    public XS_Opportunity(){
        userName = UserInfo.getName();
        total_size = 0;
        
        loadOpps();
        
        if(xList.size() == 0)
            xSellCount = true;
        
        lstwrapper = new List<wrapper>();
        
        if(isSuperUser) 
            header = 'sep=|\r\nID| Stage| Client Name| Client Type Industry| Decision| Quarter| '
                    + 'Submission Date| Submitted by| Nominee| Nominee Division| '
                    + 'Nominee Group| Nominee Region| Nominee Title| Deal Product Type| '
                    + 'Size of Transaction| Revenue 000s| Transaction Status| '
                    + 'Estimated Timing of Transaction| Declaration| MNPI| Notes| '
                    + 'One time fee vs Ongoing| Why significant| Other Comments| First time business| Intra ISG\r\n';
        else if(isPrivateDelegateUser) 
            header = 'sep=|\r\nID| Stage| Client Name| Client Type Industry| Decision| Quarter| '
                    + 'Submission Date| Submitted by| Nominee| Nominee Division| '
                    + 'Nominee Group| Nominee Region| Nominee Title| Deal Product Type| '
                    + 'Size of Transaction| Revenue 000s| Transaction Status| '
                    + 'Estimated Timing of Transaction| Declaration| Notes| '
                    + 'One time fee vs Ongoing| Why significant| Other Comments| First time business| Intra ISG\r\n';
        else if(isPublicDelegateUser) 
            header = 'sep=|\r\nID| Stage| Client Type Industry| Decision| Quarter| '
                    + 'Submission Date| Submitted by| Nominee| Nominee Division| '
                    + 'Nominee Group| Nominee Region| Nominee Title| Deal Product Type| '
                    + 'Revenue 000s| Transaction Status|  Estimated Timing of Transaction| '
                    + 'Declaration| Notes| One time fee vs Ongoing| Why significant| '
                    + 'Other Comments| First time business| Intra ISG\r\n';
    
    }
    
    /************************************************************************************
        * LOAD OPPS 
        *
        ************************************************************************************/
    public void loadOpps(){
        
        applicationAccess = true;
        
        try{
        
            xList = new List<Cross_Sell__c>();
            XSellIdList = new List<Id>();
            
            loggedInUserId = UserInfo.getUserId();
            loggedInProfileId = UserInfo.getProfileId();
            
            List<Cross_Sell__c> XSellNomineeList = [select Id from Cross_Sell__c where Nominee__r.User__r.Id = :loggedInUserId];
            
            List<GroupMember> GMList = [select GroupId from GroupMember where UserorGroupId = :UserInfo.getUserId()];
            List<Id> GMIdList = new list<Id>();
            if(GMList != null) {
                for(GroupMember GM:GMList)
                    GMIdList.add(GM.GroupId);
            }
            
            List<Cross_Sell__Share> XSellShareList = [select ParentId from Cross_Sell__Share where
                                                      UserorGroupId in :GMIdList or UserorGroupId = :loggedInUserId];
            if(XSellShareList != null) {
                for(Cross_Sell__Share XS:XSellShareList)
                    XSellIdList.add(XS.ParentId);
            }
            
            if(XSellNomineeList != null) {
                for(Cross_Sell__c XS:XSellNomineeList)
                    XSellIdList.add(XS.Id);
            }
            
            // Id loggedInUserId = UserInfo.getUserId();
            isSuperUser = false;
            isPrivateNormalUser = false;
            isPrivateDelegateUser = false;
            isPublicDelegateUser = false;
            
            // check logged in user permission set details for super user
            // assign super user variable true or false
            List<PermissionSet> PSSuperUserList = [select Id from PermissionSet where name IN( 'XS_Super_User')];
            if(PSSuperUserList.size() > 0) {
                PSASuperUserList = [select Id from PermissionSetAssignment where
                                    AssigneeId = :loggedInUserId and PermissionSetId IN :PSSuperUserList];
                if(PSASuperUserList.size() > 0)
                    PSASuperUser = PSASuperUserList.get(0);
            }
            
            // check logged in user permission set details for private normal
            // assign private normal variable true or false
            List<PermissionSet> PSPrivateNormalUserList = [Select Id from PermissionSet where Name='XS_Private_Normal_User'];
            if(PSPrivateNormalUserList.size() > 0) {
                PSAPrivateNormalUserList= [select Id from PermissionSetAssignment where
                                           AssigneeId = :loggedInUserId and PermissionSetId IN :PSPrivateNormalUserList];
                if(PSAPrivateNormalUserList.size() > 0)
                    PSAPrivateNormalUser = PSAPrivateNormalUserList.get(0);
            }
            
            // check logged in user permission set details for private delegate
            // assign private delegate variable true or false
            List<PermissionSet> PSPrivateDelegateUserList = [Select Id from PermissionSet where Name='XS_Private_Delegates'];
            if(PSPrivateDelegateUserList.size() > 0) {
                PSAPrivateDelegateUserList= [select Id from PermissionSetAssignment where
                                             AssigneeId = :loggedInUserId and PermissionSetId IN :PSPrivateDelegateUserList ];
                if(PSAPrivateDelegateUserList.size() > 0)
                    PSAPrivateDelegateUser = PSAPrivateDelegateUserList.get(0);
            }
            
            // Added by Avinash
            // check logged in user permission set details for public delegate
            // assign public delegate variable true or false
            List<PermissionSet> pspublicDelegateUserList = [Select Id from PermissionSet where Name='XS_Public_Delegates'];
            if(pspublicDelegateUserList.size() > 0) {
                psaPublicDelegateUserList = [select Id from PermissionSetAssignment where
                                             AssigneeId = :loggedInUserId and PermissionSetId IN :pspublicDelegateUserList];
                if(psaPublicDelegateUserList.size() > 0)
                    psaPublicDelegateUser = psaPublicDelegateUserList.get(0);
            }
            
            List<PermissionSetAssignment> xSellUserList = [SELECT id FROM PermissionSetAssignment where
                                    AssigneeId = :loggedInUserId AND (PermissionSet.Name = 'XS_Normal_Users' OR PermissionSet.Name = 'XS_Business_Admin') ];
            if(xSellUserList.size() > 0)
                psaOtherUser = xSellUserList.get(0);
            
            // get profile name of the logged in user
            loggedInProfile = [select Name from Profile where id =:loggedInProfileId];
            
            
            if(PSASuperUser != null || loggedInProfile.Name == 'System Administrator') {
                isSuperUser = true;
                
                string year = '';
                string month = '01';
                string day = '01';
                
                if(Label.XS_Display_Year == '0'){
                year = String.valueOf(Date.today().Year());
                }
                else if(Label.XS_Display_Year == '1'){
                year = String.valueOf(Date.today().Year()-1);
                }
                else if(Label.XS_Display_Year == '2'){
                year = String.valueOf(Date.today().Year()-2);
                }
                else if(Label.XS_Display_Year == '3'){
                year = String.valueOf(Date.today().Year()-3);
                }
                else{
                year = String.valueOf(Date.today().Year()-10);
                }
                string stringDate = year + '-' + month + '-' + day ;
                
                Date submittedDate = date.valueOf(stringDate);
                
                
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,c.Declaration_non_boolean__c, c.First_Time_Business_non_boolean__c, c.Intra_ISG_non_boolean__c,
                         c.Transaction_Status__c, c.Declaration__c,   c.Notes_By_Delegates__c,c.MNPI__c, c.MNPI_non_boolean__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Beneficiary_Division__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c, c.Approval_Status__c, c.Approval_Comment__c, 
                         c.Other_Divisions_Involved1__c, c.Other_Divisions_Involved2__c, c.Other_individuals_involved__c, c.Other_individuals_involved1__c,
                         c.Other_individuals_involved2__c, c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, createdById,   
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division') FROM 
                         Cross_Sell__c c WHERE (c.Stage__c != 'Draft' OR CREATEDBYID = :loggedInUserId) AND Submission_Date__c >=: submittedDate ORDER BY CreatedDate desc];
                        
                        total_size = xList.size();     
            } 
            /*--- Commented for JIRA - XSELLFORCE-16 Requirement ---*/
            /*
            else if(PSAPrivateDelegateUser != null ) {
                isPrivateDelegateUser  = true;
                
               xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c,  , c.Notes_By_Delegates__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c,c.Beneficiary_Division__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division')
                         FROM Cross_Sell__c c WHERE CALENDAR_YEAR(CreatedDate) = :Date.today().year() 
                         AND (CREATEDBYID = :loggedInUserId OR (c.Stage__c != 'Draft' AND ID IN :XSellIdList)) ORDER BY CreatedDate desc];
            } else if(psaPublicDelegateUser != null ) {
                isPublicDelegateUser = true;
                
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c,  , c.Notes_By_Delegates__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c,c.Beneficiary_Division__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division')
                         FROM Cross_Sell__c c WHERE CALENDAR_YEAR(CreatedDate) = :Date.today().year() 
                         AND (CREATEDBYID = :loggedInUserId OR (c.Stage__c != 'Draft' AND ID IN :XSellIdList)) ORDER BY CreatedDate desc];
            } else if(PSAPrivateNormalUser != null ) {
                isPrivateNormalUser  = true;
                
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c, c.Size_of_Transaction__c,
                         c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c, c.Transaction_Status__c, c.Declaration__c,
                          , c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Beneficiary_Division__c,
                         c.Nominee_Title__c, c.Nominee_Region__c, c.Nominee_MSID__c, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division') FROM Cross_Sell__c c WHERE 
                         CALENDAR_YEAR(CreatedDate) = :Date.today().year() AND (CREATEDBYID = :loggedInUserId OR ID IN :XSellIdList)
                         ORDER BY Name DESC];
            } else if(psaOtherUser != null) {
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c, c.Size_of_Transaction__c,
                         c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c, c.Transaction_Status__c, c.Declaration__c,
                          , c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c,
                         c.Nominee_Title__c, c.Nominee_Region__c, c.Nominee_MSID__c, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division') FROM Cross_Sell__c c
                         where CALENDAR_YEAR(CreatedDate ) = :Date.today().year() AND 
                         (createdById = :loggedInUserId OR id in :XSellIdList) ORDER BY CreatedDate desc];
                         
                isSuperUser = false;
            } 
            */
            else {
                    string year ='';
                    string month = '01';
                string day = '01';
                
                if(Label.XS_Display_Year == '0'){
                 year = String.valueOf(Date.today().Year());
                }
                else if(Label.XS_Display_Year == '1'){
                 year = String.valueOf(Date.today().Year()-1);
                }
                else if(Label.XS_Display_Year == '2'){
                 year = String.valueOf(Date.today().Year()-2);
                }
                else if(Label.XS_Display_Year == '3'){
                 year = String.valueOf(Date.today().Year()-3);
                }
                else{
                 year = String.valueOf(Date.today().Year()-10);
                }
                string stringDate = year + '-' + month + '-' + day ;
                Date submittedDate = date.valueOf(stringDate);
                
                

            // applicationAccess = false;
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c,  c.Notes_By_Delegates__c,c.Declaration_non_boolean__c, c.First_Time_Business_non_boolean__c, c.Intra_ISG_non_boolean__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Beneficiary_Division__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c, c.Approval_Status__c, 
                         c.Approval_Comment__c, c.Other_Divisions_Involved1__c, c.Other_Divisions_Involved2__c,c.MNPI__C, c.MNPI_non_boolean__c,
                         c.Other_individuals_involved__c, c.Other_individuals_involved1__c, c.Other_individuals_involved2__c, 
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, createdById, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division') FROM Cross_Sell__c c
                         where (createdById = :loggedInUserId OR id in :XSellIdList) AND Submission_Date__c >=: submittedDate ORDER BY CreatedDate desc];
                         
                         
                          total_size = xList.size();
                          
              /*Query to fetch notes from Note object*/        
             for(Cross_Sell_Opty_Notes__c xSellNote : [SELECT ID, Cross_Sell__c, Notes__c FROM Cross_Sell_Opty_Notes__c WHERE Cross_Sell__c IN :xList AND CREATEDBYID = :loggedInUserId ORDER BY createddate DESC]){
                    noteMap.put(xSellNote.id+'!~!'+xSellNote.Cross_Sell__c,xSellNote.Cross_Sell__c+'!~!'+xSellNote.Notes__c);
            }
            }
            
            List<Cross_Sell_Parties_Involved__c> divisionsList = new List<Cross_Sell_Parties_Involved__c>();
            
            wrapperList = new List<Wrapper>();
            for(Cross_Sell__c xs: xList) {
                
                String otherDivisions = '';
                if(xs.Cross_Sell_Parties_Involved__r != null) {
                        for(Cross_Sell_Parties_Involved__c xsChild: xs.Cross_Sell_Parties_Involved__r){
                                if(!otherDivisions.contains(xsChild.Division__c)) {
                                        otherDivisions += xsChild.Division__c + ';';
                                }
                        }
                }
                if(isSuperUser == false && xs.createdById == loggedInUserId){
                String noteString = ''; 
                
                for(String targetNotes : noteMap.values()){
                    String[] noteArray = targetNotes.split('!~!');
                    if(noteArray[0] == xs.id){
                        //xs.Notes_By_Delegates__c = noteArray[1];
                        noteString += noteArray[1]+';';
                    }
                }
                xs.Notes_By_Delegates__c = noteString.removeEnd(';');
                }
                otherDivisions = otherDivisions .removeEnd(';');
                Wrapper wrap = new Wrapper(xs, otherDivisions);
                wrapperList.add(wrap);
            }
            
        } Catch(Exception E) {
            
        }
    }
     
    public PageReference deleteXSell(){
        Pagereference p;
        try {
            list<Cross_Sell__c> XSellList= [Select id from Cross_Sell__c where id = :toDelete];
            if(XSellList.size() > 0 || XSellList[0].Id != ''){
                delete XSellList;
            } 
            
            p = new Pagereference('/apex/XS_Opportunity?tab=Home');
            p.setRedirect(true);
        } catch(Exception e) {
            return null;
        }
        
        return p;
    }
    
    
    public List<Cross_Sell_Opty_Notes__c> getRelatedCrossSellNotes() {
        
        List<Cross_Sell_Opty_Notes__c> toReturn = new List<Cross_Sell_Opty_Notes__c>();
        toReturn = [SELECT Id, Name, Cross_Sell__c,Notes__c FROM Cross_Sell_Opty_Notes__c WHERE cross_sell__c =: x.Id];            
        
        return toReturn;
    }
    
    
    
    /*************************************************************************************
    * NEW 
    *
    *************************************************************************************/
    public pageReference create(){
        
        PageReference p = new PageReference('/apex/XS_Opportunity_NewRecordP?tab=Home');
        p.setRedirect(true);
        return p; 
    }
    
    /**********************************************************************************
    * EDIT
    *
    ***********************************************************************************/
    public pageReference editLine(){
        
        PageReference p = new PageReference('/apex/XS_OpportunityEdit?id=' + crossSellId);
        p.setRedirect(true);
        return p; 
        
    }
    
    public void export(){
        try{
            loggedInProfile = [select Name from Profile where id =:loggedInProfileId];
            
            if(PSASuperUser != null || loggedInProfile.Name == 'System Administrator') {
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,c.Declaration_non_boolean__c, c.First_Time_Business_non_boolean__c, c.Intra_ISG_non_boolean__c,
                         c.Transaction_Status__c, c.Declaration__c,   c.Notes_By_Delegates__c,c.Approval_Status__c,c.Approval_Comment__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Nominee_Group__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,c.MNPI__C, c.MNPI_non_boolean__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division') FROM 
                         Cross_Sell__c c WHERE (c.Stage__c != 'Draft' OR CREATEDBYID = :loggedInUserId) ORDER BY CreatedDate desc ];
                         
            } 
            /*
            else if(PSAPrivateDelegateUser != null ) {
               xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c,  , c.Notes_By_Delegates__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Nominee_Group__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division')
                         FROM Cross_Sell__c c WHERE (CREATEDBYID = :loggedInUserId 
                         OR (c.Stage__c != 'Draft' AND ID IN :XSellIdList)) ORDER BY CreatedDate desc];
            } else if(psaPublicDelegateUser != null ) {
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c,  , c.Notes_By_Delegates__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Nominee_Group__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, 
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division')
                         FROM Cross_Sell__c c WHERE (CREATEDBYID = :loggedInUserId 
                         OR (c.Stage__c != 'Draft' AND ID IN :XSellIdList)) ORDER BY CreatedDate desc];
            } else if(PSAPrivateNormalUser != null ) {
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c, c.Size_of_Transaction__c,
                         c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c, c.Transaction_Status__c, c.Declaration__c,
                          , c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, 
                         c.Nominee_Title__c, c.Nominee_Region__c, c.Nominee_MSID__c, c.Nominee_Group__c,
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division') FROM Cross_Sell__c c WHERE 
                         (CREATEDBYID = :loggedInUserId OR ID IN :XSellIdList) ORDER BY Name DESC];
            } else if(psaOtherUser != null) {
                xList = [SELECT c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c, c.Size_of_Transaction__c,
                         c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c, c.Transaction_Status__c, c.Declaration__c,
                          , c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c,
                         c.Nominee_Title__c, c.Nominee_Region__c, c.Nominee_MSID__c, c.Nominee_Group__c,
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division') FROM Cross_Sell__c c
                         WHERE (createdById = :loggedInUserId OR id in :XSellIdList) ORDER BY CreatedDate desc];
            }
          */  
          else{
            xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c,  c.Notes_By_Delegates__c,c.Declaration_non_boolean__c, c.First_Time_Business_non_boolean__c, c.Intra_ISG_non_boolean__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Beneficiary_Division__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c, c.Approval_Status__c, 
                         c.Approval_Comment__c, c.Other_Divisions_Involved1__c, c.Other_Divisions_Involved2__c,c.MNPI__C, c.MNPI_non_boolean__c,
                         c.Other_individuals_involved__c, c.Other_individuals_involved1__c, c.Other_individuals_involved2__c, 
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, createdById,
                             (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r 
                              WHERE ROLE__c = 'Other Division')
                         FROM Cross_Sell__c c WHERE (CREATEDBYID = :loggedInUserId 
                         OR (c.Stage__c != 'Draft' AND ID IN :XSellIdList)) ORDER BY CreatedDate desc];
          }
        } catch(Exception e) {
                System.debug('Exception: ' + e);
        }
        
        if( xList.isEmpty() )
            return;
        
        /*List<Cross_Sell__c> cList = [SELECT Name, Client_Additional_Details__c,
                                     Client_Name__c, Client_Type_Industry__c,
                                     Closed_Date__c, Deal_Product_Type__c,
                                     Decision__c, Declaration__c,
                                     Division_Dsc_Org__c, Estimated_Timing_of_Transaction__c,
                                     First_time_business__c, Intra_ISG__c,
                                     Level_Dsc_Job__c, Manager__c,
                                      , MSID__c, Nominee__r.Name,
                                     Nominee_Division__c, Nominee_Group__c,Nominee_Grp__c,
                                     Nominee_Region__c, Nominee_Title__c,
                                     One_time_fee_vs_Ongoing__c, Other_Individual_s_Involved__c,
                                     Quarter__c, Revenues_000s__c,
                                     Size_of_Transaction__c, Stage__c,
                                     Submission_Date__c, Submitted_by__c,
                                     Transaction_Status__c, Why_significant__c,
                                     Other_Comments__c, Notes_By_Delegates__c
                                     FROM Cross_Sell__c WHERE Id in: xList ]; */
        
        for( Cross_Sell__c cs: xList){
            wrapper w = new wrapper();
            
            w.name = cs.Name;
            //w.beneficiaryDivision = cs.beneficiary_Division__c; 
            //w.beneficiaryFullName = cs.Beneficiary_Full_Name__c;
            //w.beneficiaryMSID = cs.Beneficiary_MSID__c;
            //w.beneficiaryRegion = cs.Beneficiary_Region__c;
            //w.beneficiaryTitle = cs.Beneficiary_Title__c;
            
            /*if(cs.Client_Additional_Details__c != null) {
                w.clientAdditionalDetails = cs.Client_Additional_Details__c;
                if(isPublicDelegateUser)
                    w.clientAdditionalDetails = isPublicDelegateUser ? 'RESTRICTED' : NULL;
            }*/
            
            if(cs.Client_Name__c != null) {
                w.clientName = cs.Client_Name__c;
                if(isPublicDelegateUser)
                    w.clientName = isPublicDelegateUser ? 'RESTRICTED' : NULL;
                
            }
            
            if(cs.Client_Type_Industry__c != null) {
                w.clientTypeIndustry = cs.Client_Type_Industry__c;
                
            }
            
            /*if(cs.Closed_Date__c != null)
                w.closedDate = cs.Closed_Date__c <> NULL ? cs.Closed_Date__c.format() : NULL;*/
            
            if(cs.Deal_Product_Type__c != null) {
                w.dealProductType = cs.Deal_Product_Type__c;
                
            }
            
            if(cs.Decision__c != null)
                w.decision = cs.Decision__c;
                
            if(cs.Declaration__c != null)
                w.declaration = cs.Declaration_non_boolean__c<> NULL ? String.valueOf(cs.Declaration_non_boolean__c) : NULL;
                
            if(cs.Estimated_Timing_of_Transaction__c != null)
                w.estimatedTimingofTransaction = cs.Estimated_Timing_of_Transaction__c <> NULL ? cs.Estimated_Timing_of_Transaction__c.format() : NULL;
                
            if(cs.First_time_business__c != null)
                w.firstTimeBusiness = cs.First_Time_Business_non_boolean__c<> NULL ? String.valueOf(cs.First_Time_Business_non_boolean__c) : NULL;
                
            if(cs.Intra_ISG__c != null)
                w.intraISG = cs.Intra_ISG_non_boolean__c<> NULL ? String.valueOf(cs.Intra_ISG_non_boolean__c) : NULL;
                
            if(cs.Nominee_Manager_s_Full_name__c != null)
                w.manager = cs.Nominee_Manager_s_Full_name__c;
                
             if(cs.MNPI_non_boolean__c!= null)
                w.mNPI = cs.MNPI_non_boolean__c <> NULL ? String.valueOf(cs.MNPI_non_boolean__c) : NULL;
                
                
            if(cs.Nominee_MSID__c != null)
                w.mSID = cs.Nominee_MSID__c;
                
            if(cs.Nominee__r.Name != null)
                w.nominee = cs.Nominee__r.Name;
                
            if(cs.Nominee_Division__c != null)
                w.nomineeDivision = cs.Nominee_Division__c;
                
            if(cs.Nominee_Group__c!= null)
                w.nomineeGroup = cs.Nominee_Group__c;  
                
            if(cs.Nominee_Region__c != null) {    
                w.nomineeRegion = cs.Nominee_Region__c;
                
            }
            
            if(cs.Nominee_Title__c != null) {
                w.nomineeTitle = cs.Nominee_Title__c;
                
            }
            
            if(cs.One_time_fee_vs_Ongoing__c != null)
                w.onetimefeevsOngoing = cs.One_time_fee_vs_Ongoing__c;
                
            if(cs.Quarter__c != null)
                w.quarter = cs.Quarter__c;
            
            if(cs.Revenues_000s__c != null) {
                w.revenues000s = cs.Revenues_000s__c;
                
            }
            
            if(cs.Size_of_Transaction__c != null) {
                w.sizeofTransaction = cs.Size_of_Transaction__c;
                if(isPublicDelegateUser)
                    w.sizeofTransaction = isPublicDelegateUser ? 'RESTRICTED' : NULL;
                
            }
            
            if(cs.Stage__c != null)
                w.stage = cs.Stage__c;
                
            if(cs.Submission_Date__c != null)
                w.submissionDate = cs.Submission_Date__c <> NULL ? cs.Submission_Date__c.format() : NULL;
                
            if(cs.Submitted_by__c != null)
                w.submittedby = cs.Submitted_by__c;
                
            if(cs.Transaction_Status__c != null)
                w.transactionStatus = cs.Transaction_Status__c;
            
            if(cs.Why_significant__c != null) {
                w.whysignificant = cs.Why_significant__c.replaceAll('\n','<br/>');
            } 
            
            if(cs.Other_Comments__c != null) {   
                w.otherComments = cs.Other_Comments__c.replaceAll('\n','<br/>');
            }
            
            if(cs.Notes_By_Delegates__c != null) {
                w.notesByDelegates = cs.Notes_By_Delegates__c;
            }
            
            if(cs.Approval_Status__c!= null) {
                w.approvStatus= cs.Approval_Status__c;
            }
            
            if(cs.Approval_Comment__c!= null) {
                w.approvComment= cs.Approval_Comment__c;
            }
            lstwrapper.add(w);
        }
                Apexpages.currentPage().getHeaders().put('Content-Disposition', 'attachment; filename="TEST.csv"');
        
        system.debug('lstwrapper :'+lstwrapper.size());
        
    } 
    
    public PageReference exportToCSV(){
        PageReference pr = new PageReference('/apex/XS_GenerateCSV');
        pr.setRedirect(false);
        return pr;
    }    
        
    public class Wrapper{
        
        public String name {get;set;}
        // public String beneficiaryDivision{get;set;}
        // public String beneficiaryFullName{get;set;}
        // public String beneficiaryMSID{get;set;}
        // public String beneficiaryRegion{get;set;}
        // public String beneficiaryTitle{get;set;}
        public String clientAdditionalDetails{get;set;}
        public String clientName{get;set;}
        public String clientTypeIndustry{get;set;}
        public String closedDate{get;set;}
        public String dealProductType{get;set;}
        public String decision{get;set;}
        public String declaration{get;set;}
        public String divisionDscOrg{get;set;}
        public String estimatedTimingofTransaction{get;set;}
        public String firstTimeBusiness{get;set;}
        public String intraISG{get;set;}
        public String levelDscJob{get;set;}
        public String manager{get;set;}
        public String mNPI{get;set;}
        public String mSID{get;set;}
        public String nominee{get;set;}
        public String nomineeDivision{get;set;}
        public String nomineeGroup{get;set;}
        //public String nomineeManagersFullname{get;set;}
        public String nomineeRegion{get;set;}
        public String nomineeTitle{get;set;}
        public String onetimefeevsOngoing{get;set;}
        public String otherIndividualInvolved{get;set;}
        public String quarter{get;set;}
        public String revenues000s{get;set;}
        public String sizeofTransaction{get;set;}
        public String stage{get;set;}
        public String submissionDate{get;set;}
        public String submittedby{get;set;}
        public String transactionStatus{get;set;}
        public String whysignificant{get;set;}
        public String otherComments{get;set;}
        public String notesByDelegates{get;set;}
        public String approvStatus{get;set;}
        public String approvComment{get;set;}
           
        /**
         *   Added by Avinash on 09/09/2016
         */
        public Cross_Sell__c xs{get; set;}
        public String otherDivisions{get; set;}
        
        public Wrapper() {
                
        }
        
        public Wrapper(Cross_Sell__c xs, String otherDivisions) {
                this.xs = xs;
                this.otherDivisions = otherDivisions;
        }
    }
    
    
    //advance search logic
    
    Public pagereference advancedSearch() {
        requestList = New list<Cross_Sell__c>();
        Datetime DtStart;
        Datetime DtEnd;
        date stDate;
        date etDate;
        date removalStartDate;
        date removalEndDate;
        
        errorMessage1 ='';
        isAdvancedSearch = true; 
        showNoDataFound = false;  
        xList.clear();
        requestList.clear();
        list<Cross_Sell__c> dummyReqList = new list<Cross_Sell__c>();
        TotalRequests = string.valueOf(0); 
        integer total_size = 0;
        
        boolean first=false;
        boolean second=false;
       
      //  String Query='SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Client_Name__c, Nominee__c, Nominee_Title__c, Nominee_Division__c, Nominee_Manager_s_Full_name__c, Nominee_Region__c, Client_Type_Industry__c, Transaction_Product_Type__c, Closed_Date__c, Nominee_Group__c, Submitted_by__c, Transaction_Status__c, Intra_ISG__c, One_time_fee_vs_Ongoing__c, First_time_business__c, Why_significant__c, Other_Comments__c,  , Declaration__c, Stage__c, Revenues_000s__c, Division_Dsc_Org__c, Cost_Center_Desc__c, CC_Region_Org__c, Level_Dsc_Job__c, Manager__c, Size_of_Transaction__c, Beneficiary_Full_Name__c, Other_indiv_involved__c, Beneficiary_Region__c, Is_MS_connect_used__c, Client_Additional_Details__c, Deal_Product_Type__c, Estimated_Timing_of_Transaction__c, Decision__c, Select_Exact_Period__c, Submission_Date__c, Notes_By_Delegates__c, Quarter__c, MSID__c, Beneficiary_MSID__c, Beneficiary_Title__c, Beneficiary_Full_Name_s__c, Submitter_Email__c, Email_Group_Name__c, Nominee_MSID__c, Delegate_Email_Group__c, Nominee_Grp__c, Beneficiary_Division__c, Trade_ID__c, Job_Number__c, Other_individuals_involved__c, Is_covered_by_JV__c, Other_Divisions_Involved1__c, Other_Divisions_Involved2__c, Other_individuals_involved1__c, Other_individuals_involved2__c from Cross_Sell__c where';
        String Query= 'Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,c.Transaction_Status__c, c.Declaration__c,  , c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Beneficiary_Division__c, c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, createdById,  (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r  WHERE ROLE__c = \'Other Division\') FROM Cross_Sell__c c WHERE'  ;
        if(strStatusAdvSearch != null && strStatusAdvSearch != '' && strStatusAdvSearch != 'All' ){
            Query += ' Stage__c  = \''+strStatusAdvSearch  +'\' AND '; 
        }
        
        if(strInputSearch!=null && strInputSearch!='' && strInputSearch != 'Search ID'){
              strInputSearch = String.escapeSingleQuotes(strInputSearch);
              Query += ' Name  like \'%'+strInputSearch+'%\' AND ';
        }
        
         if(strSubmitterSearch!=null && strSubmitterSearch!='' && strSubmitterSearch != 'e.g. John Smith, John'){
              strSubmitterSearch = String.escapeSingleQuotes(strSubmitterSearch);
              Query += ' Submitted_by__c like \'%'+strSubmitterSearch+'%\' AND ';
        }
        
         if(strNomineeSearch!=null && strNomineeSearch!='' && strNomineeSearch != 'e.g. John Smith, John'){
              strNomineeSearch = String.escapeSingleQuotes(strNomineeSearch);
              Query += ' Nominee__r.name  like \'%'+strNomineeSearch+'%\' AND ';
        }
                
        if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch.trim() != '' && strCreatedStartDtAdvSearch != 'From'){
            stDate = date.parse(strCreatedStartDtAdvSearch);               
            DtStart = Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
            Query += ' CreatedDate >=:DtStart  AND';
        }
         
        if(strCreatedEndAdvSearch != null && strCreatedEndAdvSearch.trim() !='' && strCreatedEndAdvSearch != 'To'){
            etDate=date.parse(strCreatedEndAdvSearch); 
            DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
            DtEnd=DtEnd.adddays(1);
            Query+=' CreatedDate <:DtEnd AND';
        } 
        Query+=' Name != NULL ';
        Query+=' order by createdDate desc ';
        if(strCreatedStartDtAdvSearch!= null && strCreatedStartDtAdvSearch.trim() != '' && strCreatedStartDtAdvSearch != 'From' && strCreatedEndAdvSearch!= null && strCreatedEndAdvSearch.trim() != '' && strCreatedEndAdvSearch != 'To')
        {
            if (DtStart.getTime()> (DtEnd.getTime()-1)) {
                errorMessage1 = 'The start date must be before the end date. Please select a valid date.';
                strCreatedStartDtAdvSearch = null;
                strCreatedEndAdvSearch= null;
                flagCheckStart ='not loaded';
                flagCheckEnd ='not loaded';
            first = true;
            }
        }
        
        if(  first == true  ||  second == true){
            return null;
        }
        system.debug('---> Query :-'+Query);
        dummyReqList = (List<Cross_Sell__c>)Database.Query(Query);
        if(dummyReqList != null && !dummyReqList.isEmpty()){
            TotalRequests = string.valueOf(dummyReqList.size()); 
            total_size = dummyReqList.size();
            if(dummyReqList.size() > list_size){
               for(Integer i = 0; i < list_size;i++){
                   requestList.add(dummyReqList[i]);
               }
           }
           else {
               xList = dummyReqList ;
           }
        }
        else {
            showNoDataFound = true;
             } 
        system.debug('---> size :-'+dummyReqList.size() + '--Value --'+dummyReqList);
        /*-- Populate the Wrapper class : START --*/
        
        wrapperList = new List<Wrapper>();
         for(Cross_Sell__c xs: dummyReqList) {
                
                String otherDivisions = '';
                if(xs.Cross_Sell_Parties_Involved__r != null) {
                        for(Cross_Sell_Parties_Involved__c xsChild: xs.Cross_Sell_Parties_Involved__r){
                                if(!otherDivisions.contains(xsChild.Division__c)) {
                                        otherDivisions += xsChild.Division__c + ';';
                                }
                        }
                }
                if(isSuperUser == false && xs.createdById == loggedInUserId){
                String noteString = ''; 
                
                for(String targetNotes : noteMap.values()){
                    String[] noteArray = targetNotes.split('!~!');
                    if(noteArray[0] == xs.id){
                        //xs.Notes_By_Delegates__c = noteArray[1];
                        noteString += noteArray[1]+';';
                    }
                }
                xs.Notes_By_Delegates__c = noteString.removeEnd(';');
                }
                otherDivisions = otherDivisions .removeEnd(';');
                Wrapper wrap = new Wrapper(xs, otherDivisions);
                wrapperList.add(wrap);
            }
        /*-- Populate the Wrapper class : END --*/
        system.debug('---> Wrapper :-'+wrapperList);
        return null;
    }
    
    
    public pagereference clearSearch(){
        PageReference pageRef = new PageReference('/apex/XS_Opportunity?tab=Home');
        return pageRef;
    }
    
    
    
   public Integer getTotal_size() {
      return total_size;
   }
    
/*-- PAGINATION lOGIC : STARTS --*/
     public list<Cross_Sell__c> getPageResults(Integer offSetCounter){
        list<Cross_Sell__c> pageRecords;
        String Query= 'Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,c.Transaction_Status__c, c.Declaration__c,  , c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c, c.Beneficiary_Division__c, c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c, createdById,  (SELECT Id, Division__c, Role__c, Cross_Sell__c FROM Cross_Sell_Parties_Involved__r  WHERE ROLE__c = \'Other Division\') FROM Cross_Sell__c c WHERE'  ;
        Query+=' Name != NULL order by createdDate desc '; 
        Query+='Limit '+list_size+' OFFSET '+offSetCounter;  
        pageRecords = (List<Cross_Sell__c>)Database.Query(Query);  
        total_size = pageRecords.size();     
        return pageRecords;
    }
    
    
    public PageReference Beginning() { // previous button

      offSetCounter = 0;
      system.debug('next'+offSetCounter+'button'+list_size);
           searchList=  getPageResults(offSetCounter);
          
           
        /*-- Populate the Wrapper class : START --*/
        
        wrapperList = new List<Wrapper>();
         for(Cross_Sell__c xs: searchList) {
                
                String otherDivisions = '';
                if(xs.Cross_Sell_Parties_Involved__r != null) {
                        for(Cross_Sell_Parties_Involved__c xsChild: xs.Cross_Sell_Parties_Involved__r){
                                if(!otherDivisions.contains(xsChild.Division__c)) {
                                        otherDivisions += xsChild.Division__c + ';';
                                }
                        }
                }
                if(isSuperUser == false && xs.createdById == loggedInUserId){
                String noteString = ''; 
                
                for(String targetNotes : noteMap.values()){
                    String[] noteArray = targetNotes.split('!~!');
                    if(noteArray[0] == xs.id){
                        //xs.Notes_By_Delegates__c = noteArray[1];
                        noteString += noteArray[1]+';';
                    }
                }
                xs.Notes_By_Delegates__c = noteString.removeEnd(';');
                }
                otherDivisions = otherDivisions .removeEnd(';');
                Wrapper wrap = new Wrapper(xs, otherDivisions);
                wrapperList.add(wrap);
            }
        /*-- Populate the Wrapper class : END --*/
        
          
      return null;
   }
    
    
    public PageReference Previous() { // previous button
      
       offSetCounter -= list_size;
       system.debug('next'+offSetCounter+'button'+list_size);
       if(offSetCounter > 0){
       searchList=  getPageResults(offSetCounter);
           
        /*-- Populate the Wrapper class : START --*/
        
        wrapperList = new List<Wrapper>();
         for(Cross_Sell__c xs: searchList) {
                
                String otherDivisions = '';
                if(xs.Cross_Sell_Parties_Involved__r != null) {
                        for(Cross_Sell_Parties_Involved__c xsChild: xs.Cross_Sell_Parties_Involved__r){
                                if(!otherDivisions.contains(xsChild.Division__c)) {
                                        otherDivisions += xsChild.Division__c + ';';
                                }
                        }
                }
                if(isSuperUser == false && xs.createdById == loggedInUserId){
                String noteString = ''; 
                
                for(String targetNotes : noteMap.values()){
                    String[] noteArray = targetNotes.split('!~!');
                    if(noteArray[0] == xs.id){
                        //xs.Notes_By_Delegates__c = noteArray[1];
                        noteString += noteArray[1]+';';
                    }
                }
                xs.Notes_By_Delegates__c = noteString.removeEnd(';');
                }
                otherDivisions = otherDivisions .removeEnd(';');
                Wrapper wrap = new Wrapper(xs, otherDivisions);
                wrapperList.add(wrap);
            }
        /*-- Populate the Wrapper class : END --*/
        
          }
          
          else 
              system.debug('negative offset');
      return null;
   }
   
   
    
    public PageReference Next() { // next button

      offSetCounter += list_size;
      system.debug('next'+offSetCounter+'button'+list_size);
      if(offSetCounter > 0){
           searchList=  getPageResults(offSetCounter);
          
           
        /*-- Populate the Wrapper class : START --*/
        
        wrapperList = new List<Wrapper>();
         for(Cross_Sell__c xs: searchList) {
                
                String otherDivisions = '';
                if(xs.Cross_Sell_Parties_Involved__r != null) {
                        for(Cross_Sell_Parties_Involved__c xsChild: xs.Cross_Sell_Parties_Involved__r){
                                if(!otherDivisions.contains(xsChild.Division__c)) {
                                        otherDivisions += xsChild.Division__c + ';';
                                }
                        }
                }
                if(isSuperUser == false && xs.createdById == loggedInUserId){
                String noteString = ''; 
                
                for(String targetNotes : noteMap.values()){
                    String[] noteArray = targetNotes.split('!~!');
                    if(noteArray[0] == xs.id){
                        //xs.Notes_By_Delegates__c = noteArray[1];
                        noteString += noteArray[1]+';';
                    }
                }
                xs.Notes_By_Delegates__c = noteString.removeEnd(';');
                }
                otherDivisions = otherDivisions .removeEnd(';');
                Wrapper wrap = new Wrapper(xs, otherDivisions);
                wrapperList.add(wrap);
            }
        /*-- Populate the Wrapper class : END --*/
        }
        else
            system.debug('offsetCounter negative');
          
      return null;
   }
  
    public PageReference End() { // previous button
        
      system.debug('total size'+total_size);
      system.debug('offSetCounter '+offSetCounter );
      offSetCounter = total_size - math.mod(total_size, list_size);
      system.debug('next'+offSetCounter+'button'+list_size);
           searchList=  getPageResults(offSetCounter);
          
           
        /*-- Populate the Wrapper class : START --*/
        
        wrapperList = new List<Wrapper>();
         for(Cross_Sell__c xs: searchList) {
                
                String otherDivisions = '';
                if(xs.Cross_Sell_Parties_Involved__r != null) {
                        for(Cross_Sell_Parties_Involved__c xsChild: xs.Cross_Sell_Parties_Involved__r){
                                if(!otherDivisions.contains(xsChild.Division__c)) {
                                        otherDivisions += xsChild.Division__c + ';';
                                }
                        }
                }
                if(isSuperUser == false && xs.createdById == loggedInUserId){
                String noteString = ''; 
                
                for(String targetNotes : noteMap.values()){
                    String[] noteArray = targetNotes.split('!~!');
                    if(noteArray[0] == xs.id){
                        //xs.Notes_By_Delegates__c = noteArray[1];
                        noteString += noteArray[1]+';';
                    }
                }
                xs.Notes_By_Delegates__c = noteString.removeEnd(';');
                }
                otherDivisions = otherDivisions .removeEnd(';');
                Wrapper wrap = new Wrapper(xs, otherDivisions);
                wrapperList.add(wrap);
            }
        /*-- Populate the Wrapper class : END --*/
        
          
      return null;
   }
   
   
   /*-- PAGINATION lOGIC : ENDS --*/ 
   
    public Integer getRowsCount() {
        return list_size;
    }
   
   
}