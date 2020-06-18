/*****************************************************************************
*
*   DG DOC UTILITIES
*    
*  Routines to be used by force apps to generated docs for signature
*
*  Change Log:
*
*  MRM - Created 8/1/16
*
******************************************************************************/    
public class DG_DocUtilities {
  
    public DG_DocUtilities () {
    
    }
    /****************************************************************************************************************
    * this is called from the assignment page...the document will be attached to the space assigment record
    *****************************************************************************************************************/
    @future(callout=true)
    public static void decFuture(Map<String,String> saMap){
      
      Parking_Lot_Space_Assignment__c a = [select id, employee__r.emp_id__c , employee__r.name, name,  parking_lot_Request__c, employee__c, employee__r.email__c
        from Parking_Lot_Space_Assignment__C where id = :saMap.get('sa')];
      
      String sessionIdIn = saMap.get('session');
      String attachID = genCongaDocument(sessionIdIn, System.Label.GP_DeclarationCongaTemplateId,System.Label.GP_CongaQueryId1,System.Label.GP_CongaQueryId2,a.Parking_Lot_Request__c,a.Parking_Lot_Request__c,'TempDec',a.id);
             
      a.Declaration_Envelope_Id__c = createEnvelopeForAssign(a,attachID);
      a.declaration_form_generated_new_pass__c = true;
      
      update a;
      
       
    }
    
    /***************************************************************************************************************************
    * Performs a conga merge and returns attachment id
    *****************************************************************************************************************************/
    
