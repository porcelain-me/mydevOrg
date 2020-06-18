@istest(SeeAllData=false)

public class WV_Test_WV_PreviewContentController{

    public testmethod static void Testmethod01(){     
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='t6est', Last_Name__c='terr',Email__c='test@gmail.com',Empl_Class_Job__c='A',Status__c='Active');
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
        
        Waiver_Employeetag__c customset0=new Waiver_Employeetag__c(name='@Country1',Field_API_Name__c='Country_Home__c');            
        Waiver_Employeetag__c customset1=new Waiver_Employeetag__c(name='@Division1',Field_API_Name__c='Division_Org__c');
        Waiver_Employeetag__c customset2=new Waiver_Employeetag__c(name='@EmpId1',Field_API_Name__c='Emp_Id__c');
        Waiver_Employeetag__c customset3=new Waiver_Employeetag__c(name='@FirstName1',Field_API_Name__c='First_Name__c');
        Waiver_Employeetag__c customset4=new Waiver_Employeetag__c(name='@LastName1',Field_API_Name__c='Last_Name__c');
        Waiver_Employeetag__c customset5=new Waiver_Employeetag__c(name='@Region1',Field_API_Name__c='CC_Region_Org__c');
        insert customset0;
        insert customset1;
        insert customset2;
        insert customset3;
        insert customset4;
        insert customset5;
        
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
        Scheme__c Scheme01=new Scheme__c(Name='Test scheme test',abacus__c='No',Term__c ='Fixed',source__c =source1.Id,deferral__c =def.Id,description__c='Personal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place. Salesforce.comPersonal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place.',scheme_Currency__c=currencys.Id,Waiver_Template__c=template.Id,Active__c=true);
        insert Scheme01;
        
        //Custom data-text..,
        Custom_Data_upload_file__c custom01=new Custom_Data_upload_file__c(name='investmentfile',Scheme__c=Scheme01.Id,File_Type__c='Text',Columns__c='MSID->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom01;
        
        Wav_Custom_data__c customdata01=new Wav_Custom_data__c(File_Upload__c=custom01.Id,MSID__c='test',Text1__c='100',Text2__c='1,000');
        insert customdata01;
        
        //Custom data-table..,
        Custom_Data_upload_file__c custom02=new Custom_Data_upload_file__c(name='Pensionfile',Scheme__c=Scheme01.Id,File_Type__c='Table',Columns__c='msid->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom02;
        
        Wav_Custom_data__c customdata03=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c='test',Text1__c='1,00',Text2__c='');
        insert customdata03;
        Wav_Custom_data__c customdata04=new Wav_Custom_data__c(File_Upload__c=custom02.Id,MSID__c='test',Text1__c='240',Text2__c='test');
        insert customdata04;
        
        //Contents.
        Wav_Content__c content01=new Wav_Content__c(Content__c='Test',Content_Type__c='Introduction',Scheme__c=Scheme01.Id);
        insert content01;
        
        Wav_Content__c content02=new Wav_Content__c(Content__c='@Country1 @Division1 @EmpId1 @FirstName1 @LastName1 @Region1 Test @Pensionfile.table @investmentfile.table @investmentfile.msid @investmentfile.min_value @investmentfile.max_value',Content_Type__c='Description',Scheme__c=Scheme01.Id);
        insert content02;
        
        Wav_Content__c content03=new Wav_Content__c(Content__c='Test',Content_Type__c='Terms & Conditions',Scheme__c=Scheme01.Id);
        insert content03;
        
        Wav_Content__c content04=new Wav_Content__c(Content__c='<p><a href="www.google.com">link1</a></p>',Content_Type__c='Links',Scheme__c=Scheme01.Id);
        insert content04;
        
        Wav_Content__c content05=new Wav_Content__c(Content__c='Hi @FirstName @LastName @Url @DateTime @ElectionName',Content_Type__c='Email Template - Election Submit/Update',Scheme__c=Scheme01.Id);
        insert content05;
        
        Wav_Content__c content06=new Wav_Content__c(Content__c='Hi @FirstName @LastName @Url @DateTime @ElectionName',Content_Type__c='Email Template - Election Cancellation',Scheme__c=Scheme01.Id);
        insert content06;
        
        PageReference moreinfopage=new PageReference('/apex/WV_MoreInfo?schemeId='+Scheme01.Id);
        Test.setCurrentPage(moreinfopage);         
        WV_PreviewContentController preview=new WV_PreviewContentController();    
        preview.sendErrorEmail();  
        preview.getThisYear();      

    }
}