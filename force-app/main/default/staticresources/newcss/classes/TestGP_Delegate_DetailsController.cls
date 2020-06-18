@isTest
public class TestGP_Delegate_DetailsController{
    static testMethod void myTest(){
    Employee__c emp1 = new Employee__c(first_name__c = 'Sachin'
        ,last_Name__c = 'Tendulkar'
        ,name = 'Sachin Tendulkar'
        ,emp_id__c = '2929'
        ,email__c = 'sachin.tendulkar@morganstanley.com'
        ,Level_Dsc_Job__c = 'Contingent');
                    
        insert emp1; 
    Test.startTest();
        GP_Delegate_DetailsController obj = new GP_Delegate_DetailsController();
        obj.employeeId = emp1.id;
        obj.getdelegatedetails();  
    Test.stopTest();          
    } 
}