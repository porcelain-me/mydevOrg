@isTest(seeAllData = false)
private class FFAP_FA_AccountAssociationsTest {
	private static User ffapUser;
	private static Employee__c emp1;
    private static FFAP_Agreement__c faAgreement;    
    private static final Integer PRIMARY_COUNT = 2;
    private static final Integer JPN_COUNT = 4;
    private static final Integer FA_COUNT = PRIMARY_COUNT + JPN_COUNT + 3;
    private static FA_Account__c tempFaAccount; 
    static testmethod void testFAAssociations(){
    	ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
    	System.runAs(ffapUser){
    		createData();
    		Test.startTest();    		
    		
    		Test.setCurrentPage(Page.FFAP_FA_AccountAssociations);
            ApexPages.currentPage().getParameters().put('faaId', faAgreement.Id);  
            ApexPages.currentPage().getParameters().put('empId', emp1.Emp_ID__c);
            ApexPages.StandardController faStdController = new ApexPages.StandardController(new FFAP_Agreement__c());
    		FFAP_FA_AccountAssociations faAssociationPage = new FFAP_FA_AccountAssociations(faStdController);
    		
    		System.assertEquals(FFAP_DataUtil.FA_Primary_TYPE, faAssociationPage.fa_Type, 'Default Fa Type should be primary Type.');
    		System.assertEquals(emp1.Name, faAssociationPage.fa_Name, 'Name should match.');
    		System.assertEquals(PRIMARY_COUNT, faAssociationPage.faAccountAssociationList.size(), 'FA count should be ' + PRIMARY_COUNT);
    		System.assertEquals(3, faAssociationPage.mapFAAccountType.size(), 'FA count should be ' + 3);
    		
    		faAssociationPage.fa_Type = FFAP_DataUtil.FA_JPN_TYPE;   		
    		faAssociationPage.switchTab();
    		
    		System.assertEquals(JPN_COUNT, faAssociationPage.faAccountAssociationList.size(), 'FA count should be ' + JPN_COUNT);
    		System.assertEquals(true, faAssociationPage.isEditTempJPN, 'isEditTempJPN should be true.');
    		
    		faAssociationPage.faAccountAssociationList[0].faAccountAssociation.FA_Account__r.Temp_FA_Account__c = tempFaAccount.Id;
    		faAssociationPage.saveTempJPNNumbers();
    		
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
	       }else{
	       	   fa = FFAP_TestClassUtilities.createFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId, 'Secondary');
	           fa.InActive__c = true;
	       }
	       faList.add(fa);
	   }
	   Id agreementRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.AGREEMENT_RECORDTYPE);
	   tempFaAccount = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '100 - ' + emp1.Emp_ID__c, agreementRecordTypeId);
	   faList.add(tempFaAccount);
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
    }    
}