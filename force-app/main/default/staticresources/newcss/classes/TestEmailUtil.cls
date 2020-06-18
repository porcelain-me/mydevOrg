/** AUTHOR : RAHUL JAIN **/
 @isTest
private class TestEmailUtil {
   /** TEST METHOD **/
    static testmethod void testClass(){
    	
    	 User usr =   CM_TestClassUtilities.getTempUser();
    	 
    	system.runAs(usr){
    		
    		TestClassUtilities.setAllTriggerOn();
    		
    	}   	 	
    	
       
       string toAddress = 'consulting@appirio.com';
       string targetObjectId = null;
       boolean saveAsActivity = false;
       string htmlbody = '<b>asdf</b>';
       string textbody = null;
       string subject = 'subject';
       string fromAddress = 'consulting@appirio.com';
       system.runAs(usr){
       EmailUtil.sendSingleEmail(toAddress, targetObjectId, saveAsActivity, 
       htmlbody, textbody, subject, fromAddress);
        }
       textbody = 'asd'; 
       htmlbody = null;
       
       List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
       emailList.add(EmailUtil.getSingleEmail(toAddress, targetObjectId, saveAsActivity, htmlbody, textbody, subject, fromAddress));
       system.runAs(usr){
       	EmailUtil.sendBulkEmail(emailList);
       }
   }
}