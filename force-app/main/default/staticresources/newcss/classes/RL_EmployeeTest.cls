@isTest(SeeAllData=true)

public class RL_EmployeeTest {

    public static User getSystemAdminTempUser(){
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator' LIMIT 1];
       
       /* User tempUser = new User(alias = 'RLTest', email='RL' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='RLTest' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
        System.debug('---------Test User---------'+tempUser);*/
        User tempUser = [select name from user where Profile.Name = 'System Administrator' and isActive = true LIMIT 1 ];
      
        return tempUser; 
    }
    
    public static testmethod void test1()
     {
        
         //User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
         Employee__c emp = [select id, user__c from employee__c where Job_Country_Job__c  ='HKG' and emp_id__c = '95BYG' and status__c = 'Active' and user__r.isActive = true limit 1];
         
         User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :emp.user__c];
         
         System.runAs(thisUser) {

       
         
      Test.startTest(); 
      
       /*User u1 = [select name from user where name = 'Avinash Munaga' and Profile.Name = 'All MS Employee' and isActive = true LIMIT 1];      
       system.debug('--------------------u1--------------'+u1.name);
       */      
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];
      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];
       
       //Employee__c newEmployee = new Employee__c(Name='Avinash Munaga1',Emp_ID__c = '82KLE', User__c= u1.id,Job_Region_Code__c='EU');
       //insert newEmployee;
       Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NJ' LIMIT 1];
       
       RL_DivisionDscOrg__c newDivision = new RL_DivisionDscOrg__c(Name='12123',Division_Code__c='25000',Division_Dsc_Value__c='Morgan Stanley Strats ',Primary_Pay_Company__c='123',Super_Department_Code__c='012') ;   
       insert newDivision;
       
        Urgent_Request__c ur = [select id,group_name__c from Urgent_Request__c LIMIT 1];
                  
           
        RL_JobCountrySignatoryCodes__c newCode = new RL_JobCountrySignatoryCodes__c(Name='HKG_1212');
        newCode.Job_Country__c = 'HKG';
        newCode.Pay_Company__c = 12;
        newCode.Signatory_Name__c = 'Test';
        newcode.Signature_Object__c = 'Test';           
       insert newCode;
           
       RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name='Test',Building_City__c='Bangalore',Postal_Code__c='1234');
       insert newEmpOffice;
      
       RL_OwnerShip_Assignment__c newOwnership = new RL_OwnerShip_Assignment__c(Name='Test');
       insert newOwnership;
      
       RL_Group_assignment__c newGroup = new RL_Group_assignment__c(Name='Test');
       insert newGroup;       
         
             
      //Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = 'a1Qf00000001vrH']; 
      
     /* Reference_Letter__c rL = [select id, name, reference_letter_code__c from Reference_Letter__c where id='a1Hf0000000H1oz'];       
      Reference_Letter_Request__c newLetter = [select Id,Name, reference_letter__c,Reference_letter_name__c,requesting_employee__c ,Destination__c,Date_of_Travel__c,Return_Date__c,
                 Include_Family_Members__c,Name_of_the_Person__c, Relationship__c,Court_Date__c,Reason_for_Exemption__c,Duration_in_Day__c,
                 Duration_in_Week__c,Duration_in_Month__c,Duration_in_Year__c, requesting_employee__r.name,workflow__c,for_employee__c,
                     for_employee__r.name,Urgent_HR_Request__c,Compensation_Information__c,Nationality__c from Reference_Letter_Request__c where id='a1Qf00000001XsA' ];
      */
        
   
        APXT_CMQR__Conga_Merge_Query__c congaQuery = [select id from APXT_CMQR__Conga_Merge_Query__c limit 1];
        APXTConga4__Conga_Template__c congaTemplate = [select id from APXTConga4__Conga_Template__c limit 1];       
       /*Reference_Letter__c rL = new Reference_Letter__c(Name='Testing',Requestor__c='0001177',Reference_Letter_Code__c='RL0001',Location__c='Asia',Conga_Query_Id__c=congaQuery.id ,Conga_Template__c=congaTemplate.id );
          insert rL;      */
      
        Reference_Letter__c rL = [select id, name, Reference_Letter_Code__c,Location__c, Conga_Query_Id__c, Conga_Template__c from Reference_Letter__c where Reference_Letter_Code__c='RL0001'    ]; 
        Cont_Eork_type__c newPoi  = new Cont_Eork_type__c(Name='132',Contigent_Work_code__c='Test');
        insert newPoi;
             
             
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = rL.id;   
        
             
        newLetter.Conga_Employee_Gender__c = 'Male';
        newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA'; 
        //newLetter.Poi_Type__c  = newPoi.    
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
       
        newLetter.Conga_Employee_Job_City__c = 'IND';
        newLetter.Conga_Super_Division_Dsc_Org__c = 'IND';
        newLetter.Conga_Headcount_Job__c = 'Test';
        newLetter.Conga_Level_job__c = 'TEST';
        newLetter.Conga_Level_Dsc_Job__c = 'Test';
        newLetter.For_Employee_Email__c = 'abc@test.com';
        newLetter.Requesting_Employee_Email__c = 'abc@test.com';
        newLetter.Status__c = 'Approval Step 2';
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
        newLetter.Conga_Employee_Job_Country__c=newcode.id;           
        newLetter.Building_City_Directory__c = newEmpOffice.Building_City__c;
        newLetter.Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c;             
        
        insert newLetter;        
      
       PageReference pageRef = Page.RL_Home;
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
       ApexPages.currentPage().getParameters().put('success',newLetter.id);
       ApexPages.currentPage().getParameters().put('id',newLetter.id);
       ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
       ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
             ApexPages.currentPage().getParameters().put('dev',newLetter.id);
       RL_Employee customController = new RL_Employee();
            
       customcontroller.AddMore();
       customcontroller.AddMore1();
       customcontroller.cancel();
       customcontroller.getIncludeBaseSalary();
       //customcontroller.setFlag1();
       //customcontroller.setFlag2();
       customcontroller.setFlagToNameRelationship();
       customcontroller.FlagToTheRecipientBelow();
       customcontroller.FlagToIncludedInThisCoverNote();
       customcontroller.FlagToIncludedBasSalaryRentApp();
       customcontroller.includeBaseSalary();
       customcontroller.showRecipient();
       customcontroller.setDurationFlag();
       customcontroller.setLayoutFlag();
       customcontroller.showInvitingOrg();
       customcontroller.setJourneyFLag();
       customcontroller.setNationalityFlag();
       customcontroller.setAddresseFlag();
       customcontroller.setPassportFlag();
       //customcontroller.setRecipientFlag();
       customcontroller.showLetterSelection();
       customcontroller.save();
       customcontroller.reDirect();
       customcontroller.newRequest();
       customcontroller.exit();
       customcontroller.cancel();
       customcontroller.getAvailableLetters();
       customcontroller.getRequestFor();
       customcontroller.getEmployees();
       customcontroller.setEmployeeRequest();
       customcontroller.getReferenceLetterList();
       //customcontroller.getGroups();
       //customcontroller.validateEMEAHR();       
      //r.Address_by_Reference__c = 'Address Only';          
      
             
        /*Reference_Letter_Request__c newRefLetter = new Reference_Letter_Request__c(Requesting_Employee__c = newEmployee.id ,Reference_Letter__c=newRef.id , Request_For__c = 'Myself' , Number_of_Copies__c='1',Conga_First_Name__c='Test1',Conga_Last_Name__c='Test2',
                                                                                   Primary_Pay_Company_Dsc_Job__c='Desc',Conga_Login_Id_Directory__c ='test',Conga_Employee_Job_Country__c='India',
                                                                                  Conga_Meeting_Location__c = 'India',Conga_Region_Dsc_Org__c='Test',Status__c='Approval Step 2');
        insert newRefLetter; */
        
             
             
      
       
         
        
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Validate validate = new RL_Validate();
        validate.validationsForEMEA(rL, newLetter);
        validate.resetFields(newLetter  );
      
        
       //apexpages.currentpage().getParameters().put('dev','dev');
     
      
             
       
       Test.stopTest();
         }
     }
    
     public static testmethod void test2()
     {
         Employee__c emp = [select id, user__c from employee__c where Job_Country_Job__c  ='HKG' and emp_id__c = '95BYG' and status__c = 'Active' and user__r.isActive = true limit 1];
         
         User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :emp.user__c];
         
         System.runAs(thisUser) {

       
         
      Test.startTest(); 
      
       /*User u1 = [select name from user where name = 'Avinash Munaga' and Profile.Name = 'All MS Employee' and isActive = true LIMIT 1];
       system.debug('--------------------u1--------------'+u1.name);
         */
             
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];
      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];
       
       //Employee__c newEmployee = new Employee__c(Name='Avinash Munaga1',Emp_ID__c = '82KLE', User__c= u1.id,Job_Region_Code__c='EU');
       //insert newEmployee;
       Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NJ' and Job_Country_Job__c = 'HKG' LIMIT 1];
