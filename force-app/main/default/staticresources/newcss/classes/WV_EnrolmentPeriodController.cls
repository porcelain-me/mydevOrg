public class WV_EnrolmentPeriodController {
    
    public List<Enrollment_Period__c> enrolmentList {get; set;} 
    public string selectedSchemeId {get; set;}
    public boolean isCreateAllowed {get; set;}
    public string enrolId {get; set;}
    public boolean showEnrolDetail {get; set;}
    public boolean showEnrolList {get; set;}
    public boolean showEnrolSaveButton {get; set;}
    public boolean showEnrolEditButton {get; set;}
    public Enrollment_Period__c selectedEnrolment {get; set;}
    public List<Scheme__c> schemeRecord {get; set;}
    public boolean isEditmode {get; set;}   
    public boolean displayError {get;set;}
    public datetime currentTime {get; set;}    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    
    public WV_EnrolmentPeriodController(){
        try{
            showEnrolList=true;
            showEnrolDetail=false;        
            displayError = false;        
            currentTime=System.now();
            customPageMessage=null;
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;
            OrgName=Label.ORG_ENVIRONMENT; 
            
            selectedSchemeId = ApexPages.Currentpage().getParameters().get('Id');
            if(selectedSchemeId != null && selectedSchemeId != ''){
                schemeRecord = WV_Utility.getSchemeDetails(selectedSchemeId);
                enrolmentList=WV_Utility.getEnrolmentList(selectedSchemeId);
            }
        }
        Catch (Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside enrolment period constructor'+e.getlinenumber()+'-'+e.getmessage()); 
            displayError = true;
        }
        
    }
    
    public pageReference enrolAction(){
        try{
            displayError = false;
            customPageMessage=null;            
            enrolId = ApexPages.Currentpage().getParameters().get('enrolIds');        
            showEnrolDetail = true;
            showEnrolList=false;      
            selectedEnrolment=WV_Utility.getEnrolment(enrolId)[0];
            enrolId = null;
        }
        Catch (Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside enrolAction'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Enrolment tab-->enrolAction','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError = true;
        }
        return null;
    }
    
    public pageReference enrolSave(){
        Boolean checkMandatory = true;
        displayError = false;
        customPageMessage=null;
        
        try{     
            if((selectedEnrolment.name == null || selectedEnrolment.name =='')){
                selectedEnrolment.name.addError(Label.WV_NoInput_MandatoryField);
                checkMandatory = false;
                
            } 
            if(selectedEnrolment.Start_Date__c == null){
                selectedEnrolment.Start_Date__c.addError(Label.WV_NoInput_MandatoryField);
                checkMandatory = false;
                
            }  
            if(selectedEnrolment.Compensation_Year__c == null){
                selectedEnrolment.Compensation_Year__c.addError(Label.WV_NoInput_MandatoryField);
                checkMandatory = false;
                
            }  
            if(selectedEnrolment.end_Date__c ==null){
                selectedEnrolment.end_Date__c.addError(Label.WV_NoInput_MandatoryField);
                checkMandatory = false;
                
            } 
                            
            if( !checkMandatory) {
                displayError = true;
                return null;
            }
            
            List<Enrollment_Period__c> preEnrolmentList=WV_Utility.validateStartDateEnrolmentPeriod(selectedSchemeId,selectedEnrolment.Id,selectedEnrolment.Start_Date__c);
            List<Enrollment_Period__c> futureEnrolmentList=WV_Utility.validateEndDateEnrolmentPeriod(selectedSchemeId,selectedEnrolment.Id,selectedEnrolment.End_Date__c);
            
            if(preEnrolmentList != null && preEnrolmentList.size() >0){
                customPageMessage=Label.WV_Enrol_DATE_MERGING_MISMATCH;
                typeOfMessage='Error';
                displayError = true;
                return null; 
            } 
            else if(futureEnrolmentList != null && futureEnrolmentList.size() >0){
                customPageMessage=Label.WV_Enrol_DATE_MERGING_MISMATCH;
                typeOfMessage='Error';
                displayError = true;
                return null; 
            }  
            else{
                if(selectedEnrolment.Id == null && selectedEnrolment.Start_Date__c < system.now().addminutes(-1)){
                    customPageMessage=Label.WV_Enrol_STARTDATE_INVALID;
                    typeOfMessage='Error';
                    displayError = true;
                    return null;
                }
                
                if(selectedEnrolment.Id != null){                    
                    if(selectedEnrolment.end_date__c <= system.now().addminutes(-1)){
                        customPageMessage=Label.WV_Enrol_EDIT_ENDDATE_INVALID;
                        typeOfMessage='Error';
                        displayError = true;
                        return null;
                    }
                    Datetime validStartDateforEdit=WV_Utility.validationOnEnrolmentStartdate(selectedSchemeId,selectedEnrolment);
                    if( validStartDateforEdit != null ){
                        customPageMessage=Label.WV_Enrol_EDIT_STARTDATE_INVALID+' '+validStartDateforEdit.format();
                        typeOfMessage='Error';
                        displayError = true;
                        return null;
                    }
                }
                
                
                if(selectedEnrolment.Start_Date__c >= selectedEnrolment.end_date__c){
                    customPageMessage=Label.WV_Enrol_STARTDATE_ENDDATE_MISMATCH;
                    typeOfMessage='Error';
                    displayError = true;
                    return null;
                }
                                
                selectedEnrolment.Override_Scheme__c=selectedSchemeId;
                upsert selectedEnrolment;     
                
                if(schemeRecord != null && schemeRecord.size() >0 ){
                    schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                    schemeRecord[0].Last_updated_date__c=system.now();                
                    update  schemeRecord[0];  
                }    
                
            }         
            enrolmentList=WV_Utility.getEnrolmentList(selectedSchemeId);
            showEnrolDetail =false;
            showEnrolList=true; 
                      
            return null; 
        }
        Catch(DMLException e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside enrolSave method'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Enrolment tab-->enrolSave method','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError = true;
            return null; 
        }       
    }
    
    public pageReference enrolBack(){
        try{
            displayError = false;
            selectedEnrolment=null;
            customPageMessage=null;            
            enrolmentList=WV_Utility.getEnrolmentList(selectedSchemeId);
            showEnrolDetail =false;
            showEnrolList=true;            
        }
        Catch (Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside enrolBack method'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Enrolment tab-->enrolBack method','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError = true;
        }  
        return null;      
    }
    
    public pageReference enrolNew(){
        try{
            customPageMessage=null;
            displayError = false;
            showEnrolDetail =true;
            showEnrolList=false;
            selectedEnrolment=new Enrollment_Period__c();
        }
        Catch (Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside enrolNew method'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Enrolment tab-->enrolNew method','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            displayError = true;
        }  
        return null; 
    }

}