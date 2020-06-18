@isTest(SeeAllData=true)
private class RL_Reminder_SendEmailsHelper_Test {
    
    static testMethod void myTest() {
        
        List<Reference_Letter_Request__c> refList= new List<Reference_Letter_Request__c>();
        Datetime dt1=Datetime.now();
        
        RL_Emp_Office_Address__c newEmpoffice = RL_TestData.createEmpoffice();
        //Insert new employee
        Employee__c newEmployee = RL_TestData.createEmp();
        
        Reference_Letter__c refLetter = [select id,Reference_Letter_Code__c,Requestor__c 
                                         from Reference_Letter__c where Name='Bank Letter'  LIMIT 1]; 
        //Insert Reference Letter Request 
        Reference_Letter_Request__c newLetter1 = 
            new Reference_Letter_Request__c (Reference_Letter__c = refLetter.id,Conga_Employee_Gender__c = 'Female', 
                                             Company_Address_Title__c = 'Sample',Company_Address_SName__c = 'Sa',
                                             Requesting_Employee__c = newEmployee.id, For_Employee__c = newEmployee.id,
                                             Conga_Login_Id_Directory__c = newEmployee.Login_Id_Directory__c,          
                                             Building_City_Directory__c = newEmpOffice.Building_City__c,
                                             Building_Postal_Cd_Directory__c = newEmpOffice.Postal_Code__c,
                                             Company_Address_Name__c ='sa',Company_Address_1__c  = '1',
                                             Company_Address_3__c = '3',Company_Address_PC__c  = 'PC',
                                             Address_by_Reference__c ='Name and Address',Company_Name__c = 'MS',
                                             Address_1_Home__c = 'Address 1 Home', Address_2_Home__c = 'Address 2 Home',
                                             Address_3_Home__c = 'Address 3 Home', Address_4_Home__c = 'Address 4 Home',
                                             Conga_Home_City__c = 'Conga Home', Conga_Home_Postal_Code__c = 'Conga Postalcode',
                                             Conga_State_Home__c ='TN', Conga_State_Home_Dsc_Home__c ='TN',
                                             Conga_Country_Dsc_Home__c ='IND',Conga_Adj_Hire_Date__c = date.today(),
                                             Conga_Age__c = '24',Conga_Alternate1_Dsc_Org__c = 'ABC',
                                             Conga_Alternate1_Org__c = 'ABC',Conga_Birth_Country_Description__c = 'IND',
                                             Conga_Building_Address_1_Directory__c = 'Test 1',
                                             Conga_Building_Address_2_Directory__c = 'Test 2',
                                             Conga_Building_Address_3_Directory__c = 'Test 3',
                                             Conga_Building_Country_Directory__c = 'Test Building',
                                             Conga_Building_Directory__c = 'Test Building',
                                             Conga_Building_Dsc_Bldg__c = 'Test Building',
                                             Conga_Building_Job__c = 'Test Building',
                                             Conga_Building_State_Directory__c = 'Test Building',
                                             Conga_Business_Title__c = 'Test',Conga_CC_City_Dsc_Org__c = 'Test',
                                             Conga_CC_City_Org__c = 'Test', Conga_CC_Region_Org__c = 'A',
                                             conga_citizenship_country__c = 'Test',Conga_Club_Status__c= 'Test',
                                             Conga_Club_Year__c= 'Test',Conga_Commitment_Status__c= 'Test',
                                             Conga_Cost_Center__c= 'Test', Cost_Center_Code__c= 'Test',
                                             Conga_Cost_Center_Desc__c= 'Test',Conga_Country_Home__c= 'Test',          
                                             Conga_Covenant_Date__c= date.today(), Conga_Current_Compensation_Year__c= 'Test',
                                             Conga_Days_of_Perm_Serv_Total_LOS__c = 10, Conga_Dept_Org__c= 'Test',
                                             Conga_Division_Org__c= 'Test', Conga_DocuSign_GUID__c= 'Test',
                                             Conga_Email__c= 'Test@abc.com', Conga_Empl_Class_Job__c = 'Test',
                                             Conga_Empl_Type_Dsc_Job__c= 'Test', Conga_Empl_Type_Job__c= 'Test',
                                             Conga_Employee_Sub_Class__c= 'Test', Conga_Ethnic_Group__c= 'Test',
                                             Conga_Ethnic_Group_Dsc__c= 'Test', Conga_Financial_Advisor_Number__c= 'Test',
                                             Conga_Floor_Directory__c= 'Test', Conga_Gender_Dsc__c= 'Test',
                                             Conga_Geographic_Region_Directory__c= 'Test', Conga_HasEquity__c= true,
                                             Conga_Inactive__c= true,Conga_Job_City_Job__c= 'Test',Conga_Jobcode_Job__c= 'Test',
                                             Conga_Job_Country_Dsc_Job__c= 'Test', Conga_Job_Family__c= 'Test',
                                             Conga_Job_Function_code__c= 'Test', Conga_Job_Function_Dsc__c= 'Test',
                                             Conga_Job_State_Job__c= 'Test', Conga_Job_Title__c= 'Test',
                                             Conga_Job_Title_Dsc_Job__c= 'Test', Conga_Legal_Entity_Job__c= 'Test',
                                             Conga_MS_MSSB__c = '123', Conga_Phone_Area_Code_Home__c = '123',
                                             Conga_Phone_Number_Home__c = '123', Conga_Poi_Type__c = 'TEST' ,
                                             Conga_Region_Dsc_Org__c = 'Test' , Conga_Sched_Hours_Job__c = 12,
                                             Conga_Schedule_Type_Dsc_Job__c = 'Test', Conga_Schedule_Type_Job__c = 'Test',
                                             Conga_Status__c = 'Test', Conga_Sub_Depart2_Dsc_Org__c = 'Test',
                                             Conga_Sub_Depart2_Org__c = 'Test', Conga_Subdept_Dsc_Org__c = 'Test',
                                             Conga_Subdept_Org__c = 'Test', Conga_Super_Depart_Dsc_Org__c = 'Test',           
                                             Conga_Super_Depart_Org__c = 'Test', Conga_Super_Division__c = 'Test',
                                             Conga_Super_Division_Dsc_Org__c = 'Test', Conga_Term_Reason__c = 'Test',
                                             Conga_USA_Diversity_Ind_Job__c = 'Test', Conga_Work_Days_Total__c = 12,
                                             Conga_Work_Phone__c = '123', Conga_Employee_Job_City__c = 'IND',
                                             //Company_Name__c = 'Test1',
                                             Conga_First_Name__c = 'IND', Conga_Last_Name__c = 'IND',
                                             Conga_Job_Country_Job__c = 'IND',Conga_Title__c = 'MS',Conga_Headcount_Job__c='12',
                                             Conga_Level_Job__c='12', Conga_Level_Dsc_Job__c='test',
                                             For_Employee_Email__c='abc@as.com', Requesting_Employee_Email__c='abc@as.com',        
                                             Status__c='Approval Step 2', Escalation__c='No',
                                             //Email_Requestor_Email__c='abc@as.com',
                                             Email_OnBehalf_Email__c='abc@as.com', Email_Q_Template__c ='Task_completed_by_HR_Partner',
                                             // Email_Q_Template__c ='test',
                                             Email_OnBehalf_Template__c='To_the_person_who_submitted_the_letter' ,
                                             Email_Requestor_Template__c ='To_the_person_who_submitted_the_letter',
                                             Destination__c='India', Include_Passport_Number__c = boolean.valueof('true'),          
                                             The_recipient_below__c = true, Include_Current_Base_Salary__c = false,
                                             Include_Total_Compensation__c = false, Address_Letter_To__c = 'Specify Name/Address', 
                                             Request_For__c='Myself', Include_Family_Members__c = true, Duration_in_Day__c = '1',
                                             Duration_in_Month__c = 'Year(s)', Urgent_HR_Request__c = true,
                                             email_q_name__c = 'RL_HRSC_Queue_ASIA',Comments__c = false,
                                             email_requestor_email__c= 'references.asia@morganstanley.com',
                                             SET_Q_TEMPLATE_Reminder_Template__c='Remainder_emails',
                                             SET_Q_EMAIL_Reminder_Name__c='RL_HRSC_Queue_ASIA');   
        
        
        Database.insert(newLetter1);
        refList.add(newLetter1);
        
        Test.startTest();
            RL_Reminder_SendEmailsHelper reminderClassObject= new RL_Reminder_SendEmailsHelper(); 
            reminderClassObject.setMailContent(refList);
            reminderClassObject.makeTheTestRun();
        Test.stopTest();
    }
}