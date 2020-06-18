@isTest(SeeAllData=true)
private class RL_Employee_Test
{
    private static User getSystemAdminTempUser(){
        User tempUser = RL_TestData.getSystemAdminTempUser();
        
        return tempUser;
        
    }
    
    /******* Test class for Constructor DEV environment********************/
    static testMethod void myTest1() {
        System.runAs(getSystemAdminTempUser()) {
            Reference_Letter_Request__c letterRequest1 = RL_TestData.createRefLetterRL001();
            
            test.startTest();  
            
            
            PageReference testPageReference = Page.RL_home; 
            testPageReference.getParameters().put('successLoad','true');
            testPageReference.getParameters().put('urlVal','dev');
            Test.setCurrentPage(testPageReference);
            
            // ApexPages.StandardController controller = new ApexPages.Standardcontroller(letterRequest1);
            ApexPages.currentPage().getParameters().put('id', letterRequest1.id);
            
            letterRequest1 .Include_Passport_Number__c = true;
            RL_Employee rlController = new RL_Employee();
            rlController.setFlag1();
            rlController.setFlag2();
            rlController.getincludeBaseSalary();
            rlController.showRecipientDetails();
            rlController.setFlagToNameRelationship();
            rlController.FlagToBusinessVisaIsPassPortNo();
            rlController.FlagToTheRecipientBelow();
            //erlController.FlagToIncludedInThisCoverNote();
            //rlController.FlagToTheRecipientBelow();
            rlController.FlagToIncludedBasSalaryRentApp();
            rlController.includeBaseSalary();
            rlController.showRecipientDetails();
            rlController.showRecipient();
            rlController.setDurationFlag();
            rlController.setJourneyFLag();
            rlController.setNationalityFlag();
            rlController.setAddresseFlag();
            rlController.setPassportFlag();
            //rlController.setRecipientFlag();
            rlController.showLetterSelection();
          
            rlController.reDirect();
            rlController.newRequest();
            rlController.exit();
            rlController.cancel();
            rlController.getAvailableLetters();
            rlController.getRequestFor();
            rlController.setEmployeeRequest();
            rlController.getEmployees();
            rlController.getReferenceLetterList();
            
            rlController.setLayoutFlag();
            //rlController.showInvitingOrg();
            //rlController.save();
            rlController.getItems();
            
            RL_Employee.getGroups();
            RL_Employee.validateEMEAHR();
            
            test.stopTest();
        }
    }
    
    /******* Test class for Job_Region_Code__c = 'NA' & QA environment*********/
    static testMethod void myTest2() {
        System.runAs(getSystemAdminTempUser())  {
            Reference_Letter_Request__c letterRequest = RL_TestData.sampleData();
                     
            test.startTest();   
            
            PageReference testPageReference = Page.RL_home; 
            testPageReference.getParameters().put('urlVal','qa');
            Test.setCurrentPage(testPageReference) ;
            letterRequest.request_for__c = 'Another Employee';
           
            //update letterRequest;
            ApexPages.currentPage().getParameters().put('id', letterRequest.id);
            
            RL_Employee rlController = new RL_Employee();
            rlController.setLayoutFlag();
            rlController.setFlag1();
            
            test.stopTest();
            
        }
    }
    
    /******* Test class for Job_Region_Code__c = 'EU' & UAT environment*********/
    static testMethod void myTest3() {
        System.runAs(getSystemAdminTempUser()) {
            Reference_Letter_Request__c letterRequest = RL_TestData.createRefLetterRL019();
            
            test.startTest();
            
            PageReference testPageReference = Page.RL_home; 
            testPageReference.getParameters().put('urlVal','uat');
            testPageReference.getParameters().put('exception','true');
            testPageReference.getParameters().put('value','value1');
            Test.setCurrentPage(testPageReference) ;
            
            ApexPages.currentPage().getParameters().put('id', letterRequest.id);
            
            RL_Employee rlController = new RL_Employee();
            rlController.showInvitingOrg();
            //rlController.save();
            
            test.stopTest();
        }
    }
    
