// Adding @isTest annotation as this class is not used

@isTest
public with sharing class XS_OpportunityGP {
    
    
    public List<Cross_Sell__c> xList {get;set;}
    public string crossSellId {get;set;}
    public Boolean isSuperUser{get;set;}
    
    public List<Employee__c> beneficiaryList{get;set;}
    public Cross_Sell__c x {get;set;}
    
    
    /**********************************************************************************
     *CONSTRUCTOR 
     *
     **********************************************************************************/
    public XS_OpportunityGP(){
        
        /*beneficiaryList = [SELECT Id, Name, Emp_ID__c FROM Employee__c LIMIT 10];
        for(Employee__C emp : beneficiaryList) {
            Cross_Sell__c.Beneficiary_Full_Name__c = emp.Name;
        }*/
        
        loadOpps();
    }
    
    /************************************************************************************
     *LOAD OPPS 
     *
     ************************************************************************************/
    public void loadOpps(){
        
        xList = new List<Cross_Sell__c>();
        list<Id> XSellIdList = new list<Id>();
        Id loggedInUserId = UserInfo.getUserId();
        Id loggedInProfileId = UserInfo.getProfileId();
        
        list<GroupMember> GMList = [select GroupId from GroupMember where UserorGroupId = :UserInfo.getUserId()];
        list<Cross_Sell__c> XSellNomineeList = [select Id from Cross_Sell__c where Nominee__r.User__r.Id = :loggedInUserId];
        list<Id> GMIdList = new list<Id>();
        if(GMList != null)
        {
            for(GroupMember GM:GMList)
                GMIdList.add(GM.GroupId);
        }
        list<Cross_Sell__Share> XSellShareList = [select ParentId from Cross_Sell__Share where
                                                  UserorGroupId in :GMIdList or UserorGroupId = :loggedInUserId];
        if(XSellShareList != null)
        {
            for(Cross_Sell__Share XS:XSellShareList)
                XSellIdList.add(XS.ParentId);
        }
        
        if(XSellNomineeList != null)
        {
            for(Cross_Sell__c XS:XSellNomineeList)
                XSellIdList.add(XS.Id);
        }
        
        
        Profile loggedInProfile = [select Name from Profile where id =:loggedInProfileId];
        
        
        if(loggedInProfile.Name == 'XS Super Users') {
            isSuperUser = true;
            
            xList = [Select c.Why_significant__c,c.Nominee_Region__c,c.Estimated_Timing_of_Transaction__c,
                     c.Deal_Product_Type__c,c.Client_Additional_Details__c,c.Submitted_by__c,
                     c.Beneficiary_Region__c,c.Decision__c,c.Select_Exact_Period__c,c.Nominee_Division__c,
                     c.Nominee_Manager_s_Full_name__c, c.Transaction_Status__c, c.Transaction_Product_Type__c,
                     c.Stage__c, c.Size_of_Transaction__c, c.Revenues_000s__c, c.OwnerId, c.Other_Comments__c,
                     c.One_time_fee_vs_Ongoing__c, c.Nominee__c, c.Nominee__r.name, c.Name, c.Manager__c, c.MNPI__c,
                     c.Level_Dsc_Job__c, c.LastModifiedDate, c.Intra_ISG__c, c.Id, c.First_time_business__c,
                     c.Division_Dsc_Org__c, c.Declaration__c, c.CreatedDate, c.CreatedById, c.Cost_Center_Desc__c,
                     c.Closed_Date__c, c.Client_Type_Industry__c, c.Client_Name__c, c.CC_Region_Org__c 
                     ,  c.Submission_Date__c, c.LastModifiedById, c.MSID__c,
                     c.Nominee_Title__c, c.Beneficiary_MSID__c, c.Beneficiary_Full_Name__c, c.Beneficiary_Title__c,Notes_By_Delegates__c,Beneficiary_Full_Name_s__c From Cross_Sell__c c];
        } else if(loggedInProfile.Name == 'XS Normal Users'
                        || loggedInprofile.Name == 'XS Delegate Public Side Users') {
            xList = [Select c.Why_significant__c,c.Nominee_Region__c,c.Estimated_Timing_of_Transaction__c,
                     c.Decision__c,c.Deal_Product_Type__c,c.Client_Additional_Details__c,
                     c.Beneficiary_Region__c,c.Select_Exact_Period__c,c.Nominee_Division__c,
                     c.Nominee_Manager_s_Full_name__c, c.Transaction_Status__c, c.Transaction_Product_Type__c,
                     c.Stage__c,  c.Revenues_000s__c, c.OwnerId, c.Other_Comments__c, c.One_time_fee_vs_Ongoing__c,
                     c.Nominee__c, c.Nominee__r.name, c.Name, c.Manager__c, c.Submitted_by__c,c.MNPI__c,
                     c.Size_of_Transaction__c,c.Client_Type_Industry__c,c.Level_Dsc_Job__c, c.LastModifiedDate,
                     c.Intra_ISG__c, c.Id, c.First_time_business__c, c.Division_Dsc_Org__c, c.Declaration__c,
                     c.CreatedDate, c.CreatedById, c.Cost_Center_Desc__c, c.Closed_Date__c,  c.Client_Name__c,
                     c.CC_Region_Org__c, c.Submission_Date__c, c.LastModifiedById,
                     c.MSID__c, c.Nominee_Title__c, c.Beneficiary_MSID__c, c.Beneficiary_Full_Name__c, c.Beneficiary_Title__c,Notes_By_Delegates__c,Beneficiary_Full_Name_s__c From Cross_Sell__c c
                     where createdById = :UserInfo.getUserId() OR id in :XSellIdList];
            
            isSuperUser = false;
        } else {
            isSuperUser = true;
            xList = [Select c.Why_significant__c,c.Decision__c,c.Nominee_Region__c,c.Estimated_Timing_of_Transaction__c,
                     c.Submitted_by__c,c.Size_of_Transaction__c,c.Deal_Product_Type__c,c.Client_Additional_Details__c,
                     c.Beneficiary_Region__c,c.Select_Exact_Period__c,c.Nominee_Division__c,
                     c.Nominee_Manager_s_Full_name__c, c.Transaction_Status__c, c.Transaction_Product_Type__c,
                     c.Stage__c,  c.Revenues_000s__c, c.OwnerId, c.Other_Comments__c, c.One_time_fee_vs_Ongoing__c,
                     c.Nominee__c, c.Nominee__r.name, c.Name, c.Manager__c, c.MNPI__c, c.Level_Dsc_Job__c,
                     c.LastModifiedDate, c.Intra_ISG__c, c.Id, c.First_time_business__c, c.Division_Dsc_Org__c,
                     c.Declaration__c, c.CreatedDate, c.CreatedById, c.Cost_Center_Desc__c, c.Closed_Date__c,
                     c.Client_Type_Industry__c, c.Client_Name__c, c.CC_Region_Org__c,
                     c.Submission_Date__c, c.LastModifiedById, c.MSID__c,
                     c.Nominee_Title__c, c.Beneficiary_MSID__c, c.Beneficiary_Full_Name__c, c.Beneficiary_Title__c,Notes_By_Delegates__c,Beneficiary_Full_Name_s__c From Cross_Sell__c c];
        }
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
        
        PageReference p = new PageReference('/apex/XS_Opportunity_NewRecordGP');
        p.setRedirect(true);
        return p; 
    }
    
    /**********************************************************************************
    * EDIT 
    *
    ***********************************************************************************/
    public pageReference editLine(){
        
        PageReference p = new PageReference('/apex/xs_opportunityEdit?id=' + crossSellId);
        p.setRedirect(true);
        return p; 
        
    }        
}