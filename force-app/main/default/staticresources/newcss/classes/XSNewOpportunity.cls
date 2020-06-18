public with sharing class XSNewOpportunity {
    
    public Cross_Sell__c XSellObj;
    public String nominee {get;set;}
    public String XS_OtherIndivs{get;set;}
    public ApexPages.StandardController controller{get;set;}
    
    public list<Employee__c> nomineelist{get;set;}
    public boolean nomineePopup{get;set;}
    public Boolean isSuperUser{get;set;}
    
    public string RequesteeNominee{get;set;}
    public String individualName{get; set;}
    public string individualName1{get;set;}
    public string individualName2{get;set;}
    public string calledFrom{get;set;}
    private final ApexPages.StandardController ctrlr;
    
    public PermissionSetAssignment PSASuperUser;
    public List<PermissionSetAssignment> PSASuperUserList;
    
    public String nomineeName { get; set;} // Name of the nominee on the main page
    public String nomineeName1 { get; set;}
    public String nomineeName2 { get; set;}
    public String nomineeDivision { get; set;} // Division of the nominee on the main page
    public String nomineeTitle { get; set;} // Title of the nominee on the main page
    public String nomineeRegion { get; set;} // Region of the nominee on the main page
    public String nomineeMSID { get; set;} // MSID of the nominee on the main page
    public String nomineeManager { get; set;} // Manager of the nominee on the main page
    public String nomineeGroup { get; set;} // Group of the nominee on the main page
    
    public String otherIndivName{get; set;}
    public String otherIndivName1{get; set;}
    public String otherIndivName2{get; set;}
    
    
    public User user{get;set;}
    public String userName{get;set;}
    
    public Boolean mnpi {get;set;}
    public Boolean isg {get;set;}
    public Boolean ftb {get;set;}
    public Boolean dec {get;set;}
    
    public Boolean nomineeErrorMessage{get;set;}
    public Boolean otherCommentsErrorMessage{get;set;}
    public Boolean significantErrorMessage{get;set;}
    
    public Boolean pageErrorMessage{get;set;}
    public String selFTBoption {get;set;}
    
    public String otherDivsInvolved {get;set;}
    public String otherIndivsInvolved {get;set;}
    public String selMNPIoption {get;set;}
    public String OtherIndividualsInvolved {get;set;}
    
    public String xSellStatus{get;set;}
  
    
    public XSNewOpportunity(ApexPages.StandardController controller) {
      
        ctrlr = controller;
        
        mnpi = false;
        isg = false;
        ftb = false;
        dec = false;
        
        nomineeName = '';
        nomineeName1 = '';
        nomineeName2 = '';
        
        otherIndivName = '';
        otherIndivName1 = '';
        otherIndivName2 = '';
        
        try{
        
               xSellStatus = ApexPages.currentPage().getParameters().get('status');
        
        
        
            Id loggedInProfileId = UserInfo.getProfileId();
            Id loggedInUserId = UserInfo.getUserId();
            
            String parentId = ApexPages.currentPage().getParameters().get('parentRecordId');
            XSellObj = (Cross_Sell__c) controller.getRecord();
            
            Cross_Sell__c parentXSell;
            system.debug('parent Id *******' + parentId);
            if(parentId != null) {
                system.debug('parent Id *******' + parentId);
                
                parentXSell = [SELECT id, Nominee__r.Name, Client_Name__c, Stage__c,  Nominee__c, Nominee_Group__c,
                             Nominee_Manager_s_Full_name__c, Nominee_Division__c,Nominee_MSID__c,Nominee_Grp__c, 
                             Nominee_Region__c,Nominee_Title__c,Revenues_000s__c,Client_Type_Industry__c,
                             Client_Additional_Details__c, Deal_Product_Type__c, Transaction_Status__c,
                             Estimated_Timing_of_Transaction__c, One_time_fee_vs_Ongoing__c, Why_significant__c,MNPI_non_boolean__c,
                             Other_Comments__c, Intra_ISG__c, MNPI__c, First_time_business__c,Beneficiary_Division__c, Other_individuals_involved__r.Name,
                             Nominee__r.emp_id__c, Size_of_Transaction__c, Other_individuals_involved__c,Other_individuals_involved1__c,Other_individuals_involved2__c,
                             Other_individuals_involved1__r.Name,Other_individuals_involved2__r.Name,Nominee__r.Manager__r.name,
                             Other_Divisions_Involved1__c,Other_Divisions_Involved2__c,Trade_ID__c,Job_Number__c
                             FROM Cross_Sell__c WHERE id = :parentId];
            }
            
            if(parentXSell != null) {
                // XSellObj.id = parentXSell.id;
                XSellObj.Nominee__c = parentXSell.Nominee__c;
                
                XSellObj.Client_Name__c = parentXSell.Client_Name__c;
                XSellObj.Client_Type_Industry__c = parentXSell.Client_Type_Industry__c;
                XSellObj.Client_Additional_Details__c = parentXSell.Client_Additional_Details__c;
                XSellObj.Deal_Product_Type__c = parentXSell.Deal_Product_Type__c;
                XSellObj.Transaction_Status__c = parentXSell.Transaction_Status__c;
                XSellObj.Estimated_Timing_of_Transaction__c = parentXSell.Estimated_Timing_of_Transaction__c;
                XSellObj.One_time_fee_vs_Ongoing__c = parentXSell.One_time_fee_vs_Ongoing__c;
                XSellObj.Why_significant__c = parentXSell.Why_significant__c;
                XSellObj.Other_Comments__c = parentXSell.Other_Comments__c;
                XSellObj.Intra_ISG__c = parentXSell.Intra_ISG__c;
                XSellObj.First_time_business__c = parentXSell.First_time_business__c;
                XSellObj.MNPI__c = parentXSell.MNPI__c;
                XSellObj.Stage__c = 'Draft';
                XSellObj.Size_of_Transaction__c = parentXSell.Size_of_Transaction__c;
                XSellObj.Revenues_000s__c = parentXSell.Revenues_000s__c;
                XSellObj.Other_individuals_involved1__c =parentXSell.Other_individuals_involved1__c ;
                XSellObj.Other_individuals_involved2__c  =parentXSell.Other_individuals_involved2__c  ;
                XSellObj.Other_individuals_involved__c=parentXSell.Other_individuals_involved__c;
                XSellObj.Trade_ID__c =parentXSell.Trade_ID__c ;
                XSellObj.Job_Number__c =parentXSell.Job_Number__c ;
                XSellObj.Beneficiary_Division__c=parentXSell.Beneficiary_Division__c;
                XSellObj.Other_Divisions_Involved1__c =parentXSell.Other_Divisions_Involved1__c ;
                XSellObj.Other_Divisions_Involved2__c =parentXSell.Other_Divisions_Involved2__c ;
                
                
                nomineeName = parentXSell.Nominee__r.name;
                nomineeDivision = parentXSell.Nominee_Division__c;
                nomineeTitle = parentXSell.Nominee_Title__c;
                nomineeRegion = parentXSell.Nominee_Region__c;
                nomineeManager = parentXSell.Nominee__r.Manager__r.name;
                nomineeGroup = parentXSell.Nominee_Group__c;
                
                otherIndivName = parentXSell.Other_individuals_involved__r.Name;
                otherIndivName1 = parentXSell.Other_individuals_involved1__r.Name;
                otherIndivName2 = parentXSell.Other_individuals_involved2__r.Name;
               
                if(parentXSell.Nominee_MSID__c != null && parentXSell.Nominee_MSID__c != '') {
                    nomineeMSID = parentXSell.Nominee_MSID__c;
                } else {
                    nomineeMSID = parentXSell.Nominee__r.emp_id__c;
                }
                
                XSellObj.Other_indiv_involved__c = parentXSell.Other_individuals_involved__r.Name;
                //XSellObj.Other_individuals_involved__c = parentXSell.Other_indiv_involved__c;
                XSellObj.Beneficiary_Division__c = parentXSell.Beneficiary_Division__c;
               
                
            }
            
            user = [SELECT id, Name, Emp_Id__c, firstname, lastname FROM USER WHERE Id = :loggedInUserId];
            userName = user.Name;
            // Cross_Sell__c.Submitted_by__c = user.firstname + ' ' + user.lastname;
            
            isSuperUser = false;
            List<PermissionSet> PSSuperUserList = [select Id from PermissionSet where name = 'XS_Super_User'];
            
            if(PSSuperUserList.size() > 0)
                PSASuperUserList= [select Id from PermissionSetAssignment where AssigneeId = :loggedInUserId
                                   and PermissionSetId = :PSSuperUserList.get(0).Id]; 
            
            Profile loggedInProfile = [select Name from Profile where id =:loggedInProfileId];
            if(PSASuperUserList.size() > 0)
                PSASuperUser = PSASuperUserList.get(0);
            
            if(PSASuperUser != null || loggedInProfile.Name == 'System Administrator') {
                isSuperUser = true;
            }        
            else {
                isSuperUser = false;
            }
            
            NomineeList= [select Id, Name, first_name__c, Last_name__c,Business_Title__c, Division_Dsc_Org__c,Dept_Dsc_Org__c,
                              citizenship_country__c, Job_Title_Dsc_Job__c, Manager__r.Name, Job_Region_Code__c,
                               emp_id__c, Division_Org__c FROM Employee__c  WHERE User__c != null limit 1];

            /*
            system.debug('clone val is: '+ApexPages.CurrentPage().getParameters().get('clone'));
            if(!String.isEmpty(ApexPages.CurrentPage().getParameters().get('clone'))){
                xSellObj = new Cross_Sell__c( Id= ApexPages.CurrentPage().getParameters().get('clone') );
                system.debug('inside if.');
            }else
                XSellObj = (Cross_Sell__c) controller.getRecord(); */
            
            if(XSellObj.id != null) {
                system.debug('inside if again...');
                XSellObj = [Select  c.Id, c.Why_significant__c, nominee__r.name, c.Transaction_Status__c,
                        c.Transaction_Product_Type__c, c.Stage__c, c.Size_of_Transaction__c, c.Revenues_000s__c,
                        c.Other_Comments__c, c.One_time_fee_vs_Ongoing__c, c.Nominee__c, c.Name, c.MNPI__c,
                        c.Intra_ISG__c, c.First_time_business__c, c.Division_Dsc_Org__c, c.Declaration__c,
                        c.Closed_Date__c, c.Client_Type_Industry__c, c.Client_Name__c, Quarter__c, MNPI_non_boolean__c,
                        c.Nominee_Manager_s_Full_name__c, c.Nominee__r.emp_id__c, c.Nominee_Division__c,
                        c.Nominee_Title__c, c.Nominee_Region__c From Cross_Sell__c c where id = :XSellObj.id];
                system.debug('the sobject is : '+xsellobj);
            }
            
            this.controller = new ApexPages.StandardController(XSellObj);
            // system.debug('controller ****' + this.controller);
            
            pageErrorMessage = false;
            
            XSellObj.First_time_business__c = false;
        } Catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        
    }
    
    public String selFTBoption(){       
        return selFTBoption;
    }
    
    public String selMNPIoption(){       
        return selMNPIoption;
    }
    
    public List<SelectOption> getpicklistVals(){
        List<SelectOption> ftbOpts = new List<SelectOption>();
        ftbOpts.add(new SelectOption('true','Yes'));
        ftbOpts.add(new SelectOption('false','No'));
        
        return ftbOpts;
    }
    
     public List<SelectOption> getotherDivspicklist(){
        List<SelectOption> otherDivs = new List<SelectOption>();
        otherDivs .add(new SelectOption('IBD','IBD'));
        otherDivs .add(new SelectOption('Institutional Equity Division','Institutional Equity Division'));
        otherDivs .add(new SelectOption('Fixed Income & Commodities','Fixed Income & Commodities'));
        otherDivs .add(new SelectOption('GCM - Joint Venture','GCM - Joint Venture'));
        otherDivs .add(new SelectOption('Strategic Relationship Management','Strategic Relationship Management'));
        otherDivs .add(new SelectOption('Bank Resource Management','Bank Resource Management'));
        
        return otherDivs;
    }
    
    public List<SelectOption> getotherDivspicklistOptional(){
        List<SelectOption> otherDivs = new List<SelectOption>();
        otherDivs .add(new SelectOption('','--None--'));
        otherDivs .add(new SelectOption('IBD','IBD'));
        otherDivs .add(new SelectOption('Institutional Equity Division','Institutional Equity Division'));
        otherDivs .add(new SelectOption('Fixed Income & Commodities','Fixed Income & Commodities'));
        otherDivs .add(new SelectOption('GCM - Joint Venture','GCM - Joint Venture'));
        otherDivs .add(new SelectOption('Strategic Relationship Management','Strategic Relationship Management'));
        otherDivs .add(new SelectOption('Bank Resource Management','Bank Resource Management'));
        
        return otherDivs;
    }
    
    
    public List<SelectOption> getmnpipicklistVals(){
        List<SelectOption> mnpiOpts = new List<SelectOption>();
        mnpiOpts.add(new SelectOption('true','Yes'));
        mnpiOpts.add(new SelectOption('false','No'));
        
        return mnpiOpts;
    }
    
    public PageReference setNomineeName() {
        return null;
    }
    
    public PageReference SaveXSell() {
        try{
            system.debug('@@@@@@>'+ XSellObj);
            system.debug('@@@@@@>'+ controller);
            //XSellObj = (Cross_Sell__c) controller.getRecord();
            
            system.debug('#######>'+ XSellObj);
            //if(XSellObj.Estimated_Timing_of_Transaction__c == null 
            //        || XSellObj.Estimated_Timing_of_Transaction__c.format() == '')
            //    XSellObj.Estimated_Timing_of_Transaction__c = system.today();
            
            /*
            if(validateForm()){
                return null;
            } 
            */
            insert XSellObj;
          //  controller.Save();
            
            /*
            Cross_Sell_Parties_Involved__c xsOtheParties = new Cross_Sell_Parties_Involved__c();
            xsOtheParties . Other_Divisions_Involved__c = otherDivsInvolved;
            xsOtheParties . Other_Individuals_Involved__c = otherIndivsInvolved;
            insert xsOtheParties;
            */
        } Catch(Exception e){
            system.debug('Error---@@@@@@>'+ e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the XSell');
            ApexPages.addMessage(myMsg);
            pageErrorMessage = true;
            return null;
        }
        
        PageReference p = new PageReference('/apex/XS_OpportunityEditP?id=' + XSellObj.Id + '&tab=Home&status=Draft');
        p.setRedirect(true);
        return p;
    }
    
    public PageReference SubmitXSell() {
       
       
       XSellObj.Stage__c = 'Submitted';
        try{
        
            insert XSellObj;
         
        } Catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while submitting the XSell');
            ApexPages.addMessage(myMsg);
            pageErrorMessage = true;
            return null;
        }
        
        PageReference p = new PageReference('/apex/XS_OpportunityEditP?id=' + XSellObj.Id + '&tab=Home&status=Submit');
        p.setRedirect(true);
        return p;
    }
    

    
    
    public PageReference CancelXSell() {
        
        PageReference p = new PageReference('/apex/XS_Opportunity?tab=Home');
        p.setRedirect(true);
        
        return p;
        
    }
    
    public pagereference closewindow() {
        nomineeList.clear();
        nomineePopup = false;
        return null;  
        
    }
    
    public PageReference searchNominee() {
        
        nomineePopup = true;
        System.debug('nomineeName:' + nomineeName + 'asdf');
        if(nomineeName != null && nomineeName != '') {
            RequesteeNominee = nomineeName;
            System.debug('###########' + nomineeName);
            filterNominee();
        }
        
        return null; 
        
    }
    
    public PageReference filterEmployee() {
        
        if(NomineeList != null){
        NomineeList.clear();
        }
        
        if(individualName.split('').size() <= 2 && individualName != '')
            return NULL;
        
        if(individualName1.split('').size() <= 2 && individualName1 != '')
            return NULL;
        
        if(individualName2.split('').size() <= 2 && individualName2 != '')
            return NULL;
        
            
        String query =''; 
        if(individualName!= '' && calledFrom == 'firstIndiv'){
        query = 'SELECT Id, Name, First_Name__c, Last_Name__c,Business_Title__c,citizenship_country__c, Job_Title_Dsc_Job__c,' +
            ' Manager__r.Name, Job_Region_Code__c, emp_id__c, Division_Org__c, Division_Dsc_Org__c, Dept_Dsc_Org__c FROM ' +
            ' Employee__c WHERE (Name like \'%' + individualName + '%\' or Emp_Id__c like \'%' + individualName +
            '%\') AND Status__c=\'Active\' AND User__c != null AND email__c != \'' + UserInfo.getUserEmail() + '\' LIMIT 50';
        }
        
        if(individualName1 != '' && calledFrom == 'secondIndiv'){
        system.debug('inside 2nd if');
        query = 'SELECT Id, Name, First_Name__c, Last_Name__c,Business_Title__c,citizenship_country__c, Job_Title_Dsc_Job__c,' +
            ' Manager__r.Name, Job_Region_Code__c, emp_id__c, Division_Org__c, Division_Dsc_Org__c, Dept_Dsc_Org__c FROM ' +
            ' Employee__c WHERE (Name like \'%' + individualName1 + '%\' or Emp_Id__c like \'%' + individualName1 +
            '%\') AND Status__c=\'Active\' AND User__c != null AND email__c != \'' + UserInfo.getUserEmail() + '\' LIMIT 50';
            
            system.debug('inside 2nd if1'+query);
        }
       if(individualName2 != '' && calledFrom == 'thirdIndiv'){
        query = 'SELECT Id, Name, First_Name__c, Last_Name__c,Business_Title__c,citizenship_country__c, Job_Title_Dsc_Job__c,' +
            ' Manager__r.Name, Job_Region_Code__c, emp_id__c, Division_Org__c, Division_Dsc_Org__c, Dept_Dsc_Org__c FROM ' +
            ' Employee__c WHERE (Name like \'%' + individualName2 + '%\' or Emp_Id__c like \'%' + individualName2 +
            '%\') AND Status__c=\'Active\' AND User__c != null AND email__c != \'' + UserInfo.getUserEmail() + '\' LIMIT 50';
        }
        
        try{
            NomineeList = Database.query(query);
            system.debug('query!!!'+query);
            system.debug('nomineelist!!!'+NomineeList );
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        return null;
    }
    
    public PageReference filterNominee() {
        
        if(NomineeList!= null){
        NomineeList.clear();
        }
        
        
        if(RequesteeNominee.split('').size() <= 2)
            return NULL;
      /* Jira ID : XSELLFORCE-10 */  
     /*   string query = 'SELECT Id, Name, First_Name__c, Last_Name__c,Business_Title__c,citizenship_country__c, Job_Title_Dsc_Job__c,' +
            ' Manager__r.Name, Job_Region_Code__c, emp_id__c, Division_Org__c, Division_Dsc_Org__c, Dept_Dsc_Org__c FROM ' +
            ' Employee__c WHERE (Name like \'%' + RequesteeNominee + '%\' or Emp_Id__c like \'%' + RequesteeNominee +
            '%\') AND Status__c=\'Active\' AND User__c != null AND email__c != \'' + UserInfo.getUserEmail() + '\' LIMIT 10';
      */ 
     
       string query = 'SELECT Id, Name, First_Name__c, Last_Name__c,Business_Title__c,citizenship_country__c, Job_Title_Dsc_Job__c,' +
            ' Manager__r.Name, Job_Region_Code__c, emp_id__c, Division_Org__c, Division_Dsc_Org__c, Dept_Dsc_Org__c FROM ' +
            ' Employee__c WHERE (Name like \'%' + RequesteeNominee + '%\' or Emp_Id__c like \'%' + RequesteeNominee +
            '%\') AND Status__c=\'Active\' AND User__c != null LIMIT 50';
           
         
        try{
            NomineeList = Database.query(query);
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        return null;
    }
    
    /******************************************************************************************
    * DECLARATION SEt   
    *
    *******************************************************************************************/
    public PageReference decSet() {
        
        if (dec == true) {
            dec = false;
            XSellObj.Declaration__c = false;
        } else {
            dec = true;
            XSellObj.Declaration__c = true;
        }
        return null;
    }
    
    /******************************************************************************************
    * FTB SEt   
    *
    *******************************************************************************************/
    public PageReference ftbSet() {
        
        if (ftb == true) {
            ftb = false;
            XSellObj.First_time_business__c = false;
        } else {
            ftb = true;
            XSellObj.First_time_business__c = true;
        }
        return null;
    }
    
    /******************************************************************************************
    * MNPI SEt   
    *
    *******************************************************************************************/
    public PageReference mnpiSet() {
        
        if (mnpi == true) {
            mnpi = false;
            XSellObj.MNPI__c = false;
        } else {
            mnpi = true;
            XSellObj.MNPI__c = true;
        }
        return null;
    }
    
    /******************************************************************************************
    * ISG   
    *
    *******************************************************************************************/
    public PageReference isgSet() {
        
        if (isg == true) {
            isg = false;
            XSellObj.Intra_ISG__c = false;
        } else {
            isg = true;
            XSellObj.Intra_ISG__c = true;
        }
        return null;
    }
    
    // validate form before submission
    public Boolean validateForm() {
    
        Boolean validationError = false;
        nomineeErrorMessage = false;
        
        try {
            if(nomineeName == null || nomineeName == '') {
                nomineeErrorMessage = true;
                validationError = true;
            }
                
            if(XSellObj.Client_Name__c == null || XSellObj.Client_Name__c == '') {
                XSellObj.Client_Name__c.addError('You must enter a value');
                validationError = true;
            }
                
            if(XSellObj.Client_Type_Industry__c == null || XSellObj.Client_Type_Industry__c == '') {
                XSellObj.Client_Type_Industry__c.addError('You must enter a value');
                validationError = true;
            }
            
            if(XSellObj.Revenues_000s__c == null) {
                XSellObj.Revenues_000s__c.addError('You must enter a value');
                validationError = true;
            }
                
            if(XSellObj.Size_of_Transaction__c == null) {
                XSellObj.Size_of_Transaction__c.addError('You must enter a value');
                validationError = true;
            }
            
            if(XSellObj.Other_Comments__c != null && XSellObj.Other_Comments__c.length() > 500) {
                otherCommentsErrorMessage = true;
                validationError = true;
            }
            
            if(XSellObj.Why_significant__c != null && XSellObj.Why_significant__c.length() > 500) {
                significantErrorMessage = true;
                validationError = true;
            }
        } catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return validationError;
    }
    
    /*
    public PageReference assignNominee() {
        System.debug('Nominee Id : ' + nomineeId);
        XSellObj.Nominee__c = nomineeId; // [Select Id, Name FROM Employee__C where Emp_Id__c = :nomineeId].id; 
        
        nomineePopup = false;
        
        return null;
    }
    */
}