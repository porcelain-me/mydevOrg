//  11/11/2011 RJ: Added  ORIGINAL
//                 To purge all the campaign notification records those are inactive and before provided custom setting date
//
//

global class CM_DeleteBatchCampaignNotification implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
  
  
  // by default, we won't delete records fewer than 7 days old.
  private Date beforeInactiveCNExecutionDate; // = Date.Today() + 1;         // = Date.Today() - 7;
  

  private Integer recordLimit = 250000;
  
  private CM_GENERALSETTINGS__c campaignSetting = CM_GENERALSETTINGS__c.getInstance().id == null ? CM_GENERALSETTINGS__c.getOrgDefaults() : CM_GENERALSETTINGS__c.getInstance();
  
  // constructors
  public CM_DeleteBatchCampaignNotification() {
    if(campaignSetting <> null && campaignSetting.id <> null && campaignSetting.Delete_CN_Batch_Exec_Date__c <> null){
        beforeInactiveCNExecutionDate = campaignSetting.Delete_CN_Batch_Exec_Date__c;
    }
  }
  
  public CM_DeleteBatchCampaignNotification(Integer lim) {
    recordLimit = lim;
    if(campaignSetting <> null && campaignSetting.id <> null && campaignSetting.Delete_CN_Batch_Exec_Date__c <> null){
        beforeInactiveCNExecutionDate = campaignSetting.Delete_CN_Batch_Exec_Date__c;
    }
  }
  
  public CM_DeleteBatchCampaignNotification(Date beforeInactiveCNExecutionDate) {
    // only delete CN before a particular inactive datetime
    this.beforeInactiveCNExecutionDate = beforeInactiveCNExecutionDate;
  }
  
  public CM_DeleteBatchCampaignNotification(Integer lim, Date beforeInactiveCNExecutionDate) {
    recordLimit = lim;
    this.beforeInactiveCNExecutionDate = beforeInactiveCNExecutionDate;
  }


  /*** SCHEDULEABLE INTERFACE Methods ***/  
  global void execute(SchedulableContext sc) {
    id batchId = Database.executeBatch(new CM_DeleteBatchCampaignNotification(), 200);
    System.debug('\n\n==> batchId = ' + batchId); 
  }
  
  /*** BATCHABLE INTERFACE Methods ***/  
  global Database.QueryLocator start(Database.BatchableContext context) {
    if (beforeInactiveCNExecutionDate != null) {
        //Removed Order by clause
      Database.QueryLocator ans = 
          Database.getQueryLocator('Select Id From Campaign_Notification__c where IsActive__c = false and InActiveDate__c <: beforeInactiveCNExecutionDate  limit ' + recordLimit);
      return ans;      
    } else {
        return null;       
    }
  }


  global void execute(Database.BatchableContext context, List<SOBject> objects) {

    List<Campaign_Notification__c> campaignNotificationRecordsToDelete = new List<Campaign_Notification__c>();
    for(SObject sobj: objects) {
      Campaign_Notification__c campaignNotification = (Campaign_Notification__c)sobj;
      campaignNotificationRecordsToDelete.add(campaignNotification);
    }
    delete campaignNotificationRecordsToDelete;
    
    Database.emptyRecycleBin(campaignNotificationRecordsToDelete);
  }


  global void finish(Database.BatchableContext context) {
  }

}