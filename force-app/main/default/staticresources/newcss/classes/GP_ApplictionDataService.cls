//@RestResource(urlMapping='/passes/*')
public with sharing class GP_ApplictionDataService {
    public String inputID {get;set;}
    
    public List<Employee_Vehicle__c> vList {get;set;}
    public String parm1 {get;set;}
    
    public GP_ApplictionDataService() { 
    
    
        User u = [select emp_id__c from User where id = :userinfo.getUserId()];
        
        Employee__c e = [select id from Employee__c where emp_id__c = :u.emp_id__c];
        
        Set<String> empIdSet = new Set<String>();
        
        empIdSet.add(e.id);
        
        vList = new List<Employee_Vehicle__c>();
        
        List<Employee_Delegate__c> dList = new List<Employee_Delegate__c>();
        
        dList = [       Select Delegate__c 
                                 From Employee_Delegate__c e
                                 where employee__c = :e.id
                                 and status__c = 'Approved'
                                 and application__c = 'Global Parking'
                                 ];
                                 
        for (Employee_Delegate__c d:dList)
                empIdSet.add(d.delegate__c);
        
        vList = [Select
                          e.Type__c
                        , e.Status__c
                        , e.State__c
                                , e.Registration_Number__c
                                , e.Name
                                , e.Make_Model__c
                                , e.Id
                                , e.High_Roof__c
                        , e.Employee__c
                                , e.Emp_Id__c
                                , e.Company_Car__c
                                , e.Color__c 
                        From Employee_Vehicle__c e
                        where employee__c in :empIdSet
                        and status__c = 'Active'];
    
    }
    
    /*******************************************************************************************
        * Sample Save
        **********************************************************************************************/
        public pageReference save() {
                
                 
                system.debug('Parm 1 is: ' + parm1);
                return null;
        }
        
                
}