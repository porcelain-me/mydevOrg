/** Controller class for RIF_SyncProjectAndSNRsProcessorPage, this is where the SNRs
* according to the user's access is updated with the latest Project details
**/
public class RIF_EmployeeSyncProcessor {
    // page variables
    //public Project__c project {get; set;}
    public List<WrapEmployee> wrapEList{get;set;}
    public Boolean showComplete {get;set;}
    public String errorMessageString {get;set;} 
    public Boolean renderMessages {get;set;}
    public Integer batchBeingProcessed {get;set;}
    public Integer totalBatchSize {get;set;}
    public Integer totalSNRs {get; set;}
    public List<String> saveMessages = new List<String>();
    public Integer totalErrors = 0;
    public Integer totalSuccesses = 0;
    
    // variables
    public Integer BATCH_SIZE = 10; // the size of the batch to be processed
    public List<Severance_and_Release__c> snrList,sTemp;
    public List<Employee__c> empList;
    public Set<String> empIdSet = new Set<String>();
    public String projectId {get;set;}
    public String snrNames = '';
    public Integer linesToProcess,linesProcessed = 0;
    public static Map<String,Severance_And_Release__c> idSNRMap = new Map<String,Severance_And_Release__c>();
    public Map<String,Severance_And_Release__c> srRelatedMap = new Map<String,Severance_And_Release__c>();
    public Map<String,Severance_And_Release__c> allSNRsMap;
    public Map<String,Unvested_Equity__c> uEquity = new Map<String,Unvested_Equity__c>();
    public Map<String,Employee__c> empDetailsMap = new Map<String,Employee__c>();
    public List<Project_Level__c> projectLevels = new List<Project_Level__c>();
    public Set<Severance_and_Release__c> totalSNRsSet = new Set<Severance_and_Release__c>();
    public Map<String,Project_Level__c> pLevelMap = new Map<String,Project_Level__c>();
    public List<Unvested_Equity__c> uEqtyList = new List<Unvested_Equity__c>();
    public List<WrapEmployee> finalWrapperList;
    
    /** the constructor **/
    public RIF_EmployeeSyncProcessor(){
        snrList = new List<Severance_and_Release__c>();
        empList = new List<Employee__c>();
        allSNRsMap = new Map<String,Severance_And_Release__c>();
        
        finalWrapperList = new List<WrapEmployee>();
        
        totalBatchSize = BATCH_SIZE;
        batchBeingProcessed = 0;
        projectId = system.currentPageReference().getParameters().get('projectId');
        snrNames = system.currentPageReference().getParameters().get('snrName');
        // TODO : get all SNRs, also get the Override fields
        snrList = RIF_UserLevelData.getSRLIStfromSNRName(snrNames);
        system.debug(' -- snrList SIZE -- ' + snrList.size());
        //linesToProcess = snrList.size();
        initilizeData();
        processBatch();
    }
    
