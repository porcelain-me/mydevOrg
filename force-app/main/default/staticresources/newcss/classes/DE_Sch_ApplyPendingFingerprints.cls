global class DE_Sch_ApplyPendingFingerprints implements Schedulable{
   
    global void execute(SchedulableContext SC) {
        if(!Test.isRunningTest()){
            DE_Batch_ApplyPendingFingerprints penFinPrints= new DE_Batch_ApplyPendingFingerprints();
            Database.executeBatch(penFinPrints);
        }
    }

}