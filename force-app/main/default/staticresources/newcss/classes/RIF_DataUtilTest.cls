//
// 08/26/2013 : MG : Test Class for RIF_DataUtil.cls
//
@isTest
public class RIF_DataUtilTest {
    static List<Employee__c> empList;
    static list<Project__c> projList;
    static list<Project_Level__c> listProjLevel;
    //static list<Comp_Data__c> listCompData;
    //static Covenant_Parameters__c cp;
    static Project_Decisional_Unit__c pdu;
    static list<Severance_And_Release__c> listSR;
    static Severance_Parameters__c sp;
     RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
    
    public static void createTestData(){
       // Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c = '10910' LIMIT 1];
        
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        system.runAs(thisUser){
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_System_Admin' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            
           // Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
            //insert snr;
        }
    }
    
    static testmethod void getTriggerSwitchTest(){
        Test.startTest();
        createTestData();
        Trigger_Switch__c tSwitch = RIF_DataUtil.getTriggerSwitch();
        system.assertEquals( tSwitch != null, true);
        Test.stopTest();
        
    }
    
    static testmethod void getProfileIdTest(){
        Test.startTest();
        createTestData();
        Id sysAdminProfileId = RIF_DataUtil.getProfileId('System Administrator');
        system.assertEquals(true, sysAdminProfileId != null);
        Test.stopTest();
    }
    
    static testmethod void getExistingGroupMembersTest(){
        Test.startTest();
        createTestData();
        List<Group> grpList = new list<Group>();
        Group grp1 = new Group(Name = 'TESTSuper_Division_1');
        grpList.add(grp1);
        Group grp2 = new Group(Name = 'TESTSuper_Division_2');
        grpList.add(grp2);
        insert grpList;
        List<GroupMember> listGrpMember = new List<GroupMember>();
        listGrpMember.add(new GroupMember(userOrGroupId = userInfo.getUserId(), GroupId = grpList[0].Id));
        listGrpMember.add(new GroupMember(userOrGroupId = userInfo.getUserId(), GroupId = grpList[1].Id));
        insert listGrpMember;
        
        map<Id, set<Id>> mapUserIdSetGrpIds = new map<Id, set<Id>>();
        mapUserIdSetGrpIds.put(userInfo.getUserId(), new Set<Id>{grpList[0].Id, grpList[1].Id});
        
        set<Id> setUserIds = new set<Id>{userInfo.getUserId()};
        set<Id> setGroupIds = new set<Id>{grpList[0].Id, grpList[1].Id};
        
        list<GroupMember> listExistingGrpMember = RIF_DataUtil.getExistingGroupMembers(mapUserIdSetGrpIds);
        
        listExistingGrpMember = RIF_DataUtil.getExistingGroupMembers(setGroupIds, setUserIds);
        Test.StopTest();
    }
    
    static testmethod void create_InsertGroupMemberTest(){
        Test.StartTest();
        List<Group> grpList = new list<Group>();
        Group grp1 = new Group(Name = 'TESTSuper_Division_1');
        grpList.add(grp1);
        Group grp2 = new Group(Name = 'TESTSuper_Division_2');
        grpList.add(grp2);
        insert grpList;
        
        GroupMember grpMember = RIF_DataUtil.createGroupMember(userInfo.getUserId(), grpList[0].Id);
        
        system.assertEquals(true, grpMember <> null);
        
        RIF_DataUtil.insertGroupMembers(new list<GroupMember>{grpMember});
        
        List<GroupMember> listInsertedGroupMember = [Select Id from GroupMember where GroupId in : grpList];
        system.assertEquals(1, listInsertedGroupMember.size());
        
        Test.StopTest();
    }
    
    static testmethod void deleteGroupMembersTest(){
        Test.startTest();
        createTestData();
        List<Group> grpList = new list<Group>();
        Group grp1 = new Group(Name = 'TESTSuper_Division_1');
        grpList.add(grp1);
        Group grp2 = new Group(Name = 'TESTSuper_Division_2');
        grpList.add(grp2);
        insert grpList;
        List<GroupMember> listGrpMember = new List<GroupMember>();
        listGrpMember.add(new GroupMember(userOrGroupId = userInfo.getUserId(), GroupId = grpList[0].Id));
        listGrpMember.add(new GroupMember(userOrGroupId = userInfo.getUserId(), GroupId = grpList[1].Id));
        insert listGrpMember;
        
        RIF_DataUtil.deleteGroupMembers(listGrpMember);
        
        listGrpMember = [Select Id from GroupMember where UserOrGroupId = :userInfo.getUserId() and GroupId in : grpList];
        
        system.assertEquals(0, listGrpMember.size());
        Test.StopTest();
    }
    
