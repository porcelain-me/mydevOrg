/**
 * 
 * modified by Avinash Munaga on 10/06/2016
 * 
 */

@isTest
private class RIF_ProjectLevelTest1
{

    private static final string PROJECT_BASED_TERMINATION = 'Project Based Termination';
    private static Severance_Parameters__c sp;
    static testMethod void myTest() {
    
        
        
        test.startTest();
        /****Insert Employee****/
            List<Employee__c> empList = new List<Employee__c>();
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(0, '123#0', '(INDIA', 'MSSB', 'Managing Director', '123');
            Employee__c emp1 = RIF_TestClassUtilities.createTestEmployee(1, '123#1', 'INDIA', 'MS', 'Director', '1233');
            empList.add(emp);
            empList.add(emp1);
            insert empList;
            
        /******Insert Project List******/
            RecordType rt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Project__c' limit 1];
            list<Project__c> projList = new List<Project__c>();
        
            projList.add( RIF_TestClassUtilities.createTestProject(0, rt.Id ));
            projList.add( RIF_TestClassUtilities.createTestProject(1, rt.Id ));
            insert projList;
            
            sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'INDIA', 'MSSB', 'Managing Director', '123');
            insert sp;
            
        /*********Insert Project Level********/
            list<Project_Level__c> listProjLevel = new list<Project_Level__c>();
            listProjLevel.add(RIF_TestClassUtilities.createTestProjectLevel(projList[0].Id, sp.Id));
            listProjLevel.add(RIF_TestClassUtilities.createTestProjectLevel(projList[1].Id, sp.Id));
            insert listProjLevel;
        
        RIF_ProjectLevelManager.populateDenormalizedFieldsIntoPL(listProjLevel,true);
        test.stopTest();
        
      
    }
    
}