//       newEmployee.Job_Country_Job__c = 'HKG';
//       update newEmployee;
             
       RL_DivisionDscOrg__c newDivision = new RL_DivisionDscOrg__c(Name='12123',Division_Code__c='25000',Division_Dsc_Value__c='Morgan Stanley Strats ',Primary_Pay_Company__c='123',Super_Department_Code__c='012') ;   
       insert newDivision;
       
        Urgent_Request__c ur = [select id,group_name__c from Urgent_Request__c LIMIT 1];
                  
           
        RL_JobCountrySignatoryCodes__c newCode = new RL_JobCountrySignatoryCodes__c(Name='HKG_1212');
        newCode.Job_Country__c = 'HKG';
        newCode.Pay_Company__c = 12;
        newCode.Signatory_Name__c = 'Test';
        newcode.Signature_Object__c = 'Test';           
       insert newCode;
           
       RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name='Test',Building_City__c='Bangalore',Postal_Code__c='1234');
       insert newEmpOffice;
      
       RL_OwnerShip_Assignment__c newOwnership = new RL_OwnerShip_Assignment__c(Name='Test');
       insert newOwnership;
      
       RL_Group_assignment__c newGroup = new RL_Group_assignment__c(Name='Test');
       insert newGroup;       
         
             
      //Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = 'a1Qf00000001vrH']; 
      
     /* Reference_Letter__c rL = [select id, name, reference_letter_code__c from Reference_Letter__c where id='a1Hf0000000H1oz'];       
      Reference_Letter_Request__c newLetter = [select Id,Name, reference_letter__c,Reference_letter_name__c,requesting_employee__c ,Destination__c,Date_of_Travel__c,Return_Date__c,
                 Include_Family_Members__c,Name_of_the_Person__c, Relationship__c,Court_Date__c,Reason_for_Exemption__c,Duration_in_Day__c,
                 Duration_in_Week__c,Duration_in_Month__c,Duration_in_Year__c, requesting_employee__r.name,workflow__c,for_employee__c,
                     for_employee__r.name,Urgent_HR_Request__c,Compensation_Information__c,Nationality__c from Reference_Letter_Request__c where id='a1Qf00000001XsA' ];
      */
        
   
               
      /* Reference_Letter__c rL = new Reference_Letter__c(Name='Testing',Requestor__c='0001177',Reference_Letter_Code__c='RL0007',Location__c='Asia',Conga_Query_Id__c='a0mf0000000EBGc',Conga_Template__c='a0Rf0000000Bivv');
          insert rL;      */
      Reference_Letter__c rL = [select id, name, Reference_Letter_Code__c,Location__c, Conga_Query_Id__c, Conga_Template__c from Reference_Letter__c where Reference_Letter_Code__c='RL0007'    ]; 
             
        Cont_Eork_type__c newPoi  = new Cont_Eork_type__c(Name='132',Contigent_Work_code__c='Test');
        insert newPoi;
             
             
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = rL.id;    
        newLetter.Conga_Employee_Gender__c = 'Female';
        
        newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA'; 
        //newLetter.Poi_Type__c  = newPoi.    
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
       
        newLetter.Conga_Employee_Job_City__c = 'IND';
        newLetter.Conga_Super_Division_Dsc_Org__c = 'IND';
        newLetter.Conga_Headcount_Job__c = 'Test';
        newLetter.Conga_Level_job__c = 'TEST';
        newLetter.Conga_Level_Dsc_Job__c = 'Test';
        newLetter.For_Employee_Email__c = 'abc@test.com';
        newLetter.Requesting_Employee_Email__c = 'abc@test.com';
        newLetter.Status__c = 'Approval Step 2';
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
        newLetter.Conga_Employee_Job_Country__c=newcode.id;           
        newLetter.Building_City_Directory__c = newEmpOffice.Building_City__c;
        newLetter.Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c;             
        insert newLetter;        
      
       PageReference pageRef = Page.RL_Home;
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
       ApexPages.currentPage().getParameters().put('success',newLetter.id);
       ApexPages.currentPage().getParameters().put('id',newLetter.id);
       ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
       ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
             ApexPages.currentPage().getParameters().put('dev',newLetter.id);
       RL_Employee customController = new RL_Employee();
            
       customcontroller.AddMore();
       customcontroller.AddMore1();
       customcontroller.cancel();
       customcontroller.getIncludeBaseSalary();
       //customcontroller.setFlag1();
       //customcontroller.setFlag2();
       customcontroller.setFlagToNameRelationship();
       customcontroller.FlagToTheRecipientBelow();
       customcontroller.FlagToIncludedInThisCoverNote();
       customcontroller.FlagToIncludedBasSalaryRentApp();
       customcontroller.includeBaseSalary();
       customcontroller.showRecipient();
       customcontroller.setDurationFlag();
       customcontroller.setLayoutFlag();
       customcontroller.showInvitingOrg();
       customcontroller.setJourneyFLag();
       customcontroller.setNationalityFlag();
       customcontroller.setAddresseFlag();
       customcontroller.setPassportFlag();
       //customcontroller.setRecipientFlag();
       customcontroller.showLetterSelection();
       customcontroller.save();
       customcontroller.reDirect();
       customcontroller.newRequest();
       customcontroller.exit();
       customcontroller.cancel();
       customcontroller.getAvailableLetters();
       customcontroller.getRequestFor();
       customcontroller.getEmployees();
       customcontroller.setEmployeeRequest();
       customcontroller.getReferenceLetterList();
       //customcontroller.getGroups();
       //customcontroller.validateEMEAHR();       
      //r.Address_by_Reference__c = 'Address Only';          
      
             
        /*Reference_Letter_Request__c newRefLetter = new Reference_Letter_Request__c(Requesting_Employee__c = newEmployee.id ,Reference_Letter__c=newRef.id , Request_For__c = 'Myself' , Number_of_Copies__c='1',Conga_First_Name__c='Test1',Conga_Last_Name__c='Test2',
                                                                                   Primary_Pay_Company_Dsc_Job__c='Desc',Conga_Login_Id_Directory__c ='test',Conga_Employee_Job_Country__c='India',
                                                                                  Conga_Meeting_Location__c = 'India',Conga_Region_Dsc_Org__c='Test',Status__c='Approval Step 2');
        insert newRefLetter; */
        
             
             
      
       
         
        
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Validate validate = new RL_Validate();
        validate.validationsForEMEA(rL, newLetter);
        validate.resetFields(newLetter  );
      
        
       //apexpages.currentpage().getParameters().put('dev','dev');
     
      
             
       
       Test.stopTest();
         }
     }
    
     public static testmethod void test3()
     {
        
         Employee__c emp = [select id, user__c from employee__c where Job_Country_Job__c  ='HKG' and emp_id__c = '95BYG' and status__c = 'Active' and user__r.isActive = true limit 1];
         
         User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :emp.user__c];
         

         System.runAs(thisUser) {

       
         
      Test.startTest(); 
      
       /*User u1 = [select name from user where name = 'Avinash Munaga' and Profile.Name = 'All MS Employee' and isActive = true LIMIT 1];
       system.debug('--------------------u1--------------'+u1.name);
         */    
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];
      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];
       
       //Employee__c newEmployee = new Employee__c(Name='Avinash Munaga1',Emp_ID__c = '82KLE', User__c= u1.id,Job_Region_Code__c='EU');
       //insert newEmployee;
       /*Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where id = 'a00f0000005hPY3' LIMIT 1];
       newEmployee.Job_Country_Job__c = 'HKG';
       update newEmployee;
       */
       Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NJ' and Job_Country_Job__c = 'HKG' LIMIT 1];      

       RL_DivisionDscOrg__c newDivision = new RL_DivisionDscOrg__c(Name='12123',Division_Code__c='25000',Division_Dsc_Value__c='Morgan Stanley Strats ',Primary_Pay_Company__c='123',Super_Department_Code__c='012') ;   
       insert newDivision;
       
        Urgent_Request__c ur = [select id,group_name__c from Urgent_Request__c LIMIT 1];
                  
           
        RL_JobCountrySignatoryCodes__c newCode = new RL_JobCountrySignatoryCodes__c(Name='HKG_1212');
        newCode.Job_Country__c = 'HKG';
        newCode.Pay_Company__c = 12;
        newCode.Signatory_Name__c = 'Test';
        newcode.Signature_Object__c = 'Test';           
       insert newCode;
           
       RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name='Test',Building_City__c='Bangalore',Postal_Code__c='1234');
       insert newEmpOffice;
      
       RL_OwnerShip_Assignment__c newOwnership = new RL_OwnerShip_Assignment__c(Name='Test');
       insert newOwnership;
      
       RL_Group_assignment__c newGroup = new RL_Group_assignment__c(Name='Test');
       insert newGroup;       
         
             
      //Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = 'a1Qf00000001vrH']; 
      
     /* Reference_Letter__c rL = [select id, name, reference_letter_code__c from Reference_Letter__c where id='a1Hf0000000H1oz'];       
      Reference_Letter_Request__c newLetter = [select Id,Name, reference_letter__c,Reference_letter_name__c,requesting_employee__c ,Destination__c,Date_of_Travel__c,Return_Date__c,
                 Include_Family_Members__c,Name_of_the_Person__c, Relationship__c,Court_Date__c,Reason_for_Exemption__c,Duration_in_Day__c,
                 Duration_in_Week__c,Duration_in_Month__c,Duration_in_Year__c, requesting_employee__r.name,workflow__c,for_employee__c,
                     for_employee__r.name,Urgent_HR_Request__c,Compensation_Information__c,Nationality__c from Reference_Letter_Request__c where id='a1Qf00000001XsA' ];
      */
        
   
               
       /*Reference_Letter__c rL = new Reference_Letter__c(Name='Testing',Requestor__c='0001177',Reference_Letter_Code__c='RL0003',Location__c='Asia',Conga_Query_Id__c='a0mf0000000EBGc',Conga_Template__c='a0Rf0000000Bivv');
          insert rL;      
      */
        Reference_Letter__c rL = [select id, name, Reference_Letter_Code__c,Location__c, Conga_Query_Id__c, Conga_Template__c from Reference_Letter__c where Reference_Letter_Code__c='RL0003'    ];      
        Cont_Eork_type__c newPoi  = new Cont_Eork_type__c(Name='132',Contigent_Work_code__c='Test');
        insert newPoi;
             
             
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = rL.id;     
        newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA'; 
        //newLetter.Poi_Type__c  = newPoi.    
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
       
        newLetter.Conga_Employee_Job_City__c = 'IND';
        newLetter.Conga_Super_Division_Dsc_Org__c = 'IND';
        newLetter.Conga_Headcount_Job__c = 'Test';
        newLetter.Conga_Level_job__c = 'TEST';
        newLetter.Conga_Level_Dsc_Job__c = 'Test';
        newLetter.For_Employee_Email__c = 'abc@test.com';
        newLetter.Requesting_Employee_Email__c = 'abc@test.com';
        newLetter.Status__c = 'Approval Step 2';
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
        newLetter.Conga_Employee_Job_Country__c=newcode.id;           
        newLetter.Building_City_Directory__c = newEmpOffice.Building_City__c;
        newLetter.Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c;             
        insert newLetter;        
      
       PageReference pageRef = Page.RL_Home;
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
       ApexPages.currentPage().getParameters().put('success',newLetter.id);
       ApexPages.currentPage().getParameters().put('id',newLetter.id);
       ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
       ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
             ApexPages.currentPage().getParameters().put('dev',newLetter.id);
       RL_Employee customController = new RL_Employee();
            
       customcontroller.AddMore();
       customcontroller.AddMore1();
       customcontroller.cancel();
       customcontroller.getIncludeBaseSalary();
       //customcontroller.setFlag1();
       //customcontroller.setFlag2();
       customcontroller.setFlagToNameRelationship();
       customcontroller.FlagToTheRecipientBelow();
       customcontroller.FlagToIncludedInThisCoverNote();
       customcontroller.FlagToIncludedBasSalaryRentApp();
       customcontroller.includeBaseSalary();
       customcontroller.showRecipient();
       customcontroller.setDurationFlag();
       customcontroller.setLayoutFlag();
       customcontroller.showInvitingOrg();
       customcontroller.setJourneyFLag();
       customcontroller.setNationalityFlag();
       customcontroller.setAddresseFlag();
       customcontroller.setPassportFlag();
       //customcontroller.setRecipientFlag();
       customcontroller.showLetterSelection();
       customcontroller.save();
       customcontroller.reDirect();
       customcontroller.newRequest();
       customcontroller.exit();
       customcontroller.cancel();
       customcontroller.getAvailableLetters();
       customcontroller.getRequestFor();
       customcontroller.getEmployees();
       customcontroller.setEmployeeRequest();
       customcontroller.getReferenceLetterList();
       //customcontroller.getGroups();
       //customcontroller.validateEMEAHR();       
      //r.Address_by_Reference__c = 'Address Only';          
      
             
        /*Reference_Letter_Request__c newRefLetter = new Reference_Letter_Request__c(Requesting_Employee__c = newEmployee.id ,Reference_Letter__c=newRef.id , Request_For__c = 'Myself' , Number_of_Copies__c='1',Conga_First_Name__c='Test1',Conga_Last_Name__c='Test2',
                                                                                   Primary_Pay_Company_Dsc_Job__c='Desc',Conga_Login_Id_Directory__c ='test',Conga_Employee_Job_Country__c='India',
                                                                                  Conga_Meeting_Location__c = 'India',Conga_Region_Dsc_Org__c='Test',Status__c='Approval Step 2');
        insert newRefLetter; */
        
             
             
      
       
         
        
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Validate validate = new RL_Validate();
        validate.validationsForEMEA(rL, newLetter);
        validate.resetFields(newLetter  );
      
        
       //apexpages.currentpage().getParameters().put('dev','dev');
     
      
             
       
       Test.stopTest();
         }
     }
      
    public static testmethod void test4()
     {
        
         Employee__c emp = [select id, user__c from employee__c where Job_Country_Job__c  ='HKG' and emp_id__c = '95BYG' and status__c = 'Active' and user__r.isActive = true limit 1];
         /*Employee__c emp = RL_Test_Data.createEmp('Emp4','4774','RL128');
         emp.Empl_Class_Job__c = 'C';
        emp.Employee_Sub_Class__c = 'R';
        emp.Job_Region_Code__c = 'NA';
        emp.Status__c = 'Active';
        emp.Job_Region_Code__c = 'EU';
        update emp;*/
         User thisUser = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :emp.user__c];
         
         System.runAs(thisUser) {

       
         
      Test.startTest(); 
      
      /* User u1 = [select name from user where name = 'Avinash Munaga' and Profile.Name = 'All MS Employee' and isActive = true LIMIT 1];
       system.debug('--------------------u1--------------'+u1.name);
        */     
       EmailTemplate newTemplate = [Select e.Id, e.DeveloperName From EmailTemplate e where folder.Name='Ref Letter Folder' LIMIT 1];
      
       QueueSobject newQ = [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType='Reference_Letter_Request__c' LIMIT 1];
       
       //Employee__c newEmployee = new Employee__c(Login_Id_Directory__c='munaga1',Name='Avinash Munaga1',Emp_ID__c = '82KLE', User__c= u1.id,Job_Region_Code__c='N');
       //insert newEmployee;
       /*Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where id = 'a00f0000005hPY3' LIMIT 1];
       newEmployee.Job_Country_Job__c = 'SGP';
       update newEmployee;
         */
       Employee__c newEmployee = [select id,Login_Id_Directory__c,Poi_Type__c,Job_Region_Code__c  from Employee__c where status__c = 'Active' and Empl_Class_Job__c = 'A' and Job_Region_Code__c ='NJ' and Job_Country_Job__c = 'SGP' LIMIT 1];    
       
       RL_DivisionDscOrg__c newDivision = new RL_DivisionDscOrg__c(Name='12123',Division_Code__c='25000',Division_Dsc_Value__c='Morgan Stanley Strats ',Primary_Pay_Company__c='123',Super_Department_Code__c='012') ;   
       insert newDivision;
       
        Urgent_Request__c ur = [select id,group_name__c from Urgent_Request__c LIMIT 1];
                  
           
        RL_JobCountrySignatoryCodes__c newCode = new RL_JobCountrySignatoryCodes__c(Name='HKG_1212');
        newCode.Job_Country__c = 'HKG';
        newCode.Pay_Company__c = 12;
        newCode.Signatory_Name__c = 'Test';
        newcode.Signature_Object__c = 'Test';           
       insert newCode;
           
       RL_Emp_Office_Address__c newEmpoffice = new RL_Emp_Office_Address__c(Name='Test',Building_City__c='Bangalore',Postal_Code__c='1234');
       insert newEmpOffice;
      
       RL_OwnerShip_Assignment__c newOwnership = new RL_OwnerShip_Assignment__c(Name='Test');
       insert newOwnership;
      
       RL_Group_assignment__c newGroup = new RL_Group_assignment__c(Name='Test');
       insert newGroup;       
         
             
      //Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = 'a1Qf00000001vrH']; 
      
     /* Reference_Letter__c rL = [select id, name, reference_letter_code__c from Reference_Letter__c where id='a1Hf0000000H1oz'];       
      Reference_Letter_Request__c newLetter = [select Id,Name, reference_letter__c,Reference_letter_name__c,requesting_employee__c ,Destination__c,Date_of_Travel__c,Return_Date__c,
                 Include_Family_Members__c,Name_of_the_Person__c, Relationship__c,Court_Date__c,Reason_for_Exemption__c,Duration_in_Day__c,
                 Duration_in_Week__c,Duration_in_Month__c,Duration_in_Year__c, requesting_employee__r.name,workflow__c,for_employee__c,
                     for_employee__r.name,Urgent_HR_Request__c,Compensation_Information__c,Nationality__c from Reference_Letter_Request__c where id='a1Qf00000001XsA' ];
      */
        
   
               
       /*Reference_Letter__c rL = new Reference_Letter__c(Name='Testing',Requestor__c='0001177',Reference_Letter_Code__c='RL0003',Location__c='Asia',Conga_Query_Id__c='a0mf0000000EBGc',Conga_Template__c='a0Rf0000000Bivv');
          insert rL;      
      */
      Reference_Letter__c rL = [select id, name, Reference_Letter_Code__c,Location__c, Conga_Query_Id__c, Conga_Template__c from Reference_Letter__c where Reference_Letter_Code__c='RL0003'    ]; 
             
        Cont_Eork_type__c newPoi  = new Cont_Eork_type__c(Name='132',Contigent_Work_code__c='Test');
        insert newPoi;
             
             
        Reference_Letter_Request__c newLetter = new Reference_Letter_Request__c ();
        newLetter.Reference_Letter__c = rL.id;     
        newLetter.Email_Q_Name__c = 'RL_HRSC_Queue_ASIA'; 
        //newLetter.Poi_Type__c  = newPoi.    
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
       
        newLetter.Conga_Employee_Job_City__c = 'IND';
        newLetter.Conga_Super_Division_Dsc_Org__c = 'IND';
        newLetter.Conga_Headcount_Job__c = 'Test';
        newLetter.Conga_Level_job__c = 'TEST';
        newLetter.Conga_Level_Dsc_Job__c = 'Test';
        newLetter.For_Employee_Email__c = 'abc@test.com';
        newLetter.Requesting_Employee_Email__c = 'abc@test.com';
        newLetter.Status__c = 'Approval Step 2';
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
       // newLetter.All_Employees__c = newEmployee.id;
        newLetter.For_Employee__c = newEmployee.id;    
        newLetter.Status__c='Approval Step 2';
        newLetter.Escalation__c='No';
    //newLetter.Email_Q_Name__c = 'Test Group';
        newLetter.Email_Requestor_Email__c='abc@as.com';
        newLetter.Email_OnBehalf_Email__c='abc@as.com';
        newLetter.Requesting_Employee__c = newEmployee.id;        
        newLetter.Destination__c='India';
        newLetter.Conga_Employee_Job_Country__c=newcode.id;           
        newLetter.Building_City_Directory__c = newEmpOffice.Building_City__c;
        newLetter.Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c;
       // newLetter.Include_Passport_Number__c= true;
        //newLetter.BusinessVisaIsPassPortNo = true;
        
        insert newLetter;        
      
       PageReference pageRef = Page.RL_Home;
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.StandardController(newLetter);
       ApexPages.currentPage().getParameters().put('success',newLetter.id);
       ApexPages.currentPage().getParameters().put('id',newLetter.id);
       ApexPages.currentPage().getParameters().put('successLoad',newLetter.id);
       ApexPages.currentPage().getParameters().put('visaLetterAsia',newLetter.id);
             ApexPages.currentPage().getParameters().put('dev',newLetter.id);
       RL_Employee customController = new RL_Employee();
            
       customcontroller.AddMore();
       customcontroller.AddMore1();
       customcontroller.cancel();
       customcontroller.getIncludeBaseSalary();
       //customcontroller.setFlag1();
       //customcontroller.setFlag2();
       customcontroller.setFlagToNameRelationship();
       customcontroller.FlagToTheRecipientBelow();
       customcontroller.FlagToIncludedInThisCoverNote();
       customcontroller.FlagToIncludedBasSalaryRentApp();
       customcontroller.includeBaseSalary();
       customcontroller.showRecipient();
       customcontroller.setDurationFlag();
       customcontroller.setLayoutFlag();
       customcontroller.showInvitingOrg();
       customcontroller.setJourneyFLag();
       customcontroller.setNationalityFlag();
       customcontroller.setAddresseFlag();
       customcontroller.setPassportFlag();
       //customcontroller.setRecipientFlag();
       customcontroller.showLetterSelection();
       customcontroller.save();
       customcontroller.reDirect();
       customcontroller.newRequest();
       customcontroller.exit();
       customcontroller.cancel();
       customcontroller.getAvailableLetters();
       customcontroller.getRequestFor();
       customcontroller.getEmployees();
       customcontroller.setEmployeeRequest();
       customcontroller.getReferenceLetterList();
       //customcontroller.getGroups();
       //customcontroller.validateEMEAHR();       
      //r.Address_by_Reference__c = 'Address Only';          
      
             
        /*Reference_Letter_Request__c newRefLetter = new Reference_Letter_Request__c(Requesting_Employee__c = newEmployee.id ,Reference_Letter__c=newRef.id , Request_For__c = 'Myself' , Number_of_Copies__c='1',Conga_First_Name__c='Test1',Conga_Last_Name__c='Test2',
                                                                                   Primary_Pay_Company_Dsc_Job__c='Desc',Conga_Login_Id_Directory__c ='test',Conga_Employee_Job_Country__c='India',
                                                                                  Conga_Meeting_Location__c = 'India',Conga_Region_Dsc_Org__c='Test',Status__c='Approval Step 2');
        insert newRefLetter; */
        
             
             
      
       
         
        
      
      
              
       // Reference_Letter_Request__c r = [select Id,Name from Reference_Letter_Request__c where id = :rL.id];      
       
        RL_Validate validate = new RL_Validate();
        validate.validationsForEMEA(rL, newLetter);
        validate.resetFields(newLetter);
        //validate.validationForAsiaLetters(rL, newLetter, newEmployee);
        
       //apexpages.currentpage().getParameters().put('dev','dev');
     
      
             
       
       Test.stopTest();
         }
     }
   /* static testMethod void myTest8() {
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
    } */

}