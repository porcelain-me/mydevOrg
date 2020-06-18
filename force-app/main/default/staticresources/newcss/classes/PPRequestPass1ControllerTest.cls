@isTest (SeeAllData = false) 
public class PPRequestPass1ControllerTest {

      static testmethod void PPRequestPass()
        {
            Test.startTest();   
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
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
       d.FolderId = UserInfo.getUserId();
           d.Name='TestDoc';  
           insert d;
                
             PR_Request__c returnPRRequest = [select id from PR_Request__c where id = :newPRRequest.id];
             
             PageReference pg=new PageReference('/apex/PP_RequestPass');
             Test.setCurrentPage(pg);
                
             ApexPages.StandardController sc = new ApexPages.StandardController(returnPRRequest); 
             ApexPages.currentPage().getParameters().put('Id',returnPRRequest.id); 
             system.debug('----------------rID------------'+returnPRRequest.id); 
             PPRequestPass1Controller PPC = new PPRequestPass1Controller(sc);
             String rID = returnPRRequest.id;              
             system.debug('----------------rID------------'+rID);   
             PPC.UpdateRequest();
             //  PPC.DocumentLogoUrl='MSLogo1.jpg';
             //PPC.getImageName();   
             //PPC.getDocumentLogoUrl();
                
             
            }
            Test.stopTest();
             Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
        }
       
}