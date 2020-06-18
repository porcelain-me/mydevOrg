global class DE_Batch_ApplyPendingCarco implements Database.Batchable<sObject>{
    // query to get all the Pending records for CARCO/FFIEC
    private final String query = 'select id,name,Dual_Employment_FFIEC_Status__c,Dual_Hat_FFIEC_Status_Date__c,MSID__c,LastModifiedDate,  Dual_Hat_FFIEC_Status_In_Date__c from Dual_Employ_Pending_FFIEC_Status__c';
    
    public DE_Batch_ApplyPendingCarco(){    //defining the constructor which is used in DE_Batch_ApplyPendingFingerprints to call this batch class
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Dual_Employ_Pending_FFIEC_Status__c> pendingCarcoTable ){
        
        //Create a map with MSIDs
        Map <string,Dual_Employ_Pending_FFIEC_Status__c > mapMsIDsWithCarcoObj= new Map <string,Dual_Employ_Pending_FFIEC_Status__c >();
       
        for(Dual_Employ_Pending_FFIEC_Status__c carcoObj: pendingCarcoTable ){
            mapMsIDsWithCarcoObj.put(carcoObj.MSID__c,carcoObj);
        }
        
        List<Employee__c> updateEmpRecords= new List<Employee__c>();
        
        Set <Dual_Employ_Pending_FFIEC_Status__c> deleteProcessedRecords = new  Set<Dual_Employ_Pending_FFIEC_Status__c> ();
            
        for(Employee__c empToUpdate: [select id,Emp_ID__c,Dual_Hat_Eligible__c,Dual_Hat_FFIEC_Status__c,Dual_Hat_FFIEC_Status_Date__c,  Dual_Hat_FFIEC_Status_In_Date__c from Employee__c where Emp_ID__c IN:mapMsIDsWithCarcoObj.keyset()]){
            
            // Update FFIEC Status and Status Date to Emp only if the Employee is Dual Hat Eligible
                if(empToUpdate.Dual_Hat_Eligible__c){
                
                    
                        empToUpdate.Dual_Hat_FFIEC_Status__c = mapMsIDsWithCarcoObj.get(empToUpdate.Emp_ID__c).Dual_Employment_FFIEC_Status__c;
                       
                        empToUpdate.Dual_Hat_FFIEC_Status_Date__c = mapMsIDsWithCarcoObj.get(empToUpdate.Emp_ID__c).Dual_Hat_FFIEC_Status_Date__c;
                        
                        empToUpdate.Dual_Hat_FFIEC_Status_In_Date__c = mapMsIDsWithCarcoObj.get(empToUpdate.Emp_ID__c).Dual_Hat_FFIEC_Status_In_Date__c;
                        
                    // add the Employee to the update list
                    updateEmpRecords.add(empToUpdate);
                    
                    // add the pending CARCO record to delete list
                    deleteProcessedRecords.add(mapMsIDsWithCarcoObj.get(empToUpdate.Emp_ID__c));
                }
            
        }
    
        if(updateEmpRecords!=null && updateEmpRecords.size()>0){
            update updateEmpRecords;
        }
        
        if(mapMsIDsWithCarcoObj!=null && mapMsIDsWithCarcoObj.size()>0){
        
        //    List <Dual_Employ_Pending_FFIEC_Status__c> deletedpendingRecords= new  List <Dual_Employ_Pending_FFIEC_Status__c> ();
            
            for(Dual_Employ_Pending_FFIEC_Status__c pendObj: mapMsIDsWithCarcoObj.values()){
                
                Boolean sixMonthsOldFlag = false;
                //If(pendObj.Dual_Hat_FFIEC_Status_Date__c.addMonths(6) <= System.Today())
                // delete based on last 6 months i.e. LastModifiedDate
                if(pendObj.LastModifiedDate.addMonths(6) <= System.Today())
                {
                    sixMonthsOldFlag = true;
                    }
                    else
                    {
                    sixMonthsOldFlag = false;
                    }
                //FFIEC cleared status date must not be greater than 6 months. Hence add those records for deletion
                
                if(pendObj.Dual_Employment_FFIEC_Status__c == 'CLER' && sixMonthsOldFlag )
                {
                    deleteProcessedRecords.add(pendObj);    
                
                }
              
             
             }
        }
        
        // Delete processed and old Pending CARCO records
        if(deleteProcessedRecords!=null && deleteProcessedRecords.size()>0) {
            List <Dual_Employ_Pending_FFIEC_Status__c> deletependingRecords = new  List <Dual_Employ_Pending_FFIEC_Status__c> ();
            deletependingRecords.addAll(deleteProcessedRecords);
            delete deletependingRecords;
        }

    }
    
    
    global void finish(Database.BatchableContext BC){
        Database.executeBatch(new DE_Batch_ApplyPendingLMS());
    
    }
    
    
    }