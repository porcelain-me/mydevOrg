global class PP_AutoCloseRequestold implements Database.Batchable<SObject>{
    
    public static final String A='N_DAYS_AGO:3';
     static final string QUERY = 'Select id,Name,Status__c ,CC_WatchList__c,Approval_Rejection_Date__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Approved\'  AND Approval_Rejection_Date__c='+A;
     global Database.QueryLocator start(Database.BatchableContext c) {    
        return Database.getQueryLocator(QUERY);        
    }
  
    global void execute(Database.BatchableContext c, List<PR_Request__c > objects) {
    list<PR_Request__c > UpdatePrRequest=new list<PR_Request__c >();
     Map<String,String> empMap = new Map<String,String>();
    
    //email template map population
     List<EmailTemplate> eList = new List<EmailTemplate>();
     eList = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Property Pass Folder'];
     for (EmailTemplate e:eList){
     String V=e.id;
      empMap.put(e.developername,v.substring(0,15));
                  }
    
    /*Email alise creation fom property pass*/
    String orgEmail = null;
    String orgEmailId = null;
    for(OrgWideEmailAddress owe : DG_DataUtil.getOrgWideEmaillAddresses(System.Label.Property_Pass)) {
        orgEmail = owe.Address;
        orgEmailId = owe.id;
    }
    
    
    // to identify the environamnt
    String urlString  = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());    
    
    
    
    
            Contact c2 = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
            insert c2;
                       
            List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
            list<String> watcherListDetails=new list<String>();
            
    
      //Population of To/CC for Actual Prod
         
          for(PR_Request__c obj : objects){
            
            if(obj.CC_WatchList__c!=null){
            list<String> watcheremails=obj.CC_WatchList__c.split(';');
            for(String X:watcheremails){
            watcherListDetails.add(X);
            
            }
            watcherListDetails.add(obj.Manager_Email__c);
            
           }
                
         obj.status__C='closed';
         obj.IsAutoColsed__c=true;
         
          //Added to show Auto Closed Request
         
         obj.ClosedDate__c=system.now();
        //End
        
        
         UpdatePrRequest.add(Obj);
         
         
         }
         
         
          Update UpdatePrRequest;
   
   
   
        for(PR_Request__c V1:UpdatePrRequest){         
         Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
                 List<String> emailToAddresses = new List<String>();
                emailToAddresses.add(v1.Requestor_Email__c);
                if(v1.Requestor_Email__c!=v1.Requestee_Email__c){
                     emailToAddresses.add(v1.Requestee_Email__c);
               
                }
                
                if (emailToaddresses.size() > 0){
                 if (urlString.toLowercase().contains('prod') || urlString.toLowercase().contains('uat')){
                     //if (production or uat) then send to actual users  
                     email.setToAddresses(emailToAddresses);
                     email.setCcAddresses(watcherListDetails);
                 } 
                 else {
                     //if not (production or uat) then send to group email for testing purposes
                     emailToAddresses = new List<String>();
                     emailToaddresses.add(orgEmail);
                 }                                         
                                       
                    
                     email.setOrgWideEmailAddressId(orgEmailId);
                    
                    system.debug('c is: ' + c2);
                    email.setTargetObjectId(c2.id);
                    email.setWhatId(v1.id);
                 //  email.setTemplateId('00Xf0000000E1GY');
                    email.setTemplateId(empMap.get(system.label.PP_email8));
                    
                    //system.debug('email-2'+a.set_Requestor_Template__c);
                    //for qa
                   // email.setTemplateId('00Xe0000000R5Ep');
                    
                    emailList.add(email);
                }
            }
             
         
         
        
         
         
    

    
    if (emailList.size() > 0) { 
            system.debug('email size'+emailList.size());
            system.debug('emailList: '+emailList);
            Messaging.sendEmail(emailList,true);
            
        }
        delete c2;

    
    
    
    
    
    
    
    //send email     
    
    
           }
    
    global void finish(Database.BatchableContext c) {
    }
  
}