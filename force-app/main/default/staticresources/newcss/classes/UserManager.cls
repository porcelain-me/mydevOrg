// 09/05/2013 : MG : created two methods getSuperDivisionMapping, getCaseTeamMapping.
public without sharing class UserManager {
    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    public static void createPublicGroupMemberships(map<Id, User> newMap, map<Id, User> oldMap,
                                                             boolean isInsert, boolean isUpdate, boolean isDelete, boolean isBefore){
        //Id sysAdminProfileId = RIF_DataUtil.getProfileId(SYSTEM_ADMINISTRATOR);
        
        map<Id,Set<Id>> mapUserIdSetNewGroupIds = new map<Id,Set<Id>>();
        map<Id,Set<Id>> mapUserIdSetOldGroupIds = new map<Id,Set<Id>>();
        Map<String, String> superDivisionMapping = getSuperDivisionMapping();
        Map<String, String> erCaseTeamMapping = getCaseTeamMapping();
        List<String> superDivisionList;
        List<String> caseTeamList;
        for(User u : newMap.values()){
            //if(sysAdminProfileId == u.ProfileId) continue;
                if(isInsert || (isUpdate && oldMap.get(u.Id).RIF_Allow_Super_Division__c != u.RIF_Allow_Super_Division__c)){
                    if(u.RIF_Allow_Super_Division__c != NULL && u.RIF_Allow_Super_Division__c != ''){ 
                        superDivisionList = u.RIF_Allow_Super_Division__c.split(';');
                        if(!mapUserIdSetNewGroupIds.containsKey(u.Id)){
                            mapUserIdSetNewGroupIds.put(u.Id, new Set<Id>());   
                        }
                        for(String superDivision : superDivisionList){
                            String publicGroupId = superDivisionMapping.get(superDivision.tolowerCase());                   
                            if(publicGroupId != NULL)
                              mapUserIdSetNewGroupIds.get(u.Id).add(publicGroupId);
                        }
                    }
                    if((isUpdate && oldMap.get(u.Id).RIF_Allow_Super_Division__c != NULL
                         && oldMap.get(u.Id).RIF_Allow_Super_Division__c != u.RIF_Allow_Super_Division__c)){
                        superDivisionList = oldMap.get(u.Id).RIF_Allow_Super_Division__c.split(';');
                        if(!mapUserIdSetOldGroupIds.containsKey(u.Id)){
                            mapUserIdSetOldGroupIds.put(u.Id, new Set<Id>());   
                        }
                        for(String superDivision : superDivisionList){
                            String publicGroupId = superDivisionMapping.get(superDivision.toLowerCase());                   
                            if(publicGroupId != NULL)
                              mapUserIdSetOldGroupIds.get(u.Id).add(publicGroupId);
                        }
                    }
                }
                if(isInsert || (isUpdate && oldMap.get(u.Id).ER_Case_Team_Allowed__c != u.ER_Case_Team_Allowed__c)){
                    if(u.ER_Case_Team_Allowed__c != NULL && u.ER_Case_Team_Allowed__c != ''){
                        caseTeamList = u.ER_Case_Team_Allowed__c.split(';');
                        if(!mapUserIdSetNewGroupIds.containsKey(u.Id)){
                            mapUserIdSetNewGroupIds.put(u.Id, new Set<Id>());   
                        }
                        for(String caseTeam : caseTeamList){
                            String publicGroupId = erCaseTeamMapping.get(caseTeam.tolowerCase());                   
                            if(publicGroupId != NULL)
                              mapUserIdSetNewGroupIds.get(u.Id).add(publicGroupId);
                        }
                    }
                    if((isUpdate && oldMap.get(u.Id).ER_Case_Team_Allowed__c != NULL
                         && oldMap.get(u.Id).ER_Case_Team_Allowed__c != u.ER_Case_Team_Allowed__c)){
                        caseTeamList = oldMap.get(u.Id).ER_Case_Team_Allowed__c.split(';');
                        if(!mapUserIdSetOldGroupIds.containsKey(u.Id)){
                            mapUserIdSetOldGroupIds.put(u.Id, new Set<Id>());   
                        }
                        for(String caseTeam : caseTeamList){
                            String publicGroupId = erCaseTeamMapping.get(caseTeam.tolowerCase());                   
                            if(publicGroupId != NULL)
                              mapUserIdSetOldGroupIds.get(u.Id).add(publicGroupId);
                        }
                    }
                }
        }        
        
        if(mapUserIdSetNewGroupIds.isEmpty() && mapUserIdSetOldGroupIds.isEmpty()){           
            return;
        }else{
            Set<String> setUserIdSetNewGroupIds = new Set<String>();
            Set<String> setUserIdSetOldGroupIds = new Set<String>(); 
            
            for(Id userId : mapUserIdSetNewGroupIds.keyset()){
                Set<Id> groupIds = mapUserIdSetNewGroupIds.get(userId);
                for(Id groupId : groupIds){
                    setUserIdSetNewGroupIds.add(userId + '~' + groupId);
                }
            }
            
            for(Id userId : mapUserIdSetOldGroupIds.keyset()){
                Set<Id> groupIds = mapUserIdSetOldGroupIds.get(userId);
                for(Id groupId : groupIds){
                    setUserIdSetOldGroupIds.add(userId + '~' + groupId);
                }
            }
            
            manageGroupMembership(setUserIdSetNewGroupIds, setUserIdSetOldGroupIds);
        }    
    }
    
    @future
    public static void manageGroupMembership(Set<String> setUserIdSetNewGroupIds, Set<String> setUserIdSetOldGroupIds){
        map<Id, Set<Id>> mapUserIdSetNewGroupIds = new map<Id, Set<Id>>();
        map<Id,Set<Id>> mapUserIdSetOldGroupIds = new  map<Id,Set<Id>>();
        
        for(String str : setUserIdSetOldGroupIds){
            List<String> arr = str.split('~');
            String userId = arr[0];
            String groupId = arr[1];
            if(mapUserIdSetOldGroupIds.containsKey(userId)){
                mapUserIdSetOldGroupIds.get(userId).add(groupId);
            }else {
                mapUserIdSetOldGroupIds.put(userId,new Set<id>{groupId});
            }            
        }
        
        for(String str : setUserIdSetNewGroupIds){
            List<String> arr = str.split('~');
            String userId = arr[0];
            String groupId = arr[1];
            if(mapUserIdSetNewGroupIds.containsKey(userId)){
                mapUserIdSetNewGroupIds.get(userId).add(groupId);
            }else {
                mapUserIdSetNewGroupIds.put(userId,new Set<id>{groupId});
            }            
        }
        
        List<GroupMember> listGroupmembersToInsert = new list<GroupMember>();
        
        List<GroupMember> listGroupMembersToDelete = new list<GroupMember>();
        list<GroupMember> grpList = getExistingGroupMembers(mapUserIdSetOldGroupIds);
        
        system.debug('Jitendra_Group List: '+grpList);
        
        for(GroupMember member : grpList){
            Id userId = member.UserOrGroupId;
            if(mapUserIdSetOldGroupIds.containsKey(userId)){
                for(Id GroupId : mapUserIdSetOldGroupIds.get(userId)){
                    if(groupId == member.groupId){
                        listGroupMembersToDelete.add(member);
                        break; 
                    }
                }
            }
        }  
        system.debug('Jitendra List for delete: '+listGroupMembersToDelete);
        // create new Group Member's List
        for(Id userId : mapUserIdSetNewGroupIds.keySet()){
            for(Id groupId : mapUserIdSetNewGroupIds.get(userId)){
                GroupMember newMember = createGroupMember(userId, groupId);
                listGroupmembersToInsert.add(newMember);
            }
            
        }
        system.debug('Jitendra_Group List for Insert: '+listGroupmembersToInsert);
        // delete old profile group members
        deleteGroupMembers(listGroupMembersToDelete);
        
        // insert new profile group memebers
        insertGroupMembers(listGroupmembersToInsert);
    }
    
    public static Map<String, String> getCaseTeamMapping(){
        Map<String, String> caseTeamMapping = new Map<String, String>();
        List<ER_Public_Group_to_Team_Mapping__c> caseTeamList = ER_Public_Group_to_Team_Mapping__c.getAll().values();
        Set<String> publicGroupNameSet = new Set<String>();
        for(ER_Public_Group_to_Team_Mapping__c caseTeam : caseTeamList){
            publicGroupNameSet.add(caseTeam.Public_Group_Name__c);
        }
        Map<String, String> publicGroupMapping = new Map<String, String>();
        for(Group pg : [SELECT Id, Name FROM Group WHERE Name IN :publicGroupNameSet]){
            publicGroupMapping.put(pg.Name.toLowerCase(), pg.Id);
        }
        for(ER_Public_Group_to_Team_Mapping__c caseTeam : caseTeamList){
            if(caseTeam.Team_Name__c != NULL && caseTeam.Public_Group_Name__c != NULL){
              caseTeamMapping.put(caseTeam.Team_Name__c.toLowerCase(), publicGroupMapping.get(caseTeam.Public_Group_Name__c.toLowerCase()));
            }
        }
        return caseTeamMapping;
    }
    
    public static Map<String, String> getSuperDivisionMapping(){
    	Map<String, String> superDivisionMapping = new Map<String, String>();
    	List<RIF_PB_SuperDivision_Mapping__c> superDivisionList = RIF_PB_SuperDivision_Mapping__c.getAll().values();
    	Set<String> publicGroupNameSet = new Set<String>();
    	for(RIF_PB_SuperDivision_Mapping__c superdivision : superDivisionList){
            publicGroupNameSet.add(superdivision.Public_Group__c);
        }
        Map<String, String> publicGroupMapping = new Map<String, String>();
        for(Group pg : [SELECT Id, Name FROM Group WHERE Name IN :publicGroupNameSet]){
        	publicGroupMapping.put(pg.Name.toLowerCase(), pg.Id);
        }
        for(RIF_PB_SuperDivision_Mapping__c superdivision : superDivisionList){
        	if(superdivision.Super_Division__c != NULL && superdivision.Public_Group__c != NULL){
    		  superDivisionMapping.put(superdivision.Super_Division__c.tolowerCase(), publicGroupMapping.get(superdivision.Public_Group__c.toLowerCase()));
        	}
    	}
    	return superDivisionMapping;
    }
    
    public static User getUserDetails(Id userId){
        User user = [SELECT Id, RIF_Allow_Super_Division__c, Profile.Name, ER_Case_Team_Allowed__c FROM User WHERE Id = :userId limit 1];
        return user;
    }
    
    public static list<User> getUserDetailsOnUserIds(list<string> userIds){
        return [SELECT Id, RIF_Allow_Super_Division__c, Profile.Name, ER_Case_Team_Allowed__c FROM User WHERE Id in :userIds]; 
    }
    
    public static list<GroupMember> getExistingGroupMembers(Map<Id,Set<Id>> mapUserIdListGroupIds){
    // This method returns list of existing GroupMembers.
    // mapUserIdGroupId : map of UserId and GroupId.
        Set<Id> allGroupIds = new Set<Id>();
        for(Set<Id> groupIds : mapUserIdListGroupIds.values()){
            allGroupIds.addAll(groupIds);
        }
            
        return getExistingGroupMembers(allGroupIds, mapUserIdListGroupIds.keySet());
               
    }
    
    public static list<GroupMember> getExistingGroupMembers(Set<Id> allGroupIds, Set<Id> userIds){
    // This method returns list of existing GroupMembers.
    // mapUserIdGroupId : map of UserId and GroupId.        
        return [Select GroupId,UserOrGroupId from GroupMember 
                                        where GroupId in :allGroupIds 
                                        and UserOrGroupId in : userIds]; 
    }
    
    public static GroupMember createGroupMember(Id userOrGroupId, Id groupId){
        // this method creates group member
        return new GroupMember(UserOrGroupId = userOrGroupId, GroupId = groupId);
    }
    
    public static void deleteGroupMembers(list<GroupMember> listGroupMembersToDelete){
    // Delete list of existing Group Member Records from database.
        if(!listGroupMembersToDelete.isEmpty()){           
             Database.DeleteResult[] ldR = Database.delete(listGroupMembersToDelete, false);
            // Process the delete results
            List<String> errorMessages = new List<String>();
            for(Database.DeleteResult dr : ldR){
                if(!dr.isSuccess()){
                    Database.Error err = dr.getErrors()[0];   
                    System.debug('Unable to insert Group Member record due to following exception:' + err.getMessage());             
                }            
            }
         }    
    }
    
    public static void insertGroupMembers(list<GroupMember> listGroupMembersToInsert){
    // insert new group members into database.
        if(!listGroupMembersToInsert.isEmpty()){
            Database.SaveResult[] lsr = Database.insert(listGroupMembersToInsert, false);
            List<String> errorMessages = new List<String>();        
            // Process the save results
            for(Database.SaveResult sr : lsr){
              if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
                System.debug('Unable to insert Group Member record due to following exception:' + err.getMessage());
              }            
            }
        }
    }
}