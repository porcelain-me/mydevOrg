/******************************************************************************************
* Tap Request  -   Used for creating a tap request                       
*
* ChangeLog:
*
*   10/1/14- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public without sharing class TAPRequest { 
     
    public Tap_Request__c t {get;set;}
    
    
    public TAPRequest () {
    	
    	t = new Tap_Request__c();
       
    }
     
    
    /******************************************************************************************
    * EXIT    
    *
    *******************************************************************************************/
    
    public PageReference save(){
        
        Boolean error=false;
        
        if (t.request_type__c == null) {    			
        	t.request_type__c.addError('Request Type Is Required!');
        	error=true;
        }
        if (t.justification__c == null) {    			
        	t.justification__c.addError('Justifcation Is Required!');
        	error=true;
        }
        
        if (error)
        	return null;
        	
        t.status__c = 'System Admin Enabled for 24 hours';
        
        t.current_profile__c = UserInfo.getProfileId();
        
        t.user__c = UserInfo.getUserId();
        
        Profile p = [select id from Profile where name = 'System Administrator'];
        
        User u = [select firstname, alias, timezoneSidKey, emailencodingkey, localesidkey,languagelocalekey, lastname, email, username, profileid from User where id = :t.user__c];
        
        /* check if user already was created on previous request */
        String userCheck = u.username + '.admin';
        
        if (test.isRunningTest())
        	userCheck =  u.username + '893111';
        
        /* check if the user has an admin id, if so see if it active or not */
        List<User> checkUserList = [select id, isActive from User where username = :userCheck];
        if (checkUserList.size() > 0){
        	if (checkUserList[0].isActive){
        		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Your System Administrator id is already active. Use the forgot password feature to recover your password!'));
        		return null;
        	}
        }
         
       	if (checkUserList.size() > 0){  //previously created user so just reactivate and send password reset
       		TAP_Future.activateUser(checkUserList[0].id);
       		t.assigned_admin_user__c = checkUserList[0].id;
       	}
       	else{ //otherwise create new admin user with diff username 
        	User newU = u.clone();
         
        	newU.profileid = p.id;
        	newU.alias = 'adm' + u.alias.substring(0,5);
        	
        	if (test.isRunningTest())
        		newU.username = newU.username + '.893111';
        	else
        		newU.username = newU.username + '.admin';
        		
        		
        	try {
        		insert newU;
        	}
        	catch (Exception e){    
        		if (string.valueOf(e).contains('License Limit')) {    			
        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'There are too many salesforce license types used in this environment already; license limit exceeded!'));
        			return null;
        		}
        		else{
        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,string.valueOf(e)));
        			return null;
        		}
        		
        	}
        	
        	
        	t.assigned_admin_user__c = newU.id;
        	system.resetPassword(newU.id, true);
        	
       	}
       	
       	 String s = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());  
       	 
       	 if (s.contains('prod'))
       	 	t.environment__c = 'Production';
       	 else
       	 if (s.contains('dev'))
       	 	t.environment__c = 'DEV';
       	 else
       	 if (s.contains('qa'))
       	 	t.environment__c = 'QA';
       	  else
       	 if (s.contains('uat'))
       	 	t.environment__c = 'UAT';
       	 	
        insert t;
        
        
        
        return new PageReference('/' + System.Label.TAP_List_View_URL);
    }
    
	/******************************************************************************************
    * EXIT   
    *
    *******************************************************************************************/
    
    public PageReference exit(){
        
      
       return new PageReference('/' + + System.Label.TAP_List_View_URL);
    }
    
	
}