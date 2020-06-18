public class FFAP_DocusignAPI_AutoUtilitiesOld {
    //will be used to connect to Docusign API    
    private DocusignAuthenticationHelper docusign;    
    private String empId;
    private boolean isFA;
    private boolean isPwa;
    private String templateId;
    private Employee__c manager;    
    private FFAP_Agreement__c faAgreement;
    private map<Integer, String> MONTHS = new map<Integer, String>{1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 
                                                9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'};
    
    public FFAP_DocusignAPI_AutoUtilitiesOld(String empId){
    	this.empId = empId;
    	isFA = false;
    	isPwa = false; 
    }
     
    public String populateSystemData(){        
        docusign = new DocusignAuthenticationHelper();
        if(docusign.isConfigured == false){
        	return docusign.error;
        } 
        Docusign_Template_Setting__c template = Docusign_Template_Setting__c.getValues('Default');        
        if(template == null){
        	return 'Docusign Templates are not configured. Please ask your System Administrator to configure.';
        }
        if(isPwa == true){
            templateId = template.PWA_Template__c;
        }else if(isFA == true){
            templateId = template.FA_Template__c;
        }
        System.debug('Template Id' + templateId);
        return FFAP_DataUtil.SUCCESS;
    }
    
    public String sentCommitmentAgreementForSignature(){
    	String resultString = FFAP_DataUtil.SUCCESS;    	
    	for(FFAP_Agreement__c faAgreementTemp : FFAP_DataUtil.getAgreementDetailsOnAdvisorId(empId)){
            faAgreement = faAgreementTemp;
        }
        resultString = validateData();
        if(resultString == ''){        	
        	resultString = populateSystemData();
	        if(resultString == FFAP_DataUtil.SUCCESS){
	            resultString = sendNow();    
	        }
        }
        return resultString;
    }    
    
    private String validateData(){
    	String resultString = '';
    	Employee__c emp = FFAP_DataUtil.getEmployeeDetailsOnEmpId(empId);    	
    	if(emp == null){
    		return 'No Employee found with provided MSID.';
    	}else{
    		List<String> errors = FFAP_CongaManager.validateEmployee(emp, 'Employee', true);
            for(String error : errors){
                resultString += error + '\n';
            }
            if(emp.FFAP_Is_PWA__c){
                isPwa = true;
	        }else if(emp.FFAP_Is_FA__c){
	            isFa = true;
	        }
	        if(isPwa == false && isFa == false){
	            return 'Employee is not FA/PWA.';
	        }	
    	}    	                 
        if(faAgreement == null){
            if(isPwa || isFa){                            
	            faAgreement = new FFAP_Agreement__c(Employee__c = emp.Id, Is_Commitment_Agreement_Generated__c = false);	            
		        faAgreement.Employee__r = emp;
		        faAgreement.Emp_Id__c = emp.Emp_Id__c;
            }            
        }else if(faAgreement.Is_Commitment_Agreement_Generated__c){
        	return 'Commitment Agreement is already created for this Employee.';
        }
        manager = FFAP_CongaManager.returnCongaActiveManagerForCurrentEmployee(emp);
       if(manager == null){
            resultString += 'Branch Manager not found on Employee'+ '(' + emp.Name + ' - ' + emp.Emp_Id__c + ').' + '\n';
       }else{       	    
           List<String> errors = FFAP_CongaManager.validateEmployee(manager, 'Branch Manager', true);
	        for(String error : errors){
	            resultString += error + '\n';
	        }
        }       
       return resultString;
    }
    
    public String sendNow(){
    	system.debug('in old send now');
    	String resultString = FFAP_DataUtil.SUCCESS;
    	DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = docusign.webServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        System.debug('Setting authentication to: ' + auth);            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
 
        //create envelope
        DocuSignAPI.EnvelopeInformation envelope = createEnvelope();        
        
        DocuSignAPI.ArrayOfRecipient1 recipients = new DocuSignAPI.ArrayOfRecipient1();
        recipients.Recipient = new DocuSignAPI.Recipient[2];
        
        //Add Current FA as Recipient
        recipients.Recipient[0] = createRecipient(faAgreement.Employee__r.Email__c, faAgreement.Employee__r.Name, 'Advisor', 1, 1);        
        //Add Manager as Recipient        
        recipients.Recipient[1] = createRecipient(manager.Email__c, manager.Name, 'Manager', 2, 2);
        
        DocuSignAPI.ArrayOfTemplateReference templates = new DocuSignAPI.ArrayOfTemplateReference();
        templates.TemplateReference = new DocuSignAPI.TemplateReference[1];
        
        DocuSignAPI.TemplateReference template = new DocuSignAPI.TemplateReference();
        template.Template = templateId;
        template.TemplateLocation = 'Server';        
        templates.TemplateReference[0] = template;
        
        template.RoleAssignments = new DocuSignAPI.ArrayOfTemplateReferenceRoleAssignment();
        template.RoleAssignments.RoleAssignment = new DocuSignAPI.TemplateReferenceRoleAssignment[2];
        
        //Add Advisor Role
        DocuSignAPI.TemplateReferenceRoleAssignment role1 = new DocuSignAPI.TemplateReferenceRoleAssignment();
        role1.RoleName = 'Advisor';
        role1.RecipientID = 1;
        
        //Add Manager Role
        DocuSignAPI.TemplateReferenceRoleAssignment role2 = new DocuSignAPI.TemplateReferenceRoleAssignment();
        role2.RoleName = 'Manager';
        role2.RecipientID = 2;
        
        template.RoleAssignments.RoleAssignment[0] = role1;
        template.RoleAssignments.RoleAssignment[1] = role2;
        
        //Add Tabs
        template.AdditionalTabs = new DocuSignAPI.ArrayOfTab();
        template.AdditionalTabs.Tab = new DocuSignAPI.Tab[2];
        
        //Tab for MSID
        template.AdditionalTabs.Tab.add(createTab('MSID', faAgreement.Emp_Id__c, 'MSID', 'Calibri'));
    	Date currentDate = System.Today();
        String dateString = currentDate.day() + ' day of ' + MONTHS.get(currentDate.month()) + ', ' + currentDate.year() + ', ';
        //Tab for dateString
        template.AdditionalTabs.Tab.add(createTab('AgreementMonthYear', dateString, 'DAYMONTH&YEAR', 'TimesNewRoman'));
        String envelopeId;
        try {
            if(!Test.isRunningTest()){            	
            	DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateEnvelopeFromTemplates(templates, recipients, envelope, true);
            	System.debug(es);
            	envelopeId = es.EnvelopeID;
                System.debug('Envelope Sent Succesfully. Envelope Id: ' + es.EnvelopeID);
            }else{
            	envelopeId = 'TESTENVELOPEID';
            }
        } catch (CalloutException e) {
            return 'Error in Sending document for signature. - ' + e.getMessage() + '\n Please contact to System Administrator.';                
        }
        faAgreement.Is_Commitment_Agreement_Generated__c = true;
        if(faAgreement.Id != null){            
            update faAgreement;
        }else{
        	insert faAgreement;
        	if(envelopeId != null){
        		List<dsfs__DocuSign_Status__c> dsList = FFAP_DataUtil.getDocusignStatus(envelopeId);
        		if(!dsList.isEmpty()){
        			dsList[0].FFAP_Record__c = faAgreement.Id;
        			update dsList;
        		}
        	}
        }
    	return resultString;
    }
    
    private DocuSignAPI.Tab createTab(String name, String value, String tabString, String font){
    	// Tab
        DocuSignAPI.Tab tab = new DocuSignAPI.Tab();
        tab.Name = name;
        tab.TabLabel = name;
        tab.Type_x = 'Custom';
        tab.CustomTabType = 'Text';
        tab.Value = value;
        tab.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab.AnchorTabItem.AnchorTabString = '\\FFAP'+ tabString +'\\';
        tab.AnchorTabItem.YOffset = -8.0;
        tab.AnchorTabItem.IgnoreIfNotPresent = true;
        tab.RecipientID = 1;
        tab.DocumentID = 1;
        tab.Font = font;
        if(name == 'MSID'){
            tab.FontSize = 'Size11';
        }else{
        	tab.FontSize = 'Size12';
        }
        tab.Underline = false;
        tab.ScaleValue = 1;
        return tab;
    }
    
    private DocuSignAPI.EnvelopeInformation createEnvelope(){
        DocuSignAPI.EnvelopeInformation envelope = new DocuSignAPI.EnvelopeInformation();
        envelope.Subject = 'Commitment Package Document sent by Morgan Stanley.';
        envelope.EmailBlurb = 'Please click the link below to review and electronically sign your Commitment Agreement.';
        envelope.AccountId  = docusign.accountId; 
        envelope.AllowReassign = false;
        envelope.AutoNavigation = true;
        envelope.EnvelopeIDStamping = false;
                
        //Adding envelope custom fields
        populateEnvelopeCustomFields(envelope);
        return envelope;
    }
    
    private void populateEnvelopeCustomFields(DocuSignAPI.EnvelopeInformation envelope){
        envelope.CustomFields = new DocuSignAPI.ArrayOfCustomField();
        envelope.CustomFields.CustomField = new DocuSignAPI.CustomField[2];
        //setting sourceid field        
        DocuSignAPI.CustomField agreementIdField = new DocuSignAPI.CustomField();
        if(faAgreement.Id != null){
            agreementIdField.Name = 'AgreementId';
            agreementIdField.Value = faAgreement.Id;
        }else{
        	agreementIdField.Name = 'EmployeeId';
            agreementIdField.Value = faAgreement.Employee__c;
        }
        agreementIdField.CustomFieldType = 'Text';
        agreementIdField.Show = 'true';
        agreementIdField.Required = 'false';
        envelope.CustomFields.CustomField[0] = agreementIdField;
        
        //setting empId field        
        DocuSignAPI.CustomField empIdField = new DocuSignAPI.CustomField();
        empIdField.Name = 'MSID';
        empIdField.Value = faAgreement.Emp_Id__c;
        empIdField.CustomFieldType = 'Text';
        empIdField.Show = 'true';
        empIdField.Required = 'false';
        envelope.CustomFields.CustomField[1] = empIdField;
    }

    private DocuSignAPI.Recipient createRecipient(String email, String name, String role, Integer recipientId, Integer routingOrder){
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID = recipientId;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = routingOrder;
        recipient.Email = email;
        recipient.RoleName = role;
        recipient.UserName = name;
        recipient.RequireIDLookup = false;               
        return recipient;
    }
}