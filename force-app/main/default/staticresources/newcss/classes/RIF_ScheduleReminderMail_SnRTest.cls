@istest
public class RIF_ScheduleReminderMail_SnRTest {

     public static testMethod void RIF_ScheduleReminderMail_SnRTest () {
        String CRON_EXP = '0 0 0 15 3 ? 2032';
      	Test.startTest();
        RIF_ScheduleReminderMail_SnR srm = new RIF_ScheduleReminderMail_SnR();
        //Database.executeBatch(srm);
        String schedId = system.schedule('Test - 0988 Job', CRON_EXP, srm);
        test.stopTest();
             
         }
     
     }