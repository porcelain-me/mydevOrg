global class ScheduleCommon_UpdateUserBatch implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        String query='Select Username,ID, Short_Id__c,isActive from User where Short_Id__c!=null order by Short_Id__c';
        Common_UpdateUserBatch cb = new Common_UpdateUserBatch(query);
        Database.executeBatch(cb,2000);
    }
}