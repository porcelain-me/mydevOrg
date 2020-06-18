@isTest(SeeAllData = false) 
public class PP_ScheduleAllBatchesTest {
    
     static testmethod void PPRecord()
      {
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser)
         {
	
                    String CRON_EXP = '0 0 0 1 1 ? 2025';  
                    String jobId = System.schedule('testScheduledApex', CRON_EXP, new PP_ScheduleAllBatches() );

                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
					
                    System.assertEquals(CRON_EXP, ct.CronExpression); 
                    System.assertEquals(0, ct.TimesTriggered);
                    System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
         }
         Test.stopTest();
      }
}