public without sharing class RIF_UpdateSeveranceAndRelease {
    //getter-setters
    public string disableStatusField{get;set;}
    public Severance_And_Release__c srRecord {get;set;} 
    private string projectId{get;set;}
    private project__c project{get;set;}
    public boolean isProjCommDateLeapYear{get;set;}
    public Project_Level__c projectLevelforSnR{get;set;}
    private List<Project_Level__c> lstPLevelforSnR {get;set;}
    public  Employee__c emp{get; set;}
    public String CommDt{get; set;}
    /***********Start Code by Sudarshan K. on 02/07/2016*************************/
    public boolean isReadOnlyAccess { get; set; }
    public boolean isEditOnlyAccess { get; set; }
    /**************************End Code*************************************************/
    public boolean renderRelRetIn{get;set;}     //MSN:RIF#139
    public RIF_UpdateSeveranceAndRelease (ApexPages.StandardController std){
         disableStatusField='false';
		 renderRelRetIn=false;        //MSN:RIF#139    
         /*****************Start Code by Sudarshan K. on 02/07/2016*************************/
         isReadOnlyAccess = false;
         isEditOnlyAccess = false;
         List<UserRecordAccess> lstRecordAccess = [SELECT RecordId, HasReadAccess, HasEditAccess, MaxAccessLevel FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: std.getId()];
         if(!lstRecordAccess.isEmpty()){
             isReadOnlyAccess = lstRecordAccess[0].HasReadAccess;
             isEditOnlyAccess =  lstRecordAccess[0].HasEditAccess;
         }
         /***********************End code***************************************/
        
        String recordTypeID=ApexPages.currentPage().getParameters().get('RecordType'); //RecordType
        //System.debug('@@@@@@@'+recordTypeID);
        srRecord = RIF_DataUtil.getSeveranceAndReleaseRecord(std.getId());
        system.debug('##########srRecord###########'+srRecord);
        system.debug('##########srRecord cOMMUNICATION dATE###########'+srRecord.Communication_Date__c);
        system.debug('##########srRecord TERMINATION DATE###########'+srRecord.Termination_Date__c);
        if(recordTypeID!=null && recordTypeID!='')
            srRecord.RecordTypeID=recordTypeID;
        
        try{
            //MSN:RIF#139  - Starts
            List<permissionsetAssignment> perSetAssList  = [select id,assigneeid, Assignee.name,permissionsetid, permissionset.name  from permissionsetAssignment where permissionset.name in ('RIF_HR_Operations','RIF_System_Admin') and assigneeid = :UserInfo.getUserID()];
            if(perSetAssList!=null && !perSetAssList.isEmpty())
            {
                renderRelRetIn = true;
            }
            //MSN:RIF#139   - Ends
            Map<Id,Permissionset> opsPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Operations']);
            permissionsetAssignment currentOpsUser=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:opsPermissionMap.keyset() AND assigneeid=:UserInfo.getUserID()];
            if(currentOpsUser!=null)
                disableStatusField='true';
        }
        catch(Exception e){
            System.debug(e);
        }
        
        
        
        project=RIF_DataUtil.getProject(srRecord.Project__c)[0];
        if( (project.Communication_Date__c != null) && (Date.isLeapYear(project.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=true;   
        }
        else if( (project.Communication_Date__c != null) && (!Date.isLeapYear(project.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=false;   
        }
        map<Id,Employee__c> empMap = RIF_DataUtil.getEmployeeList(new set<string>{srRecord.Employee__c});
        if(!empMap.isEmpty()){
            emp = empMap.get(srRecord.Employee__c); 
        }
        
        lstPLevelforSnR=RIF_DataUtil.getProjectLevels(srRecord.Project__c,emp.Job_Country_Job__c,emp.Level_Dsc_Job__c,emp.MS_MSSB__c);
        if(lstPLevelforSnR != null && lstPLevelforSnR.size() > 0){
            projectLevelforSnR = lstPLevelforSnR[0]; 
        }
    }
    
    public void getDetailsForFormulas(){
        // 5-Dec-2016 : Check to supress calculations on current SNR if the Status picklist is disabled
        if(!srRecord.Disable_Status_picklist__c){
            system.debug('##########srRecord###########'+srRecord);
            system.debug('##########srRecord cOMMUNICATION dATE###########'+srRecord.Communication_Date__c);
            system.debug('##########srRecord TERMINATION DATE###########'+srRecord.Termination_Date__c);
            if( (srRecord.Communication_Date__c != null) && (Date.isLeapYear(srRecord.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=true;   
            }
            else if( (srRecord.Communication_Date__c != null) && (!Date.isLeapYear(srRecord.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=false;   
            }
            //copying employee DOH date into S&R
            // 3-Mar-17 : Check to avoid error when SNR does not have SNR Project Level
            if(emp!= null && emp.DOH_Recent__c!=null && projectLevelforSnR != null){
                //srRecord.DOH_Recent__c=emp.DOH_Recent__c;
                String plLOSThrough=projectLevelforSnR.Los_Through__c;
                if(plLOSThrough=='Last Day On Premises'){
                    srRecord.LOS_1__c=String.valueOF( (((srRecord.DOH_Recent__c.daysbetween(srRecord.Last_Day_On_Premises__c))+1)/365.25).setScale(2) );
                }
                else{
                    srRecord.LOS_1__c=String.valueOF( (((srRecord.DOH_Recent__c.daysbetween(srRecord.Termination_Date__c))+1)/365.25).setScale(2));
                }
            }
            //Notice Days 
            srRecord.Notice_Days_1__c=String.valueOf((srRecord.Communication_Date__c.daysbetween(srRecord.Termination_Date__c))+1);  
            //System.debug('**************************emp:'+emp);
            //System.debug('**************************srRecord.Notice_Days_1__c:'+srRecord.Notice_Days_1__c);
            CommDt = srRecord.Notice_Days_1__c;
        }
    } 
    
    public PageReference save(){
        if(srRecord != null && srRecord.Communicated__c==false){
            //srRecord.Communicated__c=false;
            srRecord.Communicated_Date__c=null;
            // 3-Jan-17 : Replacing Communicated_Details_of_Package__c with Severance_Package_Communicated__c
            //srRecord.Communicated_Details_of_Package__c=false;
            srRecord.Severance_Package_Communicated__c = false;
            srRecord.Package_Receipt_Date__c=null;
            srRecord.Release_Returned__c=false;
            srRecord.Release_Returned_Date__c=null;
            //srRecord.Work_Requirement_for_Severance__c=false;
            //srRecord.Is_termination_related_to_Project__c=false;            
        }
        // 23-Jan-2017 : Defect#1876 : Enforce 'Last Premise Date' validation on each save
        if(srRecord.Last_Day_On_Premises__c > srRecord.Termination_Date__c){ 
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.RIF_LastDayGreaterThanTerminationDate));
            return null;   
        }
        // 15-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override -- STARTS
        if(srRecord != null && srRecord.HR_Contact_lkp__c != null && !validHREmp(String.valueOf(srRecord.HR_Contact_lkp__c))){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'HR Contact - Override : Employee inactive or not a member of Dept-81200'));
            return null;              
        }        
        if(srRecord != null && srRecord.HR_Signatory_lkp__c != null && !validHREmp(String.valueOf(srRecord.HR_Signatory_lkp__c))){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'HR Signatory - Override : Employee inactive or not a member of Dept-81200'));
            return null;              
        }
        // 15-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override -- ENDS
        // 3-Jan-17 : Replacing Communicated_Details_of_Package__c with Severance_Package_Communicated__c
        //if(srRecord != null && srRecord.Communicated__c ==true && (srRecord.Communicated_Date__c == null || srRecord.Communicated_Details_of_Package__c == false || srRecord.Package_Receipt_Date__c == null) ){
        if(srRecord != null && srRecord.Communicated__c ==true && (srRecord.Communicated_Date__c == null || srRecord.Severance_Package_Communicated__c == false || srRecord.Package_Receipt_Date__c == null) ){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All four communication fields - Communicated, Communicated Date, Communicated Details of Package, Package Receipt Date needs to be filled before proceeding'));
            return null;              
        } 
        list<ApexPages.Message> pageMessage = RIF_DataUtil.upsertResult(new list<Severance_And_Release__c>{srRecord});
        system.debug('errormsg: '+pageMessage);
        if(!pageMessage.isEmpty()){
            ApexPages.getMessages().clear();
            for(ApexPages.Message msg : pageMessage){
                ApexPages.addMessage(msg);
            } 
           return null;
        }
        return new PageReference('/'+srRecord.Id);
    }
    // 15-Sep-2016 : Defect#1792 : Changes related to HR Contact/HR Signatory override
    // method check if the provided HR emp id ACTIVE in the system and member of 81200 CC
    public Boolean validHREmp(Id hrID){
        Boolean isValidHR = false;
        List<Employee__c> empRes = RIF_DataUtil.getEmployee(String.valueOf(hrID));
        if(!empRes.isEmpty()){
            isValidHR = RIF_DataUtil.isValidHREmp(empRes[0].Emp_ID__c);
        }
        return isValidHR;
    }
    
}