/* batch that will assign the projects to the corresponding users
The project and the user ids will be loaded in to the object*/
global class SharePrjtWithUsr_Batch implements Database.Batchable<SObject>{
    
    List<Project__share> prjShareList;
    public String queryStr = 'SELECT User_Emp_Id__c,User_ID__c,Project_Name__c,Project_ID__c FROM Share_Projects_with_User__c';
    
    global Database.QueryLocator start(Database.BatchableContext c){
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext c, List<Share_Projects_with_User__c> allRecs){
        prjShareList = new List<Project__share>();
        if(allRecs != null && !allRecs.isEmpty()){
            for(Share_Projects_with_User__c rec : allRecs){
                if(!String.isEmpty(rec.Project_ID__c) && !String.isEmpty(rec.User_ID__c)){
                    Project__share prjShr = new Project__share();
                    prjShr.ParentId  = (rec.Project_ID__c).trim();
                    prjShr.UserOrGroupId = (rec.User_ID__c).trim();
                    prjShr.RowCause = 'Manual';
                    prjShr.AccessLevel = 'Edit';
                    prjShareList.add(prjShr);
                } 
            }
        }
        if(prjShareList != null && !prjShareList.isEmpty()){
            try{
                Database.SaveResult[] results = Database.insert(prjShareList,false);
                List<Project__share> insertedPrjList = new List<Project__share>(prjShareList);
                for(Integer i = 0 ; insertedPrjList.size() > i ; i++){
                    Database.SaveResult result = results[i];
                    Project__share eachRec = insertedPrjList[i];
                    if(!result.isSuccess()){
                        for(Database.Error err : result.getErrors()){
                            system.debug('*** ERROR INSERTING SNR SHARED RECORDS *** ' + err);
                        }
                    }
                }
            }
            catch(Exception exp){
                system.debug(' -- Exception while inserting PROJECT SHARE RECORDS -- ' + exp);
            }
        }
    }
    
    global void finish(Database.BatchableContext c){
       // do nothing
    }
}