global class PP_ApproverReminder implements Database.Batchable<SObject>{
     
    Contact ct;
   
    /*Datetime SDate = Datetime.now().addDays(+1);      
    String SubmittedDate = SDate.format('yyyy-MM-dd');
    Datetime RDate = Datetime.now().adddays(+1);     
    String ReturnDate = RDate.format('yyyy-MM-dd');*/
    
    Datetime SDate = Datetime.now();      
    String SubmittedDate = SDate.format('yyyy-MM-dd');
    
    
    Datetime CDate = Datetime.now().addHours(-4);
    String CreatedDate = CDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');    
    
    
    //global final string QUERY = 'Select id,Name,Property_Service_Approver__c,Status__c,Approvers_List__c,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\'  AND Removal_Date__c >= ' +SubmittedDate +'  AND  submitted_date__c <=' +SubmittedDate+' AND CreatedDate <=' +CreatedDate;
   
    global string QUERY = 'Select id,Name,Property_Service_Approver__c,Status__c,Approvers_List__c,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\'  AND Removal_Date__c >= ' +SubmittedDate +'  AND  submitted_date__c <=' +SubmittedDate+' AND CreatedDate <=' +CreatedDate;
       
   
    
    //global final string QUERY = 'Select id,Name,Property_Service_Approver__c,Status__c,Approvers_List__c,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\'  AND Removal_Date__c = ' +SubmittedDate +'  AND  submitted_date__c =' +SubmittedDate;
    
    //global final string QUERY = 'Select id,Name,Property_Service_Approver__c,Status__c,Approvers_List__c,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\'  AND Removal_Date__c>=  ' +ReturnDate+'  AND  submitted_date__c <=' +SubmittedDate;
    
    global Database.QueryLocator start(Database.BatchableContext c) {  
     
         system.debug('final queryin PP_ApproverReminder : ' + QUERY );   
        
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
        
        
         //Adding for Contact gettings created in contact tab
           ct = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
          insert ct; 
          system.debug('-------------Contact---------------'+ct);  
          // values in this list will be deleted after sending emails
          List<contact> contactList = new List<Contact>();
          contactList.add(ct);
          //End
               
        
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
    
            Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
            List<String> emailToAddresses = new List<String>();
            
            emailToAddresses = obj.Approvers_List__c.split(';'); 
            
            
            if(SYSTEM.Label.ORG_ENVIRONMENT == 'DEV' || SYSTEM.Label.ORG_ENVIRONMENT == 'QA') { 
                    emailToAddresses.add(obj.Requestor_Email__c);
                   // ct= new Contact(firstname='**test**', lastname='**test**',email=orgEmail);                     
            }
            else {
                /*if(emailToAddresses.size() >0){
                    ct= new Contact(firstname='**test**', lastname='**test**',email=emailToAddresses[0]); 
                    emailToAddresses.remove(0);
                }  
                if(emailToAddresses.size() >1){
                    emailToAddresses.remove(0); 
                }*/  
                ct= new Contact(firstname='**test**', lastname='**test**',email=emailToAddresses[0]);
                insert ct;
                contactlist.add(ct);
                                        
            }               
            //insert ct;
            emailToAddresses.remove(0);
            //Contact ct = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
             
            //emailToAddresses.addAll(obj.Approvers_List__c.split(';')); 
            
            List<String> emailCCAddresses = new List<String>();
            // CC Requestor
            emailCCAddresses.add(obj.Requestor_Email__c);
            // CC Requestee
            //if(obj.Requestor_Email__c!=obj.Requestee_Email__c){
            if(obj.Requestee_Email__c != null && obj.Requestor_Email__c!=obj.Requestee_Email__c){
                emailCCAddresses.add(obj.Requestee_Email__c);
            }
            // CC watchers
            emailCCAddresses.addAll(watcherListDetails);
            
          
        
        
            
            email = PP_SendEmail.CreateEmail(emailToAddresses, orgEmail, urlString, emailCCAddresses, ct, orgEmailid, obj, system.label.PP_email7, emailTemplateMap);
            system.debug('system.label.PP_email7: ' + system.label.PP_Email7); 
            system.debug('emailToaddresses: ' +emailToAddresses);
            system.debug('emailCCAddresses: ' +emailCCAddresses);

            if (email != null)
                system.debug('email-7: '+email.getTemplateId());
                emailList.add(email);             
            }
    
            if (emailList.size() > 0) { 
                system.debug('email size'+emailList.size());
                system.debug('emailList: '+emailList);
                Messaging.sendEmail(emailList,true);
            }
            //delete ct;
            if(contactList.size() > 0) {
            system.debug('-----------------ApproverReminder ContactList-------------------'+contactList);
                for(Contact item: contactList)
            delete item;
        }
            
       }
    
    global void finish(Database.BatchableContext c) {}

}