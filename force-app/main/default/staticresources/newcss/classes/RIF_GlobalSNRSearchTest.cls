@isTest
public class RIF_GlobalSNRSearchTest {
 static testMethod void myTest(){
     
     Test.startTest();  
        
        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator'];
        
        User tempUser = new User(alias = 'newUser', email='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com',
          emailencodingkey='UTF-8', lastname='Testing',
          languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,isActive = true,
          timezonesidkey='America/Los_Angeles', username='TUADMIN' + DateTime.now().format('MMddyyhhmmss') + '@morganstanley.com');
     
        Employee__c emp = new Employee__c();
     
            emp.Emp_ID__c = '77626';
            emp.Name = 'Donna LaGreca';
            emp.Level_Dsc_Job__c = 'Professional';
            emp.Level_Job__c = '30';
            emp.MS_MSSB__c = 'MS';
            emp.Job_Country_Job__c  = 'USA';
            emp.Status__c = 'Active';
            emp.Super_Division__c = '10300';
            emp.Division_Org__c = '89521';
            emp.Super_Depart_Org__c = '10900';
            emp.Dept_Org__c = '81200';
            emp.Subdept_Org__c = '96000';
            emp.Sub_Depart2_Org__c = '98347';
            emp.Cost_Center__c ='Y089';
            emp.User__c = tempUser.id;
         
            insert  emp; 
     
     
       
     
          
 final String PROJECT_BASED_TERMINATION = 'Both';             
     
           
            
            /*****Creating  Project & Severance & Release*****************/
         
            
            Project__c proj = new Project__c();
            proj.name = 'Test Project' ;
            proj.Country__c = 'USA' ; 
            proj.Status__c = 'Active' ;
            proj.Communication_Date__c  = Date.today();
            proj.Termination_Date__c = proj.Communication_Date__c.addDays(15);
            insert proj ;
         RecordType rt = [Select Id from RecordType where Name = 'ROJECT_BASED_TERMINATION' and SobjectType = 'Project__c' limit 1];
           
      Severance_And_Release__c snr = RIF_TestClassUtilities.createTestSR(proj.Id, emp.Id, rt.Id);
            snr.Super_Division__c = '10910';
           snr.Project__c = proj.id;
            
            snr.Employee__c = emp.id ;
         snr.Communication_Date__c  = Date.today();
         snr.Termination_Date__c = SnR.Communication_Date__c.addDays(15);
     
     Project_Decisional_Unit__c pdu = new Project_Decisional_Unit__c();
            pdu.Project__c = proj.id;
            pdu.Decisional_Unit_Name__c = '10910';
            pdu.Employee__c = emp.id;
            pdu.HR_Signatory__c = emp.id;
         Coverage_Entitlement__c covEnt = new Coverage_Entitlement__c();
            covEnt.HR_Name__c = emp.id;
            insert covEnt;
            
            Coverage_Entitlement_Org__c covEntOrg = new Coverage_Entitlement_Org__c();
            covEntOrg.Coverage_Entitlement__c= covEnt.id;
            covEntOrg.Coverage_Entitlement_Type__c= 'Super Division';
            //covEntOrg.Coverage_Entitlement_Org_Code__c= orgCode.id;
            covEntOrg.Org_Hierarchy_Code__c= '10910 - Wealth Management';
            insert covEntOrg;
         
   

       
            pageReference pager = page.RIF_GlobalSNRSearchPage;
     ApexPages.currentPage().getParameters().put('id',emp.id);
     
            Test.setCurrentPage(pager);
     RIF_GlobalSNRSearch glSNRsearch  = new RIF_GlobalSNRSearch();
     
           glSNRsearch.projectName = 'new project';
           glSNRsearch.empId = 'testid';
           glSNRsearch.empName='test employee';
           glSNRsearch.pjtOwnerName='test employee';
           glSNRsearch.prjtStatus='open';
           glSNRsearch.createdByName='test employee';
           glSNRsearch.totalResults=100;
            glSNRsearch.empName = 'test';
     glSNRsearch.projectType = 'Both';
     glSNRsearch.search();
     glSNRsearch.clear();
     glSNRsearch.snrRecordTypes();
     glSNRsearch.getDisablePrevious();
     glSNRsearch.getPrjStatusOptions();
     glSNRsearch.getProjectSelections();
     glSNRsearch.last();
     glSNRsearch.next();
     glSNRsearch.OFFSET = 1;
     glSNRsearch.first();
     glSNRsearch.getDisablePrevious();
     glSNRsearch.needsSNRsShareCheck= true ;
     glSNRsearch.empName = 'test';
     glSNRsearch.projectName = 'ONE_OFF_TERMINATION';
     
     
     
     //RIF_DataUtil.getLoggedInUSerCovEntitlementTypeWithCode()
     final String ONE_OFF_TERMINATION = 'test01'; 
     
    Test.stopTest();
     }
    static testmethod void DisplayWrapper(){
        RIF_GlobalSNRSearch.DisplayWrapper dw = new RIF_GlobalSNRSearch.DisplayWrapper('test','test','test','test','Active',true,true,'test01','testid','prjtid',0);
		/*dw.projectName ='test';
		dw.empMSID ='test';
      	dw.empName ='test';
        dw.projectStatus ='Active';
        dw.snrVisible = true;
        dw.projectVisible = true;
        dw.empVisible = true; 
       	dw.snrId ='test01';
        dw.empId ='testid';
        dw.prjtId ='prjtid';
        dw.index = 0;*/
        
    }
}