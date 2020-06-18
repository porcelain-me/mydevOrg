@isTest(SeeAllData = false)
private class FFAP_FA_RetirementProcessStartTest {
	private static User ffapUser;
    private static Employee__c emp1;
    private static FFAP_Agreement__c faAgreement;
    private static final Integer PRIMARY_COUNT = 0;
    private static final Integer JPN_COUNT = 1;
    private static final Integer FA_COUNT = PRIMARY_COUNT + JPN_COUNT;
	private static testmethod void testFARetirement(){
		ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
		System.runAs(ffapUser){
            createData();
            Test.startTest();
            
            List<FA_Account_Association__c> faAccAssociationAgreementTypeList = 
                    FFAP_DataUtil.getFAAccAssociationListOnEmpIdAccType(emp1.Emp_Id__c, FFAP_DataUtil.FA_JPN_TYPE, FFAP_DataUtil.AGREEMENT_RECORDTYPE);
            System.assertEquals(true, faAccAssociationAgreementTypeList.isEmpty(), 'No Agreement should be created.');
            Test.setCurrentPage(Page.FFAP_FA_RetirementProcessStart);
            ApexPages.currentPage().getParameters().put('faaId', faAgreement.Id);  
            ApexPages.currentPage().getParameters().put('empId', emp1.Emp_ID__c);
            ApexPages.StandardController faStdController = new ApexPages.StandardController(new FFAP_Agreement__c());
            FFAP_FA_RetirementProcessStart faRetirementPage = new FFAP_FA_RetirementProcessStart(faStdController);
            
            System.assertEquals(true, faRetirementPage.isError, 'Error should be thrown.');            
            System.assertEquals(true, ApexPages.hasMessages(ApexPages.severity.ERROR), 'Error should be thrown.');
            
            faAgreement.Is_Commitment_Agreement_Generated__c = true;
            update faAgreement;
            
            faRetirementPage = new FFAP_FA_RetirementProcessStart(faStdController);
            System.assertEquals(true, faRetirementPage.isError, 'Error should be thrown.');
            System.assertEquals(true, ApexPages.hasMessages(ApexPages.severity.ERROR), 'Error should be thrown.');
            
            faAgreement.Is_Commitment_Agreement_Signed__c = true;
            update faAgreement;
                        
            faRetirementPage = new FFAP_FA_RetirementProcessStart(faStdController);
            System.assertEquals(false, faRetirementPage.isError, 'No Error should be thrown.');
            
            faRetirementPage.pageAction();
            faAccAssociationAgreementTypeList = 
                    FFAP_DataUtil.getFAAccAssociationListOnEmpIdAccType(emp1.Emp_Id__c, FFAP_DataUtil.FA_JPN_TYPE, FFAP_DataUtil.AGREEMENT_RECORDTYPE);
            System.assertEquals(1, faAccAssociationAgreementTypeList.size(), 'One Retirement Agreement should be created.');
            
            faRetirementPage = new FFAP_FA_RetirementProcessStart(faStdController);
            faRetirementPage.pageAction();
            
            PageReference pg = faRetirementPage.getredirectUrl();            
            System.assertNotEquals(null, pg, 'Page Reference can not be null');
            
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
        faAgreement = FFAP_TestClassUtilities.createAgreement(emp1.Id);
        insert faAgreement;
        
        //FA Account
        List<FA_Account__c> faList = new List<FA_Account__c>();
        FA_Account__c fa;
        Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
        for(Integer counter = 1; counter < FA_COUNT + 1; counter ++){       
            if(counter <= PRIMARY_COUNT){
                fa = FFAP_TestClassUtilities.createPrimaryFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId);
            }else if(counter <= PRIMARY_COUNT + JPN_COUNT){
                fa = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId);
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
		
		List<Production_Period__c> faPBList = FFAP_TestClassUtilities.createProductionPeriod(5);
		insert faPBList;
		List<FA_Account_Production_Period_Association__c> faPPAList = FFAP_TestClassUtilities.createProductionPeriodAssociation(faPBList, faAssocationList);
		insert faPPAList;		
	}
}