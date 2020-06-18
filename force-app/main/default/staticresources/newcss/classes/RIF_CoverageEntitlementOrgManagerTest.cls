@istest
public class RIF_CoverageEntitlementOrgManagerTest {
    public static User tempU;
    public static RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
    public static Severance_And_Release__c snr;
    Public static Severance_and_Release__share shared;
   // public static 
    public static void setupData(){
        
        Employee__c emp = new Employee__c();
        emp.emp_id__c = 'MS12';
        emp.name = 'Test';
        emp.Level_Dsc_Job__c = 'Professional';
        emp.Level_Job__c = '30';
        emp.MS_MSSB__c = 'MSSB';
        emp.Job_Country_Job__c  = 'USA';
        emp.Status__c = 'active';
        emp.Super_Division__c = '10910';
        insert  emp;
        
        testUtil.createCoverageEntitlements(emp);
        
        Project__c proj = new Project__c();
        //proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
        proj.name = 'Test Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        insert proj ;
        
        //Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR(); 
        //snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rt.Id);
        snr = new Severance_And_Release__c();
        snr.Super_Division__c = '10910';
        snr.Project__c = proj.id;
        snr.Emp_Id__c = emp.id;
       
        insert snr;
            
    }
    public static testMethod void getSNRDetails_test(){
        setupData();
         
        Set<string> SetSr = new Set<string>();
        SetSr.add(snr.id);
    
        Test.startTest();
        RIF_CoverageEntitlementOrgManager.getSNRDetails(Setsr);
        test.stopTest(); 
    }
    
    public static testMethod void getAllSharedSNRs_test(){
        setupData();
		//snr.OwnerId        
        
       User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        Shared = new Severance_and_Release__share();
        shared.AccessLevel= 'Edit';
        shared.ParentId = snr.id;
        shared.RowCause = 'Manual';
        shared.UserOrGroupId = thisUser.Id;
        insert shared;
        
        Set<string> SetOwner = new Set<string>();
       	SetOwner.add(snr.ownerid);
        //SetOwner.add(shared.Id);
        Test.startTest();
        RIF_CoverageEntitlementOrgManager.getAllSharedSNRs(SetOwner);
        test.stopTest(); 
    }
    public static testmethod void deleteSNRAccessForUsers_test(){
        setupData();
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        Shared = new Severance_and_Release__share();
        shared.AccessLevel= 'Edit';
        shared.ParentId = snr.id;
        shared.RowCause = 'Manual';
        shared.UserOrGroupId = thisUser.Id;
        insert shared;
        List<Severance_and_Release__share>  SnRList = new List<Severance_and_Release__share>();
        SnRList.add(shared);
        Test.startTest();
        RIF_CoverageEntitlementOrgManager.deleteSNRAccessForUsers(SnRList);
        Test.stopTest();
    }
    public static testmethod void changeOwnershipOfSNRs_test(){
      /*Employee__c emp = new Employee__c();
        emp.emp_id__c = 'MS12';
        emp.name = 'Test';
        emp.Level_Dsc_Job__c = 'Professional';
        emp.Level_Job__c = '30';
        emp.MS_MSSB__c = 'MSSB';
        emp.Job_Country_Job__c  = 'USA';
        emp.Status__c = 'active';
        emp.Super_Division__c = '10910';
        insert  emp;
        Project__c proj = new Project__c();
        //proj.RecordTypeId  = [Select Id,SobjectType,Name From RecordType WHere Name ='Project Based Termination' and SobjectType ='Project__c'].Id;
        proj.name = 'Test Project' ;
        proj.Country__c = 'USA' ; 
        proj.Status__c = 'Active' ;
        proj.Communication_Date__c  = Date.today();
        proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
        insert proj ;*/
        
        snr = new Severance_And_Release__c();
        snr.Super_Division__c = '10910';
        //snr.Project__c = proj.id;
        //snr.Emp_Id__c = emp.id;
       
        insert snr;
       
        List<Severance_and_Release__c> Snrlistaffected = new List<Severance_and_Release__c>();
        Snrlistaffected.add(snr);
        
        RIF_Master_Settings__c settings = new RIF_Master_Settings__c();
        settings.Default_RIF_System_Admin__c='Sagarika Padhy';
      settings.Name ='Settings';
        insert settings;
        
        test.startTest();
        RIF_CoverageEntitlementOrgManager.changeOwnershipOfSNRs(Snrlistaffected);
        Test.stopTest();
    }
    /*public static testmethod void changeOwnershipOfSNRs_test1(){
         snr = new Severance_And_Release__c();
        snr.Super_Division__c = '10910';
        //snr.Project__c = proj.id;
        //snr.Emp_Id__c = emp.id;
       
        insert snr;
       
        List<Severance_and_Release__c> Snrlistaffected1 = new List<Severance_and_Release__c>();
        Snrlistaffected1.add(snr);
        
        RIF_Master_Settings__c settings = new RIF_Master_Settings__c();
        settings.Default_RIF_System_Admin__c='';
     //settings.SetupOwnerId = '';
     User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
     settings.Name ='Settings';
settings.SetupOwnerId = snr.id;
        insert settings;
        
        test.startTest();
        RIF_CoverageEntitlementOrgManager.changeOwnershipOfSNRs(Snrlistaffected1);
        Test.stopTest();
        
    }*/
public static testmethod void deleteResults_test(){
    setupData();
User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
    Shared = new Severance_and_Release__share();
        shared.AccessLevel= 'Edit';
        shared.ParentId = snr.id;
        shared.RowCause = 'Manual';
        shared.UserOrGroupId = thisUser.Id;
        insert shared;
    List<SObject> listsobject = new List<SObject>();
    listsobject.add(Shared);
    test.startTest();
    RIF_CoverageEntitlementOrgManager.deleteResults(listsobject);
    Test.stopTest();
}
    Public static testmethod void updateResults_test(){
     setupData();
     List<SObject> lstSObj = new List<SObject>();
     lstSObj.add(snr);
     test.startTest();
     RIF_CoverageEntitlementOrgManager.updateResults(lstSObj);
     test.stopTest();
    }
    public static testmethod void insertResults_test(){
        setupData();
       List<SObject> lstSObjInsert = new List<SObject> ();
        lstSObjInsert.add(snr);
        test.startTest();
        RIF_CoverageEntitlementOrgManager.insertResults(lstSObjInsert);
        test.stopTest();
    }
    
