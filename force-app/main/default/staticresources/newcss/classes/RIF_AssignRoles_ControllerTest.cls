@isTest
public class RIF_AssignRoles_ControllerTest
{        
       
        
        static testMethod void mainTestDataMethod(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
        
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
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Professional',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
                    
            assignRolesctrl.roleType= 'HR Coverage'; 
            assignRolesctrl.jobStatus='complete';
            assignRolesctrl.userid=tempUser.id;
            assignRolesctrl.AssignPermissionSet();
                         
            assignRolesctrl  .empSfIDWithNoEntitlement =emp.id;
            assignRolesctrl  .jobStatus ='Complete';
            assignRolesctrl  .error ='error';
            assignRolesctrl  .typeOfMessage ='message';
            assignRolesctrl  .searchText = 'Abhijeet Tripathy'; 
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            System.debug('@@@@@@@@'+emWrap .userid);
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
            
           
       
            assignRolesctrl .initializeMemebers();
            assignRolesctrl .getUsers('load');
            assignRolesctrl .search();
            assignRolesctrl .changeUserProfile(tempUser .id,p.id);
            assignRolesctrl .addCovEntitlement();
            assignRolesctrl  .DeassignPermissionSet();
            assignRolesctrl .cancel();
           
           }
           
           Test.stopTest(); 
           
      }    
      
      
       static testMethod void mainTestDataMethod1(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
        
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
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Professional',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
                    
            assignRolesctrl.roleType= 'HR Operations'; 
            assignRolesctrl.jobStatus='complete';
            assignRolesctrl.userid=tempUser.id;
            assignRolesctrl.AssignPermissionSet();
                         
            assignRolesctrl  .empSfIDWithNoEntitlement =emp.id;
            assignRolesctrl  .jobStatus ='Complete';
            assignRolesctrl  .error ='error';
            assignRolesctrl  .typeOfMessage ='message';
            assignRolesctrl  .searchText = 'Abhijeet Tripathy'; 
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            System.debug('@@@@@@@@'+emWrap .userid);
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
            
           
       
            assignRolesctrl .initializeMemebers();
            assignRolesctrl .getUsers('load');
            assignRolesctrl .search();
            assignRolesctrl .changeUserProfile(tempUser .id,p.id);
            assignRolesctrl  .DeassignPermissionSet();
            assignRolesctrl .addCovEntitlement();
            assignRolesctrl .cancel();
           
           }
           
           Test.stopTest(); 
           
      }    
      
      
       static testMethod void mainTestDataMethod2(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
        
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
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Professional',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
                    
            assignRolesctrl.roleType= 'HR Compensation'; 
            assignRolesctrl.jobStatus='complete';
            assignRolesctrl.userid=tempUser.id;
            assignRolesctrl.AssignPermissionSet();
                         
            assignRolesctrl  .empSfIDWithNoEntitlement =emp.id;
            assignRolesctrl  .jobStatus ='Complete';
            assignRolesctrl  .error ='error';
            assignRolesctrl  .typeOfMessage ='message';
            assignRolesctrl  .searchText = 'Abhijeet Tripathy'; 
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            System.debug('@@@@@@@@'+emWrap .userid);
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
            
           
       
            assignRolesctrl .initializeMemebers();
            assignRolesctrl .getUsers('load');
            assignRolesctrl .search();
            assignRolesctrl .changeUserProfile(tempUser .id,p.id);
            assignRolesctrl  .DeassignPermissionSet();
            assignRolesctrl .addCovEntitlement();
            assignRolesctrl .cancel();
           
           }
           
           Test.stopTest(); 
           
      }    
      
      
       static testMethod void mainTestDataMethod3(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
        
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
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Professional',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
                    
            assignRolesctrl.roleType= 'HR International'; 
            assignRolesctrl.jobStatus='complete';
            assignRolesctrl.userid=tempUser.id;
            assignRolesctrl.AssignPermissionSet();
                         
            assignRolesctrl  .empSfIDWithNoEntitlement =emp.id;
            assignRolesctrl  .jobStatus ='Complete';
            assignRolesctrl  .error ='error';
            assignRolesctrl  .typeOfMessage ='message';
            assignRolesctrl  .searchText = 'Abhijeet Tripathy'; 
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            System.debug('@@@@@@@@'+emWrap .userid);
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
            
           
       
            assignRolesctrl .initializeMemebers();
            assignRolesctrl .getUsers('load');
            assignRolesctrl .search();
            assignRolesctrl .changeUserProfile(tempUser .id,p.id);
            assignRolesctrl  .DeassignPermissionSet();
            assignRolesctrl .addCovEntitlement();
            assignRolesctrl .cancel();
           
           }
           
           Test.stopTest(); 
           
      }    
      
      
       static testMethod void mainTestDataMethod4(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
        
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
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Professional',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
                    
            assignRolesctrl.roleType= 'System Admin'; 
            assignRolesctrl.jobStatus='complete';
            assignRolesctrl.userid=tempUser.id;
            assignRolesctrl.AssignPermissionSet();
                         
            assignRolesctrl  .empSfIDWithNoEntitlement =emp.id;
            assignRolesctrl  .jobStatus ='Complete';
            assignRolesctrl  .error ='error';
            assignRolesctrl  .typeOfMessage ='message';
            assignRolesctrl  .searchText = 'Abhijeet Tripathy'; 
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            System.debug('@@@@@@@@'+emWrap .userid);
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
            
           
       
            assignRolesctrl .initializeMemebers();
            assignRolesctrl .getUsers('load');
            assignRolesctrl .search();
            assignRolesctrl .changeUserProfile(tempUser .id,p.id);
            assignRolesctrl  .DeassignPermissionSet();
            assignRolesctrl .addCovEntitlement();
            assignRolesctrl .cancel();
           
           }
           
           Test.stopTest(); 
           
      }    
      
      
       static testMethod void mainTestDataMethod5(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
        
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
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Professional',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
                    
            assignRolesctrl.roleType= 'Document Admin'; 
            assignRolesctrl.jobStatus='complete';
            assignRolesctrl.userid=tempUser.id;
            assignRolesctrl.AssignPermissionSet();
                         
            assignRolesctrl  .empSfIDWithNoEntitlement =emp.id;
            assignRolesctrl  .jobStatus ='Complete';
            assignRolesctrl  .error ='error';
            assignRolesctrl  .typeOfMessage ='message';
            assignRolesctrl  .searchText = 'Abhijeet Tripathy'; 
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            System.debug('@@@@@@@@'+emWrap .userid);
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
            
           
       
            assignRolesctrl .initializeMemebers();
            assignRolesctrl .getUsers('load');
            assignRolesctrl .search();
            assignRolesctrl .changeUserProfile(tempUser .id,p.id);
            assignRolesctrl  .DeassignPermissionSet();
            assignRolesctrl .addCovEntitlement();
            assignRolesctrl .cancel();
           
           }
           
           Test.stopTest(); 
           
      }    
     
          static testMethod void mainTestDataMethod6(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
        
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
                Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                MS_MSSB__c = 'MSSB',Job_Country_Job__c='USA',Division_Dsc_Org__c='Wealth Management Field',Super_Division_Dsc_Org__c='Wealth Management',
                Super_Division__c='10910',Job_Function_Dsc__c='Financial Advisor',Job_Title_Dsc_Job__c='FA Intermediate',Level_Dsc_Job__c='Professional',
                Division_Org__c='99190',Cost_Center__c='100310',Sub_Depart2_Org__c='26410',Subdept_Org__c='12082',Dept_Org__c='11018',Super_Depart_Org__c='25305',
                
                Login_Id_Directory__c='test',Poi_Type__c='1',Status__c='Active');
            insert emp;
            
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
                    
            assignRolesctrl.roleType= 'Generic User'; 
            assignRolesctrl.jobStatus='complete';
            assignRolesctrl.userid=tempUser.id;
            assignRolesctrl.AssignPermissionSet();
                         
            assignRolesctrl  .empSfIDWithNoEntitlement =emp.id;
            assignRolesctrl  .jobStatus ='Complete';
            assignRolesctrl  .error ='error';
            assignRolesctrl  .typeOfMessage ='message';
            assignRolesctrl  .searchText = 'Abhijeet Tripathy'; 
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            System.debug('@@@@@@@@'+emWrap .userid);
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
            
           
       
            assignRolesctrl .initializeMemebers();
            assignRolesctrl .getUsers('load');
            assignRolesctrl .search();
            assignRolesctrl .changeUserProfile(tempUser .id,p.id);
            assignRolesctrl  .DeassignPermissionSet();
            assignRolesctrl .addCovEntitlement();
            assignRolesctrl .cancel();
           
           }
           
           Test.stopTest(); 
           
      }  
      
      
      static testMethod void mainTestDataMethod7(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee' LIMIT 1]; 
             User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
             insert tempUser;
        
            test.startTest();
        
            System.runAs(tempUser){
            
            RIF_AssignRoles_Controller assignRolesctrl = new RIF_AssignRoles_Controller();
          
            RIF_AssignRoles_Controller.employeeWrapper emWrap = new RIF_AssignRoles_Controller.employeeWrapper ();
            
            emWrap.name='Employee2';
            emWrap .empSFID='testu';
            emWrap .userid=tempUser.id;
            emWrap .email='SystemAdministrator@testorg.com';
            emWrap .Emp_ID='34LHF';
            emWrap .username='SystemAdministrator@testorg.com';
            emWrap .profile=p.id;
            emWrap .covEntitlementID='coventitlemtn';
            emWrap .eSuperDivision='wealth management';
         
            assignRolesctrl .getUsers('');
            assignRolesctrl .search();
           
           }
           
           Test.stopTest(); 
          }    
      
         
     }