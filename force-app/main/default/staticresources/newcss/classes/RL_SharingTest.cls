@isTest(SeeAllData=true)
public class RL_SharingTest {
    
    public RL_SharingTest(){}
    static testmethod void sharerecord() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        
        //User tempUser = [select name from user where name = 'Avinash Munaga'];  
        system.runas(tempUser) {
            System.Test.startTest();
            
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
            newLetter.Duration_in_Day__c = '1';
            newLetter.Duration_in_Month__c = 'Year(s)';
            newLetter.Urgent_HR_Request__c = true;
            newLetter.email_q_name__c = 'RL_HRSC_Queue_ASIA'; 
            //status__c = 'Created',
            newLetter.email_requestor_email__c= 'references.asia@morganstanley.com'; 
            newLetter.set_q_email_cc__c = 'RL_HRSC_Queue_ASIA';
            newLetter.Comments__c = false;
            newLetter.SET_Q_TEMPLATE_Reminder_Template__c='Remainder_emails';
            newLetter.SET_Q_EMAIL_Reminder_Name__c='RL_HRSC_Queue_ASIA'; 
            insert newLetter;     
            
            newLetter = [select id from Reference_Letter_Request__c where id=:newLetter.id LIMIT 1];
            
            
            RL_Sharing.shareReadWrite(newLetter);        
            System.Test.stoptest();
        }
    }
    
}