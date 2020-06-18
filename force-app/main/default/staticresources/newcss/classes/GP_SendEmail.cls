public class GP_SendEmail{
    
    /*
    1. assign new pass
    2. cancellation requested
    3. cancellation complete
    4. cancellation rejected
    5. parking pass replacement
    6. replacment parking pass id complete
    
    */
    public static void sendEmail(ID emailtemplateId, Map<ID,String> EmailToAddressesmap , Map<ID,String> EmailCCAddressesmap,Map<ID,ID> Parkingrequestmap){
        
    if (System.Label.GP_Emails_Enabled == 'true'){
        System.debug('************************************** INPUT TO EMAIL ****************************************');
        system.debug('Email To Addresses:' + EmailToAddressesmap);
        system.debug('Email CC Addresses:' + EmailCCAddressesmap);
        system.debug('parking :' + Parkingrequestmap);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         
        List<Contact> contacts= new List<Contact>();
        
        OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Global Parking'];
        
        System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%Inside Send Email Method%%%%%%%%%%%%%%%%%%%%%');
        
        //Fix for GLBPARKING-393: Using custom setting to manage environmental logic, as opposed to hard-coded environment check
        GP_Master_Settings__c settings = GP_Master_Settings__c.getValues('Settings');
        
        Map<ID,Contact> Contactmap = new Map<ID,Contact>();
        
        for(ID key : Parkingrequestmap.keySet()){
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Inside For Loop^^^^^^^^^^^');
            
            Contact c = null;
            if(settings.Stub_Billing_Emails__c) { 
                c = new Contact(firstname='**test**', lastname='**test**',email=owe.address);      
                Contactmap.put(key,c); 
            }   
            else {
                system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key));               
                 c = new Contact(firstname='**test**', lastname='**test**',email=EmailToAddressesmap.get(key)); 
                Contactmap.put(key,c);           
            }
        }
        for(Contact c :Contactmap.values()){
            contacts.add(c);
        }
        insert contacts;
        for(ID key : Parkingrequestmap.keySet()){
            system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key)); 
            Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
            if(!settings.Stub_Billing_Emails__c) { 
                List<String> emailToAddresses =  new List<String>{EmailToAddressesmap.get(key)};
                List<String> emailCCAddresses =  new List<String>();
                
                if (emailccaddressesmap.get(key) != null && emailccaddressesmap.get(key).trim() != ''){
                    String cc = EmailCCAddressesmap.get(key);
                    List<String> ccList = cc.split(',');
                    for (String s:ccList)
                        emailCCaddresses.add(s);
                }
                System.debug('********************** Email To Addresses**********'+emailToAddresses);
                System.debug('********************** Email CC Addresses**********'+emailCCAddresses );
                emailToAddresses.remove(0);
                email.setToAddresses(emailToAddresses); 
                if (!emailCCAddresses.isEmpty())
                    email.setCcAddresses(emailCCAddresses);         
            }
                
            email.setTargetObjectId(Contactmap.get(key).id);
            email.setOrgWideEmailAddressId(owe.id);
            email.setWhatId(Parkingrequestmap.get(key)); 
            System.debug('********************** Value of Parking Lot Request ID**********'+Parkingrequestmap.get(key));
            email.setTemplateId(emailtemplateId);
            email.setSaveAsActivity(false);
            mails.add(email);
        }   
        if (!test.isRunningTest()){
            List <Messaging.SendEmailResult> sendEmailResultList= new List <Messaging.SendEmailResult> (Messaging.sendEmail(mails));
            System.debug('***********sendEmailResultList**********'+sendEmailResultList);
        }
             
        delete contacts;
      }   
    }
    
    /*
    1.  send email for billing
    */
    
    public static void sendEmailForInvoiceAndDispute(ID emailtemplateId, Map<ID,String> EmailToAddressesmap , Map<ID,String> EmailCCAddressesmap,Map<ID,ID> Parkingrequestmap){
        
       if (System.Label.GP_Emails_Enabled == 'true'){
        System.debug('************************************** INPUT TO EMAIL ****************************************');
        system.debug('Email To Addresses:' + EmailToAddressesmap);
        system.debug('Email CC Addresses:' + EmailCCAddressesmap);
        system.debug('parking :' + Parkingrequestmap);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        List<Contact> contacts= new List<Contact>();
        
        OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Global Parking'];
        
        System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%Inside Send Email Method%%%%%%%%%%%%%%%%%%%%%');

        //Fix for GLBPARKING-393: Using custom setting to manage environmental logic, as opposed to hard-coded environment check
        GP_Master_Settings__c settings = GP_Master_Settings__c.getValues('Settings');
        
        Map<ID,Contact> Contactmap = new Map<ID,Contact>();
        
        for(ID key : Parkingrequestmap.keySet()){
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Inside For Loop^^^^^^^^^^^');
            
            Contact c = null;
            if(settings.Stub_Billing_Emails__c) { 
                c = new Contact(firstname='**test**', lastname='**test**',email=owe.address);      
                Contactmap.put(key,c);      

            }   
            else {
                system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key));               
                 c = new Contact(firstname='**test**', lastname='**test**',email=EmailToAddressesmap.get(key)); 
                Contactmap.put(key,c);           
            }
        }
        for(Contact c :Contactmap.values()){
            contacts.add(c);
        }
        insert contacts;
         EmailTemplate templateId7 = [Select id from EmailTemplate where developerName = 'GP_Email_7_Monthly_Dispute_Submitted'];
        for(ID key : Parkingrequestmap.keySet()){
            system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key)); 
            system.debug('-----------EmailCCAddressesmap.get(key)--------------'+EmailCCAddressesmap.get(key));
            Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
            if(!settings.Stub_Billing_Emails__c){
                List<String> emailToAddresses;
                String emailString;
                if(!EmailToAddressesmap.isEmpty() && EmailToAddressesmap.containsKey(key)) {
                	emailString = EmailToAddressesmap.get(key);
                	emailToAddresses =  new List<String>{};
                	for(String emailItem : emailString.split(',')) {
                		emailToAddresses.add(emailItem);
                	}
                }
                List<String> emailCCAddresses;
                if(!EmailCCAddressesmap.isEmpty() && EmailCCAddressesmap.containsKey(key)) {
                	emailString = EmailCCAddressesmap.get(key);
                	emailCCAddresses =  new List<String>{};
                	if(emailString != null) {
	                	for(String emailItem : emailString.split(',')) {
	                		emailCCAddresses.add(emailItem);
	                	}
                	}
                }
                System.debug('********************** Email To Addresses**********'+emailToAddresses);
                System.debug('********************** Email CC Addresses**********'+emailCCAddresses );
                emailToAddresses.remove(0);
                email.setToAddresses(emailToAddresses); 
                if (emailCCAddresses != null && !emailCCAddresses.isEmpty())
                    email.setCcAddresses(emailCCAddresses);         
            }
                
            email.setTargetObjectId(Contactmap.get(key).id);
            email.setOrgWideEmailAddressId(owe.id);
            email.setWhatId(key);
           	if (emailtemplateId == templateId7.id){
           		system.debug(key);
           		
           		Parking_Lot_Space_Assignment_Time_Used__c fd = [select id, invoice__r.id from Parking_Lot_Space_Assignment_Time_Used__c where id = :key];
           		email.setWhatId(fd.invoice__r.id);
           	}
            
            System.debug('********************** Value of Billing Object ID**********'+key);
            System.debug('********************** Value of Parking Lot Request ID**********'+Parkingrequestmap.get(key));
            email.setTemplateId(emailtemplateId);
            email.setSaveAsActivity(false);
            mails.add(email);
        }   
        List <Messaging.SendEmailResult> sendEmailResultList= new List <Messaging.SendEmailResult> (Messaging.sendEmail(mails));
        System.debug('***********sendEmailResultList**********'+sendEmailResultList);
        
        delete contacts;
        
       }
        
    }
    
    
    
    /* public static void sendEmail(ID emailtemplateId, Map<ID,String> EmailToAddressesmap , Map<ID,String> EmailCCAddressesmap,Map<ID,ID> Parkingrequestmap,Map<ID,Attachment> Attachmentmap){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        List<Contact> contacts= new List<Contact>();
        
        OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Global Parking'];
        
        System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%Inside Send Email Method%%%%%%%%%%%%%%%%%%%%%');
        
        Map<ID,Contact> Contactmap = new Map<ID,Contact>();
        
        for(ID key : Parkingrequestmap.keySet()){
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Inside For Loop^^^^^^^^^^^');
            
            Contact c = null;
            if (SYSTEM.Label.ORG_ENVIRONMENT == 'PROD') { 
                        
                system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key));               
                 c = new Contact(firstname='**test**', lastname='**test**',email=EmailToAddressesmap.get(key)); 
                Contactmap.put(key,c);  
            }   
        
            else    
            {
                c = new Contact(firstname='**test**', lastname='**test**',email=owe.address);      
                Contactmap.put(key,c);                                 
            }
        }
        for(Contact c :Contactmap.values()){
            contacts.add(c);
        }
        insert contacts;
        for(ID key : Parkingrequestmap.keySet()){
            system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key)); 
            Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();

            if (SYSTEM.Label.ORG_ENVIRONMENT == 'PROD'){
                List<String> emailToAddresses =  new List<String>{EmailToAddressesmap.get(key)};
                List<String> emailCCAddresses =  new List<String>{EmailCCAddressesmap.get(key)};
                System.debug('********************** Email To Addresses**********'+emailToAddresses);
                System.debug('********************** Email CC Addresses**********'+emailCCAddresses );
                emailToAddresses.remove(0);
                email.setToAddresses(emailToAddresses); 
                email.setCcAddresses(emailCCAddresses);         
            }
            efa.setFileName(Attachmentmap.get(key).Name);
            efa.setBody(Attachmentmap.get(key).Body);    
            email.setTargetObjectId(Contactmap.get(key).id);
            email.setOrgWideEmailAddressId(owe.id);
            email.setWhatId(Parkingrequestmap.get(key)); 
            System.debug('********************** Value of Parking Lot Request ID**********'+Parkingrequestmap.get(key));
            email.setTemplateId(emailtemplateId);
            email.setSaveAsActivity(false);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

            mails.add(email);
            
            
           
           
            
        }   
             List <Messaging.SendEmailResult> sendEmailResultList= new List <Messaging.SendEmailResult> (Messaging.sendEmail(mails));
             System.debug('***********sendEmailResultList**********'+sendEmailResultList);
        
        delete contacts;
        
    }*/

   
   
   /*
   1. create new pass
   2. vehicle details updated
 
   */ 

   public static void sendEmail(ID emailtemplateId, Map<ID,String> EmailToAddressesmap , Map<ID,ID> Parkingrequestmap){
    
      if (System.Label.GP_Emails_Enabled == 'true'){
        System.debug('************************************** INPUT TO EMAIL ****************************************');
        system.debug('Email To Addresses:' + EmailToAddressesmap);
        system.debug('Email CC Addresses:' + ' NO CC required'); 
        system.debug('parking :' + Parkingrequestmap);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Contact> contacts= new List<Contact>();
        OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Global Parking'];
        System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%Inside Send Email Method%%%%%%%%%%%%%%%%%%%%%');
        Map<ID,Contact> Contactmap = new Map<ID,Contact>();
        List<String> emailToAddresses =  new List<String>();

        //Fix for GLBPARKING-393: Using custom setting to manage environmental logic, as opposed to hard-coded environment check
        GP_Master_Settings__c settings = GP_Master_Settings__c.getValues('Settings');

        for(ID key : Parkingrequestmap.keySet()){
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Inside For Loop^^^^^^^^^^^');
            Contact c;
            if (settings.Stub_New_Req_Updated_Vehicle_Emails__c) { 
                c = new Contact(firstname='**test**', lastname='**test**',email=owe.address);      
                Contactmap.put(key,c);           
            }   
            else {
                if (EmailToAddressesmap.get(key) != null){
                    String toaddress = EmailToAddressesmap.get(key);
                    List<String> toaddressList = toaddress.split(',');
                    for (String s:toaddressList)
                        emailToAddresses.add(s);
                }
                system.debug('********************** Email To Addresses**********'+emailToAddresses[0]);
                system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key));               
                c = new Contact(firstname='**test**', lastname='**test**',email=emailToAddresses[0]); 
                Contactmap.put(key,c);         
            }
        }
        for(Contact c :Contactmap.values()){
            contacts.add(c);
        }
        
        insert contacts;
        system.debug(contacts);
        system.debug('contact map' + contactmap);
        
        for(ID key : Parkingrequestmap.keySet()){
            system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key)); 
            Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
            if (!settings.Stub_New_Req_Updated_Vehicle_Emails__c){
                system.debug('********************** Email To Addresses**********'+emailToAddresses);
                emailToAddresses.remove(0);
                email.setToAddresses(emailToAddresses); 
            }   
                
            email.setTargetObjectId(Contactmap.get(key).id);
            email.setOrgWideEmailAddressId(owe.id);
            email.setWhatId(Parkingrequestmap.get(key)); 
            System.debug('********************** Value of Parking Lot Request ID**********'+Parkingrequestmap.get(key));
            email.setTemplateId(emailtemplateId);
            email.setSaveAsActivity(false);
            mails.add(email);
        }   
        if (!test.isRunningTest()){
            List <Messaging.SendEmailResult> sendEmailResultList= new List <Messaging.SendEmailResult> (Messaging.sendEmail(mails));
            system.debug('***********sendEmailResultList**********'+sendEmailResultList);
        }
             
        delete contacts;
      }   
    }
    
    /*
    1. add delegate request
    2. approve delegate reqeust
    
    */

    public static void sendEmail(ID emailtemplateId, Map<ID,String> EmailToAddressesmap , Map<ID,String> EmailCCAddressesmap,Map<ID,String> delegatemap){
      if (System.Label.GP_Emails_Enabled == 'true'){
        System.debug('************************************** INPUT TO EMAIL ****************************************');
        system.debug('Email To Addresses:' + EmailToAddressesmap);
        system.debug('Email CC Addresses:' + EmailCCAddressesmap); 
        system.debug('delegate map :' + delegatemap);
        
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        List<Contact> contacts= new List<Contact>();
        
        OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Global Parking'];
        
        System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%Inside Send Email Method%%%%%%%%%%%%%%%%%%%%%');
        
        Map<ID,Contact> Contactmap = new Map<ID,Contact>();
        
        //Fix for GLBPARKING-393: Using custom setting to manage environmental logic, as opposed to hard-coded environment check
        GP_Master_Settings__c settings = GP_Master_Settings__c.getValues('Settings');
        
        for(ID key : delegatemap.keySet()){
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Inside For Loop^^^^^^^^^^^');
            
            Contact c = null;
            if (settings.Stub_Delegate_Assignment_Emails__c) { 
                c = new Contact(firstname='**test**', lastname='**test**',email=owe.address);      
                Contactmap.put(key,c);      
            }   
        
            else {
                system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key));               
                c = new Contact(firstname='**test**', lastname='**test**',email=EmailToAddressesmap.get(key)); 
                Contactmap.put(key,c);             
            }
        }
        for(Contact c :Contactmap.values()){
            contacts.add(c);
        }
        insert contacts;
        for(ID key : delegatemap.keySet()){
            system.debug('-----------EmailToAddressesmap.get(key)--------------'+EmailToAddressesmap.get(key)); 
            Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
            if (!settings.Stub_Delegate_Assignment_Emails__c){
                 
                List<String> emailCCAddresses = new List<String>();
                if (emailCCAddressesmap.get(key) != null && emailCCAddressesmap.get(key).trim() != ''){
                    String temp =  EmailCCAddressesmap.get(key);
                    List<String> tempList = temp.split(',');
                    system.debug('templist is:' + tempList);
                    for (String s:tempList) 
                        emailCCAddresses.add(s);
                    for (String s:tempList)
                        if (!emailCCAddresses.isempty())
                            email.setCCAddresses(emailCCAddresses);  
                }       
            }
                
            email.setTargetObjectId(Contactmap.get(key).id);
            email.setOrgWideEmailAddressId(owe.id);
            email.setWhatId(key); 
            System.debug('********************** Value of Delegate Request ID**********'+delegatemap.get(key));
            email.setTemplateId(emailtemplateId);
            email.setSaveAsActivity(false);
            mails.add(email);
            
            
           
           
            
        }   
        if (!test.isRunningTest()){
           List <Messaging.SendEmailResult> sendEmailResultList= new List <Messaging.SendEmailResult> (Messaging.sendEmail(mails));
           System.debug('***********sendEmailResultList**********'+sendEmailResultList);
        }
             
        delete contacts;
      }
    }   
     
    public static void sendGPEmail(String emailtemplateId, Map<String,String> EmailToAddressesmap, String rId, Boolean ccDelegates){
     
      if (System.Label.GP_Emails_Enabled == 'true'){
      	
        //Fix for GLBPARKING-393: Using custom setting to manage environmental logic, as opposed to hard-coded environment check
        GP_Master_Settings__c settings = GP_Master_Settings__c.getValues('Settings');
       
        Parking_Lot_Request__c r = [select id, requestee__c from Parking_Lot_Request__c where id = :rid];
        
        List<String> ccList = new List<String>();
		if (!settings.Stub_Parking_Request_Submitted_Emails__c && ccDelegates) { 
        	List<Employee_Delegate__c> empDelegates = [Select 
                                  Delegate__c
                                 ,employee__c
                                 ,delegate__r.email__c
                                 From Employee_Delegate__c 
                                 where application__c = 'Global Parking'
                                 and status__c = 'Approved'
                                 and employee__c = :r.requestee__c
                                 ];
           	for (Employee_Delegate__c d:empDelegates){
           		ccList.add(d.delegate__r.email__c);
          	}	
        }
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Contact> contacts= new List<Contact>();
        OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Global Parking'];
        List<String> emailToAddresses =  new List<String>();
        Contact c;

        for(String emailAddress : EmailToAddressesMap.keySet()){
            if(settings.Stub_Parking_Request_Submitted_Emails__c) { 
            	c = new Contact(firstname='**test**', lastname='**test**',email=owe.address); 
            }   
            else {
                if (emailAddress != null){
                    String toaddress = emailAddress;
                    List<String> toaddressList = toaddress.split(',');
                    for (String s:toaddressList)
                        emailToAddresses.add(s);
                }
                c = new Contact(firstname='**test**', lastname='**test**',email=emailToAddresses[0]);
            }
        }
        
        
        insert c;
        
        Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
        if (!settings.Stub_Parking_Request_Submitted_Emails__c){
           email.setToAddresses(emailToAddresses); 
           if (ccDelegates)
       			if (!ccList.isEmpty())
            		email.setCCAddresses(ccList);
        }   
               
        email.setTargetObjectId(c.id);
        email.setOrgWideEmailAddressId(owe.id);
        email.setWhatId(rid); 
        email.setTemplateId(emailtemplateId);
        email.setSaveAsActivity(false);
        mails.add(email);
      	
      	if (!test.isRunningTest()){
        	List <Messaging.SendEmailResult> sendEmailResultList= new List <Messaging.SendEmailResult> (Messaging.sendEmail(mails));
        }
             
        delete c;
      }   
    }
    
}