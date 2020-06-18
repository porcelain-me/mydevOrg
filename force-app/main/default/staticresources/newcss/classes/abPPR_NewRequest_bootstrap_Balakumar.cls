// Modified by Avinash on 02/03/2016
// looks like a copy of another class

@isTest
public class abPPR_NewRequest_bootstrap_Balakumar {

    public String requestId{get;set;}
    public String nameFile{get;set;}
    Public Blob UploadCSV{get;set;}
    Public User u{get;set;}
    public Employee__c requestorEmp {get;set;}   //requestor
    public Employee__c requesteeEmp {get;set;}   //requestee
    public PR_Request__c requestDeatils{get;set;}
    Public String PropertyOwner{get;set;}
    Public String IsParmanent{get;set;}
    Public list<property_Detail__c> ProdDetailslist{get;set;}
    Public property_Detail__c ProdDetails{get;set;}
    Public boolean ItemNoToRemoved{get;set;}
    Public boolean AddmoreRows{get;set;}
    Public Boolean AddOthers{get;set;}
    Public Boolean showPropOwnerVendor{get;set;}
    Public Boolean ReturnDate{get;set;}
    Public Integer defaultRows{get;set;}
    Public Integer noofrequests{get;set;}                
    public String CurrentManager{get;set;}            
    public boolean showtable{get;set;}
    Public List<Employee__c> ApproverList{get;set;}   
    public list<PR_Request__c > requestList {get;set;}
    public list<EDC_Approver__c> EDCApproverlist{get;set;}
    public list<employee__c> removeWatcher{get;set;}
    //new for edc fulfilment manager..,
    public list<EDC_Group_Fulfillment__c> EDCCloseOutManagerslist{get;set;}
    public string fulfillmanagerName {get; set;}
    public string fulfillmanagerId {get; set;}
    public boolean isEDCRequestFulfillment {get; set;}
    public string ER_FulFillmentManager{get; set;}
    
    public list<Propert_Service_approvers__c> PPSApproverList{get;set;}
    public boolean AddSearchbox{get;set;}
    public boolean AddFreeText{get;set;}
    public boolean AddVendor{get;set;}
     
    public boolean IsApprover{get;set;}
    public String IdPlaceHolder{get;set;}
    Public blob notesAndAttchment{get;set;}
    Public String FileName1{get;set;}
    public String currentManagerId{get;set;}
    public String DestinationDetailsName{get;set;}
    public String RequestTab{get;set;} 
    
    //added for error messages in each inputs for validations.
    public string ER_RequestorEmployee {get; set;}
    public string ER_RequestType {get; set;}
    public string ER_Approver {get; set;} 
    public string ER_PropertyOwner {get; set;}
    public string ER_OtherOwner {get; set;}
    public string ER_CurrentManager {get; set;}
    public string ER_RemovalType {get; set;}
    public string ER_ReturnDate {get; set;}
    public string ER_RemovalDate {get; set;}
    public string ER_To{get; set;}
    public string ER_From {get; set;}
    public string ER_DestinationDetailsName{get; set;} 
    public string ER_Purpose{get; set;} 
    public string ER_EquipReceipt{get; set;} 
    public string ER_CSVUploadError{get; set;}
    
    public static final string MandatoryErrorMessage='Error: You must enter this value.';  
    public static final string MandatoryErrorMessage1='Error: Date should be greater than current date';
    
    public list<Building_Locations__c> buildingList{get;set;} 
    public list<Building_Locations__c> buildingListTo{get;set;} 
    public list<addmorerow> innerlist{get;set;}
    public boolean showEditRecall{get;set;} 
    public string strSearchReq {get; set;}
    public String strInputSearch {get;set;}
    
    public string strStatus {get; set;}
    public boolean isEDCRequest{get;set;}
    public boolean isPropertyservice{get;set;}
    public boolean isStandard{get;set;}
    Public boolean EDCCloseOutSection{get;set;}
    
    public date removaldate{get;set;}
    public Document uplodedDocument{get;set;}
    public boolean showtableCsv{get;set;}
    
    public list<property_Detail__c> listofDeatisl{get;set;}
    public list<property_Detail__c> listofDetails_Manual{get;set;}
    
    public boolean fromViewRequest{get;set;}
    
    public list<attachment> listofNotesAndAttchment{get;set;}
    public List<Attachment> fileAttchment{get;set;}

    public id AttachmentId{get;set;}
    public boolean showattachmentpopup{get;set;}
    
    public boolean showcsvuploadfile{get;set;}
    public boolean showuploadbutton{get;set;}
    public boolean showbuildingpopup{get;set;}
    public String approvalcomments{get;set;}
    public boolean showrejectionPopup{get;set;}
    public boolean showAddOthers{get;set;}
    public String watcherList{get;set;}
    public String RequestorEmployee{get;set;}
    public String RequesteeEmployee{get;set;}
    public Boolean showReqPopup{get;set;}
    public boolean addwatcher{get;set;}
    public list<Employee__C> EmployeeList{get;set;}
    public String watcherEmployee{get;set;}
    public String lastwatcher{get;set;}
    public boolean addsourcepopup{get;set;}
    
    Public boolean PropertyServicesSection{get;set;}
    
    public List<Document> doc {get; set;}
    public List<document> attachments {get; set;}
    public string DocumentId {get; set;}
    public String FulfillmentManager{get;set;}


    public boolean isOutofScope {get; set;}
    public string isOutofScopeTo {get; set;}
    public string docContentType {get; set;}
    
    public string removeDateStr{get; set;}
    public string returnDateDt{get; set;}
    public date removedate{get; set;}
    public string returnDateEx {get; set;}
    public string dummyFlagforDatePicker {get; set;}
    public boolean isApprover1{get;set;}
    public boolean isFloorSecurity{get;set;}
    
    public string getrequestTypeToolTip(){
        string X= 'Standard: Remove property from a Morgan Stanley Office Building \n\nData Center : Remove property from a Morgan Stanley Data Center (either MS owned or co-located) \n\nProperty Services: Remove property related to facility or move management for a Morgan Stanley Office Building';
         
       return x;
    }
     public string getRemovalTypeTooltip(){
        string X= 'Temporary: Select Temporary if property will be returned to the originating MS Office or Data Center \n\nPermanent : Select Permanent if property will be relocated or permanently removed from the originating MS Office Building or Data Center';
         
       return x;
    }
   
