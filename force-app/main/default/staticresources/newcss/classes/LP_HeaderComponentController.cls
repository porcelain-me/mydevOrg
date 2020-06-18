public class LP_HeaderComponentController{
public User LoggedInUser {get;set;}    
public Employee__c LoggedinEmployee {get;set;}   
public string OrgName {get; set;}    
public String selectedTab{get;set;}   
public boolean isApproval{get;set;}
public boolean isSecurityAdmin{get;set;}    
public boolean isAdmin{get;set;}
public string PageURL {get; set;}            
Public LP_HeaderComponentController(){
  try{
        isApproval = false;
         isSecurityAdmin= false;            
         selectedTab = ApexPages.Currentpage().getParameters().get('tab');
         PageURL = ApexPages.currentPage().getUrl();
         System.debug('*********************'+PageURL);             
         System.debug('*********************Inside PP_HeaderComponentController:'+selectedTab );
       //   LoggedInUser = PP_Util.getLoggedinUserDetails(UserInfo.getUserId());
      //    LoggedinEmployee = PP_Util.getLoggedinEmployeeDetails(LoggedInUser.email);
                 /*             //for EDC Approver           
                  EDC_Approver__c EDCApprover=EDC_Approver__c.getinstance(LoggedinEmployee.name);
                    //system.debug('Check MSID'+EDCApprover.MS_ID__c+LoggedinEmployee.Emp_ID__c);
                        if(EDCApprover!=null && EDCApprover.MS_ID__c==LoggedinEmployee.Emp_ID__c)
                           { isApproval=true;}                      
                         //for Property service approver            
                          Propert_Service_approvers__c PSApprover=Propert_Service_approvers__c.getinstance(LoggedinEmployee.name);
                            if(PSApprover!=null && PSApprover.MS_ID__c==LoggedinEmployee.Emp_ID__c){
                              isApproval=true; }                         
                        //for standard approver
                       PP_Job_Level_Desc__c SSApprover=PP_Job_Level_Desc__c.getinstance(LoggedinEmployee.Level_Dsc_Job__c);
                          if(SSApprover!=null && LoggedinEmployee.Level_Dsc_Job__c==SSApprover.Name){ 
                                         isApproval=true;             }
                                //For close Request Tab depending upon the permission set 
                     List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
                                system.debug('##lstcurrentUserPerSet' + lstcurrentUserPerSet);
                                          for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
                                         system.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
                                         if(psa.PermissionSet.Name.equals(system.label.PP_Security_Admin))
                                        isSecurityAdmin = true;
                                           else 
                                        isSecurityAdmin = false; 
                                         }  
                                           */ 
        //for admin tab         
        List<PermissionSetAssignment> lstcurrentUserPerSet = [   SELECT Id, PermissionSet.Name,AssigneeId  FROM PermissionSetAssignment   WHERE AssigneeId = :Userinfo.getUserId() ]; 
        system.debug('##lstcurrentUserPerSet' + lstcurrentUserPerSet);
         for (PermissionSetAssignment psa: lstcurrentUserPerSet){
        system.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
        if(psa.PermissionSet.Name.equals(system.label.PP_Security_Admin)){
         isAdmin = true;
        break;          }
         else{ 
         isAdmin = false;
            } 
            } 
        System.debug('*********************Inside PP_HeaderComponentController:isAdmin ::'+isAdmin );
          String urlString=String.ValueOf(URL.getSalesforceBaseUrl());
          if(urlString != null && urlString.toLowercase().contains('dev')){                OrgName='DEV';            } 
            else if(urlString != null && urlString.toLowercase().contains('qa')){                OrgName='QA';            } 
         
         else if(urlString != null && urlString.toLowercase().contains('uat')){                OrgName='UAT';            }
        else{                OrgName='PROD';            }        }       
         Catch(Exception e){            //System.debug('****************exception in header constrctor'+e);       
          }    
          }


}