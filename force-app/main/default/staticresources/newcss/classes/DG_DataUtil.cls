// 
// (c) 2014 Appirio, Inc. 
//
// Description : Utility class for Employee Acknowledgement App containing all queries.
//
// 08 Jan 2014 Jitendra Kothari Original
// 04 Feb 2014 Jitendra Kothari Added new soql queries
//
public without sharing class DG_DataUtil{
    public static final String SUCCESS = 'Success';
    public static final String INITIAL = 'DocuSign';
    public static final String DECLINED = 'Declined';
    public static final String PENDING = 'Pending';
    public static final String ACCEPTED = 'Accepted';
    public static final String PDF = 'Acknowledgement';    
    public static final integer BATCH_SCHEDULE_HOUR = 1;
    public static final integer BATCH_SCHEDULE_MINUTE = 2;
    
    public static list<List_Employee__c> getListEmployees(id listId){
        return [select Id, Is_Sent_for_Signature__c, List__c, Employee__c, 
                    list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name, list__r.Email_Body__c,
                    list__r.Email_Subject__c, list__r.Action_Required_By_Date__c,
                    Employee__r.Email__c, Employee__r.Emp_id__c, Employee__r.Name, Employee__r.Status__c, 
                    Employee__r.Docusign_GUID__c, Employee__r.First_Name__c, Employee__r.Last_name__c
                from List_Employee__c
                where List__c = :listId
                    and status__c <> 'Sent'];
    }
    
    public static Integer getListWithName(String name){
    	return [SELECT count() FROM List__c WHERE Name = :name limit 1];
    }
    
    /*public static List<List__c> getListWithNames(Set<String> name){
        return [SELECT Id, Name FROM List__c WHERE Name IN :name];
    }*/
    
    public static list<List_Employee__c> getListEmployeesOnEmpId(id listId, string empId){
        return [select Id, Is_Sent_for_Signature__c, List__c, Employee__c, status__c,
                    list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name, list__r.Email_Body__c,
                    list__r.Email_Subject__c, list__r.Action_Required_By_Date__c,
                    Employee__r.Email__c, Employee__r.Emp_id__c, Employee__r.Name, Employee__r.Status__c, 
                    Employee__r.Docusign_GUID__c, Employee__r.First_Name__c, Employee__r.Last_name__c
                from List_Employee__c
                where List__c = :listId
                    and Employee__r.Emp_id__c =: empId];
    }
    
    public static list<List_Employee__c> getListEmployeesOnEmpRecordId(id listId, Id empRecordId){
        return [select Id, Is_Sent_for_Signature__c, List__c, Employee__c, status__c,
                    list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name, list__r.Email_Body__c,
                    list__r.Email_Subject__c, list__r.Action_Required_By_Date__c,
                    Employee__r.Email__c, Employee__r.Emp_id__c, Employee__r.Name, Employee__r.Status__c, 
                    Employee__r.Docusign_GUID__c, Employee__r.First_Name__c, Employee__r.Last_name__c
                from List_Employee__c
                where List__c = :listId
                    and Employee__c =: empRecordId limit 1];
    }
    public static list<List_Employee__c> getListEmployeesForError(id listEmpId){
        return [SELECT Id, Error__c                    
                FROM List_Employee__c
                WHERE Id = :listEmpId
                    AND Status__c = 'Failed' limit 1];
    }
    
    public static list<List_Employee__c> getListEmployeesOnListIds(set<id> listIds){
        return [select Id, List__c, Employee__c
                from List_Employee__c
                where List__c in :listIds
                AND List__r.Enable_for_Acknowledgement__c = true];
    }
    
    public static list<List_Employee__c> getListIdOnListEmployees(set<id> listEmpId){
        return [select Id, List__c, List__r.Name, Status__c, Is_Sent_for_Signature__c
                from List_Employee__c
                where id IN :listEmpId];
    }
    
    public static List<List_Employee__c> getListEmployeeRecordsOnEmp(Id empRecordId){
        return [SELECT Id, List__r.Enable_for_Acknowledgement__c 
                   FROM List_Employee__c 
                   WHERE Employee__c = :empRecordId
                   and List__r.Enable_for_Acknowledgement__c = true];
    }
    
    public static list<List_Template__c> getListTemplateForAcknowledgement(set<id> listIds){
        return [select id, List__c, Template__c
                from List_Template__c
                where (List__c IN :listIds OR Id IN :listIds)
                AND List__r.Enable_for_Acknowledgement__c = true
                AND Template__r.Template_Type__c = :PDF];
    }
    
    public static list<List_Template__c> getListTemplate(set<id> listIds){
        return [select id, List__c, Template__c, Template_Title__c ,
                    list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name
                from List_Template__c
                where List__c in :listIds];
    }
    
    public static list<List_Template__c> getListTemplate(id listId){
        return getListTemplate(new Set<Id>{listId});
    }
    
    public static list<List_Template__c> getListTemplateOnType(id listId, string templateType){
        return [select id, List__c, Template__c, Template_Title__c,
                    list__r.Is_Sent_for_Signature__c, list__r.Total_Employees__c, list__r.Name
                from List_Template__c
                where List__c = :listId
                    and Template__r.Template_Type__c =: templateType];
    }
    
    public static list<Attachment> getTemplateAttachment(set<id> parentIds){
        return [select id, Body, Name, BodyLength, ParentId  
                from Attachment 
                where ParentId in : parentIds order by createddate desc];
    }
    
    public static list<Employee__c> getEmployees(set<id> employeeIds){
        return [select id, Email__c, Emp_id__c, Name
                from Employee__c
                where id in :employeeIds];
    }
    
    public static List<Employee__c> getEmployeeForUser(Id userId){
        return [SELECT Id, Emp_Id__c FROM Employee__c WHERE User__c = :userId limit 1];
    }
    
    public static List<Employee__c> getEmployeesOnEmpId(String empId){
        return [SELECT Id, Name, Emp_Id__c
                                        FROM Employee__c WHERE Emp_Id__c = :empId limit 1];
    }
    
    public static list<Template__c> getTemplates(set<id> templateIds){
        return [select id, Title__c, Template_Type__c
                from Template__c
                where id in : templateIds];
    }
    
    public static List__c getListDetails(Id listId){
        return [select id, docusign_status__c, Is_Sent_For_Signature__c from List__c where Id =: listId limit 1];
    }
    
    public static List<List__c> getListDetailsOnId(Id listId){
        return [select id, Is_Sent_For_Signature__c from List__c where Id =: listId limit 1];
    }
    
    public static List__c getListDetailsAvailableForSignature(){
    	for(List__c listTemp : [SELECT Id, Name, DocuSign_Status__c, Sent_For_Signature_Date__c, Signature_Submittor__c 
                            from list__c 
                            WHERE DocuSign_Status__c IN ('Ready','Processing') 
                            order by Sent_For_Signature_Date__c asc LIMIT 1]){
            return listTemp;
        }
        return null;
    }   
     
    public static List__c getListEnvelopesAvailableForSignature(){
    	for(List__c listTemp : [SELECT Id, Name, embedded_email_status__c, DocuSign_Status__c, Sent_For_Signature_Date__c, Signature_Submittor__c 
                            from list__c 
                            WHERE Embedded_Email_Status__c = 'Ready' 
                            order by Sent_For_Signature_Date__c asc LIMIT 1]){
            return listTemp;
        } 
        return null;
    }    
    
    public static List<List__c> getReadyListRecords(){
    	return [SELECT Id 
                    FROM List__c 
                    WHERE DocuSign_Status__c  = 'Ready' 
                    order by Sent_For_Signature_Date__c asc];
    }
    public static List<List_Employee_Template__c> getListEmpTemplatesOnListEmployees(set<Id> lstEmpIds){
    	return [SELECT Id, Document_Accepted_On__c, Document_Declined_On__c, Document_Last_Viewed_On__c,
                            List_Employee__r.List__r.Action_Required_By_Date__c, Template__r.Title__c, List_Employee__r.List__r.document_display_name__c
                         FROM List_Employee_Template__c 
                         WHERE List_Employee__c IN :lstEmpIds
                         and Template__r.Template_Type__c = :DG_DataUtil.PDF
                         order by List_Employee__r.List__r.action_required_by_date__c];
    }    
    
    public static List<User> getUserDetail(Id userId){
        return [SELECT Id, Emp_Id__c FROM User WHERE id = :userId limit 1];
    }
    
    public static boolean checkIfBatchJobScheduled(string batchName){
    	Integer runningBatchCount = [SELECT count() 
						                From CronTrigger
						                where state != 'DELETED' 
						                and CronJobDetail.Name like :batchName+'%' ];
                    
        if(runningBatchCount > 0){
            return true;
        }
        return false;
    }
    public static boolean checkIfBatchIsAlreadySubmitted(String apexClassName){     
        // find out the last time the job ran for specified class
        Integer runningBatchCount = [SELECT count() 
                                          FROM  AsyncApexJob 
                                          WHERE ApexClass.Name = :apexClassName
                                          AND Status in ('Queued', 'Processing')
                                          limit 1];
        if(runningBatchCount > 0){
            return true;
        }
        return false;
    }
    public static List<OrgWideEmailAddress> getOrgWideEmaillAddresses(String name){
    	return [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = :name limit 1];
    }
    
    public static List<List_Employee__c> getListEmployeesFromParentList(String status, String parentListId, String latestProcessedEmpId, Integer rowCount){    	
    	if(status == 'All'){
            return [Select Employee__c, Employee__r.Emp_Id__c  
                        from List_Employee__c 
                        where List__c = :parentListId 
                        and Employee__r.Emp_Id__c > :latestProcessedEmpId
                        order by employee__r.Emp_Id__c asc
                        limit :rowCount];
        }
        return [Select Employee__c, Employee__r.Emp_Id__c  
                    from List_Employee__c 
                    where List__c = :parentListId 
                    and Employee__r.Emp_Id__c > :latestProcessedEmpId
                    AND Status__c = :status
                    order by employee__r.Emp_Id__c asc
                    limit :rowCount];
    }
}