@isTest (SeeAllData = false) 
public class PRApprovalTriggerTest {
	
     static testmethod void beforeinsert()
     {
         User tempUser = PP_TestData.getSystemAdminTempUser();
         Employee__c empSource1 = PP_TestData.insertManagerEmployee();          	
         Employee__c newEmployee = PP_TestData.insertEmployee(empSource1, tempUser);                          
         Building_Locations__c BL = PP_TestData.insertBuilding();
         
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
   			 /*
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3';
             newPRRequest.CC_WatchList__c='first@morganstanley.com;second@morganstanley.com;third@morganstanley.com';             
             insert newPRRequest;
             */
             PR_Request__c newPRRequest = PP_TestData.insertPRRequest(newEmployee, BL);
             newPRRequest = [SELECT Property_Owner__c FROM PR_Request__c WHERE Id =:newPRRequest.id];
             System.debug('PR_Request__c: ' + newPRRequest.Property_Owner__c);       
             System.assertEquals('Self', newPRRequest.Property_Owner__c);  
             
             
             newPRRequest.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
             newPRRequest.Request_Type__c='Data Center (EDC only)'; 
            
             Test.stopTest();
         }
          Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
             
    }
     static testmethod void afterinsertWatcher()
     {
         User tempUser = PP_TestData.getSystemAdminTempUser();
         Employee__c empSource1 = PP_TestData.insertManagerEmployee();         
         Employee__c newEmployee = PP_TestData.insertEmployee(empSource1, tempUser);                          
         Building_Locations__c BL = PP_TestData.insertBuilding();
         
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
             PR_Request__c newPRRequest = PP_TestData.insertPRRequest(newEmployee, BL);                			 
             /*newPRRequest.Request_Type__c='Data Center (EDC only)';              
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3,User4';
             newPRRequest.CC_WatchList__c='first@morganstanley.com;second@morganstanley.com;third@morganstanley.com;fourth@morganstanley.com';              
             newPRRequest.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';*/             
             newPRRequest.status__c='Recalled';
             update newPRRequest;
             newPRRequest.Status__c='Submitted';                       
             update newPRRequest;
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3';
             newPRRequest.CC_WatchList__c='first@morganstanley.com;second@morganstanley.com;third@morganstanley.com';
             update newPRRequest;
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2';
             newPRRequest.CC_WatchList__c='first@morganstanley.com;second@morganstanley.com';
             update newPRRequest;
             Test.stopTest();
         }
          Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
             
    }
     static testmethod void afterinsertWatcher5()
     {
         User tempUser = PP_TestData.getSystemAdminTempUser();
         Employee__c empSource1 = PP_TestData.insertManagerEmployee();         
         Employee__c newEmployee = PP_TestData.insertEmployee(empSource1, tempUser);                          
         Building_Locations__c BL = PP_TestData.insertBuilding();
         
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
   			 PR_Request__c newPRRequest = PP_TestData.insertPRRequest(newEmployee, BL); 			    
             newPRRequest.Approvers_List__c='first@morganstanley.com;second@morganstanley.com';
             update newPRRequest;  
             
             newPRRequest.Request_Type__c='Data Center (EDC only)';              
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3,User4,User5';
             newPRRequest.CC_WatchList__c='first@morganstanley.com;second@morganstanley.com;third@morganstanley.com;fourth@morganstanley.com;five@morganstanley.com';              
             newPRRequest.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
             newPRRequest.Status__c='Recalled';
             update newPRRequest;
             //newPRRequest.Status__c='Submitted';
             //update newPRRequest;         
             Test.stopTest();
         }
          Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
             
    }
     static testmethod void afterinsertWatcher6()
     {
         User tempUser = PP_TestData.getSystemAdminTempUser();
         Employee__c empSource1 = PP_TestData.insertManagerEmployee();         
         Employee__c newEmployee = PP_TestData.insertEmployee(empSource1, tempUser);                          
         Building_Locations__c BL = PP_TestData.insertBuilding();
         
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
   			 PR_Request__c newPRRequest = PP_TestData.insertPRRequest(newEmployee, BL);                   
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3,User4,User5,User6';
             newPRRequest.CC_WatchList__c='first@mor.com;second@mor.com;third@mor.com;fou@mor.com;five@mor.com;six@mor.com';              
             newPRRequest.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
              newPRRequest.Status__c='Submitted';
             update newPRRequest;
             newPRRequest.Status__c='Cancelled'; 
             newPRRequest.IsAutoCancelled__c=false;
             update newPRRequest;            
             Test.stopTest();
         }
            Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1);   
    }
     static testmethod void afterinsertRequestApprove()
     {
         User tempUser = PP_TestData.getSystemAdminTempUser();
         Employee__c empSource1 = PP_TestData.insertManagerEmployee();         
         Employee__c newEmployee = PP_TestData.insertEmployee(empSource1, tempUser);                          
         Building_Locations__c BL = PP_TestData.insertBuilding();
         
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
   			 PR_Request__c newPRRequest = PP_TestData.insertPRRequest(newEmployee, BL);                
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3,User4,User5,User6,User7';
             newPRRequest.CC_WatchList__c='first@mor.com;second@mor.com;third@mor.com;fou@mor.com;five@mor.com;six@mor.com;sev@mor.com'; 
             newPRRequest.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
             newPRRequest.Status__c='Approved';
             update newPRRequest;
             newPRRequest.Status__c='Approved';              
             update newPRRequest;            
             Test.stopTest();
         }
          Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1);     
    }
     static testmethod void afterinsertRequestReject()
     {
         User tempUser = PP_TestData.getSystemAdminTempUser();
         Employee__c empSource1 = PP_TestData.insertManagerEmployee();         
         Employee__c newEmployee = PP_TestData.insertEmployee(empSource1, tempUser);                          
         Building_Locations__c BL = PP_TestData.insertBuilding();
         
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
   			 PR_Request__c newPRRequest = PP_TestData.insertPRRequest(newEmployee, BL);                 
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3,User4,User5,User6,User7,User8';
             newPRRequest.CC_WatchList__c='first@mor.com;second@mor.com;third@mor.com;fou@mor.com;five@mor.com;six@mor.com;sev@mor.com;eig@mor.com'; 
             newPRRequest.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
             newPRRequest.Status__c='Rejected';
             update newPRRequest;
             newPRRequest.Status__c='Rejected';              
             update newPRRequest;            
             Test.stopTest();
         }
          Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1);     
    }
     static testmethod void afterinsertRequestClosed()
     {
         User tempUser = PP_TestData.getSystemAdminTempUser();
         Employee__c empSource1 = PP_TestData.insertManagerEmployee();         
         Employee__c newEmployee = PP_TestData.insertEmployee(empSource1, tempUser);                          
         Building_Locations__c BL = PP_TestData.insertBuilding();
         
         Test.startTest();   
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
         {
   			 PR_Request__c newPRRequest = PP_TestData.insertPRRequest(newEmployee, BL);               
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3,User4,User5,User6,User7,User8,User9';
             newPRRequest.CC_WatchList__c='first@mor.com;second@mor.com;third@mor.com;fou@mor.com;five@mor.com;six@mor.com;sev@mor.com;eig@mor.com;nin@mor.com';        
             newPRRequest.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
             newPRRequest.Status__c='Submitted';
             newPRRequest.IsAutoColsed__c=false;
             update newPRRequest;
             newPRRequest.Status__c='Closed';              
             newPRRequest.CC_WatcherNames__c='Test User1,Test User2,User3,User4,User5,User6,User7,User8,User9,User10';
             newPRRequest.CC_WatchList__c='first@mor.com;second@mor.com;third@mor.com;fou@mor.com;five@mor.com;six@mor.com;sev@mor.com;eig@mor.com;nin@mor.com;ten@mor.com';        
             update newPRRequest;            
             Test.stopTest();
         }
           Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1);    
    }
}