/** Controller class for RIF_GlobalSNRSearchPage vf page 
This class will control all the page functions
**/
public class RIF_GlobalSNRSearch {
    // declare all the page attributes
    public String projectType {get; set;}
    public String projectName {get; set;}
    // work around to get Datepicker on IE
    public Severance_And_Release__c snrCreatedFrom {get; set;}
    public Severance_And_Release__c snrCreatedTo {get; set;}
    public String empId {get; set;}
    public String empName {get; set;}
    public String pjtOwnerName {get; set;}
    public String prjtStatus {get; set;}
    public String createdByName {get; set;}
    public Integer totalResults {get; set;}
    public List<DisplayWrapper> finalResult {get; set;}
    
    // other member variables
    public static final String ONE_OFF_TERMINATION = 'One Off Termination';
    public static final String PROJECT_BASED_TERMINATION = 'Project Based Termination';
    public List<Severance_and_Release__c> snrResultList;
    public List<Severance_And_Release__c> accessibleSRList;
    public Date createdFrom,createdTo;
    public Map<String,String> snrRecTypeMap;
    public String snrRecType = '';
    public Map<String,Set<String>> userAllCovEntsMap = new Map<String,Set<String>>();
    public static Map<String,String> orgHierMap = new Map<String,String>{ 'Super Division' => 'Super_Division__c', 'Division' => 'Division__c','Super Department' => 'Super_Department__c', 'Department' => 'Department__c','Sub Department' => 'Sub_Department__c', 'Sub Department 2' => 'Sub_Department_2__c','Cost Center' => 'Cost_Center__c' };
    public String theEntitlements = '';
    public Boolean needsSNRsShareCheck;
    public Set<String> accessibleProjectSet = new Set<String>();
    public Set<String> accessibleSNRSet = new Set<String>();
    public Set<String> userGroupsSet = new Set<String>();
    public Set<String> manuallySharedProjectsSet = new Set<String>();
    public Integer OFFSET = 0;
    public Integer RESULT_SIZE = 50;
    public Integer TOTAL_ROWS = 0;
    
    // the constructor
    public RIF_GlobalSNRSearch(){
        projectType = 'Both'; 
        snrCreatedFrom = new Severance_And_Release__c();
        snrCreatedTo = new Severance_And_Release__c();
        snrResultList = new List<Severance_and_Release__c>();
        finalResult = new List<DisplayWrapper>();
        needsSNRsShareCheck = true;
        // get all the RIF groups the the logged in user is part of
        userGroupsSet = getUserRIFGroup(UserInfo.getUserId());
        userGroupsSet.add(String.valueOf(UserInfo.getUserId()));
        // get project record types
        snrRecTypeMap = snrRecordTypes();
        // get accessible projects
        accessibleProjectSet = checkProjectAccess(userGroupsSet);
        // get accessible SNRs
        accessibleSNRSet = checkSNRAccess(userGroupsSet);
        // get all the coverage entitlements for the logged in user
        theEntitlements = entitlementsStringMaker(RIF_DataUtil.getLoggedInUSerCovEntitlementTypeWithCode(UserInfo.getUserId()));
        system.debug(' -- theEntitlements --' + theEntitlements);   
    }
    
