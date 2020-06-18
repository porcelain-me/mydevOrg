Public class PP_ActivateUser{

    Public static void updateApproverUser(Id userID) {
        if(userID != null) {
            User check = [select id, isActive from user where id= :userId];
            if(check.isActive == false) {
                check.isActive = true;
                update check;
            }
        }                
    }
    
    Public static void updateWatcher(Id watcherId) {
    if(watcherId!= null) {
    system.debug('-----------WatchersUserID--------------'+watcherId);
            User check = [select id, isActive from user where id= :watcherId];
            if(check.isActive == false) {
                check.isActive = true;
                update check;
            }
        }                
    }
    
}