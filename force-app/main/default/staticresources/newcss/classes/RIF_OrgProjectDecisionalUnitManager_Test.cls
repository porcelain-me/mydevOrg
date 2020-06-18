@isTest(seealldata='true')
public class RIF_OrgProjectDecisionalUnitManager_Test {
    
    public static testMethod void  test1() {
        //Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
        RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
        testUtil.insertOrgHierarchy();
        
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        System.runAs(thisUser) {
            // Assign permission sets to user
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_System_Admin' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_HR_Coverage' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            // Create Employee with above user
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(0,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = thisUser.id;
            emp.Super_Division__c='10910';
            insert emp;
            
            // Assign user with Coverage Entitlements
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
            //covEntOrg.Coverage_Entitlement_Org_Code__c= orgCode.id;
            covEntOrg.Org_Hierarchy_Code__c='10910 - Wealth Management';
            insert covEntOrg;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            // get hr employee
            Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = '10910';
            pdu.Employee__c = hrEmp.id;
            pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            // insert project org level
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            //projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Org_Hierarchy_Code__c='10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            insert projOrgLevel;
            
            List<Child_Project_Decisional_Unit__c> childList = new List<Child_Project_Decisional_Unit__c>();
            childList.add(projOrgLevel);
            
            Map<id,Child_Project_Decisional_Unit__c> childMap = new Map<id,Child_Project_Decisional_Unit__c>();
            childMap.put(projOrgLevel.id, projOrgLevel);
            
            RIF_OrgProjectDecisionalUnitManager.popuateProjectID(childList, childMap);
            //RIF_OrgProjectDecisionalUnitManager.checkorgPDUEntitlements(childList, childMap);
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert snr
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rt.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Project_Decisional_Org_Level__c = projOrgLevel.Id;
            insert snr;
            
            RIF_OrgProjectDecisionalUnitManager.checkEmployeesDependencyOnDeletedOrgLevelDecisionalUnits(childList, childMap);
            RIF_OrgProjectDecisionalUnitManager.checkEmployeesDependencyOnUpdatedOrgLevelDecisionalUnits(childList, childMap, childList, childMap);
        }
    }

}