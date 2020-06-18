@isTest(SeeAllData = false)
private class FFAP_FA_RetirementProcessTest {
	private static User ffapUser;
    private static Employee__c emp1;
    private static Employee__c emp2;
    private static FFAP_Agreement__c faAgreement;
    private static final Integer PRIMARY_COUNT = 0;
    private static final Integer JPN_COUNT = 1;
    private static final Integer FA_COUNT = PRIMARY_COUNT + JPN_COUNT;
    private static testmethod void testFARetirement(){
    	ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            
            Test.setCurrentPage(Page.FFAP_FA_RetirementProcess);
            ApexPages.currentPage().getParameters().put('faaId', faAgreement.Id); 
            
            ApexPages.StandardController faStdController = new ApexPages.StandardController(new FFAP_Agreement__c());
            FFAP_FA_RetirementProcess faRetirementPage = new FFAP_FA_RetirementProcess(faStdController);
            
            System.assertEquals(false, faRetirementPage.showTabs, 'Tab should not be shown.');
            System.assertEquals(false, faRetirementPage.showFATable, 'FA Table should not be shown.');
            System.assertEquals(false, faRetirementPage.showJpnTable, 'JPN Table should not be shown.');
            System.assertEquals(true, ApexPages.hasMessages(ApexPages.severity.ERROR), 'Error should be thrown.');
            
            ApexPages.currentPage().getParameters().put('empId', emp1.Emp_ID__c);
            faRetirementPage = new FFAP_FA_RetirementProcess(faStdController);
            
            System.assertEquals(false, faRetirementPage.showTabs, 'Tab should not be shown.');
            System.assertEquals(true, ApexPages.hasMessages(ApexPages.severity.ERROR), 'Error should be thrown.');
            
            emp1.DOH_Recent__c = System.today().addYears(-5);
            update emp1;            
            faRetirementPage = new FFAP_FA_RetirementProcess(faStdController);
            
            System.assertEquals(true, faRetirementPage.showTabs, 'Tab should be shown.');
            System.assertEquals(false, faRetirementPage.showFATable, 'FA Table should not be shown.');
            System.assertEquals(true, faRetirementPage.showJpnTable, 'JPN Table should be shown.');
            
            faRetirementPage.addFA();
            System.assertEquals(true, ApexPages.hasMessages(ApexPages.severity.ERROR), 'Error should be thrown.');
            
            faRetirementPage.faAccountAssociationTemp.Financial_Advisor__c = emp1.Id;
            faRetirementPage.addFA();
            System.assertEquals(true, ApexPages.hasMessages(ApexPages.severity.ERROR), 'Error should be thrown.');
            
            faRetirementPage.faAccountAssociationTemp.Financial_Advisor__c = emp2.Id;
            faRetirementPage.addFA();
            
            List<FA_Account__c> faList = [SELECT Id FROM FA_Account__c where Name = :(emp1.Emp_Id__c + '-1')];
            System.assertEquals(1, faList.size(), 'Only one FA should be created.');
            
            faRetirementPage.jpnToDelete = faList[0].Id;
            faRetirementPage.deleteTempJpn();
            
            faList = [SELECT Id FROM FA_Account__c where Name = :(emp1.Emp_Id__c + '-1')];
            System.assertEquals(true, faList.isEmpty(), 'FA should be deleted.');
            
            faRetirementPage.saveJPN();
            faRetirementPage.savePrimary();
            faRetirementPage.switchTab();
            Test.stopTest();
        }
    }
    private static void createData(){    	
        //Employee
        List<Employee__c> empList = new List<Employee__c>();
        emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST002', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        empList.add(emp1);
        empList.add(emp2);
        insert empList;
        
        //FA Agreement
        faAgreement = FFAP_TestClassUtilities.createAgreement(emp1.Id);
        faAgreement.JPNEnhancedGridRate__c = 1.0;
        insert faAgreement;
        
        //FA Account
        List<FA_Account__c> faList = new List<FA_Account__c>();
        FA_Account__c fa;
        FA_Account__c tempFaAccount;
        Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
        Id agreementRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.AGREEMENT_RECORDTYPE);
        for(Integer counter = 1; counter < FA_COUNT + 1; counter ++){       
            if(counter <= PRIMARY_COUNT){
                fa = FFAP_TestClassUtilities.createPrimaryFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId);
            }else if(counter <= PRIMARY_COUNT + JPN_COUNT){
                fa = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId);
                fa.IsEnhancedOption__c = true;
                tempFaAccount = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '100-' + emp1.Emp_ID__c, agreementRecordTypeId);
                faList.add(tempFaAccount);
            }
            faList.add(fa);
        }
        insert faList;
        
        //FA Association
        List<FA_Account_Association__c> faAssocationList = new List<FA_Account_Association__c>();
        FA_Account_Association__c faAssocation;
        for(FA_Account__c faTemp : faList){
         faAssocation = FFAP_TestClassUtilities.createFAAccountAssociation(emp1.Id, faTemp.Id);
         if(faTemp.Type__c == FFAP_DataUtil.FA_Primary_TYPE){
             faAssocationList.add(faAssocation);         
               }else if(faTemp.Type__c == FFAP_DataUtil.FA_JPN_TYPE){
                faAssocation.FA_Split_Percent__c = 50;
                faAssocationList.add(faAssocation);
                faAssocationList.add(FFAP_TestClassUtilities.createFAAccountAssociation(emp2.Id, faTemp.Id, 100 - faAssocation.FA_Split_Percent__c));            
               }
        }
        insert faAssocationList;
        
        //Production Period
        List<Production_Period__c> faPBList = FFAP_TestClassUtilities.createProductionPeriod(5);
        insert faPBList;
        
        //FA Account Production Period Association
        List<FA_Account_Production_Period_Association__c> faPPAList = FFAP_TestClassUtilities.createProductionPeriodAssociation(faPBList, faAssocationList);
        insert faPPAList;
        
        //FFAP Default Multiplier
        FFAP_TestClassUtilities.createFFAPDefaultMultipliers();
    }
}