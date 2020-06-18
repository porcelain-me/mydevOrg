/*** 
 * BatchManager
 *
 * Description:
 *
 *   Coordinates the execution of different batch jobs.
 *
 ***/
public class BatchManager {
	public static final string USER_CREATION_BATCHABLE = 'FFAP_DocusignUserCreation';
	public static Batch_Settings__c settings = null;
	public static final string SETTINGS_KEY = 'Default';
	
	public BatchManager() {    
     BatchManager.settings = Batch_Settings__c.getInstance(SETTINGS_KEY);    
    }
    // Invoke this method from a Batchable class when it completes.
  public static void batchComplete(String batchableClassName) {
    new BatchManager().handleBatchComplete(batchableClassName);
  }
  
  public static void scheduleBatch(String batchableClassName) {
    new BatchManager().handleScheduleBatch(batchableClassName);
  }
  
  private void handleBatchComplete(String BatchableClassName) { 
  	String emailHandlerAddr = settings.batch_manager_email__c;    
    if (batchableClassName == USER_CREATION_BATCHABLE) {
      sendEmailTrigger(emailHandlerAddr, BatchableClassName);
    }
  }
  private void handleScheduleBatch(String BatchableClassName) {
  	if (batchableClassName == USER_CREATION_BATCHABLE) {
      runFFAPDocusignUserCreation();
    }
  }
  
  private void runFFAPDocusignUserCreation() {    
    if(!Test.isRunningTest()){
        Id batchId = Database.executeBatch(new FFAP_DocusignUserCreation(), 200);
    }
  }
  
   
  public static void sendEmailTrigger(String emailAddr, String command) {      
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
      mail.setToAddresses( new String[]{emailAddr} );
      mail.setSubject(command);
      String body  = '=============';
      mail.setPlainTextBody(body);
      Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail} );
  }
}