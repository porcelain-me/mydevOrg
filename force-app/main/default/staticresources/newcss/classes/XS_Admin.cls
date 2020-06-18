public with sharing class XS_Admin {
    
    public List<SelectOption> publicGroups{get;set;}
    public Boolean isSaveDisabled{get;set;}
    public String selectedGroup {get;set;}
    
    public List<Wrapper> wrapperlist{get;set;}
    public List<User> users{get;set;}
    
    public String userId {get;set;}
    
    public List<User> userSearchList {get;set;}
    public boolean userPopup {get;set;}
    
    private String groupName {get;set;}
    public User usr{get;set;}
    public Boolean usersZero{get;set;}
    
    public String requesteeUser {get;set;}
    List<GroupMember> grpList = new List<GroupMember>();
    public String errorMessage {get;set;}
    
    public boolean displayError {get;set;}
    
    public list<Wrapper> searchwrapper{get;set;}
    
    Map<String, String> groupsMap = new Map<String, String>{
        'XS Super Users' => 'XS_Super_User',
            'XS Private Side Users' => 'XS_Private_Normal_User',
            'XS Public Delegate Users' => 'XS_Public_Delegates',
            'XS Private Delegate Users' => 'XS_Private_Delegates',
            'XS Normal Users' => 'XS_Normal_Users',
            
            'Super Users' => 'XS_Super_User',
            'Private Side Users' => 'XS_Private_Normal_User',
            'Public Delegate Users' => 'XS_Public_Delegates',
            'Private Delegate Users' => 'XS_Private_Delegates',
            'Normal Users' => 'XS_Normal_Users'
            };
                
    public XS_Admin(){
        displayError = FALSE;
        wrapperlist = new List<Wrapper>();
        searchwrapper = new list<wrapper>();
        isSaveDisabled = TRUE;
        usr = new User();
        users = new List<User>();
        userSearchList = new List<User>();
        requesteeUser = '';
        userPopup = false;
        publicGroups = new List<SelectOption>();
        Set<String> manageGroups = new Set<String>();
                    
        String superUserId = '';
        List<SelectOption> publicGroupsTemp = new List<SelectOption>();
                    
        for(Group g : [SELECT Id, Name FROM Group WHERE Name IN: groupsMap.keySet() ORDER BY Name]){
            if(!manageGroups.contains(g.Name)){
                manageGroups.add(g.Name);
                    if(g.Name.equalsIgnoreCase('XS Super Users')){
                        publicGroups.add(new SelectOption(g.Id, g.Name.split('XS')[1]));
                        continue;
                    }
                    // publicGroupsTemp.add(new SelectOption(g.Id, g.Name.split('XS')[1]));
                    if(g.Name.contains('XSell'))
                        publicGroupsTemp.add(new SelectOption(g.Id, g.Name.split('XSell')[1]));
                    else
                        publicGroupsTemp.add(new SelectOption(g.Id, g.Name.split('XS')[1]));
            }
        }
                    
        for(SelectOption so: publicGroupsTemp){
            publicGroups.add(so);
        }
                    
        userId = '';
        if(users.size() == 0)
            usersZero = true;
    }
    
    public void GetUserIdsFromGroups() {
        users = new List<User>();
        wrapperlist = new list<wrapper>();
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        system.debug('selectedGroup: '+selectedGroup); 
        system.debug('publicGroups: '+publicGroups);
        
        for(SelectOption so: publicGroups){
            if(so.getValue().equals(selectedGroup)){
                system.debug('inside if for teh so.gevalue: ' + so.getValue() 
                                + 'and groupsmap is : '+groupsmap+' while so.getlabel is: '+so.getlabel());
                groupName = groupsMap.get(so.getLabel().trim());
                break;
            }
        }
        
        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember 
                                Where GroupId = :selectedGroup]) {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType)) {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            // else if (((String)m.UserOrGroupId).startsWith(groupType))
            // {
            // Call this function again but pass in the group found within this group
            // result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            // }
        }
        
        map<String, id> Empidmap = new map<String, id>();
        system.debug('result has '+result.size()+' members.');
        list<user> usersToAdd = [SELECT Id, FirstName, LastName,  Division, 
                                 ReceivesInfoEmails, Emp_Id__c, isActive FROM User 
                                 WHERE ID IN: result ];
        if(usersToAdd.isEmpty())
            return;
        
        for(User u: usersToAdd) {
            system.debug('u: '+u);
            users.add(u);
            Empidmap.put(u.Emp_Id__c, u.id);
        }
        
        
        list<employee__c> emplist = [select Emp_ID__c, Job_Title_Dsc_Job__c, 
                                        Manager__r.Name, Division_Dsc_Org__c FROM 
                                        Employee__c where Emp_ID__c IN: EmpidMap.keySet()];
        if(!empList.isEmpty()) {
            for(User usr: usersToAdd) {
                wrapper w = new wrapper();
                w.usr = usr;
                for(Employee__c emp: emplist){
                
                    if(emp.EMP_ID__c <> NULL &&  usr.Emp_Id__c.equals(emp.EMP_ID__c)) {
                        w.emp = emp;
                        break;
                        }
                    
                }
                wrapperlist.add(w);
            }
        }
        system.debug('wrapperList is: '+wrapperList); 
    }
    
    public void removeGroupMember(){
        system.debug('userid:' +userId);
        if(!String.isEmpty(userId)){
            GroupMember GM = new GroupMember();
            GM.GroupId = selectedGroup;
            GM.UserOrGroupId = userId;
            
            grpList.addAll([Select Id, UserOrGroupId from GroupMember 
                            where GroupId =: selectedGroup and UserOrGroupId =: userId ]);
            system.debug('grpList : '+grpList  );
            removeTemp();
        }
        
    }
    // if(!grpList.isEmpty()){
    // delete grpList;
    // insert GM;
    // GetUserIdsFromGroups();
    
    private void removeTemp(){
        List<User> newUsers = new List<User>();
        for(User us: users){
            if(us.id.equals(userId))
                continue;
            newUsers.add(us);
        }
        users = newUsers;
        isSaveDisabled = false;
        for(User usr: users){
            if(usr.ReceivesInfoEmails <> NULL && usr.ReceivesInfoEmails){
                // isSaveDisabled = FALSE;
                break;
            }
        }
        
        
        
        list<wrapper> newwrapperList=new list<wrapper>();
        
        for(wrapper wrap: wrapperlist){
            if(wrap.usr.id.equals(userId))
                continue;
            newwrapperlist.add(wrap);
        }
        wrapperlist = newwrapperlist;
        
        for(wrapper w: wrapperlist){
            if(w.usr.ReceivesInfoEmails <> NULL && w.usr.ReceivesInfoEmails ){
                isSaveDisabled = FALSE;
                break;
            }
        }
        
        system.debug('inside else for the new users: '+users);
    }
    // @future
    public static void updateInactiveUsers(set<Id> userIDs) {
        
        list<User> usersToUpdate = new List<User>();
        for(Id userId: userIDs)
            usersToUpdate.add(new User(id=userId, isActive=TRUE));
        if(!Test.isRunningTest())
            update usersToUpdate;
        
    }
    
    public void addGroupMembers(){
        if(!String.isEmpty(selectedGroup)){
            // errorMessage='Yo';
            List<GroupMember> gmList = new List<GroupMember>();
            List<PermissionSetAssignment> permissionSetObjs = new List<PermissionSetAssignment>();
            String permissionSetName = NULL;
            Set<Id> usersToAdd = new Set<Id>();
            Set<Id> usersToRemove = new Set<Id>();
            
            set<id> inactiveUsersToAdd = new set<id>();
            for(wrapper w:wrapperlist){
                if(w.usr.ReceivesInfoEmails <> NULL && w.usr.ReceivesInfoEmails){
                    GroupMember GM = new GroupMember();
                    GM.GroupId = selectedGroup;
                    GM.UserOrGroupId = w.usr.Id;
                    gmList.add(gm);
                    if(!w.usr.isActive){
                        inactiveUsersToAdd.add(w.usr.id);
                        continue;
                    }
                    usersToAdd.add(w.usr.Id);
                }
            }
            
            for(GroupMember gm: grpList)
                usersToRemove.add(gm.userOrGroupId);
            
            // try{
            if(!gmList.isEmpty()){
                
                updateInactiveUsers(inactiveUsersToAdd);
                usersToAdd.addAll(inactiveUsersToAdd);
                system.debug('groupName :: '+groupName );
                List<PermissionSetAssignment> permissionSetList = this.assignPermissionSet(groupName, usersToAdd);
                
                if(permissionSetList <> NULL && !permissionSetList.isEmpty()){
                    try{
                        // insert permissionSetList;
                        
                        insertPermissions(JSON.serialize(permissionSetList));
                    }catch(Exception ex){
                        GetUserIdsFromGroups();
                        errorMessage = ex.getMessage();
                        ApexPages.addMessages(ex);
                        selectedGroup='';
                        isSaveDisabled = TRUE;
                        
                        list<wrapper> newwrapperlst = new list<wrapper>();
                        
                        for(wrapper w:wrapperlist){
                            if(w.usr.ReceivesInfoEmails <> NULL && w.usr.ReceivesInfoEmails){
                                
                            } else{
                                newwrapperlst.add(w);
                            }
                        }
                        wrapperlist = newwrapperlst ;
                        return;
                    }
                }
                try{
                    // insert gmList;
                    
                    insertGroupMembers(JSON.serialize(gmList));
                }catch(Exception ex){
                    GetUserIdsFromGroups();
                    return;
                } 
                
            }
            if(!grpList.isEmpty()){
                // delete grpList;
                set<Id> grpids = new set<id>();
                
                for(GroupMember gm: grpList){
                    grpIds.add(gm.id);
                }
                
                deleteGroupMembers(grpIds);
                
                List<PermissionSetAssignment> permissionSetList = 
                            this.removePermissionSetAssignment(groupName, usersToRemove);
                if(permissionSetList <> NULL && !permissionSetList.isEmpty()){
                    // delete permissionSetList;
                    set<id> pIds = new set<id>();
                    
                    for(PermissionSetAssignment ps: permissionSetList){
                        pids.add(ps.id);
                    }
                    deletePermissions(pIds);
                }
            }
            // }catch(Exception ex){
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, ex.getMessage()));
            // }
            if(!gmlist.isEmpty() || !grpList.isEmpty())
                GetUserIdsFromGroups();
            
            
        }
    }
    
    
    public PageReference filterUser() {
        searchwrapper.clear();
        userSearchList.clear();
        system.debug('RequesteeUser: '+RequesteeUser);
        if(RequesteeUser.split('').size()<=2)
            return NULL;
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId 
                                                          FROM Profile where UserLicenseId  
                                                          in (SELECT Id FROM UserLicense 
                                                              where name ='Salesforce Platform')]);
        Set<Id> keys = profileIds.Keyset();
        // List<user> standardProfileUsers = [select id from user where profileId in:profileIds.Keyset()];
        string query = 'SELECT Id, Name, FirstName, LastName,'
            + ' ReceivesInfoEmails, profileid, Emp_Id__c, isActive'
            + ' FROM User WHERE profileId in: keys  AND (Name like \'%' 
            + RequesteeUser +'%\' OR Emp_Id__c like \'%' + RequesteeUser 
            + '%\') LIMIT 15';
        system.debug('query to be done: '+query);
        
        userSearchList= Database.query(query);
        if(usersearchlist.isempty())
            return null;
        
        set<string> msids = new set<string>();
        
        for(user u: usersearchlist)
            msids.add(u.emp_id__c);
        
        list<employee__c> emplistrecs = [select Business_Title__c, Division_Dsc_Org__c, 
                                         emp_id__c from employee__c where emp_id__c in: msids];
        
        
        for(user u: usersearchlist){
            employee__c e = null;
            for(employee__c emp: emplistrecs){
                
                if(emp.emp_id__c.equals(u.emp_id__c)){
                    e = emp;
                    break;
                
                }
            }
            if(e == null)
                e = new employee__c(emp_id__c = '');
            searchwrapper.add(new wrapper(u, e));
        }
        
        
        // } catch (Exception e) {
        // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
        // ApexPages.addMessage(myMsg);
        // return null;
        // }
        
        return null;
    }
    
    
    public void addUserElement(){
        for(wrapper w: wrapperlist){
            System.debug('meaningful'+w.usr.id);
            if(w.usr.id.equals(usr.clone(TRUE,FALSE,FALSE,FALSE).id)){
                displayError = TRUE;
                errorMessage = 'User already existing in the list.';
                return;
            }
        }
        displayError = FALSE;
        // which group does this user belong to?
        system.debug('user to be added clone: '+usr.clone(TRUE,FALSE,FALSE,FALSE).id);
        List<GroupMember> grplist = [Select Id, UserOrGroupId, groupid from 
                                     GroupMember where UserOrGroupId = 
                                     :usr.clone(TRUE,FALSE,FALSE,FALSE).id];
        // TEST this scenario with users who don't belong to any group
        system.debug('grplist: '+grplist);
        
        if(!grplist.isEmpty()){
            set<string> groupsCheck = new set<string>{'XS_Public_Delegate_users',
                'XS_Delegate_Users', 'XS_Private_Side_Users', 'XSell_Normal_User'};
                set<id> groupids = new set<id>();
            for(groupmember gm: grplist)
                groupids.add(gm.groupid);
            
            groupIds.add(id.valueof(selectedGroup));
            list<group> groups = [SELECT DeveloperName, id FROM Group where id in: groupids];
            boolean doProceed = FALSE;
            String currentGroupName;
            for(group grp: groups){
                if(grp.id==id.valueof(selectedgroup)){
                    if(groupsCheck.contains(grp.DeveloperName)){
                        currentGroupName = grp.DeveloperName;
                        doProceed = TRUE;
                    }
                }
            }
            
            if(doProceed){
                system.debug('inside doproceed block');
                Set<String> userGroupNames = new Set<String>();
                boolean proceedFurther = FALSE;
                for(group grp: groups){
                    if(grp.id <> id.valueof(selectedgroup)){
                        if(groupsCheck.contains(grp.DeveloperName)){
                            userGroupNames.add(grp.DeveloperName);
                            proceedFurther = TRUE;
                        }
                    }
                }
                if(proceedFurther){
                    system.debug('inside proceed further');
                    if(currentGroupName.equals('XS_Public_Delegate_users') 
                            || currentGroupName.equals('XS_Delegate_Users')){
                        if(currentGroupName.equals('XS_Public_Delegate_users'))
                            if(userGroupNames.contains('XS_Delegate_Users')){
                                errorMessage = 'Since selected User is already a member'
                                    + ' of Private Delegate Users group, kindly remove '
                                    + 'the existing membership in order to proceed.';
                                displayError = TRUE;
                                return;
                            }
                        if(currentGroupName.equals('XS_Delegate_Users'))
                            if(userGroupNames.contains('XS_Public_Delegate_users')){
                                errorMessage = 'Since selected User is already a member'
                                    + ' of Public Delegate Users group, kindly remove'
                                    + ' the existing membership in order to proceed.';
                                displayError = TRUE;
                                return;
                            }
                    } else if(currentGroupName.equals('XS_Private_Side_Users') 
                                    || currentGroupName.equals('XSell_Normal_User')){
                        if(currentGroupName.equals('XS_Private_Side_Users'))
                            if(userGroupNames.contains('XSell_Normal_User')){
                                errorMessage = 'Since selected User is already a member'
                                    + ' of Normal Users group, kindly remove the'
                                    + ' existing membership in order to proceed.';
                                displayError = TRUE;
                                return;
                            }
                        if(currentGroupName.equals('XSell_Normal_User'))
                            if(userGroupNames.contains('XS_Private_Side_Users')){
                                errorMessage = 'Since selected User is already a member'
                                    + ' of Private Side Users group, kindly remove the'
                                    + ' existing membership in order to proceed.';
                                displayError = TRUE;
                                return;
                            }
                    }
                }
            }
        }
        displayError = FALSE;
      
        usr.FirstName= usr.Name.split(' ')[0];
        usr.LastName= usr.Name.split(' ')[1];
        usr.ReceivesInfoEmails = TRUE;
        users.add(usr.clone(TRUE,FALSE,FALSE,FALSE));
        isSaveDisabled = FALSE;
        wrapper w = new wrapper();
        w.usr = usr.clone(TRUE, FALSE, FALSE, FALSE);
        wrapperlist.add(w);
        
        
    }
    
    private String myPermissionSetId{get;set;}
    private List<PermissionSetAssignment> assignPermissionSet(String name, Set<Id> userIds){
        myPermissionSetId = NULL;
        system.debug('name: '+name);
        List<PermissionSetAssignment> returnVal = new List<PermissionSetAssignment>();
        this.searchPermissionSet(name);
        if(myPermissionSetId == NULL)
            return NULL;
        for(Id userId: userIds){
            returnVal.add(new PermissionSetAssignment(PermissionSetId = myPermissionSetId, AssigneeId = userId));
        }
        return returnVal; 
    }
    
    private void searchPermissionSet(String name){
        system.debug('name: '+name);
        PermissionSet ps = [SELECT Id,Name FROM PermissionSet where name=: name LIMIT 1];
        if(ps <> NULL)
            myPermissionSetId = ps.Id;
        
    }
    
    public List<PermissionSetAssignment> removePermissionSetAssignment(String name, Set<Id> userIds){
        myPermissionSetId = NULL;
        List<PermissionSetAssignment> returnVal = new List<PermissionSetAssignment>();
        this.searchPermissionSet(name);
        if(myPermissionSetId == NULL)
            return NULL;
        returnVal = [SELECT AssigneeId, Id, PermissionSetId FROM PermissionSetAssignment 
                     WHERE AssigneeId IN: userIds and PermissionSetId=:myPermissionSetId];
        return returnVal; 
        
        
    }
    
    @future
    private static void deleteGroupMembers(Set<Id> userIds){
        List<GroupMember> grpList = new List<GroupMember>();
        
        for(Id userId: userIds){
            grpList.add(new GroupMember(Id = userId));
        }
        Database.delete(grpList);
    }
    
    @future
    private static void deletePermissions(Set<Id> pIds){
        List<PermissionSetAssignment> pList = new List<PermissionSetAssignment>();
        
        for(Id pId: pIds){
            pList.add(new PermissionSetAssignment(Id = pId));
        }
        Database.delete(pList);
    }
    
    @future
    private static void insertGroupMembers(String userIds){
        List<GroupMember> grpList = (List<GroupMember>)JSON.deserialize(userIds, List<GroupMember>.class);
        
        /* for(Id userId: userIds){
grpList.add(new GroupMember(Id = userId));
} */
        if(!Test.isRunningTest())
            Database.insert(grpList);
    }
    
    @future
    private static void insertPermissions(String pIds){
        List<PermissionSetAssignment> pList = 
            (List<PermissionSetAssignment>)JSON.deserialize(pIds, List<PermissionSetAssignment>.class);
        
        /* for(Id pId: pIds){
pList.add(new PermissionSetAssignment(Id = pId));
} */
        // try{
        
        if(!Test.isRunningTest())
            Database.insert(pList);
        //}catch(Exception ex){
        //  ApexPages.addMessages(ex);
        //}
    }
    
    public class Wrapper{
        public User usr{get;set;}
        public Employee__c emp{get;set;}
        
        public wrapper(){}
        
        public wrapper(User usr, Employee__c emp){
            this.usr = usr;
            this.emp = emp;
        }
    }
}