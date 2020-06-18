@isTest (SeeAllData = false) 
public class PP_RequestHomeControllerTest {
	private static User SysUser;
    public PR_Request__c requestDeatils{get;set;}
    //public list<addmorerow> innerlist{get;set;}
    public list<String> strUserBelongsToGrp{get;set;}
    
    public static testmethod void PPRequestHomeController(){
	SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
            
          /*  Employee__c empSource1 = new Employee__c (name = 'Test User1', Status__c='Active',emp_id__c = '15DEF', email__c='SystemAdministrator1@testorg.com',Officer__c='Y');
           insert empSource1;
            
           Employee__c empSource = new Employee__c (name = 'Test User', Status__c='Active',emp_id__c = '15ABC',Manager__c=empSource1.Id, email__c='SystemAdministrator@testorg.com',Officer__c='Y',User__c=SysUser.id);
           insert empSource;*/
           User tempUser = PP_TestData.getSystemAdminTempUser();
           system.debug('-----------------User ---------------'+tempUser);
             
           Employee__c empSource1 = PP_TestData.insertManagerEmployee();
           system.debug('-----------------Manager Employee ---------------'+empSource1);
             
           Employee__c empSource = PP_TestData.insertEmployee(empSource1, tempUser);
           system.debug('----------------- Employee ---------------'+empSource);  
             
           
           Building_Locations__c BL=PP_TestData.insertBuilding();
           system.debug('----------------- Building Location ---------------'+empSource);                       
              
           PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           system.debug('---------------- PR Request ---------------'+newPRRequest);
           newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2);
             
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
		   d.FolderId = UserInfo.getUserId();
           d.Name='TestDoc';  
           insert d;
           
           
             
