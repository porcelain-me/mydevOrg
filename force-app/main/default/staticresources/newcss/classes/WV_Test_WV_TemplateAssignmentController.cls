@istest(SeeAllData=false)

public class WV_Test_WV_TemplateAssignmentController{
    
    public testmethod static void Testmethod01(){
        
        Wav_Source__c source=new Wav_Source__c(Name='Test Source 01',active__C=true,Source_Order__c=0);
        insert source;
        
        Deferral__c def=new Deferral__c(Name='Test Deferral 01',active__C=true,order__c=1);
        insert def;
        
        Wav_Currency__c currencys=new Wav_Currency__c(Name='Test Currency 01',Value__c='INR',active__c=true);
        insert currencys;
        
        Abacus__c abacus=new Abacus__c(Name='Test abacus 01',Value__c=0);
        insert abacus;
        
        Waiver_Template__c template=new Waiver_Template__c(Name='Test Template 01');
        insert template;
        
        Waiver_Template__c template1=new Waiver_Template__c(Name='Test Template 02');
        insert template1;
        Input_Controls_Mapping__c control8=WV_TestData.WV_insertControls(template1.Id,'List Control 01','List Capture','Primary',true);
        Input_Controls_Mapping__c control9=WV_TestData.WV_insertControls(template1.Id,'Value Control 01','Value Capture','Secondary',false);
       
       
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
        
        Custom_Data_upload_file__c customdata=new Custom_Data_upload_file__c(Scheme__c=schemes[0].Id,File_Type__c='Text',Columns__c='msid->MSID__c,min value->Text1__c,max value->Text2__c');
        insert customdata;
        
        WV_TemplateAssignmentController temp=new WV_TemplateAssignmentController();
        temp.getTemplates();
        
        temp.queryinputControls();
        temp.submit();
        
        temp.selectedTemplate=template.Id;
        temp.queryinputControls();
        temp.submit();
        
        Input_Controls_Mapping__c control1=WV_TestData.WV_insertControls(template.Id,'List Control 01','List Capture','Primary',true);
        Input_Controls_Mapping__c control2=WV_TestData.WV_insertControls(template.Id,'List Control 02','List Capture','Secondary',true);
        Input_Controls_Mapping__c control3=WV_TestData.WV_insertControls(template.Id,'Value Control 01','Value Capture','Secondary',false);
        Input_Controls_Mapping__c control4=WV_TestData.WV_insertControls(template.Id,'Value Control 02','Value Capture',null,true);
        Input_Controls_Mapping__c control5=WV_TestData.WV_insertControls(template.Id,'Multilist Control 01','Multi Value Option Capture',null,true);
        Input_Controls_Mapping__c control6=WV_TestData.WV_insertControls(template.Id,'Multilist Control 02','Multi Value Option Capture','Secondary',true);
        Input_Controls_Mapping__c control7=WV_TestData.WV_insertControls(template.Id,'Multilist Control 03','Multi Value Option Capture','Secondary',true);
        
        WV_TemplateAssignmentController temp1=new WV_TemplateAssignmentController();
        temp1.getTemplates();
        temp1.selectedTemplate=template.Id;
        temp1.queryinputControls();
        temp1.submit();
        
        WV_TemplateAssignmentController temp2=new WV_TemplateAssignmentController();
        temp2.getTemplates();
        temp2.selectedTemplate=template.Id;
        temp2.queryinputControls();
        
        Integer i=0;
        Integer j=0;
        Integer k=0;
        
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp2.controlList){                             
            if(t.inputControl.Input_control_type__c=='Value Capture' && i==0){
                t.inputControl.Value_Type__c= 'Number';
                t.fileName_min=customdata.Id;
                t.fileName_max=customdata.Id;
                t.inputControl.Controlling_Field__c=control1.Id;
                i++;
            }   
            else if(t.inputControl.Input_control_type__c=='Value Capture' && i==1){
                t.inputControl.Value_Type__c= 'Number';
                t.inputControl.Controlling_Field__c=control1.Id;
                t.inputControl.Default_Minimum_Value__c =0;
                t.inputControl.Default_Maximum_Value__c=100;
                t.fileName_min=customdata.Id;
                t.fileName_max=customdata.Id;
                t.columnName_min='min value';
                t.columnName_max='max value';
                t.inputControl.Controlling_Field__c=control2.Id;
                i++;
            }   
            if(t.inputControl.Input_control_type__c=='List Capture' && j==0){
                t.inputControl.Custom_Data_Values__c='Amount\r\nPercentage\r\nAmount (in Rs).';
                j++;
            } 
            else if(t.inputControl.Input_control_type__c=='List Capture' && j==1){
                t.inputControl.Custom_Data_Values__c='Amount\r\nPercentage';
                J++;
            }   
            if(t.inputControl.Input_control_type__c=='Multi Value Option Capture' && k==0){
                t.inputControl.Custom_Data_Values__c='Investment01\r\nInvestment01';
                t.inputControl.Description__c=null;
                K++;
            }  
            else if(t.inputControl.Input_control_type__c=='Multi Value Option Capture' && k==1){
                t.inputControl.Custom_Data_Values__c='Investment01\r\nInvestment02';
                t.inputControl.Description__c='MetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project is an implementation of Salesforce.com for storing all the leads coming from various sources like P&C Website, Call Center and Paper Leads at one place. Salesforce.comMetLife Property & Causality Integrated Sales Desktop project i';
                K++;
            }  
            else if(t.inputControl.Input_control_type__c=='Multi Value Option Capture' && k==2){
                t.inputControl.Custom_Data_Values__c='Investment01\r\nInvestment02';
                t.inputControl.Description__c='test';      
                K++;              
            }   
            t.getColoumnList_min();
            t.getDynamicList();
            t.getColoumnList_max();                          
        }
        
