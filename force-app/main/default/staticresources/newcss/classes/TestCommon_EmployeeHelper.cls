// 09/30/2011 RJ: ORIGINAL
//                Test class for Common_EmployeeHelper Class.
@isTest(seeAllData=false)
private class TestCommon_EmployeeHelper {
    static User usr;    
    static {
          //usr = CM_TestClassUtilities.getTempUser();
          usr = getTempUser();
    }
    static User getTempUser(){
    
        Profile p = [select id from Profile where Name = 'All MS Employee'];
        
        User u = new User(alias = 'test', email = 'T2' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 emailencodingkey = 'UTF-8', lastname = 'Testing0',
                                 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.id, 
                                 Short_Id__c = 'winLogT',
                                 timezonesidkey = 'America/Los_Angeles', username = 'T1' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
                                 Emp_ID__c = 'TEST1', isActive = true);                    
        return u;
     } 
    
    static testMethod void isUserAnalystTest() {   
         //T1C_CustomSettingsManager.setAllTriggerOn();       
           GPSTrigger_Switch__c dSwitch = GPSTrigger_Switch__c.getInstance();
          if(dSwitch != null && dSwitch.Id != null){
           // dSwitch.Is_syncUserFromGPSEmp_Trigger_On__c = false;  
          }else{
            dSwitch = new GPSTrigger_Switch__c(Name = 'Default'); 
            //dSwitch.Is_syncUserFromGPSEmp_Trigger_On__c = false;
            // insert dSwitch;   
          }
        System.runAs(usr){
          Test.startTest();
          T1C_CustomSettingsManager.setAllTriggerOn();  
          // Analyst Employee..
          GPSEmployee__c e = new GPSEmployee__c();
          e.Name = 'test';
          e.User__c = usr.Id;
          e.Division__c = 'Research';
          e.MS_ID__c = 'TEST1';        
          e.Is_Producer_Employee__c = true;
          e.Active_Flag__c = false;
          
          insert e;

          
          //System.assertEquals(Common_EmployeeHelper.getInstance().isUserAnalyst(), true, 'Current user should be analyst');
          
          Test.stopTest();
        }  
    }
    
    static testMethod void isUserNotAnalystTest() {
          
       System.runAs(usr){
          Test.startTest();
          T1C_CustomSettingsManager.setAllTriggerOn();  
          // Non - Analyst Employee..
          GPSEmployee__c e = new GPSEmployee__c();
          e.Name = 'test1';
          e.Division__c = 'Nothing';
          e.MS_ID__c = 'testSEFR';        
          e.Is_Producer_Employee__c = true;          
          e.Active_Flag__c = true;
          insert e;
          
          System.assertEquals(Common_EmployeeHelper.getInstance().isUserAnalyst(), false, 'Current user should not be analyst');
          
          Test.stopTest();
        } 
    }
}