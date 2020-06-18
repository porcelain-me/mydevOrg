// 
// 06/26/2013 RJ: Created; Controller class for RIF_CreateSRFromProjectLevel.page
//

public class RIF_CreateSRFromProjectLevel { 
    public Severance_And_Release__c sr{get;set;}
    public String retURL{get;set;}
    private static final string SOBJECT_NAME = 'Severance_And_Release__c'; 
    private string recordTypeId{get;set;}
    private string recordTypeName{get;set;} 
    private string projectLevelId{get;set;}
    private string projectId{get;set;}
    public project__c project{get;set;}
    public boolean isProjCommDateLeapYear{get;set;}
    public Project_Level__c projectLevelforSnR{get;set;}
    private List<Project_Level__c> lstPLevelforSnR {get;set;}
    public string termDt{get;set;}
    public string commntDt {get;set;}
    public string lastDayDt {get;set;}
	public Unvested_Equity__c empUnvested{get;set;}
	private List<Unvested_Equity__c> empUnvestedList{get;set;}
	public string unvestedtotalValue{get;set;}
	//public string unvestedDateAsOf{get;set;}
    public  Employee__c emp{get;set;}
    public boolean isRunningFromProjectLevel{get;set;} 
    public Boolean disableButton {get;set;}
    
    public RIF_CreateSRFromProjectLevel(){
        sr = new Severance_And_Release__c();
        retURL = '';
        recordTypeId = '';
        recordTypeName = '';
        projectLevelId = '';
        projectId = '';
        disableButton = false;
        //6-Mar-2017 : Added new variable to check Leap Year 
        isProjCommDateLeapYear = false;
    }
   
    public pagereference pageAction(){
        project= new project__c ();
        List<Project_Level__c> lstPLevelforSnR = new List<Project_Level__c>();
        //recordTypeName =  ApexPages.currentPage().getParameters().get('
        //
        //');
        retURL = EncodingUtil.urlEncode(ApexPages.currentPage().getParameters().get('retURL'), 'UTF-8');     
        projectId = ApexPages.currentPage().getParameters().get('pid');
        project=RIF_DataUtil.getProject(projectId)[0];
        if( (project.Communication_Date__c != null) && (Date.isLeapYear(project.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=true;   
        }
        else if( (project.Communication_Date__c != null) && (!Date.isLeapYear(project.Communication_Date__c.year()))  ){
                isProjCommDateLeapYear=false;   
        }

        calculateFormulaValuesOnSR();   
        recordTypeName='Project Based Termination'; 
        if(recordTypeName <> NULL){  
            List<RecordType> lstRT = RIF_DataUtil.getRecordTypeForName(recordTypeName);
            for(RecordType rt : lstRT){            
                if(rt.SobjectType == SOBJECT_NAME){
                    recordTypeId = rt.Id;
                }
            }
        }
        sr.RecordTypeId = recordTypeId;
        
        return null;
    }


    public void calculateFormulaValuesOnSR(){
         sr.Communication_Date__c = project.Communication_Date__c;
         sr.Last_Day_On_Premises__c = project.Communication_Date__c;
         sr.Termination_Date__c = project.Termination_Date__c;
    }
   
    
    public pageReference create(){    
        	
        
        List<Severance_And_Release__c> listSR = new  List<Severance_And_Release__c>(RIF_SeveranceAndReleaseManager.validateAndCreateSR(projectId,recordTypeId, new List<Severance_And_Release__c>{sr},null));
        //System.debug('listSR returned from RIF_SeveranceAndReleaseManager.validateAndCreateSR() project:'+listSR[0].project__c+'project pl:'+listSR[0].Project_Level__c);
        List<ApexPages.Message> pageMessages= new List<ApexPages.Message>();
        if(listSR!=null && listSR.size()>0)
        	pageMessages = RIF_DataUtil.insertResult(listSR);
         
        if(!pageMessages.isEmpty()){
           for(ApexPages.Message msg : pageMessages){
               ApexPages.addMessage(msg);
            }
            disableButton = false;
            return null;
        }       

        if(!listSR.isEmpty() ){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Employee added successfully.You can either close the window or continue adding employees!'));
            sr = new Severance_And_Release__c();
            disableButton = false;
            return null;
        }
        disableButton = false;
        return null;
    }
   

    public pageReference cancel(){
      return new PageReference(retURL);    
    }
   
    public void getEmployeeDetails(){
        disableButton = true;
        map<Id,Employee__c> empMap = RIF_DataUtil.getEmployeeList(new set<string>{sr.Employee__c}); 
        if(!empMap.isEmpty()){
            emp = empMap.get(sr.Employee__c); 
            sr.Emp_Id__c=emp.Emp_Id__c; 
        }
		
		empUnvestedList = RIF_DataUtil.getUnvestedEquityForEmployee(sr.Employee__c); 
		if(empUnvestedList != null && empUnvestedList.size() > 0){
			empUnvested = empUnvestedList[0];
			if(empUnvested.Date_as_of__c!=null)
				sr.Unvested_As_of_Date__c=empUnvested.Date_as_of__c; 
			//copy unvested values to variable
		    unvestedtotalValue=empUnvested.Unvested_total_balance__c;
		}
		 
        lstPLevelforSnR=RIF_DataUtil.getProjectLevels(projectId,emp.Job_Country_Job__c,emp.Level_Dsc_Job__c,emp.MS_MSSB__c);
        System.debug('###lstPLevelforSnR###'+lstPLevelforSnR );
        if(lstPLevelforSnR != null && lstPLevelforSnR.size() > 0){
            projectLevelforSnR = lstPLevelforSnR[0]; 
             //Calling calculateFormulaValuesOnSR() is required, as next time when user tries to add employee from the same screen, the project parameters are getting blank
             calculateFormulaValuesOnSR();
             calculateLos();
        }
        
    }
    

    public void calculateLos(){
        //copying employee DOH date into S&R
        if(emp.DOH_Recent__c!=null){
            sr.DOH_Recent__c=emp.DOH_Recent__c;
            String plLOSThrough=projectLevelforSnR.Los_Through__c;
            System.debug('r.DOH_Recent__c-' + sr.DOH_Recent__c);
            System.debug('sr.Termination_Date__c-' + sr.Termination_Date__c);
            if(plLOSThrough=='Last Day On Premises'){
                sr.LOS_1__c=String.valueOF( (((sr.DOH_Recent__c.daysbetween(sr.Last_Day_On_Premises__c))+1)/365.25).setScale(2) );
            }
            else{
                sr.LOS_1__c=String.valueOF( (((sr.DOH_Recent__c.daysbetween(sr.Termination_Date__c))+1)/365.25).setScale(2));
            }
        }
        
        //Notice Days 
       sr.Notice_Days_1__c=String.valueOf((sr.Communication_Date__c.daysbetween(sr.Termination_Date__c))+1); 
    }
    
}