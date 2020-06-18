/***********************************************************************************************
*  This class is used by the force.com scheduler to run the batch process for global parking
*
* Change Log:
*
* 4/7/15 - MRM Created Class
*
*************************************************************************************************/
global class GP_AssignmentExpirationExecute  implements Schedulable
{ 
    global void execute(SchedulableContext SC) 
    { 
        id batchinstanceid = database.executeBatch(new GP_AssignmentExpiration(),1000);  
    }
}