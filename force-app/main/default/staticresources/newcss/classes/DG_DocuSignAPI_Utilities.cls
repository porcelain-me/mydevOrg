// 
// (c) 2014 Appirio, Inc. 
//
// Description : This class actually does the docusign call to create and send envelope.
//
// 7 Jan 2014 Manisha Gupta Original
// 
public class DG_DocuSignAPI_Utilities {       
    //will be used to connect to Docusign API
    private DocusignAuthenticationHelper docusign;
    private List<Attachment> attachList;
    private List<List_Employee__c> empList;  
    private String brandId;
    public DG_DocuSignAPI_Utilities(List<List_Employee__c> empList, List<Attachment> attachList){
    	this.empList = empList;
    	this.attachList = attachList;
    }
    public DG_DocuSignAPI_Utilities(){
    } 
       
    public String checkDocumentsAndSendForSignature(){
    	String resultString = '';
        resultString = populateSystemData();
        if(resultString == DG_DataUtil.SUCCESS){
            resultString = SendNow();   
        }
        return resultString;
    } 
     
    public String checkDocumentsAndSendForSignatureToEmployee(String templateTitle, String msid){
    	String resultString = '';
        resultString = populateSystemData();
        if(resultString == DG_DataUtil.SUCCESS){
            resultString = CreateEmbeddedSigningForTemplate(templateTitle,msid);   
        }
        return resultString;
    }
         
	private String populateSystemData(){
        docusign = new DocusignAuthenticationHelper();
        if(docusign.isConfigured == false){ 
            return docusign.error;
        }
        brandId = docusign.getBrandId('Document Generator');
        return DG_DataUtil.SUCCESS;
    }    
    
    private String SendNow(){       
    	
    	system.debug('*********************** start send now ****************************************' + system.now()); 
        String resultString = DG_DataUtil.SUCCESS;
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = docusign.webServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        System.debug('Setting authentication to: ' + auth);            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
 
        //DocuSignAPI.Envelope envelope; 
        System.debug('Constructing recipients list');
	
        //Employee__c emp;
        //Attachment attach;
        Integer docCounter = 0;
        String status = '';
        String error = '';
        String envelopeId;
        Integer employeeId = 1;
        List<String> errors;
        system.debug('Starting loop....');
        for(List_Employee__c emp : empList){
        	system.debug('====================' + emp);
        	system.debug('in loop...');
            DocuSignAPI.Envelope envelope = createEnvelope(emp);
            envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
            envelope.Recipients.Recipient = new DocuSignAPI.Recipient[1];                

            if(emp.Employee__r != null){                                  
                envelope.Recipients.Recipient.add(createRecipient(emp.Employee__c, emp.Employee__r.Email__c, emp.Employee__r.Name, 1, 1));                                          
            }
            //Tabs
            envelope.Tabs = new DocuSignAPI.ArrayOfTab();
            
            /* allocate space for all the tabs needed */
            
            envelope.Tabs.Tab = new DocuSignAPI.Tab[3 * attachList.size()];
             
            //Documents
            envelope.Documents = new DocuSignAPI.ArrayOfDocument();
            envelope.Documents.Document = new DocuSignAPI.Document[attachList.size()];
            
            system.debug('***********************');
            system.debug('envelope:' + envelope);
            system.debug('attach list size:' + attachList.size());
            
            docCounter = 0; 
            DocuSignAPI.Document document;
            for(Attachment attach : attachList){
            	system.debug('doc counter:' + docCounter);
            	system.debug('attach:' + attach);
            	document = new DocuSignAPI.Document();
	            Integer endIndex = attach.Name.lastIndexOf('.');
	            if (endIndex >= 0) {
	                document.FileExtension = attach.Name.substring(endIndex + 1);
	            } else{
	                document.FileExtension = 'doc';  
	            }
	               
	            //document.ID = docCounter + 1;
	           
	            docCounter++; 
	            document.ID = docCounter; 
	              
	            document.pdfBytes = EncodingUtil.base64Encode(attach.Body);
	            document.Name = attach.Name;
	            envelope.Documents.Document.add(document);
	            system.debug('doc list size:' + envelope.Documents.Document.size());
	           
            }  
            envelope.Tabs.Tab.add(createTab(1, 1, 'SignHere'));
            envelope.Tabs.Tab.add(createTab(1, 1, 'DateSigned'));
            envelope.Tabs.Tab.add(createTab(1, 1, 'FullName'));  
            // Document 
            //DocuSignAPI.Document  
            /*
            *
            *	Create and Send Envelope is the callout to docusign server
            *
            *
            *
            *
            */                           
            try {  
            	if(!Test.isRunningTest()){
            		system.debug('Envelope is:' + envelope);
                    DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
                    envelopeId = es.EnvelopeID;	                    
            	}else{
            		envelopeId = 'TESTENVELOPID';
            	}
            	DG_UtilityClass.populateStatus(emp, 'Sent', '');
                
            	System.debug('Envelope Sent Succesfully. Envelope Id: ' + envelopeId);
            	//return DG_DataUtil.Success;
            } catch ( CalloutException e) {
            	DG_UtilityClass.populateStatus(emp, 'Failed', e.getMessage());
                System.debug('Exception - ' + e );      
                //return e.getMessage();              
            }   
            employeeId++;         
        }
        system.debug('end loop...');
        update empList;
        
        
        system.debug('*********************** end send now ****************************************' + system.now()); 
        return resultString;
    }
    
