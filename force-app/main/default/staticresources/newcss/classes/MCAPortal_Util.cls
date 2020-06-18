public class MCAPortal_Util {
    Public static Boolean isApprover(){
        List<GroupMember> grpMembers = [ SELECT group.DeveloperName FROM  GroupMember WHERE  Group.Type = 'Regular' 
                                        and group.DeveloperName = 'MCA_Americas_Approvers'
                                        AND UserOrGroupId =:userinfo.getuserid()];
        if(grpMembers != NULL && grpMembers.size() > 0){
            return true;
        }
        return false;
    }
    
    Public static List <MCARequest__c> getMCASingleRecord( String rID){
        List <MCARequest__c> X=[select id,Status__c from MCARequest__c where id =: rID limit 1];
        if(X!= NULL && X.size() > 0 ){
            return X;
        }
        return null;
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
    
     public static boolean checkIfAdmin() {
		List<PermissionSetAssignment> permissions = [SELECT Id, PermissionSet.Name, AssigneeId
													FROM PermissionSetAssignment
                                                     WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'MCA_Admin'];
		system.debug('##permissions' + permissions);

		if(!permissions.isEmpty() && permissions!=null){
			return true;
		}
		else {
			return false;
		}
	}
    
    
}