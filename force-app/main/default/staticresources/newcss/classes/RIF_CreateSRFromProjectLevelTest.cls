@isTest
private class RIF_CreateSRFromProjectLevelTest {
    private static final String PROJECT_BASED_TERMINATION = 'Project Based Termination';
    private static testMethod void Test_RIF_CreateSRFromProjectLevel() {
        User thisUser = RIF_TestClassUtilities.getTempUser();
        system.runAs(thisUser){
            RIF_TestClassUtilities.setAllTriggerOn();
            
            List<Employee__c> empList = new List<Employee__c>();
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(0, '123#0', 'USA', 'MSSB', 'Managing Director', '123');
            emp.DOH_Recent__c = Date.newInstance(2010, 01, 01);
            empList.add(emp);
            
            Employee__c emp1 = RIF_TestClassUtilities.createTestEmployee(1, '123#1', 'USA', 'MS', 'Director', '1233');
            emp.DOH_Recent__c = Date.newInstance(2011, 01, 01);
            empList.add(emp1);
            
            insert empList;
            
            RecordType rt = [Select Id from RecordType where Name = :PROJECT_BASED_TERMINATION and SobjectType = 'Project__c' limit 1];
            
            list<Project__c> projList = new List<Project__c>();        
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            proj.Country__c  = 'USA';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(28);
            projList.add( proj);
            insert projList;
            
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Managing Director', '123');
            insert sp;
            
            list<Project_Level__c> listProjLevel = new list<Project_Level__c>();
            listProjLevel.add(RIF_TestClassUtilities.createTestProjectLevel(projList[0].Id, sp.Id));
            insert listProjLevel;
             
            Project_Decisional_Unit__c pdu = RIF_TestClassUtilities.createTestProjDecisionalUnit('Super Division0', 'Super Division', projList[0].Id);
            insert pdu;
            
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(listProjLevel[0].Id, empList[0].Id, rt.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
                        
            Test.startTest();
            
            Test.setCurrentPage(Page.RIF_CreateSRFromProjectLevel);
            ApexPages.currentPage().getParameters().put('RecordType', PROJECT_BASED_TERMINATION);
            ApexPages.currentPage().getParameters().put('pid', projList[0].Id);
            ApexPages.currentPage().getParameters().put('retURL', '/' + projList[0].Id);  
            
            RIF_CreateSRFromProjectLevel createSRController = new RIF_CreateSRFromProjectLevel();
            createSRController.isProjCommDateLeapYear = false;
            createSRController.projectLevelforSnR = new Project_Level__c();
            createSRController.commntDt = '';
            createSRController.termDt = '';
            createSRController.lastDayDt = '';
            createSRController.empUnvested = new Unvested_Equity__c();
            createSRController.unvestedtotalValue = '';
            createSRController.isRunningFromProjectLevel = false;
            createSRController.emp = empList[0];
            createSRController.sr = snr;
            createSRController.sr.Employee__c = empList[0].Id;
            
            createSRController.pageAction();
            createSRController.getEmployeeDetails();
            createSRController.calculateLos();
     
           // system.assertEquals('/' + projList[0].Id, createSRController.retURL, 'Return url should be same as passed.');
            system.debug('1565166263'+projList[0].Id);
            
            createSRController.cancel();
            System.PageReference pg = createSRController.create();
            
            
            system.assertEquals(empList[0].Id, createSRController.emp.Id, 'Employee should be fetched correctly.');
            //system.assertNotEquals(NULL, pg, 'page reference should not be null.');
            
            ApexPages.currentPage().getParameters().put('RecordType', PROJECT_BASED_TERMINATION);
            ApexPages.currentPage().getParameters().put('pid', projList[0].Id);
            ApexPages.currentPage().getParameters().put('retURL', '/' + projList[0].Id);  
            
            createSRController = new RIF_CreateSRFromProjectLevel();
            createSRController.emp = empList[1];
            createSRController.sr.Employee__c = empList[1].Id;
            
            createSRController.pageAction();
            pg = createSRController.create();
            
            system.assertEquals(empList[1].Id, createSRController.emp.Id, 'Employee should be fetched correctly.');
            //system.assertEquals(NULL, pg, 'page reference should be null.');
            
            Test.stopTest();
        }
    }
}