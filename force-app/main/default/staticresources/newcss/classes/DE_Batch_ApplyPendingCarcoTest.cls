@isTest
public class DE_Batch_ApplyPendingCarcoTest{

    static testMethod void batchFFIECTest(){
        
         Test.StartTest();
         
       
         
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
         User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
         insert tempUser;
        
         System.debug('userId: ' + tempUser.Id);
        
          Dual_Hat_Eligible_Config__c detElCo = new Dual_Hat_Eligible_Config__c(Job_Code_Job__c = '601337', Job_Title_Dsc_Job__c = 'Private Wealth Advisor');
       insert detElCo;
        
        Employee__c emp = new Employee__c(
            Name='Dual Employee',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
            Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
            Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
            Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
            gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
            Job_Region_Code__c='EU',Emp_ID__c = 'Test',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
            State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
            Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
            Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
            Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
            Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',gender__c='F',
            citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
            Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
            Login_Id_Directory__c='test',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Status__c='Active',Dept_Org__c='81826');
        insert emp;
        
        
           emp.Jobcode_Job__c = '601337';
        update emp;
 
                
            Dual_Employ_Pending_FFIEC_Status__c pendCarco = new Dual_Employ_Pending_FFIEC_Status__c(
            MSID__c='Test', Dual_Hat_FFIEC_Status_Date__c=Date.newInstance(2015,10,20),Dual_Employment_FFIEC_Status__c = 'CLER');
        insert pendCarco ;
       
       
         DE_Batch_ApplyPendingCarco pendCarcoBatch = new DE_Batch_ApplyPendingCarco ();
         Id batchprocessid = Database.executeBatch(pendCarcoBatch);
       
        Test.StopTest();
    
    }
}