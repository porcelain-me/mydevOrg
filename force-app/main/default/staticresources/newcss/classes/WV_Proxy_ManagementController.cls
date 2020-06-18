public class WV_Proxy_ManagementController {

    public string searchText {get; set;}
    public List<employee__c> searchedActiveEmployeesList {get; set;}
    public List<user> searchedUsersFinalList {get; set;}
    public set<Id> adminUsers;
    public string error {get; set;}
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    public exception exp{get; set;} 
   
    public WV_Proxy_ManagementController (){
       
        try{
            customPageMessage =null;
            typeOfMessage=null;
            exp=null;
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;
            OrgName=Label.ORG_ENVIRONMENT;   
            searchedActiveEmployeesList=new   List<employee__c> ();         
        } 
        Catch(Exception e){
            system.debug('****Exception inside WV_Proxy_ManagementController constructor'+e.getlinenumber()+'-'+e.getmessage());
            exp=e;
            customPageMessage=PAGE_ERROR;
        }
   }
   
   public PageReference search(){
        adminUsers=new set<Id>();
        searchedUsersFinalList =new List<User>();
        error=null;
        customPageMessage =null;
        
        try{
            if(searchText == null || searchText.trim() =='' ){
                error=Label.WV_Proxy_NoKeywordFound;
                if(searchedActiveEmployeesList != null){
                   searchedActiveEmployeesList.clear();
                }
                return null;
            }
            //Limiting no of records to 1000 as per limit in salesfroce in VF page repeat component..,
            searchedActiveEmployeesList =[select id,name,User__c,Emp_ID__c,Inactive__c,User__r.name,User__r.username,User__r.email,User__r.profileId,User__r.profile.name,User__r.Isactive,Status__c from Employee__c where Status__c = 'Active' AND user__r.profile.name='All MS Employee' AND user__c !=:userinfo.getuserId() AND (name like:'%'+searchText+'%' OR User__r.name like:'%'+searchText+'%' OR user__r.username like:'%'+searchText+'%' OR user__r.email like:searchText+'%' OR emp_ID__c=:searchText) Limit 1000];
            if(searchedActiveEmployeesList ==null || (searchedActiveEmployeesList != null && searchedActiveEmployeesList.size()==0)){
                error=Label.WV_Proxy_NoEmpFound;
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside search()'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Proxy management page','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
        } 
        return null;
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Proxy Access Tab-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }  
}