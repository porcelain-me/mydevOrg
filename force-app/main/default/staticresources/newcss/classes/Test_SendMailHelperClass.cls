@isTest(SeeAllData=true)
public with sharing class Test_SendMailHelperClass {
	private static User getSystemAdminTempUser(){
        User tempUser = RL_TestData.getSystemAdminTempUser();
        
        return tempUser; 
    }
    
    static testMethod void positiveTest(){
    	System.runAs(getSystemAdminTempUser()) {
    		SendMailHelperClass obj = new SendMailHelperClass();
    	
	    	Messaging.singleEmailMessage email = obj.createEmailInstance('mailBody', 'mailSubject');
	    	obj.sendEmail(email);
	    	
	    	obj = new SendMailHelperClass('test@morganstanley.com', new Messaging.SingleEmailMessage(), 'emailBody');
    	}
    }
}