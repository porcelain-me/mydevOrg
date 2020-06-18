public  class PP_RejectioncommentsController {
	
	
	
	
    public String requestId {get;set;}
    public String approvalStatus {get;set;}
    
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