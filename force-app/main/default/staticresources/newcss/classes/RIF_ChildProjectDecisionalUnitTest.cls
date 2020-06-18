@isTest(SeeAllData=true)
public class RIF_ChildProjectDecisionalUnitTest{
    
    static testMethod void myTest(){
        
        Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
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
            covEntOrg.Org_Hierarchy_Code__c = '10910 - Wealth Management';
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
            pdu.Decisional_Unit_Name__c = 'Test- PDU ' + Math.random();           
            pdu.Employee__c = hrEmp.id;
            pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            // insert project org level
            
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            //projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            insert projOrgLevel; 
            Test.startTest();
                       projOrgLevel.Total_Employees__c= 5;   
                update projOrgLevel;
                delete projOrgLevel;
            Test.stopTest();
        }
            
        Child_Project_Decisional_Unit__c childpdu = new Child_Project_Decisional_Unit__c ( Project_Decisional_Unit__c = 'a08f0000004ZpAb' , Decisional_Unit_Type__c= 'Super Division', Decisional_Unit_Code__c  = 'a0Sf0000000J8tdEAC' , Employee__c = 'a00f00000078aJeAAI');
        
    }
}