@istest(SeeAllData=false)

public class WV_Test_WV_SchemeExtension{
    
    public testmethod static void Testmethod01(){
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='test', Last_Name__c='test',Email__c='test@gmail.com',Cost_Center__c='4324',Country_Home__c='IND',Job_Region_Code__c='EU',Officer__c='N',Primary_Pay_Company_Job__c='96',Empl_Class_Job__c='A',Benefit_Program__c='UK',Status__c='Active');
        insert employee;
        
        Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
        insert source;
        
        Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
        insert def;
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR');
        insert currencys;
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus 01',Value__c=0);
        insert abacus;
        
        PageReference pg=new PageReference('/apex/WV_Schemes?retURL=test');
        Test.setCurrentPage(pg);
        Scheme__c Sch=new Scheme__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(Sch);
        
        WV_schemeExtension Ext=new WV_schemeExtension(sc);
        Ext.getActiveSources();
        Ext.getActiveDeferrals();
        Ext.getActiveCurrencies();
        Ext.getAbacusValues();
        
        Ext.schemeObj.name=null;
        Ext.schemeObj.abacus__c=null;
        Ext.schemeObj.Term__c =null;
        Ext.schemeObj.source__c =null;
        Ext.schemeObj.deferral__c =null;
        Ext.schemeObj.description__c=null;
        
        Ext.isAbacusEnabled=true;
        Ext.schemeObj.scheme_Currency__c=null;
        Ext.schemeObj.Abacus_n__c=null;
        Ext.save();
        
        Ext.displayAbacusCheck();
        
        Ext.schemeObj.abacus__c='yes';
        Ext.schemeObj.name='Test 7645.';
        Ext.schemeObj.description__c='Salesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for stor Salesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storSalesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for stor Salesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for stor';
        system.assert(Ext.schemeObj.description__c.length()>300,'Description should be greater than 300 chars for this scenario');
        
        Ext.displayAbacusCheck();
                
        Ext.isAbacusEnabled=true;
        Ext.schemeObj.scheme_Currency__c=currencys.Id;
        Ext.schemeObj.Abacus_n__c=null;
        Ext.save();
        
        Ext.isAbacusEnabled=true;
        Ext.schemeObj.scheme_Currency__c=null;
        Ext.schemeObj.Abacus_n__c=abacus.Id;
        Ext.save();
        
        Ext.isAbacusEnabled=true;
        Ext.schemeObj.scheme_Currency__c=currencys.Id;
        Ext.schemeObj.Abacus_n__c=abacus.Id;
        Ext.save();
        
        Ext.schemeObj.name='Test';
        Ext.schemeObj.abacus__c='No';
        Ext.schemeObj.Term__c ='Fixed';
        Ext.schemeObj.source__c =source.Id;
        Ext.schemeObj.deferral__c =def.Id;
        Ext.schemeObj.description__c='test';
        system.assert(Ext.schemeObj.description__c.length()<=300,'Description should be less than or equal 300 chars for this scenario');
        Ext.isAbacusEnabled=false;
        Ext.schemeObj.scheme_Currency__c=currencys.Id;
        
        Ext.displayAbacusCheck();
        Ext.save();        
        Ext.cancel();
        
        List<scheme__c> schemeList=[select id,name from scheme__C];
        system.assert(schemeList!=null,'Scheme not created yet');
        system.assert(schemeList.size()>0,'Scheme not created yet');
        
        //Duplicate
        WV_schemeExtension Ext1=new WV_schemeExtension(sc);
        Ext1.sendErrorEmail();
        Ext1.schemeObj.name='Test';
        Ext1.schemeObj.abacus__c='No';
        Ext1.schemeObj.Term__c ='Fixed';
        Ext1.schemeObj.source__c =source.Id;
        Ext1.schemeObj.deferral__c =def.Id;
        Ext1.schemeObj.description__c='test';
        Ext1.isAbacusEnabled=false;
        Ext1.schemeObj.scheme_Currency__c=currencys.Id;
        Ext1.save();
        
        WV_schemeExtension Ext2=new WV_schemeExtension(sc);
        Ext2.schemeObj.name='Salesforce';
        Ext2.schemeObj.abacus__c='No';
        Ext2.schemeObj.Term__c ='Open';
        Ext2.schemeObj.source__c =source.Id;
        Ext2.schemeObj.deferral__c =def.Id;
        Ext2.schemeObj.description__c='test';
        Ext2.isAbacusEnabled=false;
        Ext2.schemeObj.scheme_Currency__c=currencys.Id;
        Ext2.save();       
        
