@isTest
global with sharing class RL_Reminder_BatchUpdate implements Database.Batchable<sObject> {
	
	// list is assigned values from existing record
    public List<Reference_Letter_Request__C> requestList {get; set;}
    
    // list is assigned the updated values to update the records
    public List<Reference_Letter_Request__C> updateList {get; set;}
	
	// default implementation of start metod of batch interface
    global Database.QueryLocator start(Database.BatchableContext BC){
        /*String query = 'SELECT id, Status__C, SET_Q_EMAIL_Reminder_Name__c, Email_Requestor_Email__c, Reference_Letter_Code__c' +
                        ', Email_Q_Name__c, Email_OnBehalf_Email__c, set_q_email_cc__c, SET_Q_TEMPLATE_Reminder_Template__c' +
                        ', Conga_CC_Region_Org__c, Conga_Employee_Job_Country__c, Cong a_Employee_Department__c, Escalation__c' +
                        ' from REFERENCE_LETTER_REQUEST__C where Status__C=\'' + requestStatus + '\' AND name=\'' + requestId +'\'';*/
        String query = 'SELECT id, Status__C, SET_Q_EMAIL_Reminder_Name__c, Email_Requestor_Email__c, Reference_Letter_Code__c' +
                        ', Email_Q_Name__c, Email_OnBehalf_Email__c, set_q_email_cc__c, SET_Q_TEMPLATE_Reminder_Template__c' +
                        ', Conga_CC_Region_Org__c, Conga_Employee_Job_Country__c, Conga_Employee_Department__c, Escalation__c' +
                        ', Conga_Employee_Division_Dsc__c, Dept_Dsc_Org__c, Urgent_HR_Request__c, Conga_Super_Division_Dsc_Org__c' +
                        ', Submitted_Approved_Date__c from REFERENCE_LETTER_REQUEST__C where (Status__C=\'Approval Step 1\' OR' +
                        ' Status__C=\'Approval Step 2\' OR Status__C=\'Rejected By HR Partner\' OR Status__C=\'Approval Step 3\'' +
                        ' OR Status__C=\'Approval Step 4\') AND CreatedDate > 2014-10-29T10:00:00-00:00';
        return Database.getQueryLocator(query);
    }
    // default implementation of execute metod of batch interface
    global void execute(Database.BatchableContext BC, List<Reference_Letter_Request__C> scope){
        requestList = new List<Reference_Letter_Request__C>();
        updateList = new List<Reference_Letter_Request__C>();
        
        requestList = scope;
        
        for(Reference_Letter_Request__C req: requestList){
        	
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
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'HR_Partner_Approver_For_HR';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            //Hong Kong Administration excluding HR
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Administration'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Company' && (req.Conga_Employee_Department__c == 'Marketing' ||
	            			 		 req.Conga_Employee_Department__c == 'Corporate Communications' ||
	            			 		 req.Conga_Employee_Department__c == 'Reengineering & Expense management')) {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Administration_Corporat';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            //Hong Kong Corporate Services Popul
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Administration'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Company' && (req.Conga_Employee_Department__c == 'Corporate Services')) {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Corporate_Services_Popul';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            //Hong Kong Fixed Income Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Fixed Income & Commodities'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_FixedIncomeCoverageApprover';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            //Hong Kong GCM-Joint Venture Popul
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'GCM – Joint Venture'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_GCM_Joint_Venture_Popul';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            //Hong Kong Private Wealth Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Institutional Equity Division'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Private_Wealth_Manageme';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong IBD Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'IBD'
	            			 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_IBD_Coverage_Approvers';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Operations Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Operations') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Operations_Population';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Institutional Equity Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Institutional Equity Division'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_IED_Coverage_Approvers';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Investment Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Investment Management') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Investment_Management_P';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong MS Strats and Modeling
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'MS Strats and Modeling'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_MS_Strats_and_Modeling';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Research Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Research'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Research_Coverage_Approvers';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Technology & Data Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Technology & Data') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Technology_and_data';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Finance/Internal Audit/Legal Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Super_Division_Dsc_Org__c == 'Company'
	            		 && (req.Conga_Employee_Division_Dsc__c == 'Legal and Compliance'
	            		  || req.Conga_Employee_Division_Dsc__c == 'Internal Audit'
	            		  || req.Conga_Employee_Division_Dsc__c == 'Finance'
	            		  || req.Conga_Employee_Division_Dsc__c == 'Risk Management')) {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_FinanceInternalAuditLegal';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Bank Resource Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Resource Management'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Bank_Resource_Management';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Company Management
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Division_Dsc__c == 'Company Management'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Company') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Hong_Kong_Company_Management_Approvers';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong Company Management
	            else if(req.Conga_Employee_Job_Country__c == 'China' && req.Conga_Employee_Division_Dsc__c == 'JVs'
	            		 && req.Conga_Super_Division_Dsc_Org__c == 'Institutional Securities') {
	                if((req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'Asia_JV_Population';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  false) {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // Hong Kong HR Population
	            else if(req.Conga_Employee_Job_Country__c == 'Hong Kong' && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE) {
	                if(req.status__C == 'Approval Step 2'){
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'HR_Partner_H';
	                    req.set_q_email_cc__c = '';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	                } else if (req.status__C == 'Approval Step 1') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_Approver_For_HR';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            
	            //ASIAURG
	            // HR Partner Remainder Email For Australia
	            if(req.Conga_Employee_Job_Country__c == 'Australia' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Australia_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For China
	            else if(req.Conga_Employee_Job_Country__c == 'China' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'China_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For India
	            else if(req.Conga_Employee_Job_Country__c == 'India' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'India_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For Indonesia
	            else if(req.Conga_Employee_Job_Country__c == 'Indonesia' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Indonesia_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For Japan
	            else if(req.Conga_Employee_Job_Country__c == 'Japan' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Japan_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For Korea
	            else if(req.Conga_Employee_Job_Country__c == 'Korea' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Korea_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For Singapore
	            else if(req.Conga_Employee_Job_Country__c == 'Singapore' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Singapore_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For Taiwan
	            else if(req.Conga_Employee_Job_Country__c == 'Taiwan' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Taiwan_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For Thailand
	            else if(req.Conga_Employee_Job_Country__c == 'Thailand' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if( req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Thailand_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // HR Partner Remainder Email For Vietnam
	            else if(req.Conga_Employee_Job_Country__c == 'Vietnam' && (req.status__C == 'Approval Step 2'
	            		 ||(req.status__C == 'Approval Step 1' && req.Urgent_HR_Request__c ==  true))) {
					if(req.Reference_Letter_Code__c != 'RL0015'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'Vietnam_Coverage_Approvers';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	} else if (req.Reference_Letter_Code__c == 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                }
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            
	            //ASIA HR
	            if(req.Conga_CC_Region_Org__c != 'EU' && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE) {
					if (req.status__C == 'Approval Step 1' && req.Reference_Letter_Code__c != 'RL0015') {
	                    req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_Approver_For_HR';
	                    req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                    req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                } else if(req.status__C == 'Approval Step 2'){
		                req.SET_Q_EMAIL_Reminder_Name__c = 'HR_Partner_H';
		                req.set_q_email_cc__c = '';
		                req.SET_Q_TEMPLATE_Reminder_Template__c = 'Remainder_emails';
	            	}
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            
	            // Asia Emp Approval Step 1
	            else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Rejected By HR Partner') && req.Conga_CC_Region_Org__c != 'EU'){
	            	System.debug('***********Reminder batch Update********');
	                req.SET_Q_EMAIL_Reminder_Name__c = 'RL_HRSC_Queue_ASIA';
	                req.set_q_email_cc__c = 'references.asia@morganstanley.com';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'email5_Reminder_emails';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 1 - Employee
	            else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Approval Step 3') && req.Conga_CC_Region_Org__c == 'EU'
	                             && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_Approval_Queue_EMEA';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Reminder_emails';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 2 - Employee
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE && req.Escalation__c == 'No'){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_EMEA_Approver_Approval_Group';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Email_5b_Reminder_emails_HROPS';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 2 and Escalation - Employee
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'EMEA_HROPS';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Email_5c_Reminder_email_HRSCEMEAL3';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 4 - Employee
	            else if(((req.status__C == 'Approval Step 4' && req.Escalation__c == 'Yes')
	                         || (req.status__C == 'Approval Step 2' && req.Escalation__c == 'No'))
	                         && (req.Conga_CC_Region_Org__c == 'EU' && req.Conga_Employee_Department__c != System.Label.RL_HR_VALUE)){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_EMEA_Approver_Approval_Group';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Email_5d_Reminder_email_HRSC_Final';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 1 - HR
	            else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Approval Step 3') && req.Conga_CC_Region_Org__c == 'EU'
	                        && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'No'){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_EMEA_HR_Approval_Group';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Reminder_emails';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 2 - HR
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'NO'){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_EMEA_HR_Approver_Approval_Group';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Email_5b_Reminder_emails_HROPS';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 2 and Escalation Yes - HR
	            else if(req.status__C == 'Approval Step 2' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_EMEA_Senior_Hr_Approval_Group';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Email_5c_Reminder_email_HRSCEMEAL3';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            // EMEA Approval Step 4 - HR
	            else if(req.status__C == 'Approval Step 4' && req.Conga_CC_Region_Org__c == 'EU'
	                         && req.Conga_Employee_Department__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                req.SET_Q_EMAIL_Reminder_Name__c = 'HRSC_EMEA_HR_Approver_Approval_Group';
	                req.set_q_email_cc__c = '';
	                req.SET_Q_TEMPLATE_Reminder_Template__c = 'EMEA_Email_5d_Reminder_email_HRSC_Final';
	                req.Email_Requestor_Email__c = '';
	                req.Email_Q_Name__c = '';
	                req.Email_OnBehalf_Email__c = '';
	            }
	            updateList.add(req);
	            
	            if(updateList.size() == 200) {
	            	update updateList;
	            	updateList = new List<Reference_Letter_Request__C>();
	            }
            }
        }
        if(updateList.size() > 0) {
        	update updateList;
        }
        
    }
    // default implementation of stop metod of batch interface
    global void finish(Database.BatchableContext BC){
        
    }
}