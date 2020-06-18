@isTest(SeeAllData=true)
public class RL_Test_Data {
    
    //User tempUser = [select name from user where name = 'Namita Shaha' LIMIT 1];  
    
    public RL_Test_Data()
    {
        system.debug('------------Test------------');
    }
    
    public static User getSystemAdminTempUser()
    {                                  
        // User tempUser = [select name from user where name = 'Avinash Munaga'];      
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'  LIMIT 1]; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id,emp_id__c='4774',
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');      
        return tempUser; 
        
    }
    
    
    /*public static Reference_Letter_Request__Share createshare()
{     
Referenece_Letter_Request__c newLetter = RL_Test_Data.createRefLetterRL001();
Reference_Letter_Request__Share shr = new Reference_Letter_Request__Share(); 
shr.AccessLevel = 'edit';
shr.ParentId = newLetter.id;
//shr.RowCause = 'Rule';
shr.UserOrGroupId = '005f0000000jlOI'; 
//shr.IsDeleted = false;  
insert shr;   
//system.assertequals('Test',shr.RowCause); 
//shr = [select id from Reference_Letter_Request__Share where id = :shr.id Limit 1]; 
return shr;   
}*/
    
    public static RL_DivisionDscOrg__c creteDivision(String divName)
    {
        //RL Division Insertion
        RL_DivisionDscOrg__c newDivision = new RL_DivisionDscOrg__c(Name=divName,Division_Code__c='25000',Division_Dsc_Value__c='Morgan Stanley Strats ',Primary_Pay_Company__c='123',Super_Department_Code__c='012') ;   
        insert newDivision; 
        //system.assertequals('Divsion3',newDivision.Name);
        newDivision = [select id from RL_DivisionDscOrg__c where id = :newDivision.id Limit 1]; 
        return newDivision; 
    }
    
    public static RL_JobCountrySignatoryCodes__c createSigncode(String signcode)
    {
        //RL Job Country Insertion       
        RL_JobCountrySignatoryCodes__c newSignCode = new RL_JobCountrySignatoryCodes__c(Name=signcode,Job_Country__c = 'HKG',
                                                                                        Pay_Company__c = 12,Signatory_Name__c = 'Test',Signature_Object__c = 'Test');       
        insert newSignCode;       
        //system.assertequals('HKG',newSignCode.Job_Country__c);       
        newSignCode = [select id from RL_JobCountrySignatoryCodes__c where id = :newSignCode.id Limit 1]; 
        return newSignCode; 
        
    }
    
