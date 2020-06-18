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
private class RIF_WebserviceTest {
    private static final string ONE_OFF_TERMINATION = 'One Off Termination';
    private static testMethod void Test_getSRRecordTypeId() {
        User thisUser = RIF_TestClassUtilities.getTempUser();
        Test.startTest();
        system.runAs(thisUser){
            String recordTypeId = RIF_Webservice.getSRRecordTypeId(ONE_OFF_TERMINATION);
            system.assertNotEquals(NULL, recordTypeId, 'Record Type Id should not be null.');
            
            recordTypeId = RIF_Webservice.getSRRecordTypeId(null);
            system.assertEquals('', recordTypeId, 'Record Type Id should be blank.');
            
            recordTypeId = RIF_Webservice.getSRRecordTypeId('Incorrect Record Type Name');
            system.assertEquals('', recordTypeId, 'Record Type Id should be blank.');
        }
        Test.stopTest();
    }
    
    private static testMethod void Test_CreateOneOffProjectFromSR() {
        User thisUser = RIF_TestClassUtilities.getTempUser();
        RIF_TestClassUtilities.setAllTriggerOn();
        
        system.runAs(thisUser){
            //List<Employee__c> listEmp = new List<Employee__c>();
            Employee__c emp1 = RIF_TestClassUtilities.createTestEmployee(0, '123#1', 'USA', 'MSSB', 'Managing Director', '1');
            insert emp1;                                  
            //insert listEmp;
            
            RecordType rt = [Select Id from RecordType where Name=:ONE_OFF_TERMINATION and SobjectType = 'Project__c'];
            
            
            Set<String> setEmpIds = new Set<String>{'123#1'};
            List<Project__c> listProject = new List<Project__c>();
            listProject.add(RIF_TestClassUtilities.createTestProject(0, rt.Id));
            //listProject.add(RIF_TestClassUtilities.createTestProject(1, rt.Id));
            insert listProject;
            
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Managing Director', '123');
            insert sp; 
            
            List<Project_Level__c> listPL = new List<Project_Level__c>();
            listPL.add(RIF_TestClassUtilities.createTestProjectLevel(listProject[0].Id, sp.Id));
            //listPL.add(RIF_TestClassUtilities.createTestProjectLevel(listProject[1].Id, sp.Id));
            insert listPL;
            
            list<Project_Decisional_Unit__c> pduList = new list<Project_Decisional_Unit__c>();
            pduList.add(RIF_TestClassUtilities.createTestProjDecisionalUnit('test decisional Unit', 'Division', listProject[0].Id));
            //pduList.add(RIF_TestClassUtilities.createTestProjDecisionalUnit('test decisional Unit', 'Division', listProject[1].Id));
            insert pduList;
            
            /*Comp_Data__c compData = RIF_TestClassUtilities.createTestCompData(0, '123#1', '123.12', '123.12');
            insert compData;*/
            
            /*compData = RIF_TestClassUtilities.createTestCompData(1, '123#2', '123.12', '123.12');
            insert compData;*/
            //(commented on 16/10/2015 as covenant notice will be taken from severance parameter by level/severance parameter on s&R)
            /*Covenant_Parameters__c cp = RIF_TestClassUtilities.createTestCovenantParam('USA', 'MSSB', 'Managing Director'); 
            insert cp;*/
            
            RecordType srRT = [Select Id from RecordType where Name=:ONE_OFF_TERMINATION and SobjectType = 'Severance_And_Release__c'];
            
            list<Severance_And_Release__c> listSR = new List<Severance_And_Release__c>();
            listSR.add(RIF_TestClassUtilities.createTestSR(listPL[0].Id, emp1.Id, srRT.Id));
            insert listSR;
            
            Test.startTest();
            
            String result = RIF_Webservice.CreateOneOffProjectFromSR(NULL);
            system.assertEquals('Project can not create.', result);
            
            result = RIF_Webservice.CreateOneOffProjectFromSR(listSR[0].Id);
            system.assertEquals('Project created.', result);
            listSR = [Select Id, Project_Level__r.Project__r.RecordType.Name, RecordType.Name from Severance_And_Release__c where Id = :listSR[0].Id];
            system.assertEquals(ONE_OFF_TERMINATION, listSR[0].RecordType.Name, 'Record Type should be one of termination');   
            system.assertEquals(ONE_OFF_TERMINATION, listSR[0].Project_Level__r.Project__r.RecordType.Name, 'Record Type should be one of termination');
            
            Test.stopTest();
        }
        
    }
}