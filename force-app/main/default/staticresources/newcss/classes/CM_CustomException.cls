//  09/30/2011 RJ: ORIGINAL
//                 CUSTOM EXCEPTION CLASS FOR CAMPAIGN APPLICATION
//  03/26/2011 RJ: Added Four new future methods and updated logWarningMessage method. 
public class CM_CustomException extends Exception{
	 
	//03/30/2012 UV : added this custom setting
	private static CM_GENERALSETTINGS__c generalSettings = CM_GENERALSETTINGS__c.getInstance();
	public static String Default_Source_For_Exception{get{return generalSettings.Default_Source_For_Exception__c <> null ? generalSettings.Default_Source_For_Exception__c : CM_TestClassUtilities.Default_Source_For_Exception;}}
	
	 // constructor
   public CM_CustomException(String message, String messageType){
   	  System.debug(Logginglevel.WARN, messageType + ':' + message);      
   	  // defined new constructor with two string type arguments.
   	  // IMPORTANT: Require for flex implementation
   	  //            Always set this message with hyphen at the beginning and end of the message
   	  this.setMessage('-' + message + '-');
   	     	  
   }
   
   
   public CM_CustomException(String customMessage, String messageType, String originalMessage){
      // defined new constructor with two string type arguments.
      System.debug(Logginglevel.WARN, messageType + ':' + originalMessage);
      // IMPORTANT: Require for flex implementation
      //            Always set this message with hyphen at the beginning and end of the message
      this.setMessage('-' + customMessage + '-');       
   }
   
      
   public static void logWarningMessage(String message){
   	  System.debug(Logginglevel.WARN, message);   	     	        
   } 
   
   public static void logWarningMessage(List<String> messages){
      for(String msg : messages){
      	System.debug(Logginglevel.WARN, msg); 
      }             
   }     

/*  Commented by Sudarshan K. 17th Feb 2016 while Campaign Migration. 
// OBJECT NAME:   
// Batch_Log__c

// FIELDS:   
// Contact__c Lookup(Contact)   
// DML_Rows_Used__c  Number(10, 0)
// DML_Statements_Used__c  Number(10, 0) 
// Elapsed_Time__c Number(9, 9) 
// Message__c  Text(255) 
// Query_Rows_Used__c  Number(10, 0) 
// Query_Statements_Used__c  Number(10, 0)
// Source__c Text(255)

// TO DO: MOVE THE DEFAULT SOURCE to CUSTOM SETTING  
   
   @future
   public static void logException(String exceptionMessage){
   	  Batch_Log__c log = new Batch_Log__c();
	    log.message__c = exceptionMessage;
	    log.source__c = Default_Source_For_Exception;
	    insert log;
   }
   
   @future
   public static void logException(String exceptionMessage, String source){
      Batch_Log__c log = new Batch_Log__c();
      log.message__c = exceptionMessage;
      log.source__c = source;
      insert log;
   }
   
   @future   
   public static void logException(List<String> messages) {
     List<Batch_Log__c> logs = new List<Batch_Log__c>();
     for (String msg : messages) {
       Batch_Log__c log = new Batch_Log__c();
       log.message__c = msg;
       log.source__c = Default_Source_For_Exception;
       logs.add(log);
     }
     insert logs;
   }
   
   @future   
   public static void logException(List<String> messages, String source) {
     List<Batch_Log__c> logs = new List<Batch_Log__c>();
     for (String msg : messages) {
       Batch_Log__c log = new Batch_Log__c();
       log.message__c = msg;
       log.source__c = source;
       logs.add(log);
     }
     insert logs;
   }*/
}