/************************************************************************
*  This batch process goes thru a list and sends an email to each employee
*  that should receive an embedded signing ceremony.
*
* Change Log:
* 	4/1/2104 - MRM - Created class
*************************************************************************/
global class DG_DocusignEmailEmbeddedCeremony implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful{
    
    
    public string queryStr = 'select Id, Is_Sent_for_Signature__c, List__c, Employee__c,' + 
        ' list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name, List__r.Email_Subject__c, List__r.Email_Body__c, List__r.Action_Required_By_Date__c, ' +
        ' Employee__r.Email__c, Employee__r.Emp_id__c, Employee__r.Name, Employee__r.Status__c, Employee__r.Docusign_GUID__c, Employee__r.First_Name__c, Employee__r.Last_Name__c'+
        ' from List_Employee__c' +
        ' where Is_Sent_for_Signature__c = true AND Status__c = \'Sent\'' +
        ' and list__c = :listId limit :remainingApiCalls';
    
    private List__c listRecord;
    private Id listId;
    private Integer remainingApiCalls;
    private Integer apiCallsDone;
    private datetime batchStartTime;
    private Bulk_Docusign_Settings__c docusignSetting;
    private String ERROR_QUERY = 'SELECT Id FROM List_Employee__c WHERE Id = null';
    
    global Database.QueryLocator start(Database.BatchableContext c) {
        apiCallsDone = 0;
        boolean isProcessed = validateAPICall();
        if(Trigger_Switch__c.getInstance().Is_DG_DocusignSentForSignature_Off__c == true
               || !isProcessed){ 
            return Database.getQueryLocator(ERROR_QUERY);
        }
        listRecord = DG_DataUtil.getListEnvelopesAvailableForSignature();
        
        if(listRecord == null){
            queryStr = ERROR_QUERY;
        }else{
        	listId = listRecord.Id;
            listRecord.Embedded_Email_Status__c = 'Processing';
            update listRecord;
        }
        
        system.debug(queryStr);
        system.debug('list__c = '+listId +' limit '+remainingApiCalls);
        return Database.getQueryLocator(queryStr); 
    }
    
    global void execute(Database.BatchableContext c, List<List_Employee__c> empList){
    	
    	system.debug('Executing...');
    	
        if(batchStartTime == null){
            batchStartTime = Datetime.now();
        }
        
         
        if(remainingApiCalls > apiCallsDone){
            /*
            make api call to get url then send email
            */
            
            List<dsfs__DocuSign_Status__c> docList = new List<dsfs__DocuSign_Status__c>();
            docList = [select dsfs__DocuSign_Envelope_ID__c
            		 	from dsfs__DocuSign_Status__c
            			where List_Employee__c = :empList[0].id
            			and dsfs__Envelope_Status__c = 'Completed'
            			limit 1
            ];
            //xx
            Integer mark;
           	DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(docList[0].dsfs__DocuSign_Envelope_ID__c,null);
             
            /* send email */
            
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
    global void execute(SchedulableContext sc){
    	
    	
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new DG_DocusignEmailEmbeddedCeremony(), Limits.getLimitCallouts());
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
}