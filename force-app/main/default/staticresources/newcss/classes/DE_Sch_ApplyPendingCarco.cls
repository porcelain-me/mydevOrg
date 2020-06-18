global class DE_Sch_ApplyPendingCarco implements Schedulable{
   
    global void execute(SchedulableContext SC) {
    
        DE_Batch_ApplyPendingCarco pendCarcos = new DE_Batch_ApplyPendingCarco('select id,name,Dual_Employment_FFIEC_Status__c,Dual_Hat_FFIEC_Status_Date__c,MSID__c from Dual_Employ_Pending_FFIEC_Status__c ');
        Database.executeBatch(pendCarcos );
    }

}