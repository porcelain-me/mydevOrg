global class PP_ScheduleAutoClose implements Schedulable {
   global void execute(SchedulableContext sc) {
      PP_AutoCloseRequest b = new PP_AutoCloseRequest(); 
      database.executebatch(b);
   }


}