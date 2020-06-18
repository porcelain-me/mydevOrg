@isTest                                                //dummy class
global class PP_ApproverReminderOld implements Database.Batchable<SObject>{
    
    
     public static final String A='N_DAYS_AGO:2';
   
     static final string QUERY = 'Select id,Name,Property_Service_Approver__c,Status__c ,submitted_date__c,CC_WatchList__c,Removal_Date__c,Request_Type__c,Requestor_Email__c,Requestee_Email__c,createddate,LastModifiedDate,Manager_Email__c from PR_Request__c where Status__c=\'Submitted\' AND submitted_date__c='+A;
     global Database.QueryLocator start(Database.BatchableContext c) {    
        return Database.getQueryLocator(QUERY);        
    }
  
      global void execute(Database.BatchableContext c, List<PR_Request__c > objects) {
      list<PR_Request__c > UpdatePrRequest=new list<PR_Request__c >();
      Map<String,String> empMap = new Map<String,String>();
    
    
    //email template map poulation (id,api name)
    
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
    
    //group logic
     //group logic
     Map<String,String> gMap = new Map<String,String>();
    Map<string,String> gIdMap = new Map<string,String>();
    Map<string,List<GroupMember>> groupMemberMap = new Map<string,List<GroupMember>>();
    List<Group> gList = new List<Group>();
    gList = [Select g.Id, g.DeveloperName, (Select UserOrGroupId From GroupMembers) From Group g];
    for (Group g:gList){
        String V=g.id;
        gMap.put(g.developername,v.substring(0,15));
        gIdMap.put(v.substring(0,15),g.developername);
        groupMemberMap.put(g.id,g.GroupMembers);
    }
   
    
    
   
    
    
    //base URL which can be used to not send actual emails to test environments.
    
           String urlString  = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
    
    
    
    
    
            Contact c1 = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
             insert c1;
                       
            List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
                
                                           
                for(PR_Request__c obj : objects){
                list<String> watcherListDetails=new list<String>();
                    if(obj.CC_WatchList__c!=null){
                    list<String> watcheremails=obj.CC_WatchList__c.split(';');
                      for(String X:watcheremails){
                       watcherListDetails.add(X);
            
                         }
                    if(obj.Requestor_Email__c!=obj.Requestee_Email__c){
                      watcherListDetails.add(obj.Requestor_Email__c);
                       watcherListDetails.add(obj.Requestee_Email__c);
                    
                         }
                     else
                     {
                     watcherListDetails.add(obj.Requestor_Email__c);
                      }
            
                         }
                        
            
            
            
            
            
              // population of to/cc  list in emails for Prod
                 Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
                 List<String> emailToAddresses = new List<String>();
                 
                if(obj.Request_Type__c=='MS Office (Most common)' && obj.Manager_Email__c!=null){
                 
                emailToAddresses.add(obj.Manager_Email__c);
                }
                else
                {
                 ID gId1 = gMap.get(obj.Property_Service_Approver__c);
                
                List<GroupMember> gmList1 = groupMemberMap.get(gId1);
                if(gmList1.size()>0){
                Set<ID> userIdSet1 = new Set<ID>();
                for (GroupMember g:gmList1){
                    if (string.valueOf(g.UserOrGroupId).startswith('005')){
                        userIdSet1.add(g.UserOrGroupId);
                    }   
                }
                
                
                
                if (userIdSet1.size() > 0){
                    List<User> uList1 = [select email from User where id in :userIdSet1];
                    for (User u:uList1){
                        //added by sanjib
                        emailToAddresses.add(u.email);
                        email.setCcAddresses(watcherListDetails);
                    }
                }
                
                }
                }
                
                
               
                if (emailToaddresses.size() > 0){
                 if (urlString.toLowercase().contains('prod') || urlString.toLowercase().contains('uat')){
                     //if (production or uat) then send to actual users  
                     email.setToAddresses(emailToAddresses);
                 }
                 else {
                     //if not (production or uat) then send to group email for testing purposes
                     emailToAddresses = new List<String>();
                     emailToaddresses.add(orgEmail);
                 }
                                         
                                       
                    
                     email.setOrgWideEmailAddressId(orgEmailId);
                    
                    system.debug('c is: ' + c1);
                    email.setTargetObjectId(c1.id);
                    email.setWhatId(obj.id);
                  // email.setTemplateId('00Xf0000000Dzzg');
                    email.setTemplateId(empMap.get(system.label.PP_email7));
                    
                    //system.debug('email-2'+a.set_Requestor_Template__c);
                    //qa testing 
                   // email.setTemplateId('00Xe0000000R5Eo');
                    
                    
                    
                    emailList.add(email);
                }
            }
                   
                
         //send the email
         
                
                
                
                
                
                
            
            
            
            
            
            
            
            
         
    
    
    if (emailList.size() > 0) { 
            system.debug('email size'+emailList.size());
            system.debug('emailList: '+emailList);
            Messaging.sendEmail(emailList,true);
            
        }
        delete c1;

    
    
    
    
    
    
    
         }        
    
    global void finish(Database.BatchableContext c) {
    }
  
}