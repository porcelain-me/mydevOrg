@isTest
public class RIF_AgeAckTestClass{
    public static RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
    public static  User tempU;
	  public static void setupData(){
        tempU = new User();
        //tempU = testUtil.createUser();
        tempU = testUtil.createUser2();
    }
	public static testmethod void testMethod3()
    {
        
        /*  Remove this
        
       setupData();
        system.runAs(tempU){
            Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
            Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            Employee__c emp1 = testUtil.createEmployeeFromUser(tempU);
            testUtil.insertOrgHierarchy();      
            
           testUtil.createCoverageEntitlements(emp1); 
			
            
            
             Employee__c emp1 = new Employee__c();
            emp1.emp_id__c = 'MS12';
            emp1.name = 'Test';
            emp1.Level_Dsc_Job__c = 'Professional';
            emp1.Level_Job__c = '30';
            emp1.MS_MSSB__c = 'MSSB';
            emp1.Job_Country_Job__c  = 'USA';
            emp1.Status__c = 'Active';
            emp1.Super_Division__c = '10910';
            emp1.Dept_Org__c='81200';
            insert  emp1;
            
            
            
             Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;        
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Super_Division__c = '10910';
             						snr.Project__c = proj.id;
         
         
         insert snr;
        
         till here */
        
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_System_Admin'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        
       PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         System.runAs (tempHR) {
       
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Super_Division__c = '10910';
             						snr.Project__c = proj.id;
         
         
         insert snr;
        
        // above this is new
         
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
            
            List<Child_Project_Decisional_Unit__c> listchildPDU = new List<Child_Project_Decisional_Unit__c>();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Super Division';
        NewChildPDU.Org_Hierarchy_Code__c = '10910 - Wealth Management';
        NewChildPDU.ProjectID__c=proj.Id;
            listchildPDU.add(NewChildPDU);
        //NewChildPDU.decisional_unit_type__c = 'Department';
     
            
  	  /*Child_Project_Decisional_Unit__c NewChildPDU1 = new Child_Project_Decisional_Unit__c();
        NewChildPDU1.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU1.Org_Hierarchy_Code__c = '11002 - 1 - Northwest';
        NewChildPDU1.ProjectID__c=proj.Id;
        NewChildPDU1.decisional_unit_type__c = 'Department';
            
        listchildPDU.add(NewChildPDU1);*/
        insert listchildPDU;
            
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
            //rifclass.generate();
            
         rifclass.selectedPDU ='All';
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.getEmployees();
             rifclass.exit();
             rifclass.start();
          
            
        }
    }
    
    public static testmethod void testMethod4()
    {
 
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_System_Admin'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        
       PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         System.runAs (tempHR) {
       
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Super_Division__c = '10910';
             						snr.Division__c = '99190';
             						snr.Project__c = proj.id;
         
         
         insert snr;
                 
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
            
            List<Child_Project_Decisional_Unit__c> listchildPDU = new List<Child_Project_Decisional_Unit__c>();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Division';
        NewChildPDU.Org_Hierarchy_Code__c = '99190 - Wealth Management Field';
        NewChildPDU.ProjectID__c=proj.Id;
            listchildPDU.add(NewChildPDU);
      
        insert listchildPDU;
            
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
            //rifclass.generate();
            
         rifclass.selectedPDU ='All';
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.getEmployees();
             rifclass.exit();
             rifclass.start();
          
            
        }
    }
    
    public static testmethod void testMethod5()
    {
 
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_System_Admin'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        
       PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         System.runAs (tempHR) {
       
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Super_Division__c = '10910';
             						snr.Division__c = '99190';
             						snr.Super_Department__c = '25307';
             						snr.Project__c = proj.id;
         
         
         insert snr;
                 
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
            
            List<Child_Project_Decisional_Unit__c> listchildPDU = new List<Child_Project_Decisional_Unit__c>();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Super Department';
        NewChildPDU.Org_Hierarchy_Code__c = '25307 - Western';
        NewChildPDU.ProjectID__c=proj.Id;
            listchildPDU.add(NewChildPDU);
      
        insert listchildPDU;
            
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
            //rifclass.generate();
            
         rifclass.selectedPDU ='All';
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.getEmployees();
             rifclass.exit();
             rifclass.start();
          
            
        }
    }
    
