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
@isTest(SeeAllData=false) 
private class TestPurge_Records {

   static void TestSetup(){
        TestClassutilities.setAllTriggerOn();
        List<GPSContact__c> lstCon = new List<GPSContact__c>();
        for(Integer i=0; i<100; i++){
            GPSContact__c con= new GPSContact__c();
            con.Name = 'test'+i;
            con.FirstName__c = 'fstest'+i;
            con.LastName__c= 'lstest'+i;
            lstCon.add(con);
        }
        insert lstCon;
    }
    
    static testmethod void testDelete1(){
        Test.startTest();
          TestSetup();
          id batchId = Database.executeBatch(new Purge_Records('GPSContact__c', ' LastModifiedById!=null ',10 ), 100);
          System.debug('\n\n==> batchId = ' + batchId); 
          
        Test.stopTest();
         Integer n= Database.countQuery('Select Count() from GPSContact__c where LastModifiedById!=null');
         System.AssertEquals(n,90);
    }
    
    static testmethod void testDelete2(){
        Test.startTest();
          TestSetup();
          id batchId = Database.executeBatch(new Purge_Records('GPSContact__c', ' LastModifiedById!=null ' ), 100);
          System.debug('\n\n==> batchId = ' + batchId); 
        
        Test.stopTest();
         Integer n= Database.countQuery('Select Count() from GPSContact__c where LastModifiedById!=null ');
         System.AssertEquals(n,0);
    }
    
    
}