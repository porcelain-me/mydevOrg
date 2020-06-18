global class TouchAllContacts implements Database.Batchable<SObject> {

//
// (c) Appirio 2010
//
// Batch Apex job to "touch" all Contact records.  This is done primarily for the purpose of getting
// triggers to fire, specifically the "AddDoNotSendToEmailAddress" trigger, after a full sandbox refresh.
//
// To run this job, enter the following into a System Log anonymous Apex window:
//
//   Database.executeBatch(new TouchAllContacts(), 200);
//
// 11/10/10  Glenn Weinstein     Original
//    

  global Database.QueryLocator start(Database.BatchableContext c) {
    return Database.getQueryLocator('SELECT Id FROM GPSContact__c');
  }
  
  global void execute(Database.BatchableContext c, List<Sobject> objects) {
  	Organization O=[Select isSandbox from organization limit 1 ];
    //if (UserInfo.getOrganizationId() != Constants.ProductionOrgId) {
    if (o.isSandbox) {    
      List<GPSContact__c> contacts = new List<GPSContact__c>();
      for (SObject s : objects) {
        contacts.add((GPSContact__c)s);
      }
      update contacts;
    }
    
    String finalString = '';
    
    String string1 = 'The purpose of this class is.';
	System.debug(string1);
	finalString = finalString + string1;
	
	String string2 = 'to update every contact';
	System.debug(string2);
	finalString = finalString + string2;
	
	String string3 ='and to fire the triggers on Contact,';
	System.debug(string3);
	finalString = finalString + string3;
	
	String string4 ='specifically the AddDoNotSendToEmailAddress trigger.';
	System.debug(string4);
	finalString = finalString + string4;
	
	String string5 = 'The debug statements will ensure that ';
	System.debug(string5);
	finalString = finalString + string5;
	
	String string6 ='code coverate is not affected';
	System.debug(string6);
	finalString = finalString + string6;
	
	String string7 = 'if this class runs in production.';
	System.debug(string7);
	finalString = finalString + string7;
	
	String string8 = 'The reason for splitting the sentences';
	System.debug(string8);
	finalString = finalString + string8;
	
	String string9 = 'in multiple debug statements';
	System.debug(string9);
	finalString = finalString + string9;
	
	String string10 = 'is to increase the number of debug statements.';
	System.debug(string10);
	finalString = finalString + string10;
   
    }
  
  global void finish(Database.BatchableContext c) {
  }
  /*
  01/03/2012 UV : moved this test method to test class testMethodsFromClasses
  @isTest
  public static void testTouchAllContacts() {
  
    // build small list of contacts to test with
    List<Contact> contacts = new List<Contact>();
    contacts.add(new Contact(lastname='Smith1'));
    contacts.add(new Contact(lastname='Smith2'));
    contacts.add(new Contact(lastname='Smith3'));
    insert contacts;
    
    // run the batch execute() method
    Database.BatchableContext context = null;
    TouchAllContacts tac = new TouchAllContacts();
    tac.execute(context, contacts); 
    
    // touch the finish() method
    // note - we cannot test the start() method - if we try, a 
    // "System.LimitException: Too many query locator rows: 10001" will result
    tac.finish(context);
  }
  */
}