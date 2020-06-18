global class cleanOrgHierBATCH implements Database.Batchable<sObject>{
    global List<Org_Hierarchy__c> start(Database.BatchableContext bc){
        List<Org_Hierarchy__c> orgHierList = [SELECT Id FROM Org_Hierarchy__c LIMIT 50000];
        return orgHierList;
    }
    
    global void execute(Database.BatchableContext bc, List<Org_Hierarchy__c> orgHierList){
        if(!orgHierList.isEmpty()){
            Database.delete(orgHierList);
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
}