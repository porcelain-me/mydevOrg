//
// 06/15/2013 : MG : ORIGINAL
// Description : Manager class to popualte denormalized fields on S&R.
//
//07/11/2013: RA: Update populateDenormalizedFieldsIntoSR() to check if at least of the S&R's org department fields matches with project decisional units 
public without sharing class RIF_SeveranceAndReleaseManager{
    
   
    
    //public static string CALCULATE_AND_OVERRIDE_MANUAL_CHANGES = 'Calculate and Override Manual Changes';
    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator'; 
    //private static final string ONE_OFF_TERMINATION = 'One Off Termination';
    
    // return employee.emp_id with their failure status if exists.
    public static map<String,String> populateDenormalizedFieldsIntoSR(list<Severance_And_Release__c> listNewSR, map<Id,Severance_And_Release__c> mapOldSR,
                                                             boolean isInsert, boolean isUpdate, boolean isDelete, boolean isBefore){
      system.debug('####RIF_OrgHierarchySharingRecalBatch.batch#####'+RIF_OrgHierarchySharingRecalBatch.batch);                                                         
    // Map to store all the employees from child PDUs (if decisional unit = Employee)
    Map<String,String> childPDUEmpIDDetailsMap = new Map<String,String>();
                                                                 
        if(isUpdate && isBefore){
            //for updating S&R record type from multiple to One-Off
            if(!RIF_StopDuplicateAccrualByWorkflow.stopSRUpdateFromProject)
            {
                for(Severance_And_Release__c sr : listNewSR){ 
                   if(sr.recorDTypeID!=mapOldSR.get(sr.id).recorDTypeID)
                        changeSRRecordTpe(sr);  
                }  
            }
            //System.debug('###listNewSR[0].recorDTypeID###'+listNewSR[0].recorDTypeID);
            
            
        } 
        if(isInsert && isBefore){
            set<String> employeeIds = new set<String>();
            list<string> projectLevelIds = new list<string>();
            set<String> setCountries = new Set<String>();
            set<String> setMSSB = new Set<String>();
            set<String> setJobLevel = new Set<String>();
            set<String> setSuperDivisions = new Set<String>();
            system.debug('is insert & before');
            User user = RIF_DataUtil.getUserDetails(UserInfo.getUserId());
            for(Severance_And_Release__c sr : listNewSR){ 
                if(sr.Employee__c <> null){
                    employeeIds.add(sr.Employee__c);
                    System.debug('###sr.Project_Level__c#####'+sr.Project_Level__c);
                    projectLevelIds.add(sr.Project_Level__c);
                }
            }
            
            //map<string,string> mapProjectOrgDeptFields = new map<string,string>();
            map<string,List<string>> mapProjectOrgDeptFields = new map<string,List<string>>();
            map<String,String> mapEmpIdError = new map<String,String>();
            //map<String,Comp_Data__c> mapEmpIdCompData = new map<String,Comp_Data__c>();
            map<String, Unvested_Equity__c> mapEmpIdUnvestedEquity = new map<String, Unvested_Equity__c>();
            map<Id,Employee__c> mapEmployees = RIF_DataUtil.getEmployeeList(employeeIds);
            map<Id, Project_Level__c> mapProjectLevels = new map<Id, Project_Level__c>(RIF_DataUtil.getProjectLevelsForSRCreation(projectLevelIds));
            System.debug('###MapprojectLevelIds#####'+mapProjectLevels);
            projectLevelIds.clear();
            projectLevelIds = null;
            employeeIds.clear();
            //employeeIds = null;
            // get List Of employees
            for(Employee__c emp : mapEmployees.values()){
                //mapEmployeeIdEmpId.put(emp.Id, emp.Emp_Id__c);
                employeeIds.add(emp.Emp_Id__c);
            }
            //System.debug('###employeeIds#####'+employeeIds); 
            // get list of comp data
            //for(Comp_Data__c compData : RIF_DataUtil.getCompDataForEmpIds(mapEmployeeIdEmpId.values()))
            /*for(Comp_Data__c compData : RIF_DataUtil.getCompDataForEmpIds(new list<string>(employeeIds))){
                mapEmpIdCompData.put(compData.Emp_Id__c, compData);
            }*/
             
            for(Unvested_Equity__c unvestedEquity : RIF_DataUtil.getUnvestedEquityForEmpIds(new list<string>(employeeIds))){
                mapEmpIdUnvestedEquity.put(unvestedEquity.Emp_Id__c, unvestedEquity);
            }
            System.debug('###mapEmpIdUnvestedEquity#####'+mapEmpIdUnvestedEquity);
            employeeIds.clear();
            // create set of country, mssb and level for getting covenant paramteters
            for(Project_Level__c pl : mapProjectLevels.values()){
                setCountries.add(pl.Country__c);
                setJobLevel.add(pl.Level_Dsc__c);
                setMSSB.add(pl.MS_MSSB__c);
                //mapProjectOrgDeptFields.put(pl.project__c, '');
                mapProjectOrgDeptFields.put(pl.project__c, new List<string> ());
            }
            system.debug(RIF_DataUtil.getTriggerSwitch());
            
            string oneOffRecordTypeIdSR = '';
            for(RecordType rt: RIF_Datautil.getRecordTypeForName(Label.RIF_OneOffTermination)){
                if(rt.SobjectType == 'Severance_And_Release__c'){
                    oneOffRecordTypeIdSR = rt.Id;
                }
            }
             System.debug('###mapProjectOrgDeptFields#####'+mapProjectOrgDeptFields); 
            if(RIF_DataUtil.getTriggerSwitch().RIF_ValidateOrgDeptFieldsinSnRTrigger__c){
                
               
                //Added by Anshul Goyal on Aug 13,2015 to aplly check on adding employee based on the Org level decisional Units.Previously check was done using Project Decisional Units.
               System.debug('#####Start Org level PDUs######'+RIF_DataUtil.getProjectDecisionalOrgLevelsOnProjectId(mapProjectOrgDeptFields.keySet())); 
                for(Child_Project_Decisional_Unit__c childPdu: RIF_DataUtil.getProjectDecisionalOrgLevelsOnProjectId(mapProjectOrgDeptFields.keySet())){  
                    System.debug('###childPdu#####'+childPdu+'##unittype###'+childPdu.Decisional_Unit_Type__c+'####Decision unit#####'+childPdu.Decisional_Unit_Derived__c);  
                    String tempServiceValue = childPdu.Decisional_Unit_Type__c+':'+childPdu.Decisional_Unit_Derived__c+';'; 
                    List <string> tempServiceValueList= new List <string>(mapProjectOrgDeptFields.get(childPdu.Project_Decisional_Unit__r.project__c));
                    tempServiceValueList.add(tempServiceValue);
                    mapProjectOrgDeptFields.put(childPdu.Project_Decisional_Unit__r.project__c, tempServiceValueList); 
                    system.debug('Temp Service Value is:' + tempServiceValue); 
                    // 07-18-2015 : If the child PDU contains an employee, add it to the map for further checks
                    if(String.isNotBlank(childPdu.Employee__c))
                    	childPDUEmpIDDetailsMap.put(childPdu.Employee__c,childPdu.Emp_ID__c);
                }
                system.debug('--- childPDUEmpIDDetailsMap --- ' + childPDUEmpIDDetailsMap);
                
            }else{
                mapProjectOrgDeptFields.clear();
            }
            
            system.debug('####mapProjectOrgDeptFields:' + mapProjectOrgDeptFields);
            //(commented on 16/10/2015 as covenant notice will be taken from severance parameter by level/severance parameter on s&R)
            //map<String,Id> mapCovenantParameters = new map<String,Id>();
            
            // get covenant parameters(commented on 16/10/2015 as covenant notice will be taken from severance parameter by level/severance parameter on s&R)
            /*for(Covenant_Parameters__c cp : RIF_DataUtil.getCovenantParamsList(setMSSB,setCountries,setJobLevel)){
                mapCovenantParameters.put(cp.Country__c+'+'+cp.MS_MSSB__c+'+'+cp.Level_Dsc__c, cp.Id);
            }*/
            
            setMSSB.clear();
            setMSSB = null;
            setCountries.clear();
            setCountries = null;
            setJobLevel.clear();
            setJobLevel = null;
            
            Employee__c emp;
            String empId;
            
            // update S&R fields
            for(Severance_And_Release__c sr : listNewSR){
                if(sr.Project_Level__c <> null){
                    RIF_DataUtil.copyFieldsToSRFromProjectLevelAndProject(sr,mapProjectLevels.get(sr.Project_Level__c)); 
                    system.debug('######communication date of project severancereleasemanagerclass()######'+sr.Communication_Date__c);                 
                }
                if(sr.Employee__c <> null){
                    system.debug('EMPLOYEE NOT NULL');
                    //empId = mapEmployeeIdEmpId.get(sr.Employee__c);
                    emp = mapEmployees.get(sr.Employee__c);
                    empId = emp.Emp_ID__c;
                    RIF_DataUtil.copyFieldsToSRFromEmployee(sr,emp);   
                    //RIF_DataUtil.calculateFormulaValuesOnSR(sr,emp,mapProjectLevels.get(sr.Project_Level__c));                        
                    setSuperDivisions.add(sr.Super_Division__c);
                    if(mapEmpIdUnvestedEquity.containsKey(empId)){
                       //RIF_DataUtil.copyFieldsToSRFromUnvestedEquity(sr,mapEmpIdUnvestedEquity.get(empId));
                    }
                    //(commented on 16/10/2015 as covenant notice will be taken from severance parameter by level/severance parameter on s&R)
                    /*if(emp.Covenant_Date__c <> null && mapCovenantParameters.containsKey(sr.Country__c+'+'+sr.MS_MSSB__c+'+'+sr.Level_Desc__c)){
                        sr.Covenant_Parameters__c = mapCovenantParameters.get(sr.Country__c+'+'+sr.MS_MSSB__c+'+'+sr.Level_Desc__c);
                    }*/
                    System.debug('Jitendra -> ' + user.Profile.Name);
                    System.debug('Jitendra -> ' + user.RIF_Allow_Super_Division__c);
                    System.debug('Jitendra -> ' + emp.Super_Division__c);
                    Project_Level__c pl = mapProjectLevels.get(sr.Project_Level__c);
                    /*if(user.Profile.Name != SYSTEM_ADMINISTRATOR 
                       && (!pl.Project__r.Super_Division__c.contains(emp.Super_Division__c) || !user.RIF_Allow_Super_Division__c.contains(emp.Super_Division__c))){
                        System.debug('Jitendra -> ' + emp.Super_Division__c);
                        mapEmpIdError.put(sr.Emp_Id__c, Label.RIF_S_R_USER_SUPER_DIVISION_NOT_MATCHING);
                    }*/
                } 
                // below check will not executes for OneOffTermination SR records
                if(RIF_DataUtil.getTriggerSwitch().RIF_ValidateOrgDeptFieldsinSnRTrigger__c && sr.RecordTypeId != oneOffRecordTypeIdSR){
                    //identify invalid employee's records
                    system.debug('-----------IN IF--------');
                    if(mapProjectOrgDeptFields.containsKey(mapProjectLevels.get(sr.Project_Level__c).Project__c)){
                        //string serviceTypeValue = mapProjectOrgDeptFields.get(mapProjectLevels.get(sr.Project_Level__c).Project__c);
                        List <string> serviceTypeValues = new  List <string>(mapProjectOrgDeptFields.get(mapProjectLevels.get(sr.Project_Level__c).Project__c));
                        system.debug('serviceTypeValues list: '+ serviceTypeValues);
                        system.debug('SR-Division: '+ sr.Division__c+'; SR-Department: '+ sr.Department__c);
                        system.debug('sd:' + sr.super_division__c);
                        system.debug('sd:' + sr.super_department__c);
                        system.debug('d:' + sr.department__c);
                        system.debug('a:' + sr.Project_Level__r.project__c);
                        system.debug('b:' + sr.Decisional_Unit__r.project__c);
                        Boolean findserviceTypeValue=false;
                        for(String serviceTypeValue: serviceTypeValues){
                            if((serviceTypeValue.contains('Super Division:') && serviceTypeValue.contains(sr.Super_Division__c+';')) ||
                               (serviceTypeValue.contains('Super Department:') && serviceTypeValue.contains(sr.Super_Department__c+';')) ||
                               (serviceTypeValue.contains('Division:') && serviceTypeValue.contains(sr.Division__c+';')) ||
                               (serviceTypeValue.contains('Department:') && serviceTypeValue.contains(sr.Department__c+';')) ||
                               (serviceTypeValue.contains('Sub Department:') && serviceTypeValue.contains(sr.Sub_Department__c+';')) ||
                               (serviceTypeValue.contains('Sub Department 2:') && serviceTypeValue.contains(sr.Sub_Department_2__c+';')) ||
                               (serviceTypeValue.contains('Cost Center:') && serviceTypeValue.contains(sr.Cost_Center__c+';')) ||
                               (serviceTypeValue.contains('Employee:') && childPDUEmpIDDetailsMap.containsKey(sr.Employee__c))){
                                findserviceTypeValue=true;
                                system.debug('*********8 IN IF');
                                //mapEmpIdError.put(sr.Emp_Id__c, sr.Emp_Id__c +': is invalid employee for the selected project. Project Decisional Unit record is not available for this employee. ');
                            } 
                        }
                        if(!findserviceTypeValue)
                            mapEmpIdError.put(sr.Emp_Id__c, sr.Emp_Id__c +': is invalid employee for the selected project. Project Decisional Org Level record is not available for this employee. ');   
                    } 
                }
                emp = null;
                //sr.Employee__c = null;
            }
            //Permission based on Super Division 
            /*List<String> superDivisionList = new List<String>();
            Project__c prj;
            for(Project_Level__c pl : mapProjectLevels.values()){
               if(prj == NULL)
                   prj = new Project__c(Id = pl.Project__c, Super_Division__c = pl.Project__r.Super_Division__c != NULL && pl.Project__r.Super_Division__c != ''? pl.Project__r.Super_Division__c + ',':''); 
               if(pl.Project__r.Super_Division__c != NULL){
                superDivisionList = pl.Project__r.Super_Division__c.split(',');
                setSuperDivisions.removeAll(superDivisionList);                         
                break;
               }                
            }
            superDivisionList.clear();
            superDivisionList.addAll(setSuperDivisions);
            if(prj != NULL ){
                prj.Super_Division__c = prj.Super_Division__c + String.join(superDivisionList, ',');
                update prj;
            }*/
            
            mapProjectLevels.clear();
            //mapEmployeeIdEmpId.clear();
            mapEmployees.clear();
            mapEmpIdUnvestedEquity.clear();
            //mapCovenantParameters.clear();
            mapProjectOrgDeptFields.clear();
            
            
            return mapEmpIdError;
            
        }/*else if(isDelete){
            updateProjectSuperDivision(mapOldSR.values());
        }else if(isInsert && !isBefore){
            updateProjectSuperDivision(listNewSR);
        }*/
        
        return new map<String,String>();
    }
    
    //MSN:RIF#117  Added new method
    public static list<Severance_And_Release__c> validatePrjtSyncSNR(String projectId,  List<Severance_And_Release__c> listSR, String mode){
        //listSR=[select id,Emp_Id__c,Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c from Severance_And_Release__c where id=:listSR[0].id];
        system.debug(' -- SR list -- ' + listSR);
        list<ApexPages.Message> pageMessages = new list<ApexPages.Message>();
        map<string, Severance_And_Release__c> mapSRToUpsert = new map<string, Severance_And_Release__c>();
        set<String> empIds = new Set<String>(); 
        for(Severance_And_Release__c sr : listSR){
            System.debug('Inside validateAndCreateSR() sr.Emp_Id__c:'+sr.Emp_Id__c);
            mapSRToUpsert.put(sr.Emp_Id__c, sr); 
            empIds.add(sr.Emp_Id__c);
        }
        map<String, Employee__c> mapEmp = new map<String, Employee__c>();
        System.debug('Inside validateAndCreateSR() empIds###'+empIds); 
        list<Employee__c> lstEmp = RIF_DataUtil.getEmployeesForEmpIds(empIds); 
        System.debug('###lstEmp####'+RIF_DataUtil.getEmployeesForEmpIds(empIds));
        empIds.clear();
        for(Employee__c emp : lstEmp){
            mapEmp.put(emp.Emp_Id__c, emp); 
        }  
        for(Severance_And_Release__c sr : listSR){
            if(mapEmp.containsKey(sr.Emp_Id__c)){
                mapSRToUpsert.put(sr.Emp_Id__c, sr);
            }          
        }
        mapEmp.clear();
        
        User user = RIF_DataUtil.getUserDetails(UserInfo.getUserId());
        Set<String> setDisqualifiedSRForUserCoverage = new set<String>();  
        if(user.Profile.Name != SYSTEM_ADMINISTRATOR ){
            Map <string,set <string>> covTypeToCodeMap= new Map <string,set <string>> (RIF_DataUtil.getLoggedInUSerCovEntitlementTypeWithCode(Userinfo.getuserID()));
            
            System.debug('####covTypeToCodeMap####'+covTypeToCodeMap);
            System.debug('####listSR####'+listSR);
            
            //Added by Anshul on July 17,2015 for restricting the S&R to be created by the Non-coverage HR User
            for(Severance_And_Release__c sr : RIF_DataUtil.getDisqualifiedSRForUserCoverage(listSR,covTypeToCodeMap)){
                setDisqualifiedSRForUserCoverage.add(sr.Emp_Id__c); 
                pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ': Selected employee does not exist in your Coverage Area.'));
                mapSRToUpsert.remove(sr.Emp_Id__c);      
            } 
            System.debug('####setDisqualifiedSRForUserCoverage####'+setDisqualifiedSRForUserCoverage);
        }  
        for(ApexPages.Message msg : pageMessages){
            ApexPages.addMessage(msg);
        }           
        return mapSRToUpsert.values();
        
    }
    
    //public static list<Severance_And_Release__c> validateAndCreateSR(set<string> employeeIds, String projectId, String recordTypeId, List<Severance_And_Release__c> listSR)
    public static list<Severance_And_Release__c> validateAndCreateSR(String projectId, String recordTypeId, List<Severance_And_Release__c> listSR, String mode){
        //listSR=[select id,Emp_Id__c,Employee__r.Super_Division__c,Employee__r.Division_Org__c,Employee__r.Super_Depart_Org__c,Employee__r.Dept_Org__c,Employee__r.Subdept_Org__c,Employee__r.Sub_Depart2_Org__c,Employee__r.Cost_Center__c from Severance_And_Release__c where id=:listSR[0].id];
        system.debug(' -- SR list -- ' + listSR);
        list<ApexPages.Message> pageMessages = new list<ApexPages.Message>();
        map<string, Severance_And_Release__c> mapSRToUpsert = new map<string, Severance_And_Release__c>();
        set<String> empIds = new Set<String>(); 
        for(Severance_And_Release__c sr : listSR){
            System.debug('Inside validateAndCreateSR() sr.Emp_Id__c:'+sr.Emp_Id__c);
            mapSRToUpsert.put(sr.Emp_Id__c, sr); 
            empIds.add(sr.Emp_Id__c);
        }
        map<String, Employee__c> mapEmp = new map<String, Employee__c>();
        System.debug('Inside validateAndCreateSR() empIds###'+empIds); 
        list<Employee__c> lstEmp = RIF_DataUtil.getEmployeesForEmpIds(empIds); 
        System.debug('###lstEmp####'+RIF_DataUtil.getEmployeesForEmpIds(empIds));
        empIds.clear();
        for(Employee__c emp : lstEmp){
            mapEmp.put(emp.Emp_Id__c, emp); 
        }
        System.debug('##Inside validateAndCreateSR() mapEmp#######'+mapEmp);
        for(Severance_And_Release__c sr : listSR){
            if(mapEmp.containsKey(sr.Emp_Id__c)){
                mapSRToUpsert.put(sr.Emp_Id__c, sr);
            }else{
                pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ': Selected employee is not a valid employee.'));
            }                
        }
        mapEmp.clear();

        map<String,Project_Level__c> mapKeyFieldsProjectLevel = new map<String,Project_Level__c>();
        set<String> setEmpIdsForExistingSR = new set<String>();
        String projectCountry;
        String keyFieldString;
        boolean isError;
        
        Project__c currProject=RIF_DataUtil.getProject(projectId)[0];
        system.debug('###currProject.status__c####'+currProject.status__c);
        if(currProject.status__c.equalsIgnoreCase('Closed') && mode == null){ 
            for(Severance_And_Release__c sr : listSR){   //RIF_DataUtil.findAllSeveranceAndReleaseInProject(mapSRToUpsert.keySet(), projectId)
                system.debug('###sr.Emp_Id__c####'+sr.Emp_Id__c);
                setEmpIdsForExistingSR.add(sr.Emp_Id__c);
                pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ':Employee can\'t be added employees to Closed project'));
                mapSRToUpsert.remove(sr.Emp_Id__c);  
            }
        } 
        if(!currProject.status__c.equalsIgnoreCase('Model') && mode == null){
            system.debug(' -- mapSRToUpsert.keySet() -- ' + mapSRToUpsert.keySet());
            system.debug(' -- project -- ' + projectId);
            // 4-July-2017 : JIRA#88 : When adding an employee to a project, the employee should not be present in any other ACTIVE project
            /*
            for(Severance_And_Release__c sr : RIF_DataUtil.findSeveranceAndReleaseInProject(mapSRToUpsert.keySet(), projectId)){
                system.debug(' -- sr -- ' + sr);
                setEmpIdsForExistingSR.add(sr.Emp_Id__c);
                pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ': Selected employee is already a member of '+sr.Project_Level__r.Project__r.name+' project'));
                mapSRToUpsert.remove(sr.Emp_Id__c);
            }
			*/
            for(Severance_And_Release__c sr : RIF_DataUtil.findSNRInActiveProject(mapSRToUpsert.keySet())){
                setEmpIdsForExistingSR.add(sr.Emp_Id__c);
                pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ': Selected employee is already a member of '+sr.Project_Level__r.Project__r.name+' project'));
                mapSRToUpsert.remove(sr.Emp_Id__c);
            }
        } 
        
        for(Project_Level__c pl : RIF_DataUtil.getProjectLevelsForProject(projectId)){
            mapKeyFieldsProjectLevel.put(pl.Country__c +'-'+ pl.Level_Dsc__c +'-'+ pl.MS_MSSB__c +'-'+ pl.Level__c,pl);
            projectCountry = pl.project__r.Country__c;
        }
        system.debug('keyfieldsprojectlevel:' + mapKeyFieldsProjectLevel);
        
        // get employee list and check
        // 1. employee country matches with project country.
        // 2. a matching project level exists for employee
        // 3. matching project level severance parameter exicsts
        // If all the above conditions match then create a new SR record else show appropriate error message on page.
        //Added by Anshul on July 17,2015 for restricting the S&R to be created by the Non-coverage HR User
        User user = RIF_DataUtil.getUserDetails(UserInfo.getUserId());
        Set<String> setDisqualifiedSRForUserCoverage = new set<String>();  
        if(user.Profile.Name != SYSTEM_ADMINISTRATOR ){
            Map <string,set <string>> covTypeToCodeMap= new Map <string,set <string>> (RIF_DataUtil.getLoggedInUSerCovEntitlementTypeWithCode(Userinfo.getuserID()));
            
            System.debug('####covTypeToCodeMap####'+covTypeToCodeMap);
            System.debug('####listSR####'+listSR);
            
            //Added by Anshul on July 17,2015 for restricting the S&R to be created by the Non-coverage HR User
            for(Severance_And_Release__c sr : RIF_DataUtil.getDisqualifiedSRForUserCoverage(listSR,covTypeToCodeMap)){
                setDisqualifiedSRForUserCoverage.add(sr.Emp_Id__c); 
                pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ': Selected employee does not exist in your Coverage Area.'));
                mapSRToUpsert.remove(sr.Emp_Id__c);      
            } 
            System.debug('####setDisqualifiedSRForUserCoverage####'+setDisqualifiedSRForUserCoverage);
        }   
        for(Employee__c emp : lstEmp){ 
            isError = false;
            if( (!setEmpIdsForExistingSR.contains(emp.Emp_Id__c)) && ((!setDisqualifiedSRForUserCoverage.contains(emp.Emp_Id__c))) ){
                
                if(projectCountry != emp.Job_Country_Job__c ){
                    isError = true;
                    pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, emp.Emp_ID__c + ': Selected employee is not valid employee for this project. Employee\'s Country is not matching with current project.'));
                }       
                keyFieldString = emp.Job_Country_Job__c+'-'+emp.Level_Dsc_Job__c+'-'+emp.MS_MSSB__c+'-'+emp.Level_Job__c;
                if(!mapKeyFieldsProjectLevel.containsKey(keyFieldString)){
                    isError = true;
                    pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, emp.Emp_ID__c + emp.Level_Dsc_Job__c+emp.MS_MSSB__c+emp.Level_Job__c+': Parameter record is not available for employee\'s Country, Level_Dsc, MS_MSSB and Level_Job. Please create a new Paramater Record.'));
                }else if(mapKeyFieldsProjectLevel.get(keyFieldString).Severance_Parameters__c == null){
                    isError = true;
                    pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, emp.Emp_ID__c + ': Severance Parameter is not available for employee\'s Country, MS-MSSB, Job level.'));
                }
                System.debug('####isError ####'+isError);
                
                if(!isError){
                    //MSN:RIF#121 Added if mode!='empSync' condition and taken Project_Level__c up
                    
                    mapSRToUpsert.get(emp.Emp_Id__c).Project_Level__c = mapKeyFieldsProjectLevel.get(keyFieldString).Id;
                    if(mode!='empSync')
                    {
                        system.debug('key:' + keyFieldString);
                        system.debug('keyget:' + mapKeyFieldsProjectLevel.get(keyFieldString));
                        
                        mapSRToUpsert.get(emp.Emp_Id__c).recordTypeId = recordTypeId;
                        
                        //Added by Anshul on 12 june 2015
                        mapSRToUpsert.get(emp.Emp_Id__c).Project__c = mapKeyFieldsProjectLevel.get(keyFieldString).Project__c;
                        //mapSRToUpsert.get(emp.Emp_Id__c).Active_Project__c = mapKeyFieldsProjectLevel.get(keyFieldString).Project__c;  
                        mapSRToUpsert.get(emp.Emp_Id__c).Employee__c = emp.id;
                        if(mapSRToUpsert.get(emp.Emp_Id__c).status__c == null || mapSRToUpsert.get(emp.Emp_Id__c).status__c == '')
                            mapSRToUpsert.get(emp.Emp_Id__c).status__c ='Selected'; 
                        //Added by Anshul on 18 june 2015 to populate project decisional unit on S&R level
                        Set <string> tempProjectSet= new Set <string>();
                        tempProjectSet.add(mapSRToUpsert.get(emp.Emp_Id__c).Project__c);
                        Set <string> decisionunitCodes= new Set <string>(); 
                        decisionunitCodes.add(emp.Cost_Center__c);
                        decisionunitCodes.add(emp.Sub_Depart2_Org__c);
                        decisionunitCodes.add(emp.Subdept_Org__c);
                        decisionunitCodes.add(emp.Dept_Org__c);
                        decisionunitCodes.add(emp.Super_Depart_Org__c);
                        decisionunitCodes.add(emp.Division_Org__c);
                        decisionunitCodes.add(emp.Super_Division__c);
                        decisionunitCodes.add(emp.Emp_ID__c); // 07-18-2016 : Add the employee ID
                        system.debug('***tempProjectSet:' + tempProjectSet);
                        for(Child_Project_Decisional_Unit__c childPdu:  RIF_DataUtil.getProjectDecisionalOrgLevelsOnProjectId(tempProjectSet)){
                            system.debug('childPdu.Decisional_Unit_Type__c:' + childPdu.Decisional_Unit_Type__c);
                            system.debug('childPdu.Decisional_Unit_Derived__c oooooooo:' + childPdu.Decisional_Unit_Derived__c);
                            //checking the decision unit type codes with the employees data corresponding to the decision type
                            // 07-18-2016 : Added check for Employee type PDU
                            // 28-July-2016 Ginto : changes to assign the values if child PDU type is Employee -- START
                            if(childPdu.Decisional_Unit_Type__c != 'Employee' && decisionunitCodes.contains(childPdu.Decisional_Unit_Derived__c) && mapSRToUpsert.get(emp.Emp_Id__c).Project_Decisional_Org_Level__c == null && mapSRToUpsert.get(emp.Emp_Id__c).Decisional_Unit__c == null ){
                                system.debug('childPdu.Decisional_Unit_Derived__c:' + childPdu.Decisional_Unit_Derived__c);
                                system.debug('decisionunitCodes.contains(childPdu.Decisional_Unit_Derived__c) First Time:' + decisionunitCodes.contains(childPdu.Decisional_Unit_Derived__c));
                                mapSRToUpsert.get(emp.Emp_Id__c).Decisional_Unit__c=childPdu.Project_Decisional_Unit__c;
                                mapSRToUpsert.get(emp.Emp_Id__c).Project_Decisional_Org_Level__c= childPdu.id; 
                            }
                            else if(decisionunitCodes.contains(childPdu.Emp_ID__c) && mapSRToUpsert.get(emp.Emp_Id__c).Project_Decisional_Org_Level__c == null && mapSRToUpsert.get(emp.Emp_Id__c).Decisional_Unit__c == null){
                                mapSRToUpsert.get(emp.Emp_Id__c).Decisional_Unit__c=childPdu.Project_Decisional_Unit__c;
                                mapSRToUpsert.get(emp.Emp_Id__c).Project_Decisional_Org_Level__c= childPdu.id; 
                            }
                            // 28-July-2016 Ginto : changes to assign the values if child PDU type is Employee -- END
                        }
                        
                        //End of the code added on 18 june
                        system.debug('mapSRToUpsert:' + mapSRToUpsert);
                        
                        /*mapSRToUpsert.put(emp.Id, new Severance_And_Release__c(Employee__c = emp.Id, 
Emp_Id__c = emp.Emp_Id__c, 
recordTypeId = recordTypeId, 
Project_Level__c = mapKeyFieldsProjectLevel.get(keyFieldString).Id));*/
                    }
                    
                }else{
                    mapSRToUpsert.remove(emp.Emp_Id__c);
                }
            }
        } 
        system.debug('Before return mapSRToUpsert:' + mapSRToUpsert);
        for(ApexPages.Message msg : pageMessages){
           ApexPages.addMessage(msg);
        }           
        return mapSRToUpsert.values();
   }
   
   //Added for sharing S&R records with Comp and Ops User while record creation
   public static void shareSRWithRIFRoles(List<Severance_And_Release__c > listNewSRs){
       // Map<Id,Permissionset> sysAdminPermissionMap= new Map<Id,Permissionset> ();
        Set <id> srIDsComp= new Set <id>  ();
        Set <id> srIDsOps= new Set <id>  ();
        Map<Id,Permissionset> OperationsPermissionMap= new Map<Id,Permissionset>();
        Map<Id,Permissionset> compensationPermissionMap= new Map<Id,Permissionset>();
        Map <string,string> covTypeToCodeMap= new Map <string,string> ();
        set<Id> OperationsUsers= new set<Id>();
        set<Id> compensationUsers=new set<Id>();
        //set<Id> sysAdminUsers=new set<Id>();
        
        //sysAdminPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_System_Admin']);
        OperationsPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Operations']); 
        compensationPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Compensation']);
        /*for(Severance_And_Release__c sr:listNewSRs){
            checkSRRecordAccessibleForUser();
            srIDs.add(sr.id);   
        }*/
       
        if(OperationsPermissionMap!= null && OperationsPermissionMap.keyset() != null && OperationsPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment perAssignmentObj:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:OperationsPermissionMap.keyset()]){
                Set <id> accessibleRecordIds= new Set <id>(Rif_DataUtil.checkSRRecordAccessibleForUser(listNewSRs,perAssignmentObj.assigneeid)); 
                if(accessibleRecordIds.size()>0)
                    RIF_Sharing.shareSRListWithUsers(accessibleRecordIds,new Set <id> {perAssignmentObj.assigneeid},'Edit');
            }
            
            
        }
        if(compensationPermissionMap!= null && compensationPermissionMap.keyset() != null && compensationPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment perAssignmentObj:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:compensationPermissionMap.keyset()]){
                Set <id> accessibleRecordIds= new Set <id>(Rif_DataUtil.checkSRRecordAccessibleForUser(listNewSRs,perAssignmentObj.assigneeid)); 
      			system.debug('***********accessibleRecordIds'+accessibleRecordIds);
                if(accessibleRecordIds.size()>0)
                    RIF_Sharing.shareSRListWithUsers(accessibleRecordIds,new Set <id> {perAssignmentObj.assigneeid},'Read');
            }
          
        }
    } 
    
    
      
    
    
    //added on 27/10/2015 for changing the s&r record type from project based to one off
    public static void changeSRRecordTpe(Severance_And_Release__c newSRRecord){
        list<ApexPages.Message> pageMessages = new list<ApexPages.Message>();
        Project_Level__c pl_newSRRecord=[select id,Severance_Parameters__c,MS_MSSB__c,Level_Dsc__c,Country__c from Project_Level__c where id=:newSRRecord.Project_Level__c];
        final string recordTypeID;
        //string SOBJECT_NAME = 'Severance_And_Release__c'; 
        string ONE_OFF_TERMINATION = 'One Off Termination';
        string project_OneOffRecordTypeId = '';
        string sr_OneOffRecordTypeId = '';
        
        List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(ONE_OFF_TERMINATION);
        for(RecordType rt : lstRT){
           if(rt.SobjectType == 'Project__c'){
               project_OneOffRecordTypeId = rt.Id;
           }
           if(rt.SobjectType == 'Severance_And_Release__c'){
               sr_OneOffRecordTypeId = rt.Id;
           }
        }
        if(newSRRecord.recordTypeID==sr_OneOffRecordTypeId){
            //clone multiple termination project and attach to the s&R record as one off project
                 // COPY THE FIELDS THAT ARE TO BE CLONED
                 //Project__c proj = [select Id ,Primary_Key__c,Country__c,Status__c,Termination_Date__c,Name,Template1__c,Communication_Date__c,Master_Project__c,S_R_Warn_Count__c,Notice_Days__c,WARN__c,System_Super_Division__c from Project__c where id=:newSRRecord.project__c];
                 Project__c proj = RIF_DataUtil.getProject(newSRRecord.project__c)[0];
            	 
                 system.debug('###old proj###'+proj );
                 Project__c newproj= new Project__c(); 
                 newproj=proj.clone(false);
                 newproj.name='One-Off- '+newSRRecord.Last_Name__c+', '+newSRRecord.First_Name__c+ '_'+dateTime.now();
                 newproj.Primary_Key__c = ''; 
                 newproj.recordTypeID=project_OneOffRecordTypeId;
                 insert newproj;
                 system.debug('###new proj###'+newproj.id+'##'+newproj.name);
                 
                 //getting severance parameters
                 
                 List<Severance_Parameters__c> spList = RIF_DataUtil.getSeverancePrameters(pl_newSRRecord.Country__c, pl_newSRRecord.MS_MSSB__c, pl_newSRRecord.Level_Dsc__c);
                 if(spList.isEmpty()){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Severance Parameter is not available for provided Country, MS-MSSB, Job level.'));
                    //return null;
                    newSRRecord.addError('Severance Parameter is not available for provided Country, MS-MSSB, Job level.');
                 }
                 /*else{
                    spList[0];
                 }*/
                // Project Level Record Creation
                Project_Level__c pl = RIF_DataUtil.cloneSevParamToProjectLevel(spList [0]);
                pl.Project__c = newproj.Id;
                pl.Country__c = newproj.Country__c;
                pageMessages = RIF_DataUtil.insertResult(new List<SObject>{pl});
                
                // Project Decisional Unit Record Creation
                Project_Decisional_Unit__c pdu= new Project_Decisional_Unit__c ();
                pdu.Project__c = newproj.Id;
            	// 12-Jan-2017 : ALM#1817 : Adding the generic name to the One-Off project's PDU
            	pdu.Decisional_Unit_Name__c = 'Generic Decisional Unit on One Off';
                pageMessages = RIF_DataUtil.insertResult(new List<SObject>{pdu});
                
            	// 18-July-17 : JIRA#RIF-93 : Stop creation of One-Off project if the previous project Status is 'Model'
                 if(String.valueOf(proj.Status__c).equalsIgnoreCase('Model')){
                     pageMessages.add(new ApexPages.Message(ApexPages.Severity.ERROR, newSRRecord.Emp_Id__c + ': ' + Label.RIF_ModelProject_Warning));
                 }

                //check the error messages and add error if any
                if(!pageMessages.isEmpty()){
                    String errorMessagesString='';
                    for(ApexPages.Message msg : pageMessages){
                       ApexPages.addMessage(msg);
                       errorMessagesString+=msg;
                    }
                    newSRRecord.adderror(errorMessagesString);
                }
                // 12-Jan-2017 : ALM#1817 : Removing the creation of child PDU while inserting a new One-Off project --- STARTS
                /*
                // org PDU Record Creation
               Child_Project_Decisional_Unit__c childPDU= new Child_Project_Decisional_Unit__c();
               childPDU.Project_Decisional_Unit__c = pdu.Id;
               childPDU.ProjectID__c=newproj.Id;
               childPDU.Decisional_Unit_Type__c='Super Division';
           		// 1-Sep-2016 : Org Hierarchy changes -- STARTS
				
               //List<Org_Codes__c> orgCode = new List<Org_Codes__c> ([SELECT Id,Name, Code_Type__c, Code__c from org_codes__c where code_type__c = 'Super Division' and code__c =:newSRRecord.Super_Division__c]);
         		List<Org_Hierarchy__c> orgHierCode = new List<Org_Hierarchy__c> ([SELECT Id,Name,Super_Division__c, Super_Division_Description__c FROM Org_Hierarchy__c WHERE Super_Division__c =: newSRRecord.Super_Division__c LIMIT 1]);
				// TODO get the correct query and conditions
				
               if(orgHierCode != null && !orgHierCode.isEmpty())
                //childPDU.Decisional_Unit_Code__c=orgHierCode[0].ID;
				childPDU.Org_Hierarchy__c = orgHierCode[0].Id;
               pageMessages = RIF_DataUtil.insertResult(new List<SObject>{childPDU});
               //check the error messages and add error if any
                if(!pageMessages.isEmpty()){
                    String errorMessagesString='';
                    for(ApexPages.Message msg : pageMessages){
                       ApexPages.addMessage(msg);
                       errorMessagesString+=msg;
                    }
                    newSRRecord.adderror(errorMessagesString);
                }   */
                // 1-Sep-2016 : Org Hierarchy changes -- ENDS
                //change the project id from the s&r to newly created project
                newSRRecord.project__c=newproj.id;
                newSRRecord.active_project__c=newproj.id;
                newSRRecord.recordTypeID=sr_OneOffRecordTypeId;
                newSRRecord.Project_Level__c=pl.id;
                newSRRecord.Decisional_Unit__c=pdu.id;
                //newSRRecord.Project_Decisional_Org_Level__c=childPDU.id;
				// 12-Jan-2017 : ALM#1817 : Removing the creation of child PDU while inserting a new One-Off project --- ENDS                 
                
        }
        
        //stop update trigger on S&R
        RIF_StopDuplicateAccrualByWorkflow.stopSRUpdateFromProject=true; 
            
    }
    public static void deleteOneOffproject(List<Severance_And_Release__c > listOldSR, map <id,Severance_And_Release__c> oldSRMap){
        
        string ONE_OFF_TERMINATION = 'One Off Termination';
        list <Severance_And_Release__c> oldSRList= new list <Severance_And_Release__c> (RIF_DataUtil.getSeveranceAndReleaseListFromSetIds(oldSRMap.keyset()));
        System.debug('####entered into deleteOneOffproject() oldSRList#####'+oldSRList); 
        Set <id> oneOffprojIDs= new Set <id> ();
        Id project_OneOffRecordTypeId;
        List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(ONE_OFF_TERMINATION);
        for(RecordType rt : lstRT){
           if(rt.SobjectType == 'Project__c'){
               project_OneOffRecordTypeId = rt.Id; 
           }
        }
        for(Severance_And_Release__c sr : oldSRList){
            System.debug('####sr.project__r.recordtypeID#####'+sr.project__r.recordtypeID+'###project_OneOffRecordTypeId####'+project_OneOffRecordTypeId);
            if(sr.project__r.recordtypeID==project_OneOffRecordTypeId)
                oneOffprojIDs.add(sr.project__c);   
        }
        /*List <Project_Decisional_Unit__c> DecisionalList=new List <Project_Decisional_Unit__c>(RIF_DataUtil.getProjectDecisionalUnitOnProjectIdsSet(oneOffprojIDs));
        List <Project_Level__c> parameterLevelList=new List <Project_Level__c>(Rif_DataUtil.getProjectLevelsForMassProjects(oneOffprojIDs));       
        if(DecisionalList!=null && DecisionalList.size() > 0){
            delete DecisionalList;
        }
        if(parameterLevelList!=null && parameterLevelList.size()>0)
            delete parameterLevelList; */ 
        System.debug('####oneOffprojIDs#####'+oneOffprojIDs);
        List <project__c> deletedOneOffProjectsList= new List <project__c>(RIF_DataUtil.getProjectListFromIds(oneOffprojIDs));
        System.debug('####deletedOneOffProjectsList#####'+deletedOneOffProjectsList);
        if(deletedOneOffProjectsList!=null && deletedOneOffProjectsList.size()>0){
            RIF_StopRecursiveloopOnDeleteOneOffSR.stopRecursion=true;
            delete deletedOneOffProjectsList;
        }
    }
   
    // 17-Apr-2017 : Check if the new SNR does not already exist in the current project
    // this method will check if the SNR that will be inserted in the project, is not a duplicate one
    public static void checkDuplicateSNRRecord(List<Severance_And_Release__c> newSNRsList){
        // store the projects and their corresponding emp ids
        Map<String,Set<String>> projectAndEmpIdsMap = new Map<String,Set<String>>();
        Set<String> projectIdsSet = new Set<String>();
        if(newSNRsList != null && !newSNRsList.isEmpty()){
            for(Severance_And_Release__c snr : newSNRsList){
                if(snr.Record_Type__c != 'One Off Termination'){
                    projectIdsSet.add(snr.Project__c);
                }
            }
            system.debug(' -- projectIdsSet -- ' + projectIdsSet);
            if(projectIdsSet != null && !projectIdsSet.isEmpty()){
                for(String eachPrj : projectIdsSet){
                    Set<String> tempEmpIdSet = new Set<String>();
                    for(Severance_And_Release__c eachSNR : newSNRsList){
                        if(String.valueOf(eachSNR.Project__c) == eachPrj){
                            // add the emp id in the set
                            tempEmpIdSet.add(eachSNR.Emp_Id__c);
                        }
                    }
                    if(tempEmpIdSet != null && !tempEmpIdSet.isEmpty()){
                        projectAndEmpIdsMap.put(eachPrj,tempEmpIdSet);
                    }
                }
            }
            system.debug(' -- projectAndEmpIdsMap -- ' + projectAndEmpIdsMap);
            if(projectAndEmpIdsMap != null && !projectAndEmpIdsMap.isEmpty()){
                for(Severance_and_Release__c snr : [SELECT Id,Emp_Id__c,Project__c FROM Severance_and_Release__c WHERE Project__c IN : projectAndEmpIdsMap.keySet() AND Project__r.Status__c = 'Active']){
                    if(projectAndEmpIdsMap.containsKey(snr.Project__c) && projectAndEmpIdsMap.get(snr.Project__c).contains(snr.Emp_Id__c)){
                        for(Severance_And_Release__c sr : newSNRsList){
                            if(sr.Project__c == snr.Project__c && sr.Emp_Id__c == snr.Emp_Id__c){
                                sr.addError('You are attempting to add a duplicate employee to the same project!');
                            }
                        }
                    }
                }
            }
        }
    }
    
}