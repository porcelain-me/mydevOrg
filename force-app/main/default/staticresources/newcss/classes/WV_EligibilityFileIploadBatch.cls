global class WV_EligibilityFileIploadBatch implements Database.batchable<String>, Database.Stateful
{
   public String m_csvFile;
   public String fileId;
   
   global Iterable<String> start(Database.batchableContext batchableContext)
   { 
       return new WV_EligiblityCSVIterator(m_csvFile,'\n');
   }
   
   global void execute(Database.BatchableContext batchableContext, List<String> scope)  {
        if(scope != null && scope.size() >0){
            set<String> MSIDSet=new set<String>(scope);
            List<Employee__c> EmpLst;
            Map<string,Employee__c> EmployeeMap=new Map<string,Employee__c>();
            List<Eligible_Employees__c> eligibleEmployeeList=new List<Eligible_Employees__c>();
            List<Error_Employee__c> ErrorEmployeeList=new List<Error_Employee__c>();            
            
            EmpLst=WV_Utility.getEmployeeListonMSID(MSIDset);
            
            if(EmpLst != null && EmpLst.size() >0){
                for(Employee__c emp:EmpLst){
                    EmployeeMap.put(emp.Emp_ID__c,emp);                        
                }  
            }
            
            for(String msid: scope) {            
               if (msid.replaceAll(',','').trim().length() == 0) continue;
                
               if(EmployeeMap.containsKey(msid)){
                    Eligible_Employees__c e=new Eligible_Employees__c();                
                    e.Employee__c=EmployeeMap.get(msid).id;
                    e.Eligibility__c=fileId;
                    eligibleEmployeeList.add(e);
               }
               else{
                    Error_Employee__c error=new Error_Employee__c();
                    error.name=msid;
                    error.Eligibility__c=fileId;
                    ErrorEmployeeList.add(error);
               }    
                       
           }   
           
           if(eligibleEmployeeList != null && eligibleEmployeeList.size() >0){   
               Database.Insert(eligibleEmployeeList);
               eligibleEmployeeList.clear();
           }
           if(ErrorEmployeeList != null && ErrorEmployeeList.size() >0){
               Database.Insert(ErrorEmployeeList);
               ErrorEmployeeList.clear();
           }
       }
   }
   global void finish(Database.BatchableContext batchableContext){
   
   }
}