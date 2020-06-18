/*****************************************************************************************************
*
* This batch class is used to send reminder emails for Cross Sell submissions
*
* Change Log:
*
* 02/03/2016 - Created by Avinash
*
*******************************************************************************************************/

global with sharing class XS_SendEmails implements Database.Batchable<sObject> {
	
	public List<Cross_Sell__c> submissionList{get;set;}
	
	// default implementation of start metod of batch interface
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT id, Name FROM Cross_Sell__c WHERE Submission_Date__c = LAST_N_DAYS:7';
        
        return Database.getQueryLocator(query);
    }
    
    
    /*
    * This callse the send email helper for a set of reference letter requests
    *
    */
    global void execute(Database.BatchableContext BC, List<Cross_Sell__C> scope){
        // System.debug('Scheduled class ' + scope);
        XS_SendEmails sendMail = new XS_SendEmails();
        sendMail.setMailContent(scope);
    }
   
    
    // default implementation of stop metod of batch interface
    global void finish(Database.BatchableContext BC){
        
    }
    
    public List<Cross_Sell__c> getXSellList() {
    	List<Cross_Sell__c> xSell = [SELECT id, Name, Nominee__r.Division_Dsc_Org__c
    								 FROM Cross_Sell__c WHERE Submission_Date__c = LAST_N_DAYS:7];
    								 
		return xSell;
    }
    
    public List<Cross_Sell_Parties_Involved__c> getPartiesList() {
    	List<Cross_Sell_Parties_Involved__c> parties = [SELECT id, Name, Division__c FROM
    					 Cross_Sell_Parties_Involved__c WHERE LastModifiedDate = LAST_N_DAYS:7 AND Role__c= 'Division'];
    								 
		return parties;
    }
    
    public void setMailContent(List<Cross_Sell__c> xsellList) {
    
	    Contact c;
	    
	    List<Group> groupList;
	    List<EmailTemplate> emailList;
	    String orgEmail = null;
	    String orgEmailId = null;
	    
	    // values in this list will be deleted after sending emails
        List<contact> contactList = new List<Contact>();
        
    	/*
    	List<Cross_Sell__History> xSellhistory = [SELECT ParentId, OldValue, NewValue, Field, CreatedDate
    					 FROM Cross_Sell__History  WHERE CreatedDate = LAST_N_DAYS:7];
    	*/
    	
    	try {
	        
	        for(OrgWideEmailAddress owe : DG_DataUtil.getOrgWideEmaillAddresses(System.Label.XS_Orgwide_Email_Name)) {
	            orgEmail = owe.Address;
	            orgEmailId = owe.id;
	        }
    		
    		//Insert the contact one time for the set of requests
	        c = new Contact(firstname = '**test**', lastname = '**test**', email = orgEmail);
	        insert c;
	        
	        // add insert contact to this list
	        contactList.add(c);
    		
    		// Details of the present ORG - Values are DEV, QA, UAT, PROD
    		String env = System.Label.ORG_ENVIRONMENT.toLowerCase();
    		
    		groupList = [Select g.Id, g.DeveloperName, (Select UserOrGroupId From GroupMembers)
    							 From Group g WHERE g.DeveloperName like 'XS%' ];
	        Map<String,String> gMap = new Map<String,String>();
	        Map<string,List<GroupMember>> groupMemberMap = new Map<string,List<GroupMember>>();
	        for (Group g : groupList){
	            String v = g.id;
	            gMap.put(g.developername,v);
	            groupMemberMap.put(v,g.GroupMembers);
	        }
    		
    		emailList = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name = 'XSell'];
    		Map<String, String> emailMap = new Map<String, String>();
	        for (EmailTemplate e : emailList){
	            String V=e.id;
	            emailMap.put(e.developername,v.substring(0,15));
	        }
        
	        List<String> emailToAddresses = new List<String>();
	        
			// Create object for Email Message
			Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
	        
	        // list to add email objects
	        List<Messaging.Singleemailmessage> emailSendList = new List<Messaging.SingleEmailMessage>();
	        
	        for(Group groupName : groupList){
		            	
            	Id gId = gMap.get(groupName.developername);
            
	            if(groupMemberMap.size() > 0){
	                List<GroupMember> gmList = groupMemberMap.get(gId);
	                Set<ID> userIdSet = new Set<ID>();
	                
	                for (GroupMember g:gmList){
	                    if (string.valueOf(g.UserOrGroupId).startswith('005')){
	                        userIdSet.add(g.UserOrGroupId);
	                    }
	                }
	                
	                if (userIdSet.size() > 0){
	                    List<User> uList = [select email from User where id in :userIdSet];
	                    for (User u:uList){
	                        emailToAddresses.add(u.email);
	                    }
	                }
	            }
	            
	        	system.debug('reminder email - ' + emailSendList.size());
	        	
	        	if(groupName.developername == 'XS_Super_Users'
	        			 || groupName.developername == 'XS_Public_Delegate_users'
	        			 || groupName.developername == 'XS_Delegate_Users' ) {
		            
		            if (!env.contains('prod')) {  //if not production then send to group email for testing purposes
		                emailToAddresses = new List<String>();
				        // emailToAddresses.add(orgEmail);
		            } else {
		            	
		                if(emailToAddresses.size() > 0) {
		                    String emailOfContact = emailToAddresses.get(0);
		                    c = new Contact(firstname = '**test**', lastname = '**test**', email = emailOfContact);
		                    insert c;
		                    
		                    String removed = emailToAddresses.remove(0);
		                    System.debug('removed element : ' + removed);
		                    System.debug('List size after deletion: ' + emailToAddresses.size());
		                }
		            }
		            
		            // initialize email object
		            email = new Messaging.singleEmailMessage();
		            
		            email.setToAddresses(emailToAddresses);
		            email.setSaveAsActivity(false);
		            email.setTargetObjectId(c.id);
		            email.setOrgWideEmailAddressId(orgEmailId);
		            email.setWhatId(xsellList[0].id);
		            email.setTemplateId(emailMap.get('XS_superuser_delegate_weekly'));
		            
		            /*
		            String temp = '<html>';
		            temp += '<br/><div>Hi,</div><br/>';
		            temp +='<div>Below is an update of submisisons during the week ending '
		            			 + Datetime.now().format('MMM dd, yyyy')+'</div><br/>';
					temp += '<span style="margin-left:30px;">';
					temp += '- &nbsp;&nbsp;' + xsellList.size() + ' submission(s) has/have been logged this week<br/></span>';
					temp += '<ul style="margin-left:60px;list-style-type:circle"><li>' + +
									 'reflect nominees from within your division</li>';
					temp += '<li>transactions where your division has been cited as the beneficiary</li></ul><br/>';
					temp += '<span style="margin-left:30px;">- &nbsp;&nbsp;Please click <a href=" ' + System.Label.DG_BaseUrl 
									+ '/apex/XS_Opportunity">here</a> for more details</span>';
					temp += '</html>';
					System.debug('temp: ' + temp);
					
		            email.setHtmlBody(temp);
		            */
		        
			        // add email object to list to send the list of mails at once
			        if (email != null)
		        		emailSendList.add(email);
		        }
	        }
			
	        //send the list one time
	        if (emailSendList.size() > 0) {
	        	System.debug('emailSendList.size(): ' + emailSendList.size());
	            Messaging.sendEmail(emailSendList,true);
	        }
	        
    	} catch(Exception e) {
    		
    	} finally {
			if(contactList.size() > 0) {
                for(Contact item: contactList)
                    delete item;
            }
		}
    }

}