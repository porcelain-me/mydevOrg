@isTest (SeeAllData = false)  
public class PP_ApproverReminderTest {     
    static testmethod void ApproverReminder() {
    
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
               newPRRequest.submitted_date__c = Date.today().addDays(-3);
               newPRRequest.Removal_Date__c  = Date.today().addDays(+2);   
               newPRRequest.Status__c='Submitted';   
                  Datetime CDate = Datetime.now().addHours(-5);
               String CreatedDate = CDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');    
               Datetime SDate = Datetime.now();      
    String SubmittedDate = SDate.format('yyyy-MM-dd'); 
               update newPRRequest;
             system.debug('---------------- PR Request ---------------'+newPRRequest+CreatedDate);  
               
              Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
              system.debug('---------------- Prop Detail ---------------'+PropDetail); 
               
               
               
               Test.startTest(); 
               PP_ApproverReminder c = new PP_ApproverReminder();
			   C.QUERY   =    'Select id,Name,Property_Service_Approver__c,Status__c,Approvers_List__c,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\'  AND Removal_Date__c > ' +SubmittedDate +'  AND  submitted_date__c <=' +SubmittedDate;

               ID batchprocessid = Database.executeBatch(c);
    		   Test.StopTest();
               
		   }
        Integer i = [SELECT COUNT() FROM PR_Request__c];
        System.assertEquals(i, 1);
} 
    
   
}