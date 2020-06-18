@isTest
public class RIF_Bulk_Create_SR_ProcessorTest{
    
    private static testMethod void bulkCreateSRProcessor () {
        
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
                                      snr.Status__c = 'Selected';
        							  snr.Super_Division__c = '10910';
             						  snr.Project__c = proj.id;
         
         
         insert snr;    
             
                Attachment listAllAttach_At_DecisionalUnits = new Attachment();
        listAllAttach_At_DecisionalUnits.ParentId =proj.Id;
        listAllAttach_At_DecisionalUnits.Name= 'super division';
        listAllAttach_At_DecisionalUnits.Body=Blob.valueOf('Test\n Test\n Test');
        listAllAttach_At_DecisionalUnits.ContentType='text/csv'; 
        insert listAllAttach_At_DecisionalUnits;
        
         PageReference pageRef = Page.RIF_Bulk_Employee_Processor;
         Test.setCurrentPage(pageRef);
         ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
           
          RIF_Bulk_Create_SR_Processor rifclass = new RIF_Bulk_Create_SR_Processor(controller);
           
    Test.startTest();
    rifclass.processBatch();
    rifclass.saveRecords();
    rifclass.exit();
    Test.stoptest();
    }
}
    private static testMethod void Method2 (){
        
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
                                      snr.Status__c = 'Selected';
        							  snr.Super_Division__c = '10910';
             						  snr.Project__c = proj.id;
         
         
         insert snr;    
          String snrId = snr.ID;
          String snrId1 = snrId.substring(0,15);
             
        Attachment listAllAttach_At_DecisionalUnits = new Attachment();
        listAllAttach_At_DecisionalUnits.ParentId =proj.Id;
        listAllAttach_At_DecisionalUnits.Name= 'super division';
        listAllAttach_At_DecisionalUnits.Body=Blob.valueOf('Severance And Release: ID,Emp Id,Employee,Communication Date,Termination Date,Last Day On Premises,Status,Level Desc,Comments,Exhibit A,WARN?,Is employee eligible for rehire?,Communicated,Communicated Date,Communicated Details of Package,Package Receipt Date,Release Returned,Release Returned Date,Is termination related to Project,Work Requirement for Severance,EPK Code,Unused Vacation Days,Overnight Package,Overnight Delivery Date,Sent to LHH,Outplacement,Sent to Workday,HR Contact - Override,HR Signatory - Override \n'+ 
                                                           +snrId1+ ',HRTEST,Harilaos Stefanou,3/2/2018,4/19/2018,3/1/2018,Selected,Non-Exempt,,0,0,1,1,3/1/2018,1,3/14/2018,0,,0,0,,2,0,,0,Milestone Seminar,0,, ');
		listAllAttach_At_DecisionalUnits.ContentType='text/csv'; 
        insert listAllAttach_At_DecisionalUnits;
        
         PageReference pageRef = Page.RIF_Bulk_Employee_Processor;
         pageRef.getParameters().put('mode', 'u');
         Test.setCurrentPage(pageRef);
         ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
           
          RIF_Bulk_Create_SR_Processor rifclass = new RIF_Bulk_Create_SR_Processor(controller);
                                                           
          

           
    Test.startTest();
    rifclass.processBatch();
    rifclass.saveRecords();
    rifclass.exit();
    Test.stoptest();
    }
}
    private static testMethod void Method3 (){
        
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
                                      snr.Status__c = 'Selected';
        							  snr.Super_Division__c = '10910';
             						  snr.Project__c = proj.id;
         
         
         insert snr;    
          String snrId = snr.ID;
          String snrId1 = snrId.substring(0,15);
             
        Attachment listAllAttach_At_DecisionalUnits = new Attachment();
        listAllAttach_At_DecisionalUnits.ParentId =proj.Id;
        listAllAttach_At_DecisionalUnits.Name= 'super division';
        listAllAttach_At_DecisionalUnits.Body=Blob.valueOf('Severance And Release: ID,Emp Id,Employee,Communication Date,Termination Date,Last Day On Premises,Status,Level Desc,Comments,Exhibit A,WARN?,Is employee eligible for rehire?,Communicated,Communicated Date,Communicated Details of Package,Package Receipt Date,Release Returned,Release Returned Date,Is termination related to Project,Work Requirement for Severance,EPK Code,Unused Vacation Days,Overnight Package,Overnight Delivery Date,Sent to LHH,Outplacement,Sent to Workday,HR Contact - Override,HR Signatory - Override \n'+ 
                                                           +snrId1+ ',HRTEST,Harilaos Stefanou,3/2/2018,4/19/2018,3/1/2018,Selected,Non-Exempt,,0,0,1,1,3/1/2018,1,3/14/2018,0,,0,0,,2,0,,0,Milestone Seminar,0,, ');
		listAllAttach_At_DecisionalUnits.ContentType='text/csv'; 
        insert listAllAttach_At_DecisionalUnits;
        
         PageReference pageRef = Page.RIF_Bulk_Employee_Processor;
         pageRef.getParameters().put('mode', 'a');
         Test.setCurrentPage(pageRef);
         ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
           
          RIF_Bulk_Create_SR_Processor rifclass = new RIF_Bulk_Create_SR_Processor(controller);
                                                           
          

           
    Test.startTest();
    rifclass.processBatch();
    rifclass.saveRecords();
    rifclass.exit();
    Test.stoptest();
    }
}
    
    
    
    private static testMethod void Method4 (){
        
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
                                      snr.Status__c = 'Selected';
        							  snr.Super_Division__c = '10910';
             						  snr.Project__c = proj.id;
         
         
         insert snr;    
          String snrid = snr.ID;
          String snrId1 = snrid.substring(0,15);
             
        Attachment listAllAttach_At_DecisionalUnits = new Attachment();
        listAllAttach_At_DecisionalUnits.ParentId =proj.Id;
        listAllAttach_At_DecisionalUnits.Name= 'super division';
        listAllAttach_At_DecisionalUnits.Body=Blob.valueOf('Severance And Release: ID,Emp Id,Employee,Communication Date,Termination Date,Last Day On Premises,Status,Level Desc,Comments,Exhibit A,WARN?,Is employee eligible for rehire?,Communicated,Communicated Date,Communicated Details of Package,Package Receipt Date,Release Returned,Release Returned Date,Is termination related to Project,Work Requirement for Severance,EPK Code,Unused Vacation Days,Overnight Package,Overnight Delivery Date,Sent to LHH,Outplacement,Sent to Workday,HR Contact - Override,HR Signatory - Override \n'+ 
                                                           +',HRTEST,,3/2/2018,4/19/2018,3/1/2018,aaa,,,2,2,2,2,3/1/2018,2,3/14/2018,2,,2,2,,2,2,,2,Milestone Seminar,2,, ');
        listAllAttach_At_DecisionalUnits.ContentType='text/csv';
        insert listAllAttach_At_DecisionalUnits;
        
         PageReference pageRef = Page.RIF_Bulk_Employee_Processor;
         pageRef.getParameters().put('mode', 'u');
         Test.setCurrentPage(pageRef);
         ApexPages.StandardController controller = new  ApexPages.StandardController(proj);
           
          RIF_Bulk_Create_SR_Processor rifclass = new RIF_Bulk_Create_SR_Processor(controller);
                                                           
          

           
    Test.startTest();
    rifclass.processBatch();
    rifclass.saveRecords();
    rifclass.exit();
    Test.stoptest();
    }
}
   
  
}