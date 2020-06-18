global class PP_ScheduleAllBatches implements Schedulable {
global Integer batchSize{get;set;} {batchSize = 200;}

    global void execute(SchedulableContext sc) {      
        // run the reminder mails for pending approval
        PP_ApproverReminder approverReminderBatch = new PP_ApproverReminder();       
        database.executebatch(approverReminderBatch, batchSize);   
        
        // run the batch to auto cancel unapproved requests
        pp_UpdateUnApprovedRequest autoCancelBatch = new pp_UpdateUnApprovedRequest();
        database.executebatch(autoCancelBatch, batchSize);   

        // run the batch to auto close approved requests
        PP_AutoCloseRequest autoCloseBatch = new PP_AutoCloseRequest();
        database.executebatch(autoCloseBatch, batchSize);        
    }
}