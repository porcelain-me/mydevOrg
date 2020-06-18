/************************************************************************************
*
* 6/6/14 - MRM Create test for future class
*
**************************************************************************************/
@isTest
private class TestFFAP_Future {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	String uId = userinfo.getUserId();
        	
        	User u = [select email from User where id = :uId];
        	
        	Employee__c e = new Employee__c (name = 'Test User', emp_id__c = 'Test$', email__c=u.email);
        	insert e;
        	 
        	FFAP_Agreement__c fap = new FFAP_Agreement__c(employee__c = e.id);
        	insert fap;
        	
        	ID ffapId = fap.id;
        	
        	String envelopeId ='testEnv';
        	String emailAddress= u.email;
        	String templateId='1';
        	String queryId='1'	;
        	String docName='dog1.doc';
        	
        	FFAP_Future.doFFAPUpdates(e.Id, e.emp_id__c, ffapId, envelopeId, emailAddress);
        	
        
        	
        	Test.StopTest();
     
    }
    
    static testmethod void test2(){
		 
        	Test.startTest();
        	
        	String uId = userinfo.getUserId();
        	
        	User u = [select email from User where id = :uId];
        	
        	Employee__c e = new Employee__c (name = 'Test User', emp_id__c = 'Test$', email__c=u.email);
        	insert e;
        	
        	ID ffapId = null;
        	
        	String envelopeId ='testEnv';
        	String emailAddress= u.email;
        	String templateId='1';
        	String queryId='1'	;
        	String docName='dog1.doc';
        	
        	
        
        	
        	Test.StopTest();
     
    }
}