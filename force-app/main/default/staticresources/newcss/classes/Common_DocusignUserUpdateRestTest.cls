// 
// (c) 2014 Appirio, Inc. 
//
// Description : Test class for Common_DocusignUserUpdateRest
//
// 09 Mar 2014 Jitendra Kothari Original
//
@isTest(seeAllData = false)
private class Common_DocusignUserUpdateRestTest {
    private static User sysUser;
    private static List<Employee__c> empListWithOneEmployee;
    private static List<Employee__c> empListWithTenEmployee;
    private static testmethod void testDocusignUserCreation(){ 
        sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();
            Common_DocusignUserUpdateRest userCreation = new Common_DocusignUserUpdateRest();           
            
            userCreation.start(null);
            FFAP_TestClassUtilities.createDocusignRecord();
            
            userCreation.start(null);
            userCreation.execute(null, empListWithOneEmployee);            
            
            userCreation.execute(null, empListWithTenEmployee);
            userCreation.finish(null);
            userCreation.execute(null);
            Test.stopTest();
        }
    }
    private static void createData(){
        FFAP_TestClassUtilities.setAllTriggerOn(sysUser.Id);
        //Employee
        List<Employee__c> empList = new List<Employee__c>();
        empListWithOneEmployee = new List<Employee__c>();
        empListWithTenEmployee = new List<Employee__c>();
        Employee__c emp;
        for(Integer i = 1; i < 13; i++){
            emp = FFAP_TestClassUtilities.createTestEmployee(i, 'TEST00' + i, '600097', '3', '1', '2');
            if(i == 1){
                emp.City_Home__c = null;
                empListWithOneEmployee.add(emp);
            }else{
                empListWithTenEmployee.add(emp);
            }
            empList.add(emp);
        }
        insert empList;
        
        //Bulk_Docusign_Settings__c record creation
        /*Bulk_Docusign_Settings__c bulkDocusignSetting = DG_TestClassUtilities.createBulkDocusignSettingRecord();
        bulkDocusignSetting.Docusign_API_Limit_Hourly__c = 100;
        bulkDocusignSetting.SFDC_Callout_Limit_Per_Batch__c = 10;
        insert bulkDocusignSetting;*/
    }
}