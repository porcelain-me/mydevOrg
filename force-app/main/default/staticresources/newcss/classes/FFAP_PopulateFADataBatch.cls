global class FFAP_PopulateFADataBatch implements Database.Batchable<SObject>, System.Schedulable, Database.Stateful{
    private static final DateTime activeDate = System.Now();
    private static boolean setInactiveFA = false;
    
    global Database.QueryLocator start(Database.BatchableContext c) {
        String QUERY = 'SELECT Id, Status__c, JPN__c, FA_Type__c, FA__c, MSID__c, MSID_Split__c, ' + 
                        'Error__c FROM Staging_FA_Account__c' + 
                        ' WHERE Status__c = \'New\'' +
                        ' ORDER BY FA_Type__c, JPN__c, MSID__c';
        List<Staging_FA_Account__c> lsitSFAA = [Select Id From Staging_FA_Account__c Where Status__c = 'New' LIMIT 1];
        if (!lsitSFAA.isEmpty()){
            setInactiveFA = true;
        }
        //don't fetch actual record if switch is turned off for this batch process
        if(Trigger_Switch__c.getInstance().Is_FFAP_PopulateFADataBatch_Off__c == true){
            QUERY = 'SELECT Id FROM Staging_FA_Account__c WHERE Id = null';
        }       
        return Database.getQueryLocator(QUERY);        
    }
    global void execute(Database.BatchableContext c, List<Sobject> objects) {
        List<Staging_FA_Account__c> stagingFARecords = (List<Staging_FA_Account__c>) objects;
         
        //this will contain unique jpn number to Staging FA record map. Mostly used when
        Map<String, List<Staging_FA_Account__c>> jpnNumberToFAmap = new Map<String, List<Staging_FA_Account__c>>();
        Set<String> msIdSet = new Set<String>();
        Map<String, String> empIdToFANumber = new Map<String, String>();
        for(Staging_FA_Account__c stagingFA : stagingFARecords){
            //setting default type
            if(stagingFA.FA_Type__c == null){
                stagingFA.FA_Type__c = FFAP_DataUtil.FA_Primary_TYPE;
            }
            if(stagingFA.JPN__c != null){               
                empIdToFANumber.put(stagingFA.MSID__c, stagingFA.FA__c);
                if(!jpnNumberToFAmap.containsKey(stagingFA.JPN__c)){
                    jpnNumberToFAmap.put(stagingFA.JPN__c, new List<Staging_FA_Account__c>());
                    msIdSet = new Set<String>();
                }
                if(!msIdSet.contains(stagingFA.MSID__c)){
                    jpnNumberToFAmap.get(stagingFA.JPN__c).add(stagingFA);
                    msIdSet.add(stagingFA.MSID__c);                 
                }
            }
        }
        System.debug('unique ' + jpnNumberToFAmap);
        if(!jpnNumberToFAmap.isEmpty()){
            List<Employee__c> empForUpdate = new List<Employee__c>();
            List<Employee__c> empList = FFAP_DataUtil.getEmployeesOnEmpId(empIdToFANumber.keySet());
            for(Employee__c emp : empList){
                if(emp.Financial_Advisor_Number__c != empIdToFANumber.get(emp.Emp_Id__c)){
                    emp.Financial_Advisor_Number__c = empIdToFANumber.get(emp.Emp_Id__c);
                    empForUpdate.add(emp);
                }                
            }
            if(!empForUpdate.isEmpty()){
                Database.update(empForUpdate, false);
                empForUpdate = null;
            }
            Map<String, Employee__c> empRecords = new Map<String, Employee__c>();
            for(Employee__c emp : empList){
                empRecords.put(emp.Emp_Id__c, emp);
            }
            
            for(Staging_FA_Account__c stagingFA : stagingFARecords){
                if(!empRecords.containsKey(stagingFA.MSID__c)){
                   logStatus(stagingFA, 'Failed', 'Employee record is not found with MSID.');
                }
            }
            Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
            Id inActiveRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.INACTIVE_RECORDTYPE);
            Set<Id> recordTypeIdSet = new Set<Id>();
            recordTypeIdSet.add(activeRecordTypeId);
            recordTypeIdSet.add(inActiveRecordTypeId);
            List<FA_Account__c> faList = [SELECT Id, Name, Type__c FROM FA_Account__c WHERE Name IN : jpnNumberToFAmap.keySet() AND RecordTypeId IN : recordTypeIdSet];
            Map<String, FA_Account__c> faExists = new Map<String, FA_Account__c>();
            Set<Id> faIdExists = new Set<Id>();
            for(FA_Account__c fa : faList){
                faExists.put(fa.Name, fa);
                faIdExists.add(fa.Id);
            }
            faList = new List<FA_Account__c>();
            
            FA_Account__c faTemp;
            List<Staging_FA_Account__c> tempStagingFARecords;
            Map<String, FA_Account__c> jpnToFAAccount = new Map<String, FA_Account__c>();           
            for(String jpnNumber : jpnNumberToFAmap.keySet()){
                tempStagingFARecords = jpnNumberToFAmap.get(jpnNumber);
                if(faExists.containsKey(jpnNumber)){
                    faTemp = faExists.get(jpnNumber); 
                }else{
                    faTemp = new FA_Account__c(Name = jpnNumber, RecordTypeId = activeRecordTypeId);
                    //setting default type
                    if(tempStagingFARecords.isEmpty()){
                        faTemp.Type__c = FFAP_DataUtil.FA_Primary_TYPE;
                    }else{
                        faTemp.Type__c = tempStagingFARecords[0].FA_Type__c;
                    }                   
                }               
                faTemp.Last_Active_Date__c = activeDate;
                faTemp.RecordTypeId = activeRecordTypeId;
                jpnToFAAccount.put(jpnNumber, faTemp);              
            }
            if(!jpnToFAAccount.isEmpty()){
                Database.UpsertResult[] result = Database.upsert(jpnToFAAccount.values(), false);
                // Process the save results
                for(Integer indx = faList.size() - 1; indx > -1; indx--){
                   if(!result[indx].isSuccess()){                 
                       Database.Error err = result[indx].getErrors()[0];
                       System.debug('Unable to insert FA record due to following exception:' + err.getMessage());
                       for(Staging_FA_Account__c stagingFA : stagingFARecords){
                            if(stagingFA.JPN__c == faList[indx].Name){
                               logStatus(stagingFA, 'Failed', err.getMessage());
                            }
                       }
                  }            
                }
            }
            
            List<FA_Account_Association__c> faAccountAssociationExisting = FFAP_DataUtil.getFAAccAssociationListOnFAAccountIds(faIdExists);                                                            
            Map<String, FA_Account_Association__c> jpnTofaAccountAssociations = new Map<String, FA_Account_Association__c>();
            for(FA_Account_Association__c fa : faAccountAssociationExisting){               
                jpnTofaAccountAssociations.put(fa.FA_Account__r.Name + '$-#' + fa.Emp_Id__c, fa);
            }
            FA_Account_Association__c fa;
            List<FA_Account_Association__c> faAccountAssociations = new List<FA_Account_Association__c>();
            List<String> jpnNumberList = new List<String>();
            String key;
            for(String jpnNumber : jpnNumberToFAmap.keySet()){
                tempStagingFARecords = jpnNumberToFAmap.get(jpnNumber);             
                for(Staging_FA_Account__c stagingFA : tempStagingFARecords){
                    if(stagingFA.Status__c == 'Failed') break;
                    key = stagingFA.JPN__c + '$-#' + stagingFA.MSID__c;
                    System.debug('key used - ' + key);
                    if(jpnTofaAccountAssociations.containsKey(key)){
                        fa = jpnTofaAccountAssociations.get(key);
                        fa.FA_Split_Percent__c = stagingFA.MSID_Split__c;                       
                        jpnTofaAccountAssociations.remove(key);
                    }else{
                        fa = new FA_Account_Association__c(FA_Split_Percent__c = stagingFA.MSID_Split__c);
                        fa.FA_Account__c = jpnToFAAccount.get(jpnNumber).Id;
                        if(empRecords.containsKey(stagingFA.MSID__c)){
                            fa.Financial_Advisor__c = empRecords.get(stagingFA.MSID__c).Id;
                        }
                    } 
                    if(fa.Financial_Advisor__c != null){                
                        faAccountAssociations.add(fa);
                    }
                    //jpnNumberList.add(jpnNumber);
                    jpnNumberList.add(key);
                }
            }
            if(!jpnTofaAccountAssociations.isEmpty()){
               delete jpnTofaAccountAssociations.values();
            }
            List<FA_Account_Association__c> faAccountAssociationsAfterInsert;
            if(!faAccountAssociations.isEmpty()){
                Database.UpsertResult[] result = Database.upsert(faAccountAssociations, false);                
                // Process the save results
                for(Integer indx = faAccountAssociations.size() - 1; indx > -1; indx--){
                   if(!result[indx].isSuccess()){                 
                       Database.Error err = result[indx].getErrors()[0];
                       System.debug('Unable to upsert FA Association record due to following exception:' + err.getMessage());
                       for(Staging_FA_Account__c stagingFA : stagingFARecords){
                        key = stagingFA.JPN__c + '$-#' + stagingFA.MSID__c;
                        if(key == jpnNumberList[indx]){
                            logStatus(stagingFA, 'Failed', err.getMessage());
                        }
                       }
                  }else{
                        for(Staging_FA_Account__c stagingFA : stagingFARecords){
                            key = stagingFA.JPN__c + '$-#' + stagingFA.MSID__c;
                            if(key == jpnNumberList[indx]){
                              logStatus(stagingFA, 'Completed', null);
                            }
                        }
                  }            
                }
            } 
            update stagingFARecords;        
        }
        System.debug('Number of DML Rows:' + Limits.getDmlRows());
        System.debug('Number of DML Statements:' + Limits.getDMLStatements());
        System.debug('Heap Size:' + Limits.getHeapSize());
        System.debug('Number of Queries:' + Limits.getQueries());
        System.debug('Number of SOQL Rows:' + Limits.getQueryRows());
        System.debug('Number of Script statements:' + Limits.getScriptStatements());
    }
    
    private void logStatus(Staging_FA_Account__c stagingFA, String status, String error){
        stagingFA.Status__c = status;
        stagingFA.Error__c = error;
    }
    
    global void finish(Database.BatchableContext c) {
        //don't update actual record if switch is turned off for this batch process
        if(Trigger_Switch__c.getInstance().Is_FFAP_PopulateFADataBatch_Off__c == true){
            return;
        }
        if (setInactiveFA){
            Id inActiveRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.INACTIVE_RECORDTYPE);
            List<FA_Account__c> faList = FFAP_DataUtil.getActiveFAAccountsOnActiveDate(activeDate, FFAP_DataUtil.ACTIVE_RECORDTYPE);
            for(FA_Account__c fa : faList){
                fa.RecordTypeId = inActiveRecordTypeId;
                fa.InActive__c = true;
            }
            if(!faList.isEmpty()){
               update faList;
            } 
        }
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new FFAP_PopulateFADataBatch(), 200);
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
}