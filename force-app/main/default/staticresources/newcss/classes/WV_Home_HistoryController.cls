public class WV_Home_HistoryController{

    public User LoggedInUser {get;set;}
    public Employee__c LoggedinEmployee {get;set;}
    public boolean noElectionFlag {get; set;}
    public boolean noActiveSchemes {get; set;}
    public WV_ElectionsHistoryWrapper history {get; set;}
    public List<WV_multiListWrapper> multiList {get; set;} 
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    
    public WV_Home_HistoryController(){        
        try{            
            Map<Id,List<Response__c>> ElectionResponses;
            Map<Id,Scheme__c> EmployeeElectionSchemes;   
            noElectionFlag=false;
            noActiveSchemes=false;                        
            List<Election__c> employeeElection;
            Map<Id,Map<String,String>> electionStatusMap;
            set<string> tempSchemeSet;
            set<string> tempElectionSet;
            multiList=new List<WV_multiListWrapper>();   
            string electionId=ApexPages.Currentpage().getParameters().get('eid');  
            string userId=ApexPages.Currentpage().getParameters().get('uid');   
            history=new WV_ElectionsHistoryWrapper();
            history.enddate=null;            
            customPageMessage =null;
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null;         
            OrgName=Label.ORG_ENVIRONMENT;               

            if(userId != null && userId != '' && userId.trim() != ''){
                LoggedInUser = WV_Utility.getLoggedinUserDetails(userId);
            }
            
            if(LoggedInUser !=null){
                LoggedinEmployee = WV_Utility.getLoggedinEmployeeDetails(LoggedInUser.Emp_Id__c);
            }
            
            if(electionId != null && LoggedinEmployee != null){
                employeeElection = WV_Utility.getElectionDetails(electionId);                
                if(employeeElection != null && employeeElection.size() > 0){
                    tempSchemeSet=new set<string>{employeeElection[0].scheme__c};
                    tempElectionSet=new set<string>{employeeElection[0].Id};   
                    if(tempSchemeSet != null && tempSchemeSet.size() >0){                
                        EmployeeElectionSchemes= WV_Utility.getSchemeDetails(tempSchemeSet);
                    }
                    if(tempElectionSet != null && tempElectionSet.size() >0){     
                        ElectionResponses= WV_Utility.getAllResponseDetails(tempElectionSet);
                    }
                }
            }      
            if(employeeElection  != null && employeeElection.size() > 0){                
                Election__c q=employeeElection[0];
                history.ElectionId=q.id;
                history.CreatedDate=q.CreatedDate.format();
                history.LastModifiedDateDt=q.LastModifiedDate;
                history.LastModifiedDate=q.LastModifiedDate.format();
                history.EmployeeId=q.Employee__c;
                history.SchemeId=q.Scheme__c;
                history.SchemeName=q.Scheme__r.Name;
                history.SourceId=q.Scheme__r.Source__c;
                history.SourceName=q.Scheme__r.Source__r.Name;
                history.SourceOrder=q.Scheme__r.Source__r.Source_Order__c;
                history.DeferralId=q.Scheme__r.Deferral__c;
                history.DeferralName=q.Scheme__r.Deferral__r.name;
                history.TemplateId=q.Scheme__r.Waiver_Template__c;
                history.TemplateName=q.Scheme__r.Waiver_Template__r.Name;
                history.schemeCurrency=q.Scheme__r.Scheme_Currency__c;
                history.schemeCurrency_Code=q.Scheme__r.Scheme_Currency__r.Value__c;
                history.Election=q;
                if(history.Election.Related_Enrolment__r.End_Date__c != null){
                    history.enddate=history.Election.Related_Enrolment__r.End_Date__c.format();
                }
                if(ElectionResponses != null && ElectionResponses.containsKey(q.Id)){ 
                    history.Responses=ElectionResponses.get(q.Id);    
                }    
            }         
           
        }
        catch(Exception e){
            customPageMessage=PAGE_ERROR;
            system.debug('****Exception in constructor of WV_Home_History page'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;        
        }
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Election History detail page-->Constructor()','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside WV_Home_HistoryController-->sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    } 
   
}