    static testmethod void getSeverancePrametersTest(){
        Test.StartTest();
            createTestData();
            
            sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Vice Director', '123');
            
            List<Severance_Parameters__c> spList = new List<Severance_Parameters__c>();
            spList.add(sp);
            //insert sp;
            
            List<Severance_Parameters__c> listSP = RIF_DataUtil.getSeverancePrameters(new list<String>(),'','','','');
            system.assertNotEquals(10000, listSP.size());
            
            listSP = RIF_DataUtil.getSeverancePrameters(new List<String>{sp.Id});
            system.assertNotEquals(10000, listSP.size());
            
            listSP = RIF_DataUtil.getSeverancePrameters(sp.Id);
            system.assertNotEquals(10000, listSP.size());
            
            listSP = RIF_DataUtil.getSeverancePrametersForCountry(sp.Country__c);
            system.assertNotEquals(10000, listSP.size());
            
            listSP = RIF_DataUtil.getSeverancePrameters(sp.Country__c, sp.MS_MSSB__c, sp.Level_Dsc__c);
            system.assertNotEquals(10000, listSP.size());
            
            RIF_DataUtil.cloneSevParamToProjectLevel(sp);
            RIF_DataUtil.getProjectLevelsOfSeveranceParameter(sp.Id);
            
            RecordType rt = [Select Id, Name from RecordType where Name = 'Project Based Termination' 
                                        and SobjectType = 'Project__c' limit 1];
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            Set<id> projIds = new Set<Id>();
            projIds.add(proj.id);
            
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            List<String> plList = new List<String>();
            plList.add(pl.Id);
            
            Set<String> plSet = new Set<String>();
            plSet.add(pl.id);
            
            Set<id> plSet2 = new Set<id>();
            plSet2.add(pl.id);
            
            RIF_DataUtil.getProject(proj.Id);
            RIF_DataUtil.getProjectList(plList);
            RIF_DataUtil.getProjectListFromIds(plSet2);
            RIF_DataUtil.getProjectListOnRecordTypeName(rt.Name);
            
            RIF_DataUtil.cloneSevParamToProjectLevel(pl,sp);
            RIF_DataUtil.insertResult(spList);
            
            sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Vice Chancellor', '123');
            RIF_DataUtil.insertResult(sp);
            
            spList.add(sp);
            RIF_DataUtil.upsertResult(spList);
            
            RIF_DataUtil.getProjectRecordTypeForId(rt.Id);
            RIF_DataUtil.getRecordTypeForName(rt.Name);
            RIF_DataUtil.getRecordTypeForId(rt.Id, 'Project__c');
            
            RIF_DataUtil.getProjectLevels(plSet);
            RIF_DataUtil.getProjectLevels(proj.Id, '', '', '');
            RIF_DataUtil.getProjectLevelsForProject(proj.Id);
            RIF_DataUtil.getProjectLevelsForMassProjects(projIds);
            
            insert proj;
            
        
        Test.StopTest();
    }
    
    static testmethod void cloneSevParamToProjectLevelTest(){
        Test.StartTest();
        	createTestData();
        Test.StopTest();
    }
    
