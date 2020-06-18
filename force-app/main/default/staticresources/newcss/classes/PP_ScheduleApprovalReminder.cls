global class PP_ScheduleApprovalReminder implements Schedulable {
   global void execute(SchedulableContext sc) {
      PP_ApproverReminder b = new PP_ApproverReminder(); 
      database.executebatch(b);
   }
}