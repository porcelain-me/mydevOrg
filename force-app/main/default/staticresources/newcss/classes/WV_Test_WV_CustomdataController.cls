@istest(SeeAllData=false)

public class WV_Test_WV_CustomdataController{
    
    public testmethod static void Testmethod01(){
        
        Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
        insert source;
        system.assert(source.Id!=null,'Source record insert error');
        
        Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
        insert def;
        system.assert(def.Id!=null,'Deferral record insert error');
                    
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR',active__C=true);
        insert currencys;     
        system.assert(currencys.Id!=null,'currency record insert error');       
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus 01',Value__c=0);
        insert abacus;
        system.assert(abacus.Id!=null,'abacus record insert error');      
        
        Waiver_Employeetag__c customset0=new Waiver_Employeetag__c(name='@Country',Field_API_Name__c='Country_Home__c');            
        Waiver_Employeetag__c customset1=new Waiver_Employeetag__c(name='@Division',Field_API_Name__c='Division_Org__c');
        Waiver_Employeetag__c customset2=new Waiver_Employeetag__c(name='@EmpId',Field_API_Name__c='Emp_Id__c');
        Waiver_Employeetag__c customset3=new Waiver_Employeetag__c(name='@FirstName',Field_API_Name__c='First_Name__c');
        Waiver_Employeetag__c customset4=new Waiver_Employeetag__c(name='@LastName',Field_API_Name__c='Last_Name__c');
        Waiver_Employeetag__c customset5=new Waiver_Employeetag__c(name='@Region',Field_API_Name__c='CC_Region_Org__c');
        insert customset0;
        system.assert(customset0.Id!=null,'Employee tags record insert error'); 
        insert customset1;
        system.assert(customset1.Id!=null,'Employee tags record insert error'); 
        insert customset2;
        system.assert(customset2.Id!=null,'Employee tags record insert error'); 
        insert customset3;
        system.assert(customset3.Id!=null,'Employee tags record insert error'); 
        insert customset4;
        system.assert(customset4.Id!=null,'Employee tags record insert error'); 
        insert customset5;
        system.assert(customset5.Id!=null,'Employee tags record insert error'); 
        
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
        system.debug('****schemes'+schemes);
        System.assert(schemes!=null,'Scheme record not inserted');
        System.assertEquals(schemes.size(),1,'Scheme record not inserted');
        
        PageReference schDetail=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail);  
        
        Scheme__c Sch01=new Scheme__c(Id=schemes[0].Id);
        ApexPages.StandardController SchemeDetail= new ApexPages.StandardController(Sch01);            
        
        string insideContent;
        blob insideContentblob;
        
        WV_CustomdataController customdata003=new WV_CustomdataController();    
        customdata003.selectedSchemeId=null;
        customdata003.add();
        
        WV_CustomdataController customdata=new WV_CustomdataController();
        customdata.getLoadMethods();
        
        customdata.add();
        
        customdata.fileUploadRecord.Name='test test';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
         customdata.selectedLoadMethod='Text';
        insideContent='';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.xls';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='MSIE\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='MSIE,min value,maxvalue\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='MSID,min value,maxvalue\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='MSID,min value,min value\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='MSID,,min value\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();            
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='MSID,min value,maxvalue\n00llk,"100,345,234",1000\n00llk,"100,100",1000\ntest,,"test"\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();
        
        customdata.fileUploadRecord.Name='testtest';
        customdata.selectedLoadMethod='Text';
        insideContent='MSID,min value,maxvalue\n00llk,100,1000\n00llk,"100,100",1000\ntest,,"test"\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata.contentBody1.body=insideContentblob;
        customdata.contentName='test.csv';
        customdata.add();
        
        WV_CustomdataController customdata4=new WV_CustomdataController();
        customdata4.getLoadMethods();
        customdata4.fileUploadRecord.Name='testtest1';
        customdata4.selectedLoadMethod='Table';
        insideContent='MSID,min value,maxvalue\n00llk,100,1000\n00llk,"100,100",1000\ntest,,"test"\n';
        insideContentblob=blob.valueOf(insideContent);
        customdata4.contentBody1.body=insideContentblob;
        customdata4.contentName='testing2.csv';
        customdata4.add();
        
        PageReference customBatchStatus=new PageReference('/apex/WV_BatchStatusBar_CustomData');
        Test.setCurrentPage(customBatchStatus);
        
        WV_BatchStatusBar_CustomDataController BCustom=new WV_BatchStatusBar_CustomDataController();
        Bcustom.getBatchJobs();
        BCustom.sendErrorEmail();           
        
        List<Custom_Data_upload_file__c> customfiles00=[select id,name from Custom_Data_upload_file__c where name='testtest'];
        system.debug('******************customfiles00'+customfiles00);
        system.assert(customfiles00!=null,'Custom data file with name \'testtest\' is not inserted.'); 
        system.assertEquals(customfiles00.size(),1,'Custom data file with name \'testtest\' is not inserted.'); 
        
        Waiver_Template__c template=new Waiver_Template__c(Name='Test Template test');
        insert template;
        system.assert(template.Id!=null,'Template insert error'); 
        
        Input_Controls_Mapping__c controlCloned1=new Input_Controls_Mapping__c(Waiver_Template__c=template.Id,name='List Control test',Input_Control_Type__c='List Capture',Control_Visibility__c='Primary',Required__c=true,Show_Currency__c=true,Custom_Data_Values__c='Amount\r\nPercentage',Custom_Min__c=customfiles00[0].Id+',Text1__c');
        insert controlCloned1;
        system.assert(controlCloned1.Id!=null,'Control insert error'); 
        
        PageReference schDetail001=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail001); 
        WV_CustomdataController customdata002=new WV_CustomdataController();
        customdata002.getLoadMethods();                
        customdata002.selectedFile=customfiles00[0].Id;
        customdata002.deleteFile();
        
        delete controlCloned1;
        
        List<Custom_Data_upload_file__c> customfiles001=[select id,name from Custom_Data_upload_file__c where name='testtest'];
        system.debug('******************customfiles001'+customfiles001);
        system.assert(customfiles001!=null,'Custom data file with name \'testtest\' is not inserted.'); 
        system.assertEquals(customfiles001.size(),1,'Custom data file with name \'testtest\' is not inserted.'); 
        
        WV_CustomdataController customdata2=new WV_CustomdataController();
        customdata2.getLoadMethods();
        customdata2.deleteFile();   
        
        WV_CustomdataController customdata3=new WV_CustomdataController();
        customdata3.getLoadMethods();             
        customdata3.selectedFile=customfiles001[0].Id;
        customdata3.deleteFile();    
    }    
}