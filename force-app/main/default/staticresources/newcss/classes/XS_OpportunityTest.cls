@isTest
private class XS_OpportunityTest {
    
    private static User insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='ALL MS Employee'  LIMIT 1]; 
        
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
        
        return tempUser;
    }
    
    private static Employee__c insertEmp(User tempUser) {
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
            Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
            Login_Id_Directory__c='test',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Status__c='Active',Dept_Org__c='81826');
        insert emp;
        
        return emp;
    }
    
    static testMethod void xsTest1() {
        
        User tempUser = XS_OpportunityTest.insertUser();
        Employee__c emp = XS_OpportunityTest.insertEmp(tempUser);
        
        Cross_Sell__c xs = new Cross_Sell__c();
        
        Test.setCurrentPage(Page.xs_opportunity);
        ApexPages.currentPage().getParameters().put('id', emp.id);
        
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
        xs.Deal_Product_Type__c = 'testproduct';
        xs.Decision__c ='test';
        xs.Nominee_Title__c ='MD';
        xs.Estimated_Timing_of_Transaction__c =system.today();
        xs.Quarter__c ='Q1 2016';
        xs.Nominee_Manager_s_Full_name__c ='tets manager';
        xs.Nominee_Division__c = 'IBD';
        xs.Nominee_Group__c='Department';
        xs.Nominee_Region__c ='NA';
        insert xs;
        
        // add permission set to user
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet permSet = [SELECT id FROM PermissionSet WHERE name = 'XS_Super_User'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = tempUser.Id;
            psa.PermissionSetId = permSet.Id;
            insert psa;
        }
        
        XS_Opportunity xsoppty;
        System.runAs(tempUser) {
            xsoppty = new XS_Opportunity();
            
            xs.Stage__c = 'submitted';
            update xs;
        }
        
        xsoppty.x =xs;
        
        Cross_Sell_Opty_Notes__c xsOptyN = new Cross_Sell_Opty_Notes__c();
        xsOptyN.Cross_Sell__c = xs.id;
        xsOptyN.Notes__c = 'Text';
        insert xsOptyN;
        
        System.debug('#######'+xs.id);
        ApexPages.currentPage().getParameters().put('id', xs.id);
        
        xsoppty.getRelatedCrossSellNotes();
        xsoppty.loadopps();
        xsoppty.create();
        xsoppty.editLine();
        
        if(xsoppty.xList.size() > 0)
            xsoppty.export();
        
        xsoppty.crossSellId = 'abcdvs';
        xsoppty.toDelete = '';
        xsoppty.crossSellId ='abvss';
        xsoppty.toDelete = xs.id;
        xsoppty.exportToCSV();
        xsoppty.deleteXSell();
        
    }
    
    static testMethod void xsTest2() {
        
        User tempUser = XS_OpportunityTest.insertUser();
        Employee__c emp = XS_OpportunityTest.insertEmp(tempUser);
        
        // add permission set to user
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet permSet = [SELECT id FROM PermissionSet WHERE name = 'XS_Private_Normal_User'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = tempUser.Id;
            psa.PermissionSetId = permSet.Id;
            insert psa;
        }
        
        Cross_Sell__c xs = new Cross_Sell__c();
        System.runAs(tempUser) {
            XS_Opportunity xsoppty = new XS_Opportunity();
        }
    }
    
    static testMethod void xsTest3() {
        
        User tempUser = XS_OpportunityTest.insertUser();
        Employee__c emp = XS_OpportunityTest.insertEmp(tempUser);
        
        // add permission set to user
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet permSet = [SELECT id FROM PermissionSet WHERE name = 'XS_Private_Delegates'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = tempUser.Id;
            psa.PermissionSetId = permSet.Id;
            insert psa;
        }
        
        Cross_Sell__c xs = new Cross_Sell__c();
        
        System.runAs(tempUser) {
            XS_Opportunity xsoppty = new XS_Opportunity();
        }  
        
    }
    
    static testMethod void xsTest4() {
        
        User tempUser = XS_OpportunityTest.insertUser();
        Employee__c emp = XS_OpportunityTest.insertEmp(tempUser);
        
        // add permission set to user
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet permSet = [SELECT id FROM PermissionSet WHERE name = 'XS_Public_Delegates'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = tempUser.Id;
            psa.PermissionSetId = permSet.Id;
            insert psa;
        }
        
        Cross_Sell__c xs = new Cross_Sell__c();
        
        System.runAs(tempUser) {
            XS_Opportunity xsoppty = new XS_Opportunity();
        }
        
    }
    
    static testMethod void xsTest5() {
        
        User tempUser = XS_OpportunityTest.insertUser();
        Employee__c emp = XS_OpportunityTest.insertEmp(tempUser);
        
        // add permission set to user
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet permSet = [SELECT id FROM PermissionSet WHERE name = 'XS_Normal_Users'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = tempUser.Id;
            psa.PermissionSetId = permSet.Id;
            insert psa;
        }
        
        Cross_Sell__c xs = new Cross_Sell__c();
        
        System.runAs(tempUser) {
            XS_Opportunity xsoppty = new XS_Opportunity();
            
            xsoppty.header = '';
            xsoppty.xList = new List<Cross_Sell__c>();
            xsoppty.crossSellId = '';
        
            xsoppty.isSuperUser = TRUE;
            xsoppty.isPrivateDelegateUser = TRUE;
            xsoppty.isPublicDelegateUser = TRUE;
            xsoppty.isPrivateNormalUser = TRUE;
            
            xsoppty.beneficiaryList = new  List<Employee__c>();
            
            xsoppty.PSASuperUserList = new List<PermissionSetAssignment>() ;
            xsoppty.PSAPrivateDelegateUserList = new List<PermissionSetAssignment>();
            xsoppty.PSAPrivateNormalUserList = new List<PermissionSetAssignment>();
            xsoppty.psaPublicDelegateUserList = new List<PermissionSetAssignment>();
            
            xsoppty.userName = '';
            xsoppty.lstwrapper = null;
            
            xsoppty.xSellCount = TRUE;
            xsoppty.applicationAccess = TRUE;
            xsoppty.toDelete = '';
        }
        
    }
}