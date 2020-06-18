global class FFAP_DocusignUserCreation implements Database.Batchable<SObject>, System.Schedulable,Database.AllowsCallouts, Database.Stateful{
    //will be used to connect to Docusign API
    private DocusignAuthenticationHelper docusign;
    private Integer recordCount = 100;
    private String ERROR_QUERY = 'SELECT Id FROM Employee__c WHERE Id = null';
    private String QUERY = 'SELECT Id, Name, Email__c, First_Name__c, Last_Name__c ' + 
                        ' FROM Employee__c WHERE DocuSign_GUID__c = null' + 
                         ' AND Email__c != null AND First_Name__c != null AND Last_Name__c != null' + 
                         ' AND Status__c = \'Active\' limit 10';
    private String QUERY_EXECUTE;
    public List<EmployeeWrapper> empWrapList;
    private String emailAddr;
    
    public FFAP_DocusignUserCreation(){
    	empWrapList = new List<EmployeeWrapper>();
    }
    global Database.QueryLocator start(Database.BatchableContext c) {
 
    	//don't fetch employee records if switch is turned off for this batch process
        if(Trigger_Switch__c.getInstance().Is_FFAP_DocusignUserCreation_Off__c == true){
        	QUERY_EXECUTE = ERROR_QUERY; 
        }else{
	    	Docusign_Template_Setting__c template = Docusign_Template_Setting__c.getValues('Default');        
	        if(template == null ){
	            System.debug('Template Setting is not configured. Please ask your System Administrator to configure.');
	            QUERY_EXECUTE = ERROR_QUERY; 
	        }else{            
		        if(populateSystemData() != FFAP_DataUtil.SUCCESS){
		            QUERY_EXECUTE = ERROR_QUERY; 
		        }else{		        	
		        	QUERY_EXECUTE = QUERY;
		        	if(template.Docusign_Adminsitrator_Email__c != null){
		        		emailAddr = template.Docusign_Adminsitrator_Email__c;
		        	}
		        	if(template.Docusign_User_record_limit__c != null){
		        		try{
		        	      recordCount = Integer.valueOf(template.Docusign_User_record_limit__c);
		        		}catch(Exception ex){}
		        	}
		        }
	        }   
        }     
        return Database.getQueryLocator(QUERY_EXECUTE);       
    }    
    
    global void execute(Database.BatchableContext c, List<Employee__c> empList) {    	
    	List<Employee__c> empForProcessing = new List<Employee__c>();
        if(!empList.IsEmpty()){
        	if(empList.size() > recordCount){
        		for(Employee__c emp : empList){
        			empForProcessing.add(emp);
        			if(empForProcessing.size() == recordCount){
        				if(createDocusignAccountifUnderGovernorLimit(empForProcessing) == false){
        					break;
        				}else{
        					empForProcessing = new List<Employee__c>();
        				}
        			}
        		}
        	}else{
        	    createDocusignAccountifUnderGovernorLimit(empList);
        	}
        }
    }
    
    private boolean createDocusignAccountifUnderGovernorLimit(List<Employee__c> empList){
    	if(Limits.getCallouts() < Limits.getLimitCallouts() && Limits.getDMLRows() < Limits.getLimitDMLRows()){
            String resultString = sendNow(empList);
            return true;
        }else{
        	return false;
    	}
    }
    
    private String populateSystemData(){
        docusign = new DocusignAuthenticationHelper();
        if(docusign.isConfigured == false){
            return docusign.error;
        }
        
        return FFAP_DataUtil.SUCCESS;
    }
    
    private String SendNow(List<Employee__c> empList){
        String resultString = FFAP_DataUtil.SUCCESS;
        DocusignAccountmanagementAPI.AccountManagementServiceSoap dsApiSend = new DocusignAccountmanagementAPI.AccountManagementServiceSoap();
        dsApiSend.endpoint_x = docusign.webAccMgmtServiceUrl;

        //Set Authentication
        String auth = docusign.authString;
        System.debug('Setting authentication to: ' + auth);
            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        DocusignAccountmanagementAPI.ArrayOfMember Members = new DocusignAccountmanagementAPI.ArrayOfMember();
        Members.Member = new DocusignAccountmanagementAPI.Member[empList.size()];
        DocusignAccountmanagementAPI.Member mem;
        for(Employee__c emp : empList){
        	mem = new DocusignAccountmanagementAPI.Member();
        	mem.MemberEmailAddress = emp.Email__c;
        	mem.MemberUserName = emp.First_Name__c + ' ' + emp.Last_Name__c;        	
        	mem.MemberPassword = generatePassword();        	
        	Members.Member.add(mem);
        }
        
        try {
        	DocusignAccountmanagementAPI.AddMembersToAccountResult_element es;
            if(!Test.isRunningTest()){	            	
                es = dsApiSend.AddMembersToAccount(docusign.accountId, Members);	            	
                System.debug('Result - >' + es);                
            }else{
            	//This has been done to provide coverage to test class by sending dummy response
            	es = new DocusignAccountmanagementAPI.AddMembersToAccountResult_element();
            	es.Members = new DocusignAccountmanagementAPI.ArrayOfMemberResult();
            	es.Success = true;
            	System.debug('Check -> ' + empList.size());
            	es.Members.Member = new DocusignAccountmanagementAPI.MemberResult[empList.size()];
            	DocusignAccountmanagementAPI.MemberResult memResult;
            	for(Employee__c emp : empList){
            		memResult = new DocusignAccountmanagementAPI.MemberResult();
            		memResult.Success = true;
            		memResult.UserId = emp.Emp_Id__c;
            		memResult.MembershipId = emp.Emp_Id__c;
            		es.Members.Member.add(memResult);
            	}
            	System.debug('Result - >' + es);  
            }
            processResult(es, empList);
        } catch (CalloutException e) {            
            System.debug('Exception - ' + e );
            return 'Docusign Sign API Call failed - ' + e.getMessage() + '\n Please contact to System Administrator.';                    
        }        
        return resultString;
    }
    //will generate password according to password policy
    private String generatePassword(){
    	Blob blobKey = crypto.generateAesKey(256);
        String password = EncodingUtil.convertToHex(blobKey);
        if(password != null){
            System.debug('Password-> ' + password);
            password = password.left(14);
            String lastNumber = password.subString(13, 14); 
            if(!password.isNumeric()){
            	lastNumber =  '9';
            }
            String firstLetter = password.subString(0, 1);
            String secondLetter = password.subString(1, 2);            
            if(secondLetter.isAlpha()){
                secondLetter = secondLetter.toLowerCase();
            }else{
                secondLetter = 'm';
            }            
            if(firstLetter.isAlpha()){
            	firstLetter = firstLetter.toUpperCase();
            }else{
            	firstLetter = 'W';
            }     
            password = firstLetter + secondLetter + password.substring(2, 13) + lastNumber + '@';       
            System.debug('Password-> ' + password);
        }
    	return password;
    }
      
    private void processResult(DocusignAccountmanagementAPI.AddMembersToAccountResult_element es, List<Employee__c> empList){
    	List<Employee__c> empforUpdate = new List<Employee__c>();
    	
    	if(es != null && es.Success == true){
            DocusignAccountmanagementAPI.MemberResult mem;
            Employee__c emp;
            for(Integer indx = empList.size() - 1; indx > -1; indx--){
                mem = es.Members.Member[indx];
                emp = empList.get(indx);
                if(mem != null && mem.Success == true){
                	emp.DocuSign_GUID__c = mem.UserId;
                	empforUpdate.add(emp);
                }else if(mem != null && mem.Error != null){
                	//System.debug('jitendra -> ' + mem.Error.ErrorCode);//Member_Email_And_User_Name_Already_Exists
                	//System.debug('jitendra -> ' + mem.Error.Description);//Member Email And User Name Already Exists. Invalid login.
                	empWrapList.add(new EmployeeWrapper(emp, mem.Error.ErrorCode, mem.Error.Description));
                }                
            }
        }else{
            
        }
        if(!empforUpdate.isEmpty()){
            update empforUpdate;
        }
    }
    global void finish(Database.BatchableContext c) {
    	if(Trigger_Switch__c.getInstance().Is_FFAP_DocusignUserCreation_Off__c == false){
	    	if(!empWrapList.isEmpty() && emailAddr != null){
	    		String body = '';
	    		String EMAIL_TEMPLATE = '<tr><td>[EMPNAME]</td><td>[ERRORDESC]</td></tr>' ;//<td>[ERRORCODE]</td>
	    		Integer counter = 1;
	    		body = 'Docusign Record failed to create for below Employees:<br/><br/>';
	    		body += '<table><tr><td>Employee Name</td><td>Error Description</td></tr>';//<td>Error code</td>
	    		for(EmployeeWrapper emp : empWrapList){
	    			body += EMAIL_TEMPLATE.replace('[EMPNAME]', emp.emp.First_Name__c + ' ' + emp.emp.Last_Name__c)
	    			         .replace('[ERRORDESC]', emp.errorDescription);
	                counter++;
	    		}
	    		body += '</table>';
	    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
	            mail.setToAddresses(new String[]{emailAddr});
	            mail.setSubject('Docusign Account not created.');
	            //System.debug(body);
	            mail.setHtmlBody(body);
	            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
	    	}
    	}
    }
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            Id batchId = Database.executeBatch(new FFAP_DocusignUserCreation(), recordCount * Limits.getLimitCallouts());
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
    
    
    public class EmployeeWrapper{
    	public Employee__c emp{get;set;}
    	public String errorCode{get;set;}
    	public String errorDescription{get;set;}
    	public EmployeeWrapper(Employee__c emp, String errorCode, String errorDescription){
    		this.emp = emp;
    		this.errorCode = errorCode;
    		this.errorDescription = errorDescription;
    	}
    }
}