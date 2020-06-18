/************************************************************************************
*
* 3/5/15 - MRM Create Tests
*
**************************************************************************************/
@isTest
private class TestUserRegistration {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	
        	Force_Activation__c f = new Force_Activation__c(name ='dev-1', encoded_url__c = 'hrforcedev');
			insert f;
			
			PageReference pageRef = Page.SYS_Registration;
			Test.setCurrentPage(pageRef); 
			ApexPages.currentPage().getParameters().put('shortname', 'mosermar'); 
        	ApexPages.currentPage().getParameters().put('urlId', '1'); 
        	
        	User_Registration__c u = new User_Registration__c(shortname__c = 'mosermar');        	
        	
        	User_RegController uC = new User_RegController();
        	uC.grabAndGo();
        	
        	
        	Test.StopTest();
     
    }
   
   
   
}