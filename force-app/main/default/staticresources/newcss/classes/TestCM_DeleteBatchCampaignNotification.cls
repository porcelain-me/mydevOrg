//  
// 11/14/2011 RJ: Test class for CM_DeleteBatchCampaignNotification.cls
//
//
@isTest
private class TestCM_DeleteBatchCampaignNotification {
	
	
   static testMethod void myUnitTest() {
   	  CM_TestClassUtilities.SetCamapignLimitSettings();
   	  
      Campaign_Notification__c  cNotification = new Campaign_Notification__c ();     
      cNotification.IsActive__c = false;
      cNotification.InActiveDate__c = Date.today() - 10;      
      insert cNotification;
      
     /**
       RJ:
       NOTE: WE CANNOT MAKE DeleteBatchTeamInterestStaging CLASS TO RUN UNDER A BATCHABLE JOB 
       IN A TEST CLASS BECAUSE CONTROLLER CLASS IS BATCHABLE AS WELL AS SCHEDULABLE. AS DOING THAT MIGHT
       LEAD TO FOLLOWING EXCEPTION:
              
       System.UnexpectedException: No more than one executeBatch can be called from 
       within a testmethod. Please make sure the iterable returned from your start method 
       matches the batch size, resulting in one executeBatch invocation 
     
     **/
     
     CM_DeleteBatchCampaignNotification deleteBatch = new CM_DeleteBatchCampaignNotification();
     
     deleteBatch.execute(null, new List<Campaign_Notification__c>{cNotification});
     
     deleteBatch.finish(null);
     deleteBatch = new CM_DeleteBatchCampaignNotification(200);
     deleteBatch = new CM_DeleteBatchCampaignNotification(Date.Today() + 1);
     deleteBatch = new CM_DeleteBatchCampaignNotification(200, Date.Today() + 1);
     deleteBatch.start(null);
     
     Date d = null;
     deleteBatch = new CM_DeleteBatchCampaignNotification(d);
     
     
     
    }
    
    
    
}