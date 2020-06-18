public class PP_ReworkComments{

    public String requestId {get;set;}
    public String approvalStatus {get;set;}
    
    public Employee__c getActorDetails(){
        Employee__c emp;
        List<ProcessInstanceHistory> x=getApprovalSteps();
        if(x.size()>0){
            emp=[select id,emp_id__c,name from employee__C where user__C=:x[0].ActorId] ;
        }
        return emp;    
    } 
    
    public List<ProcessInstanceHistory> getApprovalSteps(){
        if (requestId != null) {
            system.debug('check the ID'+requestId);
            PR_Request__c quote = [Select Id, (Select Comments, RemindersSent, OriginalActorId, ActorId
                 From ProcessSteps where StepStatus=:approvalStatus order by SystemModstamp desc limit 1) from PR_Request__c where Id = :requestId];
            return quote.ProcessSteps;
        }
        return new List<ProcessInstanceHistory> ();
    }
    
 }