    /********************************************************************************
    *  Create Embedded Signing for a particular template and msid
    * 
    *	Input is template title and msid
    *	Output is envelope id
    *
    * Change Log: 
    * 4/15/14 MRM - Created Class
    ********************************************************************************/
     private String CreateEmbeddedSigningForTemplate(String templateTitle, String msid){        
        
        String resultString = DG_DataUtil.SUCCESS;
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = docusign.webServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        System.debug('Setting authentication to: ' + auth);            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
 
        //DocuSignAPI.Envelope envelope; 
        
        Integer docCounter = 0;
        String status = '';
        String error = '';
        String envelopeId;
        Integer employeeId = 1;
        List<String> errors;
        
    	/* get the user email address */
    	
    	User u = [select email, emp_id__c from user where id = :UserInfo.getUserId()];
    	
    	/* find the employee id for example 59XYZ */
    	
    	Employee__c emp = [select emp_id__c, email__c, name from employee__c where Emp_ID__c = :	u.emp_id__c];
        
        /* Create the envelope */
        DocuSignAPI.Envelope envelope = createEnvelopeForEmployee(templateTitle, emp);
       
       	/* create the recipient list */
        envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[1];                
        envelope.Recipients.Recipient.add(createRecipient(emp.id, emp.Email__c, emp.Name, 1, 1));                                          

        /* create tabs */
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        envelope.Tabs.Tab = new DocuSignAPI.Tab[3];
		             
            
       	/* get the requested documents template id */
       	Template__c t = [Select t.Title__c, t.Template_Type__c, t.SystemModstamp, t.OwnerId, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.CurrencyIsoCode, t.CreatedDate, t.CreatedById
      	 From Template__c t where title__c = :templateTitle];
            
       	/* get the template's attachment; get the latest one*/
       	Attachment attach = [Select a.SystemModstamp, a.ParentId, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsPrivate, a.IsDeleted, a.Id, a.Description, a.CreatedDate, a.CreatedById, a.ContentType, a.BodyLength, a.Body From Attachment a
      		where parentid = :t.id order by lastmodifiedDate desc limit 1];
       
         
       	docCounter = 0; 
       	DocuSignAPI.Document document = new DocuSignAPI.Document();
       
       	//Allocate space for Document
       	envelope.Documents = new DocuSignAPI.ArrayOfDocument();
       	envelope.Documents.Document = new DocuSignAPI.Document[1];
     
	   	Integer endIndex = attach.Name.lastIndexOf('.');
	   	if (endIndex >= 0) {
	   		document.FileExtension = attach.Name.substring(endIndex + 1);
	   	} else{
	   		document.FileExtension = 'doc';  
	   	}
	           
	   	docCounter++; 
	   	document.ID = docCounter; 
	   	document.pdfBytes = EncodingUtil.base64Encode(attach.Body);
	   	document.Name = attach.Name;
	   	envelope.Documents.Document.add(document);
	    
       
       	envelope.Tabs.Tab.add(createTab(1, 1, 'SignHere'));
       	envelope.Tabs.Tab.add(createTab(1, 1, 'DateSigned'));
       	envelope.Tabs.Tab.add(createTab(1, 1, 'FullName'));  
                                       
       	try { 
          	if(!Test.isRunningTest()){
          		system.debug('Envelope is:' + envelope);
                DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
                envelopeId = es.EnvelopeID;	                    
          	}else{
           		envelopeId = 'TESTENVELOPID';
        	}
           	System.debug('Envelope created Successfully. Envelope Id: ' + envelopeId);
         } 
         catch ( CalloutException e) {
                System.debug('Exception - ' + e );      
         }
        system.debug('****Envelope is:'+ envelope);
        
        return envelopeId.toUpperCase();
    }
    
