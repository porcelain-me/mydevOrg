/*
 *
 *  Avinash Munaga - 06/23/2015
 *  this is a default class that can be used to send emails
 */
public without sharing class SendMailHelperClass {
	
	// string for orgEmail and orgEmailId
	String orgEmail = null;
	String orgEmailId = null;
	
	// messaging object instance varaiable
	Messaging.SingleEmailMessage email = null;
	
	// body content of email
	String emailContent = null;
	
	// default constructor
	public SendMailHelperClass(){
		for(OrgWideEmailAddress owe : DG_DataUtil.getOrgWideEmaillAddresses(System.Label.RL_Orgwide_Email_Name)) {
            this.orgEmail = owe.Address;
            this.orgEmailId = owe.id;
        }
	}
	
	// constructor with parameters
	public SendMailHelperClass(String orgEmailId, Messaging.SingleEmailMessage email, String emailContent){
		this.orgEmailId = orgEmailId;
		this.email = email;
		this.emailContent = emailContent;
	}
	
	// build messaging object instance variable
	public Messaging.SingleEmailMessage createEmailInstance(String emailContent, String subjectLine) {
		
		// label returns environment details
		String env = System.Label.ORG_ENVIRONMENT.toLowerCase();
		
		// messaging object instantiation
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		
		// lists for sending emails
		List<String> emailAddresses = new List<String>();
		emailAddresses.add(orgEmail);
		
		// email object content
		email.setSaveAsActivity(false);
		email.setToAddresses(emailAddresses);
		email.setHtmlbody(emailContent);
		email.setSubject(subjectLine);
		
		return email;
	}
	
	// sendEmail method which sends email
	public void sendEmail(Messaging.SingleEmailMessage email){
		List<Messaging.SingleEmailMessage> emailSendList = new List<Messaging.SingleEmailMessage>();
		if(email != null) {
			emailSendList.add(email);
			Messaging.sendEmail(emailSendList,true);
		}
	}
	
}