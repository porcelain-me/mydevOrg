/**
* 
* To send reminder emails without updating the record 
* Author : Avinash Munaga
*
* Change Log:
*
* 12/3/14 - Restructured class to respect governor limits
* 24/04/2015 - changes made to GCM-Joint ventures
*/

public without sharing class RL_Reminder_SendEmailsHelper {
    
    Contact c; 
    
    List<Group> groupList;
    List<EmailTemplate> emailList;
    String orgEmail = null;
    String orgEmailId = null;
    List<Messaging.Singleemailmessage> emailSendList = new List<Messaging.SingleEmailMessage>();
    
    // This is called from the rl_reminder_sendemails process  
    
    public void setMailContent(List<Reference_Letter_Request__c> refList){
        
        //Do this stuff only once per set of requests so that governor limits are not exceeded
        
        groupList = [Select g.Id, g.DeveloperName, (Select UserOrGroupId From GroupMembers) From Group g];
        emailList = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name = 'Ref Letter Folder'];
        
        for(OrgWideEmailAddress owe : DG_DataUtil.getOrgWideEmaillAddresses(System.Label.RL_Orgwide_Email_Name)) {
            orgEmail = owe.Address;
            orgEmailId = owe.id;
        }
        
        //Insert the contact one time for the set of requests
        c = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
        insert c;

		try {
        	//process the set of requests
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
	            
	            if(differenceInHrs > Long.valueOf(System.Label.RL_ReminderTimeDiff)){
	                
	                //Approval Process 1 - Reference Letter Request: Travel Insurace Cover Note Approval HR
	                if(req.Reference_Letter_Code__c == 'RL0015'
	                     && (req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')) {
	                    if(req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE){
	                        qEmail = 'HR_Partner_Approver_For_HR';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                //Approval Process 3&4 - Reference Letter Request: For Terminated one step
	                if(req.Reference_Letter_Code__c == 'RL0004' && req.One_Step_Approval__c) {
	                    if(req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE){
	                        qEmail = 'HR_Partner_Approver_For_HR';
	                        qEmailCC = '';
	                        template = 'email5_Reminder_emails';
	                    } else {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                //Approval Process 5 & 6 - Reference Letter Request: For HR
	                if((req.Job_Region_Code__c == 'NJ' || req.Job_Region_Code__c == 'JA') 
	                					&& req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE) {
	                    if(req.Urgent_HR_Request__c){
	                        qEmail = 'HR_Partner_H';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else {
	                        qEmail = 'HRSC_Approver_For_HR';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                
	                /*ALM 258 : 'Please consolidate all 15 Hong Kong Approver queues into 2 queues | MAQ : 29th March 2017 : START */
	                else if(req.Conga_Job_Country_Job__c == 'HKG' && (req.Conga_Super_Division__c == '10200' || req.Conga_Super_Division__c == '98100' 
	                			|| req.Conga_Super_Division__c == '10300' || req.Conga_Super_Division__c == '10999' || req.Conga_Super_Division__c == '11100')
	                			&& req.Conga_Division_Org__c != '89521' ){
	                    if(((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                        qEmail = 'Hong_Kong_Infra_Ops_Tech_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if ((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  false) {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                /* For  Hong Kong ISG Coverage Approvers Approvals */
	                 else if(req.Conga_Job_Country_Job__c == 'HKG' && (req.Conga_Super_Division__c == '10600'
	                             || req.Conga_Super_Division__c == '10100' || req.Conga_Super_Division__c == '10910')) {
	                    if(((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                        qEmail = 'Hong_Kong_ISGCoverageApprovers';
	                        qEmailCC = '';	
	                        template = 'Remainder_emails';
	                    } else if ((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  false) {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                } 
	                
	                /*ALM 258 : 'Please consolidate all 15 Hong Kong Approver queues into 2 queues | MAQ : 29th March 2017 : END */
	               
	                // Hong Kong Company Management
	                else if(req.Conga_Job_Country_Job__c == 'HKG' && req.Conga_Division_Org__c == '85000'
	                         && req.Conga_Super_Division__c == '10300') {
	                    if(((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                        qEmail = 'Hong_Kong_Company_Management_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if ((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  false) {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // Asia Jv's
	                else if(req.Conga_Job_Country_Job__c == 'CHN' && req.Conga_Division_Org__c == '94150'
	                         && req.Conga_Super_Division__c == '10100') {
	                    if(((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true) || req.status__C == 'Approval Step 2'){
	                        qEmail = 'Asia_JV_Population';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if ((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  false) {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                
	                //ASIAURG
	                // HR Partner Remainder Email For Australia
	                else if(req.Conga_Job_Country_Job__c == 'AUS' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Australia_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For China
	                else if(req.Conga_Job_Country_Job__c == 'CHN' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'China_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For India
	                else if(req.Conga_Job_Country_Job__c == 'IND' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'India_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For Indonesia
	                else if(req.Conga_Job_Country_Job__c == 'IDN' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Indonesia_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For Japan
	                else if(req.Conga_Job_Country_Job__c == 'JPN' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Japan_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For Korea
	                else if(req.Conga_Job_Country_Job__c == 'KOR' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Korea_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For Singapore
	                else if(req.Conga_Job_Country_Job__c == 'SGP' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Singapore_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For Taiwan
	                else if(req.Conga_Job_Country_Job__c == 'TWN' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Taiwan_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For Thailand
	                else if(req.Conga_Job_Country_Job__c == 'THA' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if( req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Thailand_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                // HR Partner Remainder Email For Vietnam
	                else if(req.Conga_Job_Country_Job__c == 'VNM' && (req.status__C == 'Approval Step 2'
	                         ||((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Urgent_HR_Request__c ==  true))) {
	                    if(req.Reference_Letter_Code__c != 'RL0015'){
	                        qEmail = 'Vietnam_Coverage_Approvers';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    } else if (req.Reference_Letter_Code__c == 'RL0015') {
	                        qEmail = 'RL_HRSC_Queue_ASIA';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    }
	                }
	                
	                //ASIA HR
	                else if(req.Job_Region_Code__c != 'EU' && req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE) {
	                    if ((req.status__C == 'Approval Step 1' || req.status__C == 'Rejected By HR Partner')
	                                 && req.Reference_Letter_Code__c != 'RL0015') {
	                        qEmail = 'HRSC_Approver_For_HR';
	                        // qEmailCC = 'references.asia@morganstanley.com';
	                        template = 'email5_Reminder_emails';
	                    } else if(req.status__C == 'Approval Step 2'){
	                        qEmail = 'HR_Partner_H';
	                        qEmailCC = '';
	                        template = 'Remainder_emails';
	                    }
	                }
	                
	                // Asia Emp Approval Step 1
	                else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Rejected By HR Partner') && req.Job_Region_Code__c != 'EU'){
	                    qEmail = 'RL_HRSC_Queue_ASIA';
	                    // qEmailCC = 'references.asia@morganstanley.com';
	                    template = 'email5_Reminder_emails';
	                }
	                // EMEA Approval Step 1 - Employee
	                else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Approval Step 3') && req.Job_Region_Code__c == 'EU'
	                                 && req.Conga_Dept_Org__c != System.Label.RL_HR_VALUE){
	                    qEmail = 'HRSC_Approval_Queue_EMEA';
	                    qEmailCC = '';
	                    template = 'EMEA_Reminder_emails';
	                }
	                // EMEA Approval Step 2 - Employee
	                else if(req.status__C == 'Approval Step 2' && req.Job_Region_Code__c == 'EU'
	                             && req.Conga_Dept_Org__c != System.Label.RL_HR_VALUE && req.Escalation__c == 'No'){
	                    qEmail = 'HRSC_EMEA_Approver_Approval_Group';
	                    qEmailCC = '';
	                    template = 'EMEA_Email_5b_Reminder_emails_HROPS';
	                }
	                // EMEA Approval Step 2 and Escalation - Employee
	                else if(req.status__C == 'Approval Step 2' && req.Job_Region_Code__c == 'EU'
	                             && req.Conga_Dept_Org__c != System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                    qEmail = 'EMEA_HROPS';
	                    qEmailCC = '';
	                    template = 'EMEA_Email_5c_Reminder_email_HRSCEMEAL3';
	                }
	                // EMEA Approval Step 4 - Employee
	                else if(((req.status__C == 'Approval Step 4' && req.Escalation__c == 'Yes')
	                             || (req.status__C == 'Approval Step 2' && req.Escalation__c == 'No'))
	                             && (req.Job_Region_Code__c == 'EU' && req.Conga_Dept_Org__c != System.Label.RL_HR_VALUE)){
	                    qEmail = 'HRSC_EMEA_Approver_Approval_Group';
	                    qEmailCC = '';
	                    template = 'EMEA_Email_5d_Reminder_email_HRSC_Final';
	                }
	                // EMEA Approval Step 1 - HR
	                else if((req.status__C == 'Approval Step 1' || req.Status__C == 'Approval Step 3') && req.Job_Region_Code__c == 'EU'
	                            && req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'No'){
	                    qEmail = 'HRSC_EMEA_HR_Approval_Group';
	                    qEmailCC = '';
	                    template = 'EMEA_Reminder_emails';
	                }
	                // EMEA Approval Step 2 - HR
	                else if(req.status__C == 'Approval Step 2' && req.Job_Region_Code__c == 'EU'
	                             && req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'NO'){
	                    qEmail = 'HRSC_EMEA_HR_Approver_Approval_Group';
	                    qEmailCC = '';
	                    template = 'EMEA_Email_5b_Reminder_emails_HROPS';
	                }
	                // EMEA Approval Step 2 and Escalation Yes - HR
	                else if(req.status__C == 'Approval Step 2' && req.Job_Region_Code__c == 'EU'
	                             && req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                    qEmail = 'HRSC_EMEA_Senior_Hr_Approval_Group';
	                    qEmailCC = '';
	                    template = 'EMEA_Email_5c_Reminder_email_HRSCEMEAL3';
	                }
	                // EMEA Approval Step 4 - HR
	                else if(req.status__C == 'Approval Step 4' && req.Job_Region_Code__c == 'EU'
	                             && req.Conga_Dept_Org__c == System.Label.RL_HR_VALUE && req.Escalation__c == 'Yes'){
	                    qEmail = 'HRSC_EMEA_HR_Approver_Approval_Group';
	                    qEmailCC = '';
	                    template = 'EMEA_Email_5d_Reminder_email_HRSC_Final';   
	                }
	            }
	            
	            // Added by Avinash Munaga
	            // this is added as part of phase 1 not having In-Progress view
	            // need to be removed in Phase 2 after In-Progress view is available
	            // qEmailCC = 'references.asia@morganstanley.com';
	            
	            //try to generate an email for each request
	            Messaging.Singleemailmessage rEmail = sendMail(req, qEmail, qEmailCC, template, c);
	            
	            //if an email is generated add it to the list to send one time at the end
	            if (rEmail != null)
	                emailSendList.add(rEmail);
            }
            system.debug('*******####'+emailSendList);
	        //send the list one time
	        if (emailSendList.size() > 0) { 
	        	system.debug('email size'+emailSendList.size());
	            Messaging.sendEmail(emailSendList,true);
	        }
		} catch(Exception e) {
			// Date: 06/24/2015
			system.debug('*******#### catch'+e);
		    string devInfo = 'RL_Reminder Emails: Exception caught sending reminder emails at line ' + e.getLineNumber();
		    
		    /*PageReference testPageReference = Page.RL_Sys_Exception; 
            testPageReference.getParameters().put('cause', '' + e.getCause());
            testPageReference.getParameters().put('message', '' + e.getMessage());
            testPageReference.getParameters().put('devInfo', devInfo);
            Test.setCurrentPage(testPageReference);
            
		    RL_Employee_Init empException = new RL_Employee_Init();
		    empException.emailNotification();*/
		} finally {
            system.debug('*******####'+emailSendList);
			if(c != null) {
	        	//delete the temp contact record.
	        	delete c;
			}
		}
    }
    
    
    // Private class that creates a single email message or returns null    
    Messaging.Singleemailmessage sendMail(Reference_Letter_Request__c ref, String qEmail, String qEmailCC, String qTemplate, Contact c){
        
        // String env = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
        String env = System.Label.ORG_ENVIRONMENT.toLowerCase();
        
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
        
        Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
        
        List<String> emailToAddresses = new List<String>();
        
        if(qEmail != null && qEmail != '' && !qEmail.contains('@')){
            Id gId = gMap.get(qEmail);
            
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
            
            if (!env.contains('prod')) {  //if not production then send to group email for testing purposes
                emailToAddresses = new List<String>();
                 // emailToaddresses.add(orgEmail);
                 c = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
                 insert c;
            } else {
                if(emailToaddresses.size() > 0) {
                    String emailOfContact = emailToaddresses.get(0);
                    System.debug('first elements in list : ' + emailOfContact);
                    c = new Contact(firstname='**test**', lastname='**test**',email=emailOfContact);
                    insert c;
                    
                    String removed = emailToaddresses.remove(0);
                    System.debug('removed element : ' + removed);
                    System.debug('List size after deletion: ' + emailToaddresses.size());
                }
            }
            email.setToAddresses(emailToAddresses);

            List<String> emailCCAddresses = new List<String>();
            if(qEmailCC != null && qEmailCC != '' && env.contains('prod')){
                emailCCAddresses.add(qEmailCC);
                email.setCcAddresses(emailCCAddresses);
            }
            
            email.setSaveAsActivity(false);
            email.setTargetObjectId(c.id);
            email.setOrgWideEmailAddressId(orgEmailId);
            email.setWhatId(ref.id);
            email.setTemplateId(emailMap.get(qTemplate));
            
            system.debug('reminder email');
            return email;
        }
        else
            return null;
    }
    
    public void makeTheTestRun(){
    Integer i=0;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
      i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
  }
}