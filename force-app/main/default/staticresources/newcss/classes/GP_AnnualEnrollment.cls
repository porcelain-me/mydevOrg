/**************************************************************************************
* GLOBAL PARKING ANNUAL ENROLLMENT
* This batch process applies new payment methods selected in the open annual enrollment period
*
* Change Log:
*
*	MRM 8/12/16 - Created class
*
****************************************************************************************/
global class GP_AnnualEnrollment implements Database.Batchable<SObject>, System.Schedulable{
	
	String regionID; 
	String batchID;

	String queryStr = 'select id ,Assigned_Method_of_Payment__c ,Enrollment_Period_Payment_Method__c ' + 
					' ,requestee__r.user__r.email ' +
					' ,requestee__r.user__c ' +
    				' from Parking_Lot_Request__c ' +
    				' where  ' + 
    				' enrollment_period_payment_method__c <> null ' +
    				' and type__c = ' + '\'' + 'Parking Space' +  '\'' +
    				' and Status__c = ' + '\'' + 'Assigned' + '\'';
	
	global GP_AnnualEnrollment(String regionID, String batchID) { 
        this.regionID = regionID; 
        this.batchID = batchID;
        
        Parking_Enrollment_Batch__c batch = [select id, status__c from Parking_Enrollment_Batch__c where id = :batchID];
    	batch.status__c = 'Running';
    	update batch;
    	
    }
	
	global Database.QueryLocator start(Database.BatchableContext c) { 
		
    	queryStr += ' and Parking_Lot_region__c = ' + '\'' + regionID + '\'';
    	return Database.getQueryLocator(queryStr); 
   
    }
    
    
    /**************************************************************************************************
    *
    *
    * EXECUTE
    *
    *
    ****************************************************************************************************/
    
    global void execute(Database.BatchableContext c, List<Parking_Lot_Request__c> rList){
    	
    	OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Global Parking'];
      	EmailTemplate template = [SELECT id FROM EmailTemplate WHERE developerName = 'GP_Email_2_Space_Assigned'];
        
        Contact con = new Contact(firstname='**test**', lastname='**test**',email=owe.address);
		insert con; 
		
      
    	system.debug('in execute');
    	
    	Map<String,Parking_Lot_Space_Assignment__c> aMap = new Map<String,Parking_Lot_Space_Assignment__c>();
    	Set <String> rSet = new Set<String>();
    	Set <String> userIdSet = new Set<String>();
    	
    	Set <String> employeeIdSet = new Set<String>();
    	Map <String,String> requestToEmailMap = new Map<String,String>();
    	Map <String,User> userMap = new map<String,User> ();
    	
    	
    	for (Parking_Lot_Request__c r:rList){
    		rSet.add(r.id);
    		userIdSet.add(r.requestee__r.user__c);
    		requestToEmailMap.put(r.id,r.requestee__r.user__r.email);
    		employeeIdset.add(r.requestee__c);
    	}
    	
    	/* get all the delegates for all the employees in all of the requests */
    	
    	List<Employee_Delegate__c> empDelegates = [Select 
                                  Delegate__c
                                 ,employee__c
                                 ,delegate__r.user__r.email
                                 ,delegate__r.user__c
                                 From Employee_Delegate__c 
                                 where application__c = 'Global Parking'
                                 and status__c = 'Approved'
                                 and employee__c in :employeeIdSet
                                 ];
         
       
        	                        
    	/*create a map for employee along with the delegate email addresses */
    	Map <String,List<String>> employeeDelegateListMap = new Map<String,List<String>>();
    	for (Employee_Delegate__c d:empDelegates){
    		List<String> tempList = new List<String>();
    		
    		if (employeeDelegateListMap.get(d.employee__c) == null){
    			tempList.add(d.delegate__r.user__r.email);
    		}
    		else{
    			tempList = employeeDelegateListMap.get(d.employee__c);
    		}
   			employeeDelegateListMap.put(d.employee__c,templist);
   			userIdSet.add(d.delegate__r.user__c);
    	}
    	
    	List<User> userList = [Select id, email from User where id in :userIdSet];
        for (User u:userList)
        	userMap.put(u.id,u);
        	
    	system.debug('Employee delegate email list:' + employeeDelegateListMap);
    	
    	
    	
    	List<Parking_Lot_Space_Assignment__c> aList = new List<Parking_Lot_Space_Assignment__c>();
    	aList= [select id, parking_Lot_Request__c from Parking_Lot_Space_Assignment__c where parking_Lot_Request__c in :rSet];
    	for (Parking_Lot_Space_Assignment__c a:aList){
    		aMap.put(a.parking_lot_request__c,a);
    	}
    	
    	
    	List<Parking_Lot_Space_Assignment__c> uSpaceAssList = new List<Parking_Lot_Space_Assignment__c>();
    	
    	List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
    	
    	
    	for (Parking_Lot_Request__c r:rList){
    		r.Assigned_Method_of_Payment__c	= r.Enrollment_Period_Payment_Method__c;
    		r.Enrollment_Period_Payment_Method__c = null;
    		if (aMap.get(r.id) != null){
    			Parking_Lot_Space_Assignment__c a = aMap.get(r.id);
    			a.Method_of_Payment__c = r.assigned_method_of_payment__c;
    			uSpaceAssList.add(a);
    		}
    		mailList.add(createEmail(requestToEmailMap.get(r.id),employeeDelegateListMap.get(r.requestee__c),owe, r, userMap.get(r.requestee__r.user__c),template.id, con));
    	}
    	
    	Parking_Enrollment_Batch__c batch = [select id, total_processed__c, status__c from Parking_Enrollment_Batch__c where id = :batchID];
    
    	

		try{
			
			if (System.Label.GP_Emails_Enabled == 'true'){
				Messaging.sendEmail(mailList);
				delete con;
			}
			
    		if (!rlist.isEmpty())   	
    			update rList;
    		
    		batch.total_processed__c = batch.total_processed__c + rList.size();
    		
    		if (!uSpaceAssList.isEmpty())
		   		update uSpaceAssList;
		   	
		 	batch.status__c = 'Running';
    	   	update batch;
		}
		catch (Exception e){
			 
			batch.status__c = 'Failed';
    		batch.message__c= 'Raise CSIT request for assistance. Provide the following error message on ticket: Exception location 1 ' + string.valueOf(e);
    		update batch; 
		}
    }
    
    /*****************************************************************/
    /* email sending class                                           */
    /*****************************************************************/
    global Messaging.singleEmailMessage createEmail(String to, List<String> ccList, OrgWideEmailAddress owe, Parking_Lot_Request__c r, User u, ID templateId, Contact c) {
    	
    	List<String> toLIst = new List<String>();
    	toList.add(to);
    	
    	Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();

        //Fix for GLBPARKING-393: Using custom setting to manage environmental logic, as opposed to hard-coded environment check
        GP_Master_Settings__c settings = GP_Master_Settings__c.getValues('Settings');

        if(settings.Stub_Annual_Enrollment_Batch_Emails__c){
       		email.setTargetObjectId(c.id);
       		List <String> tempList = new List<String>();
       		tempList.add(owe.address);
       		email.setToAddresses(tempList);
        } 
       	else{
        	email.setTargetObjectId(u.id);
        	email.setToAddresses(toList); 
        	if (ccList != null)
         		if (!ccList.isEmpty())
            		email.setCCAddresses(ccList);
       	}  
               
       
        email.setOrgWideEmailAddressId(owe.id);
        email.setWhatId(r.id); 
        email.setTemplateId(templateId);
        email.setSaveAsActivity(false);
         	
      	return email;
    }
    
    /**************************************************************************************************
    *
    *
    * FINISH
    *
    *
    ****************************************************************************************************/
    
    global void finish(Database.BatchableContext c){
    	
    	Parking_Enrollment_Batch__c batch = [select id, total_processed__c, status__c from Parking_Enrollment_Batch__c where id = :batchID];
    	if (batch.Status__c == 'Running'){
    		batch.Status__c = 'Complete';
    		update batch;
    	}
    	
    
    	
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new GP_AnnualEnrollment(null,null), 1000);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    }
}