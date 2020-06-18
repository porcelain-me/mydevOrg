@isTest (SeeAllData = false) 
public class PP_UtilTest {
	
    public static testmethod void PPUtilTest(){
	User SysUser = PP_TestData.getSystemAdminTempUser();
    System.runAs(SysUser)
         {
            
           Employee__c empSource1 = new Employee__c (name = 'Test User1', Status__c='Active',emp_id__c = '15DEF', email__c='SystemAdministrator1@testorg.com',Officer__c='Y');
           insert empSource1;
            
           Employee__c empSource = new Employee__c (name = 'Test User', Status__c='Active',emp_id__c = '15ABC',Manager__c=empSource1.Id, email__c='SystemAdministrator@testorg.com',Officer__c='Y',User__c=SysUser.id);
           insert empSource;
           
           Employee__c empSource2 = new Employee__c (name = 'Test User2', Status__c='Active',emp_id__c = '15ADC',Assignment_Contact_Manager__c=empSource1.Id, email__c='SystemAdministrator@testorg.com',Officer__c='N',User__c=SysUser.id);
           insert empSource2;  
           //Employee__c empSource1 = PP_TestData.insertManagerEmployee();  
           //Employee__c empSource = PP_TestData.insertEmployee(empSource1,SysUser);
  
           //empSource.Manager__r.id = 'Test Manager';
           //update empSource;  
           system.debug('----------------- EmpSource ---------------'+empSource);
           
           Building_Locations__c BL=PP_TestData.insertBuilding();
           system.debug('----------------- Building Location ---------------'+empSource);                       
              
           PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           system.debug('---------------- PR Request ---------------'+newPRRequest);
          
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
		   d.FolderId = UserInfo.getUserId();
           d.Name='TestDoc';  
           insert d;
           
            
             
           Test.startTest();           
           utilmethods(empSource,empSource2,BL,newPRRequest,PropDetail,d);
           
           Test.stopTest();
              Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
                
      }
      
    }
    
     public static void utilmethods(Employee__c empSource,Employee__c empSource2,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
	       
		  
           PP_Util.getProfileOfLoggedInUser();
           PP_Util.getLoggedinUserRecord();
           PP_Util.getLoggedinEmployeeDetailsbyEmpID(empSource.Emp_ID__c);
           PP_Util.isApproverForStandardReq(empSource.Emp_ID__c);
           PP_Util.isApproverForStandardReq(empSource2.Emp_ID__c);
           
           PP_Util.isApproverForEdcORPropSrvcsReq();
           PP_Util.getAllGrpsForUserForEdcORPropSrvcsReq();
           PP_Util.isSecurityAdmin();
           PP_Util.getApproverByEmpIDAndGrpName('PP_EMEA_Data_Center_Approvers');
           PP_Util.getStatusName('Saved');
           PP_Util.getStatusName('Submitted');
           PP_Util.getStatusName('Recalled');
           PP_Util.getStatusName('Approved');
           PP_Util.getStatusName('Closed');
           PP_Util.getStatusName('Cancelled');
           PP_Util.getStatusName('Rejected');
           PP_Util.isLoggedInUserAdmin();
           PP_Util.getInScopeBuildings();
           PP_Util.getAllBuildings();
           PP_Util.getPPRequestDetails(newPRRequest.id);
           PP_Util.getPPSingleRecord(newPRRequest.id);
           PP_Util.getPPropertyDetail(PropDetail.id);
           PP_Util.getIndivBuildingDetail(BL.id);
           PP_Util.getEmployeeRecordbyID(empSource.id);
           PP_Util.getOrgWideEmaillAddresses('Property Pass');
           PP_Util.getPPEmailTemplates();
         
           PP_Util.getPPGrpAppoverByID('PP_EMEA_Data_Center_Approvers',empSource.User__c);
           
               
           PP_Util.getPPGrpApproverEmails('PP_Floor_Security_Group');
           list<Propert_Service_approvers__c> lst = [select name from Propert_Service_approvers__c LIMIT 2];
           
           PP_Util.sortList( lst, 'name', 'asc');
           PP_Util.sortList( lst, 'name', 'desc');
         
           list<Employee__c> emp = [select name from Employee__c LIMIT 2];
           PP_Util.sortList( emp, 'name', 'asc');
           PP_Util.sortList( emp, 'name', 'desc');
    }
}