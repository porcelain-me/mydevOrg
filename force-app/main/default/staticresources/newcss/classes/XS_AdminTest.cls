@isTest
private class XS_AdminTest {
    
    public static void dataProvider(Set<String> names){
        
        list<Employee__c> emplist = new list<Employee__c>();
        for(String name: names){
            emplist.add(new Employee__c(Emp_ID__c = name));
        }
        Database.insert(emplist);
    }
    
    static testMethod void xsTest() {
        
        Set<String> names = new Set<String>();
        Set<Id> userIdSet = new Set<Id>();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', ReceivesInfoEmails= TRUE,
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
        
        names.add(tempUser.Alias);
        userIdSet.add(tempUser.Id);
        
        XS_Admin xa = new XS_Admin();
        xa.selectedGroup = xa.publicgroups[0].getValue();
            
        for(User userToAdd: 
               [SELECT Id, Alias, FirstName FROM User WHERE ID IN: XS_AdminTest.getUserList(xa.selectedGroup)]) {
            // for(User userToAdd:userList) {
            names.add(userToAdd.alias);
            userIdSet.add(userToAdd.Id);
        }
        dataProvider(names);
        
        Test.startTest();
        
            // XS_AdminTest.updateUser(userIdSet);
            xa.GetUserIdsFromGroups();
            xa.userId = xa.wrapperlist[0].usr.Id;
        
            xa.removeGroupMember();
            xa.addGroupMembers();
            // xa.removePermissionSetAssignment('test', userIdSet);
        
            XS_Admin.updateInactiveUsers(userIdSet);
        
        Test.stopTest();
    }
    
    static testMethod void addUserTest() {
        
        XS_Admin xa = new XS_Admin();
        Set<String> names = new Set<String>();
        
        String testName = '';
        boolean isAdded = false;
        
        Set<Id> userIdSet = new Set<Id>();
        
        Test.startTest();
            
            xa.selectedGroup = xa.publicgroups[0].getValue();
            
            for(User userToAdd: 
                    [SELECT Id, Alias, FirstName FROM User WHERE ID IN: XS_AdminTest.getUserList(xa.selectedGroup)]){
                names.add(userToAdd.alias);
                if(!isAdded){
                    isAdded = true;
                    testName = userToAdd.FirstName;
                }
                userIdSet.add(userToAdd.Id);
            }
            dataProvider(names);
        
            XS_AdminTest.updateUser(userIdSet);
        
            xa.GetUserIdsFromGroups();
            System.assert(xa.wrapperlist.size()>0);
        
            xa.userId = xa.wrapperlist[0].usr.Id;
            // Add logic
            xa.requesteeUser = testName;
            xa.filterUser();
            xa.usr = xa.userSearchList[0];
            // xa.usr.Name = 'abc xyz';//xa.userSearchList[0].Name;
            // xa.usr.id = xa.userSearchList[0].Id;
            xa.addUserElement();
            xa.addGroupMembers();
            xa.addUserElement();
            xa.removeGroupMember();
        Test.stopTest();
    }
    
    
    static testMethod void addDuplicateUserTest() {
        Test.startTest();
        XS_Admin xa = new XS_Admin();
        
        xa.selectedGroup = xa.publicgroups[0].getValue();
        Set<String> names = new Set<String>();
        String testName = '';
        boolean isAdded = false;
        for(User userToAdd: [SELECT Id, Alias, FirstName FROM User WHERE ID IN: XS_AdminTest.getUserList(xa.selectedGroup)]){
            names.add(userToAdd.alias);
            if(!isAdded){
                isAdded = true;
                testName = userToAdd.FirstName;
            }
        }
        dataProvider(names);
        xa.GetUserIdsFromGroups();
        System.assert(xa.wrapperlist.size()>0);
        xa.userId = xa.wrapperlist[0].usr.Id;
        
        
        // Add logic
        xa.requesteeUser = testName;
        xa.filterUser();
        // xa.usr = new user(firstName = xa.userSearchList[0].Name.split(' ')[0], lastName = xa.userSearchList[0].Name.split(' ')[1], id = xa.userSearchList[0].Id);
        xa.usr = xa.userSearchList[0];
        // xa.usr.Name = 'abc xyz';//xa.userSearchList[0].Name;
        // xa.usr.id = xa.userSearchList[0].Id;
        xa.addUserElement();
        xa.addUserElement();
        xa.addGroupMembers();
        
        Test.stopTest();
    }
    
    private static Set<Id> getUserList(String selectedGroup){
        Set<Id> result = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :selectedGroup]) {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType)) {
                result.add(m.UserOrGroupId);
            }
            
        }
        return result;
    }
    
    private static void updateUser(Set<Id> userIdSet) {
        
        List<User> userList = new List<User>();
        for(User tempUser: [SELECT Id, ReceivesInfoEmails FROM USER WHERE Id IN :userIdSet]) {
            if(!tempuser.ReceivesInfoEmails){
                tempuser.ReceivesInfoEmails = TRUE;
                userList.add(tempUser);
            }
        }
        
        Database.update(userList);
    }
}