public with sharing class DG_ScheduleFuture {
	@future
	public static void submitJob(){
		
		id batchId = Database.executeBatch(new DG_DocusignSentForSignature(), 10); 
		
	}
	
	@future
	public static void insertJob(String name){
		
		DG_Trigger_Job__c j =  new DG_Trigger_Job__c(name = name);
		insert j;
		
	} 
}