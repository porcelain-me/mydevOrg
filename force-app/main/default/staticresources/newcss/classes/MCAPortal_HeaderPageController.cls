public class MCAPortal_HeaderPageController{
    
    public User LoggedInUser {get;set;}
    public Employee__c LoggedinEmployee {get;set;}
    public string OrgName {get; set;}
    public string OrgName_Display {get; set;}
    public boolean noProxyAllowed {get; set;}
    public string proxyUserId {get; set;}
    public List<permissionsetAssignment> adminUsersList {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;}     
    public string firstname {get; set;}
    public string lastname{get; set;}
    public boolean isPreviewpage {get; set;}    
    public string PageURL {get; set;}
    public boolean isHomepage {get; set;}
    
    public MCAPortal_HeaderPageController(){        
        try{
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            PageURL = ApexPages.currentPage().getUrl().toLowerCase(); 
            currentPageURL = urlString+PageURL;
            exp=null;  
            firstname='';          
            lastname='';
            isPreviewpage=false;
            OrgName_Display=Label.ORG_ENVIRONMENT;
            OrgName=Label.ORG_ENVIRONMENT.tolowercase(); 

            LoggedInUser = WV_Utility.getLoggedinUserDetails(UserInfo.getUserId());                           
            
            LoggedinEmployee = WV_Utility.getLoggedinEmployeeDetails(LoggedInUser.Emp_Id__c);
            if(LoggedInUser != null){
                firstname=LoggedInUser.firstname;
                lastname=LoggedInUser.lastname;
            }            
        }
        Catch(Exception e){
           system.debug('****Exception inside Header page Constructor'+e.getlinenumber()+'-'+e.getmessage()); 
           exp=e;
        }
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
               WV_Utility.captureException('My Card Access','Employee facing UI Header page','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('********************Exception inside sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }
}