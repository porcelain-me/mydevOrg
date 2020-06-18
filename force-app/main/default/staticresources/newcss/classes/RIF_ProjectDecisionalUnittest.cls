@isTest(SeeAllData=true)
private class RIF_ProjectDecisionalUnittest
{

    private static final string PROJECT_BASED_TERMINATION = 'Project Based Termination';
    
    static testMethod void myTest() {
    
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
            
            
            
        
            Project_Decisional_Unit__c pdu = RIF_TestClassUtilities.createTestProjDecisionalUnit('test decisional Unit', 'Division', projList[0].Id);
            
        
        test.startTest();
        
        /*******Insert Project Decisional Unit******/
        insert pdu;
            
            
        /**************Delete Project Decisional Unit******************/
        delete pdu;    
            
    
        test.stopTest();
        
      
    }
    
}