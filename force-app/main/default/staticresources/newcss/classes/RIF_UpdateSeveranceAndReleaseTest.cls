@isTest(SeeAllData=true)
public class RIF_UpdateSeveranceAndReleaseTest{
    
    static testMethod void myTest(){
       
        Severance_And_Release__c snr;
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
            emp.DOH_Recent__c = Date.today();
            insert emp;
            
            // Assign user with Coverage Entitlements
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
            //covEntOrg.Coverage_Entitlement_Org_Code__c= orgCode.id;
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            insert covEntOrg;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = new Project__c ();
            proj.name = 'Test Project' ;
            proj.RecordTypeId = rt.id;
            proj.Country__c = 'USA' ; 
            proj.Status__c = 'Active' ;
            proj.Super_Division__c = 'Super Division 1';
            proj.Communication_Date__c  = Date.today();
            proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);                                
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
             projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            insert projOrgLevel;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert snr
            snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rt.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Project_Decisional_Org_Level__c = projOrgLevel.Id;
            snr.Decisional_Unit__c = pdu.Id;
            snr.Communication_Date__c  = Date.today();//date.parse('12/27/2009');
            snr.Termination_Date__c = SnR.Communication_Date__c.addDays(15);
            
        }
        insert snr;
        
       
        ApexPages.standardController stdcon = New ApexPages.StandardController(SnR);
        
        Test.startTest();
        
        RIF_UpdateSeveranceAndRelease obj = new RIF_UpdateSeveranceAndRelease(stdcon);
        
        obj.getDetailsForFormulas();
        obj.save();
      
        Test.stopTest();    
    }   
    
    static testMethod void myTest1(){
        
        Severance_And_Release__c snr;
        //Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
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
            emp.DOH_Recent__c = Date.today();
            insert emp;
            
            // Assign user with Coverage Entitlements
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
           // covEntOrg.Coverage_Entitlement_Org_Code__c= orgCode.id;
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            insert covEntOrg;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = new Project__c ();
            proj.name = 'Test Project' ;
            proj.RecordTypeId = rt.id;
            proj.Country__c = 'USA' ; 
            proj.Status__c = 'Active' ;
            proj.Super_Division__c = 'Super Division 1';
            proj.Communication_Date__c  = Date.today();
            proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);                                
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
             projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            insert projOrgLevel;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert snr
            snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rt.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Project_Decisional_Org_Level__c = projOrgLevel.Id;
            snr.Decisional_Unit__c = pdu.Id;
            snr.Communication_Date__c  = Date.today();//date.parse('12/27/2009');
            snr.Termination_Date__c = SnR.Communication_Date__c.addDays(15);
            snr.Last_Day_On_Premises__c =  SnR.Termination_Date__c.addDays(15);
        }
        insert snr;
        
        ApexPages.standardController stdcon = New ApexPages.StandardController(SnR);
        
        Test.startTest();
        Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];

        RIF_UpdateSeveranceAndRelease obj = new RIF_UpdateSeveranceAndRelease(stdcon);
        
        obj.getDetailsForFormulas();
        obj.save();
       obj.validHREmp(hrEmp.id);
        
        Test.stopTest();    
    }     
}