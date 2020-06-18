public with sharing class Lp_HomeController1 {
    public boolean showHomePage {get; set;} 
    public String datename {get; set;}
     public Employee__c requestorEmp {get;set;}
     public boolean displayPopup{get;set;}
     public String payment_type{get;set;}
     
     public Employee__c Mydate{get;set;} {
     
     }   
     
    
    public PageReference reset() {
        return null;
    }


    public PageReference next() {
        return null;
    }


    public PageReference save() {
        return null;
    }
    
    public void showPopup()
    {
        displayPopup = true;
    }
    
    
    public void closePopup()
    {
        displayPopup = false;
    }
    


 public LP_HomeController1()
    {
         
   
        
    user u = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email  from user where id = :UserInfo.getUserId()];
    requestorEmp = [select emp_id__c, name,First_Name__c,Middle_Name__c, CC_Region_Org__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                            , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                            , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center__c,Level_Dsc_Job__c,Level_Job__c,Dept_Dsc_Org__c,Cost_Center_Desc__c, Work_Phone__c, Email__c,Is_HR_Partner__c,Status__c,Building_Directory__c 
                            from employee__c where Email__c = :  u.email];  
    
       
    }



}