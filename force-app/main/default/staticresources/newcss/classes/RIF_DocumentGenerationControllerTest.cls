/**
 *
 * Test class 
 * Created on 10/06/2016 by Avinash Munaga
 */

@isTest(seealldata=true)
public class RIF_DocumentGenerationControllerTest {
    
    private static Severance_And_Release__c snr;
    
    private static testMethod void generateTest1() {
        String sessionId = UserInfo.getSessionId();
        User thisUser = RIF_TestClassUtilities.getTempUser();
        
        system.runAs(thisUser) {
            PageReference tpageRef = Page.RIF_DocumentGeneration;
            Test.setCurrentPage(tpageRef);
            
            Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            //sr.Outplacement__c = '3 Months';
            insert sr;
            
            ApexPages.currentPage().getParameters().put('SRId', sr.Id);
            ApexPages.currentPage().getParameters().put('sessionId',sessionId);
            ApexPages.currentPage().getParameters().put('serverUrl',System.label.Server_URL);
            
            RIF_DocumentGenerationController cont = new RIF_DocumentGenerationController();
            
            Test.startTest();
            
            cont.selectedDocs= new List<String>{'All'};
            
            cont.Generate();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void generateTest2() {
        String sessionId = UserInfo.getSessionId();
        User thisUser = RIF_TestClassUtilities.getTempUser();
        
        system.runAs(thisUser) {
            PageReference tpageRef = Page.RIF_DocumentGeneration;
            Test.setCurrentPage(tpageRef);
            
            Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            insert sr;
            
            ApexPages.currentPage().getParameters().put('SRId', sr.Id);
            ApexPages.currentPage().getParameters().put('sessionId',sessionId);
            ApexPages.currentPage().getParameters().put('serverUrl',System.label.Server_URL);
            
            RIF_DocumentGenerationController cont = new RIF_DocumentGenerationController();
            
            Test.startTest();
            
            cont.selectedVersion = 'Final';
            cont.selectedDocs= new List<String>{'Release Agreement'};
            
            cont.Generate();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void generateTest3() {
        String sessionId = UserInfo.getSessionId();
        User thisUser = RIF_TestClassUtilities.getTempUser();
        
        system.runAs(thisUser) {
            PageReference tpageRef = Page.RIF_DocumentGeneration;
            Test.setCurrentPage(tpageRef);
            
            Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            sr.Over_40__c = false;
            sr.exhibit_A__c = true;
            insert sr;
            
            ApexPages.currentPage().getParameters().put('SRId', sr.Id);
            ApexPages.currentPage().getParameters().put('sessionId',sessionId);
            ApexPages.currentPage().getParameters().put('serverUrl',System.label.Server_URL);
            
            RIF_DocumentGenerationController cont = new RIF_DocumentGenerationController();
            
            Test.startTest();
            
            cont.selectedVersion = 'Final';
            cont.selectedDocs= new List<String>{'Exhibit A'};
            
            cont.Generate();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void generateTest4() {
        String sessionId = UserInfo.getSessionId();
        User thisUser = RIF_TestClassUtilities.getTempUser();
        
        system.runAs(thisUser) {
            PageReference tpageRef = Page.RIF_DocumentGeneration;
            Test.setCurrentPage(tpageRef);
            
            Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            insert sr;
            
            ApexPages.currentPage().getParameters().put('SRId', sr.Id);
            ApexPages.currentPage().getParameters().put('sessionId',sessionId);
            ApexPages.currentPage().getParameters().put('serverUrl',System.label.Server_URL);
            
            RIF_DocumentGenerationController cont = new RIF_DocumentGenerationController();
            
            Test.startTest();
            
            cont.selectedVersion = '';
            cont.selectedDocs= new List<String>{'Release Agreement'};
            
            cont.Generate();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void generateTest5() {
        String sessionId = UserInfo.getSessionId();
        User thisUser = RIF_TestClassUtilities.getTempUser();
        
        system.runAs(thisUser) {
            PageReference tpageRef = Page.RIF_DocumentGeneration;
            Test.setCurrentPage(tpageRef);
            
            Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            sr.Over_40__c = true;
            insert sr;
            
            ApexPages.currentPage().getParameters().put('SRId', sr.Id);
            ApexPages.currentPage().getParameters().put('sessionId',sessionId);
            ApexPages.currentPage().getParameters().put('serverUrl',System.label.Server_URL);
            
            RIF_DocumentGenerationController cont = new RIF_DocumentGenerationController();
            
            Test.startTest();
            
            cont.selectedVersion = 'Final';
            cont.selectedDocs= new List<String>{'Age Disclosure'};
            
            cont.Generate();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void generateTest6() {
        String sessionId = UserInfo.getSessionId();
        User thisUser = RIF_TestClassUtilities.getTempUser();
        
        system.runAs(thisUser) {
            PageReference tpageRef = Page.RIF_DocumentGeneration;
            Test.setCurrentPage(tpageRef);
            
            Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            sr.Over_40__c = true;
            insert sr;
            
            ApexPages.currentPage().getParameters().put('SRId', sr.Id);
            ApexPages.currentPage().getParameters().put('sessionId',sessionId);
            ApexPages.currentPage().getParameters().put('serverUrl',System.label.Server_URL);
            
            RIF_DocumentGenerationController cont = new RIF_DocumentGenerationController();
            
            Test.startTest();
            
            cont.selectedVersion = 'Final';
            cont.selectedDocs= new List<String>{'Separation Summary'};
            
            cont.Generate();
            
            Test.stopTest();
        }
    }
}