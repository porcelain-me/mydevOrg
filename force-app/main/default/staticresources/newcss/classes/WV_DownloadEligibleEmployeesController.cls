public class WV_DownloadEligibleEmployeesController {
    
    public string selectedEligibilityRecord {get; set;}
    public string employeeQuery {get; set;}
    public string readResult {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}

    public WV_DownloadEligibleEmployeesController (){
        try{
            selectedEligibilityRecord = ApexPages.Currentpage().getParameters().get('Id');
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null;           
            OrgName=Label.ORG_ENVIRONMENT;                 
            readResult='MSID\n';
            
            if(selectedEligibilityRecord != null && selectedEligibilityRecord.trim() != ''){
                List<Eligibility__c> EligibleSchemeListByRules=[select id,name,Benefit_Program__c,Cost_Center__c,Employee_Class__c,Home_Country__c,Job_Region__c,Officer__c,Pay_Company__c from Eligibility__c where Id=:selectedEligibilityRecord];
                employeeQuery='';
                if(EligibleSchemeListByRules != null && EligibleSchemeListByRules.size() != 0){
                    Eligibility__c eligibility = EligibleSchemeListByRules[0];
                    employeeQuery = 'select id,emp_Id__c,inactive__c,Status__c  from employee__c where Status__c = \'Active\' AND';
                    
                    if(eligibility.Benefit_Program__c != null && eligibility.Benefit_Program__c.trim() != ''){
                        set<string> s=new set<string>(eligibility.Benefit_Program__c.split(','));
                        employeeQuery = employeeQuery + ' benefit_Program__c IN:s AND';
                    }
                    
                    if(eligibility.Employee_Class__c != null && eligibility.Employee_Class__c.trim() != ''){
                        set<string> s1=new set<string>(eligibility.Employee_Class__c.split(','));
                        employeeQuery = employeeQuery + ' Empl_Class_Job__c IN:s1 AND';
                    }
                    
                    if(eligibility.Job_Region__c != null && eligibility.Job_Region__c.trim() != ''){
                        set<string> s2=new set<string>(eligibility.Job_Region__c.split(','));
                        employeeQuery = employeeQuery + ' Job_Region_Code__c IN:s2 AND';
                    }
                    
                    if(eligibility.Home_Country__c != null && eligibility.Home_Country__c.trim() != ''){
                        List<String> strHomeCntry = new List<string>(eligibility.Home_Country__c.split(','));                                         
                        set<string> s3=new set<string>(eligibility.Home_Country__c.split(','));
                        employeeQuery = employeeQuery + ' Country_Home__c IN:s3 AND';
                    }
                    
                    if(eligibility.Cost_Center__c != null && eligibility.Cost_Center__c.trim() != ''){
                        set<string> s4=new set<string>(eligibility.Cost_Center__c.split(','));
                        employeeQuery = employeeQuery + ' Cost_Center__c IN:s4 AND';
                    }
                    
                    if(eligibility.officer__c != null && eligibility.officer__c.trim() != ''){
                        set<string> s5=new set<string>(eligibility.officer__c.split(','));
                        employeeQuery = employeeQuery + ' Officer__c IN:s5 AND';
                    }
                    
                    if(eligibility.Pay_Company__c != null && eligibility.Pay_Company__c.trim() != ''){
                        set<string> s6=new set<string>(eligibility.Pay_Company__c.split(','));
                        employeeQuery = employeeQuery + ' Primary_Pay_Company_Job__c IN:s6 AND';
                    }
                    
                    if(employeeQuery.endsWith('AND')){
                        employeeQuery=employeeQuery.removeEnd('AND');
                    } 
                    //Limiting no of records to max limit (1 million)
                    employeeQuery=employeeQuery+' Limit 1000000';
                    
                    system.debug('****formed dynamic employeeQuery'+employeeQuery);
                    if(employeeQuery != null && employeeQuery != ''){
                        for(Sobject[] sobj:Database.Query(employeeQuery)){
                            List<employee__c> empList=(List<employee__c>)sobj;  
                            for(employee__C e:empList){
                                readResult=readResult+'"'+e.emp_Id__c+'"\n';    
                            }                          
                        }
                    }
                } 
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside Constructor'+e.getlinenumber()+'-'+e.getmessage()); 
           exp=e;
        }

    }  
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){    
                WV_Utility.captureExceptionFuture('My Elections','WV_DownloadEligibleEmployees Page','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            } 
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }  
}