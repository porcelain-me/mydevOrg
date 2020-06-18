@isTest (SeeAllData = false) 
public class PP_CreateRequestControllerTest {
    private static User SysUser;
    public PR_Request__c requestDeatils{get;set;}
             
    public static testmethod void removerow(){
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
           
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           
           Property_Detail__c PropDetail1 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property2',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
           insert PropDetail1;
           system.debug('---------------- Prop Detail 1---------------'+PropDetail1); 
             
           
            Property_Detail__c PropDetail2 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property3',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
           insert PropDetail2;
           system.debug('---------------- Prop Detail 2---------------'+PropDetail2); 


             
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',newPRRequest.id);
           
          
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
            //sDocument sdoc = new PP_CreateRequestController.sDocument.sDocument();
            //PP_CreateRequestController.sDocument sdoc = new PP_CreateRequestController.sDocument();
         
           crtReq.requestorEmp = empSource;           
           crtReq.requestDeatils = newPRRequest; 
           crtReq.propertyToDel=1;
           crtReq.removeRow(); 

         }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
    }    
    
    
    
     
    public static testmethod void submitrequest(){
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
           
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Property_Detail__c PropDetail1 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property2',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
           insert PropDetail1;
           system.debug('---------------- Prop Detail 1---------------'+PropDetail); 
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
           d.FolderId = UserInfo.getUserId();
           d.Name='propertyfile.csv';             
           d.Type='csv';  
           insert d;
             
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',newPRRequest.id);
           
          
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
           crtReq.requestorEmp = empSource;           
           crtReq.requestDeatils = newPRRequest; 
           //crtReq.ProdDetails1 =   PropDetail;
           crtReq.doc = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           crtReq.attachments  = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           
           crtReq.RequestorEmployee = 'RequestorEmployee';  
           crtReq.requestDeatils.CC_WatcherNames__c='first@first.com';
           crtReq.requestDeatils.CC_WatchList__c='first@first.com';           
           crtReq.CurrentManager='Manager';
           crtReq.requestDeatils.Property_Owner__c='Self'; 
           
           crtReq.showAddOthers=false;
           crtReq.requestDeatils.Other_Owners__c=null;
           crtReq.jobregion= true;
            crtReq.ER_FulFillmentManager='string';
             crtReq.docContentType='docContent';
            crtReq.setActorname='name';
           //crtReq.removaldate = Date.today();
           crtReq.removeDateStr= '10/10/2016';
           crtReq.requestDeatils.Removal_Date__c=Date.today(); 
           crtReq.ReturnDate=true;
           crtReq.returnDateDt = '11/11/2016'; 
           crtReq.requestDeatils.Expected_Return_Date__c=Date.today().adddays(+1);
           
           crtReq.requestDeatils.ActualApprover__c = tempUser.id;
           crtReq.submitRequest(); 
           
           
         }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
    }    
    
    public static testmethod void approverequest(){
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
           newPRRequest.Status__c='Saved';            
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Property_Detail__c PropDetail1 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property2',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
           insert PropDetail1;
           system.debug('---------------- Prop Detail 1---------------'+PropDetail); 
             
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
           d.FolderId = UserInfo.getUserId();
           d.Name='propertyfile.csv';            
           d.Type='csv';  
           insert d;
                    
           PP_CreateRequestController crtReq = new PP_CreateRequestController();          
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           ApexPages.currentPage().getParameters().put('id',newPRRequest.id);
           
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
            crtReq.approveRequest();
           
         }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
    } 
    public static testmethod void Rejectrequest(){
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
           //newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           //newPRRequest.Expected_Return_Date__c=Date.today().addDays(+2); 
           newPRRequest.Status__c='Saved';
            
           update newPRRequest;
           system.debug('---------------- PR Request ---------------'+newPRRequest);  
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
          Property_Detail__c PropDetail1 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property2',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
            insert PropDetail1;
           system.debug('---------------- Prop Detail 1---------------'+PropDetail); 
             
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
           d.FolderId = UserInfo.getUserId();
           d.Name='propertyfile.csv';  
           //d.ContentType='image/png';
           d.Type='csv';  
           insert d;
             
           
           //ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
             
          // PP_CreateRequestController1 crtReq = new PP_CreateRequestController1();
            PP_CreateRequestController crtReq = new PP_CreateRequestController();          
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
            ApexPages.currentPage().getParameters().put('id',newPRRequest.id);
             
           
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
        
             
           
           crtReq.approvalcomments='Rejected';
           crtReq.RejectRequest();
         }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
    } 
    
     public static testmethod void recallrequest(){
       
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
           PP_CreateRequestController rqust = new PP_CreateRequestController();
           
           
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
        //rqust.RequestId = newPRRequest.id; 
        rqust.requestDeatils = newPRRequest;
        ApexPages.currentPage().getParameters().put('Id',newPRRequest.id);  
        rqust.recallrequest();
             
         
             
         }    
         Integer i = [SELECT COUNT() FROM PR_Request__c];
              System.assertEquals(i, 1); 
    }
    
    private static testmethod void PPCreateRequestController(){
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
               
               Property_Detail__c PropDetail1 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property2',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
               insert PropDetail1;
               system.debug('---------------- Prop Detail 1---------------'+PropDetail); 
                 
               Document d = new Document();           
               d.AuthorId = UserInfo.getUserId();
               d.FolderId = UserInfo.getUserId();
               d.Name='propertyfile.csv';            
               d.Type='csv';  
               insert d;          
                 
               Test.startTest();
                   othermethods(empSource1,empSource,BL,newPRRequest,PropDetail,d);
                   doValidation(empSource1,empSource,BL,newPRRequest,PropDetail,d);
                   saverequest(empSource1,empSource,BL,newPRRequest,PropDetail,d);           
                   CloseConfirm(empSource1,empSource,BL,newPRRequest,PropDetail,d);  
               Test.stopTest();
                  Integer i = [SELECT COUNT() FROM PR_Request__c];
                System.assertEquals(i, 1);
                
        }
    }
    
    public static void othermethods(Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
        
           PropDetail.Asset_Tag__c=null;
           PropDetail.Serial_No__c=null;
           update PropDetail;
        
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',newPRRequest.id);
           ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
             
           //PP_CreateRequestController1 crtReq = new PP_CreateRequestController1();
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
          
          
          
           crtReq.requestorEmp = empSource;           
           crtReq.requestDeatils = newPRRequest;  
           crtReq.doc = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           crtReq.attachments  = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
             
           
             
            
           //crtReq.removeRow();   
           crtReq.TotalItems();
           crtReq.Totalbox();
           crtReq.TotalPallets();             
           
           crtReq.Addmore(); 
             
           crtReq.addOtherOwner();
           
           crtReq.requestDeatils.Request_Type__c = 'MS Office (Most common)';          
           crtReq.getApproverlookup();  
           crtReq.requestDeatils.Request_Type__c = 'Tech & Data (EDC & EUS only)';  
           crtReq.getApproverlookup();    
           crtReq.requestDeatils.Request_Type__c = 'Facilities/Move Mgmt (Prop Svcs only)';  
           crtReq.getApproverlookup();    
           
           crtReq.saveSelectedApprover();
           crtReq.CloseWindow();
           crtReq.CloseConfirm();
           crtReq.requestDeatils.Request_Type__c = 'Tech & Data (EDC & EUS only)';
           crtReq.requestorEmp.CC_Region_Org__c = 'NA';
           crtReq.requestorEmp.Job_Region_Code__c = 'NA';
           crtReq.changeApprover();
           crtReq.requestDeatils.Request_Type__c = 'Tech & Data (EDC & EUS only)';  
           crtReq.requestorEmp.CC_Region_Org__c = 'EU';
           crtReq.requestorEmp.Job_Region_Code__c = 'EU'; 
           crtReq.changeApprover();
           crtReq.requestorEmp.CC_Region_Org__c = ''; 
           crtReq.changeApprover();
             
           crtReq.requestDeatils.Request_Type__c = 'MS Office (Most common)';
            
           crtReq.changeApprover();
           
           crtReq.pageHome();
           crtReq.pagereload();
        
           crtReq.closepopup();
           
           crtReq.requestDeatils.Removal_Type__c='Temporary';
           crtReq.RemovalType();
           
           crtReq.nameFile='.csv';
           crtReq.UploadCSV=Blob.valueOf('firstname lastname\nTest,Test1,Test2,Test3,123,123');
           crtReq.UploadCSV(); 
           
           crtReq.nameFile='.csv';
           crtReq.UploadCSV=Blob.valueOf('Serial No description asset tag');
           crtReq.UploadCSV(); 
           
           
           crtReq.requestDeatils.Property_Owner__c='Other';
           crtReq.ownerDeatils();
            crtReq.addOtherOwner();
           crtReq.requestDeatils.Destination_Details__c='MS Data Center';
           crtReq.AddDestination();
           crtReq.submitRequest();
           
           crtReq.requestDeatils.Property_Owner__c='Vendor';
           crtReq.ownerDeatils(); 
           crtReq.requestDeatils.Property_Owner__c='';             
           crtReq.ownerDeatils();
         crtReq.showAddFormerEmployee=true;   
        crtReq.requestDeatils.Property_Owner__c='Former Employee or Contractor';
         crtReq.strOtherFormerEmployee=''; 
             crtReq.doValidation(); 

           crtReq.ownerDeatils(); 
           
           crtReq.requestDeatils.Destination_Details__c='Charitable Donation';
           crtReq.AddDestination();
           crtReq.submitRequest();
           crtReq.requestDeatils.Destination_Details__c='Tech & Data (EDC & EUS only)';
           crtReq.AddDestination();
           crtReq.submitRequest();
           crtReq.requestDeatils.Destination_Details__c='Vendor';
           crtReq.AddDestination();
           crtReq.submitRequest();
           crtReq.requestDeatils.Destination_Details__c='Home';
           crtReq.AddDestination();
        //crtReq.deleteRequest();
           crtReq.submitRequest();
           
           crtReq.requestDeatils.Destination_Details__c=''; 
           crtReq.AddDestination();
             
           crtReq.UploadAttachment();
           
           crtReq.Fileselectioattachment();
           crtReq.uploadfileCSV();
           crtReq.downloadCVS();
           crtReq.buildingData();
           crtReq.selectedBuiding();
           crtReq.clear();
           crtReq.takeaction();
           crtReq.searchEmployee();
           crtReq.WatcherEmployee();  
           
           crtReq.watcherEmployee=null;
           crtReq.RequesteeEmployee='T';
           crtReq.FilterWatcherEmployee();
           crtReq.FilterRequestorEmployee();
           crtReq.RequesteeEmployee=null;
           crtReq.watcherEmployee='Te';   
           crtReq.FilterWatcherEmployee();
           crtReq.FilterRequestorEmployee();
           crtReq.watcherEmployee='Test';
           crtReq.RequesteeEmployee='Test';
           crtReq.FilterWatcherEmployee();
           crtReq.FilterRequestorEmployee();
        
        
           crtReq.requestDeatils.Employee_Requestee_Name__c=crtReq.requestDeatils.Employee_Requestor_Name__c;
           crtReq.requestorEmp.Building_Directory__c='Building';
           crtReq.requestDeatils.Location111__c = null;  
           crtReq.SelectedEmployee();  
           crtReq.recallrequestconfirm();
           crtReq.reWork();
           
           crtReq.DeleteConfirm();
           
           crtReq.RequestWithBlankEmailConfirmation();
           
           crtReq.RequestWithBlankEmailConfirmation();
           
           crtReq.AddSource();
           crtReq.selectedBuiding1();
           crtReq.OpenVendorpopup();
           crtReq.OpenPropOwnerVendorPopup();
             
           crtReq.VendorName='Test';
           crtReq.filterVendorData();
           crtReq.VendorName='T';
           crtReq.filterVendorData();
             
           crtReq.vendorNameUi='T';
           crtReq.filterVendorData1();
           crtReq.vendorNameUi='Test';
           crtReq.filterVendorData1();
           
           crtReq.selectedVendor();
           //crtReq.noApproverAvailable();
           
           crtReq.cancelRequest();
           
           crtReq.requestDeatils.Status__c = 'Submitted';
           crtReq.cancelRequest();
            
           //crtReq.CloseConfirm();
           crtReq.CancelConfirm();
           
           
           crtReq.DestinationDetailsName='Destination';  
           crtReq.SearchToBuilding();
           crtReq.DestinationDetailsName='De';
           crtReq.SearchToBuilding();
             
           crtReq.RequestNoConfirmation(); 
           //crtReq.sDocument;
           crtReq.requestDeatils.CC_WatchList__c=null;
           crtReq.lastwatcher=empSource.Emp_ID__c;
            
           crtReq.SelectedEmployee1();
        
           crtReq.requestDeatils.CC_WatcherNames__c='Richa Sharma,Sanjib Ghosh';
           crtReq.requestDeatils.CC_WatchList__c = 'test.test@morganstanley.com';
           crtReq.lastwatcher=empSource.Emp_ID__c;
           crtReq.SelectedEmployee1(); 
          
           
          
           
           //crtReq.RejectRequest(); 
           Attachment a = new Attachment(Name='Attachment1',ParentId=newPRRequest.id,Body = EncodingUtil.base64Decode(newPRRequest.Removal_Purpose__c), ContentType = 'image/jpeg');
           insert a;
           crtReq.AttachmentId=a.id;
           crtReq.DeleteATtachment();
          
           crtReq.DocumentId = d.id;
           crtReq.DeleteATtachment();
       
           Attachment a1 = new Attachment(Name='Attachment2',ParentId=newPRRequest.id,Body = EncodingUtil.base64Decode(newPRRequest.Removal_Purpose__c), ContentType = 'image/jpeg');
           insert a1;
           crtReq.AttachmentId=a1.id; 
           crtReq.DeleteFile();
           
            Document d1 = new Document();           
           d1.AuthorId = UserInfo.getUserId();
           d1.FolderId = UserInfo.getUserId();
           d1.Name='TestDoc';  
           insert d1;
           crtReq.DocumentId = d1.id;
           crtReq.DeleteFile();
        
           crtReq.deletedocs();
        
           
           
           crtReq.closeRequest();
      
    }
    public static void saverequest(Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',newPRRequest.id);
           ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
           
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
          
           crtReq.requestorEmp = empSource;           
           crtReq.requestDeatils = newPRRequest;  
           //crtReq.listofDeatisl = [select id,name,Property_Name__c,Description__c,Boxes__c,Items__c,Pallets__c from Property_Detail__c where id = :PropDetail.id LIMIT 1]; 
           crtReq.doc = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           crtReq.attachments  = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
               
           crtReq.removeDateStr=null;
           crtReq.ReturnDate=true;
           crtReq.returnDateDt=null; 
           crtReq.requestDeatils.Request_Type__c='MS Office (Most common)';  
           crtReq.saveRequest(); 
      
           
    }     
    public static void doValidation(Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
    
           
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',newPRRequest.id);
           ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
           
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
           crtReq.requestorEmp = empSource;           
           crtReq.requestDeatils = newPRRequest;  
           //crtReq.listofDeatisl = [select id,name,Property_Name__c,Description__c,Boxes__c,Items__c,Pallets__c from Property_Detail__c where id = :PropDetail.id LIMIT 1]; 
           crtReq.doc = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           crtReq.attachments  = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
          
           crtReq.RequestorEmployee = null;
           crtReq.requestDeatils.CC_WatcherNames__c='WatcherNames';  
           crtReq.requestDeatils.CC_WatchList__c=null;
           crtReq.requestDeatils.Request_Type__c=null;
           crtReq.CurrentManager=null;
           crtReq.requestDeatils.Property_Owner__c=null;
           crtReq.requestDeatils.Property_Owner__c='';  
           crtReq.showAddOthers=true;
           //crtReq.requestDeatils.Property_Owner__c='Other';
           crtReq.CurrentManager=null;             
           crtReq.requestDeatils.Removal_Type__c=null;
           crtReq.removeDateStr=null;
           crtReq.ReturnDate=true;
           crtReq.returnDateDt = 'NaN/NaN/NaN';  
           crtReq.requestDeatils.Location111__c=null;
           crtReq.AddSearchbox=true;
           crtReq.AddVendor=true;
           crtReq.AddFreeText=true;
           crtReq.requestDeatils.removal_purpose__c='Removal Purpose';
           //crtReq.innerlist =  PropDetail;   
           crtReq.Addmore();
           crtReq.doValidation();
             
    }     
    public static void CloseConfirm(Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
           
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           
           //PP_CreateRequestController1 rqust = new PP_CreateRequestController1();
            PP_CreateRequestController rqust = new PP_CreateRequestController();
           
          
           newPRRequest.Status__c='Submitted';
           update newPRRequest;
           system.debug('---------------SubmitRequest Details---------------------'+newPRRequest);
            ApexPages.currentPage().getParameters().put('id',newPRRequest.Id);

           //rqust.RequestId = newPRRequest.id; 
           rqust.CloseConfirm();
        
           newPRRequest.Status__c='Approved';
           update newPRRequest;
           rqust.CloseConfirm();
           
    }
    
     public static testmethod void submitrequest1(){
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
           
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Property_Detail__c PropDetail1 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property2',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
           insert PropDetail1;
           system.debug('---------------- Prop Detail 1---------------'+PropDetail); 
           Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
           d.FolderId = UserInfo.getUserId();
           d.Name='propertyfile.csv';             
           d.Type='csv';  
           insert d;
             
           list<Propert_Service_approvers__c> PPSApproverList=new   list<Propert_Service_approvers__c>();
           Propert_Service_approvers__c cs = new  Propert_Service_approvers__c ();
   
           cs.Name='1221_AoA_PropSvcs_Approvers';
           //cs.Other fiels values
           cs.Building__c='1221 Avenue of the Americas';
           cs.MS_ID__c='NA';
           cs.Group_Api_Name__c='PP_1221_AoA_PropSvcs_Approvers';
           PPSApproverList.add(cs);
           insert PPSApproverList;
             
           list<Tech_Data_Approvers__c> EDCANDEUSApprover=new   list<Tech_Data_Approvers__c>();
           Tech_Data_Approvers__c csetts = new  Tech_Data_Approvers__c ();
   
           csetts.Name='EMEA_Data_Center_Approvers';
          
           csetts.Approvers_Group__c='1221 Avenue of the Americas';
           
           csetts.Group_Api_Name__c='PP_EMEA_Data_Center_Approvers';
           EDCANDEUSApprover.add(csetts);
           insert EDCANDEUSApprover;  
             
             
             
  
             
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',newPRRequest.id);
           
          
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
           crtReq.requestorEmp = empSource;           
           crtReq.requestDeatils = newPRRequest; 
           //crtReq.ProdDetails1 =   PropDetail;
           crtReq.doc = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           crtReq.attachments  = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           
           crtReq.RequestorEmployee = 'RequestorEmployee';  
           crtReq.requestDeatils.CC_WatcherNames__c='first@first.com';
           crtReq.requestDeatils.CC_WatchList__c='first@first.com';           
           crtReq.CurrentManager='Manager';
           crtReq.requestDeatils.Property_Owner__c='Self';  
           crtReq.showAddOthers=false;
           crtReq.requestDeatils.Other_Owners__c=null;
             
           //crtReq.removaldate = Date.today();
           crtReq.removeDateStr= '10/10/2016';
           crtReq.requestDeatils.Removal_Date__c=Date.today(); 
           crtReq.ReturnDate=true;
           crtReq.returnDateDt = '11/11/2016'; 
           crtReq.requestDeatils.Expected_Return_Date__c=Date.today().adddays(+1);
           
           crtReq.requestDeatils.ActualApprover__c = tempUser.id;
           crtReq.submitRequest(); 
           
           
         }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
    }    
    /*public static testMethod void myTest() {
    list<Propert_Service_approvers__c> PPSApproverList=new   list<Propert_Service_approvers__c>();
   Propert_Service_approvers__c cs = new  Propert_Service_approvers__c ();
   
        cs.Name='1221_AoA_PropSvcs_Approvers';
        //cs.Other fiels values
        cs.Building__c='1221 Avenue of the Americas';
        cs.MS_ID__c='NA';
        cs.Group_Api_Name__c='PP_1221_AoA_PropSvcs_Approvers';
        PPSApproverList.add(cs);
        insert PPSApproverList;

}*/
 
  public static testmethod void Reworkrequest(){
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
           
               
           Property_Detail__c PropDetail=PP_TestData.insertPD(newPRRequest);
           system.debug('---------------- Prop Detail ---------------'+PropDetail); 
           
           Property_Detail__c PropDetail1 = new Property_Detail__c(Request_Details__c=newPRRequest.id,Name = 'Property2',Property_Name__c='Documents',Description__c='Desc',Boxes__c='2',Items__c='3',Pallets__c='4');
           insert PropDetail1;
           system.debug('---------------- Prop Detail 1---------------'+PropDetail); 
             PR_Request__c reWorkSt  = new PR_Request__c(ReworkComments__c='test',EDC_CloseOut_Approver__c=empSource1.id,Status__c='saved',Removal_Type__c='Permanent',
                          Request_Type__c='MS Office (Most common)',Property_Owner__c='Self',Location111__c= null,Destination_Details__c='Vendor',Removal_Purpose__c = 'test1',
                          Employee_Requestee_Name__c = empSource.Id);
             
           insert reWorkSt;
             system.debug('---------------- reWorkSt ---------------'+reWorkSt);
             Document d = new Document();           
           d.AuthorId = UserInfo.getUserId();
           d.FolderId = UserInfo.getUserId();
           d.Name='propertyfile.csv';             
           d.Type='csv';  
           insert d;
             
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',reWorkSt.id);
           
          
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
           
               
           crtReq.requestorEmp = empSource;
              newPRRequest.Property_Service_Approver__c='PP_1585Bway_PropSvcs_Approvers';
           update newPRRequest;
             crtReq.ReworkRequest();
           //crtReq.ProdDetails1 =   PropDetail;
           crtReq.doc = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           crtReq.attachments  = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           
           crtReq.RequestorEmployee = 'RequestorEmployee';  
           //crtReq.requestDeatils.CC_WatcherNames__c='first@first.com';
           //crtReq.requestDeatils.CC_WatchList__c='first@first.com';           
           crtReq.CurrentManager='Manager';
           crtReq.requestDeatils.Property_Owner__c='Self';  
           crtReq.showAddOthers=false;
           crtReq.requestDeatils.Other_Owners__c=null;
             
           //crtReq.removaldate = Date.today();
           crtReq.removeDateStr= '10/10/2016';
           crtReq.requestDeatils.Removal_Date__c=Date.today(); 
           crtReq.ReturnDate=true;
           crtReq.returnDateDt = '11/11/2016'; 
           crtReq.requestDeatils.Expected_Return_Date__c=Date.today().adddays(+1);
           
           crtReq.requestDeatils.ActualApprover__c = tempUser.id;
           crtReq.submitRequest(); 
           
           
         }
         Integer i = [SELECT COUNT() FROM PR_Request__c];
            System.assertEquals(i, 1);
           //crtReq.ReworkRequest();  
    } 
    
    
   
