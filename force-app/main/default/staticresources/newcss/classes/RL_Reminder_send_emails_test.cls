@isTest (SeeAllData = false)  
public class RL_Reminder_send_emails_test {     
    static testmethod void ApproverReminder() {
    
         
               
               
               Test.startTest(); 
               RL_Reminder_SendEmails c = new RL_Reminder_SendEmails();               
               Database.executeBatch(c);
               Test.stopTest();
    
       }
        }