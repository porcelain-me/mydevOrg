@isTest(SeeAllData=true)
public class RL_Reminder_BatchUpdateTest {
    
    public RL_Reminder_BatchUpdateTest()
    {
    system.debug('------------Test------------');
    }
           
	static testmethod void ReminderBatchUpdate()   
    {
      
       User tempUser = [select name from user where name = 'Avinash Munaga'];  
       system.runas(tempUser)
       {
       
           
       //Reference_Letter_Request__c newLetter = RL_TestData.createRefLetterRL001();
       //st = [select id from Reference_Letter_Request__c where id = :newLetter.id LIMIT 1];
           
      /*  PageReference pageRef = Page.RL_Home;
   	    system.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(rs);
        ApexPages.currentPage().getParameters().put('success',rs.id);
        ApexPages.currentPage().getParameters().put('id',rs.id);
        ApexPages.currentPage().getParameters().put('successLoad',rs.id);
        ApexPages.currentPage().getParameters().put('visaLetterAsia',rs.id);
        ApexPages.currentPage().getParameters().put('dev',rs.id);
           */
       system.Test.startTest();       
       Copy_RL_Reminder_BatchUpdate myClass = new Copy_RL_Reminder_BatchUpdate ();              
       ID batchprocessid = Database.executeBatch(myClass);          
       system.Test.stopTest();
    }    
    
    } 
    
   /* static testmethod void ReminderBatchUpdate1()   
    {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
      
       //User tempUser = [select name from user where name = 'Namita Shaha'];  
       system.runas(tempUser)
       {
          
       Employee__c newEmployee  = RL_TestData.createEmp();
       newEmployee.Division_Dsc_Org__c	= 'Administration';
           
       update newEmployee;    
       Reference_Letter__c refLetter = RL_TestData.createRefRL0016(); 
       
       //Reference Letter Request 
       Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id;  
        newLetter.Conga_Employee_Job_Country__c = 'Hong Kong';
        
        newLetter.Conga_Super_Division_Dsc_Org__c = 'Company';
        newLetter.Conga_Employee_Department__c = 'Corporate Services';        
        newLetter.status__C = 'Rejected By HR Partner';
        newLetter.Urgent_HR_Request__c =  true;           
        //newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';                                
        newLetter.For_Employee__c = newEmployee.id;           
        newLetter.Requesting_Employee__c = newEmployee.id;                          
        insert newLetter;         
        
       RL_Reminder_BatchUpdate myClass = new RL_Reminder_BatchUpdate ();   
       ID batchprocessid = Database.executeBatch(myClass);    
       
    }    
    
    } */
}