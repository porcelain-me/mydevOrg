Public class PP_UtilSid
{
    
    Public Static FINAL String STANDARD_REQUEST_TYPE = 'MS Office (Most common)';
    Public Static FINAL String EDC_AND_EUS_REQUEST_TYPE= 'Tech & Data (EDC & EUS only)';
    
    Public Static FINAL String PROPERTY_SERVICES_REQUEST_TYPE = 'Facilities/Move Mgmt (Prop Svcs only)';


    public static String getProfileOfLoggedInUser()
    {
        String profileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
        return profileName; 
    }

    
    Public static User getLoggedinUserRecord() {
        List<User> LoggedInUser;
        LoggedInUser = [select id, name, firstname, lastname, email,Emp_Id__c  from user where id = :userinfo.getuserid()];
        if(LoggedInUser != null && LoggedInUser.size() > 0){
            return LoggedInUser[0];
        }
        return null;    
    }


    /********* GET LOGGED IN EMPLOYEE DETAILS BASED ON EMP ID ************************/
    Public static Employee__c getLoggedinEmployeeDetailsbyEmpID(String empID){
        List<Employee__c> LoggedinEmployee; 
        if(empID != null && empID != ''){
            LoggedinEmployee = [select emp_id__c,Manager__c,Manager__r.Id,Manager__r.emp_id__c,Assignment_Contact_Manager__c,Assignment_Contact_Manager__r.name,Assignment_Contact_Manager__r.emp_id__c,Officer__c, cost_center__c,name,First_Name__c,Job_Region_Code__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                                , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c,user__c
                                , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c 
                                from employee__c where  Emp_ID__c =: empID AND Status__c = 'Active' ];
            
            
            if(LoggedinEmployee != null && LoggedinEmployee.size() >0){
                return LoggedinEmployee[0];
            }
        }
        return null;    
    } 
    
    Public static Boolean isApproverForStandardReq(string msID){
        List<Employee__c> LoggedinEmployees; 
            LoggedinEmployees = [select id, name, emp_id__c,Assignment_Contact_Manager__c,Officer__c from employee__c 
                                where Emp_ID__c =: msID AND Status__c = 'Active'  ];
            if(LoggedinEmployees != null && LoggedinEmployees.size() > 0  ){
                if(LoggedinEmployees[0].Officer__c == 'Y'){
                    return true;
                }
                else {
                 return getReportees(LoggedinEmployees[0].ID);
                }
            }
        return false;
    }


    Private static Boolean getReportees(ID d){
        Integer c = 0;
        c = [select count() from employee__c 
                              where Assignment_Contact_Manager__c =: d AND Status__c = 'Active' AND officer__c= 'N' ];
        if( c > 0) return true;
        return false;
    }

    Public static Boolean isApproverForEdcORPropSrvcsReq(){
        List<GroupMember> grpMembers = [ SELECT group.DeveloperName FROM  GroupMember WHERE  Group.Type = 'Regular' 
                                         and group.DeveloperName like'PP_%'  and group.DeveloperName <> 'PP_Floor_Security_Group'
                                         AND UserOrGroupId =:userinfo.getuserid()];
       
        if(grpMembers != NULL && grpMembers.size() > 0){
            return true;
        }
        return false;
    }

    Public static List<GroupMember> getAllGrpsForUserForEdcORPropSrvcsReq(){
        List<GroupMember> grpMembers = [ SELECT group.DeveloperName FROM  GroupMember WHERE  Group.Type = 'Regular' 
                                         and group.DeveloperName like'PP_%'  and group.DeveloperName <> 'PP_Floor_Security_Group'
                                         AND UserOrGroupId =:userinfo.getuserid()];
        if(grpMembers != NULL && grpMembers.size() > 0){
            return grpMembers ;
        }
        return grpMembers ;
    }

    
    Public static Boolean isSecurityAdmin(){
        List<GroupMember> grpMembers = [ SELECT group.DeveloperName FROM  GroupMember WHERE  Group.Type = 'Regular' 
                                         and group.DeveloperName = 'PP_Floor_Security_Group'
                                         AND UserOrGroupId =:userinfo.getuserid()];
        if(grpMembers != NULL && grpMembers.size() > 0){
            return true;
        }
        return false;
    }
    
    Public static Boolean getApproverByEmpIDAndGrpName(String grpName) {
        system.debug('grpName: ' + grpName);
        system.debug('userinfo.getuserid(): ' + userinfo.getuserid());
        if(grpName == Null) return false;
        List<GroupMember> grpMembers = [SELECT group.DeveloperName FROM  GroupMember WHERE  Group.Type = 'Regular' 
                                         and group.DeveloperName like: grpName  AND UserOrGroupId =:userinfo.getuserid()];
        if(grpMembers != NULL && grpMembers.size() > 0){
            system.debug('Inside getApproverByEmpIDAndGrpName: true');
            return true;
        }
        return false;
    }

    Public Static String getStatusName(String strStatus){
        String retStatusName = '';
        if(strStatus != Null){
            if(strStatus == 'Saved')
                retStatusName = 'In Draft';
            else if(strStatus == 'Submitted')
                retStatusName = 'Pending Approval';
            else if(strStatus == 'Recalled')
                retStatusName = 'In Draft';
            else if(strStatus == 'Approved')
                retStatusName = 'Approved';
            else if(strStatus == 'Closed')
                retStatusName = 'Closed';
            else if(strStatus == 'Cancelled')
                retStatusName = 'Cancelled';
            else if(strStatus == 'Rejected')
                retStatusName = 'Rejected';
            //else if(strStatus=='Pending Checked-in')
            //    retStatusName ='Pending Delivery Confirm';
        }
         return retStatusName ;
    }

    Public static Boolean isLoggedInUserAdmin() {
        /*
        // FOR SYS ADMIN's - ADMIN TAB SHOULD BE VISIBLE
        Id SYS_ADMIN_PROFILE_ID = [select ProfileId from User where Profile.Name = 'System Administrator'].ProfileId;
        If(UserInfo.getProfileId() == SYS_ADMIN_PROFILE_ID ){
        isAdmin = true;
        }  
        else {*/
        
        List<permissionsetAssignment> adminUsersList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN (select id from permissionset where name=:system.label.PP_Security_Admin) and AssigneeId = :Userinfo.getUserId()];
        System.debug ('***************** adminUsersList **************'+adminUsersList);
        if(adminUsersList != null && adminUsersList.size() > 0){
            return true;
        }
        return false;
    }
    
    Public static List<Building_Locations__c> getInScopeBuildings() {
        List <Building_Locations__c> inScopeBuildings ;
        inScopeBuildings = [ select id,Name, Address1__c,Address2__c,CITY_DESCRIPTION__c,InScope__c,InScopeTo__c,InScopeFrom__c  
                             from Building_Locations__c where InScopeFrom__c = true 
                             and PROPERTY_STATUS__c='ACTIVE' order by name asc limit 1000];
        if(inScopeBuildings != NULL && inScopeBuildings.size() > 0){
            return inScopeBuildings;
        }
        return NULL;
    }


    Public static List<Building_Locations__c> getAllBuildings() {
        List <Building_Locations__c> allActiveBuildings ;
        allActiveBuildings = [  select id,name,inScope__c,InScopeFrom__c,InScopeTo__c from Building_Locations__c where InScopeFrom__c=false 
                               and PROPERTY_STATUS__c='ACTIVE' order by name asc];
        if(allActiveBuildings != NULL && allActiveBuildings.size() > 0){
            return allActiveBuildings ;
        }
        return NULL;
    }
    
    Public static List <PR_Request__c> getPPRequestDetails( String selID){
        List <PR_Request__c> reqDetails;
        if( selID == NULL) return null;
        reqDetails = [select name,IsRejected__c,IsAttachment__c,ReworkComments__c,bearer_name__c,IsApprover__c,createdbyid,LastModifiedBy.name,lastmodifieddate,CreatedBy.FirstName,CreatedBy.LastName,Estimated_Property_Value__c,Manager__r.name,Employee_Requestee_Name__r.name,Employee_Requestee_Name__r.emp_ID__C,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,PP_Vendor_Details__c,PP_Vendor_Details__r.name,Requestor_Region__c ,
        Employee_Requestor_Name__r.name,CancelledBy__r.name,CancelledDate__c,ClosedBy__r.name,ClosedDate__c,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Property_Service_Approver__c,
        Request_Type__c,Property_Owner__c,Other_Owners__c,Others__c,Location111__r.name,CC_WatchList__c,Approval_Rejection_Date__c ,IsPassGenerated__c,
        Destination_Details__c,Destination__r.name,IsAutoColsed__c,IsAutoCancelled__c,Removal_Purpose__c ,Expected_Return_Date__c,Equipment_Receipt_Confirm__c,CC_WatcherNames__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.name  from PR_Request__c 
        where id=:selID limit 1];
        if(reqDetails != NULL && reqDetails.size() > 0 ){
            return reqDetails;
        }
        return null;
    }
    
    Public static List <PR_Request__c> getPPSingleRecord( String rID){
        List <PR_Request__c> X=[select id,Status__c, Approvers_List__c from PR_Request__c where id =: rID limit 1];
        if(X!= NULL && X.size() > 0 ){
            return X;
        }
        return null;
    }
    
    Public static List<property_Detail__c> getPPropertyDetail( String reqID){
        List<property_Detail__c> itemProperties = [SELECT id, Description__c,Asset_Tag__c,Quantity__c,Property_Name__c,Boxes__c,Serial_No__c,Items__c,Pallets__c FROM property_Detail__c where request_details__c=:reqID and Property_Name__c != null and Description__c != null];  
        if(itemProperties != NULL && itemProperties.size() > 0 ){
            return itemProperties ;
        }
        return null;
    }
     
     Public static List<Building_Locations__c> getIndivBuildingDetail( String buildingID){
        list<Building_Locations__c> location = [select id,name from Building_Locations__c where LDAP_Code__c=: buildingID and InScopefrom__c=true and PROPERTY_STATUS__c='ACTIVE'  limit 1];
        if(location != NULL && location.size() > 0 ){
            return location ;
        }
        return null;
    }
     
    Public static List<Employee__c> getEmployeeRecordbyID( String recordID) {
        List<Employee__c> empList = [select user__c,id,email__c,Emp_ID__c, Assignment_Contact_Manager__c,Manager__c,Manager__r.name,Manager__r.Id, Building_Directory__c,Assignment_Contact_Manager__r.Name,Job_Region_Code__c,Cost_Center__c from employee__C where id=:recordID AND Status__c = 'Active' limit 1];
        
        
        
        if(empList != NULL && empList.size() > 0 ){
            return empList;
        }
        return null;

     
    }
    
    Public static Employee__c getLoggedinEmployeeDetailsbyID(String empID){
        List<Employee__c> LoggedinEmployee; 
        if(empID != null){
            LoggedinEmployee = [select emp_id__c,Manager__c,Manager__r.Id,Manager__r.emp_id__c,Assignment_Contact_Manager__c,Assignment_Contact_Manager__r.name,Assignment_Contact_Manager__r.emp_id__c,Officer__c, cost_center__c,name,First_Name__c,Job_Region_Code__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                                , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c,user__c
                                , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c 
                                from employee__c where  Id=: empID AND Status__c = 'Active' ];
            
            
            if(LoggedinEmployee != null && LoggedinEmployee.size() >0){
                return LoggedinEmployee[0];
            }
        }
        return null;    
    } 
    
    public static List<OrgWideEmailAddress> getOrgWideEmaillAddresses(String name){
        return [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = :name limit 1];
    }

    Public static List<EmailTemplate> getPPEmailTemplates(){
        List<EmailTemplate> eList = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Property Pass Folder'];
        return eList;
    }
    
    Public Static Boolean getPPGrpAppoverByID(String grpName, ID idApprv) {
       if(grpName == Null || idApprv == Null) return null;
        List<GroupMember> grpMembers = [SELECT UserOrGroupId FROM  GroupMember WHERE  Group.Type = 'Regular' 
                                         and group.DeveloperName like: grpName and UserOrGroupId =: idApprv];
        if(grpMembers != NULL && grpMembers.size() > 0){
            return true;
        }
        return false;
    }

    Public static List<String> getPPGrpApproverEmails(String grpName) {
        if(grpName == Null) return null;
        List<String> sGrp = new List<string>();
        Set<ID> userIdSet = new Set<ID>();
        List<GroupMember> grpMembers = [SELECT UserOrGroupId FROM  GroupMember WHERE  Group.Type = 'Regular' 
                                         and group.DeveloperName like: grpName];
        // System.debug('********grpMembers *************'+grpMembers+grpName);                                
        if(grpMembers != NULL && grpMembers.size() > 0){
            for (GroupMember gM: grpMembers ){
                if (string.valueOf(gM.UserOrGroupId).startswith('005')){
                    userIdSet.add(gM.UserOrGroupId);
                }   
            }
            System.debug('*********************getPPGrpApproverEmails():userIdSet::'+userIdSet);
            if(userIdSet != NULL && userIdSet.size() > 0){
                List<User> uList = [select email from User where id in :userIdSet];
                if(uList != Null){
                    for (User u:uList){
                        sGrp.add(u.email);
                    }
                }
            }
        }
        //System.debug('*********************getPPGrpApproverEmails():'+sGrp);
        return sGrp;
    
        }
     
     /*
     *  Method Name : sortlist
     *  Arguments :  None    
     *  Description : This method returns sorted list of sobejct in ASC,DESC order
    */
    public static List<sObject> sortList(List<sObject> items,String sortField,String order)
    {
        List<sObject> resultList = new List<sObject>();
        //Create a map that can be used for sorting 
        Map<object, List<sObject>> objectMap = new Map<object, List<sObject>>();

        for(sObject ob : items)
        {
            if(objectMap.get(ob.get(sortField)) == null)
            {
                // For non Sobject use obj.ProperyName
                objectMap.put(ob.get(sortField), new List<sObject>());
            }
            objectMap.get(ob.get(sortField)).add(ob);
        }
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();

        for(object key : keys)
        {
            resultList.addAll(objectMap.get(key));
        }

        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc')
        {
            for(Sobject ob : resultList)
            {
                items.add(ob);
            }
        }
        else if(order.toLowerCase() == 'desc')
        {
            for(integer i = resultList.size()-1; i >= 0; i--)
            {
                items.add(resultList[i]);
            }
        }
        return items;
    }
}