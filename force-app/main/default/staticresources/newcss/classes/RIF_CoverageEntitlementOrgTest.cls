@istest
Public class RIF_CoverageEntitlementOrgTest {
  
    static testMethod void myTest(){
     
       Test.startTest(); 
       Employee__c emp = new Employee__c();
            emp.emp_id__c = 'MS12';
            emp.name = 'Test';
            emp.Level_Dsc_Job__c = 'Professional';
            emp.Level_Job__c = '30';
            emp.MS_MSSB__c = 'MSSB';
            emp.Job_Country_Job__c  = 'USA';
            emp.Status__c = 'active';
            emp.Super_Division__c = '10910';
            insert  emp;
     
      RIF_OrgHierarchy_TestUtil testUtil =  new RIF_OrgHierarchy_TestUtil(); 
      testUtil.createCoverageEntitlements(emp);
         
       
        List<Coverage_Entitlement_Org__c> delList = [select iD  from Coverage_Entitlement_Org__c LIMIT 1];
       
         delete delList;
      
      
          Test.stopTest();
    }
}