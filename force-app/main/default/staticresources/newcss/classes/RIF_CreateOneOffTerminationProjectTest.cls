@isTest(seealldata='true')
private class RIF_CreateOneOffTerminationProjectTest {
    private static final String ONE_OFF_TERMINATION = 'One Off Termination';
    
    private static testMethod void Test_CreateOneOffTerminationProjectFromProjectLevel() {
        
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        system.runAs(thisUser){
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_System_Admin' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            RIF_TestClassUtilities.setAllTriggerOn();
            
            User nonSysAdminUser = RIF_TestClassUtilities.getOtherUser();
            nonSysAdminUser.RIF_Allow_Super_Division__c = 'Super Division 1';
            
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(445,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = thisUser.id;
            emp.Super_Division__c='10910';
            emp.DOH_Recent__c = Date.newInstance(2010, 01, 01);
            insert emp;
            
            // Assign user with Coverage Entitlements
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
            //covEntOrg.Org_Hierarchy_Code__c = '10910 - Super Division';
            insert covEntOrg;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(446, rt.Id );
            proj.Status__c = 'Mod';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(446, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            // insert pdu
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'Test- PDU ' + Math.random();           
            //pdu.Employee__c = hrEmp.id;
            //pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            //
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rt.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Last_Day_On_Premises__c = date.today().addDays(30);
            
            Test.setCurrentPage(Page.RIF_CreateOneOffTerminationProject);
            ApexPages.currentPage().getParameters().put('plID', pl.Id);
            
            RIF_CreateOneOffTerminationProject createSRController = new RIF_CreateOneOffTerminationProject();
            createSRController.project = proj;
            createSRController.sp = sp;
            createSRController.sr = snr;
            createSRController.pdu = pdu;
            //createSRController.childPDU = projOrgLevel;
            
            System.PageReference pg;
            
            Test.startTest();
            	
            	pg = createSRController.getEmployeeDetails();
            	createSRController.getDetailsBeforeSave();            	
                pg = createSRController.finish();
            
                //system.assertNotEquals(NULL, pg, 'page reference should not be null.');
               
                //system.assertNotEquals(NULL, createSRController.sr.Id, 'SnR should be inserted.');
            
            Test.stopTest();
        }
    }
    
    private static testMethod void Test_methodAll() {
       
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        system.runAs(thisUser){
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_System_Admin' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            RIF_TestClassUtilities.setAllTriggerOn();
            
            User nonSysAdminUser = RIF_TestClassUtilities.getOtherUser();
            nonSysAdminUser.RIF_Allow_Super_Division__c = 'Super Division 1';
            
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(447,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = thisUser.id;
            emp.Super_Division__c='10910';
            emp.DOH_Recent__c = Date.newInstance(2010, 01, 01);
            insert emp;
            
            // Assign user with Coverage Entitlements
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
            covEntOrg.Org_Hierarchy_Code__c = '10910 - Super Division';
            insert covEntOrg;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(447, rt.Id );
            proj.Status__c = 'Mod';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(447, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            // insert pdu
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'Test- PDU ' + Math.random();           
            //pdu.Employee__c = hrEmp.id;
            //pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            RecordType rtSNR = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rtSNR.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Last_Day_On_Premises__c = date.today().addDays(5);
            snr.Communication_Date__c = Date.today();
            snr.Termination_Date__c = Date.today().addDays(14);
            snr.Notice_Days_1__c = '';
            snr.LOS_1__c = '';
            
            Test.startTest();
            /*
           	 	PageReference thePage = Page.RIF_CreateOneOffTerminationProject;
            	Test.setCurrentPage(thePage);
            	thePage.getParameters().put('plID',pl.Id);
                RIF_CreateOneOffTerminationProject createSRController = new RIF_CreateOneOffTerminationProject();
                //createSRController.project = proj;
                createSRController.sp = sp;
                createSRController.sr = snr;
                createSRController.pdu = pdu;
                //createSRController.childPDU = projOrgLevel;
            	createSRController.getEmployeeDetails();
            	createSRController.getDetailsBeforeSave();            	
                createSRController.finish();
            */
                RIF_CreateOneOffTerminationProject createSRController = new RIF_CreateOneOffTerminationProject();
                createSRController.project = proj;
                createSRController.sp = sp;
                createSRController.sr = snr;
                createSRController.pdu = pdu;
                //system.assertNotEquals(NULL, pg, 'page reference should not be null.');
               
                //system.assertNotEquals(NULL, createSRController.sr.Id, 'SnR should be inserted.');
            
            Test.stopTest();
        }
    }

}