    public static testMethod void getConfiguredFieldsList(){
        RecordType rt = [Select Id from RecordType where Name = 'One Off Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            insert proj;
            RIF_DataUtil.getConfiguredFieldsList('One Off Termination');
    }
    
    
    
    static testMethod void testMethod1() {
        
        User thisUser = RIF_TestClassUtilities.getTempUser();
        insert thisUser;
        
        List<String> useridList = new List<String>();
        useridList.add(thisUser.Id);
        
        System.runAs(thisUser) {
            Employee__c emp = RIF_TestClassUtilities.createTestEmployee(0,'123451234', 'USA', 'MSSB', 'Director','123');
            emp.User__c = thisUser.id;
            emp.Super_Division__c='10910';
            emp.Dept_Org__c='81200';
            emp.DOH_Recent__c = Date.newInstance(2010, 01, 01);
            insert emp;
            
            Set<String> empSet = new Set<String>();
            empSet.add(emp.Id);
            
            Severance_And_Release__c snr = new Severance_And_Release__c();
                
            List<String> srIdList = new List<String>();
            srIdList.add(snr.Id);
                
            Set<id> srIdSet = new Set<id>();
            srIdSet.add(snr.Id);
            
            Test.startTest();
                String profileId = RIF_DataUtil.getProfileId('System Administrator');
                System.assertNotEquals('id', profileId);
                
                System.assertNotEquals(thisUser, RIF_DataUtil.getUserDetails(thisUser.id));
                
                RIF_DataUtil.getUserDetailsOnUserIds(useridList);
                RIF_DataUtil.getOrgWideEmaillAddresses('DEV');
                RIF_DataUtil.getListDefaultNoticePeriodsFromCustomSetting();
                
                RIF_DataUtil.getEmployeeList(empSet);
                RIF_DataUtil.getEmployee(emp.Id);
            	RIF_DataUtil.isValidHREmp(emp.Id);
            	RIF_DataUtil.getAllValidHREmployees();
                RIF_DataUtil.getSingleEmployeeRecord(emp.Emp_ID__c);
                RIF_DataUtil.getEmpRecForHR(emp.Emp_ID__c);
                
                RIF_DataUtil.copyFieldsToSRFromEmployee(snr, emp);
                RIF_DataUtil.getSeveranceAndReleaseList(srIdList);
                RIF_DataUtil.getSeveranceAndReleaseListFromSetIds(srIdSet);
                
                RIF_DataUtil.convertStringToCurrency('1520');
                
                RIF_DataUtil.checkRIFUser(UserInfo.getUserId());
               // RIF_DataUtil.getAccessibleEmployee(emp.id);
                
            Test.stopTest();
        }
    }
    
    static testMethod void testMethod2(){
        
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
         
        
        List<Severance_And_Release__c> srList = new List<Severance_And_Release__c>();
       Severance_And_Release__c snr = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp.Id,
                recordTypeId = rt.Id,
                Status__c = 'Selected',
                Super_Division__c = '10910',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            srList.add(snr);
             insert srList;
            
        Employee__c emp1 = [SELECT Id, Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,
                               Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c
                               FROM Employee__c WHERE id = :snr.Employee__c LIMIT 1];
        Test.startTest();
            //RIF_DataUtil.checkEmpCompDataVisibility(UserInfo.getUserId(), emp);
            //RIF_DataUtil.checkSRRecordAccessibleForUser(srList, UserInfo.getUserId());
            RIF_DataUtil.getAccessibleSRRecordsFromSRList(srList);
        Test.stopTest();
    }
    }
    
