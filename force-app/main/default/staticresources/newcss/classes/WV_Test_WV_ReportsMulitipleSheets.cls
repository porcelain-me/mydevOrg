@istest(SeeAllData=false)

public class WV_Test_WV_ReportsMulitipleSheets{

    public testmethod static void Testmethod002(){     
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='test', Last_Name__c='test',Email__c='test@gmail.com',Cost_Center__c='4324',Country_Home__c='IND',Job_Region_Code__c='EU',Officer__c='N',Primary_Pay_Company_Job__c='96',Empl_Class_Job__c='A',Benefit_Program__c='UK',Status__c='Active');
        insert employee;
        
        User loggedinUser;
        List<Profile> profilename=[select id,name from profile where name='All MS Employee'];
        system.assert(profilename!=null,'ALL MS Employee profile is not there.');
        system.assertEquals(profilename.size(),1,'ALL MS Employee profile is not there.');
        
        List<User> validUser=[select id, name, firstname, lastname, email,Emp_Id__c,profileId,isactive,CreatedDate  from user where profileid=:profilename[0].id AND Emp_Id__c!=null AND isactive=true limit 1];
        system.assert(validUser!=null,'No Active user found in ALL MS Employee profile.');
        system.assertEquals(validUser.size(),1,'No Active user found in ALL MS Employee profile.');
        
        employee.emp_Id__c=validUser[0].emp_Id__c;
        update employee;
        loggedinUser=validUser[0];
        system.debug('**********'+loggedinUser); 
        
        Wav_Source__c source1=new Wav_Source__c(Name='Test Source testing',active__C=true,Source_Order__c=0);
        insert source1;
        
        Wav_Source__c source2=new Wav_Source__c(Name='Test Source testinging',active__C=true,Source_Order__c=1);
        insert source2;
        
        Deferral__c def=new Deferral__c(Name='Test Deferral test',active__C=true,order__c=1);
        insert def;
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency test',Value__c='INR');
        insert currencys;
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus test',Value__c=0);
        insert abacus;
        
        Waiver_Template__c template=new Waiver_Template__c(Name='Test Template test');
        insert template;
        
        Input_Controls_Mapping__c control1=WV_TestData.WV_insertControls(template.Id,'List Control test','List Capture','Primary',true);
        Input_Controls_Mapping__c control2=WV_TestData.WV_insertControls(template.Id,'List Control test','List Capture','Secondary',true);
        Input_Controls_Mapping__c control3=WV_TestData.WV_insertControls(template.Id,'Value Control test','Value Capture','Secondary',false);
        Input_Controls_Mapping__c control4=WV_TestData.WV_insertControls(template.Id,'Value Control test','Value Capture',null,true);
        Input_Controls_Mapping__c control5=WV_TestData.WV_insertControls(template.Id,'Value Control test','Value Capture',null,false);
        Input_Controls_Mapping__c control6=WV_TestData.WV_insertControls(template.Id,'Multilist Control test','Multi Value Option Capture',null,true);
        Input_Controls_Mapping__c control7=WV_TestData.WV_insertControls(template.Id,'Multilist Control test','Multi Value Option Capture','Secondary',true);
        
        //Fixed scheme with shorter description..,
        Scheme__c Scheme01=new Scheme__c(Name='Test scheme test',abacus__c='Yes',Abacus_n__C=abacus.Id,Term__c ='Fixed',source__c =source1.Id,deferral__c =def.Id,description__c='Personal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place. Salesforce.comPersonal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place.',scheme_Currency__c=currencys.Id,Waiver_Template__c=template.Id,Active__c=true);
        insert Scheme01;
        
        Enrollment_Period__c enrolold01=new Enrollment_Period__c(name='test',Start_Date__c=system.now().addyears(-1),End_Date__c=system.now().addyears(-1).addmonths(2),Override_Scheme__c=Scheme01.Id);
        insert enrolold01;   
        
