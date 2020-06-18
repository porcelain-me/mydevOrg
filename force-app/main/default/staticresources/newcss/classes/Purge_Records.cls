global without sharing class Purge_Records implements Database.Batchable<SObject> {
     /*** 
       *  Description : Class to delete Records       *

       *
      ***/
      
    /*** To Run this Class From the Console:
    
    (1) TO DELETE 3000 EMPTY CDM RECORDS 
    id batchId = Database.executeBatch(new Purge_Records('Contact', ' Contact__c = Null AND Research_Document_Metadata__c = Null ', 3000 ), 200);
    System.debug('\n\n==> batchId = ' + batchId); 
    
    (2) TO DELETE ALL EMPTY CDM RECORDS 
    id batchId = Database.executeBatch(new Purge_Records('Contact_Document_Match__c', ' Contact__c = Null AND Research_Document_Metadata__c = Null '), 200);
    System.debug('\n\n==> batchId = ' + batchId); 
        
    
    
    ***/
    
    private String SOBJECT_NAME = ' ' ;
    
    private String  WHERE_CLAUSE =' WHERE  ' ; 
    
    private String  LIMIT_CLAUSE =' LIMIT 0 ';
    
    // default constructor
    public Purge_Records(String ObjectName, string WhereClause) {
        
        SOBJECT_NAME = ObjectName;
        WHERE_CLAUSE = ' WHERE ' + WhereClause;
        LIMIT_CLAUSE =' ';
        
    }
    
  
    public Purge_Records(String ObjectName, string WhereClause,Integer numberOfRecordsToDelete) {
        
        SOBJECT_NAME = ObjectName;
        WHERE_CLAUSE = ' WHERE ' + WhereClause;
        LIMIT_CLAUSE = ' LIMIT ' + numberOfRecordsToDelete;
    }
    
    
    
    
    
    /***** START *****/
    global Database.QueryLocator start(Database.BatchableContext context){
        
         Database.QueryLocator recordSet = Database.getQueryLocator('select id from ' + SOBJECT_NAME + WHERE_CLAUSE + LIMIT_CLAUSE);
         
         System.debug('select id from ' + SOBJECT_NAME + WHERE_CLAUSE + LIMIT_CLAUSE);
         return recordSet;      
        
    }
    
    /***** EXECUTE *****/
    global void execute(Database.BatchableContext context, List<SOBject> objects) {
        //Delete the rows
        delete objects;
        //Delete Permanently. cannot be undeleted
        Database.emptyRecycleBin(objects);
    }
    
    
    /***** FINISH *****/
    global void finish(Database.BatchableContext context) {
        //To Do: Call the scheduled batch again or run the execute method of the scheduled batch
        //which will invoke this class for the next applicable object to purge
    }
    
}