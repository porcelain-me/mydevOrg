@isTest
public class RL_Validate_Test_Abhijeet {
    
    static testMethod void myTest(){
        
        RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name='TestAddress3',Building_City__c='Bangalore',Postal_Code__c='1234');
        insert newEmpOffice;    
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                      LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                      TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
                                      
        insert tempUser;                                  
        System.runAs(tempUser) {
            Employee__c newEmployee = new Employee__c(
                Name='Employee2',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                Job_Region_Code__c='EU',Emp_ID__c = 'test',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA', Job_Title_Dsc_Job__c='admin',
                Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                Login_Id_Directory__c='test',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Status__c='Active',Dept_Org__c='81826');
            insert newEmployee;
            
            newEmployee = [select id,emp_id__c, gender_dsc__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c
                       , Job_Title__c, Status__c , Country_Dsc_Home__c, CC_Region_Org__c, Job_Region_Code__c, Region_Dsc_Org__c
                       , Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c, Birth_Date__c
                       , Job_Country_Job__c,Empl_Class_Job__c,Empl_Class_Dsc_Job__c,Employee_Sub_Class__c, Email__c,Is_HR_Partner__c
                       , Base_Annual_Amount__c, IND_Basic_Salary_Amount__c from Employee__c where Id =:newEmployee.id];
        
            Reference_Letter__c refLetter = new Reference_Letter__c(name = 'Business Visa Letter' , Employment_Status__c = 'Active');
            insert refLetter;
        
            Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
            newLetter.Reference_Letter__c = refLetter.id;  
            newLetter.Address_by_Reference__c ='Name and Address';         
            newLetter.Conga_Employee_Gender__c = 'Female';        
            newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA';         
            newLetter.Conga_Adj_Hire_Date__c = date.today();                        
            newLetter.Conga_Covenant_Date__c= date.today();                                   
            newLetter.For_Employee__c = newEmployee.id;           
            newLetter.Requesting_Employee__c = newEmployee.id;                            
            insert newLetter; 
            
            RL_Validate obj = new RL_Validate();
            Test.startTest();
                obj.formatName('Abhijeet');
                obj.validateRequesteeStatus(newLetter, 'Active');
            Test.stopTest();    
        }
    
    }
}