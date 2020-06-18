@isTest(seeAllData='true')
public class RIF_Create_ProjDecisiOrgLvl_Test {
    
    public static testMethod void test1() {
        
        Child_Project_Decisional_Unit__c childPDU = new Child_Project_Decisional_Unit__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(childPDU);
        
        Test.startTest();
        RIF_Create_Project_Decisional_Org_Level projDecObj = new RIF_Create_Project_Decisional_Org_Level(sc);
            projDecObj.saveAndNewRecordFlag = false;
            projDecObj.pdu = new Project_Decisional_Unit__c();
            projDecObj.childDecUnitRecord = childPDU;
            projDecObj.dmlErrorMessages = '';
            
            projDecObj.save();
            
            System.assertEquals(false, projDecObj.saveAndNewRecordFlag);
        Test.stopTest();
    }
    
    public static testMethod void test2() {
        Severance_And_Release__c snr = RIF_CreateUpdate_Accrual_Test.testCreateSnR();
        
        Child_Project_Decisional_Unit__c childPDU = [SELECT Id FROM Child_Project_Decisional_Unit__c 
                                                     		WHERE Id=:snr.Project_Decisional_Org_Level__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(childPDU);
        
        Test.startTest();
            RIF_Create_Project_Decisional_Org_Level projDecObj = new RIF_Create_Project_Decisional_Org_Level(sc);
            projDecObj.save();
            projDecObj.saveAndNew();
        Test.stopTest();
    }
}