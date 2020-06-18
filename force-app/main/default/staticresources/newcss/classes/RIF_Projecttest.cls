@isTest(SeeAllData=true)
private class RIF_Projecttest
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
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            update proj;
            delete proj;
        
        test.stopTest();
        
      
    }
    
}