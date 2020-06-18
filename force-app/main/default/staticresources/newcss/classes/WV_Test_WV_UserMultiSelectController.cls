@istest(SeeAllData=false)

public class WV_Test_WV_UserMultiSelectController{
    
    public testmethod static void Testmethod01(){
        
        Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
        insert source;
        
        Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
        insert def;
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR',active__c=true);
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
        system.assert(schemes!=null,'Scheme is not created yet');
        system.assert(schemes.size()>0,'Scheme is not created yet');
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);  
        
        Scheme__c Sch01=new Scheme__c(Id=schemes[0].Id);
        ApexPages.StandardController SchemeDetail= new ApexPages.StandardController(Sch01); 
        List<PermissionSetAssignment> assignments=[SELECT Assignee.Name, AssigneeId,PermissionSet.id,PermissionSet.name FROM PermissionSetAssignment where (PermissionSet.name='My_Elections_Scheme_Admin' OR PermissionSet.name='My_Elections_HRSC_admin') limit 1];

        WV_UserMultiSelectComponentController userMultiSelect=new WV_UserMultiSelectComponentController();  
        userMultiSelect.InitialRightList=new List<Id>();          
        if(assignments != null && assignments.size()>0){
            userMultiSelect.InitialRightList=new List<Id>();
            userMultiSelect.InitialRightList.add(assignments[0].AssigneeId);
        }
        userMultiSelect.getLeftOptionList();
        userMultiSelect.getRightOptionList();
        userMultiSelect.ClickLeft();
        userMultiSelect.ClickRight();           
    }            
    

}