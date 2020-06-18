public with sharing class MCA_SecurityManagementProfileController {
    
    public string employeeId {get; set;}    
    public Employee__c employee {get; set;}
    public string activeTab{get; set;}
    public string  errorResult {get;set;}    
    public string selectedTab {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    public exception exp{get; set;} 
    public boolean isActive {get; set;}
    public boolean hideCardholderTabContent {get; set;}
    public boolean hideCardTabContent {get; set;}
    public boolean hideCardSwipeTabContent {get; set;}
    public boolean hideTransactionTabContent {get; set;}
    public boolean hideDisableCardTabContent {get; set;}
    public boolean hideTempCardTabContent {get; set;}
    public boolean hideClearancesTabContent {get; set;}
    public boolean initializeComponent{get{ init();return true;}set;}

    public MCA_SecurityManagementProfileController () {
    	
    }
    
    public void init(){
        errorResult='';    
        isActive=false;
        
        try{
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;        
            OrgName=Label.ORG_ENVIRONMENT; 
            
            //Set employee record details
            if(employeeId != null) {
            	employee = [SELECT ID, Name, Status__c, Empl_Type_Dsc_Job__c, Business_Title__c, Login_Id_Directory__c, Work_Phone__c, Emp_ID__c, 
            		Phone_Number_Home__c, Cost_Center__c, Building_Directory__c, Floor_Directory__c, Subdept_Dsc_Org__c, Building_Address_1_Directory__c,
            		Super_Depart_Dsc_Org__c, Building_City_Directory__c, Building_State_Directory__c, Email__c FROM Employee__c WHERE Id = :employeeId];
            }
            
            hideCardholderTabContent=false;
            hideCardTabContent=true; 
            hideCardSwipeTabContent=true;
            hideTransactionTabContent=true; 
            hideDisableCardTabContent=true;
            hideTempCardTabContent =true;
            hideClearancesTabContent =true;
            activeTab='cardholderTab';
        }
        Catch(Exception e){
            system.debug('****Exception inside MCA SecurityManagementProfile page constructor'+e.getlinenumber()+'-'+e.getmessage());
            exp=e;   
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.WV_Exception_Admin);
            ApexPages.addMessage(myMsg);
        }
    }

   public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Card Access','Security Management Profile page-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }
}