    public static String genCongaDocument(String sessionIdIn, String congaTemplateId, String congaQuery1Id, String congaQuery2Id , String query1Parm0, String query2Parm0, String tempFileName, String congaId){
   
      Http h = new Http();

    HttpRequest req = new HttpRequest();
    
    String url = System.Label.Conga_HTTP; //'https://composer-congamerge-com.ccg-dev.ms.com/composer8/index.html?';
    
    String sessionId='?sessionId=' + sessionIdIn;
    system.debug('Sessions is: ' + sessionIdIn);
    String serverUrl= '&serverUrl=' + System.Label.FFAP_Conga_Base_URL + '/services/Soap/u/13.0/' + UserInfo.getOrganizationId();
    
    String id='&id=' + congaId;
    String TemplateId='&TemplateId=' + congaTemplateId;
    String QueryId='&QueryId=' + congaQuery1Id + '?pv0=' + query1Parm0 + ',' + congaQuery2Id + '?pv0=' + query1Parm0;
    String parms = '&APIMode=1&ofn=Declaration&lg3=1&DefaultPDF=1';

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
    
    
    /*****************************************************************************
    *  Create the envelope
    *
    ******************************************************************************/
    public static String createEnvelopeForAssign(Parking_Lot_Space_Assignment__c a, String attachID){
      
      String embeddedEnvId;
      /* check if conga document has been created */
      String name =  'Declaration.doc';
      
      Attachment attach;
      system.debug('attachID is:' + attachID);
      attachID = attachID.replace('/','');
      system.debug('attachID is:' + attachID);
          
      if (!Test.isRunningTest()) 
        attach = [Select a.name, createddate, a.ParentId, a.Description, a.Body From Attachment a
            where id = :attachID];
    else{
      attach = new Attachment (name=name,body=blob.valueOf('test body'),parentid = a.id);
    }    
    
      
      String resultString = FFAP_DataUtil.SUCCESS;
      
    DocusignAuthenticationHelper docusign;    
    docusign = new DocusignAuthenticationHelper();
      
      DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = docusign.webServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
 
        //create envelope
        DocuSignAPI.Envelope envelope = createEnvelope(a.employee__r.name,docusign);  
        
        populateEnvelopeCustomFields(envelope,a);
        
         envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[1]; 
        
        //Add the parker as the recipient
        //String email, String name, String role, Boolean isRemote, Integer recipientId, Integer routingOrder, String embeddedId
        envelope.Recipients.Recipient.add(createRecipient(a.employee__r.Email__c, a.employee__r.name, 'Parker', true, 1, 1, a.employee__c));        
        
         system.debug('env recipients:' + envelope.Recipients.Recipient);
         
         //Subject
         envelope.Subject = 'Parking Pass Declaration' + ' for ' + a.Employee__r.name;
         envelope.EmailBlurb  = 'blurb';
         
         //Set expiry definition - 500 days (GLBPARKING-392)
         DocuSignAPI.Notification notification = new DocuSignAPI.Notification();
         notification.UseAccountDefaults = false;
         DocuSignAPI.Expirations expirations = new DocuSignAPI.Expirations();
         expirations.ExpireEnabled = true;
         expirations.ExpireAfter = 500;
         notification.Expirations = expirations;
         envelope.Notification = notification;
        
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
                
      document.pdfBytes = EncodingUtil.base64Encode(attach.body);
      document.Name = 'Declaration.pdf';
      
      envelope.Documents.Document.add(document);
       
       system.debug('env docs:' + envelope.documents);
       //Tabs
       envelope.Tabs = new DocuSignApi.ArrayOfTab();
       envelope.Tabs.Tab = new DocuSignAPI.Tab[2];
       
       envelope.Tabs.Tab.add(createTabReplace(4, 1, 1, 'SignHere'));
    
       envelope.Tabs.Tab.add(createTabReplace(-6, 1, 1, 'DateSigned'));
        
      String envelopeId;
      
      system.debug('envelope is:' + envelope);
        try {
            if(!Test.isRunningTest()){              
              DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
              
              System.debug(es);
              envelopeId = es.EnvelopeID;
                System.debug('Envelope Sent Succesfully. Envelope Id: ' + es.EnvelopeID);
                embeddedEnvId = envelopeId;
            }else{
              envelopeId = 'TESTENVELOPEID';
            }
        } catch (CalloutException e) {
            return 'Error in Sending document for signature. - ' + e.getMessage() + '\n Please contact to System Administrator.';                
        }
        
         //Commented on 7th Feb 2017 by Mayur for Jira - GLBPARKING-363
        //delete attach;
        
      return envelopeId;
      
    } 
    
    private static void populateEnvelopeCustomFields(DocuSignAPI.Envelope envelope, Parking_Lot_Space_Assignment__c a){
        envelope.CustomFields = new DocuSignAPI.ArrayOfCustomField();
        envelope.CustomFields.CustomField = new DocuSignAPI.CustomField[3];
        
        //setting empId field        
        DocuSignAPI.CustomField empIdField = new DocuSignAPI.CustomField();
        empIdField.Name = 'EmployeeId';
        empIdField.Value = a.employee__c;
        empIdField.CustomFieldType = 'Text';
        empIdField.Show = 'true';
        empIdField.Required = 'false';
        envelope.CustomFields.CustomField[0] = empIdField;
        
        DocuSignAPI.CustomField empIdField2 = new DocuSignAPI.CustomField();
        empIdField2.Name = 'AssignmentId';
        empIdField2.Value = a.id;
        empIdField2.CustomFieldType = 'Text';
        empIdField2.Show = 'true';
        empIdField2.Required = 'false';
        envelope.CustomFields.CustomField[1] = empIdField2;
        
        DocuSignAPI.CustomField empIdField3 = new DocuSignAPI.CustomField();
        empIdField3.Name = 'MSID';
        empIdField3.Value = a.employee__r.emp_id__c;
        empIdField3.CustomFieldType = 'Text';
        empIdField3.Show = 'true';
        empIdField3.Required = 'false';
        envelope.CustomFields.CustomField[2] = empIdField3;
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
        tab.AnchorTabItem.AnchorTabString = '\\HRDG'+ tabString +'\\'; 
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
    
    private static DocuSignAPI.Tab createTabReplace(Decimal offset,Integer recipientId, Integer documentId, String tabType){
        // Tab
        DocuSignAPI.Tab tab = new DocuSignAPI.Tab();
        tab.Type_x = tabType;
        tab.RecipientID = recipientId;
        tab.DocumentID = documentId;
        
        tab.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab.AnchorTabItem.IgnoreIfNotPresent = true;
        tab.AnchorTabItem.YOffset = offset;
        tab.FontSize = 'Size10';
        tab.Font = 'TimesNewRoman';
        
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
    private static DocuSignAPI.Envelope createEnvelope(String employeeName,DocusignAuthenticationHelper docusign){
        
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject = 'Parking Pass Declaration for ' + employeeName;
        envelope.EmailBlurb = 'Please click the link below to review and electronically sign your Declaration.';
        envelope.AccountId  = docusign.accountId; 
        envelope.AllowReassign = false;
        envelope.AutoNavigation = true;
        envelope.EnvelopeIDStamping = false;
        
        return envelope;
    }
    
       private static DocuSignAPI.Recipient createRecipient(String email, String name, String role, Boolean embeddedSigner, Integer recipientId, Integer routingOrder, String embeddedId){
       
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID = recipientId;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = routingOrder;
        recipient.Email = email;
        recipient.RoleName = role;
        recipient.UserName = name;
        recipient.RequireIDLookup = false; 
        
        if (embeddedSigner){
          recipient.CaptiveInfo = createRecipientCaptiveInfo(embeddedId);
        }      
      
        
        return recipient;
    }
    /*
     This is for embedded signing
    */
    
     private static DocuSignAPI.RecipientCaptiveInfo createRecipientCaptiveInfo(string ClientUserId){
       DocuSignAPI.RecipientCaptiveInfo rci = New DocuSignAPI.RecipientCaptiveInfo();
        rci.ClientUserId = ClientUserId;
        return rci;
    }
    
}