@istest(SeeAllData=false)

public class WV_Test_WV_ShowSchemeLastUpdated {
    
    public testmethod static void Testmethod01(){
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
        
        List<Scheme__c> schemes=[select id,name from Scheme__c limit 1];
        system.assert(schemes!=null,'Scheme is not created yet');
        system.assert(schemes.size()>0,'Scheme is not created yet');
        
        WV_ShowSchemeLastUpdatedDateController schemePage=new WV_ShowSchemeLastUpdatedDateController();
        schemePage.getLastupdatedBy();  
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);   
        
        WV_ShowSchemeLastUpdatedDateController schemePage1=new WV_ShowSchemeLastUpdatedDateController();
        schemePage1.getLastupdatedBy();        
    }            
    

}