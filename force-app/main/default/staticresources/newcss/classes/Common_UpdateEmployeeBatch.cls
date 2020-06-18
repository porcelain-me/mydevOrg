// 
// (c) 2014 Appirio, Inc. 
//
// Description : Bulk update of Employees for which user is not created.
//
// 22 Jan 2014 Manisha Gupta Original
//
/***********************************************************************************************
*
* Change Log:
*
*   MRM - 3/4/2015  - never user database saveresult unless you know what you are doing.
*
************************************************************************************************/
global class Common_UpdateEmployeeBatch implements Database.Batchable<SObject>, System.Schedulable{
    
    String queryStr = 'Select Id, Emp_Id__c from Employee__c where User__c = null and Emp_Id__c <> null ';  
     
    global Database.QueryLocator start(Database.BatchableContext c) {
        
        
        return Database.getQueryLocator(queryStr);  
    }
    
    global void execute(Database.BatchableContext c, List<Employee__c> empList){
        map<String,Employee__c> mapEmpIdEmp = new map<String,Employee__c>();
        list<Employee__c> listEmpToUpdate = new list<Employee__c>();
        for(Employee__c emp : empList){
            mapEmpIdEmp.put(emp.Emp_Id__c, emp);
        }
        Employee__c emp;
        for(User usr : [Select Id, Emp_Id__c from User where Emp_Id__c IN : mapEmpIdEmp.keySet()]){
            emp = mapEmpIdEmp.get(usr.Emp_Id__c);
            emp.User__c = usr.Id;
            listEmpToUpdate.add(emp);
        }
        
        if(listEmpToUpdate.size() > 0)
       
            update listEmpToUpdate;
        
        
       
        /*
        if(!listEmpToUpdate.isEmpty()){
            Database.saveResult[] listSR = database.update(listEmpToUpdate);
            for(database.saveResult sr : listSR){
                system.debug('Error while updating emloyees-----' + sr.getErrors());
            }
        }
        */ 
    }
    
    global void finish(Database.BatchableContext c){
    // DET - Pending Jobs for JIRA 7,8 - start
        datetime dt = system.now().addMinutes(5);        
        String sch = dt.second() + ' ' + dt.minute() + ' ' + dt.Hour() + 
                    ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        system.schedule('DE_Batch_ApplyPendingRecords '+datetime.now(), sch, new DE_Sch_ApplyPendingFingerprints());
    // DET - Pending Jobs for JIRA 7,8 - end
    
        //Common User Update Batch - start 6th June 2017
        datetime dt1 = system.now().addMinutes(15);        
        String sch1 = dt1.second() + ' ' + dt1.minute() + ' ' + dt1.Hour() + 
                    ' ' + dt1.day() + ' ' + dt1.month() + ' ? ' + dt1.year();
        system.schedule('Common_UpdateUserBatch '+datetime.now(), sch1, new ScheduleCommon_UpdateUserBatch());
         //Common User Update Batch - End 6th June 2017
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new Common_UpdateEmployeeBatch(), 1000);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    }
}