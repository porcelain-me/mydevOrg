global class UserSecurityManagement {

    User thisUser;
    String userName = '';
    
    global UserSecurityManagement() {
        thisUser = new User();
    }
    
    @RemoteAction
    global Static List<User> getUserDetails(String name) {
        List<User> userList;
        try {
            if(name.length() >= 3) {
                name = '%' + name + '%';
                userList = [SELECT id,Name,Emp_id__C FROM User WHERE Name like :name OR Emp_Id__C like :name LIMIT 10];
            }
            if(userList.size() > 0)
                return userList;
        } catch(Exception e) {
            System.debug(e);
        }
        
        return null;
    }
    
    @RemoteAction
    global Static Map<String, List<sObject>> getUserAssignments(String userId) {
        
        Map<String, List<sObject>> userMap = new Map<String, List<sObject>>();
        
        try {
            /*
            List<Profiles> tempProfileList = [SELECT Id, Name FROM Profiles];
            userMap.put('allProfiles', tempProfileList);
            
            tempProfileList = [SELECT Profile.Name FROM USER WHERE id=:userId];
            userMap.put('userProfile', tempProfileList);
            */
            
            List<PermissionSet> tempPermissionList = [select id, label from permissionset where (NOT label Like '%00e%')];
            userMap.put('allPermissions', tempPermissionList);
            
            List<PermissionSetAssignment>tempPermissionAssignList = [SELECT id, AssigneeId, Assignee.Name, 
                                                        Permissionset.id, PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId = :userId];
            userMap.put('userPermissions', tempPermissionAssignList);
            
            List<Group> tempGroupList = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Regular'];
            userMap.put('allGroups', tempGroupList);
            
            List<GroupMember>tempGroupMemberList = [Select Group.id, Group.Name 
                                        From GroupMember WHERE UserOrGroupId=:userId AND Group.Type = 'Regular'];
            userMap.put('userGroups', tempGroupMemberList);
            
            tempGroupList = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue'];
            userMap.put('allQueues', tempGroupList);
            
            tempGroupMemberList = [Select Group.id, Group.Name
                                        From GroupMember WHERE UserOrGroupId=:userId AND Group.Type = 'Queue'];
            userMap.put('userQueues', tempGroupMemberList);
            
        } catch(Exception e) {
            System.debug(e);
        }
        
        
        
        return userMap;
    }
}