    static testMethod void myTest4() {
        System.runAs(getSystemAdminTempUser()) {
            Reference_Letter_Request__c letterRequest = RL_TestData.otherMethodsData();
            
            test.startTest();
            
            PageReference testPageReference = Page.RL_home; 
            testPageReference.getParameters().put('urlVal','dev');
            
            Test.setCurrentPage(testPageReference) ;
            
            ApexPages.currentPage().getParameters().put('id', letterRequest.id);
            
            RL_Employee rlController = new RL_Employee();
            rlController.setFlag1();
            
            test.stopTest();
        }
    }
    
    /******** Test class for Unassigned Variables *********/
    static testMethod void myTest5() {
        
        test.startTest();  
        
        PageReference testPageReference = Page.RL_home; 
        testPageReference.getParameters().put('urlVal','dev');
        Test.setCurrentPage(testPageReference);
        
        RL_Employee rlController = new RL_Employee ();
        
        List<String> List1= new List<String>{ 'one', 'two' };
        rlController.Addmember = List1;
        rlController.showLetterSection4 = True;
        rlController.showLetterSection5 = True;
        rlController.showLetterSection6 = True;
        rlController.showLetterSection7 = True;
        rlController.showLetterSection8 = True;
        rlController.showLetterSection9 = True;
        rlController.showLetterSection10 = True;
        rlController.showLetterSection10 = True;
        rlController.showDurationErrMsg = True;
        rlController.errorMsg = True;
        rlController.addMoreCount1 = True;
        rlController.showcontingent = True;
        rlController.success = 'True';
        rlController.selectedLetterId = 'True';
        rlController.requestStatus = 'True';
        
        rlController.Count = 10;
        rlController.AddMore();
        rlController.AddMore1();
        
        test.stopTest();
    }
    
     /******* Test class for Job_Region_Code__c = 'NA' & QA environment*********/
    static testMethod void myTest6() {
        System.runAs(getSystemAdminTempUser())  {
            Reference_Letter_Request__c letterRequest = RL_TestData.sampleData();
               
            test.startTest();   
            
            PageReference testPageReference = Page.RL_home; 
            testPageReference.getParameters().put('urlVal','dev');
            Test.setCurrentPage(testPageReference) ;
            letterRequest.request_for__c = 'Terminated';
           
            //update letterRequest;
            ApexPages.currentPage().getParameters().put('id', letterRequest.id);
            
            RL_Employee rlController = new RL_Employee();
            rlController.setLayoutFlag();
            rlController.setFlag1();
           
            test.stopTest();
            
        }
    }

 
 
    public static testMethod void testbusinessPassportInd(){
        //System.runAs(getSystemAdminTempUser())
            
        { 
             Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        
        EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];      
        QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];       
        Urgent_Request__c ur = [select id,group_name__c from Urgent_Request__c LIMIT 1];
        OrgWideEmailAddress orgEmail = [Select Address from OrgWideEmailAddress LIMIT 1];
        
        
        
            
            Employee__c newEmployee = new Employee__c(Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                                                  Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                                                  Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                                                  Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                                                  gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                                                  Job_Region_Code__c='EU',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                                                  State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                                                  Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                                                  Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                                                  Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                                                  Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                                                  citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                                                  Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                                                 Poi_Type__c='1',Job_Country_Job__c = 'IND',Job_Title_Dsc_Job__c ='abc',Status__c='Active',Dept_Org__c='81826');
        
        insert newEmployee;
        
         /* Employee__c emp = RIF_TestClassUtilities.createTestEmployee(0,'123451234', 'USA', 'MSSB', 'Director','123');
          emp.Super_Division__c='10910';
            emp.Job_Country_Job__c = 'IND';
          
            insert emp; */  
     
      
    Reference_Letter_Request__c letterRequest = RL_TestData.sampleData();
        
        test.startTest(); 
         
        
        RL_Employee Rlemp = new RL_Employee();
             Rlemp.passportNumber = true;  
        newEmployee.Job_Country_Job__c = 'IND'; 
        // = 'IND';
        
