// 
// (c) 2014 Appirio, Inc. 
//
// Description : Controller class for DG_CreateDSEN page to send the document for signing using docusign.
//
// 20 Jan 2014 Rahul Agrawal Original
//
public with sharing class DG_CreateDSEN {
    public Id listId {get;set;}
    public String empId{get;set;}
    public boolean isError {get;set;}
    public boolean isCompleted {get;set;}    
    
    public DG_CreateDSEN (){
    	system.debug(ApexPages.currentPage().getParameters());
        if(ApexPages.currentPage().getParameters().containsKey('lid')){
            this.listId = ApexPages.currentPage().getParameters().get('lid');
        }
        
        for(User user : DG_DataUtil.getUserDetail(UserInfo.getUserId())){
        	system.debug(user);
        	this.empId = user.Emp_Id__c;
        }
               
        this.isError = false;
        this.isCompleted = false;
    }
    
    public void initiateProcess(){
    	system.debug(listId + ';'+ empId);
        if(listId == null){
            logErrorComplete('List not found.');
            return;
        }
        if(empId == null){
            logErrorComplete('Employee not found.');
            return;
        }
        
        set<Id> setTemplateIds = new set<Id>();
        for(List_Template__c listTemplate : DG_DataUtil.getListTemplateOnType(listId, DG_DataUtil.INITIAL)){
            setTemplateIds.add(listTemplate.Template__c);
        }
        Map<String, Attachment> nameToAttachmentMap = new Map<String, Attachment>();
        for(Attachment doc : DG_DataUtil.getTemplateAttachment(setTemplateIds)){
            if(!nameToAttachmentMap.containsKey(doc.parentId)){
                nameToAttachmentMap.put(doc.parentId, doc);
            }
        }
        
        if(nameToAttachmentMap.isEmpty()){
            logErrorComplete('No Documents found');
            return;
        }
        
        list<List_Employee__c> empList = DG_DataUtil.getListEmployeesOnEmpId(listId, empId);
        if(validateEmployee(empList)){
            DG_DocuSignAPI_Utilities utilities = new DG_DocuSignAPI_Utilities(empList, nameToAttachmentMap.values());
            utilities.checkDocumentsAndSendForSignature();
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Your request has been submitted. You will recieve an email once completed.'));
        }
        isCompleted = true;
        
    }
    
    private boolean validateEmployee(list<List_Employee__c> empList){
        List<String> errors;
        if(empList.isEmpty()){
            logError('List Employee not found in List.');
        }
        for(List_Employee__c emp : empList){
        	if(emp.Status__c == 'Sent'){
        		logError('Already sent for signature.');
        	}else if(emp.Employee__c == null){
                logError('Employee not found in List.');
            }else{
                errors = FFAP_CongaManager.validateEmployee(emp.Employee__r, 'Employee', true);
                if(!errors.isEmpty()){
                    logError(String.join(errors, ','));
                }
            }
        }
        if(isError){
            return false;
        }else{
            return true;
        }
    }
    
    public void logError(String error){
        isError = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
    }
    public void logErrorComplete(String error){
        isCompleted = true;
        logError(error);
    }
}