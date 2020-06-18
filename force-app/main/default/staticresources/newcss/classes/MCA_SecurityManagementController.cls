public with sharing class MCA_SecurityManagementController {
    
    public string selectedEmployeeId {get; set;}
    public Employee__c employee {get; set;}
    public String employeeSearchString{get;set;}
    public string activeTab {get; set;}
    public string errorMessage {get;set;}
    public Boolean displayErrorMessage {get;set;}
    public string selectedTab {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    public exception exp {get; set;} 
    public Boolean isSearch {get; set;}
    public list<Employee__C> EmployeeList{get;set;}
    public boolean displayEmployeeProfile{
      get{        
        if(isSearch || selectedEmployeeId == null){
          return false;
        }else{
          return true;
        }
      }
    }

    public MCA_SecurityManagementController () {
        
        errorMessage='';
        isSearch = false;
        try{
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;        
            OrgName=Label.ORG_ENVIRONMENT; 
            
            //Set employee record details
            selectedEmployeeId = ApexPages.Currentpage().getParameters().get('id');
            if(selectedEmployeeId != null) {
            	employee = [SELECT ID, Name FROM Employee__c WHERE Id = :selectedEmployeeId];
            }
        }
        Catch(Exception e){
            system.debug('****Exception inside MCA SecurityManagement page construtor'+e.getlinenumber()+'-'+e.getmessage());
            exp=e;   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_Exception_Admin);
            ApexPages.addMessage(myMsg);
        }
    }
    
    public pagereference searchEmployee(){
    	isSearch = true;
        if((employee!=null || employeeSearchString!='') && (employeeSearchString!=null && employeeSearchString.length()<=2) ){
           displayErrorMessage=true;
           errorMessage='Please enter a minimum of 3 characters.';
        }
        else if((employeeSearchString==null || employeeSearchString=='') ){
            displayErrorMessage=true;
            errorMessage='Please enter a minimum of 3 characters.';
        }
        else {
            EmployeeList=null;
            displayErrorMessage = false;
            errorMessage=null;
            String Query='select id,emp_id__c,Officer__c,Division_Dsc_Org__c,CC_City_Dsc_Org__c,Floor_Directory__c, name,First_Name__c, Last_Name__c,Dept_Dsc_Org__c,Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where'; 
	        if(employeeSearchString!=null || employeeSearchString!=''){        
	            if(employeeSearchString.length()<=2){
	                displayErrorMessage=true;
	                errorMessage='Please enter a minimum of 3 characters.';
	            }else{
	             Query+=' (name like \'%'+employeeSearchString+'%\' OR emp_id__c=\''+employeeSearchString+'\') and status__c=\'Active\'';
	            }
	        }
	        
	        if(Query.endsWith('where')){
	            Query=Query.removeEnd('where');
	            EmployeeList=null;
	        }
	        else{
	            Query+='  order by name asc ';
	            EmployeeList=(List<Employee__C>)Database.Query(Query);
	            if(EmployeeList.size() > 20){
	                    errorMessage='Too many search results found. Please narrow your search criteria and try again.';
	                    displayErrorMessage = true;
	                    EmployeeList=null;
	                    return null;
	            }
	            else {
	            	isSearch = true;
	            }
	        }
    	}
        return null;
    }
    
    public PageReference selectedEmployee(){
        if(selectedEmployeeId != null) {
        	employee = [SELECT ID, Name FROM Employee__c WHERE Id = :selectedEmployeeId];
        }
        isSearch=false;
        return null;
    }

   public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Card Access','Security Management page-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }
}