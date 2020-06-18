@isTest (SeeAllData = false) 
public class PP_AdhocReportControllerTest {
    Public String Status{get;set;}
    public String RequestorRegion{get;set;}
    public String RequestType{get;set;}
    public PR_Request__c inputSearchrequest{get;set;}
    public string RequesteeEmployee{get;set;}
    public String DocumentAttached{get;set;}
    public String AssesttagSearch{get;set;}
    public String SerialtagSearch{get;set;}
    static testmethod void PPRecord()
      {
           
         User PPUser = PP_TestData.getSystemAdminTempUser();
         system.debug('-------------User------------'+PPUser); 
         System.runAs(PPUser) 
           { 
             
             User tempUser = PP_TestData.getSystemAdminTempUser();
             system.debug('-----------------User ---------------'+tempUser);
             
             Employee__c empSource1 = PP_TestData.insertManagerEmployee();
             system.debug('-----------------Manager Employee ---------------'+empSource1);
             
             Employee__c empSource = PP_TestData.insertEmployee(empSource1, tempUser);
             system.debug('----------------- Employee ---------------'+empSource);  
             
             Building_Locations__c BL=PP_TestData.insertBuilding();
             system.debug('----------------- Building Location ---------------'+BL);                       
              
           PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           system.debug('---------------- PR Request ---------------'+newPRRequest);
           newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2); 
              
              
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           
              Test.startTest();               
               
               PP_AdhocReportController Ad = new PP_AdhocReportController();
               Ad.inputSearchrequest = newPRRequest; 
               
               Ad.goBackToAdminPage();
               Ad.closewindow();               
               Ad.SelectedEmployee();
               Ad.SearchEmployee();
               
               Ad.RequesteeEmployee = 'Test';
               Ad.FilterEmployee();
               
               Ad.CreatedDateFrom='11/24/2015';
               Ad.CreatedDateTo='11/28/2015';
               Ad.RemovalDateFrom='11/24/2015';
               Ad.RemovalDateTo='11/28/2015';
               Ad.Approvaldatefrom='11/24/2015';
               Ad.ApprovaldateTo='11/28/2015';
               Ad.Status ='Pending Approval';
               Ad.RequestorRegion='APAC';
               Ad.RequestType='MS Office (Most common)';
               newPRRequest.Destination_Details__c = 'Charitable Donation';
               newPRRequest.Equipment_Receipt_Confirm__c = '123'; 
               newPRRequest.ClosedBy__c=userinfo.getUserId();
               newPRRequest.ActualApprover__c=userinfo.getUserId();    
               Ad.DocumentAttached='yes';
               Ad.AssesttagSearch = '123';
               Ad.SerialtagSearch='123';    
               Ad.RequestId='PR-001000';    
               Ad.filterRequest();             
               Ad.exportrequest(); 
               
               Ad.Status ='In Draft';
               Ad.RequestorRegion='EMEA';
               Ad.RequestType='Data Center (EDC only)';
               newPRRequest.Destination_Details__c = 'Disposal';              
               Ad.filterRequest(); 
               Ad.exportrequest(); 
               
               Ad.Status ='Rejected';
               Ad.RequestorRegion='NA';
               Ad.RequestType='Facilities/Move Mgmt (Prop Svcs only)';
               newPRRequest.Destination_Details__c = 'Hiring Agency';              
               Ad.filterRequest();
               Ad.exportrequest();  
               
               Ad.Status ='Closed';              
               newPRRequest.Destination_Details__c = 'Home';              
               Ad.filterRequest(); 
               Ad.exportrequest(); 
               
               Ad.Status ='Recalled';              
               newPRRequest.Destination_Details__c = 'MS Data Center';              
               Ad.filterRequest();
               Ad.exportrequest();  
               
               Ad.Status ='Approved';              
               newPRRequest.Destination_Details__c = 'MS Office Building';              
               Ad.filterRequest(); 
               Ad.exportrequest(); 
               
                
               Ad.Status ='Cancelled';              
               newPRRequest.Destination_Details__c = 'Other';              
               Ad.filterRequest(); 
               Ad.exportrequest(); 
               
               newPRRequest.Destination_Details__c = 'Vendor';              
               Ad.filterRequest(); 
               Ad.exportrequest(); 
               
               Ad.searchAssest();
               Ad.RequestId=null;               
               Ad.filterRequest();
               Ad.exportrequest(); 
           }
         Test.stopTest();
          Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
      }
    
}