    public static RL_Emp_Office_Address__c createEmpoffice(String Empoffice)
    {
        //RL Employee Address Insertion 
        RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name=Empoffice,Building_City__c='Bangalore',Postal_Code__c='1234');
        insert newEmpOffice;       
        //system.assertequals('TestAddress3',newEmpOffice.Name);
        newEmpOffice = [select id,Building_City__c,Postal_Code__c from RL_Emp_Office_Address__c where id = :newEmpOffice.id LIMIT 1]; 
        return newEmpOffice;   
    }
    
    public static  RL_OwnerShip_Assignment__c createOwnership(String ownership)
    {
        // RL Ownership Address 
        RL_OwnerShip_Assignment__c newOwnership = new RL_OwnerShip_Assignment__c();
        newOwnership.Name=ownership;
        newOwnership.Country__c ='India Coverage Approvers';
        newOwnership.CurrencyIsoCode  = 'USD';
        insert newOwnership; 
        //system.assertequals('Ownership3',newOwnership.Name);
        newOwnership = [select id from RL_OwnerShip_Assignment__c where id = :newOwnership.id Limit 1]; 
        return newOwnership;
    }  
    
    public static  RL_Group_assignment__c createRLGroup(String RLgroup)
    {
        // RL Group Assignment  
        RL_Group_assignment__c newAssgnGroup = new RL_Group_assignment__c();
        newAssgnGroup.Name=RLgroup;   
        newAssgnGroup.CurrencyIsoCode = 'USD';
        //newAssgnGroup.CreatedById = tempUser;
        //newassgnGroup.CreatedDate = date.today();
        newassgnGroup.Group_Name__c = 'India_Coverage_Approvers';
        //newassgnGroup.SetupOwnerId = '00Df0000002K0p7EAC';
        insert newAssgnGroup;   
        //system.assertequals('GroupAssignment3',newAssgnGroup.Name);
        newAssgnGroup = [select id from RL_Group_assignment__c where id = :newAssgnGroup.id Limit 1]; 
        return newAssgnGroup;
    }
    
    public static  Cont_Eork_type__c createContEor(String ContEor)
    {
        //Cont Insertion 
        Cont_Eork_type__c newPoi  = new Cont_Eork_type__c(Name=ContEor,CurrencyIsoCode='USD',Contigent_Work_code__c='TestWorkcode');
        insert newPoi;
        system.assertequals('TestWorkcode',newPoi.Contigent_Work_code__c);
        newPoi = [select id from Cont_Eork_type__c where id = :newPoi.id  Limit 1]; 
        return newPoi;
    }
    
    
    public static  Employee__c createEmp(String Emp,String id, String login )
    {
        //User tempUser = [select name from user where name = 'Avinash Munaga'];  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User tempUser  = new User(Alias = 'standt', Email='SystemAdministrator@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='SystemAdministrator@testorg.com');
        
        EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];      
        QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];       
        Urgent_Request__c ur = [select id,group_name__c from Urgent_Request__c LIMIT 1];
        OrgWideEmailAddress orgEmail = [Select Address from OrgWideEmailAddress LIMIT 1];
        
        
        
        Employee__c newEmployee = new Employee__c( Name='Emp',Address_1_Home__c='Add1',Address_2_Home__c='Add2',
                                                  Address_3_Home__c='Add3',Address_4_Home__c='Add4',Adj_Hire_Date__c=Date.today(),Age__c='30',
                                                  Alternate1_Dsc_Org__c='DSC1',Alternate1_Org__c='Org1',Base_Annual_Amount__c='123',Base_Annual_Currency__c='12',
                                                  Benefit_Program__c='Bnft1',Birth_Country__c='USA',Birth_Country_Description__c='Country',
                                                  gender_dsc__c='Male',First_Name__c='Employee1',Last_Name__c='Employee2',Empl_Class_Job__c='A',
                                                  Job_Region_Code__c='NJ',Emp_ID__c = 'id',User__c= tempUser.id,City_Home__c='City',Zip_Home__c='1234',
                                                  State_Home__c='PA',State_Home_Dsc_Home__c='PAA',Country_Dsc_Home__c='USA',
                                                  Building_Address_1_Directory__c='bldng1',Building_Address_2_Directory__c='bldng2',
                                                  Building_Address_3_Directory__c='bldng3',Building_Country_Directory__c='WP',
                                                  Building_Dsc_Bldg__c='DSC1',Building_Job__c='Job1',Building_State_Directory__c='ST',
                                                  Business_Title__c='Mr',CC_City_Dsc_Org__c='CCDSCOrg1',CC_City_Org__c='CCCityOrg',
                                                  citizenship_country_dsc__c='CtCiy',Club_Status__c='Clb',Club_Year__c='1982',Commitment_Status__c='Stat',
                                                  Cost_Center__c='341',Cost_Center_Code__c='982',Cost_Center_Desc__c='CenterDesc',Country_Home__c='USA',
                                                  Login_Id_Directory__c='login',Poi_Type__c='1',Job_Country_Job__c = 'SGP',Job_Title_Dsc_Job__c ='abc',Status__c='Inactive',Employee_Sub_Class__c='R', Dept_Org__c='81826');        
        insert newEmployee;        
        newEmployee = [select id,emp_id__c, gender_dsc__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c, Status__c
                       , Country_Dsc_Home__c, CC_Region_Org__c, Job_Region_Code__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c, Birth_Date__c
                       , Job_Country_Job__c,Empl_Class_Job__c,Empl_Class_Dsc_Job__c,Employee_Sub_Class__c, Email__c,Is_HR_Partner__c
                       , Base_Annual_Amount__c, IND_Basic_Salary_Amount__c from Employee__c where Id =:newEmployee.id];
        //system.assertEquals('Employee2',newEmployee.Name); 
        //id = 'a00f0000005hPY3'     
        /*newEmployee = [select id,emp_id__c, gender_dsc__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c, Status__c
, Country_Dsc_Home__c, CC_Region_Org__c,Job_Region_Code__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c, Birth_Date__c
, Job_Country_Job__c,Empl_Class_Job__c,Empl_Class_Dsc_Job__c,Employee_Sub_Class__c, Email__c,Is_HR_Partner__c
, Base_Annual_Amount__c, IND_Basic_Salary_Amount__c,Status___c from Employee__c where Name='Avinash Munaga' LIMIT 1];
*/
        
        return newEmployee;
    }
    
    
    
    public static  Reference_Letter__c createRefRL0001()
    {       
        Reference_Letter__c refLetter = [select id,Conga_Query_Id__c,Conga_Template__c,Employment_Status__c,Location__c,Purpose_Description__c,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Current Employee Reference Letter'  LIMIT 1]; 
        //system.assertEquals('Current Employee Reference Letter', refLetter.Name);
        return refLetter;
        
    }
    
    public static  Reference_Letter__c createRefRL0002()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Business Visa Letter' and Reference_Letter_Code__c='RL0002'  LIMIT 1]; 
        //system.assertEquals('Business Visa Letter', refLetter.Name); 
        return refLetter; 
        
    }
    
    public static  Reference_Letter__c createRefRL0003()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='APEC Business Travel Card'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0004()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Terminated Employee Reference Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0005()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Pre-hire Employee Reference Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0006()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Rental Application Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0007()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='HK Sponsorship of Foreign Domestic Helper'  LIMIT 1]; 
        return refLetter;  
    }
    public static Reference_Letter__c createRefRL0008()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='HK Schengen Multiple Entry Visa Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0009()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Personal Visa Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0010()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='HK Exempt from Jury Duty'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0011()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='AUS Completed Probation Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0012()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='AUS Novated Lease Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0013()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='BMW Corporate Program'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0014()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Mobile Phone Connection Request Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static Reference_Letter__c createRefRL0015()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='MS Travel Insurance Cover Note'  LIMIT 1]; 
        return refLetter;  
    }
    public static Reference_Letter__c createRefRL0016()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Rental Letter'  LIMIT 1]; 
        return refLetter;  
    }
    public static  Reference_Letter__c createRefRL0017()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Bank Letter'  LIMIT 1]; 
        return refLetter;  
    } 
    public static  Reference_Letter__c createRefRL0018()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Current Letter'  LIMIT 1]; 
        return refLetter;  
    }  
    public static  Reference_Letter__c createRefRL0019()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Reference_Letter_Code__c='RL0019' and Name='Business Visa Letter'  LIMIT 1]; 
        return refLetter;  
    } 
    public static  Reference_Letter__c createRefRL0020()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Tourist Visa Letter'  LIMIT 1]; 
        return refLetter;  
    } 
    public static  Reference_Letter__c createRefRL0021()
    {       
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c from Reference_Letter__c where Name='Mortgage Letter'  LIMIT 1]; 
        return refLetter;  
    }
    
    public static  Reference_Letter_Request__c createRefLetterRL001()
    {   
        
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division1');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature1');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress1');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership1');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup1');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor1');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp1','4771','RL121');
        
        //Reference_Letter_Request__Share shrRecord = RL_Test_Data.createshare(); 
        
        Reference_Letter__c  refLetter = RL_Test_Data.createRefRL0001();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Request_For__c='Myself',
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
        
        
        
         
       
        
        
        
        
        
        
        system.assertequals('Specify Name/Address',newLetter.Address_Letter_To__c); 
        
        newLetter = [select id from Reference_Letter_Request__c where id=:newLetter.id LIMIT 1];        
        RL_Sharing.shareReadWrite(newLetter);  
        
        /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {'me@email1.com','you@email2.com'};
