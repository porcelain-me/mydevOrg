@isTest
private class EM_MainPageControllerTest
{
    static testMethod void myTest() {
       
       Entitlement_Mapping__c em = new Entitlement_Mapping__c();
       ApexPages.StandardController sc = new ApexPages.StandardController(em );
       EM_MainPageController emmcr = new EM_MainPageController( sc);                //one instance to test if part
       EM_MainPageController emmcr2 = new EM_MainPageController( sc);               //another isntance to test else part
        
       test.startTest();                            //testing starts
       emmcr .eonId = 12121;
       emmcr2 .eonId = 12121;
       emmcr.selectEntProv = 'Permission Set';
       emmcr.entitlprovname = '0PSf0000000CsjF';
       emmcr2.selectEntProv = 'Profile';
       emmcr2.entitlprovname = '00ef0000000LtW2';
       emmcr.getgroupName();
       emmcr.geteonId();
       emmcr.getentitlprovname();                    //calling the methods from 2 instances so that 
       emmcr.getEntProvOptions();                    //both the if and else parts will be executed
       emmcr.EntProvFilter();
       emmcr.save();
       emmcr.getselectEntProv();
       emmcr2.EntProvFilter();         
       emmcr2.save();
       
       test.stopTest();                            //testing stops
        
       
  }
}