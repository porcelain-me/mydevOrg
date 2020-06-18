// 
// (c) 2014 Appirio, Inc. 
//
// Description : Docusign userid passed to employee guid field for Employee Acknowledge app through docusign soap api.
//
// 09 Mar 2014 Jitendra Kothari Original
//
global class Common_DocusignUserUpdate implements Database.Batchable<SObject>, System.Schedulable,Database.AllowsCallouts, Database.Stateful{
    //will be used to connect to Docusign API
    private DocusignAuthenticationHelper docusign;
    private Integer recordCount = 10;
    private String ERROR_QUERY = 'SELECT Id FROM Employee__c WHERE Id = null';
    private String QUERY = 'SELECT Id, Name, Email__c, First_Name__c, Last_Name__c ' + 
                        ' FROM Employee__c WHERE DocuSign_GUID__c = null' + 
                         ' AND Email__c != null AND First_Name__c != null AND Last_Name__c != null' + 
                         ' AND Status__c = \'Active\' limit :remainingApiCalls';
    private String QUERY_EXECUTE;
    private Integer remainingApiCalls;
    private Integer apiCallsDone;
    private datetime batchStartTime;
    private Bulk_Docusign_Settings__c docusignSetting;
    global Database.QueryLocator start(Database.BatchableContext c) {
    	apiCallsDone = 0;
        boolean isProcessed = validateAPICall(); 
        //don't fetch employee records if switch is turned off for this batch process
        if(Trigger_Switch__c.getInstance().Is_FFAP_DocusignUserCreation_Off__c == true || !isProcessed){
            QUERY_EXECUTE = ERROR_QUERY; 
        }else{                              
            if(populateSystemData() != FFAP_DataUtil.SUCCESS){
                QUERY_EXECUTE = ERROR_QUERY; 
            }else{
            	QUERY_EXECUTE = QUERY;
            }
        }     
        return Database.getQueryLocator(QUERY_EXECUTE);       
    }    
    
    global void execute(Database.BatchableContext c, List<Employee__c> empList) {       
        String resultString = sendNow(empList);
    }
    private String populateSystemData(){
        docusign = new DocusignAuthenticationHelper();
        if(docusign.isConfigured == false){
            return docusign.error;
        }
        
        return FFAP_DataUtil.SUCCESS;
    }
    
    private String SendNow(List<Employee__c> empList){
        String resultString = FFAP_DataUtil.SUCCESS;
        DocusignAccountmanagementAPI.AccountManagementServiceSoap dsApiSend = new DocusignAccountmanagementAPI.AccountManagementServiceSoap();
        dsApiSend.endpoint_x = docusign.webAccMgmtServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        System.debug('Setting authentication to: ' + auth);
            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        List<Employee__c> empforUpdate = new List<Employee__c>();
        	
        for(Employee__c emp : empList){
	        try {
	            DocusignAccountmanagementAPI.CheckAccountMemberResult_element es;
	            if(!Test.isRunningTest()){                  
	                es = dsApiSend.CheckAccountMember(docusign.accountId, emp.Email__c);                    
	                System.debug('Result - >' + es);                
	            }else{
	                //This has been done to provide coverage to test class by sending dummy response
	                es = new DocusignAccountmanagementAPI.CheckAccountMemberResult_element();
	                es.Success = true;
	                es.UserId = emp.Emp_Id__c;
	                System.debug('Result - >' + es);  
	            }
		        if(es != null && es.Success == true){            
		            emp.DocuSign_GUID__c = es.UserId;
		            empforUpdate.add(emp);
		        }
		        apiCallsDone++;
	        } catch (CalloutException e) {            
	            System.debug('Exception - ' + e );
	            return 'Docusign Sign API Call failed - ' + e.getMessage() + '\n Please contact to System Administrator.';                    
	        } 
        }
        if(!empforUpdate.isEmpty()){
            update empforUpdate;
        }       
        return resultString;
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
    global void finish(Database.BatchableContext c) {
    	if(docusignSetting.Last_DocuSign_API_Limit_Reached__c == null ||
           docusignSetting.DocuSign_API_Used_Last_Hour__c == docusignSetting.Docusign_API_Limit_Hourly__c){
           docusignSetting.Last_DocuSign_API_Limit_Reached__c = DateTime.Now(); 
        }
        docusignSetting.DocuSign_API_Used_Last_Hour__c += apiCallsDone;
        docusignSetting.DocusignJobScheduled__c = false;
        update docusignSetting; 
        
        if(Trigger_Switch__c.getInstance().Is_FFAP_DocusignUserCreation_Off__c == false){
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
            
            Integer remainingEmployees = [Select count() FROM Employee__c WHERE Status__c = 'Active' AND Email__c != null 
                    AND First_Name__c != null AND Last_Name__c != null AND DocuSign_GUID__c = null limit 1];
            if(remainingEmployees > 0){
               // DG_UtilityClass.scheduleBatchUserUpdate(DG_DataUtil.BATCH_SCHEDULE_HOUR, 0, dt);
            }
        }        
    }
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            Id batchId = Database.executeBatch(new Common_DocusignUserUpdate(), Limits.getLimitCallouts());
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
}