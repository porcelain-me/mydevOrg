public class FFAP_DocusignAPI_Utilities {
    private String docType;
    private Id sourceId;
    private String envelopeId;    
    //will be used to connect to Docusign API
    private DocusignAuthenticationHelper docusign;
    private String objectAPIName;
    private Map<String, Attachment> nameToAttachmentMap;
    private Map<String, List<FFAP_Document_Recipient__c>> docNameToRecipientMap;  
    private Map<Id, Employee__c> empMap;  
    private DocuSignAPI.Envelope envelope;
    private List<FFAP_Document_Recipient__c> docRecipientListForUpdate;
    public boolean isCompleted;
    private boolean isModificationProcess;
    private boolean isAgreement;
    private String empId;
    private FFAP_Agreement__c faAgreement;
    private JPN_Change__c jpnChange;
    
    public FFAP_DocusignAPI_Utilities(Id sourceId, String docType){
        this.docType = docType;
        this.sourceId = sourceId;
        this.objectAPIName = this.sourceId.getSObjectType().getDescribe().getName();
        this.isCompleted = false;        
    } 
    
    public String checkDocumentsAndSendForSignature(){
    	isAgreement = false;
    	isModificationProcess = false;
    	String resultString = FFAP_DataUtil.SUCCESS;
    	if(this.objectAPIName == 'FFAP_Agreement__c'){
    		isAgreement = true;
            for(FFAP_Agreement__c faAgreementTemp : FFAP_DataUtil.getAgreementDetailsOnAgreementIds(new set<Id>{sourceId})){
                faAgreement = faAgreementTemp;
                break;
            }
            if(faAgreement == null){
                resultString = 'No Agreement record found.';
            }else{
                empId = faAgreement.Emp_Id__c;
            }
        }else if(this.objectAPIName == 'JPN_Change__c'){
        	isModificationProcess = true;
        	for(JPN_Change__c jpnChangeTemp : FFAP_DataUtil.getJPNChangeDetail(new list<Id>{sourceId})){
                jpnChange = jpnChangeTemp;
                break;
            }
            if(jpnChange == null){
                resultString = 'No JPN Change record found.';
            }else{
            	empId = jpnChange.JPN_Change_Requestor__r.Emp_Id__c;
            }
        }
        
        if(resultString == FFAP_DataUtil.SUCCESS){
	        resultString = populateSystemData();
	        if(resultString == FFAP_DataUtil.SUCCESS){
                resultString = populateDocumentsAndEmployees();
                if(resultString == FFAP_DataUtil.SUCCESS){
                    resultString = populateAttachments();
                    if(resultString == FFAP_DataUtil.SUCCESS){
                        resultString = SendNow();                        
                    }
                }
	        }
        }
        return resultString;
    }
    
    public String populateSystemData(){
        docusign = new DocusignAuthenticationHelper();
        if(docusign.isConfigured == false){
            return docusign.error;
        }
        return FFAP_DataUtil.SUCCESS;
    }
    
    public String populateDocumentsAndEmployees(){
        if(FFAP_DataUtil.getFFAPDocRecipientCountOnSourceIdAndPackage(sourceId, this.docType) == 0){
            return 'No Document is generated for this package for signing through Docusign.';
        }
        List<FFAP_Document_Recipient__c> docRecipientList = FFAP_DataUtil.getFFAPDocRecipientsOnSourceIdAndPackage(sourceId, this.docType);        
        return populateDocumentsAndEmployees(docRecipientList);
    }
    
    private String populateDocumentsAndEmployees(List<FFAP_Document_Recipient__c> docRecipientList){
    	if(docRecipientList.isEmpty()){
            return 'Document is already sent for signature.';
        }
    	docNameToRecipientMap = new Map<String, List<FFAP_Document_Recipient__c>>();
        empMap = new Map<Id, Employee__c>();
        for(FFAP_Document_Recipient__c docRec : docRecipientList){
            if(!docNameToRecipientMap.containsKey(docRec.Name)){
                docNameToRecipientMap.put(docRec.Name, new List<FFAP_Document_Recipient__c>());
            }
            docNameToRecipientMap.get(docRec.Name).add(docRec);
            empMap.put(docRec.Recipient__c, null);
        }
        empMap = new Map<Id, Employee__c>(FFAP_DataUtil.getEmployeeDetailsOnId(empMap.keySet()));
        if(empMap.isEmpty()){
            return 'No recipient exists for Signing.';
        }else{
        	List<String> errors = FFAP_CongaManager.validateEmployees(empMap.values());
        	if(!errors.isEmpty()){
        		String resultString = '';
	        	for(String error : errors){
	        		if(resultString == ''){
	                   resultString += error;
	        		}else{
                        resultString += '\n' + error;
	        		}
	            }
	            return resultString;            
        	}
        }
        return FFAP_DataUtil.SUCCESS;   
    }
    
    public String populateAttachments(){
        nameToAttachmentMap = new Map<String, Attachment>();
        List<Attachment> attachList = FFAP_DataUtil.getAttachmentsOnParentIdAndDocName(sourceId, docNameToRecipientMap.keySet());
        if(attachList.isEmpty()){
            return 'Document is not generated yet. Please wait for few minutes.';
        }
        for(Attachment attach : attachList){
            if(!nameToAttachmentMap.containsKey(attach.Name)){
                nameToAttachmentMap.put(attach.Name, attach);
            }
        }
        
        return FFAP_DataUtil.SUCCESS;
    }

    private String SendNow(){
        String resultString = FFAP_DataUtil.SUCCESS;
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = docusign.webServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        System.debug('Setting authentication to: ' + auth);            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
 
        DocuSignAPI.Envelope envelope; 
        System.debug('Constructing recipients list');
        List<FFAP_Document_Recipient__c> docRecipientList;
        docRecipientListForUpdate = new List<FFAP_Document_Recipient__c>();
        Integer docCounter = 0;
        Integer signOrder;
        Employee__c emp;
        Attachment attach;
        for(String docName : docNameToRecipientMap.keySet()){
            if(docCounter > 10){
                break;
            }           
            docRecipientList = docNameToRecipientMap.get(docName);
            if(!docRecipientList.isEmpty()){
                envelope = createEnvelope(docName);
                //Documents
                envelope.Documents = new DocuSignAPI.ArrayOfDocument();
                envelope.Documents.Document = new DocuSignAPI.Document[1];
                
                // Document
                DocuSignAPI.Document document = new DocuSignAPI.Document();
                attach = nameToAttachmentMap.get(docName);
                if(attach == null){
                    populateStatus(docRecipientList, 'Failed', 'Attachment Not found.'); 
                    continue;
                }
                Integer endIndex = attach.Name.lastIndexOf('.');
                if (endIndex >= 0) {
                    document.FileExtension = attach.Name.substring(endIndex + 1);
                } else{
                    document.FileExtension = 'doc'; 
                }
                
                document.ID = docCounter + 1;
                document.pdfBytes = EncodingUtil.base64Encode(attach.Body);
                document.Name = attach.Name;
                envelope.Documents.Document.add(document);
                
                //Tabs
                envelope.Tabs = new DocuSignAPI.ArrayOfTab();
                envelope.Tabs.Tab = new DocuSignAPI.Tab[2 * docRecipientList.size()];
                
                envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
                envelope.Recipients.Recipient = new DocuSignAPI.Recipient[docRecipientList.size()];                
                for(FFAP_Document_Recipient__c docRec : docRecipientList){
                    emp = empMap.get(docRec.Recipient__c);
                    if(emp != null){                                  
                        signOrder = Integer.valueOf(docRec.Signing_Order__c);
                        envelope.Recipients.Recipient.add(createRecipient(emp.Email__c, emp.Name, signOrder, signOrder));
                        //Tab creation
                        envelope.Tabs.Tab.add(createTab(signOrder, docCounter, 'SignHere'));
                        envelope.Tabs.Tab.add(createTab(signOrder, docCounter, 'DateSigned'));                          
                    }                    
                }                
                try {
                	if(!Test.isRunningTest()){
	                    DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
	                    envelopeId = es.EnvelopeID;	                    
                	}else{
                		envelopeId = 'TESTENVELOPID';
                	}
                	System.debug('Envelope Sent Succesfully. Envelope Id: ' + envelopeId);
                    populateStatus(docRecipientList, 'Sent', null);
                } catch ( CalloutException e) {
                	populateStatus(docRecipientList, 'Failed', e.getMessage());                	
                    System.debug('Exception - ' + e );                    
                }
                docRecipientListForUpdate.addAll(docRecipientList);
                docCounter++;               
            }
        }
        if(docRecipientListForUpdate != null && !docRecipientListForUpdate.isEmpty()){
            update docRecipientListForUpdate;
        }
        if(docCounter > 10){
            this.isCompleted = false;
        }else{
        	this.isCompleted = true;
        	if(isAgreement){
        		if(docType == FFAP_DataUtil.RETIREMENT){
        			faAgreement.Is_Retirement_Agreement_Sent_for_Sign__c = true;
        		}else if(docType == FFAP_DataUtil.DECEASED){
        			faAgreement.Is_Deceased_Agreement_Sent_for_Sign__c = true;
        		}
        		update faAgreement;
            }else if(isModificationProcess){
                jpnChange.Is_Sent_for_Signature__c = true;
                update jpnChange;
            }
        }
        return resultString;
    }    
    
    private void populateStatus(List<FFAP_Document_Recipient__c> docRecipientList, String status, String error){
    	for(FFAP_Document_Recipient__c docRec : docRecipientList){
            docRec.Docusign_Status__c = status;            
            docRec.Error__c = error;
        }
    }
    
    private DocuSignAPI.Envelope createEnvelope(String docName){
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject = this.docType + ' Package Document sent by Morgan Stanley.';
        envelope.EmailBlurb = 'Please click the link below to review and electronically sign ' + this.docType + ' Agreement.';
        envelope.AccountId  = docusign.accountId; 
        envelope.AllowReassign = false;
        envelope.AutoNavigation = true;
        envelope.EnvelopeIDStamping = false;
        //envelope.AllowRecipientRecursion = true;        
        //Adding envelope custom fields
        populateEnvelopeCustomFields(envelope);
        return envelope;
    }
    
    private void populateEnvelopeCustomFields(DocuSignAPI.Envelope envelope){
        envelope.CustomFields = new DocuSignAPI.ArrayOfCustomField();
        envelope.CustomFields.CustomField = new DocuSignAPI.CustomField[2];
        //setting sourceid field        
        DocuSignAPI.CustomField sourceIdField = new DocuSignAPI.CustomField();
        if(isAgreement){
	        sourceIdField.Name = 'AgreementId';
        }else if(isModificationProcess){
        	sourceIdField.Name = 'JpnchangeId';
        }
        sourceIdField.Value = sourceId;
        sourceIdField.CustomFieldType = 'Text';
        sourceIdField.Show = 'true';
        sourceIdField.Required = 'false';
        envelope.CustomFields.CustomField[0] = sourceIdField;
        
        //setting empId field        
        DocuSignAPI.CustomField empIdField = new DocuSignAPI.CustomField();
        empIdField.Name = 'MSID';
        empIdField.Value = empId;
        empIdField.CustomFieldType = 'Text';
        empIdField.Show = 'true';
        empIdField.Required = 'false';
        envelope.CustomFields.CustomField[1] = empIdField;
    }    
    
    private DocuSignAPI.Recipient createRecipient(String email, String name, Integer recipientId, Integer routingOrder){
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID = recipientId;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = routingOrder;
        recipient.Email = email;
        recipient.UserName = name;
        recipient.RequireIDLookup = false;        
        return recipient;
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
            tab.AnchorTabItem.AnchorTabString = '\\FFAPSigner'+ recipientId + '\\';
        }else if(tabType == 'DateSigned'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPDate'+ recipientId + '\\';
        }
        return tab;
    }
}