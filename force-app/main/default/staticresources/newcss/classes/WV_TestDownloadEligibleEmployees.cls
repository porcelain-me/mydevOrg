@istest(SeeAllData=false)

public class WV_TestDownloadEligibleEmployees{

    public testmethod static void Testmethod02(){  
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='test', Last_Name__c='test',Email__c='test@gmail.com',Cost_Center__c='4324',Country_Home__c='IND',Job_Region_Code__c='EU',Officer__c='N',Primary_Pay_Company_Job__c='96',Empl_Class_Job__c='A',Benefit_Program__c='UK',Status__c='Active');
        insert employee;        
        system.assert(employee!=null,'Employee record insert error');
           
        Eligibility__c eligibiltyrule=new Eligibility__c(Cost_Center__c='4324',Home_Country__c='IND',Job_Region__c='EU',Officer__c='N',Pay_Company__c='96',name='Database rules',Database_Driven__c=true,Employee_Class__c='A',Benefit_Program__c='UK');
        insert eligibiltyrule; 
        system.assert(eligibiltyrule!=null,'Rule based eligibility record insert error');
        
        PageReference downloadpage=new PageReference('/apex/WV_DownloadEligibleEmployees?id='+eligibiltyrule.Id);
        Test.setCurrentPage(downloadpage); 
              
        WV_DownloadEligibleEmployeesController eligibilityRule=new WV_DownloadEligibleEmployeesController ();
        eligibilityRule.sendErrorEmail();        
    }
}