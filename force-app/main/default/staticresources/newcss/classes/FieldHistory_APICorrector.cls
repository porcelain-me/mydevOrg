/** This batch will replace the API values to corresponding Field Name **/
global class FieldHistory_APICorrector implements Database.Batchable<sObject>{
    
    String snrHistoryObj = 'Sev_And_Release_Encrypted_Field_History__c';
    //public String theObject,masterObject = '';
    public Map<String,String> apiToLabelMap = new Map<String,String>();
    public String queryStr = 'SELECT Id, Field__c, NewValue__c, OldValue__c FROM ';
    List<Sev_And_Release_Encrypted_Field_History__c> updateList = new List<Sev_And_Release_Encrypted_Field_History__c>();
    
    // constructor that will find out the field history name
    /*global FieldHistory_APICorrector(String objName){
        if(!String.isBlank(objName)){
            if(objName.equalsIgnoreCase('Sev_And_Release_Encrypted_Field_History__c')){
                theObject = 'Sev_And_Release_Encrypted_Field_History__c';
                masterObject = 'Severance_And_Release__c';
            }
            else if(objName.equalsIgnoreCase('Employee_Encrypted_Field_History__c')){
                theObject = 'Employee_Encrypted_Field_History__c';
                masterObject = 'Employee__c';
                
            }
            else if(objName.equalsIgnoreCase('CrossSell_Encrypted_Field_History__c')){
                theObject = 'CrossSell_Encrypted_Field_History__c';
                masterObject = 'Cross_Sell__c';
            }
        }
    }*/
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(queryStr + snrHistoryObj);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> resultsList){
        if(resultsList != null && !resultsList.isEmpty()){
            // build the object field definer
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType schemaForObject = schemaMap.get('Severance_And_Release__c');
            Map<String, Schema.SObjectField> fieldMap = schemaForObject.getDescribe().fields.getMap();
            for(String fieldAPI: fieldMap.keySet()){
                if(fieldMap.containsKey(fieldAPI)){
                    String theLabel = fieldMap.get(fieldAPI).getDescribe().getLabel();
                    apiToLabelMap.put(fieldAPI, theLabel);
                }
            }
            for(sObject res : resultsList){
                Sev_And_Release_Encrypted_Field_History__c newRec = (Sev_And_Release_Encrypted_Field_History__c)res;
                
                String theAPIVal = String.valueOf(newRec.Field__c).toLowerCase();
                if(!String.isBlank(newRec.Field__c) && !apiToLabelMap.isEmpty() && apiToLabelMap.containsKey(theAPIVal)){
                    newRec.Field__c = apiToLabelMap.get(theAPIVal);
                    updateList.add(newRec);
                } 
            }
            system.debug(' -- updateList -- ' + updateList);
            if(updateList != null && !updateList.isEmpty()){
                update updateList;
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        // do nothing
    }
    
}