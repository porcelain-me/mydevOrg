public class EPAScorecardCustomController {
        
    public EPAScorecardCustomController()
	{
		id = ApexPages.currentPage().getParameters().get('id');
		contractNumber =  ApexPages.currentPage().getParameters().get('cn');
		url = system.Label.ssourl+'/'+id;
		user = userinfo.getName();
	}
	public String user {get;set;}
     public String id {get;set;}
     public String contractNumber {get;set;}
	 public String url {get;set;}
	 public String rejectMsg {get;set;}  
        public PageReference rejectRecord()
        {
        	Product_Request__c obj = [select Status__c,EPAScoreCardApprove__c,owner.id from Product_Request__c where id=:id];
        	obj.Status__c = 'Cancelled';
        	obj.EPAScoreCardApprove__c =false; 
        	obj.EPAScoreCardReject__c = true;
        	obj.RejectMessage__c = rejectMsg;
        	Database.saveresult sr = database.update (obj);
        	if(sr.isSuccess())
        	{
		         Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
         email.setTargetObjectId(obj.owner.id);//euprodrequest.RequestedBy__c);
         email.setWhatId(id);
         Id templateId = [select id, name from EmailTemplate where developername = 'PR_EPAScorecard_Rejected_email'].Id;
         email.setTemplateId(templateId);
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
		          PageReference pg = new PageReference(system.Label.ssourl+'/'+id);
		          return pg;
        	}
        	else
        	{ 
		          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		          mail.setToAddresses( new String[] { 'rakesh.singh1@morganstanley.com.test' } );
		          mail.setSaveAsActivity(false);
		          mail.setSubject('Error : EPA Scorecard Rejected: '+ contractNumber);
		          List<Database.Error> err = sr.getErrors();
		          mail.setPlainTextBody(err[0].getStatusCode() + ': ' + err[0].getMessage());
		          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		          PageReference pg = new PageReference(system.Label.ssourl+'/'+id);
		          return pg;
        		
        	}
        }       


	public string getRequestor()
	{ 
		return [select owner.email from Product_Request__c where id=:id].owner.email;
	}
}