public class WV_SchemeDetailController {
    
    public string selectedSchemeId {get; set;}    
    public Scheme__c schemeRecord {get; set;}
    public boolean allowSchemeEdit {get; set;}  
    public boolean hideEnrolTabContent {get; set;}
    public boolean hideEligibiltyTabContent {get; set;}
    public boolean hideContentTabContent {get; set;}
    public boolean hideCustomdataTabContent {get; set;}
    public boolean hideTemplateTabContent {get; set;}
    public boolean hideSharingTabContent {get; set;}    
    public string activeTab{get; set;}
    public string  errorResult {get;set;}    
    public string selectedTab {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    public exception exp{get; set;} 
    public boolean isActive {get; set;}
    public Boolean isAbacusEnabled { set; get; }

    public WV_SchemeDetailController (ApexPages.StandardController controller) {
        
        errorResult='';    
        isActive=false;
        
        try{
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;        
            OrgName=Label.ORG_ENVIRONMENT; 
                
            this.schemeRecord = (Scheme__c)controller.getRecord();
            selectedTab = ApexPages.Currentpage().getParameters().get('tab');
            if(selectedTab != null && selectedTab.trim() !=''){
                if(selectedTab =='enrolTab'){
                    hideEnrolTabContent=false;
                    hideEligibiltyTabContent=true; 
                    hideContentTabContent=true;
                    hideCustomdataTabContent=true; 
                    hideTemplateTabContent=true;
                    hideSharingTabContent =true;
                    activeTab='enrolTab';  
                }    
                else if(selectedTab =='eligiblilityTab'){
                    hideEnrolTabContent=true;
                    hideEligibiltyTabContent=false; 
                    hideContentTabContent=true;
                    hideCustomdataTabContent=true; 
                    hideTemplateTabContent=true;
                    hideSharingTabContent =true;
                    activeTab='eligiblilityTab';      
                } 
                else if(selectedTab =='contentTab'){
                    hideEnrolTabContent=true;
                    hideEligibiltyTabContent=true; 
                    hideContentTabContent=false;
                    hideCustomdataTabContent=true; 
                    hideTemplateTabContent=true; 
                    hideSharingTabContent =true;
                    activeTab='contentTab';
                } 
                else if(selectedTab =='customdataTab'){
                    hideEnrolTabContent=true;
                    hideEligibiltyTabContent=true; 
                    hideContentTabContent=true;
                    hideCustomdataTabContent=false; 
                    hideTemplateTabContent=true; 
                    hideSharingTabContent =true;
                    activeTab='customdataTab';
                } 
                else if(selectedTab =='templateTab'){
                    hideEnrolTabContent=true;
                    hideEligibiltyTabContent=true; 
                    hideContentTabContent=true;
                    hideCustomdataTabContent=true; 
                    hideTemplateTabContent=false;
                    hideSharingTabContent =true;
                    activeTab='templateTab';
                } 
                else if(selectedTab =='shareTab'){
                    hideEnrolTabContent=true;
                    hideEligibiltyTabContent=true; 
                    hideContentTabContent=true;
                    hideCustomdataTabContent=true; 
                    hideTemplateTabContent=true;
                    hideSharingTabContent =false; 
                    activeTab='shareTab';
                }
                else{
                    hideEnrolTabContent=false;
                    hideEligibiltyTabContent=true; 
                    hideContentTabContent=true;
                    hideCustomdataTabContent=true; 
                    hideTemplateTabContent=true;
                    hideSharingTabContent =true; 
                    activeTab='enrolTab';
                } 
            }
            else{
                hideEnrolTabContent=false;
                hideEligibiltyTabContent=true; 
                hideContentTabContent=true;
                hideCustomdataTabContent=true; 
                hideTemplateTabContent=true;
                hideSharingTabContent =true; 
                activeTab='enrolTab';
            }
            
            allowSchemeEdit = false;
            if(schemeRecord != null){
                List<Scheme__c> scheme= WV_Utility.getSchemeDetails_New(schemeRecord.Id);
                if(scheme != null && scheme.size() == 1){
                    schemeRecord=scheme[0];
                    if(schemeRecord.active__c == false){
                        allowSchemeEdit=true;                        
                    }
                    else{
                        isActive=true;
                    }
                    if(schemeRecord.Term__c=='Open' && (selectedTab ==null || selectedTab.trim()=='')){
                        activeTab='eligiblilityTab';
                        hideEnrolTabContent=true;
                        hideEligibiltyTabContent=false;
                        hideContentTabContent=true;
                        hideCustomdataTabContent=true; 
                        hideTemplateTabContent=true;
                        hideSharingTabContent =true; 
                    }
                }
            }
        }
        Catch(Exception e){
            system.debug('****Exception inside Scheme Detail page construtor'+e.getlinenumber()+'-'+e.getmessage());
            exp=e;   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_Exception_Admin);
            ApexPages.addMessage(myMsg);
        }
    }
    
