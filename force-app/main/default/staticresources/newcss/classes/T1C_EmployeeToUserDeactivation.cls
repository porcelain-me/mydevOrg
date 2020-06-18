public class T1C_EmployeeToUserDeactivation {
    //Updating target list in saperate method because of Mix DML issue
    public static void DeactivateTargetList(Set<String> userIdSet){
        
        List<Target_List__c> toBeDeactivateTargetLst = new List<Target_List__c>(); //Stores target lists to be deactivate
        
        String newEmployeeStatus = 'Inactivated ' + Datetime.now().format('MM/dd/yyyy');
        
        //Update status on target list 
        for(Target_List__c targetList : [Select Id, iiCampaign__r.Active_Flag__c , Employee_Status__c,User__c From Target_List__c where User__c IN :userIdSet]){
            
            if(targetList.iiCampaign__r.Active_Flag__c == true){
                targetList.Employee_Status__c = newEmployeeStatus;
                toBeDeactivateTargetLst.add(targetList);
            }
        }
        
        
        if(toBeDeactivateTargetLst != null && toBeDeactivateTargetLst.size() > 0){
                update toBeDeactivateTargetLst;
        }
        
             
    }

}