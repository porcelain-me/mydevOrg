@isTest (SeeAllData = false)  
public class PP_ScheduleAutoCancelTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
static testmethod void ScheduleAutoCancelTest() {    
        User PPUser = PP_TestData.getSystemAdminTempUser();       
         System.runAs(PPUser) 
           { 
            
              Test.startTest();

      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new PP_ScheduleAutoCancel());
             
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

   
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

     
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run 
    
      System.assertEquals('2022-03-15 00:00:00', 
         String.valueOf(ct.NextFireTime));
      // Verify the scheduled job hasn't run yet. 
    
      Test.stopTest();
    
		   }
}
    
}