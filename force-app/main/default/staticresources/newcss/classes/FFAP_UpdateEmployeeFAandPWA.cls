// 19/09/2013 jaipal: Original 
//    A scheduled batch job which scans all of employee records and Update their FA and PWA flags.
//
//    NOTE: This batch job should be scheduled to run daily after Employee ETL process completed.   


global class FFAP_UpdateEmployeeFAandPWA implements Database.Batchable<SObject>, System.Schedulable, database.AllowsCallouts{
    
    global set<string> faTypes = new set<string>();
    global set<string> pwaTypes = new set<string>();
    global set<string> allValidTypesFunctionCode = new set<string>();

    global String Type_FA = 'Financial Advisor';
    global String Type_PWA = 'Private Wealth Advisor';
    
    public FFAP_UpdateEmployeeFAandPWA(){
        populateFAandPWA();
    }
    
    
    private void populateFAandPWA(){
       for(FFAP_JobTitles__c jt : [SELECT Id, Type__c, Job_Title_Desc__c, Function_Code__c FROM FFAP_JobTitles__c Where Is_Active__c = True Order By Type__c ASC]){
           
            allValidTypesFunctionCode.add(jt.Function_Code__c);
           
            if(jt.Type__c == Type_FA)
                faTypes.add(jt.Function_Code__c);
             
            if(jt.Type__c == Type_PWA)
                pwaTypes.add(jt.Function_Code__c);   
                
        }
         
      }
    
    global Database.QueryLocator start(Database.BatchableContext c) {    
        // Query on employee object based on all valid type
        string query =  'SELECT Id, FFAP_Is_PWA__c, FFAP_Is_FA__c, Job_Function_code__c From Employee__c Where Status__c = \'Active\'  '; 
                       	
        //don't fetch employee records if switch is turned off for this batch process
        if(Trigger_Switch__c.getInstance().Is_FFAP_UpdateEmployeeHierarchy_Off__c == true){
            query = 'SELECT Id FROM Employee__c WHERE Id = null';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext c, List<Sobject> objects){
        
        // Update employee record  with their respective Branch Manager, Complex Manager and Regional Director.
        for(SObject s : objects){
            Employee__c emp = (Employee__c)s;
            
            if(faTypes.contains(emp.Job_Function_code__c)){
                 emp.FFAP_Is_FA__c = true ;
                }
            else{
                 emp.FFAP_Is_FA__c = false ;
        	    } 
                  
            if(pwaTypes.contains(emp.Job_Function_code__c)){
                emp.FFAP_Is_PWA__c = true ; 
            	}
            else{
                 emp.FFAP_Is_PWA__c = false ;
            	} 
            
        }
        system.debug('Objects: '+ objects);
        Database.update(objects, false);
    }
    
    global void finish(Database.BatchableContext c){
       
        
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new FFAP_UpdateEmployeeFAandPWA(), 200);
            System.debug('\n\n==> batchId = ' + batchId);
        }
    }
}