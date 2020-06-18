global class DE_Batch_ApplyPendingLMS implements Database.Batchable<sObject>{

    //Query to get all the records from pending LMS object
    private final String query = 'select id,name,Dual_Employment_Training_Assigned_Date__c,Dual_Employment_Training_Complete_Date__c,MSID__c,LastModifiedDate from Dual_Employ_Pending_Training_Status__c ';
    public DE_Batch_ApplyPendingLMS (){        //Defining the constructor which is used in DE_Batch_ApplyPendingCarco to call this batch class
      
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Dual_Employ_Pending_Training_Status__c> pendingTrainingTable ){    //Batch class start
        //create a map for MSIDs 
        Map <string,Dual_Employ_Pending_Training_Status__c > mapMsIDsWithTrainingObj= new Map <string,Dual_Employ_Pending_Training_Status__c >();
       
        for(Dual_Employ_Pending_Training_Status__c TrainingObj: pendingTrainingTable ){
            mapMsIDsWithTrainingObj.put(TrainingObj.MSID__c,TrainingObj);
        }
            
        List<Employee__c> empToUpdate= new List<Employee__c>();
        List<Dual_Hat_Training_Status__c> addLMSRecords = new List<Dual_Hat_Training_Status__c>();
        
        Set <Dual_Employ_Pending_Training_Status__c> deleteProcessedRecords= new  Set<Dual_Employ_Pending_Training_Status__c> ();
        Dual_Employ_Pending_Training_Status__c pendingRecordBeingProcessed;
        
        for(Employee__c empToUpdateObj: [select id, Emp_ID__c, Dual_Hat_Eligible__c,Dual_Hat_Training_Complete_Date__c from Employee__c where Emp_ID__c IN:mapMsIDsWithTrainingObj.keyset()]){
            
            //Process the records only if the employee is dual employment eligible
            if(empToUpdateObj.Dual_Hat_Eligible__c){
            
                pendingRecordBeingProcessed = mapMsIDsWithTrainingObj.get(empToUpdateObj.Emp_ID__c);
                Dual_Hat_Training_Status__c lmsObj =  new Dual_Hat_Training_Status__c();
                
                //assign the field values from pending object to the main training object
                lmsObj .Employee__c = empToUpdateObj.id;
                lmsObj .Assigned_Date__c = pendingRecordBeingProcessed.Dual_Employment_Training_Assigned_Date__c;
                lmsObj .Completion_Date__c = pendingRecordBeingProcessed.Dual_Employment_Training_Complete_Date__c;
                
                //add the records to insertion list
                addLMSRecords .add(lmsObj );
                
                //add the records to delete list
                deleteProcessedRecords.add(pendingRecordBeingProcessed);
            }
        }
            
        if(addLMSRecords !=null && addLMSRecords .size()>0){
            insert addLMSRecords ;                            //insert the training object records
        }
        
        if(mapMsIDsWithTrainingObj!=null && mapMsIDsWithTrainingObj.size()>0){
        
            for(Dual_Employ_Pending_Training_Status__c pendObj: mapMsIDsWithTrainingObj.values()){
                
                Boolean sixMonthsOldFlag = false;
                //If(pendObj.Dual_Employment_Training_Complete_Date__c.addMonths(6) <= System.Today())
                //delete based on last 6 months i.e. LastModifiedDate                
                if(pendObj.LastModifiedDate.addMonths(6) <= System.Today())
                {
                    sixMonthsOldFlag = true;
                    }
                    else
                    {
                    sixMonthsOldFlag = false;
                    }
            
                //check whether the records are more than 6 months old
                if(sixMonthsOldFlag)
                {
                    deleteProcessedRecords.add(pendObj);        //add the records to processed list for further deletion
                }
            }
       
        }
        
        if(deleteProcessedRecords!=null && deleteProcessedRecords.size()>0){
             List <Dual_Employ_Pending_Training_Status__c> deletependingRecords = new  List <Dual_Employ_Pending_Training_Status__c> ();
             deletependingRecords.addAll(deleteProcessedRecords);
             delete deletependingRecords ;                       //delete the records from pending object
        }
    }            
    
    
    global void finish(Database.BatchableContext BC){
    }
    
    
}