public with sharing class WV_SchemeExtension{

    public Scheme__c  scheme ;
    public Scheme__c  schemeObj         { set; get; }    
    public Boolean     errorFlg         { set; get; }
    public Boolean    isAbacusEnabled   { set; get; }
    public string cancelUrl             { get; set;}
    public boolean errorFlag {get; set;}
    public string DescriptionError {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    public exception exp{get; set;} 
    public string sourceError {get; set;}
    public string deferralError {get; set;}
    public string currencyError {get; set;}
    public string abacusError {get; set;}

    public WV_schemeExtension( ApexPages.StandardController stdController ){     
        try{ 
            this.errorFlg = false;  
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;            
            OrgName=Label.ORG_ENVIRONMENT;             
            cancelUrl='';
            sourceError=null;
            deferralError =null;
            currencyError =null;
            abacusError =null;             
            this.schemeObj = new Scheme__c();
            this.errorFlg = false;
            cancelUrl = ApexPages.Currentpage().getParameters().get('retURL');
            isAbacusEnabled =false;         
            DescriptionError =null;          
        }         
        Catch(Exception e){
            errorFlag=true;
            system.debug('****exception in WV_schemeExtension constructor'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
        }
             
    }
    
    public list<selectoption> getActiveSources(){
    
        List<selectoption> activeSourceLst=new List<selectoption>();
        activeSourceLst.add(new selectoption('','---None---'));               
        try{            
            List<wav_source__c> activesources=WV_Utility.getActiveSources();
            if(activesources != null && activesources.size()>0){
                for(wav_source__c s:activesources ){
                    activeSourceLst.add(new selectoption(s.Id,s.name));
                }
            }
        }
        Catch(Exception e){
            system.debug('****exception in getActiveSources()'+e.getmessage()+'--'+e.getlinenumber());
        }  
        return activeSourceLst;  
    }
    
     public list<selectoption> getActiveDeferrals(){
    
        List<selectoption> activeDeferralsLst=new List<selectoption>();
        activeDeferralsLst.add(new selectoption('','---None---'));        
        try{            
            List<deferral__c> activedeferrals=WV_Utility.getActiveDeferrals();
            if(activedeferrals != null && activedeferrals.size()>0){
                for(deferral__c s:activedeferrals ){
                    activeDeferralsLst.add(new selectoption(s.Id,s.name));
                }
            }
        }
        Catch(Exception e){
            system.debug('****exception in getActiveSources()'+e.getmessage()+'--'+e.getlinenumber());
        }  
        return activeDeferralsLst;  
    }
    
    public list<selectoption> getActiveCurrencies(){
    
        List<selectoption> activeCurrenciesLst=new List<selectoption>();
        activeCurrenciesLst.add(new selectoption('','---None---'));        
        try{            
            List<wav_currency__c > activedcurrencies=WV_Utility.getActiveCurrencies();
            if(activedcurrencies != null && activedcurrencies.size()>0){
                for(wav_currency__c s:activedcurrencies ){
                    activeCurrenciesLst.add(new selectoption(s.Id,s.name));
                }
            }
        }
        Catch(Exception e){
            system.debug('****exception in getActiveSources()'+e.getmessage()+'--'+e.getlinenumber());
        }  
        return activeCurrenciesLst;  
    }
    
    public list<selectoption> getAbacusValues(){
    
        List<selectoption> AbacusValuesLst=new List<selectoption>();
        AbacusValuesLst.add(new selectoption('','---None---'));        
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
    
    public pageReference save(){
        try{  
            errorFlag =false;      
            sourceError=null;
            deferralError =null;
            currencyError =null;
            abacusError =null;               
            scheme = new Scheme__c();
            
            if(this.schemeObj.name == null || this.schemeObj.name.trim() == ''){
                this.schemeObj.name.addError(Label.WV_Mandatory_Field);        
            }
            else if(this.schemeObj.name.isAlphanumericSpace()==false){
                this.schemeObj.name.addError(Label.WV_Scheme_ValidName);        
            }
            else{
                scheme.name=this.schemeObj.name; 
            } 
            
            if(this.schemeObj.abacus__c == null || this.schemeObj.abacus__c.trim() == ''){
                this.schemeObj.abacus__c.addError(Label.WV_Mandatory_Field);        
            }
            else{
                scheme.abacus__c = this.schemeObj.abacus__c; 
            } 
            
            if(this.schemeObj.Term__c == null || this.schemeObj.Term__c.trim() == ''){
                this.schemeObj.Term__c.addError(Label.WV_Mandatory_Field);        
            }
            else{
                scheme.Term__c =   this.schemeObj.Term__c; 
            } 
            
            if(this.schemeObj.source__c == null){
                sourceError=Label.WV_Mandatory_Field;        
            }
            else{
                scheme.source__c = this.schemeObj.source__c;
            }   
            
            if(this.schemeObj.deferral__c == null){
                deferralError=Label.WV_Mandatory_Field;      
            }
            else{
                scheme.deferral__c= this.schemeObj.deferral__c;
            }      
            
            if(this.schemeObj.description__c == null || this.schemeObj.description__c.trim() == ''){
                this.schemeObj.description__c.addError(Label.WV_Mandatory_Field);     
            }
            else if(this.schemeObj.description__c.length()> 300){
                this.schemeObj.description__c.addError(Label.WV_SchemeCreation_LimitonDescription);     
            }
            else{
                scheme.description__c = this.schemeObj.description__c;
            }
            
            if(isAbacusEnabled == true){
                if( this.schemeObj.scheme_Currency__c == null && this.schemeObj.Abacus_n__c != null ){
                    currencyError =Label.WV_Mandatory_Field;      
                    return null;
                }
                else if(this.schemeObj.scheme_Currency__c != null && this.schemeObj.Abacus_n__c == null){
                    abacusError =Label.WV_Mandatory_Field;      
                    return null;
                }
                else if(this.schemeObj.scheme_Currency__c == null && this.schemeObj.Abacus_n__c == null){
                    currencyError =Label.WV_Mandatory_Field;      
                    abacusError =Label.WV_Mandatory_Field;      
                    return null;
                }                
                scheme.scheme_Currency__c = this.schemeObj.scheme_Currency__c;
                scheme.Abacus_n__c= this.schemeObj.Abacus_n__c;
            }
            else{             
                 scheme.scheme_Currency__c = this.schemeObj.scheme_Currency__c;            
            }
            
            if(( ((this.schemeObj.description__c == null || this.schemeObj.description__c.trim() =='')||(this.schemeObj.description__c.length()> 300)) || (this.schemeObj.name==null || this.schemeObj.name.trim()=='' || this.schemeObj.name.isAlphanumericSpace()==false) || (this.schemeObj.abacus__c==null || this.schemeObj.abacus__c.trim()=='') || (this.schemeObj.Term__c==null || this.schemeObj.Term__c.trim()=='') || (sourceError != null) || (deferralError!=null)) && ( (isAbacusEnabled ==true && scheme.Abacus_n__c != null) || (isAbacusEnabled ==false))){
                return null;
            }
            
            scheme.Last_updated_by__c=Userinfo.getuserId();
            scheme.Last_updated_date__c=system.now();
            
            insert  this.scheme;
            PageReference thePage = new PageReference( '/' +scheme.Id);
            thePage.setRedirect( true );
            return thePage;
        } 
        catch( Exception e ){
            if(e.getmessage().contains('Duplicate')){
                this.schemeObj.name.addError(Label.WV_SchemeCreationDuplicateName);
            }
            else{                
                errorFlag =true;
                system.debug('****Exception inside getContentTypes'+e.getlinenumber()+'-'+e.getmessage());            
                WV_Utility.captureException('My Elections','Scheme Creation page --> save()','Exception Type :'+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
            return null;
        }
      
    }
    
    public PageReference cancel(){
        errorFlag =false;
        try{
            PageReference thePage = new PageReference( '/'+cancelUrl);
            thePage.setRedirect( true );
            return thePage;
        }
        Catch(Exception e){
            system.debug('****exception in cancel()'+e.getmessage()+'-'+e.getlinenumber());
            WV_Utility.captureException('My Elections','Scheme Creation page --> cancel()','Exception Type :'+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            errorFlag =true;
        }  
        return null;  
    }
    
    public pageReference displayAbacusCheck(){
        errorFlag =false;
        try{
            abacusError=null;
            currencyError=null;
            sourceError=null;
            deferralError=null;
            
            if(schemeObj.Abacus__c == 'Yes'){        
                isAbacusEnabled  = true;            
            }
            else{
                isAbacusEnabled  = false;
            }        
        }
        Catch(Exception e){
            system.debug('****exception in displayAbacusCheck()'+e.getmessage()+'-'+e.getlinenumber());
            WV_Utility.captureException('My Elections','Scheme Creation page --> displayAbacusCheck()','Exception Type :'+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            errorFlag =true;
        } 
        return null;
    }   
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){  
                 WV_Utility.captureException('My Elections','Scheme Creation Page-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }   

}