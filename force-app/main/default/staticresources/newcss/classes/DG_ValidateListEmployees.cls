// 
// (c) 2014 Appirio, Inc. 
//
// Description : Batch Job to Validate employee details related to List Employee.
//
// 14 Jan 2014 Jitendra Kothari Original
//

global class DG_ValidateListEmployees implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful{
    private String ERROR_QUERY = 'SELECT Id FROM List_Employee__c WHERE Id = null';
    public set<id> listIds;
    public string queryStr = 'select Id, Is_Sent_for_Signature__c, List__c, Employee__c, ' + 
                    ' Employee__r.Email__c, Employee__r.Emp_Id__c, Employee__r.Name, Employee__r.Status__c, Employee__r.Docusign_GUID__c'+
                    ' from List_Employee__c' +
                    ' where Is_Sent_for_Signature__c = false AND Status__c = \'Created\'' +
                    ' AND List__c IN :listIds';

    global Database.QueryLocator start(Database.BatchableContext c) {
        listIds = new set<Id>();
        for(List__c listTemp : DG_DataUtil.getReadyListRecords()){
            listIds.add(listTemp.Id);
        }
        return Database.getQueryLocator(queryStr);
    }
    global void execute(Database.BatchableContext c, List<List_Employee__c> empList){
        List<String> errors;
        for(List_Employee__c emp : empList){
            if(emp.Employee__c == null){ 
                DG_UtilityClass.populateStatus(emp, 'Failed', 'Employee not found.');
            }else{
                errors = FFAP_CongaManager.validateEmployee(emp.Employee__r, 'Employee', true);
                if(!errors.isEmpty()){
                    DG_UtilityClass.populateStatus(emp, 'Failed', String.join(errors, ','));
                }
            } 
        }
        update empList;
    }
    
    global void finish(Database.BatchableContext c){
        DG_UtilityClass.scheduleBatchSentForSignature(0, DG_DataUtil.BATCH_SCHEDULE_MINUTE);
    }
}