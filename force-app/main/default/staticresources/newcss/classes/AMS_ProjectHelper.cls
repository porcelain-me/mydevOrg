public with sharing class AMS_ProjectHelper {
    public class amsException extends Exception {}
    
	public static Id terminateProject(Id projectId) {
		//Check for existing project details
        List<AMS_Project__c> projects = [Select Id, Status__c From AMS_Project__c 
                                 WHERE Id = :projectId];
        if(projects.isEmpty()) {
        	throw new amsException('Project details not found');
        }
		AMS_Project__c project = projects[0];
        if(!project.Status__c.equals('Completed')) {
        	throw new amsException('You can only terminate Completed records');
        }
        
		return project.Id;
	}


}