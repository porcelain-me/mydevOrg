/***
* CampaignEmailScheduler

* Description:This class is created to send an aggregate alert at the end of the day to Target list owners
If contacts are added to their list throught out the day.

* Author : Vipin Makhija , 13/04/2015 

06/05/15 VM moved the send email method out of loop to prevent the email invocation limit 
08-May-17 Jaideep Menon : Jira 4913: Added logic to filter users from receiving notifications.

Looping active users and fetching Id to assign it to mail , To prevent the external email limit ,
Now all emails are considered internal and there is no limit. 

***/
global class CampaignEmailScheduler implements Schedulable {         
	
	
	global void execute(SchedulableContext SC){
	
	//Fetching list of target list members created in last 1 day
	list <Target_List_Member__c >  listMembers =  [select id , iiCampaign__c , Contact_Name__c ,Account__c, TN_ID__c , Name , Target_List_Status__c ,   User_Email__c  from Target_List_Member__c where Days_since_created__c < 1 and ((Target_List__r.Override_iiCampaign_Notification_Setting__c = false and Target_List__r.iiCampaign__r.Target_List_Update_Notifications_Enabled__c = true) or (Target_List__r.Override_iiCampaign_Notification_Setting__c = true and Target_List__r.Receive_Target_List_Update_Notifications__c = true)) order by iiCampaign__c asc];
	
	Map<String , list <Target_List_Member__c >> mapTargetListMembers = new Map<String , list <Target_List_Member__c >>();
	
	list<Messaging.SingleEmailMessage> listEmail = new list<Messaging.SingleEmailMessage>();

	Map<String,String> mapUserId = new Map<String,String>();
	
    //Iterating list of members and creating map of target list owner against its target list members
	for(Target_List_Member__c tm : listMembers) {
		
	  
	  if(mapTargetListMembers != null && mapTargetListMembers.keyset().contains(tm.User_Email__c)){
		  
		  list<Target_List_Member__c> targetlistMembers = mapTargetListMembers.get(tm.User_Email__c);
		  targetlistMembers.add(tm);
		  mapTargetListMembers.put(tm.User_Email__c ,targetlistMembers);
		  
	  }else {
	  	

	      list<Target_List_Member__c> targetlistMembers = new list<Target_List_Member__c>();
	      targetlistMembers.add(tm);
	      mapTargetListMembers.put(tm.User_Email__c ,targetlistMembers);
      
	  	}
	}  
	
	//Querying user's email and Id , This is done to assign user Id to mail so that email count is considered as internal users
	for(User usr : [select id , email from User where isActive = true]){
	
		mapUserId.put(usr.email , usr.id);

	}
	//Processing target list owner emails set and creating a mail 
	  for(String emailStr : mapTargetListMembers.keyset()){

		  system.debug(emailStr + 'emailStr**');
		  String emailAddr = emailStr ;
		  String command = 'iiCampaign Target List Updates '+ '  ' +system.today() ;
		   
		  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    
	      mail.setToAddresses( new String[]{emailAddr} );
	      mail.setSubject( command );
	      mail.setTargetObjectId(mapUserId.get(emailStr)); 
	      mail.setSaveAsActivity(false);   
		  for(OrgWideEmailAddress owa : [select id,DisplayName, Address from OrgWideEmailAddress]) {

		      if(owa.DisplayName == 'iicampaign-admin') 
		      		mail.setOrgWideEmailAddressId(owa.id);		  
		  }	      
	      
	      String body  = 'Following contacts have been added to your Target Lists ';
	      

	      
	      body = body + '<br><br><table border="1">'; 

	      body = body +  '<tr>'+
	      	  '<th>'+ 'Campaign Name' + '</th>'+
			  '<th>'+ 'Contact Name' + '</th>'+
			    '<th>'+'Account Name'+ '</th>' +
			    '<th>'+'Contact TN ID' + '</th>'+
			 ' </tr> <br>';
		 
		 //Processing the target list members while adding theit attributes in mail	 	      
	      for(Target_List_Member__c tmvar : mapTargetListMembers.get(emailStr)){	      	   
	      	body = body +  '<tr>'+
	      	'<td>'+ tmvar.iiCampaign__c+ '</td>'+
			  '<td>'+ tmvar.Contact_Name__c+ '</td>'+
			    '<td>'+(tmvar.Account__c != null && tmvar.Account__c != ''?tmvar.Account__c:'')+ '</td>' +
			    '<td>'+tmvar.TN_ID__c+ '</td>'+
			 ' </tr> <br>';
	      
	      }
	      
	      	body = body + '</table> <br>';
	      	
	      	body = body + 'More Details <a href = '+ Label.CampaignForceShortURL + '> '+Label.CampaignForceShortURL+' </a>' ; 
	        mail.setHtmlBody(body);
	        	  	  		
	  		listEmail.add(mail);
	   	  //Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail} );		
	  
	  	} 
  		
  		Messaging.sendEmail( listEmail );		
		
	}
	
}