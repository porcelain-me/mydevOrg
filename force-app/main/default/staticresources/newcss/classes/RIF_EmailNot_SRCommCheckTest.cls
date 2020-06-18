/**
 *
 * Test class 
 * Created on 10/06/2016 by Avinash Munaga
 */
@isTest
public with sharing class RIF_EmailNot_SRCommCheckTest {
	
	static testMethod void testCommunicationCheck(){
		System.runAs(RIF_TestClassUtilities.getTempUser()){
			
            String query = 'SELECT id, Name FROM Severance_And_Release__c';
            
            List<Severance_And_Release__c> srList = [SELECT id, Name FROM Severance_And_Release__c];
			
			test.startTest();
            
            RIF_EmailNot_SRCommCheck srCheck = new RIF_EmailNot_SRCommCheck(query);
			Database.executeBatch(srCheck);
            
            Database.QueryLocator ql = srCheck.start(null);
            srCheck.execute(null,srList);
            srCheck.Finish(null);
            
			test.stopTest();
			
		}
	}
}