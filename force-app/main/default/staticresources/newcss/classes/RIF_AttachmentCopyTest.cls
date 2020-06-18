@isTest

public class RIF_AttachmentCopyTest{
 public static final string PROJECT_BASED_TERMINATION = 'Project Based Termination';
    public static testMethod void attachCopyTest(){
       
       Set<ID> srBatchSet;
       Boolean updateSR;
       Map<ID,Map<ID,List<Attachment>>> fromToDU;
       Map<ID,Map<ID,List<Attachment>>> fromToSRDoc;
       set<String> congaTemp;
       
      
       RecordType srrt = [Select Id from RecordType where Name = : PROJECT_BASED_TERMINATION and SobjectType = 'Severance_And_Release__c' limit 1];
       
       Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'arphil', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Phillips', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='Aaron', Emp_Id__c = '84JWP', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
        System.runAs(tempUser){
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
            Login_Id_Directory__c='arphil',Poi_Type__c='1',Job_Country_Job__c = 'USA',Status__c='Active',Dept_Org__c='11001');
        insert emp;
       
       Severance_And_Release__c snr = new Severance_And_Release__c();
             snr.Project_Level__c =  'a0Ef0000003k7hs';
             snr.Employee__c  = emp.id;
             snr.recordTypeId = srrt.id;
             snr.Status__c  = 'Selected';
         insert snr;
       
    ApexPages.currentPage().getParameters().put('id', snr.id);   
      
     RIF_AttachmentCopy rifAttCpy = new RIF_AttachmentCopy(updateSR, srBatchSet, fromToDU, fromToSRDoc, congaTemp); 
     
       Database.executeBatch(rifAttCpy);
        
         }   
    }
}