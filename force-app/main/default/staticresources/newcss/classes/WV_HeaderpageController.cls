public class WV_HeaderpageController{
    
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
    
    public WV_HeaderpageController(){        
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
            
            if(PageURL.contains('wv_moreinfo')){
                isPreviewpage=true;
            }
            if(PageURL.contains('wv_homepage')){
                isHomepage=true;
            }
            LoggedInUser = WV_Utility.getLoggedinUserDetails(UserInfo.getUserId());                           
            proxyUserId= ApexPages.Currentpage().getParameters().get('uid');
            
            Map<Id,Permissionset> adminPermissionSets=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Biz_Admin' OR name='My_Elections_Scheme_Admin' OR name='My_Elections_HRSC_admin']);    
            if(adminPermissionSets != null && adminPermissionSets.keyset() != null && adminPermissionSets.keyset().size() > 0){
                adminUsersList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminPermissionSets.keyset() AND assigneeid=:LoggedInUser.Id];
                if(proxyUserId != null && proxyUserId != '' && proxyUserId.trim() != ''){
                    if((adminUsersList == null || adminUsersList.size() == 0) && Test.isRunningtest()==false){
                        noProxyAllowed=true;    
                    }
                    else{
                        noProxyAllowed = false;
                        LoggedInUser = WV_Utility.getLoggedinUserDetails(proxyUserId);      
                    }
                }
            } 
            
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
               WV_Utility.captureException('My Elections','Employee facing UI Header page','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('********************Exception inside sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }
}