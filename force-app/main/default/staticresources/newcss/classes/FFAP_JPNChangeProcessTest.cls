@isTest(SeeAllData = false)
private class FFAP_JPNChangeProcessTest {
    private static User ffapUser;
    private static Employee__c emp1;
    private static Employee__c emp2;
    private static FA_Account__c fa;
    private static JPN_Change__c jpnChange;
    private static final Integer FA_COUNT = 1;
    
    private static testMethod void testJPNChangeForModifcation(){
    	ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
        	createData();
            Test.startTest();
            Test.setCurrentPage(Page.FFAP_JPNChangeProcess);
            ApexPages.currentPage().getParameters().put('empId', emp2.Id);  
            ApexPages.currentPage().getParameters().put('id', jpnChange.Id);  
            ApexPages.StandardController faStdController = new ApexPages.StandardController(jpnChange);
            FFAP_JPNChangeProcess jpnChangeProcess = new FFAP_JPNChangeProcess(faStdController);
            jpnChangeProcess.selectedJPNId = fa.Id;
            jpnChangeProcess.addToJPNChangeList();
            jpnChangeProcess.selectedJPNId = fa.Id;
            jpnChangeProcess.addToJPNChangeList();
            //if(jpnChangeProcess.newFaAccList.size() > 0){
            System.assertEquals(jpnChangeProcess.newFaAccList.size(), 1, 'FA Account using JPN Change process should create.');
            jpnChangeProcess.jpnToDelete = jpnChangeProcess.newFaAccList[0].Id;
            //}
            jpnChangeProcess.deleteTempJpn();
            System.assertEquals(jpnChangeProcess.newFaAccList.size(), 0, 'FA Account using JPN Change process should delete.');
            jpnChangeProcess.faAccAssociationTemp.Financial_Advisor__c = emp1.Id;
            jpnChangeProcess.addFA();
            System.assertEquals(jpnChangeProcess.faAccAssList.size(), 1, 'FA Account Association record should create.');
            
            jpnChangeProcess.faAccAssociationTemp.Financial_Advisor__c = null;
            jpnChangeProcess.addFA();
            jpnChangeProcess.jpnChange.RecordTypeId = FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.NEW_JPN_RECORDTYPE);
            jpnChangeProcess.recordTypeChange();
            jpnChangeProcess.jpnChange.RecordTypeId = FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.MODIFICATION_RECORDTYPE);
            jpnChangeProcess.recordTypeChange();
            jpnChangeProcess.jpnChange.Modification_Type__c = 'Termination of Contract';
            jpnChangeProcess.modificationTypeChange();
            jpnChangeProcess.jpnChange.Modification_Type__c = 'Active';
            jpnChangeProcess.advisorTypeChange();
            jpnChangeProcess.SaveChangeProcess();
        }
    }
    
    private static void createData(){
        //Employee
        List<Employee__c> empList = new List<Employee__c>();
        emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST002', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        Employee__c emp3 = FFAP_TestClassUtilities.createTestEmployee(3, 'TEST003', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        empList.add(emp3);
        empList.add(emp2);
        insert emp1;
        insert empList;
        
        //FA Agreement
        /*faAgreement = FFAP_TestClassUtilities.createAgreement(emp1.Id);
        insert faAgreement;*/
        
        //FA Account
        List<FA_Account__c> faList = new List<FA_Account__c>();
        
        Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
        for(Integer counter = 1; counter < FA_COUNT + 1; counter ++){       
            fa = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId);
            faList.add(fa);
        }       
        insert faList;
        
        //FA Association
        List<FA_Account_Association__c> faAssocationList = new List<FA_Account_Association__c>();
        FA_Account_Association__c faAssocation;
        for(FA_Account__c faTemp : faList){
            faAssocation = FFAP_TestClassUtilities.createFAAccountAssociation(emp3.Id, faTemp.Id);
            if(faTemp.Type__c == FFAP_DataUtil.FA_JPN_TYPE){
                faAssocation.FA_Split_Percent__c = 50;
                faAssocationList.add(faAssocation);
                faAssocationList.add(FFAP_TestClassUtilities.createFAAccountAssociation(emp2.Id, faTemp.Id, 100 - faAssocation.FA_Split_Percent__c));            
            }
        }
        insert faAssocationList;
        
        List<Production_Period__c> faPBList = FFAP_TestClassUtilities.createProductionPeriod(5);
        insert faPBList;
        List<FA_Account_Production_Period_Association__c> faPPAList = FFAP_TestClassUtilities.createProductionPeriodAssociation(faPBList, faAssocationList);
        insert faPPAList;
        
        jpnChange = FFAP_TestClassUtilities.createJPNChange('FA', FFAP_DataUtil.getJPNChangeRecordTypeId(FFAP_DataUtil.NEW_JPN_RECORDTYPE), emp2.Id);
        insert jpnChange;       
    }
   
}