public class WV_EligibilityAssignmnet{
    
    public string SchemeID;
    public string pageBlockTitle {get; set;}
    public string selectedSchemeId{get; set;}
    public string selectedLoadMethod{get; set;}
    public Eligibility__c EligibilityRecord{get; set;}
    public string Salesforce15Id{get; set;}    
    public boolean ShowMainSection{get; set;}
    public boolean ShowRuleSection{get; set;}
    public boolean ShowCustomDataSection{get; set;}    
    public boolean IsSaveButtonEnabled{get; set;}
    public boolean IsPreviewCsvButtonEnabled{get; set;}
    public boolean IsUploadDataButtonEnabled{get; set;}
    public boolean IsDeleteButtonEnabled{get; set;}
    public boolean DisplayReportLink{get; set;}
    public blob body{get; set;}
    public string Name{get; set;}
    public List<string> LoadedMSIDList{get; set;}
    public set<string> MSIDset;
    public boolean isNextbuttonEnabled {get; set;}
    public string ResultString {get; set;}    
    public string preEligibleEmployee {get; set;}
    public boolean showDownloadLink {get; set;}
    public boolean showCurrentEmployeeLink  {get; set;}
    public boolean showStatusBar {get; set;}
    public string selectedEligibilityId {get; set;}
    public List<Eligibility__c> EligiblityRecords;
    public List<Scheme__c> schemeRecord {get; set;}    
    public string errorEmployeeReportId{get; set;}
    public string eligibleEmployeeReportId{get; set;}
    public string ruleBasedEmployeeReportId{get; set;}    
    public boolean displayError {get; set;}    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
        
    public List<selectoption> getLoadMethods(){
        List<selectoption> Lst=new List<selectoption>();
        Lst.add(new selectoption('rule','Rule'));
        Lst.add(new selectoption('customdata','File Upload'));    
        return Lst;
    }  
    
    public WV_EligibilityAssignmnet() {
        displayError =false;
        customPageMessage=null;
        showStatusBar=false;
        try{
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;
            OrgName=Label.ORG_ENVIRONMENT;  
            
            selectedSchemeId = ApexPages.Currentpage().getParameters().get('Id');      
            if(selectedSchemeId != null && selectedSchemeId != ''){
                eligiblityRecords=WV_Utility.getEligibilityforScheme(selectedSchemeId);
                schemeRecord = WV_Utility.getSchemeDetails(selectedSchemeId);
                 List<Report> erroremployeesReport=WV_Utility.getReports('Error_Employees');
                 if(erroremployeesReport != null && erroremployeesReport.size() > 0){
                     errorEmployeeReportId=erroremployeesReport[0].Id;
                 }
                 List<Report> eligibleEmployeesReport=WV_Utility.getReports('Eligible_Employee');
                 if(eligibleEmployeesReport != null && eligibleEmployeesReport.size() > 0){
                     eligibleEmployeeReportId=eligibleEmployeesReport[0].Id;
                 }
                 List<Report> rulebasedEmployeesReport=WV_Utility.getReports('Employee_Report');
                 if(rulebasedEmployeesReport != null && rulebasedEmployeesReport.size() > 0){
                     ruleBasedEmployeeReportId=rulebasedEmployeesReport[0].Id;        
                 }            
            }
            
            pageBlockTitle ='Eligibility Criteria';  
            ShowMainSection=true;
            ShowRuleSection=false;   
            ShowCustomDataSection=false;
            
            IsSaveButtonEnabled=false;
            IsPreviewCsvButtonEnabled=false;
            IsUploadDataButtonEnabled=false;
            IsDeleteButtonEnabled=false;
            DisplayReportLink=false;   
            isNextbuttonEnabled=true;  
            
            showDownloadLink =false;
            showCurrentEmployeeLink = false;        
            preEligibleEmployee ='';
            Salesforce15Id='';
            
            if(eligiblityRecords != null && eligiblityRecords.size() == 1){
                if(eligiblityRecords[0].name == 'Database rules'){
                    selectedLoadMethod = 'rule';
                    EligibilityRecord=eligiblityRecords[0];                            
                    ShowRuleSection=true;                        
                    ShowCustomDataSection=false;
                    ShowMainSection=false;             
                    IsSaveButtonEnabled=true;
                    IsPreviewCsvButtonEnabled=false;
                    IsUploadDataButtonEnabled=false;
                    IsDeleteButtonEnabled=true;
                    DisplayReportLink=WV_Utility.geteligibleForDownloadEmployees(EligibilityRecord);
                    isNextbuttonEnabled =false; 
                }
                else{
                    selectedLoadMethod = 'customdata';
                    EligibilityRecord=eligiblityRecords[0];
                    LoadedMSIDList=new List<string>();
                    
                    ShowRuleSection=false;
                    ShowCustomDataSection=true;
                    ShowMainSection=false;
                                        
                    showCurrentEmployeeLink = true;
                    showDownloadLink = true;
                    IsSaveButtonEnabled=false;
                    IsPreviewCsvButtonEnabled=true;
                    IsUploadDataButtonEnabled=true;
                    IsDeleteButtonEnabled=true; 
                    isNextbuttonEnabled =false;  
                }
                Salesforce15Id=String.ValueOf(EligibilityRecord.Id).subString(0,15);    
            }
        }
        Catch(Exception e){        
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside constructor'+e.getlinenumber()+'-'+e.getmessage());
        }
    }
    