    private DocuSignAPI.Envelope createEnvelope(List_Employee__c listEmployee){
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        
        String subject = listEmployee.List__r.Email_Subject__c;
        String emailBody = listEmployee.List__r.Email_Body__c;
        if(subject != null){
            subject = DG_UtilityClass.replaceMergeText(subject, listEmployee.Employee__r);
        }else{
        	subject = 'Document sent by Morgan Stanley.';
        }
        if(subject.length() > 100){
            subject = subject.substring(0, 100);
        }
        envelope.Subject = subject;
        if(emailBody != null){
            emailBody = DG_UtilityClass.replaceMergeText(emailBody, listEmployee.Employee__r);
        }else{
            emailBody = 'Please click the link below to review and electronically sign Document.';
        }
        if(emailBody.length() > 2000){
        	emailBody = emailBody.substring(0, 2000);
        }
        envelope.EmailBlurb = emailBody;
        envelope.AccountId  = docusign.accountId; 
        envelope.AllowReassign = false;
        envelope.AutoNavigation = true;
        envelope.EnvelopeIDStamping = false;
        if(brandId != null){
        	//envelope.BrandId = 'ec8f15a8-03ec-432a-a454-5f0da34a1f10';
        	envelope.BrandId = brandId;
        }
        integer expirationDays = 30;
        if(listEmployee.list__r.Action_Required_By_Date__c != null){
        	date currDate = Date.today();
        	date expirationDate = Date.valueOf(listEmployee.list__r.Action_Required_By_Date__c);
        	expirationDays = currDate.daysBetween(expirationDate);
        } 
        system.debug('expirationDays: '+ expirationDays);
        //add notification to envelope
        populateEnvelopeNotification(envelope, decimal.valueOf(expirationDays)); 
        //Adding envelope custom fields
        populateEnvelopeCustomFields(envelope, listEmployee.Id);
        //Adding envelope notification fields
        populateEventNotification(envelope);
        system.debug('-----envelope----' + envelope);
        return envelope;
    }
    
    /********************************************************************************
    * CREATE ENVELOPE FOR EMPLOYEE
    * 
    *	
    *
    * Change Log:
    * 4/15/14 MRM - Created Class
    ********************************************************************************/
     private DocuSignAPI.Envelope createEnvelopeForEmployee(String templateName, Employee__c employee){
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        
        /* change the confirmation email subject here */
        
        if (templateName == 'Doc Acknowledgement')
        	envelope.Subject = 'Decline Arbitration Benefit';
        else
        	envelope.Subject = null;
       
        envelope.AccountId  = docusign.accountId; 
        envelope.AllowReassign = false;
        envelope.AutoNavigation = true;
        envelope.EnvelopeIDStamping = false;
        if(brandId != null){
        	envelope.BrandId = brandId;
        }
        //add notification to envelope
        return envelope;
    }
    