    /** Method will get all the details for further processing **/
    public void initilizeData(){
        // snr Id set
        Set<String> snrIdsSet = new Set<String>();
        // get all employee MSIDs
        if(!snrList.isEmpty()){
            for(Severance_and_Release__c snr : snrList){
                empIdSet.add(snr.Employee__r.Emp_ID__c);
                snrIdsSet.add(snr.Id);
            }
        }
        system.debug(' -- empIdSet -- ' + empIdSet);
        // TODO : This query will be replaced with the one in constructor ********
        // Add all the override fields for update operation
        sTemp = [SELECT Base_Salary__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c, Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c,
                 Outplacement__c,Status__c,Project__c,Emp_Id__c,RecordTypeId,Id,Employee__c,Base_Salary_Override__c,Notice_Days_Override__c,Notice_Amount_Override__c,Basic_Severance_Local_Override__c,
                 Additional_Notice_Override__c,Additional_Notice_Amount_Override__c,Additional_Severance_Override1__c,
                 Communication_Date__c, Termination_Date__c, Last_day_on_Premises__c, DOH_Recent__c, LOS_1__c ,
                 Enhanced_Severance_Local_Override__c,Cobra_Override__c 
                 FROM Severance_And_Release__c 
                 WHERE Id IN : snrIdsSet];
        system.debug(' -- sTemp -- ' + sTemp);
        system.debug(' -- sTemp SIZE -- ' + sTemp.size());
        
        for (Severance_And_Release__c s : sTemp){
            srRelatedMap.put(s.employee__c,s);
            idSNRMap.put(s.Id,s);
        }
        system.debug(' -- srRelatedMap SIZE -- ' + srRelatedMap.size());
        allSNRsMap.putAll(srRelatedMap);
        system.debug(' -- allSNRsMap -- ' + allSNRsMap);
        linesToProcess = allSNRsMap.size();
        totalSNRs = allSNRsMap.size();
        // get all the employee details
        if(!empIdSet.isEmpty()){
            empList = [SELECT Id, Job_State_Job__c,Job_Title__c,Job_Title_Dsc_Job__c,DOH_Original__c,Sched_Hours_Job__c,Base_Annual_Amount__c,IND_Basic_Salary_Amount__c,Cost_Center__c, Cost_Center_Desc__c, Dept_Org__c, Dept_Dsc_Org__c, Division_Org__c, Division_Dsc_Org__c,
                       Emp_ID__c, Level_Job__c, Level_Dsc_Job__c, MS_MSSB__c, Region_Dsc_Org__c,Subdept_Org__c, Subdept_Dsc_Org__c, Sub_Depart2_Org__c, 
                       Sub_Depart2_Dsc_Org__c, Super_Division__c, Super_Division_Dsc_Org__c, Covenant_Date__c, Job_Country_Job__c,Cobra_Grossup_Amount_Cobra__c, 
                       DOH_Recent__c, First_Name__c, Last_Name__c, Super_Depart_Dsc_Org__c, Super_Depart_Org__c,Days_of_Perm_Serv_Total_LOS__c, 
                       Login_Id_Directory__c, Name, Empl_Type_Job__c, Ethnic_Group__c, Gender__c, Jobcode_Job__c, Status__c,
                       ca_flag__c,age__c,  Address_1_Home__c, Address_2_Home__c,Address_3_Home__c, Address_4_Home__c, City_Home__c, State_Home__c, Zip_Home__c,
                       HasEquity__c,Birth_Date__c,Phone_Area_Code_Home__c,Phone_Number_Home__c 
                       FROM Employee__c   
                       WHERE Emp_Id__c in : empIdSet ];
        }
        if(!empList.isEmpty()){
            for(Employee__c emp : empList){
                empDetailsMap.put(emp.Id, emp);
            }
        }
        // get the project levels
        projectLevels = [SELECT Id, Project__c,Severance_Parameters__c,Level__c,Basic_Max__c,Basic_Min__c,Cobra_Months__c,Los_Through__c,Covenant_Notice__c,Enhanced_Max__c,Enhanced_Min__c,
                         Notice_Calc__c,Sev_Weeks__c,Sev_Weeks_Max__c,Sev_Weeks_Min__c,Weekly_Mulitple__c,country__c,level_dsc__c,ms_mssb__c,Back_Out_Notice__c
                         FROM Project_Level__c 
                         WHERE Project__c =: projectId ]; 
        
        for(Project_Level__c l : projectLevels){
            pLevelMap.put(l.country__c + '-' + l.level_dsc__c + '-' + l.ms_mssb__c,l);
        }
        // get the unvested equity amount and date
        uEqtyList = [SELECT Id, Unvested_Total_Balance__c, Date_As_of__c, Employee_temp__c
                     FROM Unvested_Equity__c
                     WHERE Employee_temp__r.Emp_Id__c in : empIdSet ];
        
        for(Unvested_Equity__c u:uEqtyList){
            uEquity.put(u.employee_temp__c,u);
        }
        
    }
    
