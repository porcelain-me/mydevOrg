// 
//   (c) 2010 Appirio, Inc.
//
//   BatchReassignedContactNotification (Batch Classs to send Reassignment Notification to Users)
//   
//   03 Aug 2010   Prafull Gupta      Original (PR-05654).
//	 09 May 2015   Jaideep Menon      Add Org-wide address
//
global class BatchReassignedContactNotification implements Database.Batchable<sObject>{
  
  global final String query;
  
  // Constructor
  global BatchReassignedContactNotification(){
    query = 'Select Target_List__r.User__r.Email, Target_List__c, Reassigned_By__r.Preferred_Name__c, Reassigned_By__r.LastName,' +  
            ' GPSContact__r.FirstName__c, GPSContact__r.LastName__c, Account__c' + 
            ' From Target_List_Member__c' + 
            ' where Reassigned_By__c != null and' + 
            ' Removed_Reason__c = null and' + 
            ' Viewed_By_User__c = false and' + 
            ' Reassigned_Date__c > ' + (String.valueOf(System.now().addHours(-24))).replace(' ', 'T') + 'z';
    
  }
  
  // start method implementation of  database.batchable
  global Database.Querylocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
  }
  
  // execute method implementation of  database.batchable
  global void execute(Database.BatchableContext BC, List<Sobject> scope) {
    System.debug('______EXECUTING BATCH_______');
    
    Map<String, List<Target_List_Member__c>> mapTargetListMembers = new Map<String, List<Target_List_Member__c>>();
    Target_List_Member__c tlistMember;
    
    for(Sobject sobj: scope) {
      tlistMember = (Target_List_Member__c) sobj;
      if(mapTargetListMembers.containsKey(tlistMember.Target_List__c)) {
        List<Target_List_Member__c> lstItems = mapTargetListMembers.get(tlistMember.Target_List__c);
        lstItems.add(tlistMember);
        mapTargetListMembers.put(tlistMember.Target_List__c, lstItems);
      } else {
        // this is the first entry for this OpportunityLineItem
        mapTargetListMembers.put(tlistMember.Target_List__c, new List<Target_List_Member__c>{tlistMember});
      }
    }
    
    System.debug('_______MAP TARGET LIST MEMBERS_______' + mapTargetListMembers);
    
    Map<String, String> mapRecepientToMailBody = prepareMailBody(mapTargetListMembers);
    
    System.debug('______MAP RECEPIENT TO MAIL BODY_______' + mapRecepientToMailBody);
    
    List<Messaging.SingleEmailMessage> mails = createMailsToSend(mapRecepientToMailBody);
    Messaging.sendEmail(mails);  
  }
  
  // finish method implementation of  database.batchable
  global void finish(Database.BatchableContext BC) {
    System.debug('__________________FINISHED________________');
  }
  
  
  // Method generating mail body from target list member data
  private Map<String, String> prepareMailBody(Map<String, List<Target_List_Member__c>> mapTargetListMembers) {
    Map<String, String> mapRecepientMailBody = new Map<String, String>();
    String mailBody = '';
    String recepientEmail = '';
    List<Target_List_Member__c> lstMembers;
    for(String targetListId : mapTargetListMembers.keySet()){
      lstMembers = mapTargetListMembers.get(targetListId);
      recepientEmail = lstMembers[0].Target_List__r.User__r.Email;
      mailBody = '';
      mailBody += 'You have been reassigned ' + lstMembers.size() + ' new contacts. Their details can be found below. Please review and take action on these contacts within the II Campaign Application, accessible from within the II application.';
      mailBody += '<br/><br/>';
      mailBody += '<table border="1" cellspacing="0" cellpadding="0" style="width:800px">'; 
      mailBody +=   '<tr>';
      mailBody +=     '<th>Reassigned By</th>';
      mailBody +=     '<th>Account</th>';
      mailBody +=     '<th>First Name</th>';
      mailBody +=     '<th>Last Name</th>';
      mailBody +=   '</tr>';
      
      for(Target_List_Member__c member : lstMembers){
        mailBody +=   '<tr>';
        mailBody +=     '<td width="200px">' + member.Reassigned_By__r.Preferred_Name__c + ' ' + member.Reassigned_By__r.LastName +  '</td>';
        mailBody +=     '<td width="200px">' + member.Account__c + '</td>';
        mailBody +=     '<td width="200px">' + member.GPSContact__r.FirstName__c + '</td>';
        mailBody +=     '<td width="200px">' + member.GPSContact__r.LastName__c + '</td>';
        mailBody +=   '</tr>';
      }
  
      mailBody += '</table>';
      mapRecepientMailBody.put(recepientEmail, mailBody);
    }
    
    return mapRecepientMailBody;
  }
  
  // method prepating mails to send
  private Messaging.SingleEmailMessage[] createMailsToSend(Map<String, String> mapRecepientToMailBody) {
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();
    
    Messaging.SingleEmailMessage mail;
    Id orgWideAddressId;
    
    for(OrgWideEmailAddress owa : [select id,DisplayName, Address from OrgWideEmailAddress]) {
		if(owa.DisplayName == 'iicampaign-admin') 
			orgWideAddressId = owa.id;			  
	}	     
		  
    for(String emailAddress : mapRecepientToMailBody.keySet()){
      mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(new String [] {emailAddress});
      
      mail.setSubject('II Campaign – Contact Reassignment Notification');
      mail.setHtmlBody(mapRecepientToMailBody.get(emailAddress));
      
      if(orgWideAddressId != null)
      	mail.setOrgWideEmailAddressId(orgWideAddressId);
      else
      	mail.setSenderDisplayName('NOTIFICATION: MORGAN STANLEY');
      
      mails.add(mail);
    }
    return mails;
  }
  
}