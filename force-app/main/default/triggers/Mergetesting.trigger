trigger Mergetesting on Lead (Before update, after update, before delete, after delete) {


if(Trigger.isBefore && Trigger.isDelete){
   for (Lead delLead: Trigger.old){
   }

}

}