    /** Method that will process the SNR records **/
    public PageReference processBatch(){
        wrapEList = new List<WrapEmployee>();
        List<Severance_and_Release__c> snrTempList = new List<Severance_and_Release__c>();
        // start processing the records batchwise according to the records in the map
        system.debug(' -- allSNRsMap START -- ' + allSNRsMap);
        if(!allSNRsMap.isEmpty()){
            batchBeingProcessed ++;
            // go over the SNRs and get only BATCH_SIZE number of records
            Integer counter = 0;
            for(String empMSID : allSNRsMap.keySet()){
                if(counter == BATCH_SIZE){
                    break;
                }
                else{
                    snrTempList.add(allSNRsMap.get(empMSID));
                    // remove the entry from the main map
                    allSNRsMap.remove(empMSID);
                }
                counter ++;
            }
            system.debug(' -- snrTempList -- ' + snrTempList);
            // snrs list to process, process for each employee set
            if(snrTempList != null && !snrTempList.isEmpty() && !empDetailsMap.isEmpty()){
                for(Severance_and_Release__c snr : snrTempList){
                    system.debug(' -- snr -- ' + snr);
                    String totalBalance;
                    Datetime uDateAsOf;
                    if (uEquity.get(snr.Employee__c) != null){
                        totalBalance = uEquity.get(snr.Employee__c).Unvested_Total_Balance__c;
                        uDateAsOf = uEquity.get(snr.Employee__c).Date_As_of__c;
                    }
                    wrapEList.add(new wrapEmployee(empDetailsMap.get(snr.Employee__c) ,
                                                   pLevelMap.get(empDetailsMap.get(snr.Employee__c).Job_Country_Job__c + '-' + empDetailsMap.get(snr.Employee__c).Level_Dsc_Job__c + '-' + empDetailsMap.get(snr.Employee__c).MS_MSSB__c),  snr, totalBalance, uDateAsOf));
                }
            }
            // add all entries to the final wrapper list that will be used for insert 
            finalWrapperList.addAll(wrapEList);
            system.debug(' -- allSNRsMap END -- ' + allSNRsMap);
        }
        // when the entire processing completes
        else {
            system.debug(' -- All SNRs processed! -- ');
            // check if we have all the SNRs in the final wrapper list
            if (finalWrapperList.size() > 0){
                // save all records
                saveRecords();
            }
            
            ApexPages.getMessages().clear();
            Set<String> msidsFoundSet = new Set<String>();
            String msid;
            for(String msg : saveMessages){
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
            showComplete = true;
            if(saveMessages.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Errors!'));
            } 
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Process completed with Errors (not all records have been updated)!'));
            }
            return null; 
        }
        
        return null;
        
    }
    
    /** Save the processed records **/
    public void saveRecords(){
        system.debug(' -- IN SAVE RECORDS -- ');
        system.debug(' -- finalWrapperList -- ' + finalWrapperList);
        
        List< Severance_And_Release__c> sList = new List< Severance_And_Release__c>();
        
        for (wrapEmployee w : finalWrapperList){
            //w.s.Project__c = project.Id;
            //w.s.Employee__c = w.e.id;
           // w.s.RecordTypeId = r.id;
            //w.s.Emp_Id__c = w.e.emp_id__c;
            //w.s.Employee__c = w.e.id;
            slist.add(w.s);
        }
        
        system.debug(' -- slist -- ' + slist);
        
        List<Severance_And_Release__c> templistSR = new List<Severance_And_Release__c>();
        
        system.debug(' -- projectId -- ' + projectId);
       
        
        templistSR = RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectId, null, sList,'empSync');
        
        system.debug(' -- templistSR -- ' + templistSR);
        