    // search SNRs with the conditions entered on the page
    public PageReference search(){
        if(String.isEmpty(theEntitlements)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have no coverage entitlements configured!'));
            return null; 
        }
        
        snrResultList = new List<Severance_and_Release__c>();
        finalResult = new List<DisplayWrapper>();
        createdFrom = null;
        createdTo = null;
        Set<String> projectShareCopySet = new Set<String>();
        // CONDITION 1 --- project/SNR type check (One-Off OR Project based)
        system.debug(' -- projectType -- ' + projectType);
        if(snrRecTypeMap != null && !snrRecTypeMap.isEmpty()){
            if(projectType.equalsIgnoreCase('Project')){
                snrRecType = snrRecTypeMap.get(PROJECT_BASED_TERMINATION);
            }
            else if(projectType.equalsIgnoreCase('OneOff')){
                snrRecType = snrRecTypeMap.get(ONE_OFF_TERMINATION);
            }
            else{
                snrRecType ='';
            }
        }
        // CONDITION 2 --- project name
        system.debug('-- projectName --' + projectName);
        // CONDITION 3 --- created date range
        system.debug(' -- snrCreatedFrom -- ' + snrCreatedFrom);
        system.debug(' -- snrCreatedTo -- ' + snrCreatedTo);
        
        if(snrCreatedFrom != null){
            if(snrCreatedFrom.Created_Date_From__c != null){
                createdFrom = snrCreatedFrom.Created_Date_From__c;
            }
        }
        if(snrCreatedTo != null){
            if(snrCreatedTo.Created_Date_To__c != null){
                createdTo = snrCreatedTo.Created_Date_To__c;
            }
        }

        system.debug(' -- createdFrom -- ' + createdFrom);
        system.debug(' -- createdTo -- ' + createdTo);
        // CONDITION 4 --- employee MSID
        system.debug(' -- empId -- ' + empId);
        // CONDITION 5 --- employee name
        system.debug(' -- empId -- ' + empName);
        // CONDITION 6 --- project owner name
        system.debug(' -- pjtOwnerName -- ' + pjtOwnerName);
        // CONDITION 7 --- project status
        system.debug(' -- prjtStatus -- ' + prjtStatus);
        // CONDITION 8 --- created by name
        system.debug(' -- createdByName -- ' + createdByName);
        
        
        
        // *** Get all manually shared projects ***
        // get all the SNRs that are not visible to the user, but the overlying project is manually shared with the user
        system.debug(' -- manuallySharedProjectsSet -- ' + manuallySharedProjectsSet);
        // get the SNRs from these projects, check the coverage and then share it manually with the user
        if(needsSNRsShareCheck){
            Boolean sharedNewSNRs = shareSNRsWithUser(manuallySharedProjectsSet);
            system.debug(' -- sharedNewSNRs -- ' + sharedNewSNRs);
            // get the latest SNR shared list
            if(sharedNewSNRs){
                accessibleSNRSet = checkSNRAccess(userGroupsSet);
            }
            needsSNRsShareCheck = false;
        }
        
        
        // get the total rows that will be returned
        TOTAL_ROWS = RIF_GlobalSNRSearchDataFetcher.getTotalRecords(theEntitlements, snrRecType, projectName, createdFrom, createdTo, empId, empName, pjtOwnerName, prjtStatus, createdByName);
        // perform the query
        snrResultList = RIF_GlobalSNRSearchDataFetcher.getAllSNRRecords(theEntitlements, snrRecType, projectName, createdFrom, createdTo, empId, empName, pjtOwnerName, prjtStatus, createdByName, OFFSET, RESULT_SIZE);
        if(snrResultList != null && !snrResultList.isEmpty()){
            system.debug(' -- accessibleProjectSet -- ' + accessibleProjectSet);
            system.debug(' -- accessibleSNRSet -- ' + accessibleSNRSet);
            Integer index = 1;
            // get all SNRs owned and already shared with the user
            projectShareCopySet.addAll(accessibleProjectSet);
            system.debug(' -- projectShareCopySet BEF -- ' + projectShareCopySet);
            for(Severance_and_Release__c snr : snrResultList){
                if(projectShareCopySet != null && !projectShareCopySet.isEmpty() && projectShareCopySet.contains(snr.Project__c)){
                    projectShareCopySet.remove(snr.Project__c);
                }
                system.debug(' -- snr -- ' + snr);
                Boolean hasPrjtAccess = false;
                Boolean hasSNRAccess = false;
                // find the access to project
                if(accessibleProjectSet != null && !accessibleProjectSet.isEmpty() && accessibleProjectSet.contains(String.valueOf(snr.Project__c))){
                    hasPrjtAccess = true;
                }
                // find the access to snr and emp
                if(accessibleSNRSet != null && !accessibleSNRSet.isEmpty() && accessibleSNRSet.contains(String.valueOf(snr.Id))){
                    hasSNRAccess = true;
                }
                system.debug(' -- hasPrjtAccess -- ' + hasPrjtAccess);
                system.debug(' -- hasSNRAccess -- ' + hasSNRAccess);
                // add all information to the wrapper
                finalResult.add(new DisplayWrapper(snr.Name, snr.Project__r.Name, snr.Employee__r.Emp_ID__c, snr.Employee__r.Name, snr.Project__r.Status__c, hasPrjtAccess, hasSNRAccess, snr.Id, snr.Employee__c, snr.Project__c, index));
                index++;
            }
        }
        
        totalResults = TOTAL_ROWS;
        
        return null;
        
    }
    
