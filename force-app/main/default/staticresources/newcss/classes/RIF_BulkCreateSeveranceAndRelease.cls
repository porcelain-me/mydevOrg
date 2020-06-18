//07/01/2013 RA: Created for bulk creation of S&R records via uploading csv files.
//
//

public class RIF_BulkCreateSeveranceAndRelease {
    
    //public string selectedRegion{get;set;}
    public transient blob fileContent {get;set;}
    public transient string fileName {get;set;}
    public String successResult{get;set;}
    public String failedResult{get;set;}
    public Set<String> errMessageList{get;set;}
    public map<string,Severance_And_Release__c> rows{get;set;}
    public boolean isUploaded{get;set;}
    public boolean isCreatedUpdated{get;set;}
    public List<csvWrapper> csvWSuccessList{get;set;}
    public List<csvWrapper> csvWFailList {get;set;}
    public String recordTypeName;
    private boolean isHeapSizeError = false;
    public string projectId{get;set;}
    private set<string> failedEmpIds;
    //private  listSRToInsert; 
    public list<prepareSeveranceAndRelease> lstSR{get;set;}
    private transient map<string, list<String>> dRows;
    
    public static final Integer BATCH_SIZE = 400;
    public static final String NO_FILE_SELECTED_ERROR = Label.RIF_No_File_Selected; 
    public static final String FILE_NOT_HAS_EXTENSION_ERROR = Label.RIF_File_Not_Has_Extension;
    public static final String NOT_CSV_FILE_ERROR = Label.RIF_Not_CSV_File_Error;
    public static final String EMP_ID_NOT_POPULATED = Label.RIF_Emp_Id_Not_Populated;
    public static final String EXCEEDED_MAX_LIMIT_UPLOAD = Label.RIF_Exceeded_Max_Limit_Upload;
    public static final Integer CONTENT_BATCH = 10000;
    private static final string SOBJECT_NAME = 'Severance_And_Release__c';
    
    
    public RIF_BulkCreateSeveranceAndRelease(){
        initiateMembers();
        isUploaded = false;  
        projectId = ApexPages.currentPage().getParameters().get('projectId'); 
        recordTypeName = ApexPages.currentPage().getParameters().get('recordType'); 
    }
    
    private void initiateMembers(){
      successResult = '';
      failedResult = '';
      csvWSuccessList = new List<csvWrapper>();
      csvWFailList = new List<csvWrapper>();
      rows = new map<string, Severance_And_Release__c>();
      errMessageList = new Set<String>();
      lstSR = new list<prepareSeveranceAndRelease>();
      isCreatedUpdated = false;
      failedEmpIds = new set<string>();
    }
    
    private static boolean isHeapSizeCrossed{
        get{        
            if(Limits.getHeapSize() < (Limits.getLimitHeapSize() - 20000)){
                return false;
            }else{
                return true;
            }
        }
    }
    public void createUpdateSR(){
        //validateFileExtension();
        if(failedEmpIds.size() == rows.size()){
            csvWFailList.add(new csvWrapper('All', 'Fail', 'All employees have some issue. Please check once again.', null));
            return;
        }
        list<Severance_And_Release__c> listSRToInsert = new list<Severance_And_Release__c>();
        
        for(prepareSeveranceAndRelease psr : lstSR){
            listSRToInsert.add(psr.srRecord);
        }
        system.debug('SR for insertion: ' +listSRToInsert);
        if(!listSRToInsert.isEmpty()){
            List<ApexPages.Message> pageMessages = RIF_DataUtil.upsertResult(listSRToInsert);
            for(Severance_And_Release__c sr : listSRToInsert){
                if(sr.Id <> null && rows.containsKey(sr.Emp_Id__c)){
                    rows.put(sr.Emp_Id__c, sr);
                }
            }
        }
        populateEmpIdProcessStatus();
        
        isCreatedUpdated = true;
        
       
    }
    
