@isTest (SeeAllData = false)  
public class PP_HttpHeadererControllerTest {
static testmethod void HttpHeaderControllerTest() {
	 User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {            
             Test.startTest();
             PP_HttpHeaderController  PC = new PP_HttpHeaderController ();
             PC.AttributeKey = '12';
             PC.AttributeVal = '23';
             PC.getSideEffects();
             Test.stopTest();
             system.assertEquals(PC.AttributeKey,'12');
             
         }
	}
    
}