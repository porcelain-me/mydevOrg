public class WV_ChangeAdminsController{
    public string searchText {get; set;}
    public List<employee__c> searchedActiveEmployeesList {get; set;}
    public set<Id> adminUsers;
    public set<Id> adminUsersBiz;
    public set<Id> adminUsersHRSC;
    public List<employeeWrapper> empList {get; set;}
    public string userid{get; set;}
    public Map<Id,Permissionset> adminPermissionSets;
    public Map<Id,Permissionset> adminPermissionSetsBiz;
    public Map<Id,Permissionset> adminPermissionSetsHRSC;
    public string error {get; set;}
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    public exception exp{get; set;} 
    
    public WV_ChangeAdminsController(){
        try{
            customPageMessage =null;
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;            
            OrgName=Label.ORG_ENVIRONMENT; 
            empList =new List<employeeWrapper>();
            getUsers('load');  
        }
        catch(Exception e){
            system.debug('****Exception in constructor of manage access page'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';    
        }
    }
   
    public PageReference search(){        
        error = null;
        customPageMessage=null;        
        try{
            empList =new List<employeeWrapper>();
            if(searchText == null || searchText.trim() =='' ){
                error=Label.WV_ChangeAdmins_NoKeywordFound; 
                return null;
            }
            else{
                getUsers(null);
                if(empList.size()<1){
                    error=Label.WV_ChangeAdmins_NoEmployeesFound;                    
                }
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside search()'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Access management page, search()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
        }
        return null;
    }
    
     public void getUsers(string type){
        adminUsers=new set<Id>();
        adminUsersBiz=new set<Id>();
        adminUsersHRSC=new set<Id>(); 
        
        adminPermissionSets=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Scheme_Admin']);
        adminPermissionSetsBiz=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Biz_Admin']);
        adminPermissionSetsHRSC=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_HRSC_admin']);
        
        if(adminPermissionSets != null && adminPermissionSets.keyset() != null && adminPermissionSets.keyset().size() > 0){
            List<permissionsetAssignment> adminUsersList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminPermissionSets.keyset()];
            for(permissionsetAssignment admins:adminUsersList){
                adminUsers.add(admins.assigneeid);
            }
        }
        
        if(adminPermissionSetsBiz != null && adminPermissionSetsBiz.keyset() != null && adminPermissionSetsBiz.keyset().size() > 0){            
            List<permissionsetAssignment> adminUsersListBiz=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminPermissionSetsBiz.keyset()];
            for(permissionsetAssignment admins:adminUsersListBiz){
                adminUsersBiz.add(admins.assigneeid);
            }
        }
        
        if(adminPermissionSetsHRSC != null && adminPermissionSetsHRSC.keyset() != null && adminPermissionSetsHRSC.keyset().size() > 0){                
            List<permissionsetAssignment> adminUsersListHRSC=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminPermissionSetsHRSC.keyset()];
            for(permissionsetAssignment admins:adminUsersListHRSC){
                adminUsersHRSC.add(admins.assigneeid);
            }
        }
        
        //Limiting 1000 records as repeat in Vf works max of 1000 records.,
        if( type==null){
            searchedActiveEmployeesList =[select id,name,User__c,Emp_ID__c,Inactive__c,User__r.name,User__r.username,User__r.email,User__r.profileId,User__r.profile.name,User__r.Isactive,Status__c from Employee__c where ( Status__c = 'Active' AND user__r.profile.name='All MS Employee' AND user__c !=:Userinfo.getUserId() AND (name like:'%'+searchText+'%' OR User__r.name like:'%'+searchText+'%' OR user__r.username like:'%'+searchText+'%' OR user__r.email like:searchText+'%' OR emp_ID__c=:searchText)) Limit 1000];
        }
        else{
            searchedActiveEmployeesList =[select id,name,User__c,Emp_ID__c,Inactive__c,User__r.name,User__r.username,User__r.email,User__r.profileId,User__r.profile.name,User__r.Isactive,Status__c from Employee__c where ( Status__c = 'Active' AND user__r.profile.name='All MS Employee' AND user__c !=:Userinfo.getUserId() AND (user__c IN:adminUsers OR user__c IN:adminUsersBiz OR user__c IN:adminUsersHRSC) ) Limit 1000];
        }
        
        for(Employee__c emp:searchedActiveEmployeesList){
            employeeWrapper emps=new employeeWrapper();
            emps.name=emp.name;
            emps.email=emp.User__r.email;
            emps.userid=emp.User__c;
            emps.Emp_ID=emp.Emp_ID__c;
            emps.username=emp.User__r.username;
            emps.profile =emp.User__r.profile.name;
            if(adminUsers.contains(emp.User__c)){
                emps.isSchemeAdmin=true;
            }
            if(adminUsersBiz.contains(emp.User__c)){
                emps.isBizAdmin=true;
            }
            if(adminUsersHRSC.contains(emp.User__c)){
                emps.isHRSCAdmin=true;
            }
            empList.add(emps);
        }
    }
    
    public class employeeWrapper{
        public string name {get; set;}     
        public string userid{get; set;}   
        public string email{get; set;} 
        public string Emp_ID {get; set;}
        public string username {get; set;}
        public string profile {get; set;}
        public boolean isSchemeAdmin{get; set;} 
        public boolean isBizAdmin{get; set;} 
        public boolean isHRSCAdmin{get; set;} 
        public employeeWrapper(){
            this.isSchemeAdmin=false;
            this.isBizAdmin=false;
            this.isHRSCAdmin=false;
        }   
    }
    
    public pageReference AssignPermission(){
        customPageMessage=null; 
        try{
            if(userid != null){                    
                if(adminPermissionSets.keyset() != null && adminPermissionSets.keyset().size() ==1){
                    activateUser(userid);   
                    List<Id> idlist=new List<Id>(adminPermissionSets.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                }
                for(employeeWrapper empl:empList){
                    if(empl.userid==userid ){
                        empl.isSchemeAdmin=true;
                        break;
                    }
                }  
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside AssignPermission()'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureExceptionFuture('My Elections','Access management page-->AssignPermission()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());  
        }
        return null;
    }
    
    public pageReference DeassignPermission(){
       customPageMessage=null; 
       try{
           if(userid != null){                    
                if(adminPermissionSets.keyset() != null && adminPermissionSets.keyset().size() ==1){
                    activateUser(userid);   
                    List<Id> idlist=new List<Id>(adminPermissionSets.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isSchemeAdmin=false;
                            break;
                        }
                    }               
                }
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside DeassignPermission'+e.getlinenumber()+'-'+e.getmessage()); 
            WV_Utility.captureExceptionFuture('My Elections','Access management page-->DeassignPermission()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());  
        }
        return null;  
    }
    
    public pageReference AssignPermissionBiz(){
        customPageMessage=null; 
        try{
            if(userid != null){                    
                if(adminPermissionSetsBiz.keyset() != null && adminPermissionSetsBiz.keyset().size() ==1){
                    activateUser(userid);   
                    List<Id> idlist=new List<Id>(adminPermissionSetsBiz.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                }
                for(employeeWrapper empl:empList){
                    if(empl.userid==userid ){
                        empl.isBizAdmin=true;
                        break;
                    }
                }  
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside AssignPermissionBiz'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureExceptionFuture('My Elections','Access management page-->AssignPermissionBiz()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());  
        }
        return null;
    }
    
    public pageReference DeassignPermissionBiz(){
       customPageMessage=null; 
       try{
           if(userid != null){                    
                if(adminPermissionSetsBiz.keyset() != null && adminPermissionSetsBiz.keyset().size() ==1){
                    activateUser(userid);   
                    List<Id> idlist=new List<Id>(adminPermissionSetsBiz.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isBizAdmin=false;
                            break;
                        }
                    }               
                }
            }
        }
         Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside DeassignPermissionBiz'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureExceptionFuture('My Elections','Access management page-->DeassignPermissionBiz()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());  
        }
        return null;  
    }
    
    public pageReference AssignPermissionHRSC(){
        customPageMessage=null; 
        try{
            if(userid != null){                    
                if(adminPermissionSetsHRSC.keyset() != null && adminPermissionSetsHRSC.keyset().size() ==1){
                    activateUser(userid);   
                    List<Id> idlist=new List<Id>(adminPermissionSetsHRSC.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                }
                for(employeeWrapper empl:empList){
                    if(empl.userid==userid ){
                        empl.isHRSCAdmin=true;
                        break;
                    }
                }  
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside AssignPermissionBiz'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureExceptionFuture('My Elections','Access management page-->AssignPermissionHRSC()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
        }
        return null;
    }
    
    public pageReference DeassignPermissionHRSC(){
       customPageMessage=null; 
       try{
           if(userid != null){                    
                if(adminPermissionSetsHRSC.keyset() != null && adminPermissionSetsHRSC.keyset().size() ==1){
                    activateUser(userid);                    
                    List<Id> idlist=new List<Id>(adminPermissionSetsHRSC.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isHRSCAdmin=false;
                            break;
                        }
                    }               
                }
            }
        }
         Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside DeassignPermissionBiz'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureExceptionFuture('My Elections','Access management page-->DeassignPermissionBiz()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
        }
        return null;  
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Manage Access Tab-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }    
    
    public void activateUser(String userId){
        if(userId != null && userId.trim() != ''){
            List<user> usersList=[select id,isactive from user where isactive=false AND id=:userId];
            if(usersList != null && usersList.size() >0){
                usersList[0].isactive=true;
                update usersList[0];
            }
        }
    }
}