@isTest(SeeAllData=true)
public class RL_RejectionCommentsTest1 {
    
    public RL_RejectionCommentsTest1()
    {
    system.debug('------------Test------------');
    }
        
    static testmethod void testRejComments()
    {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
      
       //User tempUser = [select name from user where name = 'Namita Shaha' LIMIT 1];  
       system.runas(tempUser)
       {
       Test.startTest();   
                     
       Employee__c newEmployee = RL_TestData.createEmp();
           
       Reference_Letter__c refLetter = RL_TestData.createRefRL0016(); 
       
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id;  
        newLetter.Address_by_Reference__c ='Name and Address';
        newLetter.Company_Address_Title__c = null;
        newLetter.Company_Address_SName__c = null;
        newLetter.Company_Address_Name__c =null;   
        newLetter.Company_Name__c = null;
        newLetter.Company_Address_1__c  = null;
        newLetter.Company_Address_3__c = null;
        newLetter.Company_Address_PC__c  = null;           
        newLetter.Conga_Employee_Gender__c = 'Female';        
        newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
        newLetter.Conga_Adj_Hire_Date__c = date.today();                        
        newLetter.Conga_Covenant_Date__c= date.today();                             
        newLetter.For_Employee__c = newEmployee.id;           
        newLetter.Requesting_Employee__c = newEmployee.id;                            
        insert newLetter;         
        
        /*
         Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
         request.setComments('Submitted the request for approval.');
         request.setObjectId(newLetter.Id);        
         Approval.ProcessResult result = Approval.process(request);
          
        //Call RL_Validate Controller
        RL_RejectionComments rct = new RL_RejectionComments();
        List<ProcessInstanceHistory> testList = rct.getApprovalSteps();
        // List<ProcessInstanceHistory> testList1 = rct.getApprovalProcessStatus();      
       */
       
       Test.stopTest();
    }    
    
    } 
    
}