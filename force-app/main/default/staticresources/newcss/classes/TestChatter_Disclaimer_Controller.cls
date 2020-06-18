/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestChatter_Disclaimer_Controller {
	
	static User usr;
    
     static{
         T1C_CustomSettingsManager.setAllTriggerOn(); 
         User usrtest = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        // temp user
        system.runAs(usrtest){
           usr =   CM_TestClassUtilities.getTempUser();
        }
    }
    

   static testmethod void testChatter_Disclaimer_Controller() {
       //T1C_CustomSettingsManager.setAllTriggerOn();
       
       GPSEmployee__c emp= new GPSEmployee__c(MS_ID__c=usr.Emp_Id__c,Name=usr.LastName);
	   insert emp;
       
       System.runAs(usr){
         Test.startTest();
        
        
         Chatter_Disclaimer_Controller CDC = new Chatter_Disclaimer_Controller();
         CDC.Update_Chatter_Disclaimer_Acknowledged();        

		 GPSEmployee__c currentUser = [SELECT Id, Chatter_Disclaimer_Acknowledged__c FROM GPSEmployee__c WHERE User__c = : UserInfo.getUserId()];
         System.assertEquals(true, currentUser.Chatter_Disclaimer_Acknowledged__c);
         Test.stopTest();
       }
    
   }
}