        Rlemp.FlagToBusinessVisaIsPassPortNo();
        //System.assertEquals(true, Rlemp.businessPassportInd); 
            test.stopTest();
    }
 
 
 
 
 
 
 






}
static testMethod void myTest8() {
     Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee'  LIMIT 1]; 
     User tempUser = new User(alias = 'newUser', email='TUALLMS' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,emp_id__c='4774',
          timezonesidkey='America/Los_Angeles', username='TUALLMS' + DateTime.now().format('MMddyyhhmmss') + '+hr@ms.com');
     
     insert tempUser;
    
    Employee__c newEmployee = new Employee__c( Name='Emp',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                                                  Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                                                  Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                                                  Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                                                  gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                                                  Job_Region_Code__c='NJ',Emp_ID__c = '4774',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                                                  State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                                                  Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                                                  Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                                                  Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                                                  Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                                                  citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                                                  Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                                                  Login_Id_Directory__c='login1',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Job_Title_Dsc_Job__c ='abc',Status__c='Inactive',Employee_Sub_Class__c='R', Dept_Org__c='81826');

        insert newEmployee;    
        
    	 Employee__c newEmployee1 = new Employee__c( Name='Emp',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                                                  Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                                                  Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                                                  Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                                                  gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                                                  Job_Region_Code__c='NJ',Emp_ID__c = 'ANBF',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                                                  State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                                                  Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                                                  Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                                                  Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                                                  Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                                                  citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                                                  Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                                                  Login_Id_Directory__c='login2',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Job_Title_Dsc_Job__c ='abc',Status__c='Active',Employee_Sub_Class__c='R', Dept_Org__c='81826');

		insert newEmployee1; 
    	
    	
      
       PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Reference_Letter_User' LIMIT 1];
       //insert new PermissionSetAssignment(AssigneeId = tempUser.id, PermissionSetId = ps.Id );
    System.runAs(tempUser){
            
            Reference_Letter_Request__c letterRequest1 = RL_Test_Data.testterminated();
            system.debug('***********'+letterRequest1);
            test.startTest();   
            
            PageReference testPageReference = Page.RL_home; 
            
            testPageReference.getParameters().put('urlVal','dev');
			ApexPages.currentPage().getParameters().put('id', letterRequest1.id);
            Test.setCurrentPage(testPageReference);
            
             ApexPages.StandardController controller = new ApexPages.Standardcontroller(letterRequest1);
           	 
        	 RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name='Empoffice',Building_City__c='Bangalore',Postal_Code__c='1234');
        		insert newEmpOffice;    
        
        	 Reference_Letter__c  refLetter = RL_Test_Data.createRefRL0004();
        	
        	 Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
																				 All_Employees__c = newEmployee.Id,
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee1.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
                                                                                 Building_City_Directory__c = newEmpOffice.Building_City__c,Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c,
                                                                                 Company_Address_Name__c ='sa',Company_Address_1__c  = '1',Company_Address_3__c = '3',Company_Address_PC__c  = 'PC',
                                                                                 Address_by_Reference__c ='Name and Address',Company_Name__c = 'MS',Address_1_Home__c = 'Address 1 Home',
                                                                                 Address_2_Home__c = 'Address 2 Home',Address_3_Home__c = 'Address 3 Home', Address_4_Home__c = 'Address 4 Home',
                                                                                 Conga_Home_City__c = 'Conga Home', Conga_Home_Postal_Code__c = 'Conga Postalcode',Conga_State_Home__c ='TN',                                                                        
                                                                                 Conga_State_Home_Dsc_Home__c ='TN',Conga_Country_Dsc_Home__c ='IND',Conga_Adj_Hire_Date__c = date.today(),
                                                                                 Conga_Age__c = '24',Conga_Alternate1_Dsc_Org__c = 'ABC',Conga_Alternate1_Org__c = 'ABC',Conga_Birth_Country_Description__c = 'IND',
                                                                                 Conga_Building_Address_1_Directory__c = 'Test 1',Conga_Building_Address_2_Directory__c = 'Test 2',
                                                                                 Conga_Building_Address_3_Directory__c = 'Test 3', Conga_Building_Country_Directory__c = 'Test Building',
                                                                                 Conga_Building_Directory__c = 'Test Building', Conga_Building_Dsc_Bldg__c = 'Test Building',
                                                                                 Conga_Building_Job__c = 'Test Building',Conga_Building_State_Directory__c = 'Test Building',
                                                                                 Conga_Business_Title__c = 'Test',Conga_CC_City_Dsc_Org__c = 'Test',Conga_CC_City_Org__c = 'Test',
                                                                                 Conga_CC_Region_Org__c = 'A',conga_citizenship_country__c = 'Test',Conga_Club_Status__c= 'Test',
                                                                                 Conga_Club_Year__c= 'Test',Conga_Commitment_Status__c= 'Test',Conga_Cost_Center__c= 'Test',
                                                                                 Cost_Center_Code__c= 'Test',Conga_Cost_Center_Desc__c= 'Test',Conga_Country_Home__c= 'Test',          
                                                                                 Conga_Covenant_Date__c= date.today(),
                                                                                 Conga_Current_Compensation_Year__c= 'Test',
                                                                                 Conga_Days_of_Perm_Serv_Total_LOS__c = 10,
                                                                                 Conga_Dept_Org__c= 'Test',
                                                                                 Conga_Division_Org__c= 'Test',
                                                                                 Conga_DocuSign_GUID__c= 'Test',
                                                                                 Conga_Email__c= 'Test@abc.com',
                                                                                 Conga_Empl_Class_Job__c = 'Test',
                                                                                 Conga_Empl_Type_Dsc_Job__c= 'Test',
                                                                                 Conga_Empl_Type_Job__c= 'Test',
                                                                                 Conga_Employee_Sub_Class__c= 'Test',
                                                                                 Conga_Ethnic_Group__c= 'Test',
                                                                                 Conga_Ethnic_Group_Dsc__c= 'Test',
                                                                                 Conga_Financial_Advisor_Number__c= 'Test',
                                                                                 Conga_Floor_Directory__c= 'Test',
                                                                                 Conga_Gender_Dsc__c= 'Test',
                                                                                 Conga_Geographic_Region_Directory__c= 'Test',
                                                                                 Conga_HasEquity__c= true,
                                                                                 Conga_Inactive__c= true,
                                                                                 Conga_Job_City_Job__c= 'Test',
                                                                                 Conga_Jobcode_Job__c= 'Test',
                                                                                 Conga_Job_Country_Dsc_Job__c= 'Test',
                                                                                 Conga_Job_Family__c= 'Test',
                                                                                 Conga_Job_Function_code__c= 'Test',
                                                                                 Conga_Job_Function_Dsc__c= 'Test',
                                                                                 Conga_Job_State_Job__c= 'Test',
                                                                                 Conga_Job_Title__c= 'Test',
                                                                                 Conga_Job_Title_Dsc_Job__c= 'Test',
                                                                                 Conga_Legal_Entity_Job__c= 'Test',
                                                                                 Conga_MS_MSSB__c = '123',
                                                                                 Conga_Phone_Area_Code_Home__c = '123',
                                                                                 Conga_Phone_Number_Home__c = '123',
                                                                                 Conga_Poi_Type__c = 'TEST' ,
                                                                                 Conga_Region_Dsc_Org__c = 'Test' ,
                                                                                 Conga_Sched_Hours_Job__c = 12,
                                                                                 Conga_Schedule_Type_Dsc_Job__c = 'Test',
                                                                                 Conga_Schedule_Type_Job__c = 'Test',
                                                                                 Conga_Status__c = 'Test',
                                                                                 Conga_Sub_Depart2_Dsc_Org__c = 'Test',
                                                                                 Conga_Sub_Depart2_Org__c = 'Test',
                                                                                 Conga_Subdept_Dsc_Org__c = 'Test',
                                                                                 Conga_Subdept_Org__c = 'Test',
                                                                                 Conga_Super_Depart_Dsc_Org__c = 'Test',           
                                                                                 Conga_Super_Depart_Org__c = 'Test',
                                                                                 Conga_Super_Division__c = 'Test',
                                                                                 Conga_Super_Division_Dsc_Org__c = 'Test',
                                                                                 Conga_Term_Reason__c = 'Test',
                                                                                 Conga_USA_Diversity_Ind_Job__c = 'Test',
                                                                                 Conga_Work_Days_Total__c = 12,
                                                                                 Conga_Work_Phone__c = '123',
                                                                                 
                                                                                 Conga_Employee_Job_City__c = 'IND',
                                                                                 //Company_Name__c = 'Test1',
                                                                                 Conga_First_Name__c = 'IND',
                                                                                 Conga_Last_Name__c = 'IND',
                                                                                 Conga_Job_Country_Job__c = 'IND',
                                                                                 Conga_Title__c = 'MS',                            
                                                                                 Conga_Headcount_Job__c='12',
                                                                                 Conga_Level_Job__c='12',
                                                                                 Conga_Level_Dsc_Job__c='test',
                                                                                 For_Employee_Email__c='abc@as.com',
                                                                                 Requesting_Employee_Email__c='abc@as.com',        
                                                                                 Status__c='Approval Step 2',
                                                                                 // Status__C = 'Created',
                                                                                 Escalation__c='No',
                                                                                 //Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                        
                                                                                 
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = boolean.valueof('true'),          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 //To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c= 'Pre Hired/Terminated',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true,
                                                                                 email_q_name__c = 'RL_HRSC_Queue_ASIA', 
                                                                                 //status__c = 'Created',
                                                                                 email_requestor_email__c= 'references.asia@morganstanley.com', 
                                                                                 set_q_email_cc__c = 'RL_HRSC_Queue_ASIA',
                                                                                 Comments__c = false,
                                                                                 SET_Q_TEMPLATE_Reminder_Template__c='Remainder_emails',
                                                                                 SET_Q_EMAIL_Reminder_Name__c='RL_HRSC_Queue_ASIA');   
        
        insert newLetter; 

           
            letterRequest1 .Include_Passport_Number__c = true;
             
            RL_Employee rlController = new RL_Employee();
            rlController.r.request_for__c= 'terminated';
           
            rlController.setFlag1(); 
            //rlController.r.request_for__c='Pre Hired/Terminated';
            rlController.setFlag2();
            test.stopTest();
	}
    } 

