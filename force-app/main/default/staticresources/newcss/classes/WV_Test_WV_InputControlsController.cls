@istest(SeeAllData=false)

public class WV_Test_WV_InputControlsController{

    public testmethod static void Testmethod01(){     
        
        Waiver_Template__c template=new Waiver_Template__c(Name='Test Template test');
        insert template;
        
        Input_Controls_Mapping__c control1=WV_TestData.WV_insertControls(template.Id,'List Control test','List Capture','Primary',true);
        Input_Controls_Mapping__c control2=WV_TestData.WV_insertControls(template.Id,'List Control test','List Capture','Secondary',true);
        Input_Controls_Mapping__c control3=WV_TestData.WV_insertControls(template.Id,'Value Control test','Value Capture','Secondary',false);
        
        Waiver_Template__c template01=new Waiver_Template__c(Name='Test Template test01');
        insert template01;
        
        Apexpages.standardController std=new Apexpages.standardController(template);
        WV_InputControlsController controls=new WV_InputControlsController(std);
        controls.sendErrorEmail();
        controls.getControls();
        
        Apexpages.standardController std1=new Apexpages.standardController(template01);
        WV_InputControlsController controls1=new WV_InputControlsController(std1);
        controls1.sendErrorEmail();
        controls1.getControls();
        
        Apexpages.standardController std2=new Apexpages.standardController(template01);        
        WV_InputControlsController controls2=new WV_InputControlsController(std2);
        controls2.sendErrorEmail();
        controls2.temp=null;        
        controls2.getControls();
    } 
}