    public void validateFileExtension(){
        errMessageList = new Set<String>();
        
        if(fileName == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, NO_FILE_SELECTED_ERROR));
            return;           
        }
        
        
        if(fileName.lastIndexOf('.') == -1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, FILE_NOT_HAS_EXTENSION_ERROR ));
            return;            
        }
        
        if(fileName.lastIndexOf('.') <> -1 && fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase() <> 'csv'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,NOT_CSV_FILE_ERROR ));
            return;
        }
      
        UploadAndPrepareSeverenceAndRelease();
        
        if(isHeapSizeError){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'File Size is too large. please reduce the file size.' ));
            return;
        }
      
    }
    
    public PageReference UploadAndPrepareSeverenceAndRelease(){         
        parseDataRows(getDataRows());
        isUploaded = true;
        //map<string, Comp_Data__c> mapEmpIdCompData = new map<string, Comp_Data__c>();
        if(!rows.isEmpty()){
            list<string> empIds = new list<string>();
            empIds.addAll(rows.keySet());
            /*for(Comp_Data__c cd : RIF_DataUtil.getCompDataForEmpIds(empIds)){
                mapEmpIdCompData.put(cd.Emp_Id__c, cd);
            }*/
            Map<string, Employee__c> empMap = new map<string, Employee__c>();
            for(Employee__c emp : RIF_DataUtil.getEmployeesMapForEmpIds(rows.keySet()).values()){
                empMap.put(emp.Emp_Id__c, emp);
            }
            //system.debug('mapEmpIdCompData_Ra: '+ mapEmpIdCompData);
            
            List<Severance_And_Release__c> listSRToInsert = new List<Severance_And_Release__c>();
            for(string str: rows.keySet()){
                listSRToInsert.add(new Severance_And_Release__c(Emp_Id__c = str));
            }
            //added on 10 Nov 2015
            for(Severance_And_Release__c sr : listSRToInsert){
                RIF_DataUtil.copyFieldsToSRFromEmployee(sr,empMap.get(sr.Emp_Id__c)); 
            }
            //List<Severance_And_Release__c> listSRToInsert = RIF_SeveranceAndReleaseManager.validateAndCreateSR(rows.keySet(), projectId, getSRRecordTypeId());
            listSRToInsert = RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectId, getSRRecordTypeId(), listSRToInsert,null); 
            if(!listSRToInsert.isEmpty()){
                system.debug('-------' +  listSRToInsert);
                for(Severance_And_Release__c sr : listSRToInsert){
                    if(rows.containsKey(sr.Emp_Id__c)){
                        string srFieldValue = dRows.get(sr.Emp_Id__c).size()>1?dRows.get(sr.Emp_Id__c)[1].trim():null;
                        if(sr.Id <> null && srFieldValue != null && srFieldValue != '')
                            //sr.status__c = srFieldValue;
                        
                        srFieldValue = dRows.get(sr.Emp_Id__c).size()>2?dRows.get(sr.Emp_Id__c)[2].trim():null;
                        if(srFieldValue != null && srFieldValue != ''){
                            //Employee__c emp = new Employee__c(emp_Id__c = srFieldValue);
                            //sr.Decisional_Unit_Member__r = emp;
                            system.debug('Employee_empId__c:  '+sr);
                        }
                        
                      //  system.debug('####dRows.get(sr.Emp_Id__c)[4].trim()###'+dRows.get(sr.Emp_Id__c)[4].trim());
                       // system.debug('####dRows.get(sr.Emp_Id__c)[5].trim()###'+dRows.get(sr.Emp_Id__c)[5].trim()); 
                         //system.debug('####dRows.get(sr.Emp_Id__c)[3].trim()###'+dRows.get(sr.Emp_Id__c)[2].trim());
                        //added on 09/11/2015
                        rows.put(sr.Emp_Id__c, sr);
                        lstSR.add(new 
                        prepareSeveranceAndRelease(sr, empMap.get(sr.Emp_Id__c))
                        );
                        /*if(mapEmpIdCompData.containsKey(sr.Emp_Id__c)){
                            rows.put(sr.Emp_Id__c, sr);
                            lstSR.add(new 
                            prepareSeveranceAndRelease(sr, empMap.get(sr.Emp_Id__c))
                            );
                        }*/
                    }
                }
                /*List<ApexPages.Message> pageMessages = RIF_DataUtil.upsertResult(listSRToInsert);
                for(Severance_And_Release__c sr : listSRToInsert){
                    if(sr.Id <> null && rows.containsKey(sr.Emp_Id__c)){
                        rows.put(sr.Emp_Id__c, sr);
                    }
                }*/
            }
            system.debug('lstSR_RA: '+ lstSR);
        }
        csvWFailList.clear();
        failedEmpIds.clear();
        populateEmpIdProcessStatus();
        return null;
    }
    
    
    
    public map<string, list<String>> getDataRows(){
        String content = '';          
        dRows = new map<string, list<String>>();
        try {
            //system.debug(fileContent); 
            content = fileContent.toString() + '\n,';
            
            //content = EncodingUtil.base64Encode(fileContent) + '\n,';
            
            isHeapSizeError = false;              
            populateDataRows(0, content.length(), content, dRows);  
  
            if(isHeapSizeError){               
                return new map<string, list<String>>();
            }
        } catch (System.ListException e) {
            errMessageList.add(EXCEEDED_MAX_LIMIT_UPLOAD);
        }
        content = null;
        fileContent = null;
        system.debug(dRows);
        return dRows;
    }
    
    public void populateDataRows(Integer startIndx, Integer endIndx, String content, map<string, list<String>> dRows){
        try{
            system.debug('content: '+ content.split('\n'));
            /*if(content.endsWith(',') || content.endsWith('\n')){
                endIndx = endIndx - 1;
            }*/
            String content1 = content.substring(startIndx, endIndx);
             
            startIndx =  startIndx + content1.length();
            endIndx = startIndx + endIndx;
              
            if(isHeapSizeCrossed){  
                isHeapSizeError = true;                    
            }  
                           
            if(dRows <> null){
                while(content1.length() <> 0){
                    system.debug('content1: '+ content1);
                    string line = '';
                    Integer eIndx = content1.length() - 1;
                    
                    if(content1.indexOf('\n') <> -1){system.debug('in rahul');
                        eIndx = content1.indexOf('\n');
                    }
                    system.debug('eIndex: '+ eIndx);
                    line = content1.substring(0, eIndx);
                    content1 = content1.substring(eIndx + 1);
                    system.debug('Line: '+ line+'; conent1: '+ content1);
                    list<string> lineAttr = line.split(',');
                    if(lineAttr.size() > 0 && lineAttr[0].trim() == 'Emp Id')
                        continue;
                    dRows.put(lineAttr[0].trim(), lineAttr);
                    system.debug('drows: '+dRows);
                }
                if(dRows.isEmpty()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, EMP_ID_NOT_POPULATED));
                } 
                if(isHeapSizeCrossed){  
                    isHeapSizeError = true;                    
                    //throw new CM_CustomException(HEAPSIZE_EXCEPTION, 'Heap(Memory)');                
                }          
            }           
        }catch(Exception ex){
            errMessageList.add(ex.getMessage());
        }
        system.debug('drows: '+dRows);
        return;
    }
    
    public void parseDataRows(map<string, list<String>> dataRows) {system.debug('content: '+ dataRows);
        rows.clear();
        for(String line : dataRows.keySet()) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) 
                continue;
            rows.put(line.replaceAll(',','').trim(),null);
        }
        system.debug('rows: '+ rows);
    }
    
    public void populateEmpIdProcessStatus(){
        //csvWFailList.clear();
        failedResult = '"EMP Id","Failure Message"\n';
        //find out validation failure for emp Ids
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            list<string> empStatus = msg.getSummary().split(':', 2);
            system.debug('empStatus== '+ empStatus);
            if(empStatus.size() > 0 && !failedEmpIds.contains(empStatus[0])){//&& rows.containsKey(empStatus[0]))
                //rows.put(empStatus[0], null);
                csvWFailList.add(new csvWrapper(empStatus[0], 'Fail', empStatus[1], null));
                failedResult += '"'+empStatus[0]+'","'+empStatus[1]+'"\n';
                failedEmpIds.add(empStatus[0]);
            }
        }
        //Find out not exist employees
        for(string str: rows.keySet()){
            if(failedEmpIds.contains(str) || rows.get(str) != null){
                continue;
            }else{
                csvWFailList.add(new csvWrapper(str, 'Fail', 'Employee does not exist.', null));
                failedResult += '"'+str+'","'+'Employee does not exist.'+'"\n';
                failedEmpIds.add(str);
            }
        }
        
        system.debug('rows after failure: '+ csvWFailList);
        
        // capture empIds those are successfuly created as S&R record.
        csvWSuccessList.clear();
        successResult = '"EMP Id","Success Status"\n';
        for(string str : rows.keySet()){
            system.debug(str +' --> '+ rows.get(str));
            if(rows.get(str) <> null){
                csvWSuccessList.add(new csvWrapper(str, 'Pass', '', rows.get(str)));
                successResult += '"'+str+'","success"\n';
            }
        }
        
    }
    public string getSRRecordTypeId(){
        String recordTypeId;
        if(recordTypeName <> NULL){  
            List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(recordTypeName);
            for(RecordType rt : lstRT){            
                if(rt.SobjectType == SOBJECT_NAME){
                    recordTypeId = rt.Id;
                }
            }
        }
        return recordTypeId;
    }
    
    
    public String getSucessResultCSV() {
        return successResult;
    }
    
    public String getFailureResultCSV() {
        return failedResult;
    }
    
    public Pagereference CSVUploadSuccessResultsCSV(){
        return Page.RIF_CSVUploadSuccessResultsExcel;
    }
    
    public Pagereference CSVUploadFailureResultsCSV(){
        return Page.RIF_CSVUploadFailedResultsExcel;
    }
    
    public class csvWrapper{
        public string empId{get;set;}
        public string result{get;set;}
        public string failureReason{get;set;}
        public Severance_And_Release__c sr{get;set;}
                
        public csvWrapper(){
            this.failureReason = 'Error: ';
            this.result = 'Pass';
        }
        public csvWrapper(string emp_id, string result_status, string failure_reason, Severance_And_Release__c sr){
            this.failureReason = failure_reason;
            this.result = result_status;
            this.empId = emp_id;
            this.sr = sr;
        }
    }
    
    public class prepareSeveranceAndRelease{
        public Severance_And_Release__c srRecord{get;set;}
        //public Comp_Data__c compData{get;set;}
        public Employee__c empData{get;set;}
        
        public prepareSeveranceAndRelease(Severance_And_Release__c srRecord, Employee__c empData){
            this.srRecord = srRecord;
            //this.compData = compData;
            this.empData = empData;
        }
    }
}