@isTest
private class XS_OpportunityEditTest {
    
    static testMethod void xsTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='XS Super Users'  LIMIT 1]; 
        
        User tempUser  = new User(Alias = 'standt', Email='sarah.philips@morganstanley.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
        
            System.debug('@@@@@@@@@@@@@@@@@@USERID ' + tempUser.Id);
            test.startTest();
            
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
            
            Cross_Sell__c xs = new Cross_Sell__c();
            xs.Why_significant__c='Significant';
            xs.Transaction_Status__c='Booked';
            xs.Transaction_Product_Type__c='test2';
            xs.Stage__c='draft';
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
            xs.Other_individuals_involved1__c = emp.id;
            xs.Other_individuals_involved2__c = emp.id;
            xs.Other_Divisions_Involved1__c = 'Institutional Equity Division';
            xs.Other_Divisions_Involved2__c = 'Strategic Relationship Management';
           
            insert xs;
           
            // add permission set to user
            System.runAs(new User(Id = Userinfo.getUserId())) {
                PermissionSet permSet = [SELECT id FROM PermissionSet WHERE name = 'XS_Super_User'];
                System.debug('@@@@@@@@@@@@@@@@@@PERMSETID ' + permSet.Id);
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = tempUser.Id;
                psa.PermissionSetId = permSet.Id;
                insert psa;
            }
            
            System.debug('Employee Id: ' + emp.Id);
            
            
            
            ApexPages.StandardController sc = new ApexPages.StandardController(xs);
            ApexPages.currentPage().getParameters().put('id', xs.id);
        
        System.runas(tempUser){            
            xs.Client_Name__c='Job Level2';
            xs.Stage__c='submitted';
            update xs;
            
            
            Cross_Sell_Opty_Notes__c xsoptnote = new Cross_Sell_Opty_Notes__c();
            xsoptnote.Cross_Sell__c = xs.id; //'CS-00000026';
            xsoptnote.Notes__c = 'any random text';
            System.debug('%%%%%%%%%%%%'+xs.id);
            insert xsoptnote;
            
            
            XS_OpportunityEdit xsOpptyEd = new XS_OpportunityEdit(sc);
            xsOpptyEd.x = xs;
            
            xsOpptyEd.selection ='division';
            xsOpptyEd.nominee = 'testNominee';
            xsOpptyEd.RequesteeNominee = 'Employee2';
            xsOpptyEd.isg = 'isg';
            xsOpptyEd.ftb = 'ftb';
            xsOpptyEd.dec = 'dec';
            xsOpptyEd.toDelete = 'delete';
            
            
            ApexPages.currentPage().getParameters().put('id', xs.id);
            ApexPages.currentPage().getParameters().put('crossSellOptyId', xs.id);
            xsOpptyEd.save();
            xsOpptyEd.AddOtherParties();
            xsOpptyEd.AddNotes();
            xsOpptyEd.Submit();
            xsOpptyEd.Approve();
            xsOpptyEd.decSet();
            xsOpptyEd.ftbSet();
            xsOpptyEd.CancelChanges();
            xsOpptyEd.mnpiSet();
            xsOpptyEd.isgSet();
            xsOpptyEd.closewindow();
            xsOpptyEd.searchNominee();
            xsOpptyEd.setRequesteeNominee();
            xsOpptyEd.setNotes();
            xsOpptyEd.CancelNotes();
            xsOpptyEd.saveNotes();
            xsOpptyEd.SaveData();
            xsOpptyEd.filterNominee();
            xsOpptyEd.addnotesPop();
            xsoptnote.Notes__c = 'Edited note';
            xsOpptyEd.updateNotes();
            xsOpptyEd.closewindow2();
            xsOpptyEd.closewindow3();            
            xsOpptyEd.validateForm();
            xsOpptyEd.sharePop();
            xsOpptyEd.CancelData();
            xsOpptyEd.doNothing();
            xsOpptyEd.copyRecord();
            xsOpptyEd.cloneOppty();
            // xsOpptyEd .getQuarterDescribe();
            xsOpptyEd.getRelatedCrossSellRecords();
            xsOpptyEd.getRelatedCrossSellNotes();
            xsOpptyEd.deletePartiesInvolved();
            xsOpptyEd.deleteNotes();
            xsOpptyEd.deleteXSell();
            xsOpptyEd.getpicklistVals();
            xsOpptyEd.closewindow4();
            
            /*  XS_Sharing class testing  */
            
            Cross_Sell__Share xsShare = new Cross_Sell__Share(); 
            Cross_Sell_Parties_Involved__c xsParInvo = new Cross_Sell_Parties_Involved__c();
            User ur = new User();
            ur = [Select IsActive, Name,id from User u  where IsActive=true limit 1];
            xsParInvo .Employee__c = ur.id;
            
            
            
            List<ID> uToShareWithList = new List<ID>();
            Set<ID> uToShareWithIDSet = new Set<ID>();
            // User usr = [select id from User where isactive=true limit 1];
            Employee__c e = [select user__r.id, user__r.isactive from Employee__c where id = :xs.Nominee__c];
            uToShareWithList .add(e.user__r.id);            
            uToShareWithIDSet .add(e.user__r.id);
            
            
            xsOpptyEd.submitStatus= true;
            xsOpptyEd.isPrivateDelegate= false;
            xsOpptyEd.otherCommentsErrorMessage =true;
            xsOpptyEd.significantErrorMessage=true;
            xsOpptyEd.Share='stringshare';
            test.stopTest();
                }   
    
    }
    
     static testMethod void xsTest1() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='XS Super Users'  LIMIT 1]; 
        
        User tempUser  = new User(Alias = 'standt', Email='sarah.philips@morganstanley.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
        
            System.debug('@@@@@@@@@@@@@@@@@@USERID ' + tempUser.Id);
            
            
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
        
        Cross_Sell__c xs = new Cross_Sell__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(xs);
        Test.setCurrentPage(Page.xs_opportunity);     
        XS_OpportunityEdit xsOpptyEd = new XS_OpportunityEdit(sc);   
        
        xs.Why_significant__c=null;
        xs.Transaction_Status__c='';
        xs.Transaction_Product_Type__c='';
        xs.Stage__c='submitted';
        xs.Size_of_Transaction__c=null;
        xs.Revenues_000s__c=null;
        xs.Other_Comments__c=null;
        xs.One_time_fee_vs_Ongoing__c='';
        xs.MNPI__c=true;
        xs.Intra_ISG__c=true;
        xs.First_time_business__c=true;
        xs.Declaration__c=true;
        xs.Closed_Date__c=Date.newInstance(2015,10,30);
        xs.Client_Type_Industry__c='';
        xs.Client_Name__c='';     
        xs.Other_Comments__c= 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';   
        xs.Why_significant__c='Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        xs.Other_individuals_involved1__c = emp.id;
        xs.Other_individuals_involved2__c = emp.id;
        xs.Other_Divisions_Involved1__c = 'Institutional Equity Division';
        xs.Other_Divisions_Involved2__c = 'Strategic Relationship Management';
        xs.Nominee__c=emp.Id;
        xs.Nominee_Manager_s_Full_name__c ='tets manager';
        xs.Nominee_Division__c = 'IBD';
        xs.Nominee_Group__c='Department';
        xs.Nominee_Region__c ='NA';
        xs.Nominee_Title__c ='MD';
        
        insert xs;
        
        xsOpptyEd .validateForm(); 
        xsOpptyEd.save();
        xsOpptyEd.Submit();
    }
   static testMethod void xsTestElse() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='XS Super Users'  LIMIT 1]; 
        
        User tempUser  = new User(Alias = 'standt', Email='sarah.philips@morganstanley.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, FirstName='test', Emp_Id__c = 'test', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        insert tempUser;
        
            System.debug('@@@@@@@@@@@@@@@@@@USERID ' + tempUser.Id);
            
            
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
            
            Cross_Sell__c xs = new Cross_Sell__c();
            xs.Why_significant__c='Significant';
            xs.Transaction_Status__c='Booked';
            xs.Transaction_Product_Type__c='test2';
            xs.Stage__c='Submitted';
            xs.Size_of_Transaction__c='1';
            xs.Revenues_000s__c='1';
            xs.Other_Comments__c= 'other comments';     
            xs.One_time_fee_vs_Ongoing__c='On Going';
            xs.Nominee__c=emp.Id;
            xs.MNPI__c=false;
            xs.Intra_ISG__c=false;
            xs.First_time_business__c=false;
            xs.Declaration__c=false;
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
            xs.Other_individuals_involved1__c = emp.id;
            xs.Other_individuals_involved2__c = emp.id;
            xs.Other_Divisions_Involved1__c = 'Institutional Equity Division';
            xs.Other_Divisions_Involved2__c = 'Strategic Relationship Management';
           
            insert xs;
           
            // add permission set to user
            System.runAs(new User(Id = Userinfo.getUserId())) {
                PermissionSet permSet = [SELECT id FROM PermissionSet WHERE name = 'XS_Super_User'];
                System.debug('@@@@@@@@@@@@@@@@@@PERMSETID ' + permSet.Id);
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = tempUser.Id;
                psa.PermissionSetId = permSet.Id;
                insert psa;
            }
            
            System.debug('Employee Id: ' + emp.Id);
            
            
            
            ApexPages.StandardController sc = new ApexPages.StandardController(xs);
            ApexPages.currentPage().getParameters().put('id', xs.id);
        
        System.runas(tempUser){            
            xs.Client_Name__c='Job Level2';
            xs.Stage__c='submitted';
            update xs;
            
            
            Cross_Sell_Opty_Notes__c xsoptnote = new Cross_Sell_Opty_Notes__c();
            xsoptnote.Cross_Sell__c = xs.id; //'CS-00000026';
            xsoptnote.Notes__c = 'any random text';
            System.debug('%%%%%%%%%%%%'+xs.id);
            insert xsoptnote;
            
            
            XS_OpportunityEdit xsOpptyEd = new XS_OpportunityEdit(sc);
            xsOpptyEd.x = xs;
            
            Cross_Sell_Parties_Involved__c PartInv = new Cross_Sell_Parties_Involved__c();
            PartInv.Cross_Sell__c = xs.id;
            PartInv.Division__c = 'selection';
            PartInv.Employee__c = emp.id;
            PartInv.Role__c = 'selected';
            insert PartInv;
            
            
            
            xsOpptyEd.selection ='Division';
            xsOpptyEd.nominee = 'testNominee';
            xsOpptyEd.RequesteeNominee = 'Employee2';
            xsOpptyEd.isg = 'isg';
            xsOpptyEd.ftb = 'ftb';
            xsOpptyEd.dec = 'dec';
            xsOpptyEd.toDelete = 'a2Zf00000002rA1EAI';
            
            
            ApexPages.currentPage().getParameters().put('id', xs.id);
            ApexPages.currentPage().getParameters().put('crossSellOptyId', xs.id);
            xsOpptyEd.save();
            xsOpptyEd.AddOtherParties();
            xsOpptyEd.AddNotes();
            xsOpptyEd.Submit();
            xsOpptyEd.Approve();
            xsOpptyEd.decSet();
            xsOpptyEd.ftbSet();
            xsOpptyEd.CancelChanges();
            xsOpptyEd.mnpiSet();
            xsOpptyEd.isgSet();
            xsOpptyEd.closewindow();
            xsOpptyEd.searchNominee();
            xsOpptyEd.setRequesteeNominee();
            xsOpptyEd.setNotes();
            xsOpptyEd.CancelNotes();
            xsOpptyEd.saveNotes();
            xsOpptyEd.SaveData();
            xsOpptyEd.filterNominee();
            xsOpptyEd.addnotesPop();
            xsoptnote.Notes__c = 'Edited note';
            xsOpptyEd.updateNotes();
            xsOpptyEd.closewindow2();
            xsOpptyEd.closewindow3();
            xsOpptyEd.closewindow4();
            xsOpptyEd.validateForm();
            xsOpptyEd.sharePop();
            xsOpptyEd.CancelData();
            xsOpptyEd.doNothing();
            xsOpptyEd.copyRecord();
            xsOpptyEd.cloneOppty();
            // xsOpptyEd .getQuarterDescribe();
            xsOpptyEd.getRelatedCrossSellRecords();
            xsOpptyEd.getRelatedCrossSellNotes();
            xsOpptyEd.deletePartiesInvolved();
            xsOpptyEd.deleteNotes();
            xsOpptyEd.deleteXSell();
            xsOpptyEd.getpicklistVals();
            
            /*  XS_Sharing class testing  */
            
            Cross_Sell__Share xsShare = new Cross_Sell__Share(); 
            Cross_Sell_Parties_Involved__c xsParInvo = new Cross_Sell_Parties_Involved__c();
            User ur = new User();
            ur = [Select IsActive, Name,id from User u  where IsActive=true limit 1];
            xsParInvo .Employee__c = ur.id;
            
            
            
            List<ID> uToShareWithList = new List<ID>();
            Set<ID> uToShareWithIDSet = new Set<ID>();
            // User usr = [select id from User where isactive=true limit 1];
            Employee__c e = [select user__r.id, user__r.isactive from Employee__c where id = :xs.Nominee__c];
            uToShareWithList .add(e.user__r.id);            
            uToShareWithIDSet .add(e.user__r.id);
            
            
            xsOpptyEd.submitStatus= true;
            xsOpptyEd.isPrivateDelegate= false;
            xsOpptyEd.otherCommentsErrorMessage =true;
            xsOpptyEd.significantErrorMessage=true;
            xsOpptyEd.Share='stringshare';
            
        }   
    }
    
}