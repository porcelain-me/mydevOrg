public with sharing class DocusignStatusManager {
    public static void handleTrigger(List<dsfs__DocuSign_Status__c> triggerNew, map<Id, dsfs__DocuSign_Status__c> triggerOldMap, boolean isInsert, boolean isUpdate,
                                                        boolean isDelete, boolean isBefore, boolean isAfter){
    	// FFAP related functionality
    	if(isBefore && (isUpdate || isInsert)){
	    	Set<String> employeeIds = new Set<String>();    	
		    for(dsfs__DocuSign_Status__c ds : triggerNew){
		        if(ds.FFAP_Record__c == null && ds.Employee_Id__c != null){
		            employeeIds.add(ds.Employee_Id__c);
		        }
		    }
		    if(!employeeIds.isEmpty()){
		        map<Id, FFAP_Agreement__c> faAgreements = FFAP_DataUtil.getAgreementDetailsOnEmpRecordId(employeeIds);
		        for(dsfs__DocuSign_Status__c ds : triggerNew){
		            if(faAgreements.containsKey(ds.Employee_Id__c)){
		                ds.FFAP_Record__c = faAgreements.get(ds.Employee_Id__c).Id;
		                ds.Employee_Id__c = null;
		            }
		        }
		    }
    	}
    	
    	// Document Generator App
    	if(isAfter && isUpdate){
    		set<id> listEmployeeIds = new set<id>(); 
    		list<Attachment> lstAttachment = new list<Attachment>();
    		list<List_Employee__c> lstListEmployee = new list<List_Employee__c>();
    		string listName;
    		for(dsfs__DocuSign_Status__c ds : triggerNew){
                if(ds.List_Employee__c != null && ds.dsfs__Envelope_Status__c == DG_DataUtil.DECLINED){
                    lstListEmployee.add(new List_Employee__c(id=ds.List_Employee__c, Status__c = DG_DataUtil.DECLINED));
                }
            }
            
            if(!lstListEmployee.isEmpty()){
            	update lstListEmployee;
            }
        }
    }
    
    
}