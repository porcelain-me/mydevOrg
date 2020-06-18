/*
* created by Avinash Munaga on 10/20/2014
* This schduler is called at certain interveals of time which updates Reference Letter Request Object
* which in turn calls the trigger to send reminder emails
*/
@isTest
global with sharing class RL_Reminder_Scheduler implements Schedulable {
    
    // default implementation of execute method of schdulable interface
    global void execute(SchedulableContext context){
        // ID batchProcessId = Database.executeBatch(new RL_UpdateObject(requestId, requestStatus),50);
        ID batchProcessId = Database.executeBatch(new RL_Reminder_BatchUpdate(), 100);
        
        /*RL_Reminder_SendMail sendMail = new RL_Reminder_SendMail();
        sendMail.setMailContent();*/
    }
}