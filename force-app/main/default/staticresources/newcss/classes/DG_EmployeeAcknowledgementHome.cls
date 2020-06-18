//  abc// (c) 2014 Appirio, Inc. 
// test2 abc
// Description : Controller class for DG_EmployeeAcknowledgementHome page. This will show user's all document (Pending, Accespted, Declined).
//
// 17 Jan 2014 Jitendra Kothari Original
//      



//dcgfhdsftghsrdf

/* 1/8/2015 - Mark Moser - Modified class to finish implementation of this feature
*/
public class DG_EmployeeAcknowledgementHome {
    
    public List<wrapperClass> acceptedWrapper{get;set;}
    public List<wrapperClass> pendingWrapper{get;set;}
   	public List<wrapperClass> declinedWrapper{get;set;}
    
    
    public boolean showTabs{get; set;}
   
    public DG_EmployeeAcknowledgementHome (){
        List<Employee__c> empList = DG_DataUtil.getEmployeeForUser(UserInfo.getUserId());
        showTabs = false;
        if(empList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No Employee is associated with this user.'));         
            return;
        }else{
            List<List_Employee__c> lstEmps = [SELECT Id, List__r.Enable_for_Acknowledgement__c 
                   FROM List_Employee__c 
                   WHERE Employee__c = :empList.get(0).id
                   and (List__r.Enable_for_Acknowledgement__c = true or list__r.Is_Sent_for_Signature__c = true)];
                   
            if(!lstEmps.isEmpty()){
                set<Id> lstEmpIds = new set<Id>();
                for(List_Employee__c lstEmp : lstEmps){
                    lstEmpIds.add(lstEmp.Id);
                }
                getEmployeeTemplates(lstEmpIds,empList.get(0).emp_id__c);
            }
            showTabs = true;
        }
    
    }
    
    /*****************************************************************************************************************
    *
    *	Get Employee Templates 
    *   	
    *****************************************************************************************************************/
    
    public void getEmployeeTemplates(set<Id> lstEmpIds, String empId){
        
        
        system.debug('empid is: ' + empid);
        
       	acceptedWrapper = new LIst<wrapperClass>();
       	pendingWrapper = new LIst<wrapperClass>();
       	declinedWrapper = new LIst<wrapperClass>();
       	 
        
        for(List_Employee_Template__c empTemp : [SELECT Id, Document_Accepted_On__c, Document_Declined_On__c, Document_Last_Viewed_On__c,
                            List_Employee__r.List__r.Action_Required_By_Date__c
                            , Template__r.Title__c, List_Employee__r.List__r.document_display_name__c
                            ,createddate
                         	FROM List_Employee_Template__c 
                         	WHERE List_Employee__c IN :lstEmpIds
                         	and Template__r.Template_Type__c = :DG_DataUtil.PDF
                         	order by List_Employee__r.List__r.action_required_by_date__c])
        {
            if(empTemp.Document_Accepted_On__c == null && empTemp.Document_Declined_On__c == null){
                pendingWrapper.add(new wrapperClass(empTemp.List_Employee__r.List__r.document_display_name__c, 'Acknowledgement',date.valueOf(empTemp.createdDate),'/apex/DG_DocAckReview?listEmpTempId=' + empTemp.Id + '&showAccept=true',null));
        
            }
            else 
            if(empTemp.Document_Accepted_On__c != null && empTemp.Document_Declined_On__c == null){
                acceptedWrapper.add(new wrapperClass(empTemp.List_Employee__r.List__r.document_display_name__c, 'Acknowledgement',date.valueOf(empTemp.document_Accepted_on__c),'/apex/DG_DocAckReview?listEmpTempId=' + empTemp.Id + '&showAccept=false',null));
            }
        }
        
       
        
        List<dsfs__DocuSign_Status__c> tempList = new List<dsfs__DocuSign_Status__c>();	
       
        tempList = [select dsfs__DocuSign_Envelope_ID__c
        				,dsfs__Subject__c 
        				,dsfs__Completed_Date_Time__c
        				,dsfs__Envelope_Status__c
        				,dsfs__Sent_Date_Time__c
        				,dsfs__Declined_Date_Time__c
        				,dsfs__Declined_Reason__c
        				,list_employee__r.list__r.name
        				,list_employee__r.list__r.document_display_name__c
        				,ffap_record__c
        				,createddate
            		 	from dsfs__DocuSign_Status__c
            			where List_Employee__r.Employee__r.Emp_ID__c = :empId or ffap_record__r.employee__r.emp_id__c = :empId
            			order by lastModifiedDate
            			
        ];
        
        for(dsfs__DocuSign_Status__c d:tempList){
        	
        	String docName;
        	if (d.list_employee__r.list__r.document_display_name__c == null)
        		docName = d.dsfs__subject__c;
        	else
        		docName = d.list_employee__r.list__r.document_display_name__c;
        	
        	if (d.dsfs__Envelope_Status__c == 'Sent' || d.dsfs__Envelope_status__c == 'Delivered'){
 				pendingWrapper.add(new wrapperClass(docName, 'DocuSign',date.valueOf(d.createddate),'/apex/DG_RouteToEmbeddedSigningEnvId?envId=' + d.dsfs__DocuSign_Envelope_ID__c,d));
        	}
        	else
        	if (d.dsfs__Envelope_status__c == 'Completed'){
        		acceptedWrapper.add(new wrapperClass(docName, 'DocuSign',date.valueOf(d.createddate),'/apex/DG_RouteToEmbeddedSigningEnvId?envId=' + d.dsfs__DocuSign_Envelope_ID__c,d));
        	}
        	else
        	if (d.dsfs__Envelope_status__c == 'Declined'){
        		declinedWrapper.add(new wrapperClass(docName, 'DocuSign',date.valueOf(d.createddate),'/apex/DG_RouteToEmbeddedSigningEnvId?envId=' + d.dsfs__DocuSign_Envelope_ID__c,d));
        
    		}
        }
        
    }
    
    /*****************************************************************************************************************
    *
    *	Accepted Wrapper Class 
    *   	
    *****************************************************************************************************************/
    
    public class wrapperClass{
    	
    	public String docName {get;set;}
    	public String docType {get;set;}
    	public Date dateAccepted {get;set;}
    	public String link {get;set;}
    	public dsfs__DocuSign_Status__c d {get;set;} 
    	
    	public wrapperClass(String dn, String dt, Date dateAccepted, String l,dsfs__DocuSign_Status__c din){
    		
    		docName = dn;
    		doctype = dt;
    		link = l;
    		this.dateAccepted = dateAccepted;
    		d=din;
    		
    	}
    	
    }
    
    
}