    public static testmethod void testMethod6()
    {
 
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_System_Admin'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        
       PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         System.runAs (tempHR) {
       
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Department__c = '11001';
             						snr.Project__c = proj.id;
         
         
         insert snr;
                 
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
            
            List<Child_Project_Decisional_Unit__c> listchildPDU = new List<Child_Project_Decisional_Unit__c>();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Department';
        NewChildPDU.Org_Hierarchy_Code__c = '11001 - 2 - Pacific Coast';
        NewChildPDU.ProjectID__c=proj.Id;
            listchildPDU.add(NewChildPDU);
      
        insert listchildPDU;
            
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
            //rifclass.generate();
            
         rifclass.selectedPDU ='All';
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.getEmployees();
             rifclass.exit();
             rifclass.start();
          
            
        }
    }
    
       public static testmethod void testMethod7()
    {
 
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_System_Admin'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        
       PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         System.runAs (tempHR) {
       
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Sub_Department__c = '11020';
             						snr.Project__c = proj.id;
         
         
         insert snr;
                 
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
            
            List<Child_Project_Decisional_Unit__c> listchildPDU = new List<Child_Project_Decisional_Unit__c>();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Sub Department';
        NewChildPDU.Org_Hierarchy_Code__c = '11020 - Europe';
        NewChildPDU.ProjectID__c=proj.Id;
            listchildPDU.add(NewChildPDU);
      
        insert listchildPDU;
            
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
            //rifclass.generate();
            
         rifclass.selectedPDU ='All';
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.getEmployees();
             rifclass.exit();
             rifclass.start();
          
            
        }
    }
    
    public static testmethod void testMethod8()
    {
 
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_System_Admin'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        
       PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         System.runAs (tempHR) {
       
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Sub_Department_2__c = '98110';
             						snr.Project__c = proj.id;
         
         
         insert snr;
                 
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
            
            List<Child_Project_Decisional_Unit__c> listchildPDU = new List<Child_Project_Decisional_Unit__c>();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Sub Department 2';
        NewChildPDU.Org_Hierarchy_Code__c = '98110 - Prime Client Service Tech2';
        NewChildPDU.ProjectID__c=proj.Id;
            listchildPDU.add(NewChildPDU);
      
        insert listchildPDU;
            
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
            //rifclass.generate();
            
         rifclass.selectedPDU ='All';
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.getEmployees();
             rifclass.exit();
             rifclass.start();
          
            
        }
    }
    
    public static testmethod void testMethod9()
    {
 
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_System_Admin'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
        
       PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         System.runAs (tempHR) {
       
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Cost_Center__c = '100626';
             						snr.Project__c = proj.id;
         
         
         insert snr;
                 
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
            
            List<Child_Project_Decisional_Unit__c> listchildPDU = new List<Child_Project_Decisional_Unit__c>();
        Child_Project_Decisional_Unit__c NewChildPDU = new Child_Project_Decisional_Unit__c();
        NewChildPDU.Project_Decisional_Unit__c = newPDU.Id;
        NewChildPDU.Decisional_Unit_Type__c = 'Cost Center';
        NewChildPDU.Org_Hierarchy_Code__c = '100626 - CHERRY HILL, NJ';
        NewChildPDU.ProjectID__c=proj.Id;
            listchildPDU.add(NewChildPDU);
      
        insert listchildPDU;
            
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
            //rifclass.generate();
            
         rifclass.selectedPDU ='All';
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.getEmployees();
             rifclass.exit();
             rifclass.start();
          
            
        }
    }
    
    
   
