@isTest (SeeAllData = false) 
public class PP_CategoryWrapperTest {
		static testmethod void PPCategoryWrapperTest() {
    
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
           {  
               Test.startTest();
               Building_Locations__c BL=PP_TestData.insertBuilding();
               
               system.debug('----------------- Building Location ---------------'+BL);   
               PP_CategoryWrapper C = new PP_CategoryWrapper();
               c.cat = BL;
               c.checked=false;
               Test.stopTest();
               Integer i = [SELECT COUNT() FROM Building_Locations__c];
            System.assertEquals(i, 1);
           }
            
     }
    
}