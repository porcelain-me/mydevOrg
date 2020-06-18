// 
// (c) 2014 Appirio, Inc. 
//
// Description : Utility class for Employee Acknowledge app.
//
// 14 Jan 2014 Jitendra Kothari Original
 
public with sharing class DG_UtilityClass {
	private static final String FIRST_NAME = '\\[First Name\\]';
	private static final String LAST_NAME = '\\[Last Name\\]';
	private static final String NAME = '\\[Name\\]';
	
    public static String replaceMergeText(String text, Employee__c emp){
    	String firstName = emp.First_Name__c <> null ? emp.First_Name__c : '';
    	String lastName = emp.Last_Name__c <> null ? emp.Last_Name__c : '';
    	String empName = emp.Name <> null ? emp.Name : ''; 
    	return text.replaceAll(FIRST_NAME, firstName).replaceAll(LAST_NAME, lastName).replaceAll(NAME, empName);
    }
    public static void populateStatus(List_Employee__c listEmp, String status, String error){
        listEmp.Status__c = status;            
        listEmp.Error__c = error;        
        if(status == 'Sent'){
            listEmp.Is_Sent_for_Signature__c = true;
        }        
    } 
    
    public static void sendCompletedEmailToUser(List__c listRecord){
         if(Trigger_Switch__c.getInstance().Is_DG_DocusignSentForSignature_Off__c == false){
            String body = '';
            body = 'Document Sending Process is completed for ' + listRecord.Name + ' list.';
            
            User currUser;
            for(User user : [select Email, Id from User where id = :listRecord.Signature_Submittor__c]){
            	currUser = user; 
            }
            if(Test.isRunningTest()){
            	currUser = new User(Email = 'abc@ms.com');
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
            mail.setToAddresses(new String[]{currUser.Email});
            mail.setSubject('Document Sending Process completed.');
            //System.debug(body);
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});            
        }
    }
    
    public static void scheduleBatchSentForSignature(integer afterHours, integer afterMinutes){
    	scheduleBatchSentForSignature(afterHours, afterMinutes, null);
    }
      
    public static void scheduleBatchSentForSignature(integer afterHours, integer afterMinutes, Datetime dt){
    	string batchName = 'DocusignSentForSignature';
        afterHours = afterHours == null ? 0 : afterHours;
        afterMinutes = afterMinutes == null ? 0 : afterMinutes;
        if(dt == null)
            dt = system.now();
        
        dt = dt.addMinutes(afterMinutes);
        dt = dt.addHours(afterHours);        
        String sch = dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + 
                    ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        boolean isBatchScheduled = DG_DataUtil.checkIfBatchJobScheduled(batchName);
        Bulk_Docusign_Settings__c docusignSetting = Bulk_Docusign_Settings__c.getInstance('Default');
        if(docusignSetting != null && !isBatchScheduled){
        	//system.schedule(batchName + dt, sch, new DG_DocusignSentForSignature()); 
        	id batchId = system.scheduleBatch(new DG_DocusignSentForSignature(null),batchName + dt, 1, 10);
        	docusignSetting.DocusignJobScheduled__c = true;  
        	update docusignSetting; 
        }       
    } 
     
  
    
    public static void scheduleBatchSentForSignatureForMinute(integer afterMinutes){
        scheduleBatchSentForSignature(0, afterMinutes, null);
    }
      
    public static void scheduleBatchSentForSignatureForHour(integer afterHours){
        scheduleBatchSentForSignature(afterHours, 0, null);
    }	
    
    
}