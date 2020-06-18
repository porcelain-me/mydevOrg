/***********************************************************************************************
*  This class is used by the force.com scheduler to run the batch process for permission set audit file
*
* Change Log:
*
* 2/3/15 - MRM Created Class
*
*************************************************************************************************/
global class SYS_Execute_AuditBatch implements Schedulable
{ 
    global void execute(SchedulableContext SC) 
    { 
        id batchinstanceid = database.executeBatch(new SYS_Audit_Batch(),5000);   
    }
}