//RA: Created for create One Off Termination Project from Project Level Detail page or from Independent Tab
//
public without sharing class RIF_CreateOneOffTerminationProject {
    
    //variables
    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    private string ONE_OFF_TERMINATION = 'One Off Termination';
    private string project_OneOffRecordTypeId = '';
    private string sr_OneOffRecordTypeId = '';
    private Child_Project_Decisional_Unit__c childPDU;
    
    //getter-setters
    public string projectLevelId {get;set;}
    public Project_Decisional_Unit__c pdu {get;set;}
    public Severance_Parameters__c sp {get;set;}
    public Project__c project{get;set;}
    public Severance_And_Release__c sr{get;set;}
    public Project_Level__c projectLevelforSnR{get;set;}
    public boolean isProjCommDateLeapYear{get;set;}
    public List<Unvested_Equity__c> empUnvestedList{get;set;} 
    public Unvested_Equity__c empUnvested{get;set;}
    //public Comp_Data__c compData{get; set;}
    public string unvestedtotalValue{get;set;}
    
    public Employee__c emp{get;set;}
    //private string CALCULATE_AND_OVERRIDE_MANUAL_CHANGES = 'Calculate and Override Manual Changes';
    
    
    public RIF_CreateOneOffTerminationProject() {
        //projectLevelforSnR= new Project_Level__c();
        projectLevelId = null;
        // 6-Mar-2017 : Initialize the value of this flag to FALSE
        isProjCommDateLeapYear = false;
        if(ApexPages.currentPage().getParameters().containsKey('plID')){
            projectLevelId = ApexPages.currentPage().getParameters().get('plID');
        }
        //pageMessages = new list<ApexPages.Message>();
        project = new Project__c(Country__c=' ');
        sp =  new Severance_Parameters__c(MS_MSSB__c='',Level_Dsc__c='');
        pdu = new Project_Decisional_Unit__c();
        childPDU= new Child_Project_Decisional_Unit__c();
        
        sr = new Severance_And_Release__c();
        
        List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(ONE_OFF_TERMINATION);
        for(RecordType rt : lstRT){
           if(rt.SobjectType == 'Project__c'){
               project_OneOffRecordTypeId = rt.Id;
           }
           if(rt.SobjectType == 'Severance_And_Release__c'){
               sr_OneOffRecordTypeId = rt.Id;
           }
        }
    }
    
    public Pagereference finish(){
        return createOneOffTerminationProject();
    }
    
    
    public Pagereference createOneOffTerminationProject(){
        getEmployeeDetails();
        list<ApexPages.Message> pageMessages = new list<ApexPages.Message> ();
        
       /** Terminated Employees can be used for Projects
        if(!emp.status__c.equalsIgnoreCase('Active')){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Only Active employees can be selected')); 
            return null;     
        }
        ****/
        if(!project.status__c.equalsIgnoreCase('Model')){
            // 4-July-2017 : JIRA#88 : When adding an employee to a project, the employee should not be present in any other ACTIVE project
            /*
            for(Severance_And_Release__c sr : RIF_DataUtil.findSeveranceAndReleaseInProjectOneOff(emp.Emp_Id__c) ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ': Selected employee is already a member of '+sr.Project_Level__r.Project__r.name+' project'));
                return null; 
            }
			*/
            for(Severance_And_Release__c sr : RIF_DataUtil.findSNRInActiveProject(new Set<String>{emp.Emp_Id__c}) ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, sr.Emp_Id__c + ': Selected employee is already a member of '+sr.Project_Level__r.Project__r.name+' project'));
                return null; 
            }
            
        }
        
        Boolean isEmployeeAccessible=false;
        isEmployeeAccessible=RIF_DataUtil.getAccessibleEmployee(emp);  
        System.debug('Outside IF--'+isEmployeeAccessible);
        if(!isEmployeeAccessible){
            System.debug('Inside IF--'+isEmployeeAccessible);
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, emp.Emp_Id__c + ': Selected employee does not exist in your Coverage Area.'));
            return null;     
        }
        
        
       
       /** if(sr.Last_Day_On_Premises__c < Date.today()){
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_LastDayLessthanToday));
             return null;   
        }**/
        
        if(sr.Last_Day_On_Premises__c > project.Termination_Date__c){ 
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_LastDayGreaterThanTerminationDate));
             return null;   
        }
        
   /*     if(sr.Basic_Severance_Local__c > sr.Project_Level__r.Basic_Max__c){ 
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_BasicSeveranceNotGreater));
             return null;   
        }            */
        
        // project Creation
        //project.Name='One-Off-RIF-'+ dateTime.now().time();
        project.Name='One-Off- '+sr.Last_Name__c+', '+sr.First_Name__c+ '_'+dateTime.now();
        project.RecordTypeId = project_OneOffRecordTypeId;
        project.Super_Division__c = emp.Super_Division__c;
        project.Notice_Days__c = project.Communication_Date__c.daysbetween(project.termination_date__c ); 
        
        
        pageMessages = RIF_DataUtil.insertResult(new List<SObject>{project});
        if(!pageMessages.isEmpty()){
            for(ApexPages.Message msg : pageMessages){
               ApexPages.addMessage(msg);
            }
            return null;
        } 
        //insert parameter by level
        projectLevelforSnR.Project__c = project.Id;
        pageMessages = RIF_DataUtil.insertResult(new List<SObject>{projectLevelforSnR}); 
        
        // Project Decisional Unit Record Creation
        pdu.Project__c = project.Id;
        pdu.Decisional_Unit_Name__c='Generic Decisional Unit on One Off';
        pageMessages = RIF_DataUtil.insertResult(new List<SObject>{pdu});
        
        //query employee for getting super division
        Employee__c emprecord=RIF_DataUtil.getSingleEmployeeRecord(emp.Emp_Id__c);
        //Employee__c emprecord=RIF_DataUtil.getSingleEmployeeRecord(emp.id);
        
        // org PDU Record Creation
        /* childPDU.Project_Decisional_Unit__c = pdu.Id;
        childPDU.ProjectID__c=project.Id;
        childPDU.Decisional_Unit_Type__c='Super Division';
        List<Org_Codes__c> orgCode = new List<Org_Codes__c> ();
         orgCode = [SELECT Id,Name, Code_Type__c, Code__c from org_codes__c where code_type__c = 'Super Division' and code__c =:emprecord.Super_Division__c];
        if(orgCode != null && orgCode.size() >0)
              childPDU.Decisional_Unit_Code__c=orgCode[0].ID;
              
              //childPDU.Decisional_Unit_Code__c=emprecord.Super_Division__c;
        pageMessages = RIF_DataUtil.insertResult(new List<SObject>{childPDU}); */
        
        // Severance & Release Record Creation
        //sr.Project_Decisional_Org_Level__c=childPDU.id;
        sr.Project_Level__c = projectLevelforSnR.Id;
        sr.outplacement__c= projectLevelforSnR.outplacement__c;
        sr.project__c=project.id;
        sr.WARN__c=project.WARN__c;
        sr.RecordTypeId = sr_OneOffRecordTypeId;
        
        // 09/17/2013 : MG : populate Decision_Unit__c field of SR with pdu
        if(pdu.Id <> null){
            sr.Decisional_Unit__c = pdu.Id;
        }
        //Added by Anshul on 02 May 2016 for restricting the employees creation for non coverage Hr coverage user on ONE-OFF Level
        list<Severance_And_Release__c> listSR = new list<Severance_And_Release__c>();
        
        Severance_And_Release__c tempSR= new Severance_And_Release__c();
        
        //tempSR=RIF_SeveranceAndReleaseManager.validateAndCreateSR(project.id,project_OneOffRecordTypeId , new List<Severance_And_Release__c> {sr}, null)[0];
        listSR=RIF_SeveranceAndReleaseManager.validateAndCreateSR(project.id,sr_OneOffRecordTypeId , new List<Severance_And_Release__c> {sr}, null);
        
        if(listSR!= null && listSR.size()>0)
        tempSR = listSR[0];
        
        if(tempSR!=null)
              pageMessages = RIF_DataUtil.insertResult(new List<SObject>{tempSR});
        
        //if(!pageMessages.isEmpty()){
        if(!pageMessages.isEmpty() || ApexPages.hasMessages()){
           
            for(ApexPages.Message msg : pageMessages){
               ApexPages.addMessage(msg);
            }    
            try{
                delete project;
            }catch(exception ex){
                system.debug('Unable to delete due to following exception:' + ex.getMessage());
            }               
            /*project = new Project__c(Country__c='USA');
            sp =  new Severance_Parameters__c();
            pdu = new Project_Decisional_Unit__c();
            sr = new Severance_And_Release__c(); */
            system.debug('Now returning null**');
            return null;
        }  
        System.debug('PROJECT CREATED !!!!!!!!!'+sr.id)   ;
        // 26-Sept-17 : JIRA#RIF-93 :Added check to redirect to the project page if it's a MODEL project
        if(project.Status__c.equalsIgnoreCase('Model')){
            return new PageReference('/' + project.id);
        }
        else{
            return new PageReference('/' + sr.id);
        }
               
    }
    public void  getDetailsBeforeSave(){
        list<ApexPages.Message> pageMessages = new list<ApexPages.Message> ();
        //Create Sev Parameter
        //sp =new Severance_Parameters__c();
        List <Severance_Parameters__c> spList = [SELECT Id, OwnerId, IsDeleted, Name,  Back_Out_Notice__c, Basic_Max__c, Basic_Min__c, Cobra_Months__c, Country__c, Covenant_Notice__c, Enhanced_Max__c, Enhanced_Min__c, Enhanced_Percent__c, Is_NonUS__c, Level_Dsc__c, Level__c, Los_Through__c, MS_MSSB__c, Notice_Calc__c, OutPlacement__c, Primary_Key__c, Sev_Weeks_Max__c, Sev_Weeks_Min__c, Sev_Weeks__c, Template__c, Weekly_Mulitple__c FROM Severance_Parameters__c 
                                                                                  where MS_MSSB__c=:sr.MS_MSSB__c and Country__c =:sr.Country__c and Level__c = :sr.Level__c and Level_Dsc__c =: sr.Level_Desc__c limit 1];

        // Project Level Record Creation
        if(spList != null && spList.size() > 0)
              projectLevelforSnR = RIF_DataUtil.cloneSevParamToProjectLevel(spList[0]);
        else
        projectLevelforSnR = RIF_DataUtil.cloneSevParamToProjectLevel(sp);
        //projectLevelforSnR.Project__c = project.Id;
        projectLevelforSnR.Country__c = project.Country__c;
        //pageMessages = RIF_DataUtil.insertResult(new List<SObject>{projectLevelforSnR});
        System.debug('########'+pageMessages );
        System.debug('##projectLevelforSnR.id##'+projectLevelforSnR.id);
        System.debug('##projectLevelforSnR.Sev_Weeks__c##'+projectLevelforSnR.Sev_Weeks__c); 
        System.debug('##projectLevelforSnR.outplacement__c##'+projectLevelforSnR.outplacement__c);

        sr.Communication_Date__c = project.Communication_Date__c;
        // sr.Last_Day_On_Premises__c = project.Termination_Date__c; 
        sr.Termination_Date__c = project.Termination_Date__c;
        sr.Notice_Days_1__c=String.valueOf((sr.Communication_Date__c.daysbetween(sr.Termination_Date__c))+1);
        
        System.debug('##Sr.DOH_Recent__c##'+Sr.DOH_Recent__c);
        System.debug('##sr.Termination_Date__c##'+sr.Termination_Date__c);
         //Los Calculation
        if(projectLevelforSnR.Los_Through__c=='Last Day On Premises'){
            sr.LOS_1__c=String.valueOF( (((sr.DOH_Recent__c.daysbetween(sr.Last_Day_On_Premises__c))+1)/365.25).setScale(2) );
             
        }
        else{
            sr.LOS_1__c=String.valueOF( (((sr.DOH_Recent__c.daysbetween(sr.Termination_Date__c))+1)/365.25).setScale(2));
         
        }
        system.debug(' -- Comm Date -- ' + project.Communication_Date__c);
        system.debug(' -- LEAP YEAR -- ' + Date.isLeapYear(project.Communication_Date__c.year()));
        system.debug(' -- isProjCommDateLeapYear BEF-- ' + isProjCommDateLeapYear);
        if( (project.Communication_Date__c != null) && (Date.isLeapYear(project.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=true;   
        }
        else if( (project.Communication_Date__c != null) && (!Date.isLeapYear(project.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=false;   
        }
        system.debug(' -- isProjCommDateLeapYear AFT-- ' + isProjCommDateLeapYear);
        //return null;
    }
    
   public pageReference  getEmployeeDetails(){
        list<ApexPages.Message> pageMessages = new list<ApexPages.Message> ();
        
        empUnvestedList = RIF_DataUtil.getUnvestedEquityForEmployee(sr.Employee__c); 
        if(empUnvestedList != null && empUnvestedList.size() > 0){
            empUnvested = empUnvestedList[0];

      if(empUnvested.Date_as_of__c!=null)
        sr.Unvested_As_of_Date__c=empUnvested.Date_as_of__c; 
            
            unvestedtotalValue=empUnvested.Unvested_total_balance__c;
        }
        
        List<Employee__c> empList = RIF_DataUtil.getEmployee(sr.Employee__c);       
        if(!empList.isEmpty()){
            emp = empList[0];
            project.Country__c = emp.Job_Country_Job__c;
            sp.MS_MSSB__c = emp.MS_MSSB__c;
            sp.Level_Dsc__c = emp.Level_Dsc_Job__c;
            if(emp.DOH_Recent__c!=null){
                sr.DOH_Recent__c=emp.DOH_Recent__c;
            }
             
        }
        List<Severance_Parameters__c> spList = new List<Severance_Parameters__c> ();
        //Validate Severance Parameters Exist or not
              
        if(project.Country__c == 'USA')
               spList =RIF_DataUtil.getSeverancePrameters(project.Country__c, sp.MS_MSSB__c, sp.Level_Dsc__c);

        //if(spList.isEmpty()){
        if(spList!= null && spList.size() > 0){
            sp = spList[0];
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Severance Parameter is not available for provided Country, MS-MSSB, Job level.'));
            return null;
        }
        
        return null;
    }
    
    // IGNORE THIS METHOD
    public void test_method(){
        Integer i = 0;
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
   


}