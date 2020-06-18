public class WV_ElectionsHistoryController {
    
    public User LoggedInUser {get;set;}
    public Employee__c LoggedinEmployee {get;set;}
    public transient List<WV_ElectionsHistoryWrapper> ElectionsHistoryWrapperList{get; set;}
    public boolean noElectionFlag {get; set;}
    public boolean noProxyAllowed {get; set;}
    public boolean noAccessAllowed {get; set;}
    public string proxyUserId {get; set;}    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    
    public WV_ElectionsHistoryController (){
    
        try{
            set<string> SchemeList=new set<String>();
            set<string> ElectionSet=new set<String>();
            ElectionsHistoryWrapperList=new List<WV_ElectionsHistoryWrapper>();
            List<Election__c> EmployeeElections;
            Map<Id,List<Response__c>> ElectionResponses;
            Map<Id,Scheme__c> EmployeeElectionSchemes;
            noElectionFlag=false;
            noProxyAllowed =false;
            noAccessAllowed = false;
            
            customPageMessage =null;
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null;         
            OrgName=Label.ORG_ENVIRONMENT; 
            
            LoggedInUser = WV_Utility.getLoggedinUserDetails(UserInfo.getUserId());
             
            proxyUserId= ApexPages.Currentpage().getParameters().get('uid');
            if(proxyUserId != null && proxyUserId != '' && proxyUserId.trim() != ''){
                Map<Id,Permissionset> adminPermissionSets=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Biz_Admin' OR name='My_Elections_Scheme_Admin' OR name='My_Elections_HRSC_admin']);    
                if(adminPermissionSets != null && adminPermissionSets.keyset() != null && adminPermissionSets.keyset().size() > 0){
                    List<permissionsetAssignment> adminUsersList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminPermissionSets.keyset() AND assigneeid=:LoggedInUser.Id];
                    if((adminUsersList == null || adminUsersList.size() == 0) && Test.isRunningtest()==false){
                        noProxyAllowed=true;   
                    }
                    else{
                        LoggedInUser = WV_Utility.getLoggedinUserDetails(proxyUserId);
                    }
                } 
            }                       
            
            if(LoggedInUser !=null){
                LoggedinEmployee = WV_Utility.getLoggedinEmployeeDetails(LoggedInUser.Emp_Id__c);
            }
            if(LoggedinEmployee != null ){
                if(noProxyAllowed==false){
                    EmployeeElections = WV_Utility.getLoggedinEmployeeElections(LoggedinEmployee);
                    if(EmployeeElections == null || EmployeeElections.size() == 0){
                        noElectionFlag=true;
                    }
                }
            } 
            else{
                noAccessAllowed = true;
            }
            
            if(noProxyAllowed==false && noAccessAllowed == false && noElectionFlag==false){            
                if(EmployeeElections != null && EmployeeElections.size()>0){
                    for(Election__c e:EmployeeElections){
                        SchemeList.add(e.Scheme__c);
                        ElectionSet.add(e.Id);
                    }
                }   
                    
                if(SchemeList != null && SchemeList.size() > 0){
                    EmployeeElectionSchemes= WV_Utility.getSchemeDetails(SchemeList);
                }
                if(ElectionSet != null && ElectionSet.size() > 0){
                    ElectionResponses= WV_Utility.getPrimaryResponseDetails(ElectionSet);
                }            
                if(EmployeeElections != null && EmployeeElections.size() > 0){                
                    for(Election__c q:EmployeeElections){
                        WV_ElectionsHistoryWrapper history=new WV_ElectionsHistoryWrapper();
                        history.ElectionId=q.id;
                        history.CreatedDate=q.CreatedDate.format();
                        history.LastModifiedDateDt=q.LastModifiedDate;
                        history.LastModifiedDate=q.LastModifiedDate.format();
                        history.year=string.ValueOf(q.LastModifiedDate.year());
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
                        if(ElectionResponses != null && ElectionResponses.containsKey(q.Id)){ 
                            history.Responses=ElectionResponses.get(q.Id);        
                        }       
                        ElectionsHistoryWrapperList.add(history);                    
                    }
                } 
            }
            EmployeeElections=null;
            ElectionResponses=null;               
        }
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            system.debug('****Exception inside WV_ElectionsHistoryController()'+e.getlinenumber()+'-'+e.getmessage()); 
            exp=e;
        }
        
    }
    
    public pageReference Gohomepage(){    
        try{
            string pageStr='/apex/WV_Homepage';
            if(proxyUserId != null && proxyUserId.trim() !=''){
                pageStr=pageStr+'?uid='+proxyUserId.trim();
            }
            
            PageReference homepage=new PageReference(pageStr);
            homepage.setRedirect(true);
            return homepage;     
        } 
        Catch(Exception e){
            system.debug('****Exception inside WV_ElectionsHistoryController-->Gohomepage()'+e.getlinenumber()+'-'+e.getmessage()); 
            customPageMessage=PAGE_ERROR;
            WV_Utility.captureExceptionFuture('My Elections','Election History Home page-->Gohomepage()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }
        return null;
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(noproxyAllowed==false && proxyUserId != null && proxyUserId.trim() != '' && LoggedInUser != null && LoggedInUser.isactive==false){
                WV_Utility.doActivateUsers(LoggedInUser.Id);
            }
            
            if(exp != null){
                WV_Utility.captureExceptionFuture('My Elections','Election History Home page-->Constructor()','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside WV_ElectionsHistoryController-->sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    } 
}