    public pageReference save(){
        try{
            errorResult='';
            allowSchemeEdit=false;
            wav_currency__c currencyRecord;
            
            wav_source__c sourceRecord=[select id,active__c from wav_source__c where id=:schemeRecord.source__c];
            deferral__c deferralRecord=[select id,active__c from deferral__c where id=:schemeRecord.deferral__c];
            
            if(schemeRecord.scheme_Currency__c != null){
                currencyRecord=[select id,active__c from wav_currency__c where id=:schemeRecord.scheme_Currency__c];
            }
            if(schemeRecord.description__c == null || schemeRecord.description__c.trim() == ''){
                schemeRecord.description__c.addError(Label.WV_Mandatory_Field);
                allowSchemeEdit=true;
            }
            else if(schemeRecord.description__c.length()> 300){
                schemeRecord.description__c.addError(Label.WV_SchemeCreation_LimitonDescription);
                allowSchemeEdit=true;
            }
            else{
                schemeRecord.description__c = schemeRecord.description__c;
            }
            
            //added recently.
            If(schemeRecord.Abacus_n__c != null){
                schemeRecord.Abacus__c='Yes';
            }
            else{
                schemeRecord.Abacus__c='No';
            }
            
            if(schemeRecord.active__c == true){
                if(sourceRecord != null && sourceRecord.active__c ==false){
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationSource);
                    ApexPages.addMessage(myMsg1);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationSource+' ';
                }
                if(deferralRecord != null && deferralRecord.active__c ==false){
                    ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationDeferral);
                    ApexPages.addMessage(myMsg2);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationDeferral+' ';
                }
                if(currencyRecord != null && currencyRecord.Id != null && currencyRecord.active__c ==false){
                    ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationCurrency);
                    ApexPages.addMessage(myMsg3);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationCurrency+' ';
                }
                
