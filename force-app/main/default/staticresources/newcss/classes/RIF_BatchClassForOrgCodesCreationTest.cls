// 07/12/2013 RJ: Original 
// Test class for Batchable and Schedulable class 'RIF_BatchClassForOrgCodesCreation'.
//
//
@isTest
private class RIF_BatchClassForOrgCodesCreationTest {

    static testMethod void myUnitTest() {
        Test.StartTest();
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c emp;
        for(Integer i=0;i<10;i++){
          emp = createTestEmployee(i, '123#' + i, 'USA', 'MSSB', 'Managing Director', '123');
          empList.add(emp);
        }
        insert empList;
     
       /** 
           NOTE: WE CANNOT MAKE RIF_BatchClassForOrgCodesCreation CLASS TO RUN UNDER A BATCHABLE JOB 
           IN A TEST CLASS BECAUSE IT IS BATCHABLE AS WELL AS SCHEDULABLE. AS DOING THAT MIGHT
           LEAD TO FOLLOWING EXCEPTION while deployment to production:
                  
           System.UnexpectedException: No more than one executeBatch can be called from 
           within a testmethod. Please make sure the iterable returned from your start method 
           matches the batch size, resulting in one executeBatch invocation 
         
         **/
     
         RIF_BatchClassForOrgCodesCreation deleteBatch = new RIF_BatchClassForOrgCodesCreation();
         Integer totalNumberOfRecordsHastoBeCreatedWithTenEmployees= 70;
         deleteBatch.execute(null, empList);
         List<Org_Codes__c> lst= [select id from Org_Codes__c];
         System.assertEquals(lst.size(), totalNumberOfRecordsHastoBeCreatedWithTenEmployees, 'Correct Number of Org Codes Not Created');
         
         
         deleteBatch.execute(null, empList);
         System.assertEquals(lst.size() > totalNumberOfRecordsHastoBeCreatedWithTenEmployees, false, 'Check that no more codes are created');
         
         
         deleteBatch.finish(null);
         deleteBatch.start(null);
         
         Test.StopTest();
    
      
     

    }
    
    private static Employee__c createTestEmployee(Integer indx, String empId, String Country, String MSSB, String jobLevelDsc, String jobLevel){
    	Employee__c emp = new Employee__c(Name = 'Test Employee_' + indx, 
    									  emp_Id__c = empId, 
    									  Job_Country_Job__c = Country,
                                          MS_MSSB__c = MSSB, 
                                          Level_Dsc_Job__c = jobLevelDsc, 
                                          Covenant_Date__c = Date.today(), 
                                          Level_Job__c = jobLevel, 
                                          Super_Division__c= 'Super Division' + indx,
	                                      Super_Depart_Org__c ='Super Department' + indx,
	                                      Subdept_Org__c = 'Sub Department' + indx,
	                                      Division_Org__c = 'Division' + indx,
	                                      Dept_Org__c = 'Department' + indx,
	                                      Sub_Depart2_Org__c = 'Sub Department 2' + indx,
	                                      Cost_Center__c = 'Cost Center' + indx,
	                                      Super_Division_Dsc_Org__c= 'Super Division Dsc' + indx,
	                                      Super_Depart_Dsc_Org__c ='Super Department Dsc' + indx,
	                                      Subdept_Dsc_Org__c = 'Sub Department Dsc' + indx,
	                                      Division_Dsc_Org__c = 'Division Dsc' + indx,
	                                      Dept_Dsc_Org__c = 'Department Dc' + indx,
	                                      Sub_Depart2_Dsc_Org__c = 'Sub Department 2 Dsc' + indx,
	                                      Cost_Center_Desc__c = 'Cost Center' + indx );
		return emp;
    }
}