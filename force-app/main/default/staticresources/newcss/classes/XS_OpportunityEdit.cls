/******************************************************************************************
* Cross Sell Edit Controller
*
* ChangeLog:
*
*   9/29/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public with sharing class XS_OpportunityEdit { 
    
    public Cross_Sell__c x {get;set;} 
    public String nominee {get;set;}
    public string requesteeNominee{get;set;}
    public String selection{get;set;}
    public String selected{get;set;}
    public String QuarterFieldValue{get;set;}
    
    public String mnpi {get;set;}
    public String isg {get;set;}
    public String ftb {get;set;}
    public String dec {get;set;}
    public list<Employee__c> nomineelist{get;set;}
    public boolean nomineePopup{get;set;}
    
    public boolean submitStatus{get;set;}
    public String nomineeName2{get;set;}
    public String nomineeId2{get;set;}
    public boolean notesPopup{get;set;}
    public boolean sharePopup{get;set;}   
    public String Notes1{get;set;}
    public String Notes{get;set;}
    public String crossSellOptyId {get;set;}
    public boolean isPrivateDelegate {get;set;}
    public boolean isCreatedLogin{get;set;}
    public boolean isSubmittedLogin{get;set;}

    // Added by Avinash Munaga
    public Boolean nomineeErrorMessage{get;set;}
    public Boolean otherCommentsErrorMessage{get;set;}
    public Boolean significantErrorMessage{get;set;}
    
    public Boolean isSuperUser{get;set;}
    public Boolean isSharedUser{get;set;}
    
    public String toDelete{get;set;}
    public String Share{get;set;}
    
    public PermissionSetAssignment psaSuperUser;
    public list<PermissionSetAssignment> psaSuperUserList;
    public list<PermissionSetAssignment> psaPrivateDelegateUserList ;
    
    public List<SelectOption> quarterDescribe{get;set;} // = new List<SelectOption>();
    
    public String xSellStatus{get;set;}
    public Boolean isDivisionMember{get;set;}
    public Boolean isDivisionMember1{get;set;}
    public Boolean isDivisionMember2{get;set;}
    public Boolean makeVisible{get;set;}
    public Boolean apprCommentErrorMsg{get;set;}
    /****************************
    * STANDARD CONTROLLER       
    *
    ****************************/
    public XS_OpportunityEdit(ApexPages.StandardController controller) {
    
        // Added by Avinash Munaga on 26/11/2015
        // get id of logged in user
        Id loggedInUserId = UserInfo.getUserId();
        String loggedInUserFullName = UserInfo.getName();
        /*String stat = ApexPages.CurrentPage().getParameters().get('status');
            if(stat=='Submit')
        {
             submitStatus = true;
        }*/
                
        isSuperUser = false; // assign variable value to false
        isCreatedLogin = false; // assign variable value to false
        isSubmittedLogin = false; // assign variable value to false
        isSharedUser = false; //assign variable value to false
        isDivisionMember = false;
        isDivisionMember1 = false;
        isDivisionMember2 = false;
        
        
        Profile loggedInProfile;
        List<PermissionSet> psSuperUserList;
        List<PermissionSet> psPrivateDelegateUserList;
        try{
            xSellStatus = ApexPages.currentPage().getParameters().get('status');
            
            // get profile details of the logged in user
            loggedInProfile = [select Name from Profile where id = :UserInfo.getProfileId()];
            
            // get list of permission sets to a list
            psSuperUserList = [select Id from PermissionSet where name IN( 'XS_Super_User')];
                         
            psPrivateDelegateUserList =
                     [select Id from PermissionSet where name IN( 'XS_Private_Delegates','XS_Private_Normal_User')];
        
            // iterate through the permission set list    
            if(psSuperUserList.size() > 0) {
                // assign permission set of the logged in user from the permission set list
                psaSuperUserList = [select Id from PermissionSetAssignment where
                                                AssigneeId = :loggedInUserId and PermissionSetId IN :psSuperUserList];
                if(psaSuperUserList.size() > 0)
                    psaSuperUser = psaSuperUserList.get(0);
            }
            
            if(psPrivateDelegateUserList.size() > 0) {
                // assign permission set of the logged in user from the permission set list
                psaPrivateDelegateUserList = [select Id from PermissionSetAssignment where
                                                AssigneeId = :loggedInUserId and PermissionSetId IN :psPrivateDelegateUserList];
                if(psaPrivateDelegateUserList.size() > 0)
                   isPrivateDelegate = true;
            }
    
            if(psaSuperUser != null || loggedInProfile.Name == 'System Administrator') {
                // if condition satisfied assign variable true to make Super User
                isSuperUser = true;
            }
            
            x = (Cross_Sell__c) controller.getRecord();
            NomineeList= [select id, Name, first_name__c, Last_name__c, Business_Title__c, Job_Region_Code__c,
                Job_Title_Dsc_Job__c, Division_Dsc_Org__c, emp_id__c, citizenship_country__c, Manager__r.Name, Dept_Dsc_Org__c 
                from Employee__c WHERE User__c != null limit 1]; 
            
            if(x.id != null) { 
                x = [Select  c.Id, c.Why_significant__c, nominee__r.name, c.Transaction_Status__c,Estimated_Timing_of_Transaction__c,
                     c.Transaction_Product_Type__c, c.Stage__c, c.Size_of_Transaction__c, c.Revenues_000s__c, c.Decision__c,
                     c.CreatedById, c.Other_Comments__c,c.Is_covered_by_JV__c, c.One_time_fee_vs_Ongoing__c, c.Nominee__c, c.Name, c.Manager__c, 
                     c.Submitted_by__c, c.Level_Dsc_Job__c, c.Intra_ISG__c, c.First_time_business__c,Deal_Product_Type__c, c.MNPI__C, c.MNPI_non_boolean__c,
                     c.Declaration__c, c.Client_Additional_Details__c, c.Closed_Date__c, c.Client_Type_Industry__c, c.Client_Name__c,c.Other_Divisions_Involved2__c,c.Other_Divisions_Involved1__c, 
                     c.Submission_Date__c, Quarter__c, c.Nominee_Manager_s_Full_name__c, c.Nominee__r.emp_id__c, c.Nominee_Division__c,c.Approval_Status__c,c.Approval_Comment__c,
                     c.Nominee_Title__c, c.Nominee_Region__c, c.Nominee_MSID__c, c.Nominee_Group__c, c.Trade_ID__c, c.Job_Number__c,
                     Is_MS_connect_used__c,Other_indiv_involved__c,Beneficiary_Division__c From Cross_Sell__c c where id = :x.id];
            }
            // Undo comments after checking the functionality - check 13/11/2015
            if(x.Stage__c == 'Submitted') {
                submitStatus = true;
                QuarterFieldValue = x.Quarter__c;
                quarterDescribe = new List<SelectOption>();
                
                Date thisDate = date.today();        
                if(thisDate.month() == 1 || thisDate.month() == 2 || thisDate.month() == 3) {
                    quarterDescribe.add(new SelectOption('--None--', '--None--'));
                    quarterDescribe.add(new SelectOption('Q2 ' + thisDate.year(), 'Q2 ' + thisDate.year()));
                    quarterDescribe.add(new SelectOption('Q3 ' + thisDate.year(), 'Q3 ' + thisDate.year()));
                    quarterDescribe.add(new SelectOption('Q4 ' + thisDate.year(), 'Q4 ' + thisDate.year()));
                    quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
                } else if(thisDate.month() == 4  || thisDate.month() == 5 || thisDate.month() == 6) {
                    quarterDescribe.add(new SelectOption('--None--', '--None--'));
                    quarterDescribe.add(new SelectOption('Q3 ' + thisDate.year(), 'Q3 ' + thisDate.year()));
                    quarterDescribe.add(new SelectOption('Q4 ' + thisDate.year(), 'Q4 ' + thisDate.year()));
                    quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
                    quarterDescribe.add(new SelectOption('Q2 ' + (thisDate.year()+1), 'Q2 ' + (thisDate.year()+1)));
                } else if(thisDate.month() == 7  || thisDate.month() == 8 || thisDate.month() == 9) {
                    quarterDescribe.add(new SelectOption('--None--', '--None--'));
                    quarterDescribe.add(new SelectOption('Q4 ' + thisDate.year(), 'Q4 ' + thisDate.year()));
                    quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
                    quarterDescribe.add(new SelectOption('Q2 ' + (thisDate.year()+1), 'Q2 ' + (thisDate.year()+1)));
                    quarterDescribe.add(new SelectOption('Q3 ' + (thisDate.year()+1), 'Q3 ' + (thisDate.year()+1)));
                } else if(thisDate.month() == 10  || thisDate.month() == 11 || thisDate.month() == 12) {
                    quarterDescribe.add(new SelectOption('--None--', '--None--'));
                    quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
                    quarterDescribe.add(new SelectOption('Q2 ' + (thisDate.year()+1), 'Q2 ' + (thisDate.year()+1)));
                    quarterDescribe.add(new SelectOption('Q3 ' + (thisDate.year()+1), 'Q3 ' + (thisDate.year()+1)));
                    quarterDescribe.add(new SelectOption('Q4 ' + (thisDate.year()+1), 'Q4 ' + (thisDate.year()+1)));
                }
            } else {
                submitStatus = false;
            }
            
            if(x.CreatedById == loggedInUserId) {
                isCreatedLogin = true;
                
            } 
            
            if(x.Submitted_by__c == loggedInUserFullName ) {
                isSubmittedLogin = true;
                
            } 
                        
            Set<String> grpNameSet = new Set<String>();
            List<String> grpIds = new List<String>();
            List<GroupMember> groupmembers = new List<GroupMember>();
            groupmembers = [Select GroupId from GroupMember where UserOrGroupId=: loggedInUserId];
            if(!groupmembers .isEmpty()){
                for(GroupMember gmem:groupmembers  ){
                    grpIds .add(gmem.GroupId);
                }
            }
            
            if(!grpIds .isEmpty()){
            List<Group> groups = new List<Group>();
            groups =[Select Name from Group where ID IN :grpIds];
               if(!groups.isEmpty()){
                for(Group grps: groups){
                    grpNameSet.add(grps.Name);
                }
                }
            }
            
            if(grpNameSet.contains(x.Beneficiary_Division__c)){
                isDivisionMember =true;
            }

            if(x.Other_Divisions_Involved1__c != ''){
                if(grpNameSet.contains(x.Other_Divisions_Involved1__c)){
                isDivisionMember1 =true;
                }
            }

            if(x.Other_Divisions_Involved2__c != ''){
                if(grpNameSet.contains(x.Other_Divisions_Involved2__c)){
                isDivisionMember2 =true;
                }
            }
            
            System.debug('superUser ------'+isSuperUser );
            System.debug('SubmitStatus ------'+SubmitStatus );
            System.debug('isSubmittedLogin ------'+isSubmittedLogin );
            System.debug('isDivisionMember ------'+isDivisionMember );
            System.debug('isDivisionMember1 ------'+isDivisionMember1 );
            System.debug('isDivisionMember2------'+isDivisionMember2);
            if(SubmitStatus && !isSubmittedLogin && (isSuperUser || (isDivisionMember || isDivisionMember1 || isDivisionMember2))){
                
                System.debug('makeVisible  before------'+makeVisible );
                makeVisible = true;
                System.debug('makeVisible  after------'+makeVisible );

            }
           
           
            List<Id> xSellIdList = new List<Id>();
            List<Cross_Sell__c> xSellNomineeList = [select Id from Cross_Sell__c where
                                                                Nominee__r.User__r.Id = :loggedInUserId];
            List<Cross_Sell__Share> xSellShareList = [select ParentId from Cross_Sell__Share where UserorGroupId = :loggedInUserId];
            if(xSellShareList != null) {
                for(Cross_Sell__Share XS:xSellShareList)
                    xSellIdList.add(XS.ParentId);
            }
                
            if(xSellNomineeList != null) {
                for(Cross_Sell__c XS:xSellNomineeList)
                    xSellIdList.add(XS.Id);
            }
            for(Id id: xSellIdList) {
                if(x.id == id) {
                    isSharedUser = true;
                }
            }
            
            NotesPopup = false;
            
            requesteeNominee = x.nominee__r.name;
        } catch(Exception e) {
            system.debug('@@@@@'+e);
        }
    }
    
    public PageReference deleteXSell(){
     
        list<Cross_Sell__c> XSellList= [Select id from Cross_Sell__c where id = :x.Id];
        if(XSellList.size() > 0 || XSellList[0].Id != ''){
            try{
                delete XSellList;
            } catch(Exception e){
                return null;
            }
        }
        
        Pagereference p = new Pagereference('/apex/XS_Opportunity?tab=Home');
        p.setRedirect(true);
        return p;

     }
    
    /******************************************************************************************
    * SAVE   
    *
    *******************************************************************************************/
    public PageReference save() {
    
        /*
        if(validateForm()){
            return null;
        }
        */
        
        try {
            System.debug('x.quarter: ' + x.Quarter__c);
            System.debug('QuarterFieldValue ********* ' + QuarterFieldValue);
            x.Quarter__c = QuarterFieldValue;
            update x;
        } catch (Exception e) {
            System.debug('Error ********* ' + e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the XSell');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        PageReference p = new PageReference('/apex/XS_OpportunityEditP?id='
                                            + ApexPages.CurrentPage().getParameters().get('Id') + '&status=Draft');
        p.setRedirect(true);
        return p;
    }
    
    public pageReference copyRecord() {
        PageReference p = new PageReference('/apex/XS_Opportunity_NewRecordP?parentRecordId='
                                            + ApexPages.CurrentPage().getParameters().get('Id'));
        p.setRedirect(true);
        return p;
    }
    
    public PageReference AddOtherParties() {
        PageReference p = new PageReference('/apex/XSell_Other_Parties_Involved?XSellid='
                                                + ApexPages.CurrentPage().getParameters().get('Id'));
        p.setRedirect(true);
        return p;  
    }
    
    public PageReference AddNotes() {
        
        PageReference p = new PageReference('/apex/XSell_Opty_Notes?XSellid='
                                            + ApexPages.CurrentPage().getParameters().get('Id'));
        p.setRedirect(true);
        return p; 
    }
    
    public PageReference Submit() {
        /*
        if(validateForm()){
            return null;
        }
        */
        
        x.Stage__c = 'Submitted';
        // x.Submission_Date__c = date.today().format();
        try {
            update x;
      
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the XSell');
            ApexPages.addMessage(myMsg);
            return null;
       }
                
        submitStatus = true;
        
        PageReference p = new PageReference('/apex/XS_OpportunityEditP?id='
                                            + ApexPages.CurrentPage().getParameters().get('Id') + '&status=Submit');
        p.setRedirect(true);
        return p; 
    }
    
    public PageReference Approve() {
        Cross_Sell__c XS = [select Stage__c from Cross_Sell__c where id = 
                                        :ApexPages.CurrentPage().getParameters().get('Id')];
        XS.Stage__c = 'Approved';
        try {
            update XS;
        } catch (Exception e) {
            
        }
        return(new PageReference('/apex/XS_Opportunity'));
        
    }
    
    /******************************************************************************************
    * DECLARATION SEt   
    *
    *******************************************************************************************/
    public PageReference decSet() {
        
        if (x.declaration__c == true)
            x.declaration__c = false;
        else
            x.declaration__c = true;
        
        return null;
    }   
    /******************************************************************************************
    * FTB SEt   
    *
    *******************************************************************************************/
    public PageReference ftbSet() {
        
        if (x.first_time_business__c == true)
            x.first_time_business__c = false;
        else
            x.first_time_business__c = true;
        
        return null;
    }   
    
    public PageReference CancelChanges() {
        PageReference pg = new PageReference('/apex/XS_Opportunity?tab=Home');
        pg.setRedirect(true);
        
        return pg;
    }
    
    /******************************************************************************************
    * MNPI SEt   
    *
    *******************************************************************************************/
    public PageReference mnpiSet() {
        
        system.debug('MNPI is:' + mnpi);
        
       if (x.mnpi__c == true)
            x.mnpi__c = false;
       else
            x.mnpi__c = true;
        
        return null;
    }
    
    /******************************************************************************************
    * ISG   
    *
    *******************************************************************************************/
    public PageReference isgSet() {
        
        if (x.intra_isg__c == true)
            x.intra_isg__c = false;
        else
            x.intra_isg__c = true;
        
        return null;
        
    }   
    
    public pagereference closewindow() {
        nomineePopup = false;
        
        return null;  
        
    }
    
    public PageReference setRequesteeNominee() {
        //this.requesteenominee = requesteenominee;
        
        return null;
    }
    
    /******************************************************************************************
     * SEARCH    
     *
     *******************************************************************************************/
    public PageReference searchNominee(){
        nomineePopup = true;
        if(x.Nominee__r.name != null && x.Nominee__r.name != '') {
            requesteenominee = x.Nominee__r.name;
            filterNominee();
        }
        
        return null;
    }
    
    public PageReference filterNominee() {
        NomineeList.clear();
        
        if(RequesteeNominee.split('').size() <= 2)
            return NULL;
       /* Jira ID : XSELLFORCE-10 */ 
      /*  string query = 'SELECT Id, Name, First_Name__c, Last_Name__c,Business_Title__c,citizenship_country__c, Job_Title_Dsc_Job__c,' +
            ' Manager__r.Name, Job_Region_Code__c, emp_id__c, Division_Org__c, Division_Dsc_Org__c, Dept_Dsc_Org__c  FROM ' +
            ' Employee__c WHERE (Name like \'%' + RequesteeNominee + '%\' or Emp_Id__c like \'%' + RequesteeNominee +
            '%\') AND Status__c=\'Active\' AND User__c != null AND email__c != \'' + UserInfo.getUserEmail() + '\' LIMIT 10';
      */  
       string query = 'SELECT Id, Name, First_Name__c, Last_Name__c,Business_Title__c,citizenship_country__c, Job_Title_Dsc_Job__c,' +
            ' Manager__r.Name, Job_Region_Code__c, emp_id__c, Division_Org__c, Division_Dsc_Org__c, Dept_Dsc_Org__c  FROM ' +
            ' Employee__c WHERE (Name like \'%' + RequesteeNominee + '%\' or Emp_Id__c like \'%' + RequesteeNominee +
            '%\') AND Status__c=\'Active\' AND User__c != null LIMIT 50'; 
        system.debug('query to be done is: '+query);
        
        try {
            NomineeList = Database.query(query);
        } catch (Exception e) {
            
        }
        
        return null;
    }
    
    
    public List<cross_sell_parties_involved__c> getRelatedCrossSellRecords() {
        List<cross_sell_parties_involved__c> toReturn = new List<cross_sell_parties_involved__c>();
        
        try {
        System.debug('@@@@'+x.id);
            toReturn = [SELECT Id, Name, Role__c, Employee__c, Employee__r.Name, Employee__r.emp_id__c,
                        Employee__r.Job_Title_Dsc_Job__c, Employee__r.Job_Region_Code__c, Division__c, 
                        Cross_Sell__c, Employee__r.Division_Dsc_Org__c FROM 
                        cross_sell_parties_involved__c WHERE cross_sell__c =: x.Id]; 
                        
        System.debug('#######'+toReturn);                
                        
        } catch (Exception e) {
            
        }          
        
        return toReturn;
    }
    
    
    
    public void deletePartiesInvolved() {
        
        try {
            List<Cross_Sell_Parties_Involved__c> PartiesInvolved = [Select id from Cross_Sell_Parties_Involved__c
                                                                    where id = :toDelete];
                                                                    
                                                      
            if(PartiesInvolved.size() > 0 || PartiesInvolved[0].Id != ''){
                delete PartiesInvolved;
            }
        } catch (Exception e) {
            
        }
    }
    
    public List<Cross_Sell_Opty_Notes__c> getRelatedCrossSellNotes() {
        List<Cross_Sell_Opty_Notes__c> toReturn = new List<Cross_Sell_Opty_Notes__c>();
        
        try {
            if(isCreatedLogin == true && isSuperUser == false){
            toReturn = [SELECT Id, Name, Cross_Sell__c,Notes__c,CreatedBy.Name, LastModifiedBy.Name
                    FROM Cross_Sell_Opty_Notes__c WHERE cross_sell__c =: x.Id AND CreatedById =: x.CreatedById];
            }
            else{
            toReturn = [SELECT Id, Name, Cross_Sell__c,Notes__c,CreatedBy.Name, LastModifiedBy.Name
                    FROM Cross_Sell_Opty_Notes__c WHERE cross_sell__c =: x.Id]; 
            }
        } catch (Exception e) {
            
        }
        
        return toReturn;
    }
    
    
    public void deleteNotes(){
        try {
            List<Cross_Sell_Opty_Notes__c> Notes = [Select id from
                                                    Cross_Sell_Opty_Notes__c where id = :toDelete];
            if(Notes.size() > 0 || Notes[0].Id != ''){
                delete Notes;
            }
        } catch (Exception e) {
            
        }
    }
    
    public PageReference CancelNotes() {
        
        PageReference p = new PageReference('/apex/XS_OpportunityEditP?id='
                                            + ApexPages.CurrentPage().getParameters().get('XSellId')+ '&tab=Home');
        p.setRedirect(true);
        return p;
    }
    
    public PageReference setNotes() {
        return null;
    }
    
    public PageReference saveNotes() {
        system.debug('the notes value is *********: '+notes1);
        
        notesPopup = false;
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'NOTES: .' + notes1));
        
        Cross_Sell_Opty_Notes__c OptyNotes = new Cross_Sell_Opty_Notes__c();
        OptyNotes.Notes__c = Notes;
        OptyNotes.Cross_Sell__c = x.id;
        
        try {
            insert OptyNotes;
        } catch (Exception e) {
            return null;
        }
        
        PageReference p = new PageReference('/apex/XS_OpportunityEditP?id='
                                            + x.id + '&tab=Home');
        p.setRedirect(true);
        return p;
    }
    
    public PageReference addnotesPop(){
        notesPopup = true;
        
        return null;
    }
    
    public pagereference closewindow2() {
        notesPopup = false;
        
        return null;
    }

    public void doNothing() {
        system.debug('selection: '+selection+' selected: '+selected);
        system.debug('nomineeName2: '+nomineeName2+' nomineeId2: '+nomineeId2);
        }


    public PageReference updateNotes(){
        Cross_Sell_Opty_Notes__c OptyNotes = new Cross_Sell_Opty_Notes__c(id=crossSellOptyId, Notes__c = notes1);
        
        try {
            update OptyNotes;
        } catch (Exception e) {
            return null;
        }
        
        return NULL;
    }

    public pagereference closewindow3() {
        notesPopup = false;
        
        return null;  
        
    }

    /*
        public PageReference SaveData() {
        try{
            for(Cross_Sell_Parties_Involved__c XSellParty: listPartiesInvolved) {
                XSellParty.Cross_Sell__c = ApexPages.CurrentPage().getParameters().get('XSellId');
            }
        
            list<Cross_Sell_Parties_Involved__c> XSellPartyList1 = new list<Cross_Sell_Parties_Involved__c>();
            for(Cross_Sell_Parties_Involved__c XSellParty: listPartiesInvolved) {
                if(XSellParty.Role__c != null) {
                 XSellPartyList1.add(XSellParty);
              }
            }
        
            insert XSellPartyList1;
        //controller.save();
            return (new PageReference('/Apex/xs_opportunityEditP?id=' + ApexPages.CurrentPage().getParameters().get('XSellId')+ '&tab=Home'));
        } Catch(Exception e) {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
             ApexPages.addMessage(myMsg);
             return null;
        }
    
    }
    */

    public PageReference SaveData() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'NOTESb: .' ));
        system.debug('nomineeName2: '+nomineeName2+' nomineeId2: '+nomineeId2);
        
        if(selection == null)
            return NULL;
        
        if(String.isEmpty(selection))
            return NULL;
        
        system.debug('selected: '+selected+' selection: '+selection);
        system.debug('xsekk: '+ApexPages.CurrentPage().getParameters().get('id'));
        
        try {
            Cross_Sell_Parties_Involved__c partiesToInsert = 
                new Cross_Sell_Parties_Involved__c(Role__c=selected, 
                                                   Cross_Sell__c = ApexPages.CurrentPage().getParameters().get('id'));
                      system.debug('@@@@@@@@@@ '+partiesToInsert);
            
            if(selected.equalsIgnoreCase('Other Division')){
                partiesToInsert.Division__c = selection;
            } else { 
                partiesToInsert.Employee__c = nomineeId2;
            }
            insert partiesToInsert;
        } catch (Exception e) {
                System.debug('share exception: ' + e.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while sharing Cross sell');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        return (new PageReference('/apex/XS_OpportunityEditP?id=' +
                                  ApexPages.CurrentPage().getParameters().get('Id') +
                                  '&tab=Home'));
    }
        
    public PageReference CancelData() {
        return (new PageReference('/apex/XS_OpportunityEditP?id='
                                  + ApexPages.CurrentPage().getParameters().get('Id')
                                  + '&tab=Home'));
    }
    
    public PageReference sharePop(){
        sharePopup = true;
        
        return null;
    }
    
    public pagereference closewindow4() {
        sharePopup = false;
        
        return null;  
        
    }
    
    // validate form before submission
    public Boolean validateForm() {
    
        Boolean validationError = false;
        nomineeErrorMessage = false;
        apprCommentErrorMsg = false;
        
        try {
            if(x.Nominee__r.name == null || x.Nominee__r.name == '') {
                nomineeErrorMessage = true;
                validationError = true;
            }
                
            if(x.Client_Name__c == null || x.Client_Name__c == '') {
                x.Client_Name__c.addError('You must enter a value');
                validationError = true;
            }
                
            if(x.Client_Type_Industry__c == null || x.Client_Type_Industry__c == '') {
                x.Client_Type_Industry__c.addError('You must enter a value');
                validationError = true;
            }
            
            if(x.Revenues_000s__c == null) {
                x.Revenues_000s__c.addError('You must enter a value');
                validationError = true;
            }
                
            if(x.Size_of_Transaction__c == null) {
                x.Size_of_Transaction__c.addError('You must enter a value');
                validationError = true;
            }
            
            if(x.Other_Comments__c != null && x.Other_Comments__c.length() > 500) {
                otherCommentsErrorMessage = true;
                validationError = true;
            }
            
            if(x.Why_significant__c != null && x.Why_significant__c.length() > 500) {
                significantErrorMessage = true;
                validationError = true;
            } else if(x.Why_significant__c == null) {
                x.Why_significant__c.addError('You must enter a value');
                validationError = true;
            }
            
            
        } catch (Exception e) {
        
            system.debug('e---------------'+e);
            return null;
        }
        
        return validationError;
    }
    
    public PageReference cloneOppty(){
        PageReference pr = new PageReference('/apex/XS_Opportunity_NewRecordP?clone='+x.Id);
        pr.setRedirect(true);
        return pr;
    }
    
    public List<SelectOption> getpicklistVals(){      
        
        List<SelectOption> ftbOpts = new List<SelectOption>();
        ftbOpts.add(new SelectOption('true','Yes'));
        ftbOpts.add(new SelectOption('false','No'));
        return ftbOpts;
        
    }
    
    /*
    public List<SelectOption> getQuarterDescribe() {
        Date thisDate = date.today();
        
        if(thisDate.month() == 1 || thisDate.month() == 2 || thisDate.month() == 3) {
            quarterDescribe.add(new SelectOption('--None--', '--None--'));
            quarterDescribe.add(new SelectOption('Q2 ' + thisDate.year(), 'Q2 ' + thisDate.year()));
            quarterDescribe.add(new SelectOption('Q3 ' + thisDate.year(), 'Q3 ' + thisDate.year()));
            quarterDescribe.add(new SelectOption('Q4 ' + thisDate.year(), 'Q4 ' + thisDate.year()));
            quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
        } else if(thisDate.month() == 4  || thisDate.month() == 5 || thisDate.month() == 6) {
            quarterDescribe.add(new SelectOption('--None--', '--None--'));
            quarterDescribe.add(new SelectOption('Q3 ' + thisDate.year(), 'Q3 ' + thisDate.year()));
            quarterDescribe.add(new SelectOption('Q4 ' + thisDate.year(), 'Q4 ' + thisDate.year()));
            quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
            quarterDescribe.add(new SelectOption('Q2 ' + (thisDate.year()+1), 'Q2 ' + (thisDate.year()+1)));
        } else if(thisDate.month() == 7  || thisDate.month() == 8 || thisDate.month() == 9) {
            quarterDescribe.add(new SelectOption('--None--', '--None--'));
            quarterDescribe.add(new SelectOption('Q4 ' + thisDate.year(), 'Q4 ' + thisDate.year()));
            quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
            quarterDescribe.add(new SelectOption('Q2 ' + (thisDate.year()+1), 'Q2 ' + (thisDate.year()+1)));
            quarterDescribe.add(new SelectOption('Q3 ' + (thisDate.year()+1), 'Q3 ' + (thisDate.year()+1)));
        } else if(thisDate.month() == 10  || thisDate.month() == 11 || thisDate.month() == 12) {
            quarterDescribe.add(new SelectOption('--None--', '--None--'));
            quarterDescribe.add(new SelectOption('Q1 ' + (thisDate.year()+1), 'Q1 ' + (thisDate.year()+1)));
            quarterDescribe.add(new SelectOption('Q2 ' + (thisDate.year()+1), 'Q2 ' + (thisDate.year()+1)));
            quarterDescribe.add(new SelectOption('Q3 ' + (thisDate.year()+1), 'Q3 ' + (thisDate.year()+1)));
            quarterDescribe.add(new SelectOption('Q4 ' + (thisDate.year()+1), 'Q4 ' + (thisDate.year()+1)));
        }
        
        return quarterDescribe;
    }
    
    public void setQuarterDescribe() {
        
    }
    */
    
    public pagereference saveApprove(){
            
            try{
                update x;
            }
            catch(Exception e){
                 System.debug('Error ********* ' + e);
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the XSell');
                 ApexPages.addMessage(myMsg);
                 
            }
            System.debug('pagerefere');
            PageReference p = new PageReference('/apex/XS_OpportunityEditP?id='
                                            + ApexPages.CurrentPage().getParameters().get('Id'));
                                             System.debug('pagerefere');
            p.setRedirect(true);
            return p;
        
        }
    
}