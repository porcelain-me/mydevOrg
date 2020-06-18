@isTest
public class ER_PINewButtonControllerTest {
    
    static testMethod void Newbutton()   {
        Case__c cs =new Case__c();
        ApexPages.StandardController sc = new ApexPages.standardController(cs);
        ER_PINewButtonController Newbuttoncontroller = new ER_PINewButtonController(sc);
        {
            Test.startTest();
            PageReference pageRef = Page.ER_PINewButton;
            Test.setCurrentPage(pageRef);
            Newbuttoncontroller.buttonRedirect(); 
            Newbuttoncontroller.discCallMethod();
            Newbuttoncontroller.hrCallMethod(); 
            Test.stopTest();
        }
    } 
}