        List<Scheme__c> schemes=[select id,name,active__c,Term__c from Scheme__c where Term__c='Fixed' limit 1];
        system.assert(schemes!=null,'Fixed Scheme not created yet');
        system.assert(schemes.size()>0,'Fixed Scheme not created yet');
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);  
        
        Scheme__c Sch01=new Scheme__c(Id=schemes[0].Id);
        ApexPages.StandardController SchemeDetail= new ApexPages.StandardController(Sch01);                 
        
        WV_SchemeDetailController Detail=new WV_SchemeDetailController(SchemeDetail);
        
        PageReference schDetail01=new PageReference('/apex/WV_SchemeDetails?tab=enrolTab&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail01);
        WV_SchemeDetailController Detail01=new WV_SchemeDetailController(SchemeDetail);
        
        PageReference schDetail02=new PageReference('/apex/WV_SchemeDetails?tab=eligiblilityTab&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail02);
        WV_SchemeDetailController Detail02=new WV_SchemeDetailController(SchemeDetail);
        
        PageReference schDetail03=new PageReference('/apex/WV_SchemeDetails?tab=contentTab&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail03);
        WV_SchemeDetailController Detail03=new WV_SchemeDetailController(SchemeDetail);
        
        PageReference schDetail04=new PageReference('/apex/WV_SchemeDetails?tab=customdataTab&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail04);
        WV_SchemeDetailController Detail04=new WV_SchemeDetailController(SchemeDetail);
        
        PageReference schDetail05=new PageReference('/apex/WV_SchemeDetails?tab=templateTab&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail05);
        WV_SchemeDetailController Detail05=new WV_SchemeDetailController(SchemeDetail);
        
        PageReference schDetail07=new PageReference('/apex/WV_SchemeDetails?tab=shareTab&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail07);
        WV_SchemeDetailController Detail07=new WV_SchemeDetailController(SchemeDetail);
        
        PageReference schDetail08=new PageReference('/apex/WV_SchemeDetails?tab=test&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail08);
        WV_SchemeDetailController Detail08=new WV_SchemeDetailController(SchemeDetail);
        Detail08.enableSave();
        Detail08.schemeRecord.description__c=null;
        Detail08.save();
        
        Detail08.schemeRecord.description__c='Salesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for stor Salesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storSalesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for stor Salesforce.com MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for stor';
        system.assert(Detail08.schemeRecord.description__c.length()>300,'Description should be greater than 300 chars for this scenario');
        Detail08.save();
        
        Detail08.schemeRecord.description__c='test';
        system.assert(Detail08.schemeRecord.description__c.length()<=300,'Description should be less than or equal 300 chars for this scenario');
        Detail08.save();
        
        source.active__c=false;
        update source;
        
        def.active__c=false;
        update def;
        
        currencys.active__c=false;
        update currencys;
        
        PageReference schDetail12=new PageReference('/apex/WV_SchemeDetails?tab=test&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail12);
        WV_SchemeDetailController Detail12=new WV_SchemeDetailController(SchemeDetail);
        Detail12.schemeRecord.active__c=true;            
        Detail12.save();
        
        Detail12.sendErrorEmail();            
        
        schemes[0].active__c = true;
        update schemes[0];
        
        PageReference schDetail09=new PageReference('/apex/WV_SchemeDetails?id='+schemes[0].Id);
        Test.setCurrentPage(schDetail09);
        WV_SchemeDetailController Detail09=new WV_SchemeDetailController(SchemeDetail);
        Detail09.deleteScheme();
        
        system.assert(schemes[0] != null,'Scheme record shouldnt get deleted');
        system.assert(schemes[0].Id != null,'Scheme record shouldnt get deleted');
        
        schemes[0].term__c= 'Open';
        update schemes[0];
        
        Election__c Election01=new Election__c(Employee__c=employee.Id,Scheme__c=Schemes[0].Id,isCancelled__c=false);
        insert Election01;
        
        schemes[0].active__c = false;
        update schemes[0];
        
        PageReference schDetail10=new PageReference('/apex/WV_SchemeDetails?id='+schemes[0].Id);
        Test.setCurrentPage(schDetail10);
        WV_SchemeDetailController Detail10=new WV_SchemeDetailController(SchemeDetail);
        Detail10.deleteScheme();
        
        system.assert(schemes[0] != null,'Scheme record shouldnt get deleted');
        system.assert(schemes[0].Id != null,'Scheme record shouldnt get deleted');
        
        delete Election01;
        
        PageReference schDetail11=new PageReference('/apex/WV_SchemeDetails?id='+schemes[0].Id);
        Test.setCurrentPage(schDetail11);
        WV_SchemeDetailController Detail11=new WV_SchemeDetailController(SchemeDetail);
        Detail11.deleteScheme();          
        
    }            
    

}