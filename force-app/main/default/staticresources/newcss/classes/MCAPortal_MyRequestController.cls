public class MCAPortal_MyRequestController {
public string OrgName {get; set;}
    public User LoggedInUser {get;set;}
    public Employee__c LoggedinEmployee {get;set;}
    public string OrgName_Display {get; set;}
    public string PageURL {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string customPageMessage {get; set;}
    public string typeOfMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
	public list<MCARequest__c> requestList {get;set;}
    public String selectedTab{get;set;}
    public String strDisplayCategory {get; set;}
    public String TotalRequests { get; set; }
    public boolean viewReq{get;set;} 
    public boolean isAdmin{get;set;} 
    public MCAPortal_MyRequestController(){        
        try{
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            PageURL = ApexPages.currentPage().getUrl().toLowerCase(); 
            currentPageURL = urlString+PageURL;
            OrgName_Display=Label.ORG_ENVIRONMENT;
            OrgName=Label.ORG_ENVIRONMENT.tolowercase(); 
            strDisplayCategory = 'All';
            TotalRequests = '0';
            viewReq = false;
            LoggedInUser = PP_Util.getLoggedinUserRecord();
            if(LoggedInUser == NULL) {
                return;
            }
            LoggedinEmployee  = PP_Util.getLoggedinEmployeeDetailsbyEmpID(LoggedInUser.Emp_Id__c);
            if(LoggedinEmployee == NULL) {
                system.debug('**************NO EMPLOYEE FOUND WITH EMPID:'+LoggedInUser.Emp_Id__c);
                return;
            }
            else
            {
                //selectedTab='RequestHome';
                //selectedTab = ApexPages.Currentpage().getParameters().get('tab');
                requestList =[Select ID, Name, Employee_Requestee_Name__r.name, Createddate, Status__c, 
                              Additional_access_timing__c, Clearances_to_be_added__c, Start_Date__c, End_Date__c from 
                              MCARequest__c where Employee_Requestee_Name__c=:LoggedinEmployee.ID  order by createddate desc];
                if(requestList != null && !requestList.isEmpty()){
                    TotalRequests = string.valueOf(requestList.size()); 
                    
                }
            }
            isAdmin =MCAPortal_Util.checkIfAdmin();  
        }
        catch(Exception e){
            system.debug('*****Exception in constructor of Home page BCPPortal_HomepageController()'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';    
        }
    }
    
    public pagereference AdminConsoleRedirect(){
        PageReference pr = new PageReference('/home/home.jsp');
        pr.setRedirect(true);
        return pr;
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
    public pagereference NewRequest(){
        PageReference pr = new PageReference('/apex/MCAPortal_NewAreaRequest?tab=NewRequest');
        pr.setRedirect(true);
        return pr;
    }
    
}