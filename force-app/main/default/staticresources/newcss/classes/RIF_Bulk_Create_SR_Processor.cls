/**********************************************************************************************
* BULK CREATE SR PROCESSOR
*   This processes a file for the employee bulk upload process.
*
* Change log:
*
*   2/4/16 - Created Process
*
************************************************************************************************/
public without sharing class RIF_Bulk_Create_SR_Processor {  

    //Getter-Setters
    public Blob csvFileBody{get;set;}
    public string fileNameCSV{get;set;}
    public List<Severance_And_Release__c> srList{get;set;}
    public List<Employee__c> eList {get;set;}
    public List<wrapEmployee> wrapEList{get;set;}
    public Project__c p {get;set;}
    public Integer linesRemaining {get;set;}
    public Integer linesProcessed {get;set;}
    public Integer linesToProcess {get;set;}
    public Boolean showComplete {get;set;}
    public List<RIF_File_Upload_History__c> lstHistoryLoad {get;set;} 
   
    public Boolean isProjCommDateLeapYear {get;set;}
    public String errorMessageString {get;set;} 
    public Boolean renderMessages {get;set;}
    public Integer batchBeingProcessed {get;set;}
    //Private
    String csvAsString;
    List<String> csvFileLines = new List<String>();
    public Integer BATCHSIZE {get;set;}
    
    static final string FILETYPE='Bulk Create Severance And Release'; 
    public List<String> saveMessages = new List<String>();
    Integer totalErrors = 0;
    Integer totalSuccesses = 0;
    String mode;
    public String title {get;set;}
    
    /* variables for update process */
    Map<ID,Severance_And_Release__c> srMap = new Map<ID,Severance_And_Release__c>();
    Map<String,Integer> lineMap = new Map<String,Integer>();
    // 2-Nov-2016 : ALM#1792 : Changes related to HR Contact/HR Signatory override
    public Map<String,String> allHREmployeesMap = new Map<String,String>();
    // 14-Mar-2017 : During bulk update the Override fields values must be preserved
    public static Map<String,Severance_And_Release__c> idSNRMap = new Map<String,Severance_And_Release__c>();
    // 17-Apr-2017 : ALM#1877 : Added below logic to handle invalid MSID during bulk add
    public Set<String> invalidMSIDSet;
    public Boolean isModelProject;
    
    /**********************************************************************************************
    *
    * CONSTRUCTOR
    *
    ************************************************************************************************/
    public RIF_Bulk_Create_SR_Processor (ApexPages.StandardController controller){
        batchBeingProcessed = 0;
        
        mode = system.currentPageReference().getParameters().get('mode');

        BATCHSIZE = integer.valueOf(System.label.RIF_BulkBatchSize);
        
        
        errorMessageString ='';
        linesProcessed = 0;  
        showComplete = false;
        lstHistoryLoad = new List<RIF_File_Upload_History__c>(); 
        
        renderMessages = false;
        isModelProject = false;
        // 2-Nov-2016 : ALM#1792 : Changes related to HR Contact/HR Signatory override
        // populate this map with all the HRs (Active & belongs to 81200 dept), 
        // this map will further be used to check the emps added in the CSV file
        allHREmployeesMap = RIF_DataUtil.getAllValidHREmployees();
        
        p = (Project__c)controller.getRecord();
        
        // 24-Oct-17 : JIRA#RIF-92 : Disable checklist items in Model Project
        // added the Status__c field in the query
        p = [select Communication_date__c 
             ,Default_Notice_Days_New__c
             ,termination_date__c
             ,Status__c
             from Project__c 
             where id = :p.id]; 
         
        if( (p.Communication_Date__c != null) && (Date.isLeapYear(p.Communication_Date__c.year()))  ){
            isProjCommDateLeapYear=true;   
        }
        else if( (p.Communication_Date__c != null) && (!Date.isLeapYear(p.Communication_Date__c.year()))  ){
            isProjCommDateLeapYear=false;   
        }
        // 24-Oct-17 : JIRA#RIF-92 : Disable checklist items in Model Project
        // check if the Project is a MODEL project
        if(String.valueOf(p.Status__c).equalsIgnoreCase('Model')){
            isModelProject = true;
        }
            
        List<Attachment> aList = [select id,body, name from Attachment where parentId = :p.id order by createddate desc limit 1];
        if (!aList.isEmpty()){
            csvFileBody = aList[0].body;    
            fileNameCSV = aList[0].name;
        }
        
        csvAsString = csvFileBody.toString();
        List<String> csvFileLinesTemp = csvAsString.split('\n'); 
        
        Boolean firstLine = true;
        for(String s:csvFileLinesTemp){
            if (firstLine)
                firstLine = false;
            else
                csvFileLines.add(s);
        }
        
        linesToProcess = csvFileLines.size();
        wrapEList = new List<wrapEmployee>();
        
         
        
        if (Mode == null){
            title = 'Process Employee File';
            processBatch();
        }
        else{
            title = 'Severance And Release Bulk Update';
            if (!validFile()){
                system.debug('ready to process update batch');
                processBatch();
            }
            else{
                showComplete = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'File contains errors.  Processing halted!'));
            }
        }

    }
   
   
    /**********************************************************************************************
    *
    * PROCESS BATCH
    *
    ************************************************************************************************/
    public pageReference processBatch(){
        
        system.debug('************** in process batch ********************');
        system.debug('MODE is: ' + mode);

        if (linesProcessed >= linesToProcess){
            system.debug('final line reached');
            if (wrapEList.size() > 0)
                saveRecords();
            
            ApexPages.getMessages().clear();
            set<String> msidsFoundSet = new set<String>();
            
            String msid;
            for(String msg : saveMessages){
                // 17-May-17 : ALM#1942 : Display the correct count of SUCCESS and FAILED records
                /* 
                Integer result =msg.indexOf('MSID=');
                system.debug('result is: ' + result);
                if (result != 0){
                    result = result + 5;
                    msid = msg.substring(result,5);
                }
                */
                Integer index = msg.indexOf(':');
                if (index > 0){
                    msid = msg.substring(0,index);
                }
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
                
                system.debug('msid=' +  msid);
                if (!msidsFoundSet.contains(msid))  //add errors if first time msid is found
                    totalErrors++;
                
                msidsFoundSet.add(msid);
            }           
            
            totalSuccesses = linesToProcess - totalErrors;
            
            showComplete=true;

            if(saveMessages.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Errors!'));
            } 
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Process completed with Errors (not all records have been updated)!'));
            }

            // 24-Oct-17 : JIRA#RIF-92 : Disable checklist items in Model Project
        	// added new message for MODEL projects
        	String modelWarning = ' NOTE : As this is a \'Model\' project, no updates will be made to the checklist fields (Communicated/Communicated Date/Communicated Details of Package/Package Receipt Date/Release Returned/Release Returned Date)';
            if(isModelProject){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, modelWarning));
            }
            
            RIF_File_Upload_History__c historyObj= new RIF_File_Upload_History__c ( File_Name__c=fileNameCSV,File_type__c=FILETYPE,Total_Records__c=linesToProcess,Total_Success_Records__c=totalSuccesses,Total_Failed_Records__c=totalErrors);
            insert historyObj;
           
            List<RIF_File_Upload_History_Detail__c> hDetailList = new List<RIF_File_Upload_History_Detail__c>();
             
            for(String msg : saveMessages){
                RIF_File_Upload_History_Detail__c h = new RIF_File_Upload_History_Detail__c(RIF_Regional_File_Upload_History__c = historyObj.id,
                    error_message__c = msg);
                hDetailList.add(h);
            }
            
            if (!hDetailList.isEmpty())
                insert hDetailList;
            
            lstHistoryLoad = RIF_DataUtil.getFileUploadHistories(FILETYPE);
             
            return null;
            
        }       
        
        if (wrapEList.size() > 0){
            saveRecords();
            wrapEList = new List<wrapEmployee>();
        }
         
        Set<String> empSet = new Set<String>();
       
        system.debug('linesProcessed:' + linesProcessed);
        system.debug('batchBeingProcessed: ' + batchBeingProcessed);
        
        batchBeingProcessed++;
        
        system.debug(' batchsize: ' + batchsize + ' batchbeingprocessed: ' + batchBeingProcessed);
        
        Map<String,Severance_And_Release__c> srByEmp = new Map<String,Severance_And_Release__c>();
            
        for(Integer i=linesProcessed; i<BATCHSIZE*batchBeingProcessed; i++) {
          
            if (linesProcessed <= linesToProcess-1){
                system.debug('i is: ' + i + ' batchsize: ' + batchsize + ' batchbeingprocessed: ' + batchBeingProcessed);
            
                List<String> csvRecordData = csvFileLines[i].split(',');
            
                if (mode == null) //create mode
                    empSet.add(csvRecordData[0].trim());
                else //update mode
                    empSet.add(csvRecordData[1].trim());
            
                /* if update create line map by emp id */
                //
                //
                 
                
                if (mode == 'u'){
                    Map<String, Object> fieldValueMap = new Map<String, Object>();
                    
                    Severance_And_Release__c sr = new Severance_And_Release__c();
                    
                    Integer j=0;
                    for (String s:csvRecordData){
                        csvRecordData[j] = s.replace('"','');
                        if (csvRecordData[j] == '')
                            csvRecordData[j] = null;
                        j++;
                    }
                
                    fieldValueMap.put('id', csvRecordData[0]);
                    //srIDSet.add(csvRecordData[0]);
                    lineMap.put(csvRecordData[0],i+2);
                
                    system.debug('New date is: ' + fixDate(csvRecordData[3]));
                                        
                    fieldValueMap.put('Communication_Date__c', fixDate(csvRecordData[3]));
                    fieldValueMap.put('Termination_Date__c', fixDate(csvRecordData[4]));
                    fieldValueMap.put('Last_Day_On_Premises__c', fixDate(csvRecordData[5]));
                    fieldValueMap.put('Status__c', csvRecordData[6]);
                    //fieldValueMap.put('Sub_Status__c', csvRecordData[7]);
                    // 14-Sept-17 : JIRA#48 : Added new field 'Level Desc' to the report --- STARTS
                    // all below will increase by +1 (e.g fieldValueMap.put('Status_Credit_Or_Selected__c', csvRecordData[7]);)
                    //fieldValueMap.put('Status_Credit_Or_Selected__c', csvRecordData[8]);  MSN:RiF#33 Changes Removed this field from report
                    fieldValueMap.put('Comments__c', csvRecordData[8]);
                    fieldValueMap.put('Exhibit_A__c', fixBoolean(csvRecordData[9]));
                    fieldValueMap.put('WARN__c', fixBoolean(csvRecordData[10]));
                    fieldValueMap.put('Is_employee_eligible_for_rehire__c', fixBoolean(csvRecordData[11]));
                    // 24-Oct-17 : JIRA#RIF-92 : Disable checklist items in Model Project
                    // update the below given checklist items only when the project is NOT a MODEL one
                    if(!isModelProject){
                        fieldValueMap.put('Communicated__c', fixBoolean(csvRecordData[12]));
                        fieldValueMap.put('Communicated_Date__c', fixDate(csvRecordData[13]));
                        // 3-Jan-17 : Replacing Communicated_Details_of_Package__c with Severance_Package_Communicated__c
                        //fieldValueMap.put('Communicated_Details_of_Package__c', fixBoolean(csvRecordData[14]));
                        fieldValueMap.put('Severance_Package_Communicated__c', fixBoolean(csvRecordData[14]));
                        fieldValueMap.put('Package_Receipt_Date__c', fixDate(csvRecordData[15]));
                        fieldValueMap.put('Release_Returned__c', fixBoolean(csvRecordData[16]));
                        fieldValueMap.put('Release_Returned_Date__c', fixDate(csvRecordData[17]));
                    }
                    fieldValueMap.put('Is_termination_related_to_Project__c', fixBoolean(csvRecordData[18]));
                    fieldValueMap.put('Work_Requirement_for_Severance__c', fixBoolean(csvRecordData[19]));
                    fieldValueMap.put('EPK_Code__c', csvRecordData[20]);
                    //system.debug('made it here');
                    if (csvRecordData[21] == null)
                        fieldValueMap.put('Unused_Vacation_Days__c', null);
                    else    
                        fieldValueMap.put('Unused_Vacation_Days__c', integer.valueOf(csvRecordData[21]));
                    //system.debug('made it here');
                    fieldValueMap.put('Overnight_Package__c', fixBoolean(csvRecordData[22]));
                    fieldValueMap.put('Overnight_Delivery_Date__c', fixDate(csvRecordData[23]));
                    fieldValueMap.put('sent_to_LHH__c', fixBoolean(csvRecordData[24]));
                    fieldValueMap.put('Outplacement__c', csvRecordData[25]);
                    //system.debug('made it here');
                    fieldValueMap.put('Sent_to_Workday__c', fixBoolean(csvRecordData[26]));
                    //system.debug('made it here');       
                    // 15-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override -- STARTS
                    if(csvRecordData[27] != null && String.valueOf(csvRecordData[27]).trim() != '' 
                    && !String.isBlank(convertMSIDtoEmpID(String.valueOf(csvRecordData[27]).trim())) 
                    && validHREmp(String.valueOf(csvRecordData[27]).trim())){
                        fieldValueMap.put('HR_Contact_lkp__c', convertMSIDtoEmpID(String.valueOf(csvRecordData[27]).trim()));
                    }
                    else{
                         fieldValueMap.put('HR_Contact_lkp__c', '');
                    }
                    if(csvRecordData[28] != null && String.valueOf(csvRecordData[28]).trim() != '' && !String.isBlank(convertMSIDtoEmpID(String.valueOf(csvRecordData[28]).trim())) && validHREmp(String.valueOf(csvRecordData[28]).trim())){
                        fieldValueMap.put('HR_Signatory_lkp__c', convertMSIDtoEmpID(String.valueOf(csvRecordData[28]).trim()));
                    }
                    else{
                        fieldValueMap.put('HR_Signatory_lkp__c', '');
                    }
                    // 14-Sept-17 : JIRA#48 : Added new field 'Level Desc' to the report --- ENDS
                    
                    // 24-Apr-17 : Set the belwo flags to FALSE, these flags indicate that the override fields were not modified by the user
                    fieldValueMap.put('Is_Changed_Add_Notice_Override__c', false);
                    fieldValueMap.put('Is_Changed_Add_Sev_Override__c', false);
                    fieldValueMap.put('Is_Changed_Base_Salary_Override__c', false);
                    fieldValueMap.put('Is_Changed_Basic_Sev_Override__c', false);
                    fieldValueMap.put('Is_Changed_Cobra_Override__c', false);
                    fieldValueMap.put('Is_Changed_Enhan_Sev_Override__c', false);
                    fieldValueMap.put('Is_Changed_Notice_Amt_Override__c', false);
                    // 15-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override -- ENDS
                    /* put all the updates in the sr record */
                
                    for(String fieldName : fieldValueMap.keySet())
                        sr.put(fieldName, fieldValueMap.get(fieldName));
                     
                    if (csvRecordData[1].trim() != null)
                        srByEmp.put(csvRecordData[1].trim(),sr);
                    
                    //system.debug('made it here');
                    
                }
                //
                //
                /* end of line map */
                
                system.debug('empset: ' + empSet);
            
                linesProcessed++;
            }
        }
       
        eList = [select Id, Base_Annual_Amount__c,IND_Basic_Salary_Amount__c,Cost_Center__c, Cost_Center_Desc__c, Dept_Org__c, Dept_Dsc_Org__c, Division_Org__c, Division_Dsc_Org__c,
                   Emp_ID__c, Level_Job__c, Level_Dsc_Job__c, MS_MSSB__c, Region_Dsc_Org__c,Subdept_Org__c, Subdept_Dsc_Org__c, Sub_Depart2_Org__c, 
                   Sub_Depart2_Dsc_Org__c, Super_Division__c, Super_Division_Dsc_Org__c, Covenant_Date__c, Job_Country_Job__c,Cobra_Grossup_Amount_Cobra__c, 
                   DOH_Recent__c, First_Name__c, Last_Name__c, Super_Depart_Dsc_Org__c, Super_Depart_Org__c,Days_of_Perm_Serv_Total_LOS__c, 
                   Login_Id_Directory__c, Name, Empl_Type_Job__c, Ethnic_Group__c, Gender__c, Jobcode_Job__c, Status__c,
                   ca_flag__c,age__c,  Address_1_Home__c, Address_2_Home__c,Address_3_Home__c, Address_4_Home__c, City_Home__c, State_Home__c, Zip_Home__c,
                   HasEquity__c,Birth_Date__c,Phone_Area_Code_Home__c,Phone_Number_Home__c 
               from Employee__c   
               where emp_id__c in :empSet];
        
        // 17-Apr-2017 : ALM#1877 : Added below logic to handle invalid MSID during bulk add
        // if it's bulk add, and emp set and the above list is not empty
        
        // 15-May-2017 : ALM#1942 : Check if all the MSIDs provided are invalid ones
        Boolean allInvalidMSIDs = false; // this flag will be TRUE only if all the MSIDs in the sheet are invalid
        
        if(mode == null && empSet != null){
            // check if the above query results is empty, which means all the MSIDs in the sheet are invalid
            if(eList == null || eList.isEmpty()){
                if(!empSet.isEmpty()){
                    // copy all the MSIDs from the sheet into the set
                    invalidMSIDSet = new Set<String>(empSet);
                    allInvalidMSIDs = true;
                }
            }
            // check if the emp set and the returned emps list is of the same size
            if(eList != null && !eList.isEmpty() && !empSet.isEmpty() && empSet.size() != eList.size()){
                // copy all the MSIDs from the sheet into the set
                invalidMSIDSet = new Set<String>(empSet);
                for(Employee__c emp : eList){
                    // check if this MSID exists in the MSIDs from the sheet, if yes remove from the set
                    if(invalidMSIDSet != null && !invalidMSIDSet.isEmpty() && invalidMSIDSet.contains(emp.Emp_ID__c)){
                        invalidMSIDSet.remove(emp.Emp_ID__c);
                    }
                }
            }
        }
        
        if(allInvalidMSIDs == true && invalidMSIDSet != null && !invalidMSIDSet.isEmpty()){
            for(String errMsg : invalidMSIDSet){
                // 17-May-17 : ALM#1942 : Display the correct count of SUCCESS and FAILED records
                // changed the error message 
                saveMessages.add(errMsg + ': Invalid MSID found! ');
            }
        }
        
        /* this code sees if there is an existing sr for the update process */
        
        Set<String> empIdSet = new Set<String>();
        
        for (Employee__c e:eList)
            empIdSet.add(e.id);
        
        //List<Severance_And_Release__c> sTemp = [select id,employee__c from Severance_And_Release__c where employee__c in :empIdSet];
        // 15-Mar-2017 : Include the changes to the override fields for SNR
        // Add all the override fields for update operation
        //MSN: Added doh_recent__c field in below query 14 March 2018
        List<Severance_And_Release__c> sTemp = [select id,doh_recent__c,employee__c,Base_Salary_Override__c,Notice_Days_Override__c,Notice_Amount_Override__c,Basic_Severance_Local_Override__c,Additional_Notice_Override__c,Additional_Notice_Amount_Override__c,Additional_Severance_Override1__c,Enhanced_Severance_Local_Override__c,Cobra_Override__c from Severance_And_Release__c where employee__c in :empIdSet];
        system.debug(' -- sTemp -- ' + sTemp);
        Map<String,Severance_And_Release__c> srRelatedMap = new Map<String,Severance_And_Release__c>();
        
        for (Severance_And_Release__c s:sTemp){
            srRelatedMap.put(s.employee__c,s);
            idSNRMap.put(s.Id,s);
        }
        
       // projectId,emp.Job_Country_Job__c,emp.Level_Dsc_Job__c,emp.MS_MSSB__c
        
        Map<String,Project_Level__c> pLevelMap = new Map<String,Project_Level__c>();
        
        List<Project_Level__c> projectLevels = new List<Project_Level__c>([
                Select id
                , project__c
                ,Severance_Parameters__c
                ,Level__c
                ,Basic_Max__c
                ,Basic_Min__c
                ,Cobra_Months__c
                ,Los_Through__c
                ,Covenant_Notice__c
                ,Enhanced_Max__c
                ,Enhanced_Min__c
                ,Notice_Calc__c
                ,Sev_Weeks__c
                ,Sev_Weeks_Max__c
                ,Sev_Weeks_Min__c
                ,Weekly_Mulitple__c
                ,country__c
                ,level_dsc__c
                ,ms_mssb__c
                ,Back_Out_Notice__c
                from Project_Level__c 
                where project__c =: p.id]); 
        
        for (Project_Level__c l:projectLevels){
            pLevelMap.put(l.country__c + '-' + l.level_dsc__c + '-' + l.ms_mssb__c,l);
        }
        
        Map<String,Unvested_Equity__c> uEquity = new Map<String,Unvested_Equity__c>();
        
        List<Unvested_Equity__c> uEqtyList = new List<Unvested_Equity__c>([
                Select id,
                Unvested_Total_Balance__c,
                Date_As_of__c,
                employee_temp__c
                from Unvested_Equity__c
                where employee_temp__c in :empIdSet]);

        for (Unvested_Equity__c u:uEqtyList){
            uEquity.put(u.employee_temp__c,u);
        }
            system.debug(' -- uEquity -- ' + uEquity);
        for (Employee__c e:eList){
            String tempId;
            String totalBalance;
            Datetime uDateAsOf;
            if (srRelatedMap.get(e.id) == null)
                tempId = null;
            else
                tempId = srRelatedMap.get(e.id).id;
            
            if (uEquity.get(e.id) != null){
                totalBalance = uEquity.get(e.id).Unvested_Total_Balance__c;
                uDateAsOf = uEquity.get(e.id).Date_As_of__c;//String.valueOf(uEquity.get(e.id).Date_As_of__c);
            }
            wrapEList.add(new wrapEmployee(e,pLevelMap.get(e.Job_Country_Job__c + '-' + e.Level_Dsc_Job__c + '-' + e.MS_MSSB__c),p.termination_date__c,p,tempId, srByEmp, mode,totalBalance, uDateAsOf)); 
        } 
        
         
        return null;
    }
    
    /**********************************************************************************************
    *
    * SAVE RECORDS
    *
    ************************************************************************************************/
    public pageReference saveRecords(){
        
        system.debug('saving records');
        
        RecordType r = [select id 
                        from RecordType 
                        where SobjectType = 'Severance_And_Release__c' 
                        and developername = 'Project_Based_Termination'];
        
        List< Severance_And_Release__c> sList = new List< Severance_And_Release__c>();
        for (wrapEmployee w:wrapEList){
            w.s.project__c = p.id;
            w.s.employee__c = w.e.id;
            //w.s.base_salary__c = w.e.IND_Basic_Salary_Amount__c;
            // 14-Mar-2017 : Commenting the base salary as we are already setting this from the page
            //w.s.base_salary__c = w.e.Base_Annual_Amount__c;
            w.s.recordtypeId = r.id;
            w.s.emp_id__c = w.e.emp_id__c;
            w.s.employee__c = w.e.id;
            slist.add(w.s);
            system.debug('would be saving:' + w.e.emp_id__c);

        }
       
        List<Severance_And_Release__c> templistSR = new List<Severance_And_Release__c>();
        
        templistSR = RIF_SeveranceAndReleaseManager.validateAndCreateSR(p.id, r.id, sList,mode);

        for(ApexPages.Message msg : ApexPages.getMessages()){
            saveMessages.add(string.valueOf(msg.getDetail()));
        } 

        system.debug('errors: ' + ApexPages.getMessages());
        
        System.debug('listSR returned from RIF_SeveranceAndReleaseManager.validateAndCreateSR()'+templistSR); 
                
        if (!tempListSR.isEmpty()){
            Database.SaveResult[] srSList;
            if (mode == null) 
                srSList = Database.insert(templistSR, false);
            else   
                srSList = Database.update(templistSR, false);
            system.debug(srsList);
            Integer i=0;
            for (Database.saveResult srS:srSList){ 
                if (!srS.isSuccess()){//only look at failures, or NOT Successes
                    for (Database.Error err :srS.getErrors()) {
                        saveMessages.add('MSID=' + tempListSr[i].Emp_Id__c + ': ' + err.getMessage() + ' No updates will occur for this employee!');
                    }
                }
                i++;
            }    
        }
        // 17-Apr-2017 : ALM#1877 : Display the below message if there were any invalid MSIDs in the sheet,
        // rest of the employees with the correct MSIDs will be inserted
        if(invalidMSIDSet != null && !invalidMSIDSet.isEmpty()){
            for(String errMsg : invalidMSIDSet){
                // 17-May-17 : ALM#1942 : Display the correct count of SUCCESS and FAILED records
                // changed the error message 
                saveMessages.add(errMsg + ': Invalid MSID found! ');
            }
        }
       
        return null; 
    }
    
    /**********************************************************************************************
    *
    * EXIT
    *
    ************************************************************************************************/
    public pageReference exit(){
        
        PageReference p = new PageReference('/apex/rif_standardprojectpage?id=' + p.id);
        p.setRedirect(true);
        return p;  
        
        
    }
    /**********************************************************************************************
    *
    * WRAP EMPLOYEE
    *
    ************************************************************************************************/ 
    public class wrapEmployee{
    
        public Employee__c e{get;set;}
        public Severance_And_Release__c s {get;set;}
        public Project_Level__c pl {get;set;}
        public Project__c p {get;set;}
        public String srId {get;set;}
        public Decimal noticeDays {get;set;}
        public String baseSevWeeks {get;set;}    
        public String INDBasicSalaryAmount {get;set;}
        public String unvestedAmt {get;set;}
        
        public wrapEmployee(Employee__c e,Project_Level__c pl, Date terminationDate,Project__c p, String srId, Map<String,Severance_And_Release__c> srByEmp, String mode, String totalBal, Datetime asOfDt ){
            this.e = e;
            this.pl = pl;
            this.p = p;
            this.unvestedAmt = totalBal;
            if (pl != null){
                if (pl.sev_weeks__c == null)
                    pl.sev_weeks__c = 0;
                
                this.baseSevWeeks = string.valueOf(pl.sev_weeks__c);
            }
             
            //this.INDBasicSalaryAmount = string.valueOf(e.IND_Basic_Salary_Amount__c);
            this.INDBasicSalaryAmount = string.valueOf(e.Base_Annual_Amount__c);
            if (srId != null)
                this.srId = srId;
            
            s = new Severance_and_release__c();
            
    
            if (mode == 'u'){
                if (srByEmp.get(e.emp_id__c) != null)
                    s = srByEmp.get(e.emp_id__c);
                noticeDays = s.Communication_date__c.daysBetween(s.termination_date__c) + 1;
                if (pl != null){
                    //MSN:RIF#146 Commented below line and added if condition for SNR doh_recent__c issue 14 March 18
                    //Decimal years = ((e.doh_recent__c.daysBetween(date.valueof(s.last_day_on_premises__c)) + 1)/365.25).setScale(2);
                    if(idSNRMap != null && !idSNRMap.isEmpty() && idSNRMap.containsKey(srId) && idSNRMap.get(srId).doh_recent__c!=null)
                    {
                        Decimal years = ((idSNRMap.get(srId).doh_recent__c.daysBetween(date.valueof(s.last_day_on_premises__c)) + 1)/365.25).setScale(2);
                        s.los_1__c = string.valueOf(years);
                    }
                    
                }
                s.notice_days_1__c = string.valueOf(noticeDays);
                
                s.id = srId;
                system.debug('sr termination date for ' + e.emp_id__c + ' is: ' + s.termination_date__c);
                // 15-Mar-2017 : Added the override fields for update SNR
                // check if we have any values in the override fields
                if(idSNRMap != null && !idSNRMap.isEmpty() && idSNRMap.containsKey(srId)){
                    s.Base_Salary_Override__c = idSNRMap.get(srId).Base_Salary_Override__c;
                    s.Notice_Days_Override__c = idSNRMap.get(srId).Notice_Days_Override__c;
                    s.Notice_Amount_Override__c = idSNRMap.get(srId).Notice_Amount_Override__c;
                    s.Basic_Severance_Local_Override__c = idSNRMap.get(srId).Basic_Severance_Local_Override__c;
                    s.Additional_Notice_Override__c = idSNRMap.get(srId).Additional_Notice_Override__c;
                    s.Additional_Notice_Amount_Override__c = idSNRMap.get(srId).Additional_Notice_Amount_Override__c;
                    s.Additional_Severance_Override1__c = idSNRMap.get(srId).Additional_Severance_Override1__c;
                    s.Enhanced_Severance_Local_Override__c = idSNRMap.get(srId).Enhanced_Severance_Local_Override__c;
                    s.Cobra_Override__c = idSNRMap.get(srId).Cobra_Override__c;
                }
                
            }
            else{
                s.first_name__c = e.first_name__c;
                s.last_name__c = e.last_name__c;
                noticeDays = p.default_notice_days_new__c;
                // 7/29/2016 - Fix for 1700 - Start
                // last day on premises should default equal to communication date
                s.last_day_on_premises__c = p.Communication_Date__c;
                // 7/29/2016 - Fix for 1700 - End
                s.communication_date__c = p.Communication_Date__c;
                s.termination_date__c = terminationDate;
                s.Notice_Days_1__c = string.valueOf(p.default_notice_days_new__c);
                s.address_1_home__c = e.address_1_home__c;
                s.address_2_home__c = e.address_2_home__c;
                s.address_3_home__c = e.address_3_home__c;
                s.address_4_home__c = e.address_4_home__c;
                s.City_Home__c = e.city_home__c;
                s.State_Home__c = e.state_home__c;
                s.Zip_Home__c = e.Zip_Home__c;
                s.ca_flag__c = e.ca_flag__c;
                if(totalBal != null && e.hasEquity__c){
                    s.Conga_Total_Unvested_Value__c = totalBal;
                    s.Unvested_As_of_Date__c = asOfDt;
                }
                if(e.Phone_Area_Code_Home__c != null && e.Phone_Number_Home__c != null)
                    s.Home_Phone_Number__c = e.Phone_Area_Code_Home__c + e.Phone_Number_Home__c;
            
            
                if (pl != null){
                    Decimal years = ((e.doh_recent__c.daysBetween(date.valueof(s.last_day_on_premises__c)) + 1)/365.25).setScale(2);
                    s.los_1__c = string.valueOf(years);
                }
                
            }
          system.debug(' -- SNR in wrapper -- ' + s);
       }
    }
    
    /*************************************************************************************************************
    * Incorporate bulk update classes
    **************************************************************************************************************/
    
    
    /**********************************************************************************************
    *
    * VALIDATE RECORDS
    *
    ************************************************************************************************/
    Boolean validFile(){
        
        Boolean error = false;
        Integer lineNumber = 0;
        
        Map<String,Severance_And_Release__c> srMap = new Map<String,Severance_And_Release__c>();
        // 24-Nov-2016 : Added Disable_Status_picklist__c to the query for validations
        for(Severance_And_Release__c s:[select id,Disable_Status_picklist__c from Severance_And_Release__c where project__c = :p.id]){
            srMap.put(string.valueOf(s.id).substring(0,15),s);
        }
        system.debug('srMap: ' + srMap);
        
        for (integer i=0;i < linesToProcess;i++){
            
            List<String> csvRecordData = csvFileLines[i].split(',');
                
             System.debug('csvRecordData :' + csvRecordData);
                 
            Integer j=0;
            for (String s:csvRecordData){
                csvRecordData[j] = s.replace('"','');
                if (csvRecordData[j] == '')
                    csvRecordData[j] = null;
                j++;
            }
            
            lineNumber = i + 2;      
            //fieldValueMap.put('id', csvRecordData[0]);
            if(srMap.get(csvRecordData[0]) == null || csvRecordData[0] == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Id] ' + csvRecordData[0] + ' is invalid!'));
                error=true;
            }
            
            if(csvRecordData[1] == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Emp Id] MSID=' + csvRecordData[1] + ' is invalid!'));
                error=true;
            }
            
            
            //fieldValueMap.put('Communication_Date__c', date.valueOf(csvRecordData[3]));
            if(!validDate(csvRecordData[3])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Communication_Date__c] ' + csvRecordData[3] + ' is invalid!'));
                error=true;
            }
            
            //fieldValueMap.put('Termination_Date__c', date.valueOf(csvRecordData[4]));
            if(!validDate(csvRecordData[4])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Termination_Date__c] ' + csvRecordData[4] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('Last_Day_On_Premises__c', date.valueOf(csvRecordData[5]));
            if(!validDate(csvRecordData[5])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Last_Day_On_Premises__c] ' + csvRecordData[5] + ' is invalid!'));
                error=true;
            }
               
            // validateTermnLastDay(csvRecordData[5],csvRecordData[4]);  
            
            Date lastDayOnPremise = date.parse(csvRecordData[5]);
            Date terminationDate = date.parse(csvRecordData[4]);
        
            if(lastDayOnPremise > terminationDate ){ 
                 ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_LastDayGreaterThanTerminationDate));
                 error= true;
             }
               
               
            //fieldValueMap.put('Status__c', csvRecordData[6]);
            //19-Oct : Changes for Defect 1812 - Removed Credit option
            if (csvRecordData[6] == null || csvRecordData[6] == 'Selected' || csvRecordData[6] == 'Not Selected'){
                Integer doNothing;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Status__c] ' + csvRecordData[6] + ' is invalid!'));
                error=true;
            }
            // 14-Sept-17 : JIRA#48 : Added new field 'Level Desc' to the report, all below csv row indexes will increase by 1 --- STARTS
            // 18-Nov-2016 : Added checks for correct Sub Status values
			//MSN:RIF#33 Changes - Commented below if- else
            /*if (csvRecordData[8] == null || csvRecordData[8] == 'Severance / no replace' || csvRecordData[8] == 'Severance / need replace' || csvRecordData[8] == 'No severance / no replace' || csvRecordData[8] == 'No severance / need replace'){
                Integer doNothing;                
            } 
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Status_Credit_Or_Selected__c] ' + csvRecordData[8] + ' is invalid!'));
                error=true;
            }*/
            //fieldValueMap.put('Sub_Status__c', csvRecordData[7]);
            
            //fieldValueMap.put('Comments__c', csvRecordData[8]);
            
            //fieldValueMap.put('Exhibit_A__c', boolean.valueOf(csvRecordData[9]));
            
            if (!validBoolean(csvRecordData[9])){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Exhibit_A__c] ' + csvRecordData[9] + ' is invalid!'));
                error=true;
            }
             
            //fieldValueMap.put('WARN__c', boolean.valueOf(csvRecordData[10]));
            if (!validBoolean(csvRecordData[10])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[WARN__c] ' + csvRecordData[10] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('Is_employee_eligible_for_rehire__c', boolean.valueOf(csvRecordData[11]));
            if (!validBoolean(csvRecordData[11])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Is_employee_eligible_for_rehire__c] ' + csvRecordData[11] + ' is invalid!'));
                error=true;
            }
            // 20-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override -- STARTS
            // validations to check the fields for Accruals -- STARTS
            //fieldValueMap.put('Communicated__c', boolean.valueOf(csvRecordData[12]));
            // 24-Oct-17 : JIRA#RIF-92 : Disable checklist items in Model Project --- STARTS
            // if the project is a MODEL one, do not update the below checklist fields
            if(!isModelProject){
                if (!validBoolean(csvRecordData[12])){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Communicated__c] ' + csvRecordData[12] + ' is invalid!'));
                    error=true;
                } else if(csvRecordData[12] == '1' ||  csvRecordData[12].equalsIgnoreCase('true')){
                    String errorMsg = '';
                    if(csvRecordData[13] == null) {
                        errorMsg += 'Line: ' + lineNumber + ' Communicated Date is required.';
                    }
                    if(!(csvRecordData[14] == '1' ||  csvRecordData[14].equalsIgnoreCase('true'))) {
                        errorMsg += 'Line: ' + lineNumber + ' Communicated Details of Package is required.';
                    }
                    if(errorMsg != '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
                        error = true;
                    }
                }
                //fieldValueMap.put('Communicated_Date__c', date.valueOf(csvRecordData[13]));
                if(!validDate(csvRecordData[13])){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Communicated_Date__c] ' + csvRecordData[13] + ' is invalid!'));
                    error=true;
                } else{
                    if(csvRecordData[13] != null && ((csvRecordData[12] == '0' ||  csvRecordData[12].equalsIgnoreCase('false')))){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Communicated field is required'));
                        error=true;
                    }
                }
                //fieldValueMap.put('Communicated_Details_of_Package__c', boolean.valueOf(csvRecordData[14]));
                if (!validBoolean(csvRecordData[14])){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Communicated_Details_of_Package__c] ' + csvRecordData[14] + ' is invalid!'));
                    error=true;
                } else if(csvRecordData[14] == '1' ||  csvRecordData[14].equalsIgnoreCase('true')){
                    String errorMsg = '';
                    if(csvRecordData[15] == null) {
                        errorMsg += 'Line: ' + lineNumber + ' Package Receipt Date is required.';
                    }
                    if((csvRecordData[12] == '0' ||  csvRecordData[12].equalsIgnoreCase('false'))){
                        errorMsg += 'Line: ' + lineNumber + ' Communicated Date is required.';
                    }
                    if(errorMsg != '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
                        error = true;
                    }
                } 
                //fieldValueMap.put('Package_Receipt_Date__c', date.valueOf(csvRecordData[15]));
                if(!validDate(csvRecordData[15])){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Package_Receipt_Date__c] ' + csvRecordData[15] + ' is invalid!'));
                    error=true;
                }
                else{
                    if(csvRecordData[15] != null && ((csvRecordData[14] == '0' ||  csvRecordData[14].equalsIgnoreCase('false')))){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Communicated Details of Package field is required'));
                        error=true;
                    }
                }
                // 20-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override -- ENDS 
                //fieldValueMap.put('Release_Returned__c', boolean.valueOf(csvRecordData[16]));
                if (!validBoolean(csvRecordData[16])){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Release_Returned__c] ' + csvRecordData[16] + ' is invalid!'));
                    error=true;
                }
                //fieldValueMap.put('Release_Returned_Date__c', date.valueOf(csvRecordData[17]));
                if(!validDate(csvRecordData[17])){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Release_Returned_Date__c] ' + csvRecordData[17] + ' is invalid!'));
                    error=true;
                }
            }
            // 24-Oct-17 : JIRA#RIF-92 : Disable checklist items in Model Project --- ENDS
            
            //fieldValueMap.put('Is_termination_related_to_Project__c', boolean.valueOf(csvRecordData[18]));
            if (!validBoolean(csvRecordData[18])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Is_termination_related_to_Project__c] ' + csvRecordData[18] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('Work_Requirement_for_Severance__c', boolean.valueOf(csvRecordData[19]));
            if (!validBoolean(csvRecordData[19])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Work_Requirement_for_Severance__c] ' + csvRecordData[19] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('EPK_Code__c', csvRecordData[20]);
            
            //fieldValueMap.put('Unused_Vacation_Days__c', csvRecordData[21]);
            if (!validInteger(csvRecordData[21])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Unused_Vacation_Days__c] ' + csvRecordData[21] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('Overnight_Package__c', boolean.valueOf(csvRecordData[22]));
            if (!validBoolean(csvRecordData[22])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Overnight_Package__c] ' + csvRecordData[22] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('Overnight_Delivery_Date__c', date.valueOf(csvRecordData[23]));
            if(!validDate(csvRecordData[23])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Overnight_Delivery_Date__c] ' + csvRecordData[23] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('sent_to_LHH__c', boolean.valueOf(csvRecordData[24]));
            if (!validBoolean(csvRecordData[24])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[sent_to_LHH__c] ' + csvRecordData[24] + ' is invalid!'));
                error=true;
            }
            //fieldValueMap.put('Outplacement__c', csvRecordData[25]);
            if (csvRecordData[25] == 'Milestone Seminar' || csvRecordData[25] == '3 Months' || csvRecordData[25] == '6 Months' || csvRecordData[25] == null)
                Integer doNothing;
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Outplacement__c] ' + csvRecordData[25] + ' is invalid!'));
                error=true;
            }
                
            //fieldValueMap.put('Sent_to_Workday__c', boolean.valueOf(csvRecordData[26]));
            if (!validBoolean(csvRecordData[26])){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[Sent_to_Workday__c] ' + csvRecordData[26] + ' is invalid!'));
                error=true;
            }
            
            // 15-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override
            if(csvRecordData[27] != null && String.valueOf(csvRecordData[27]).trim() != ''){
                if(String.isBlank(convertMSIDtoEmpID(String.valueOf(csvRecordData[27]).trim()))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[HR Contact - Override] \'' + csvRecordData[27] + '\' is an invalid MSID!'));
                    error=true;
                }
                else if(!validHREmp(String.valueOf(csvRecordData[27]).trim())){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[HR Contact - Override] \'' + csvRecordData[27] + '\' Employee is Inactive or not a member of Dept-81200!'));
                    error=true;
                }
            }
            // 15-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override
            if(csvRecordData[28] != null && String.valueOf(csvRecordData[28]).trim() != ''){
                if(String.isBlank(convertMSIDtoEmpID(String.valueOf(csvRecordData[28]).trim()))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[HR Signatory - Override] \'' + csvRecordData[28] + '\' is an invalid MSID!'));
                    error=true;
                }
                else if(!validHREmp(String.valueOf(csvRecordData[28]).trim())){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' Field[HR Signatory - Override] \'' + csvRecordData[28] + '\' Employee is Inactive or not a member of Dept-81200!'));
                    error=true;
                }
            }
            // 24-Nov-2016 : Make sure that if the SNR already has Status=Not Selected and Communicated=true, do not allow overrides 
            if(srMap.containsKey(csvRecordData[0]) && srMap.get(csvRecordData[0]).Disable_Status_picklist__c == true){
                if(String.valueOf(csvRecordData[6]) != 'Not Selected' || String.valueOf(csvRecordData[12]) != '1' ||  csvRecordData[12].equalsIgnoreCase('true')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Line: ' +  lineNumber  + ' \'Status\'/\'Communicated\' fields cannot be changed once these are set to \'Not Selected\'/\'Communicated\''));
                    error=true;
                }
            }
            // 20-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override -- ENDS
        }
                
        return error;
        
    }
    
    /**********************************************************************************************
    *
    * VALIDATE DATE
    *
    ************************************************************************************************/
    Boolean validDate(String dateIn){
        
        
        Boolean validDate = true;
        
        if (dateIn == null)
            return true;
          
            
        try{
            system.debug('**** Checking date with parse');
            Date checkDate = date.parse(dateIn);    
            system.debug(checkdate);
        }
        catch (Exception e) {
            validDate = false;
        }
        
        return validDate;
    }
    /**********************************************************************************************
    *
    * fixDate
    *
    ************************************************************************************************/
    Date fixDate(String dateIn){
    
        Date newDate = null;
        system.debug('in fixdate');
            
        if (dateIn == null){
            system.debug('leaving fix date');
            return null;
        }
        else{
            system.debug('*** date in is: ' + datein);
            newDate = date.parse(DateIn);
        }
        system.debug('leaving fixdate');    
        return newDate;
    }
    
    /**********************************************************************************************
    *
    * fixBoolean
    *
    ************************************************************************************************/
    Boolean fixBoolean(String booleanIn){
    
        if (booleanIn == null)
            return false;
            
        booleanIn = booleanIn.trim();
        
        if (booleanIn.toUpperCase() == 'TRUE' || booleanIn == '1' || booleanIn.toUpperCase() == 'Y' || booleanIn.toUpperCase() == 'YES')
            return true;
        
        if (booleanIn.toUpperCase() == 'FALSE' ||booleanIn == '0' || booleanIn.toUpperCase() == 'N' || booleanIn.toUpperCase() == 'NO')
            return false;
            
        return false; 
        
    }
    /**********************************************************************************************
    *
    * VALIDATE INTEGER
    *
    ************************************************************************************************/
    Boolean validInteger(String integerIn){
        
        Boolean validInteger = true;
        
        if (integerIn == null)
            return true;
            
        try{
            Integer checkInt = integer.valueOf(integerIn);
        }
        catch (Exception e) {
            validInteger = false;
        }
        
        return validInteger; 
    }
    
    /**********************************************************************************************
    *
    * VALIDATE BOOLEAN
    *
    ************************************************************************************************/
    Boolean validBoolean(String booleanIn){
        
        Boolean validBoolean = true;
        
        booleanIn = booleanIn.trim();
        
        if (booleanIn.toUpperCase() == 'TRUE' || booleanIn.toUpperCase() == 'FALSE' || booleanIn == '0' || booleanIn == '1' )
            validBoolean = true;
        else
            validBoolean = false;
        
        return validBoolean;
    }

  /*  public void validateTermnLastDay(String lastDayonPrem, String termDate){
        
        Date lastDayOnPremise = date.parse(lastDayonPrem);
        Date terminationDate = date.parse(termDate);
        
        if(lastDayOnPremise < terminationDate ){ 
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_LastDayGreaterThanTerminationDate));
             error= true;
             }
    }*/
    
    // 15-Sep-2016 : ALM#1792 : Changes related to HR Contact/HR Signatory override
    // method to convert the MSID to the corresponding record Id of the Employee, and check if the MSID is valid one
    public String convertMSIDtoEmpID(String msid){
        String returnId = '';       
        if(!allHREmployeesMap.isEmpty() && !String.isBlank(msid) && msid.length() == 5){
            returnId = allHREmployeesMap.get(msid);
        }
        return returnId;
    }
    // 19-Sep-2016 : ALM#1792 : Changes related to HR Contact/HR Signatory override
    // method check if the provided HR emp id ACTIVE in the system and member of 81200 CC
    public Boolean validHREmp(String msid){
        Boolean isValidHR = false;       
        if(!allHREmployeesMap.isEmpty() && !String.isBlank(msid) && allHREmployeesMap.containsKey(msid)){
            isValidHR = true;
        }
        return isValidHR;
    }
}