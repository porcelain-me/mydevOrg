@isTest
public class ER_buttonControllerTest {
    
    static testMethod void buttonRedirect()    
        
    {
        Case__c cs =new Case__c();
        ApexPages.StandardController sc = new ApexPages.standardController(cs);
        
        ER_buttonController buttoncontroller = new ER_buttonController(sc);
        {
            Test.startTest();
            PageReference pageRef = Page.ER_NewButtonRedirect;
            Test.setCurrentPage(pageRef);
            buttoncontroller.buttonRedirect();      
            Test.stopTest();
        }
        
        
    }
}