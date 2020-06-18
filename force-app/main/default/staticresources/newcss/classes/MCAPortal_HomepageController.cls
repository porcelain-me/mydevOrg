public class MCAPortal_HomepageController {

    public string OrgName {get; set;}
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
    public MCAPortal_HomepageController(){        
        try{
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            PageURL = ApexPages.currentPage().getUrl().toLowerCase(); 
            currentPageURL = urlString+PageURL;
            OrgName_Display=Label.ORG_ENVIRONMENT;
            OrgName=Label.ORG_ENVIRONMENT.tolowercase(); 
            strDisplayCategory = 'All';
            TotalRequests = '0';
            viewReq = false;
            //selectedTab='RequestHome';
            //selectedTab = ApexPages.Currentpage().getParameters().get('tab');
            requestList =[Select ID, Name, Employee_Requestee_Name__r.name, Createddate, Status__c, 
                          Additional_access_timing__c from 
                          MCARequest__c where Status__c='Submitted' order by createddate desc];
            if(requestList != null && !requestList.isEmpty()){
                TotalRequests = string.valueOf(requestList.size()); 
            }
            isAdmin=MCAPortal_Util.checkIfAdmin();
        }
        catch(Exception e){
            system.debug('*****Exception in constructor of Home page BCPPortal_HomepageController()'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';    
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
    public pagereference NewRequest(){
        PageReference pr = new PageReference('/apex/MCAPortal_NewAreaRequest?tab=NewRequest');
        pr.setRedirect(true);
        return pr;
    }

    public pagereference AdminConsoleRedirect(){
        PageReference pr = new PageReference('/');
        pr.setRedirect(true);
        return pr;
    }
}