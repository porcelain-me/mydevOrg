@istest(SeeAllData=false)

public class WV_Test_WV_ReadAndPopulateBatch {
    
    public testmethod static void Testmethod01(){
        Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
        insert source;
        
        Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
        insert def;
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR');
        insert currencys;
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus 01',Value__c=0);
        insert abacus;
        
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='test', Last_Name__c='test',Email__c='test@gmail.com',Cost_Center__c='4324',Country_Home__c='IND',Job_Region_Code__c='EU',Officer__c='N',Primary_Pay_Company_Job__c='96',Empl_Class_Job__c='A',Benefit_Program__c='UK',Status__c='Active');
        insert employee;
        
        PageReference pg=new PageReference('/apex/WV_Schemes?retURL=test');
        Test.setCurrentPage(pg);
        Scheme__c Sch=new Scheme__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(Sch);        
        
        WV_schemeExtension Ext=new WV_schemeExtension(sc);        
        Ext.schemeObj.name='Test';
        Ext.schemeObj.abacus__c='No';
        Ext.schemeObj.Term__c ='Fixed';
        Ext.schemeObj.source__c =source.Id;
        Ext.schemeObj.deferral__c =def.Id;
        Ext.schemeObj.description__c='test';
        Ext.isAbacusEnabled=false;
        Ext.schemeObj.scheme_Currency__c=currencys.Id;
        
        Ext.displayAbacusCheck();
        Ext.save();        
        Ext.cancel();   
        
        List<Scheme__c> schemes=[select id,name from Scheme__c limit 1];
        system.debug('***********schemes'+schemes);
        system.assert(schemes!=null,'No Schemes created to process');
        system.assert(schemes.size()>0,'No schemes createed to process');
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);  
        
        Scheme__c Sch01=new Scheme__c(Id=schemes[0].Id);
        ApexPages.StandardController SchemeDetail= new ApexPages.StandardController(Sch01);            
        
        
        Custom_Data_upload_file__c custom=new Custom_Data_upload_file__c(Columns__c='msid->MSID__c,Optioned Choosed New->Text1__c',File_Type__c='Text',Scheme__c=schemes[0].Id);
        insert custom;
        string insideContent;
        blob insideContentblob;
        
        insideContent='msid,Optioned Choosed New,\n00llk,1000\n';
        insideContentblob=blob.valueOf(insideContent);
        Map<integer,string> maps=new MAp<integer,string>{0=>'MSID__C',1=>'Text1__c'};
        WV_ReadAndPopulateBatch testbatch=new WV_ReadAndPopulateBatch(insideContent,String.ValueOf(custom.Id),maps);
        String schs = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', schs, testbatch);
    }
}