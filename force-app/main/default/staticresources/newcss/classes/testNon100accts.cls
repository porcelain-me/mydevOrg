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
private class testNon100accts {

    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        Pagereference pageRef = Page.Non100accts_Edit;
        Test.setCurrentPageReference(pageRef); 
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        
        MSET_Account__c testacct = new MSET_Account__c(name = 'Non100acctsAccount', recordtypeid=recordtypeid.id);
        insert testacct;
        Non_100_accts__c test_1 = new Non_100_accts__c();
        ApexPages.Standardcontroller non100accts = new ApexPages.Standardcontroller(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Account_Manager__c = 'TBD';
        test_1.Sales_Manager__c = 'Anthony LaSalle';
        test_1.Comments__c = 'No Comments'; 
        test_1.MSET_customer_del__c = 'Yes';
        test_1.MSET_Stage1__c = 'MSET opportunity';
        test_1.MSET_Stage2__c = 'MSET growth opportunity';
        
        insert test_1;
        
        Non100acctsController Non100accts_extn = new Non100acctsController(non100accts);
        
        Non100accts_extn.getPageTitle();
    }
    
      static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        Pagereference pageRef = Page.Non100accts_Edit;
        Test.setCurrentPageReference(pageRef); 
        
        Non_100_accts__c test_1 = new Non_100_accts__c();
        ApexPages.Standardcontroller non100accts = new ApexPages.Standardcontroller(test_1);
        
       
        
        try{ 
       insert test_1;
       }
       catch(Exception e)
       {
        
       }
        
       
    }
}