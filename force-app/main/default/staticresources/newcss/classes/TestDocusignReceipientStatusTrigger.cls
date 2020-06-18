/************************************************************************************
*
* 6/6/14 - MRM Create test for docusign trigger
*
**************************************************************************************/
@isTest
private class TestDocusignReceipientStatusTrigger {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	String uId = userinfo.getUserId();
        	
        	User u = [select email from User where id = :uId];
        	
        	Employee__c e = new Employee__c (name = 'Test User', emp_id__c = 'Test$', email__c=u.email);
        	insert e;
        	
        	FFAP_Agreement__c fap = new FFAP_Agreement__c(employee__c = e.id);
        	insert fap;
        	
        	dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c(
        			 FFAP_Record__c = fap.id
        			,dsfs__Subject__c = 'Commitment Agreement'
        			,dsfs__docusign_Envelope_id__c = 'testenv'
        			);
        	insert ds;
        	
        	dsfs__DocuSign_Recipient_Status__c drs = new dsfs__DocuSign_Recipient_Status__c(
        		dsfs__Envelope_Id__c = 'testenv'
        		,dsfs__docusign_recipient_id__c = '1'
        		,dsfs__Recipient_Status__c = 'Sent'
        		,dsfs__DocuSign_Routing_Order__c = 2
        		,name = 'test class'
        		,dsfs__Parent_Status_Record__c = ds.id
        		,dsfs__DocuSign_Recipient_Email__c = u.email
				);
        	
        	insert drs;
        	
        	Test.StopTest();
     
    }
    
    
}