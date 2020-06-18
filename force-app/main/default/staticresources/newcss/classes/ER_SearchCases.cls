//
// 07/18/2013 RJ: ORIGINAL ; Controller class for search cases Page
//
// 08/28/2013 : MG : Updated for Jira HRFORCE-190

public with sharing class ER_SearchCases {
   public Case__c erCase{get;set;}
   public Case__c erCase1{get;set;}
   public Related_Cases__c rCases{get;set;}
   public list<CaseWrapper> listCases{get;private set;}
   public boolean isSearchClicked{get;set;}
   public boolean isAllowToViewPage{get;set;}
   public boolean isHR{get;set;}
   public boolean isCompliance{get;set;}
   public Parties_Involved__c partyInvolved{get;set;}
   public list<SelectOption> rolePickListValues{get;set;}
   public String empId{get;set;}
   public String externalPartyName{get;set;}
   
   final String QUERY_STRING = 'Select Id, Name, Status__c, Description__c, Subject__c, T360_Case__c,Department__c,Fast_Add_Person__c, Department__r.Name, Reported_Date__c, Incident_Date__c, Category__c, EEO_Issue__c, Discipline_Type__c, Owner.Name <INNER_QUERY> From Case__c where <WhereClause> Order By Name desc';
   final String INNER_QUERY_STRING = ', (Select Id, Party_Name__c, name, Party_Full_Name__c, Is_Person_Anonymous__c, Is_Person_External__c, External_Party_Name__c ' +
                                        'from Parties_Involved__r '+
                                        'where Is_System_Case_Record__c = false and Role__c includes (\'<CASE_ROLE>\') Order By Party_Name__c asc)';
   final String REPORT_URL = '/' + Label.ER_CaseGlobalSearchReportID + '?pv0=<CASE_NAMES>&pv2=<CASE_ROLE>';
   final string COMPLIANCE_ROLE = 'Subject of Complaint/Issue';
   final String HR_ROLE = 'Person Raising Issue';
   final String ANY_ROLE = 'Any';
   final string INTERNAL = 'internal';
   final string INNER_WHERECLAUSE_INTERNAL = ' AND Is_Person_External__c = false AND Is_Person_Anonymous__c = false ';
   final string INNER_WHERECLAUSE_EXTERNAL = ' AND Is_Person_External__c = true ';
   public String val{get; set;} 
    
    public ER_SearchCases(){
         erCase = new Case__c();
         erCase.Status__c = ''; 
         erCase1 = new Case__c();
         rCases = new Related_Cases__c(); 
         listCases = new list<CaseWrapper>(); 
         partyInvolved = new Parties_Involved__c();
         isSearchClicked = false; 
         isAllowToViewPage = true; 
         isHR = false;
         isCompliance = false;
         validatePermission();
         getOptionListForPartyRoles();
         val = INTERNAL;
         
         empId = null;
         system.debug('------------' + rolePickListValues);
    }
    
    public void validatePermission(){
        ER_CaseSearch_Permissions__c permissions = ER_CaseSearch_Permissions__c.getInstance(Userinfo.getProfileId());
        system.debug('----permission---' + permissions);
        if(permissions == null || (!permissions.IS_HR__c && !permissions.IS_Compliance__c)){
            isAllowToViewPage = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.ER_CaseSearchAuthorization));
        }else{
            if(permissions.IS_HR__c){
                isHR = true;
            }
            if(permissions.IS_Compliance__c){
                isCompliance = true;
            }
        }
    }
   
    public void searchCases(){
        listCases = new list<CaseWrapper>(); 
        isSearchClicked = false;
        String caseId = rCases.Related_Case__c;
        String t360 = erCase.T360_Case__c;
        String status = erCase.Status__c;
      //  String subject = erCase.Fast_Add_Person__c;
        String subject = erCase.Subject__c;
        String Description = erCase.Description__c;
        Date reportedStartDate = erCase.Reported_Date__c;
        Date reportedEndDate = erCase1.Reported_Date__c;
        Date incidentStartDate = erCase.Incident_Date__c;
        Date incidentEndDate = erCase1.Incident_Date__c;
        String eeoIssue = erCase.EEO_Issue__c;
        string ownerId = erCase.OwnerId;
        string investigator = erCase.Investigator__c;
        //string partyName = '';
       // system.debug(' -- partyInvolved -- '+ partyInvolved);
       /* if(!string.valueof(partyInvolved.Party_Name__c).contains('Object')){
         partyName = partyInvolved.Party_Name__c;   
        }*/
        string partyName = partyInvolved.Party_Name__c;   
        String partyRole = partyInvolved.Role__c;
        String disciplineType = erCase.Discipline_Type__c;
        set<string> caseIds = new set<string>();
        system.debug('val: '+ val);
        String selectedCategorys = '';
        if (erCase.Category__c <> null){
            for (String s: erCase.Category__c.split(';')){
                   selectedCategorys += '\'' + s + '\',';
            }
            selectedCategorys = selectedCategorys.substring (0,selectedCategorys.length() -1);
        }
        
        String department = erCase.Department__c;
        if(caseId == null && t360 == null && (status == null || status == '') && reportedStartDate == null && reportedEndDate == null && incidentStartDate == null && incidentEndDate == null &&
            (subject == null || subject == '') && department == null && (selectedCategorys == null ||  selectedCategorys == '') 
            && (eeoIssue == null || eeoIssue == '') && (ownerId == null || ownerId == '') && (investigator == null || investigator == '') && 
            (partyName == null || partyName == '') && disciplineType == null ){
                
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.ER_NoCaseSearchCriteriaMessage));
            return;
        }else if((reportedStartDate != null && reportedEndDate == null) || (reportedStartDate == null && reportedEndDate != null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.ER_CaseSearchStartEndDate));
                return;
        }else{
            if((incidentStartDate != null && incidentEndDate == null) || (incidentStartDate == null && incidentEndDate != null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.ER_CaseSearchStartEndDate));
                return;
            }
        }
        
        isSearchClicked = true;
        String whereClause =  caseId <> null ? ' Id =:caseId ' : '';
        if((caseId == null) && (t360<> null)){
         whereClause = t360 <> null ? ' T360_Case__c = :t360' : '';
        }
               
        String innerWhereClause = ''; 
        if((caseId == null)&(t360 == null)){
            whereClause +=  (status <> null && status <> '') ? ' AND Status__c = :status ' : '';
            whereClause +=  (reportedStartDate <> null && reportedEndDate <> null) ? ' AND (Reported_Date__c >= :reportedStartDate and Reported_Date__c <= :reportedEndDate) ' : '';
            whereClause +=  (incidentStartDate <> null && incidentEndDate <> null) ? ' AND (Incident_Date__c >= :incidentStartDate and Incident_Date__c <= :incidentEndDate) ' : '';
            whereClause += (department <> null) ? ' AND Department__c = :department' : '';
            whereClause += selectedCategorys != '' ? ' AND Category__c INCLUDES (' + selectedCategorys + ')' : '';
            whereClause += (eeoIssue <> null && eeoIssue <> '') ? ' AND EEO_Issue__c = :eeoIssue' : '';
            whereClause += (ownerId <> null && ownerId <> '') ? ' AND OwnerId = :ownerId' : '';
            whereClause += (investigator <> null && investigator <> '') ? ' AND Investigator__c = :investigator' : '';
            whereClause += (disciplineType <> null) ? ' AND Discipline_Type__c = :disciplineType' : '';
            
            if(subject <> null && subject <> ''){
                subject = subject.replaceAll('\\\\', '\\\\\\\\');
                subject = '%' + subject + '%';
                whereClause += (subject <> null && subject <> '') ? ' AND Subject__c like :subject' : ''; 
                
            }
            
            //Search Based on Party Involved
            
            innerWhereClause = 'Where Is_System_Case_Record__c = false ';
            boolean runPIQuery = false;
            if(partyRole <> ANY_ROLE){
                innerWhereClause += ' AND Role__c includes (\'' + partyRole +'\')';
                runPIQuery = true;
                
            }
            
            if(partyName <> null && partyName <> ''){
               partyName = partyName.replaceAll('\\\\', '\\\\\\\\');
               partyName = '%' + partyName + '%';
               
               innerWhereClause += (val == INTERNAL ? INNER_WHERECLAUSE_INTERNAL : INNER_WHERECLAUSE_EXTERNAL) ;
               
               innerWhereClause += ' AND Party_Name__c like :partyName ';
               runPIQuery = true;
               system.debug('--------------' + partyName);
                
            }
            
            if(runPIQuery){
                String query = 'Select Id, Party_Name__c, Case__c, Name from Parties_Involved__c ' + innerWhereClause;
                System.debug('query -> ' + query);
                for(Parties_Involved__c pi : Database.query(query)){
                    caseIds.add(pi.Case__c);
                    
                }
            }
            whereClause += (runPIQuery && caseIds.size() > 0) ? ' AND Id IN :caseIds' : '';
        }
        
        if(whereClause <> null && whereClause <> ''){ 
            system.debug(whereClause.trim());
            if(whereClause.trim().startsWith('AND')){
                whereClause = whereClause.replaceFirst('AND', '');
            }
            String queryString = QUERY_STRING.replace('<WhereClause>', whereClause);
            String innerQuery = isHR ? INNER_QUERY_STRING.replace('<CASE_ROLE>', HR_ROLE) : INNER_QUERY_STRING.replace('<CASE_ROLE>', COMPLIANCE_ROLE) ;
            queryString = queryString.replace('<INNER_QUERY>', innerQuery);
            system.debug('-----------------' + queryString);
            for(Case__c erCase : Database.query(queryString)){
                listCases.add(new CaseWrapper(erCase, erCase.Parties_Involved__r));
            }
            isSearchClicked = true;
        }
        
    }
    
    public PageReference exportResults(){
        String caseNames = '';
        for(CaseWrapper erCase : listCases){            
            caseNames += caseNames == '' ? erCase.parentCase.Name : ','+erCase.parentCase.Name;
        }
        //return new PageReference(REPORT_URL + caseNames);
        String caseRole = isHR == true ? HR_ROLE : COMPLIANCE_ROLE;
        String reportURL = REPORT_URL.replace('<CASE_NAMES>', caseNames).replace('<CASE_ROLE>', caseRole);
        return new PageReference(reportURL);
        
    }
    
    public void clearSearch(){
        erCase = new Case__c();
        erCase.Status__c = ''; 
        erCase1 = new Case__c();
        rCases = new Related_Cases__c(); 
        listCases = new list<CaseWrapper>(); 
        partyInvolved = new Parties_Involved__c();
        isSearchClicked = false; 
        isAllowToViewPage = true;
        val = INTERNAL;
        empId = null;
        if(isHR) 
            partyInvolved.Role__c = ANY_ROLE;
    }
    
    public void getEmpId(){
        
        List<Employee__c> empList = ER_DataUtil.getEmployee(partyInvolved.Person__c);
        if(!empList.isEmpty()){
            partyInvolved.Party_Name__c = empList[0].Emp_Id__c;
            empId = empList[0].Emp_Id__c;
        }
    }
    
    private void getOptionListForPartyRoles(){

        if(isHR){
            rolePickListValues = new List<SelectOption>();
            Schema.sObjectType sobject_type = partyInvolved.getSObjectType(); //grab the sobject that was passed
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Role__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
            for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                rolePickListValues.add(new SelectOption(a.getLabel(), a.getValue()));//add the value  to our final list
            }
            rolePickListValues.add(new SelectOption(ANY_ROLE, ANY_ROLE));//add the 'ANY'  to our final list only for HR profile
            partyInvolved.Role__c = ANY_ROLE;
        }else{
            rolePickListValues = new List<SelectOption>();
            rolePickListValues.add(new SelectOption('Subject of Complaint/Issue', 'Subject of Complaint/Issue'));
        }
        system.debug('------------' + rolePickListValues);
    }
   
    public class CaseWrapper{
        public Case__c parentCase{get; set;}
        //public list<Parties_Involved__c> piList{get; set;}
        public boolean showChildrenRecords{get; set;}
        public String caseReportedDate{get;set;}
        public String caseIncidentDate{get;set;}
        public string piName{get;set;}
        public CaseWrapper(Case__c parentCase, list<Parties_Involved__c> piList){
            this.parentCase = parentCase;
            if(parentCase.Reported_Date__c <> null){
                Datetime dt = dateTime.newInstance(parentCase.Reported_Date__c, Time.newInstance(0, 0, 0, 0));
                this.caseReportedDate = dt.format('MM/dd/yyyy').substring(0,10); // Reported Date must be shown in MM/dd/yyyy format.
                
            }else{
                caseReportedDate = '';
            }
            
            if(parentCase.Incident_Date__c <> null){
                Datetime dt = dateTime.newInstance(parentCase.Incident_Date__c, Time.newInstance(0, 0, 0, 0));
                this.caseIncidentDate = dt.format('MM/dd/yyyy').substring(0,10); // Reported Date must be shown in MM/dd/yyyy format.
                
            }else{
                caseIncidentDate = '';
            }
            
            //this.piList = piList;
            this.piName = '';
            for(Parties_Involved__c pi : piList){
                string pName = (!pi.Is_Person_Anonymous__c ? (pi.Is_Person_External__c ? pi.External_Party_Name__c : pi.Party_Full_Name__c) : '');
                if(pName <> null && pName <> '')
                    piName += (piName == '' ? pName : ', '+pName);
            }
            
            this.piName = (piName == '' ? 'None' : piName);
        }
    }  
}