    private void populateEventNotification(DocuSignAPI.Envelope envelope){
    	envelope.EventNotification = new DocuSignAPI.EventNotification();
    	envelope.EventNotification.IncludeSenderAccountAsCustomField = true; 
    }
    
    private void populateEnvelopeNotification(DocuSignAPI.Envelope envelope, Decimal expirationDays){
    	envelope.Notification = new DocuSignAPI.Notification();
    	envelope.Notification.UseAccountDefaults = false;
    	envelope.Notification.Expirations = new DocuSignAPI.Expirations();
    	if(expirationDays != null){
    	   envelope.Notification.Expirations.ExpireAfter = expirationDays.intValue();
	    }else{
	       envelope.Notification.Expirations.ExpireAfter = 30;	
	    }
    	   
    	envelope.Notification.Expirations.ExpireEnabled = true;
    }
    private void populateEnvelopeCustomFields(DocuSignAPI.Envelope envelope, Id sourceId){
        envelope.CustomFields = new DocuSignAPI.ArrayOfCustomField();
        envelope.CustomFields.CustomField = new DocuSignAPI.CustomField[1];
        //setting sourceid field        
        DocuSignAPI.CustomField sourceIdField = new DocuSignAPI.CustomField();
        sourceIdField.Name = 'ListEmployeeId';        
        sourceIdField.Value = sourceId;
        sourceIdField.CustomFieldType = 'Text';
        sourceIdField.Show = 'true';
        sourceIdField.Required = 'false';
        envelope.CustomFields.CustomField[0] = sourceIdField;               
    }    
    
    private DocuSignAPI.Recipient createRecipient(String embeddedId, String email, String name, Integer recipientId, Integer routingOrder){
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID = recipientId;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = routingOrder;
        recipient.Email = email;
        recipient.UserName = name;
        recipient.RequireIDLookup = false;
        if (embeddedId != ''){
        	recipient.CaptiveInfo = createRecipientCaptiveInfo(embeddedId);
        }
        return recipient;
    }
    
    private DocuSignAPI.RecipientCaptiveInfo createRecipientCaptiveInfo(string ClientUserId){
     	DocuSignAPI.RecipientCaptiveInfo rci = New DocuSignAPI.RecipientCaptiveInfo();
        rci.ClientUserId = ClientUserId;
        return rci;
    }
    
    private DocuSignAPI.Tab createTab(Integer recipientId, Integer documentId, String tabType){
        // Tab
        DocuSignAPI.Tab tab = new DocuSignAPI.Tab();
        tab.Type_x = tabType;
        tab.RecipientID = recipientId;
        tab.DocumentID = documentId;
        tab.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab.AnchorTabItem.IgnoreIfNotPresent = true;
        if(tabType == 'SignHere'){
            tab.AnchorTabItem.AnchorTabString = '\\HRDGSigner'+ recipientId + '\\';
        }else if(tabType == 'DateSigned'){
            tab.AnchorTabItem.AnchorTabString = '\\HRDGDate'+ recipientId + '\\';
        }else if(tabType == 'Approve'){
            tab.AnchorTabItem.AnchorTabString = '\\HRDGApprove'+ recipientId + '\\';
        }else if(tabType == 'Decline'){
            tab.AnchorTabItem.AnchorTabString = '\\HRDGDecline'+ recipientId + '\\';
        }else if(tabType == 'FullName'){
            tab.AnchorTabItem.AnchorTabString = '\\HRDGFullName'+ recipientId + '\\';
        }else if(tabType == 'FirstName'){
            tab.AnchorTabItem.AnchorTabString = '\\HRDGFirstName'+ recipientId + '\\';
        }else if(tabType == 'LastName'){
            tab.AnchorTabItem.AnchorTabString = '\\HRDGLastName'+ recipientId + '\\';
        }
        return tab;
    }  
}