    //constructor starts here 
    Public abPPR_NewRequest_bootstrap_Balakumar()
    {
        EDCCloseOutSection=false;
        showMessage=false;
        isEDCRequestFulfillment=false;
        fulfillmanagerName='';
        fulfillmanagerId=null;
        approvalcomments=null;
        DocumentId = '';
        dummyFlagforDatePicker='loaded';
        strStatus = getStatusName('Saved');
        isOutofScope =false;
        isOutofScopeTo ='No';
        buildingList=new list<Building_Locations__c>(); 
        buildingListto=new list<Building_Locations__c>();     
        PPSApproverList=new list<Propert_Service_approvers__c>();
        EDCApproverlist=new list<EDC_Approver__c>();
        vendorList=  new list<PP_Vendor_Details__c>();        
        listofDeatisl=new list<property_Detail__c>();
        list<employee__c> ApproverList1=new list<Employee__C>();
        //For Existing things..,
        listofNotesAndAttchment=new list<Attachment>(); 
        fileAttchment=new List<Attachment>();
        EDCCloseOutManagerslist=new list<EDC_Group_Fulfillment__c>();
        
        attachments =new List<Document>();
        doc=new List<Document>();
        removeWatcher=new list<employee__C>();
        //Have to keep common to both..,Kumki        
        buildingList=[select id,name,BUILDING_NAME__c,City_State__c,Address1__c,Address2__c,CITY_DESCRIPTION__c     
         from Building_Locations__c where InScopeFrom__c=true ]; 
         system.debug('Check the building'+buildingList);
         
        
        //EDC Approver population              
        Map<String, EDC_Approver__c> EDCApprover = EDC_Approver__c.getAll();
        
        for(EDC_Approver__c r:EDCApprover.values())
        {
            EDCApproverlist.add(r);
        }      
        EDCApproverlist=PP_Util.sortList(EDCApproverlist, 'name', 'asc');
        //Property Service Approver Population
        Map<String, Propert_Service_approvers__c> PPSApprover = Propert_Service_approvers__c.getAll(); 
        
        for(Propert_Service_approvers__c r:PPSApprover.values())
        {
            PPSApproverList.add(r);
        }        
        //---Ends common Kumki
        PPSApproverList=PP_Util.sortList(PPSApproverList, 'name', 'asc');
        
        if(ApexPages.currentPage().getParameters().get('tab') != NULL){
            requestTab = getTabName(ApexPages.currentPage().getParameters().get('tab'));
        }
        
        //new for EDC Fulfillment manager population              
        Map<String, EDC_Group_Fulfillment__c> EDCFulfillmentManager = EDC_Group_Fulfillment__c.getAll();
        if(EDCFulfillmentManager != null && EDCFulfillmentManager.keyset() != null && EDCFulfillmentManager.keyset().size()>0){
            for(EDC_Group_Fulfillment__c r:EDCFulfillmentManager.values())
            {
                EDCCloseOutManagerslist.add(r);
            }      
            EDCCloseOutManagerslist=PP_Util.sortList(EDCCloseOutManagerslist, 'name', 'asc');            
        }
        system.debug('**************EDC Fulfillment manager'+EDCCloseOutManagerslist);

        if(ApexPages.currentPage().getParameters().get('id') != NULL){
            isOutofScope=false;
            innerlist=new list<addmorerow>();
            for(integer i=0;i<5;i++){
                innerlist.add(new addmorerow());    
            }
//Removal_Date__c,Property_Description__c,

            
            requestDeatils=[select name,Manager__r.name,Employee_Requestee_Name__r.name,PP_Vendor_Details__c,PP_Vendor_Details__r.name,Requestor_Region__c ,
                Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Property_Service_Approver__c,
                Request_Type__c,Property_Owner__c,Other_Owners__c,Others__c,Location111__r.name,CC_WatchList__c,Approval_Rejection_Date__c ,
                Destination_Details__c,Destination__r.name,Removal_Purpose__c ,Expected_Return_Date__c ,Equipment_Receipt_Confirm__c,CC_WatcherNames__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.name  from PR_Request__c 
                where id=:ApexPages.currentPage().getParameters().get('id') limit 1];    
            //Added by Balakumar
             //requestor details edit section
            requestorEmp = [select emp_id__c,cost_center__C, name,First_Name__c,CC_Region_Org__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                            , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                            , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c 
                            from employee__c where id=:requestDeatils.Employee_Requestee_Name__c];    
                            
                            
                            
                            
            String useremail = [select email from user where id=:userinfo.getUserId()].email;
    
  employee__C loggedInEmp = [select emp_id__c,Officer__c, cost_center__c,name,First_Name__c,CC_Region_Org__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                            , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                            , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c 
                            from employee__c where email__C = : useremail];  
                                                   
  if(loggedInEmp.Officer__c=='Y'){
    isApprover1=true;
  }  
  else
  {
    isApprover1=false;
  }      
   
   
   //if the logged in user is a security admin or floor security
   
     List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() ];
           system.debug('##lstcurrentUserPerSet' + lstcurrentUserPerSet);

          for (PermissionSetAssignment psa: lstcurrentUserPerSet)
               {
          system.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
          if(psa.PermissionSet.Name.equals(system.label.PP_Security_Admin)){
            
          
                isFloorSecurity = true;
                break;
          }
                 else{
                    
                 
                isFloorSecurity = false;
                 }
               }
   
   
   
   
                                                 
          
           //approved details
           
            if(requestDeatils.Other_Owners__c!=null){
           VendorName=requestDeatils.Other_Owners__c;
           }
           if(requestDeatils.PP_Vendor_Details__c!=null){
           vendorNameUi=requestDeatils.PP_Vendor_Details__r.name;
            }
            
            //End Balakumar
                
            system.debug('**********requestDeatils'+requestDeatils);

            if(requestDeatils.Request_Type__c == 'Data Center'){
                EDCCloseOutSection =true;
                if(requestDeatils.EDC_CloseOut_Approver__c != null){
                    fulfillmanagerName=requestDeatils.EDC_CloseOut_Approver__r.name;
                    fulfillmanagerId=requestDeatils.EDC_CloseOut_Approver__c;
                }
            }         
            
            RequestorEmployee=requestDeatils.Employee_Requestee_Name__r.name;
            if(requestDeatils.Manager__c!=null){
            CurrentManager=requestDeatils.Manager__r.name;  
            currentManagerId =requestDeatils.Manager__c;  
            }
            
           else if(requestDeatils.Request_Type__c=='Data Center' && requestDeatils.Requestor_Region__c=='NA'){
        CurrentManager='Americas_Data_Center_Approvers';
        }
        
        else if(requestDeatils.Request_Type__c=='Data Center' && requestDeatils.Requestor_Region__c=='EU'){
        CurrentManager='EMEA_Data_Center_Approvers';
        }
        
        else{
        CurrentManager='Asia_Data_Center_Approvers';
        }
        
        if(requestDeatils.Request_Type__c=='Property Services'){
        CurrentManager=null;
        }
        
            
       List<ProcessInstanceHistory> x=getApprovalProcessStatus();
       if(x.size()>0){
       setActorname=[select name from user where id=:x[0].ActorId].name ;
     }
            
            
            
            
                
            DestinationDetailsName=requestDeatils.Destination__r.name;
            strStatus = getStatusName(requestDeatils.Status__c);
            
            changeApprover_N();
            
            ownerDeatils_N();
            
            RemovalType_N();
            
            AddDestination_N();
            
            ProdDetailslist=[select id,name,Property_Name__c,Description__c,Quantity__c,UOM__c,Serial_No__c, Asset_Tag__c from property_Detail__c where request_details__c=:ApexPages.currentPage().getParameters().get('id')];
            system.debug('**********'+ProdDetailslist);
            
            listofNotesAndAttchment=[select id,name from Attachment where parentid=: ApexPages.currentPage().getParameters().get('id') AND name !='propertyfile.csv'];
            fileAttchment=[select id,name from Attachment where parentid=: ApexPages.currentPage().getParameters().get('id') AND name ='propertyfile.csv'];
            
            if(ProdDetailslist.size() > 0 && fileAttchment.size() ==0){
                for(integer j=0;j<innerlist.size();j++){
                    for(integer i=0;i<ProdDetailslist.size();i++){
                        innerlist[i].ProdDetails1=ProdDetailslist[i];
                    }
                }
            }
        }
        else {
            showuploadbutton=false;  
            showcsvuploadfile=false;
            showattachmentpopup=false;  
            
            requestList =new list<PR_Request__c >();
            ApproverList=new list<Employee__c>();
            requestDeatils=new PR_Request__c();
            ProdDetailslist=new list<property_Detail__c>(); 
            ProdDetails=new property_Detail__c();
            ItemNoToRemoved=false;
            AddmoreRows=false;
            ReturnDate=false;
            defaultRows =5;
            uplodedDocument=new Document(); 
            lastwatcher='';
            showEditRecall=false;   
            
            innerlist=new list<addmorerow>();
            for(integer i=0;i<5;i++){
                innerlist.add(new addmorerow());    
            }
            //get the logged in user details
            u = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email  from user where id = :UserInfo.getUserId()];
            
           //get the employee related to the user
            requestorEmp = [select emp_id__c, cost_center__c,name,First_Name__c,CC_Region_Org__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                            , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                            , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c 
                            from employee__c where Emp_ID__c = :  u.Emp_Id__c];                         
          
        
            requestDeatils.Employee_Requestor_Name__c = requestorEmp.id; 
            requestDeatils.Employee_Requestee_Name__c = requestorEmp.id; 
            RequestorEmployee=requestorEmp.name;   
            //removeDate=date.today(); 
               
            if(requestorEmp.Manager__c!=null ){
            CurrentManager=requestorEmp.Manager__r.name;
            currentManagerId=requestorEmp.Manager__r.id;
            }
            
            //Added by sanjib 30-10 for building data modification
            if(requestorEmp.Building_Directory__c!=null || requestorEmp.Building_Directory__c!=''){
                list<Building_Locations__c> location  =[select id from Building_Locations__c where LDAP_Code__c=:requestorEmp.Building_Directory__c limit 1];
                if(location.size()>0){
                    requestDeatils.Location111__c=location[0].id;
                }else{
                    requestDeatils.Location111__c=null;
                    //requestDeatils.Location111__c='<font size=2 color=red>BUILDING NOT IN SCOPE</font>';
                }
            }else{
                    requestDeatils.Location111__c=null;
                    //requestDeatils.Location111__c='<font size=2 color=red>BUILDING NOT IN SCOPE</font>';
            
            }
            requestDeatils.Removal_Type__c='Permanent';
            
            
        if(requestDeatils.Location111__c != null){
            list<Building_Locations__c> location  =[select id,name,InScopeFrom__c from Building_Locations__c where Id=:requestDeatils.Location111__c];
            if(location.size()==1 && location[0].InScopeFrom__c ==false){
                isOutofScope =true;
                requestDeatils.Location111__c=null;
            }
            else{
                isOutofScope =false;
            }            
        }    
        else{
                isOutofScope =true;
        } 
        