    public PageReference StartNext(){
        displayError =false;
        customPageMessage=null;
        showStatusBar =false;
        try{            
            ShowRuleSection=false;
            ShowCustomDataSection=false;
            ShowMainSection=true;
            preEligibleEmployee = '';   
            showCurrentEmployeeLink = false;
            showDownloadLink=false;
            
            if(selectedSchemeId !='' && selectedSchemeId != null && selectedLoadMethod != null && selectedLoadMethod != ''){
                EligiblityRecords=WV_Utility.getEligibilityforScheme(selectedSchemeId);
                if(EligiblityRecords == null || EligiblityRecords.size()==0){   
                    EligibilityRecord=new Eligibility__c();                              
                    if(selectedLoadMethod == 'rule'){                
                        ShowRuleSection=true;
                        ShowCustomDataSection=false;
                        ShowMainSection=false;
                        
                        IsSaveButtonEnabled=true;
                        IsPreviewCsvButtonEnabled=false;
                        IsUploadDataButtonEnabled=false;
                        IsDeleteButtonEnabled=false;
                        isNextbuttonEnabled=false;
                    }        
                    if(selectedLoadMethod == 'customdata'){
                        ShowCustomDataSection=true;
                        ShowRuleSection=false;
                        ShowMainSection=false;
                        
                        IsSaveButtonEnabled=false;
                        IsPreviewCsvButtonEnabled=true;
                        IsUploadDataButtonEnabled=true;
                        IsDeleteButtonEnabled=false;
                        isNextbuttonEnabled =false;
                        
                    }
                }                
            }
            else{
                if(selectedSchemeId ==null || selectedSchemeId.trim() == ''){
                    customPageMessage=Label.WV_Eligibility_No_Scheme;
                    typeOfMessage='Error';
                }
                else{
                    customPageMessage=Label.WV_Eligibility_No_MethodSelected;
                    typeOfMessage='Error';
                }
                
                ShowRuleSection=false;
                ShowCustomDataSection=false;
                ShowMainSection=true;
                            
                IsSaveButtonEnabled=false;
                IsPreviewCsvButtonEnabled=false;
                IsUploadDataButtonEnabled=false;
                IsDeleteButtonEnabled=false;
                isNextbuttonEnabled =true;
                
                displayError =true;
            }
        }
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside StartNext method'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Eligibilty tab-->StartNext method','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError =true;
        }
        