public static testmethod void testSomethingInsDocument() {
    SysUser = PP_TestData.getSystemAdminTempUser();
          System.runAs(SysUser)
          {
 Document d1 = new Document();           
           d1.AuthorId = UserInfo.getUserId();
           d1.FolderId = UserInfo.getUserId();
           d1.Name='TestDoc';  
           insert d1;
    


    PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',d1.id);
           
          
          // PP_CreateRequestController crtReq = new PP_CreateRequestController(document);
	PP_CreateRequestController.sDocument b = new PP_CreateRequestController.sDocument(d1);
	
    //b.sDocument();
  }
    
}
    public static void elsemethod (Employee__c empSource1,Employee__c empSource,Building_Locations__c BL,PR_Request__c newPRRequest,Property_Detail__c PropDetail,Document d){
    
           
           PageReference pg=new PageReference('/apex/PP_CreateRequest?retURL=test');
           Test.setCurrentPage(pg);
           pg.getParameters().put('id',newPRRequest.id);
           ApexPages.StandardController sc = new ApexPages.StandardController(newPRRequest);  
           
           PP_CreateRequestController crtReq = new PP_CreateRequestController();
           crtReq.requestorEmp = empSource;           
           /*crtReq.requestDeatils = newPRRequest;
           delete newPRRequest;
           crtReq.deleteRequest();*/
           //crtReq.listofDeatisl = [select id,name,Property_Name__c,Description__c,Boxes__c,Items__c,Pallets__c from Property_Detail__c where id = :PropDetail.id LIMIT 1]; 
           crtReq.doc = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
           crtReq.attachments  = [select id,AuthorId,FolderId,Name from document where id =:d.id LIMIT 1];
          
           crtReq.RequestorEmployee = null;
           crtReq.isBlankEmailAdd = true; 
           crtReq.requestDeatils.CC_WatcherNames__c='WatcherNames';  
           crtReq.requestDeatils.CC_WatchList__c=null;
           crtReq.requestDeatils.Request_Type__c=null;
          
           //crtReq.requestDeatils.Property_Owner__c=null;
           //crtReq.requestDeatils.Property_Owner__c='';  
           crtReq.showAddOthers=true;
           crtReq.Other_Owners ='';
        crtReq.requestDeatils.Property_Owner__c='Other';
        crtReq.doValidation();
        //crtReq.showAddFormerEmployee=true; 
        //crtReq.requestDeatils.Property_Owner__c='Former Employee or Contractor';
        // crtReq.strOtherFormerEmployee=''; 

           crtReq.CurrentManager=null;             
           crtReq.requestDeatils.Removal_Type__c=null;
           crtReq.removeDateStr=null;
           crtReq.ReturnDate=true;
           crtReq.returnDateDt = 'NaN/NaN/NaN';  
           crtReq.requestDeatils.Location111__c=null;
           crtReq.AddSearchbox=true;
           crtReq.AddVendor=true;
           crtReq.AddFreeText=true;
           crtReq.requestDeatils.removal_purpose__c='Removal Purpose';
        
           //crtReq.innerlist =  PropDetail; 
             
           crtReq.Addmore();
           
            
    }   
  }