        Enrollment_Period__c enrol01=new Enrollment_Period__c(name='test1',Start_Date__c=system.now().addminutes(-10),End_Date__c=system.now().addminutes(10),Override_Scheme__c=Scheme01.Id);
        insert enrol01;     
       
        //Eligibility-Rule based..,
        Eligibility__c eligibiltyrule01=new Eligibility__c(name='Database rules',Database_Driven__c=true,Scheme__c=Scheme01.Id,Cost_Center__c='4324',Home_Country__c='IND',Job_Region__c='EU',Officer__c='N',Pay_Company__c='96',Employee_Class__c='A',Benefit_Program__c='UK');
        insert eligibiltyrule01;
                        
        //Custom data-text..,
        Custom_Data_upload_file__c custom01=new Custom_Data_upload_file__c(name='investmentfile',Scheme__c=Scheme01.Id,File_Type__c='Text',Columns__c='MSID->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom01;
        
        Wav_Custom_data__c customdata02=new Wav_Custom_data__c(File_Upload__c=custom01.Id,MSID__c=employee.emp_Id__c,Text1__c='100',Text2__c='1,000');
        insert customdata02;
        
        //Custom data-table..,
        Custom_Data_upload_file__c custom02=new Custom_Data_upload_file__c(name='Pensionfile',Scheme__c=Scheme01.Id,File_Type__c='Table',Columns__c='msid->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom02;
        
        Wav_Custom_data__c customdata05=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='100',Text2__c='1,000');
        insert customdata05;
        
        Wav_Custom_data__c customdata06=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='test, me',Text2__c='1000');
        insert customdata06;
        
