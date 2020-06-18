// 
// (c) 2014 Appirio, Inc. 
//
// Description : Controller class for DG_EmployeeAcknowledgement page. This will show document and all user to accept and decline.
//
// 17 Jan 2014 Manisha Gupta Original
//
public class DG_EmployeeAcknowledgement {
	
	public string listEmpTempId;
	public string documentName{get;set;}
	public List_Employee_Template__c listEmpTemp;
	public boolean isPreviouslyDeclined{get;set;}
	public boolean showAccept {get;set;}
	public transient Attachment document{get;set;} 
	public DG_EmployeeAcknowledgement(){
		if(Apexpages.currentPage().getParameters().containsKey('listEmpTempId')){
			listEmpTempId = Apexpages.currentPage().getParameters().get('listEmpTempId');
		}	
		
		showAccept = false;
		if(Apexpages.currentPage().getParameters().get('showAccept') == 'true'){
			showAccept = true;
		}	
		
		
		for(List_Employee_Template__c tempListEmpTemp : [Select List_Employee__c, Template__c, Template__r.Name, Document_Declined_On__c, 
														   Document_Accepted_On__c , Document_Last_Viewed_On__c
														   from List_Employee_Template__c 
														   where Id = :listEmpTempId]){
														   	
	   		listEmpTemp = tempListEmpTemp;
	   		documentName = tempListEmpTemp.Template__r.Name;
			isPreviouslyDeclined = listEmpTemp.Document_Declined_On__c <> null ? true : false;
	   	}
	   	if(listEmpTemp == null) {
	   		ApexPages.AddMessage(new apexpages.Message(ApexPages.severity.ERROR, 'List Employee Template Record not found'));
	   		return;
	   	}
		for(Attachment tempDoc : [Select parentId, parent.Name, body 
								  from Attachment 
								  where parentId = :listEmpTemp.Template__c order by createdDate desc limit 1]){
			document = tempDoc;						  	
		}
		if(document == null){
			ApexPages.AddMessage(new apexpages.Message(ApexPages.severity.ERROR, 'No attached document found on template ' + documentName));
	   		return;
		}
	}
	
	public void updateLastViewedOn(){
		listEmpTemp.Document_Last_Viewed_On__c = datetime.now();
		update listEmpTemp;
	}
	
	public void accept(){
		listEmpTemp.Document_Accepted_On__c = datetime.now();
		listEmpTemp.Document_Declined_On__c = null;
		update listEmpTemp;
		
		
	}
	
	public PageReference accept2(){
		listEmpTemp.Document_Accepted_On__c = datetime.now();
		listEmpTemp.Document_Declined_On__c = null;
		update listEmpTemp;
		
		return new PageReference('/' + 'apex/DG_DocAckQ');
	}
	
	public PageReference cancel(){
		
		return new PageReference('/' + 'apex/DG_DocAckQ');
	}
	
	public void decline(){
		listEmpTemp.Document_Accepted_On__c = null;
		listEmpTemp.Document_Declined_On__c = datetime.now();
		update listEmpTemp;
		
		 
	}
}