    public static testMethod void test3() {
       /* RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
        
        Employee__c emp= RIF_TestClassUtilities.createTestEmployee(1, '12345', 'USA', 'MSSB', 'jobLevelDsc', 'jobLevel');
        Project__c proj=RIF_TestClassUtilities.createTestProject(1,rt.id );
        Severance_Parameters__c sp=RIF_TestClassUtilities.createTestSeveranceParameter(1, 'USA', 'MSSB', 'levelDsc', 'level');
         Project_Level__c pl =RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);  
        Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(pl.id, emp.Id, rt.Id);*/
        
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
            //insert snr;
          
        
        List<Severance_And_Release__c> srList = new List<Severance_And_Release__c>();
        srList.add(snr);
        insert srList;
        
        Set<Id> srIdSet = new Set<Id>();
        srIdSet.add(snr.Id);
        
        Set<String> srIdSet2 = new Set<String>();
        srIdSet2.add(snr.Id);
        
        Set<String> templateSet = new Set<String>();
        
        List<APXTConga4__Conga_Template__c> templateList = [SELECT id FROM APXTConga4__Conga_Template__c];
        for(APXTConga4__Conga_Template__c template: templateList) {
            templateSet.add(template.Id);
        }
        
        Test.startTest();
            RIF_Util_Kumaresan.updateSnROnContentManagementforSet(srIdSet, templateSet);
            RIF_Util_Kumaresan.updateSnROnContentManagement_New(templateSet, srList);
            RIF_Util_Kumaresan.getAccessableSRrecord(snr.Project__c);
            
            RIF_Util_Kumaresan.getFullQueryFromSobject(snr, snr.Id, 'sr', srIdSet2);
            RIF_Util_Kumaresan.getFullQueryFromSobject(snr, snr.Id, 'Proj', srIdSet2);
            RIF_Util_Kumaresan.getFullQueryFromSobject(snr, snr.Id, 'statisIds', srIdSet2);
            RIF_Util_Kumaresan.getAllFieldsFromSObject(snr, snr.Id, 'sr', srIdSet2);
            RIF_Util_Kumaresan.getAllFieldsFromSObject(snr, snr.Id, 'Proj', srIdSet2);
        Test.stopTest();
    }
    }
    
    public static testMethod void test4() {
         
         List<Severance_And_Release__c> snrList = new List<Severance_And_Release__c>();    
        //Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
      /*  RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
        testUtil.insertOrgHierarchy();*/
        
        User thisUser = RIF_TestClassUtilities.getALLMSUser();
        insert thisUser;
        
        System.runAs(thisUser) {
            // Assign permission sets to user
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_System_Admin' LIMIT 1];
            insert new PermissionSetAssignment(AssigneeId = thisUser.id, PermissionSetId = ps.Id );
            ps = [SELECT ID From PermissionSet WHERE Name = 'RIF_HR_Coverage' LIMIT 1];
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
               	covEntOrg.Org_Hierarchy_Code__c= '10910';
                covEntOrgList.add(covEntOrg);
            
                Coverage_Entitlement_Org__c covEntOrg1 = new Coverage_Entitlement_Org__c();
                covEntOrg1.Coverage_Entitlement__c= covEnt.id;
                covEntOrg1.Coverage_Entitlement_Type__c= 'Division';   
                covEntOrg1.Org_Hierarchy_Code__c= '85000';
                covEntOrgList.add(covEntOrg1);
           
            Coverage_Entitlement_Org__c covEntOrg2 = new Coverage_Entitlement_Org__c();
            covEntOrg2.Coverage_Entitlement__c= covEnt.id;
            covEntOrg2.Coverage_Entitlement_Type__c= 'Super Department';   
            covEntOrg2.Org_Hierarchy_Code__c= '25307';
            covEntOrgList.add(covEntOrg2);
            
            Coverage_Entitlement_Org__c covEntOrg3 = new Coverage_Entitlement_Org__c();
            covEntOrg3.Coverage_Entitlement__c= covEnt.id;
            covEntOrg3.Coverage_Entitlement_Type__c= 'Department';   
            covEntOrg3.Org_Hierarchy_Code__c= '11002';
            covEntOrgList.add(covEntOrg3);
            
            Coverage_Entitlement_Org__c covEntOrg4 = new Coverage_Entitlement_Org__c();
            covEntOrg4.Coverage_Entitlement__c= covEnt.id;
            covEntOrg4.Coverage_Entitlement_Type__c= 'Sub Department';   
            covEntOrg4.Org_Hierarchy_Code__c= '12255';
            covEntOrgList.add(covEntOrg4);
            
            Coverage_Entitlement_Org__c covEntOrg5 = new Coverage_Entitlement_Org__c();
            covEntOrg5.Coverage_Entitlement__c= covEnt.id;
            covEntOrg5.Coverage_Entitlement_Type__c= 'Sub Department 2';   
            covEntOrg5.Org_Hierarchy_Code__c= '26424';
            covEntOrgList.add(covEntOrg5);
            
            Coverage_Entitlement_Org__c covEntOrg6 = new Coverage_Entitlement_Org__c();
            covEntOrg6.Coverage_Entitlement__c= covEnt.id;
            covEntOrg6.Coverage_Entitlement_Type__c= 'Cost Center';   
            covEntOrg6.Org_Hierarchy_Code__c= '571195';
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
           // pdu.Employee__c = Emp.id;
           // pdu.HR_Signatory__c = Emp.id;
            insert pdu;
            
           
            
            // insert project org level
            
            List<Child_Project_Decisional_Unit__c> projOrgLevelList = new List<Child_Project_Decisional_Unit__c>();
            
             Child_Project_Decisional_Unit__c projOrgLevel0 = new Child_Project_Decisional_Unit__c();
            projOrgLevel0.Decisional_Unit_Type__c='Employee';
            projOrgLevel0.Project_Decisional_Unit__c=pdu.id;
            projOrgLevel0.Org_Hierarchy_Code__c='';
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
                                      Project_Decisional_Org_Level__c = projOrgLevel1.Id,
                                      Decisional_Unit__c = pdu.Id);
            	snrList1.add(snr1);	
            
            Severance_And_Release__c snr2 = new Severance_And_Release__c(
                                      Project_Level__c = pl.Id, 
                                      Employee__c = emp.Id,
                                      recordTypeId = rt.Id,
                                      Status__c = 'Selected',
                					  Super_Department__c= '25307',
                                      Project__c = proj.id,
                                      Project_Decisional_Org_Level__c = projOrgLevel1.Id,
                                      Decisional_Unit__c = pdu.Id);
            	snrList1.add(snr2);	
            Severance_And_Release__c snr3 = new Severance_And_Release__c(
                                      Project_Level__c = pl.Id, 
                                      Employee__c = emp.Id,
                                      recordTypeId = rt.Id,
                                      Status__c = 'Selected',
                					  Department__c = '11002',
                                      Project__c = proj.id,
                                      Project_Decisional_Org_Level__c = projOrgLevel1.Id,
                                      Decisional_Unit__c = pdu.Id);
            	snrList1.add(snr3);	
            Severance_And_Release__c snr4 = new Severance_And_Release__c(
                                      Project_Level__c = pl.Id, 
                                      Employee__c = emp.Id,
                                      recordTypeId = rt.Id,
                                      Status__c = 'Selected',
                					  Sub_Department__c = '12255',
                                      Project__c = proj.id,
                                      Project_Decisional_Org_Level__c = projOrgLevel1.Id,
                                      Decisional_Unit__c = pdu.Id);
            	snrList1.add(snr4);	
            Severance_And_Release__c snr5 = new Severance_And_Release__c(
                                      Project_Level__c = pl.Id, 
                                      Employee__c = emp.Id,
                                      recordTypeId = rt.Id,
                                      Status__c = 'Selected',
                					   Sub_Department_2__c = '26424',
                                      Project__c = proj.id,
                                      Project_Decisional_Org_Level__c = projOrgLevel1.Id,
                                      Decisional_Unit__c = pdu.Id);
            	snrList1.add(snr5);	
            Severance_And_Release__c snr6 = new Severance_And_Release__c(
                                      Project_Level__c = pl.Id, 
                                      Employee__c = emp.Id,
                                      recordTypeId = rt.Id,
                                      Status__c = 'Selected',
                					  Cost_Center__c = '571195',
                                      Project__c = proj.id,
                                      Project_Decisional_Org_Level__c = projOrgLevel1.Id,
                                      Decisional_Unit__c = pdu.Id);
            	snrList1.add(snr6);	        
        		insert snrList1;
            
             unvested_Equity__c unEquit = new Unvested_Equity__c();
            unEquit.Employee__c = emp.Id;
            unEquit.Unvested_total_balance__c = '100';
            unEquit.Emp_Id__c = emp.Emp_ID__c;
            unEquit.Employee_temp__c=emp.Id;
            insert unEquit;
            
            RIF_File_Upload_History__c file =new RIF_File_Upload_History__c();
            file.File_Name__c='My Documentst.csv';
            file.File_type__c='Accural';
            insert  file;
            
            
         Test.startTest();
            RIF_DataUtil.checkEmpCompDataVisibility(UserInfo.getUserId(), emp);
            RIF_DataUtil.getAccessibleEmployee(emp);
            RIF_DataUtil.checkSRRecordAccessibleForUser(snrList1, UserInfo.getUserId());
            RIF_DataUtil.getAccessibleSRRecordsFromSRList(snrList1);
            RIF_DataUtil.copyFieldsToSRFromUnvestedEquity(snr, unEquit);
            RIF_DataUtil.getAccessibleSRRecords(proj.Id);
            RIF_DataUtil.getAccessibleSRRecordsFromSRList(snrList1);
            RIF_DataUtil.updateSRWithOtherOrgPduANDPdu(Pdu.ID, proj.ID, SnRList1, 'All');
            RIF_DataUtil.getEligibleOrgPDuForSR(snr, proj.ID, Pdu.ID, 'xyz');    
            RIF_DataUtil.getSeveranceAndReleaseRecord(snr.Id);
            RIF_DataUtil.getUnvestedEquityForEmployee( emp.Id);
            RIF_DataUtil.getLoggedInUSerCovEntitlementTypeWithCode(thisUser.id);
           // RIF_DataUtil.checkOrgPDUScopeDowngraded(projOrgLevelList[1], SnRList1);
           RIF_DataUtil.getFileUploadHistories('accural');
           
          

        Test.stopTest();
        
            }  
    }
}