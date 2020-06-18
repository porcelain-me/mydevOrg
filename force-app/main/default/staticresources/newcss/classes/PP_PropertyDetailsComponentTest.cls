@isTest (SeeAllData = false)  
public class PP_PropertyDetailsComponentTest {     
    static testmethod void PropertyDetailsComponent() {
    
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
           newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2); 
           newPRRequest.submitted_date__c = Date.today().addDays(-3); 
           newPRRequest.Status__c='Submitted';  
               
           //newPRRequest.CC_WatchList__c = 'middle.middle@morganstanley.com';    
           //newPRRequest.Approvers_List__c = 'first.first@morganstanley.com;last.last@morganstanley.com';            
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property1',Property_Name__c='Documents',Description__c='Desc',Boxes__c='1',Items__c='2',Pallets__c='3');
           insert PropDetail;
          
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
               
           Test.startTest(); 
           PP_ProperyDetailsComponent PPC = new PP_ProperyDetailsComponent();
           PPC.RequestId = newPRRequest.id;    
           PPC.getPropertyDetails();
               
           PPC.getPropertyDetailsTotal();  
           
           
           PPC.getPropertyDetailsTotal();    
           Test.stopTest();
    
		   }
         Integer i = [SELECT COUNT() FROM Property_Detail__c];
              System.assertEquals(i, 1);
} 
    
   
}