@isTest
public class Rif_EmailProjectOwnerBatchTest {
    
    static testmethod void mytest(){
        
        
        List<Severance_And_Release__c> snrList = new List<Severance_And_Release__c>();    
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
            List<Employee__c> emplist = new List<Employee__c>();
            Employee__c emp1 = new Employee__c();
            emp1.Name = 'Test Employee_';
            emp1.emp_Id__c = '12345';
            emp1.Job_Country_Job__c = 'USA';
            emp1.MS_MSSB__c = 'MSSB';
            emp1.Level_Dsc_Job__c = 'Director'; 
            emp1.Covenant_Date__c = Date.today();
            emp1.Level_Job__c = '123';
            emp1.User__c = thisUser.id;
            emp1.Super_Division__c= '10910';
            emp1.Super_Depart_Org__c ='Super Department';
            emp1.Subdept_Org__c = 'Sub Department';
            emp1.Division_Org__c = 'Division' ;
            emp1.Dept_Org__c = 'Department';
            emp1.Sub_Depart2_Org__c = 'Sub Department 2' ;
            emp1.Cost_Center__c = 'Cost Center' ;
            emp1.Dept_Org__c='81200';
            emp1.Status__c='Active';
            emp1.DOH_Recent__c=date.today()-1;
            emp1.Phone_Area_Code_Home__c='134';
            emp1.Phone_Number_Home__c='123456';
            emplist.add(emp1);
            
            
            insert emplist;
            
            
            
            // get record type of project
            RecordType rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Project__c' limit 1];
            // insert project
            Project__c proj = RIF_TestClassUtilities.createTestProject(0, rt.Id );
            proj.Communication_Date__c=date.today();
            proj.Country__c = 'USA' ; 
            proj.Status__c = 'Active' ;
            proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
            insert proj;
            
            // get hr employee
            Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'WM';
            pdu.Employee__c = hrEmp.id;
            pdu.HR_Signatory__c = hrEmp.id;
            insert pdu;
            
            
            
            // insert project org level
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            // projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.Project_Decisional_Unit__c = pdu.id;
            insert projOrgLevel;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // Assign user with Coverage 
            // List<Coverage_Entitlement__c> covEntList = new List<Coverage_Entitlement__c>();
            
            Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp1.id;
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
            
            Severance_And_Release__c snr1 = new Severance_And_Release__c(
                Project_Level__c = pl.Id, 
                Employee__c = emp1.Id,
                //recordTypeId = rt.Id,
                Status__c = 'Selected',
                Super_Division__c = '10910',
                Project__c = proj.id,
                Project_Decisional_Org_Level__c = projOrgLevel.Id,
                Decisional_Unit__c = pdu.Id);
            snr1.Communication_Date__c=date.today();
            snr1.Termination_Date__c=date.today();
            snr1.Emp_Id__c= emp1.id;
            snr1.Last_Day_On_Premises__c=date.today();
            snr1.Conga_Total_Unvested_Value__c='12';
            snr1.Home_Phone_Number__c=emp1.Phone_Area_Code_Home__c+emp1.Phone_Number_Home__c;
            insert snr1;    
            Severance_And_Release__c snr2  = [Select name from Severance_And_Release__c where Id = :snr1.Id];
            
            
            Severance_Release_ETL_Temp__c sretl = new Severance_Release_ETL_Temp__c();
            sretl.Changed_Fields__c = 'Address 4 - Home| DOH Original| Job State -Job|Job Title Dsc Job';
            sretl.Employee__c = emp1.Id;
            sretl.Project__c = proj.Id;
            sretl.Severance_And_Release__c = snr1.Id;
            sretl.Active__c = True;
            insert sretl;  
            
            
            final String query = 'SELECT Id,Project__r.ownerId,Severance_And_Release__r.name,Project__r.owner.email,Employee__r.emp_id__c,Employee__r.name, Project__r.name,Changed_Fields__c, Employee__c, Project__c, Severance_And_Release__c, Active__c, MS_ID__c from Severance_Release_ETL_Temp__c where Active__c =true and createddate >= LAST_N_DAYS:5    and Severance_And_Release__r.Communicated__c =false and project__r.status__c=\'Active\'   order by Severance_And_Release__r.name, createddate desc';
            
            Test.startTest();
            
            Rif_EmailProjectOwnerBatch emailproj =new Rif_EmailProjectOwnerBatch();
            emailproj.start(null);
            emailproj.execute(null);
            emailproj.finish(null);
            
            
            Test.stopTest();
            
        }
    }
}