@isTest(seealldata=true)
    public class RIF_SelectSR_Print_ContTest{
    
    static testMethod void myTest(){
       
        
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
            
            // Create Employee with above user
            List<Employee__c> emplist = new List<Employee__c>();
            for(Integer indx=0;indx<25;indx++){
                Employee__c emp = new Employee__c();
                emp.Name = 'Test Employee_' + indx;
                                          emp.emp_Id__c = '12345' + indx;
                                          emp.Job_Country_Job__c = 'USA';
                                          emp.MS_MSSB__c = 'MSSB';
                                          emp.Level_Dsc_Job__c = 'Director'; 
                                          emp.Covenant_Date__c = Date.today();
                                          emp.Level_Job__c = '123';
                                          emp.User__c = thisUser.id;
                                          emp.Super_Division__c= '10910';
                                          emp.Super_Depart_Org__c ='Super Department' + indx;
                                          emp.Subdept_Org__c = 'Sub Department' + indx;
                                          emp.Division_Org__c = 'Division' + indx;
                                          emp.Dept_Org__c = 'Department' + indx;
                                          emp.Sub_Depart2_Org__c = 'Sub Department 2' + indx;
                                          emp.Cost_Center__c = 'Cost Center' + indx;
                                          emplist.add(emp);
                                          
            }
            insert emplist;
            
            // Assign user with Coverage 
            List<Coverage_Entitlement__c> covEntList = new List<Coverage_Entitlement__c>();
            for(Employee__c emp : emplist){
                Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
                covEnt.HR_Name__c = emp.id;
                covEntList.add(covEnt);
                
            }
            insert covEntList;
            List<Coverage_Entitlement_Org__c> covEntOrgList = new List<Coverage_Entitlement_Org__c>();
            for(Coverage_Entitlement__c covEnt: covEntList){
                Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
                covEntOrg.Coverage_Entitlement__c= covEnt.id;
                covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
               // covEntOrg.Coverage_Entitlement_Org_Code__c= orgCode.id;
               covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
                covEntOrgList.add(covEntOrg);
            }
            insert covEntOrgList;
            
            
            
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
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            // insert 
            
            for(Employee__c emp : emplist){
                Severance_And_Release__c snr = new Severance_And_Release__c(
                                      Project_Level__c = pl.Id, 
                                      Employee__c = emp.Id,
                                      recordTypeId = rt.Id,
                                      Status__c = 'Selected',
                                      Super_Division__c = '10910',
                                      Project__c = proj.id,
                                      Project_Decisional_Org_Level__c = projOrgLevel.Id,
                                      Decisional_Unit__c = pdu.Id);
                                      snrList.add(snr);
                
            }
           insert snrList; 
        }
        
            
            
            project__c project ;
            project = [SELECT id,RecordTypeId from project__c  where id=: snrList[0].project__c ];
        
        
       
           Test.startTest();
               ApexPages.standardController stdcon = New ApexPages.StandardController(project);
               RIF_SelectSR_Print_Cont obj = new RIF_SelectSR_Print_Cont(stdcon);
                
                obj.redirectToDownloadPage();
                obj.createConfigRecords();
                obj.selectAll();
                obj.deSelectAll();
                obj.doNext();
                obj.doPrevious();
                obj.getHasPrevious();
                obj.getHasNext();
                obj.getPageNumber();
                obj.getPageSize();
                obj.getTotalPages();
                obj.selectAll();
                obj.NoOfPackages = 'All Packages';
                obj.createConfigRecords();
                
                
           Test.stopTest();
            
        
    }
    
    static testMethod void myTest1(){
        Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        snr.exhibit_A__c = true;
        Employee__c emp;
        emp= [SELECT id,Age__c from Employee__c where id=: snr.Employee__c ];
        emp.Age__c ='35';
        update emp;
        insert snr ;
            
            
            project__c project ;
            project = [SELECT id,RecordTypeId from project__c  where id=: snr.project__c ];
        
        
       
           Test.startTest();
               ApexPages.standardController stdcon = New ApexPages.StandardController(project);
               RIF_SelectSR_Print_Cont obj = new RIF_SelectSR_Print_Cont(stdcon);
                obj.wrapperList[0].IsSelected=true;
                obj.employeeAge = '35';
               // obj.selectedItems.add('Exhibit A');
                obj.selectAll(); 
                //obj.Generate();
                //obj.GenerateAll();  
                //obj.GenerateAllStep2();
           Test.stopTest();
            
        
    }
    
    static testMethod void myTest2(){
        Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        snr.exhibit_A__c = true;
        insert snr ;
        //insert snr ;
            
            
            project__c project ;
            project = [SELECT id,RecordTypeId from project__c  where id=: snr.project__c ];
        
        
       
           Test.startTest();
               ApexPages.standardController stdcon = New ApexPages.StandardController(project);
               RIF_SelectSR_Print_Cont obj = new RIF_SelectSR_Print_Cont(stdcon);
                obj.wrapperList[0].IsSelected=true;
                obj.employeeAge = '35';
                //obj.selectedItems.add('Exhibit A');
                obj.selectAll();
                obj.selectedDocs = null; 
                obj.Generate();
                obj.GenerateAll();  
                obj.GenerateAllStep2();
           Test.stopTest();
            
        
    }
}