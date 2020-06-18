/**
 * This is a batch util class to update all the employee records. 
**/
global class EmployeeUpdateAllBatch implements Database.Batchable<SObject>{
  
  String queryStr = 'Select Id from Employee__c';
  
  global Database.QueryLocator start(Database.BatchableContext c) {
    
      
      return Database.getQueryLocator(queryStr); 
    }
    
    global void execute(Database.BatchableContext c, List<Employee__c> empList){
      
      List<Employee__c> employeeList = new List<Employee__c>();
      
      for(Employee__c e:empList) {
        employeeList.add(e);
      }
      
      update employeeList;
    }
    
    global void finish(Database.BatchableContext c){
      
    }
    
}