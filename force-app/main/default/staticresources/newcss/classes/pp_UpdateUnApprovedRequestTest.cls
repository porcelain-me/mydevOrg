@isTest (SeeAllData = false)  
public class pp_UpdateUnApprovedRequestTest {     
    static testmethod void UpdateUnApprovedRequest() {
    
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
           { 
            User tempUser = PP_TestData.getSystemAdminTempUser();
           system.debug('-----------------User ---------------'+tempUser);
             
           Employee__c empSource1 = PP_TestData.insertManagerEmployee();
           system.debug('-----------------Manager Employee ---------------'+empSource1);
             
           Employee__c empSource = PP_TestData.insertEmployee(empSource1, tempUser);
           system.debug('----------------- Employee ---------------'+empSource);  
             
           Building_Locations__c BL=PP_TestData.insertBuilding();
           system.debug('----------------- Building Location ---------------'+BL);                       
              
           PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           system.debug('---------------- PR Request ---------------'+newPRRequest);          
           newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2); 
           newPRRequest.Removal_Date__c = Date.today().addDays(-3); 
           newPRRequest.Status__c='Submitted';                
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
                      
               Test.startTest(); 
               pp_UpdateUnApprovedRequest c = new pp_UpdateUnApprovedRequest( );
               
               Database.executeBatch(c);
               Test.stopTest();
    
		   }
        Integer i = [SELECT COUNT() FROM PR_Request__c];
        System.assertEquals(i, 1);
} 
    
   
}