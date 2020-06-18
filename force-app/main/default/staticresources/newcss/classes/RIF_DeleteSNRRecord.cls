/** This class will handle the SNR deletes. 
** Deleting the SNR will only be done by RIF Super users, users in RIF System Admin public group and the Owner of the SNR **/

public without sharing class RIF_DeleteSNRRecord{
    public String snrId,userId,snrToDel;
    public String projectId {get; set;}
    Severance_and_Release__c snrRec;
    List<PermissionSetAssignment> permsSetUsersList = new List<PermissionSetAssignment>();
    List<GroupMember> groupMemberList = new List<GroupMember>();
    
    public RIF_DeleteSNRRecord(ApexPages.StandardController cont){
        snrId = cont.getId();
        snrToDel = ApexPages.currentPage().getParameters().get('snrToDel');
        userId = UserInfo.getUserId();
        if(snrId != null){
            snrRec = RIF_DataUtil.getSeveranceAndReleaseRecord(snrId);
            if(snrRec != null){
                projectId = snrRec.Project__c;
            }
        }
        else if(snrToDel != null){
            snrRec = RIF_DataUtil.getSeveranceAndReleaseRecord(snrToDel);
            if(snrRec != null){
                projectId = snrRec.Project__c;
            }
        }
    }
    
    public PageReference deleteRecord(){
        Set<String> allUserInPS = new Set<String>();
        // check if the user is a RIF Super user
        permsSetUsersList = [SELECT Id,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId IN (SELECT Id FROM PermissionSet WHERE Name = 'RIF_Super_User') AND AssigneeId =: userId];
        // check if the user belong to the RIF System Admin user group
        groupMemberList = [SELECT GroupId,UserOrGroupId FROM GroupMember WHERE GroupId IN (SELECT Id FROM Group WHERE DeveloperName = 'RIF_System_Admin') AND UserOrGroupId =: userId];
        // checks for all criteria
        if(snrRec != null && snrRec.OwnerId == userId || !permsSetUsersList.isEmpty() || !groupMemberList.isEmpty()){
            delete snrRec;
            if(snrId != null){
                return new PageReference('/' + projectId);
            }
            else if(snrToDel != null){
                return new PageReference('/apex/RIF_SelectSR_Print' + '?id=' + projectId);
            }
        }
        return null;
    }
    
}