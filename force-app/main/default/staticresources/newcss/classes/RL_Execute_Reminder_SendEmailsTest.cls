@isTest (SeeAllData = false)  
public class RL_Execute_Reminder_SendEmailsTest{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
static testmethod void ScheduleTest() {
    
        /*User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
           { */
           
              Test.startTest();

      // Schedule the test job 
    
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new RL_Execute_Reminder_SendEmails());
         
      // Get the information from the CronTrigger API object 
    
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same 
    
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run 
    
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run 
    
      System.assertEquals('2022-03-15 00:00:00', 
         String.valueOf(ct.NextFireTime));
      // Verify the scheduled job hasn't run yet. 
    
      Test.stopTest();
    
       //}
}
    
}