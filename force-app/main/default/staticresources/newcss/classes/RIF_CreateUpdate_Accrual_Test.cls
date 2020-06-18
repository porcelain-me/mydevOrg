@isTest(seealldata=true)
public without Sharing class RIF_CreateUpdate_Accrual_Test {
    
    private String sessionId = UserInfo.getSessionId();
    
    public static Severance_And_Release__c testCreateSnR() {
        
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
        }
        
        return snr;
    }
    /*
    private static testMethod void testMethod1() {
        
        Date thisDate = Date.today();
        
        Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        sr.Communicated_Date__c = Date.newInstance(thisDate.year(), thisDate.month(), (thisDate.day()-2));
        sr.Communicated__c = true;
        sr.Severance_Package_Communicated__c = true;
        sr.Package_Receipt_Date__c = Date.today();
        sr.status__c = 'Not Selected';
        insert sr;
        
        Map<id,Severance_And_Release__c> oldMap = new Map<Id,Severance_And_Release__c>(
            [SELECT id, Name, Communicated_Date__c, Termination_Date__c, Last_Day_On_Premises__c, DOH_Recent__c, status__c,
            Base_Salary_Override__c, Notice_Amount_Override__c, Basic_Severance_Local_Override__c, Communicated__c, 
            Additional_Notice_Override__c, Additional_Severance_Override1__c, Enhanced_Severance_Local_Override__c,
            Cobra_Override__c, Communicated_Details_of_Package__c, Release_Returned__c, Work_Requirement_for_Severance__c,
            EMp_Id__C, Project__c, Historical_Data_Load__c,Severance_Package_Communicated__c,Package_Receipt_Date__c FROM Severance_And_Release__c WHERE id = :sr.Id LIMIT 1]);
        
        sr.Communicated_Date__c = thisDate;
        sr.Termination_Date__c = thisDate.addDays(28);
        sr.Last_Day_On_Premises__c = thisDate.addDays(28);
        sr.Notice_Days_Override__c = '2';
        update sr;
        
        System.debug('Project-' + sr.project__C);
        List<Severance_And_Release__c> srList = [SELECT id, Name, Communicated_Date__c, Termination_Date__c, daily_rate__c,
                                                 Last_Day_On_Premises__c, DOH_Recent__c, Base_Salary_Override__c,
                                                 Additional_Notice__c, Notice_Amount_Override__c, Basic_Severance_Local_Override__c, 
                                                 Additional_Severance1__c, Additional_Notice_Override__c, 
                                                 Additional_Severance_Override1__c,Basic_Severance_Local__c, 
                                                 Enhanced_Severance_Local_Override__c, Cobra_Override__c,  status__c,Cobra__c,
                                                 Communicated_Details_of_Package__c, Release_Returned__c, Communicated__c,
                                                 Work_Requirement_for_Severance__c, EMp_Id__C, Project__c,
                                                 Historical_Data_Load__c, Buy_Out_of_Notice_Period_Lcl__c,
                                                 Buy_Out_of_Termination__c, Consultation_End_Date__c,Notice_Days_Override__c,
                                                 Consultation_Start_Date__c,Cost_Center__c, Cost_Center_Desc__c, 
                                                 Additional_Notice_Amount__c, Additional_Notice_Amount_Override__c, 
                                                 Department__c, Department_Desc__c, Division__c, Division_Desc__c, 
                                                 Enhanced_Severance_Local__c,Ex_Gracia_Cash_Payment__c, Last_Edited_Date__c,
                                                 Accrual_Type__c, Notice_Amount__c, Notice_Days_1__c,
                                                 Pay_in_Lieu_of_Benefits_Local__c,Pension_Contribution__c,Social_Insurance__c,
                                                 Statutory_Redundancy_Pay__c,Super_Department__c, Super_Department_Desc__c,
                                                 Super_Division__c, Super_Division_Desc__c,Termination_Bonus__c,
                                                 Voluntary_Involuntary_Flg__c,Severance_Package_Communicated__c,Package_Receipt_Date__c FROM 
                                                 Severance_And_Release__c WHERE id = :sr.Id LIMIT 1];
        
        Map<id,Severance_And_Release__c> newMap = new Map<Id,Severance_And_Release__c>(
            [SELECT id, Name, Communicated_Date__c, Termination_Date__c, Last_Day_On_Premises__c, DOH_Recent__c, status__c,
            Base_Salary_Override__c, Notice_Amount_Override__c, Basic_Severance_Local_Override__c, Communicated__c,
            Additional_Notice_Override__c, Additional_Severance_Override1__c, Enhanced_Severance_Local_Override__c,
            Cobra_Override__c, Communicated_Details_of_Package__c, Release_Returned__c, Work_Requirement_for_Severance__c,
            EMp_Id__C, Project__c, Historical_Data_Load__c,Severance_Package_Communicated__c,Package_Receipt_Date__c FROM Severance_And_Release__c WHERE id = :sr.Id LIMIT 1]);
        
        Test.startTest();
        
        	RIF_CreateUpdate_Accrual.createUpdateAccrual(srList, oldMap, newMap);
        
        Test.stopTest();
        
    }
    */
    private static testMethod void testMethod2() {
        
        Date thisDate = Date.today();
        
        Severance_And_Release__c sr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        sr.Communicated_Date__c = Date.newInstance(thisDate.year(), thisDate.month(), (thisDate.day()-2));
        sr.Communicated__c = true;
        sr.Severance_Package_Communicated__c = true;
        sr.Package_Receipt_Date__c = Date.today();
        insert sr;
        
        Map<id,Severance_And_Release__c> oldMap = new Map<Id,Severance_And_Release__c>(
            [SELECT id, Communication_Date__c,Name, Communicated_Date__c, Termination_Date__c, Last_Day_On_Premises__c, DOH_Recent__c, status__c,
            Base_Salary_Override__c, Notice_Amount_Override__c, Basic_Severance_Local_Override__c, Communicated__c,
            Additional_Notice_Override__c, Additional_Severance_Override1__c, Enhanced_Severance_Local_Override__c,
            Cobra_Override__c, Communicated_Details_of_Package__c, Release_Returned__c, Work_Requirement_for_Severance__c,
            EMp_Id__C, Project__c, Historical_Data_Load__c,Severance_Package_Communicated__c,Package_Receipt_Date__c FROM Severance_And_Release__c WHERE id = :sr.Id LIMIT 1]);
        
        sr.Communicated_Date__c = thisDate;
        sr.Termination_Date__c = thisDate.addDays(28);
        sr.Last_Day_On_Premises__c = thisDate.addDays(28);
        sr.Notice_Days_Override__c = '2';
        update sr;
        
        List<Severance_And_Release__c> srList = [SELECT id,Communication_Date__c, Name, Communicated_Date__c, Termination_Date__c, daily_rate__c,
                                                 Last_Day_On_Premises__c, DOH_Recent__c, Base_Salary_Override__c,
                                                 Additional_Notice__c, Notice_Amount_Override__c, Basic_Severance_Local_Override__c, 
                                                 Additional_Severance1__c, Additional_Notice_Override__c, 
                                                 Additional_Severance_Override1__c,Basic_Severance_Local__c, 
                                                 Enhanced_Severance_Local_Override__c, Cobra_Override__c,  status__c,Cobra__c,
                                                 Communicated_Details_of_Package__c, Release_Returned__c, Communicated__c,
                                                 Work_Requirement_for_Severance__c, EMp_Id__C, Project__c,
                                                 Historical_Data_Load__c, Buy_Out_of_Notice_Period_Lcl__c,
                                                 Buy_Out_of_Termination__c, Consultation_End_Date__c,Notice_Days_Override__c,
                                                 Consultation_Start_Date__c,Cost_Center__c, Cost_Center_Desc__c, 
                                                 Additional_Notice_Amount__c, Additional_Notice_Amount_Override__c, 
                                                 Department__c, Department_Desc__c, Division__c, Division_Desc__c, 
                                                 Enhanced_Severance_Local__c,Ex_Gracia_Cash_Payment__c, Last_Edited_Date__c,
                                                 Accrual_Type__c, Notice_Amount__c, Notice_Days_1__c,
                                                 Pay_in_Lieu_of_Benefits_Local__c,Pension_Contribution__c,Social_Insurance__c,
                                                 Statutory_Redundancy_Pay__c,Super_Department__c, Super_Department_Desc__c,
                                                 Super_Division__c, Super_Division_Desc__c,Termination_Bonus__c,
                                                 Voluntary_Involuntary_Flg__c,Severance_Package_Communicated__c,Package_Receipt_Date__c FROM 
                                                 Severance_And_Release__c WHERE id = :sr.Id LIMIT 1];
        
        Map<id,Severance_And_Release__c> newMap = new Map<Id,Severance_And_Release__c>(
            [SELECT Pay_in_Lieu_of_Benefits_Local__c,id,Communication_Date__c, Name, Communicated_Date__c, Termination_Date__c, Last_Day_On_Premises__c, DOH_Recent__c, status__c,
            Base_Salary_Override__c, Notice_Amount_Override__c, Basic_Severance_Local_Override__c, Communicated__c,
            Additional_Notice_Override__c, Additional_Severance_Override1__c, Enhanced_Severance_Local_Override__c,
            Cobra_Override__c, Communicated_Details_of_Package__c, Release_Returned__c, Work_Requirement_for_Severance__c,
            EMp_Id__C, Project__c, Historical_Data_Load__c,Severance_Package_Communicated__c,Package_Receipt_Date__c FROM Severance_And_Release__c WHERE id = :sr.Id LIMIT 1]);
        
        Test.startTest();
        
        	RIF_CreateUpdate_Accrual rifAccrual = new RIF_CreateUpdate_Accrual();
        	RIF_CreateUpdate_Accrual.createUpdateAccrual(srList, oldMap, newMap);
        
        	sr.status__c = 'Not Selected';
        	update sr;
        	RIF_CreateUpdate_Accrual.createUpdateAccrual(srList, oldMap, newMap);
        
        Test.stopTest();
    }
}