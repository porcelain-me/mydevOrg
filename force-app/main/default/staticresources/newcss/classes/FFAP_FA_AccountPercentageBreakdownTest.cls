@isTest(SeeAllData = false)
private class FFAP_FA_AccountPercentageBreakdownTest {
    private static User ffapUser;
    private static Employee__c emp1;
    private static Employee__c emp2;
    private static FA_Account__c fa;
    private static FA_Account__c faJPN;
    
    private static final Integer FA_COUNT = 1;
    private static testmethod void testAccountPerBreakdownForCMP(){
        ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            Test.setCurrentPage(Page.FFAP_FA_AccountPercentageBreakdown);
            ApexPages.currentPage().getParameters().put('JPN', fa.Id);  
            ApexPages.currentPage().getParameters().put('showAdvisors', 'true');
            ApexPages.currentPage().getParameters().put('changeRequestor', 'DONTKNOWWHATTOSEND');
            ApexPages.currentPage().getParameters().put('changeFor', 'CMP');
            FFAP_FA_AccountPercentageBreakdown fabBreakdownPage = new FFAP_FA_AccountPercentageBreakdown();
            fabBreakdownPage.saveAndReturn();
            fabBreakdownPage.cancelAddAdvisor();
            fabBreakdownPage.addAdvisorRow();
            Savepoint sp = Database.setSavepoint();
            fabBreakdownPage.exceptionHandler('Percenatge Breakdown Error: ', sp, true);
            for(FFAP_FA_AccountPercentageBreakdown.FFAP_AccountDetails ffapAccDetail: fabBreakdownPage.lstFAAccountDetail){
	            if(!(ffapAccDetail.faAccAssociation.Id != null && ffapAccDetail.isDeleted)){
	                if(ffapAccDetail.faAccAssociation.Id == null){
	                	ffapAccDetail.faAccAssociation.Financial_Advisor__c = emp1.Id;
	                	ffapAccDetail.faAccAssociation.Financial_Advisor__r = emp1;
	                    ffapAccDetail.faAccAssociation.Is_New_Advisor__c = true;
	                }
	            }
	        }
	        
	        fabBreakdownPage.addAdvisorRow();
            
            for(FFAP_FA_AccountPercentageBreakdown.FFAP_AccountDetails ffapAccDetail: fabBreakdownPage.lstFAAccountDetail){
                if(!(ffapAccDetail.faAccAssociation.Id != null && ffapAccDetail.isDeleted)){
                    if(ffapAccDetail.faAccAssociation.Id == null){
                        ffapAccDetail.faAccAssociation.Financial_Advisor__c = emp1.Id;
                        ffapAccDetail.faAccAssociation.Financial_Advisor__r = emp1;
                        ffapAccDetail.faAccAssociation.Is_New_Advisor__c = true;
                    }
                }
            }
            
            
            fabBreakdownPage.saveAdvisor();
            fabBreakdownPage.deletedEmpId = emp2.Emp_Id__c;
            fabBreakdownPage.deleteAdvisor();
            fabBreakdownPage.addRow();
            String coveragePeriod;
            for(String str : fabBreakdownPage.mapCoverage_PrecentageBreakDown.keySet()){
            	coveragePeriod = str;
            	break;
            }
            fabBreakdownPage.deletedMarkedCoveragePeriod = coveragePeriod;
            fabBreakdownPage.deleteRow();
            
            Test.stopTest();
        }
    }
    
    private static testmethod void testAccountPerBreakdownForRetirmentPrimary(){
        ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            Test.setCurrentPage(Page.FFAP_FA_AccountPercentageBreakdown);
            ApexPages.currentPage().getParameters().put('JPN', fa.Id);  
            ApexPages.currentPage().getParameters().put('showAdvisors', 'true');
            ApexPages.currentPage().getParameters().put('changeRequestor', 'DONTKNOWWHATTOSEND');
            ApexPages.currentPage().getParameters().put('changeFor', 'Retirement_Primary');
            FFAP_FA_AccountPercentageBreakdown fabBreakdownPage = new FFAP_FA_AccountPercentageBreakdown();
            fabBreakdownPage.saveAndReturn();
            fabBreakdownPage.cancelAddAdvisor();
            fabBreakdownPage.addAdvisorRow();
            
            for(FFAP_FA_AccountPercentageBreakdown.FFAP_AccountDetails ffapAccDetail: fabBreakdownPage.lstFAAccountDetail){
                if(!(ffapAccDetail.faAccAssociation.Id != null && ffapAccDetail.isDeleted)){
                    if(ffapAccDetail.faAccAssociation.Id == null){
                        ffapAccDetail.faAccAssociation.Financial_Advisor__c = emp1.Id;
                        ffapAccDetail.faAccAssociation.Financial_Advisor__r = emp1;
                        ffapAccDetail.faAccAssociation.Is_New_Advisor__c = true;
                    }
                }
            }
            
            fabBreakdownPage.saveAdvisor();
            fabBreakdownPage.deletedEmpId = emp2.Emp_Id__c;
            fabBreakdownPage.deleteAdvisor();
            fabBreakdownPage.addRow();
            String coveragePeriod;
            for(String str : fabBreakdownPage.mapCoverage_PrecentageBreakDown.keySet()){
                coveragePeriod = str;
                break;
            }
            fabBreakdownPage.deletedMarkedCoveragePeriod = coveragePeriod;
            fabBreakdownPage.deleteRow();
            
            Test.stopTest();
        }
    }
    
    private static testmethod void testAccountPerBreakdownForRetirmentJPN(){
        ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            Test.setCurrentPage(Page.FFAP_FA_AccountPercentageBreakdown);
            ApexPages.currentPage().getParameters().put('JPN', faJPN.Id);  
            ApexPages.currentPage().getParameters().put('showAdvisors', 'true');
            ApexPages.currentPage().getParameters().put('changeRequestor', 'DONTKNOWWHATTOSEND');
            ApexPages.currentPage().getParameters().put('changeFor', 'Retirement_JPN');
            FFAP_FA_AccountPercentageBreakdown fabBreakdownPage = new FFAP_FA_AccountPercentageBreakdown();
            fabBreakdownPage.saveAndReturn();
            fabBreakdownPage.cancelAddAdvisor();
            fabBreakdownPage.addAdvisorRow();
            
            for(FFAP_FA_AccountPercentageBreakdown.FFAP_AccountDetails ffapAccDetail: fabBreakdownPage.lstFAAccountDetail){
                if(!(ffapAccDetail.faAccAssociation.Id != null && ffapAccDetail.isDeleted)){
                    if(ffapAccDetail.faAccAssociation.Id == null){
                        ffapAccDetail.faAccAssociation.Financial_Advisor__c = emp1.Id;
                        ffapAccDetail.faAccAssociation.Financial_Advisor__r = emp1;
                        ffapAccDetail.faAccAssociation.Is_New_Advisor__c = true;
                    }
                }
            }
            
            fabBreakdownPage.saveAdvisor();
            fabBreakdownPage.deletedEmpId = emp2.Emp_Id__c;
            fabBreakdownPage.deleteAdvisor();
            fabBreakdownPage.addRow();
            String coveragePeriod;
            for(String str : fabBreakdownPage.mapCoverage_PrecentageBreakDown.keySet()){
                coveragePeriod = str;
                break;
            }
            fabBreakdownPage.updateRetireeFFAPSplit();
            fabBreakdownPage.curKey = coveragePeriod;
            fabBreakdownPage.ffapMultiplier = 100;
            fabBreakdownPage.updateRetireeFFAPSplit();
            fabBreakdownPage.addRow();
            fabBreakdownPage.deletedMarkedCoveragePeriod = coveragePeriod;
            fabBreakdownPage.deleteRow();
            
            Test.stopTest();
        }
    }
    
    private static testmethod void testAccountPerBreakdown(){
        ffapUser = FFAP_TestClassUtilities.createSystemDataFFAPUser();
        System.runAs(ffapUser){
            createData();
            Test.startTest();
            Test.setCurrentPage(Page.FFAP_FA_AccountPercentageBreakdown);
            ApexPages.currentPage().getParameters().put('JPN', fa.Id);  
            ApexPages.currentPage().getParameters().put('showAdvisors', 'true');
            ApexPages.currentPage().getParameters().put('changeRequestor', 'DONTKNOWWHATTOSEND');
            FFAP_FA_AccountPercentageBreakdown fabBreakdownPage = new FFAP_FA_AccountPercentageBreakdown();
            fabBreakdownPage.saveAndReturn();
            fabBreakdownPage.cancelAddAdvisor();
            fabBreakdownPage.saveAdvisor();
            fabBreakdownPage.deletedEmpId = emp2.Emp_Id__c;
            fabBreakdownPage.deleteAdvisor();
            fabBreakdownPage.addRow();
            String coveragePeriod;
            for(String str : fabBreakdownPage.mapCoverage_PrecentageBreakDown.keySet()){
                coveragePeriod = str;
                break;
            }
            fabBreakdownPage.deletedMarkedCoveragePeriod = coveragePeriod;
            fabBreakdownPage.deleteRow();
            
            Test.stopTest();
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
            fa = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '-100' + counter, activeRecordTypeId);
            faList.add(fa);
        }  
        
        //Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
        faJPN = FFAP_TestClassUtilities.createJPNFAAccount(emp1.Emp_ID__c + '-' + emp1.Emp_ID__c, activeRecordTypeId);
        faList.add(faJPN);
        
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
    }
}