static testMethod void myTest9() {
     Profile p = [SELECT Id FROM Profile WHERE Name='All MS Employee'  LIMIT 1]; 
     User tempUser = new User(alias = 'newUser', email='TUALLMS' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,emp_id__c='4774',
          timezonesidkey='America/Los_Angeles', username='TUALLMS' + DateTime.now().format('MMddyyhhmmss') + '+hr@ms.com');
     
     insert tempUser;
    
    Employee__c newEmployee = new Employee__c( Name='Emp',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                                                  Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                                                  Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                                                  Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                                                  gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                                                  Job_Region_Code__c='NJ',Emp_ID__c = '4774',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                                                  State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                                                  Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                                                  Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                                                  Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                                                  Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                                                  citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                                                  Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                                                  Login_Id_Directory__c='login1',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Job_Title_Dsc_Job__c ='abc',Status__c='Terminated',Employee_Sub_Class__c='R', Dept_Org__c='81826');

        insert newEmployee;    
        
    	 Employee__c newEmployee1 = new Employee__c( Name='Emp',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                                                  Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                                                  Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                                                  Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                                                  gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                                                  Job_Region_Code__c='NJ',Emp_ID__c = 'ANBF',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                                                  State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                                                  Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                                                  Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                                                  Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                                                  Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                                                  citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                                                  Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                                                  Login_Id_Directory__c='login2',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Job_Title_Dsc_Job__c ='abc',Status__c='Terminated',Employee_Sub_Class__c='R', Dept_Org__c='81826');

		insert newEmployee1; 
    	
    	
      
       PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Reference_Letter_User' LIMIT 1];
       //insert new PermissionSetAssignment(AssigneeId = tempUser.id, PermissionSetId = ps.Id );
    System.runAs(tempUser){
            
            Reference_Letter_Request__c letterRequest1 = RL_Test_Data.testterminated();
            system.debug('***********'+letterRequest1);
            test.startTest();   
            
            PageReference testPageReference = Page.RL_home; 
            
            testPageReference.getParameters().put('urlVal','dev');
		
            testPageReference.getParameters().put('exception','true');
            testPageReference.getParameters().put('value','value1');
            Test.setCurrentPage(testPageReference) ;
			ApexPages.currentPage().getParameters().put('id', letterRequest1.id);
            Test.setCurrentPage(testPageReference);
            
             ApexPages.StandardController controller = new ApexPages.Standardcontroller(letterRequest1);
           	 
        	 RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name='Empoffice',Building_City__c='Bangalore',Postal_Code__c='1234');
        		insert newEmpOffice;    
        
        	 Reference_Letter__c  refLetter = RL_Test_Data.createRefRL0004();
        	
        	 Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
																				 All_Employees__c = newEmployee.Id,
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee1.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
                                                                                 Building_City_Directory__c = newEmpOffice.Building_City__c,Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c,
                                                                                 Company_Address_Name__c ='sa',Company_Address_1__c  = '1',Company_Address_3__c = '3',Company_Address_PC__c  = 'PC',
                                                                                 Address_by_Reference__c ='Name and Address',Company_Name__c = 'MS',Address_1_Home__c = 'Address 1 Home',
                                                                                 Address_2_Home__c = 'Address 2 Home',Address_3_Home__c = 'Address 3 Home', Address_4_Home__c = 'Address 4 Home',
                                                                                 Conga_Home_City__c = 'Conga Home', Conga_Home_Postal_Code__c = 'Conga Postalcode',Conga_State_Home__c ='TN',                                                                        
                                                                                 Conga_State_Home_Dsc_Home__c ='TN',Conga_Country_Dsc_Home__c ='IND',Conga_Adj_Hire_Date__c = date.today(),
                                                                                 Conga_Age__c = '24',Conga_Alternate1_Dsc_Org__c = 'ABC',Conga_Alternate1_Org__c = 'ABC',Conga_Birth_Country_Description__c = 'IND',
                                                                                 Conga_Building_Address_1_Directory__c = 'Test 1',Conga_Building_Address_2_Directory__c = 'Test 2',
                                                                                 Conga_Building_Address_3_Directory__c = 'Test 3', Conga_Building_Country_Directory__c = 'Test Building',
                                                                                 Conga_Building_Directory__c = 'Test Building', Conga_Building_Dsc_Bldg__c = 'Test Building',
                                                                                 Conga_Building_Job__c = 'Test Building',Conga_Building_State_Directory__c = 'Test Building',
                                                                                 Conga_Business_Title__c = 'Test',Conga_CC_City_Dsc_Org__c = 'Test',Conga_CC_City_Org__c = 'Test',
                                                                                 Conga_CC_Region_Org__c = 'A',conga_citizenship_country__c = 'Test',Conga_Club_Status__c= 'Test',
                                                                                 Conga_Club_Year__c= 'Test',Conga_Commitment_Status__c= 'Test',Conga_Cost_Center__c= 'Test',
                                                                                 Cost_Center_Code__c= 'Test',Conga_Cost_Center_Desc__c= 'Test',Conga_Country_Home__c= 'Test',          
                                                                                 Conga_Covenant_Date__c= date.today(),
                                                                                 Conga_Current_Compensation_Year__c= 'Test',
                                                                                 Conga_Days_of_Perm_Serv_Total_LOS__c = 10,
                                                                                 Conga_Dept_Org__c= 'Test',
                                                                                 Conga_Division_Org__c= 'Test',
                                                                                 Conga_DocuSign_GUID__c= 'Test',
                                                                                 Conga_Email__c= 'Test@abc.com',
                                                                                 Conga_Empl_Class_Job__c = 'Test',
                                                                                 Conga_Empl_Type_Dsc_Job__c= 'Test',
                                                                                 Conga_Empl_Type_Job__c= 'Test',
                                                                                 Conga_Employee_Sub_Class__c= 'Test',
                                                                                 Conga_Ethnic_Group__c= 'Test',
                                                                                 Conga_Ethnic_Group_Dsc__c= 'Test',
                                                                                 Conga_Financial_Advisor_Number__c= 'Test',
                                                                                 Conga_Floor_Directory__c= 'Test',
                                                                                 Conga_Gender_Dsc__c= 'Test',
                                                                                 Conga_Geographic_Region_Directory__c= 'Test',
                                                                                 Conga_HasEquity__c= true,
                                                                                 Conga_Inactive__c= true,
                                                                                 Conga_Job_City_Job__c= 'Test',
                                                                                 Conga_Jobcode_Job__c= 'Test',
                                                                                 Conga_Job_Country_Dsc_Job__c= 'Test',
                                                                                 Conga_Job_Family__c= 'Test',
                                                                                 Conga_Job_Function_code__c= 'Test',
                                                                                 Conga_Job_Function_Dsc__c= 'Test',
                                                                                 Conga_Job_State_Job__c= 'Test',
                                                                                 Conga_Job_Title__c= 'Test',
                                                                                 Conga_Job_Title_Dsc_Job__c= 'Test',
                                                                                 Conga_Legal_Entity_Job__c= 'Test',
                                                                                 Conga_MS_MSSB__c = '123',
                                                                                 Conga_Phone_Area_Code_Home__c = '123',
                                                                                 Conga_Phone_Number_Home__c = '123',
                                                                                 Conga_Poi_Type__c = 'TEST' ,
                                                                                 Conga_Region_Dsc_Org__c = 'Test' ,
                                                                                 Conga_Sched_Hours_Job__c = 12,
                                                                                 Conga_Schedule_Type_Dsc_Job__c = 'Test',
                                                                                 Conga_Schedule_Type_Job__c = 'Test',
                                                                                 Conga_Status__c = 'Test',
                                                                                 Conga_Sub_Depart2_Dsc_Org__c = 'Test',
                                                                                 Conga_Sub_Depart2_Org__c = 'Test',
                                                                                 Conga_Subdept_Dsc_Org__c = 'Test',
                                                                                 Conga_Subdept_Org__c = 'Test',
                                                                                 Conga_Super_Depart_Dsc_Org__c = 'Test',           
                                                                                 Conga_Super_Depart_Org__c = 'Test',
                                                                                 Conga_Super_Division__c = 'Test',
                                                                                 Conga_Super_Division_Dsc_Org__c = 'Test',
                                                                                 Conga_Term_Reason__c = 'Test',
                                                                                 Conga_USA_Diversity_Ind_Job__c = 'Test',
                                                                                 Conga_Work_Days_Total__c = 12,
                                                                                 Conga_Work_Phone__c = '123',
                                                                                 
                                                                                 Conga_Employee_Job_City__c = 'IND',
                                                                                 //Company_Name__c = 'Test1',
                                                                                 Conga_First_Name__c = 'IND',
                                                                                 Conga_Last_Name__c = 'IND',
                                                                                 Conga_Job_Country_Job__c = 'IND',
                                                                                 Conga_Title__c = 'MS',                            
                                                                                 Conga_Headcount_Job__c='12',
                                                                                 Conga_Level_Job__c='12',
                                                                                 Conga_Level_Dsc_Job__c='test',
                                                                                 For_Employee_Email__c='abc@as.com',
                                                                                 Requesting_Employee_Email__c='abc@as.com',        
                                                                                 Status__c='Approval Step 2',
                                                                                 // Status__C = 'Created',
                                                                                 Escalation__c='No',
                                                                                 //Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                        
                                                                                 
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = boolean.valueof('true'),          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 //To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c= 'Pre Hired/Terminated',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true,
                                                                                 email_q_name__c = 'RL_HRSC_Queue_ASIA', 
                                                                                 //status__c = 'Created',
                                                                                 email_requestor_email__c= 'references.asia@morganstanley.com', 
                                                                                 set_q_email_cc__c = 'RL_HRSC_Queue_ASIA',
                                                                                 Comments__c = false,
                                                                                 SET_Q_TEMPLATE_Reminder_Template__c='Remainder_emails',
                                                                                 SET_Q_EMAIL_Reminder_Name__c='RL_HRSC_Queue_ASIA');   
        
        insert newLetter; 

           
            letterRequest1 .Include_Passport_Number__c = true;
             
            RL_Employee rlController = new RL_Employee();
            //rlController.r.request_for__c= 'terminated';
           
            
            rlController.r.request_for__c='Pre Hired/Terminated';
            //rlController.showInvitingOrg();
			rlController.save();
            test.stopTest();
	}
    } 


}