mail.setToAddresses(toAddresses);

mail.setSubject('My Subject');

mail.setUseSignature(false);
mail.setHtmlBody('Hi');

// Send the email
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        system.debug('-------------------------------Successfully Inserted RL001----------------------------------'); 
        //refLetter = RL_Test_Data.createRefRL0003();
        //refLetter = RL_Test_Data.createRefRL0001();         
        return newLetter;
        
        
    } 
    
    public static  Reference_Letter_Request__c testterminated() {
     RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division1');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature1');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress1');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership1');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup1');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor1');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp4','4774','RL128');
           newEmployee.Empl_Class_Job__c = 'C';
        newEmployee.Employee_Sub_Class__c = 'R';
        newEmployee.Job_Region_Code__c = 'NA';
        newEmployee.Status__c = 'Active';
        newEmployee.Job_Region_Code__c = 'EU';
        update newEmployee;
        
        Reference_Letter__c  refLetter = RL_Test_Data.createRefRL0004();        
        System.debug('@@@@@@@@@@@@'+refLetter.id);
        System.debug('@@@@@@@@@@@@'+newEmployee.id);
        Reference_Letter_Request__c newLetter1 = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Request_For__c='Terminated',
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
        
        insert newLetter1; 
        
        system.assertequals('Specify Name/Address',newLetter1.Address_Letter_To__c); 
        
        newLetter1= [select id from Reference_Letter_Request__c where id=:newLetter1.id LIMIT 1];        
        RL_Sharing.shareReadWrite(newLetter1);  
        
        newLetter1= [select id from Reference_Letter_Request__c where id = :newLetter1.id];
        
        return newLetter1;
             
    }
    
     
    
    
    
    
    
    
    
    
    public static  Reference_Letter_Request__c createRefLetterRL002()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division2');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature2');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress2');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership2');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup2');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor2');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp2','4772','RL123');       
        refLetter = RL_Test_Data.createRefRL0002();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 //Email_Requestor_Email__c='abc@as.com',
                                                                                 //Email_OnBehalf_Email__c='abc@as.com',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,        
                                                                                 
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 //Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;  
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c); 
        system.debug('-------------------------------Successfully Inserted RL002----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];        
        //refLetter = RL_Test_Data.createRefRL0003();         
        refLetter = RL_Test_Data.createRefRL0002();         
        return newLetter;
    }
    
    public static  Reference_Letter_Request__c createRefLetterRL003()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division3');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature3');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress3');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership3');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup3');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor3');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp3','4773','RL124');       
        refLetter = RL_Test_Data.createRefRL0003();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,        
                                                                                 
                                                                                 
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter; 
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL003----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        refLetter = RL_Test_Data.createRefRL0003();         
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL004()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division4');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature4');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress4');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership4');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup4');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor4');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp4','4774','RL128');       
        refLetter = RL_Test_Data.createRefRL0004();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter; 
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL004----------------------------------');  
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0004(); 
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL005()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division5');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature5');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress5');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership5');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup5');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor5');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp5','4775','RL129');       
        refLetter = RL_Test_Data.createRefRL0005();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter; 
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL005----------------------------------');    
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0005(); 
        return newLetter;
    } 
    public static  Reference_Letter_Request__c createRefLetterRL006()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division6');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature6');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress6');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership6');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup6');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor6');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp6','4776','RL130');       
        refLetter = RL_Test_Data.createRefRL0006();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;  
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL006----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0006();
        return newLetter;
    } 
    public static  Reference_Letter_Request__c createRefLetterRL007()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division7');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature7');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress7');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership7');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup7');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor7');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp7','4777','RL131');       
        refLetter = RL_Test_Data.createRefRL0007();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL007----------------------------------');  
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0007();
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL008()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division8');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature8');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress8');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership8');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup8');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor8');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp8','4778','RL132');       
        refLetter = RL_Test_Data.createRefRL0008();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;  
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL008----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        refLetter = RL_Test_Data.createRefRL0008();         
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL009()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division9');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature9');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress9');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership9');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup9');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor9');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp9','4779','RL133');       
        refLetter = RL_Test_Data.createRefRL0009();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                           
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter; 
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL009----------------------------------');  
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0009();
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL011()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division11');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature11');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress11');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership11');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup11');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor11');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp11','4782','RL134');       
        refLetter = RL_Test_Data.createRefRL0011();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter; 
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL011----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0011(); 
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL013()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division13');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature13');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress13');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership13');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup13');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor13');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp13','4784','RL135');       
        refLetter = RL_Test_Data.createRefRL0013();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL013----------------------------------');  
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0013(); 
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL015()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division15');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature15');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress15');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership15');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup15');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor15');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp15','4786','RL136');       
        refLetter = RL_Test_Data.createRefRL0015();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;  
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL015----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0015(); 
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL016()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division16');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature16');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress16');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership16');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup16');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor16');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp16','4787','RL139');       
        refLetter = RL_Test_Data.createRefRL0016();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;  
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('------------Successfully Inserted RL016--------------'+newLetter); 
        system.debug('-------------------------------Successfully Inserted RL016----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0016(); 
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL017()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division17');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature17');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress17');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership17');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup17');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor17');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp17','4788','RL141');       
        refLetter = RL_Test_Data.createRefRL0017();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true,email_q_name__c='RL_HRSC_Queue_ASIA');   
        
        insert newLetter;  
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL017----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0017();
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL019()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division19');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature19');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress19');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership19');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup19');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor19');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp19','4790','RL142');       
        refLetter = RL_Test_Data.createRefRL0019();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL019----------------------------------'); 
        
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0019();
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL020()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division20');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature20');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress20');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership20');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup20');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor20');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp20','4791','RL143');       
        refLetter = RL_Test_Data.createRefRL0020();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                         
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL020----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0020(); 
        return newLetter;
    }
    public static  Reference_Letter_Request__c createRefLetterRL021()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('division21');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignature21');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddress21');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownership21');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroup21');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEor21');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Emp21','4792','RL144');       
        refLetter = RL_Test_Data.createRefRL0021();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Conga_CC_Region_Org__c = 'EU',conga_citizenship_country__c = 'Test',Conga_Club_Status__c= 'Test',
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                          
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = false,
                                                                                 Include_Total_Compensation__c = false,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted RL021----------------------------------');  
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        
        //refLetter = RL_Test_Data.createRefRL0003(); 
        refLetter = RL_Test_Data.createRefRL0021(); 
        return newLetter;
    }
    public static  Reference_Letter_Request__c sampleData()
    {   
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('divisionsample');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('TestSignaturesample');        
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('TestAddresssample');
        
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownershipsample');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroupsample');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEorsample');         
        Employee__c newEmployee = RL_Test_Data.createEmp('Empsample','4793','RL145'); 
        newEmployee.Job_Region_Code__c = 'NA';
        update newEmpOffice; 
        
        refLetter = RL_Test_Data.createRefRL0021();        
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female',
                                                                                 Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',Requesting_Employee__c = newEmployee.id,  
                                                                                 For_Employee__c = newEmployee.id, Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
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
                                                                                 Conga_CC_Region_Org__c = 'NA',conga_citizenship_country__c = 'Test',Conga_Club_Status__c= 'Test',
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
                                                                                 Escalation__c='No',
                                                                                 Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                                                                 // Email_Q_Template__c ='test',
                                                                                 Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                                                                 Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ,                                                                         
                                                                                 Email_Requestor_Email__c='abc@as.com',
                                                                                 Email_OnBehalf_Email__c='abc@as.com',         
                                                                                 Destination__c='India',
                                                                                 Include_Passport_Number__c = true,          
                                                                                 The_recipient_below__c = true,
                                                                                 Include_Current_Base_Salary__c = true,
                                                                                 Include_Total_Compensation__c = true,
                                                                                 To_whom_it_may_concern__c = true,
                                                                                 Address_Letter_To__c = 'Specify Name/Address', 
                                                                                 Request_For__c='Myself',
                                                                                 Include_Family_Members__c = true,   
                                                                                 Duration_in_Day__c = '1',
                                                                                 Duration_in_Month__c = 'Year(s)',
                                                                                 Urgent_HR_Request__c = true);   
        
        insert newLetter;  
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted Sample data----------------------------------');  
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        return newLetter;
        /*refLetter = RL_Test_Data.sampleData(); 

return newLetter;*/
    }
    public static  Reference_Letter_Request__c triggerData()
    {
        Reference_Letter__c  refLetter; 
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('divisiontrig');
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('testsignaturetrig');        
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('testaddresstrig');        
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownershiptrig');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgrouptrig');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEortrig');         
        
        Employee__c newEmployee = RL_Test_Data.createEmp('Emptrig','4794','RL146');        
        refLetter = RL_Test_Data.createRefRL0021();        
        Reference_Letter_Request__c newLetter1 = new Reference_Letter_Request__c ();
        //newLetter1.All_Employees__c = null;
        //newLetter1.Conga_HasEquity__c=null;
        newLetter1.Reference_Letter__c = refLetter.id;
        newLetter1.For_Employee__c = newEmployee.id;  
        //newLetter1.Employee_Job_Country__c= 'USA';           
        newLetter1.Address_1_Home__c = null; 
        newLetter1.Address_2_Home__c = null;   
        newLetter1.Address_3_Home__c = null;     
        newLetter1.Address_4_Home__c = null;
        newLetter1.Conga_Home_City__c = null;
        newLetter1.Conga_Home_Postal_Code__c = null;
        newLetter1.Conga_State_Home__c =null;
        newLetter1.Conga_State_Home_Dsc_Home__c =null;
        newLetter1.Conga_Country_Dsc_Home__c =null;
        newLetter1.Person_RelationShip_Table__c = null;
        newLetter1.Conga_Total_Reward_Currency__c = null;
        newLetter1.Conga_Adj_Hire_Date__c = null;
        newLetter1.Conga_Age__c = null;
        newLetter1.Conga_Alternate1_Dsc_Org__c = null;
        newLetter1.Conga_Building_Address_1_Directory__c = null;
        newLetter1.Conga_Building_Address_2_Directory__c = null;
        newLetter1.Conga_Alternate1_Org__c = null;
        newLetter1.Conga_Building_Address_3_Directory__c = null;
        newLetter1.Conga_Building_Country_Directory__c = null;
        newLetter1.Conga_Building_Directory__c = null;
        newLetter1.Conga_Building_Dsc_Bldg__c = null;
        newLetter1.Conga_Building_Job__c = null;
        newLetter1.Conga_Building_State_Directory__c = null;
        newLetter1.Conga_Business_Title__c = null;
        newLetter1.Conga_CC_City_Dsc_Org__c = null;
        newLetter1.Conga_CC_City_Org__c = null;
        newLetter1.Conga_CC_Region_Org__c = null;
        newLetter1.Conga_citizenship_country__c = null;                 
        newLetter1.Conga_Club_Status__c = null;      
        newLetter1.Conga_Club_Year__c = null;      
        newLetter1.Conga_Cost_Center__c = null;        
        newLetter1.Cost_Center_Code__c = null;        
        newLetter1.Conga_Cost_Center_Desc__c = null;        
        newLetter1.Conga_Country_Home__c = null;        
        newLetter1.Conga_Covenant_Date__c = null;            
        newLetter1.Conga_Current_Compensation_Year__c = null;       
        newLetter1.Conga_Days_of_Perm_Serv_Total_LOS__c = null;        
        newLetter1.Conga_Dept_Org__c = null;
        newLetter1.Conga_Division_Org__c = null;
        newLetter1.Conga_DocuSign_GUID__c = null;
        newLetter1.Conga_Email__c = null;                              
        newLetter1.Conga_Empl_Class_Job__c = null;                   
        newLetter1.Conga_Empl_Type_Dsc_Job__c = null;            
        newLetter1.Conga_Empl_Type_Job__c = null;           
        newLetter1.Conga_Employee_Sub_Class__c = null;            
        newLetter1.Conga_Ethnic_Group__c = null;            
        newLetter1.Conga_Ethnic_Group_Dsc__c = null;            
        newLetter1.Conga_Financial_Advisor_Number__c = null;            
        newLetter1.Conga_Floor_Directory__c= null;           
        newLetter1.Conga_Gender_Dsc__c= null;
        newLetter1.Conga_Geographic_Region_Directory__c= null;
        //newLetter1.Conga_HasEquity__c= null;
        //newLetter1.Conga_Inactive__c= null;
        newLetter1.Conga_Job_City_Job__c= null;
        newLetter1.Conga_Jobcode_Job__c= null;
        newLetter1.Conga_Job_Country_Dsc_Job__c= null;
        newLetter1.Conga_Job_Family__c= null;
        newLetter1.Conga_Job_Function_code__c= null;
        newLetter1.Conga_Job_Function_Dsc__c= null;
        newLetter1.Conga_Job_State_Job__c= null;
        newLetter1.Conga_Job_Title__c= null;
        newLetter1.Conga_Job_Title_Dsc_Job__c= null;
        newLetter1.Conga_Legal_Entity_Job__c= null;
        newLetter1.Conga_MS_MSSB__c= null;
        newLetter1.Conga_Phone_Area_Code_Home__c= null;
        newLetter1.Conga_Phone_Number_Home__c= null;
        newLetter1.Status__c='Created';   
        newLetter1.Conga_Poi_Type__c= null;
        newLetter1.Conga_Region_Dsc_Org__c= null;
        newLetter1.Conga_Sched_Hours_Job__c= null; 
        newLetter1.Conga_Schedule_Type_Job__c= null;  
        newLetter1.Conga_Status__c= null;
        newLetter1.Conga_Sub_Depart2_Dsc_Org__c= null;
        newLetter1.Conga_Sub_Depart2_Org__c= null;
        newLetter1.Conga_Schedule_Type_Dsc_Job__c= null;
        newLetter1.Conga_Subdept_Dsc_Org__c= null;
        newLetter1.Conga_Subdept_Org__c= null;
        newLetter1.Conga_Super_Depart_Dsc_Org__c= null;
        newLetter1.Conga_Super_Depart_Org__c= null;
        newLetter1.Conga_Super_Division__c= null;
        newLetter1.Conga_Super_Division_Dsc_Org__c= null;
        newLetter1.Conga_Term_Reason__c= null;
        newLetter1.Conga_Work_Days_Total__c= null;    
        newLetter1.Conga_Work_Phone__c = null;     
        //newLetter1.Requesting_Employee_Email__c='abc@abc.com';    
        //newLetter1.For_Employee_Email__c = 'jones.bharathy@morganstanley.com';
        //newLetter1.Requesting_Employee__c = 'a00f0000005tQaO';
        newLetter1.Conga_USA_Diversity_Ind_Job__c= null;
        newLetter1.For_Employee_Email__c = 'abc@test.com';
        newLetter1.Requesting_Employee__c = newEmployee.id;          
        newLetter1.Requesting_Employee_Email__c = 'jones.bharathy@morganstanley.com';           
        newLetter1.Escalation__c = 'Yes';
        newLetter1.Email_Q_Template__c ='Task_completed_by_HR_Partner';
        // Email_Q_Template__c ='test',
        newLetter1.Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ;
        newLetter1.Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter' ; 
        newLetter1.Status__c='Approval Step 2';
        newLetter1.Conga_First_Name__c = null;
        //newLetter1.Employee_Department_sanjib_test__c = '0122';           
        newLetter1.Conga_Last_Name__c = null;
        newLetter1.Conga_Job_Country_Job__c = null;
        newLetter1.Conga_Title__c = null;
        newLetter1.Conga_Employee_Gender__c = 'Male';           
        newLetter1.Conga_Recent_Term_Date__c =null;
        newLetter1.DOH_Recent__c = null;          
        newLetter1.Conga_DOH_Original__c = null;
        newLetter1.Conga_Employee_Department__c = null;
        newLetter1.Conga_Headcount_Job__c='Test';
        newLetter1.Conga_Level_job__c='Test';
        newLetter1.Previous_Year_Commision_Currency__c = null;
        newLetter1.Previous_Year_Commision_Amount__c = null;         
        newLetter1.Previous_Year_TRWD_Currency__C = null;
        newLetter1.Previous_Year_TRWD_Amount__C = null;
        newLetter1.Conga_Common_Amount__c = null;
        newLetter1.Conga_Common_Currency__c = null;
        newLetter1.Conga_eicp_amount__c = null;
        newLetter1.Conga_eicp_currency__c=null;
        newLetter1.Conga_IND_Basic_Salary_Amount__c = null;
        newLetter1.Conga_ind_total_allowance_amount__c=null;
        newLetter1.Conga_Employee_Secondment__c = null;
        newLetter1.Conga_ind_total_allowance_amount__c = null;       
        newLetter1.Conga_ind_total_allowance_currency__c = null;
        newLetter1.Conga_prev_bonus_amount__c = null;
        newLetter1.Conga_Prev_Bouns_Amt_2__c=null;
        newLetter1.Conga_Prev_Bouns_Amt_3__c = null;
        newLetter1.Conga_Prev_Comp_1__c=null;
        newLetter1.Conga_Prev_Comp_2__c = null;
        newLetter1.Conga_Prev_Comp_3__c = null;
        newLetter1.Conga_Prev_Currency_Format_2__c=null;
        newLetter1.Conga_Prev_Currency_Format_1__c = null;
        newLetter1.Conga_Prev_Currency_Format_3__c = null;
        newLetter1.Prior_EICP_Annual_Amount__c=null;
        newLetter1.Base_Annual_Amount__c  = null;                
        newLetter1.Conga_Days_of_Perm_Serv_Total_LOS__c = null;
        newLetter1.Prior_EICP_Annual_Currency__c = null;
        newLetter1.Conga_Dept_Org__c = null;
        newLetter1.Conga_Total_Reward_Amount__c = null;
        newLetter1.Conga_Division_Org__c = null;       
        newLetter1.Conga_Empl_Type_Dsc_Job__c = null;               
        newLetter1.Conga_Empl_Type_Job__c = null;
        newLetter1.Base_Annual_Currency__c = null;      
        newLetter1.Conga_Ethnic_Group__c = null;
        newLetter1.Conga_Ethnic_Group_Dsc__c = null;
        newLetter1.Conga_Employee_Sub_Class__c = null;
        newLetter1.Conga_Financial_Advisor_Number__c = null;                   
        //newLetter1.Conga_Employee_Job_Country__c = null;
        newLetter1.Conga_Employee_Job_Country__c =   newSigncode.id;
        newLetter1.Urgent_HR_Request__c = true;
        //newEmployee.Inactive__c=false;
        newLetter1.Submitted_Approved_Date__c = Date.parse('5/5/2005');
        newLetter1.Email_Q_Name__c  = 'RL_HRSC_Queue_ASIA';
        newLetter1.Status__c = 'Completed';           
        
        insert newLetter1;
        system.assertEquals('RL_HRSC_Queue_ASIA', newLetter1.Email_Q_Name__c);
        system.debug('-------------------------------Successfully Inserted Trigger data----------------------------------'); 
        newLetter1 = [select id from Reference_Letter_Request__c where id = :newLetter1.id];
        return newLetter1;
    }
    
    public static  Reference_Letter_Request__c otherMethodsData() 
    {
        RL_DivisionDscOrg__c newDivision = RL_Test_Data.creteDivision('divisionmethodsdata');
        system.debug('------------new Division--------------');    
        newDivision = [select id from RL_DivisionDscOrg__c where id = :newDivision.id Limit 1];
        
        RL_JobCountrySignatoryCodes__c newSigncode = RL_Test_Data.createSigncode('testsignaturemethodsdata');
        RL_Emp_Office_Address__c newEmpoffice = RL_Test_Data.createEmpoffice('testaddressmethodsdata');
        RL_OwnerShip_Assignment__c newOwnership = RL_Test_Data.createOwnership('ownershipmethodsdata');
        RL_Group_assignment__c newAssgnGroup = RL_Test_Data.createRLGroup('RLgroupmethodsdata');
        Cont_Eork_type__c newPoi = RL_Test_Data.createContEor('ContEormethodsdata');   
        
        Employee__c newEmployee = RL_Test_Data.createEmp('Empmethodsdata','4795','RL147');
        Reference_Letter__c refLetter = RL_Test_Data.createRefRL0001();   
        
        //Reference Letter Request 
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = refLetter.id;    
        newLetter.Conga_Employee_Gender__c = 'Female';        
        newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA'; 
        //newLetter.Poi_Type__c  = newPoi.   
        
        newLetter.Company_Address_Title__c = 'Sample';
        newLetter.Company_Address_SName__c = 'Sa';
        newLetter.Company_Address_Name__c ='sa';
        newLetter.Company_Address_1__c  = '1';
        newLetter.Company_Address_3__c = '3';
        newLetter.Company_Address_PC__c  = 'PC';
        newLetter.Address_by_Reference__c ='Name and Address';
        newLetter.Company_Name__c = 'MS';           
        newLetter.Address_1_Home__c = 'Address 1 Home';       
        newLetter.Address_2_Home__c = 'Address 2 Home';       
        newLetter.Address_3_Home__c = 'Address 3 Home';       
        newLetter.Address_4_Home__c = 'Address 4 Home';        
        newLetter.Conga_Home_City__c = 'Conga Home';
        newLetter.Conga_Home_Postal_Code__c = 'Conga Postalcode';
        newLetter.Conga_State_Home__c ='TN';
        newLetter.Conga_State_Home_Dsc_Home__c ='TN';
        newLetter.Conga_Country_Dsc_Home__c ='IND';
        //newLetter.Reference_Letter_Code__c = 'RL0001';
        newLetter.Conga_Adj_Hire_Date__c = date.today();        
        newLetter.Conga_Age__c = '24';
        newLetter.Conga_Alternate1_Dsc_Org__c = 'ABC';
        newLetter.Conga_Alternate1_Org__c = 'ABC';
        newLetter.Conga_Birth_Country_Description__c = 'IND';
        newLetter.Conga_Building_Address_1_Directory__c = 'Test 1';
        newLetter.Conga_Building_Address_2_Directory__c = 'Test 2';
        newLetter.Conga_Building_Address_3_Directory__c = 'Test 3';
        newLetter.Conga_Building_Country_Directory__c = 'Test Building';
        newLetter.Conga_Building_Directory__c = 'Test Building';
        newLetter.Conga_Building_Dsc_Bldg__c = 'Test Building';
        newLetter.Conga_Building_Job__c = 'Test Building';
        newLetter.Conga_Building_State_Directory__c = 'Test Building';
        newLetter.Conga_Business_Title__c = 'Test';
        newLetter.Conga_CC_City_Dsc_Org__c = 'Test';
        newLetter.Conga_CC_City_Org__c = 'Test';
        newLetter.Conga_CC_Region_Org__c = 'A';
        newLetter.Conga_citizenship_country__c = 'Test';
        newLetter.Conga_Club_Status__c= 'Test';
        newLetter.Conga_Club_Year__c= 'Test';
        newLetter.Conga_Commitment_Status__c= 'Test';
        newLetter.Conga_Cost_Center__c= 'Test';
        newLetter.Cost_Center_Code__c= 'Test';
        newLetter.Conga_Cost_Center_Desc__c= 'Test';
        newLetter.Conga_Country_Home__c= 'Test';          
        newLetter.Conga_Covenant_Date__c= date.today();
        newLetter.Conga_Current_Compensation_Year__c= 'Test';
        newLetter.Conga_Days_of_Perm_Serv_Total_LOS__c = 10;
        newLetter.Conga_Dept_Org__c= 'Test';
        newLetter.Conga_Division_Org__c= 'Test';
        newLetter.Conga_DocuSign_GUID__c= 'Test';
        newLetter.Conga_Email__c= 'Test@abc.com';
        newLetter.Conga_Empl_Class_Job__c = 'Test';
        newLetter.Conga_Empl_Type_Dsc_Job__c= 'Test';
        newLetter.Conga_Empl_Type_Job__c= 'Test';
        newLetter.Conga_Employee_Sub_Class__c= 'Test';
        newLetter.Conga_Ethnic_Group__c= 'Test';
        newLetter.Conga_Ethnic_Group_Dsc__c= 'Test';
        newLetter.Conga_Financial_Advisor_Number__c= 'Test';
        newLetter.Conga_Floor_Directory__c= 'Test';
        newLetter.Conga_Gender_Dsc__c= 'Test';
        newLetter.Conga_Geographic_Region_Directory__c= 'Test';
        newLetter.Conga_HasEquity__c= true;
        newLetter.Conga_Inactive__c= true;
        newLetter.Conga_Job_City_Job__c= 'Test';
        newLetter.Conga_Jobcode_Job__c= 'Test';
        newLetter.Conga_Job_Country_Dsc_Job__c= 'Test';
        newLetter.Conga_Job_Family__c= 'Test';
        newLetter.Conga_Job_Function_code__c= 'Test';
        newLetter.Conga_Job_Function_Dsc__c= 'Test';
        newLetter.Conga_Job_State_Job__c= 'Test';
        newLetter.Conga_Job_Title__c= 'Test';
        newLetter.Conga_Job_Title_Dsc_Job__c= 'Test';
        newLetter.Conga_Legal_Entity_Job__c= 'Test';
        newLetter.Conga_MS_MSSB__c = '123';
        newLetter.Conga_Phone_Area_Code_Home__c = '123';
        newLetter.Conga_Phone_Number_Home__c = '123';
        newLetter.Conga_Poi_Type__c = 'TEST' ;
        newLetter.Conga_Region_Dsc_Org__c = 'Test' ;
        newLetter.Conga_Sched_Hours_Job__c = 12;
        newLetter.Conga_Schedule_Type_Dsc_Job__c = 'Test';
        newLetter.Conga_Schedule_Type_Job__c = 'Test';
        newLetter.Conga_Status__c = 'Test';
        newLetter.Conga_Sub_Depart2_Dsc_Org__c = 'Test';
        newLetter.Conga_Sub_Depart2_Org__c = 'Test';
        newLetter.Conga_Subdept_Dsc_Org__c = 'Test';
        newLetter.Conga_Subdept_Org__c = 'Test';
        newLetter.Conga_Super_Depart_Dsc_Org__c = 'Test';           
        newLetter.Conga_Super_Depart_Org__c = 'Test';
        newLetter.Conga_Super_Division__c = 'Test';
        newLetter.Conga_Super_Division_Dsc_Org__c = 'Test';
        newLetter.Conga_Term_Reason__c = 'Test';
        newLetter.Conga_USA_Diversity_Ind_Job__c = 'Test';
        newLetter.Conga_Work_Days_Total__c = 12;
        newLetter.Conga_Work_Phone__c = '123';
        newLetter.Conga_Login_Id_Directory__c = 'TEST'; 
        newLetter.Conga_Employee_Department__c = null;    
        newLetter.Conga_Employee_Job_City__c = 'IND';
        newLetter.Conga_Super_Division_Dsc_Org__c = 'IND';
        newLetter.Conga_Headcount_Job__c = 'Test';
        newLetter.Conga_Level_job__c = 'TEST';
        newLetter.Conga_Level_Dsc_Job__c = 'Test';
        newLetter.Passport_Number__c='passport1234';    
        //newLetter.For_Employee_Email__c = 'abc@test.com';
        //newLetter.Requesting_Employee_Email__c = 'abc@test.com';
        //newLetter.Status__c = 'Approval Step 2';
        newLetter.Conga_First_Name__c = 'IND';
        newLetter.Conga_Last_Name__c = 'IND';
        newLetter.Conga_Job_Country_Job__c = 'IND';
        newLetter.Conga_Title__c = 'MS';
        newLetter.Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c;       
        newLetter.Conga_Employee_Job_City__c = 'India';
        newLetter.Conga_Super_Division_Dsc_Org__c ='test';
        newLetter.Conga_Headcount_Job__c='12';
        newLetter.Conga_Level_Job__c='12';
        newLetter.Conga_Level_Dsc_Job__c='test';
        newLetter.For_Employee_Email__c='abc@as.com';
        newLetter.Requesting_Employee_Email__c='abc@as.com';
        //newLetter.All_Employees__c = newEmployee.id;
        newLetter.For_Employee__c = newEmployee.id;    
        newLetter.Status__c='Approval Step 2';
        newLetter.Escalation__c='No';
        //newLetter.Email_Q_Name__c = 'Test Group';
        newLetter.Email_Requestor_Email__c='abc@as.com';
        newLetter.Email_OnBehalf_Email__c='abc@as.com';
        newLetter.Requesting_Employee__c = newEmployee.id;        
        newLetter.Destination__c='India';
        newLetter.Conga_Employee_Job_Country__c=newSigncode.id;           
        newLetter.Building_City_Directory__c = newEmpOffice.Building_City__c;
        newLetter.Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c;  
        newLetter.Include_Passport_Number__c = true;  
        newLetter.The_recipient_below__c = true;
        newLetter.Include_Current_Base_Salary__c = true;
        newLetter.Include_Total_Compensation__c = true;
        newLetter.To_whom_it_may_concern__c = true;
        newLetter.Address_Letter_To__c = 'Specify Name/Address'; 
        newLetter.Request_For__c='Pre Hired/Terminated';
        newLetter.Include_Family_Members__c = true;
        newLetter.Duration_in_Day__c = '1';
        newLetter.Duration_in_Month__c = 'Week(s)' ;
        newLetter.Urgent_HR_Request__c = true;
        
        insert newLetter;         
        
        system.assertEquals('Specify Name/Address', newLetter.Address_Letter_To__c);
        system.debug('-------------------------------Successfully Inserted Data----------------------------------'); 
        newLetter = [select id from Reference_Letter_Request__c where id = :newLetter.id];
        return newLetter;
    }
    
}