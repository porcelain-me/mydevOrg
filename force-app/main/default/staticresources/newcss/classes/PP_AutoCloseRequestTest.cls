@isTest (SeeAllData = false)  
public class PP_AutoCloseRequestTest {     
    static testmethod void AutoCloseRequest() {
    
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
           newPRRequest.Removal_Date__C = Date.today().addDays(-3); 
           newPRRequest.Status__c='Approved';    
           newPRRequest.CC_WatchList__c = 'middle.middle@morganstanley.com';    
           newPRRequest.Approvers_List__c = 'first.first@morganstanley.com;last.last@morganstanley.com'; 
           //newPRRequest.Requestor_Email__c = 'requestor.name@morganstanley.com'; 
           //newPRRequest.Requestee_Email__c = 'requeste.name@morganstanley.com';    
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
		   d.FolderId = UserInfo.getUserId();
           d.Name='TestDoc';  
           insert d;
               
               Test.startTest(); 
               //string QUERY = 'Select id,Name,Approvers_List__c,Property_Service_Approver__c,Status__c ,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\' AND submitted_date__c<='+newPRRequest.submitted_date__c;
               PP_AutoCloseRequest c = new PP_AutoCloseRequest( );
               
               Database.executeBatch(c);
               Test.stopTest();
    
		   }
        Integer i = [SELECT COUNT() FROM PR_Request__c];
        System.assertEquals(i, 1);
} 
    
   
}