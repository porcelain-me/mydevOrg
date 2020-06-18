public class SystemAccessGrantManager {

    @InvocableMethod(label='Grant System Accesses' description='Grants system accesses to a user/employee as defined by the relative system access request/grant records')
	public static void grantSystemAccess(List<System_Access_Grant__c> systemAccessGrants) {
        
        //For potential bulk processing, ensure that grants are collecter per employee prior to parsing/application
        Set<Id> accessReqIds = new Set<Id>();
        Map<Id,List<System_Access_Grant__c>> employeeGrantMap = new Map<Id,List<System_Access_Grant__c>>();
        Map<Id,System_Access_Request__c> employeeRequestMap = new Map<Id,System_Access_Request__c>();
        for(System_Access_Grant__c grant : systemAccessGrants) {
            accessReqIds.add(grant.System_Access_Request__c);
        }
        Map<Id,System_Access_Request__c> accessReqMap = new Map<Id,System_Access_Request__c>([SELECT Id, Employee__c, App_Permissions__c FROM System_Access_Request__c WHERE Id IN :accessReqIds]);
        for(System_Access_Grant__c grant : systemAccessGrants) {
            System_Access_Request__c req = accessReqMap.get(grant.System_Access_Request__c);
            if(employeeGrantMap.containsKey(req.Employee__c)) {
            	List<System_Access_Grant__c> grantList = employeeGrantMap.get(req.Employee__c);
                grantList.add(grant);
                employeeGrantMap.put(req.Employee__c,grantList);
            }
            else {
            	List<System_Access_Grant__c> grantList = new List<System_Access_Grant__c>();
                grantList.add(grant);
                employeeGrantMap.put(req.Employee__c,grantList);
            }
            employeeRequestMap.put(grant.Id,accessReqMap.get(grant.System_Access_Request__c));
        }
        
        //**********Find existing employee accesses************
        //User & Profile Definition
        Map<Id,Employee__c> empMap = new Map<ID, Employee__c>([SELECT Id, User__c, User__r.IsActive, User__r.ProfileId FROM Employee__c WHERE Id IN :employeeGrantMap.KeySet()]);
        Set<Id> userIds = new Set<Id>();
        for(Employee__c emp : empMap.values()) {
            if(emp.User__c != null) {
            	userIds.add(emp.User__c);
            }
        }
        //Permission Set Definition
        List<PermissionSetAssignment> existingPermissionSets = [SELECT Id, AssigneeId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId IN :userIds];
        Map<Id,Set<String>> existingPermissionMap = new Map<Id,Set<String>>();
        for(PermissionSetAssignment pset : existingPermissionSets){
            if(existingPermissionMap.containsKey(pset.AssigneeId)) {
            	Set<String> grantSet = existingPermissionMap.get(pset.AssigneeId);
                grantSet.add(pset.PermissionSet.Name);
                existingPermissionMap.put(pset.AssigneeId,grantSet);
            }
            else {
            	Set<String> grantSet = new Set<String>();
                grantSet.add(pset.PermissionSet.Name);
                existingPermissionMap.put(pset.AssigneeId,grantSet);
            }
        }
        //Public Group Definition
        List<GroupMember> existingGroupMem = [SELECT Id, group.Id, group.Name, UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN :userIds];
        Map<Id,Set<String>> existingGroupMap = new Map<Id,Set<String>>();
        for(GroupMember mem : existingGroupMem){
            if(existingGroupMap.containsKey(mem.UserOrGroupId)) {
            	Set<String> grantSet = existingGroupMap.get(mem.UserOrGroupId);
                grantSet.add(mem.group.Name);
                existingGroupMap.put(mem.UserOrGroupId,grantSet);
            }
            else {
            	Set<String> grantSet = new Set<String>();
                grantSet.add(mem.group.Name);
                existingGroupMap.put(mem.UserOrGroupId,grantSet);
            }
        }
        
        //Find map of permission sets for comparison
        List<PermissionSet> psets = [select Id, Label FROM PermissionSet];
        Map<String,Id> psetMap = new Map<String,Id>();
        for(PermissionSet pset : psets) {
            psetMap.put(pset.Label,pset.Id);
        }
        //Find map of public groups for comparison
        List<group> groups = [select Id, name FROM Group];
        Map<String,Id> groupMap = new Map<String,Id>();
        for(Group g : groups) {
            groupMap.put(g.Name,g.Id);
        }
        //Find map of App Permissions for comparison
        List<App_Permission__c> appPermissions = [SELECT Id, Name, Profile__c, Permission_Sets__c, Public_Groups__c FROM App_Permission__c];
        Map<String,App_Permission__c> appMap = new Map<String,App_Permission__c>();
        for(App_Permission__c appPermission : appPermissions) {
            appMap.put(appPermission.Name,appPermission);
        }
        
        //**********Iterate over employee grant - determine grant application**********
        List<User> userInsertList = new List<User>();
        List<User> userUpdateList = new List<User>();
        for(Id empId : employeeGrantMap.keySet()) {
            Employee__c emp = empMap.get(empId);
            List<System_Access_Grant__c> grants = employeeGrantMap.get(empId);
            
            //User creation/activation capture
            User u;
            if(emp.User__c != null) {
                u = emp.User__r;
                if(!u.IsActive) {
                    u.IsActive = true;
                    userUpdateList.add(u);
                }
            }
            else {
                u = new User();
                //TBD: Define & Insert u
                //userInsertList.add(u);
            }
            
            //Determine Profile application
            //NOTE: Cannot update profile from MS Employee to System Admin due to API limitations (would require cloning the user)
            
            if(!grants.isEmpty()) {
            	//Determine Permission Set application
                if(emp.User__c != null && existingPermissionMap.containsKey(emp.User__c)) {
                    applyPermissionSets(emp.User__c, existingPermissionMap.get(emp.User__c), grants, employeeRequestMap, psetMap, appMap); 
                }
                else {
                	applyPermissionSets(emp.User__c, null, grants, employeeRequestMap, psetMap, appMap); 
                }
            	//Determine Public Group application
                if(emp.User__c != null && existingGroupMap.containsKey(emp.User__c)) {
                    applyPublicGroups(emp.User__c, existingGroupMap.get(emp.User__c), grants, employeeRequestMap, groupMap, appMap); 
                }
                else {
                	applyPublicGroups(emp.User__c, null, grants, employeeRequestMap, groupMap, appMap); 
                }
            }
        }
    }
    
    public static void applyPermissionSets(Id userId, Set<String> existingPermissions, List<System_Access_Grant__c> systemAccessGrants, Map<Id,System_Access_Request__c> employeeRequestMap, Map<String,Id> psetMap, Map<String,App_Permission__c> appMap) {
        for(System_Access_Grant__c grant : systemAccessGrants) {
            System_Access_Request__c req = employeeRequestMap.get(grant.Id);
            if(req.App_Permissions__c != null && !''.equals(req.App_Permissions__c)) {
                for(String appKey : req.App_Permissions__c.split(';')) {
                    if(appMap.containsKey(appKey)) {
                        App_Permission__c appPermission = appMap.get(appKey);
                        if(appPermission.Permission_Sets__c != null && !''.equals(appPermission.Permission_Sets__c)) {
                            for(String key : appPermission.Permission_Sets__c.split(';')) {
                                if((existingPermissions != null || !existingPermissions.contains(key)) && psetMap.containsKey(key)) {
                                    savePermissionData(userId,psetMap.get(key));
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @future
    public static void savePermissionData(Id userId, Id pSetId) {
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = userId;
        psa.PermissionSetId = pSetId;
        insert psa;
        //TBD: Save history of changes for reversal later
    }
    
    public static void applyPublicGroups(Id userId, Set<String> existingPublicGroups, List<System_Access_Grant__c> systemAccessGrants, Map<Id,System_Access_Request__c> employeeRequestMap, Map<String,Id> pgroupMap, Map<String,App_Permission__c> appMap) {
        List<GroupMember> pGroupList = new List<GroupMember>();
        for(System_Access_Grant__c grant : systemAccessGrants) {
            System_Access_Request__c req = employeeRequestMap.get(grant.Id);
            if(req.App_Permissions__c != null && !''.equals(req.App_Permissions__c)) {
                for(String appKey : req.App_Permissions__c.split(';')) {
                    if(appMap.containsKey(appKey)) {
                        App_Permission__c appPermission = appMap.get(appKey);
                        if(appPermission.Public_Groups__c != null && !''.equals(appPermission.Public_Groups__c)) {
                            for(String key : appPermission.Public_Groups__c.split(';')) {
                                if((existingPublicGroups == null || !existingPublicGroups.contains(key)) && pgroupMap.containsKey(key)) {
                                    savePublicGroupData(userId,pgroupMap.get(key));
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @future
    public static void savePublicGroupData(Id userId, Id pGroupId) {
        GroupMember member = new GroupMember();
        member.UserOrGroupId = userId;
        member.groupId = pGroupId;
        insert member;
        //TBD: Save history of changes for reversal later
    }
}