        return null;
    
    }
    
    public PageReference Backbutton(){
        customPageMessage=null;
        try{
            displayError =false;
            ShowRuleSection=false;
            ShowCustomDataSection=false;
            ShowMainSection=true;
            showStatusBar =false;
                        
            IsSaveButtonEnabled=false;
            IsPreviewCsvButtonEnabled=false;
            IsUploadDataButtonEnabled=false;
            IsDeleteButtonEnabled=false;
            isNextbuttonEnabled =true;   
            customPageMessage=null;  
        }
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside Backbutton method'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Eligibilty tab-->Backbutton method','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError =true;
        }
        return null;
    }
        
    public PageReference submit(){
        
        try{
            displayError =false;
            customPageMessage=null;
            showStatusBar=false;
            if(EnforceDataValidation('Benefit Program',EligibilityRecord.Benefit_Program__c)==false)
                return null;
            if(EnforceDataValidation('Job Region',EligibilityRecord.Job_Region__c)==false)
                return null;
            if(EnforceDataValidation('Cost Center',EligibilityRecord.Cost_Center__c)==false)
                return null;
            if(EnforceDataValidation('Pay Company',EligibilityRecord.Pay_Company__c)==false)
                return null;
            if(EnforceDataValidation('Home Country',EligibilityRecord.Home_Country__c)==false)
                return null;
            if(EnforceDataValidation('Employee Class',EligibilityRecord.Employee_Class__c)==false){
                return null;
            }
            if((EligibilityRecord.Benefit_Program__c==null || EligibilityRecord.Benefit_Program__c.trim()=='') && (EligibilityRecord.Job_Region__c==null || EligibilityRecord.Job_Region__c.trim()=='') && (EligibilityRecord.Cost_Center__c==null || EligibilityRecord.Cost_Center__c.trim()=='') && (EligibilityRecord.Home_Country__c==null || EligibilityRecord.Home_Country__c.trim()=='') && (EligibilityRecord.Pay_Company__c==null || EligibilityRecord.Pay_Company__c.trim()=='') && (EligibilityRecord.Employee_Class__c==null || EligibilityRecord.Employee_Class__c.trim()=='') && (EligibilityRecord.Officer__c==null || EligibilityRecord.Officer__c=='') ){
                customPageMessage=Label.WV_Eligibility_No_input;
                typeOfMessage='Error';
                
                displayError =true;
                return null;
            }
            EligibilityRecord.Name = 'Database rules';
            EligibilityRecord.Database_Driven__c=true;        
            EligibilityRecord.Scheme__c=selectedSchemeId;
            upsert EligibilityRecord;
            
            if(schemeRecord != null && schemeRecord.size() >0 ){
                schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                schemeRecord[0].Last_updated_date__c=system.now();                
                update  schemeRecord[0];  
            }    
            
            ShowRuleSection=true;   
            ShowCustomDataSection=false;
            ShowMainSection=false;
            
            IsSaveButtonEnabled=true;
            IsPreviewCsvButtonEnabled=false;
            IsUploadDataButtonEnabled=false;
            IsDeleteButtonEnabled=true;
            DisplayReportLink=WV_Utility.geteligibleForDownloadEmployees(EligibilityRecord);
            isNextbuttonEnabled =false;  
            
            customPageMessage=Label.WV_Eligibility_Rule_SuccessUpdate;
            typeOfMessage='Info';
            displayError = true;
        }
        catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside submit'+e.getlinenumber()+'-'+e.getmessage());
            WV_Utility.captureException('My Elections','Scheme Detail page->Eligibility tab-->submit()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError =true;
        }
        return null;
    }
    
    public boolean EnforceDataValidation(string fieldname,string field){
        if(field != null && field != ''){
            if( field.substring(0,1).isalphanumeric()==false || field.substring((field.length()-1),(field.length())).isalphanumeric()==false){
                customPageMessage=fieldname+' '+Label.WV_Eligibility_Validation_RuleInput;
                typeOfMessage='Error';
                displayError =true;
                return false;
            }
            for(string e:field.split(',')){   
                if(e.trim()==''){                        
                    customPageMessage=fieldname+' '+Label.WV_Eligibility_Validation_RuleInput;
                    typeOfMessage='Error';
                    displayError =true;
                    return false;
                }
            }
            return true;            
       }  
       else{
           return true;
       }  
       
    }
        
    public PageReference Upload(){
        Savepoint sp = Database.setSavepoint();
        displayError =false;
        string[] eachCleanFieldList;
        customPageMessage=null;
        showStatusBar =false;
        try{        
            showDownloadLink =true;  
            showCurrentEmployeeLink =true; 
            
            if(body == null){
                customPageMessage=Label.WV_Eligibilty_No_File_Chossed;
                typeOfMessage='Error';
                displayError =true;
                body =null;  
                return null;            
            }
            else if(name == null){
                customPageMessage=Label.WV_Eligibilty_No_FileName;
                typeOfMessage='Error';
                displayError =true;
                body =null;  
                return null;           
            }             
            else if(name.lastIndexOf('.') == -1){
                customPageMessage=Label.WV_Eligibilty_No_Extn;
                typeOfMessage='Error';
                displayError =true;
                body =null;  
                return null;            
            }            
            else if(name.lastIndexOf('.') <> -1 && name.substring(name.lastIndexOf('.') + 1).toLowerCase() <> 'csv'){
                customPageMessage=Label.WV_Eligibilty_No_ValidExtn_Csv;
                typeOfMessage='Error';
                displayError =true;
                body =null;              
                return null;
            }   
            List<AsyncApexJob> openJobs =WV_Utility.getPendingBatchJobs(null);
            if(openJobs != null && openJobs.size() < 5){
                List<AsyncApexJob> pendingBacthJobs=WV_Utility.getPendingBatchJobs('WV_EligibilityFileIploadBatch');
                if(pendingBacthJobs != null && pendingBacthJobs.size() > 0){
                    customPageMessage=Label.WV_Eligibilty_Pending_BatchJob;
                    typeOfMessage='Error';
                    displayError =true;
                    body =null;  
                    return null;
                }
            }
            else{
                customPageMessage=Label.WV_Eligibilty_BatchNotAllowed;
                typeOfMessage='Error';
                displayError =true;
                body =null;  
                return null;
            }                     
              
            string MSIDFile=body.toString();
            string[] filelines =new string[2];
            set<string> duplicateCheck;
            if(MSIDFile != null && MSIDFile.trim() != ''){
                filelines[0] = MSIDFile.subString(0,MSIDFile.indexOf('\n'));
                MSIDFile= MSIDFile.subString((MSIDFile.indexOf('\n') + '\n'.length()),MSIDFile.length());
                eachCleanFieldList=WV_Utility.getCleanFields(filelines[0].split(','));
                if(eachCleanFieldList != null && eachCleanFieldList.size() >0){
                    duplicateCheck=new set<string>(eachCleanFieldList);
                    if(duplicateCheck != null && duplicateCheck.size() >0){
                        for(string dup:duplicateCheck){
                            if(dup==null || dup.trim()==''){
                                Database.rollback(sp);
                                customPageMessage=Label.WV_Eligibility_DuplicateColumns;
                                typeOfMessage='Error';
                                displayError =true;      
                                body=null;         
                                return null;
                            }
                        }
                    }
                }
            }
            else{
                filelines[0] =null;
            }
            
            
            if(MSIDFile.trim() != '' && MSIDFile.contains('\n')){
                filelines[1] = MSIDFile.subString(0,MSIDFile.indexOf('\n'));
            }
            else{
                filelines[1]=null;
            }     
            
            if((filelines[0] == null || (eachCleanFieldList[0] == null || eachCleanFieldList[0].trim() != 'MSID'))){    
                Database.rollback(sp);
                customPageMessage=Label.WV_Eligibilty_No_MSIDfirst;
                typeOfMessage='Error';
                displayError =true;      
                body=null;         
                return null;
            } 
            else if(duplicateCheck != null && eachCleanFieldList != null && (duplicateCheck.size() < eachCleanFieldList.size())){
                Database.rollback(sp);
                customPageMessage=Label.WV_Eligibility_DuplicateColumns;
                typeOfMessage='Error';
                displayError =true;      
                body=null;         
                return null;
            }   
            else if(filelines[1] == null){
                Database.rollback(sp);
                customPageMessage=Label.WV_Eligibility_No_Rows;
                typeOfMessage='Error';
                displayError =true;      
                body=null;         
                return null;
            }          
            else{        
                EligibilityRecord.Name = 'File Upload';             
                EligibilityRecord.Database_Driven__c=false;
                EligibilityRecord.Scheme__c=selectedSchemeId;
                Upsert EligibilityRecord;
                
                if(schemeRecord != null && schemeRecord.size() >0 ){
                    schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                    schemeRecord[0].Last_updated_date__c=system.now();                
                    update  schemeRecord[0];  
                }    
                
                Salesforce15Id=String.ValueOf(EligibilityRecord.Id).subString(0,15);
                
                WV_EligibilityFileIploadBatch batchProcess=new WV_EligibilityFileIploadBatch();
                batchProcess.m_csvFile=MSIDFile;
                batchProcess.fileId=EligibilityRecord.Id;
                Database.ExecuteBatch(batchProcess,2000);
                
                showStatusBar=true;
                displayError =true;
                body=null;   
                ShowRuleSection=false;   
                ShowCustomDataSection=true;
                ShowMainSection=false;
                
                IsSaveButtonEnabled=false;
                IsPreviewCsvButtonEnabled=true;
                IsUploadDataButtonEnabled=true;
                IsDeleteButtonEnabled=true;
                isNextbuttonEnabled =false;  
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside Upload'+e.getlinenumber()+'-'+e.getmessage());
            WV_Utility.captureException('My Elections','Scheme Detail page->Eligibility tab-->Upload()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError =true;
            body=null;   
        }
        return null;
    }
    
    public PageReference DeleteRecord(){
        displayError =false;
        customPageMessage=null;
        showStatusBar=false;
        
        try{
            if(selectedSchemeId != null && selectedSchemeId != ''){
                if(selectedLoadMethod == 'rule'){ 
                    delete EligibilityRecord; 
                    EligibilityRecord=new Eligibility__c();  
                     
                    ShowRuleSection=false;
                    ShowCustomDataSection=false;
                    ShowMainSection=true;
                    
                    IsSaveButtonEnabled=false;
                    IsPreviewCsvButtonEnabled=false;
                    IsUploadDataButtonEnabled=false;
                    IsDeleteButtonEnabled=false;
                    DisplayReportLink=false;
                    isNextbuttonEnabled =true;
                }        
                else if(selectedLoadMethod == 'customdata'){
                        EligibilityRecord.scheme__c=null;
                        update EligibilityRecord;                                      
                        
                        ShowCustomDataSection=false;
                        ShowRuleSection=false;
                        ShowMainSection=true;
                        
                        EligibilityRecord=new Eligibility__c();
                        
                        IsSaveButtonEnabled=false;
                        IsPreviewCsvButtonEnabled=false;
                        IsUploadDataButtonEnabled=false;
                        IsDeleteButtonEnabled=false; 
                        isNextbuttonEnabled =true; 
                }
                if(schemeRecord != null && schemeRecord.size() >0 ){
                    schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                    schemeRecord[0].Last_updated_date__c=system.now();                
                    update  schemeRecord[0];  
                } 
            }
            else{
                customPageMessage=Label.WV_Eligibility_No_Scheme;
                typeOfMessage='Error';
                displayError =true;
            }
        }    
        catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside submit'+e.getlinenumber()+'-'+e.getmessage());
            WV_Utility.captureException('My Elections','Scheme Detail page->Eligibility tab-->DeleteRecord()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }
        return null;   
    }
      
    
}