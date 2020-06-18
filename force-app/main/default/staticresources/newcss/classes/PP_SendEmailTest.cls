@isTest (SeeAllData = false)  
public class PP_SendEmailTest {
     
    static testmethod void PPSendEmailTest() {
    
 	
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
           { 
            Employee__c empSource = new Employee__c (name = 'Test User', Status__c='Active',emp_id__c = '15ABC', email__c='SystemAdministrator@testorg.com');
            insert empSource;   
            system.debug('----------------- EmpSource ---------------'+empSource);
           
           Building_Locations__c BL=PP_TestData.insertBuilding();
           system.debug('----------------- Building Location ---------------'+empSource);                       
              
           //PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           PR_Request__c newPRRequest = new PR_Request__c();
             newPRRequest.Employee_Requestor_Name__c = empSource.id;
             newPRRequest.Request_Type__c='MS Office (Most common)';
             newPRRequest.Manager__c = empSource.Manager__r.id;
             newPRRequest.Property_Owner__c='Self';
			 newPRRequest.Removal_Type__c='Permanent';
             newPRRequest.Removal_Date__c=Date.today();
             newPRRequest.Location111__c=BL.id;
             newPRRequest.Removal_Purpose__c='Business Purpose';
             newPRRequest.submitted_date__c = Date.today().adddays(-2);
           newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           newPRRequest.Status__c='Submitted'; 
           newPRRequest.CC_WatchList__c='first.first@morganstanley.com';    
           newPRRequest.Approvers_List__c='last.last@morganstanley.com;middle.middle@morganstanley.com;';
           insert newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
           
           PR_Request__c newPRRequest1 = [select id,name,CC_WatchList__c,Approvers_List__c from PR_Request__c where id =: newPRRequest.id];    
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
		   d.FolderId = UserInfo.getUserId();
           d.Name='TestDoc';  
           insert d;
           
           /*
           Test.startTest();
          
           List<String> emailToAddresses = new List<String>();
           emailToAddresses.add('test.a@morganstanley.com');
           List<String> emailCCAddresses = new List<String>();
           emailCCAddresses.add('test.b@morganstanley.com');
          
           String urlString  = string.valueOf(URL.getSalesforceBaseUrl().toExternalForm());
               
           String orgEmail = null;
           String orgEmailId = null;
           OrgWideEmailAddress Owe = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Property Pass' limit 1];        
           orgEmail = owe.Address;
           orgEmailId = owe.id;
           
           Contact co = new Contact(firstname='**test**', lastname='**test**',email=orgEmail);
           insert co;
        
        
         Map<String,String> emailTemplateMap = new Map<String,String>();          
         EmailTemplate  eList =  [Select Id, DeveloperName From EmailTemplate where folder.Name='Property Pass Folder' LIMIT 1];
         String V=eList.id;
         emailTemplateMap.put(eList.developername,v.substring(0,15));
         
         PP_SendEmail.CreateEmail(emailToAddresses, 'hrfrce-property-pass-dev@morganstanley.com', urlString, emailCCAddresses,co,orgEmailId,newPRRequest,'PP_Email_1_PENDING_APPROVAL_PP_Request', emailTemplateMap);
       	 Test.stopTest();*/
    
	}
} 
}