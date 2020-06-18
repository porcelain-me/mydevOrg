// 
// (c) 2014 Appirio, Inc. 
//
// Description : Email Service class which will send document for signing to employee mentioned in email through docusign
// As an user, I would like to be able to send an email to opt out
// As an user, when I sent an email to opt out, I should receive a DocuSign email to sign opt out document
//
// 04 Feb 2014 Jitendra Kothari Original
//
/**
 * Email services are automated processes that use Apex classes to process the contents, headers, and attachments of inbound email.
 */
global class DG_EAOptOutEmailHandler implements Messaging.InboundEmailHandler{
	
    public static final String EMAIL_SUBJECT_START = 'ListID-';
    public static final String EMAIL_FORMAT_ERROR = 'Email Format is not correct.';    
    String empId;
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        return sendOptOutDocument(email);
    }
    
    public Messaging.InboundEmailResult sendOptOutDocument(Messaging.InboundEmail email){
        String subject = email.Subject;
        String body = (email.plainTextBody != null) ? email.plainTextBody : email.htmlBody;
        String capghritccEmailAdress = getOrgWideEmaillAddress();
        List<String> emailAddresses = new List<String>();
        
        if(capghritccEmailAdress != null){
            emailAddresses.add(capghritccEmailAdress);
        }
        
        if(subject != null && subject.startsWith(EMAIL_SUBJECT_START) && body != null){
            system.debug('------------------' + subject);
            //fetch List id from email subject
            String listIdString = subject.trim().replaceAll(EMAIL_SUBJECT_START, '');
            system.debug('------------------' + listIdString);
            
            //fetch employee msid from email body
            List<String> bodyParts = body.trim().split('\n');
            if(bodyParts.isEmpty()){
                return sendEmailTrigger(emailAddresses, EMAIL_FORMAT_ERROR);
            }
            empId = bodyParts.get(0);
            system.debug('------------------' + empId);
            
            //fetch employee based on msid
            List<Employee__c> employeeList = DG_DataUtil.getEmployeesOnEmpId(empId); 
            if(employeeList.isEmpty()){
                return sendEmailTrigger(emailAddresses, 'Employee not found with specified MSID ' + empId);             
            }
            Employee__c emp = employeeList.get(0);
            employeeList = null;
            
            Id listId = validateId(listIdString);
            if(listId == null){
                return sendEmailTrigger(emailAddresses, 'Not valid salesforce ListId ' + listId);
            }else{
                String objectAPIName = listId.getSObjectType().getDescribe().getName();
                if(objectAPIName != 'List__c'){
                    return sendEmailTrigger(emailAddresses, 'Not valid salesforce ListId ' + listId);
                }
            }
            //fetch list record based on list id
            List<List__c> listRecords = DG_DataUtil.getListDetailsOnId(listId);
            if(listRecords.isEmpty()){
                return sendEmailTrigger(emailAddresses, 'List Record not found with specified ListId ' + listId);
            }
            List__c listRecord = listRecords.get(0);
            listRecords = null;
            
            //fetch list employee record based on list id and employee id
            List<List_Employee__c> empList = DG_DataUtil.getListEmployeesOnEmpRecordId(listRecord.Id, emp.Id);
            if(empList.isEmpty()){
                return sendEmailTrigger(emailAddresses, 'Employee does not exists in specified List - ' + listId);
            }
            
            //fetch templates which can need to be sent through docusign to user
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
            setTemplateIds = null;
            if(nameToAttachmentMap.isEmpty()){
                return sendEmailTrigger(emailAddresses, 'No Documents found in specified List - ' + listId);
            }
            
            //validate records
            List<String> errors = validateEmployee(empList);
            if(!errors.isEmpty()){
                return sendEmailTrigger(emailAddresses, String.join(errors, ','));
            }
            
            //This will call docusign api and will send documents to user for signing through docusign
            DG_DocuSignAPI_Utilities utilities = new DG_DocuSignAPI_Utilities(empList, nameToAttachmentMap.values());
            utilities.checkDocumentsAndSendForSignature();
            
            //check if there is any error on the record
            empList = DG_DataUtil.getListEmployeesForError(empList.get(0).Id);
            if(empList.isEmpty()){
                return prepareResult(true);
            }else{
                return sendEmailTrigger(emailAddresses, empList.get(0).Error__c);
            }
        }   
        return sendEmailTrigger(emailAddresses, EMAIL_FORMAT_ERROR);
    }
            
    public Messaging.InboundEmailResult prepareResult(boolean isSuccess){        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        result.success = isSuccess;
        result.message = null;
        return result;
    }
    
    public Messaging.InboundEmailResult sendEmailTrigger(List<String> emailAddresses, String error) {
        if(!emailAddresses.isEmpty()){            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
            mail.setToAddresses( emailAddresses );
            mail.setSubject('Error while processing opt out email.');
            String body  = error;
            mail.setPlainTextBody(body);
            Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail} );
        }
        return prepareResult(false);
    }
    
    public String getOrgWideEmaillAddress(){
        String capghritccEmailAdress = null;
        for(OrgWideEmailAddress owa : DG_DataUtil.getOrgWideEmaillAddresses(System.Label.DG_OrgWideEmailAddressName)) {
            capghritccEmailAdress = owa.Address;
        }
        return capghritccEmailAdress;
    }
    
     public Messaging.InboundEmailResult sendEmail(List<String> emailAddresses, String subject, String body) {
         
        if(!emailAddresses.isEmpty()){            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses( emailAddresses );
            mail.setReplyTo(getOrgWideEmaillAddress());
            mail.setSenderDisplayName(getOrgWideEmaillAddress());
            /*
            List<String> plist = new List<String>();
            plist.add('mark.moser@morganstanley.com');
            mail.setCcAddresses(pList);
            */
            mail.setSubject(subject);
            mail.setHtmlBody(body);
           
            Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail} );
        }
        return prepareResult(false);
    }
    
    
    public List<String> validateEmployee(list<List_Employee__c> empList){
        List<String> errors = new List<String>();        
        for(List_Employee__c emp : empList){
            if(emp.Status__c == 'Sent'){
                errors.add('Already sent for signature for Employee MSID - ' + empId);
            }else{
                errors.addAll(FFAP_CongaManager.validateEmployee(emp.Employee__r, 'Employee', true));                              
            }
        }
        return errors;
    }
    
    public Id validateId(String Idparam) {
        Id validId = null;
        try {   
            validId = Idparam;
        } catch (Exception ex) {}
        return validId;
    }
}