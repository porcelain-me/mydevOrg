@isTest (SeeAllData = false) 
public class PP_RejectioncommentsControllerTest {
	private static User SysUser;
    public PR_Request__c requestDeatils{get;set;}
  
       
    private static testmethod void RejectioncommentsControllerTest(){
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
           system.debug('----------------- Building Location ---------------'+BL);                       
              
           PR_Request__c newPRRequest=PP_TestData.insertPRRequest(empSource,BL);
           system.debug('---------------- PR Request ---------------'+newPRRequest);
           newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2); 
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
             
           Test.startTest();
           PP_RejectioncommentsController RC = new PP_RejectioncommentsController();
           RC.requestId = newPRRequest.id;
           RC.approvalStatus='Started';  
           RC.getApprovalSteps();
           Test.stopTest();
                
      }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
    }
    
}