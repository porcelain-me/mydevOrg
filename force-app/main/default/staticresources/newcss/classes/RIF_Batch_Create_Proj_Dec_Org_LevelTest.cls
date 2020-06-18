@isTest
public class RIF_Batch_Create_Proj_Dec_Org_LevelTest
{
    static testMethod void rifCreateProjLevelTest(){
    
        Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'arphil', Email='Sys@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Phillips', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='Aaron', Emp_Id__c = '84JWP', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='Sys@testorg.com');
        insert tempUser;
        
        Employee__c emp = new Employee__c(
            Name='Employee2',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
            Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
            Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
            Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
            gender_dsc__c='Male',First_Name__c='Aaron',Last_Name__c='Phillips',Empl_Class_Job__c='A',
            Job_Region_Code__c='NA',Emp_ID__c = '84JWP',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
            State_Home__c='NJ',State_Home_Dsc_Home__c='New Jersey',Country_Dsc_Home__c='USA',
            Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
            Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='USA',
            Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='NY',
            Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
            citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Not Signed',
            Country_Home__c='USA',
            Super_Division_Dsc_Org__c = 'Wealth Management',Division_Dsc_Org__c='Wealth Management Field',Cost_Center__c='100124',
            Sub_Depart2_Org__c='26216',Subdept_Org__c='12261',Division_Org__c='99190',Super_Division__c='10910',MS_MSSB__c='MSSB',
            Level_Dsc_Job__c='Non-Exempt',Job_Function_Dsc__c='FA Trainee',
            Login_Id_Directory__c='arphil',Poi_Type__c='1',Job_Country_Job__c = 'USA',Status__c='Active',Dept_Org__c='81200');
        insert emp;
        
        User tempUser1  = new User(Alias = 'boothale', Email='susi@ms.com', 
                                   EmailEncodingKey='UTF-8', LastName='Booth', LanguageLocaleKey='en_US', 
                                   LocaleSidKey='en_US', ProfileId = p.Id, FirstName='Alexandra', Emp_Id__c = '62LKP', 
                                   TimeZoneSidKey='America/Los_Angeles', UserName='susi@ms.com.dev');
        insert tempUser1;
        
        Employee__c emp1 = new Employee__c(
            Name='Employee3',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
            Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
            Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
            Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
            gender_dsc__c='Female',First_Name__c='Alexandra',Last_Name__c='Booth',Empl_Class_Job__c='A',
            Job_Region_Code__c='NA',Emp_ID__c = '62LKP',User__c= tempUser1.id,City_Home__c='City',Zip_Home__c='1234',
            State_Home__c='NJ',State_Home_Dsc_Home__c='New Jersey',Country_Dsc_Home__c='USA',
            Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
            Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
            Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
            Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
            citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Not Signed',
            Country_Home__c='USA',
            Super_Division_Dsc_Org__c = 'Company',Division_Dsc_Org__c='Human Resources',Cost_Center__c='7004',
            Sub_Depart2_Org__c='89722',Subdept_Org__c='97332',Division_Org__c='89521',Super_Division__c='10300',MS_MSSB__c='MS',
            Level_Dsc_Job__c='Non-Exempt',Job_Function_Dsc__c='Human Resources',Dept_Dsc_Org__c='Human Resources',
            Login_Id_Directory__c='boothale',Poi_Type__c='1',Job_Country_Job__c = 'USA',Status__c='Active',Dept_Org__c='81200');
        insert emp1 ;
        // coverage entitlemetns for the user 
        Coverage_Entitlement__c coveEt = new Coverage_Entitlement__c();
        coveEt.HR_Name__c = emp.Id;
        insert coveEt;
        // org coverage ent for the user
        Coverage_Entitlement_Org__c orgEnt = new Coverage_Entitlement_Org__c();
        orgEnt.Coverage_Entitlement__c = coveEt.Id;
        orgEnt.Coverage_Entitlement_Type__c = 'Super Division';
        orgEnt.Org_Hierarchy_Code__c = '98100 - Technology';
        insert orgEnt;
        
        final String queryString = 'SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, ConnectionReceivedId, ConnectionSentId, Project_Decisional_Unit__c, Project__c, Decisional_Unit_Type__c, Decisional_Unit_Code__c, Decisional_Unit__c, Total_Employees__c, Employee__c, Decisional_Unit_Derived__c, Emp_ID__c, ProjectID__c from Child_Project_Decisional_Unit__c';
        List<Employee__c> empList = new List<Employee__c>(); 
        
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
        insert proj;
        
        Project_Decisional_Unit__c projDecUnit = new Project_Decisional_Unit__c();
        system.debug(' --- emp -- ' + emp);
        system.debug(' --- emp1 -- ' + emp1);
        projDecUnit .Decisional_Unit_Name__c = 'Wealth Management';
        projDecUnit .Employee__c = emp.id;
        projDecUnit .HR_Signatory__c = emp1.id;
        projDecUnit .Project__c =proj.id;
        insert projDecUnit ;
        /*
Org_Codes__c orgCode = new Org_Codes__c();
orgCode .Code__c = '10910';
orgCode .Code_Type__c ='Super Division';
orgCode .Description__c ='Global Wealth Management Group';
insert orgCode;
*/
        // insert org hierarchy
        Org_Hierarchy__c OrgHierarchy = new Org_Hierarchy__c();
        OrgHierarchy.Effective_Status__c = true;
        OrgHierarchy.Super_Division__c  = '98100';
        OrgHierarchy.Super_Division_Description__c = 'Technology';
        insert OrgHierarchy;
        
        Child_Project_Decisional_Unit__c childProj = new Child_Project_Decisional_Unit__c();
        
        childProj.Total_Employees__c = 20;
        childProj.Decisional_Unit__c = 'decUnit';
        childProj.ProjectID__c = 'projid123';
        childProj.Decisional_Unit_Type__c = 'Super Division';
        childProj.Org_Hierarchy_Code__c = '98100 - Technology';
        //childProj.Employee__c = emp.id;
        childProj.Project_Decisional_Unit__c = projDecUnit.id;
        insert childProj ;
        
        Test.startTest();
        system.runAs(tempUser){
            RIF_Batch_Create_Proj_Dec_Org_Level rifBatch = new RIF_Batch_Create_Proj_Dec_Org_Level(queryString,childProj);
            Database.executeBatch(rifBatch);       
        }
        Test.stopTest();
    }
    
    
}