@isTest(SeeAllData = false)
private class FFAP_PopulateFADataBatchTest {
	private static User sysUser;
    private static final Integer PRIMARY_COUNT = 2;
    private static final Integer JPN_COUNT = 1;
    private static final Integer FA_COUNT = PRIMARY_COUNT + JPN_COUNT + 1;
    private static List<Staging_FA_Account__c> stagingFaList;
    private static Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
    private static testmethod void testPopulateFAData(){
    	
    	sysUser = FFAP_TestClassUtilities.getSystemAdminTempUser();
        System.runAs(sysUser){
            createData();
            Test.startTest();
            FFAP_PopulateFADataBatch batch = new FFAP_PopulateFADataBatch();
            batch.start(null);            
            List<FA_Account__c> faList;
            
            System.assertEquals(2, [SELECT count() FROM FA_Account__c], 'Two FA should be present.');
            System.assertEquals(0, [SELECT count() FROM FA_Account__c WHERE InActive__c = true], 'No InActive should be present.');
            System.assertEquals(2, [SELECT count() FROM FA_Account__c WHERE InActive__c = false], 'Two Active FA should be present.');
            
            batch.execute(null, stagingFaList);
            System.assertEquals(5, [SELECT count() FROM FA_Account__c], 'Five FA should be present.');
            System.assertEquals(0, [SELECT count() FROM FA_Account__c WHERE InActive__c = true], 'No InActive should be present.');
            System.assertEquals(5, [SELECT count() FROM FA_Account__c WHERE InActive__c = false], 'Five Active FA should be present.');
            
            batch.finish(null);
            
            System.assertEquals(1, [SELECT count() FROM FA_Account__c where InActive__c = true], 'One InActive FA should be present.');
            System.assertEquals(4, [SELECT count() FROM FA_Account__c where InActive__c = false], 'Four Active FA should be present.');
            batch.execute(null);
            Test.stopTest();
        }
    }
    private static void createData(){
    	FFAP_TestClassUtilities.setAllTriggerOn(sysUser.Id);
        //Employee
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c emp1 = FFAP_TestClassUtilities.createTestEmployee(1, 'TEST001', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        Employee__c emp2 = FFAP_TestClassUtilities.createTestEmployee(2, 'TEST002', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        Employee__c emp3 = FFAP_TestClassUtilities.createTestEmployee(3, 'TEST003', '600097', 'Financial Advsior', 'TestJobLevelDesc', 'TestJobLevel');
        emp3.Status__c = 'Terminated';
        empList.add(emp1);
        empList.add(emp2);
        empList.add(emp3);
        insert empList;
               
        //FA Account and Staging FA Account        
        FA_Account__c faAcc = FFAP_TestClassUtilities.createPrimaryFAAccount(emp1.Emp_ID__c + '2001', activeRecordTypeId);
        List<FA_Account__c> faList = new List<FA_Account__c>();
        stagingFaList = new List<Staging_FA_Account__c>();
        Staging_FA_Account__c fa;
        for(Integer counter = 1; counter < FA_COUNT + 1; counter ++){       
            if(counter <= PRIMARY_COUNT){
                fa = FFAP_TestClassUtilities.createPrimaryStagingFA('100' + counter, emp1.Emp_ID__c + '100' + counter, emp1.Emp_ID__c);
                if(counter == 1){
                    faList.add(FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '100' + counter, activeRecordTypeId));
                }                
            }else if(counter <= PRIMARY_COUNT + JPN_COUNT){
                fa = FFAP_TestClassUtilities.createJPNStagingFA('100' + counter, emp1.Emp_ID__c + '100' + counter, emp1.Emp_ID__c, 40.0);
                stagingFaList.add(FFAP_TestClassUtilities.createJPNStagingFA('100' + counter, emp1.Emp_ID__c + '100' + counter, emp2.Emp_ID__c, 40.0));
                stagingFaList.add(FFAP_TestClassUtilities.createJPNStagingFA('100' + counter, emp1.Emp_ID__c + '100' + counter, emp3.Emp_ID__c, 20.0));
            }else{
            	fa = FFAP_TestClassUtilities.createStagingFA('100' + counter, null, emp1.Emp_ID__c + '100' + counter, 'ABCD', 100.0);
            }            
            stagingFaList.add(fa);
        }       
        faList.add(faAcc);
        insert stagingFaList;
        insert faList;
        
        //FA Association
       List<FA_Account_Association__c> faAssocationList = new List<FA_Account_Association__c>();
       FA_Account_Association__c faAssocation;
       for(FA_Account__c faTemp : faList){
            if(faTemp.Type__c == FFAP_DataUtil.FA_JPN_TYPE){
                faAssocation = FFAP_TestClassUtilities.createFAAccountAssociation(emp1.Id, faTemp.Id);
                faAssocation.FA_Split_Percent__c = 50;
                faAssocationList.add(faAssocation);                
                faAssocationList.add(FFAP_TestClassUtilities.createFAAccountAssociation(emp2.Id, faTemp.Id, 100 - faAssocation.FA_Split_Percent__c)); 
            }
       }
       insert faAssocationList;
    }
}