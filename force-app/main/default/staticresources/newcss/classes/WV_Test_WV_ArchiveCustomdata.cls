@isTest(SeeAllData=false)
public class WV_Test_WV_ArchiveCustomdata {
    
    public testmethod static void Testmethod01(){
        Employee__c employee=new employee__C(name='my name',emp_Id__c='mytest',First_Name__c='test', Last_Name__c='test',Email__c='test@gmail.com',Cost_Center__c='4324',Country_Home__c='IND',Job_Region_Code__c='EU',Officer__c='N',Primary_Pay_Company_Job__c='96',Empl_Class_Job__c='A',Benefit_Program__c='UK',Status__c='Active');
        insert employee;
        
        Custom_Data_upload_file__c custom=new Custom_Data_upload_file__c(Columns__c='msid->MSID__c,Optioned Choosed New->Text1__c',File_Type__c='Text');
        insert custom;
        
        Wav_Custom_data__c customDataEach=new Wav_Custom_data__c(File_Upload__c=custom.Id,MSID__c='test');
        insert customDataEach;
        
        Eligibility__c eligibility=new Eligibility__c();
        insert eligibility;
        
        Eligible_Employees__c eligibleEmployees=new Eligible_Employees__c(Employee__c=employee.Id,Eligibility__c=eligibility.Id);
        insert eligibleEmployees;
        
        Error_Employee__c errorEmployees=new Error_Employee__c(name='test',Eligibility__c=eligibility.Id);
        insert errorEmployees;
        
        Database.ExecuteBatch(new WV_ArchiveCustomdata());
        
        Database.ExecuteBatch(new WV_ArchiveEligibleEmployees());        
        
        Database.ExecuteBatch(new WV_ArchiveErrorEmployees());
    }


}