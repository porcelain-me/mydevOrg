/******************************************************************************************
* Milestone Extension -	This is the controller to handle dual status app 
*								 
*
*
* ChangeLog:
*
*	9/12/14 - Created by Mark R. Moser
*
*******************************************************************************************/

public with sharing class DHMilestoneExtension{ 
		 
	
	public Employee__c e {get;set;}
	
	public DHMilestoneExtension (ApexPages.StandardController stdController) {
		
		this.e = (Employee__c)stdController.getRecord();
		
		e = [select dual_hat_eligible__c 
				from Employee__c 
				where id = :e.id];
		
	
	}
	

    /******************************************************************************************
	* EXIT	 
	*
	*******************************************************************************************/
	
	public PageReference checkStatus(){
		
		
		
		if (e.Dual_Hat_Eligible__c == false){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You can not edit employees that are NOT dual hat eligible; press back to continue!');
            ApexPages.addMessage(myMsg);
            return null;
		}
       	
       	return new PageReference('/' + e.id + '/e?retURL=' + e.id); 
    }
     
    
	

}