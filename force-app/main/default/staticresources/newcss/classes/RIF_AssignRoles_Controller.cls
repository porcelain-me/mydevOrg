public class RIF_AssignRoles_Controller{
    
    public string empSfIDWithNoEntitlement{get;set;}
    public string searchText {get; set;}
    public List<employee__c> activeEmployeesList {get; set;} 
    public List<employee__c> searchedActiveEmployeesList {get; set;}
    public set<Id> coverageUsers;
    public set<Id> OperationsUsers;
    public set<Id> compensationUsers;
    public set<Id> internationalUsers;
    public set<Id> sysAdminUsers;
    public set<Id> docAdminUsers;
    public set<Id> genericUsers;
    public List<employeeWrapper> empList {get; set;}
    public List<employeeWrapper> searchedEmpList{get; set;}
    public string userid{get; set;}
    public string roleType{get; set;}
    public string jobStatus{get;set;}
    //public boolean isprofileChangeCompleted{get;set;} 
    
    public profile allMsEmpProfile;
    public profile rifUserProfile;
    public profile rifGenUserProfile;
    private string batchId; 
    
    public Map<string,string> msID_covEntitlementMap;
    public Map<Id,Permissionset> CoveragePermissionMap;
    public Map<Id,Permissionset> OperationsPermissionMap;
    public Map<Id,Permissionset> compensationPermissionMap;
    public Map<Id,Permissionset> internationalPermissionMap;
    public Map<Id,Permissionset> sysAdminPermissionMap;
    public Map<Id,Permissionset> docAdminPermissionMap;
    public Map<Id,Permissionset> genericUserPermissionMap;
    private Set <id> covEntitlementusers;
    public string error {get; set;}
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.RIF_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}
    public exception exp{get; set;}
    
    // RIF-87
    public Map<Id,Permissionset> superUserPermissionMap;
    public Set<Id> superUsers;
    
    public RIF_AssignRoles_Controller(){
        try{
            initializeMemebers();
        }
        catch(Exception e){
            system.debug('****Exception in constructor of manage access page'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';    
        }
    }
    
    public void initializeMemebers(){
            customPageMessage =null;
            searchText ='';
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;            
            OrgName=Label.ORG_ENVIRONMENT; 
            empList =new List<employeeWrapper>();
            searchedEmpList= new List<employeeWrapper>();
            msID_covEntitlementMap=new Map <string,string>();
            covEntitlementusers= new Set <id> ();
            for(Coverage_Entitlement__c cov:[select id,HR_EmpID__c,HR_Name__c from Coverage_Entitlement__c]){
                msID_covEntitlementMap.put(cov.HR_EmpID__c,cov.id);
                //covEntitlementusers.add(cov.HR_User__c);
            
            }
            getUsers('load');  
            //allMsEmpProfile=[select id,name from profile where name='All MS Employee' limit 1];
            //rifUserProfile=[select id,name from profile where name='RIF User' limit 1];
            //rifGenUserProfile=[select id,name from profile where name='RIF Generic User' limit 1];
    
    
    }
   
    public PageReference search(){        
        error = null;
        customPageMessage=null;        
        try{
            searchedEmpList=new List<employeeWrapper>();
            if(searchText == null || searchText.trim() =='' ){
                error=Label.RIF_ChangeRoles_NoKeywordFound; 
                return null;
            }
            else{
                getUsers(null);
                if(searchedEmpList.size()<1){
                    error=Label.RIF_ChangeRoles_NoEmployeesFound;                    
                }
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside search()'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('RIF','Assign Roles page, search()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
        }
        return null;
    }
    
     public void getUsers(string type){
        coverageUsers=new set<Id>();
        OperationsUsers=new set<Id>();
        compensationUsers=new set<Id>();
        internationalUsers=new set<Id>();
        sysAdminUsers=new set<Id>();
        docAdminUsers=new set<Id>();
        genericUsers=new set<Id>(); 
        superUsers = new Set<Id>();
         
        CoveragePermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Coverage']);
        OperationsPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Operations']);
        compensationPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_Compensation']);
        internationalPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_HR_International']);
        sysAdminPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_System_Admin']);
        docAdminPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_Document_Admin']);
        genericUserPermissionMap=new Map<Id,Permissionset>([select id,name,label from permissionset where name='RIF_Generic_User']);
        // JIRA-87
        superUserPermissionMap = new Map<Id,Permissionset>([SELECT Id,Name,Label from PermissionSet WHERE Name = 'RIF_Super_User']);
        
        if(CoveragePermissionMap != null && CoveragePermissionMap.keyset() != null && CoveragePermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment covUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:CoveragePermissionMap.keyset()]){
                coverageUsers.add(covUser.assigneeid);
            }
        }
        if(OperationsPermissionMap!= null && OperationsPermissionMap.keyset() != null && OperationsPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment opUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:OperationsPermissionMap.keyset()]){
                OperationsUsers.add(opUser.assigneeid);
            }
        }
        if(compensationPermissionMap!= null && compensationPermissionMap.keyset() != null && compensationPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment compUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:compensationPermissionMap.keyset()]){
                compensationUsers.add(compUser.assigneeid);
            }
        }
        if(internationalPermissionMap!= null && internationalPermissionMap.keyset() != null && internationalPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment intUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:internationalPermissionMap.keyset()]){
                internationalUsers.add(intUser.assigneeid);
            }
        }
        if(sysAdminPermissionMap!= null && sysAdminPermissionMap.keyset() != null && sysAdminPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment sysAdminUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:sysAdminPermissionMap.keyset()]){
                sysAdminUsers.add(sysAdminUser.assigneeid);
            }
        }
        if(docAdminPermissionMap!= null && docAdminPermissionMap.keyset() != null && docAdminPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment docAdminUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:docAdminPermissionMap.keyset()]){
                docAdminUsers.add(docAdminUser.assigneeid);
            }
        }
        if(genericUserPermissionMap!= null && genericUserPermissionMap.keyset() != null && genericUserPermissionMap.keyset().size() > 0){
           
            for(permissionsetAssignment genUser:[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:genericUserPermissionMap.keyset()]){
                genericUsers.add(genUser.assigneeid);
            }
        }
        // RIF-87
        if(superUserPermissionMap != null && !superUserPermissionMap.isEmpty()){
            for(PermissionsetAssignment supUser : [SELECT Id,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId IN : superUserPermissionMap.keyset()]){
                superUsers.add(supUser.AssigneeId);
            }
        }
         
        //Limiting 1000 records as repeat in Vf works max of 1000 records.,AND user__r.profile.name='All MS Employee' 
        if(type==null){
            //AND user__c !=:Userinfo.getUserId()
            searchedActiveEmployeesList =[select id,name,User__c,Emp_ID__c,Inactive__c,User__r.name,User__r.username,User__r.email,User__r.profileId,User__r.profile.name,User__r.Isactive,Status__c,Super_Division_Dsc_Org__c from Employee__c where Status__c = 'Active' AND user__r.Isactive=true AND (name like:'%'+searchText+'%' OR User__r.name like:'%'+searchText+'%' OR user__r.username like:'%'+searchText+'%' OR user__r.email like:searchText+'%' OR emp_ID__c=:searchText) Limit 1000];
        }
        else{
             //AND user__c !=:Userinfo.getUserId()
            ActiveEmployeesList =[select id,name,User__c,Emp_ID__c,Inactive__c,User__r.name,User__r.username,User__r.email,User__r.profileId,User__r.profile.name,User__r.Isactive,Status__c,Super_Division_Dsc_Org__c from Employee__c where ( Status__c = 'Active' AND user__r.Isactive=true  AND (user__c IN:CoverageUsers OR user__c IN:OperationsUsers OR user__c IN:compensationUsers OR user__c IN:internationalUsers OR user__c IN:sysAdminUsers OR user__c IN:docAdminUsers OR user__c IN:genericUsers OR user__c IN : superUsers ) ) Limit 1000];
        }
        if(searchedActiveEmployeesList !=null && searchedActiveEmployeesList .size()>0){
            for(Employee__c emp:searchedActiveEmployeesList){
                employeeWrapper emps=new employeeWrapper();
                emps.empSFID=emp.id;
                emps.name=emp.name;
                emps.email=emp.User__r.email;
                emps.userid=emp.User__c;
                emps.Emp_ID=emp.Emp_ID__c;
                emps.username=emp.User__r.username;
                emps.profile =emp.User__r.profile.name;
                emps.eSuperDivision=emp.Super_Division_Dsc_Org__c;
                
                if(msID_covEntitlementMap.get(emps.Emp_ID)!= null && msID_covEntitlementMap.get(emps.Emp_ID) !=''){
                    emps.covEntitlementID=msID_covEntitlementMap.get(emps.Emp_ID);
                }
                
                if(CoverageUsers.contains(emp.User__c)){
                    emps.isHRCoverage=true;
                }
                if(OperationsUsers.contains(emp.User__c)){
                    emps.isHROperations=true;
                }
                if(compensationUsers.contains(emp.User__c)){
                    emps.isHRComp=true;
                }
                if(internationalUsers.contains(emp.User__c)){
                    emps.isHRInt=true;
                }
                if(sysAdminUsers.contains(emp.User__c)){
                    emps.isSysAdmin=true;
                }
                if(docAdminUsers.contains(emp.User__c)){
                    emps.isdocAdmin=true;
                }
                if(genericUsers.contains(emp.User__c)){
                    emps.isgenUser=true;
                }
                // RIF - 87
                if(superUsers.contains(emp.User__c)){
                    emps.isSuperUser=true;
                }
                searchedEmpList.add(emps);
            }
        }
        else if(ActiveEmployeesList !=null && ActiveEmployeesList.size()>0){
                empList.clear();
            for(Employee__c emp: ActiveEmployeesList){
                employeeWrapper emps=new employeeWrapper();
                emps.empSFID=emp.id;
                emps.name=emp.name;
                emps.email=emp.User__r.email;
                emps.userid=emp.User__c;
                emps.Emp_ID=emp.Emp_ID__c;
                emps.username=emp.User__r.username;
                emps.profile =emp.User__r.profile.name;
                emps.eSuperDivision=emp.Super_Division_Dsc_Org__c;
               
                if(msID_covEntitlementMap.get(emps.Emp_ID)!= null && msID_covEntitlementMap.get(emps.Emp_ID) !=''){
                    emps.covEntitlementID=msID_covEntitlementMap.get(emps.Emp_ID);
                }
                
                if(CoverageUsers.contains(emp.User__c)){
                    emps.isHRCoverage=true;
                }
                if(OperationsUsers.contains(emp.User__c)){
                    emps.isHROperations=true;
                }
                if(compensationUsers.contains(emp.User__c)){
                    emps.isHRComp=true;
                }
                if(internationalUsers.contains(emp.User__c)){
                    emps.isHRInt=true;
                }
                if(sysAdminUsers.contains(emp.User__c)){
                    emps.isSysAdmin=true;
                }
                if(docAdminUsers.contains(emp.User__c)){
                    emps.isdocAdmin=true;
                }
                if(genericUsers.contains(emp.User__c)){
                    emps.isgenUser=true;
                }
                // RIF - 87
                if(superUsers.contains(emp.User__c)){
                    emps.isSuperUser=true;
                }
                empList.add(emps);
            }
        }
        
    }
    
    public class employeeWrapper{
        public string name {get; set;}
        public string empSFID{get;set;}     
        public string userid{get; set;}   
        public string email{get; set;} 
        public string Emp_ID {get; set;}
        public string username {get; set;}
        public string profile {get; set;}
        public string covEntitlementID{get;set;}
        public boolean isHRCoverage{get; set;} 
        public boolean isHROperations{get; set;} 
        public boolean isHRComp{get; set;} 
        public boolean isHRInt{get; set;} 
        public boolean isSysAdmin{get; set;} 
        public boolean isdocAdmin{get; set;} 
        public boolean isgenUser{get; set;} 
        public string eSuperDivision{get; set;} 
        // RIF - 87
        public Boolean isSuperUser {get;set;}
            
        public employeeWrapper(){
            this.isHRCoverage=false;
            this.isHROperations=false;
            this.isHRComp=false;
            this.isHRInt=false;
            this.isSysAdmin=false;
            this.isdocAdmin=false;
            this.isgenUser=false;
            this.isSuperUser = false;
        }   
    }
    
    public void changeUserProfile(String userID, String profileID){
        //Change User profile to 'RIF User' or 'All MS Employee' using the batch class'RIF_Batch_ChangeUserProfile'
        //isprofileChangeCompleted=false;
       /**
        batchId=Database.ExecuteBatch(new RIF_Batch_ChangeUserProfile(userid, profileID)); 
        if(batchID != null){
            AsyncApexJob asyncJob=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate,CreatedById,CreatedBy.name, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where Id=:batchID limit 1];
            jobStatus=asyncJob.Status;
            if(asyncJob.TotalJobItems==asyncJob.JobItemsProcessed)
                isprofileChangeCompleted=true; 
            else
                isprofileChangeCompleted=false;
            system.debug('###asyncJob.Status###'+asyncJob.Status) ;                      
        }  
        **/  
    }
    
    public pageReference AssignPermissionSet(){
        system.debug('*********************************AssignPermissionSet()**********************************************');
        customPageMessage=null;
        //isprofileChangeCompleted=false; 
        try{
            if( (userid != null) && (roleType=='HR Coverage')){                    
                if(CoveragePermissionMap.keyset() != null && CoveragePermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(CoveragePermissionMap.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                    Group covGroup=[select id from group where DeveloperName='RIF_HR_Coverage']; 
                     //Add the employee to the respective group also
                    List<GroupMember> GMlist = new List<GroupMember>();
                    GroupMember GM = new GroupMember();
                    GM.GroupId = covGroup.id;
                    GM.UserOrGroupId = userid; 
                    GMList.add(GM); 
                    insert GMList;
                    
                    //Change User profile to 'RIF User' using the method 'changeUserProfile()'
                    //System.debug('#####before assigning profile isprofileChangeCompleted value:'+isprofileChangeCompleted); 
                     //changeUserProfile(userid, rifUserProfile.ID);
                     //System.debug('#####after assigning profile isprofileChangeCompleted value:'+isprofileChangeCompleted); 
                   
                   
                    
                   
                }
                for(employeeWrapper empl:empList){
                    if(empl.userid==userid ){
                        empl.isHRCoverage=true;
                       // empl.profile=rifUserProfile.Name;
                        break;
                    }
                }
                
                for(employeeWrapper empl:searchedEmpList){
                    if(empl.userid==userid ){
                        empl.isHRCoverage=true;
                        //empl.profile=rifUserProfile.Name;
                        break;
                    }
                }
                  
            }
            else if( (userid != null) && (roleType=='HR Operations')){                    
                if(OperationsPermissionMap.keyset() != null && OperationsPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(OperationsPermissionMap.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                    Group opGroup=[select id from group where DeveloperName='RIF_HR_Operations'];
                   //Add the employee to the respective group also
                    List<GroupMember> GMlist = new List<GroupMember>();
                    GroupMember GM = new GroupMember();
                    GM.GroupId = opGroup.id;
                    GM.UserOrGroupId = userid;
                    GMList.add(GM); 
                    insert GMList;
                    
                    //Change User profile to 'RIF User' using the method 'changeUserProfile()'
                    //changeUserProfile(userid, rifUserProfile.ID);
                    
                     
                }
                for(employeeWrapper empl:empList){
                    if(empl.userid==userid ){
                        empl.isHROperations=true;
                      //  empl.profile=rifUserProfile.Name;
                        break;
                    }
                } 
                for(employeeWrapper empl: searchedEmpList){
                    if(empl.userid==userid ){
                        empl.isHROperations=true;
                        //empl.profile=rifUserProfile.Name;
                        break;
                    }
                }
            }
            else if( (userid != null) && (roleType=='HR Compensation')){                    
                if(compensationPermissionMap.keyset() != null && compensationPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(compensationPermissionMap.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                    Group compGroup=[select id from group where DeveloperName='RIF_HR_Compensation'];  
                    //Add the employee to the respective group also
                    List<GroupMember> GMlist = new List<GroupMember>();
                    GroupMember GM = new GroupMember();
                    GM.GroupId = compGroup.id;
                    GM.UserOrGroupId = userid;
                    GMList.add(GM); 
                    insert GMList;
                    //Change User profile to 'RIF User' using the method 'changeUserProfile()'
                    //changeUserProfile(userid, rifUserProfile.ID); 
                    //RIF_ChangeUserProfile.changeProfile(userid, rifUserProfile.ID);
                }
                for(employeeWrapper empl: empList){
                    if(empl.userid==userid ){
                        empl.isHRComp=true;
                      //  empl.profile=rifUserProfile.Name;
                        break;
                    }
                } 
                for(employeeWrapper empl: searchedEmpList){
                    if(empl.userid==userid ){
                        empl.isHRComp=true;
                        //empl.profile=rifUserProfile.Name;
                        break;
                    }
                } 
            }
            else if( (userid != null) && (roleType=='HR International')){                    
                if(internationalPermissionMap.keyset() != null && internationalPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(internationalPermissionMap.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                    
                    //Add the employee to the respective group also
                 /*   List<GroupMember> GMlist = new List<GroupMember>();
                    GroupMember GM = new GroupMember();
                    GM.GroupId = '00Gf0000000se1F';
                    GM.UserOrGroupId = userid;
                    GMList.add(GM); 
                    insert GMList;        */
                    //Change User profile to 'RIF User' using the method 'changeUserProfile()'
                     //changeUserProfile(userid, rifUserProfile.ID); 
                    //RIF_ChangeUserProfile.changeProfile(userid, rifUserProfile.ID);
                }
                for(employeeWrapper empl: empList){
                    if(empl.userid==userid ){
                        empl.isHRInt=true;
                       // empl.profile=rifUserProfile.Name;
                        break;
                    }
                }
                for(employeeWrapper empl: searchedEmpList){
                    if(empl.userid==userid ){
                        empl.isHRInt=true;
                        //empl.profile=rifUserProfile.Name;
                        break;
                    }
                }
                 
            }
            else if( (userid != null) && (roleType=='System Admin')){                    
                if(sysAdminPermissionMap.keyset() != null && sysAdminPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(sysAdminPermissionMap.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                    Group adminGroup=[select id from group where DeveloperName='RIF_System_Admin'];
                    //Add the employee to the respective group also
                    List<GroupMember> GMlist = new List<GroupMember>();
                    GroupMember GM = new GroupMember();
                    GM.GroupId = adminGroup.id;
                    GM.UserOrGroupId = userid;
                    GMList.add(GM); 
                    insert GMList;  
                    
                    //Change User profile to 'RIF User' using the method 'changeUserProfile()'
                     //changeUserProfile(userid, rifUserProfile.ID); 
                    //RIF_ChangeUserProfile.changeProfile(userid, rifUserProfile.ID);
                }
                for(employeeWrapper empl: empList){
                    if(empl.userid==userid ){
                        empl.isSysAdmin=true;
                       // empl.profile=rifUserProfile.Name;
                        break;
                    }
                } 
                for(employeeWrapper empl: searchedEmpList){
                    if(empl.userid==userid ){
                        empl.isSysAdmin=true;
                       // empl.profile=rifUserProfile.Name;
                        break;
                    }
                }
            }
            else if( (userid != null) && (roleType=='Document Admin')){                    
                if(docAdminPermissionMap.keyset() != null && docAdminPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(docAdminPermissionMap.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                    //Change User profile to 'RIF Generic User' using the method 'changeUserProfile()'
                     //changeUserProfile(userid, rifGenUserProfile.ID); 
                    //RIF_ChangeUserProfile.changeProfile(userid, rifGenUserProfile.ID);
                }
                for(employeeWrapper empl: empList){
                    if(empl.userid==userid ){
                        empl.isdocAdmin=true;
                       // empl.profile=rifGenUserProfile.Name;
                        break;
                    }
                }
                for(employeeWrapper empl: searchedEmpList){
                    if(empl.userid==userid ){
                        empl.isdocAdmin=true;
                        //empl.profile=rifGenUserProfile.Name;
                        break;
                    }
                }  
                
            }
            else if( (userid != null) && (roleType=='Generic User')){                    
                if(genericUserPermissionMap.keyset() != null && genericUserPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(genericUserPermissionMap.keyset());
                    permissionsetAssignment assign=new permissionsetAssignment(assigneeid=userid,permissionsetid=idlist[0]);
                    insert assign;
                     //Change User profile to 'RIF Generic User' using the method 'changeUserProfile()'
                     //changeUserProfile(userid, rifGenUserProfile.ID); 
                    //RIF_ChangeUserProfile.changeProfile(userid, rifGenUserProfile.ID);
                }
                for(employeeWrapper empl: empList){
                    if(empl.userid==userid ){
                        empl.isgenUser=true;
                       // empl.profile=rifGenUserProfile.Name;
                        break;
                    }
                } 
                
                for(employeeWrapper empl: searchedEmpList){
                    if(empl.userid==userid ){
                        empl.isgenUser=true;
                        //empl.profile=rifGenUserProfile.Name;
                        break;
                    }
                } 
            }
            // RIF - 87
            else if((userid != null) && (roleType.equalsIgnoreCase('Super User'))){                    
                if(superUserPermissionMap.keyset() != null && !superUserPermissionMap.isEmpty()){
                    List<Id> idlist=new List<Id>(superUserPermissionMap.keyset());
                    PermissionSetAssignment assign = new PermissionSetAssignment(AssigneeId = userid, PermissionSetId = idlist[0]);
                    insert assign;
                }
                for(employeeWrapper empl : empList){
                    if(empl.userid == userid){
                        empl.isSuperUser = true;
                        break;
                    }
                } 
                for(employeeWrapper empl : searchedEmpList){
                    if(empl.userid == userid){
                        empl.isSuperUser = true;
                        break;
                    }
                } 
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside AssignPermission()'+e.getlinenumber()+'-'+e.getmessage()); 
           //WV_Utility.captureException('My Elections','Access management page-->AssignPermission()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());  
        }
        return null;
    }
    
    public pageReference DeassignPermissionSet(){
       customPageMessage=null; 
       //isprofileChangeCompleted=false; 
       system.debug('*********************************DeassignPermissionSet()**********************************************');
       try{
           if( (userid != null) && (roleType=='HR Coverage')){                   
                if(CoveragePermissionMap.keyset() != null && CoveragePermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(CoveragePermissionMap.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                        
                    //Delete the user from the public group when permission set is removed
                    GroupMember GM  = [Select Id from GroupMember where UserOrGroupID =: userid and Group.DeveloperName = 'RIF_HR_Coverage'];
                    delete GM; 
                        
                        //Change User profile to 'All MS Employee' using the method 'changeUserProfile()'
                        //System.debug('#####before Deassigning profile isprofileChangeCompleted value:'+isprofileChangeCompleted); 
                        //changeUserProfile(userid, allMsEmpProfile.ID);
                        //System.debug('#####after Deassigning profile isprofileChangeCompleted value:'+isprofileChangeCompleted);  
                       
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isHRCoverage=false;
                          //  empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }  
                    for(employeeWrapper empl: searchedEmpList){
                        if(empl.userid==userid ){
                            empl.isHRCoverage=false;
                            //empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }             
                }
            }
            else if( (userid != null) && (roleType=='HR Operations')){                    
                if(OperationsPermissionMap.keyset() != null && OperationsPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(OperationsPermissionMap.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                         
                   //Delete the user from the public group when permission set is removed
                    GroupMember GM  = [Select Id from GroupMember where UserOrGroupID =: userid and Group.DeveloperName = 'RIF_HR_Operations'];
                    delete GM;
                        
                        //Change User profile to 'All MS Employee' using the method 'changeUserProfile()'
                       // changeUserProfile(userid, allMsEmpProfile.ID);
                    } 
                    for(employeeWrapper empl: empList){
                        if(empl.userid==userid ){
                            empl.isHROperations=false;
                         //   empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    } 
                    for(employeeWrapper empl: searchedEmpList){
                        if(empl.userid==userid ){
                            empl.isHROperations=false;
                           // empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }              
                }
            }
            else if( (userid != null) && (roleType=='HR Compensation')){                    
                if(compensationPermissionMap.keyset() != null && compensationPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(compensationPermissionMap.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                        
                    //Delete the user from the public group when permission set is removed
                    GroupMember GM  = [Select Id from GroupMember where UserOrGroupID =: userid and Group.DeveloperName = 'RIF_HR_Compensation'];
                    delete GM;
                    
                        //Change User profile to 'All MS Employee' using the method 'changeUserProfile()'
                        //changeUserProfile(userid, allMsEmpProfile.ID);
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isHRComp=false;
                          //  empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    } 
                    for(employeeWrapper empl: searchedEmpList){
                        if(empl.userid==userid ){
                            empl.isHRComp=false;
                            //empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }               
                }
            }
            else if( (userid != null) && (roleType=='HR International')){                    
                if(internationalPermissionMap.keyset() != null && internationalPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(internationalPermissionMap.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                        
                         //Delete the user from the public group when permission set is removed
                /*    GroupMember GM  = [Select Id from GroupMember where UserOrGroupID =: userid and Group.Name = 'RIF HR International'];
                    delete GM;        */
                        //Change User profile to 'All MS Employee' using the method 'changeUserProfile()'
                       // changeUserProfile(userid, allMsEmpProfile.ID);
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isHRInt=false;
                         //   empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    } 
                    for(employeeWrapper empl: searchedEmpList){
                        if(empl.userid==userid ){
                            empl.isHRInt=false;
                           // empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }              
                }
            }
            else if( (userid != null) && (roleType=='System Admin')){  
            system.debug('********************'+userid+'********"'+roletype);                  
                if(sysAdminPermissionMap.keyset() != null && sysAdminPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(sysAdminPermissionMap.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                        
                        
                    //Delete the user from the public group when permission set is removed
                    GroupMember GM  = [Select Id from GroupMember where UserOrGroupID =: userid and Group.DeveloperName = 'RIF_System_Admin'];
                    delete GM;
                        //Change User profile to 'All MS Employee' using the method 'changeUserProfile()'
                        //changeUserProfile(userid, allMsEmpProfile.ID);
                    } 
                    for(employeeWrapper empl: empList){
                        if(empl.userid==userid ){
                            empl.isSysAdmin=false;
                          //  empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    } 
                    for(employeeWrapper empl: searchedEmpList){
                        if(empl.userid==userid ){
                            empl.isSysAdmin=false;
                         //   empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }              
                }
            }
            else if( (userid != null) && (roleType=='Document Admin')){                    
                if(docAdminPermissionMap.keyset() != null && docAdminPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(docAdminPermissionMap.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                        //Change User profile to 'All MS Employee' using the method 'changeUserProfile()'
                       // changeUserProfile(userid, allMsEmpProfile.ID);
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isdocAdmin=false;
                           // empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }
                    for(employeeWrapper empl: searchedEmpList){
                        if(empl.userid==userid ){
                            empl.isdocAdmin=false;
                           // empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }                
                }
            }
            else if( (userid != null) && (roleType=='Generic User')){                    
                if(genericUserPermissionMap.keyset() != null && genericUserPermissionMap.keyset().size() ==1){
                    List<Id> idlist=new List<Id>(genericUserPermissionMap.keyset());
                    List<permissionsetAssignment> assignList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid=:idlist[0] and assigneeid=:userid];
                    if(assignList.size()>0){
                        delete assignList;
                       //Change User profile to 'All MS Employee' using the method 'changeUserProfile()'
                        //changeUserProfile(userid, allMsEmpProfile.ID);
                    } 
                    for(employeeWrapper empl:empList){
                        if(empl.userid==userid ){
                            empl.isgenUser=false;
                          //  empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    } 
                    for(employeeWrapper empl: searchedEmpList){
                        if(empl.userid==userid ){
                            empl.isgenUser=false;
                            //empl.profile=allMsEmpProfile.Name;
                            break;
                        }
                    }              
                }
            }
           // RIF - 87
           else if((userid != null) && (roleType.equalsIgnoreCase('Super User'))){                  
               if(superUserPermissionMap.keyset() != null && !superUserPermissionMap.isEmpty()){
                   List<Id> idlist=new List<Id>(superUserPermissionMap.keyset());
                   List<PermissionSetAssignment> assignList = [SELECT Id,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId =: idlist[0] AND AssigneeId =: userid];
                   if(assignList != null && !assignList.isEmpty()){
                       delete assignList;
                   } 
                   for(employeeWrapper empl:empList){
                       if(empl.userid == userid){
                           empl.isSuperUser = false;
                           break;
                       }
                   } 
                   for(employeeWrapper empl: searchedEmpList){
                       if(empl.userid == userid){
                           empl.isSuperUser = false;
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
           //WV_Utility.captureException('My Elections','Access management page-->DeassignPermission()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());  
        }
        return null;   
    }
    
    //method for creating new coverage entitlement, if not exist already for an user
    public pageReference addCovEntitlement(){
        
        system.debug('###empSfIDWithNoEntitlement####'+empSfIDWithNoEntitlement);
        if(empSfIDWithNoEntitlement!=null && empSfIDWithNoEntitlement!=''){
            //create a new coverage entitlement record
            Coverage_Entitlement__c cov= new Coverage_Entitlement__c(HR_Name__c=empSfIDWithNoEntitlement);
            insert cov;
            //+'&returnUrl='+ApexPages.currentPage().getUrl()
            return new pageReference('/'+cov.id);
        
        } 
        return null;
           
    
    }
    //cancel method refreshes the page and clear the success and error values
  
    public pageReference cancel(){
      initializeMemebers();
      searchedEmpList= new List<employeeWrapper>();
      PageReference pg=new PageReference('/apex/RIF_AssignRoles');
               pg.setredirect(true);
               return pg;
      //return null;
    }
    
    
    
    /*public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Manage Access Tab-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }*/    
}