@isTest
public class RIF_EmployeeSyncSelectTest {
    public static final string PROJECT_BASED_TERMINATION = 'Project Based Termination';
   
    private static testMethod void RIF_EmployeeSyncSelectTest() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Phillips', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='Aaron', Emp_Id__c = '84JWP', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
         PermissionSet perSe = new PermissionSet();
            perSe = [Select Id from PermissionSet where Name = 'RIF_HR_Coverage'];
            
            PermissionSetAssignment perSetAs = new PermissionSetAssignment(PermissionSetId = perSe.id, AssigneeId = tempUser.Id);
            insert perSetAs;
        
        System.runAs(tempuser){     
            //RIF_TestClassUtilities.setAllTriggerOn();
           
            
            Employee__c emp = new Employee__c(
                Name='Employee2',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                Job_Region_Code__c='EU',Emp_ID__c = 'test',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',Level_Job__c = '40',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Non-Exempt',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            RecordType rt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Project__c' limit 1];
            // RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1];
            System.debug('#########'+rt.id);
            Project__c proj  = new Project__c();
            
            proj.Communication_Date__c = System.today();
            proj.Country__c = 'USA';
            proj.Notice_Days__c = 19;
            proj.Is_Locked_By_Conga__c = false;
            proj.Package_Status__c = 'Running';
            proj.Package_Status_Message__c = 'hello';
            proj.Primary_Key__c = 'primkey';
            proj.Status__c = 'Active';
            proj.Super_Division__c ='Global Wealth Management Group';
            proj.System_Super_Division__c = 'Wealth Management';
            proj.Template__c = 'sample';
            proj.Template1__c = 'Template 2';
            proj.Termination_Date__c =System.today().addDays(19);
            proj.WARN__c = false;
            proj.RecordTypeId = rt.id;
            
       
            
            //proj.RecordTypeId = srrt.id;
            insert proj;
            
            
            List<Project__c> projList = new List<Project__c>();
            
            Severance_Parameters__c sevPara = new Severance_Parameters__c();
            sevPara .Country__c =emp.Job_Country_Job__c;
            sevPara .MS_MSSB__c =emp.MS_MSSB__c;
            sevPara .Level_Dsc__c =emp.Level_Dsc_Job__c;
            sevPara .Level__c =emp.Level_Job__c ;
            sevPara .Primary_Key__c = emp.MS_MSSB__c+'-'+emp.Level_Dsc_Job__c+'-'+emp.Job_Country_Job__c;
            insert sevPara;
            
            list<Project_Level__c> listProjLevel = new list<Project_Level__c>();
            
            Project_Level__c projLevel = new Project_Level__c();
            projLevel .Project__c = proj.id;
            projLevel .Severance_Parameters__c = sevPara.id;
            insert projLevel;    
            
            list<Project_Decisional_Unit__c> pduList = new list<Project_Decisional_Unit__c>();
            
            Project_Decisional_Unit__c projDU = new Project_Decisional_Unit__c();
            projDU .Project__c =proj.id;
            insert projDu;
            
            
            RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
            testUtil.insertOrgHierarchy();
            
            Coverage_Entitlement__c covEntl =new Coverage_Entitlement__c ();
            covEntl.HR_Name__c = emp.Id;
            insert covEntl;  
            
            Coverage_Entitlement_Org__c covEntlOrg = new Coverage_Entitlement_Org__c();
            covEntlOrg .Coverage_Entitlement__c = covEntl.id;
            
            //covEntlOrg .Coverage_Entitlement_Org_Code__c ='10910 - Global Wealth Management Group';
            covEntlOrg.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            covEntlOrg .Coverage_Entitlement_Type__c = 'Super Division';
            insert covEntlOrg ;
            
            
          
            
            RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1]; 
            
            Severance_And_Release__c snr = new Severance_And_Release__c();
            snr.Project_Level__c =  projLevel.id;
            snr.Employee__c  = emp.id;
            snr.recordTypeId = srrt.id;
            snr.Status__c  = 'Selected';
            snr.Communicated__c=false;
            snr.Historical_Data_Load__c=false;
           
            insert snr;
           
             Severance_And_Release__c snr2  = [Select name from Severance_And_Release__c where Id = :snr.Id];
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();   
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            //projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Project_Decisional_Unit__c = projDU.id;
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.ProjectID__c = proj.id;
            insert projOrgLevel;                
            
            Severance_Release_ETL_Temp__c sretl = new Severance_Release_ETL_Temp__c();
             									sretl.Changed_Fields__c = 'Address 4 - Home| DOH Original| Job State -Job|Job Title Dsc Job';
												sretl.Employee__c = emp.Id;
												sretl.Project__c = proj.Id;
												sretl.Severance_And_Release__c = snr.Id;
												sretl.Active__c = True;
		insert sretl;    
            
            
            Test.startTest();
            
            PageReference pageRef = Page.RIF_EmployeeSyncSelectPage;
             ApexPages.currentPage().getParameters().put('RecordType', PROJECT_BASED_TERMINATION);
            ApexPages.currentPage().getParameters().put('projectId', proj.Id); 
            ApexPages.currentPage().getParameters().put('snrName', snr2.Name);
            Test.setCurrentPage(pageRef);
            

            Apexpages.StandardController sc = new Apexpages.StandardController(proj);
            RIF_EmployeeSyncSelect empselec = new  RIF_EmployeeSyncSelect(sc);         
            
            
            
            empselec.getTotalPages();
            empselec.getAllSNRs();
            empselec.redirectPrj();        
            empselec.first();
            empselec.last();
            empselec.previous();
            empselec.next();
            empselec.cancel();
            empselec.syncSNRs();
          
           
            
            Boolean hasNext = empselec.hasNext;
            Boolean hasPrevious = empselec.hasPrevious;
            Integer pageNumber = empselec.pageNumber;
            boolean isselect=empselec.isselect;
            
            
            
            Test.stopTest();
        }
    }
  static testMethod void RIF_EmployeeSyncSelectTest1() {
        
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
        User tempUser1  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Phillips', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p1.Id, FirstName='Aaron', Emp_Id__c = '84JWP', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser1;
         PermissionSet perSe1 = new PermissionSet();
            perSe1 = [Select Id from PermissionSet where Name = 'RIF_HR_Coverage'];
            
            PermissionSetAssignment perSetAs = new PermissionSetAssignment(PermissionSetId = perSe1.id, AssigneeId = tempUser1.Id);
            insert perSetAs;
        
        System.runAs(tempuser1){     
            //RIF_TestClassUtilities.setAllTriggerOn();
           
            
            Employee__c emp = new Employee__c(
                Name='Employee2',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                Job_Region_Code__c='EU',Emp_ID__c = 'test',User__c= tempUser1.id,City_Home__c='City',Zip_Home__c='1234',
                State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',Level_Job__c = '40',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Non-Exempt',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            RecordType rt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Project__c' limit 1];
            // RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1];
            System.debug('#########'+rt.id);
            Project__c proj  = new Project__c();
            
            proj.Communication_Date__c = System.today();
            proj.Country__c = 'USA';
            proj.Notice_Days__c = 19;
            proj.Is_Locked_By_Conga__c = false;
            proj.Package_Status__c = 'Running';
            proj.Package_Status_Message__c = 'hello';
            proj.Primary_Key__c = 'primkey';
            proj.Status__c = 'Active';
            proj.Super_Division__c ='Global Wealth Management Group';
            proj.System_Super_Division__c = 'Wealth Management';
            proj.Template__c = 'sample';
            proj.Template1__c = 'Template 2';
            proj.Termination_Date__c =System.today().addDays(19);
            proj.WARN__c = false;
            proj.RecordTypeId = rt.id;
            
       
            
            //proj.RecordTypeId = srrt.id;
            insert proj;
            
            
            List<Project__c> projList = new List<Project__c>();
            
            Severance_Parameters__c sevPara = new Severance_Parameters__c();
            sevPara .Country__c =emp.Job_Country_Job__c;
            sevPara .MS_MSSB__c =emp.MS_MSSB__c;
            sevPara .Level_Dsc__c =emp.Level_Dsc_Job__c;
            sevPara .Level__c =emp.Level_Job__c ;
            sevPara .Primary_Key__c = emp.MS_MSSB__c+'-'+emp.Level_Dsc_Job__c+'-'+emp.Job_Country_Job__c;
            insert sevPara;
            
            list<Project_Level__c> listProjLevel = new list<Project_Level__c>();
            
            Project_Level__c projLevel = new Project_Level__c();
            projLevel .Project__c = proj.id;
            projLevel .Severance_Parameters__c = sevPara.id;
            insert projLevel;    
            
            list<Project_Decisional_Unit__c> pduList = new list<Project_Decisional_Unit__c>();
            
            Project_Decisional_Unit__c projDU = new Project_Decisional_Unit__c();
            projDU .Project__c =proj.id;
            insert projDu;
            
            
            RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
            testUtil.insertOrgHierarchy();
            
            Coverage_Entitlement__c covEntl =new Coverage_Entitlement__c ();
            covEntl.HR_Name__c = emp.Id;
            insert covEntl;  
            
            Coverage_Entitlement_Org__c covEntlOrg = new Coverage_Entitlement_Org__c();
            covEntlOrg .Coverage_Entitlement__c = covEntl.id;
            
            //covEntlOrg .Coverage_Entitlement_Org_Code__c ='10910 - Global Wealth Management Group';
            covEntlOrg.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            covEntlOrg .Coverage_Entitlement_Type__c = 'Super Division';
            insert covEntlOrg ;
            
            
         list <Severance_And_Release__c> snrlist = new List<Severance_And_Release__c>();
            
            RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1]; 
            
            Severance_And_Release__c snr = new Severance_And_Release__c();
            snr.Project_Level__c =  projLevel.id;
            snr.Employee__c  = emp.id;
            snr.recordTypeId = srrt.id;
            snr.Status__c  = 'Selected';
            snr.Communicated__c=false;
            snr.Historical_Data_Load__c=false;
            //snr.Project__c=proj.id;
            insert snr;
           
             Severance_And_Release__c snr2  = [Select name from Severance_And_Release__c where Id = :snr.Id];
            
      
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();   
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            //projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Project_Decisional_Unit__c = projDU.id;
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.ProjectID__c = proj.id;
            insert projOrgLevel;                
            
            Severance_Release_ETL_Temp__c sretl = new Severance_Release_ETL_Temp__c();
             									sretl.Changed_Fields__c = 'Address 4 - Home| DOH Original| Job State -Job|Job Title Dsc Job';
												sretl.Employee__c = emp.Id;
												sretl.Project__c = proj.Id;
												sretl.Severance_And_Release__c = snr.Id;
												sretl.Active__c = True;
           
		insert sretl;    
            
            
            Test.startTest();
            
            PageReference pageRef = Page.RIF_EmployeeSyncSelectPage;
            Test.setCurrentPage(pageRef);
            // ApexPages.currentPage().getParameters().put('RecordType', PROJECT_BASED_TERMINATION);
            ApexPages.currentPage().getParameters().put('projectId', proj.Id); 
            ApexPages.currentPage().getParameters().put('snrName', snr2.Name);
            
                      

            Apexpages.StandardController sc = new Apexpages.StandardController(proj);
            RIF_EmployeeSyncSelect empselec = new  RIF_EmployeeSyncSelect(sc);         
                   
            RIF_EmployeeSyncSelect.WrapperSNR wrap=new  RIF_EmployeeSyncSelect.WrapperSNR (snr,true,sretl);
            empselec.listWrapper.add(wrap);
            
                 RIF_EmployeeSyncSelect.WrapperSNR wrap1=new  RIF_EmployeeSyncSelect.WrapperSNR (snr,false,sretl);
            empselec.listWrapper.add(wrap1);
            
            
       
            
            //empselec.snrList=snr;
                
             Boolean hasNext = empselec.hasNext;
            Boolean hasPrevious = empselec.hasPrevious;
            Integer pageNumber = empselec.pageNumber;
            
            
            
            
             empselec.getTotalPages();
            empselec.getAllSNRs();
            empselec.syncSNRs();
            empselec.redirectPrj();        
            empselec.first();
            empselec.last();
            empselec.previous();
            empselec.next();
            empselec.cancel();
           
           
            
            
            
            
            Test.stopTest();
        }  
  }
    
 static testMethod void RIF_EmployeeSyncSelectTest2() {
        
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
        User tempUser1  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Phillips', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p1.Id, FirstName='Aaron', Emp_Id__c = '84JWP', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser1;
         PermissionSet perSe1 = new PermissionSet();
            perSe1 = [Select Id from PermissionSet where Name = 'RIF_HR_Coverage'];
            
            PermissionSetAssignment perSetAs = new PermissionSetAssignment(PermissionSetId = perSe1.id, AssigneeId = tempUser1.Id);
            insert perSetAs;
        
        System.runAs(tempuser1){     
            //RIF_TestClassUtilities.setAllTriggerOn();
           
            
            Employee__c emp = new Employee__c(
                Name='Employee2',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                Job_Region_Code__c='EU',Emp_ID__c = 'test',User__c= tempUser1.id,City_Home__c='City',Zip_Home__c='1234',
                State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',Level_Job__c = '40',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Non-Exempt',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            RecordType rt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Project__c' limit 1];
            // RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1];
            System.debug('#########'+rt.id);
            Project__c proj  = new Project__c();
            
            proj.Communication_Date__c = System.today();
            proj.Country__c = 'USA';
            proj.Notice_Days__c = 19;
            proj.Is_Locked_By_Conga__c = false;
            proj.Package_Status__c = 'Running';
            proj.Package_Status_Message__c = 'hello';
            proj.Primary_Key__c = 'primkey';
            proj.Status__c = 'Active';
            proj.Super_Division__c ='Global Wealth Management Group';
            proj.System_Super_Division__c = 'Wealth Management';
            proj.Template__c = 'sample';
            proj.Template1__c = 'Template 2';
            proj.Termination_Date__c =System.today().addDays(19);
            proj.WARN__c = false;
            proj.RecordTypeId = rt.id;
            
       
            
            //proj.RecordTypeId = srrt.id;
            insert proj;
            
            
            List<Project__c> projList = new List<Project__c>();
            
            Severance_Parameters__c sevPara = new Severance_Parameters__c();
            sevPara .Country__c =emp.Job_Country_Job__c;
            sevPara .MS_MSSB__c =emp.MS_MSSB__c;
            sevPara .Level_Dsc__c =emp.Level_Dsc_Job__c;
            sevPara .Level__c =emp.Level_Job__c ;
            sevPara .Primary_Key__c = emp.MS_MSSB__c+'-'+emp.Level_Dsc_Job__c+'-'+emp.Job_Country_Job__c;
            insert sevPara;
            
            list<Project_Level__c> listProjLevel = new list<Project_Level__c>();
            
            Project_Level__c projLevel = new Project_Level__c();
            projLevel .Project__c = proj.id;
            projLevel .Severance_Parameters__c = sevPara.id;
            insert projLevel;    
            
            list<Project_Decisional_Unit__c> pduList = new list<Project_Decisional_Unit__c>();
            
            Project_Decisional_Unit__c projDU = new Project_Decisional_Unit__c();
            projDU .Project__c =proj.id;
            insert projDu;
            
            
            RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
            testUtil.insertOrgHierarchy();
            
            Coverage_Entitlement__c covEntl =new Coverage_Entitlement__c ();
            covEntl.HR_Name__c = emp.Id;
            insert covEntl;  
            
            Coverage_Entitlement_Org__c covEntlOrg = new Coverage_Entitlement_Org__c();
            covEntlOrg .Coverage_Entitlement__c = covEntl.id;
            
            //covEntlOrg .Coverage_Entitlement_Org_Code__c ='10910 - Global Wealth Management Group';
            covEntlOrg.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            covEntlOrg .Coverage_Entitlement_Type__c = 'Super Division';
            insert covEntlOrg ;
            
            
         list <Severance_And_Release__c> snrlist = new List<Severance_And_Release__c>();
            
            RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1]; 
            
            Severance_And_Release__c snr = new Severance_And_Release__c();
            snr.Project_Level__c =  projLevel.id;
            snr.Employee__c  = emp.id;
            snr.recordTypeId = srrt.id;
            snr.Status__c  = 'Selected';
            snr.Communicated__c=false;
            snr.Historical_Data_Load__c=false;
            //snr.Project__c=proj.id;
            insert snr;
           
             Severance_And_Release__c snr2  = [Select name from Severance_And_Release__c where Id = :snr.Id];
            
      
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();   
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            //projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Project_Decisional_Unit__c = projDU.id;
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.ProjectID__c = proj.id;
            insert projOrgLevel;                
            
            Severance_Release_ETL_Temp__c sretl = new Severance_Release_ETL_Temp__c();
             									sretl.Changed_Fields__c = 'Address 4 - Home| DOH Original| Job State -Job|Job Title Dsc Job';
												sretl.Employee__c = emp.Id;
												sretl.Project__c = proj.Id;
												sretl.Severance_And_Release__c = snr.Id;
												sretl.Active__c = True;
           
		insert sretl;    
            
            
            Test.startTest();
            
            PageReference pageRef = Page.RIF_EmployeeSyncSelectPage;
            Test.setCurrentPage(pageRef);
            // ApexPages.currentPage().getParameters().put('RecordType', PROJECT_BASED_TERMINATION);
            ApexPages.currentPage().getParameters().put('projectId', proj.Id); 
            ApexPages.currentPage().getParameters().put('snrName', snr2.Name);
            
                      

            Apexpages.StandardController sc = new Apexpages.StandardController(proj);
            RIF_EmployeeSyncSelect empselec = new  RIF_EmployeeSyncSelect(sc);         
                   
         
            
                 RIF_EmployeeSyncSelect.WrapperSNR wrap1=new  RIF_EmployeeSyncSelect.WrapperSNR (snr,false,sretl);
            empselec.listWrapper.add(wrap1);
            
            
       
            
            //empselec.snrList=snr;
                
             Boolean hasNext = empselec.hasNext;
            Boolean hasPrevious = empselec.hasPrevious;
            Integer pageNumber = empselec.pageNumber;
            
            
            
            
             empselec.getTotalPages();
            empselec.getAllSNRs();
            empselec.syncSNRs();
            empselec.redirectPrj();        
            empselec.first();
            empselec.last();
            empselec.previous();
            empselec.next();
            empselec.cancel();
           
           
            
            
            
            
            Test.stopTest();
        }  
  }

 static testMethod void RIF_EmployeeSyncSelectTest3() {
        
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
        User tempUser1  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Phillips', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p1.Id, FirstName='Aaron', Emp_Id__c = '84JWP', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser1;
         PermissionSet perSe1 = new PermissionSet();
            perSe1 = [Select Id from PermissionSet where Name = 'RIF_HR_Coverage'];
            
            PermissionSetAssignment perSetAs = new PermissionSetAssignment(PermissionSetId = perSe1.id, AssigneeId = tempUser1.Id);
            insert perSetAs;
        
        System.runAs(tempuser1){     
            //RIF_TestClassUtilities.setAllTriggerOn();
           
            
            Employee__c emp = new Employee__c(
                Name='Employee2',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                Job_Region_Code__c='EU',Emp_ID__c = 'test',User__c= tempUser1.id,City_Home__c='City',Zip_Home__c='1234',
                State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',Level_Job__c = '40',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Non-Exempt',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            RecordType rt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Project__c' limit 1];
            // RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1];
            System.debug('#########'+rt.id);
            Project__c proj  = new Project__c();
            
            proj.Communication_Date__c = System.today();
            proj.Country__c = 'USA';
            proj.Notice_Days__c = 19;
            proj.Is_Locked_By_Conga__c = false;
            proj.Package_Status__c = 'Running';
            proj.Package_Status_Message__c = 'hello';
            proj.Primary_Key__c = 'primkey';
            proj.Status__c = 'Active';
            proj.Super_Division__c ='Global Wealth Management Group';
            proj.System_Super_Division__c = 'Wealth Management';
            proj.Template__c = 'sample';
            proj.Template1__c = 'Template 2';
            proj.Termination_Date__c =System.today().addDays(19);
            proj.WARN__c = false;
            proj.RecordTypeId = rt.id;
            
       
            
            //proj.RecordTypeId = srrt.id;
            insert proj;
            
            
            List<Project__c> projList = new List<Project__c>();
            
            Severance_Parameters__c sevPara = new Severance_Parameters__c();
            sevPara .Country__c =emp.Job_Country_Job__c;
            sevPara .MS_MSSB__c =emp.MS_MSSB__c;
            sevPara .Level_Dsc__c =emp.Level_Dsc_Job__c;
            sevPara .Level__c =emp.Level_Job__c ;
            sevPara .Primary_Key__c = emp.MS_MSSB__c+'-'+emp.Level_Dsc_Job__c+'-'+emp.Job_Country_Job__c;
            insert sevPara;
            
            list<Project_Level__c> listProjLevel = new list<Project_Level__c>();
            
            Project_Level__c projLevel = new Project_Level__c();
            projLevel .Project__c = proj.id;
            projLevel .Severance_Parameters__c = sevPara.id;
            insert projLevel;    
            
            list<Project_Decisional_Unit__c> pduList = new list<Project_Decisional_Unit__c>();
            
            Project_Decisional_Unit__c projDU = new Project_Decisional_Unit__c();
            projDU .Project__c =proj.id;
            insert projDu;
            
            
            RIF_OrgHierarchy_TestUtil testUtil = new RIF_OrgHierarchy_TestUtil();
            testUtil.insertOrgHierarchy();
            
            Coverage_Entitlement__c covEntl =new Coverage_Entitlement__c ();
            covEntl.HR_Name__c = emp.Id;
            insert covEntl;  
            
            Coverage_Entitlement_Org__c covEntlOrg = new Coverage_Entitlement_Org__c();
            covEntlOrg .Coverage_Entitlement__c = covEntl.id;
            
            //covEntlOrg .Coverage_Entitlement_Org_Code__c ='10910 - Global Wealth Management Group';
            covEntlOrg.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            covEntlOrg .Coverage_Entitlement_Type__c = 'Super Division';
            insert covEntlOrg ;
            
            
         list <Severance_And_Release__c> snrlist = new List<Severance_And_Release__c>();
            
            RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1]; 
            
            Severance_And_Release__c snr = new Severance_And_Release__c();
            snr.Project_Level__c =  projLevel.id;
            snr.Employee__c  = emp.id;
            snr.recordTypeId = srrt.id;
            snr.Status__c  = 'Selected';
            snr.Communicated__c=false;
            snr.Historical_Data_Load__c=false;
            snr.Project__c=proj.id;
            insert snr;
           
             Severance_And_Release__c snr2  = [Select name from Severance_And_Release__c where Id = :snr.Id];
            
      
            
            Child_Project_Decisional_Unit__c projOrgLevel = new Child_Project_Decisional_Unit__c();   
            projOrgLevel.Decisional_Unit_Type__c = 'Super Division';
            //projOrgLevel.Decisional_Unit_Code__c = orgCode.id;
            projOrgLevel.Project_Decisional_Unit__c = projDU.id;
            projOrgLevel.Org_Hierarchy_Code__c = '10910 - Wealth Management';
            projOrgLevel.ProjectID__c = proj.id;
            insert projOrgLevel;                
            
            Severance_Release_ETL_Temp__c sretl = new Severance_Release_ETL_Temp__c();
             									sretl.Changed_Fields__c = 'Address 4 - Home| DOH Original| Job State -Job|Job Title Dsc Job';
												sretl.Employee__c = emp.Id;
												sretl.Project__c = proj.Id;
												sretl.Severance_And_Release__c = snr.Id;
												sretl.Active__c = True;
           
		insert sretl;    
            
            
            Test.startTest();
            
            PageReference pageRef = Page.RIF_EmployeeSyncSelectPage;
            Test.setCurrentPage(pageRef);
            // ApexPages.currentPage().getParameters().put('RecordType', PROJECT_BASED_TERMINATION);
            ApexPages.currentPage().getParameters().put('projectId', proj.Id); 
            ApexPages.currentPage().getParameters().put('snrName', snr2.Name);
            
                      

            Apexpages.StandardController sc = new Apexpages.StandardController(proj);
            RIF_EmployeeSyncSelect empselec = new  RIF_EmployeeSyncSelect(sc);         
                   
         
            
                 RIF_EmployeeSyncSelect.WrapperSNR wrap1=new  RIF_EmployeeSyncSelect.WrapperSNR (snr,true,sretl);
            empselec.listWrapper.add(wrap1);
            
             RIF_EmployeeSyncSelect.WrapperSNR wrap=new  RIF_EmployeeSyncSelect.WrapperSNR (snr,sretl);
            empselec.listWrapper.add(wrap);
       
            
            
                
             Boolean hasNext = empselec.hasNext;
            Boolean hasPrevious = empselec.hasPrevious;
            Integer pageNumber = empselec.pageNumber;
            
            
            
            
             empselec.getTotalPages();
            empselec.getAllSNRs();
           /* empselec.syncSNRs();
            empselec.redirectPrj();        
            empselec.first();
            empselec.last();
            empselec.previous();
            empselec.next();
            empselec.cancel();*/
           
           
            
            
            
            
            Test.stopTest();
        }  
  }

    
    
       
    
    
    
}