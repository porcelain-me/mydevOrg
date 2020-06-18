global class PP_ScheduleAutoCancel implements Schedulable {
   global void execute(SchedulableContext sc) {
      pp_UpdateUnApprovedRequest b = new pp_UpdateUnApprovedRequest(); 
      database.executebatch(b);
   }


}