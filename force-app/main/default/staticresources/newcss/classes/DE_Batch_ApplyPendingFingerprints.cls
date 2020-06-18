global class DE_Batch_ApplyPendingFingerprints implements Database.Batchable<sObject>{
    
    private final String query ='select id,name,Fingerprint_Date__c,GRL_CRD_Status__c,Status_Date__c,MSID__c,LastModifiedDate  from Dual_Emploloy_Pending_Fingerprint_Status__c';
    
    public DE_Batch_ApplyPendingFingerprints (){
         }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Dual_Emploloy_Pending_Fingerprint_Status__c> pendingFPrintTable ){
        //Create a map with MSIDs
        Map <string,Dual_Emploloy_Pending_Fingerprint_Status__c > mapMsIDsWithfingerprintObj= new Map <string,Dual_Emploloy_Pending_Fingerprint_Status__c >();
       
        for(Dual_Emploloy_Pending_Fingerprint_Status__c fingerPrintObj: pendingFPrintTable ){
            mapMsIDsWithfingerprintObj.put(fingerPrintObj.MSID__c,fingerPrintObj);
        }
       
        List<DH_GRLCRD__c> addGRLRecords= new List<DH_GRLCRD__c>();
        List<Employee__c> empToUpdate= new List<Employee__c>();
        
        Set <Dual_Emploloy_Pending_Fingerprint_Status__c > deleteProcessedRecords = new  Set<Dual_Emploloy_Pending_Fingerprint_Status__c > ();
        Dual_Emploloy_Pending_Fingerprint_Status__c pendingRecordBeingProcessed;
        
        for(Employee__c empToUpdateObj: [select id, Emp_ID__c, Dual_Hat_Eligible__c from Employee__c where Emp_ID__c IN:mapMsIDsWithfingerprintObj.keyset()]){
            
            if(empToUpdateObj.Dual_Hat_Eligible__c){
            
                pendingRecordBeingProcessed = mapMsIDsWithfingerprintObj.get(empToUpdateObj.Emp_ID__c);
                DH_GRLCRD__c grlObj =  new DH_GRLCRD__c();
                
                //assign the field values of pending object to the main Fingerprint object
                grlObj.Employee__c = empToUpdateObj.id;
                grlObj.Fingerprint_Date__c = pendingRecordBeingProcessed.Fingerprint_Date__c;
                grlObj.Status__c = pendingRecordBeingProcessed.GRL_CRD_Status__c;
                grlObj.Status_Date__c = pendingRecordBeingProcessed.Status_Date__c;
                grlObj.Status_Date__c = pendingRecordBeingProcessed.Status_Date__c;
                
                
                addGRLRecords.add(grlObj);
                //add the records to delete list
                deleteProcessedRecords.add(pendingRecordBeingProcessed);
            }
        }
    
        if(addGRLRecords!=null && addGRLRecords.size()>0){
            insert addGRLRecords;                                //insert the records into main fingerprint object
        }
        
        if(mapMsIDsWithfingerprintObj.values()!=null && mapMsIDsWithfingerprintObj.size()>0 ){
        
            //if the records are older than 6 months then delete
            for(Dual_Emploloy_Pending_Fingerprint_Status__c pendObj: mapMsIDsWithfingerprintObj.values()){
                
                Boolean sixMonthsOldFlag = false;
                //If(pendObj.Fingerprint_Date__c.addMonths(6) <= System.Today())
                // delete based on last 6 months i.e. LastModifiedDate
                if(pendObj.LastModifiedDate.addMonths(6) <= System.Today())
                {
                    sixMonthsOldFlag = true;
                    }
                    else
                    {
                    sixMonthsOldFlag = false;
                    }
                
                if(sixMonthsOldFlag)
                {
                    deleteProcessedRecords.add(pendObj);         //add the records to delete list
                }
            }
        }
    
        if(deleteProcessedRecords!=null && deleteProcessedRecords.size()>0) {
            List <Dual_Emploloy_Pending_Fingerprint_Status__c > deletependingRecords = new  List <Dual_Emploloy_Pending_Fingerprint_Status__c > ();
            deletependingRecords.addAll(deleteProcessedRecords);
            delete deletependingRecords;                        //delete the records
        }
    }
    
    global void finish(Database.BatchableContext BC){            //call the next batch class
          Database.executeBatch(new DE_Batch_ApplyPendingCarco());
    }
    
}