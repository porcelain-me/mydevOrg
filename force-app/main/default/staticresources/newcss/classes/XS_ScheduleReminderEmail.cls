/*
 * This class is used to schedule jobs to send emails to users using force.com scheduler
 *
 * Change Log :
 *
 * 02/03/2016 - Created by Avinash Munaga 
 *
 */

global with sharing class XS_ScheduleReminderEmail implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        Id batchInstanceId = Database.executeBatch(new XS_SendEmails(), 100);
    }
}