/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RIF_ProjectLevelTest {
    private static string ONE_OFF_TERMINATION = 'One Off Termination';
    private static testMethod void Test_ProjectLevelManager() {
        User thisUser = RIF_TestClassUtilities.getTempUser();
        system.runAs(thisUser){
            RIF_TestClassUtilities.setAllTriggerOn();
            RecordType rt = [Select Id from RecordType where Name = :ONE_OFF_TERMINATION and SobjectType = 'Project__c' limit 1];
            
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Managing Director', '123');
            insert sp;
            
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            Test.startTest();
            insert pl;
            
            Test.stopTest();
            
            list<Project_Level__c> plList = [select Id, Level_Dsc__c, Level__c from Project_Level__c where Id = :pl.Id limit 1];
            system.assertEquals(1, plList.size(), 'One project level should be inserted.');
            system.assertEquals(sp.Level__c, plList[0].Level__c, 'Severance Parameter Level should be project level.');
            system.assertEquals(sp.Level_Dsc__c, plList[0].Level_Dsc__c, 'Severance Parameter Level description should be project level description.');
        }
    }
}