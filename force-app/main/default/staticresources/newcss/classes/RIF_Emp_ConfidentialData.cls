public class RIF_Emp_ConfidentialData {
        //Variables
        public Employee__c empObj{get;set;}
        
        //Getter-Setters
        public boolean showEmpCompDataFlag{get;set;}   
        public RIF_Emp_ConfidentialData (ApexPages.StandardController controller){
            empObj=(Employee__c)controller.getRecord();
            showEmpCompDataFlag=false; 
            empObj=[select id,name,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from employee__c where id=:empObj.id];  
        }
        
        
        public void shareEmpCompData(){
            if(empObj!=null){
                Employee__c  empRecord_loggedInUser=[select id,Emp_ID__c,Super_Division__c,Division_Org__c,Super_Depart_Org__c,Dept_Org__c,Subdept_Org__c,Sub_Depart2_Org__c,Cost_Center__c from Employee__c where User__c=:Userinfo.getuserID()];
                Coverage_Entitlement__c covEntitlementObj=[select id,HR_Name__c,(select id,HR_EmpID__c,Coverage_Entitlement_Type__c,Coverage_Entitlement_Org_Code_Derived__c from HR_Coverage_Orgs__r),HR_EmpID__c from Coverage_Entitlement__c where HR_Name__c=:empRecord_loggedInUser.id limit 1];
                if(covEntitlementObj==null) 
                    showEmpCompDataFlag=true;
                else if(covEntitlementObj!=null && covEntitlementObj.HR_Coverage_Orgs__r.size()>0){
                    System.debug('### covEntitlementObj.HR_Coverage_Orgs__r'+covEntitlementObj.HR_Coverage_Orgs__r);
                    Map <string,string> covTypeToCodeMap= new Map <string,string> ();
                    for(Coverage_Entitlement_Org__c covEntOrg: covEntitlementObj.HR_Coverage_Orgs__r){
                        covTypeToCodeMap.put(covEntOrg.Coverage_Entitlement_Type__c,covEntOrg.Coverage_Entitlement_Org_Code_Derived__c );       
                    }
                    if( (covTypeToCodeMap.containsKey('Super Division')) && (covTypeToCodeMap.get('Super Division').equalsIgnoreCase(empObj.Super_Division__c)) )  
                         showEmpCompDataFlag=true;  
                    else if( (covTypeToCodeMap.containsKey('Division')) && (covTypeToCodeMap.get('Division').equalsIgnoreCase(empObj.Division_Org__c)) )  
                         showEmpCompDataFlag=true; 
                    else if( (covTypeToCodeMap.containsKey('Super Department')) && (covTypeToCodeMap.get('Super Department').equalsIgnoreCase(empObj.Super_Depart_Org__c)) )  
                         showEmpCompDataFlag=true;    
                    else if( (covTypeToCodeMap.containsKey('Department')) && (covTypeToCodeMap.get('Department').equalsIgnoreCase(empObj.Dept_Org__c)) )  
                         showEmpCompDataFlag=true;  
                    else if( (covTypeToCodeMap.containsKey('Sub Department')) && (covTypeToCodeMap.get('Sub Department').equalsIgnoreCase(empObj.Subdept_Org__c)) )    
                         showEmpCompDataFlag=true; 
                    else if( (covTypeToCodeMap.containsKey('Sub Department 2')) && (covTypeToCodeMap.get('Sub Department 2').equalsIgnoreCase(empObj.Sub_Depart2_Org__c)) )      
                        showEmpCompDataFlag=true;
                    else if( (covTypeToCodeMap.containsKey('Cost Center')) && (covTypeToCodeMap.get('Cost Center').equalsIgnoreCase(empObj.Cost_Center__c)) )   
                        showEmpCompDataFlag=true; 
                    
                }
                else if(covEntitlementObj!=null && covEntitlementObj.HR_Coverage_Orgs__r.size()==0)
                    showEmpCompDataFlag=true;  
            }
            
        }

}