@istest(SeeAllData=false)

public class WV_Test_WV_EligibilityAssignmnet{
    
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
        
        WV_EligibilityAssignmnet Eligib=new WV_EligibilityAssignmnet();
        Eligib.getLoadMethods();
        Eligib.selectedLoadMethod=null;
        Eligib.StartNext();
        
        Eligib.selectedLoadMethod='rule';
        Eligib.StartNext();            
        
        Eligib.Backbutton();
        
        Eligib.selectedLoadMethod='rule';
        Eligib.StartNext(); 
        
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c=null;
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK,';
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK';
        Eligib.EligibilityRecord.Job_Region__c='EU,NJ,';
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK';
        Eligib.EligibilityRecord.Job_Region__c='EU,NJ';
        Eligib.EligibilityRecord.Cost_Center__c='324,4324,';
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK';
        Eligib.EligibilityRecord.Job_Region__c='EU,NJ';
        Eligib.EligibilityRecord.Cost_Center__c='324,4324';
        Eligib.EligibilityRecord.Employee_Class__c=',A,B,C,,I,';
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK';
        Eligib.EligibilityRecord.Job_Region__c='EU,NJ';
        Eligib.EligibilityRecord.Cost_Center__c='324,4324';
        Eligib.EligibilityRecord.Employee_Class__c='B,C,,I';
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK';
        Eligib.EligibilityRecord.Job_Region__c='EU,NJ';
        Eligib.EligibilityRecord.Cost_Center__c='324,4324';
        Eligib.EligibilityRecord.Employee_Class__c='A,B,C,I';
        Eligib.EligibilityRecord.Pay_Company__c='Test,';
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK';
        Eligib.EligibilityRecord.Job_Region__c='EU,NJ';
        Eligib.EligibilityRecord.Cost_Center__c='324,4324';
        Eligib.EligibilityRecord.Employee_Class__c='A,B,C,I';
        Eligib.EligibilityRecord.Pay_Company__c='Test';
        Eligib.EligibilityRecord.Home_Country__c='IND,';
        Eligib.submit();
        
        Eligib.EligibilityRecord.Benefit_Program__c='UK';
        Eligib.EligibilityRecord.Job_Region__c='EU,NJ';
        Eligib.EligibilityRecord.Cost_Center__c='324,4324';
        Eligib.EligibilityRecord.Employee_Class__c='A,B,C,I';
        Eligib.EligibilityRecord.Pay_Company__c='Test';
        Eligib.EligibilityRecord.Home_Country__c='IND';
        Eligib.submit();
        
        WV_EligibilityAssignmnet Eligib01=new WV_EligibilityAssignmnet(); 
                   
        Eligib01.DeleteRecord();
        
        String insideContent;
        blob insideContentblob;
        
        Eligib01.selectedLoadMethod='customdata';
        Eligib01.StartNext();
        
        Eligib01.body=null;
        Eligib01.Upload();
        
        insideContent='test';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.name=null;
        Eligib01.Upload();
        
        insideContent='test';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.name='test';
        Eligib01.Upload();
        
        insideContent='test';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;
        Eligib01.name='test.xls';
        Eligib01.Upload();
                    
        insideContent='';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;
        Eligib01.name='test.csv';            
        Eligib01.Upload();
        
        Eligib01.name='test.csv'; 
        insideContent='MSIE';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.Upload();
        
        Eligib01.name='test.csv'; 
        insideContent='MSID';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.Upload();
        
        Eligib01.name='test.csv'; 
        insideContent='MSID\n';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.Upload();
        
        Eligib01.name='test.csv'; 
        insideContent='MSID,,minValue\n';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.Upload();
        
        Eligib01.name='test.csv'; 
        insideContent='MSID,MSID\n';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.Upload();
        
        Eligib01.name='test.csv'; 
        insideContent='MSID\nmytest\n00llk\n3456\n453\n45\n1\n0\n5,4637\n"54324"\n';
        insideContentblob=blob.valueOf(insideContent);
        Eligib01.body=insideContentblob;            
        Eligib01.Upload();            
        
        PageReference eligibilityStatus=new PageReference('/apex/WV_BatchStatusBar?&ClassName=WV_EligibilityFileIploadBatch');
        Test.setCurrentPage(eligibilityStatus); 
        WV_BatchStatusBar SB=new WV_BatchStatusBar();
        SB.getBatchJobs();
        SB.sendErrorEmail();
        
        PageReference schDetail00=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail00);  
        
        WV_EligibilityAssignmnet Eligib02=new WV_EligibilityAssignmnet(); 
        Eligib02.DeleteRecord();
        
        WV_EligibilityAssignmnet Eligib03=new WV_EligibilityAssignmnet(); 
        Eligib03.selectedSchemeId=null;
        Eligib03.StartNext();
        
        WV_EligibilityAssignmnet Eligib04=new WV_EligibilityAssignmnet(); 
        Eligib04.selectedSchemeId=null;
        Eligib04.DeleteRecord();
        
    }            
    

}