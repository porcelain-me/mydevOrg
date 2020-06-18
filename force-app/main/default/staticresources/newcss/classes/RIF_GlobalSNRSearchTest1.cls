/* Class covers RIF_GlobalSNRSearch class */
@isTest
public class RIF_GlobalSNRSearchTest1 {  
    public static User tempUser = new User();
    public static User tempUser1 = new User();
    
    @isTest
    public static void test_RIF_GlobalSNRSearch(){
        Integer randSeed = Crypto.getRandomInteger();
        String seed = String.valueOf(randSeed).substring(0,5);
        tempUser = RIF_TestClassUtilities.getALLMSUser();
        tempUser.Username = seed + '@tester.com.fake';
        insert tempUser;  
        
        // another All MS Employee - this HR user will manually share the project with the 'tempUser'
        Integer randSeed1 = Crypto.getRandomInteger();
        String seed1 = String.valueOf(randSeed1).substring(0,5);
        tempUser1 = RIF_TestClassUtilities.getALLMSUser();
        tempUser1.Username = seed1 + '@tester.com.fake';
        insert tempUser1; 
        
        
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_System_Admin' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = tempUser.id, PermissionSetId = ps.Id );
            // other All MS Employee user, assign the 'RIF System Admin' perm set
            insert new PermissionSetAssignment(AssigneeId = tempUser1.id, PermissionSetId = ps.Id );
            // insert new Project/SNR and then share it with tempUser
            shareProject(tempUser1.Id);
        
            system.runAs(tempUser){
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(345,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = tempUser.id;
            emp.Super_Division__c = '10910';
            emp.DOH_Recent__c = Date.newInstance(2010, 01, 01);
            insert emp;
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c = 'Super Division';
            covEntOrg.Org_Hierarchy_Code__c	 = '10910 - Wealth Management';
            insert covEntOrg;
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            RecordType snrRT = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(345, rt.Id );
            proj.Status__c = 'Active';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(345, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            // insert pdu
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'Test- PDU ' + Math.random();           
            insert pdu;
            // insert SNR
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, snrRT.Id);
            snr.Project__c = proj.id;
            snr.Super_Division__c = '10910';
            snr.Last_Day_On_Premises__c = date.today().addDays(30);
            insert snr;

            Date date1 = Date.newInstance(2017, 01, 01);
            Date date2 = Date.newInstance(2017, 12, 31);
            Severance_and_Release__c tempSNR = new Severance_and_Release__c(Created_Date_From__c = date1, Created_Date_To__c = date2);
            Test.startTest();
            // load the page
            PageReference thePage = Page.RIF_GlobalSNRSearchPage;
            Test.setCurrentPage(thePage);
            // load the constructor
            RIF_GlobalSNRSearch theConst = new RIF_GlobalSNRSearch();
            //theConst.projectType = 'Project';
            theConst.projectName = 'test';
            theConst.snrCreatedFrom = tempSNR;
            theConst.snrCreatedTo = tempSNR;
            List<SelectOption> opts = theConst.getPrjStatusOptions();
            List<SelectOption> opts1 = theConst.getProjectSelections();
            theConst.OFFSET = 0;
            theConst.search();
            theConst.clear();
            //theConst.previous();
            theConst.first();
            theConst.next();
            theConst.last();
            theConst.getDisableNext();
            theConst.getDisablePrevious();
            Test.stopTest();            
        }
        
    }
    
    // this method will share the project with the 'tempUser'
    public static void shareProject(String userId){
        system.runAs(tempUser1){
            Integer randSeed = Crypto.getRandomInteger();
            String seed = String.valueOf(randSeed).substring(1,4);
            Integer intSeed = Integer.valueOf(seed);
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(intSeed,String.valueOf(intSeed), 'USA', 'MSSB', 'Director','123');
            emp.User__c = tempUser1.id;
            emp.Super_Division__c = '10910';
            emp.DOH_Recent__c = Date.newInstance(2010, 01, 01);
            insert emp;
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c = 'Super Division';
            covEntOrg.Org_Hierarchy_Code__c	 = '10910 - Wealth Management';
            insert covEntOrg;
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            RecordType snrRT = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(intSeed, rt.Id );
            proj.Status__c = 'Active';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(intSeed, 'USA', 'MSSB', 'VP', String.valueOf(intSeed));
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            // insert pdu
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'Test- PDU ' + Math.random();           
            insert pdu;
            // insert SNR
            Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, snrRT.Id);
            snr.Project__c = proj.id;
            snr.Super_Division__c = '10910';
            snr.Division__c = '10910';
            snr.Super_Department__c = '10910';
            snr.Department__c = '10910';
            snr.Sub_Department__c = '10910';
            snr.Sub_Department_2__c = '10910';
            snr.Cost_Center__c = '10910';
            snr.Last_Day_On_Premises__c = date.today().addDays(30);
            insert snr;
            system.debug(' -- snr -- ' + snr);
            
            // share the project with 'tempUser'
            Project__share sharePrj = new Project__share();
            sharePrj.UserOrGroupId = tempUser.Id;
            sharePrj.AccessLevel = 'Edit';
            sharePrj.ParentId = proj.Id;
            insert sharePrj;  
            
            Severance_and_Release__share snrPrj = new Severance_and_Release__share();
            snrPrj.UserOrGroupId = tempUser.Id;
            snrPrj.AccessLevel = 'Edit';
            snrPrj.ParentId = snr.Id;
            insert snrPrj;   
        }
        
    }
    
}