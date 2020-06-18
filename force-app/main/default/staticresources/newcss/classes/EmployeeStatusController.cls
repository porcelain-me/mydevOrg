/******************************************************************************************
* Employee Status Controller -	This is the controller to handle dual status app 
*								 
*
*
* ChangeLog:
*
*	9/12/14 - Created by Mark R. Moser
*
*******************************************************************************************/

public without sharing class EmployeeStatusController { 
	 

	
	public List<Employee__c> foundlist{get;set;}
	
	public Employee__c e {get;set;}
	
 	
	public EmployeeStatusController () {
		
		e = new Employee__c();
	}
	
	
	/******************************************************************************************
	* EXIT	 
	*
	*******************************************************************************************/
	
	public PageReference exit(){
		
		
        return new PageReference('/500/o'); 
    }
    
    /******************************************************************************************
	* SEARCH -	Searches for accts
	*
	*******************************************************************************************/
    
	public PageReference search(){
		
		foundList = new List<Employee__c>();
		
		foundList = [select id, name, emp_ID__c from Employee__c where id = :e.Search_for_FA__c and ffap_is_fa__c = true]; 
		
		
		if (foundList.size() == 0)
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No FA found with that name!'));
		
		return null;
	}
	

}