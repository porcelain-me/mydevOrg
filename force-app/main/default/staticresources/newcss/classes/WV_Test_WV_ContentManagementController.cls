@istest(SeeAllData=false)

public class WV_Test_WV_ContentManagementController {
    
    public testmethod static void Testmethod01(){        
        
        Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
        insert source;
        
        Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
        insert def;
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR');
        insert currencys;
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus 01',Value__c=0);
        insert abacus;        
                    
        Waiver_Employeetag__c customset0=new Waiver_Employeetag__c(name='@Country',Field_API_Name__c='Country_Home__c');            
        Waiver_Employeetag__c customset1=new Waiver_Employeetag__c(name='@Division',Field_API_Name__c='Division_Org__c');
        Waiver_Employeetag__c customset2=new Waiver_Employeetag__c(name='@EmpId',Field_API_Name__c='Emp_Id__c');
        Waiver_Employeetag__c customset3=new Waiver_Employeetag__c(name='@FirstName',Field_API_Name__c='First_Name__c');
        Waiver_Employeetag__c customset4=new Waiver_Employeetag__c(name='@LastName',Field_API_Name__c='Last_Name__c');
        Waiver_Employeetag__c customset5=new Waiver_Employeetag__c(name='@Region',Field_API_Name__c='CC_Region_Org__c');
        insert customset0;
        insert customset1;
        insert customset2;
        insert customset3;
        insert customset4;
        insert customset5;    
        
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
        system.debug('****schemes'+schemes);
        System.assert(schemes!=null,'Scheme record not inserted');
        System.assertEquals(schemes.size(),1,'Scheme record not inserted');
        
        //Custom data-table..,
        Custom_Data_upload_file__c custom=new Custom_Data_upload_file__c(name='PensionfileTable',Scheme__c=schemes[0].Id,File_Type__c='Table',Columns__c='msid->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom;
        
        Custom_Data_upload_file__c custom01=new Custom_Data_upload_file__c(name='PensionfileText',Scheme__c=schemes[0].Id,File_Type__c='Text',Columns__c='msid->MSID__c,min value->Text1__c,max value->Text2__c');
        insert custom01;
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);   
        
        WV_ContentManagementController content=new WV_ContentManagementController();
        content.getContentTypes();
        
        content.DeleteRecord();
        
        content.recoveryStatus();
        content.Submit();
        
        content.selectedContentType='Intro';
        content.recoveryStatus();            
        content.Submit(); 
        
        content.selectedContentType='Introduction';
        content.recoveryStatus();            
        content.Submit();          
        
        content.selectedContentType='Introduction';
        content.recoveryStatus();     
        content.contentArea ='MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for st';       
        system.assert(content.contentArea.length()>1000,'Introduction content should be greater than 1000 chars for this scenario');
        content.Submit();
        
        content.DeleteRecord();
        
        content.selectedContentType='Introduction';
        content.recoveryStatus();     
        content.contentArea ='test';   
        system.assert(content.contentArea.length()<=1000,'Introduction content should be less than or equal 1000 chars for this scenario');    
        content.Submit();
        
        content.selectedContentType='Introduction';
        content.recoveryStatus();   
        content.contentArea ='testing';       
        content.Submit();
                    
        content.selectedContentType='Description';
        content.recoveryStatus();
        content.Submit();
        
        content.selectedContentType='Description';              
        content.recoveryStatus();
        content.contentArea ='test'; 
        content.Submit();
        
        content.selectedContentType='Terms & Conditions';
        content.recoveryStatus();
        content.contentArea ='test'; 
        content.Submit();     
        
        content.selectedContentType='Links';
        content.recoveryStatus();
        content.contentArea ='test'; 
        content.Submit();  
        
        content.selectedContentType='Links';
        content.recoveryStatus();
        content.Submit();  
        
        content.selectedContentType='Email Template - Election Submit/Update';
        content.recoveryStatus();
        content.contentArea ='test'; 
        content.Submit();  
        
        content.selectedContentType='Email Template - Election Submit/Update';
        content.recoveryStatus();
        content.Submit();  
        
        content.selectedContentType='Email Template - Election Cancellation';
        content.recoveryStatus();
        content.contentArea ='test'; 
        content.Submit();  
        
        content.selectedContentType='Email Template - Election Cancellation';
        content.recoveryStatus();
        content.Submit();  
        content.DeleteRecord();
        
                
        content.selectedContentType='Terms & Conditions'; 
        content.selectedSchemeId= null;
        content.Submit();
        
        content.selectedContentType=null;
        content.selectedSchemeId= null;
        content.Submit();            
    }              

}