/** Batch class to check the updated Org Hierarchy records and process it to recalculate sharing rules
for Severance and Release object based on the updated Cost center and other information  **/
global class RIF_OrgHierarchySharingRecalBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    // member initialization
    public static boolean batch=false;
    Set<String> empSet,sNrIds,prjSet;
    List<Severance_and_release__c> affectedSNRsLst,renameAffectedSNRLst;
    List<Severance_and_release__share> sNrShareRecords;
    Set<Severance_and_release__share> allShareRecords,delShareRecords;
    Map<String, Employee__c> empMap; 
    Map<ID, Employee__c> affectedEmpMap;
    Map<String,Severance_and_Release__c> snrFinalUpdateMap = new Map<String,Severance_and_Release__c>();
    Map<String,Severance_and_Release__c> oneOffSNRsMap;
    Map<String,Map<String,String>> snrOrgChangeMap = new Map<String,Map<String,String>>();
    //static fields for sending emails
    Map<String,String> projectOwnerId = new Map<String,String>(); 
    Map<ID,String> projectIdName = new Map<ID,String>();
    Map<String,String> projectOwnerEmail = new Map<String,String>(); 
    List<String> rifSYSADMINs = new List<String>();
    List<String> rifSuperUsers = new List<String>();
    // used for sending emails
    global Map<String,String> projectOwnerIdForMail = new Map<String,String>();  
    global Map<String,String> projectOwnerEmailForMail = new Map<String,String>(); 
    global Set<String> prjSetForMail = new Set<String>();
    
    //1) Get All SnRs within the Active projects whose status is not Credit and who are not communicated
    string getAllSNR_query = 'SELECT Id,Name,Status__c,Communicated__c,Emp_id__c,Record_Type__c,' +
        'Cost_Center__c,Sub_Department__c,Sub_Department_2__c,Department__c,Super_Department__c,Division__c,Super_Division__c,' +
        'Cost_Center_Desc__c,Sub_Department_Desc__c,Sub_Department_2_Desc__c,Department_Desc__c,Super_Department_Desc__c,Division_Desc__c,Super_Division_Desc__c,' +
        'Project__c,Project__r.Name,Project__r.Record_Type__c,Decisional_Unit__c,Project_Decisional_Org_Level__c,OwnerId ' +
        'FROM Severance_and_Release__c WHERE Communicated__c = false AND Status__c IN (\'Selected\', \'Not Selected\') ' +
        'AND Project__c IN (SELECT Id FROM Project__c WHERE Status__c = \'Active\') ' +
      	'AND Historical_Data_Load__c = false';
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        // get all the active SNR in the system
        return Database.getQueryLocator(getAllSNR_query);    
    }
    
    
    global void execute(Database.BatchableContext bc, List<Severance_and_release__c> snrList){
        
        //2) Get All employee data for selected snrs:
        batch=true;
        empSet = new set<String>();
        system.debug(' -- execute -- : snrList --'  + snrList.size());
        
        if(!snrList.isEmpty()){
            for(Severance_and_Release__c s : snrList){
                if(s.Emp_Id__c <> null)
                    empSet.add(s.Emp_Id__c);
            }
            system.debug(' -- empSet -- ' + empSet.size());
            
            affectedEmpMap = new Map<ID, Employee__c>();
            List<Employee__c> empLst = [SELECT Id,Status__c,Emp_id__c,
                                        Cost_Center__c,Sub_Depart2_Org__c,Subdept_Org__c,Dept_Org__c,Super_Depart_Org__c,Division_Org__c,Super_Division__c,
                                        Cost_Center_Desc__c,Sub_Depart2_Dsc_Org__c,Subdept_Dsc_Org__c,Dept_Dsc_Org__c,Super_Depart_Dsc_Org__c,Division_Dsc_Org__c,Super_Division_Dsc_Org__c
                                        FROM Employee__c WHERE Emp_id__c IN : empSet];
            system.debug(' -- empLst -- ' + empLst.size());
            empMap = new Map<String, Employee__c>();
            
            if(!empLst.isEmpty()){
                for(Employee__c emp : empLst){
                    empMap.put(emp.Emp_Id__c, emp);
                }
            }
            system.debug(' -- empMap -- ' + empMap);
            system.debug(' -- EXE snrList -- ' + snrList.size());
            system.debug(' -- snrList--  ' + snrList);
            
            affectedSNRsLst = new List<Severance_and_Release__c>();
            renameAffectedSNRLst = new List<Severance_and_Release__c>();
            oneOffSNRsMap = new Map<String,Severance_and_Release__c>();
            list<Severance_and_release__c> snrTOBEUPDATEDList = new list<Severance_and_release__c>();
            Set<String> costCenterSet,subDepart2Set,subDepartSet,DepartSet,superDepartSet,DivisionSet,superDivisionSet;
            costCenterSet = new Set<String>();
            subDepart2Set = new Set<String>();
            subDepartSet = new Set<String>();
            DepartSet = new Set<String>();
            superDepartSet = new Set<String>();
            DivisionSet = new Set<String>();
            superDivisionSet = new Set<String>();
            Set<String> affectedPDUIds = new Set<String>(); // store all the IDs of the changes PDUs
            Map<String,Set<String>> newSNROrgCodes = new Map<String,Set<String>>();
            Map<String,Map<String,String>> renameChangesMap = new Map<String,Map<String,String>>();
            //3) Loop through all SNRs and identify what Org level information got changed from Employee to SNR
            // 13-Feb-17 : Added the logic to update the changed org code's description as well
            for(Severance_and_Release__c s : snrList){
                if(empMap.containsKey(s.emp_id__c) && ( s.Cost_Center__c != empMap.get(s.emp_id__c).Cost_Center__c || s.Sub_Department__c != empMap.get(s.EMP_ID__C).Subdept_Org__c || s.Sub_Department_2__c != empMap.get(s.EMP_ID__C).Sub_Depart2_Org__c
                                                       || s.Department__c != empMap.get(s.EMP_ID__C).Dept_Org__c || s.Super_Department__c != empMap.get(s.EMP_ID__C).Super_Depart_Org__c || s.Division__c != empMap.get(s.EMP_ID__C).Division_Org__c 
                                                       || s.Super_Division__c != empMap.get(s.EMP_ID__C).Super_Division__c )){
                                                           affectedEmpMap.put(s.ID, empMap.get(s.emp_id__c));
                                                           Set<String> newOrgCodes = new Set<String>();
                                                           Map<String,String> tempChangesMap = new Map<String,String>();
                                                           
                                                           if(s.Cost_Center__c != empMap.get(s.emp_id__c).Cost_Center__c){
                                                               costCenterSet.add(empMap.get(s.emp_id__c).Cost_Center__c);
                                                               s.Cost_Center__c = empMap.get(s.emp_id__c).Cost_Center__c;
                                                               s.Cost_Center_Desc__c = empMap.get(s.emp_id__c).Cost_Center_Desc__c;
                                                               newOrgCodes.add(empMap.get(s.emp_id__c).Cost_Center__c);
                                                               tempChangesMap.put('Cost Center',empMap.get(s.emp_id__c).Cost_Center__c);
                                                           }
                                                           
                                                           if(s.Sub_Department_2__c != empMap.get(s.EMP_ID__C).Sub_Depart2_Org__c){
                                                               subDepart2Set.add(empMap.get(s.EMP_ID__C).Sub_Depart2_Org__c);
                                                               s.Sub_Department_2__c = empMap.get(s.EMP_ID__C).Sub_Depart2_Org__c;
                                                               s.Sub_Department_2_Desc__c = empMap.get(s.EMP_ID__C).Sub_Depart2_Dsc_Org__c;
                                                               newOrgCodes.add(empMap.get(s.EMP_ID__C).Sub_Depart2_Org__c);
                                                               tempChangesMap.put('Sub Department 2',empMap.get(s.EMP_ID__C).Sub_Depart2_Org__c);
                                                           }
                                                           if( s.Sub_Department__c != empMap.get(s.EMP_ID__C).Subdept_Org__c){
                                                               subDepartSet.add(empMap.get(s.EMP_ID__C).Subdept_Org__c);
                                                               s.Sub_Department__c = empMap.get(s.EMP_ID__C).Subdept_Org__c;
                                                               s.Sub_Department_Desc__c = empMap.get(s.EMP_ID__C).Subdept_Dsc_Org__c;
                                                               newOrgCodes.add(empMap.get(s.EMP_ID__C).Subdept_Org__c);
                                                               tempChangesMap.put('Sub Department',empMap.get(s.EMP_ID__C).Subdept_Org__c);
                                                           }
                                                           if(s.Department__c != empMap.get(s.EMP_ID__C).Dept_Org__c ){
                                                               DepartSet.add(empMap.get(s.EMP_ID__C).Dept_Org__c);
                                                               s.Department__c = empMap.get(s.EMP_ID__C).Dept_Org__c;
                                                               s.Department_Desc__c= empMap.get(s.EMP_ID__C).Dept_Dsc_Org__c;
                                                               newOrgCodes.add(empMap.get(s.EMP_ID__C).Dept_Org__c);
                                                               tempChangesMap.put('Department',empMap.get(s.EMP_ID__C).Dept_Org__c);
                                                           }
                                                           if(s.Super_Department__c != empMap.get(s.EMP_ID__C).Super_Depart_Org__c){
                                                               superDepartSet.add(empMap.get(s.EMP_ID__C).Super_Depart_Org__c);
                                                               s.Super_Department__c = empMap.get(s.EMP_ID__C).Super_Depart_Org__c;
                                                               s.Super_Department_Desc__c = empMap.get(s.EMP_ID__C).Super_Depart_Dsc_Org__c;
                                                               newOrgCodes.add(empMap.get(s.EMP_ID__C).Super_Depart_Org__c);
                                                               tempChangesMap.put('Super Department',empMap.get(s.EMP_ID__C).Super_Depart_Org__c);
                                                               
                                                           }
                                                           if(s.Division__c != empMap.get(s.EMP_ID__C).Division_Org__c){
                                                               DivisionSet.add(empMap.get(s.EMP_ID__C).Division_Org__c);
                                                               s.Division__c = empMap.get(s.EMP_ID__C).Division_Org__c;
                                                               s.Division_Desc__c = empMap.get(s.EMP_ID__C).Division_Dsc_Org__c;
                                                               newOrgCodes.add(empMap.get(s.EMP_ID__C).Division_Org__c);
                                                               tempChangesMap.put('Division',empMap.get(s.EMP_ID__C).Division_Org__c);
                                                           }
                                                           if(s.Super_Division__c != empMap.get(s.EMP_ID__C).Super_Division__c ){
                                                               superDivisionSet.add(empMap.get(s.EMP_ID__C).Super_Division__c );
                                                               s.Super_Division__c = empMap.get(s.EMP_ID__C).Super_Division__c;
                                                               s.Super_Division_Desc__c = empMap.get(s.EMP_ID__C).Super_Division_Dsc_Org__c;
                                                               newOrgCodes.add(empMap.get(s.EMP_ID__C).Super_Division__c);
                                                               tempChangesMap.put('Super Division',empMap.get(s.EMP_ID__C).Super_Division__c);
                                                           }
                                                           affectedSNRsLst.add(s);
                                                           snrFinalUpdateMap.put(s.Id, s);
                                                           snrOrgChangeMap.put(s.Id, tempChangesMap); // holds the delta changes on SNR
                                                           
                                                           newSNROrgCodes.put(s.Id,newOrgCodes); // get all SNR and their new codes
                                                           
                                                       }
                // 12-Dec-2016 : New check to handle Org Level Description remaning,
                // if the org codes are the same, but description change, make the changes accordingly
                if(empMap.containsKey(s.emp_id__c) && 
                   ((s.Cost_Center__c == empMap.get(s.emp_id__c).Cost_Center__c && s.Cost_Center_Desc__c != empMap.get(s.emp_id__c).Cost_Center_Desc__c) ||
                    (s.Sub_Department_2__c == empMap.get(s.EMP_ID__C).Sub_Depart2_Org__c && s.Sub_Department_2_Desc__c != empMap.get(s.emp_id__c).Sub_Depart2_Dsc_Org__c) ||
                    (s.Sub_Department__c == empMap.get(s.EMP_ID__C).Subdept_Org__c && s.Sub_Department_Desc__c != empMap.get(s.emp_id__c).Subdept_Dsc_Org__c) ||
                    (s.Department__c == empMap.get(s.EMP_ID__C).Dept_Org__c && s.Department_Desc__c != empMap.get(s.emp_id__c).Dept_Dsc_Org__c) ||
                    (s.Super_Department__c == empMap.get(s.EMP_ID__C).Super_Depart_Org__c && s.Super_Department_Desc__c != empMap.get(s.emp_id__c).Super_Depart_Dsc_Org__c) ||
                    (s.Division__c == empMap.get(s.EMP_ID__C).Division_Org__c && s.Division_Desc__c != empMap.get(s.emp_id__c).Division_Dsc_Org__c) ||
                    (s.Super_Division__c == empMap.get(s.EMP_ID__C).Super_Division__c && s.Super_Division_Desc__c != empMap.get(s.emp_id__c).Super_Division_Dsc_Org__c))
                  ){
                      Map<String,String> renamedCodesMap = new Map<String,String>();
                      // check for specific level renaming
                      if(s.Cost_Center_Desc__c != empMap.get(s.emp_id__c).Cost_Center_Desc__c){
                          s.Cost_Center_Desc__c = empMap.get(s.emp_id__c).Cost_Center_Desc__c;
                          renamedCodesMap.put(s.Cost_Center__c, s.Cost_Center_Desc__c);
                      }
                      if(s.Sub_Department_2_Desc__c != empMap.get(s.emp_id__c).Sub_Depart2_Dsc_Org__c){
                          s.Sub_Department_2_Desc__c = empMap.get(s.emp_id__c).Sub_Depart2_Dsc_Org__c;
                          renamedCodesMap.put(s.Sub_Department_2__c, s.Sub_Department_2_Desc__c);
                      }
                      if(s.Sub_Department_Desc__c != empMap.get(s.emp_id__c).Subdept_Dsc_Org__c){
                          s.Sub_Department_Desc__c = empMap.get(s.emp_id__c).Subdept_Dsc_Org__c;
                          renamedCodesMap.put(s.Sub_Department__c, s.Sub_Department_Desc__c);
                      }
                      if(s.Department_Desc__c != empMap.get(s.emp_id__c).Dept_Dsc_Org__c){
                          s.Department_Desc__c = empMap.get(s.emp_id__c).Dept_Dsc_Org__c;
                          renamedCodesMap.put(s.Department__c, s.Department_Desc__c);
                      }
                      if(s.Super_Department_Desc__c != empMap.get(s.emp_id__c).Super_Depart_Dsc_Org__c){
                          s.Super_Department_Desc__c = empMap.get(s.emp_id__c).Super_Depart_Dsc_Org__c;
                          renamedCodesMap.put(s.Super_Department__c, s.Super_Department_Desc__c);
                      }
                      if(s.Division_Desc__c != empMap.get(s.emp_id__c).Division_Dsc_Org__c){
                          s.Division_Desc__c = empMap.get(s.emp_id__c).Division_Dsc_Org__c;
                          renamedCodesMap.put(s.Division__c, s.Division_Desc__c);
                      }
                      if(s.Super_Division_Desc__c != empMap.get(s.emp_id__c).Super_Division_Dsc_Org__c){
                          s.Super_Division_Desc__c = empMap.get(s.emp_id__c).Super_Division_Dsc_Org__c;
                          renamedCodesMap.put(s.Super_Division__c, s.Super_Division_Desc__c);
                      }
                    renameAffectedSNRLst.add(s); // the SNRs with updated Org description
                    renameChangesMap.put(s.Id,renamedCodesMap); // SNR id => org code => org desc(changed)
                }
                // store all the One Offs
                if(s.Record_Type__c == 'One Off Termination'){
                    oneOffSNRsMap.put(s.Id,s);
                }
            }
            system.debug(' -- affectedSNRsLst SIZE-- ' + affectedSNRsLst.size());
            system.debug(' -- EXE snrTOBEUPDATEDList -- ' + snrTOBEUPDATEDList.size());
            system.debug(' -- EXE affectedSNRsLst:: -- ' + affectedSNRsLst);
            system.debug(' -- snrOrgChangeMap -- ' + snrOrgChangeMap);
            system.debug(' -- renameAffectedSNRLst SIZE-- ' + renameAffectedSNRLst.size());
            system.debug(' -- renameAffectedSNRLst -- ' + renameAffectedSNRLst);
            system.debug(' -- renameChangesMap -- ' + renameChangesMap);
            system.debug(' -- oneOffSNRsMap-- '+ oneOffSNRsMap);
            if(!affectedSNRsLst.isEmpty() || !renameAffectedSNRLst.isEmpty()){
                sNrIds = new Set<String>();
                prjSet = new Set<String>();
                
                for(Severance_and_Release__c sNr : affectedSNRsLst){
                    sNrIds.add(sNr.id); // get all SnR IDs
                    prjSet.add(sNr.project__c); // get all Project IDs
                }
                
                system.debug(' -- EXE sNrIds -- ' + sNrIds.size());
                system.debug(' -- EXE prjSet -- ' + prjSet.size());
                system.debug(' -- EXE prjSet ::-- ' + prjSet);
                
                
                //Identify the existing PDUs and OrgLevelPDUs from affected SNR List
                set <string> existingOrgLevelPDUsIDSet = new set <string>();
                set <string> existingPDUsIDSet = new set <string>();
                List<Child_Project_Decisional_Unit__c> existingOrgLevelPDUList;
                Map<string, Child_Project_Decisional_Unit__c> tempMap;
                Map<string, Child_Project_Decisional_Unit__c> existingOrgLevelPDUsMap;
                List<Project_Decisional_Unit__c> existingPDUList;
                Map<string, Project_Decisional_Unit__c> tempMapPDU;
                Map<string, Project_Decisional_Unit__c> existingPDUsMap;
                
                /********************/
                for(Severance_and_Release__c sNr : affectedSNRsLst){
                    //add in set
                    existingPDUsIDSet.add(sNr.Decisional_Unit__c);
                    existingOrgLevelPDUsIDSet.add(sNr.Project_Decisional_Org_Level__c);
                    
                }     
                system.debug(' -- existingPDUsIDSet -- ' + existingPDUsIDSet);
                system.debug(' -- existingOrgLevelPDUsIDSet -- ' + existingOrgLevelPDUsIDSet);
                
                existingOrgLevelPDUList = [SELECT Id, name, Project__c,ProjectID__c, Org_Hierarchy_Code__c,Employee__c,Project_Decisional_Unit__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c, system_generated__c 
                                           FROM Child_Project_Decisional_Unit__c WHERE ID in:existingOrgLevelPDUsIDSet ];
                if(!existingOrgLevelPDUList.isEmpty() || !renameAffectedSNRLst.isEmpty() || !oneOffSNRsMap.isEmpty()){
                    tempMap = new  Map<string, Child_Project_Decisional_Unit__c>();
                    for(Child_Project_Decisional_Unit__c c: existingOrgLevelPDUList){
                        tempMap.put(c.id, c);
                    }   
                    existingOrgLevelPDUsMap = new  Map<string, Child_Project_Decisional_Unit__c>();
                    for(Severance_and_Release__c sNr : affectedSNRsLst){
                        if(tempMap.containsKey(sNr.Project_Decisional_Org_Level__c)){
                            existingOrgLevelPDUsMap.put(sNr.ID, tempMap.get(sNr.Project_Decisional_Org_Level__c));
                        }
                    }
                    system.debug(' -- existingOrgLevelPDUsMap -- ' + existingOrgLevelPDUsMap);
                    
                    //Get the NEW Org Level PDUs from SNR List,
                    map<string, string> tempStrMap = new map<string, string> ();
                    Map<String,String> empNewCode = new Map<String,String>();
                    list<string> tempList = new list<string> ();
                    for(string e: existingOrgLevelPDUsMap.keySet()){
                        for(string s: newSNROrgCodes.get(e)){
                            system.debug('####################e:'+e);
                            system.debug('####################s:'+s);
                            
                            if(existingOrgLevelPDUsMap.get(e).Decisional_Unit_Type__c == 'Cost Center' && existingOrgLevelPDUsMap.get(e).Decisional_Unit_Derived__c != s){//newSNROrgCodes.get(e).Cost_Center__c){//IF equal dont do anything
                                tempStrMap.put(e, s);
                                tempList.add(s);
                            }
                            if(existingOrgLevelPDUsMap.get(e).Decisional_Unit_Type__c == 'Sub Department' && existingOrgLevelPDUsMap.get(e).Decisional_Unit_Derived__c != s){//newSNROrgCodes.get(e).Sub_Department__c){//IF equal dont do anything
                                tempStrMap.put(e, s);
                                tempList.add(s);
                                
                            }
                            if(existingOrgLevelPDUsMap.get(e).Decisional_Unit_Type__c == 'Sub Department 2' && existingOrgLevelPDUsMap.get(e).Decisional_Unit_Derived__c != s){//newSNROrgCodes.get(e).Sub_Department_2__c){//IF equal dont do anything
                                tempStrMap.put(e, s);
                                tempList.add(s);
                                
                            }
                            if(existingOrgLevelPDUsMap.get(e).Decisional_Unit_Type__c == 'Department' && existingOrgLevelPDUsMap.get(e).Decisional_Unit_Derived__c != s){//newSNROrgCodes.get(e).Department__c){//IF equal dont do anything
                                tempStrMap.put(e, s);
                                tempList.add(s);
                            }
                            if(existingOrgLevelPDUsMap.get(e).Decisional_Unit_Type__c == 'Super Department' && existingOrgLevelPDUsMap.get(e).Decisional_Unit_Derived__c != s){//newSNROrgCodes.get(e).Super_Department__c){//IF equal dont do anything
                                tempStrMap.put(e, s);
                                tempList.add(s);
                            }
                            if(existingOrgLevelPDUsMap.get(e).Decisional_Unit_Type__c == 'Division' && existingOrgLevelPDUsMap.get(e).Decisional_Unit_Derived__c != s){//newSNROrgCodes.get(e).Division__c){//IF equal dont do anything
                                tempStrMap.put(e, s);
                                tempList.add(s);
                            }
                            if(existingOrgLevelPDUsMap.get(e).Decisional_Unit_Type__c == 'Super Division' && existingOrgLevelPDUsMap.get(e).Decisional_Unit_Derived__c != s){//newSNROrgCodes.get(e).Super_Division__c){//IF equal dont do anything
                                tempStrMap.put(e, s);
                                tempList.add(s);
                            }
                        }
                    }
                    system.debug(' -- tempStrMap -- ' + tempStrMap);
                    system.debug(' -- tempList -- ' + tempList);
                    //Identify if new Org PDU already exists within the project or not
                    existingOrgLevelPDUList = new list<Child_Project_Decisional_Unit__c>();
                    map<string, Child_Project_Decisional_Unit__c> alreadyExistsNewOrgLevelPDUsMap = new map<string, Child_Project_Decisional_Unit__c> ();
                    list<Severance_and_Release__c> toBEInsertedOrgLevelSNRlst = new list<Severance_and_Release__c>();
                    
                    existingOrgLevelPDUList = [SELECT Id, name, Project__c,ProjectID__c, Org_Hierarchy_Code__c,Employee__c,Project_Decisional_Unit__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c, system_generated__c,Project_Decisional_Unit__r.Decisional_Unit_Name__c 
                                               FROM Child_Project_Decisional_Unit__c WHERE ProjectID__c in: prjSet and Decisional_Unit_Derived__c in:tempList ];
                    system.debug(' -- existingOrgLevelPDUList -- ' + existingOrgLevelPDUList);
                    if(!existingOrgLevelPDUList.isEmpty()){
                        
                        system.debug( ' -- newSNROrgCodes -- '  + newSNROrgCodes);
                        system.debug(' -- snrOrgChangeMap BEFORE-- ' + snrOrgChangeMap);
                       
                        for(Severance_and_Release__c snr : affectedSNRsLst){
                            for(Child_Project_Decisional_Unit__c cO: existingOrgLevelPDUList){
                                if(cO.ProjectID__c == snr.Project__c && newSNROrgCodes.get(snr.Id).contains(cO.Decisional_Unit_Derived__c) && existingOrgLevelPDUsMap.get(snr.Id).Decisional_Unit_Type__c == cO.Decisional_Unit_Type__c){ //cO.Decisional_Unit_Type__c == existingOrgLevelPDUsMap.get(snr.Id).Decisional_Unit_Type__c && 
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id,cO);
                                    system.debug(' - in already -'+alreadyExistsNewOrgLevelPDUsMap);
                                    snrOrgChangeMap.remove(snr.Id); // remove the entries for the existing PDUs, we need this to create ORG PDUs
                                }
                            }
                            
                        }
                    }


                    //Need to Add OrgLevel PDus which are not affected by Change in alreadyExistsNewOrgLevelPDUsMap
                    for(Severance_and_Release__c snr : affectedSNRsLst){
                       // system.debug('##empMap.containsKey(snr.emp_id__c):'+ empMap.containsKey(snr.emp_id__c));
                       // system.debug('##existingOrgLevelPDUsMap.containsKey(snr.id):'+ existingOrgLevelPDUsMap.containsKey(snr.id));
                        if(empMap.containsKey(snr.emp_id__c) && existingOrgLevelPDUsMap.containsKey(snr.id)){
                           // system.debug('##existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c :'+ existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c );
                           // system.debug('existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c:'+existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c);
                           // system.debug('empMap.get(snr.emp_id__c).cost_center__c:'+empMap.get(snr.emp_id__c).cost_center__c);
                            if(existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c == 'Cost Center' 
                                && existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c == empMap.get(snr.emp_id__c).cost_center__c){
                                if( !alreadyExistsNewOrgLevelPDUsMap.containsKey(snr.Id)){
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id, existingOrgLevelPDUsMap.get(snr.id));
                                }
                            }
                            else if(existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c == 'Sub Department' 
                                && existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c == empMap.get(snr.emp_id__c).Subdept_Org__c){
                                if( !alreadyExistsNewOrgLevelPDUsMap.containsKey(snr.Id)){
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id, existingOrgLevelPDUsMap.get(snr.id));
                                }
                            }
                            else if(existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c == 'Sub Department 2' 
                                && existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c == empMap.get(snr.emp_id__c).Sub_Depart2_Org__c){
                                if( !alreadyExistsNewOrgLevelPDUsMap.containsKey(snr.Id)){
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id, existingOrgLevelPDUsMap.get(snr.id));
                                }
                            }
                            else if(existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c == 'Department' 
                                && existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c == empMap.get(snr.emp_id__c).Dept_Org__c){
                                if( !alreadyExistsNewOrgLevelPDUsMap.containsKey(snr.Id)){
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id, existingOrgLevelPDUsMap.get(snr.id));
                                }
                            }
                            else if(existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c == 'Super Department' 
                                && existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c == empMap.get(snr.emp_id__c).Super_Depart_Org__c){
                                if( !alreadyExistsNewOrgLevelPDUsMap.containsKey(snr.Id)){
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id, existingOrgLevelPDUsMap.get(snr.id));
                                }
                            }
                            else if(existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c == 'Division' 
                                && existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c == empMap.get(snr.emp_id__c).Division_Org__c){
                                if( !alreadyExistsNewOrgLevelPDUsMap.containsKey(snr.Id)){
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id, existingOrgLevelPDUsMap.get(snr.id));
                                }
                            }
                            else if(existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Type__c == 'Super Division' 
                                && existingOrgLevelPDUsMap.get(snr.id).Decisional_Unit_Derived__c == empMap.get(snr.emp_id__c).Super_Division__c){
                                if( !alreadyExistsNewOrgLevelPDUsMap.containsKey(snr.Id)){
                                    alreadyExistsNewOrgLevelPDUsMap.put(snr.Id, existingOrgLevelPDUsMap.get(snr.id));
                                }
                            }

                        }
                    }
                    
                    system.debug(' -- alreadyExistsNewOrgLevelPDUsMap -- ' + alreadyExistsNewOrgLevelPDUsMap);
                    system.debug(' -- snrOrgChangeMap AFTER -- ' + snrOrgChangeMap);
                    
                    existingPDUList = [SELECT Id, Project__c, HR_Signatory__c, Employee__c, Decisional_Unit_Name__c FROM Project_Decisional_Unit__c WHERE Project__c IN : prjSet and ID in:existingPDUsIDSet ];
                    if(!existingPDUList.isEmpty()){
                        tempMapPDU = new  Map<string, Project_Decisional_Unit__c>();
                        for(Project_Decisional_Unit__c p: existingPDUList){
                            tempMapPDU.put(p.id, p);
                        }   
                        
                        existingPDUsMap = new  Map<string, Project_Decisional_Unit__c>();
                        for(Severance_and_Release__c sNr : affectedSNRsLst){
                            if(tempMapPDU.containsKey(sNr.Decisional_Unit__c)){
                                existingPDUsMap.put(sNr.ID, tempMapPDU.get(sNr.Decisional_Unit__c));
                            }
                        }
                    }
                    
                    
                    //Create New Org Level PDUs and PDUs
                    //Create PDUs                   
                    List<Project_Decisional_Unit__c> pduTOBECreated = new List<Project_Decisional_Unit__c>();
                    set<Project_Decisional_Unit__c> pduTOBECreatedSet = new set<Project_Decisional_Unit__c>();
                    list<String>lstPDUDecUnitName = new list<string>();
                    for(Severance_and_Release__c s : affectedSNRsLst){
                        if(!alreadyExistsNewOrgLevelPDUsMap.containskey(s.ID)){
                            system.debug(' -- EXE s ::-- ' + s);
                            Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
                            newPDU.Project__c = s.Project__c;
                            newPDU.HR_Signatory__c = existingPDUsMap.get(s.ID).HR_Signatory__c;
                            newPDU.Employee__c = existingPDUsMap.get(s.ID).Employee__c;
                            newPDU.Decisional_Unit_Name__c = 'SYS GEN (' + existingPDUsMap.get(s.ID).Decisional_Unit_Name__c + ')';
                            if(!pduTOBECreatedSet.contains(newPDU)){
                                lstPDUDecUnitName.add(newPDU.Decisional_Unit_Name__c);
                                pduTOBECreated.add(newPDU);
                                pduTOBECreatedSet.add(newPDU);
                            }
                        }
                    }
                    
                    // insert the new system generated PDU
                    if(!pduTOBECreated.isEmpty()){
                        try{
                            Database.SaveResult[] results =  Database.insert(pduTOBECreated,false);
                            for(Integer i = 0 ; pduTOBECreated.size() > i ; i++){
                                Database.SaveResult result = results[i];
                                Project_Decisional_Unit__c eachRec = pduTOBECreated[i];
                                if(!result.isSuccess()){
                                    for(Database.Error err : result.getErrors()){
                                        system.debug('*** ERROR IN PDU INSERT *** '+err);
                                    }
                                }
                            }
                        }
                        catch(Exception exp){
                            system.debug(' Error while inserting PDUs ' +exp.getMessage());
                        }
                    }
                    system.debug(' -- pduTOBECreated INSERTED -- ' + pduTOBECreated);
                    
                    //}
                    
                    set<String> setPDUIds = new Set<String>();
                    map<string,Project_Decisional_Unit__c> newPDUsMap = new map<string,Project_Decisional_Unit__c>();
                    //get the newly created PDU's ID
                    List<Project_Decisional_Unit__c> insertedPDU = [SELECT Id, Project__c, HR_Signatory__c, Employee__c, Decisional_Unit_Name__c FROM Project_Decisional_Unit__c WHERE Decisional_Unit_Name__c IN : lstPDUDecUnitName and Project__c IN : prjSet ORDER BY Project__c];
                    if(!insertedPDU.isEmpty()){
                        for (Project_Decisional_Unit__c p : insertedPDU){
                            setPDUIds.add(p.ID);
                            for(String u: existingPDUsMap.keySet()){
                                if(p.Decisional_Unit_Name__c.equalsIgnoreCase('SYS GEN (' + existingPDUsMap.get(u).Decisional_Unit_Name__c + ')') && p.Project__c == existingPDUsMap.get(u).Project__c){
                                    newPDUsMap.put(u,p);
                                }
                            }
                        }
                    }
                    
                    system.debug('--newPDUsMap--'+newPDUsMap);
                    //insert new org level PDUs now
                    
                    Map<String, Org_Hierarchy__c> mapOrgHierarchy = new Map<String, Org_Hierarchy__c>();
                    //Get the Org Hierarchies for new re-org orgs
                    system.debug(' -- costCenterSet -- ' + costCenterSet);
                    system.debug(' -- subDepart2Set -- ' + subDepart2Set);
                    system.debug(' -- subDepartSet -- ' + subDepartSet);
                    system.debug(' -- DepartSet -- ' + DepartSet);
                    system.debug(' -- superDepartSet -- ' + superDepartSet);
                    system.debug(' -- DivisionSet -- ' + DivisionSet);
                    system.debug(' -- superDivisionSet -- ' + superDivisionSet);
                    
                    Map<string,Org_Hierarchy__c> costCenterMap = new Map<string,Org_Hierarchy__c>();
                    Map<string,Org_Hierarchy__c> subDepartMap = new Map<string,Org_Hierarchy__c>();
                    Map<string,Org_Hierarchy__c> subDepart2Map = new Map<string,Org_Hierarchy__c>();
                    Map<string,Org_Hierarchy__c> departMap = new Map<string,Org_Hierarchy__c>();
                    Map<string,Org_Hierarchy__c> superDepartMap = new Map<string,Org_Hierarchy__c>();
                    Map<string,Org_Hierarchy__c> divisionMap = new Map<string,Org_Hierarchy__c>();
                    Map<string,Org_Hierarchy__c> superDivisionMap = new Map<string,Org_Hierarchy__c>();
                    
                    List<Org_Hierarchy__c> orgHierarchyList = [SELECT Id, Name, TREE_Effective_Date__c, Effective_Status__c, Super_Division__c, Division__c, Super_Department__c,  Department__c, Sub_Department__c, 
                                                               Sub_Department_2__c, Department_ID__c, Cost_Center_Description__c,Sub_Department_2_Description__c,Sub_Department_Description__c,
                                                               Department_Description__c,Super_Department_Description__c,Division_Description__c,Super_Division_Description__c FROM Org_Hierarchy__C 
                                                               WHERE (  (Department_ID__c IN : costCenterSet) OR 
                                                                      (Sub_Department_2__c IN : subDepart2Set) OR 
                                                                      (Sub_Department__c IN : subDepartSet) OR 
                                                                      (Department__c IN : DepartSet ) OR 
                                                                      (Super_Department__c IN : superDepartSet) OR 
                                                                      (Division__c IN : DivisionSet) OR 
                                                                      (Super_Division__c IN : superDivisionSet) ) 
                                                               AND Effective_Status__c = true]; //SHD we consider only active ones???
                    
                    if(!orgHierarchyList.isEmpty()){
                        for(Org_Hierarchy__c each : orgHierarchyList){
                            costCenterMap.put(each.Department_ID__c, each);
                            subDepartMap.put(each.Sub_Department__c, each);
                            subDepart2Map.put(each.Sub_Department_2__c, each);
                            departMap.put(each.Department__c, each);
                            superDepartMap.put(each.Super_Department__c, each);
                            divisionMap.put(each.Division__c, each);
                            superDivisionMap.put(each.Super_Division__c, each);
                        }
                    }
                    
                    system.debug(' -- costCenterMap -- ' + costCenterMap);
                    system.debug(' -- subDepartMap -- ' + subDepartMap);
                    system.debug(' -- subDepart2Map -- ' + subDepart2Map);
                    system.debug(' -- departMap -- ' + departMap);
                    system.debug(' -- superDepartMap -- ' + superDepartMap);
                    system.debug(' -- divisionMap -- ' + divisionMap);
                    system.debug(' -- superDivisionMap -- ' + superDivisionMap);
                    
                    
                    List<Child_Project_Decisional_Unit__c> OrgDUTOBECreated = new List<Child_Project_Decisional_Unit__c>();
                    // ALM 1884 : Avoid duplicate Org PDUs from being created
                    Set<Child_Project_Decisional_Unit__c> newOrgPDUSet = new Set<Child_Project_Decisional_Unit__c>();
                    //list<String>lstPDUDecUnitName = new list<string>();
                    for(Severance_and_Release__c s : affectedSNRsLst){
                        if(!alreadyExistsNewOrgLevelPDUsMap.containskey(s.ID) && snrOrgChangeMap.containsKey(s.ID) && newPDUsMap.containsKey(s.ID) && existingOrgLevelPDUsMap.containsKey(s.Id)){
                            system.debug(' -- EXE orgLEvel s ::-- ' + s);
                            
                            Child_Project_Decisional_Unit__c newORGDU = new Child_Project_Decisional_Unit__c();
                            
                            newORGDU.Project_Decisional_Unit__c = newPDUsMap.get(s.ID).ID; // the ID of the new PDU
                            newORGDU.ProjectID__c = existingOrgLevelPDUsMap.get(s.ID).ProjectID__c;
                            newORGDU.Employee__c = existingOrgLevelPDUsMap.get(s.ID).Employee__c;
                            //newORGDU.Decisional_Unit_Type__c = existingOrgLevelPDUsMap.get(s.ID).Decisional_Unit_Type__c;
                            newORGDU.System_Generated__c = true;
                            
                            for(String decType : snrOrgChangeMap.get(s.Id).keySet()){
                                // 16-Feb-17 : ALM#1899 : If we have more than 1 org code change for the emp, the new Org PDU will only be created ONLY IF the existing org PDUs org code has changed
                                system.debug(' -- decType -- ' + decType);
                                system.debug(' -- existingOrgLevelPDUsMap.get(s.Id) -- ' + existingOrgLevelPDUsMap.get(s.Id));
                                if(decType == 'Cost Center' && existingOrgLevelPDUsMap.get(s.Id).Decisional_Unit_Type__c == 'Cost Center' && costCenterMap.containskey(s.Cost_Center__c)){
                                    newORGDU.Org_Hierarchy_Code__c = costCenterMap.get(s.Cost_Center__c).Department_ID__c + ' - ' + costCenterMap.get(s.Cost_Center__c).Cost_Center_Description__c;
                                    newORGDU.Decisional_Unit_Type__c = decType;
                                }
                                else if(decType == 'Sub Department' && existingOrgLevelPDUsMap.get(s.Id).Decisional_Unit_Type__c == 'Sub Department' && subDepartMap.containskey(s.Sub_Department__c) ){
                                    newORGDU.Org_Hierarchy_Code__c = subDepartMap.get(s.Sub_Department__c).Sub_Department__c + ' - ' + subDepartMap.get(s.Sub_Department__c).Sub_Department_Description__c;
                                    newORGDU.Decisional_Unit_Type__c = decType;
                                }
                                else if(decType == 'Sub Department 2' && existingOrgLevelPDUsMap.get(s.Id).Decisional_Unit_Type__c == 'Sub Department 2' && subDepart2Map.containskey(s.Sub_Department_2__c) ){
                                    newORGDU.Org_Hierarchy_Code__c = subDepart2Map.get(s.Sub_Department_2__c).Sub_Department_2__c + ' - ' + subDepart2Map.get(s.Sub_Department_2__c).Sub_Department_2_Description__c;
                                    newORGDU.Decisional_Unit_Type__c = decType;
                                }
                                else if(decType == 'Department' && existingOrgLevelPDUsMap.get(s.Id).Decisional_Unit_Type__c == 'Department' && departMap.containskey(s.Department__c) ){
                                    newORGDU.Org_Hierarchy_Code__c = departMap.get(s.Department__c).Department__c + ' - ' + departMap.get(s.Department__c).Department_Description__c;
                                    newORGDU.Decisional_Unit_Type__c = decType;
                                }
                                else if(decType == 'Super Department' && existingOrgLevelPDUsMap.get(s.Id).Decisional_Unit_Type__c == 'Super Department' && superDepartMap.containskey(s.Super_Department__c) ){
                                    newORGDU.Org_Hierarchy_Code__c = superDepartMap.get(s.Super_Department__c).Super_Department__c + ' - ' + superDepartMap.get(s.Super_Department__c).Super_Department_Description__c;
                                    newORGDU.Decisional_Unit_Type__c = decType;
                                }
                                else if(decType == 'Division' && existingOrgLevelPDUsMap.get(s.Id).Decisional_Unit_Type__c == 'Division' && divisionMap.containskey(s.Division__c) ){
                                    newORGDU.Org_Hierarchy_Code__c = divisionMap.get(s.Division__c).Division__c + ' - ' + divisionMap.get(s.Division__c).Division_Description__c;
                                    newORGDU.Decisional_Unit_Type__c = decType;
                                }
                                else if(decType == 'Super Division' && existingOrgLevelPDUsMap.get(s.Id).Decisional_Unit_Type__c == 'Super Division' && superDivisionMap.containskey(s.Super_Division__c) ){
                                    newORGDU.Org_Hierarchy_Code__c = superDivisionMap.get(s.Super_Division__c).Super_Division__c + ' - ' + superDivisionMap.get(s.Super_Division__c).Super_Division_Description__c;
                                    newORGDU.Decisional_Unit_Type__c = decType;
                                }
                            }
                            system.debug(' -- newORGDU -- ' + newORGDU);
                            //OrgDUTOBECreated.add(newORGDU);
                            newOrgPDUSet.add(newORGDU);
                        }
                    }
                    
                    // insert the new system generated PDU
                    system.debug(' -- newOrgPDUSet -- ' + newOrgPDUSet);
                    if(!newOrgPDUSet.isEmpty()){
                        try{
                            OrgDUTOBECreated.addAll(newOrgPDUSet);
                            Database.SaveResult[] results =  Database.insert(OrgDUTOBECreated,false);
                            for(Integer i = 0 ; OrgDUTOBECreated.size() > i ; i++){
                                Database.SaveResult result = results[i];
                                Child_Project_Decisional_Unit__c eachRec = OrgDUTOBECreated[i];
                                if(!result.isSuccess()){
                                    for(Database.Error err : result.getErrors()){
                                        system.debug('***** ERROR INSERTING ORG PDU *** '+err);
                                    }
                                }
                            }
                        }
                        catch(Exception exp){
                            system.debug('Error while inserting the Child PDUs ' + exp.getMessage());
                        }
                    }
                    
                    //get the newly created ORG PDU's ID
                    Map<String,String> newOrgPDUMap = new Map<String,String>();
                    map<string,Child_Project_Decisional_Unit__c> newOrgLevelPDUsMap = new map<string,Child_Project_Decisional_Unit__c>();
                    List<Child_Project_Decisional_Unit__c> insertedOrgPDU = [SELECT Id, Project__c,ProjectID__c, Org_Hierarchy_Code__c,Employee__c,Project_Decisional_Unit__c,Decisional_Unit_Type__c,Decisional_Unit_Derived__c
                                                                             FROM Child_Project_Decisional_Unit__c WHERE Project_Decisional_Unit__c IN : setPDUIds and System_Generated__c = true ORDER BY Project_Decisional_Unit__c];
                    system.debug(' -- insertedOrgPDU -- ' + insertedOrgPDU);
                    if(!insertedOrgPDU.isEmpty()){
                        for(Child_Project_Decisional_Unit__c p : insertedOrgPDU){
                            newOrgPDUMap.put(p.Id,p.Decisional_Unit_Derived__c);
                            for(String u: existingOrgLevelPDUsMap.keySet()){
                                if(!alreadyExistsNewOrgLevelPDUsMap.containskey(u)){
                                    //if(p.Org_Hierarchy_Code__c == orgPDUTOSNRMap.get(u).Org_Hierarchy_Code__c && p.Project__c == orgPDUTOSNRMap.get(u).Project__c && p.Project_Decisional_Unit__c == orgPDUTOSNRMap.get(u).Project_Decisional_Unit__c ){
                                    // 3-Nov : Defect#1835 : SnRs getting attached to same Org PDUs
                                    if(p.Project__c == existingOrgLevelPDUsMap.get(u).Project__c && newSNROrgCodes.get(u).contains(p.Decisional_Unit_Derived__c)){//NEED TO RETHINK HERE !!//&& p.Org_Hierarchy_Code__c == orgPDUTOSNRMap.get(u).Org_Hierarchy_Code__c){
                                        newOrgLevelPDUsMap.put(u,p);
                                    }
                                }
                            }
                        }
                    }
                    system.debug(' -- newOrgLevelPDUsMap -- ' + newOrgLevelPDUsMap);
                    
                    //4) UPDATE THE SNR AND CORRECT THE SHARING
                    
                    set<string> affectedEmpIDs = new set<string>();
                    List<Severance_and_Release__c> tempSNRList = new List<Severance_and_Release__c>(); 
                    List<Severance_and_Release__c> finalSNRList = new List<Severance_and_Release__c>(); // holds all the SNR whose fields have been updated 
                    
                    //Update PDU and Org Level PDUs at SNR
                    for(Severance_and_release__c sr: affectedSNRsLst){
                        // sr.Decisional_Unit__c = null;
                        // sr.Project_Decisional_Org_Level__c = null;
                        
                        if(!alreadyExistsNewOrgLevelPDUsMap.containskey(sr.ID)){
                           
                            if(newPDUsMap.containsKey(sr.Id)){
                                sr.Decisional_Unit__c = newPDUsMap.get(sr.ID).ID;
                            }
                            if(newOrgLevelPDUsMap.containsKey(sr.Id)){
                                sr.Project_Decisional_Org_Level__c = newOrgLevelPDUsMap.get(sr.ID).ID;
                            }
                        }
                        
                        else if(alreadyExistsNewOrgLevelPDUsMap.containskey(sr.ID)){  
                            sr.Decisional_Unit__c = alreadyExistsNewOrgLevelPDUsMap.get(sr.ID).Project_Decisional_Unit__c;
                            sr.Project_Decisional_Org_Level__c = alreadyExistsNewOrgLevelPDUsMap.get(sr.ID).ID;
                        }                   
                        
                        tempSNRList.add(sr);
                        snrFinalUpdateMap.put(sr.Id,sr);
                        //affectedEmpIDs.add(sr.EMp_ID__c);
                    }
                    
                    allShareRecords= new Set<Severance_and_release__share>();
                    
                    Map<Id,Permissionset> adminUserPermissionMap;
                    //IDENTIFY IF SNR OWNER NEEDS TO BE CHANGED
                    //= [SELECT ID from User where permissionset = 'RIF SYS ADMIN' limit 1]; 
                    //Need to check what to do if there are multiple SYS Admins??? OWner can only be one
                    adminUserPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_System_Admin']);
                    system.debug( ' -- adminUserPermissionMap -- ' + adminUserPermissionMap);
                    
                    if(adminUserPermissionMap != null && adminUserPermissionMap.keyset() != null && adminUserPermissionMap.keyset().size() > 0){
                        for(permissionsetAssignment rifAdminUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminUserPermissionMap.keyset()]){
                            rifSYSADMINs.add(rifAdminUser.assigneeid);
                        }
                    }
                    system.debug(' -- rifSYSADMINs -- ' + rifSYSADMINs);
                    
                    list<string> lstUsersEmpIDs = new list<string>();
                    list<string> lstOwnerUserEmpIDs = new list<string>();
                    Map<String,Set<String>> existingUsersAffectedSNRsMap = new Map<String,Set<String>>();
                    Set<String> existingUserIdSet = new Set<String>();
                    //Get the existing SNR sharing from  SNR share records
                    sNrShareRecords = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM severance_and_release__share WHERE parentID IN: sNrIds];
                    system.debug( '-- SNR Shared Records -- ' + sNrShareRecords);
                    
                    for(Severance_and_release__share shrR : sNrShareRecords){
                        // get all the existing users with whom the SnR record has been shared
                        if(shrR.RowCause.equalsIgnoreCase('Manual')){
                            allShareRecords.add(shrR); // add all the manually shared users for now
                            existingUserIdSet.add(shrR.UserOrGroupId);
                        } 
                    }
                    
                    Map<String,Set<String>> existingUsersEntitMap = new Map<String,Set<String>>();
                    // find the coverage entitlements of these existing users
                    if(!existingUserIdSet.isEmpty()){
                        Set<String> empIds = new Set<String>();
                        List<Employee__c> empDetails = getEmpIdFromUserId(existingUserIdSet);
                        for(Employee__c eachEmp : empDetails){
                            empIds.add(eachEmp.Id);
                        }
                        List<Coverage_Entitlement__c> existingCovEnt = getAllCoverageEntitlements(empIds);
                        if(!existingCovEnt.isEmpty()){
                            for(Coverage_Entitlement__c eachCov : existingCovEnt){
                                Set<String> tempSet = new Set<String>();                   
                                for(Coverage_Entitlement_Org__c covEntOrg: eachCov.HR_Coverage_Orgs__r){
                                    tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                                }
                                existingUsersEntitMap.put(eachCov.HR_Name__r.User__r.Id,tempSet); // emp Id => coverage ents
                            }
                        }
                    }
                    system.debug(' -- existingUsersEntitMap --' + existingUsersEntitMap);
                    
                    // 1. check if the new Org PDU is covered by the present owner. if so keep the owner as the same
                    // 2. Delete all other users from the share record
                    // 3. For all other snr make the owner as RIF Admin
                    
                    Set<String> ownerSet = new Set<String>();
                    Map<String,String> empToUser = new Map<String,String>();
                    Map<String,String> empToUserOwnerId = new Map<String,String>();
                    Map<String,String> empToUserMap = new Map<String,String>();
                    Set<String> empToUserIDSet = new Set<String>();
                    Map<String,Set<String>> hrToEntCovMap = new Map<String,Set<String>>();
                    
                    for(Severance_and_release__c sr: affectedSNRsLst){
                        ownerSet.add(sr.OwnerId);
                        empToUser.put(sr.Id,sr.OwnerId);
                        // get snr to all manually shared users map
                        Set<String> userIDsSet = new Set<String>();
                        for(Severance_and_release__share shrR : sNrShareRecords){
                            if(shrR.ParentId == sr.Id && shrR.RowCause.equalsIgnoreCase('Manual')){
                                userIDsSet.add(shrR.UserOrGroupId);
                            }
                        }
                        existingUsersAffectedSNRsMap.put(sr.Id,userIDsSet); // snr.Id => set of shared user's IDs
                    }
                    system.debug(' -- existingUsersAffectedSNRsMap -- ' + existingUsersAffectedSNRsMap);
                    system.debug(' -- ownerSet -- ' + ownerSet);
                    
                    //List<Employee__c> allEmps = [SELECT Id,Name,User__c,emp_id__C FROM Employee__c WHERE User__c IN : ownerSet];
                    List<Employee__c> allEmps = getEmpIdFromUserId(ownerSet);
                    for(Employee__c eachEmp : allEmps){
                        empToUserIDSet.add(eachEmp.Id);
                        empToUserOwnerId.put(eachEmp.User__c,eachEmp.emp_id__C);
                    }
                    system.debug('-- empToUser -' + empToUser);
                    system.debug(' --empToUserOwnerId -- ' + empToUserOwnerId);
                    for(String owner : empToUser.keySet()){ // snrId, ownerId
                        empToUserMap.put(owner,empToUserOwnerId.get(empToUser.get(owner)));
                    }
                    system.debug(' -- FINAL empToUserMap-- '+ empToUserMap);
                    
                    //List<Coverage_Entitlement__c> allCovEnt = [SELECT Id,HR_Name__c,(SELECT Id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c FROM HR_Coverage_Orgs__r),HR_EmpID__c FROM Coverage_Entitlement__c WHERE HR_Name__c IN : empToUserIDSet];
                    List<Coverage_Entitlement__c> allCovEnt = getAllCoverageEntitlements(empToUserIDSet);
                     // TODO - Create a common method 
                    for(Coverage_Entitlement__c eachCov: allCovEnt){
                        Set<String> tempSet = new Set<String>();                   
                        for(Coverage_Entitlement_Org__c covEntOrg: eachCov.HR_Coverage_Orgs__r){
                            tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                        }
                        hrToEntCovMap.put(eachCov.HR_EmpID__c,tempSet);
                    }
                    system.debug(' -- snrFinalUpdateMap --' + snrFinalUpdateMap);
                    system.debug(' -- insertedOrgPDU --' + insertedOrgPDU);
                    system.debug(' -- snrFinalUpdateMap.values() -- ' + snrFinalUpdateMap.values());
                    system.debug(' -- hrToEntCovMap -- ' + hrToEntCovMap);
                    
                    // we merge all the newly created org PDUs and the existing org level PDUs into a single map
                    map<string, Child_Project_Decisional_Unit__c> allOrgLevelPDUsMap = new map<string, Child_Project_Decisional_Unit__c> ();
                    allOrgLevelPDUsMap.putAll(newOrgLevelPDUsMap);
                    allOrgLevelPDUsMap.putAll(alreadyExistsNewOrgLevelPDUsMap);
                    
                    map<string, Org_Hierarchy__C> snrTOorgHierarchyMap = new map<string, Org_Hierarchy__C> ();
                    list<string> lstSnROrgH = new list<string> ();
                    for(string s: allOrgLevelPDUsMap.keyset()){
                    Child_Project_Decisional_Unit__c cP = allOrgLevelPDUsMap.get(s);
                    //for(Child_Project_Decisional_Unit__c cP: newOrgLevelPDUsMap.get(s)){
                        if(cP.Decisional_Unit_Type__c == 'Cost Center'){
                            if(costCenterMap.containsKey(cP.Decisional_Unit_Derived__c)){
                                snrTOorgHierarchyMap.put(s,costCenterMap.get(cP.Decisional_Unit_Derived__c));
                            }
                        }
                        else if(cP.Decisional_Unit_Type__c == 'Sub Department 2'){
                            if(subDepart2Map.containsKey(cP.Decisional_Unit_Derived__c)){
                                snrTOorgHierarchyMap.put(s,subDepart2Map.get(cP.Decisional_Unit_Derived__c));
                            }
                        }
                        else if(cP.Decisional_Unit_Type__c == 'Sub Department'){
                            if(subDepartMap.containsKey(cP.Decisional_Unit_Derived__c)){
                                snrTOorgHierarchyMap.put(s,subDepartMap.get(cP.Decisional_Unit_Derived__c));
                            }
                        }
                        else if(cP.Decisional_Unit_Type__c == 'Department'){
                            if(departMap.containsKey(cP.Decisional_Unit_Derived__c)){
                                snrTOorgHierarchyMap.put(s,departMap.get(cP.Decisional_Unit_Derived__c));
                            }
                        }
                        else if(cP.Decisional_Unit_Type__c == 'Super Department'){
                            if(superDepartMap.containsKey(cP.Decisional_Unit_Derived__c)){
                                snrTOorgHierarchyMap.put(s,superDepartMap.get(cP.Decisional_Unit_Derived__c));
                            }
                        }
                        else if(cP.Decisional_Unit_Type__c == 'Division'){
                            if(divisionMap.containsKey(cP.Decisional_Unit_Derived__c)){
                                snrTOorgHierarchyMap.put(s,divisionMap.get(cP.Decisional_Unit_Derived__c));
                            }
                        }
                        else if(cP.Decisional_Unit_Type__c == 'Super Division'){
                            if(superDivisionMap.containsKey(cP.Decisional_Unit_Derived__c)){
                                snrTOorgHierarchyMap.put(s,superDivisionMap.get(cP.Decisional_Unit_Derived__c));
                            }
                        }
                    //}
                }
                    system.debug(' -- allOrgLevelPDUsMap -- ' + allOrgLevelPDUsMap);
                    system.debug(' -- snrTOorgHierarchyMap -- ' + snrTOorgHierarchyMap);
                    
                    Map<String,String> snrToOwner =  new Map<String,String>();
                    for(Severance_and_Release__c eachSnr : snrFinalUpdateMap.values()){
                        //for(Child_Project_Decisional_Unit__c childPDU : insertedOrgPDU){
                        for(Child_Project_Decisional_Unit__c childPDU : allOrgLevelPDUsMap.values()){
                            if(hrToEntCovMap.containsKey(empToUserMap.get(eachSnr.id)) && snrTOorgHierarchyMap.containsKey(eachSnr.Id)){
                                if(childPDU.Decisional_Unit_Type__c == 'Cost Center'){
                                    // check if the owner still has access to the new PDU 
                                    if(hrToEntCovMap.get(empToUserMap.get(eachSnr.id)).contains(snrTOorgHierarchyMap.get(eachSnr.Id).Department_ID__c )){
                                        snrToOwner.put(eachSnr.id,eachSnr.OwnerId);
                                    }
                                    //if(!existingUsersEntitMap.isEmpty() && existingUsersEntitMap)
                                }
                                else if(childPDU.Decisional_Unit_Type__c == 'Sub Department'){
                                    if(hrToEntCovMap.get(empToUserMap.get(eachSnr.id)).contains(snrTOorgHierarchyMap.get(eachSnr.Id).Sub_Department__c )){
                                        snrToOwner.put(eachSnr.id,eachSnr.OwnerId);
                                    }
                                }
                                else if(childPDU.Decisional_Unit_Type__c == 'Sub Department 2'){
                                    if(hrToEntCovMap.get(empToUserMap.get(eachSnr.id)).contains(snrTOorgHierarchyMap.get(eachSnr.Id).Sub_Department_2__c )){
                                        snrToOwner.put(eachSnr.id,eachSnr.OwnerId);
                                    }
                                }
                                else if(childPDU.Decisional_Unit_Type__c == 'Department'){
                                    if(hrToEntCovMap.get(empToUserMap.get(eachSnr.id)).contains(snrTOorgHierarchyMap.get(eachSnr.Id).Department__c )){
                                        snrToOwner.put(eachSnr.id,eachSnr.OwnerId);
                                    }
                                }
                                else if(childPDU.Decisional_Unit_Type__c == 'Super Department'){
                                    if(hrToEntCovMap.get(empToUserMap.get(eachSnr.id)).contains(snrTOorgHierarchyMap.get(eachSnr.Id).Super_Department__c )){
                                        snrToOwner.put(eachSnr.id,eachSnr.OwnerId);
                                    }
                                }
                                else if(childPDU.Decisional_Unit_Type__c == 'Division'){
                                    if(hrToEntCovMap.get(empToUserMap.get(eachSnr.id)).contains(snrTOorgHierarchyMap.get(eachSnr.Id).Division__c )){
                                        snrToOwner.put(eachSnr.id,eachSnr.OwnerId);
                                    }
                                }
                                else if(childPDU.Decisional_Unit_Type__c == 'Super Division'){
                                    if(hrToEntCovMap.get(empToUserMap.get(eachSnr.id)).contains(snrTOorgHierarchyMap.get(eachSnr.Id).Super_Division__c )){
                                        snrToOwner.put(eachSnr.id,eachSnr.OwnerId);
                                    }
                                }
                            }  
                        }
                    }
                    system.debug(' -- snrToOwner -- ' + snrToOwner);
                    // assign the RIF Admin as the owner of the SnR who is no longer covered by the previous owner
                    // 21-Feb-2017 : ALM#1898 :The owner of the updated SNRs only change if the SNR gets into a new PDU, and the previous owner no longer 
                    // has access to the PDUs org level decisional unit
                    
                    for(Severance_and_Release__c eachSnr : snrFinalUpdateMap.values()){
                        if(!snrToOwner.containsKey(eachSnr.Id)){
                            // check if the SNR has been tagged to a new PDU, i.e. SYS GEN PDU or and existing one
                            if(existingOrgLevelPDUsMap.containsKey(eachSnr.Id) && existingOrgLevelPDUsMap.get(eachSnr.Id).Project_Decisional_Unit__c != eachSnr.Decisional_Unit__c){
                                system.debug(' -- changing owner -- ');
                                // 19-July-17: JIRA#RIF-87 : RIF system admins should not receive any emails
                                // the orphan SNRs will now be tagged to a pre defined user, rather than a random rif system admin
                                /*
                                eachSnr.OwnerId = rifSYSADMINs.get(0);
                                projectIdName.put(eachSnr.Project__c, rifSYSADMINs.get(0)); 
								*/
                                // check if the SNR belongs to a HR user i.e. Dept = 81200, assign it to another admin user
                                if(eachSnr.Department__c.equalsIgnoreCase('81200')){
                                    eachSnr.OwnerId = Label.RIF_Default_Email_Super_Admin;
                                }
                                // else if the SNR does not belong to a HR personnel
                                else{
                                    eachSnr.OwnerId = Label.RIF_Default_Email_Admin;
                                }
                                
                                projectIdName.put(eachSnr.Project__c, eachSnr.OwnerId); 
                            }
                        }
                    }
                    system.debug(' -- projectIdName -- ' + projectIdName);
                    // check if all users with whom the SnR record was shared still have access to the new PDU
                    Set<Severance_and_Release__share> keepUserAccessSet = new Set<Severance_and_Release__share>();
                    if(!existingUsersEntitMap.isEmpty() && !allOrgLevelPDUsMap.isEmpty()){
                        for(Severance_and_Release__c eachSnr : snrFinalUpdateMap.values()){ // get each updated SNR
                            for(Child_Project_Decisional_Unit__c childPDU : allOrgLevelPDUsMap.values()){ // get each updated/created Org PDU
                                if(existingUsersAffectedSNRsMap.containsKey(eachSnr.Id) && eachSnr.Project_Decisional_Org_Level__c == childPDU.Id){ 
                                    Set<String> tempUsers = existingUsersAffectedSNRsMap.get(eachSnr.Id);
                                    for(String eachUser : tempUsers){
                                        if(existingUsersEntitMap.containsKey(eachUser) && existingUsersEntitMap.get(eachUser).contains(childPDU.Decisional_Unit_Derived__c)){
                                            for(Severance_and_Release__share shared : allShareRecords){
                                                if((shared.ParentId == eachSnr.Id) && (shared.UserOrGroupId == eachUser)){
                                                    keepUserAccessSet.add(shared); // all these users still have coverage for the new PDU
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    system.debug(' -- keepUserAccessSet -- ' + keepUserAccessSet);
                    // find all the share records to delete
                    delShareRecords = new Set<Severance_and_Release__share>(allShareRecords);
                    Map<String,Set<String>> snrManualUsersMap = new Map<String,Set<String>>();
                    for(Severance_and_Release__share allUsr : allShareRecords){
                        Set<String> tempManUsers = new Set<String>();
                        for(Severance_and_Release__share toKeepUsr : keepUserAccessSet){
                            if(allUsr.Id == toKeepUsr.Id){
                               delShareRecords.remove(allUsr); // users who do not have access to the new PDU
                            }
                            if(toKeepUsr.ParentId == allUsr.ParentId){
                                tempManUsers.add(toKeepUsr.UserOrGroupId);
                            }
                        }
                        if(!tempManUsers.isEmpty()){
                            snrManualUsersMap.put(allUsr.ParentId,tempManUsers); // SnR Id => Set{manually shared user}
                        }
                    }
                    system.debug(' -- delShareRecords -- ' + delShareRecords);
                    system.debug(' -- snrManualUsersMap -- ' + snrManualUsersMap);
                    
                    // assign all the new SNRs to the coverage users who has got the coverage entitlements
                    // TODO - Create a common method 
                    Map<String,Set<String>> allCovUserEntMap = new Map<String,Set<String>>();
                    List<Coverage_Entitlement__c> allCoverageUsersEnt = getAllCoverageEntitlements(null);
                    system.debug(' -- allCoverageUsersEnt  -- ' + allCoverageUsersEnt );
                    if(!allCoverageUsersEnt.isEmpty()){
                        for(Coverage_Entitlement__c eaCov: allCoverageUsersEnt){
                            Set<String> tempSet = new Set<String>();                   
                            for(Coverage_Entitlement_Org__c covEntOrg: eaCov.HR_Coverage_Orgs__r){
                                tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                            }
                            if(!tempSet.isEmpty()){
                                allCovUserEntMap.put(eaCov.HR_Name__r.User__r.Id,tempSet); // user Id => Set{Cov Ent}
                            }
                        }
                    }
                    system.debug(' -- allCovUserEntMap --' + allCovUserEntMap );
                    // check if the new SNRs can be assigned to any of the users
                    Map<String,Set<String>> assignSnRToNewCovUser = new Map<String,Set<String>>();
                    for(Severance_and_Release__c eachSnr : snrFinalUpdateMap.values()){ // get each updated SNR
                        for(Child_Project_Decisional_Unit__c childPDU : allOrgLevelPDUsMap.values()){
                            if(eachSnr.Project_Decisional_Org_Level__c == childPDU.Id){
                                Set<String> tempUsers = new Set<String>();
                                for(String userId : allCovUserEntMap.keySet()){
                                    if(eachSnr.OwnerId != userId){ // ignore all SnR owners and manually shared users
                                        Set<String> userCove = allCovUserEntMap.get(userId); // all coverage users' entls. 
                                        if(userCove.contains(childPDU.Decisional_Unit_Derived__c)){
                                            tempUsers.add(userId);
                                        } 
                                    }
                                }
                                assignSnRToNewCovUser.put(eachSnr.Id,tempUsers);
                            }
                        }
                    }
                    system.debug(' -- assignSnRToNewCovUser -- ' + assignSnRToNewCovUser);
                    // delete the share records
                    system.debug(' -- delShareRecords BEFORE DEL-- ' + delShareRecords);
                    List<Severance_and_release__share> delShareRecsList = new List<Severance_and_release__share>(delShareRecords);
                    if(!delShareRecsList.isEmpty()){
                        Database.delete(delShareRecsList,false);
                    }
                    
                    // update the SNR records 
                    
                    system.debug(' -- snrFinalUpdateMap.values() SIZE -- ' + snrFinalUpdateMap.values().size());
                    system.debug(' -- snrFinalUpdateMap.values() -- ' + snrFinalUpdateMap.values());
                    
                    // update SNRs for Reorg
                    if(!snrFinalUpdateMap.isEmpty()){
                        try{
                            Database.SaveResult[] results = Database.update(snrFinalUpdateMap.values(),false);
                            List<Severance_and_release__c> insertedSNRList = new List<Severance_and_release__c>(snrFinalUpdateMap.values());
                            for(Integer i = 0 ; insertedSNRList.size() > i ; i++){
                                Database.SaveResult result = results[i];
                                Severance_and_release__c eachRec = insertedSNRList[i];
                                if(!result.isSuccess()){
                                    for(Database.Error err : result.getErrors()){
                                        system.debug('***** ERROR UPDATING SNR *** '+ err);
                                    }
                                }
                            }
                        }
                        catch(Exception exp){
                            system.debug(' Error while updating SNRs ' + snrFinalUpdateMap);
                        }
                    }
                    
                    // update SNRs for rename
                    if(!renameAffectedSNRLst.isEmpty()){
                        try{
                            Database.SaveResult[] results = Database.update(renameAffectedSNRLst,false);
                            List<Severance_and_release__c> insertedSNRList = new List<Severance_and_release__c>(renameAffectedSNRLst);
                            for(Integer i = 0 ; insertedSNRList.size() > i ; i++){
                                Database.SaveResult result = results[i];
                                Severance_and_release__c eachRec = insertedSNRList[i];
                                if(!result.isSuccess()){
                                    for(Database.Error err : result.getErrors()){
                                        system.debug('***** ERROR UPDATING SNR FOR RENAMING*** '+ err);
                                    }
                                }
                            }
                        }
                        catch(Exception exp){
                            system.debug(' Error while updating SNRs ' + renameAffectedSNRLst);
                        }
                    }
                    
                    // share the updated SnRs with new coverage users 
                    List<Severance_and_Release__share> newSharedRecordsInsertList = createNewSharedRecords(assignSnRToNewCovUser);
                    system.debug(' -- newSharedRecordsInsertList -- ' + newSharedRecordsInsertList);
                    if(!newSharedRecordsInsertList.isEmpty()){
                        try{
                            Database.SaveResult[] results = Database.insert(newSharedRecordsInsertList,false);
                            List<Severance_and_Release__share> insertedSNRList = new List<Severance_and_Release__share>(newSharedRecordsInsertList);
                            for(Integer i = 0 ; insertedSNRList.size() > i ; i++){
                                Database.SaveResult result = results[i];
                                Severance_and_Release__share eachRec = insertedSNRList[i];
                                if(!result.isSuccess()){
                                    for(Database.Error err : result.getErrors()){
                                        system.debug('***** ERROR INSERTING SNR SHARED RECORDS *** '+ err);
                                    }
                                }
                            }
                        }
                        catch(Exception exp){
                            system.debug(' Error while inserting manually shared records ' + snrFinalUpdateMap);
                        }
                    }
                    List<Child_Project_Decisional_Unit__c> updateRenamedOrgPDU = new List<Child_Project_Decisional_Unit__c>(renameOrgPDUs(renameAffectedSNRLst,renameChangesMap));
                    if(!updateRenamedOrgPDU.isEmpty()){
                        try{
                            Database.SaveResult[] results =  Database.update(updateRenamedOrgPDU,false);
                            for(Integer i = 0 ; updateRenamedOrgPDU.size() > i ; i++){
                                Database.SaveResult result = results[i];
                                Child_Project_Decisional_Unit__c eachRec = updateRenamedOrgPDU[i];
                                if(!result.isSuccess()){
                                    for(Database.Error err : result.getErrors()){
                                        system.debug('***** ERROR RENAMING ORG PDU *** '+err);
                                    }
                                }
                            }
                        }
                        catch(Exception exp){
                            system.debug('Error while inserting the Child PDUs ' + exp.getMessage());
                        }
                    }
                    
                    //EMAIL TEMPLATE CREATION
                    // 16-Oct-17 : JIRA#122 : Supress emails for One Off projects
                    // get the project type and then add only 'Project Based Termination'
                    List<Project__c> projectList = [SELECT Id,OwnerId,Owner.Email,Name,Updated_PDUs__c, Record_Type__c FROM Project__c WHERE Id IN : prjSet];
                    for(Project__c p : projectList){
                        if(!p.Record_Type__c.equalsIgnoreCase('One Off Termination')){
                            projectIdName.put(p.id, p.name);
                            projectOwnerId.put(p.id, p.OwnerId);
                            projectOwnerEmail.put(p.Id, p.Owner.Email);
                        }
                    }
                    system.debug('-- projectIdName--'+ projectIdName);
                    //Get PDUs Name - We only need previous PDU Names
                    set<string> PDUIDset = new set<string>();
                    
                    system.debug('-- existingPDUsIDSet--'+ existingPDUsIDSet);
                    Set<String> PDUName;
                    list<Project_Decisional_Unit__c> pduList;
                    map<string, set<string>> projectToPDUs = new map<string, set<string>>(); 
                    
                    List<Project_Decisional_Unit__c> existingPDUsList = new List<Project_Decisional_Unit__c>();
                    existingPDUsList = [SELECT Project__c, Decisional_Unit_Name__c FROM Project_Decisional_Unit__c WHERE ID IN : existingPDUsIDSet];
                    for(String pId: prjSet){
                        PDUName = new Set<String>();
                        for(Project_Decisional_Unit__c eachPDU : existingPDUsList){
                            if(pId == eachPDU.Project__c){ // if the project IDs are the same
                                PDUName.add(eachPDU.Decisional_Unit_Name__c);
                            }
                        }
                        projectToPDUs.put(pId,PDUName);
                    }
                    system.debug(' -- projectToPDUs -- '+ projectToPDUs);
                    
                    list<project__c> projectListToBeUpdated = new list<project__c> ();
                    for(project__c pr: projectList){
                        String tempStr = '';
                        for(String eachPDU : projectToPDUs.get(pr.id)){
                            tempStr += eachPDU + ',';
                        }
                        pr.Updated_PDUs__c = tempStr.endsWith(',') ? tempStr.removeEnd(',') : tempStr;
                        projectListToBeUpdated.add(pr);
                    }
                    system.debug('--projectListToBeUpdated--'+projectListToBeUpdated);
                     if(!projectListToBeUpdated.isEmpty()){ 
                        try{
                            update projectListToBeUpdated;
                        }
                        catch(Exception exp){
                            system.debug(' -- ERROR WHILE UPDATING PROJECTS -- ' + exp.getMessage());
                        }
                    }
                    system.debug(' -- projectListToBeUpdated -- ' + projectListToBeUpdated);
                    // assign all values for sending emails
                    prjSetForMail.addAll(prjSet);
                    projectOwnerEmailForMail.putAll(projectOwnerEmail);
                    projectOwnerIdForMail.putAll(projectOwnerId);
                    
                    system.debug(' -- prjSetForMail -- ' + prjSetForMail);
                    system.debug(' -- projectOwnerEmailForMail -- ' + projectOwnerEmailForMail);
                    system.debug(' -- projectOwnerIdForMail -- ' + projectOwnerIdForMail);
                }
            }        
        }
    }
    //}
    
    // convert the user IDs to employee IDs
    public List<Employee__c> getEmpIdFromUserId(Set<String> ownerSet){
        List<Employee__c> allEmps = new List<Employee__c>();
        allEmps = [SELECT Id,Name,User__c,emp_id__C FROM Employee__c WHERE User__c IN : ownerSet];
        return allEmps;
    }
        
    // method to get all the coverage entitlements
    public List<Coverage_Entitlement__c> getAllCoverageEntitlements(Set<String> empIdsSet){
        List<Coverage_Entitlement__c> allCovEnts = new List<Coverage_Entitlement__c>();
        if(empIdsSet != null){
            allCovEnts = [SELECT Id,HR_Name__c,HR_Name__r.User__r.Id,(SELECT Id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c FROM HR_Coverage_Orgs__r),HR_EmpID__c FROM Coverage_Entitlement__c WHERE HR_Name__c IN : empIdsSet];
        }
        else{
            allCovEnts = [SELECT Id,HR_Name__c,HR_Name__r.User__r.Id,(SELECT Id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c FROM HR_Coverage_Orgs__r),HR_EmpID__c FROM Coverage_Entitlement__c];
        }
        return allCovEnts;
    }
    // method to create new manually shared records for the updated SnRs
    // this will assign the SnRs to all the Coverage users who have the corresponding Coverage Entitlements
    public List<Severance_and_Release__share> createNewSharedRecords(Map<String,Set<String>> newUsersMap){
        List<Severance_and_Release__share> newSharedRecs = new List<Severance_and_Release__share>();
        if(!newUsersMap.isEmpty()){
            for(String snrId : newUsersMap.keySet()){
                Set<String> tempUsersSet = newUsersMap.get(snrId);
                for(String eachUser : tempUsersSet){
                    Severance_and_Release__share tempShare = new Severance_and_Release__share();
                    tempShare.ParentId = snrId;
                    tempShare.UserOrGroupId = eachUser;
                    tempShare.AccessLevel = 'Read';
                    tempShare.RowCause = 'Manual';
                    newSharedRecs.add(tempShare);            
                }
            }
        }
        return newSharedRecs;        
    }
    // rename the org PDUs
    public List<Child_Project_Decisional_Unit__c> renameOrgPDUs(List<Severance_and_Release__c> rmSNRList,Map<String,Map<String,String>> renameMap){
        List<String> orgPDUList = new List<String>();
        List<Child_Project_Decisional_Unit__c> allOrgPDUList = new List<Child_Project_Decisional_Unit__c>();
        List<Child_Project_Decisional_Unit__c> renameOrgPDUList = new List<Child_Project_Decisional_Unit__c>();
        Set<String> snrOrgs;
        Map<String,Set<String>> snrOrgCodesMap = new Map<String,Set<String>>();
        // get only the Project based SNRs
        for(Severance_and_Release__c snr : rmSNRList){
            if(snr.Record_Type__c == 'Project Based Termination' && snr.Project_Decisional_Org_Level__c != null){
                orgPDUList.add(snr.Project_Decisional_Org_Level__c);
                snrOrgs = new Set<String>();
                snrOrgs.add(snr.Cost_Center__c);
                snrOrgs.add(snr.Sub_Department_2__c);
                snrOrgs.add(snr.Sub_Department__c);
                snrOrgs.add(snr.Department__c);
                snrOrgs.add(snr.Super_Department__c);
                snrOrgs.add(snr.Division__c);
                snrOrgs.add(snr.Super_Division__c);
                snrOrgCodesMap.put(snr.Id, snrOrgs);
            } 
        }
        if(!orgPDUList.isEmpty()){
            allOrgPDUList = [SELECT Id,Decisional_Unit_Derived__c,Org_Hierarchy_Code__c FROM Child_Project_Decisional_Unit__c WHERE Id IN : orgPDUList];
            if(!allOrgPDUList.isEmpty()){
                for(Severance_and_Release__c eachSNR : rmSNRList){
                    for(Child_Project_Decisional_Unit__c eachOrg : allOrgPDUList){
                        if(eachSNR.Project_Decisional_Org_Level__c == eachOrg.Id && snrOrgCodesMap.containsKey(eachSNR.Id) && snrOrgCodesMap.get(eachSNR.Id).contains(eachOrg.Decisional_Unit_Derived__c)){
                            if(renameMap.containsKey(eachSNR.Id) && renameMap.get(eachSNR.Id).containsKey(eachOrg.Decisional_Unit_Derived__c)){
                                String tempCode = String.valueOf(eachOrg.Org_Hierarchy_Code__c).substringAfter(' - ');
                                if(String.valueOf(renameMap.get(eachSNR.Id).get(eachOrg.Decisional_Unit_Derived__c)) != tempCode){
                                    eachOrg.Org_Hierarchy_Code__c = eachOrg.Decisional_Unit_Derived__c + ' - ' + String.valueOf(renameMap.get(eachSNR.Id).get(eachOrg.Decisional_Unit_Derived__c));
                                    renameOrgPDUList.add(eachOrg);
                                }
                            }
                        }
                    }
                }
                system.debug(' -- renameOrgPDUList -- ' + renameOrgPDUList);
            }
        }
        return renameOrgPDUList;
    }
        
        
    global void finish(Database.BatchableContext bc){
        // send email to the owners of all the affected SNRs
        
        /* Preparing email  */
        // get the email template details
        Id templateId = [SELECT Id FROM EmailTemplate WHERE Name = 'RIF Batch - Org Hierarchy Change notification' LIMIT 1].Id;
        // get all rif sys admins email Ids
        // 19-July-17: JIRA#RIF-87 : RIF system admins should not receive any emails
        // commenting below lines as we will not be sending the emails to system admins
        /*
        List<String> adminEmailIDs = new List<String>();
        List<User> adminDetails = [SELECT Id,Email FROM User WHERE Id IN : rifSYSADMINs];
        for(User u : adminDetails){
            adminEmailIDs.add(u.Email);
        }
        system.debug(' -- rifSYSADMINs FIN -- ' + rifSYSADMINs);
        system.debug(' -- adminEmailIDs FIN -- ' + adminEmailIDs);
		*/
        /* Get the ORG WIDE default email address to be set in the FROM field of the email */
        String orgEmail = null;
        String orgEmailId = null;
        for(OrgWideEmailAddress owe : RIF_DataUtil.getOrgWideEmaillAddresses(System.Label.RIF_Orgwide_Email)) {
            orgEmail = owe.Address;
            orgEmailId = owe.id;
        }
        system.debug(' -- FIN orgEmail -- ' + orgEmail);
        system.debug(' -- FIN orgEmailId -- ' + orgEmailId);
        Messaging.SingleEmailMessage mail;
        system.debug(' -- prjSetForMail FIN -- ' + prjSetForMail);
        List<Messaging.SingleEmailMessage> mailingList = new List<Messaging.SingleEmailMessage>();
        for(String prjId : prjSetForMail){
            mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(projectOwnerIdForMail.get(prjId)); // set the user
            List<String> prjOwnerEmailList = new List<String>();
            prjOwnerEmailList.add(projectOwnerEmailForMail.get(prjId));
            mail.setToAddresses(prjOwnerEmailList); // to project owner
            // 19-July-17: JIRA#RIF-87 : RIF system admins should not receive any emails
            //mail.setCcAddresses(adminEmailIDs); // CC all rif admins 
            mail.setOrgWideEmailAddressId(orgEmailId);  // set FROM address e.g (hrforce-rif-notifications-dev@morganstanley.com)
            mail.setSaveAsActivity(false);
            mail.setTemplateId(templateId);
            mail.setWhatId(prjId);
            mailingList.add(mail);
        }
        system.debug(' -- all emails -- ' + mailingList);
        Messaging.sendEmail(mailingList,false);
    }   
}