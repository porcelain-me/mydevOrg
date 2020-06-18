/** Scheduler class for RIF Org Hierarchy reorg 
Schedules the batch class :- RIF_OrgHierarchySharingRecalBatch **/
global class RIF_ReorgBatch_Scheduler implements Schedulable {
    // execute the batch
    global void execute(SchedulableContext SC) {
        Id batchInstanceId = Database.executeBatch(new RIF_OrgHierarchySharingRecalBatch(), 200);
    }
}