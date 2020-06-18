public class WV_CustomdataController{
    
    public string ResultString {get; set;} 
    public attachment contentBody1 {get; set;}    
    public string contentName {get; set;}
    public Integer contentSize {get; set;}
    public string selectedSchemeId {get; set;}
    public Custom_Data_upload_file__c fileUploadRecord {get; set;}
    public List<Custom_Data_upload_file__c> CustomFileList;
    public List<CustomDataWrapper> fileWrapper {get; set;}
    public string selectedFile {get; set;}
    public string selectedLoadMethod {get; set;}
    public List<Scheme__c> schemeRecord {get; set;}
    public set<string> documentList;
    public Map<Integer,string> OrderMap;
    public string contentype{get; set;}
    public boolean showResults{get; set;}
    public boolean hideResults{get; set;}
    public boolean isBatchTriggered {get; set;}    
    public boolean showtableResults {get;set;}  
    public transient string inputContent;
    public string content1;    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public boolean showWarning{get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    
    public WV_CustomdataController() {
        try{
            showtableResults = false;
            showResults=false;
            hideResults=true;
            isBatchTriggered =false;
            string isStatusBarShow;
            customPageMessage=null;
            showWarning=false;
            
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;
            OrgName=Label.ORG_ENVIRONMENT; 
            
            selectedSchemeId = ApexPages.Currentpage().getParameters().get('Id');            
            isStatusBarShow= ApexPages.Currentpage().getParameters().get('isTriggered');
            if(isStatusBarShow != null && isStatusBarShow.trim() =='1'){
                isBatchTriggered=true;
            }
            
            fileUploadRecord =new Custom_Data_upload_file__c(); 
            if(selectedSchemeId != null && selectedSchemeId.trim() != ''){  
                CustomFileList = WV_Utility.getFileLoad(selectedSchemeId); 
                schemeRecord = WV_Utility.getSchemeDetails(selectedSchemeId); 
            }
            documentList=new set<string>();
            getFileWrapper();
            contentBody1=new attachment();
        }
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside Custom data file constructor'+e.getlinenumber()+'-'+e.getmessage()); 
        }
    }
    
    public List<selectoption> getLoadMethods(){
        List<selectoption> Lst=new List<selectoption>();
        Lst.add(new selectoption('Text','Text'));
        Lst.add(new selectoption('Table','Table'));    
        return Lst;
    }
        
    public void getFileWrapper(){ 
        
        Map<string,string> docs=new Map<string,string>();
        documentList.clear();            
        
        if(CustomFileList != null && CustomFileList.size() > 0){
            showtableResults = true;
            fileWrapper=new List<CustomDataWrapper>();
            for(Custom_Data_upload_file__c m:CustomFileList  ){
                documentList.add(m.Id);
            }            
            for(Attachment d:[select id,name,parentId from Attachment where parentId IN:documentList]){
                docs.put(d.parentId,d.Id);
            }            
            for(Custom_Data_upload_file__c m:CustomFileList  ){
                CustomDataWrapper c=new CustomDataWrapper();                
                c.Id=m.Id;
                c.Id15=string.ValueOf(m.Id).substring(0,15);
                c.name=m.name;
                c.fileType=m.File_Type__c;
                c.uploadedDate=Date.ValueOf(m.CreatedDate);
                c.uploadedBy=m.CreatedBy.Name;
                
                c.columnMappings=m.Columns__c;
                
                if(docs != null && docs.containsKey(m.Id)){
                    c.DocumentId=docs.get(m.Id);
                }
                fileWrapper.add(c);
            }
        }
    }
    
    public pageReference add(){
        Savepoint sp = Database.setSavepoint();
        isBatchTriggered =false;
        string[] eachCleanList;
        customPageMessage=null;
        showWarning=false;
        
        try{
            ResultString='';           
            List<AsyncApexJob> openJobs =WV_Utility.getPendingBatchJobsCustomData(null);
            if(openJobs != null && openJobs.size() < 5){
                List<AsyncApexJob> pendingBacthJobs=WV_Utility.getPendingBatchJobsCustomData('pending custom data');
                if(pendingBacthJobs != null && pendingBacthJobs.size() > 0){
                    customPageMessage=Label.WV_Eligibilty_Pending_BatchJob;
                    typeOfMessage='Error';
                    contentBody1.body =null;  
                    return null;
                }
            }
            else{
                customPageMessage=Label.WV_Eligibilty_BatchNotAllowed;
                typeOfMessage='Error';
                contentBody1.body =null;  
                return null;
            }
            if(selectedSchemeId == null || selectedSchemeId == ''){
                customPageMessage=Label.WV_Eligibility_No_Scheme;
                typeOfMessage='Error';                
                contentBody1.body =null;  
                return null;            
            } 
            else if(fileUploadRecord.Name == null || fileUploadRecord.Name == ''){
                customPageMessage=Label.WV_Customdata_No_FileName;
                typeOfMessage='Error';  
                contentBody1.body =null;  
                return null;            
            }
            else if(fileUploadRecord.Name.isAlphanumeric()==false){
                customPageMessage=Label.WV_Customdata_NoSpaceAllowed_Input;
                typeOfMessage='Error';  
                contentBody1.body =null;  
                return null;            
            }
            else if(selectedLoadMethod == null || selectedLoadMethod == ''){
                customPageMessage=Label.WV_Csutomdata_NO_FileType;
                typeOfMessage='Error';  
                contentBody1.body =null;  
                return null;                
            }     
            
            List<Custom_Data_upload_file__c> currentFiles=WV_Utility.checkUniquenessInFileLoad(selectedSchemeId,fileUploadRecord.Name);  

            if(currentFiles == null || currentFiles.size()>0){
                customPageMessage=Label.WV_Customdata_Unique_Filename;
                typeOfMessage='Error';  
                contentBody1.body =null;  
                return null; 
            }
            else if(contentBody1.body == null){
                customPageMessage=Label.WV_Eligibilty_No_File_Chossed;
                typeOfMessage='Error';  
                contentBody1.body =null;  
                return null;            
            }
            else if(contentName == null){
                customPageMessage=Label.WV_Eligibilty_No_File_Chossed;
                typeOfMessage='Error';  
                contentBody1.body =null;  
                return null;           
            }             
            else if(contentName.lastIndexOf('.') == -1){
                customPageMessage=Label.WV_Eligibilty_No_Extn;
                typeOfMessage='Error';  
                contentBody1.body =null;  
                return null;            
            }            
            else if(contentName.lastIndexOf('.') <> -1 && contentName.substring(contentName.lastIndexOf('.') + 1).toLowerCase() <> 'csv'){
                customPageMessage=Label.WV_Eligibilty_No_ValidExtn_Csv;
                typeOfMessage='Error';  
                contentBody1.body =null;              
                return null;
            }            
            else{                            
                Integer i=0;
                List<Wav_Custom_data__c> cList=new List<Wav_Custom_data__c>();
                OrderMap=new  Map<Integer,string>();
                List<Map<Integer,string>> AllList=new List<Map<Integer,string>>();
                Map<string,SobjectField> CustomdataFieldsMap=WV_Utility.getSObjectFieldsMap('Wav_Custom_data__c');
                Map<Integer,String> fieldMap=WV_Utility.getFileFieldMappings(); 
                               
                inputContent=contentBody1.body.toString();
                string[] filelines =new string[2]; 
                if(inputContent != null && inputContent.trim() !=''){
                    filelines[0] = inputContent.subString(0,inputContent.indexOf('\n'));
                    inputContent= inputContent.subString(inputContent.indexOf('\n') + '\n'.length(),inputContent.length());
                }
                else{
                    filelines[0]=null;
                }
                
                if(filelines[0] != null && inputContent.trim() != ''){
                    filelines[1] = inputContent.subString(0,inputContent.indexOf('\n'));
                }
                else{
                    filelines[1] =null;
                }
                
                fileUploadRecord.File_type__c=selectedLoadMethod;
                
                fileUploadRecord.Columns__c='';
                
                fileUploadRecord.Scheme__c=selectedSchemeId;
                
                if(filelines[0] != null){
                    eachCleanList=WV_Utility.getCleanFields(filelines[0].split(','));
                    if(eachCleanList.size() <= 26 && eachCleanList.size() > 1){
                        set<String> duplicateCheck=new set<string>();
                        for(string header:eachCleanList){
                            if(header != null && header.trim() != ''){
                                duplicateCheck.add(header);
                                if(i==0 && header.trim() != 'MSID'){
                                    customPageMessage=Label.WV_Eligibilty_No_MSIDfirst;
                                    typeOfMessage='Error';  
                                    contentBody1.body =null;  
                                    inputContent=null;
                                    return null;
                                }                         
                                if(fieldMap != null && fieldMap.containsKey(i)){
                                    header=header.replaceAll(',',' ').replaceAll('"',' ').trim();
                                    fileUploadRecord.Columns__c=fileUploadRecord.Columns__c+header+'->'+fieldMap.get(i)+',';
                                    OrderMap.put(i,fieldMap.get(i));                                
                                }
                                i++;
                            }
                            else{//Added to ensure the file uploaded has valid columns present.
                                customPageMessage=Label.WV_Custom_data_header_Duplicate;
                                typeOfMessage='Error';
                                contentBody1.body =null;  
                                inputContent=null;  
                                return null;
                            }
                        }
                        
                        //Added to check duplicates in header columns in csv files loaded..,
                        if(duplicateCheck.size() < eachCleanList.size()){
                            customPageMessage=Label.WV_Custom_data_header_Duplicate;
                            typeOfMessage='Error';
                            contentBody1.body =null;  
                            inputContent=null;  
                            return null;
                        }
                        
                        if(fileUploadRecord.Columns__c != '' && fileUploadRecord.Columns__c.endsWith(',')){
                            fileUploadRecord.Columns__c=fileUploadRecord.Columns__c.removeEnd(',');
                        }  
                                            
                    }
                    else{
                        customPageMessage=Label.WV_Customdata_No_of_columns_limit;
                        typeOfMessage='Error';  
                        contentBody1.body =null;  
                        inputContent=null;
                        return null;
                    }
                }
                else{
                    customPageMessage=Label.WV_Eligibilty_No_MSIDfirst;
                    typeOfMessage='Error'; 
                    contentBody1.body =null; 
                    inputContent=null; 
                    return null;
                }
                
                if(filelines[1] == null){
                    customPageMessage=Label.WV_Eligibility_No_Rows;
                    typeOfMessage='Error';                     
                    contentBody1.body =null; 
                    inputContent=null; 
                    return null;
                }
                else{                    
                    insert fileUploadRecord;
                }
                
                if(fileUploadRecord != null && fileUploadRecord.Id != null ){
                    contentBody1.name=contentName;
                    contentBody1.parentId=fileUploadRecord.Id;
                    contentBody1.description='Custom data file backup for downloading purpose.';
                    contentBody1.ContentType=contentype;
                    Insert contentBody1;
                    contentBody1.body =null;
                    contentBody1=new Attachment();
                }
                
                populateDataRows(0,800000);  
                //populateDataRows(0,50000);          
                  
                inputContent=null;  
                CustomFileList = WV_Utility.getFileLoad(selectedSchemeId); 
                getFileWrapper();                
                fileUploadRecord =new Custom_Data_upload_file__c();
                isBatchTriggered =true;
                
                if(schemeRecord != null && schemeRecord.size() >0 ){
                    schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                    schemeRecord[0].Last_updated_date__c=system.now();                
                    update  schemeRecord[0];  
                } 
            }
        }
        Catch(Exception e){
            Database.rollback(sp);
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            contentBody1.body =null;
            inputContent=null;    
            isBatchTriggered =false;
            system.debug('****Exception inside add'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Custom data tab-->add()','Exception Type : '+e.getTypeName()+'; <b>Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            return null;
        }
        PageReference homePage=new PageReference('/apex/WV_SchemeDetails?Id='+selectedSchemeId+'&tab=customdataTab&isTriggered=1');
        homePage.setRedirect(true);
        return homePage;
    }
    
    
    public pageReference deleteFile(){
       showtableResults = true;
       isBatchTriggered = false;
       customPageMessage=null;
       showWarning=false;
        
       try{
             if(selectedFile != null && selectedFile != ''){
                for(CustomDataWrapper c:fileWrapper ){ 
                    if(selectedFile == c.Id){     
                        List<Input_Controls_Mapping__c> referredControls=WV_Utility.getReferredInputControls(c.Id);
                        if(referredControls != null && referredControls.size() > 0){
                            customPageMessage=Label.WV_Cusomdata_deleteError;
                            typeOfMessage='Error';
                            return null;
                        }
                        update new Custom_Data_upload_file__c(Id=c.Id,scheme__c=null);
                        
                        if(schemeRecord != null && schemeRecord.size() >0 ){
                            schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                            schemeRecord[0].Last_updated_date__c=system.now();                
                            update  schemeRecord[0];  
                        } 
                        
                        //Related Attachment will delete automatically once parent record deleted. 
                        showtableResults = false;
                    }           
                }                
                CustomFileList = WV_Utility.getFileLoad(selectedSchemeId); 
                getFileWrapper();
                selectedFile=null;
                customPageMessage=Label.WV_Customdata_FileDeleted_Success;
                typeOfMessage='Info';
                showWarning=true;
            }
            else{
                showtableResults = true;
                customPageMessage=Label.WV_Customdata_FileNotChoosed;
                typeOfMessage='Error';
                return null;
            }
            
        }
        Catch(Exception e){
            showtableResults = true;
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside deleteFile'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureException('My Elections','Scheme Detail page->Custom data tab-->deleteFile()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }
        PageReference homePage=new PageReference('/apex/WV_SchemeDetails?Id='+selectedSchemeId+'&tab=customdataTab&isTriggered=0');
        homePage.setRedirect(true);
        return homePage;
    }
    
    
    public class CustomDataWrapper{
        public string Id {get; set;} 
        public string Id15 {get; set;}  
        public string Name {get; set;}   
        public string fileType{get; set;}   
        public date uploadedDate{get; set;} 
        public string uploadedBy{get; set;} 
        public string columnMappings {get; set;}
        public boolean isSelected{get; set;} 
        public string DocumentId {get; set;}
          
        public CustomDataWrapper(){
            this.isSelected=false;
        }
    }
    
    public void populateDataRows(Integer startIndx, Integer endIndx){
        boolean isEnded = false;                
        Integer conLength=0;
        Integer con1Length=0;
        ReadAndPopulateBatch batchProcess;
        WV_ReadAndPopulateBatch m ;  
        content1=null;                                
        
        conLength=inputContent.length();
        if(endIndx > conLength){
            endIndx = conLength;
            isEnded = true;         
        }
        
        content1 = inputContent.substring(startIndx, endIndx - 1);        
        
        if(content1.lastIndexOf('\n') != -1 && isEnded ==false){          
            content1 = content1.substring(0, content1.lastIndexOf('\n'));                       
        } 
        else if(content1.lastIndexOf('\n') != -1 && isEnded ==true){                    
            content1=content1;
        }
        
        con1Length=content1.length();
        
        startIndx =  startIndx + con1Length;
        endIndx = startIndx + 800000; 
        //endIndx = startIndx + 50000;     
        
        if(con1Length <> 0){
            List<AsyncApexJob> openJobs =WV_Utility.getPendingBatchJobsCustomData(null);
            if(openJobs != null && openJobs.size() < 5){
                batchProcess=new ReadAndPopulateBatch();
                batchProcess.m_csvFile=content1;                    
                batchProcess.OrderMap=OrderMap;
                batchProcess.fileId=fileUploadRecord.Id;
                Database.ExecuteBatch(batchProcess,200);
                batchProcess=null;
                openJobs=null; 
            } 
            else{
                Integer scheduleJobs=[SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
                system.debug('****scheduleJobs'+scheduleJobs);
                //if(scheduleJobs < 100){
                    m = new WV_ReadAndPopulateBatch (content1,fileUploadRecord.Id,OrderMap);
                    String sch = system.now().second()+' '+system.now().addminutes(1).minute()+' '+system.now().hour()+' '+system.now().day()+' '+system.now().month()+' ? '+system.now().year();
                    system.debug('****scheduled time'+sch);
                    string name='Custom data Job'+system.now()+system.now().millisecond();
                    String jobID = system.schedule(name, sch, m);
                    m=null;
                //}
            }                   
        }
        if(isEnded == false ){                                                         
            content1 = null;
            populateDataRows(startIndx, endIndx);    
        }
        else{
            inputContent=null;
        }
    }    
    
}