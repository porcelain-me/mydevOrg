/***********************************************************************************************
*  This class is used by the force.com scheduler to run the batch process for dual employment
*  reminder emails
*
* Change Log:
*
* 12/3/14 - MRM Created Class
*
*************************************************************************************************/
global class DH_ExecuteBatchEligEvaluation  implements Schedulable
{ 
    global void execute(SchedulableContext SC) 
    { 
        id batchId = Database.executeBatch(new DH_BatchEligibleEvaluation(), 1000);
    }
}