/******************************************************************************************
* Xsell Opporunity Controller
*
* ChangeLog:
*
*   9/29/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public with sharing class XS_Opportunitydummy {
    
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
    
    public List<PermissionSetAssignment> PSASuperUserList;
    public List<PermissionSetAssignment> PSAPrivateDelegateUserList;
    public List<PermissionSetAssignment> PSAPrivateNormalUserList;
    public List<PermissionSetAssignment> psaPublicDelegateUserList;
    
    public String userName{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    
    public Boolean xSellCount{get;set;}
    public Boolean applicationAccess{get;set;}
    public String toDelete{get;set;}
    
    
    /**********************************************************************************
* CONSTRUCTOR 
*
**********************************************************************************/
    public XS_Opportunitydummy(){
        userName = UserInfo.getName();
        
        loadOpps();
        
        if(xList.size() == 0)
            xSellCount = true;
        
        lstwrapper = new List<wrapper>();
        
        if(isSuperUser) 
            header = 'ID, Stage, Client Name, Client Type Industry, Decistion, Quarter, '
                    + 'Submission Date, Submitted by, Nominee , Nominee Division, '
                    + 'Nominee Group, Nominee Region, Nominee Title, Deal Product Type, '
                    + 'Size of Transaction, Revenues000s, Transaction Status, '
                    + 'Estimated Timing of Transaction, Declaration, MNPI, Notes, '
                    + 'One time fee vs Ongoing, Why significant, Other Comments, First time business, Intra ISG\r\n';
        else if(isPrivateDelegateUser) 
            header = 'ID, Stage, Client Name, Client Type Industry, Decistion, Quarter, '
                    + 'Submission Date, Submitted by, Nominee , Nominee Division, '
                    + 'Nominee Group, Nominee Region, Nominee Title, Deal Product Type, '
                    + 'Size of Transaction, Revenues000s, Transaction Status, '
                    + 'Estimated Timing of Transaction, Declaration, Notes, '
                    + 'One time fee vs Ongoing, Why significant, Other Comments, First time business, Intra ISG\r\n';
        else if(isPublicDelegateUser) 
            header = 'ID, Stage, Client Type Industry, Decistion, Quarter, '
                    + 'Submission Date, Submitted by, Nominee , Nominee Division, '
                    + 'Nominee Group, Nominee Region, Nominee Title, Deal Product Type, '
                    + 'Revenues000s, Transaction Status,  Estimated Timing of Transaction, '
                    + 'Declaration, Notes, One time fee vs Ongoing, Why significant, '
                    + 'Other Comments, First time business, Intra ISG\r\n';
    }
    
    /************************************************************************************
        * LOAD OPPS 
        *
        ************************************************************************************/
    public void loadOpps(){
        
        applicationAccess = true;
        
        try{
        
            xList = new List<Cross_Sell__c>();
            List<Id> XSellIdList = new List<Id>();
            
            Id loggedInUserId = UserInfo.getUserId();
            Id loggedInProfileId = UserInfo.getProfileId();
            
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
            
            PermissionSetAssignment psaOtherUser;
            List<PermissionSetAssignment> xSellUserList = [SELECT id FROM PermissionSetAssignment where
                                    AssigneeId = :loggedInUserId AND (PermissionSet.Name = 'XS_Normal_Users' OR PermissionSet.Name = 'XS_Business_Admin') ];
            if(xSellUserList.size() > 0)
                psaOtherUser = xSellUserList.get(0);
            
            // get profile name of the logged in user
            Profile loggedInProfile = [select Name from Profile where id =:loggedInProfileId];
            
            
            if(PSASuperUser != null || loggedInProfile.Name == 'System Administrator') {
                isSuperUser = true;
                
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c, c.MNPI__c, c.Notes_By_Delegates__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c From 
                         Cross_Sell__c c WHERE CALENDAR_YEAR(CreatedDate ) = 2016 AND (c.Stage__c != 'Draft' OR CREATEDBYID = :loggedInUserId) ORDER BY CreatedDate desc ];
                         
                        
                         
            } else if(PSAPrivateDelegateUser != null ) {
                isPrivateDelegateUser  = true;
                
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c, c.MNPI__c, c.Notes_By_Delegates__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c
                         From Cross_Sell__c c WHERE CALENDAR_YEAR(CreatedDate ) = 2016 AND (CREATEDBYID = :loggedInUserId OR
                         (c.Stage__c != 'Draft' AND ID IN :XSellIdList)) ORDER BY CreatedDate desc];
            } else if(psaPublicDelegateUser != null ) {
                isPublicDelegateUser = true;
                
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c,
                         c.Size_of_Transaction__c, c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c,
                         c.Transaction_Status__c, c.Declaration__c, c.MNPI__c, c.Notes_By_Delegates__c,
                         c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, c.Nominee_Title__c,
                         c.Nominee_Region__c, c.Nominee_MSID__c, c.First_time_business__c, c.Intra_ISG__c,
                         c.One_time_fee_vs_Ongoing__c, c.Quarter__c, c.Why_significant__c, c.Other_Comments__c
                         From Cross_Sell__c c WHERE CALENDAR_YEAR(CreatedDate ) = 2016 AND (CREATEDBYID = :loggedInUserId OR
                         (c.Stage__c != 'Draft' AND ID IN :XSellIdList)) ORDER BY CreatedDate desc];
            } else if(PSAPrivateNormalUser != null ) {
                isPrivateNormalUser  = true;
                
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c, c.Size_of_Transaction__c,
                         c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c, c.Transaction_Status__c, c.Declaration__c,
                         c.MNPI__c, c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c, 
                         c.Nominee_Title__c, c.Nominee_Region__c, c.Nominee_MSID__c From Cross_Sell__c c WHERE 
                         CALENDAR_YEAR(CreatedDate ) = 2016 AND (CREATEDBYID = :loggedInUserId OR ID IN :XSellIdList) ORDER BY Name DESC];
            } else if(psaOtherUser != null) {
                xList = [Select c.Id, c.Name, c.Client_Name__c, c.Client_Type_Industry__c, c.Stage__c, c.Decision__c,
                         c.Submission_Date__c, c.Submitted_by__c, c.Nominee__r.name, c.Deal_Product_Type__c, c.Size_of_Transaction__c,
                         c.Revenues_000s__c, c.Estimated_Timing_of_Transaction__c, c.Transaction_Status__c, c.Declaration__c,
                         c.MNPI__c, c.Notes_By_Delegates__c, c.Nominee_Manager_s_Full_name__c, c.Nominee_Division__c,
                         c.Nominee_Title__c, c.Nominee_Region__c, c.Nominee_MSID__c From Cross_Sell__c c
                         where CALENDAR_YEAR(CreatedDate ) = 2016 AND (createdById = :loggedInUserId OR id in :XSellIdList) ORDER BY CreatedDate desc];
                
                isSuperUser = false;
            } else {
                applicationAccess = false;
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
            
            p = new Pagereference('/apex/XS_Opportunitydummy?tab=Home');
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
        
        PageReference p = new PageReference('/apex/XS_Opportunitydummy_NewRecordP?tab=Home');
        p.setRedirect(true);
        return p; 
    }
    
    /**********************************************************************************
    * EDIT
    *
    ***********************************************************************************/
    public pageReference editLine(){
        
        PageReference p = new PageReference('/apex/XS_OpportunitydummyEdit?id=' + crossSellId);
        p.setRedirect(true);
        return p; 
        
    }
    
    public void export(){
        if( xList.isEmpty() )
            return;
        
        /*List<Cross_Sell__c> cList = [SELECT Name, Client_Additional_Details__c,
                                     Client_Name__c, Client_Type_Industry__c,
                                     Closed_Date__c, Deal_Product_Type__c,
                                     Decision__c, Declaration__c,
                                     Division_Dsc_Org__c, Estimated_Timing_of_Transaction__c,
                                     First_time_business__c, Intra_ISG__c,
                                     Level_Dsc_Job__c, Manager__c,
                                     MNPI__c, MSID__c, Nominee__r.Name,
                                     Nominee_Division__c, Nominee_Group__c,
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
                if(w.clientName <> null)
                    if(w.clientName.contains(','))
                        w.clientName = '"' + w.clientName + '"';
            }
            
            if(cs.Client_Type_Industry__c != null) {
                w.clientTypeIndustry = cs.Client_Type_Industry__c;
                if(w.clientTypeIndustry <> null)
                    if(w.clientTypeIndustry.contains(','))
                        w.clientTypeIndustry = '"'+w.clientTypeIndustry +'"';
            }
            
            /*if(cs.Closed_Date__c != null)
                w.closedDate = cs.Closed_Date__c <> NULL ? cs.Closed_Date__c.format() : NULL;*/
            
            if(cs.Deal_Product_Type__c != null) {
                w.dealProductType = cs.Deal_Product_Type__c;
                if(w.dealProductType <> null)
                    if(w.dealProductType.contains(','))
                        w.dealProductType = '"'+w.dealProductType +'"';
            }
            
            if(cs.Decision__c != null)
                w.decision = cs.Decision__c;
                
            if(cs.Declaration__c != null)
                w.declaration = cs.Declaration__c <> NULL ? String.valueOf(cs.Declaration__c) : NULL;
                
            if(cs.Estimated_Timing_of_Transaction__c != null)
                w.estimatedTimingofTransaction = cs.Estimated_Timing_of_Transaction__c <> NULL ? cs.Estimated_Timing_of_Transaction__c.format() : NULL;
                
            if(cs.First_time_business__c != null)
                w.firstTimeBusiness = cs.First_time_business__c <> NULL ? String.valueOf(cs.First_time_business__c) : NULL;
                
            if(cs.Intra_ISG__c != null)
                w.intraISG = cs.Intra_ISG__c <> NULL ? String.valueOf(cs.Intra_ISG__c) : NULL;
                
            if(cs.Nominee_Manager_s_Full_name__c != null)
                w.manager = cs.Nominee_Manager_s_Full_name__c;
                
            if(cs.MNPI__c != null)
                w.mNPI = cs.MNPI__c <> NULL ? String.valueOf(cs.MNPI__c) : NULL;
                
            if(cs.Nominee_MSID__c != null)
                w.mSID = cs.Nominee_MSID__c;
                
            if(cs.Nominee__r.Name != null)
                w.nominee = cs.Nominee__r.Name;
                
            if(cs.Nominee_Division__c != null)
                w.nomineeDivision = cs.Nominee_Division__c;
            /*
            if(cs.Nominee_Region__c != null) {    
                w.nomineeRegion = cs.Nominee_Region__c;
                if(w.nomineeRegion <> null)
                    if(w.nomineeRegion.contains(','))
                        w.nomineeRegion = '"'+w.nomineeRegion +'"';
            }
            */
            if(cs.Nominee_Title__c != null) {
                w.nomineeTitle = cs.Nominee_Title__c;
                if(w.nomineeTitle <> null)
                    if(w.nomineeTitle.contains(','))
                        w.nomineeTitle = '"'+w.nomineeTitle +'"'; 
            }
            
            if(cs.One_time_fee_vs_Ongoing__c != null)
                w.onetimefeevsOngoing = cs.One_time_fee_vs_Ongoing__c;
                
            if(cs.Quarter__c != null)
                w.quarter = cs.Quarter__c;
            
            if(cs.Revenues_000s__c != null) {
                w.revenues000s = cs.Revenues_000s__c;
                if(w.revenues000s<> null)
                    if(w.revenues000s.contains(','))
                        w.revenues000s = '"'+w.revenues000s+'"'; 
            }
            
            if(cs.Size_of_Transaction__c != null) {
                w.sizeofTransaction = cs.Size_of_Transaction__c;
                if(isPublicDelegateUser)
                    w.sizeofTransaction = isPublicDelegateUser ? 'RESTRICTED' : NULL;
                if(w.sizeofTransaction <> null)
                    if(w.sizeofTransaction.contains(','))
                        w.sizeofTransaction = '"'+w.sizeofTransaction +'"';
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
                w.whysignificant = cs.Why_significant__c;
                if(w.whysignificant <> null)
                    if(w.whysignificant.contains(','))
                        w.whysignificant = '"'+w.whysignificant +'"'; 
            } 
            
            if(cs.Other_Comments__c != null) {   
                w.otherComments = cs.Other_Comments__c;
                if(w.otherComments <> null)
                    if(w.otherComments.contains(',') || w.otherComments.contains('\n'))
                        w.otherComments = '"'+w.otherComments +'"';
            }
            
            if(cs.Notes_By_Delegates__c != null) {
                w.notesByDelegates = cs.Notes_By_Delegates__c;
                if(w.notesByDelegates<> null)
                    if(w.notesByDelegates.contains(';'))
                        w.notesByDelegates = '"'+w.notesByDelegates+'"';
            }
        
            lstwrapper.add(w);
        }
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
    }
    
}