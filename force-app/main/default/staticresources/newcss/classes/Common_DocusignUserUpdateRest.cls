//
// (c) 2014 Appirio, Inc. 
//
// Description : Docusign userid passed to employee guid field for Employee Acknowledge app through docusign rest api.
//
// 09 Mar 2014 Jitendra Kothari Original
//
global class Common_DocusignUserUpdateRest implements Database.Batchable<SObject>, System.Schedulable,Database.AllowsCallouts, Database.Stateful{
    //will be used to connect to Docusign API
    private DocusignAuthenticationHelper docusign;
    private String ERROR_QUERY = 'SELECT Id FROM Employee__c WHERE Id = null';
    private String QUERY = 'SELECT Id, Name ' + 
                        ' FROM Employee__c WHERE DocuSign_GUID__c = null' + 
                         ' AND Email__c != null AND First_Name__c != null AND Last_Name__c != null' + 
                         ' AND Status__c = \'Active\' AND Name in :empNamesRecords';
    private String QUERY_EXECUTE;    
    private map<String, String> empNames;
    private set<String> empNamesRecords;
    public List<UserWrapper> userList;
    global Database.QueryLocator start(Database.BatchableContext c) {         
        //don't fetch employee records if switch is turned off for this batch process
        if(Trigger_Switch__c.getInstance().Is_FFAP_DocusignUserCreation_Off__c == true){
            QUERY_EXECUTE = ERROR_QUERY; 
        }else{                              
            if(populateSystemData() != FFAP_DataUtil.SUCCESS){
                QUERY_EXECUTE = ERROR_QUERY; 
            }else{
            	fetchUsers();
            	QUERY_EXECUTE = QUERY;
                empNames = new map<String, String>();
	            for(UserWrapper uw : userList){
	                empNames.put(uw.userName, uw.userId);
	            }
	            empNamesRecords = empNames.keySet();	                                          
            }
        }     
        return Database.getQueryLocator(QUERY_EXECUTE);       
    }    
    
    global void execute(Database.BatchableContext c, List<Employee__c> empList) {       
        for(Employee__c emp : empList){
            emp.DocuSign_GUID__c = empNames.get(emp.Name);
        } 
        update empList;
    }
    private String populateSystemData(){
        docusign = new DocusignAuthenticationHelper();
        if(docusign.isConfigured == false){
            return docusign.error;
        }
        
        return FFAP_DataUtil.SUCCESS;
    }
    
    private String fetchUsers(){
        String resultString = FFAP_DataUtil.SUCCESS;
        HttpRequest req = new HttpRequest();
		req.setEndpoint(System.Label.Docusign_URL + '/restapi/v2/accounts/' + docusign.accountId + '/users');
		req.setMethod('GET');		
		req.setHeader('X-DocuSign-Authentication', docusign.authString);
		Http http = new Http();
        try {
            if(!Test.isRunningTest()){                  
                HTTPResponse res = http.send(req);
                System.debug(res.getBody());
                UserListWrapper usersList = (UserListWrapper)JSON.deserialize(res.getBody(), UserListWrapper.class);
                userList = usersList.users;
            }else{
                 userList = new List<UserWrapper>();
                 userList.add(new UserWrapper());
            }            
        } catch (CalloutException e) {            
            System.debug('Exception - ' + e );
            return 'Docusign Sign API Call failed - ' + e.getMessage() + '\n Please contact to System Administrator.';                    
        } 
        return resultString;
    }    
      
    global void finish(Database.BatchableContext c) {            
    }
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            Id batchId = Database.executeBatch(new Common_DocusignUserUpdateRest(), Limits.getLimitDmlRows());
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
    public class UserListWrapper{
    	public List<UserWrapper> users;
    }
    public class UserWrapper{
    	public String userName{get;set;}
    	public String userId{get;set;}
    	public String userType{get;set;}
    	public String userStatus{get;set;}
    	public String uri{get;set;}
    }
}