                if(schemeRecord.Term__c=='Fixed' && WV_Utility.getEnrolmentStatusforSchemeActivation(schemeRecord.Id)==false){
                    ApexPages.Message myMsg4 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationEnrolment);
                    ApexPages.addMessage(myMsg4);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationEnrolment+' ';
                }
                if(WV_Utility.getEligibiltyStatusforSchemeActivation(schemeRecord.Id)==false){
                    ApexPages.Message myMsg5 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationEligibility);
                    ApexPages.addMessage(myMsg5);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationEligibility+' ';
                }
                
                if(WV_Utility.getDescriptionContentStatusforSchemeActivation(schemeRecord.Id)==false){
                    ApexPages.Message myMsg6 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationDescription);
                    ApexPages.addMessage(myMsg6);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationDescription+' ';
                }
                
                if(WV_Utility.getIntroductionContentStatusforSchemeActivation(schemeRecord.Id)==false){
                    ApexPages.Message myMsg7 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationIntroduction);
                    ApexPages.addMessage(myMsg7);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationIntroduction+' ';
                }
                
                if(WV_Utility.getTermsandConditionStatusforSchemeActivation(schemeRecord.Id)==false){
                    ApexPages.Message myMsg8 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationTerms);
                    ApexPages.addMessage(myMsg8);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationTerms+' ';
                }
                
                if(WV_Utility.getEmailSubmissionStatusforSchemeActivation(schemeRecord.Id)==false){
                    ApexPages.Message myMsg8 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationEmailSubmit);
                    ApexPages.addMessage(myMsg8);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationEmailSubmit+' ';
                }
                
                if(WV_Utility.getEmailCancellationStatusforSchemeActivation(schemeRecord.Id)==false){
                    ApexPages.Message myMsg8 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationEmailCancellation);
                    ApexPages.addMessage(myMsg8);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationEmailCancellation+' ';
                }
                
                if(WV_Utility.getTemplate(schemeRecord.Id).size() == 0){
                    ApexPages.Message myMsg9 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDetails_ValidationTemplate);
                    ApexPages.addMessage(myMsg9);
                    errorResult=errorResult+Label.WV_SchemeDetails_ValidationTemplate+' ';
                }               
            }
            if(errorResult == ''  && schemeRecord.description__c != null && schemeRecord.description__c.trim() != '' && schemeRecord.description__c.length() <=300){
                schemeRecord.Last_updated_by__c=Userinfo.getuserId();
                schemeRecord.Last_updated_date__c=system.now();
                
                update  schemeRecord;
                if(schemeRecord.active__c == false){
                    allowSchemeEdit=true;
                }
                PageReference thePage = new PageReference('/apex/WV_SchemeDetails?Id='+schemeRecord.Id+'&tab='+activeTab);
                thePage.setRedirect( true );
                return thePage;
            }
            else if(errorResult != ''){
                allowSchemeEdit=true;
                return null;
            }
            else{
                allowSchemeEdit=true;
                return null;
            }
            
        } 
        catch( Exception e ){
            system.debug('****Exception inside Save()'+e.getlinenumber()+'-'+e.getmessage());            
            WV_Utility.captureException('My Elections','Scheme Detail page','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_Exception_Admin);
            ApexPages.addMessage(myMsg);
            return null;
        }       
    }    
    
   public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Employee facing UI Home page-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }    
    
    public pageReference enableSave(){
        return null;
    }    
    
    public pageReference deleteScheme(){
        try{
            string objecttype=string.ValueOf(schemeRecord.Id).substring(0,3);
            delete schemeRecord;
            pageReference pg=new Pagereference('/'+objecttype);
            pg.setredirect(true);
            return pg;
        }
        Catch(Exception e){
           if(e.getmessage().contains(Label.WV_SchemeActiveDelete)){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeActiveDelete);
               ApexPages.addMessage(myMsg);
               return null;
           }
           else if(e.getmessage().contains(Label.WV_SchemeDeleteonElections)){
               ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_SchemeDeleteonElections);
               ApexPages.addMessage(myMsg1);
               return null;
           }           
           system.debug('****Exception inside deleteScheme()'+e.getlinenumber()+'-'+e.getmessage());   
           WV_Utility.captureException('My Elections','Scheme Detail page -- > Deletescheme','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
           ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_Exception_Admin);
           ApexPages.addMessage(myMsg2);            
        }
        return null;
    }
    
     public list<selectoption> getAbacusValues(){
    
        List<selectoption> AbacusValuesLst=new List<selectoption>();
        AbacusValuesLst.add(new selectoption('','---Select---'));        
        try{            
            List<Abacus__c> AbacusValues=WV_Utility.getAbacusValues();
            if(AbacusValues != null && AbacusValues.size()>0){
                for(Abacus__c s:AbacusValues ){
                    AbacusValuesLst.add(new selectoption(s.Id,s.name));
                }
            }
        }
        Catch(Exception e){
            system.debug('****exception in getActiveSources()'+e.getmessage()+'--'+e.getlinenumber());
        }  
        return AbacusValuesLst;  
    }
}