public with sharing class XSPartiesInvolvedUtilQueueable1 implements Queueable, Database.AllowsCallouts{
    public list<id> newRecordIDsList = new list<id>();
    public Set<ID> EmployeeIDs = new Set<ID>();
    public list<String> DivisionNames = new list<String>();
    public Set<ID> ParentXSellIDs = new Set<ID>();  
public XSPartiesInvolvedUtilQueueable1(set<Id> EmpID, list<id> newRecordIDsListPara, list<string> DivisionNamesPara, set<ID> ParentXSellIDsPara){
    EmployeeIDs = EmpID;
    newRecordIDsList = newRecordIDsListPara;
    DivisionNames = DivisionNamesPara;
    ParentXSellIDs = ParentXSellIDsPara;
}
public void execute(QueueableContext context) {
    
        list<user> userActiveList = new list<user>();  
        for(Employee__c check :[select User__c, User__r.isActive from Employee__c where Id IN :EmployeeIDs]){
            if(check.User__r.isActive == false) {
                user objuser = new user(Id = check.User__c);
                objuser.isActive = true;
                userActiveList.add(objuser);
            }
         }
        if(userActiveList.size() > 0)
        update userActiveList;   
         
         system.debug('<-----YYYY----->'); 

         // Chain this job to next job by submitting the next job
           ID jobID =System.enqueueJob(new XSPartiesInvolvedUtilQueueable2(EmployeeIDs, newRecordIDsList, DivisionNames, ParentXSellIDs));
     }
}