           Test.startTest();           
           advancesearch(tempUser,empSource1,empSource,BL,newPRRequest,PropDetail,d);
           othermethods(tempUser,empSource1,empSource,BL,newPRRequest,PropDetail,d);
           submitConfirm(tempUser,empSource1,empSource,BL,newPRRequest,PropDetail,d);
           submitrequest(tempUser,empSource1,empSource,BL,newPRRequest,PropDetail,d);   
           clearsearch(tempUser,empSource1,empSource,BL,newPRRequest,PropDetail,d); 
           //recallrequestconfirm(tempUser,empSource1,empSource,BL,newPRRequest,PropDetail,d);             
           Test.stopTest();
                
      }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
    }
    public static void advancesearch(User tempUser,Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	       
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
           
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
           PP_RequestHomeController rqust = new PP_RequestHomeController();
           //rqust.ppRequestTotalList = [select id from PR_Request__c where id = :newPRRequest.id LIMIT 1];
           
  		    rqust.strStatusAdvSearch='Submitted';
		    rqust.strReqTypeAdvSearch='MS Office (Most common)';	         
        	rqust.strInputSearch='121';
         	//rqust.strFromBlndgAdvSearch='Test';
         	rqust.strToBlndgAdvSearch='Home';
            rqust.strCreatedStartDtAdvSearch='11/11/2015';
            rqust.strCreatedEndAdvSearch='12/12/2015';
            rqust.strRemovalStartDtAdvSearch='11/11/2015';
            rqust.strRemovalEndDtAdvSearch='12/12/2015';
       	    rqust.isApprover=true;
            rqust.endDateN= 'string';
            rqust.startDateN= 'string';
            rqust.reqnameToClose= 'string';
           //rqust.strUserBelongsToGrp=userBelongsToGrp;
           rqust.advancedSearch(); 
        
           rqust.Beginning();
           
           rqust.advancedSearch();
           //rqust.previous();
           rqust.Next();
           rqust.advancedSearch();
           rqust.End();
         
           rqust.advancedSearch();
           rqust.getDisablePrevious();
           rqust.advancedSearch();
           rqust.getDisableNext();
           rqust.getTotal_size();
                rqust.getPageNumber();
               rqust.getTotalPages();
               rqust.getRowsCount();
               rqust.getCounterValue();
        rqust.advancedSearch();
        
        rqust.strToBlndgAdvSearch = 'ToBuilding';
           rqust.strCreatedStartDtAdvSearch='11/11/2015';
            rqust.strCreatedEndAdvSearch='10/10/2015';
           rqust.advancedSearch();
            rqust.strRemovalStartDtAdvSearch='11/11/2015';
         rqust.strRemovalEndDtAdvSearch='10/10/2015';
        rqust.advancedSearch();
         
           //rqust.strUserBelongsToGrp=userBelongsToGrp;
            
           
    }
    public static void clearsearch(User tempUser,Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	  
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
           /*pg.getParameters().put('id',newPRRequest.id);
           ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
           */  
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
           PP_RequestHomeController rqust = new PP_RequestHomeController();
           //rqust.ppRequestTotalList = [select id from PR_Request__c where id = :newPRRequest.id LIMIT 1];
            
        	Group gr = new Group();
			gr = [SELECT id from Group where DeveloperName = 'PP_Floor_Security_Group' AND Type = 'Regular' limit 1];

			Groupmember grpmember = new GroupMember();
			grpmember.GroupId = gr.id;
			grpmember.UserOrGroupId = userinfo.getuserid();
			insert grpmember;
            //PP_RequestHomeController rqust1 = new PP_RequestHomeController();
            //rqust1.clearSearch();
 		    rqust.isApprover=true;  		   	
            rqust.clearSearch();
           
            
		   
        
  		   rqust.isApprover=true;       
            list<String> strUserBelongsToGrp1 = new list<String>();  
           strUserBelongsToGrp1.add('PP_1585Bway_PropSvcs_Approvers');           
           //rqust.strUserBelongsToGrp.add('PP_1585Bway_PropSvcs_Approvers');           
        
           rqust.clearSearch(); 
      
    }
    public static void othermethods(User tempUser,Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	       
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
           /*pg.getParameters().put('id',newPRRequest.id);
           ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
           */  
           //PP_RequestHomeController1 rqustotherMethod = new PP_RequestHomeController1();
           PP_RequestHomeController rqustotherMethod = new PP_RequestHomeController();
           Employee__c loggedInEmp = empSource;
           
        
           rqustotherMethod.clear();
           //rqustotherMethod.readCellMethod();
           rqustOtherMethod.ViewRequest();
           rqustOtherMethod.NewRequest();
           //rqustOtherMethod.LoadData();
          
        
            rqustOtherMethod.selectedTab='MyRequest';
        	rqustOtherMethod.getSelectedTabName();
            rqustOtherMethod.selectedTab='Admin';
        	rqustOtherMethod.getSelectedTabName();
            rqustOtherMethod.selectedTab='';
        	rqustOtherMethod.getSelectedTabName();
           //rqust.ppRequestTotalList = [select id from PR_Request__c where id = :newPRRequest.id LIMIT 1];
           
  		   rqustOtherMethod.ReqIdToClose=newPRRequest.id;       
           rqustOtherMethod.closeRequest();
           
           rqustOtherMethod.strSearchReq='CreatedDate';
           rqustOtherMethod.findDateField();
           rqustOtherMethod.strSearchReq='';
           rqustOtherMethod.findDateField();
           
           //rqustOtherMethod.recallrequestconfirm();
           
           
           rqustOtherMethod.RequestNoConfirmation();
           rqustOtherMethod.requestnosubmit();
           rqustOtherMethod.searchOpenReqs();
           rqustOtherMethod.confirmclose();
       	    rqustOtherMethod.CloseWindow1();
            rqustOtherMethod.CloseWindow2();
            rqustOtherMethod.CloseWindow3();
           rqustOtherMethod.closewindow4();
         rqustOtherMethod.closewindow5();
           rqustOtherMethod.closewindow6();
           rqustOtherMethod.pageclosereload();
          rqustOtherMethod.pagereload();
          
          system.debug('-------------------------------newPRRequest-------------'+newPRRequest);
          //rqustOtherMethod.submitconfirm();
          rqustOtherMethod.getToBuildingPicklist();
          
         /* rqustOtherMethod.buildingList = [select id,Name, Address1__c,Address2__c,CITY_DESCRIPTION__c  
                             from Building_Locations__c where InScopeFrom__c = true 
                             and PROPERTY_STATUS__c='ACTIVE' order by name asc limit 1];*/
			        
          //rqustOtherMethod.getFromBuildingPicklist();
          rqustOtherMethod.getSearchParams();
        
    }
    public static void submitConfirm(User tempUser,Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	       
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
          
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
        PP_RequestHomeController rqust = new PP_RequestHomeController();
           //rqust.ppRequestTotalList = [select id from PR_Request__c where id = :newPRRequest.id LIMIT 1];
           
           rqust.RequestId = newPRRequest.id;
           
           Property_Detail__c PD = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property1',Property_Name__c='Documents',Description__c='Desc',Boxes__c='1',Items__c='2',Pallets__c='3');
           insert PD;
           system.debug('------------Property Details-----------------'+PD); 
           List<property_Detail__c> ProdDetailslist = [select id,name,Property_Name__c,Description__c,Quantity__c,Boxes__c,Items__c,Pallets__c,UOM__c,Serial_No__c, Asset_Tag__c from property_Detail__c where request_details__c=: rqust.RequestId  and Asset_Tag__c=null and Serial_No__c=null];
        
            
  		   rqust.submitConfirm(); 
           
           
           rqust.RequestId = newPRRequest.id;
           newPRRequest.Property_Owner__c = 'Other';
           newPRRequest.Other_Owners__c=null;
           update newPRRequest;
           rqust.submitConfirm();
         
           rqust.RequestId = newPRRequest.id;           
           newPRRequest.Removal_Type__c='Temporary';           
           newPRRequest.Expected_Return_Date__c=null;
           update newPRRequest;
           rqust.submitConfirm();  
        
           rqust.RequestId = newPRRequest.id;
           newPRRequest.Destination_Details__c='Charitable Donation';
           newPRRequest.Others__c=null;
           update newPRRequest;
           rqust.submitConfirm();
           
           rqust.RequestId = newPRRequest.id;
           newPRRequest.Destination_Details__c='MS Data Center';
           newPRRequest.Destination__c =null;
           update newPRRequest;
           rqust.submitConfirm(); 
           
           rqust.RequestId = newPRRequest.id;
           newPRRequest.Destination_Details__c='Vendor';
           newPRRequest.PP_Vendor_Details__c=null;
           update newPRRequest;
           rqust.submitConfirm(); 
        
  		   
    }
    public static void submitrequest(User tempUser,Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	       
		   //PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           //Test.setCurrentPage(pg);
          
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
        PP_RequestHomeController rqust = new PP_RequestHomeController();
           newPRRequest.submitted_date__c=system.today();
           newPRRequest.Status__c = 'Recalled';  
           newPRRequest.Destination_Details__c = 'Home';           
           update newPRRequest;
           system.debug('---------------SubmitRequest Details---------------------'+newPRRequest);
           
           
        
          /* if([select count() from ProcessInstance where targetobjectid=:newPRRequest.id] < 1)
        	{       
            
            Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
            request.setObjectId(newPRRequest.id); 
            //request.nextApproverIds = a;
            //system.debug('******************userID in Approval.PRocessresult in SubmitRequest:'+userId);
            //request.setNextApproverIds(new Id[] {userid});
            request.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            Approval.ProcessResult result   =   Approval.process(request); 
        	}
        */
           rqust.RequestId = newPRRequest.id; 
           //rqust.recallRequest();
           //rqust.userid = tempUser.id;
           
           
  		   rqust.submitRequest();
           
    }    
    public static void recallrequestconfirm(User tempUser,Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	       
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
           
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
           PP_RequestHomeController rqust = new PP_RequestHomeController();
           
          
           newPRRequest.Status__c='Submitted';
           update newPRRequest;
           system.debug('---------------SubmitRequest Details---------------------'+newPRRequest);
        
           rqust.RequestId = newPRRequest.id; 
           rqust.recallrequestconfirm();
        
           newPRRequest.Status__c='Approved';
           update newPRRequest;
           rqust.recallrequestconfirm();
           
    }
    public static testmethod void recallrequest(){
	       
		   //PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           //Test.setCurrentPage(pg);
           
           SysUser = PP_TestData.getSystemAdminTempUser();
   		   System.runAs(SysUser)
         {
           
           User tempUser = PP_TestData.getSystemAdminTempUser();
           system.debug('-----------------User ---------------'+tempUser);
             
           Employee__c empSource1 = PP_TestData.insertManagerEmployee();
           system.debug('-----------------Manager Employee ---------------'+empSource1);
             
           Employee__c empSource = PP_TestData.insertEmployee(empSource1, tempUser);
           system.debug('----------------- Employee ---------------'+empSource);  
             
           
           Building_Locations__c BL=PP_TestData.insertBuilding();
           system.debug('----------------- Building Location ---------------'+empSource);                       
              
           PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           system.debug('---------------- PR Request ---------------'+newPRRequest);
           newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2);
             
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
           PP_RequestHomeController rqust = new PP_RequestHomeController();
           
           
           newPRRequest.Status__c='Saved';
           update newPRRequest;
           system.debug('---------------SubmitRequest Details---------------------'+newPRRequest);
           
         
            
        
          if([select count() from ProcessInstance where targetobjectid=:newPRRequest.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(newPRRequest.Id);

            //Submit the approval request
            Approval.ProcessResult result = Approval.process(req);

        }
        newPRRequest.Status__c='Submitted';
        update newPRRequest;
        rqust.RequestId = newPRRequest.id;   
        rqust.recallrequest();
             
             
             
           rqust.recallrequestconfirm();
        
           newPRRequest.Status__c='Approved';
           update newPRRequest;
           rqust.recallrequestconfirm();
             
         }    
         Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
    }
    /*public static testmethod void NonPRrequest(){
	       
		   //PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           //Test.setCurrentPage(pg);
           
           SysUser = PP_TestData.getSystemAdminTempUser();
   		   System.runAs(SysUser)
         {
           
           User tempUser = PP_TestData.getSystemAdminTempUser();
           system.debug('-----------------User ---------------'+tempUser);
            
             
           Employee__c empSource1 = PP_TestData.insertManagerEmployee();
           system.debug('-----------------Manager Employee ---------------'+empSource1);
             
           Employee__c empSource = PP_TestData.insertEmployee(empSource1, tempUser);
           system.debug('----------------- Employee ---------------'+empSource);  
             
           
           Building_Locations__c BL=PP_TestData.insertBuilding();
           system.debug('----------------- Building Location ---------------'+empSource);                       
              
           PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           system.debug('---------------- PR Request ---------------'+newPRRequest);
           newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           newPRRequest.Employee_Requestee_Name__c = empSource.id;  
           newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2);
            newPRRequest.Request_Type__c='Facilities/Move Mgmt (Prop Svcs only)';
            newPRRequest.submitted_date__c=system.today();
           newPRRequest.Status__c = 'Recalled';  
           newPRRequest.Destination_Details__c = 'Home';            
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
           PP_RequestHomeController rqust = new PP_RequestHomeController();
           rqust.RequestId = newPRRequest.id; 
             system.debug('---------------SubmitRequest Details---------------------'+newPRRequest);
 			rqust.submitRequest();	
          
         }    
         Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
    }
    */
    public static void advancesearch1(User tempUser,Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	       
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
           
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
           PP_RequestHomeController rqust = new PP_RequestHomeController();
           //rqust.ppRequestTotalList = [select id from PR_Request__c where id = :newPRRequest.id LIMIT 1];
           
  		   rqust.strStatusAdvSearch='Submitted';
		   rqust.strReqTypeAdvSearch='MS Office (Most common)';	         
        	rqust.strInputSearch='121';
         	rqust.strFromBlndgAdvSearch='Test';
         	rqust.strToBlndgAdvSearch='Home';
            rqust.strCreatedStartDtAdvSearch='11/11/2015';
            rqust.strCreatedEndAdvSearch='12/12/2015';
            rqust.strRemovalStartDtAdvSearch='11/11/2015';
         rqust.strRemovalEndDtAdvSearch='12/12/2015';
         rqust.isApprover=true;
           //rqust.strUserBelongsToGrp=userBelongsToGrp;
           rqust.advancedSearch(); 
        
           rqust.Beginning();
           
           rqust.advancedSearch();
           rqust.previous();
           rqust.Next();
           rqust.advancedSearch();
           rqust.End();
         
           rqust.advancedSearch();
           rqust.getDisablePrevious();
           rqust.advancedSearch();
           rqust.getDisableNext();
           rqust.getTotal_size();
                rqust.getPageNumber();
               rqust.getTotalPages();
               rqust.getRowsCount();
               rqust.getCounterValue();
        rqust.advancedSearch();
        rqust.strFromBlndgAdvSearch='Test1';
        rqust.strToBlndgAdvSearch = 'ToBuilding';
           rqust.strCreatedStartDtAdvSearch='11/11/2015';
            rqust.strCreatedEndAdvSearch='10/10/2015';
           rqust.advancedSearch();
            rqust.strRemovalStartDtAdvSearch='11/11/2015';
         rqust.strRemovalEndDtAdvSearch='10/10/2015';
        rqust.advancedSearch();
         PP_RequestHomeController rqustotherMethod = new PP_RequestHomeController();
          /* rqustOtherMethod.buildingList = [select id,Name, Address1__c,Address2__c,CITY_DESCRIPTION__c  
                             from Building_Locations__c where InScopeFrom__c = true 
                             and PROPERTY_STATUS__c='ACTIVE' order by name asc limit 1];
			        
          rqustOtherMethod.getFromBuildingPicklist();*/
           //rqust.strUserBelongsToGrp=userBelongsToGrp;
            
           
    }
    
    public static testmethod void clearsearchElse(){
	  
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
           //pg.getParameters().put('id',newPRRequest.id);
           //ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
             
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
          /* PP_RequestHomeController rqust = new PP_RequestHomeController();
           //rqust.ppRequestTotalList = [select id from PR_Request__c where id = :newPRRequest.id LIMIT 1];*/
            
        	Group gr = new Group();
			gr = [SELECT id from Group where DeveloperName = 'PP_Floor_Security_Group' AND Type = 'Regular' limit 1];

			Groupmember grpmember = new GroupMember();
			grpmember.GroupId = gr.id;
			grpmember.UserOrGroupId = userinfo.getuserid();
			insert grpmember;
        test.startTest();
            PP_RequestHomeController rqust1 = new PP_RequestHomeController();
            rqust1.clearSearch();
 		    rqust1.isApprover=false;  		   	
            //rqust.clearSearch();
           
            
		   
        
  		   //rqust.isApprover=true;       
            list<String> strUserBelongsToGrp = new list<String>();  
           //strUserBelongsToGrp1.add('PP_1585Bway_PropSvcs_Approvers');           
        //rqust1.strUserBelongsToGrp=userBelongsToGrp;   
        //rqust1.strUserBelongsToGrp.add('PP_1585Bway_PropSvcs_Approvers');           
        
          // rqust.clearSearch(); 
      test.stopTest();
    }
    public static testmethod void clearsearchElseIf(){
	  
		   PageReference pg=new PageReference('/apex/PP_RequestHome?retURL=test');
           Test.setCurrentPage(pg);
           //pg.getParameters().put('id',newPRRequest.id);
           //ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
             
           //PP_RequestHomeController1 rqust = new PP_RequestHomeController1();
          /* PP_RequestHomeController rqust = new PP_RequestHomeController();
           //rqust.ppRequestTotalList = [select id from PR_Request__c where id = :newPRRequest.id LIMIT 1];*/
            
        	Group gr = new Group();
			gr = [SELECT id from Group where DeveloperName = 'PP_Floor_Security_Group' AND Type = 'Regular' limit 1];

			Groupmember grpmember = new GroupMember();
			grpmember.GroupId = gr.id;
			grpmember.UserOrGroupId = userinfo.getuserid();
			//insert grpmember;
        test.startTest();
            PP_RequestHomeController rqust1 = new PP_RequestHomeController();
            rqust1.clearSearch();
 		    rqust1.isApprover=false; 
            //rqust1.isSecurityAdmin=false; 		   	
            //rqust.clearSearch();
            /* rqust1. = [select id,Name, Address1__c,Address2__c,CITY_DESCRIPTION__c  
                             from Building_Locations__c where InScopeFrom__c = true 
                             and PROPERTY_STATUS__c='ACTIVE' order by name asc limit 1];
			        
          rqust1.getFromBuildingPicklist();*/
            
		   
        
  		   //rqust.isApprover=true;       
            list<String> strUserBelongsToGrp = new list<String>();  
           //strUserBelongsToGrp1.add('PP_1585Bway_PropSvcs_Approvers');           
        //rqust1.strUserBelongsToGrp=userBelongsToGrp;   
        //rqust1.strUserBelongsToGrp.add('PP_1585Bway_PropSvcs_Approvers');           
        
          // rqust.clearSearch(); 
      test.stopTest();
    } 
}