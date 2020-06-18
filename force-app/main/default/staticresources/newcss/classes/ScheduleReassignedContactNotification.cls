// 
//   (c) 2010 Appirio, Inc.
//
//   ScheduleReassignedContactNotification (Class to schedule Batchable Class "BatchReassignedContactNotification")
//   
//   03 Aug 2010   Prafull Gupta      Original (PR-05654).
//
//
global class ScheduleReassignedContactNotification implements Schedulable {
  
  global void execute(SchedulableContext SC) {
    BatchReassignedContactNotification batchNotification = new BatchReassignedContactNotification();
    Database.executeBatch(batchNotification);
  }
}