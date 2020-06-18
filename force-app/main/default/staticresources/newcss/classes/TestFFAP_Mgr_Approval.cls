/************************************************************************************
*
* 6/6/14 - MRM Create test for manager signature approval controller
*
**************************************************************************************/
@isTest
private class TestFFAP_Mgr_Approval {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	
           	FFAP_Mgr_Approval controller = new FFAP_Mgr_Approval();
        
        	controller.getSortDirection();
        	controller.sortExpression = 'dsfs__Date_Sent__c';
        	controller.setSortDirection('ASC');
        	controller.setSortDirection('DESC');
       
        	controller.goToSigning();
        	controller.goToFAP();
        	
        	Test.StopTest();
     
    }
}