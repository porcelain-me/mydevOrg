@isTest(seeAlldata=true)
public class RIF_SelectSR_Print_ContTest1{
    public static Project__c proj ;
    public static Severance_And_Release__c snr;
    public static Employee__c emp;
    public static Project_Decisional_Unit__c pdu ;
  
   
    
    static testMethod void Testing1(){
        
            
        List<Severance_And_Release__c > snrList = new List<Severance_And_Release__c >();
        // Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
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
             emp = RIF_TestClassUtilities.createTestEmployee(445,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = UserInfo.getUserId();
            emp.Super_Division__c='10910';
            emp.DOH_Recent__c = Date.newInstance(2018, 03, 03);
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
            
            proj = new project__c();
            proj = RIF_TestClassUtilities.createTestProject(446, rt.Id );
            proj.Status__c = 'Model';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // get hr employee
            Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'Super Division';
            insert pdu;
            
            Org_Codes__c orgcodeemp = new Org_Codes__c(Code__c = '10910' , Code_Type__c = 'Super Division', Description__c='Global Wealth Management Group'); 
            // insert project org level
            Child_Project_Decisional_Unit__c pduOrgLevel = new Child_Project_Decisional_Unit__c ();
            //pduOrgLevel.name='test org pdu';
            pduOrgLevel.Project_Decisional_Unit__c = pdu.id ;
            pduOrgLevel.Decisional_Unit_Type__c = 'Super Division'; 
            pduOrgLevel.Decisional_Unit_Code__c = orgcodeemp.id ;  
            pduOrgLevel.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            insert pduOrgLevel ;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            RecordType rtSNR = [Select Id from RecordType  where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rtSNR.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Status__c='Selected';
            snr.Last_Day_On_Premises__c = date.today().addDays(30);
            snr.Exhibit_A__c=true;
            snr.Over_40__c=true;
            Insert snr;
            
            
            
            
            
            
            // 4-Apr-2017 : Insert the unvested equity for the emp 
            Unvested_Equity__c unEquit = new Unvested_Equity__c();
            unEquit.Employee__c = emp.Id;
            unEquit.Unvested_total_balance__c = '100';
            unEquit.Emp_Id__c = emp.Emp_ID__c;
            insert unEquit;
            
            
           /* list<employee__c> lstemp=multiEmpCreation(5);
        multiSNRCreation(10,rtSNR,pl,lstemp,proj);*/
        }
        
        
        
        project__c project ;
        project = [SELECT id,RecordTypeId from project__c  where id=: snr.project__c ];
        
        
         Test.startTest();
       
      
        
       Attachment listAllAttach_At_DecisionalUnits = new Attachment();
        listAllAttach_At_DecisionalUnits.ParentId =snr.Id;
        listAllAttach_At_DecisionalUnits.Name= 'super division';
        listAllAttach_At_DecisionalUnits.Body=Blob.valueOf('Test');
        listAllAttach_At_DecisionalUnits.ContentType='test';       
        insert listAllAttach_At_DecisionalUnits;
        

               
        ApexPages.standardController stdcon = New ApexPages.StandardController(project);
        RIF_SelectSR_Print_Cont obj = new RIF_SelectSR_Print_Cont(stdcon);
   
        obj.test_method(); 
        obj.displayGenerateAllPackages=true;
        obj.nonEditFlag=true;
        obj.selectedVersion='draft';
        obj.wrapperList[0].IsSelected=true;
        obj.isselectAll=true;
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
        obj.Generate();
        //4-Apr-2017 : Commented
        obj.GenerateAll();  
        obj.GenerateAllStep2();  
        Test.stopTest();
    }
    
    static testMethod void Testing2(){
        
            
        List<Severance_And_Release__c > snrList = new List<Severance_And_Release__c >();
        // Org_Codes__c orgCode = [SELECT id, Name FROM Org_Codes__c WHERE Code__c='10910' LIMIT 1];
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
             emp = RIF_TestClassUtilities.createTestEmployee(445,'12345', 'USA', 'MSSB', 'Director','123');
            emp.User__c = UserInfo.getUserId();
            emp.Super_Division__c='10910';
            emp.DOH_Recent__c = Date.newInstance(2018, 03, 03);
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
            
            proj = new project__c();
            proj = RIF_TestClassUtilities.createTestProject(446, rt.Id );
            proj.Status__c = 'Model';
            proj.Communication_Date__c = Date.today();
            proj.Termination_Date__c = Date.today().addDays(14);
            insert proj;
            
            // get hr employee
            Employee__C hrEmp = [SELECT id FROM Employee__C WHERE Dept_Org__c='81200' LIMIT 1];
            
            // insert PDU
            pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = 'Super Division';
            insert pdu;
            
            Org_Codes__c orgcodeemp = new Org_Codes__c(Code__c = '10910' , Code_Type__c = 'Super Division', Description__c='Global Wealth Management Group'); 
            // insert project org level
            Child_Project_Decisional_Unit__c pduOrgLevel = new Child_Project_Decisional_Unit__c ();
            //pduOrgLevel.name='test org pdu';
            pduOrgLevel.Project_Decisional_Unit__c = pdu.id ;
            pduOrgLevel.Decisional_Unit_Type__c = 'Super Division'; 
            pduOrgLevel.Decisional_Unit_Code__c = orgcodeemp.id ;  
            pduOrgLevel.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            insert pduOrgLevel ;
            
            // insert severance parameters
            Severance_Parameters__c sp = RIF_TestClassUtilities.createTestSeveranceParameter(0, 'USA', 'MSSB', 'Director', '123');
            insert sp;
            
            // insert project level
            Project_Level__c pl = RIF_TestClassUtilities.createTestProjectLevel(proj.Id, sp.Id);
            insert pl;
            
            // get record type of snr
            rt = [Select Id from RecordType where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            
            RecordType rtSNR = [Select Id from RecordType  where Name = 'Project Based Termination' and SobjectType = 'Severance_And_Release__c' limit 1];
            snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp.Id, rtSNR.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Status__c='Selected';
            snr.Last_Day_On_Premises__c = date.today().addDays(30);
            snr.Exhibit_A__c=true;
            snr.Over_40__c=true;
            Insert snr;
            
            
            
            
            
            
            // 4-Apr-2017 : Insert the unvested equity for the emp 
            Unvested_Equity__c unEquit = new Unvested_Equity__c();
            unEquit.Employee__c = emp.Id;
            unEquit.Unvested_total_balance__c = '100';
            unEquit.Emp_Id__c = emp.Emp_ID__c;
            insert unEquit;
            
            
           /* list<employee__c> lstemp=multiEmpCreation(5);
        multiSNRCreation(10,rtSNR,pl,lstemp,proj);*/
        }
        
        
        
        project__c project ;
        project = [SELECT id,RecordTypeId from project__c  where id=: snr.project__c ];
        
        
         Test.startTest();
       
      
        
       Attachment listAllAttach_At_DecisionalUnits = new Attachment();
        listAllAttach_At_DecisionalUnits.ParentId =snr.Id;
        listAllAttach_At_DecisionalUnits.Name= 'super division';
        listAllAttach_At_DecisionalUnits.Body=Blob.valueOf('Test');
        listAllAttach_At_DecisionalUnits.ContentType='test';       
        insert listAllAttach_At_DecisionalUnits;
        

               
        ApexPages.standardController stdcon = New ApexPages.StandardController(project);
        RIF_SelectSR_Print_Cont obj = new RIF_SelectSR_Print_Cont(stdcon);
   
        obj.test_method(); 
        obj.displayGenerateAllPackages=true;
        obj.nonEditFlag=true;
        obj.selectedVersion='Final';
        obj.wrapperList[0].IsSelected=true;
        obj.isselectAll=true;
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
        obj.Generate();
        //4-Apr-2017 : Commented
        obj.GenerateAll();  
        obj.GenerateAllStep2();  
        Test.stopTest();
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   /* public static list<employee__c> multiEmpCreation(integer numofrecords){
       list<employee__c> listofEmp =new list<employee__c>();
        for(integer i=0 ;i<numofrecords ;i++)
        {
            Integer name=445+i;
            string empid='12345'+i;
            
            employee__c emp=new employee__c();
             emp = RIF_TestClassUtilities.createTestEmployee(name,empid, 'USA', 'MSSB', 'Director','123');
            emp.User__c = UserInfo.getUserId();
            emp.Super_Division__c='10910';
            emp.DOH_Recent__c = Date.newInstance(2018, 03, 03);
            listofEmp.add(emp);
      
        }
        insert listofEmp;
        system.debug('%%% listofEmp'+listofEmp);
            
        return listofEmp;
        
    }
    
    public static list<Severance_And_Release__c> multiSNRCreation(integer numofrecords,RecordType rt,Project_Level__c pl,list<employee__c> emp,project__c proj){
        list<Severance_And_Release__c> snrList =new list<Severance_And_Release__c>();
        
        for(integer i=0;i<emp.size(); i++){

            Severance_And_Release__c snr = new Severance_And_Release__c();
            snr = RIF_TestClassUtilities.createTestSR(pl.Id, emp[i].Id, rt.Id);
            snr.Super_Division__c = '10910';
            snr.Project__c = proj.id;
            snr.Status__c='Selected';
            snr.Last_Day_On_Premises__c = date.today().addDays(30);
            snr.Exhibit_A__c=true;
            snr.Over_40__c=true;
            snrList.add(snr);
            
        }
        Insert snrList;
        system.debug('%%%%%%%%%% snrList'+snrList);
        return snrList;
    }*/
            
}