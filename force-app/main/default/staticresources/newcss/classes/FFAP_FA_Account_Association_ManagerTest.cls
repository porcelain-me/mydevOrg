@isTest(seeAllData = false)
private class FFAP_FA_Account_Association_ManagerTest {
    private static User ffapUser;
    private static List<FA_Account_Association__c> faAssocationList;
    private static Employee__c emp1;
    private static FA_Account__c fa;
    private static final Integer JPN_COUNT = 1;
    private static final Integer PRIMARY_COUNT = 0;
    private static final Integer FA_COUNT = PRIMARY_COUNT + JPN_COUNT;
    static testmethod void testFAAgreement(){
        ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            insert faAssocationList;
            faAssocationList = [Select Id, FFAP_Agreement__c, FFAP_Agreement__r.Employee__c, Financial_Advisor__c from FA_Account_Association__c where Id IN : faAssocationList];
            System.assertEquals(false, faAssocationList.isEmpty());
            for(FA_Account_Association__c faa : faAssocationList){
                System.assertNotEquals(null, faa.FFAP_Agreement__c);
                System.assertEquals(faa.Financial_Advisor__c, faa.FFAP_Agreement__r.Employee__c);
            }
            faAssocationList = new List<FA_Account_Association__c>();
            faAssocationList.add(FFAP_TestClassUtilities.createFAAccountAssociation(emp1.Id, fa.Id, 0.0));
            try{                
                insert faAssocationList;
            }catch(DMLException dmle){
                System.assert(dmle.getMessage().contains('This advisor is already added in this account'));
            }
            Test.stopTest();
        }
    }
    private static void createData(){
        //Employee
        List<Employee__c> empList = new List<Employee__c>();
        emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        Employee__c emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST002', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        empList.add(emp1);
        empList.add(emp2);
        insert empList;
        
        //FA Agreement
        List<FFAP_Agreement__c> faAgreementList = new List<FFAP_Agreement__c>();
        faAgreementList.add(FFAP_TestClassUtilities.createAgreement(emp1.Id));
        faAgreementList.add(FFAP_TestClassUtilities.createAgreement(emp2.Id));
        insert faAgreementList;
        
        //FA Account
        List<FA_Account__c> faList = new List<FA_Account__c>();
        Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
       for(Integer counter = 1; counter < FA_COUNT + 1; counter ++){             
           if(counter <= PRIMARY_COUNT + JPN_COUNT){
               fa = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId);
           }
           faList.add(fa);
       }       
       insert faList;
       
       //FA Association
       faAssocationList = new List<FA_Account_Association__c>();
       FA_Account_Association__c faAssocation;
       for(FA_Account__c faTemp : faList){
           faAssocation = FFAP_TestClassUtilities.createFAAccountAssociation(emp1.Id, faTemp.Id);
           if(faTemp.Type__c == FFAP_DataUtil.FA_JPN_TYPE){
            faAssocation.FA_Split_Percent__c = 50;
            faAssocation.FFAP_Agreement__c = faAgreementList.get(0).Id;
            faAssocation.Financial_Advisor__c = null;
            faAssocationList.add(faAssocation);
            faAssocationList.add(FFAP_TestClassUtilities.createFAAccountAssociation(emp2.Id, faTemp.Id, 100 - faAssocation.FA_Split_Percent__c));            
           }
       }       
    }
}