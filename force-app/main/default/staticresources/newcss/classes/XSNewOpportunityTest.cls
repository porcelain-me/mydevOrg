@isTest(seeAllData= true)

public class XSNewOpportunityTest {
    
    static testMethod void xsNewOppTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
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
            Division_Dsc_Org__c='Quality Assurance & Prod Mgmt', email__c = 'SystemAdministrator@testorg.com',
            Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
            Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
            Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
            Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
            citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
            Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
            Login_Id_Directory__c='test',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Status__c='Active',Dept_Org__c='81826');
        insert emp;
        
        Cross_Sell__c xs =new Cross_Sell__c();
        xs.Why_significant__c='Significant';
        xs.Transaction_Status__c='Booked';
        xs.Transaction_Product_Type__c='test2';
        xs.Stage__c='Draft';
        xs.Size_of_Transaction__c='1';
        xs.Revenues_000s__c='1';
        xs.Other_Comments__c='Other Comments';
        xs.One_time_fee_vs_Ongoing__c='On Going';
        xs.Nominee__c=emp.Id;
        xs.MNPI__c=true;
        xs.Intra_ISG__c=true;
        xs.First_time_business__c=true;
        xs.Declaration__c=true;
        xs.Closed_Date__c=Date.newInstance(2015,10,30);
        xs.Client_Type_Industry__c='test2';
        xs.Client_Name__c='Job Level';
        insert xs;
        
        xs.Stage__c = 'submitted';
        update xs;
        
        PageReference pageRef = Page.XS_Opportunity_NewRecordP;
        pageRef.getParameters().put('parentRecordId',xs.id);
        
        Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(pageRef);
        
        XSNewOpportunity xsnewopp = new XSNewOpportunity(new ApexPages.StandardController(xs));
        
        test.startTest();
            xsnewopp.nominee='testing'; 
            xsnewopp.nomineeName='Test';
            xsnewopp.nomineeDivision='hr';
            xsnewopp.nomineeTitle='test';
            xsnewopp.nomineeRegion='in';
            xsnewopp.nomineeMSID='34lhf';
            xsnewopp.nomineeManager='manager';
            xsnewopp.nomineeGroup='test';
            xsnewopp.XS_OtherIndivs='test';
            xsnewopp.individualName='individual';
            xsnewopp.individualName1='individual1';
            xsnewopp.individualName2='individual2';
            xsnewopp.calledFrom='test';
            xsnewopp.OtherIndividualsInvolved='test';
            
        
            xsnewopp.selFTBoption = '';
            xsnewopp.otherDivsInvolved = '';
            xsnewopp.otherIndivsInvolved = '';
            xsnewopp.XSellObj = xs;
            
            xsnewopp.filterEmployee();
            xsnewopp.SaveXSell();
            xsnewopp.SubmitXSell();
            xsnewopp.CancelXSell();
           // xsnewopp.closewindow();
            xsnewopp.searchNominee();
            xsnewopp.decSet();
            xsnewopp.ftbSet();
            xsnewopp.mnpiSet();
            xsnewopp.isgSet();
            xsnewopp.FilterNominee();
            xsnewopp.setNomineeName();
            xsnewopp.selFTBoption();
            xsnewopp.selMNPIoption();
            xsnewopp.getotherDivspicklist();
            xsnewopp.getmnpipicklistVals();
            xsnewopp.getotherDivspicklistOptional();
            
            
        
        test.stopTest();
    }
    
    static testMethod void xsNewOppTest1() { 
        Cross_Sell__c xs =new Cross_Sell__c();
        ApexPages.StandardController apsc = new ApexPages.StandardController(xs);
        XSNewOpportunity xsnewopp = new XSNewOpportunity(apsc);
        
        Test.startTest();
        
            xsnewopp.nomineeDivision='hr';
            xsnewopp.nomineeName='Test';
            xsnewopp.nomineeTitle='test';
            xsnewopp.nomineeRegion='in';
            xsnewopp.nomineeMSID='34lhf';
            xsnewopp.nomineeManager='manager';
            xsnewopp.nomineeGroup='test';
            
            xsnewopp.mnpi =true;
            xsnewopp.ftb =true;
            xsnewopp.dec =true;
            xsnewopp.isg =true;
            
            xsnewopp.decSet();
            xsnewopp.ftbSet();
            xsnewopp.mnpiSet();
            xsnewopp.isgSet();
            xsnewopp.otherCommentsErrorMessage = true;
            xsnewopp.significantErrorMessage =true;
        
        Test.stopTest();
    } 
    
    static testMethod void xsNewOppTest3() { 
        Cross_Sell__c xs = new Cross_Sell__c();
        xs.Client_Name__c = '';
        xs.Client_Type_Industry__c = '';
        xs.Why_significant__c = null;
        xs.Other_Comments__c = null;
        
        XSNewOpportunity xsnewopp = new XSNewOpportunity(new ApexPages.StandardController(xs));
        xsnewopp.XSellObj = xs;
        
        Test.startTest();
        
            xsnewopp.validateForm();
            xsnewopp.getpicklistVals();
        
        Test.stopTest();
    }
}