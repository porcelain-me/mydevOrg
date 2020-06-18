global class DE_FeedBatch implements Database.Batchable<sObject>{

    private final String query ;
    global DE_FeedBatch (String q){
        query = q;
        }
        
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

     global void execute(Database.BatchableContext BC, List<sObject> scope){
     }
     
     global void finish(Database.BatchableContext BC){
     }
}