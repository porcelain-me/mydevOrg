/***************************************************************************************************************
*
* SYS AUDIT BATCH - this batch process will generate two audit reports and email them to the sharepoint force
*					COE site
*
* Change Log:
*
*  2/3/2015 - MRM Created 
*
*
***************************************************************************************************************/
global class SYS_Audit_Batch implements Database.Batchable<SObject>{
	
	/* dummy sql to force only one batch chunk handler */
	
	String queryStr = 'Select p.PermissionSet.Name,  Assignee.Username From PermissionSetAssignment p limit 1'; 
	
	

	global Database.QueryLocator start(Database.BatchableContext c) {
		
    	
    	return Database.getQueryLocator(queryStr);  
    }
    
    global void execute(Database.BatchableContext c, List<PermissionSetAssignment> aList){
    	
    	/**********************************************************************************************************/
    	/* Permission Set Audit Logic */
    	/**********************************************************************************************************/
    	
    	String clause = 'X0%';
    	String queryStr2 = 'Select p.PermissionSet.Name,  Assignee.firstName, Assignee.lastName, Assignee.Username, SystemModstamp From PermissionSetAssignment p where not(permissionSet.name like ' + '\'' + clause + '\'' + ')';
    	queryStr2 += '  order by permissionSet.name, assignee.username'; 
	
	
    	aList = Database.query(queryStr2);
    	String fileContents = '';
    	
    	 
    	fileContents += 'PermissionSet Name' + ',' + 'Assignee First Name'  + ',' + 'Assignee Last Name' + ','  + 'Assignee User Name' +  ',' + 'Mod Datetime' + '\n';
    	for(PermissionSetAssignment a:aList){
    		
    		fileContents += a.permissionSet.name + ',' + a.assignee.firstname + ','  + a.assignee.lastname + ','  + a.assignee.username  + ',' + a.systemmodstamp +  '\n';
    	}
    	
    	sendMail(fileContents,'PermissionSetAudit');
    	
    	/**********************************************************************************************************/
    	/* Public Group Audit Logic */
    	/**********************************************************************************************************/
    	
    	List<GroupMember> gList = new List<GroupMember>();
		
		gList = [Select g.Group.Name
			, g.UserOrGroupId
			, g.SystemModstamp
			, g.Group.Type 
			From GroupMember g
			where g.group.name <> null
			order by group.name];

		
		
		set<ID> groupSet = 	new Set<ID>();
		set<ID> userSet = 	new Set<ID>();
		
		for (GroupMember g:gList){
			String id = g.userorgroupid;
			if (id.startswith('005'))
				userSet.add(g.userorgroupid);
			else
				groupSet.add(g.userorgroupid);
		}
		
		Map<ID,User> userMap = new Map<ID,User>([select firstname, lastname, name, username from User where id in: userSet]);
		Map<ID,Group> groupMap = new Map<ID,Group>([select name from Group where id in:groupSet]);
		
    	fileContents = '';
    	 
    	fileContents += 'Group Name' + ',' + 'Type'  + ',' + 'Member Name' + ',' + 'User Name' +  ',' + 'Mod Datetime' + '\n';
    	for(GroupMember g:gList){
    		
    		String uType;
    		String id = g.userorgroupid;
    		String memberName;
    		String userName; 
    		
    		if (id.startsWith('00G')){
    			uType = 'Group';
    			memberName = groupMap.get(id).name;
    			userName = '';
    		}
    		else{
    			uType = 'User';
    			memberName = userMap.get(id).name;
    			userName = userMap.get(id).username;
    		}
    			
    		fileContents += g.group.name + ',' + uType + ','  + memberName + ',' + userName  + ','  + g.SystemModstamp +  '\n';
    	}
    	
    	sendMail(fileContents,'PublicGroupAudit');
    	
    	
    	
    }
    
    /********************************************************************************************************
    *
    * This class sends an email to the hrfrce-audit-log group which in turn sends it to the audit sharepoint
    * site.
    *
    ********************************************************************************************************/ 
    global void sendMail(String fileContents, String fileName){
    	
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(System.now() + '-' + fileName + '.csv');
      	Blob myBlob = Blob.valueOf(fileContents);
		efa.setBody(myblob);
		
		Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
		 
		List<String> emailToAddresses = new List<String>();
		emailToAddresses.add(System.Label.SYS_Audit_Log_Site); 
		// Sets the paramaters of the email
        email.setSubject( filename );
        email.setToAddresses( emailToAddresses );
        email.setPlainTextBody( 'Audit Email' );
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        for(OrgWideEmailAddress owe : DG_DataUtil.getOrgWideEmaillAddresses('hrfrce-security')) {
		    email.setOrgWideEmailAddressId(owe.id);
		}
        
		
        // Sends the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
    	
    }
    
    global void finish(Database.BatchableContext c){
    	
    }
    

}