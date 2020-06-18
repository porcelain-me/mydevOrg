@isTest(SeeAllData=true)
public class RL_Reminder_SchedulerTest {
    
    public RL_Reminder_SchedulerTest()
    {
    system.debug('------------Test------------');
    }
           
	static testmethod void ReminderScheduler()
    {
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
      
       //User tempUser = [select name from user where name = 'Avinash Munaga'];  
       system.runas(tempUser)
       {
       Test.startTest();            
         RL_Reminder_Scheduler myClass = new RL_Reminder_Scheduler ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);       
           
       Test.stopTest();
    }    
    
    } 
}