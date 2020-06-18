// 
// (c) 2014 Appirio, Inc. 
//
// Description : Controller class for DG_ListClone page. This will clone the entire list, related list employees and list templates.
//
// 08 Jan 2014 Jitendra Kothari Original
//
global class DG_ListClone {
	
	public List__c parentList{get;set;}
	public List__c clonedList{get;set;}
	public String successMessage{get;set;}
	public String status{get;set;}
	private static final map<String, String> mapListEmpStatus = new map<String, String>{'All Records' => 'All', 
																						'Error Records' => 'Failed',
																						'Decline Records' => 'Declined'};
    public DG_ListClone(ApexPages.StandardController stdController) {
    	parentList = (List__c)stdController.getRecord();
    	
    	List__c temp = [select document_display_name__c from List__c where id = :parentList.id];
    	
    	
    	clonedList = new List__c();
    	clonedList.document_display_name__c = temp.document_display_name__c;
    	successMessage = DG_DataUtil.SUCCESS;
    }
    
    public void cloneRecord(){
    	Integer noListWithEnteredName = DG_DataUtil.getListWithName(clonedList.Name);
    	if(noListWithEnteredName > 0){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'List Name already exists.'));
    		return;
    	}
		status = mapListEmpStatus.get(clonedList.Clone_List_For__c);
		try{
			insert clonedList;
		}catch(exception ex){
			ApexPages.addMessages(ex); 
		}
		
		cloneListTemplates();
    }
    
    // Clone List Template Records from parent list to cloned list
    private void cloneListTemplates(){
    	List<List_Template__c> clonedListTemplates = new list<List_Template__c>();
    	/*for(List_Template__c parentListTemplate : [Select Id, Template__c 
    												from List_Template__c 
    												where List__c = :parentList.Id]){*/
        for(List_Template__c parentListTemplate : DG_DataUtil.getListTemplate(parentList.Id)){
    		clonedListTemplates.add(new List_Template__c(List__c = clonedList.Id, Template__c = parentListTemplate.Template__c));
    	}
    	if(!clonedListTemplates.isEmpty()){
			insert clonedListTemplates;
    	}
    }
    
    public static Integer getremainingDMLRows(){
    	return limits.getLimitDmlRows() - limits.getDmlRows();
    }
    // Clone List Employee Records from parent list to cloned list
    webservice static String cloneListEmployees(String latestProcessedEmpId, String clonedListId, String parentListId, String status){
    	system.debug('method called******************');
    	List<List_Employee__c> clonedListEmployees = new list<List_Employee__c>();
    	String latestEmpId = '';
    	List<List_Employee__c> empList = DG_DataUtil.getListEmployeesFromParentList(status, parentListId, latestProcessedEmpId, getremainingDMLRows());
    	/*if(status == 'All'){
    		empList = [Select Employee__c, Employee__r.Emp_Id__c  
                                                    from List_Employee__c 
                                                    where List__c = :parentListId 
                                                    and Employee__r.Emp_Id__c > :latestProcessedEmpId
                                                    order by employee__r.Emp_Id__c asc
                                                    limit :getremainingDMLRows()];
    	}else{
    		empList = [Select Employee__c, Employee__r.Emp_Id__c  
                                                    from List_Employee__c 
                                                    where List__c = :parentListId 
                                                    and Employee__r.Emp_Id__c > :latestProcessedEmpId
                                                    AND Status__c = :status
                                                    order by employee__r.Emp_Id__c asc
                                                    limit :getremainingDMLRows()];
    	}*/
    	for(List_Employee__c parentListEmployee : empList){
    													
			clonedListEmployees.add(new List_Employee__c(List__c = clonedListId, Employee__c = parentListEmployee.Employee__c));
			if(parentListEmployee.Employee__r.Emp_Id__c > latestEmpId){
				latestEmpId = parentListEmployee.Employee__r.Emp_Id__c;
			}
    	}
		if(!clonedListEmployees.isEmpty()){
			try{
				insert clonedListEmployees;
				return latestEmpId;
			}catch(exception ex){
				System.debug('Error while inserting List Employee Records - ' + ex.getMessage());
				return 'Error : ' + ex.getMessage();
			}
		}
    	
    	return DG_DataUtil.SUCCESS;
    }
    
    public PageReference navigateToClonedListRecord(){
    	return new PageReference('/' + clonedList.Id);
    }
    
    public void deleteClonedListRecord(){
    	delete clonedList;
    }
}