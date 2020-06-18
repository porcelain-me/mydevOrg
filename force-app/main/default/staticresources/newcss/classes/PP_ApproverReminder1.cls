@isTest                                                //dummy class
global class PP_ApproverReminder1 implements Database.Batchable<SObject>{
     public static final String A='N_DAYS_AGO:2';
     static final string QUERY = 'Select id,Name,Approvers_List__c,Property_Service_Approver__c,Status__c ,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\' AND submitted_date__c<='+A;
   
    
     global Database.QueryLocator start(Database.BatchableContext c) {    
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
        
        String urlString  = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
        
        Contact ct = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
        insert ct;
               
        
        List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
        
         
        for(PR_Request__c obj : objects){
           
            list<String> watcherListDetails=new list<String>();
            if(obj.CC_WatchList__c!=null) {
            
               list<String>  watcheremails=obj.CC_WatchList__c.split(';');
                for(String X:watcheremails){
                    if(X != Null){
                        watcherListDetails.add(X);
                    }
                }
            }        
    
            Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
            List<String> emailToAddresses = new List<String>();
            emailToAddresses.addAll(obj.Approvers_List__c.split(';')); 
            
            List<String> emailCCAddresses = new List<String>();
            // CC Requestor
            emailCCAddresses.add(obj.Requestor_Email__c);
            // CC Requestee
            if(obj.Requestor_Email__c!=obj.Requestee_Email__c){
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
            delete ct;
       }
    
    global void finish(Database.BatchableContext c) {}

}