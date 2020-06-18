global class DE_Sch_ApplyPendingLMS implements Schedulable{
   
    global void execute(SchedulableContext SC) {
    
        DE_Batch_ApplyPendingLMS pendLMS = new DE_Batch_ApplyPendingLMS('select id,name,Dual_Employment_Training_Assigned_Date__c,Dual_Employment_Training_Complete_Date__c,MSID__c from Dual_Employ_Pending_Training_Status__c');
        Database.executeBatch(pendLMS);
    }

}