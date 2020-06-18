public class WV_TemplateAssignmentController {

    public string selectedSchemeId {get; set;}
    public string selectedTemplate {get; set;}
    public List<Scheme__c> schemeRecord {get; set;}
    public Map<string,String> templateMap;
    public boolean hideTemplateselection {get; set;}
    public List<Input_Controls_Mapping__c> inputControls {get; set;}
    public List<inputControlsWrapper> controlList {get; set;}
    public Map<String,Custom_Data_upload_file__c> files;    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    Public boolean isRequiredEnabled {get; set;}
    public boolean isListORValueCapturePresent {get; set;}    
    
    public WV_TemplateAssignmentController(){
        
        try{
            hideTemplateselection=false;        
            customPageMessage=null;   
            selectedTemplate =null;
            isRequiredEnabled =false;
            files=null; 
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;            
            OrgName=Label.ORG_ENVIRONMENT;
             
            selectedSchemeId = ApexPages.Currentpage().getParameters().get('Id');                   
            
            if(selectedSchemeId != null && selectedSchemeId != ''){
                schemeRecord = WV_Utility.getSchemeDetails(selectedSchemeId);
                List<election__c> elections=WV_Utility.getSchemeOpenStatus(selectedSchemeId);
                templateMap=WV_Utility.getValidTemplates();
                if(schemeRecord != null && schemeRecord.size() ==1){                  
                    if(elections != null && elections.size()>0){
                        hideTemplateselection=true;   
                    }                  
                    if(schemeRecord[0].Waiver_Template__c != null){
                        selectedTemplate = schemeRecord[0].Waiver_Template__c;   
                        getInputcontrols(); 
                    }   
                    else{
                        controlList=new List<inputControlsWrapper>();
                        selectedTemplate=null;
                    }         
                }
            }
        }
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside WV_TemplateAssignmentController() constructor'+e.getlinenumber()+'-'+e.getmessage());       
        }        
    }
    
     public List<selectoption> getTemplates(){
        try{
            List<selectoption> Lst=new List<selectoption>();
            Lst.add(new selectoption('','---Select---'));
            if(templateMap != null && templateMap.keyset() != null && templateMap.keyset().size() >0){
                for(string temp:templateMap.keyset()){
                    Lst.add(new selectoption(temp,templateMap.get(temp)));
                } 
            }   
            return Lst;
        }
        Catch(Exception e){
            system.debug('****Exception inside getTemplates()'+e.getlinenumber()+'-'+e.getmessage());   
        }
        return null;
    } 
    
    public pageReference queryinputControls(){
        try{
            customPageMessage=null;
            getInputcontrols();
            if(customPageMessage != null){
                return null;
            }
        }
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside queryinputControls()'+e.getlinenumber()+'-'+e.getmessage());
            WV_Utility.captureException('My Elections','Scheme Detail page->Templates tab-->queryinputControls()','Exception Type : '+e.getTypeName()+'; Exception message:'+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }    
        return null;     
    }

    public Void getInputcontrols(){
        customPageMessage=null;
        List<selectoption> listcapturesList=new List<selectoption>();
        listcapturesList.add(new selectoption('','---select---'));
        isListORValueCapturePresent=false;
        
        if(selectedTemplate != null && selectedTemplate != ''){
            inputControls = WV_Utility.getInputControls(selectedTemplate,selectedSchemeId);
            if(inputControls != null && inputControls.size() > 0){                   
                files=WV_Utility.getFileRecords(selectedSchemeId);
                List<selectoption> filesList=new List<selectoption>();
                filesList.add(new selectoption('','---select---'));
                if(files != null && files.keyset().size() > 0){
                    for(String f:files.keySet()){
                        filesList.add(new selectoption(f,files.get(f).name));                
                    }      
                }  
                controlList=new List<inputControlsWrapper>();
                for(Input_Controls_Mapping__c I:inputControls){
                    if(I.Input_Control_Type__c=='Value Capture' || I.Input_Control_Type__c=='List Capture'){
                        isListORValueCapturePresent=true;
                    }
                    inputControlsWrapper input=new inputControlsWrapper(this);
                    input.inputControl=I;
                    input.fileList_min=filesList;
                    input.fileList_max=filesList;
                    input.filesMap=files;
                    if(I.Custom_Min__c != null && I.Custom_Min__c != ''){
                        input.fileName_min=I.Custom_Min__c.split(',')[0];  
                        input.columnName_min=I.Custom_Min__c.split(',')[1];                                                         
                    }
                    if(I.Custom_Max__c != null && I.Custom_Max__c != ''){
                        input.fileName_max=I.Custom_Max__c.split(',')[0];  
                        input.columnName_max=I.Custom_Max__c.split(',')[1];                          
                    }                        
                    if(I.Input_control_type__c=='List Capture' && I.Id != null){
                        listcapturesList.add(new selectoption(I.Id,I.name));
                    }
                    if(I.Input_control_type__c=='Value Capture'){
                        if(I.Controlling_Field__c != null && I.Dependencies_Mapping__c != null && I.Dependencies_Mapping__c.trim() !=''){
                            for(String s1:I.Dependencies_Mapping__c.split(';')){
                                string val=s1.substring(s1.indexof('-')+1);
                                if(val==''){
                                    val='No Validation';
                                }
                                input.mapControls.put(s1.substring(0,s1.indexof('-')),val);
                                if(val =='Number'){
                                  input.shownumber=true; 
                                }  
                                if(val =='Number' || val =='Percentage'){
                                  input.showCurrencyCodeCheckbox=true; 
                                } 
                            }
                        }
                    }
                    controlList.add(input);
                }
                for(inputControlsWrapper Ins:controlList){
                    if(Ins.inputControl.Input_control_type__c=='Value Capture'){
                        Ins.listcapturesList=listcapturesList;
                    }
                }
                if(isListORValueCapturePresent==false){
                    customPageMessage=Label.WV_Template_ValidationOnOneListORValueCaptureControls;
                    typeOfMessage='Error';
                    controlList.clear();
                }
            }
            else{
                customPageMessage=Label.WV_Template_TEMPLATE_NON_CONFIGURED;
                typeOfMessage='Error';
                controlList.clear();               
            }
        }
        else{
            controlList.clear();
        } 
    }
    
    public class inputControlsWrapper{
        public Input_Controls_Mapping__c inputControl {get; set;}        
        public string fileName_min {get; set;}
        public string columnName_min {get; set;}           
        public string fileName_max {get; set;}
        public string columnName_max {get; set;}               
        public List<selectOption> fileList_min {get; set;}
        public List<selectOption> fileList_max {get; set;}
        public Map<String,Custom_Data_upload_file__c> filesMap;        
        public string errorMessage{get; set;}     
        private List<OrgWideEmailAddress> org;
        public List<selectoption> listcapturesList{get; set;}
        public string selectedParentValue {get; set;}
        public string selectedChildValue {get; set;}
        public WV_TemplateAssignmentController outerclass {get; set;}
        public map<string,string> mapControls {get; set;}
        public string RemovalValue {get; set;}
        public boolean shownumber {get; set;}
        public string MapError {get; set;}
        public List<selectoption> DynamicList1{get; set;}
        public boolean showCurrencyCodeCheckbox {get; set;}
        
        public boolean getshowMappings(){
            try{
                if(mapControls != null && mapControls.keyset() != null && mapControls.keyset().size()>0){
                    return true;
                }
                return false;
            }
            Catch(Exception e){
                system.debug('****Exception inside getshowMappings() constructor'+e.getlinenumber()+'-'+e.getmessage());       
            } 
            return false;
        }
        
        public inputControlsWrapper(WV_TemplateAssignmentController parentClass){
            errorMessage=null;
            org=WV_Utility.getOrgWideAddressExceptions();
            outerclass=parentClass;
            mapControls=new map<string,string>();
            shownumber=false;
            MapError=null;
            showCurrencyCodeCheckbox=false;
        }
        
        public List<selectOption> getColoumnList_min(){
            try{
                List<selectoption> Lst=new List<selectoption>();
                Lst.add(new selectoption('','---select---'));
                if(filesMap != null && filesMap.containsKey(fileName_min)){                    
                    if(filesMap.get(fileName_min).Columns__c != null && filesMap.get(fileName_min).Columns__c != '' && filesMap.get(fileName_min).Columns__c.split(',').size()>0){
                        for(string s:filesMap.get(fileName_min).Columns__c.split(',')){
                            Lst.add(new selectoption(s.split('->')[1],s.split('->')[0]));
                        }
                    }
                    
                }   
                return Lst;
            }   
            Catch(Exception e){
                errorMessage=PAGE_ERROR;
                system.debug('****Exception inside getColoumnList_min()'+e.getlinenumber()+'-'+e.getmessage()); 
            }             
            return null;  
        }
        
        public List<selectoption> getDynamicList(){
            List<selectoption> Lst=new List<selectoption>();
            Lst.add(new selectoption('','---select---'));
            string s1;
            try{                
                if(inputControl.Controlling_Field__c != null){
                    for(inputControlsWrapper c:outerclass.controlList){
                        if(c.inputControl.Id==inputControl.Controlling_Field__c){
                           for(string s:c.inputControl.Custom_Data_Values__c.split('\n')){
                                s1=null;
                                if(s != null && s != ''){
                                    s1=s.normalizespace();
                                }
                                if(mapControls !=null && s1 != null && s1 != '' && !mapControls.containsKey(s1) ){
                                    Lst.add(new selectOption(s1,s1));
                                }
                            } 
                        }
                    }               
                }                 
            } 
            Catch(Exception e){
                errorMessage=PAGE_ERROR;
                system.debug('****Exception inside getDynamicList()'+e.getlinenumber()+'-'+e.getmessage()); 
            } 
            return lst;    
        }
        
        public pagereference makeResetonList(){
            try{  
                errorMessage=null;
                mapControls.clear(); 
                shownumber=false;
                showCurrencyCodeCheckbox=false;       
            }
            Catch(Exception e){
                errorMessage=PAGE_ERROR;
                system.debug('****Exception inside makeResetonList()'+e.getlinenumber()+'-'+e.getmessage()); 
                WV_Utility.captureException('My Elections','Scheme Detail page->Templates tab-->makeResetonList()','Exception Type : '+e.getTypeName()+'; Exception message:'+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),outerclass.currentPageURL,outerclass.OrgName,null,userinfo.getuserId());
            } 
            return null; 
        }
        
        public List<selectOption> getColoumnList_max(){
            List<selectoption> Lst=new List<selectoption>();
            Lst.add(new selectoption('','---select---'));
            try{                
                if(filesMap != null && filesMap.containsKey(fileName_max)){
                    
                    if(filesMap.get(fileName_max).Columns__c != null && filesMap.get(fileName_max).Columns__c != '' && filesMap.get(fileName_max).Columns__c.split(',').size()>0){
                        for(string s:filesMap.get(fileName_max).Columns__c.split(',')){
                            Lst.add(new selectoption(s.split('->')[1],s.split('->')[0]));
                        }
                    }
                    
                }                       
            } 
            Catch(Exception e){
                errorMessage=PAGE_ERROR;
                system.debug('****Exception inside getColoumnList_max()'+e.getlinenumber()+'-'+e.getmessage()); 
            } 
            return Lst;             
        }  
        
        public pageReference addme(){
            try{  
                MapError=null;
                errorMessage=null;
                if(selectedParentValue != null){
                    mapControls.put(selectedParentValue,selectedChildValue);
                    if(selectedChildValue =='Number'){
                      shownumber=true; 
                    }       
                    if(selectedChildValue =='Percentage' || selectedChildValue =='Number'){
                        showCurrencyCodeCheckbox=true;
                    }  
                }
                else{
                    MapError=Label.WV_Homepage_Error_MandatoryList;
                }
            }
            Catch(Exception e){
                errorMessage=PAGE_ERROR;
                system.debug('****Exception inside addme()'+e.getlinenumber()+'-'+e.getmessage()); 
                WV_Utility.captureException('My Elections','Scheme Detail page->Templates tab-->addme()','Exception Type : '+e.getTypeName()+'; Exception message:'+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),outerclass.currentPageURL,outerclass.OrgName,null,userinfo.getuserId());
            } 
            return null;
        }
        
        public pageReference removeit(){
            try{
                errorMessage=null;
                if(RemovalValue != null && RemovalValue != null && mapControls.containsKey(RemovalValue)){
                    mapControls.remove(RemovalValue);
                    shownumber=false;
                    showCurrencyCodeCheckbox=false; 
                    for(string d:mapControls.values()){
                        if(d=='Number'){
                            shownumber=true;     
                        }
                        if(d=='Number' || d=='Percentage'){
                            showCurrencyCodeCheckbox=true; 
                        }
                    }
                }
            }     
            Catch(Exception e){
                errorMessage=PAGE_ERROR;
                system.debug('****Exception inside addme()'+e.getlinenumber()+'-'+e.getmessage()); 
                WV_Utility.captureException('My Elections','Scheme Detail page->Templates tab-->removeit()','Exception Type : '+e.getTypeName()+'; Exception message:'+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),outerclass.currentPageURL,outerclass.OrgName,null,userinfo.getuserId());
            } 
            return null;
        }

    }
    
    public PageReference submit(){
    
        Savepoint sp = Database.setSavepoint();
        customPageMessage=null;
        isRequiredEnabled=false;
        Integer PrimaryControls=0;
        customPageMessage='';
        
        try{
            List<selectoption> listcapturesList=new List<selectoption>();
            listcapturesList.add(new selectoption('','---select---'));
            
            if(schemeRecord != null && schemeRecord.size() ==1 && schemeRecord[0].Waiver_Template__c ==null && (selectedTemplate == null  || selectedTemplate =='')){
                customPageMessage=Label.WV_Template_NO_TEMPLATE_SELECTED;
                typeOfMessage='Error';
                controlList.clear();
                return null;
            }
            else if(schemeRecord != null && schemeRecord.size() ==1 && schemeRecord[0].Waiver_Template__c != null && (selectedTemplate == null  || selectedTemplate =='')){
                //delete previous input control records...
                List<Input_Controls_Mapping__c> previousInputcontrols01=WV_Utility.getInputControls(schemeRecord[0].Waiver_Template__c,schemeRecord[0].Id);
                if(previousInputcontrols01 != null && previousInputcontrols01.size() > 0 && previousInputcontrols01[0].scheme__c != null){
                    delete previousInputcontrols01;
                }   
                if(schemeRecord != null && schemeRecord.size() >0){
                    schemeRecord[0].Waiver_Template__c=null;
                    schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                    schemeRecord[0].Last_updated_date__c=system.now();                
                    update  schemeRecord[0];  
                } 
                customPageMessage=Label.WV_TemplateAssignment_TemplateRemoval;
                typeOfMessage='Info';
                return null; 
            }
            
            List<Input_Controls_Mapping__c> updatedInputControlList=new List<Input_Controls_Mapping__c>();
            if(controlList != null && controlList.size() >0){
                for(inputControlsWrapper wrap:controlList){
                    if(wrap.inputControl.required__c==true){
                        isRequiredEnabled=true; 
                    } 
                    
                    if(wrap.inputControl.Control_Visibility__c=='Primary'){
                        PrimaryControls=PrimaryControls+1;
                    }
                    
                    wrap.errorMessage='';
                    if(wrap.inputControl.Input_control_type__c=='Value Capture'){
                        if(wrap.inputControl.Value_Type__c == 'Number' || wrap.shownumber==true){              
                            if(wrap.fileName_min != '' && wrap.fileName_min != null && (wrap.columnName_min == '' || wrap.columnName_min==null )){
                                wrap.errorMessage =wrap.errorMessage+' '+Label.WV_Template_NoCustomColumnSelected;
                            }
                            if(wrap.fileName_max != '' && wrap.fileName_max != null && (wrap.columnName_max == '' || wrap.columnName_max==null )){
                                wrap.errorMessage =wrap.errorMessage+' '+Label.WV_Template_NoCustomColumnSelected_Custom_Max;
                            }
                            
                            if(wrap.fileName_min != '' && wrap.columnName_min != '' && wrap.fileName_min != null && wrap.columnName_min != null){
                                wrap.inputControl.Custom_Min__c=wrap.fileName_min+','+wrap.columnName_min;
                            }   
                            else{
                                wrap.inputControl.Custom_Min__c=null;
                            }
                            
                            if(wrap.fileName_max != '' && wrap.columnName_max != '' && wrap.fileName_max != null && wrap.columnName_max != null){
                                wrap.inputControl.Custom_max__c=wrap.fileName_max+','+wrap.columnName_max;
                            }
                            else{
                                wrap.inputControl.Custom_max__c=null;
                            }
                            
                            if(wrap.inputControl.Default_Minimum_Value__c == null){
                                wrap.errorMessage=wrap.errorMessage+' '+Label.WV_Template_NoDefaultMin;
                            }
                            if(wrap.inputControl.Default_Maximum_Value__c == null){
                                wrap.errorMessage=wrap.errorMessage+' '+Label.WV_Template_NoDefaultMax;
                            }                    
                            if((wrap.inputControl.Default_Maximum_Value__c != null && wrap.inputControl.Default_Maximum_Value__c != null ) && ( (wrap.inputControl.Default_Minimum_Value__c <= 0) || (wrap.inputControl.Default_Maximum_Value__c <= 0) || ( wrap.inputControl.Default_Minimum_Value__c >= wrap.inputControl.Default_Maximum_Value__c ) )){
                                wrap.errorMessage=wrap.errorMessage+' '+Label.WV_Template_Validation_DefaultMin_Max;
                            }
                        }
                        else{
                            wrap.inputControl.Default_Minimum_Value__c=null;
                            wrap.inputControl.Default_Maximum_Value__c=null;
                            wrap.inputControl.Custom_Min__c=null;
                            wrap.inputControl.Custom_max__c=null; 
                        }
                        if(wrap.inputControl.Controlling_Field__c != null){
                            if(wrap.mapControls != null && wrap.mapControls.keyset() != null && wrap.mapControls.keyset().size()>0){
                                wrap.inputControl.Dependencies_Mapping__c='';                                
                                for(inputControlsWrapper wrap1:controlList){
                                    if(wrap1.inputControl.Id==wrap.inputControl.Controlling_Field__c){
                                        string dummy1=wrap1.inputControl.Custom_Data_Values__c.replaceAll('\r\n','\n');
                                        List<string> allList1=dummy1.split('\n');
                                        for(string s:wrap.mapControls.keyset()){
                                            boolean myflag=true;
                                            for(string s1:allList1){
                                                if(s.normalizespace()==s1.normalizespace()){
                                                    myflag=false;
                                                }
                                            } 
                                            if(myflag==true){
                                                wrap.errorMessage=wrap.errorMessage+' '+Label.WV_Template_InvalidMapping;
                                                break;
                                            }
                                        }
                                        break;
                                    }
                                }
                                for(string s:wrap.mapControls.keyset()){
                                    string val=wrap.mapControls.get(s);
                                    if(val=='No Validation'){
                                        val='';
                                    }
                                    wrap.inputControl.Dependencies_Mapping__c=wrap.inputControl.Dependencies_Mapping__c+s+'-'+val+';';
                                }
                            }
                            else{
                                wrap.inputControl.Dependencies_Mapping__c='';
                            }
                        }
                        else{
                            wrap.inputControl.Dependencies_Mapping__c=null;
                        }
                        if(wrap.inputControl.Value_Type__c != 'Number' && wrap.shownumber==false){
                            wrap.inputControl.Show_Currency__c=false;
                        }                        
                    }                
                    
                    if( (wrap.inputControl.Input_control_type__c=='List Capture' || wrap.inputControl.Input_control_type__c=='Multi Value Option Capture') && ( wrap.inputControl.Custom_Data_Values__c == null || wrap.inputControl.Custom_Data_Values__c.trim() == '') ){
                        wrap.errorMessage =wrap.errorMessage+' '+Label.WV_Template_dateValuesBlank;
                    }                
                    else if(wrap.inputControl.Input_control_type__c=='List Capture' || wrap.inputControl.Input_control_type__c=='Multi Value Option Capture'){
                        string dummy=wrap.inputControl.Custom_Data_Values__c.replaceAll('\r\n','\n');
                        List<string> allList=dummy.split('\n');
                        set<string> allSet=new set<string>(allList);
                        if(allList.size() != allSet.size()){
                            wrap.errorMessage =wrap.errorMessage+' '+Label.WV_Template_Duplicate;
                        }            
                    }
                    if(wrap.inputControl.Input_control_type__c=='Multi Value Option Capture' && ( wrap.inputControl.Description__c == null || wrap.inputControl.Description__c == '') ){
                        wrap.errorMessage =wrap.errorMessage+' '+Label.WV_Tempalte_MissingDescription;
                    }
                    else if(wrap.inputControl.Input_control_type__c=='Multi Value Option Capture' && wrap.inputControl.Description__c != null && wrap.inputControl.Description__c != '' && wrap.inputControl.Description__c.length() > 1000 ){
                        wrap.errorMessage =wrap.errorMessage+' '+Label.WV_Tempalte_LimitDescription;
                    }
                    
                    if(wrap.inputControl.Input_control_type__c=='Multi Value Option Capture' && wrap.inputControl.Control_Visibility__c=='Primary'){
                        wrap.errorMessage =wrap.errorMessage+' '+Label.WV_TemplateValidationOnPrimaryControlsForMultiList;
                    }
                                    
                    wrap.inputControl.Scheme__c=selectedSchemeId; 
                    if(wrap.errorMessage!=null && wrap.errorMessage.trim() == ''){
                        updatedInputControlList.add(wrap.inputControl); 
                         
                    }                    
                }                
                
                if(isRequiredEnabled==false){
                    customPageMessage=customPageMessage+' '+Label.WV_Template_ValidateMinOneControl;
                    typeOfMessage='Error';
                }
                
                if(PrimaryControls == 0){
                    customPageMessage=customPageMessage+' '+Label.WV_Template_ValidationonNullPrimaryControls;
                    typeOfMessage='Error';
                }
                else if(PrimaryControls > 1){
                    customPageMessage=customPageMessage+' '+Label.WV_Template_ValidationOnMorePrimaryControls;
                    typeOfMessage='Error';                     
                }
                
                if(customPageMessage != null && customPageMessage != '' && typeOfMessage=='Error'){
                    return null;   
                }
                
                if(schemeRecord != null && schemeRecord.size() ==1 && schemeRecord[0].Waiver_Template__c != null && schemeRecord[0].Waiver_Template__c != selectedTemplate && updatedInputControlList.size() == controlList.size() ){
                    //delete previous input control records...
                    List<Input_Controls_Mapping__c> previousInputcontrols=WV_Utility.getInputControls(schemeRecord[0].Waiver_Template__c,schemeRecord[0].Id);
                    if(previousInputcontrols != null && previousInputcontrols.size() > 0 && previousInputcontrols[0].scheme__c != null){
                        delete previousInputcontrols;
                    }                                          
                }     
                
                if(updatedInputControlList.size() == controlList.size()){
                    upsert updatedInputControlList;                       
                    
                    if(schemeRecord != null && schemeRecord.size() >0 ){
                        schemeRecord[0].Waiver_Template__c=selectedTemplate;
                        schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                        schemeRecord[0].Last_updated_date__c=system.now();                
                        update  schemeRecord[0];  
                    } 
                    
                    if(controlList != null && controlList.size() >0){
                        for(inputControlsWrapper IntCont:controlList){
                            if(IntCont.inputControl.Input_control_type__c=='List Capture'){
                                listcapturesList.add(new selectoption(IntCont.inputControl.Id,IntCont.inputControl.name));
                            }
                        }
                        for(inputControlsWrapper IntCont1:controlList){
                            if(IntCont1.inputControl.Input_control_type__c=='Value Capture'){
                                IntCont1.listcapturesList=listcapturesList;
                            }
                        }
                    }
                
                    customPageMessage=Label.WV_Template_TEMPLATE_SUCCESS;
                    typeOfMessage='Info';                    
                }  
               
            }
            else{
                customPageMessage=Label.WV_Template_TEMPLATE_NON_CONFIGURED;
                typeOfMessage='Error';
                controlList.clear();
                return null;  
            }                
        }
        Catch(Exception e){
            Database.rollback(sp);
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside submit()'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Templates tab-->submit()','Exception Type : '+e.getTypeName()+'; Exception message:'+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }
        
        return null;
    }
    
    public pageReference showdependency(){        
        return null;
    }
    
}