    // reset all values
    public PageReference clear(){
        OFFSET = 0;
        TOTAL_ROWS = 0;
        snrResultList.clear();
        finalResult.clear();
        projectType = 'Both'; 
        snrCreatedFrom = new Severance_And_Release__c();
        snrCreatedTo = new Severance_And_Release__c();
        return null; 
    }
    
    // get the project record type Ids
    public Map<String,String> snrRecordTypes(){
        Map<String,String> rTypeMap = new Map<String,String>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.Severance_and_release__c; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        if(rtMapById != null && !rtMapById.isEmpty()){
            for(Schema.RecordTypeInfo recT : rtMapById.values()){
                rTypeMap.put(recT.Name, recT.RecordTypeId);
            }
        }
        return rTypeMap;
    }
    
    // set the Project Status field's select option values
    public List<SelectOption> getPrjStatusOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        Schema.DescribeFieldResult fieldResult = Project__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;
    }
    
    // set the Project Status field's select option values
    public List<SelectOption> getProjectSelections(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Project','Project'));
        options.add(new SelectOption('OneOff','One-Off'));
        options.add(new SelectOption('Both','Both'));
        return options;
    }
    
    // this function takes a map of the users entitlement and returns the corresponding condition string to be used in the query
    // e.g INPUT - {Cost Center={1J06}, Department={81200, 93840}, Division={99140}, Sub Department={94652}, Sub Department 2={98326}, Super Department={73236}, 
    //Super Division={10100, 10200, 10300, 10600, 10910, 98100}}  
    // OUTPUT - the final return string (Super_Division__c IN ('10910') OR Cost_center__c IN ('001','002','003'))
    public String entitlementsStringMaker(Map<String,Set<String>> entlsMap){
        String finalString = '';
        String tempStr = '';
        for(String orgHier : entlsMap.keySet()){
            String tempHier = orgHierMap.get(orgHier);
            Set<String> tempEnts =  entlsMap.get(orgHier);
            Boolean hasCodes = false;
            String codeString = '';
            if(tempEnts != null && !tempEnts.isEmpty()){
                hasCodes = true;
                String codeStr = ' (';
                for(String code : tempEnts){
                    codeStr = codeStr + '\''+ code + '\'' + ', ';
                }
                codeStr = codeStr.removeEnd(', ') + ') ';
                codeString = codeStr;
            }
            if(hasCodes && !String.isEmpty(codeString)){
                tempStr = tempStr + tempHier + ' IN ' + codeString + ' OR ';
            }
        }
        tempStr = tempStr.removeEnd(' OR ');
        if(!String.isEmpty(tempStr)){
            finalString = ' ( ' + tempStr + ' ) ';
        }
        return finalString;
    }
    
    // this function will check the user's access to the SNR's projects - both types i.e. One Offs and Projects
    public Set<String> checkProjectAccess(Set<String> userPrjtAcc){
        Set<String> allAccessiblePrjtSet = new Set<String>();
        if(!userPrjtAcc.isEmpty()){
            // get all the projects that are accessable to the user - from the Project share table
            for(Project__share pjtShr : [SELECT ParentId,RowCause FROM Project__share WHERE UserOrGroupId IN : userPrjtAcc]){
                allAccessiblePrjtSet.add(pjtShr.ParentId);
                // get all manually shared projects
                if(String.valueOf(pjtShr.RowCause).equalsIgnoreCase('Manual')){
                    manuallySharedProjectsSet.add(pjtShr.ParentId);
                }
            }
        }
        return allAccessiblePrjtSet;
    }
    
    // this function will check the user's access to all the SNRs
    public Set<String> checkSNRAccess(Set<String> userSNRAcc){
        Set<String> allAccessibleSNRSet = new Set<String>();
        if(!userSNRAcc.isEmpty()){
            // get all the projects that are accessable to the user - from the Project share table
            for(Severance_and_Release__share snrShr : [SELECT ParentId FROM Severance_and_Release__share WHERE UserOrGroupId IN : userSNRAcc]){
                allAccessibleSNRSet.add(snrShr.ParentId);
            }
        }
        return allAccessibleSNRSet;
    }
    
    // get the public groups that the user belongs to as a SNR or project record can be shared with a group as well
    public Set<String> getUserRIFGroup(String userId){
        Set<String> userGroupIdSet = new Set<String>();
        List<GroupMember> usersRIFGroupDetails = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: userId AND GroupId IN (SELECT Id FROM Group WHERE Name LIKE '%RIF%')];
        if(usersRIFGroupDetails != null && !usersRIFGroupDetails.isEmpty()){
            for(GroupMember grp : usersRIFGroupDetails){
                userGroupIdSet.add(grp.GroupId);
            }
        }
        return userGroupIdSet;
    }
    
    // share the SNRs with the user - if the SNRs are under the users' coverage
    public Boolean shareSNRsWithUser(Set<String> projectIdSet){
        Boolean hasNewSharedSNRs = false;
        List<Severance_And_Release__c> shrSNRList = new List<Severance_And_Release__c>();
        Set<Severance_And_Release__c> snrAccessCopySet = new Set<Severance_And_Release__c>();
        shrSNRList = getAccessibleSRRecords(projectIdSet);
        system.debug(' -- shrSNRList -- ' + shrSNRList);
        if(shrSNRList != null && !shrSNRList.isEmpty()){
            // copy the list to set to compare with already existing SNRs list
            snrAccessCopySet.addAll(shrSNRList);
            try{
                for(Severance_and_Release__c snr : shrSNRList){
                    if(accessibleSNRSet != null && !accessibleSNRSet.isEmpty() && accessibleSNRSet.contains(snr.Id)){
                        system.debug(' -- already shared SNR -- ');
                        snrAccessCopySet.remove(snr);
                    }
                }
                system.debug(' -- snrAccessCopySet AFT --' + snrAccessCopySet);
                if(!snrAccessCopySet.isEmpty()){
                    List<Severance_And_Release__c> shrSNRTempList = new List<Severance_And_Release__c>();
                    shrSNRTempList.addAll(snrAccessCopySet);
                    RIF_Sharing.Share_S_R_From_Project(shrSNRTempList , Userinfo.getuserID(), 'Edit');
                    hasNewSharedSNRs = true;
                }
            }
            catch(Exception exp){
                system.debug(' EXCEPTION while inserting the SNR share records : ' + exp);
                hasNewSharedSNRs = false;
            }
        }
        return hasNewSharedSNRs;
    }
    
    // get the accessible records according to the users coverage entitlements
    public List<Severance_And_Release__c> getAccessibleSRRecords(Set<String> projectIdSet){
        accessibleSRList = new List<Severance_And_Release__c>();
        
        if(!projectIdSet.isEmpty()){
            try{
                List<Employee__c>  empObj = [SELECT Id FROM Employee__c WHERE User__c =: Userinfo.getuserID() LIMIT 1];
                system.debug(' -- empObj -- ' + empObj);
                List<Coverage_Entitlement__c> covEntitlementObj = [SELECT Id,HR_Name__c,(SELECT Id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c FROM HR_Coverage_Orgs__r),HR_EmpID__c FROM Coverage_Entitlement__c WHERE HR_Name__c=: empObj[0].Id LIMIT 1];
                system.debug(' -- covEntitlementObj -- ' + covEntitlementObj);
                system.debug(' -- projectIdSet -- ' + projectIdSet);
                List<Severance_And_Release__c> srlist = new List<Severance_And_Release__c>([SELECT Id,ownerid,Emp_Id__c,Super_Division__c,Division__c,Super_Department__c,Department__c,Sub_Department__c,Sub_Department_2__c,Cost_Center__c FROM Severance_And_Release__c WHERE Project__c IN : projectIdSet ]);
                system.debug('--- All srlist size --- '+srlist.size());  
                
                if(srlist != null && !srlist.isEmpty() && covEntitlementObj != null && !covEntitlementObj.isEmpty() && covEntitlementObj[0].HR_Coverage_Orgs__r != null && covEntitlementObj[0].HR_Coverage_Orgs__r.size() > 0){
                    Map <string,set<string>> covTypeToCodeMap= new Map <string,set<string>> ();
                    for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj[0].HR_Coverage_Orgs__r){
                        if(!covTypeToCodeMap.containsKey(covEntOrg.Coverage_Entitlement_Type__c)){
                            set<String> tempSet=new set<String>();
                            tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c);
                            covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                        }  
                        else{
                            set<String> tempSet=new set<String>();
                            tempSet=covTypeToCodeMap.get(covEntOrg.Coverage_Entitlement_Type__c);
                            tempSet.add(covEntOrg.Coverage_Entitlement_Org_Code_Derived__c); 
                            covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,tempSet);
                        }   
                    }
                    system.debug('####covTypeToCodeMap#####'+covTypeToCodeMap); 
                    for(Severance_And_Release__c sr: srlist){
                        if( covTypeToCodeMap.containsKey('Super Division') && covTypeToCodeMap.get('Super Division') != null && covTypeToCodeMap.get('Super Division').contains(sr.Super_Division__c)){  
                            accessibleSRList.add(sr);
                            system.debug('####sr.Super_Division__c inside if loop for covTypeToCodeMap#####'+sr.Super_Division__c);   
                        }
                        else if( covTypeToCodeMap.containsKey('Division') && covTypeToCodeMap.get('Division') != null && covTypeToCodeMap.get('Division').contains(sr.Division__c) )  
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Super Department') && covTypeToCodeMap.get('Super Department') != null && covTypeToCodeMap.get('Super Department').contains(sr.Super_Department__c) )  
                            accessibleSRList.add(sr);   
                        else if( covTypeToCodeMap.containsKey('Department') && covTypeToCodeMap.get('Department') != null && covTypeToCodeMap.get('Department').contains(sr.Department__c) )  
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Sub Department') && covTypeToCodeMap.get('Sub Department') != null && covTypeToCodeMap.get('Sub Department').contains(sr.Sub_Department__c) )    
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Sub Department 2') && covTypeToCodeMap.get('Sub Department 2') != null && covTypeToCodeMap.get('Sub Department 2').contains(sr.Sub_Department_2__c) )      
                            accessibleSRList.add(sr);  
                        else if( covTypeToCodeMap.containsKey('Cost Center') && covTypeToCodeMap.get('Cost Center') != null && covTypeToCodeMap.get('Cost Center').contains(sr.Cost_Center__c) )   
                            accessibleSRList.add(sr);             
                    }
                    covTypeToCodeMap.clear();
                }
                covEntitlementObj.clear();
                srlist.clear();
                
            }
            catch(Exception exp){
                system.debug(' EXCEPTION while getting the accessible SNRs for the user : ' + exp);
            }
        }    
        system.debug(' -- accessibleSRList SIZE -- ' + accessibleSRList.size());          
        return accessibleSRList;
    }
    
    // PAGINATION CONTROLLERS
    
    public PageReference first(){
        OFFSET = 0;
        search();
        return null;
    } 
    
    public PageReference previous(){
        OFFSET = OFFSET - RESULT_SIZE;
        search();
        return null;
    }
    
    public PageReference next(){
        OFFSET = OFFSET + RESULT_SIZE;
        search();
        return null;
    }
    
    public PageReference last(){
        OFFSET = TOTAL_ROWS - math.mod(TOTAL_ROWS, RESULT_SIZE);
        return null;
    }
    
    public Boolean getDisableNext(){
        if(OFFSET + RESULT_SIZE < TOTAL_ROWS){
            return false;
        }
        return true;
    }
    
    public Boolean getDisablePrevious(){
        if(OFFSET > 0){
            return false;
        }
        return true;
    }
    
    // wrapper class used to display the items on the UI
    public class DisplayWrapper{
        // member variables
        public String snrName {get; set;}
        public String projectName {get; set;}
        public String empMSID {get; set;}
        public String empName {get; set;}
        public String projectStatus {get;set;}
        public Boolean snrVisible {get; set;}
        public Boolean projectVisible {get; set;}
        public Boolean empVisible {get; set;}
        public String snrId {get; set;}
        public String empId {get; set;}
        public String prjtId {get; set;}
        public Integer index {get; set;}
        
        // the constructor , initialize all the variables
        public DisplayWrapper(String snrName, String projectName, String empMSID, String empName, String projectStatus, Boolean projectVisible, Boolean snrVisible, String snrId, String empId, String prjtId, Integer index){
            this.snrName = snrName;
            this.projectName = projectName;
            this.empMSID = empMSID;
            this.empName = empName;
            this.projectStatus = projectStatus;
            this.snrVisible = snrVisible;
            this.projectVisible = projectVisible;
            this.empVisible = snrVisible;
            this.snrId = snrId;
            this.empId = empId;
            this.prjtId = prjtId;
            this.index = index;
            
        }
    }
    
}