@istest(SeeAllData=false)

public class WV_Test_WV_ManualShareRead{
    
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
        Ext.cancel();   
        
        List<Scheme__c> schemes=[select id,name from Scheme__c limit 1];
        system.debug('***********schemes'+schemes);
        System.assert(schemes!=null,'Scheme not inserted');
        System.assertEquals(schemes.size(),1,'Scheme not inserted');
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);  
        
        Scheme__c Sch01=new Scheme__c(Id=schemes[0].Id);
        ApexPages.StandardController SchemeDetail= new ApexPages.StandardController(Sch01);          
        
        List<user> userslist=[select id,name,isactive from user where id !=:userinfo.getuserid() AND isactive=true limit 1];
        System.assert(userslist !=null,'No Active users present');
        System.assertEquals(userslist.size(),1,'No Active users present');        
        
        WV_ManualShareRead share=new WV_ManualShareRead();
        share.getUsers();
        share.addUsers();
        share.manualShareRead();        
        
        share.CurrentList.add(userslist[0].id);
        share.manualShareRead();
        share.getUsers();
        
        PageReference schDetail1=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail1);  
        WV_ManualShareRead share01=new WV_ManualShareRead();
        share01.delCont();
        
        List<Scheme__Share> schemeowners=[select id,ParentId,UserOrGroupId from Scheme__Share where parentid=:schemes[0].Id and UserOrGroupId=:userslist[0].id];
        System.assert(schemeowners !=null,'No Users added to scheme owners list.');
        System.assertEquals(schemeowners.size(),1,'No Users added to scheme owners list.');     
        
        PageReference schDetail2=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail2);  

        WV_ManualShareRead share02=new WV_ManualShareRead();
        share02.hiddenValue=schemeowners[0].id;
        share02.delCont();        
    }               

}