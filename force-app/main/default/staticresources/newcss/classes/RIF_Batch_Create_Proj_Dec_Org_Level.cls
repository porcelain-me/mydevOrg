public class RIF_Batch_Create_Proj_Dec_Org_Level implements Database.Batchable<sObject>,Database.Stateful{
    private Child_Project_Decisional_Unit__c childDecUnitRecord;
    private String queryString;
    private integer numberOfEmployees=0;
    public RIF_Batch_Create_Proj_Dec_Org_Level (string queryString,Child_Project_Decisional_Unit__c childDecUnitRecord){
        this.queryString=queryString;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(queryString);
    }
 
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        // do your updating here
        for(sObject s : scope){
            numberOfEmployees+=numberOfEmployees;
        }
        
    }
 
    public void finish(Database.BatchableContext BC){
        childDecUnitRecord.Total_Employees__c=numberOfEmployees;
        upsert childDecUnitRecord;
        
 
    }
}