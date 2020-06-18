// 
// (c) 2014 Appirio, Inc. 
//
// Description : Batch job for creating bulk docusign envelop and calling docsuign API.
//
// 09 Jan 2014 Rahul Agrawal Original
//



global class DG_DocusignSentForSignature implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful{
    
    public string queryStr = 'select Id, Is_Sent_for_Signature__c, List__c, Employee__c,' + 
        ' list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name, List__r.Email_Subject__c, List__r.Email_Body__c, List__r.Action_Required_By_Date__c, ' +
        ' Employee__r.Email__c, Employee__r.Emp_id__c, Employee__r.Name, Employee__r.Status__c, Employee__r.Docusign_GUID__c, Employee__r.First_Name__c, Employee__r.Last_Name__c'+
        ' from List_Employee__c' +
        ' where Is_Sent_for_Signature__c = false AND Status__c = \'Created\'' +
        ' and list__c = :listId ';
    
    private List__c listRecord; 
    private Id listId;
    private Integer remainingApiCalls;
    private Integer apiCallsDone;
    private datetime batchStartTime;
    private Bulk_Docusign_Settings__c docusignSetting;
    private String ERROR_QUERY = 'SELECT Id FROM List_Employee__c WHERE Id = null';
    
    global DG_DocusignSentForSignature(String listId){
    	
    	this.listId = listId;
    	listRecord = [Select id from List__c where id = :listId];
    	
    }
    
    global Database.QueryLocator start(Database.BatchableContext c) {
        apiCallsDone = 0;
        boolean isProcessed = validateAPICall();
        if(Trigger_Switch__c.getInstance().Is_DG_DocusignSentForSignature_Off__c == true
               || !isProcessed){ 
            return Database.getQueryLocator(ERROR_QUERY);
        }
        
        listRecord.DocuSign_Status__c = 'Processing';
        update listRecord;
        
        system.debug(queryStr);
        system.debug('list__c = '+listId +' limit '+remainingApiCalls);
        return Database.getQueryLocator(queryStr); 
    }
    
    global void execute(Database.BatchableContext c, List<List_Employee__c> empList){
        if(batchStartTime == null){
            batchStartTime = Datetime.now();
        }
        
        List__c l = [select enable_for_acknowledgement__c from List__c where id = :empList[0].list__c];
        
       
        set<Id> setTemplateIds = new set<Id>();
        for(List_Template__c listTemplate : DG_DataUtil.getListTemplate(listRecord.Id)){
            setTemplateIds.add(listTemplate.Template__c);
        }
        
        Map<String, Attachment> nameToAttachmentMap = new Map<String, Attachment>();
        for(Attachment doc : DG_DataUtil.getTemplateAttachment(setTemplateIds)){
            if(!nameToAttachmentMap.containsKey(doc.parentId)){
                nameToAttachmentMap.put(doc.parentId, doc);
            }
        }
        if(remainingApiCalls > apiCallsDone){
            	DG_DocuSignAPI_Utilities utilities = new DG_DocuSignAPI_Utilities(empList, nameToAttachmentMap.values());
            	utilities.checkDocumentsAndSendForSignature();
            	apiCallsDone++; 
        } 
    }
    
    global void finish(Database.BatchableContext c){
        if(docusignSetting.Last_DocuSign_API_Limit_Reached__c == null ||
           docusignSetting.DocuSign_API_Used_Last_Hour__c == docusignSetting.Docusign_API_Limit_Hourly__c){
           docusignSetting.Last_DocuSign_API_Limit_Reached__c = DateTime.Now(); 
        }
        docusignSetting.DocuSign_API_Used_Last_Hour__c += apiCallsDone;
        docusignSetting.DocusignJobScheduled__c = false;
        update docusignSetting; 
        
        listRecord.DocuSign_Status__c = 'Complete';
        update listRecord;
        
        /*
        if(Trigger_Switch__c.getInstance().Is_DG_DocusignSentForSignature_Off__c == false){
            Datetime batchEndTime = Datetime.now();
            system.debug('Start Time: '+batchStartTime+', End time: '+ batchEndTime);
            if(batchStartTime == null){
	            batchStartTime = Datetime.now(); 
	        }
            decimal  batchExecuteDuration = ((batchEndTime.getTime())/1000/60) - ((batchStartTime.getTime())/1000/60);
            Datetime dt = batchStartTime;
            if(batchExecuteDuration >= 60){
                dt = batchEndTime; 
            }
            
            Integer remainingEmployees = [Select count() FROM List_Employee__c WHERE Status__c = 'Created' AND List__c = :listRecord.Id];
            if(remainingEmployees > 0){
                DG_UtilityClass.scheduleBatchSentForSignature(DG_DataUtil.BATCH_SCHEDULE_HOUR, 0, dt);
            }else{
                listRecord.Docusign_Status__c = 'Complete';
                update listRecord;
                //DG_UtilityClass.sendCompletedEmailToUser(listRecord);
                
                //For new list
                listRecord = DG_DataUtil.getListDetailsAvailableForSignature();
                if(listRecord != null){
                    
                    boolean isProcessed = validateAPICall();
                    if(isProcessed){ 
                        DG_UtilityClass.scheduleBatchSentForSignature(0, DG_DataUtil.BATCH_SCHEDULE_MINUTE, dt); 
                    }else{
                        DG_UtilityClass.scheduleBatchSentForSignature(DG_DataUtil.BATCH_SCHEDULE_HOUR, 0, dt);
                    }
                }
            }
        }
        */
        
    }    
    
    private boolean validateAPICall(){
        docusignSetting = Bulk_Docusign_Settings__c.getInstance('Default');
        Integer currentHour = dateTime.now().hour();        
        //Integer lastLimitReachedHour = docusignSetting.Last_Docusign_API_Limit_reached__c.Hour();
        
        if(docusignSetting.Last_Docusign_API_Limit_reached__c != null &&
               docusignSetting.Docusign_API_Used_Last_Hour__c != null && 
               currentHour == docusignSetting.Last_Docusign_API_Limit_reached__c.Hour()){           
            remainingApiCalls = Integer.valueOf((docusignSetting.Docusign_API_Limit_Hourly__c - docusignSetting.Docusign_API_Used_Last_Hour__c));
        }else{
            docusignSetting.Last_DocuSign_API_Limit_Reached__c = DateTime.Now();
            docusignSetting.DocuSign_API_Used_Last_Hour__c = 0;
            remainingApiCalls = Integer.valueOf(docusignSetting.Docusign_API_Limit_Hourly__c);
        }
        
        if(remainingApiCalls > 0){
            return true;
        }
        return false;
          
    }
    /*
    global void execute(SchedulableContext sc){  
        if(!Test.isRunningTest()){
            //id batchId = Database.executeBatch(new DG_DocusignSentForSignature(), Limits.getLimitCallouts());
            id batchId = Database.executeBatch(new DG_DocusignSentForSignature(), 50); 
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
    */
}