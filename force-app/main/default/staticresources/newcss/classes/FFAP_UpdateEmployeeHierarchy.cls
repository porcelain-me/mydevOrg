// 11/09/2013 RA: Original 
//    A scheduled batch job which scans all of employee records and Update their Branch Manager, Complex Manager and Regional Director.
//
//    NOTE: This batch job should be scheduled to run daily after Employee ETL process completed.   
//


global class FFAP_UpdateEmployeeHierarchy implements Database.Batchable<SObject>, System.Schedulable, database.AllowsCallouts{
    
    
    global set<string> bmTypes = new set<string>();
    global set<string> cmTypes = new set<string>();
    global set<string> rdTypes = new set<string>();
    global set<string> allValidTypes = new set<string>();
    
    global String Type_BM = 'Branch Manager';
    global String Type_CM = 'Complex Manager';
    global String Type_RD = 'Regional Director';
    
    public FFAP_UpdateEmployeeHierarchy(){
        populateJobTitleForType();
    }
    
    
    private void populateJobTitleForType(){
        for(FFAP_JobTitles__c jt : [SELECT Id, Type__c, Job_Title_Desc__c, Job_Title_Code__c
                                       FROM FFAP_JobTitles__c 
                                       Where Is_Active__c = True  
                                       Order By Type__c ASC]){
           
            allValidTypes.add(jt.Job_Title_Code__c);
          
            if(jt.Type__c == Type_BM)
                bmTypes.add(jt.Job_Title_Code__c);
           
            if(jt.Type__c == Type_CM)
                cmTypes.add(jt.Job_Title_Code__c);
           
            if(jt.Type__c == Type_RD)
                rdTypes.add(jt.Job_Title_Code__c);
                
        }
         
      }
    
    global Database.QueryLocator start(Database.BatchableContext c) {    
        // Query on employee object based on all valid type
        string query =  'SELECT Id, Dept_Org__c, cost_center__c, Dept_Dsc_Org__c, Emp_ID__c, Job_Title_Dsc_Job__c, Sub_Depart2_Org__c, Sub_Depart2_Dsc_Org__c, '+
                          'Subdept_Org__c, Subdept_Dsc_Org__c, Manager__c, Regional_Director__c, Complex_Manager__c, jobcode_job__c '+ 
                       'From Employee__c '+
                       'Where Status__c = \'Active\' and jobcode_job__c in :allValidTypes ';
        //don't fetch employee records if switch is turned off for this batch process
        if(Trigger_Switch__c.getInstance().Is_FFAP_UpdateEmployeeHierarchy_Off__c == true){
            query = 'SELECT Id FROM Employee__c WHERE Id = null';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext c, List<Sobject> objects){
        
        map<string, Id> mapBM = new map<string,Id>();
        map<string, Id> mapCM = new map<string,Id>();
        map<string, Id> mapRD = new map<string,Id>();
        // Prepare a map of unique numbers for Branch Manager, Complex Manager and Regional Director.
        for(SObject s : objects){
            Employee__c emp = (Employee__c)s;
            system.debug('Employee record: '+ emp);
            /*if(emp.cost_center__c != null){
                mapBM.put(emp.cost_center__c, null);
            }*/
            if(emp.Subdept_Org__c != null){
                mapCM.put(emp.Subdept_Org__c, null);
            }
            if(emp.Dept_Org__c != null){
                mapRD.put(emp.Dept_Org__c, null);
            }
        }
        
        //Populate Branch Manager Map with their Employee Id based on their Unique number
        /*for(Employee__c emp : [select id, cost_center__c from Employee__c where cost_center__c in :mapBM.keySet() and jobcode_job__c in :bmTypes and Status__c = 'Active']){
            if(mapBM.containsKey(emp.cost_center__c)){
                mapBM.put(emp.cost_center__c, emp.Id);
            }
        }*/
        
        //Populate Complex Manager Map with their Employee Id based on their Unique number
        for(Employee__c emp : [select id, Subdept_Org__c from Employee__c where Subdept_Org__c in :mapCM.keySet() and jobcode_job__c in :cmTypes and Status__c = 'Active']){
            if(mapCM.containsKey(emp.Subdept_Org__c)){
                mapCM.put(emp.Subdept_Org__c, emp.Id);
            }
        }
        
        //Populate Regional Director Map with their Employee Id based on their Unique number
        for(Employee__c emp : [select id, Dept_Org__c from Employee__c where Dept_Org__c in :mapRD.keySet() and jobcode_job__c in :rdTypes and Status__c = 'Active']){
            if(mapRD.containsKey(emp.Dept_Org__c)){
                mapRD.put(emp.Dept_Org__c, emp.Id);
            }
        }
        
        // Update employee record  with their respective Branch Manager, Complex Manager and Regional Director.
        for(SObject s : objects){
            Employee__c emp = (Employee__c)s;
                          
           /* if(emp.cost_center__c != null && mapBM.containsKey(emp.cost_center__c)){
                emp.Manager__c = mapBM.get(emp.cost_center__c);
            }*/
            if(emp.Subdept_Org__c != null && mapCM.containsKey(emp.Subdept_Org__c)){
                emp.Complex_Manager__c = mapCM.get(emp.Subdept_Org__c);
            }
            if(emp.Dept_Org__c != null && mapRD.containsKey(emp.Dept_Org__c)){
                emp.Regional_Director__c = mapRD.get(emp.Dept_Org__c);
            }
        }
        system.debug('Objects: '+ objects);
        Database.update(objects, false);
    }
    
    global void finish(Database.BatchableContext c){
       
        
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new FFAP_UpdateEmployeeHierarchy(), 200);
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
}