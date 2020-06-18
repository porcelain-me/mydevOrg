@isTest (SeeAllData = false)  
public class PP_EnvironmentCheckTest {
	
    static testmethod void PPEnvironment()
      {
    	Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
    		PP_EnvironmentCheck EC = new PP_EnvironmentCheck ();   
             String urlString=URL.getSalesforceBaseUrl().toExternalForm();            
        }
        Test.stopTest();  
      } 
    
   
}