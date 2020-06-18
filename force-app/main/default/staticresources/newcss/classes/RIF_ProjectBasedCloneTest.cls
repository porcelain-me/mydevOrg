/**
 *
 * Test class 
 * Created on 10/06/2016 by Avinash Munaga
 */

@isTest
public class RIF_ProjectBasedCloneTest {
    
    private static testMethod void testcloneWithHistory() {
        System.runAs(RIF_TestClassUtilities.getTempUser()){
            
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Managing Director', '123');
            insert sp;
            
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(proj);
            
            //RIF_ProjectBasedClone.clonesevParameters = false;
            
            RIF_ProjectBasedClone testObj = new RIF_ProjectBasedClone(sc);
            //testObj.proj = proj;
            //testObj.newproj = new Project__c();
            //testObj.newRecordId = null;
            //testObj.projID = '';
            
            test.startTest();
            
            testObj.cloneWithHistory();
            
            test.stopTest();
        }
    }
}