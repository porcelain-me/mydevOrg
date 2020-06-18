public class SystemAccessRequestTriggerHandler {

	public static void handleAfterUpdate(Map<Id,System_Access_Request__c> oldRequests, Map<Id,System_Access_Request__c> updatedRequests) {
        List<System_Access_Grant__c> grantInsertList = new List<System_Access_Grant__c>();
        for(Id sfId : oldRequests.keySet()) {
            if(oldRequests.get(sfId).Status__c != updatedRequests.get(sfId).Status__c && 'Approved'.equals(updatedRequests.get(sfId).Status__c)) {
                System_Access_Grant__c grant = new System_Access_Grant__c(System_Access_Request__c = sfId);
            	grantInsertList.add(grant);
            }
        }
        if(!grantInsertList.isEmpty()) {
            insert grantInsertList;
        }
	}
}