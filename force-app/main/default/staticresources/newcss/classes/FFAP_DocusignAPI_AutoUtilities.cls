public class FFAP_DocusignAPI_AutoUtilities {
    //will be used to connect to Docusign API    
    private DocusignAuthenticationHelper docusign;    
    private String empId;
    private boolean isFA;
    private boolean isPwa;
    private String templateId;
    private Employee__c manager;  
    private String brandId;  
    Employee__c emp;
    public String embeddedEnvId {get;set;}
    private FFAP_Agreement__c faAgreement;
    private map<Integer, String> MONTHS = new map<Integer, String>{1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 
                                                9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'};
    
    public FFAP_DocusignAPI_AutoUtilities(String empId){
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
    
    public String sentCommitmentAgreementForSignature(String empid){
        String resultString = FFAP_DataUtil.SUCCESS;        
        for(FFAP_Agreement__c faAgreementTemp : FFAP_DataUtil.getAgreementDetailsOnAdvisorId(empId)){
            faAgreement = faAgreementTemp;
        }
        resultString = validateData();
        if(resultString == ''){       
            system.debug('resultString:' + resultString);   
            resultString = populateSystemData();   
            system.debug('resultString:' + resultString);   
            if(resultString == FFAP_DataUtil.SUCCESS || resultString == 'Previously Declined'){
                resultString = sendCongaNow();    
            }
            system.debug('resultString:' + resultString);   
        }
        
        //system.debug('resultString:' + resultString); 
        //if (resultString.contains('Commitment Agreement is already created'))
        //   FFAP_Future.deleteTempAttachment(faAgreement.id);
            
             
        return resultString;
    } 
    
    public String dynamicCommitmentAgreementForSignatureValidation(String empid){
        String resultString = FFAP_DataUtil.SUCCESS;        
        for(FFAP_Agreement__c faAgreementTemp : FFAP_DataUtil.getAgreementDetailsOnAdvisorId(empId)){
            faAgreement = faAgreementTemp;
        }
        resultString = validateData();
        system.debug('***** resultString:' + resultString + '*');
        if(resultString == ''){         
            resultString = populateSystemData();  //get the docusign template 
        }
        system.debug('***** resultString:' + resultString + '*');
        return resultString;
    } 
    
   
    
    private String validateData(){
        String resultString = '';
        emp = FFAP_DataUtil.getEmployeeDetailsOnEmpId(empId);       
        if(emp == null){
            return 'No Employee found with provided MSID.';
        }else{
            //MRM Simple validation routine
            List<String> errors = FFAP_CongaManager.validateEmployee(emp, 'Employee', true);
            for(String error : errors){
                resultString += error + '\n';
            }
            system.debug(' -- emp -- ' + emp);
            if(emp.FFAP_Is_PWA__c){
                isPwa = true;
            }else if(emp.FFAP_Is_FA__c){
                isFa = true;
            }
             system.debug(' -- isPwa -- ' + isPwa);
             system.debug(' -- isFa -- ' + isFa);
            if(isPwa == false && isFa == false){
                system.debug(' -- IN ERROR -- ');
                return 'Employee is not FA/PWA.';
            }   
        }                        
        if(faAgreement == null){
            if(isPwa || isFa){                            
                faAgreement = new FFAP_Agreement__c(Employee__c = emp.Id, Is_Commitment_Agreement_Generated__c = false);                
                faAgreement.Employee__r = emp;
                faAgreement.Emp_Id__c = emp.Emp_Id__c;
            } 
        /* MRM 8/18/14 - change logic to check for commit envelope instead of flag */
        //}else if(faAgreement.Is_Commitment_Agreement_Generated__c){    
        }else if(faAgreement.Commitment_Agreement_Envelope_Id__c != null){
            /* MRM 12/29/14 - see if agreement was previously declind */
            if (faAgreement.Commitment_Status__c == 'Declined'){
                system.debug('************** previously declined ******* ');
                //resultString = 'Previously Declined';
            }
            else{
            
                embeddedEnvId = faAgreement.Commitment_Agreement_Envelope_Id__c;
                return 'Commitment Agreement is already created for this Employee.';
            }
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
    /*****************************************************************************
    *  4/29/14 - This is the send now if the template is a docusign template 
    *            Otherwise the sendConginaNow method should be used
    *
    *
    ******************************************************************************/
    /*
    public String sendNow(){
        
        
        String resultString = FFAP_DataUtil.SUCCESS;
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = docusign.webServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        System.debug('Setting authentication to: ' + auth);            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
 
        //create envelope
        DocuSignAPI.Envelope envelope = createEnvelope(faAgreement.Employee__r.Name);  
        
        DocuSignAPI.ArrayOfRecipient1 recipients = new DocuSignAPI.ArrayOfRecipient1();
        recipients.Recipient = new DocuSignAPI.Recipient[2];
        
        //Add Current FA as Recipient
        recipients.Recipient[0] = createRecipient(faAgreement.Employee__r.Email__c, faAgreement.Employee__r.Name, 'Advisor', true, 1, 1, faAgreement.employee__c);        
        
        //Add Manager as Recipient        
        recipients.Recipient[1] = createRecipient(manager.Email__c, manager.Name, 'Manager', true, 2, 2,manager.id);
       
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
        //template.AdditionalTabs.Tab.add(createTab(0,'MSID', faAgreement.Emp_Id__c, 'MSID', 'Calibri'));
        Date currentDate = System.Today();
        String dateString = currentDate.day() + ' day of ' + MONTHS.get(currentDate.month()) + ', ' + currentDate.year() + ', ';
        //Tab for dateString
        template.AdditionalTabs.Tab.add(createTab(-8.0,'DayMonthYear', dateString, 'AgreementMonthYear', 'TimesNewRoman'));
        String envelopeId;
         
        try {
            if(!Test.isRunningTest()){              
                DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateEnvelopeFromTemplates(templates, recipients, envelope, true);
                //MRM DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
                
                System.debug(es);
                envelopeId = es.EnvelopeID;
                System.debug('Envelope Sent Succesfully. Envelope Id: ' + es.EnvelopeID);
                FFAP_Future.doFFAPUpdates(emp.id, faAgreement.Emp_Id__c,faAgreement.id,envelopeId,manager.Email__c);
                embeddedEnvId = envelopeId;
            }else{
                envelopeId = 'TESTENVELOPEID';
            }
        } catch (CalloutException e) {
            return 'Error in Sending document for signature. - ' + e.getMessage() + '\n Please contact to System Administrator.';                
        }
         
        
        return resultString;
    }
    */
       
    /*****************************************************************************
    *  4/29/14 - MRM This is used to send a conga based template for a commitment
    *           agreement.
    *
    ******************************************************************************/
    public String sendCongaNow(){
        
        /* check if conga document has been created */
        String name = System.Label.Commitment_Doc_Template_Name + '.doc';
        
            
        Attachment attach;
        
        String attachID = genCongaDocument();
        system.debug(' -- attachID -- ' + attachID);
        attachID = attachID.replace('/','');
        system.debug(' -- attachID -- ' + attachID);
        
        if (!Test.isRunningTest())
            attach = [Select a.name, createddate, a.ParentId, a.Description, a.Body From Attachment a
                        where id = :attachID];
        else{
            attach = new Attachment (name=name,body=blob.valueOf('test body'),parentid = faAgreement.id);
        }       
    
        String resultString = FFAP_DataUtil.SUCCESS;
        DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = docusign.webServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
 
        //create envelope
        DocuSignAPI.Envelope envelope = createEnvelope(faAgreement.Employee__r.Name);  
          
        envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[2]; 
        
        //Add Current FA as Recipient
        envelope.recipients.Recipient.add(createRecipient(faAgreement.Employee__r.Email__c, faAgreement.Employee__r.Name, 'Advisor', true, 1, 1, faAgreement.employee__c));        
        
        //Add Manager as Recipient        
        envelope.recipients.Recipient.add(createRecipient(manager.Email__c, manager.Name, 'Manager', true, 2, 2,manager.id));
        
        system.debug('env recipients:' + envelope.Recipients);
        
        //Subject
        envelope.Subject = 'Commitment Agreement' + ' for ' + faAgreement.Employee__r.name;
        envelope.EmailBlurb  = 'blurb';
        
        system.debug('env subject:' + envelope.subject);
        
        //Documents
        
        envelope.Documents = new DocuSignAPI.ArrayOfDocument();
        envelope.Documents.Document = new DocuSignAPI.Document[1];
         
        DocuSignAPI.Document document = new DocuSignAPI.Document();
         
        Integer endIndex = attach.Name.lastIndexOf('.');
        if (endIndex >= 0) {
           document.FileExtension = attach.Name.substring(endIndex + 1);
        } else{
          document.FileExtension = 'doc';  
        }
               
        document.ID = 1; 
                  
        document.pdfBytes = EncodingUtil.base64Encode(attach.Body);
        document.Name = 'Commitment Agreement.pdf';
        
        envelope.Documents.Document.add(document);
        
        system.debug('env docs:' + envelope.documents);
        //Tabs
        envelope.Tabs = new DocuSignApi.ArrayOfTab();
        envelope.Tabs.Tab = new DocuSignAPI.Tab[4];
        
        envelope.Tabs.Tab.add(createTabReplace(4, 1, 1, 'SignHere'));
        envelope.Tabs.Tab.add(createTabReplace(0, 2, 1, 'SignHere'));
        envelope.Tabs.Tab.add(createTabReplace(-6, 1, 1, 'DateSigned'));
        envelope.Tabs.Tab.add(createTabReplace(-6, 2, 1, 'DateSigned'));
         
        String envelopeId;
        
        system.debug('envelope is:' + envelope);
        try {
            if(!Test.isRunningTest()){              
                DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
                
                System.debug(es);
                envelopeId = es.EnvelopeID;
                System.debug('Envelope Sent Succesfully. Envelope Id: ' + es.EnvelopeID);
                FFAP_Future.doFFAPUpdates(emp.id, faAgreement.Emp_Id__c,faAgreement.id,envelopeId,manager.Email__c);
                embeddedEnvId = envelopeId;
            }else{
                envelopeId = 'TESTENVELOPEID';
            }
        } catch (CalloutException e) {
            return 'Error in Sending document for signature. - ' + e.getMessage() + '\n Please contact to System Administrator.';                
        }
         
        delete attach;
        
        return resultString;
    } 
    
    private String genCongaDocument(){
   
        Http h = new Http();

        HttpRequest req = new HttpRequest();

        String url =System.Label.Conga_HTTP;
        //String url = 'https://www-appextremes-com.ccg-dev.ms.com/apps/Conga/PM.aspx?';
        
        String sessionId='sessionId=' + UserInfo.getSessionId();
        String serverUrl= '&serverUrl=' + System.Label.FFAP_Conga_Base_URL + '/services/Soap/u/13.0/' + UserInfo.getOrganizationId();
        String id='&id=' + emp.id;
        String TemplateId='&TemplateId=' + System.Label.FFAP_Conga_Commitment_Template_Id;
        String QueryId='&QueryId=' +System.Label.FFAP_Conga_Commitment_Query_Id + '?pv0=' + emp.id;
        String parms = '&APIMode=1&ofn=tempCommitment&lg3=1&DefaultPDF=1';
        url+='?';
        url += sessionId;
        url += serverurl;
        url += id;
        url+= templateid;
        url+= queryid;
        url+= parms;

        system.debug('url is:' + url);

        req.setEndpoint(url);
                req.setMethod('GET');

        req.setTimeout(60000);

        HttpResponse res = h.send(req);

        System.debug('response body =>' + res.getBody());
        
        return res.getBody();
        
    }
    
    private DocuSignAPI.Tab createTab(Decimal offset, String name, String value, String tabString, String font){
        // Tab
        DocuSignAPI.Tab tab = new DocuSignAPI.Tab();
        tab.Name = name;
        tab.TabLabel = name;
        tab.Type_x = 'Custom';
        tab.CustomTabType = 'Text';
        tab.Value = value;
        tab.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab.AnchorTabItem.AnchorTabString = '\\FFAP'+ tabString +'\\'; 
        tab.AnchorTabItem.YOffset = offset;
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
    
    private DocuSignAPI.Tab createTabReplace(Decimal offset,Integer recipientId, Integer documentId, String tabType){
        // Tab
        DocuSignAPI.Tab tab = new DocuSignAPI.Tab();
        tab.Type_x = tabType;
        tab.RecipientID = recipientId;
        tab.DocumentID = documentId;
        
        tab.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab.AnchorTabItem.IgnoreIfNotPresent = true;
        tab.AnchorTabItem.YOffset = offset;
        tab.FontSize = 'Size12';
        tab.Font = 'TimesNewRoman';
        
        if(tabType == 'SignHere'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPSigner'+ recipientId + '\\';
        }else if(tabType == 'DateSigned'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPDate'+ recipientId + '\\';
        }else if(tabType == 'Approve'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPApprove'+ recipientId + '\\';
        }else if(tabType == 'Decline'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPDecline'+ recipientId + '\\';
        }else if(tabType == 'FullName'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPFullName'+ recipientId + '\\';
        }else if(tabType == 'FirstName'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPFirstName'+ recipientId + '\\';
        }else if(tabType == 'LastName'){
            tab.AnchorTabItem.AnchorTabString = '\\FFAPLastName'+ recipientId + '\\';
        }
        
        
        return tab;
    }  
    private DocuSignAPI.Envelope createEnvelope(String employeeName){
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject = 'Commitment Agreement for ' + employeeName;
        envelope.EmailBlurb = 'Please click the link below to review and electronically sign your Commitment Agreement.';
        envelope.AccountId  = docusign.accountId; 
        envelope.AllowReassign = false;
        envelope.AutoNavigation = true;
        envelope.EnvelopeIDStamping = false;
                
        //Adding envelope custom fields
        populateEnvelopeCustomFields(envelope);
        return envelope;
    }
    
    private void populateEnvelopeCustomFields(DocuSignAPI.Envelope envelope){
        
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

    private DocuSignAPI.Recipient createRecipient(String email, String name, String role, Boolean isRemote, Integer recipientId, Integer routingOrder, String embeddedId){
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID = recipientId;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = routingOrder;
        recipient.Email = email;
        recipient.RoleName = role;
        recipient.UserName = name;
        recipient.RequireIDLookup = false; 
        
        if (isRemote){
            recipient.CaptiveInfo = createRecipientCaptiveInfo(embeddedId);
        }      
        return recipient;
    }
    
     private DocuSignAPI.RecipientCaptiveInfo createRecipientCaptiveInfo(string ClientUserId){
        DocuSignAPI.RecipientCaptiveInfo rci = New DocuSignAPI.RecipientCaptiveInfo();
        rci.ClientUserId = ClientUserId;
        return rci;
    }
   
    /*
    private DocuSignAPI.Envelope createEnvelope(String employeeName){
       
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        
        envelope.AccountId  = docusign.accountId; 
        envelope.AllowReassign = false;
        envelope.AutoNavigation = true;
        envelope.EnvelopeIDStamping = false;
        if(brandId != null){
            //envelope.BrandId = 'ec8f15a8-03ec-432a-a454-5f0da34a1f10';
            envelope.BrandId = brandId;
        }
        
        integer expirationDays = 30;
        
        return envelope;
    }
    */
    
    
}