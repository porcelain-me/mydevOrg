@isTest
private class XSPartiesInvolvedUtilQueueable2Test{
    
    static testMethod void xsPIUtil2(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'Test', IsActive = true,
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
            
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
                Login_Id_Directory__c='test',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Status__c='Inactive',Dept_Org__c='81826');
            
        insert emp;
        
        Cross_Sell__C cross = new Cross_Sell__c();
        cross .Why_significant__c='Significant';
        cross .Transaction_Status__c='Booked';
        cross .Transaction_Product_Type__c='test2';
        cross .Stage__c='Draft';
        cross .Size_of_Transaction__c='1';
        cross .Revenues_000s__c='1';
        cross .Other_Comments__c='Other Comments';
        cross .One_time_fee_vs_Ongoing__c='On Going';
        cross .Nominee__c=emp.Id;
        cross .MNPI__c=true;
        cross .Intra_ISG__c=true;
        cross .First_time_business__c=true;
        cross .Declaration__c=true;
        cross .Closed_Date__c=Date.newInstance(2015,10,30);
        cross .Client_Type_Industry__c='test2';
        cross .Client_Name__c='Job Level';
        insert cross ;
            
        Cross_Sell_Parties_Involved__c crossparty = new Cross_Sell_Parties_Involved__c();
        
        crossparty .Cross_Sell__c = cross .id;
        crossparty .Division__c = 'Institutional Equity Division';
        crossparty .Employee__c = emp.id;
        crossparty .Role__c = 'Beneficiary';
        insert crossparty ;    
        
        list<id> newRecordIDsList = new list<id>();
        newRecordIDsList .add(crossparty .id);
        
        Set<ID> EmployeeIDs = new Set<ID>();
        EmployeeIDs .add(emp.id);
        
        list<String> DivisionNames = new list<String>();
        DivisionNames .add('XS_Public_Delegate_users');
        
        Set<ID> ParentXSellIDs = new Set<ID>();
        ParentXSellIDs .add(cross .id); 
        
        XSPartiesInvolvedUtilQueueable2 xsPIUtil2 = new XSPartiesInvolvedUtilQueueable2(EmployeeIDs, newRecordIDsList, DivisionNames, ParentXSellIDs);
        
        Test.startTest();
        
            Id queueId = System.enqueueJob(xsPIUtil2 );
        
        Test.stopTest();
        
    }
}