@isTest
public class TestGP_WebServiceHelper {
    static testmethod void myTest1(){
        
        GP_Master_Settings__c settings = new GP_Master_Settings__c(Name='Settings');
        insert settings;
        
        String empId = '59JRB2';
        List<Employee__c> empList = new List<Employee__c>();
        Employee__c emp1 = new Employee__c(first_name__c = 'Mark'
                    ,last_Name__c = 'Moser2'
                    ,name = 'Mark Moser2'
                    ,emp_id__c = empId
                    ,email__c = 'mark.moser@morganstanley.com'
                    ,Level_Dsc_Job__c = 'Contingent'
                    );
        Employee__c emp2 = new Employee__c(first_name__c = 'Mark'
                    ,last_Name__c = 'Moser2'
                    ,name = 'Mark Moser2'
                    ,emp_id__c = '123456'
                    ,email__c = 'mark.moser@morganstanley.com'
                    ,Level_Dsc_Job__c = 'Contingent'
                    ,User__c = UserInfo.getUserId()
                    );
        empList.add(emp1);
        empList.add(emp2);
        insert empList;
        
        GP_WebServiceHelper.requestToBeDelegate(empList[0].Id, empId);
        //Rerun to hit existing delegation processing code
        GP_WebServiceHelper.requestToBeDelegate(empList[0].Id, empId);
    }
}