    public static testmethod void testMethod1()
    {
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_HR_Coverage'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
      
        
        PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;        
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Super_Division__c = '10910';
             						snr.Project__c = proj.id;
         
         
         insert snr;
         
        RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
        w.dept_org__c = '10910';
        w.super_division__c = '10910';
        w.division_org__c = '10910';
        w.super_depart_org__c = '10910';
        w.subdept_org__c = '10910';
        w.sub_depart2_org__c = '10910';
        w.cost_center__c = '10910';
        w.employee__c = emp1.id;
        w.project__c = proj.id;
        //w.Project_Decisional_Org_Level__c = c.id;
        w.Project_Decisional_Unit__c = newPDU.Id;
        //w.org_codes__c = c.decisional_unit_code__c;
        //w.level__c = c.decisional_unit_type__c;
        w.type__c = 'Criteria';
        w.Severance_And_Release__c= snr.ID;
        w.conductor_processed__c=false;
        insert w;
        
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
        rifclass.processBatch();
            //rifclass.getEmployees();
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.exit();
             rifclass.start();
        }

    }
    
     public static testmethod void testMethod2()
    {
        Project_Decisional_Unit__c newPDU = new Project_Decisional_Unit__c();
        RIF_OrgHierarchy_TestUtil riforg = new RIF_OrgHierarchy_TestUtil();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       

        Profile p = new Profile();
        p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1];
        PermissionSet ps = new PermissionSet();
        ps = [SELECT Id,Name FROM PermissionSet WHERE Name = 'RIF_HR_Coverage'];
        User tempHR  = new User(Alias = 'standtHR', Email='SysHR@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='HR test',LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, Emp_Id__c = 'HRTEST', 
                               TimeZoneSidKey='America/Los_Angeles', UserName='SysHR@testorg.com');
        insert tempHR;
      
         System.runAs (thisUser) {
        PermissionSetAssignment psAsg = new PermissionSetAssignment(AssigneeId = tempHR.Id,PermissionSetId = ps.Id);
        insert psAsg;
        
         Employee__c emp1 = new Employee__c(Name = tempHR.Name,Emp_ID__c = tempHR.Emp_Id__c,Status__c = 'Active',User__c = tempHR.Id, Dept_Org__c='81200');
        insert emp1;
      
        //RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
     	Id rt =  Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Project Based Termination').getRecordTypeId();
            
        Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj;  
            
        Project__c proj1 = RIF_TestClassUtilities.createTestProject(0, rt );
        insert proj1; 
            
        newPDU.Employee__c = emp1.Id;
        newPDU.HR_Signatory__c = emp1.Id;
        newPDU.Decisional_Unit_Name__c = 'Test One';
        newPDU.Project__c = proj.id;
        insert newPDU;
        
       
            
         Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
         Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
         Severance_And_Release__c snr = new Severance_And_Release__c();
                                      snr.Project_Level__c = pl.id;
                                      snr.Employee__c = emp1.ID;
                                      //recordTypeId = recordTypeId,
                                      snr.Status__c = 'Selected';
        							 snr.Super_Division__c = '10910';
             						snr.Project__c = proj.id;
         
         
         insert snr;
         
            List<RIF_Age_Ack_Work__c> wlist = new List<RIF_Age_Ack_Work__c>();
            for(Integer i =0; i<1002 ; i++)
            {
                RIF_Age_Ack_Work__c w = new RIF_Age_Ack_Work__c(); 
                w.dept_org__c = '10910';
                w.super_division__c = '10910';
                w.division_org__c = '10910';
                w.super_depart_org__c = '10910';
                w.subdept_org__c = '10910';
                w.sub_depart2_org__c = '10910';
                w.cost_center__c = '10910';
                w.employee__c = emp1.id;
                w.project__c = proj.id;
                //w.Project_Decisional_Org_Level__c = c.id;
                w.Project_Decisional_Unit__c = newPDU.Id;
                //w.org_codes__c = c.decisional_unit_code__c;
                //w.level__c = c.decisional_unit_type__c;
                w.type__c = 'Criteria';
                w.Severance_And_Release__c= snr.ID;
                w.conductor_processed__c=false;
                wlist.add(w);
            }
            
        RIF_Age_Ack_work__c w1 = new RIF_Age_Ack_work__c(); 
        w1.dept_org__c = '10910';
        w1.super_division__c = '10910';
        w1.division_org__c = '10910';
        w1.super_depart_org__c = '10910';
        w1.subdept_org__c = '10910';
        w1.sub_depart2_org__c = '10910';
        w1.cost_center__c = '10910';
        w1.employee__c = emp1.id;
        w1.project__c = proj1.id;
        //w1.Project_Decisional_Org_Level__c = c.id;
        w1.Project_Decisional_Unit__c = newPDU.Id;
        //w1.org_codes__c = c.decisional_unit_code__c;
        //w1.level__c = c.decisional_unit_type__c;
        w1.type__c = 'Criteria';
        w1.Severance_And_Release__c= snr.ID;
        w1.conductor_processed__c=false;
          wlist.add(w1);
            insert wlist;
        
        PageReference pageRef = Page.Rif_ageack;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
        
        Rif_ageack rifclass = new Rif_ageack(controller);
        rifclass.processBatch();
            //rifclass.getEmployees();
            Rif_ageack.wrapEmployee wr = new Rif_ageack.wrapEmployee(emp1,w1) ;
            wr.ageAtTermination='29';
             List<Rif_ageack.wrapEmployee> wrlist = new List<Rif_ageack.wrapEmployee>() ;
            wrlist.add(wr);
            rifclass.saveData(wrlist);
            rifclass.generate();
             rifclass.exit();
             rifclass.start();
        }

    }
}