        if(requestDeatils.Destination__c != null){
            list<Building_Locations__c> locationTo  =[select id,name,InScopeTo__c from Building_Locations__c where Id=:requestDeatils.Destination__c];
            if(locationTo.size()==1 && locationTo[0].InScopeTo__c==false){
                isOutofScopeTo ='Yes';
                DestinationDetailsName=null;
                requestDeatils.Destination__c=null;
            }
            else{
                isOutofScopeTo ='No';
            }  
        }  
        else{
                isOutofScopeTo ='No';
        }       
        }
        
        
        
        //general section for approver details
        //Standard Approver popup(need to change)
        system.debug('test cose center'+requestorEmp.Cost_Center_Code__c);                
            ApproverList =[select id,emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c,Dept_Dsc_Org__c,
                          Job_Title__c , Country_Dsc_Home__c,Cost_Center__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,
                          Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,
                          Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c 
                          where Cost_Center__c=:requestorEmp.Cost_Center__c and Level_Dsc_Job__c in('Vice President','Executive Director','Managing Director') and status__c='Active' ]; 
            if(ApproverList.size()<=0){
            Employee__c X=[select Cost_Center_Code__c,Cost_Center__c from Employee__c where id=:requestorEmp.Manager__c];  
            ApproverList1=[select id,emp_id__c,Cost_Center__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c,Dept_Dsc_Org__c,
                          Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,
                          Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,
                          Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c 
                          where Cost_Center__c=:X.Cost_Center__c and Level_Dsc_Job__c in ('Vice President','Executive Director','Managing Director') and status__c='Active' ];
              }
              if(ApproverList1.size()!=0){
                ApproverList=ApproverList1;
              }
             ApproverList=PP_Util.sortList(ApproverList, 'name', 'asc');                            
            system.debug('****'+requestDeatils.Property_Owner__c); 
        
        
        
        
        
        
        
        
        
        
        
        
        
        
          
        system.debug('%%%%%%%%%%%%%%%'+requestDeatils.Removal_Date__c);
        if(requestDeatils.Removal_Date__c != null){
            removeDateStr=requestDeatils.Removal_Date__c.month()+'/'+requestDeatils.Removal_Date__c.day()+'/'+requestDeatils.Removal_Date__c.year();
        }
        if(requestDeatils.Expected_Return_Date__c != null ){
            system.debug('----------------requestDeatils.Expected_Return_Date__c------------------'+requestDeatils.Expected_Return_Date__c+date.today());
            returnDateDt=requestDeatils.Expected_Return_Date__c.month()+'/'+requestDeatils.Expected_Return_Date__c.day()+'/'+requestDeatils.Expected_Return_Date__c.year();
        }      
    }
        



    Public Pagereference Addmore(){     
        for(integer i=0;i<5;i++){
            innerlist.add(new addmorerow());
            AddmoreRows=true;   
        }    
        return null;
    }

    public Pagereference addOtherOwner(){
        system.debug('****'+requestDeatils.Property_Owner__c);
        if(requestDeatils.Property_Owner__c=='Others' || requestDeatils.Property_Owner__c=='Vendor'){
            AddOthers=true;
        }
        else
        {
            AddOthers=false;
        }
        return null;
    } 

    //get the approver
    public pagereference getApproverlookup(){   
    
        if(requestDeatils.Request_Type__c=='Data Center'){
            isEDCRequest=true;
            isPropertyservice=false;
            isStandard=false;        
        }
        
        else if(requestDeatils.Request_Type__c=='Property Services'){
            isPropertyservice=true;
            isStandard=false;
            isEDCRequest=false;            
        }
        else{
            isEDCRequest=false;
            isStandard=true;
            isPropertyservice=false;        
        }
        return null;
    }
    
    //show fulfillment manager pop up..,
    public pagereference getFulfillmentManagerlookup(){ 
        if(requestDeatils.Request_Type__c=='Data Center'){
            isEDCRequestFulfillment=true;
        }
        else{
            isEDCRequestFulfillment=false;
        }
        return null;
    }

    public Pagereference saveSelectedApprover(){
        isEDCRequest=false;
        isPropertyservice=false;
        isStandard=false;
        isEDCRequestFulfillment=false;        
        return null;
    }


    public Pagereference CloseWindow(){
        isEDCRequest=false;
        isPropertyservice=false;
        isStandard=false;
        showattachmentpopup=false;
        showcsvuploadfile=false;
        showReqPopup=false;
        addwatcher=false;
        addsourcepopup=false;
        showbuildingpopup=false;
        vendorpopup=false;
        propOwnerVendorPopup=false;
        isOutofScope=false;
        cancelConfrm=false;
        ConfirmationWindow=false;
        showrejectionPopup=false;
        //new..,
        isEDCRequestFulfillment=false;
        return null;
    }

    public pagereference changeApprover(){
        CurrentManager = null;
    
        if(requestDeatils.Request_Type__c=='Data Center' && requestorEmp.CC_Region_Org__c=='NA'){
            CurrentManager='Americas_Data_Center_Approvers';
        } else if(requestDeatils.Request_Type__c=='Data Center' && requestorEmp.CC_Region_Org__c=='EU'){
            CurrentManager='EMEA_Data_Center_Approvers';
        } else{
            CurrentManager='Asia_Data_Center_Approvers';
        }
    
        if(requestDeatils.Request_Type__c=='Property Services'){
            CurrentManager=null;
        } else if(requestDeatils.Request_Type__c=='Standard'){
            if(requestorEmp.Manager__c!=null ){
                CurrentManager=requestorEmp.Manager__r.name;
                currentManagerId=requestorEmp.Manager__r.id;
            }
        }
            
        if(requestDeatils.Request_Type__c!='Data Center' && requestDeatils.Request_Type__c!='Property Services' && requestDeatils.Request_Type__c!='Standard' ){
            CurrentManager = null;
        } 
        changeApprover_N();
        return null;
    }  
    
    public pagereference closepopup(){
        isOutofScope=false;
        return null;
    }  
    
    public void changeApprover_N(){
         if(requestDeatils.Request_Type__c=='Data Center'){
            EDCCloseOutSection=true;            
        }
        else
        {
            EDCCloseOutSection=false;       
        }
    }

    public pagereference RemovalType(){
        RemovalType_N();
        return null;
    }
    
    public void RemovalType_N(){
        system.debug('**++'+IsParmanent);
        if(requestDeatils.Removal_Type__c=='Temporary'){
            dummyFlagforDatePicker='loaded';
            ReturnDate=true;
        }
        else{
            ReturnDate=false;
        }
    }    

    public pagereference UploadCSV(){
        string [] filelines=new string[]{};
        String contectfilecsv;  
        listofDeatisl=new list<property_Detail__c>();
        doc=new List<Document>();
        showcsvuploadfile=false;
        ER_CSVUploadError='';  
                  
      //  try{                     
            contectfilecsv=UploadCSV.toString();            
            filelines = contectfilecsv.split('\n');        
            system.debug('***********'+filelines.size()+filelines);
            for (Integer i=1;i<filelines.size();i++){
                String[] inputvalues = new String[]{};
                inputvalues =getCleanFields(filelines[i].split(','));
                system.debug('testing'+inputvalues[0]);
                if( (requestDeatils.Request_Type__c!='Data Center' && inputvalues[0]!='' && inputvalues[1]!='' && inputvalues[2]!='' && inputvalues[3]!='') || (requestDeatils.Request_Type__c=='Data Center' && inputvalues[0]!='' && inputvalues[1]!='' && inputvalues[2]!='' && inputvalues[3]!='' && inputvalues[4]!='' && inputvalues[5]!='')){
                    property_Detail__c  a = new property_Detail__c();
                    system.debug('hi i am in');
                    a.Property_Name__c= inputvalues[0];
                    a.UOM__c = inputvalues[1];
                    a.Quantity__c= inputvalues[2];
                    a.Description__c= inputvalues[3];
                    if(inputvalues[4] != ''){
                        a.Serial_No__c=inputvalues[4];
                    }
                    if(inputvalues[5] != ''){
                        a.Asset_Tag__c=inputvalues[5];
                    }
                    listofDeatisl.add(a);      
                    //showcsvuploadfile=false;                                  
                }   
                /*else{
                    system.debug('**************'+listofDeatisl);
                    listofDeatisl=new List<property_Detail__c>();
                    contectfilecsv=null;
                    UploadCSV=null;
                    ER_CSVUploadError='Error: Input file that doesnt contain valid data and/or all mandatory fields to process. Data center request should include with asset number & serial tag.';
                    //Error message..,
                }*/         
            }
       
            if(listofDeatisl.size() ==0){
                system.debug('**************'+listofDeatisl);
                listofDeatisl=new List<property_Detail__c>();
                contectfilecsv=null;
                UploadCSV=null;
                ER_CSVUploadError='Error: Input file that doesnt contain valid data and/or all mandatory fields to process. Data center request should include with asset number & serial tag.';
                //Error message..,
            }  
            else{             
                document docment=new document();
                docment.Body=UploadCSV;
                docment.FolderId='00lf0000000e4LG';
                docment.Name='propertyfile.csv';
                docment.ContentType=docContentType;
                docment.type='csv';
                insert docment; 
                docment.body=null;
                doc.add(docment);
            }
                            
            contectfilecsv=null;
            UploadCSV=null;
            system.debug('********listofDeatisl'+listofDeatisl);  
            system.debug('************listofDetailsfile'+listofDeatisl);  
      //  }                
    //    catch (Exception e){
//     doc=new List<Document>();
      //      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      //     ApexPages.addMessage(errormsg);
      //      contectfilecsv=null;
       //     UploadCSV=null;
         //   return null;
     //   }   
        return null;
    }   

    Public pagereference AddDestination()
    {
        AddDestination_N();        
        Return null;
    }
    
    public Void AddDestination_N(){
        
        if(requestDeatils.Destination_Details__c=='MS Data Center' || requestDeatils.Destination_Details__c=='MS Office Building'){       
            AddSearchbox=true;
            AddFreeText=false;
            AddVendor=false;
            
        }
        else if( (requestDeatils.Destination_Details__c=='Charitable Donation' || requestDeatils.Destination_Details__c=='Disposal'|| requestDeatils.Destination_Details__c=='Other' || requestDeatils.Destination_Details__c=='Return to Hiring Agency') ){      
           AddSearchbox=false;
            AddFreeText=true;
            AddVendor=false;
            
        }
        else if( ((requestDeatils.Request_Type__c=='Data Center'|| requestDeatils.Request_Type__c=='Property Services' || requestDeatils.Request_Type__c =='Standard') && requestDeatils.Destination_Details__c=='Return to Vendor')){
         
            AddVendor=true;
            AddSearchbox=false;
            AddFreeText=false;
        }
        else
        {
            AddSearchbox=false;
            AddFreeText=false;
            AddVendor=false;
        }
    }


    Public pagereference saveRequest(){
        
        boolean flag=false;
        flag=doValidation();
        system.debug('**************ss'+listofDeatisl);
        if(flag == false){
            return null;
        }  
        

        system.debug('currentManagerId'+currentManagerId);
        //if(currentManagerId!='NA'){ 
          if(currentManagerId!=null){        
            if(approverid(requestDeatils.Request_Type__c,currentManagerId)!=null){
                requestDeatils.Manager__c=approverid(requestDeatils.Request_Type__c,currentManagerId);
            }
        }
        else
        {
            requestDeatils.Manager__c=null;
            requestDeatils.Escalate_to_Admin__c=true;
        }
        system.debug('*******currentManagerId'+currentManagerId);
        
        //new for fulfillment manager..,
        if(fulfillmanagerName != null && fulfillmanagerName.trim() !='' && fulfillmanagerId != null){
            system.debug('************'+approverid(requestDeatils.Request_Type__c,fulfillmanagerId));
            requestDeatils.EDC_CloseOut_Approver__c=approverid(requestDeatils.Request_Type__c,fulfillmanagerId);
        }
        else{
            requestDeatils.EDC_CloseOut_Approver__c=null;
        }

        if(requestDeatils.Id==null){
            insert requestDeatils;
        } else {
            update requestDeatils;
        }
        
        system.debug('**************'+listofDeatisl);
        if(listofDeatisl!= null && listofDeatisl.size() > 0){
            for(property_Detail__c X: listofDeatisl){
                X.request_details__c=requestDeatils.id;
                //newly added
                X.Id=null;
            }
            //upsert listofDeatisl;
            insert listofDeatisl;
            
            if(doc.size() > 0 && doc[0].Id != null){
                Document d=[select id,body,contentType,type,name from document where id=:doc[0].ID];
                Attachment att=new Attachment(name='propertyfile.csv',ParentId=requestDeatils.id,body=d.body);
                insert att;
                att.body=null; 
                d=null;               
            }
        }

        
        if(listofDetails_Manual != null && listofDetails_Manual.size() > 0){
            List<property_Detail__c> dummy=new List<property_Detail__c>();
            for(property_Detail__c X: listofDetails_Manual){
                property_Detail__c d=new property_Detail__c ();
                d.request_details__c=requestDeatils.id;
                d.Property_Name__c =X.Property_Name__c ;
                d.Quantity__c=X.Quantity__c;
                d.Description__c=X.Description__c;
                d.Asset_Tag__c=X.Asset_Tag__c;
                d.Serial_No__c=X.Serial_No__c;
                d.UOM__c=X.UOM__c;
                dummy.add(d);
            }
            //upsert listofDetails_Manual;
            insert dummy;
        }    
        
        if(attachments .size() >0){
            set<Id> idset=new set<Id>();
            List<Attachment> finalList=new List<Attachment>();
            for(Document d2:attachments){                
                idset.add(d2.Id);
            }
            for(document d1:[select id,name,body,contentType from document where id IN:idset]){
                attachment r=new attachment();
                r.name=d1.name;
                r.body=d1.body;
                r.contentType=d1.contentType;
                r.ParentId=requestDeatils.id;
                finalList.add(r);
            }
            insert finalList;
            finalList=null;
        }

        //newly added.
        if(ProdDetailslist != null && ProdDetailslist.size() > 0){
            delete ProdDetailslist;
        }
        
        PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap');
        pr.setRedirect(true);
        return pr;
   }
    
    public pagereference submitRequest(){ 
        Id userid;     
        boolean flag=false;
        flag=doValidation();
        system.debug('**************ss'+listofDeatisl);
        if(flag == false){
            return null;
        }  

        system.debug('check sanjib'+currentManagerId);
        if(requestDeatils.Request_Type__c=='Standard'){
            
        
        if(approverid(requestDeatils.Request_Type__c,currentManagerId)!=null){
        requestDeatils.Manager__c=approverid(requestDeatils.Request_Type__c,currentManagerId);
        userid=approverUserid(requestDeatils.Request_Type__c,currentManagerId);
        }
        }
        else
        {
            requestDeatils.Manager__c=null;
            requestDeatils.Escalate_to_Admin__c=true;
        }
        
        system.debug('*******'+currentManagerId); 
        
        //new for fulfillment manager..,
        if(fulfillmanagerName != null && fulfillmanagerName.trim() !='' && fulfillmanagerId != null){
            requestDeatils.EDC_CloseOut_Approver__c=approverid(requestDeatils.Request_Type__c,fulfillmanagerId);
        }
        else{
            requestDeatils.EDC_CloseOut_Approver__c=null;
        }      
        
        //requestDeatils.OwnerId='005f00000010w7e';        
        
        if(requestDeatils.Id==null){  
            insert requestDeatils;    
        }
        else
        {    
            update requestDeatils;
        }
        
        //insert the attachchment import functionality
        system.debug('**************'+listofDeatisl);
        if(listofDeatisl!= null && listofDeatisl.size() > 0){
            for(property_Detail__c X: listofDeatisl){
                X.request_details__c=requestDeatils.id;
                X.Id=null;
            }
            insert listofDeatisl;
            
            if(doc.size() > 0 && doc[0].Id != null){
                Document d=[select id,body,name,contentType,type from document where id=:doc[0].ID];
                Attachment att=new Attachment(name='propertyfile.csv',ParentId=requestDeatils.id,body=d.body);
                insert att;
                att.body=null; 
                d=null;               
            }
        }
        
       if(listofDetails_Manual != null && listofDetails_Manual.size() > 0){
            List<property_Detail__c> dummy=new List<property_Detail__c>();
            for(property_Detail__c X: listofDetails_Manual){
                property_Detail__c d=new property_Detail__c ();
                d.request_details__c=requestDeatils.id;
                d.Property_Name__c =X.Property_Name__c ;
                d.Quantity__c=X.Quantity__c;
                d.Description__c=X.Description__c;
                d.Asset_Tag__c=X.Asset_Tag__c;
                d.Serial_No__c=X.Serial_No__c;
                d.UOM__c=X.UOM__c;
                dummy.add(d);
            }
            //upsert listofDetails_Manual;
            insert dummy;
        }     
        
        if(attachments .size() >0){
            set<Id> idset=new set<Id>();
            List<Attachment> finalList=new List<Attachment>();
            for(Document d2:attachments){                
                idset.add(d2.Id);
            }
            for(document d1:[select id,name,body,contentType from document where id IN:idset]){
                attachment r=new attachment();
                r.name=d1.name;
                r.body=d1.body;
                r.contentType=d1.contentType;
                r.ParentId=requestDeatils.id;
                finalList.add(r);
            }
            insert finalList;
            finalList=null;
        }

        //newly added.
        if(ProdDetailslist != null && ProdDetailslist.size() > 0){
            delete ProdDetailslist;
        }
        /*
        if(requestDeatils.Manager__c!=null){
        Approval.ProcessResult result = null;
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setObjectId(requestDeatils.id); 
        //request.nextApproverIds = a;
        request.setNextApproverIds(new Id[] {userid});
        result  =   Approval.process(request); 
        }
        else
        {
             Approval.ProcessResult result = null;
             Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
             request.setObjectId(requestDeatils.id); 
        //request.nextApproverIds = a;
             // request.setNextApproverIds(new Id[] {userid});
            result  =   Approval.process(request); 
       
        } */
        PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap');
        pr.setRedirect(true);
        
        return pr;
    }

    public pagereference delRequest(){
        system.debug('the placeholder'+IdPlaceHolder);
        PR_Request__c a=[select id from PR_Request__c where id=:IdPlaceHolder];
        delete a;        
        
        //change this to provate method        
        //,Removal_Date__c,Property_Description__c,
        requestList =[select name,Employee_Requestee_Name__r.name,Removal_Date__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Request_Type__c from PR_Request__c order by createdDate desc   limit 10]; 
        
        return null;
    }
    
    //modify the folder id with folder name
    public pagereference UploadAttachment(){
        system.debug(')))))))))))))))))'+requestDeatils.id);
        document newattchment=new document();
            
        newattchment.FolderId='00lf0000000e4LG';    
        newattchment.Body=notesAndAttchment;
        newattchment.Name=FileName1;
        //newattchment.contentType='.csv';
           
        try {
            insert newattchment;
            newattchment.body=null;
            notesAndAttchment=null;
            attachments.add(newattchment);
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
          return null;
        } finally {
          
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        showattachmentpopup=false;
        return null;
     }
  
  
    //this medoth will help to map the employee and user record to get it from ui
    Private id approverid(String a,String b){
        system.debug('test sanjib'+b);
        List<employee__C> empList;
        id deligatedApprover;
        
        if(a=='Standard'){
            empList=[select user__c from employee__C where id=:b];
            if(empList != null && empList.size() > 0){
                deligatedApprover=empList[0].Id;
            }
            else{
                deligatedApprover=Id.valueOf(b);
            }
        }
        else{
            empList=[select user__c from employee__C where emp_id__c=:b];
            if(empList != null && empList.size() > 0){
                deligatedApprover=empList[0].Id;
            }
            else{
                deligatedApprover=Id.valueOf(b);
            }
        }
        return deligatedApprover;            
    }
    
    //modified by sanjib for exceptions
    Private id approverUserid(String a,String b){
        system.debug('test sanjib'+b);
        List<employee__C> empList;
        id deligatedApprover;
        
        if(a=='Standard'){
            empList=[select user__c,id from employee__C where id=:b];
            if(empList != null && empList.size() > 0){
                deligatedApprover=empList[0].user__c ;
            }
            else{
                deligatedApprover=Id.valueOf(b);
            }
        }
        else{
            empList=[select user__c from employee__C where emp_id__c=:b];
            if(empList != null && empList.size() > 0){
                deligatedApprover=empList[0].user__c;
            }
            else{
                deligatedApprover=[select user__c,id from employee__C where id=:b].user__c;
            }
        }
        return deligatedApprover;            
    }
    
    

    public class addmorerow{    
        Public property_Detail__c ProdDetails1{get;set;}
        public string ErrorMessage {get; set;}
        public addmorerow(){
            ProdDetails1=new property_Detail__c();
            ErrorMessage =null;
        }
    }
    
    
    private void recallfromapproval(String Id){
        
         ProcessInstance piFSA = [Select ID, Status From ProcessInstance Where TargetObjectID = :ID AND Status = 'Pending'];
               
        if(piFSA !=Null){
            ProcessInstanceWorkitem piwiFSA = [select Id,OriginalActorId from ProcessInstanceWorkitem where ProcessInstanceId= :piFSA.Id LIMIT 1];
            Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
            prWkItem.setWorkItemID(piwiFSA.id);
            prWkItem.setComments('Auto Approve FSA upon manager assignment of a partner member in .......');
            prWkItem.setAction('Removed');
            Approval.ProcessResult appResult = Approval.process(prWkItem);
        }        
       
        
    }
    
    
       
    
    //recall submitted request
    public pagereference recallRequest(){
        recallfromapproval(ApexPages.currentPage().getParameters().get('ID'));
        showEditRecall=false;

        pagereference p=new pagereference('/apex/PP_RequestTest_bootstrap?tab=Myrequest');
        return p;    
    }

    public pagereference DeleteATtachment(){
        if(AttachmentId !=null){
            Attachment a=[select id from attachment where id =:AttachmentId];
            delete a;            
            listofNotesAndAttchment=[select id,name from Attachment where parentid=: ApexPages.currentPage().getParameters().get('ID')  AND name !='propertyfile'];
            AttachmentId=null;
        }  
        else if(DocumentId != null &&  DocumentId != ''){
            Integer h=0;
            for(Document e:attachments){
                if(e.ID==DocumentId){
                    Document ds=new Document(Id=DocumentId);
                    delete ds;
                    break;
                }
                h++;
            }
            attachments.remove(h);
            DocumentId = null;
        }
        return null;
    }
    
     public pagereference DeleteFile(){
        if(AttachmentId!=null){
            Attachment a=[select id from attachment where id =:AttachmentId];
            delete a;            
            fileAttchment=[select id,name from Attachment where parentid=: ApexPages.currentPage().getParameters().get('id') AND name ='propertyfile.csv'];
            AttachmentId=null;
        }  
        else if(DocumentId != null &&  DocumentId != ''){
            Document ds=new Document(Id=DocumentId);
            delete ds;
            doc=new List<Document>();
            DocumentId = null;
        }
        return null;
    }

    public pagereference Fileselectioattachment(){
        showattachmentpopup=true;
        return null;
    }

    public pagereference uploadfileCSV(){
        showcsvuploadfile=true;
        return null;
    }

    public pagereference downloadCVS(){
       showuploadbutton=true;
       system.debug('*************showuploadbutton'+showuploadbutton);
       return null;
    }
    
    
    public pagereference buildingData(){
        
        
        
        showbuildingpopup=true;
        return null;
    }
    
    public pagereference selectedBuiding(){
        showbuildingpopup=false;
        return null;
    }    

    public pagereference clear(){ 
        PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap?tab='+ApexPages.currentPage().getParameters().get('tab'));
        pr.setRedirect(true);
        return pr;
    }
    
    public pagereference takeaction(){
        showrejectionPopup=true;
        return null;
    } 
    
    public pagereference approveRequest(){
        showrejectionPopup=false;
    
        Approval.ProcessResult result = null;
        List<Id> newWorkItemIds = null;
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();        
        //req2.setComments(approvalcomments);
        req2.setAction('Approve');
        ProcessInstanceWorkitem newProcess = [Select Id, processinstance.targetobjectid From ProcessInstanceWorkitem 
                                              where processinstance.targetobjectid = :ApexPages.currentPage().getParameters().get('ID')];
        req2.setWorkitemId(newProcess.Id);
        result = Approval.process(req2);
        newWorkItemIds = result.getNewWorkitemIds(); 
        
        //update the actor id 
      PR_Request__c V1=[select id from PR_Request__c where id =:  ApexPages.currentPage().getParameters().get('ID')];
      if(V1!=null){
        v1.ActualApprover__c=userinfo.getUserId();
      }
      update v1;
        
        
        
        
        
        
        
        pagereference p=new pagereference('/apex/PP_RequestTest_bootstrap?tab=MypendingApprovals');
        return p;
    }
    public boolean showMessage{get;set;}
    public pagereference RejectRequest(){
    system.debug('test Reject'+approvalcomments.length());
    if( approvalcomments.length()!=0 && approvalcomments.length() < 4000){
        showrejectionPopup=false;
        showMessage=false;
        Approval.ProcessResult result = null;
        List<Id> newWorkItemIds = null;
        
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();        
        req2.setComments(approvalcomments);
        req2.setAction('Reject');
        ProcessInstanceWorkitem newProcess = [Select Id, processinstance.targetobjectid 
        From ProcessInstanceWorkitem where processinstance.targetobjectid = :ApexPages.currentPage().getParameters().get('ID')];
        req2.setWorkitemId(newProcess.Id);
        result = Approval.process(req2);
        newWorkItemIds = result.getNewWorkitemIds(); 
        
        
        //update the actor id 
      PR_Request__c V1=[select id from PR_Request__c where id =:  ApexPages.currentPage().getParameters().get('ID')];
      if(V1!=null){
        v1.ActualApprover__c=userinfo.getUserId();
      }
      update v1;
        
       
        
        
        
        pagereference p=new pagereference('/apex/PP_RequestTest_bootstrap?tab=MypendingApprovals');
        return p;
        }
        else
        {
        showrejectionPopup=true;
        showMessage=true;
        return null;
        }
        
        
        
        
    }
    
    
    public pagereference ownerDeatils(){
        ownerDeatils_N();
        return null;
    }
    
    public void ownerDeatils_N(){
    showPropOwnerVendor =false;
    showAddOthers= false;
        if(requestDeatils.Property_Owner__c=='Others' || requestDeatils.Property_Owner__c=='Former Employee or Contractor' ){
            showAddOthers=true;
        }
        else if(requestDeatils.Property_Owner__c=='Vendor'){
            showPropOwnerVendor = true;
        }else{
            showAddOthers= false;
            showPropOwnerVendor =false;
        }
    }

    public pagereference SearchEmployee(){
        RequesteeEmployee=null;
        EmployeeList=null;
         msgError1 = false;
         msgError = null;
        showReqPopup=true;
        return null;
    }
    
    public pagereference WatcherEmployee(){
        watcherEmployee=null;
        EmployeeList=null;
         msgError1 = false;
         msgError = null;
        addwatcher=true;
        return null;
    }

    public String msgError{get;set;}
    public boolean msgError1 {get;set;}
    //public string EmployeeError {get;set;}
    
    public pagereference FilterEmployee(){
        EmployeeList=null;
        //EmployeeError = null;
        msgError1 = false;
        msgError=null;
        
        system.debug('id & Name'+RequesteeEmployee);
        String Query='select id,emp_id__c,Division_Dsc_Org__c,CC_City_Dsc_Org__c,Floor_Directory__c, name,First_Name__c, Last_Name__c,Dept_Dsc_Org__c,Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where'; 
        if((RequesteeEmployee!=null || RequesteeEmployee!='')&& (watcherEmployee==null || watcherEmployee=='') ){
             Query+=' (name like \'%'+RequesteeEmployee+'%\' OR emp_id__c=\''+RequesteeEmployee +'\') and status__c=\'Active\'';
        }
        else{
          Query+='( name like \'%'+watcherEmployee+'%\' OR emp_id__c=\''+watcherEmployee +'\' ) and status__c=\'Active\' ';            
        }

        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            //Or else Error Message to display..,
            EmployeeList=null;
        }
        else{
            Query+='  order by createdDate desc ';
            EmployeeList=(List<Employee__C>)Database.Query(Query);
             if(EmployeeList.size() > 20){
            
                    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'my error msg');
                    msgError='More number of search results found. Please Limit your Search';
                    msgError1 = true;
                    EmployeeList=null;
                    system.debug('----------------we are here--------------------'+msgError+msgError1);
                    return null;
            }
            else
            {
            EmployeeList=PP_Util.sortList(EmployeeList, 'name', 'asc');
            system.debug('**************list'+EmployeeList);           
            }
        }
        
        return null;
    }
    


    public pagereference SelectedEmployee(){
    
         CurrentManager=null;
          requestorEmp=null;
          
        list<Employee__C> ApproverList1=new list<Employee__C>();
        showReqPopup=false;
         
        requestorEmp = [select emp_id__c, name,First_Name__c,CC_Region_Org__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                        , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                        , Job_Country_Job__c,Empl_Class_Dsc_Job__c,cost_center__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c from employee__c where id = :  requestDeatils.Employee_Requestee_Name__c];                         
          
          
         //requestee manager population
         
          if(requestDeatils.Request_Type__c=='Data Center' && requestorEmp.CC_Region_Org__c=='NA'){
            CurrentManager='Americas_Data_Center_Approvers';
            requestDeatils.Property_Service_Approver__c='PP_Americas_Data_Center_Approvers';
        } else if(requestDeatils.Request_Type__c=='Data Center' && requestorEmp.CC_Region_Org__c=='EU'){
            CurrentManager='EMEA_Data_Center_Approvers';
            requestDeatils.Property_Service_Approver__c='PP_EMEA_Data_Center_Approvers';
        } else{
            CurrentManager='Asia_Data_Center_Approvers';
            requestDeatils.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
        }
    
        if(requestDeatils.Request_Type__c=='Property Services'){
            CurrentManager=null;
        } else if(requestDeatils.Request_Type__c=='Standard'){
            if(requestorEmp.Manager__c!=null ){
                CurrentManager=requestorEmp.Manager__r.name;
                currentManagerId=requestorEmp.Manager__r.id;
            }
            else
            {
                CurrentManager=null;
            }
        }
        
          
      
        if(requestorEmp.Building_Directory__c!=null || requestorEmp.Building_Directory__c!=''){  
        list<Building_Locations__c> location=[select id from Building_Locations__c where LDAP_Code__c=:requestorEmp.Building_Directory__c limit 1];
        
        if(location.size()>0){
            requestDeatils.Location111__c=location[0].id;
        }
        else
        {
            requestDeatils.Location111__c=null;
        
        }
        
        }
        else
        {
        requestDeatils.Location111__c=null;
            
        }
        //Standard Approver popup(need to change)                
       /*  ApproverList =[select id,emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c,
                          Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,
                          Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,
                          Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c 
                          where Cost_Center_Code__c=:requestorEmp.Cost_Center_Code__c and Level_Dsc_Job__c='Vice President' limit 10]; */
           ApproverList =[select id,emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c,Dept_Dsc_Org__c,
                          Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,
                          Building_Directory__c,Cost_Center__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,
                          Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c 
                          where Cost_Center__c=:requestorEmp.Cost_Center__c and Level_Dsc_Job__c in ('Vice President','Executive Director','Managing Director') and status__c='Active'];                
                          
            //if(ApproverList.size()<=0){
            if(ApproverList.size()<=0 && requestorEmp.Manager__c!=null){
             
            /*Employee__c X=[select Cost_Center_Code__c from Employee__c where id=:requestorEmp.Manager__c];  
            ApproverList1=[select id,emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c,
                          Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,
                          Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,
                          Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c 
                          where Cost_Center_Code__c=:X.Cost_Center_Code__c and Level_Dsc_Job__c='Vice President' limit 10];*/
             Employee__c X=[select Cost_Center__c,Cost_Center_Code__c from Employee__c where id=:requestorEmp.Manager__c];  
             ApproverList1=[select id,emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c,Dept_Dsc_Org__c,
                          Job_Title__c ,Cost_Center__c, Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,
                          Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,
                          Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c 
                          where Cost_Center__c=:X.Cost_Center__c and Level_Dsc_Job__c in ('Vice President','Executive Director','Managing Director') and status__c='Active'];             
              }
              if(ApproverList1.size()!=0){
                ApproverList=ApproverList1;
              }
        ApproverList=PP_Util.sortList(ApproverList, 'name', 'asc'); 
        return null;
    }

    public pagereference SelectedEmployee1(){
        system.debug('Add watcher'+watcherList);
        if(requestDeatils.CC_WatchList__c == null){
            requestDeatils.CC_WatchList__c='';
            requestDeatils.CC_WatcherNames__c='';
        }
        addwatcher=false;
        system.debug('lastwatcher'+lastwatcher);
        system.debug('requestDeatils.CC_WatchList__c1'+requestDeatils.CC_WatchList__c);
        if(lastwatcher!=null || lastwatcher!=''){
        Employee__C V=[select id,name,email__c from employee__C where emp_id__C=:lastwatcher];
        
        if(requestDeatils.CC_WatcherNames__c != '' && requestDeatils.CC_WatcherNames__c.length()> 0){
            requestDeatils.CC_WatcherNames__c= requestDeatils.CC_WatcherNames__c+ ',' + v.name;
             requestDeatils.CC_WatchList__c=requestDeatils.CC_WatchList__c+';'+v.email__c;
        }
        else{
            requestDeatils.CC_WatcherNames__c=  requestDeatils.CC_WatcherNames__c+v.name;  
             requestDeatils.CC_WatchList__c=requestDeatils.CC_WatchList__c+v.email__c;
        
        }     

        lastwatcher='';
        system.debug('requestDeatils.CC_WatchList__c2'+requestDeatils.CC_WatchList__c);
        }
        return null;
    }


    public pagereference AddSource(){
        addsourcepopup=true;    
        return null;
    }
    public pagereference selectedBuiding1(){
        addsourcepopup=false;
        return null;
    }
   public boolean vendorpopup{get;set;}
   public pagereference OpenVendorpopup(){
     //Start Balakumar
      vendorList.clear();
      vendorError=null;
       VendorNameUi=null;
     //End Balakumar
    vendorpopup=true;
    return null;
   }
   public boolean propOwnerVendorPopup{get;set;}
   public pagereference OpenPropOwnerVendorPopup(){
    //Start Balakumar
    vendorError=null;
    VendorName=null;    
    //End Balakumar
    propOwnerVendorPopup=true;
    return null;
   }
   public String vendorNameUi{get;set;}
   public String VendorName{get;set;}
   public String vendorError{get;set;}
   public list<PP_Vendor_Details__c> vendorList{get;set;}
   public pagereference filterVendorData(){
      system.debug('----------------------------Filter Data------------------------------------------');
       vendorList.clear();
       vendorError=null;
       String Query='select id,name,Is_Active__c,Region__c,Vendor_ID__c from PP_Vendor_Details__c where'; 
     system.debug('----------------------------Filter Data------------------------------------------'+VendorName.length());
      if(VendorName.length()<=2){
            vendorError='Please use atleast 3 characters to search vendor';
        }
        else{
     
        if(VendorName!=null || VendorName!='') {
             Query+=' (name like \'%'+VendorName+'%\' OR Vendor_ID__c=\''+VendorName +'\')';
        }

        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            //Or else Error Message to display..,
            vendorList=null;
        }
        else{
            Query+='  order by createdDate desc ';
            vendorList=(List<PP_Vendor_Details__c>)Database.Query(Query);
            
        }
        if(vendorList.size()==0){
        vendorError='No Data Found';
        }
        }
    
    
    return null;
   }
   
   public pagereference filterVendorData1(){
        vendorList.clear();
        //vendorError=null;
     String Query='select id,name,Is_Active__c,Region__c,Vendor_ID__c from PP_Vendor_Details__c where'; 
        if(vendorNameUi.length()<=3){
            vendorError='Please use atleast 4 characters to search vendor';
        }
        
       else
       { 
        if(vendorNameUi!=null || vendorNameUi!='') {
             Query+=' (name like \'%'+vendorNameUi+'%\' OR Vendor_ID__c=\''+vendorNameUi +'\')';
        }

        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            //Or else Error Message to display..,
            vendorList=null;
        }
        else{
            Query+='  order by createdDate desc ';
            vendorList=(List<PP_Vendor_Details__c>)Database.Query(Query);
            
        }
    
    if(vendorList.size()==0){
        vendorError='No Data Found';
    }
       }
  
    return null;
   }
   
   
   public pagereference selectedVendor(){
    vendorpopup=false;
    propOwnerVendorPopup=false;
    return null;
   }
  
  public pagereference noApproverAvailable(){
    isStandard=false;
    return null;
  }
  
  
  
  public pagereference cancelRequest(){
        if(requestDeatils.Status__c!='Submitted'){
        requestDeatils.Status__c='Cancelled';
        update requestDeatils; 
        }
        
        else
        {
                recallfromapproval(ApexPages.currentPage().getParameters().get('ID'));
                requestDeatils.Status__c='Cancelled';
            update requestDeatils; 
        
        }
        
        
        PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap');
        pr.setRedirect(true);
        return pr;
  }
  
  
  
  
  
    public String ER_watcher{get;set;}  
  
    public Boolean doValidation(){
    
        String i='0';    //added by Balakumar
        list<property_Detail__c> listdetails=new list<property_Detail__c>();  
        listofDetails_Manual =new list<property_Detail__c>();
        ER_watcher=null;  
        ER_RequestorEmployee=null;
        ER_RequestType=null;
        ER_Approver=null;
        ER_PropertyOwner=null;
        ER_OtherOwner=null;
        ER_CurrentManager=null;
        ER_RemovalType=null;
        ER_RemovalDate=null;
        ER_ReturnDate=null;
        ER_From=null;
        ER_To=null;
        ER_DestinationDetailsName=null;
        ER_EquipReceipt=null;
        ER_Purpose=null;
        ER_CSVUploadError=null;
        
        //new for fulfillment manager..,        
        ER_FulFillmentManager=null;
        
        boolean errorCheckonProperty=false;
        boolean propertyUploadError=false;
        
        
        if(RequestorEmployee == null || RequestorEmployee.trim() == ''){
            ER_RequestorEmployee=MandatoryErrorMessage;
        }
        
        //Added by Balakumar
         if(requestDeatils.CC_WatcherNames__c==null || requestDeatils.CC_WatcherNames__c.trim()==''){
            
        }
        else
        {
           if((requestDeatils.CC_WatcherNames__c != null && requestDeatils.CC_WatchList__c==null ) ){
              system.debug(requestDeatils.CC_WatcherNames__c+requestDeatils.CC_WatchList__c);
              
               ER_watcher='You must enter watcher via lookup';
                }
    
        }
        //End Balakumar
        
        if(requestDeatils.Request_Type__c == null || requestDeatils.Request_Type__c.trim() == ''){
            ER_RequestType=MandatoryErrorMessage;
        }
        
        if(CurrentManager == null || CurrentManager.trim() == '' ){
            ER_Approver=MandatoryErrorMessage;
        }
        
        if(requestDeatils.Property_Owner__c == null || requestDeatils.Property_Owner__c.trim() == ''){
            ER_PropertyOwner=MandatoryErrorMessage;
        }
        
        if((showAddOthers ==true || requestDeatils.Property_Owner__c=='Other' || requestDeatils.Property_Owner__c=='Vendor') && (requestDeatils.Other_Owners__c == null || requestDeatils.Other_Owners__c.trim() == '') ){
            ER_OtherOwner=MandatoryErrorMessage;
        }
        
        if(CurrentManager == null || CurrentManager.trim() == ''){
            ER_CurrentManager=MandatoryErrorMessage;
        }
        
        //new for fulfillment manager..,
        /*if((EDCCloseOutSection==true && (fulfillmanagerName == null || fulfillmanagerName.trim() == ''))){
            ER_FulFillmentManager=MandatoryErrorMessage;
        }
        else if(EDCCloseOutSection==false){
            fulfillmanagerName='';
            fulfillmanagerId=null;
        }*/
        
        if(requestDeatils.Removal_Type__c == null || requestDeatils.Removal_Type__c.trim() == ''){
            ER_RemovalType=MandatoryErrorMessage;
        }
        
        //Added by Balakumar
        Date d = Date.today();
        system.debug('---------------Removal Date is--------------'+removeDateStr);
        system.debug('---------------Todays Date is--------------'+d);
        //End Balakumar
        
        if(removeDateStr == null || removeDateStr.trim() == '' ){
            ER_RemovalDate=MandatoryErrorMessage;
        }
        else{
        
            Date d2= date.parse(removeDateStr);
            if (d2 < d){                                                
                        ER_RemovalDate= MandatoryErrorMessage1;
                }
                else{
                    requestDeatils.Removal_Date__c=date.parse(removeDateStr);
                        system.debug('*************requestDeatils.Expected_Return_Date__c'+removeDateStr+requestDeatils.Removal_Date__c);
                    }
        }
        
        system.debug('---------------Return Date is--------------'+returnDateDt);
        system.debug('---------------Todays Date is--------------'+d);
        
        
        if(ReturnDate==true && (returnDateDt == null || returnDateDt.trim()=='')){
            ER_ReturnDate=MandatoryErrorMessage;
        }
        else if(ReturnDate==false){
            requestDeatils.Expected_Return_Date__c=null;
        }
        else{
              Date d1= date.parse(returnDateDt);
              if (d1 < d){                                               
                        ER_ReturnDate= MandatoryErrorMessage1;                        
                    }
                else{     
                      requestDeatils.Expected_Return_Date__c=date.parse(returnDateDt);
                }
        } 
        if(requestDeatils.Location111__c == null){
            ER_From=MandatoryErrorMessage;
        }
        
        if(requestDeatils.Destination_Details__c == null || requestDeatils.Destination_Details__c.trim() == ''){
            ER_To=MandatoryErrorMessage;
        }
        
        if(AddSearchbox==true && (DestinationDetailsName == null || DestinationDetailsName.trim() == '')){
            ER_DestinationDetailsName=MandatoryErrorMessage;
        }  
        
        //Start Balakumar      
         if(AddVendor==true && (vendorNameUi == null || vendorNameUi.trim() == '')){
            ER_DestinationDetailsName=MandatoryErrorMessage;
        }        
         if(AddFreeText==true && (requestDeatils.Others__c == null || requestDeatils.Others__c.trim() == '')){
            ER_DestinationDetailsName=MandatoryErrorMessage;
        }
        //End Balakumar
        
                
        //Please Un-comment.
        /*if(EDCCloseOutSection==true && (requestDeatils.Equipment_Receipt_Confirm__c == null || requestDeatils.Equipment_Receipt_Confirm__c.trim() == '') ){
            ER_EquipReceipt=MandatoryErrorMessage;
        }*/
        //system.debug('---------------------------------Purpose Length--------------------------'+requestDeatils.Removal_Purpose__c.length());
        
        if(requestDeatils.Removal_Purpose__c == null || requestDeatils.Removal_Purpose__c.trim() == '' || requestDeatils.Removal_Purpose__c.trim() == 'Enter business purpose'){
            ER_Purpose=MandatoryErrorMessage;
            //system.debug('---------------------------------Purpose Length--------------------------'+requestDeatils.Removal_Purpose__c.length());
        }
        
        //Start Balakumar
         /*if(requestDeatils.Removal_Purpose__c.length()>4000){
                ER_Purpose='You are not allowed to enter more than 4000 characters.';
            }*/
        //End Balakumar    
        for(addmorerow X:innerlist){
            system.debug('check the list'+X);
            boolean first=false;
            boolean second=false;
            boolean third=false;
            boolean fourth=false;
            boolean fifth=false;
            boolean sixth=false;
            X.ErrorMessage=null;
            if(X!=null){            
                if(X.ProdDetails1.Property_Name__c == null || X.ProdDetails1.Property_Name__c==''){
                    first=true;
                }
                /*if(X.ProdDetails1.UOM__c==null || X.ProdDetails1.UOM__c==''){
                    second=true;
                }*/
                if((X.ProdDetails1.Quantity__c== null || X.ProdDetails1.Quantity__c.trim() =='')){
                    third=true;
                }
                if(X.ProdDetails1.Description__c==null || X.ProdDetails1.Description__c==''){
                    fourth=true;
                } 
                if( (X.ProdDetails1.Serial_No__c == null || X.ProdDetails1.Serial_No__c == '') && EDCCloseOutSection==true ){
                    fifth=true;
                } 
                if( (X.ProdDetails1.Asset_Tag__c == null || X.ProdDetails1.Asset_Tag__c == '') && EDCCloseOutSection==true ){
                    sixth=true;
                }        
                system.debug('**************'+first+second+third+fourth+fifth+sixth+X.ProdDetails1.Quantity__c);
                
                if( ( ((!first && !second && !third && !fourth && !EDCCloseOutSection) || ( EDCCloseOutSection && !first && !second && !third && !fourth && !fifth && !sixth)) && X.ProdDetails1.Quantity__c != null && X.ProdDetails1.Quantity__c.isnumeric()==true ) ){
                    listdetails.add(X.ProdDetails1);
                    propertyUploadError=true;
                }
                else if( (first && third && fourth && !EDCCloseOutSection) || (first  && third && fourth && fifth && sixth && EDCCloseOutSection) ){
                
                }
                else if(X.ProdDetails1.Quantity__c != null && X.ProdDetails1.Quantity__c.trim() != '' && X.ProdDetails1.Quantity__c.isnumeric()==false){
                    X.ErrorMessage='You must enter this value & Quantity should be numeric.';
                    errorCheckonProperty=true;
                }
                else{
                    X.ErrorMessage='You must enter this value & Quantity should be numeric.';
                    errorCheckonProperty=true;
                }        
            }
        }
        system.debug('*************error'+propertyUploadError +errorCheckonProperty+listofDeatisl.size());
        
        if((propertyUploadError || errorCheckonProperty) && (listofDeatisl.size()>0 || fileAttchment.size() >0)){
            ER_CSVUploadError='Error: You cant upload both files';
            system.debug('*************ER_CSVUploadError1');
        }
        else if(!propertyUploadError && !errorCheckonProperty && (listofDeatisl.size()<1 && fileAttchment.size() ==0)){
            ER_CSVUploadError='Error: Property details are mandatory for submition.';
            system.debug('*************ER_CSVUploadError2');
        }
        
        system.debug('*************ER_CSVUploadError'+ER_CSVUploadError);
        
        if(ER_RequestorEmployee != null || ER_RequestType!=null || ER_Approver!=null || ER_PropertyOwner!=null || ER_OtherOwner!=null || ER_CurrentManager!= null || ER_RemovalType!=null || ER_RemovalDate!=null || ER_ReturnDate!=null || ER_From!=null || ER_To!=null || ER_DestinationDetailsName!=null ||  ER_Purpose!=null || ER_CSVUploadError != null || errorCheckonProperty == true || ER_FulFillmentManager!=null || ER_watcher!=null){
            return false;
        }      
        else{
            system.debug('***************list'+listdetails);
            if(listdetails.size() > 0){
                listofDetails_Manual=listdetails;
            }
            system.debug('***************listofDetails_Manual1'+listofDetails_Manual);
            return true;
        }             
    }   

    Private static string getTabName(String strTab){
        String retTabName = '';
        if(strTab != Null){
            if(strTab == 'Myrequest')
                retTabName = 'My Request';
            else if(strTab == 'MyHistory')
                retTabName = 'My History';

            else if(strTab == 'MypendingApprovals')
                 retTabName = 'My Approvals';

            else if(strTab == 'MyclosedRequest')
                 retTabName = 'Close Requests';
            else
                retTabName = '';
         }
         return retTabName ;
    }
    Private static string getStatusName(String strStatus){
        String retStatusName = 'yet to determine';
        if(strStatus!= Null){
            if(strStatus== 'Saved')
                retStatusName = 'In Draft';
            else if(strStatus == 'Submitted')
                retStatusName = 'Pending Approval';
            else if(strStatus=='Recalled')
                retStatusName ='In Draft';
            else if(strStatus=='Approved')
                retStatusName ='Approved';
            else if(strStatus=='Closed')
                retStatusName ='Closed';
         
         else if(strStatus=='Rejected')
                retStatusName ='Rejected';
                else if(strStatus=='Pending Checked-in')
                retStatusName ='Pending Delivery Confirm';
        }
         else{
             retStatusName ='';
         }
         return retStatusName ;
    }
    
    public string[] getCleanFields(String[] initialStringList){    
        
        String[] cleanFields = new String[]{};   
                  
        String compositeField;
        Boolean makeCompositeField = false;
        for(String field : initialStringList) {
            field = field.trim();
            if (field.startsWith('"') && field.endsWith('"')) {                 
               // cleanFields.add(field.replaceAll('""','"'));
               cleanFields.add(field.replaceAll('"',''));
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ',' + field;                  
                cleanFields.add(compositeField.replaceAll('""','"'));
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField +=  ',' + field;
            } else {                  
                //cleanFields.add(field.replaceAll('""','"'));
                cleanFields.add(field.replaceAll('"',''));
            }
        }
        system.debug('******clean fields'+cleanFields);
    
        return cleanFields;
    }
   
   public pagereference CloseConfirm(){
   ConfirmationWindow=true;
   return null;
   }
   
    public pagereference CancelConfirm(){
   cancelConfrm=true;
   return null;
   }
  
   public boolean cancelConfrm{get;set;}
   public boolean ConfirmationWindow{get;set;}
    
   public pagereference closeRequest(){
//Removal_Date__c,Property_Description__c,
        //private method
        PR_Request__c a=[select name,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                        Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                        Removal_Purpose__c  from PR_Request__c where id=:ApexPages.currentPage().getParameters().get('id')];
                
                                        
        if(a!=null){
        a.Status__c='Closed';
        a.ClosedBy__c=userinfo.getUserId();
        a.ClosedDate__c=system.today();
        }
        /*
        else
        {
        if(a.status__C=='Approved'){
        a.status__C='Pending Checked-in';
        a.EDC_CloseOut_Approver__c='a00f0000005xiKd';
        }
        else
        {
        a.status__C='Closed';
        }
        }*/
        
        
        update a;
        PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap?tab=MyclosedRequest');
                  pr.setRedirect(true);
                   return pr;
}
 
 public String setActorname{get;set;}
 
 
 public pagereference SearchToBuilding(){
    
  //buildingList.clear();
  list<Building_Locations__c>  DummybuildingList =new list<Building_Locations__c>();
     
      //String Query='select id,name,City_State__c,Address1__c,Address2__c,BUILDING_NAME__c,CITY_DESCRIPTION__c from Building_Locations__c where';
      String Query='select id,name,City_State__c,Address1__c,Address2__c,CITY_DESCRIPTION__c from Building_Locations__c where';  
       
       if(DestinationDetailsName!=null || DestinationDetailsName!=''){
         Query+=' name  like \'%'+DestinationDetailsName+'%\' OR Address1__c like \'%'+DestinationDetailsName+'%\' OR Address2__c like \'%'+DestinationDetailsName+'%\' OR CITY_DESCRIPTION__c like \'%'+DestinationDetailsName+'%\' ';
       }  
       
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            //Or else Error Message to display..,
             buildingList=null;
        }
        else{
            Query+=' order by createdDate desc limit 26 ';
            system.debug('*********FinalQuery1:'+Query);
            buildingListto=(List<Building_Locations__c>)Database.Query(Query);            
        }
       
       system.debug('Hi Check'+DummybuildingList.size());
       
       
       
       
      //list<Building_Locations__c>  DummybuildingList=[select id,name,Building_Address__c,City_State__c,Address1__c,Address2__c,BUILDING_NAME__c,CITY_DESCRIPTION__c      
        // from Building_Locations__c where InScopeTo__c=true and BUILDING_NAME__c!=null ];   
        
       /* 
        
        map<String,Building_Locations__c> UniqueBuilding=new map<String,Building_Locations__c>();
         for(Building_Locations__c N1:DummybuildingList){
            If(UniqueBuilding.get(N1.BUILDING_NAME__c)==null){
                UniqueBuilding.put(N1.BUILDING_NAME__c,N1);
                buildingList.add(N1);
            }
            else
            {
                
            }
            
         } 
       
        */
        
        
    
    
    
    
    
    return null;
 }
 
 
 
 
 
 
  
   
 public List<ProcessInstanceHistory> getApprovalProcessStatus(){
        if (ApexPages.currentPage().getParameters().get('id')!= null) {
            //system.debug('Request Id :: ' + requestId + 'Approval Status :: ' + approvalStatus);
            PR_Request__c  quote = [Select Id,Approval_Rejection_Date__c , (Select Comments, RemindersSent, OriginalActorId, ActorId
                                                             From ProcessSteps where StepStatus='Approved'
                                                             order by SystemModstamp desc LIMIT 1)
                                       from PR_Request__c where id  = :ApexPages.currentPage().getParameters().get('id')];
              return quote.ProcessSteps;
            
            
            
        }
        return new List<ProcessInstanceHistory> ();
    }
       
 public list<sDocument> getdocuments(){
    list<sDocument> doclist=new list<sDocument>();
    for(Document X:attachments){
        doclist.add( new sDocument(X) );
    }
    return doclist;
 }
 
  public pagereference deletedocs(){
    list<String> selectedDocsToDelete=new list<String>();
        list<String> NotselectedDocsToDelete=new list<String>();
    
    system.debug('check'+getdocuments());
    integer h=0;
    for(sDocument V:getdocuments()){
        if(v.selecteddoc=true){
            String K=v.selectdoc.id;    
        selectedDocsToDelete.add(k.substring(0,15));
            
        }
        else
        {
            String K1=v.selectdoc.id;
            NotselectedDocsToDelete.add(k1.substring(0,15));
        }
        
    }
    system.debug('Test docs'+selectedDocsToDelete+NotselectedDocsToDelete);
    list<document> todel=new list<document>();
    todel=[select id,name,body,contentType,type from document where id in:selectedDocsToDelete];
  
    delete todel; 
    system.debug('test size'+todel.size());
    
    attachments=[select id,name,body,contentType,type from document where id in:NotselectedDocsToDelete];
    system.debug('test size'+attachments.size());
    
    
    return null;
    
 }
 
 public class   sDocument {
 public document selectdoc {get; set;}
 public boolean selecteddoc {get; set;}   
 public sDocument(document selectdoc){
    this.selectdoc=selectdoc;
    selecteddoc=false;
 }   

    
 } 
 
 /*
 
 public class sremovewatch{
 public employee__C selectedemptoremove{get;set;}
 public boolean selectedemp{get;set;}
 
 public sremovewatch(employee__c selectedemptoremove){
    this.selectedemptoremove=selectedemptoremove;
    selectedemp=false;
 }   
 
 
    
 }
 
 
 public list<sremovewatch> getremovewatch(){
    list<sremovewatch> warpperwatch=new list<sremovewatch>();
     String addedwatcher=requestDeatils.CC_WatchList__c;    
 list<String> v1=new list<String>();
 if(addedwatcher!=null){
    v1=addedwatcher.split(';');
 }  
    
    if(v1.size()>0){
    removeWatcher=[select id,name from employee__C where email__C in:v1];
    }
    else
    {
        removeWatcher=[select id,name from employee__C where email__C =:addedwatcher];
 
    }
    
   for(employee__c X:removeWatcher){
    warpperwatch.add( new sremovewatch(X) );
    }   
    
    return warpperwatch;
 
    
 }
 */
 
 
 public boolean removewatcherlist{get;set;}
 
 public pagereference removeaddedwatcher(){
    removewatcherlist=true;
    return null;
 }
 
 public pagereference savewatcher(){
    requestDeatils.CC_WatcherNames__c='';
    list<String> v1=new list<String>();
    String addedwatcher=requestDeatils.CC_WatchList__c; 
    
    if((requestDeatils.CC_WatchList__c!=null || requestDeatils.CC_WatchList__c!='') && addedwatcher.contains(';') ){
    v1=addedwatcher.split(';');
 system.debug('check'+v1.size()+v1);
 if(v1.size()>0){
    list<employee__C> H=[select id,name from employee__C where email__C in :v1 and status__c='Active'];
    for(employee__C XX:H){
        if(requestDeatils.CC_WatcherNames__c!=null || requestDeatils.CC_WatcherNames__c!=''){
        requestDeatils.CC_WatcherNames__c=requestDeatils.CC_WatcherNames__c+','+xx.Name;
        }
        else
        {
            requestDeatils.CC_WatcherNames__c=requestDeatils.CC_WatcherNames__c+xx.Name;
    
        }
    }
 }
    
    }
    
    
    else
    {
        if(addedwatcher.length()!=0){
            
 
    requestDeatils.CC_WatcherNames__c=[select name from employee__C where email__C=:addedwatcher and status__c='Active'].name;
 
 
        }
    }
    
    
    
    
    
    removewatcherlist=false;
    return null;
    
    
    
 }
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
   
}