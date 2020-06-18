/**
* 
* To send reminder emails without updating the record 
* Author : Avinash Munaga
*
*/
@isTest
public without sharing class RL_Reminder_SendMail {
	
	List<Group> groupList;
	List<EmailTemplate> emailList;
	
	public void getGroupMembers(){
		
		groupList = [Select g.Id, g.DeveloperName, (Select UserOrGroupId From GroupMembers) From Group g];
		
	}
	
	public void getEmailTemplates(){
		
		emailList = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name = 'Ref Letter Folder'];
		
	}
	
	public void sendMail(Reference_Letter_Request__c ref, String qEmail, String qEmailCC, String qTemplate){
		
		String env = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
		
		Map<String, String> emailMap = new Map<String, String>();
		for (EmailTemplate e : emailList){
	        String V=e.id;
	        emailMap.put(e.developername,v.substring(0,15));
	    }
		
		Map<String,String> gMap = new Map<String,String>();
	    Map<string,String> gIdMap = new Map<string,String>();
	    Map<string,List<GroupMember>> groupMemberMap = new Map<string,List<GroupMember>>();
	    for (Group g : groupList){
	        String v = g.id;
	        gMap.put(g.developername,v);
	        gIdMap.put(v,g.developername);
	        groupMemberMap.put(v,g.GroupMembers);
	    }
		
		List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
		Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
		
        List<String> emailAddressList = new List<String>();
        
        /* this is for the q notifications */
        List<String> emailToAddresses = new List<String>();
        List<String> emailCCAddresses = new List<String>();
        
        if(qEmail != null && qEmail != '' && !qEmail.contains('@')){
        	Id gId = gMap.get(qEmail);
            System.debug('qEmail: ' + qEmail);
            System.debug('gId: ' + gId);
            
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
            
            String orgEmail = null;
		    String orgEmailId = null;
		    for(OrgWideEmailAddress owe : DG_DataUtil.getOrgWideEmaillAddresses(System.Label.RL_Orgwide_Email_Name)) {
		        orgEmail = owe.Address;
		        orgEmailId = owe.id;
		    }
		    Contact c = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
	        insert c;
			
			if (!env.contains('prod')){  //if not production then send to group email for testing purposes
	            emailToAddresses = new List<String>();
	            emailToaddresses.add(orgEmail);
	        } else
	            email.setToAddresses(emailToAddresses);
	            
	        if(qEmailCC != null && qEmailCC != '' && env.contains('prod')){
	        	emailCCAddresses.add(qEmailCC);
	            email.setCcAddresses(emailCCAddresses);
	        }
	        
	        //email.setToAddresses(emailToAddresses);
	        email.setSaveAsActivity(false);
	        email.setTargetObjectId(c.id);
	        email.setOrgWideEmailAddressId(orgEmailId);
	        email.setWhatId(ref.id);
	        email.setTemplateId(emailMap.get(qTemplate));
	        
	        system.debug('email-1');
			emailList.add(email);
			
			if (emailList.size() > 0) { 
	            system.debug('email size'+emailList.size());
	            Messaging.sendEmail(emailList,true);
	        }
	        delete c;
		}
	}
	
	public void setMailContent(){
		
		String query = 'SELECT id, Status__C, SET_Q_EMAIL_Reminder_Name__c, Email_Requestor_Email__c, Reference_Letter_Code__c' +
                        ', Email_Q_Name__c, Email_OnBehalf_Email__c, set_q_email_cc__c, SET_Q_TEMPLATE_Reminder_Template__c' +
                        ', Conga_CC_Region_Org__c, Conga_Employee_Job_Country__c, Conga_Employee_Department__c, Escalation__c' +
                        ', Conga_Employee_Division_Dsc__c, Dept_Dsc_Org__c, Urgent_HR_Request__c, Conga_Super_Division_Dsc_Org__c' +
                        ', Submitted_Approved_Date__c from REFERENCE_LETTER_REQUEST__C where (Status__C=\'Approval Step 1\' OR' +
                        ' Status__C=\'Approval Step 2\' OR Status__C=\'Rejected By HR Partner\' OR Status__C=\'Approval Step 3\'' +
                        ' OR Status__C=\'Approval Step 4\') AND CreatedDate > 2014-10-29T10:00:00-00:00';
		List<Reference_Letter_Request__C> refList = Database.query(query);
		
		for(Reference_Letter_Request__C req: refList) {
			
			String qEmail = '';
			String qEmailCC = '';
            String template = '';
            	
        	Long differenceInHrs = 0;
        	if(req.Submitted_Approved_Date__c != null){
        		DateTime currentTime = DateTime.now();
	        	DateTime reqUpdated = req.Submitted_Approved_Date__c;
	        	differenceInHrs = (currentTime.getTime() - reqUpdated.getTime())/1000/60/60;
	        	System.debug('Time Diff : ' + differenceInHrs);
        	}
            
            if(differenceInHrs > 24){
            	
            	//Approval Process 1 - Reference Letter Request: Travel Insurace Cover Note Approval HR
	            if(req.Reference_Letter_Code__c == 'RL0015' && req.status__C == 'Approval Step 1') {
	                if(req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE){
	                    qEmail = 'HR_Partner_Approver_For_HR';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            //Hong Kong Administration excluding HR
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Administration'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Company' && (req.Conga_Employee_Department__c == 'Marketing' ||
	            			 		 req.Conga_Employee_Department__c == 'Corporate Communications' ||
	            			 		 req.Conga_Employee_Department__c == 'Reengineering & Expense management')) {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Administration_Corporat';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            //Hong Kong Corporate Services Popul
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Administration'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Company' && (req.Conga_Employee_Department__c == 'Corporate Services')) {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Corporate_Services_Popul';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            //Hong Kong Fixed Income Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Fixed Income & Commodities'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_FixedIncomeCoverageApprover';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            //Hong Kong GCM-Joint Venture Popul
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'GCM – Joint Venture'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_GCM_Joint_Venture_Popul';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            //Hong Kong Private Wealth Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Institutional Equity Division'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Private_Wealth_Manageme';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong IBD Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'IBD'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_IBD_Coverage_Approvers';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Operations Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Operations') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Operations_Population';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Institutional Equity Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Institutional Equity Division'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_IED_Coverage_Approvers';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Investment Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Investment Management') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Investment_Management_P';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong MS Strats and Modeling
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'MS Strats and Modeling'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_MS_Strats_and_Modeling';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	                
	                
	                
	            }
	            // Hong Kong Research Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Research'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Research_Coverage_Approvers';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Technology & Data Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Technology & Data') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Technology_and_data';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Finance/Internal Audit/Legal Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Company'
	            		 && (req.Conga_Employee_Division_Dsc__c == 'Legal and Compliance'
	            		  || req.Conga_Employee_Division_Dsc__c == 'Internal Audit'
	            		  || req.Conga_Employee_Division_Dsc__c == 'Finance'
	            		  || req.Conga_Employee_Division_Dsc__c == 'Risk Management')) {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_FinanceInternalAuditLegal';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Bank Resource Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Resource Management'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Bank_Resource_Management';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Company Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Company Management'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Company') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Hong_Kong_Company_Management_Approvers';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong Company Management
	            else if(req.Conga_Employee_Job_Country__c == 'China' && req.Conga_Employee_Division_Dsc__c == 'JVs'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    qEmail = 'Asia_JV_Population';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // Hong Kong HR Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE) {
	                if(req.status__C == 'Approval Step 2'){
	                    qEmail = 'HR_Partner_H';
	                    qEmailCC = '';
	                    template = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1') {
	                    qEmail = 'HRSC_Approver_For_HR';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            
	            //ASIAURG
	            // HR Partner Remainder Email For Australia
	            if(req.Conga_Employee_Job_Country__c == 'Australia' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Australia_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For China
	            else if(req.Conga_Employee_Job_Country__c == 'China' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'China_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For India
	            else if(req.Conga_Employee_Job_Country__c == 'India' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'India_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For Indonesia
	            else if(req.Conga_Employee_Job_Country__c == 'Indonesia' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Indonesia_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For Japan
	            else if(req.Conga_Employee_Job_Country__c == 'Japan' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Japan_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For Korea
	            else if(req.Conga_Employee_Job_Country__c == 'Korea' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Korea_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For Singapore
	            else if(req.Conga_Employee_Job_Country__c == 'Singapore' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Singapore_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For Taiwan
	            else if(req.Conga_Employee_Job_Country__c == 'Taiwan' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Taiwan_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For Thailand
	            else if(req.Conga_Employee_Job_Country__c == 'Thailand' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Thailand_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            // HR Partner Remainder Email For Vietnam
	            else if(req.Conga_Employee_Job_Country__c == 'Vietnam' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if(req.Reference_Letter_Code__c != 'RL0015'){
		                qEmail = 'Vietnam_Coverage_Approvers';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	            }
	            
	            //ASIA HR
	            if(req.Conga_CC_Region_Org__c != 'EU' && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE) {
					if (req.status__C == 'Approval Step 1' && req.Reference_Letter_Code__c != 'RL0015') {
	                    qEmail = 'HRSC_Approver_For_HR';
	                    qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                } else if(req.status__C == 'Approval Step 2'){
		                qEmail = 'HR_Partner_H';
		                qEmailCC = '';
		                template = 'Remainder_emails';
	            	}
	            }
	            
	            // Asia Emp Approval Step 1
	            else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Rejected By HR Partner') && req.Conga_CC_Region_Org__c != 'EU'){
	                qEmail = 'RL_HRSC_Queue_ASIA';
	                qEmailCC = 'references.asia@morganstanley.com';
	                template = 'email5_Reminder_emails';
	            }
	            // EMEA Approval Step 1 - Employee
	            else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Approval Step 3') && req.Conga_CC_Region_Org__c == 'EU'
	                             && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE){
	                qEmail = 'HRSC_Approval_Queue_EMEA';
	                qEmailCC = '';
	                template = 'EMEA_Reminder_emails';
	            }
	            // EMEA Approval Step 2 - Employee
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE && req.Escalation__c == 'No'){
	                qEmail = 'HRSC_EMEA_Approver_Approval_Group';
	                qEmailCC = '';
	                template = 'EMEA_Email_5b_Reminder_emails_HROPS';
	            }
	            // EMEA Approval Step 2 and Escalation - Employee
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                qEmail = 'EMEA_HROPS';
	                qEmailCC = '';
	                template = 'EMEA_Email_5c_Reminder_email_HRSCEMEAL3';
	            }
	            // EMEA Approval Step 4 - Employee
	            else if(((req.status__C == 'Approval Step 4' && req.Escalation__c == 'Yes')
	                         || (req.status__C == 'Approval Step 2' && req.Escalation__c == 'No'))
	                         && (req.Conga_CC_Region_Org__c == 'EU' && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE)){
	                qEmail = 'HRSC_EMEA_Approver_Approval_Group';
	                qEmailCC = '';
	                template = 'EMEA_Email_5d_Reminder_email_HRSC_Final';
	            }
	            // EMEA Approval Step 1 - HR
	            else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Approval Step 3') && req.Conga_CC_Region_Org__c == 'EU'
	                        && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'No'){
	                qEmail = 'HRSC_EMEA_HR_Approval_Group';
	                qEmailCC = '';
	                template = 'EMEA_Reminder_emails';
	            }
	            // EMEA Approval Step 2 - HR
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'NO'){
	                qEmail = 'HRSC_EMEA_HR_Approver_Approval_Group';
	                qEmailCC = '';
	                template = 'EMEA_Email_5b_Reminder_emails_HROPS';
	            }
	            // EMEA Approval Step 2 and Escalation Yes - HR
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                qEmail = 'HRSC_EMEA_Senior_Hr_Approval_Group';
	                qEmailCC = '';
	                template = 'EMEA_Email_5c_Reminder_email_HRSCEMEAL3';
	            }
	            // EMEA Approval Step 4 - HR
	            else if(req.status__C == 'Approval Step 4' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                qEmail = 'HRSC_EMEA_HR_Approver_Approval_Group';
	                qEmailCC = '';
	                template = 'EMEA_Email_5d_Reminder_email_HRSC_Final';   
	            }
            }
            
            RL_Reminder_SendMail reminder = new RL_Reminder_SendMail();
            reminder.sendMail(req, qEmail, qEmailCC, template);
		}
	}
}