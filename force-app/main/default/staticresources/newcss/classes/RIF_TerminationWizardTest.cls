@isTest(SeeAllData=true)
public class RIF_TerminationWizardTest {
    static testMethod void myTest(){
        
        /**********Creating Project****************/
        Project__c proj = new Project__c();
                proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
       
        proj.name = 'Test Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        
        insert proj ;
        
        Test.startTest();
            RIF_TerminationWizard obj = new RIF_TerminationWizard();
            obj.project = proj ;
            obj.cancelStep1_Click();
            obj.nextStep1_Click();
            
        Test.stopTest();
    }
    
    static testMethod void myTest1(){
                Project__c proj = new Project__c();
        proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
        
        proj.name = 'Test Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        Test.startTest();
            RIF_TerminationWizard obj = new RIF_TerminationWizard();
            obj.project.Country__c = proj.Country__c ;
            obj.cancelStep1_Click();
            obj.nextStep1_Click();
            
        Test.stopTest();
    }
}