        for(ApexPages.Message msg : ApexPages.getMessages()){
            saveMessages.add(string.valueOf(msg.getDetail()));
        }  
        Set<ID> setSNRTempID = new Set<ID>();
        if (!tempListSR.isEmpty()){
            Database.SaveResult[] srSList;
            srSList = Database.update(templistSR, false);
            Integer i=0;
            for(Database.saveResult srS:srSList){ 
                if (!srS.isSuccess()){//only look at failures, or NOT Successes
                    for (Database.Error err :srS.getErrors()) {
                        saveMessages.add('MSID=' + tempListSr[i].Emp_Id__c + ': ' + err.getMessage() + ' No updates will occur for this employee!');
                    }
                }
                i++;
                if(srS.isSuccess())
                {
                   setSNRTempID.add(srS.getID()); 
                }
            } 
        }
        if(!setSNRTempID.isEmpty())
        {
            List<Severance_Release_ETL_Temp__c> listETLTemp = [Select name, Changed_Fields__c, project__c,Severance_And_Release__c  
                                                               from Severance_Release_ETL_Temp__c  where Severance_And_Release__c =:setSNRTempID and active__c =true];
            if(listETLTemp!=null && !listETLTemp.isEmpty()){
                for(Severance_Release_ETL_Temp__c snrTemp :listETLTemp )
                {
                    snrTemp.Active__c = false;
                }
                update listETLTemp;
            }
        }
    }
    
    // the wrapper class, these variables will be shown on the VF page
    public class wrapEmployee{
        public Employee__c e{get;set;}
        public Severance_And_Release__c s {get;set;}
        public Project_Level__c pl {get;set;}
        public Project__c p {get;set;}
        public Decimal noticeDays {get;set;}
        public String baseSevWeeks {get;set;}    
        public String INDBasicSalaryAmount {get;set;}
        public String unvestedAmt {get;set;}
        public Boolean isProjCommDateLeapYear{get;set;}
        public wrapEmployee(Employee__c e,Project_Level__c pl,  Severance_and_Release__c s, String totalBal, Datetime asOfDt ){
            this.e = e;
            this.pl = pl;
            //this.p = p;
            this.unvestedAmt = totalBal;
            this.s = s;
            
            if( (s.Communication_Date__c != null) && (Date.isLeapYear(s.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear = true;   
            }
            else{
                isProjCommDateLeapYear = false;   
            }
            s.first_name__c = e.first_name__c;
            s.last_name__c = e.last_name__c;
            //noticeDays = p.default_notice_days_new__c;
            // 7/29/2016 - Fix for 1700 - Start
            // last day on premises should default equal to communication date
            //s.last_day_on_premises__c = p.Communication_Date__c;
            // 7/29/2016 - Fix for 1700 - End
            //s.communication_date__c = p.Communication_Date__c;
            //s.termination_date__c = terminationDate;
            //s.Notice_Days_1__c = string.valueOf(p.default_notice_days_new__c);
            s.address_1_home__c = e.address_1_home__c;
            s.address_2_home__c = e.address_2_home__c;
            s.address_3_home__c = e.address_3_home__c;
            s.address_4_home__c = e.address_4_home__c;
            s.City_Home__c = e.city_home__c;
            s.State_Home__c = e.state_home__c;
            s.Zip_Home__c = e.Zip_Home__c;
            //s.ca_flag__c = e.ca_flag__c;
            s.Country__c = e.Job_Country_Job__c;
            s.MS_MSSB__c = e.MS_MSSB__c;
            s.Level_Desc__c = e.Level_Dsc_Job__c;
            s.Level__c = e.Level_Job__c; 
            s.Job_State_Job__c = e.Job_State_Job__c;
            s.Job_Title__c= e.Job_Title__c;
            s.Job_Title_Dsc_Job__c  =e.Job_Title_Dsc_Job__c;
            s.DOH_Original__c  =e.DOH_Original__c;
            s.DOH_Recent__c  = e.DOH_Recent__c;
			s.Sched_Hours_Job__c = e.Sched_Hours_Job__c;
            
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
            
            if (pl != null){
                if (pl.sev_weeks__c == null)
                    pl.sev_weeks__c = 0;
                
                this.baseSevWeeks = string.valueOf(pl.sev_weeks__c);
            }
            this.INDBasicSalaryAmount = string.valueOf(e.Base_Annual_Amount__c);
            noticeDays = s.Communication_date__c.daysBetween(s.Termination_date__c) + 1;
            /*if (pl != null)
            {
                if(idSNRMap != null && !idSNRMap.isEmpty() && idSNRMap.containsKey(s.Id) && idSNRMap.get(s.Id).doh_recent__c!=null)
                {
                    Decimal years = ((idSNRMap.get(s.Id).doh_recent__c.daysBetween(date.valueof(s.last_day_on_premises__c)) + 1)/365.25).setScale(2);
                    s.los_1__c = string.valueOf(years);
                }
            }*/
            s.notice_days_1__c = string.valueOf(noticeDays);
        }
    }
}