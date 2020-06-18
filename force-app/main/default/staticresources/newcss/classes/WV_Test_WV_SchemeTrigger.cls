@istest(SeeAllData=false)

public class WV_Test_WV_SchemeTrigger{
    
    public testmethod static void Testmethod01(){
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='test', Last_Name__c='test',Email__c='test@gmail.com',Cost_Center__c='4324',Country_Home__c='IND',Job_Region_Code__c='EU',Officer__c='N',Primary_Pay_Company_Job__c='96',Empl_Class_Job__c='A',Benefit_Program__c='UK',Status__c='Active');
        insert employee;
        system.assert(employee.Id!=null,'employee record insert error');

        Wav_Source__c source1=new Wav_Source__c(Name='Test Source testing',active__C=true,Source_Order__c=0);
        insert source1;
        system.assert(source1.Id!=null,'Source record insert error');
        
        Wav_Source__c source2=new Wav_Source__c(Name='Test Source testinging',active__C=true,Source_Order__c=1);
        insert source2;
        system.assert(source2.Id!=null,'Source record insert error');
        
        Deferral__c def=new Deferral__c(Name='Test Deferral test',active__C=true,order__c=1);
        insert def;
        system.assert(def.Id!=null,'Deferral record insert error');
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency test',Value__c='INR');
        insert currencys;
        system.assert(currencys.Id !=null,'currency record insert error');
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus test',Value__c=0);
        insert abacus;
        system.assert(abacus.Id !=null,'abacus record insert error');  
        
        Waiver_Template__c template=new Waiver_Template__c(Name='Test Template test');
        insert template;
        system.assert(template.Id !=null,'template record insert error');  
        
        Input_Controls_Mapping__c control1=WV_TestData.WV_insertControls(template.Id,'List Control test','List Capture','Primary',true);

        Scheme__c Scheme01=new Scheme__c(Name='Test scheme test',abacus__c='No',Term__c ='Fixed',source__c =source1.Id,deferral__c =def.Id,description__c='Personal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place. Salesforce.comPersonal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place.',scheme_Currency__c=currencys.Id,Waiver_Template__c=template.Id,Active__c=true);
        insert Scheme01;
        system.assert(Scheme01.Id !=null,'Scheme record insert error'); 
        
        Enrollment_Period__c enrolold01=new Enrollment_Period__c(name='test',Start_Date__c=system.now().addyears(-1),End_Date__c=system.now().addyears(-1).addmonths(2),Override_Scheme__c=Scheme01.Id);
        insert enrolold01;  
        system.assert(enrolold01.Id !=null,'Enrolment period record insert error');       
        
        //Eligibility-Rule based..,
        Eligibility__c eligibiltyrule01=new Eligibility__c(name='Database rules',Database_Driven__c=true,Scheme__c=Scheme01.Id,Cost_Center__c='4324',Home_Country__c='IND',Job_Region__c='EU',Officer__c='N',Pay_Company__c='96',Employee_Class__c='A',Benefit_Program__c='UK');
        insert eligibiltyrule01;
        system.assert(eligibiltyrule01.Id !=null,'Eligibility record insert error');
                        
        Custom_Data_upload_file__c custom01=new Custom_Data_upload_file__c(name='investmentfile',Scheme__c=Scheme01.Id,File_Type__c='Text',Columns__c='MSID->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom01;
        system.assert(custom01.Id !=null,'Custom data file record insert error');
        
        Wav_Custom_data__c customdata02;
        
        customdata02=new Wav_Custom_data__c(File_Upload__c=custom01.Id,MSID__c=employee.emp_Id__c,Text1__c='100',Text2__c='1,000');
        insert customdata02;
        system.assert(customdata02.Id !=null,'Custom data record insert error');
        
        Custom_Data_upload_file__c custom02=new Custom_Data_upload_file__c(name='Pensionfile',Scheme__c=Scheme01.Id,File_Type__c='Table',Columns__c='msid->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom02;
        system.assert(custom02.Id !=null,'Custom data file record insert error');
        
        Wav_Custom_data__c customdata05=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='100',Text2__c='1,000');
        insert customdata05;
        system.assert(customdata05.Id !=null,'Custom data record insert error');
        
        Wav_Custom_data__c customdata06=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='test, me',Text2__c='1000');
        insert customdata06;
        system.assert(customdata06.Id !=null,'Custom data record insert error');
        
        Wav_Custom_data__c customdata07=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='',Text2__c='');
        insert customdata07;
        system.assert(customdata07.Id !=null,'Custom data record insert error');
        
        Wav_Custom_data__c customdata08=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c=employee.emp_Id__c,Text1__c='test',Text2__c='');
        insert customdata08;
        system.assert(customdata08.Id !=null,'Custom data record insert error');

        Wav_Content__c content01=new Wav_Content__c(Content__c='@Country1 @Division1 @EmpId1 @FirstName1 @LastName1 @Region1 Test @Pensionfile.table @investmentfile.table Test Source 01 @investmentfile.msid @investmentfile.min_value @investmentfile.max_value',Content_Type__c='Introduction',Scheme__c=Scheme01.Id);
        insert content01;
        system.assert(content01.Id !=null,'Introduction content record insert error');
        
        Wav_Content__c content02=new Wav_Content__c(Content__c='@Country1 @Division1 @EmpId1 @FirstName1 @LastName1 @Region1 Test @Pensionfile.table @investmentfile.table Test Source 01 @investmentfile.msid @investmentfile.min_value @investmentfile.max_value',Content_Type__c='Description',Scheme__c=Scheme01.Id);
        insert content02;
        system.assert(content02.Id !=null,'Description content record insert error');
        
        Wav_Content__c content03=new Wav_Content__c(Content__c='@Country1 @Division1 @EmpId1 @FirstName1 @LastName1 @Region1 Test @Pensionfile.table @investmentfile.table Test Source 01 @investmentfile.msid @investmentfile.min_value @investmentfile.max_value',Content_Type__c='Terms & Conditions',Scheme__c=Scheme01.Id);
        insert content03;
        system.assert(content03.Id !=null,'Terms conditions content record insert error');
        
        Input_Controls_Mapping__c controlCloned1=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='List Control test',Input_Control_Type__c='List Capture',Control_Visibility__c='Primary',Required__c=true,Scheme__c=Scheme01.Id,Show_Currency__c=true,Custom_Data_Values__c='Amount\r\nPercentage');
        insert controlCloned1;
        system.assert(controlCloned1.Id !=null,'Control record insert error');
        
        Election__c Election01=new Election__c(Employee__c=employee.Id,Related_Enrolment__c=enrolold01.Id,Scheme__c=Scheme01.Id);
        insert Election01;
        system.assert(Election01.Id !=null,'Election record insert error');
        
        Response__c res01=new Response__c (Election__c=Election01.Id,Value_New__c='Amount',Input_Controls_Mapping__c=controlCloned1.Id);
        insert res01; 
        system.assert(res01.Id !=null,'Response record insert error');
        
        Try{
            delete Scheme01;
        }
        Catch(Exception e){
        
        }
        
        Try{
            Scheme01.Active__C=false;
            update Scheme01;
            delete  Scheme01;
        }
        Catch(Exception e){
        
        }
        
        Try{
            Scheme01.Active__C=true;
            update Scheme01;
            Election01.isCancelled__c=true;
            update Election01;
            Scheme01.Active__C=false;
            update Scheme01;
            delete  Scheme01;
        }
        Catch(Exception e){
        
        }
            
                    
    }            
    

}