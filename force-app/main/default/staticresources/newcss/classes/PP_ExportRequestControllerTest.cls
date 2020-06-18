@isTest (SeeAllData = false) 
public class PP_ExportRequestControllerTest 
{
    public String Status{get;set;}
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
            
            //adding data
            
            PP_ExportRequestController exportreq = new PP_ExportRequestController();
            exportreq.requestid = 'PR-005314'; 
            System.debug('******RequestID******'+  exportreq.requestid  );
            exportreq.requestorname = userinfo.getUserId();
            exportreq.requestorcreator = userinfo.getUserId();
            exportreq.requestorregion = 'APAC'; 
            exportreq.requesttype = 'MS Office (Most common)';
            exportreq.createddatefrom = '11/24/2015'; 
            exportreq.createddateto = '11/28/2015'; 
            exportreq.removaldatefrom = '11/24/2015'; 
            exportreq.removaldateto = '11/28/2015'; 
            exportreq.approvaldatefrom = '11/24/2015'; 
            exportreq.approvaldateto = '11/28/2015'; 
            exportreq.status = 'Pending Approval'; 
            exportreq.servicenowortracking = '123'; 
            exportreq.assettag = '123'; 
            exportreq.serialno = '123'; 
            exportreq.closedby = userinfo.getUserId(); 
            exportreq.approver = userinfo.getUserId(); 
            exportreq.fromplace = 'Mumbai Nse Colo'; 
            exportreq.documentattached = 'yes'; 
            exportreq.toplace = 'Charitable Donation'; 
            exportreq.displayrecords(); 
            
            exportreq.status = 'In Draft';
            exportreq.toplace = 'Disposal'; 
            exportreq.displayrecords(); 
            
            exportreq.status = 'Rejected';
            exportreq.toplace = 'Hiring Agency'; 
            exportreq.displayrecords(); 
        
            exportreq.status = 'Recalled';
            exportreq.toplace = 'Home'; 
            exportreq.displayrecords(); 
        
            exportreq.status = 'Closed';
            exportreq.toplace = 'MS Data Center'; 
            exportreq.displayrecords(); 
        
            exportreq.status = 'Approved';
            exportreq.toplace = 'MS Office Building'; 
            exportreq.displayrecords(); 

            exportreq.requestorname = userinfo.getUserId();
            exportreq.requestorcreator = null;
            exportreq.requesttype = 'Facilities/Move Mgmt (Prop Svcs only)';
            exportreq.requestorregion = 'NA'; 
            exportreq.status = 'Cancelled';
            exportreq.toplace = 'Other'; 
            exportreq.displayrecords();
            
            exportreq.requestid = null; 
            exportreq.requestorname = null;
            exportreq.requestorcreator = userinfo.getUserId();
            exportreq.requesttype = 'Data Center (EDC only)';
            exportreq.requestorregion = 'EMEA'; 
            exportreq.status = 'Pending Approval';
            exportreq.toplace = 'Vendor'; 
            exportreq.displayrecords();
        
        

        }

        Test.stopTest();
        Integer i = [SELECT COUNT() FROM PR_Request__c];
        System.assertEquals(i, 1);
    
    }

}