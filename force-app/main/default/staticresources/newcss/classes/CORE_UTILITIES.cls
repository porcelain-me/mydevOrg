/**************************************************************************************************************************************
*  Utlitilities for System Wide utlitities
*
*
* Change Log:
*	MRM = 3/7/15 - Created class and added systemEmailNotificaiton
*
******************************************************************************************************************************************/
Public class CORE_UTILITIES
{
    /* use to send emails to notify system admin of issues in code */
    
      public static void systemEmailNotification(String orgWideEmailId, string toAddress, String plainTextBody, String subject)
    {
        Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
		email.setOrgWideEmailAddressId(orgwideEmailId);
		List<String> emailToAddresses = new List<String>();
		emailToAddresses.add(toAddress);
		email.setToAddresses(emailToAddresses);
		email.setPlainTextBody(plainTextBody);
		email.setSubject(subject);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email} );
			
    }
    
    /* get an orgwided email addreess for an orgwided label */
    
    public static String getOrgWideEmailAddressId(String label){
    
    	OrgWideEmailAddress o = new OrgWideEmailAddress();
    	
    	if (Test.isRunningTest()){
    		
    	}
    	else
			o = [Select  o.Address From OrgWideEmailAddress o
						where displayname = :label];
    	
    	return o.id;
    }

    
}