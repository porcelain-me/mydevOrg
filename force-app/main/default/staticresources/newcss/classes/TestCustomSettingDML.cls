public class TestCustomSettingDML {
       
    
    public String name {get;set;}
    public String msid {get;set;}
public     String region {get;set;}
      EDC_Approver__c settings;
 
      
    public TestCustomSettingDML (){
    Map<String,EDC_Approver__c> allEDCApprovers = EDC_Approver__c.getAll();
        allApprovers = allEDCApprovers.values(); 
    }
    



public List<EDC_Approver__c> allApprovers {get;set;}
   

    
    

public PageReference applySettings(){
  settings = EDC_Approver__c.getInstance();
    settings.name = name ;
    settings.MS_ID__c= msid ;
    settings.Region__c = region ;
    settings.SetupOwnerId = '00Df0000002K0p7EAC';

     try{
System.debug('*********************Before SAVED EDC_Approver__c'+settings);
        insert settings;
     System.debug('*********************SAVED EDC_Approver__c'+settings);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,         'Settings Updated: '));
    }
    catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Failed to update settings' ));
    }

    return null;
}

public PageReference deleteSettings(){
System.debug('*********************deleteSettings');

  settings = EDC_Approver__c.getInstance('sd');
System.debug('*********************before deleteSettings'+settings );
     try{
System.debug('*********************Before SAVED EDC_Approver__c'+settings);
        delete settings;
     System.debug('*********************SAVED EDC_Approver__c'+settings);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,         'Settings Updated: '));
    }
    catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Failed to update settings' ));
    }

    return null;
}
}