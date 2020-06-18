@isTest (SeeAllData = false) 
public class PP_ReplyViaApprovalTest {
    
public static PR_Request__c createdata()
{
            User tempUser = PP_TestData.getSystemAdminTempUser();
           system.debug('-----------------User ---------------'+tempUser);
             
           Employee__c empSource1 = PP_TestData.insertManagerEmployee();
           system.debug('-----------------Manager Employee ---------------'+empSource1);
             
           Employee__c empSource = PP_TestData.insertEmployee(empSource1, tempUser);
           system.debug('----------------- Employee ---------------'+empSource);  
             
           Building_Locations__c BL=PP_TestData.insertBuilding();
           system.debug('----------------- Building Location ---------------'+BL);        
    
            PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);                 
           newPRRequest.Status__c='Saved';            
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
    
    
               Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
             system.debug('---------------- Prop Detail ---------------'+PropDetail); 
    
    PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           ApexPages.currentPage().getParameters().put('id',newPRRequest.id);
    
           // newPRRequest.Status__c='Submitted';
        //update newPRRequest;
    
           system.debug('------------PRRequest-----------------'+newPRRequest);             
              if([select count() from ProcessInstance where targetobjectid=:newPRRequest.id] < 1)
            {       
           Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Approve.');
                req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req.setObjectId(newPRRequest.Id);
    
                //Submit the approval request
                Approval.ProcessResult result = Approval.process(req);
            
            }
     newPRRequest.Status__c='Submitted';
            update newPRRequest;
        
     return newPRRequest;
             }    
			 
