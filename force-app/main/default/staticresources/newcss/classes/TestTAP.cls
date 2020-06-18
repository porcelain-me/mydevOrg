/************************************************************************************
*
* 10/3/14 - Test for TAP classes
*
**************************************************************************************/
@isTest
private class TestTAP {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	TAP_Future.activateUser(userinfo.getUserId());
        	
        	Test.StopTest();
     
    }
   
    static testmethod void test2(){
		 
        	Test.startTest();
        	
        	TAPRequest tr = new TAPRequest();
        	 
        	tr.t.Justification__c = 'Test';
        	tr.t.Request_Type__c = 'System Administrator Permission';
        	tr.save();
        	tr.exit();
        	
        	Test.StopTest();
     
    }
    
   
}