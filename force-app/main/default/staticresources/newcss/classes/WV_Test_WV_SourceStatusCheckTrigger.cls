@istest(SeeAllData=false)

public class WV_Test_WV_SourceStatusCheckTrigger {
    
    public testmethod static void Testmethod01(){
            Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
            insert source;
            system.assert(source.Id!=null,'Source record insert error');
            update source;
            
            Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
            insert def;
            system.assert(def.Id!=null,'Deferral record insert error');
            
            Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR',active__C=true);
            insert currencys;  
            system.assert(currencys.Id !=null,'currency record insert error');                 
            
            Abacus__c abacus=new Abacus__c(Name='Test abacus 01',Value__c=0);
            insert abacus; 
            system.assert(abacus.Id !=null,'abacus record insert error');  
            
            Waiver_Template__c template=new Waiver_Template__c(Name='Test Template test');
            insert template;    
            system.assert(template.Id !=null,'template record insert error');    
            
            Input_Controls_Mapping__c control=new Input_Controls_Mapping__c(name='test',Input_Control_Type__c='List Capture',Waiver_Template__c=template.Id,Required__c=true,Control_Visibility__c='Primary');
            insert control;
            system.assert(control.Id !=null,'control record insert error'); 
            
            Scheme__c Scheme01=new Scheme__c(Name='Test scheme test',abacus__c='Yes',Abacus_n__c=abacus.Id,Term__c ='Fixed',source__c =source.Id,deferral__c =def.Id,description__c='Personal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place. Salesforce.comPersonal pension scheme (PPS), sometimes called a personal pension plan (PPP), iSalesforce.com MetLife Property & Causali ds at one place.',scheme_Currency__c=currencys.Id,Waiver_Template__c=template.Id,Active__c=true);
            insert Scheme01;
            system.assert(Scheme01.Id !=null,'Scheme record insert error'); 
            
            try{
                source.active__C=false;
                update source;
            }
            Catch(Exception e){
            
            }
            
            try{
                delete source;
            }
            Catch(Exception e){
            
            }
            
            Scheme01.Active__c=false;
            update Scheme01;
            
            try{
                delete source;
            }
            Catch(Exception e){
            
            }   
            
            try{
                source.active__C=false;
                update source;
                delete source;
            }
            Catch(Exception e){
            
            }   
        
    }            
    

}