global class PP_AutoCloseRequest implements Database.Batchable<SObject>{
    Contact ct;
    public static final String A='N_DAYS_AGO:3';
    
       static final string QUERY = 'Select id,Name,Status__c ,CC_WatchList__c,Approval_Rejection_Date__c,Approvers_List__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Approved\'  AND Removal_Date__C <='+A;
       //static final string QUERY = 'Select id,Name,Status__c ,CC_WatchList__c,Approval_Rejection_Date__c,Approvers_List__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Approved\'  AND Removal_Date__C =2015-07-23';
       
        global Database.QueryLocator start(Database.BatchableContext c) {    
        system.debug('-----'+QUERY);
        return Database.getQueryLocator(QUERY);  
              
    }
  
    global void execute(Database.BatchableContext c, List<PR_Request__c > objects) {
        list<PR_Request__c > UpdatePrRequest=new list<PR_Request__c >();

        Map<String,String> emailTemplateMap = new Map<String,String>();    
        List<EmailTemplate> eList = new List<EmailTemplate>();
        eList = PP_Util.getPPEmailTemplates();
        for (EmailTemplate e:eList){
            String V=e.id;
            emailTemplateMap.put(e.developername,v.substring(0,15));
        }
    
        /*Email alise creation fom property pass*/
        String orgEmail = null;
        String orgEmailId = null;
        for(OrgWideEmailAddress owe : PP_Util.getOrgWideEmaillAddresses(System.Label.Property_Pass)) {
            orgEmail = owe.Address;
            orgEmailId = owe.id;
        }
        
        //String urlString  = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
        String urlString  = System.Label.ORG_ENVIRONMENT.toLowerCase();
        
        //Contact ct = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
        //insert ct;
        //Adding for Contact gettings created in contact tab
           ct = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
          insert ct; 
          system.debug('-------------Contact---------------'+ct);  
          // values in this list will be deleted after sending emails
          List<contact> contactList = new List<Contact>();
          contactList.add(ct);
          //End
          
                 
        //list<String> watcherListDetails=new list<String>();
        Map<String,list<String>> watcherListDetailsMap=new Map<String,list<String>>();
        List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
        
         
        for(PR_Request__c obj : objects){
             list<String> watcherListDetails=new list<String>();
            
            if(obj.CC_WatchList__c!=null) {
            
               list<String>  watcheremails=obj.CC_WatchList__c.split(';');
                for(String X:watcheremails){
                    //if(X != Null){
                     if(X != Null && X!= 'DUMMY2015@ms.com.dummy'){
                        watcherListDetails.add(X);
                    }
                }
            }    
             watcherListDetailsMap.put(obj.Id,  watcherListDetails);        
            obj.status__C='Closed';
            obj.IsAutoColsed__c=true;
            obj.ClosedDate__c=system.now();
    
            UpdatePrRequest.add(Obj);
         }
         
         Update UpdatePrRequest;
          
         for(PR_Request__c obj:UpdatePrRequest){
    
            Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
            List<String> emailToAddresses = new List<String>();
            
           
          
          
             if(SYSTEM.Label.ORG_ENVIRONMENT == 'DEV' || SYSTEM.Label.ORG_ENVIRONMENT == 'QA') { 
                    emailToAddresses.add(obj.Requestor_Email__c);
                    //ct= new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
                     
                }
                else {
                    ct= new Contact(firstname='**test**', lastname='**test**',email=obj.Requestor_Email__c);
                    insert ct;
                    contactList.add(ct);
                    
                }               
            //insert ct;            
            
            
            //emailToAddresses.add(obj.Requestor_Email__c);
            //if(obj.Requestor_Email__c!=obj.Requestee_Email__c){
            if(obj.Requestee_Email__c != null && obj.Requestor_Email__c!=obj.Requestee_Email__c){
                emailToAddresses.add(obj.Requestee_Email__c);
            }       
            List<String> emailCCAddresses = new List<String>();

            if(watcherListDetailsMap.containsKey(obj.Id)){            
              emailCCAddresses.addAll(watcherListDetailsMap.get(obj.Id));
            }
            email = PP_SendEmail.CreateEmail(emailToAddresses, orgEmail, urlString, watcherListDetailsMap.get(obj.Id), ct, orgEmailid, obj, system.label.PP_email8, emailTemplateMap);
            
            system.debug('system.label.PP_email8: ' + system.label.PP_Email8); 
            system.debug('emailToaddresses: ' +emailToAddresses);
            system.debug('emailCCAddresses: ' +emailCCAddresses);

            if (email != null) {
                system.debug('email-8: '+email.getTemplateId());
                emailList.add(email); 
            }
            
        }

        if (emailList.size() > 0) { 
            system.debug('email size'+emailList.size());
            system.debug('emailList: '+emailList);
            Messaging.sendEmail(emailList,true);
        }
        //delete ct;
        if(contactList.size() > 0) {
            system.debug('-----------------Auto close Request ContactList-------------------'+contactList);
                for(Contact item: contactList)
            delete item;
        }
    
    }
    
    global void finish(Database.BatchableContext c) {}

}