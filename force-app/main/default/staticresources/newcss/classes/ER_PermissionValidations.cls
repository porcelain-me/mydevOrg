// 07/25/2013 RJ: Created ORIGINAL 
//                BUSINESS LOGIC FOR ER PERMISSIONS 
//
//
// 08/30/2013 : MG : Added validation for Party Involved deletion HRFORCE-194.
// 09/13/2013 : MG : Removed Logic for Note Object
// 10/04/2013 : DP : Added validation for Users with "Compliance - Firmwide - Read/Write" permission 
//                   should be the only once to create case for "Compliance - Firmwide" Team 
public without sharing class ER_PermissionValidations {
  private static final string CLOSE_STATUS = 'Closed';
  private static final string COMPLIANCE_FIRMWIDE_PERMISSION = 'Compliance - Firmwide - Read/Write';
  private static final string COMPLIANCE_FIRMWIDE_TEAM = 'Firmwide';
  
  public static void handleTrigger(List<SObject> triggerNew, map<Id,SObject> triggerOldMap,
                                                     boolean isInsert, boolean isUpdate, boolean isDelete
                                                     , boolean isBefore){
     
    if((triggerNew.getSObjectType() == Case__c.Sobjecttype) || (triggerOldMap.size() > 0 && triggerOldMap.getSObjectType() == Case__c.Sobjecttype)){ 
      validatePermissions_ERCaseObject(triggerNew, triggerOldMap, isInsert, isUpdate, isDelete, isBefore);
    }else if((triggerNew.getSObjectType() == Attachment.Sobjecttype) || (triggerOldMap.size() > 0 && triggerOldMap.getSObjectType() == Attachment.Sobjecttype)){
        validatePermissions_ERAttachmentObject(triggerNew, triggerOldMap, isInsert, isUpdate, isDelete, isBefore);
    }else if((triggerNew.getSObjectType() == Note.Sobjecttype) || (triggerOldMap.size() > 0 && triggerOldMap.getSObjectType() == Note.Sobjecttype)){
        validatePermissions_ERNoteObject(triggerNew, triggerOldMap, isInsert, isUpdate, isDelete, isBefore);
    }else{
        validatePermissions_ERCaseChildObjects(triggerNew, triggerOldMap, isInsert, isUpdate, isDelete, isBefore);
    } 
  }
   
  public static void validatePermissions_ERCaseObject(List<SObject> triggerNew, map<Id,SObject> triggerOldMap, 
                                           boolean isInsert, boolean isUpdate, boolean isDelete
                                                     , boolean isBefore){ 
        list<string> teamList = new list<string>();                                                 
        User currentUser = ER_DataUtil.getUserDetails(userInfo.getUserId());
        /*JIRA : ERCM-18 : removing the dependency of user.ER_Case_Team_Allowed__c */                                                         
        teamList = getGroupsForUser(currentUser.id);                                                                                                
        if(teamList.size() > 0)    
        currentUser.ER_Case_Team_Allowed__c = commaSeparatedString(teamList).toLowerCase(); 
        else
        currentUser.ER_Case_Team_Allowed__c = '';    
        
        ER_Permissions__c permissions = ER_Permissions__c.getInstance();
        list<string> ownerId = new list<string>();
        system.debug(currentUser.ER_Case_Team_Allowed__c);
        if((isUpdate || isInsert) && isBefore){
            for(Case__c erCase : (list<Case__c>)triggerNew){
                if(erCase.Team__c != Null && currentUser.ER_Case_Team_Allowed__c <> null){
                system.debug(currentUser.ER_Case_Team_Allowed__c);
                system.debug(erCase.Team__c);
                    if(currentUser.ER_Case_Team_Allowed__c.contains(erCase.Team__c.toLowerCase())){
                        ownerid.add(erCase.OwnerId);
                        continue;
                    }
                }
                erCase.Team__c.addError(Label.ER_CaseCreationUpdation);
            }
        }
        
      //  map<id, User> mapUser = new map<id, User>(ER_DataUtil.getUserDetailsOnUserIds(ownerid)); 
        map<id, User> mapUser = new map<id, User>(getUserInfoDetails(ownerid));
        system.debug('****** mapUser: '+mapUser);                                                                                                                 
        if((isUpdate || isInsert) && isBefore){
            for(Case__c erCase : (list<Case__c>)triggerNew){
                if(mapUser.ContainsKey(erCase.OwnerId) && 
                   mapUser.get(erCase.OwnerId).ER_Case_Team_Allowed__c <> null){
                       if (erCase.Team__c == COMPLIANCE_FIRMWIDE_TEAM && !mapUser.get(erCase.OwnerId).ER_Case_Team_Allowed__c.contains(COMPLIANCE_FIRMWIDE_PERMISSION)){
                            erCase.Team__c.addError(Label.ER_CaseCreationUpdationOwner);
                        }
                       else if (!mapUser.get(erCase.OwnerId).ER_Case_Team_Allowed__c.contains(erCase.Team__c)){
                            erCase.Team__c.addError(Label.ER_CaseCreationUpdationOwner);
                       }
                }
                if(isInsert && erCase.Status__c == CLOSE_STATUS && permissions.Is_ER_CaseLockedForCloseStatus__c){
                    erCase.addError(Label.ER_CaseCanNotCreateWithClosed);
                }
            }
        }
         
        if((isUpdate || isDelete)  && isBefore){
            if(isDelete && !permissions.Is_ER_CaseDeleteAllowed__c){                
                for (Case__c cOld: (List<Case__c>)triggerOldMap.values()){                  
                            cOld.addError(Label.ER_RecordLockedForDelete);                
                }
            }           
            if(isUpdate){ 
                for (Case__c cNew: (List<Case__c>)triggerNew){                  
                System.debug('flag -->   '+permissions.Is_ER_CaseLockedForCloseStatus__c);
                 System.debug('flag -->   '+triggerOldMap.get(cNew.Id).get('Status__c'));
                    if(triggerOldMap.get(cNew.Id).get('Status__c') == CLOSE_STATUS && permissions.Is_ER_CaseLockedForCloseStatus__c){
                        cNew.addError(Label.ER_RecordLockedForCloseStatus);
                    }  
                }
            }
        }
  } 
  
  public static void validatePermissions_ERAttachmentObject(List<SObject> triggerNew, map<Id, SObject> triggerOldMap, 
                                           boolean isInsert, boolean isUpdate, boolean isDelete, boolean isBefore){ 
    
    if((isUpdate || isDelete || isInsert)  && isBefore){
        ER_Permissions__c permissions = ER_Permissions__c.getInstance();
        List<Id> caseIds = new List<Id>();  
        map<Id, Case__c> mapCases; 
        List<Sobject> recordsList;
        boolean doLockTheRecord = false;
        doLockTheRecord = permissions.Is_ER_CaseAttachmentLockedForCloseStatus__c;
        
        recordsList = isDelete ? triggerOldMap.values() : triggerNew;
        String keyPrefix = Schema.SObjectType.Case__c.getKeyPrefix();
        for (Sobject attach : recordsList){
            if(attach.get('ParentId') != null && ((String)attach.get('ParentId')).contains(keyPrefix)){
                caseIds.add((Id)attach.get('ParentId'));
            }
        }
        mapCases = new map<id, Case__c>(ER_DataUtil.getCaseStatus(caseIds));
        
        for (Sobject attach : recordsList){              
            if(mapCases.get((Id)attach.get('ParentId')) != null && mapCases.get((Id)attach.get('ParentId')).Status__c == CLOSE_STATUS && doLockTheRecord){
                String message = (isInsert ? Label.ER_NewRecordLockedForCloseStatus : (isUpdate ? Label.ER_RecordLockedForCloseStatus : Label.ER_RecordLockedForDelete));
                attach.addError(message);  
            }
        }
    }    
    
    //Start- Added for RIF II changes on attachments before insert - Kumaresan M
    if(isInsert && isBefore){
        String QueryStr='select id,name,parentID from attachment where ';
        set<String> srAttachmentSet=new set<String>();
        set<String> AttachmentNameSet=new set<String>();
        
        String Prefix = Schema.SObjectType.Severance_And_Release__c.getKeyPrefix();
        
        if(Trigger.new != null && Trigger.new.size() >0){
            for(SObject each:Trigger.new){
                Attachment a=(Attachment)each;
                if(String.ValueOf(a.ParentId).startsWith(Prefix)){
                    srAttachmentSet.add(a.ParentId);
                    AttachmentNameSet.add(a.name);                    
                }
            }
            
            if(srAttachmentSet != null && srAttachmentSet.size() >0 && AttachmentNameSet != null && AttachmentNameSet.size() >0){
                  List<Attachment> delAttachment=[select id,name,parentId from attachment where parentId IN:srAttachmentSet AND name IN:AttachmentNameSet];
                  If(delAttachment != null && delAttachment.size() >0){
                      delete delAttachment;
                      delAttachment=null;
                  }                           
            }      
            
        }
    }       
    //End                                                
  }
  
  public static void validatePermissions_ERNoteObject(List<SObject> triggerNew, map<Id, SObject> triggerOldMap, 
                                           boolean isInsert, boolean isUpdate, boolean isDelete, boolean isBefore){ 
    
    if((isUpdate || isDelete || isInsert)  && isBefore){
        ER_Permissions__c permissions = ER_Permissions__c.getInstance();
        List<Id> caseIds = new List<Id>();  
        map<Id, Case__c> mapCases; 
        List<Sobject> recordsList;
        boolean doLockTheRecord = false;
        doLockTheRecord = permissions.Is_ER_CaseNoteLockedForCloseStatus__c;
        
        recordsList = isDelete ? triggerOldMap.values() : triggerNew;
        String keyPrefix = Schema.SObjectType.Case__c.getKeyPrefix();
        for (Sobject note : recordsList){
            if(note.get('ParentId') != null && ((String)note.get('ParentId')).contains(keyPrefix)){
                caseIds.add((Id)note.get('ParentId'));
            }
        }
        mapCases = new map<id, Case__c>(ER_DataUtil.getCaseStatus(caseIds));
        
        for (Sobject note : recordsList){              
            if(mapCases.get((Id)note.get('ParentId')) != null && mapCases.get((Id)note.get('ParentId')).Status__c == CLOSE_STATUS && doLockTheRecord){
                String message = (isInsert ? Label.ER_NewRecordLockedForCloseStatus : (isUpdate ? Label.ER_RecordLockedForCloseStatus : Label.ER_RecordLockedForDelete));
                note.addError(message);  
            }
        }
    }                                                       
  }
  
  public static void validatePermissions_ERCaseChildObjects(List<SObject> triggerNew, map<Id,SObject> triggerOldMap, 
                                           boolean isInsert, boolean isUpdate, boolean isDelete
                                                     , boolean isBefore){   
        if((isUpdate || isDelete || isInsert)  && isBefore){
            ER_Permissions__c permissions = ER_Permissions__c.getInstance();
            List<Id> caseIds = new List<Id>();  
            map<id, Case__c> mapCase; 
            List<Sobject> recordsList;
            boolean doLockTheRecord = false; 
            if((triggerNew.getSObjectType() == Parties_Involved__c.Sobjecttype) || (triggerOldMap.size() > 0 && triggerOldMap.getSObjectType() == Parties_Involved__c.Sobjecttype)){ 
              doLockTheRecord = permissions.Is_ER_PartiesInvolvedLockForCloseStatus__c;
            }
            // 10/04/2013 RA: Case Note Object is not required
            /*if((triggerNew.getSObjectType() == Case_Note__c.Sobjecttype) || (triggerOldMap.size() > 0 && triggerOldMap.getSObjectType() == Case_Note__c.Sobjecttype)){ 
              doLockTheRecord = permissions.Is_ER_CaseNoteLockedForCloseStatus__c;
            }*/
            
            if((triggerNew.getSObjectType() == Related_Cases__c.Sobjecttype) || (triggerOldMap.size() > 0 && triggerOldMap.getSObjectType() == Related_Cases__c.Sobjecttype)){
               doLockTheRecord = permissions.Is_ER_RelatedCasesLockedForCloseStatus__c;
            }
            
            if((triggerNew.getSObjectType() == Resolution__c.Sobjecttype) || (triggerOldMap.size() > 0 && triggerOldMap.getSObjectType() == Resolution__c.Sobjecttype)){
               doLockTheRecord = permissions.Is_ER_ResolutionLockedForCloseStatus__c;
            }
            
            recordsList = isDelete ?  triggerOldMap.values() : triggerNew;
            
            for (Sobject pi: recordsList){
                if(pi.get('Case__c') != null){
                    caseIds.add((Id)pi.get('Case__c'));
                }
            }
            // 10/04/2013 RA: As System Generated PI is not creating while Case record creation, below functionality is not required.
            /*// 08/30/2013 : MG : validation for party involved deletion. HRFORCE-194
            Set<Id> systemGeneratedPartiesInvolvedIds;
            if(isDelete && recordsList.getsObjectType() == Parties_Involved__c.Sobjecttype){
                systemGeneratedPartiesInvolvedIds = ER_DataUtil.getSystemGeneratedPartiesInvolvedIdsOnCaseIds(caseIds);
            }*/
            mapCase = new map<id, Case__c>(ER_DataUtil.getCaseStatus(caseIds));
            string currentUserProfileName = ER_DataUtil.getProfileNameForLoggedinUser();
            for (Sobject pI: recordsList){              
                if(mapCase.get((Id)pI.get('Case__c')) != null && mapCase.get((Id)pI.get('Case__c')).Status__c == CLOSE_STATUS && doLockTheRecord){
                    string message = (isInsert ? Label.ER_NewRecordLockedForCloseStatus : (isUpdate ? Label.ER_RecordLockedForCloseStatus : Label.ER_RecordLockedForDelete));
                    pI.addError(message);  
                }
                // 10/04/2013 RA: Case note object need to be deleted
                // 10/04/2013 RA: Resolution object has Case__c master detail relationship, need to remove PI relation from it
                /*// 08/30/2013 : MG : validation for party involved deletion. HRFORCE-194
                // 08/31/2013: RA: If user is system admin then he can delete any PI record without any validation running
                if(isDelete && recordsList.getsObjectType() == Parties_Involved__c.Sobjecttype){
                    Parties_Involved__c party = (Parties_Involved__c)pI;
                    if(currentUserProfileName != 'System Administrator'){
                        if(systemGeneratedPartiesInvolvedIds.contains(party.Id)){
                            party.addError(Label.ER_SystemGeneratedPartyInvolvedDeleteError);
                            continue;
                        }
                        if(party.Case_Notes_Count__c > 0 || party.Resolution_Count__c > 0){
                            party.addError(Label.ER_PartyInvolvedDeleteErrorForChildCount);
                        }
                    }
                }*/
            }
        }
    }
    
    public static String[] getGroupsForUser(Id userId){
    system.debug(userid);
        List<ER_Public_Group_to_Team_Mapping__c> caseTeamList = ER_Public_Group_to_Team_Mapping__c.getAll().values();
        set<string> setOfGroupUser = new set<string>();
        Set<String> publicGroupNameSet = new Set<String>();
        list<String> teamName = new list<String>();
        for(ER_Public_Group_to_Team_Mapping__c caseTeam : caseTeamList){
            publicGroupNameSet.add(caseTeam.Public_Group_Name__c);
        }
        Set<Id> groupIds = getGroupsForIds(new Set<Id>{userId});
        for(group resultList : [select Id, Name from Group where Id IN: groupIds AND Name IN :publicGroupNameSet]){
            setOfGroupUser.add(resultList.Name);
        }

        for(ER_Public_Group_to_Team_Mapping__c caseTeam : caseTeamList){
            if(setOfGroupUser.contains(caseTeam.Public_Group_Name__c)){
                teamName.add(caseTeam.Name);
            }
        }
        system.debug(teamname);
        if(teamName != null || teamName.size() > 0)
        return teamName;
        else
        return null;
    }

    // return all ids the user belongs to via direct or indirect membership
    public static Set<Id> getGroupsForIds(Set<Id> userOrGroupIds){
        Set<Id> output = new Set<Id>();
        Set<Id> nestedGroupIds = new Set<Id>();
        // only query actual groups and not roles and queues
        list<GroupMember> records = [ select id, GroupId , UserOrGroupId from GroupMember where UserOrGroupId =: userOrGroupIds and UserOrGroupId != null and Group.Type = 'Regular'];
        for (GroupMember record:records)
        {
            // found a group, remember for traversal
            if (!(record.UserOrGroupId + '').startsWith('005'))
            {
                nestedGroupIds.add(record.UserOrGroupId);   
            }
            else
            {
                output.add(record.GroupId);
            }
        }
    
        // call self to get nested groups we found
        if (nestedGroupIds.size() > 0)
        {
            output.addAll(getGroupsForIds(nestedGroupIds));
        }
        return output;
    }
    
     /* Function to return user member list from a group considering the custom setting value as well: MAQ*/
    public static list<user> getUserInfoDetails(list<id> userIds){
        system.debug('userIds :--->'+userIds);
        List<ER_Public_Group_to_Team_Mapping__c> caseTeamList = ER_Public_Group_to_Team_Mapping__c.getAll().values();
        Set<String> publicGroupNameSet = new Set<String>();
        for(ER_Public_Group_to_Team_Mapping__c caseTeam : caseTeamList){
            publicGroupNameSet.add(caseTeam.Public_Group_Name__c);
        }
        list<string> userGroupList= new list<string>();
        set<string> userGroupSet= new set<string>();
        list<GroupMember> records = [ select id, GroupId , UserOrGroupId, Group.Name from GroupMember where UserOrGroupId IN: userIds AND UserOrGroupId != null AND Group.Type = 'Regular' AND Group.Name IN :publicGroupNameSet];
        for(GroupMember GM : records){
        //userGroupList.add(GM.UserOrGroupId +'!~!'+GM.Group.Name);
        userGroupSet.add(GM.UserOrGroupId +'!~!'+GM.Group.Name);
        
        for(ER_Public_Group_to_Team_Mapping__c caseTeam : caseTeamList){
            if(caseTeam.Public_Group_Name__c == GM.Group.Name && GM.Group.Name <> null && caseTeam.Public_Group_Name__c <> null){
                userGroupList.add(GM.UserOrGroupId +'!~!'+caseTeam.Name);
            }
        }
        }
        
        List<user> ulist = New list<user>();
        for(User userVar :  [SELECT Id, RIF_Allow_Super_Division__c, Profile.Name, ER_Case_Team_Allowed__c FROM User WHERE Id in :userIds]){
         user u = new user(id = userVar.id);
         u.RIF_Allow_Super_Division__c = userVar.RIF_Allow_Super_Division__c;
         
         string gName = '';
         for(String str : userGroupList){
            String uID = str.split('!~!')[0];
            String gNameStr = str.split('!~!')[1];
            if(uID == userVar.id){
               gName += gNameStr+';';
            }   
         } 
         u.ER_Case_Team_Allowed__c = gName.removeEnd(';');
         ulist.add(u);
        }        
        return ulist;
    }
    /* Function to return String list in semicolon Separated string variable : MAQ*/
    public static String commaSeparatedString(list<String> ListVariable){
        String commaSeparatedValue = '';
        if(ListVariable.size() >0 && ListVariable != null){
            commaSeparatedValue = '';
            for(String var : ListVariable){
            commaSeparatedValue += var +';'; 
            }
            commaSeparatedValue.removeEnd(';');
            return commaSeparatedValue;
        }
        return null;
    }
}