    public static testmethod void shareAllSNRsWithUser_test(){
        setupdata();
      
       /* //Coverage_Entitlement_Org__c covEnt 
        
        Coverage_Entitlement_Org__c newCovEnt = new Coverage_Entitlement_Org__c();
        newCovEnt.Coverage_Entitlement__c = newCovEnt.Id;
        newCovEnt.Coverage_Entitlement_Type__c = 'Super Division';
        newCovEnt.Org_Hierarchy_Code__c = '10200 - Operations';
        insert newCovEnt;
           //Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
           // covEnt.HR_Name__c = emp.id;
            //insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= newCovEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
           
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            insert covEntOrg;*/
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
            
        
        Map<Id,Coverage_Entitlement_Org__c> newCovEntsMap = new Map<Id,Coverage_Entitlement_Org__c>();      
       newCovEntsMap.put(covEntOrg.id, covEntOrg);
        test.startTest();
        RIF_CoverageEntitlementOrgManager.shareAllSNRsWithUser(newCovEntsMap);
        test.stopTest();
    }

    
    }
    public static testmethod void createNewSharedRecords(){
        setupdata();
         User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
    Map<String,Set<String>> newUsersMap = new Map<String,Set<String>>();
        /* Set<Severance_And_Release__c>  SnRset = new Set<Severance_And_Release__c>();
            SnRset.add(snr);
            insert SnRset;*/
   // newUsersMap.put(snr.id, thisUser);
     test.startTest();
       RIF_CoverageEntitlementOrgManager.createNewSharedRecords(newUsersMap); 
        test.stopTest();
    }
    
}