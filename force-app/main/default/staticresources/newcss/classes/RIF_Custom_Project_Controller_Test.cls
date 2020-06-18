@isTest
public without sharing class RIF_Custom_Project_Controller_Test {
  
      
    public static testMethod void testMethod1(){
    
   
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
      
        System.runAs(thisUser) {
            // Assign permission sets to user
            
            PermissionSet  ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_HR_Coverage' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
        
            // Create Employee with above user
            List<Employee__c> emplist = new List<Employee__c>();
            
            Employee__c emp = new Employee__c();
            emp.Name = 'Test Employee_';
            emp.emp_Id__c = '12345' ;
            emp.Job_Country_Job__c = 'USA';
            emp.MS_MSSB__c = 'MSSB';
            emp.Level_Dsc_Job__c = 'Director'; 
            emp.Covenant_Date__c = Date.today();
            emp.Level_Job__c = '123';
            emp.User__c = thisUser.id;
            emp.Super_Division__c= 'Super Divison';
            emp.Super_Depart_Org__c ='Super Department';
            emp.Subdept_Org__c = 'Sub Department' ;
            emp.Division_Org__c = 'Division' ;
           emp.Dept_Org__c = 'Department';
            emp.Sub_Depart2_Org__c = 'Sub Department 2' ;
            emp.Cost_Center__c = 'Cost Center' ;
            //emp.Dept_Org__c='81200';
            
            insert emp;
            
            
            // Assign user with Coverage 
            // List<Coverage_Entitlement__c> covEntList = new List<Coverage_Entitlement__c>();
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c =emp.id ;
            
            insert covEnt;
            
            List<Coverage_Entitlement_Org__c> covEntOrgList = new List<Coverage_Entitlement_Org__c>();
            //for(Coverage_Entitlement__c covEnt: covEntList){
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';          
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            
            covEntOrgList.add(covEntOrg);
            
            Coverage_Entitlement_Org__c covEntOrg1 = new Coverage_Entitlement_Org__c();
            covEntOrg1.Coverage_Entitlement__c= covEnt.id;
            covEntOrg1.Coverage_Entitlement_Type__c= 'Division';   
            covEntOrg1.Org_Hierarchy_Code__c= '85000 - Company Management';
            covEntOrgList.add(covEntOrg1);
            //}
            insert covEntOrgList;
            
            
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            
            
            // get hr employee
            Employee__C hrEmp = new Employee__c() ;
            hrEmp=[SELECT id FROM Employee__C WHERE Dept_Org__c='81200' and  status__c= 'Active' limit 1 ];
            insert hrEmp;
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'WM';
             pdu.Employee__c = hrEmp.id;
             pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            // insert project org level
            
            List<Child_Project_Decisional_Unit__c> projOrgLevelList = new List<Child_Project_Decisional_Unit__c>();
            
            Child_Project_Decisional_Unit__c projOrgLevel0 = new Child_Project_Decisional_Unit__c();
            projOrgLevel0.Decisional_Unit_Type__c='Employee';
            projOrgLevel0.Project_Decisional_Unit__c=pdu.id;
            projOrgLevelList.add(projOrgLevel0);
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel);
            
            Child_Project_Decisional_Unit__c projOrgLevel1 = new Child_Project_Decisional_Unit__c();
            projOrgLevel1.Decisional_Unit_Type__c = 'Division';
            projOrgLevel1.Org_Hierarchy_Code__c = '85000 - Company Management';
            projOrgLevel1.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel1);
            
            insert projOrgLevelList;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert 
            
            List<Severance_And_Release__c> snrList1 = new List<Severance_And_Release__c>();
            
            Severance_And_Release__c snr = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Super_Division__c = '10910',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            
            snrList1.add(snr);
            
            Severance_And_Release__c snr1 = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Division__c = '85000',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snrList1.add(snr1);	
            
            insert snrList1;
            
            
            System.runAs(thisUser) {
                Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(proj);
                RIF_Custom_Project_Controller customObj = new RIF_Custom_Project_Controller(sc);
                
                
                customObj.eligibleReadOnlyPDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.eligibleReadWritePDU_TO_Share = new List <Project_Decisional_Unit__c>();
                
              
                
                
                customObj.redirect();
                customobj.isCoverageUser=true;
                
                Test.stopTest();
                
            }
        
    }
    }
    
    
    
    public static testMethod void testMethod2(){
        
        List<Severance_And_Release__c> snrList = new List<Severance_And_Release__c>();    
        //Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
        RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
        testUtil.insertOrgHierarchy();
        
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        System.runAs(thisUser) {
            // Assign permission sets to user
            
            PermissionSet  ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_HR_Operations' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            
            // Create Employee with above user
            List<Employee__c> emplist = new List<Employee__c>();
            
            Employee__c emp = new Employee__c();
            emp.Name = 'Test Employee_';
            emp.emp_Id__c = '12345' ;
            emp.Job_Country_Job__c = 'USA';
            emp.MS_MSSB__c = 'MSSB';
            emp.Level_Dsc_Job__c = 'Director'; 
            emp.Covenant_Date__c = Date.today();
            emp.Level_Job__c = '123';
            emp.User__c = thisUser.id;
            emp.Super_Division__c= '10910';
            emp.Super_Depart_Org__c ='Super Department';
            emp.Subdept_Org__c = 'Sub Department' ;
            emp.Division_Org__c = 'Division' ;
            emp.Dept_Org__c = 'Department';
            emp.Sub_Depart2_Org__c = 'Sub Department 2' ;
            emp.Cost_Center__c = 'Cost Center' ;
            
            
            
            
            insert emp;
            
            
            // Assign user with Coverage 
            // List<Coverage_Entitlement__c> covEntList = new List<Coverage_Entitlement__c>();
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            //covEntList.add(covEnt);
            
            
            insert covEnt;
            List<Coverage_Entitlement_Org__c> covEntOrgList = new List<Coverage_Entitlement_Org__c>();
            //for(Coverage_Entitlement__c covEnt: covEntList){
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';          
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            covEntOrgList.add(covEntOrg);
            
            Coverage_Entitlement_Org__c covEntOrg1 = new Coverage_Entitlement_Org__c();
            covEntOrg1.Coverage_Entitlement__c= covEnt.id;
            covEntOrg1.Coverage_Entitlement_Type__c= 'Division';   
            covEntOrg1.Org_Hierarchy_Code__c= '85000 - Company Management';
            covEntOrgList.add(covEntOrg1);
            //}
            insert covEntOrgList;
            
            
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            
            // Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'WM';
            //pdu.Employee__c = hrEmp.id;
            // pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            // insert project org level
            
            List<Child_Project_Decisional_Unit__c> projOrgLevelList = new List<Child_Project_Decisional_Unit__c>();
            
            Child_Project_Decisional_Unit__c projOrgLevel0 = new Child_Project_Decisional_Unit__c();
            projOrgLevel0.Decisional_Unit_Type__c = 'Employee';
            projOrgLevel0.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel0);
            
            
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            
            projOrgLevelList.add(projOrgLevel);
            
            
            Child_Project_Decisional_Unit__c projOrgLevel1 = new Child_Project_Decisional_Unit__c();
            projOrgLevel1.Decisional_Unit_Type__c = 'Division';
            projOrgLevel1.Org_Hierarchy_Code__c = '85000 - Company Management';
            projOrgLevel1.Project_Decisional_Unit__c = pdu.id;
            
            projOrgLevelList.add(projOrgLevel1);
            
            insert projOrgLevelList;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert 
            
            List<Severance_And_Release__c> snrList1 = new List<Severance_And_Release__c>();
            
            Severance_And_Release__c snr = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Super_Division__c = '10910',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snrList1.add(snr);
            
            Severance_And_Release__c snr1 = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Division__c = '85000',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snrList1.add(snr1);	
            
            insert snrList1;
            
            System.runAs(thisUser) {
                Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(proj);
                RIF_Custom_Project_Controller customObj = new RIF_Custom_Project_Controller(sc);
                
                customObj.eligibleReadOnlyPDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.eligibleReadWritePDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.isOpsUser=true;  
                customObj.redirect();
                Test.stopTest();
            }
        }
    }
    
    public static testMethod void testMethod3() {
        
        List<Severance_And_Release__c> snrList = new List<Severance_And_Release__c>();    
        //Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
        RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
        testUtil.insertOrgHierarchy();
        
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        System.runAs(thisUser) {
            // Assign permission sets to user
            
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_HR_Compensation' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            
            // Create Employee with above user
            List<Employee__c> emplist = new List<Employee__c>();
            
            Employee__c emp = new Employee__c();
            emp.Name = 'Test Employee_';
            emp.emp_Id__c = '12345' ;
            emp.Job_Country_Job__c = 'USA';
            emp.MS_MSSB__c = 'MSSB';
            emp.Level_Dsc_Job__c = 'Director'; 
            emp.Covenant_Date__c = Date.today();
            emp.Level_Job__c = '123';
            emp.User__c = thisUser.id;
            emp.Super_Division__c= '10910';
            emp.Super_Depart_Org__c ='Super Department';
            emp.Subdept_Org__c = 'Sub Department' ;
            emp.Division_Org__c = 'Division' ;
            emp.Dept_Org__c = 'Department';
            emp.Sub_Depart2_Org__c = 'Sub Department 2' ;
            emp.Cost_Center__c = 'Cost Center' ;
            
            
            
            
            insert emp;
            
            // Assign user with Coverage 
            // List<Coverage_Entitlement__c> covEntList = new List<Coverage_Entitlement__c>();
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            //covEntList.add(covEnt);
            insert covEnt;
            
            List<Coverage_Entitlement_Org__c> covEntOrgList = new List<Coverage_Entitlement_Org__c>();
            //for(Coverage_Entitlement__c covEnt: covEntList){
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';          
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            covEntOrgList.add(covEntOrg);
            
            Coverage_Entitlement_Org__c covEntOrg1 = new Coverage_Entitlement_Org__c();
            covEntOrg1.Coverage_Entitlement__c= covEnt.id;
            covEntOrg1.Coverage_Entitlement_Type__c= 'Division';   
            covEntOrg1.Org_Hierarchy_Code__c= '85000 - Company Management';
            covEntOrgList.add(covEntOrg1);
            //}
            insert covEntOrgList;
            
            
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            
            
            // get hr employee
            
            // Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'WM';
            // pdu.Employee__c = hrEmp.id;
            // pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            // insert project org level
            
            List<Child_Project_Decisional_Unit__c> projOrgLevelList = new List<Child_Project_Decisional_Unit__c>();
            
            Child_Project_Decisional_Unit__c projOrgLevel0 = new Child_Project_Decisional_Unit__c();
            projOrgLevel0.Decisional_Unit_Type__c = 'Employee';
            projOrgLevel0.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel0);
            
            
            
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel);
            
            Child_Project_Decisional_Unit__c projOrgLevel1 = new Child_Project_Decisional_Unit__c();
            projOrgLevel1.Decisional_Unit_Type__c = 'Division';
            projOrgLevel1.Org_Hierarchy_Code__c = '85000 - Company Management';
            projOrgLevel1.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel1);
            
            insert projOrgLevelList;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert 
            
            List<Severance_And_Release__c> snrList1 = new List<Severance_And_Release__c>();
            
            Severance_And_Release__c snr = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Super_Division__c = '10910',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snrList1.add(snr);
            
            Severance_And_Release__c snr1 = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Division__c = '85000',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snrList1.add(snr1);	
            
            insert snrList1;
            
            System.runAs(thisUser) {
                Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(proj);
                RIF_Custom_Project_Controller customObj = new RIF_Custom_Project_Controller(sc);
                
                customObj.eligibleReadOnlyPDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.eligibleReadWritePDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.isOpsUser=true;  
                customObj.redirect();
                Test.stopTest();
            }
        }
    }
    public static testMethod void testMethod4() {
        
       
        RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
        testUtil.insertOrgHierarchy();
        
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        System.runAs(thisUser) {
            // Assign permission sets to user
            
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_Generic_User' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            
            // Create Employee with above user
            List<Employee__c> emplist = new List<Employee__c>();
            
            Employee__c emp = new Employee__c();
            emp.Name = 'Test Employee_';
            emp.emp_Id__c = '12345' ;
            emp.Job_Country_Job__c = 'USA';
            emp.MS_MSSB__c = 'MSSB';
            emp.Level_Dsc_Job__c = 'Director'; 
            emp.Covenant_Date__c = Date.today();
            emp.Level_Job__c = '123';
            emp.User__c = thisUser.id;
            emp.Super_Division__c= '10910';
            emp.Super_Depart_Org__c ='Super Department';
            emp.Subdept_Org__c = 'Sub Department' ;
            emp.Division_Org__c = 'Division' ;
            emp.Dept_Org__c = 'Department';
            emp.Sub_Depart2_Org__c = 'Sub Department 2' ;
            emp.Cost_Center__c = 'Cost Center' ;
            
            
            
            
            insert emp;
            
            // Assign user with Coverage 
            // List<Coverage_Entitlement__c> covEntList = new List<Coverage_Entitlement__c>();
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            //covEntList.add(covEnt);
            insert covEnt;
            
            List<Coverage_Entitlement_Org__c> covEntOrgList = new List<Coverage_Entitlement_Org__c>();
            //for(Coverage_Entitlement__c covEnt: covEntList){
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';          
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            covEntOrgList.add(covEntOrg);
            
            Coverage_Entitlement_Org__c covEntOrg1 = new Coverage_Entitlement_Org__c();
            covEntOrg1.Coverage_Entitlement__c= covEnt.id;
            covEntOrg1.Coverage_Entitlement_Type__c= 'Division';   
            covEntOrg1.Org_Hierarchy_Code__c= '85000 - Company Management';
            covEntOrgList.add(covEntOrg1);
            //}
            insert covEntOrgList;
            
            
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            
            
            
            // get hr employee
            
            // Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'WM';
            // pdu.Employee__c = hrEmp.id;
            // pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            // insert project org level
            
            List<Child_Project_Decisional_Unit__c> projOrgLevelList = new List<Child_Project_Decisional_Unit__c>();
            
            Child_Project_Decisional_Unit__c projOrgLevel0 = new Child_Project_Decisional_Unit__c();
            projOrgLevel0.Decisional_Unit_Type__c = 'Employee';
            projOrgLevel0.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel0);
            
            
            
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel);
            
            Child_Project_Decisional_Unit__c projOrgLevel1 = new Child_Project_Decisional_Unit__c();
            projOrgLevel1.Decisional_Unit_Type__c = 'Division';
            projOrgLevel1.Org_Hierarchy_Code__c = '99190 - Wealth Management Field';
            projOrgLevel1.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel1);
            

            
            insert projOrgLevelList;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert 
            
            List<Severance_And_Release__c> snrList1 = new List<Severance_And_Release__c>();
            
            Severance_And_Release__c snr = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Super_Division__c = '10910',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snrList1.add(snr);
            
            Severance_And_Release__c snr1 = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Division__c = '85000',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snrList1.add(snr1);	
            
            insert snrList1;
            
            
            System.runAs(thisUser) {
                Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(proj);
                RIF_Custom_Project_Controller customObj = new RIF_Custom_Project_Controller(sc);
                
                customObj.eligibleReadOnlyPDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.eligibleReadWritePDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.isGenericUser=true;  
                customObj.redirect();
                Test.stopTest();
                
            }
        }
    }
    
    public static testMethod void testMethod5() {
       
         RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
        testUtil.insertOrgHierarchy(); 
        User thisUser = RIF_TestClassUtilities.getTempUser();
        insert thisUser;
 
        
        System.runAs(thisUser){
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(0,'123451234', 'USA', 'MSSB', 'Director','123');
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
            insert covEntOrg;
           
            
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' 
                             and SobjectType = 'Project__c' limit 1];
            Project__c proj = new Project__c();
            proj.Name = 'testProject';
            proj.Super_Division__c = '10910';
            proj.Status__c = 'Active';
            proj.Primary_Key__c = 'test_1';
            insert proj;
           
            Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(proj);
                RIF_Custom_Project_Controller customObj = new RIF_Custom_Project_Controller(sc);
                
                customObj.eligibleReadOnlyPDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.eligibleReadWritePDU_TO_Share = new List <Project_Decisional_Unit__c>();
                
                customObj.redirect();
            Test.stopTest();
        
        }
    }
        
  /*     public static testMethod void testMethod6() {
       
 User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
           
          User thisUser1 = RIF_TestClassUtilities.getTempUser();
        insert thisUser1;

            RecordType rt1 = [Select Id from RecordType where Name = 'Project Based Termination' 
                             and SobjectType = 'Project__c' limit 1];
            Project__c proj1 = new Project__c();
            proj1.Name = 'testProject';
            proj1.Super_Division__c = '10910';
            proj1.Status__c = 'Active';
            proj1.Primary_Key__c = 'test_1';
            insert proj1;
     
        project__share projshare=new project__share();
        projshare.ParentId=proj1.id;
        projshare.UserOrGroupId=thisuser1.Id;
        projshare.AccessLevel='read';
        
        insert projshare;
            system.debug('projshare'+projshare);
          
    System.runAs(thisUser) {
             Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(proj1);
                RIF_Custom_Project_Controller customObj = new RIF_Custom_Project_Controller(sc);
                
                customObj.eligibleReadOnlyPDU_TO_Share = new List <Project_Decisional_Unit__c>();
                customobj.eligibleReadWritePDU_TO_Share = new List <Project_Decisional_Unit__c>();
                
                
                customObj.redirect();
          
            Test.stopTest();
             
    
}*/

    public static testMethod void testMethod7(){
                
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        User thisUser1 = RIF_TestClassUtilities.getTempUser();
        insert thisUser1;

        RecordType rt1 = [Select Id from RecordType where Name = 'Project Based Termination' 
                             and SobjectType = 'Project__c' limit 1];
            Project__c proj1 = new Project__c();
            proj1.Name = 'testProject';
            proj1.Super_Division__c = '10910';
            proj1.Status__c = 'Active';
            proj1.Primary_Key__c = 'test_1';
            insert proj1;
     
        project__share projshare=new project__share();
        projshare.ParentId=proj1.id;
        projshare.UserOrGroupId=thisuser1.Id;
        projshare.AccessLevel='read';
        
        insert projshare;
system.debug('projshare'+projshare.AccessLevel);
        
        System.runAs(thisUser) {
            // Assign permission sets to user
            
            PermissionSet  ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_HR_Coverage' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
            // Create Employee with above user
            List<Employee__c> emplist = new List<Employee__c>();
            
            Employee__c emp = new Employee__c();
            emp.Name = 'Test Employee_';
            emp.emp_Id__c = '12345' ;
            emp.Job_Country_Job__c = 'USA';
            emp.MS_MSSB__c = 'MSSB';
            emp.Level_Dsc_Job__c = 'Director'; 
            emp.Covenant_Date__c = Date.today();
            emp.Level_Job__c = '123';
            emp.User__c = thisUser.id;
            emp.Super_Division__c= 'Super Divison';
           
            emp.Super_Depart_Org__c ='Super Department';
            emp.Subdept_Org__c = 'Sub Department' ;
            emp.Division_Org__c = 'Division' ;
            emp.Dept_Org__c = 'Department';
            emp.Sub_Depart2_Org__c = 'Sub Department 2' ;
            emp.Cost_Center__c = 'Cost Center' ;
            
            
            insert emp;
            
            
            // Assign user with Coverage 
            // List<Coverage_Entitlement__c> covEntList = new List<Coverage_Entitlement__c>();
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c =emp.id ;
            
            insert covEnt;
            
            List<Coverage_Entitlement_Org__c> covEntOrgList = new List<Coverage_Entitlement_Org__c>();
            //for(Coverage_Entitlement__c covEnt: covEntList){
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';          
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            
            covEntOrgList.add(covEntOrg);
            
            Coverage_Entitlement_Org__c covEntOrg1 = new Coverage_Entitlement_Org__c();
            covEntOrg1.Coverage_Entitlement__c= covEnt.id;
            covEntOrg1.Coverage_Entitlement_Type__c= 'Division';   
            covEntOrg1.Org_Hierarchy_Code__c= '85000 - Company Management';
            covEntOrgList.add(covEntOrg1);
           
            Coverage_Entitlement_Org__c covEntOrg2 = new Coverage_Entitlement_Org__c();
            covEntOrg2.Coverage_Entitlement__c= covEnt.id;
            covEntOrg2.Coverage_Entitlement_Type__c= 'Super Department';   
            covEntOrg2.Org_Hierarchy_Code__c= '25307 - Western';
            covEntOrgList.add(covEntOrg2);
            
            Coverage_Entitlement_Org__c covEntOrg3 = new Coverage_Entitlement_Org__c();
            covEntOrg3.Coverage_Entitlement__c= covEnt.id;
            covEntOrg3.Coverage_Entitlement_Type__c= 'Department';   
            covEntOrg3.Org_Hierarchy_Code__c= '11002 - 1 - Northwest';
            covEntOrgList.add(covEntOrg3);
            
            Coverage_Entitlement_Org__c covEntOrg4 = new Coverage_Entitlement_Org__c();
            covEntOrg4.Coverage_Entitlement__c= covEnt.id;
            covEntOrg4.Coverage_Entitlement_Type__c= 'Sub Department';   
            covEntOrg4.Org_Hierarchy_Code__c= '12255 - CMP008 - San Francisco';
            covEntOrgList.add(covEntOrg4);
            
            Coverage_Entitlement_Org__c covEntOrg5 = new Coverage_Entitlement_Org__c();
            covEntOrg5.Coverage_Entitlement__c= covEnt.id;
            covEntOrg5.Coverage_Entitlement_Type__c= 'Sub Department 2';   
            covEntOrg5.Org_Hierarchy_Code__c= '26424 - BR164-SAN FRANCISCO, CA 2';
            covEntOrgList.add(covEntOrg5);
            
            Coverage_Entitlement_Org__c covEntOrg6 = new Coverage_Entitlement_Org__c();
            covEntOrg6.Coverage_Entitlement__c= covEnt.id;
            covEntOrg6.Coverage_Entitlement_Type__c= 'Cost Center';   
            covEntOrg6.Org_Hierarchy_Code__c= '571195 - SN FRN-CSH MGT (SB)';
            covEntOrgList.add(covEntOrg6);
            
            
            
            //}
            insert covEntOrgList;
            
            
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            
            
            
            // get hr employee
            //Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'WM';
            // pdu.Employee__c = empRec.id;
            // pdu.HR_Signatory__c = empRec.id;
            insert pdu;
            
            // insert project org level
            
            List<Child_Project_Decisional_Unit__c> projOrgLevelList = new List<Child_Project_Decisional_Unit__c>();
            
            Child_Project_Decisional_Unit__c projOrgLevel0 = new Child_Project_Decisional_Unit__c();
            projOrgLevel0.Decisional_Unit_Type__c='Employee';
            projOrgLevel0.Project_Decisional_Unit__c=pdu.id;
            projOrgLevelList.add(projOrgLevel0);
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel);
            
            Child_Project_Decisional_Unit__c projOrgLevel1 = new Child_Project_Decisional_Unit__c();
            projOrgLevel1.Decisional_Unit_Type__c = 'Division';
            projOrgLevel1.Org_Hierarchy_Code__c = '85000 - Company Management';
            projOrgLevel1.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel1);
            
                         Child_Project_Decisional_Unit__c projOrgLevel2 = new Child_Project_Decisional_Unit__c();
            projOrgLevel2.Decisional_Unit_Type__c = 'Super Department';
            projOrgLevel2.Org_Hierarchy_Code__c = '25307 - Western';
            projOrgLevel2.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel2);
            
             Child_Project_Decisional_Unit__c projOrgLevel3 = new Child_Project_Decisional_Unit__c();
            projOrgLevel3.Decisional_Unit_Type__c = 'Department';
            projOrgLevel3.Org_Hierarchy_Code__c = '11002 - 1 - Northwest';
            projOrgLevel3.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel3);
            
             Child_Project_Decisional_Unit__c projOrgLevel4 = new Child_Project_Decisional_Unit__c();
            projOrgLevel4.Decisional_Unit_Type__c = 'Sub Department';
            projOrgLevel4.Org_Hierarchy_Code__c = '12255 - CMP008 - San Francisco';
            projOrgLevel4.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel4);
            
             Child_Project_Decisional_Unit__c projOrgLevel5 = new Child_Project_Decisional_Unit__c();
            projOrgLevel5.Decisional_Unit_Type__c = 'Sub Department 2';
            projOrgLevel5.Org_Hierarchy_Code__c = '26424 - BR164-SAN FRANCISCO, CA 2';
            projOrgLevel5.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel5);
            
              Child_Project_Decisional_Unit__c projOrgLevel6 = new Child_Project_Decisional_Unit__c();
            projOrgLevel6.Decisional_Unit_Type__c = 'Cost Center';
            projOrgLevel6.Org_Hierarchy_Code__c = '571195 - SN FRN-CSH MGT (SB)';
            projOrgLevel6.Project_Decisional_Unit__c = pdu.id;
            projOrgLevelList.add(projOrgLevel6);
            
            insert projOrgLevelList;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
         
          //  List<Severance_And_Release__c> snrList1 = new List<Severance_And_Release__c>();
            
            Severance_And_Release__c snr = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Super_Division__c = '10910',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            insert snr;
          //  snrList1.add(snr);
          snr.OwnerId=thisUser1.Id;
            update snr;

            System.runAs(thisUser) {
                Test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(proj);
                RIF_Custom_Project_Controller customObj = new RIF_Custom_Project_Controller(sc);
   
                
                customObj.redirect();
                
                Test.stopTest();
                
            
        }
        }
}
     
}