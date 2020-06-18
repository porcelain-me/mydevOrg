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

public with sharing class DHEmployeeStatusController { 
	 

	
	public List<wrapEmployee> foundlist{get;set;}
	
	public Employee__c e {get;set;}
	public Boolean resultsFound {get;set;}
	
 	
	public DHEmployeeStatusController () {
		
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
	* Maintain	 
	*
	*******************************************************************************************/
	
	public PageReference maintain(){
		
		String selectedID;
		
		for (Integer i=0; i < foundList.size(); i++)
			if (foundList[i].isSelected)
				selectedID = foundList[i].e.id;
		
		if (selectedID == null){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You must select and employee!');
            ApexPages.addMessage(myMsg);
            return null;
        }
		else
        	return new PageReference('/apex/dhmilestones?id=' + selectedID); 
    }
    /******************************************************************************************
	* SEARCH -	Searches for accts
	*
	*******************************************************************************************/
    
	public PageReference search(){
		
		List<Employee__c> eList = new List<Employee__c>();
		
		resultsFound = false;
		
		foundList = new List<wrapEmployee>();
		
		eList = [Select id, name, emp_ID__c from Employee__c where id = :e.Search_for_FA__c and ffap_is_fa__c = true]; 
		
		for (Employee__c e:eList){
			
			foundList.add(new wrapEmployee(e,false));
			
		}
		if (foundList.size() == 0)
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No FA found with that name!'));
		else
			resultsFound = true;
			
		return null;
	}
	
	public class wrapEmployee
    {
         
        public boolean isSelected{get;set;}
        public Employee__c e {get;set;}
        
        public wrapEmployee(Employee__c emp, Boolean sel)
        {   
            e=emp;
            isSelected = sel;
        }
    }
      
	

}