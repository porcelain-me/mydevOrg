public class PP_SearchRequestorController
{
//Logged in UserId

public PPR_NewRequest classVar{get;set;}
public PR_Request__c requestDeatils{get;set;}
 

//On BehalfOf Name
Public String RequesteeEmployee{get;set;}
Public String RequesteeEmployeeID{get;set;}
//Self
Public String RequestorEmployee{get;set;}

public PP_SearchRequestorController(){
classVar=new PPR_NewRequest();
requestDeatils=new PR_Request__c();
User u = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
 
 //get the employee related to the user
 
Employee__C RequestorEmployee1 = [select id,emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where Emp_ID__c = :  u.Emp_Id__c];                         
              
            
 classVar.requestDeatils.Employee_Requestor_Name__c = RequestorEmployee1.id;                  
 RequestorEmployee=RequestorEmployee1.name;

}


public list<Employee__C> EmployeeList{get;set;}
public boolean showReqpopup{get;set;}
public Pagereference SearchEmployee(){
showReqpopup=true;
Return null;
}
public Pagereference CloseWindow(){
showReqpopup=false;
return null;
}

public pagereference FilterEmployee(){
system.debug('id & Name'+RequesteeEmployee+RequesteeEmployeeID);
 String Query='select id,emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where'; 
             if(RequesteeEmployee!=null && RequesteeEmployeeID!=''){
              Query+=' name like \'%'+RequesteeEmployee+'%\' and emp_id__c=\''+RequesteeEmployeeID +'\' ';
             }
             else if(RequesteeEmployee!=null && RequesteeEmployeeID==''){
             system.debug('check the employee'+RequesteeEmployee);
             Query+=' name like \'%'+RequesteeEmployee+'%\' ';
             }
             else if(RequesteeEmployeeID!=null && RequesteeEmployee==null){
              Query+=' emp_id__c=\''+RequesteeEmployeeID +'\' ';
             }
              if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            //Or else Error Message to display..,
            EmployeeList=null;
        }
        else{
            Query+=' order by createdDate desc ';
            EmployeeList=(List<Employee__C>)Database.Query(Query);
            system.debug('list'+EmployeeList);           
        }
        return null;
}
public pagereference SelectedEmployee(){
showReqpopup=false;
return null;
}



}