/***********************************************************************************************
*  This class is used by the force.com scheduler to run the batch process for reference letter
*  reminder emails
*
* Change Log:
*
* 12/3/14 - MRM Created Class
*
*************************************************************************************************/
global class RL_Execute_Reminder_SendEmails  implements Schedulable
{ 
    global void execute(SchedulableContext SC) 
    { 
        id batchinstanceid = database.executeBatch(new RL_Reminder_SendEmails(),100);  
    }
}