public static testmethod void PPReplyViaApprovalTestApproved(){
	User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
             Test.startTest();  
             PR_Request__c newPRRequest = createdata();
            
          
             PR_Request__c PR = [select id,name from PR_Request__C where id = :newPRRequest.id];
             Messaging.InboundEmail email = new Messaging.InboundEmail();
		     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			 Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
 		     email.subject = 'Property Pass Request - '+PR.Name;
             email.plainTextBody = 'Approved\n'; 
		email.fromAddress = 'systemadministrator@testorg.com';            
			 env.fromAddress = 'user@acme.com';
			 inAtt.body = blob.valueOf('Approved\n');
			 inAtt.fileName = 'my attachment name';
			 inAtt.mimeTypeSubType = 'plain/txt';
			 email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
			  PP_ReplyViaApproval RA = new PP_ReplyViaApproval();
              RA.handleInboundEmail(email, env);
             Test.stoptest();   
             
         }
     Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
}
public static testmethod void PPReplyViaApprovalTestRejected(){
	User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
             Test.startTest();  
            
         PR_Request__c newPRRequest = createdata();
        
           
          PR_Request__c PR = [select id,name from PR_Request__C where id = :newPRRequest.id];
          
          system.debug('------------PRRequest-----------------'+PR);    
             Messaging.InboundEmail email = new Messaging.InboundEmail();
		     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			 Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
 		     email.subject = 'Property Pass Request - '+PR.Name;
             email.plainTextBody = 'Rejected\n';
		email.fromAddress = 'systemadministrator@testorg.com';
			 env.fromAddress = 'user@acme.com';
			 inAtt.body = blob.valueOf('Rejected\n');
			 inAtt.fileName = 'my attachment name';
			 inAtt.mimeTypeSubType = 'plain/txt';
			 email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
			  PP_ReplyViaApproval RA = new PP_ReplyViaApproval();
              RA.handleInboundEmail(email, env);
         Test.stoptest();   
                              
             
             
         }
     Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
}
public static testmethod void PPReplyViaApprovalTestRecalled(){
	User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
             Test.startTest();  
           PR_Request__c newPRRequest = createdata();
       
          PR_Request__c PR = [select id,name from PR_Request__C where id = :newPRRequest.id];
          
          system.debug('------------PRRequest-----------------'+PR);    
             Messaging.InboundEmail email = new Messaging.InboundEmail();
		     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			 Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
 		     email.subject = 'Property Pass Request - '+PR.Name;
             email.plainTextBody = '<recalled>';
		email.fromAddress = 'systemadministrator@testorg.com';
			 env.fromAddress = 'user@acme.com';
			 inAtt.body = blob.valueOf('<recalled>\n');
			 inAtt.fileName = 'my attachment name';
			 inAtt.mimeTypeSubType = 'plain/txt';
			 email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
			  PP_ReplyViaApproval RA = new PP_ReplyViaApproval();
              RA.handleInboundEmail(email, env);
         Test.stoptest();   
                              
             
             
         }
     Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
}  
public static testmethod void PPReplyViaApprovalTestApprovedSize(){
	User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
             Test.startTest();  
           PR_Request__c newPRRequest = createdata();
        newPRRequest.Status__c='Submitted';
       
          PR_Request__c PR = [select id,name from PR_Request__C where id = :newPRRequest.id];
          
          system.debug('------------PRRequest-----------------'+PR);    
             Messaging.InboundEmail email = new Messaging.InboundEmail();
		     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			 Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
 		     email.subject = 'Property Pass Request - '+PR.Name;
             email.plainTextBody = 'Approved\nRequest\n';
		email.fromAddress = 'systemadministrator@testorg.com';
			 env.fromAddress = 'user@acme.com';
			 inAtt.body = blob.valueOf('<recalled>\n');
			 inAtt.fileName = 'my attachment name';
			 inAtt.mimeTypeSubType = 'plain/txt';
			 email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
			  PP_ReplyViaApproval RA = new PP_ReplyViaApproval();
              RA.handleInboundEmail(email, env);
         Test.stoptest();   
                              
             
             
         }
     Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
} 
public static testmethod void PPReplyViaApprovalTestRejectedSize(){
	User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
             Test.startTest();  
            PR_Request__c newPRRequest = createdata();
       
           
          PR_Request__c PR = [select id,name from PR_Request__C where id = :newPRRequest.id];
          
          system.debug('------------PRRequest-----------------'+PR);    
             Messaging.InboundEmail email = new Messaging.InboundEmail();
		     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			 Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
 		     email.subject = 'Property Pass Request - '+PR.Name;
             email.plainTextBody = 'Rejected\nRequest\n';
			email.fromAddress = 'systemadministrator@testorg.com';
			 env.fromAddress = 'user@acme.com';
			 inAtt.body = blob.valueOf('<recalled>\n');
			 inAtt.fileName = 'my attachment name';
			 inAtt.mimeTypeSubType = 'plain/txt';
			 email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
			  PP_ReplyViaApproval RA = new PP_ReplyViaApproval();
              RA.handleInboundEmail(email, env);
         Test.stoptest();   
                              
             
             
         }
     Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
}    
    
    public static testmethod void PPReplyViaApprovalTestRecalledSize(){
	User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
             Test.startTest();  
            PR_Request__c newPRRequest = createdata();
       
           
          PR_Request__c PR = [select id,name from PR_Request__C where id = :newPRRequest.id];
          
          system.debug('------------PRRequest-----------------'+PR);    
             Messaging.InboundEmail email = new Messaging.InboundEmail();
		     Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			 Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
 		     email.subject = 'Property Pass Request - '+PR.Name;
             email.plainTextBody = '<recalled>\nRequest\n';
			email.fromAddress = 'systemadministrator@testorg.com';
			 env.fromAddress = 'user@acme.com';
			 inAtt.body = blob.valueOf('<recalled>\n');
			 inAtt.fileName = 'my attachment name';
			 inAtt.mimeTypeSubType = 'plain/txt';
			 email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
			  PP_ReplyViaApproval RA = new PP_ReplyViaApproval();
              RA.handleInboundEmail(email, env);
         Test.stoptest();   
                              
             
             
         }
     Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
}    
}