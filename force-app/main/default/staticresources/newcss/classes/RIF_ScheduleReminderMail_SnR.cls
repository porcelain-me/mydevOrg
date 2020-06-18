/*
 * This class is used to schedule jobs to send emails to users using force.com schedular
 *
 * Change Log :
 *
 * 15/04/2016 - Created by Avinash Munaga 
 *
 */

global with sharing class RIF_ScheduleReminderMail_SnR implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        Id batchInstanceId = Database.executeBatch(new RIF_SendEmails(), 100);
    }

}