        for(WV_TemplateAssignmentController.inputControlsWrapper t5:temp2.controlList){  
            t5.getColoumnList_min();
            t5.getDynamicList();
            t5.getColoumnList_max();                          
        }
        
        i=0;
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp2.controlList){                             
            if(t.inputControl.Input_control_type__c=='Value Capture' && t.inputControl.Controlling_Field__c != null && i==0){
                t.selectedParentValue='Amount';
                t.selectedChildValue='Text';
                i++;
                t.addme();
                
                t.selectedParentValue='Amount (in Rs).';
                t.selectedChildValue='Number';
                t.addme();
            } 
            else if(t.inputControl.Input_control_type__c=='Value Capture' && t.inputControl.Controlling_Field__c != null && i==1){
                t.selectedParentValue='Amount01';
                t.selectedChildValue='Percentage';
                i++;
                t.addme();
            }   
            
        }
        
        i=0;
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp2.controlList){                             
            if(t.inputControl.Input_control_type__c=='Value Capture' && t.inputControl.Controlling_Field__c != null && i==0){
                t.RemovalValue='Amount';
                t.removeit();
                i++;
            } 
            else if(t.inputControl.Input_control_type__c=='Value Capture' && t.inputControl.Controlling_Field__c != null && i==1){
                t.RemovalValue='Amount01';
                t.removeit();
                i++;
            }                 
        }
        
        temp2.submit();
        
        Test.StartTest();
        
        WV_TemplateAssignmentController temp3=new WV_TemplateAssignmentController();
        temp3.getTemplates();
        temp3.selectedTemplate=template.Id;
        temp3.queryinputControls();
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp3.controlList){                
            if(t.inputControl.Input_control_type__c=='Value Capture'){
                t.inputControl.Value_Type__c= 'Number';
                t.inputControl.Default_Minimum_Value__c =10;
                t.inputControl.Default_Maximum_Value__c=100;
                t.fileName_min=customdata.Id;
                t.fileName_max=customdata.Id;
                t.columnName_min='min value';
                t.columnName_max='max value';
                t.inputControl.Controlling_Field__c=control1.Id;
            }   
            if(t.inputControl.Input_control_type__c=='List Capture'){
                t.inputControl.Custom_Data_Values__c='Amount\r\nPercentage';
            }   
            if(t.inputControl.Input_control_type__c=='Multi Value Option Capture'){
                t.inputControl.Custom_Data_Values__c='Investment01\r\nInvestment02';
                t.inputControl.Description__c='MetLife Property & Causality Inte';                    
            }  
            t.getColoumnList_min();
            t.getDynamicList();
            t.getColoumnList_max();  
            t.getshowMappings();  
        }
        
        
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp3.controlList){                             
            if(t.inputControl.Input_control_type__c=='Value Capture' && t.inputControl.Controlling_Field__c != null){
                t.selectedParentValue='Amount';
                t.selectedChildValue='Text';
                t.addme();                    
                t.RemovalValue='Amount';
                t.removeit();
                
                t.selectedParentValue='Amount';
                t.selectedChildValue='Percentage';
                t.addme();                    
                t.RemovalValue='Amount';
                t.removeit();
                
                t.selectedParentValue='Amount';
                t.selectedChildValue='Number';
                t.addme();                    
                t.RemovalValue='Amount';
                t.removeit();
            }                  
        }       
        
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp3.controlList){                             
            if(t.inputControl.Input_control_type__c=='Value Capture' && t.inputControl.Controlling_Field__c != null){
                t.selectedParentValue=null;
                t.addme();
                
                t.selectedParentValue='Amount';
                t.selectedChildValue='Number';
                t.addme();                    
                t.selectedParentValue='Percenatge';
                t.selectedChildValue='Percenatge';
                t.addme();
                
                t.makeResetonList();
                
                t.selectedParentValue='Amount';
                t.selectedChildValue='Number';
                t.addme();                    
                t.selectedParentValue='Percenatge';
                t.selectedChildValue='Percenatge';
                t.addme();
            }                  
        }  
        
        temp3.submit();            
        temp3.showdependency();
        
        PageReference schDetail1=new PageReference('/apex/WV_SchemeDetails?&id='+schemes[0].Id);
        Test.setCurrentPage(schDetail1);  
        
        WV_TemplateAssignmentController temp4=new WV_TemplateAssignmentController();
        temp4.getTemplates();
        temp4.selectedTemplate=template1.Id;
        temp4.queryinputControls();
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp4.controlList){                
            if(t.inputControl.Input_control_type__c=='Value Capture'){
                t.inputControl.Value_Type__c= 'Number';
                t.inputControl.Default_Minimum_Value__c =10;
                t.inputControl.Default_Maximum_Value__c=100;
                t.fileName_min=customdata.Id;
                t.fileName_max=customdata.Id;
                t.columnName_min='min value';
                t.columnName_max='max value';
                t.inputControl.Controlling_Field__c=control8.Id;
            }   
            if(t.inputControl.Input_control_type__c=='List Capture'){
                t.inputControl.Custom_Data_Values__c='Amount\r\nPercentage';
            }   
            if(t.inputControl.Input_control_type__c=='Multi Value Option Capture'){
                t.inputControl.Custom_Data_Values__c='Investment01\r\nInvestment02';
                t.inputControl.Description__c='MetLife Property & Causality Inte';                    
            }  
            t.getColoumnList_min();
            t.getDynamicList();
            t.getColoumnList_max();  
            t.getshowMappings();  
        }
        
        for(WV_TemplateAssignmentController.inputControlsWrapper t:temp4.controlList){                             
            if(t.inputControl.Input_control_type__c=='Value Capture' && t.inputControl.Controlling_Field__c != null){
                t.selectedParentValue='Amount';
                t.selectedChildValue='Number';
                t.addme();                    
                t.selectedParentValue='Percenatge';
                t.selectedChildValue='Percenatge';
                t.addme();
            }                  
        }  
        temp4.submit();    
        
        update control8;
        update template1;
        
        delete control8;
        delete template1;
        
        source.active__c=false;
        update source;
        
        def.active__c=false;
        update def;
        
        currencys.active__c=false;
        update currencys;
        
        WV_TemplateAssignmentController temp5=new WV_TemplateAssignmentController();
        temp5.getTemplates();
        temp5.selectedTemplate=null;
        temp5.queryinputControls();
        temp5.submit();  
        
        Test.StopTest();
        
    }            
    

}