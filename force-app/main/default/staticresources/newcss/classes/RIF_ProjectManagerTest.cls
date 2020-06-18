/**
 * 
 * modified by Avinash Munaga 10/06/2016
 * 
 */ 
@isTest(seeAllData='true')
private class RIF_ProjectManagerTest {
    private static string ONE_OFF_TERMINATION = 'One Off Termination';
    
    static User getUser(Severance_And_Release__c sr) {
        Employee__c emp = [SELECT id,Name,User__c FROM Employee__c WHERE id=:sr.Employee__c];
        User thisUser = [SELECT Id, Name FROM User WHERE Id = :emp.User__c];
        
        return thisUser;
    }
    
    private static testMethod void Test_ProjectManager1() {
       Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert sr;
        
       Project__c proj = [SELECT id,Name,Status__c FROM Project__c WHERE id=:sr.Project__c];
        
        User thisUser = getUser(sr);
        system.runAs(thisUser){
            Map<Id,Project__C> oldMap = new Map<Id,Project__c>();
            oldMap.put(proj.Id,proj);
            
            proj.Status__c = 'Cancelled';
	        Update proj;
            
            List<Project__c> projList = [select Id, System_Super_Division__c,Status__c,Name,Country__c,
                                         Communication_Date__c, Termination_Date__c,Notice_Days__c,WARN__c
                                          from Project__c where id=:proj.Id limit 1];
	        system.assertEquals(1, projList.size(), 'One project should be updated.');
            
            Map<Id,Project__C> newMap = new Map<Id,Project__c>();
            for(Project__c pro : projList){
                newMap.put(pro.Id,pro);
            }
            
            Test.startTest();
            
                //RIF_ProjectManager.applyStatusValidations(true,true,false,projList,oldMap,newMap);
                RIF_ProjectManager.deleteProjectDUAndSRecord(projList);
                RIF_ProjectManager.applyStatusValidations(true,true,false,projList,oldMap,newMap);
            
            Test.stopTest();
        }
    }
    
    private static testMethod void Test_ProjectManager2() {        
        Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        sr.Communicated__c = true;
        sr.Communication_Date__c = Date.today();
        sr.Communicated_Date__c = Date.today();
        insert sr;
        
        Project__c proj = [SELECT id,Name,Status__c FROM Project__c WHERE id=:sr.Project__c];
        
        User thisUser = getUser(sr);
        system.runAs(thisUser){
            
            proj.Status__c = 'Active';
            proj.Communication_Date__c = Date.today();
            update proj;
            
            Map<Id,Project__C> oldMap = new Map<Id,Project__c>();
            oldMap.put(proj.Id,proj);
            
            proj.Status__c = 'Closed';
            update proj;
            
            List<Project__c> projList = [select Id, System_Super_Division__c,Status__c,Name,Country__c,
                                         Communication_Date__c, Termination_Date__c,Notice_Days__c,WARN__c
                                          from Project__c where id=:proj.Id limit 1];
            system.assertEquals(1, projList.size(), 'One project should be updated.');
            Map<Id,Project__C> newMap = new Map<Id,Project__c>();
            for(Project__c pro : projList){
                newMap.put(pro.Id,pro);
            }
            
            Test.startTest();
            
                Project_Decisional_Unit__c pdu = RIF_TestClassUtilities.createTestProjDecisionalUnit('','',proj.Id);
                
                Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB',
                                                                                        'Vice President-Director', '123');
                insert sp;
                
                Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
                insert pl;
                
                //RIF_ProjectManager.applyStatusValidations(true,true,false,projList,oldMap,newMap);
                RIF_ProjectManager.deleteProjectDUAndSRecord(projList);
                RIF_ProjectManager.applyStatusValidations(true,false,true,projList,oldMap,newMap);
            
            Test.stopTest();
        }
    }
    
    private static testMethod void Test_ProjectManager3() {        
        Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert sr;
        
        Project__c proj = [SELECT id,Name,Status__c FROM Project__c WHERE id=:sr.Project__c];
        
        User thisUser = getUser(sr);
        system.runAs(thisUser){
	        Map<Id,Project__C> oldMap = new Map<Id,Project__c>();
            oldMap.put(proj.Id,proj);
            
            proj.Status__c = 'Active';
            update proj;
            List<Project__C> projList = [select Id, System_Super_Division__c,Status__c,Name,Country__c,
                                         Communication_Date__c, Termination_Date__c,Notice_Days__c,WARN__c
                                          from Project__c where id=:proj.Id limit 1];
	        system.assertEquals(1, projList.size(), 'One project should be updated.');
            Map<Id,Project__C> newMap = new Map<Id,Project__c>();
            for(Project__c pro : projList){
                newMap.put(pro.Id,pro);
            }
            
            Test.startTest();
            
                //RIF_ProjectManager.applyStatusValidations(true,true,false,projList,oldMap,newMap);
                RIF_ProjectManager.deleteProjectDUAndSRecord(projList);
                RIF_ProjectManager.applyStatusValidations(true,true,false,projList,oldMap,newMap);
            
            Test.stopTest();
        }
    }
    
    private static testMethod void Test_ProjectManager4() {        
        Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert sr;
        
        Project__c proj = [SELECT id,Name,Status__c FROM Project__c WHERE id=:sr.Project__c];
        
        User thisUser = getUser(sr);
        system.runAs(thisUser){
	        proj.Status__c = 'cancelled';
	        update proj;
            
            Map<Id,Project__C> oldMap = new Map<Id,Project__c>();
            oldMap.put(proj.Id,proj);
            
            List<Project__C> projList = [select Id, System_Super_Division__c,Status__c,Name,Country__c,
                                         Communication_Date__c, Termination_Date__c,Notice_Days__c,WARN__c
                                          from Project__c where id=:proj.Id limit 1];
	        system.assertEquals(1, projList.size(), 'One project should be updated.');
            Map<Id,Project__C> newMap = new Map<Id,Project__c>();
            for(Project__c pro : projList){
                newMap.put(pro.Id,pro);
            }
            
            Test.startTest();
            
                RIF_ProjectManager.applyStatusValidations(true,false,true,projList,oldMap,newMap);
            
            Test.stopTest();
        }
    }
    
    private static testMethod void Test_ProjectManager5() {        
        Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        insert sr;
        
        Project__c proj = [SELECT id,Name,Status__c FROM Project__c WHERE id=:sr.Project__c];
        
        User thisUser = getUser(sr);
        system.runAs(thisUser){
	        proj.Status__c = 'Active';
	        update proj;
            
            Map<Id,Project__C> oldMap = new Map<Id,Project__c>();
            oldMap.put(proj.Id,proj);
            
            List<Project__C> projList = [select Id, System_Super_Division__c,Status__c,Name,Country__c,
                                         Communication_Date__c, Termination_Date__c,Notice_Days__c,WARN__c
                                          from Project__c where id=:proj.Id limit 1];
	        system.assertEquals(1, projList.size(), 'One project should be updated.');
            Map<Id,Project__C> newMap = new Map<Id,Project__c>();
            for(Project__c pro : projList){
                newMap.put(pro.Id,pro);
            }
            
            Test.startTest();
            
                RIF_ProjectManager.applyStatusValidations(true,false,true,projList,oldMap,newMap);
            
            Test.stopTest();
        }
    }
}