        Wav_Custom_data__c customdata07=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='',Text2__c='');
        insert customdata07;
        
        Wav_Custom_data__c customdata08=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='test',Text2__c='');
        insert customdata08;
        
        //Custom data-text 02..,
        Custom_Data_upload_file__c custom03=new Custom_Data_upload_file__c(name='investmentfiletext2',Scheme__c=Scheme01.Id,File_Type__c='Text',Columns__c='MSID->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom03;
        
        Wav_Custom_data__c customdata09=new Wav_Custom_data__c(File_Upload__c=custom03.Id,MSID__c=employee.emp_Id__c,Text1__c='test',Text2__c='3.65');
        insert customdata09;
        
        //Contents.
        Wav_Content__c content01=new Wav_Content__c(Content__c='@Country1 @Division1 @EmpId1 @FirstName1 @LastName1 @Region1 Test @Pensionfile.table @investmentfile.table Test Source 01 @investmentfile.msid @investmentfile.min_value @investmentfile.max_value',Content_Type__c='Introduction',Scheme__c=Scheme01.Id);
        insert content01;
        
        Wav_Content__c content02=new Wav_Content__c(Content__c='@Country1 @Division1 @EmpId1 @FirstName1 @LastName1 @Region1 Test @Pensionfile.table @investmentfile.table Test Source 01 @investmentfile.msid @investmentfile.min_value @investmentfile.max_value',Content_Type__c='Description',Scheme__c=Scheme01.Id);
        insert content02;
        
        Wav_Content__c content03=new Wav_Content__c(Content__c='@Country1 @Division1 @EmpId1 @FirstName1 @LastName1 @Region1 Test @Pensionfile.table @investmentfile.table Test Source 01 @investmentfile.msid @investmentfile.min_value @investmentfile.max_value',Content_Type__c='Terms & Conditions',Scheme__c=Scheme01.Id);
        insert content03;
        
        Input_Controls_Mapping__c controlCloned1=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='List Control test',Input_Control_Type__c='List Capture',Control_Visibility__c='Primary',Required__c=true,Scheme__c=Scheme01.Id,Show_Currency__c=true,Custom_Data_Values__c='Amount\r\nPercentage');
        insert controlCloned1;
        Input_Controls_Mapping__c controlCloned2=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='List Control test',Input_Control_Type__c='List Capture',Control_Visibility__c='Secondary',Required__c=true,Scheme__c=Scheme01.Id,Show_Currency__c=false,Custom_Data_Values__c='Amount\r\nPercentage\r\nNumbers');
        insert controlCloned2;
        Input_Controls_Mapping__c controlCloned3=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='Value Control test',Input_Control_Type__c='Value Capture',Control_Visibility__c='Secondary',Required__c=false,Scheme__c=Scheme01.Id,Show_Currency__c=true,Value_Type__c='Number',Default_Minimum_Value__c=1,Default_Maximum_Value__c=10,Custom_Min__c=custom01.Id+',Text1__c',Custom_Max__c=custom01.Id+',Text2__c');
        insert controlCloned3;
        Input_Controls_Mapping__c controlCloned4=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='Value Control test',Input_Control_Type__c='Value Capture',Control_Visibility__c=null,Required__c=true,Scheme__c=Scheme01.Id,Show_Currency__c=false,Value_Type__c='Text',Default_Minimum_Value__c=5,Default_Maximum_Value__c=20,Controlling_Field__c=controlCloned1.Id,Dependencies_Mapping__c='Amount-Number;Percentage-Percentage;',Custom_Min__c=custom03.Id+',Text1__c',Custom_Max__c=custom03.Id+',Text2__c');
        insert controlCloned4;
        Input_Controls_Mapping__c controlCloned5=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='Value Control test',Input_Control_Type__c='Value Capture',Control_Visibility__c=null,Required__c=true,Scheme__c=Scheme01.Id,Show_Currency__c=true,Value_Type__c='Percentage',Controlling_Field__c=controlCloned2.Id,Dependencies_Mapping__c='Amount-Text;Percentage-;');
        insert controlCloned5;
        Input_Controls_Mapping__c controlCloned6=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='Multilist Control test',Input_Control_Type__c='Multi Value Option Capture',Control_Visibility__c=null,Required__c=true,Scheme__c=Scheme01.Id,Custom_Data_Values__c='Investment fund01\r\nInvestment fund02\r\nInvestment fund03\r\nInvestment fund04\r\nInvestment fund05',Percentage_validation__c=false,Description__c='test');
        insert controlCloned6;
        Input_Controls_Mapping__c controlCloned7=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='Multilist Control test',Input_Control_Type__c='Multi Value Option Capture',Control_Visibility__c='Secondary',Required__c=false,Scheme__c=Scheme01.Id,Custom_Data_Values__c='Investment fund01\r\nInvestment fund02\r\nInvestment fund03\r\nInvestment fund04\r\nInvestment fund05',Percentage_validation__c=true,Description__c='test');
        insert controlCloned7;
        
        Election__c Election01=new Election__c(Employee__c=employee.Id,Related_Enrolment__c=enrolold01.Id,Scheme__c=Scheme01.Id);
        insert Election01;
        
        Response__c res01=new Response__c (Election__c=Election01.Id,Value_New__c='Amount',Input_Controls_Mapping__c=controlCloned1.Id);
        Response__c res02=new Response__c (Election__c=Election01.Id,Value_New__c='Percentage',Input_Controls_Mapping__c=controlCloned2.Id);
        Response__c res03=new Response__c (Election__c=Election01.Id,Value_New__c='100',Input_Controls_Mapping__c=controlCloned3.Id);
        Response__c res04=new Response__c (Election__c=Election01.Id,Value_New__c='test',Input_Controls_Mapping__c=controlCloned4.Id);
        Response__c res05=new Response__c (Election__c=Election01.Id,Value_New__c='test',Input_Controls_Mapping__c=controlCloned5.Id);
        
        Response__c res06=new Response__c (Election__c=Election01.Id,Value_New__c='1',Input_Controls_Mapping__c=controlCloned6.Id,MultiListName__c='Investment fund01');
        Response__c res07=new Response__c (Election__c=Election01.Id,Value_New__c='2',Input_Controls_Mapping__c=controlCloned6.Id,MultiListName__c='Investment fund06');
        Response__c res08=new Response__c (Election__c=Election01.Id,Value_New__c='45',Input_Controls_Mapping__c=controlCloned6.Id,MultiListName__c='Investment fund03');
        
        Response__c res09=new Response__c (Election__c=Election01.Id,Value_New__c='3',Input_Controls_Mapping__c=controlCloned7.Id,MultiListName__c='Investment fund06');
        Response__c res10=new Response__c (Election__c=Election01.Id,Value_New__c='5',Input_Controls_Mapping__c=controlCloned7.Id,MultiListName__c='Investment fund07');
        Response__c res11=new Response__c (Election__c=Election01.Id,Value_New__c='45',Input_Controls_Mapping__c=controlCloned7.Id,MultiListName__c='Investment fund08');
        
        insert res01;
        insert res02;
        insert res03;
        insert res04;
        insert res05;
        insert res06;
        insert res07;
        insert res08;
        insert res09;
        insert res10;
        insert res11;   
        
        PageReference homepages=new PageReference('/apex/WV_Homepage?uid='+loggedinUser.Id);
        Test.setCurrentPage(homepages); 
           
        WV_HomepageController homepage=new WV_HomepageController();
        homepage.selectedSchemeId=Scheme01.Id;
        homepage.selectedEnrolment=enrol01.Id;
        homepage.goToElection();
        homepage.Submit();            
        
        for(WV_InputControl I:homepage.SchemeWrapper.InputControlsList){  
            if(I.RecordId == controlCloned1.Id){                    
                I.SelectedList='Amount';               
            }
            if(I.RecordId == controlCloned2.Id){                    
                I.SelectedList='Percentage';               
            }
            if(I.RecordId == controlCloned3.Id){                    
                I.enteredValue='100';               
            }
            if(I.RecordId == controlCloned4.Id){                    
                I.enteredValue='5';               
            }
            if(I.RecordId == controlCloned5.Id){                    
                I.enteredValue='anyvaluess';               
            }
            if(I.RecordId == controlCloned6.Id){                    
                for(WV_multiListWrapper M:I.multilistWrapper.MultiListWrapperList){
                     M.value='12';
                     break;
                 }           
            }
            if(I.RecordId == controlCloned7.Id){                    
                for(WV_multiListWrapper M:I.multilistWrapper.MultiListWrapperList){
                     M.value='20';
                 }               
            }          
        }
        homepage.isTermsChecked=true;
        homepage.Submit();
        
        List<election__C> electionCheck=[select id,Employee__c,Related_Enrolment__c,Scheme__c from election__c where Employee__c=:employee.Id AND Related_Enrolment__c=:enrol01.Id AND Scheme__c=:Scheme01.Id];
        system.assert(electionCheck!=null,'Election is not created yet');
        system.assert(electionCheck.size()>0,'Election is not created yet');
        
        Test.starttest();
        
        PageReference reportpage=new PageReference('/apex/WV_ElectionConsolidatedReport?id='+Scheme01.Id);
        Test.setCurrentPage(reportpage); 
        
        WV_ReportsMulitipleSheets reports=new WV_ReportsMulitipleSheets();
        
        PageReference reportpage1=new PageReference('/apex/WV_ElectionConsolidatedReport?id='+Scheme01.Id+'&eid='+enrol01.Id);
        Test.setCurrentPage(reportpage1); 
        
        WV_ReportsMulitipleSheets reports1=new WV_ReportsMulitipleSheets();
        
        PageReference reportpage3=new PageReference('/apex/WV_ElectionConsolidatedReport?id='+Scheme01.Id+'&eid='+enrolold01.Id);
        Test.setCurrentPage(reportpage3); 
        
        WV_ReportsMulitipleSheets reports3=new WV_ReportsMulitipleSheets();
        
        
        PageReference reportpage2=new PageReference('/apex/WV_ElectionConsolidatedReport');
        Test.setCurrentPage(reportpage2); 
        
        WV_ReportsMulitipleSheets reports2=new WV_ReportsMulitipleSheets();
        
        Test.stoptest();         
    } 
}