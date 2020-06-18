@isTest (SeeAllData = false)  
public class PP_HeaderComponentControllerTest {
static testmethod void HeaderComponentControllerTest() {
	 User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {     
             Test.startTest();
             PageReference pageRef = Page.PP_RequestHome;
             Test.setCurrentPage(pageRef);
             
             PP_HeaderComponentController PCC = new PP_HeaderComponentController();  
             String urlString=String.ValueOf(URL.getSalesforceBaseUrl());
             Test.Stoptest();
         }
	}
    
}