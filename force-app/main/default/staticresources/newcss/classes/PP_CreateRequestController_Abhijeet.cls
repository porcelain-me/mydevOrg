public class PP_CreateRequestController_Abhijeet{
    
    public string userId;
    public boolean showPopupMessage{get;set;}
    public boolean showPopupMessage1{get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public List<SelectOption> statusOptions1 {get;set;}
    public List<SelectOption> PropertyOptions{get;set;}
    public List<SelectOption> requestType{get;set;}
    public String To_Others{get;set;}
    public String Other_Owners{get;set;}
    public String strOtherFormerEmployee{get;set;}
    public String nameFile{get;set;}
    Public Blob UploadCSV{get;set;}
    public Employee__c requestorEmp {get;set;}   //requestor
    private Employee__c loggedInEmp {get;set;}
    public PR_Request__c requestDeatils{get;set;}
    private list<Property_Detail__c> ProdDetailslist{get;set;}
    private property_Detail__c ProdDetails{get;set;}
    Public boolean ItemNoToRemoved{get;set;}
    Public boolean AddmoreRows{get;set;}
    Public Boolean AddOthers{get;set;}
    Public Boolean showPropOwnerVendor{get;set;}
    Public Boolean ReturnDate{get;set;}
    public String CurrentManager{get;set;}            
    Public List<Employee__c> ApproverList{get;set;}   
    public string fulfillmanagerName {get; set;}
    public boolean isEDCRequestFulfillment {get; set;}
    public string ER_FulFillmentManager{get; set;}
    public list<Propert_Service_approvers__c> PPSApproverList{get;set;}
    public boolean AddSearchbox{get;set;}
    public boolean AddFreeText{get;set;}
    public boolean AddVendor{get;set;}
    Public blob notesAndAttchment{get;set;}
    Public String FileName1{get;set;}
    public String currentManagerId{get;set;}    
    public String DestinationDetailsName{get;set;}
    //TO BE DELETED FROM UI
    public string ER_RequestorEmployee {get; set;}
    Public boolean EDCCloseOutSection{get;set;}
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
    public string ER_CSVUploadError{get; set;}
    public string ER_AttachUploadError{get;set;}
    public string ER_RequestNewPassForError{get;set;}
    private static final string MandatoryErrorMessage='Please select an Approver.';  
    public list<Building_Locations__c> buildingList{get;set;} 
    public list<Building_Locations__c> buildingListTo{get;set;} 
    public list<addmorerow> innerlist{get;set;}
    public String fromName {get;set;}
    public string strStatus {get; set;}
    public boolean isEDCRequest{get;set;}
    public boolean isPropertyservice{get;set;}
    public boolean isStandard{get;set;}
    private list<property_Detail__c> listofDeatisl{get;set;}
    private list<property_Detail__c> listofDetails_Manual{get;set;}
    public list<attachment> listofNotesAndAttchment{get;set;}
    public List<Attachment> fileAttchment{get;set;}
    public id AttachmentId{get;set;}
    public boolean showattachmentpopup{get;set;}
    public boolean showcsvuploadfile{get;set;}
    public boolean showbuildingpopup{get;set;}
    public String approvalcomments{get;set;}
    public String reworkcomments{get;set;}
    public boolean showrejectionPopup{get;set;}
    public boolean showreworkPopup{get;set;}
    public boolean showAddFormerEmployee{get;set;}
    public boolean showAddOthers{get;set;}
    public String RequestorEmployee{get;set;}
    public String RequesteeEmployee{get;set;}
    public Boolean showReqPopup{get;set;}
    public boolean addwatcher{get;set;}
    public list<Employee__C> EmployeeList{get;set;}
    public String watcherEmployee{get;set;}
    public String lastwatcher{get;set;}
    public boolean addsourcepopup{get;set;}
    public List<Document> doc {get; set;}
    public List<document> attachments {get; set;}
    public string DocumentId {get; set;}
    public boolean isOutofScope {get; set;}
    public string isOutofScopeTo {get; set;}
    public string docContentType {get; set;}
    public string removeDateStr{get; set;}
    public string returnDateDt{get; set;}
    public string dummyFlagforDatePicker {get; set;}
    public boolean isApprover1{get;set;}
    public boolean isFloorSecurity{get;set;}
    public String ApprovalStatus{get;set;}
    public integer propertyToDel{get;set;}        
    private string WatchersId {get; set;}
    private string WatchersUserId {get; set;} 
    private User LoggedInUser{get;set;}
    public boolean cancelConfrm{get;set;}
    public boolean deleteConfrm{get;set;}
    public boolean ConfirmationWindow1{get;set;}
    public boolean ConfirmationWindow{get;set;}
    public String ErroeOnDel{get;set;}
    Public list<sDocument>documentList1{get;set;}  
    Public String setActorname{get;set;}    
    Public String newerror{get;set;}
    public String ER_watcher{get;set;}  
    public String vendorNameUi{get;set;}
    public String VendorName{get;set;}
    public String vendorError{get;set;}
    public list<PP_Vendor_Details__c> vendorList{get;set;}
    public boolean propOwnerVendorPopup{get;set;}
    public boolean vendorpopup{get;set;}
    public String msgError{get;set;}
    public boolean msgError1 {get;set;}
    public String OfficeBuilding {get;set;}  
    public boolean isBlankEmailAdd {get;set;}
    
    //constructor starts here 
    Public PP_CreateRequestController_Abhijeet()
    {
        statusOptions = new List<SelectOption>();
        statusOptions1 = new List<SelectOption>();
        PropertyOptions = new List<SelectOption>();
        requestType = new List<SelectOption>();
        totalItemsPP=0;
        totalboxesPP=0;
        totalpalletsPP=0;
        documentList1=new list<sDocument>();
        EDCCloseOutSection=false;
        showMessage=false;
        isEDCRequestFulfillment=false;
        fulfillmanagerName='';
        approvalcomments=null;
        reworkcomments=null;
        DocumentId = '';
        dummyFlagforDatePicker='loaded';
        strStatus = PP_Util.getStatusName('Saved');
        isOutofScope =false;
        isOutofScopeTo ='No';
        buildingList=new list<Building_Locations__c>(); 
        buildingListto=new list<Building_Locations__c>();     
        PPSApproverList=new list<Propert_Service_approvers__c>();
        vendorList=  new list<PP_Vendor_Details__c>();        
        listofDeatisl=new list<property_Detail__c>();
        list<employee__c> ApproverList1=new list<Employee__C>();
        listofNotesAndAttchment=new list<Attachment>(); 
        fileAttchment=new List<Attachment>();
        innerlist=new list<addmorerow>();
        attachments =new List<Document>();
        doc=new List<Document>();
        isFloorSecurity = false;
        isApprover1= false;
        showAddFormerEmployee = false;
        showPropOwnerVendor =false;
        showAddOthers= false;
        isBlankEmailAdd = false;
        
        // APPLYING DEFAULT VALUE TO PICKLISTS
        Schema.DescribeFieldResult statusFieldDescription3 = PR_Request__c.Request_Type__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry3:statusFieldDescription3.getPicklistValues())
        {
            requestType.add(new SelectOption(pickListEntry3.getValue(),pickListEntry3.getLabel()));
            if (picklistEntry3.defaultValue){
                requestDeatils.Request_Type__c= pickListEntry3.getValue();
            }  
        }

        Schema.DescribeFieldResult statusFieldDescription = PR_Request__c.Property_Owner__c.getDescribe();
        statusOptions.add(new selectOption('', 'Select...'));
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues())
        {
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            if (picklistEntry.defaultValue){
                requestDeatils.Property_Owner__c = pickListEntry.getValue();
            }  
        }
        
        Schema.DescribeFieldResult statusFieldDescription1 = PR_Request__c.Destination_Details__c.getDescribe();
        statusOptions1.add(new selectOption('', 'Select...'));
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry1:statusFieldDescription1.getPicklistValues())
        {
            statusOptions1.add(new SelectOption(pickListEntry1.getValue(),pickListEntry1.getLabel()));
            if (picklistEntry1.defaultValue){
                requestDeatils.Destination_Details__c= pickListEntry1.getValue();
            }  
        }
        
        Schema.DescribeFieldResult statusFieldDescription2 = property_Detail__c.Property_Name__c.getDescribe();
        PropertyOptions.add(new selectOption('', 'Select...'));
        for (Schema.Picklistentry picklistEntry2:statusFieldDescription2.getPicklistValues())
        {
            PropertyOptions.add(new SelectOption(pickListEntry2.getValue(),pickListEntry2.getLabel()));
            if (picklistEntry2.defaultValue){
                ProdDetails.Property_Name__c= pickListEntry2.getValue();
            }  
        }
        
       
        //Property Service Approver Population
        Map<String, Propert_Service_approvers__c> PPSApprover = Propert_Service_approvers__c.getAll(); 
        for(Propert_Service_approvers__c r:PPSApprover.values())
        {
            PPSApproverList.add(r);
        }        
        PPSApproverList=PP_Util.sortList(PPSApproverList, 'name', 'asc');
        

        //get the logged in user details
        LoggedInUser = PP_Util.getLoggedinUserRecord();
        if(LoggedInUser == NULL) {
            return;
        }
        //LoggedInEmp
        requestorEmp  = PP_Util.getLoggedinEmployeeDetailsbyEmpID(LoggedInUser.Emp_Id__c);
        if(requestorEmp == NULL) {
            system.debug('**************NO EMPLOYEE FOUND WITH EMPID:'+LoggedInUser.Emp_Id__c);
            return;
        }            
        loggedInEmp = requestorEmp ;
        
        // ON CLICK OF REQUEST ID  -- VIEW REQUEST      
        if(ApexPages.currentPage().getParameters().get('id') != NULL) {
            system.debug('**************REQUEST ID CLICKED:'+ ApexPages.currentPage().getParameters().get('id'));

            isOutofScope = false;
            ApprovalStatus = '';
            List <PR_Request__c> reqDetails = PP_Util.getPPRequestDetails(ApexPages.currentPage().getParameters().get('id'));
            if(reqDetails != NULL && reqDetails.size() > 0) {
                //requestorEmp  = PP_Util.getLoggedinEmployeeDetailsbyEmpID(reqDetails[0].Employee_Requestee_Name__r.emp_ID__c);
                requestDeatils = reqDetails[0]; 
                system.debug('----------------RequestDeatils------------'+requestDeatils);
        
                //Identify if Logged in User is Approver 
                if( requestDeatils.request_type__c == PP_Util.STANDARD_REQUEST_TYPE) {
                    if(requestorEmp.ID == requestDeatils.Manager__c ) {
                        isApprover1 = true;
                    }
                } else {
                    if( PP_Util.getApproverByEmpIDAndGrpName(requestDeatils.Property_Service_Approver__c)) {    
                        
                        String w = requestDeatils.CC_WatcherNames__c;
                        //Checking if approver is a person who created a request/or submit on behalf of some one
                        if(requestDeatils.Employee_Requestor_Name__c <> requestorEmp.ID && 
                                requestDeatils.Employee_Requestee_Name__c <> requestorEmp.ID){
                                isApprover1 = true;
                        }
                        else{ //Check if Approver is in delegate list
                             if(w!= null && w.contains(requestorEmp.Name)) isApprover1 = true;
  
                        }
                    }
                    
                    /*********
                    if( PP_Util.getApproverByEmpIDAndGrpName(requestDeatils.Property_Service_Approver__c)) {    
                        String w = requestDeatils.CC_WatcherNames__c;
                        if(requestDeatils.Employee_Requestor_Name__c <> requestorEmp.ID && 
                                requestDeatils.Employee_Requestee_Name__c <> requestorEmp.ID){
                            if(w == NULL) {
                                isApprover1 = true;
                            } else {
                                if(!w.contains(requestorEmp.Name)) isApprover1 = true;
                            }
                        }
                    }
                   
                    
                    if( PP_Util.getApproverByEmpIDAndGrpName(requestDeatils.Property_Service_Approver__c)) {    
                        String w = requestDeatils.CC_WatcherNames__c;
                        if(w == NULL) { //No delegates
                            isApprover1 = true;
                        }
                        else{
                            if(!w.contains(requestDeatils.Employee_Requestee_Name__r.Name)) 
                                isApprover1 = true;
                        }
                    }**********/
                } 
                system.debug('----------------isApprover------------:'+isApprover1 );
                 isFloorSecurity = PP_Util.isSecurityAdmin();
                 system.debug('----------------isFloorSecurity ------------:'+isFloorSecurity );
                 
                if(requestDeatils.IsApprover__c){
                    ApprovalStatus = 'Approved';
                } else if(requestDeatils.IsRejected__c){
                    ApprovalStatus='Rejected';
                }
                
                if(requestDeatils.Other_Owners__c!=null ){
                    VendorName=requestDeatils.Other_Owners__c;
                    if(requestDeatils.Property_Owner__c=='Other')
                        Other_Owners = requestDeatils.Other_Owners__c;
                    else                
                        strOtherFormerEmployee = requestDeatils.Other_Owners__c;
                }
                
                if(requestDeatils.PP_Vendor_Details__c!=null){
                    vendorNameUi=requestDeatils.PP_Vendor_Details__r.name;
                }
                
                if(requestDeatils.Location111__r.name!=null){
                    fromname=requestDeatils.Location111__r.name;
                }  
            
                //requestDeatils.Employee_Requestee_Name__c = requestorEmp.id;
                RequestorEmployee=requestDeatils.Employee_Requestee_Name__r.name;
                system.debug('-----------RequestorEmployee----------'+RequestorEmployee);
                if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE && requestDeatils.Manager__c !=null){
                    CurrentManager=requestDeatils.Manager__r.name;  
                    currentManagerId =requestDeatils.Manager__c;
                 
                    
                    
                      
                }
                else{
                    system.debug('requestDeatils.Property_Service_Approver__c:' + requestDeatils.Property_Service_Approver__c);
                    CurrentManager = requestDeatils.Property_Service_Approver__c.subString(3, requestDeatils.Property_Service_Approver__c.length());
                }
                //system.debug('-------------DestinationDetails----------------'+requestDeatils.Destination__r.name);
                DestinationDetailsName=requestDeatils.Destination__r.name;               
                To_Others = requestDeatils.Others__c;
                strStatus = PP_Util.getStatusName(requestDeatils.Status__c);
                
                changeApprover_N();
                
                ownerDeatils_N();
                
                RemovalType_N();
                
                AddDestination_N();

                List<Attachment> allAttachments = [select id,name, description from Attachment where parentid=: ApexPages.currentPage().getParameters().get('id') ];            
                for(Attachment att: allAttachments ) {
                    //if(att.name == 'propertyfile.csv')
                    if(att.description == 'PP_CSV_File_Attachment')
                        fileAttchment.add(att);
                    else {     
                        listofNotesAndAttchment.add( att);
                    }
                }   
                
                ProdDetailslist = [select id, Description__c,Asset_Tag__c,Quantity__c,Property_Name__c,Boxes__c,Serial_No__c,Items__c,Pallets__c from property_Detail__c where request_details__c=:ApexPages.currentPage().getParameters().get('id') and Asset_Tag__c=null and Serial_No__c=null];
                
                if(ProdDetailslist != NULL && ProdDetailslist.size() > 0){
                    for(integer i=0;i<ProdDetailslist.size();i++){
                        innerlist.add(new addmorerow());                        
                    }
                    
                    if(ProdDetailslist.size() >1){
                        AddmoreRows=true; 
                    }    
                    else{
                        AddmoreRows=false;
                    }
                        
                    for(Integer j=1;j<innerlist.size();j++){
                        innerlist[j-1].addbutton=false;
                    }
                    
                    if(ProdDetailslist.size() > 0 ){
                        for(integer j=0;j<innerlist.size();j++){
                            for(integer i=0;i<ProdDetailslist.size();i++){
                                innerlist[i].ProdDetails1=ProdDetailslist[i];
                            }
                        }
                    }
                    
                    for(integer x1=0;x1<innerlist.size();x1++){
                        if(innerlist[x1].ProdDetails1.Items__c!=null){
                            integer d=integer.valueof(innerlist[X1].ProdDetails1.Items__c);
                            totalItemsPP=totalItemsPP+d;
                        }
                    
                        if(innerlist[x1].ProdDetails1.Boxes__c!=null){
                            integer d=integer.valueof(innerlist[x1].ProdDetails1.Boxes__c);
                            totalboxesPP=totalboxesPP+d;
                        }
                    
                        if(innerlist[x1].ProdDetails1.Pallets__c!=null){
                            integer d=integer.valueof(innerlist[x1].ProdDetails1.Pallets__c);
                            totalpalletsPP=totalpalletsPP+d;
                        }       
                    }   
                }
                if(requestDeatils.Removal_Date__c != null){
                    removeDateStr=requestDeatils.Removal_Date__c.month()+'/'+requestDeatils.Removal_Date__c.day()+'/'+requestDeatils.Removal_Date__c.year();
                }
                if(requestDeatils.Expected_Return_Date__c != null ){
                    returnDateDt=requestDeatils.Expected_Return_Date__c.month()+'/'+requestDeatils.Expected_Return_Date__c.day()+'/'+requestDeatils.Expected_Return_Date__c.year();
                }  
                List<ProcessInstanceHistory> x=getApprovalProcessStatus();
                 if(x.size()>0){
                  //setActorname=[select name from user where id=:x[0].ActorId].name ; 
                  setActorname=[select ActualApprover__r.name from PR_Request__c where id  =:ApexPages.currentPage().getParameters().get('id')].ActualApprover__r.name;               
                   system.debug('--------Size---------'+x.size());
                }
                //requestorEmp  = PP_Util.getLoggedinEmployeeDetailsbyEmpID(reqDetails[0].Employee_Requestee_Name__r.emp_ID__c);
            } 
            system.debug('**********************requestorEmp'+requestorEmp);
        } // VIEW REQUEST END
        // *****************************NEW REQUEST *******************************/
        else {
        
            showcsvuploadfile=false;
            showattachmentpopup=false;  
            
            //requestList =new list<PR_Request__c >();
            ApproverList=new list<Employee__c>();
            requestDeatils=new PR_Request__c();
            ProdDetailslist=new list<property_Detail__c>(); 
            ProdDetails=new property_Detail__c();
            ItemNoToRemoved=false;
            AddmoreRows=false;
            ReturnDate=false;
            lastwatcher='';
            innerlist=new list<addmorerow>();
            innerlist.add(new addmorerow());    
                    
            requestDeatils.Employee_Requestor_Name__c = requestorEmp.id; 
            requestDeatils.Employee_Requestee_Name__c = requestorEmp.id; 
            RequestorEmployee=requestorEmp.name;   
            
            if(requestorEmp.Manager__c != null ){
                CurrentManager = requestorEmp.Manager__r.name;
                currentManagerId = requestorEmp.Manager__r.id;
               
                
                     
                     
            } else {
            
           
                CurrentManager = requestorEmp.Assignment_Contact_Manager__r.Name;
                currentManagerId = requestorEmp.Assignment_Contact_Manager__c;
                
                 
                     
            }  
            
            if(requestorEmp.Building_Directory__c!=null || requestorEmp.Building_Directory__c!=''){
                list<Building_Locations__c> location  = PP_Util.getIndivBuildingDetail(requestorEmp.Building_Directory__c);
                if(location != NULL && location.size() > 0){
                    requestDeatils.Location111__c=location[0].id;
                    fromName = location[0].name;
                    isOutofScope=false;
                }else{
                    isOutofScope=true;
                }
            }else{
                    requestDeatils.Location111__c=null;
                    isOutofScope=true;
            }
            requestDeatils.Removal_Type__c='Permanent';
        }
    }
     
    /** 
        Method to check if Approver user is active. This only applies to MS Office request type and in other request types system admins has to configure 
        the approver groups and salesforce doesnt allow inactive users to be added.
    **/ 
    Public pagereference checkApproverActive() {
        if(currentManagerId != null) {
            List<Employee__c> approverEmp = PP_Util.getEmployeeRecordbyID(currentManagerId);
            if(approverEmp != NULL && approverEmp.size() > 0) {
                PP_Activateuser.updateApproverUser(approverEmp[0].User__c);
            }
         }   
        
         if(userId != null && userId.trim() != '') {
             system.debug('-----------WatchersUserID--------------'+userId);           
                    PP_Activateuser.updateWatcher(Id.ValueOf(userId));
            }
           
          
        return null;
    }    
    
     Public pagereference checkApproverManagerActive() {
        if(currentManagerId != null) {
            List<Employee__c> approverEmp = PP_Util.getEmployeeRecordbyID(currentManagerId);
            if(approverEmp != NULL && approverEmp.size() > 0) {
                PP_Activateuser.updateApproverUser(approverEmp[0].User__c);
            }
         } 
        return null;
      }  


    Private List<Employee__c> getApproversForStandardReqs(){
        system.debug('--------------Inside Approver--------------------'+requestDeatils.Employee_Requestee_Name__r.emp_ID__c +'--'+requestDeatils.Employee_Requestee_Name__c);
        //and emp_id__c <>:loggedInEmp.emp_id__c
        Employee__C emp=new employee__c();
        /*IF(requestDeatils.Employee_Requestee_Name__r.emp_ID__c !=null){        
            emp=PP_Util.getLoggedinEmployeeDetailsbyEmpID(requestDeatils.Employee_Requestee_Name__r.emp_ID__c);
        }
        elsE*/ 
        if(requestDeatils.Employee_Requestee_Name__c !=null){
            emp=PP_Util.getLoggedinEmployeeDetailsbyID(requestDeatils.Employee_Requestee_Name__c);
        }
        system.debug('***************'+emp.emp_id__c+'--'+emp.Cost_Center__c+'--'+emp.Manager__c+'--'+emp.Assignment_contact_Manager__c);
        
        ApproverList =[select id,emp_id__c, name,Dept_Dsc_Org__c, Building_Directory__c, Level_Dsc_Job__c from employee__c 
                       where Cost_Center__c=:emp.Cost_Center__c 
                       and Level_Dsc_Job__c in('Vice President','Executive Director','Managing Director') 
                       and emp_id__c <>:emp.emp_id__c
                       and user__c != null         
                       and status__c='Active' order by name asc]; 
        if(ApproverList != NULL && ApproverList.size()<=0){
        system.debug('--------------Inside Approver--------------------'+requestorEmp.Manager__c+requestorEmp.Assignment_contact_Manager__c);
            List<Employee__c> X=[select id,Cost_Center__c from Employee__c where (id=:emp.Manager__c or id=:emp.Assignment_contact_Manager__c )limit 1];  
           
            if(X != null && X.size() > 0 ) {
                //and emp_id__c <>: requestorEmp.emp_id__c  and emp_id__c <>:loggedInEmp.emp_id__c 
                ApproverList = [select id,emp_id__c, name,Dept_Dsc_Org__c, Building_Directory__c, Level_Dsc_Job__c from employee__c 
                where Cost_Center__c=:X[0].Cost_Center__c 
                and Level_Dsc_Job__c in ('Vice President','Executive Director','Managing Director') 
                and user__c != null                
                and status__c='Active' order by name asc];
                
            }
            system.debug('--------------Inside Approver--------------------'+X[0].Cost_Center__c); 
        }
        return ApproverList;
    }
   
    Public pagereference removeRow(){

        innerlist.remove(propertyToDel);
        if(innerlist.size()>=0){
            for(Integer j=0;j<(innerlist.size()-1);j++){
                innerlist[j].addbutton=false;
            }
            innerlist[(innerlist.size()-1)].addbutton=true;
        }
        
        if(innerlist.size()==1){
            AddmoreRows = false;
            innerlist[0].addbutton = true;
        }
        TotalItems();
        Totalbox();
        TotalPallets();
        return null;
    }
   public integer totalboxesPP{get;set;}
   public integer totalItemsPP{get;set;}
   
   Public pagereference TotalItems(){
       totalItemsPP=0;
        for(integer i=0;i<innerlist.size();i++){
            if(innerlist[i].ProdDetails1.Items__c!=null && innerlist[i].ProdDetails1.Items__c.isnumeric()){
                integer d=integer.valueof(innerlist[i].ProdDetails1.Items__c);
                totalItemsPP=totalItemsPP+d;
            }
        }
        return null;
    }
   
    public pagereference Totalbox(){
        totalboxesPP=0;
        for(integer i=0;i<innerlist.size();i++){
            if(innerlist[i].ProdDetails1.Boxes__c!=null && innerlist[i].ProdDetails1.Boxes__c.isnumeric()){
                integer d=integer.valueof(innerlist[i].ProdDetails1.Boxes__c);
                totalboxesPP=totalboxesPP+d;
            }
        }
        return null;
    }
    
   public integer totalpalletsPP{get;set;}
    public pagereference TotalPallets(){
        totalpalletsPP=0;
        for(integer i=0;i<innerlist.size();i++){
            if(innerlist[i].ProdDetails1.Pallets__c!=null && innerlist[i].ProdDetails1.Pallets__c.isnumeric()){
                integer d=integer.valueof(innerlist[i].ProdDetails1.Pallets__c);
                totalpalletsPP=totalpalletsPP+d;
            }       
        }
        return null;
    }
       

    Public Pagereference Addmore(){     
        for(integer i=0;i<1;i++){
            innerlist.add(new addmorerow());
            AddmoreRows=true; 
        } 
        
        for(Integer j=1;j<innerlist.size();j++){
            innerlist[j-1].addbutton=false;
        }
        
        calculateboxed();
        calculateitems();
        calculatePallets();

        return null;
    }

   private void calculateboxed(){
     totalboxesPP=0;
    for(integer i=0;i<innerlist.size();i++){
    if(innerlist[i].ProdDetails1.Boxes__c!=null && innerlist[i].ProdDetails1.Boxes__c.isnumeric()){
    integer d=integer.valueof(innerlist[i].ProdDetails1.Boxes__c);
    totalboxesPP=totalboxesPP+d;
        
            }
    }
   
   }
   
   private void calculateitems(){
     totalItemsPP=0;
    for(integer i=0;i<innerlist.size();i++){
    if(innerlist[i].ProdDetails1.Items__c!=null && innerlist[i].ProdDetails1.Items__c.isnumeric()){
    integer d=integer.valueof(innerlist[i].ProdDetails1.Items__c);
    totalItemsPP=totalItemsPP+d;
        
            }
    }
   }
   
   
   private void calculatePallets(){
     totalpalletsPP=0;
    for(integer i=0;i<innerlist.size();i++){
    if(innerlist[i].ProdDetails1.Pallets__c!=null && innerlist[i].ProdDetails1.Pallets__c.isnumeric()){
    integer d=integer.valueof(innerlist[i].ProdDetails1.Pallets__c);
    totalpalletsPP=totalpalletsPP+d;
    }       
        }
   }

  
    public Pagereference addOtherOwner(){
        system.debug('****'+requestDeatils.Property_Owner__c);
        if(requestDeatils.Property_Owner__c=='Other' || requestDeatils.Property_Owner__c=='Vendor'){
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
        //system.debug('***********getApproversForStandardReqs'+requestorEmp);
        if(requestDeatils.Request_Type__c== PP_Util.EDC_REQUEST_TYPE ){
            isEDCRequest=true;
            isPropertyservice=false;
            isStandard=false;        
        }
        
        else if(requestDeatils.Request_Type__c==  PP_Util.PROPERTY_SERVICES_REQUEST_TYPE ){
            isPropertyservice=true;
            isStandard=false;
            isEDCRequest=false;            
        }
        else{
            isEDCRequest=false;
            isStandard=true;
            isPropertyservice=false;  
    getApproversForStandardReqs();

                  
        }
        return null;
    }

    public Pagereference saveSelectedApprover(){
        checkApproverManagerActive();
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
        ConfirmationWindow1=false;
        ConfirmationWindow=false;
        showrejectionPopup=false;
        showreworkPopup=false;
        isEDCRequestFulfillment=false;
        showPopupMessage=false;
        showPopupMessage1=false;
        showPopupMessage2=false;
        isBlankEmailAdd = false;
        return null;
    }

    public pagereference changeApprover(){
        CurrentManager = null;
        if(requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE ) {
            if(requestorEmp.Job_Region_Code__c == 'NA'){
                CurrentManager='Americas_Data_Center_Approvers';
                requestDeatils.Property_Service_Approver__c='PP_Americas_Data_Center_Approvers';
            } else if(requestorEmp.Job_Region_Code__c == 'EU'){
                CurrentManager='EMEA_Data_Center_Approvers';
                requestDeatils.Property_Service_Approver__c='PP_EMEA_Data_Center_Approvers';
            } else{
                CurrentManager='Asia_Data_Center_Approvers';
                requestDeatils.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
            }
        } else if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE ){
            requestDeatils.Property_Service_Approver__c=null;
            if(requestorEmp.Manager__c !=null ){
                CurrentManager=requestorEmp.Manager__r.name;
                currentManagerId=requestorEmp.Manager__r.id;
            } else {
                CurrentManager = requestorEmp.Assignment_Contact_Manager__r.Name;
                currentManagerId = requestorEmp.Assignment_Contact_Manager__c;
            } 
        }
        system.debug('****************CurrentManager'+currentManagerId+CurrentManager);
        changeApprover_N();
        return null;
    }  
    
    public pagereference pagereload(){
    pagereference p=new pagereference('/apex/PP_CreateRequest?id='+ApexPages.currentPage().getParameters().get('id'));//+'&tab=MyRequest'
    p.setRedirect(true);
    return p;
    }
    public pagereference pageHome(){
     pagereference p=new pagereference('/apex/PP_RequestHome');
        p.setRedirect(true);
        return p;
    }
    public pagereference closepopup(){
        isOutofScope=false;
        return null;
    }  
    
    public void changeApprover_N(){
         EDCCloseOutSection=false;       
        if(requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE ) {
            EDCCloseOutSection=true;            
        }
    }

    public pagereference RemovalType(){
        RemovalType_N();
        return null;
    }
    
    public void RemovalType_N(){

        if(requestDeatils.Removal_Type__c=='Temporary'){
            dummyFlagforDatePicker='loaded';
            ReturnDate=true;
        }
        else{
            ReturnDate=false;
        }
    }    
   public boolean showuploadms{get;set;}

   Public pagereference UploadCSV(){
        String [] filelines = new string[]{};
        String contectfilecsv;  
        listofDeatisl = new list<property_Detail__c>();
        doc = new List<Document>();
        Boolean isAssetTagBlank =false;
        Boolean isSerialNoBlank = false;
        ER_CSVUploadError='';  

        try{ 
            if(!nameFile.contains('.csv')){
                ER_CSVUploadError = 'Error:  Only comma seperated file (CSV) extension is allowed. Please save the file in the correct format and retry.';
                showcsvuploadfile=true;
                showuploadms=true;
            }     
            else {
                
                showuploadms=false;  
                showcsvuploadfile=false;                
                contectfilecsv = UploadCSV.toString(); 
                filelines = contectfilecsv.split('\n'); 
                system.debug('****************Inside File UploadCSV: CSV file content:'+ filelines ); 
                system.debug('****************Inside File UploadCSV: CSV file cOLUMN nAMES:'+ filelines[0]);                  
 

                    
                if(!(filelines[0].contains('Serial No') || filelines[0].contains('serial no') || filelines[0].contains('Serial no')) ||
                    !(filelines[0].contains('asset tag') || filelines[0].contains('Asset Tag') || filelines[0].contains('Asset tag')) ||
                    !(filelines[0].contains('description') || filelines[0].contains('Description')) 
                     ){
                    ER_CSVUploadError='Error: � Serial No � Asset Tag � and Description � are required column names and  need to be the first 3 columns in that order. Please edit the file and try again.';
                    showcsvuploadfile=true;
                    showuploadms=true;
                    contectfilecsv=null;
                    UploadCSV=null;
                    return null;
                }
                //get the Asset Tag and Serial No columns
                String csvString=filelines[0];
                System.debug('Given String : '+csvString);
                List<String> listTokenStrings= getCleanFields(csvString.split(','));
                //);csvString.split(',',csvString.countMatches(',')+1);
                System.debug('listTokenStrings'+listTokenStrings );
                System.debug('Number of tokenized words in the given String '+listTokenStrings.size());
                Integer idxSerialNo = 0;
                Integer idxAssetTag = 0; 
                Integer idxDesc = 0;                
                for (Integer i=0; i < listTokenStrings.size(); i++){
                    System.debug('All:::::'+listTokenStrings[i]+ '**'+listTokenStrings[i].toLowerCase());
                    if(listTokenStrings[i].toLowerCase().trim() == 'serial no' ){
                        idxSerialNo = i;
                          System.debug('Serial No:'+listTokenStrings[i] +'--'+i);                        
                    }
                    else if(listTokenStrings[i].toLowerCase().trim() == 'asset tag'){
                        idxAssetTag = i;
                     System.debug('Asset Tag:'+listTokenStrings[i] +'--'+i);   
                    }
                    else if(listTokenStrings[i].toLowerCase().trim() == 'description'){
                        idxDesc = i;
                     System.debug('description:'+listTokenStrings[i]+'--'+i);   
                    }
                }                
               
                for (Integer i=1; i < filelines.size(); i++) {
                    String[] inputvalues = new String[]{};
                    system.debug('****************FileLines:'+filelines[i].split(','));
                    inputvalues = getCleanFields(filelines[i].split(','));
                    system.debug('*************inputvalues '+inputvalues.size()+inputvalues);
                    system.debug('****************idxSerialNo : '+idxSerialNo + inputvalues[idxSerialNo]);
                    system.debug('****************idxAssetTag : '+idxAssetTag + inputvalues[idxAssetTag] );
                    system.debug('****************idxDesc : '+idxDesc +inputvalues[idxDesc]);
                    property_Detail__c  a = new property_Detail__c();
                    if(inputvalues[idxSerialNo] !='' && inputvalues[idxAssetTag] !='' && inputvalues[idxDesc] !='') {
                        system.debug('****************Serial No: '+inputvalues[idxSerialNo] );
                        a.Serial_No__c=inputvalues[idxSerialNo];
                        system.debug('****************Asset Tag: '+inputvalues[idxAssetTag] );
                        a.Asset_Tag__c=inputvalues[idxAssetTag];
                        system.debug('****************Description: '+inputvalues[idxDesc] );
                        a.description__c=inputvalues[idxDesc];
                        listofDeatisl.add(a);    
                    }
                    else{
                        listofDeatisl=new List<property_Detail__c>();
                        break;
                    }
                }
                if(listofDeatisl.size() ==0 ) {
                    listofDeatisl=new List<property_Detail__c>();
                    contectfilecsv=null;
                    UploadCSV=null;
                    ER_CSVUploadError= 'Error: Serial No , Asset Tag and  Description data is required. If data is unavailable, enter �N/A�. Please edit the file and try again.';
                     showcsvuploadfile=true;
                      showuploadms=true;
                }  
                else{             
                    document docment=new document();
                    docment.Body=UploadCSV;
                    docment.FolderId=folderidset().substring(0,15);
                    //docment.Name='propertyfile.csv';
                    docment.Name=nameFile;
                    docment.ContentType=docContentType;
                    docment.type='csv';
                    insert docment; 
                    docment.body=null;
                    doc.add(docment);
                }
                contectfilecsv=null;
                UploadCSV=null;
                system.debug('************listofDetailsfile'+listofDeatisl);  
            }  
        }              
        catch (Exception e){
            doc=new List<Document>();
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file first, then click upload.');
            ApexPages.addMessage(errormsg);
            ER_CSVUploadError='Please select a file first, then click upload.';
            showcsvuploadfile=true;
            showuploadms=true;
            contectfilecsv=null;
            UploadCSV=null;
            return null;
        } 
       return null;
    }   

    Public pagereference AddDestination() {
        newerror=null;
        DestinationDetailsName=null;
        To_Others  =null;
        vendorNameUi = null;
        OfficeBuilding = null;
        AddDestination_N();        
        Return null;
    }
    
    private Void AddDestination_N(){
       ER_To = null;
        if(requestDeatils.Destination_Details__c=='MS Data Center' || requestDeatils.Destination_Details__c=='MS Office Building'){       
            AddSearchbox=true;
            AddFreeText=false;
            AddVendor=false;
            OfficeBuilding = DestinationDetailsName;
            
        }
        else if( (requestDeatils.Destination_Details__c=='Charitable Donation' || requestDeatils.Destination_Details__c=='Disposal'|| requestDeatils.Destination_Details__c=='Other' || requestDeatils.Destination_Details__c=='Hiring Agency') ){      
           AddSearchbox=false;
            AddFreeText=true;
            AddVendor=false;
            
        }
        else if( ((requestDeatils.Request_Type__c=='Data Center (EDC only)'|| requestDeatils.Request_Type__c=='Facilities/Move Mgmt (Prop Svcs only)' || requestDeatils.Request_Type__c =='MS Office (Most common)') && requestDeatils.Destination_Details__c=='Vendor')){ 
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

    Private void cleanUpToFields(){
        if(requestDeatils.Destination_Details__c=='MS Data Center' || requestDeatils.Destination_Details__c=='MS Office Building'){       
            requestDeatils.PP_Vendor_Details__c = null;
            requestDeatils.Others__c = null;
        }
        else if( (requestDeatils.Destination_Details__c=='Charitable Donation' || requestDeatils.Destination_Details__c=='Disposal'|| requestDeatils.Destination_Details__c=='Other' || requestDeatils.Destination_Details__c=='Hiring Agency') ){      
            requestDeatils.Destination__c = null;
            requestDeatils.PP_Vendor_Details__c = null;
            requestDeatils.Others__c = To_Others;
        }
        else if( requestDeatils.Destination_Details__c=='Vendor'){ 
            requestDeatils.Others__c = null;
            requestDeatils.Destination__c = null;
        }
        
        
        else if( requestDeatils.Destination_Details__c=='Home'){ 
            requestDeatils.Others__c = null;
            requestDeatils.Destination__c = null;
            requestDeatils.PP_Vendor_Details__c = null;
        }
        
       if(requestDeatils.Property_Owner__c=='Other' ){
            requestDeatils.Other_Owners__c = Other_Owners;
        }
        else if( requestDeatils.Property_Owner__c=='Former Employee or Contractor' ){
            requestDeatils.Other_Owners__c = strOtherFormerEmployee ;
        }
        //DestinationDetailsName = OfficeBuilding ;
        

    }

    Public pagereference saveRequest(){
    
        //To check if someone has already saved the request
        /**
        if(requestDeatils.Id != null) {  
            List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(requestDeatils.Id);
            if(chkStatus == null )  return null;
            if(chkStatus[0].Status__c == 'Saved') {
                showPopupMessage = true;
                return null;
            }
        } **/
        
        cleanUpToFields();
        
        if(removeDateStr == null || removeDateStr.trim() == '' ) {
            removeDateStr = null;
            requestDeatils.Removal_Date__c = null;
        }  
        else if(removeDateStr == 'NaN/NaN/NaN') {
            removeDateStr = null;
            requestDeatils.Removal_Date__c = null;
        }
        else
        {
        requestDeatils.Removal_Date__c=date.parse(removeDateStr);
        }
        
        if(ReturnDate==true && (returnDateDt == null || returnDateDt.trim()=='')){
            requestDeatils.Expected_Return_Date__c=null;
        }
        else if(ReturnDate==false){
            requestDeatils.Expected_Return_Date__c=null;
        }
        else if(ReturnDate==true && returnDateDt == 'NaN/NaN/NaN')
        {
        returnDateDt = null;
        requestDeatils.Expected_Return_Date__c=null;
        }else
        {
        requestDeatils.Expected_Return_Date__c=date.parse(returnDateDt);
        }
        
        if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE){
            requestDeatils.Manager__c = currentManagerId;
        } else {
            requestDeatils.Manager__c=null;
            requestDeatils.Escalate_to_Admin__c=true;
        }
        system.debug('----------RequestDetails save-----------'+requestDeatils);
        if(requestDeatils.Id==null){
            insert requestDeatils;
        } else {
            update requestDeatils;
        }
         if(listofDeatisl!= null && listofDeatisl.size() > 0){
            for(property_Detail__c X: listofDeatisl){
                X.request_details__c=requestDeatils.id;
                X.Id=null;
            }
            insert listofDeatisl;
           
            if(doc.size() > 0 && doc[0].Id != null){
                Document d=[select id,body,contentType,type,name from document where id=:doc[0].ID];
                //Attachment att=new Attachment(name='propertyfile.csv',ParentId=requestDeatils.id,body=d.body);
                Attachment att=new Attachment(name=nameFile,ParentId=requestDeatils.id,body=d.body,description='PP_CSV_File_Attachment');
                
                insert att;
                att.body=null; 
                d=null;               
            }
        }
        if(innerlist != null && innerlist.size() > 0){
            List<property_Detail__c> dummy=new List<property_Detail__c>();
            for(addmorerow X: innerlist){
                property_Detail__c d=new property_Detail__c ();
                d.request_details__c=requestDeatils.id;
                d.Property_Name__c =X.ProdDetails1.Property_Name__c ;
                d.Quantity__c=X.ProdDetails1.Quantity__c;
                d.Description__c=X.ProdDetails1.Description__c;
                d.Asset_Tag__c=X.ProdDetails1.Asset_Tag__c;
                d.Serial_No__c=X.ProdDetails1.Serial_No__c;
                 d.Boxes__c=X.ProdDetails1.Boxes__c;
                d.Items__c=X.ProdDetails1.Items__c;
                d.Pallets__c=X.ProdDetails1.Pallets__c;
                dummy.add(d);
            }
            insert dummy;
        }    
        
        if(attachments.size() >0){
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
        
        PageReference pr = new PageReference('/apex/PP_RequestHome');
        pr.setRedirect(true);
        return pr;
   }
    
    public pagereference submitRequest(){ 
        //To check if someone has already submitted the request
        if(requestDeatils.Id != null) {  
            List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(requestDeatils.Id);
            if(chkStatus == null )  return null;
            if(chkStatus[0].Status__c == 'Submitted') {
                showPopupMessage = true;
                return null;
            }
              
        }
        
            Id userid;
            List<Employee__c> eList;     
            cleanUpToFields();
    
            if(!doValidation()){
                return null;
            }  
            system.debug('********Current Manager in SubmitRequest:'+currentManagerId);
            
            requestDeatils.submitted_date__c=system.today();
            if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE ){
                requestDeatils.Manager__c = currentManagerId;
                eList = PP_Util.getEmployeeRecordbyID(currentManagerId);
                if(eList != NULL && eList.size()> 0){
                    userId = eList[0].User__c;
                }
                system.debug('********UserID in SubmitRequest:'+userId);
               
                system.debug('********requestDeatils.Manager__c in SubmitRequest:'+requestDeatils.Manager__c);
            }
            else
            {
                requestDeatils.Manager__c=null;
                requestDeatils.Escalate_to_Admin__c=true;
            }
            if(requestDeatils.Id==null){  
                insert requestDeatils;    
            }
            else
            {    
                update requestDeatils;
            }
            
            //insert the attachchment import functionality
            if(listofDeatisl!= null && listofDeatisl.size() > 0){
                for(property_Detail__c X: listofDeatisl){
                    X.request_details__c=requestDeatils.id;
                    X.Id=null;
                }
                insert listofDeatisl;
                
                if(doc.size() > 0 && doc[0].Id != null){
                    Document d=[select id,body,name,contentType,type from document where id=:doc[0].ID];
                    //Attachment att=new Attachment(name='propertyfile.csv',ParentId=requestDeatils.id,body=d.body);
                    Attachment att=new Attachment(name=nameFile,ParentId=requestDeatils.id,body=d.body, description='PP_CSV_File_Attachment');
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
                    d.Boxes__c=X.Boxes__c;
                    d.Items__c=X.Items__c;
                    d.Pallets__c=X.Pallets__c;
                    dummy.add(d);
                }
                //upsert listofDetails_Manual;
                upsert dummy;
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
            
            list<attachment> attchedDocs=new list<attachment>();
          
          attchedDocs=[select id,name from Attachment where parentid=: requestDeatils.id AND name !='propertyfile.csv'];
          if(attchedDocs.size()>0){
            requestDeatils.IsAttachment__c=true;
            update requestDeatils;
            
          }
             
            //newly added.
            if(ProdDetailslist != null && ProdDetailslist.size() > 0){
                delete ProdDetailslist;
            }
            
            if(requestDeatils.Manager__c!=null){
                Approval.ProcessResult result = null;
                Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                request.setObjectId(requestDeatils.id); 
                request.setNextApproverIds(new Id[] {userid});
                result  =   Approval.process(request); 
            }
            else
            {
                 Approval.ProcessResult result = null;
                 Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                 request.setObjectId(requestDeatils.id); 
                result  =   Approval.process(request); 
            }
            
            Id workItemId;
            Boolean isSameApprover = false;
            if( requestDeatils.request_type__c == PP_Util.STANDARD_REQUEST_TYPE) {
                //AS PER LATEST REQUIREMENTS - REQUESTOR CANN'T SELF APPROVE HIS/HER OWN REQUEST
                if(PP_Util.getLoggedinEmployeeDetailsbyEmpID(LoggedInUser.Emp_Id__c).ID == requestDeatils.Manager__c) {
                    isSameApprover = true;
                }
            } 
            else {
            
            
               //Added to check whether Employee Requestee is not equal to Logged in User
               List<Employee__c> empDetails = PP_Util.getEmployeeRecordbyID(requestDeatils.Employee_Requestee_Name__c);
               requestorEmp = empDetails[0];
                System.debug('******requestorEmp*****'+ requestorEmp.user__c +'@@@@@@@'+ LoggedInUser.ID );
               System.debug('*******requestDeatils.Employee_Requestee_Name__c****'+ requestDeatils.Employee_Requestee_Name__c);
               //End
               
               isSameApprover = (requestorEmp.user__c != LoggedInUser.ID && PP_Util.getApproverByEmpIDAndGrpName(requestDeatils.Property_Service_Approver__c));               
            }
        
            system.debug('**************isSameApprover ::'+isSameApprover );
        
            if(isSameApprover ) {
            
                system.debug('******************INSIDE SELF APPROVAL************'+ requestDeatils.id);
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approving request using Trigger');
                req.setAction('Approve');
                for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p  where p.ProcessInstance.TargetObjectId =: requestDeatils.id] )
                {
                    workItemId =  workItem.Id;
                }
                
                
                if(workItemId == null)
                {
                    SYStem.debug('Error occured in PP_CreateRequestController_Abhijeet SubmitRequest() while doing AutoApproval');
                }
                else
                {
                    req.setWorkitemId(workItemId);
                    Approval.ProcessResult result =  Approval.process(req);
                }
    
                //update the actor id 
                //requestDeatils.ActualApprover__c=requestorEmp.user__c; //userinfo.getUserId();
                PR_Request__c requestDeatils_New=[select id,name,ActualApprover__c from PR_Request__c where Id=:requestDeatils.ID];
                requestDeatils_New.ActualApprover__c=userinfo.getUserid();//requestorEmp.user__c; //userinfo.getUserId();
                update requestDeatils_New;
                
                  
        
                
            }
        
            PageReference pr = new PageReference('/apex/PP_RequestHome');
            pr.setRedirect(true);
            
            return pr;
        }
     
     private string folderidset(){
        String V=[select id,name from folder where name='Property Pass' and type='Document'].id;
        return V;
    }
    
    //modify the folder id with folder name
    public boolean showuploadattachment{get;set;}   
    
    Public pagereference UploadAttachment(){
        document newattchment = new document();
        newattchment.FolderId=folderidset().substring(0,15);   
        newattchment.Body = notesAndAttchment;        
        newattchment.Name=FileName1;        
        try {
            showuploadattachment=false;
            insert newattchment;
            attachments.add(newattchment);
            documentList1.add(new sDocument(newattchment));
            newattchment.body=null;
            notesAndAttchment=null;
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a file first, then upload.'));
          ER_AttachUploadError='Please select a file first, then upload.';
          showuploadattachment=true;
          return null;
        } 
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        showattachmentpopup=false;
        return null;
     }

    public class addmorerow{    
        Public property_Detail__c ProdDetails1{get;set;}
        public string ErrorMessage {get; set;}
        
        /*
        *  Added by Avinash Munaga
        */
        public string ErrorMessage1 {get; set;}
        public string ErrorMessage2 {get; set;}
        public string ErrorMessage3 {get; set;}                
        public boolean addbutton{get;set;}
        
        public addmorerow(){
            ProdDetails1=new property_Detail__c();
            ProdDetails1.items__c='0';
            ProdDetails1.boxes__c='0';
            ProdDetails1.pallets__c='0'; 
            ErrorMessage =null;
            addbutton=true;
            
            /*
            *  Added by Avinash Munaga
            */
            ErrorMessage1 =null;
            ErrorMessage2 =null;
            ErrorMessage3 =null;
                        
        }
    }
   
    
    private void recallfromapproval(String Id){
        
         ProcessInstance piFSA = [Select ID, Status From ProcessInstance Where TargetObjectID = :ID AND Status = 'Pending'];
               
        if(piFSA !=Null){
            ProcessInstanceWorkitem piwiFSA = [select Id,OriginalActorId from ProcessInstanceWorkitem where ProcessInstanceId= :piFSA.Id LIMIT 1];
            Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
            prWkItem.setWorkItemID(piwiFSA.id);
            prWkItem.setComments('Recall request');
            prWkItem.setAction('Removed');
            Approval.ProcessResult appResult = Approval.process(prWkItem);
        }        
    }
    
    //recall submitted request
    Public pagereference recallRequest() {
        /*
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('ID'));
        if(chkStatus == null )  return null;
         if(chkStatus[0].Status__c == 'Recalled') {
            showPopupMessage = true;
        }
        else { **/
            recallfromapproval(ApexPages.currentPage().getParameters().get('ID'));
            ConfirmationWindow = false;
            ConfirmationWindow1 = false;
            requestDeatils.Status__c = 'Recalled';            
            update requestDeatils;
            OfficeBuilding=requestDeatils.Destination__r.Name;
        //}
        strStatus = 'In Draft';
        pagereference p = new pagereference('/apex/PP_CreateRequest?id='+requestDeatils.Id);
        return p; 
    }
    
    
    
    
    
    
    
    Public pagereference recallrequestconfirm() {
    
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('ID'));
        if(chkStatus == null )  return null;
         if(chkStatus[0].Status__c == 'Recalled' || chkStatus[0].Status__c == 'Approved' || chkStatus[0].Status__C == 'Rejected' ) {
            showPopupMessage = true;
        }
        else {
            ConfirmationWindow = true;
            //system.debug('******************ConfirmationWindow ::'+ConfirmationWindow );
        }
        return null;
    }


    Public pagereference deleteAttachment(){
        if(AttachmentId != null){
            system.debug('----------------------Inside deleteAttachment:----------------'+AttachmentId);     
            Attachment a=[select id from attachment where id =:AttachmentId];
            delete a;    
            listofNotesAndAttchment = [select id,name from Attachment where parentid=: ApexPages.currentPage().getParameters().get('ID')  AND description != 'PP_CSV_File_Attachment'];
            AttachmentId = null;
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
    
    Public pagereference DeleteFile(){
        if(AttachmentId!=null){
            Attachment a=[select id from attachment where id =:AttachmentId];
            delete a;            
            fileAttchment=[select id,name from Attachment where parentid=: ApexPages.currentPage().getParameters().get('id') AND description = 'PP_CSV_File_Attachment'];
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
       return null;
    }
    
    
    public pagereference buildingData(){
        buildingListto.clear();        
        newerror=null;
        msgError=null;
        msgError1=false;
        DestinationDetailsName = null;
        showbuildingpopup=true;
        return null;
    }
    
    public pagereference selectedBuiding(){
        showbuildingpopup=false;
        return null;
    }    

    public pagereference clear(){ 
        PageReference pr = new PageReference('/apex/PP_CreateRequest?tab='+ApexPages.currentPage().getParameters().get('tab'));
        pr.setRedirect(true);
        return pr;
    }
    
    private Boolean chkrejectorlist;


    Public pagereference takeaction() {
        
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('id'));
        if(chkStatus == null )  return null;
        
        
        String s = chkStatus[0].Approvers_List__c;
      
        System.debug('aaaaaaaaaaaaaaaa' + loggedInEmp.Email__c + 'bbbbbbbbbbb' );
        System.debug('************' + chkStatus[0].Approvers_List__c+ 'bbbbbbbbbbb' );
        if(s.contains(loggedInEmp.Email__c))
        {
                chkrejectorlist = true;
        }
        
        
        
        if(chkStatus[0].Status__c == 'Rejected' || chkStatus[0].Status__c == 'Approved') {
            showPopupMessage=true;
        }  
        else if(chkStatus[0].Status__c == 'Recalled' || chkStatus[0].Status__c == 'Saved') {
            showPopupMessage1=true;
        } 
        else {
            if(chkrejectorlist==true)
                showrejectionPopup=true;
            else
            {
                showPopupMessage2=true;
            }    
        }
        return null;
    } 
    
   private Boolean chkreworklist; 
   //Add for PROPPASS-47  
   Public pagereference reWork() {
        
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('id'));
        if(chkStatus == null )  return null;
        
        
        String s = chkStatus[0].Approvers_List__c;
      
        System.debug('aaaaaaaaaaaaaaaa' + loggedInEmp.Email__c + 'bbbbbbbbbbb' );
        System.debug('************' + chkStatus[0].Approvers_List__c+ 'bbbbbbbbbbb' );
        if(s.contains(loggedInEmp.Email__c))
        {
                chkreworklist = true;
        }
        
        
        
        if(chkStatus[0].Status__c == 'Rejected' || chkStatus[0].Status__c == 'Approved' ) {
            showPopupMessage=true;
        }  
        else if(chkStatus[0].Status__c == 'Recalled' || chkStatus[0].Status__c == 'Saved') {
            showPopupMessage1=true;
        } 
        else {
            if(chkreworklist ==true)
                showreworkPopup=true;
            else
            {
                showPopupMessage2=true;
            }    
        }
        return null;
    } 
    //End
    
     
    
   private Boolean chkapproverlist;
   Public Boolean showPopupMessage2{get;set;} 
   Public pagereference approveRequest() {
        chkapproverlist = false;
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('id'));
        if(chkStatus == null )  return null;
        String s = chkStatus[0].Approvers_List__c;
      
        System.debug('aaaaaaaaaaaaaaaa' + loggedInEmp.Email__c + 'bbbbbbbbbbb' );
        System.debug('************' + chkStatus[0].Approvers_List__c+ 'bbbbbbbbbbb' );
        if(s.contains(loggedInEmp.Email__c))
        {
                chkapproverlist = true;
        }
        
        System.debug('************' + s.contains(loggedInEmp.Email__c) + 'bbbbbbbbbbb' );
        System.debug('aaaaaaaaaaaaaaaa' + chkapproverlist  + 'bbbbbbbbbbb' );

        if(chkStatus[0].Status__c == 'Approved' || chkStatus[0].Status__c == 'Rejected') {
            showPopupMessage=true;
            return null;
        }  
        else if(chkStatus[0].Status__c == 'Recalled' || chkStatus[0].Status__c == 'Saved') {
            showPopupMessage1=true;
            return null;
        }
        
        else if (chkapproverlist == false )
        {
            showPopupMessage2=true;
            return null;
        }
        
        //Check Approver Group if the user is the right approver
        //if(chkStatus.Approvers_List__c
        
        //End 
        else {
            showrejectionPopup=false;
            Approval.ProcessResult result = null;
            List<Id> newWorkItemIds = null;
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();        
            req2.setAction('Approve');
            ProcessInstanceWorkitem newProcess = [Select Id, processinstance.targetobjectid From ProcessInstanceWorkitem 
                                                  where processinstance.targetobjectid = :ApexPages.currentPage().getParameters().get('ID')];
            req2.setWorkitemId(newProcess.Id);
            result = Approval.process(req2);
            newWorkItemIds = result.getNewWorkitemIds(); 
            
            //update the actor id 
            PR_Request__c V1 = [select id from PR_Request__c where id =:  ApexPages.currentPage().getParameters().get('ID')];
            if(V1!=null){
                v1.ActualApprover__c=userinfo.getUserId();
            }
            Update v1;
            
            pagereference p = new pagereference('/apex/PP_RequestHome');
            return p;
        }
    }
        
    public boolean showMessage{get;set;}

    
    Public pagereference RejectRequest(){
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
            PR_Request__c V1 = [select id from PR_Request__c where id =:  ApexPages.currentPage().getParameters().get('ID')];
            if(V1!=null){
                v1.ActualApprover__c=userinfo.getUserId();
                update v1;
            }
            pagereference p=new pagereference('/apex/PP_RequestHome');
            return p;
        }
        else
        {
            showrejectionPopup=true;
            showMessage=true;
            return null;
        }
           
    }
    
    
    Public pagereference ReworkRequest(){
    
    PR_Request__c reWorkSt  = [select name,ReworkComments__c,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                          Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                          Removal_Purpose__c  from PR_Request__c where id=:ApexPages.currentPage().getParameters().get('id')];
    system.debug('-----Inside Re-work------------'+reWorkSt);
            
     
     if( reWorkSt != null && reworkcomments.length()!=0 && reworkcomments.length() < 32768 ){
        if(reWorkSt.status__c != 'Saved')
        {
        system.debug('-----Inside Re-work------------'+reworkcomments);
        recallfromapproval(ApexPages.currentPage().getParameters().get('ID'));
        reWorkSt.ReworkComments__c = reworkComments;
        reWorkSt.ActualApprover__c=userinfo.getUserId();
        reWorkSt.Status__c = 'Saved';
        update reWorkSt;
        pagereference p=new pagereference('/apex/PP_RequestHome');
            return p;
        }
        else{
        showPopupMessage1=true;return null;
         }  
        }
        else
        {
            showrejectionPopup=true;
            showMessage=true;
            return null;
        }
        PageReference pr = new PageReference('/apex/PP_RequestHome');
        pr.setRedirect(true);
        return pr; 
           
    }
    
    
    public pagereference ownerDeatils(){
        Other_Owners = null;
        strOtherFormerEmployee = null;
        ownerDeatils_N();
        return null;
    }
    
    public void ownerDeatils_N(){
        showPropOwnerVendor =false;
        showAddOthers= false;
        showAddFormerEmployee = false;
        ER_OtherOwner = null;
        if(requestDeatils.Property_Owner__c=='Other' ){
            showAddOthers=true;
        }
        else if (requestDeatils.Property_Owner__c=='Former Employee or Contractor' ){
            showAddFormerEmployee = true;
        }
    }

    Public pagereference SearchEmployee(){
        RequesteeEmployee=null;
        EmployeeList=null;
        msgError1 = false;
        msgError = null;
        showReqPopup=true;
        return null;
    }
    
    Public pagereference WatcherEmployee(){
        watcherEmployee=null;
        EmployeeList=null;
        msgError1 = false;
        msgError = null;
        addwatcher=true;
        return null;
    }

    Public pagereference FilterWatcherEmployee(){
       if((watcherEmployee==null || watcherEmployee=='') &&(RequesteeEmployee!=null || RequesteeEmployee!='') && (RequesteeEmployee!=null && RequesteeEmployee.length()<=2) ){
           msgError1=true;
           msgError='Please enter a minimum of 3 characters.';
       }
       else if((RequesteeEmployee==null || RequesteeEmployee=='')&& (watcherEmployee!=null || watcherEmployee!='') && watcherEmployee.length()<=2){
            msgError1=true;
            msgError='Please enter a minimum of 3 characters.';
       }
       
       else
       {
        EmployeeList=null;
        msgError1 = false;
        msgError=null;
        String Query='select id,emp_id__c,Officer__c,Division_Dsc_Org__c,CC_City_Dsc_Org__c,Floor_Directory__c, name,First_Name__c, Last_Name__c,Dept_Dsc_Org__c,Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where'; 
        if(watcherEmployee!=null || watcherEmployee!=''){        
            if(watcherEmployee.length()<=2){
                msgError1=true;
               msgError='Please enter a minimum of 3 characters.';
            }else{
             Query+=' (name like \'%'+watcherEmployee+'%\' OR emp_id__c=\''+watcherEmployee+'\') and status__c=\'Active\'';
            }
        }
        
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            EmployeeList=null;
        }
        else{
            Query+='  order by name asc ';
            EmployeeList=(List<Employee__C>)Database.Query(Query);
            if(EmployeeList.size() > 20){
                    msgError='Too many search results found. Please narrow your search criteria and try again.';
                    msgError1 = true;
                    EmployeeList=null;
                    return null;
            }
        }
       }
        return null;
    }
    
    Public pagereference FilterRequestorEmployee(){
        if((watcherEmployee==null || watcherEmployee=='') &&(RequesteeEmployee!=null || RequesteeEmployee!='') && (RequesteeEmployee!=null && RequesteeEmployee.length()<=2) ){
           msgError1=true;
           msgError='Please enter a minimum of 3 characters.';
        }
        else if((RequesteeEmployee==null || RequesteeEmployee=='')&& (watcherEmployee!=null || watcherEmployee!='') && watcherEmployee.length()<=2){
            msgError1=true;
            msgError='Please enter a minimum of 3 characters.';
        }
        else {
            EmployeeList=null;
            msgError1 = false;
            msgError=null;
            String Query='select id,emp_id__c,Officer__c,Division_Dsc_Org__c,CC_City_Dsc_Org__c,Floor_Directory__c, name,First_Name__c, Last_Name__c,Dept_Dsc_Org__c,Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where'; 
        if(RequesteeEmployee!=null || RequesteeEmployee!=''){        
            if(RequesteeEmployee.length()<=2){
                msgError1=true;
               msgError='Please enter a minimum of 3 characters.';
            }else{
             Query+=' (name like \'%'+RequesteeEmployee+'%\' OR emp_id__c=\''+RequesteeEmployee +'\') and status__c=\'Active\'';
            }
        }
        
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            EmployeeList=null;
        }
        else{
            Query+='  order by name asc ';
            EmployeeList=(List<Employee__C>)Database.Query(Query);
            if(EmployeeList.size() > 20){
                    msgError='Too many search results found. Please narrow your search criteria and try again.';
                    msgError1 = true;
                    EmployeeList=null;
                    return null;
            }
        }
       }
        return null;
    }
    
    Public pagereference SelectedEmployee(){
        //system.debug('----------inside selected employee-------------');
        CurrentManager=null;
        requestorEmp=null;
        showReqPopup=false;
        requestDeatils.Location111__c=null;
        List<Employee__c> empDetails = PP_Util.getEmployeeRecordbyID(requestDeatils.Employee_Requestee_Name__c);
        requestorEmp = empDetails[0];
        
        //Check if Employee has email address
        if(requestorEmp.email__c == null || requestorEmp.email__C == '' ){
            isBlankEmailAdd = true;
        }
        
        
        if(requestorEmp.Building_Directory__c != null || requestorEmp.Building_Directory__c != ''){  
            list<Building_Locations__c> location = PP_Util.getIndivBuildingDetail(requestorEmp.Building_Directory__c);
            if(location != null && location.size() > 0) {
                requestDeatils.Location111__c = location[0].id;
                fromName = location[0].name;
            }
            else{
                    fromName=null;
                    isOutofScope=true;
            }
        }

        if(requestDeatils.Request_Type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE )  return null;
        if(requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE) {
            changeapprover();
        }
        if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE) {
            if(requestorEmp.Manager__c != null ){
                CurrentManager = requestorEmp.Manager__r.name;
                currentManagerId = requestorEmp.Manager__r.id;
            } else {
                CurrentManager = requestorEmp.Assignment_Contact_Manager__r.Name;
                currentManagerId = requestorEmp.Assignment_Contact_Manager__c;
            }                        
            //if(!isBlankEmailAdd) checkApproverActive(); 
            checkApproverActive();
        }
        return null;
    }

    Public pagereference SelectedEmployee1(){
        userId='';
        isBlankEmailAdd = false;
        if(requestDeatils.CC_WatchList__c == null) {
            requestDeatils.CC_WatchList__c='';
            requestDeatils.CC_WatcherNames__c='';
            WatchersId='';
            WatchersUserId = '';
        }
        addwatcher=false;
        if(lastwatcher!=null || lastwatcher!='') {
            Employee__C V=[select id,name,email__c, user__c from employee__C where emp_id__C=:lastwatcher];
                //Check if Delegator has email address - Some employees doesnt have email address associated with them, those are vendors
                if(V.email__c == null || V.email__C == '' ){
                    isBlankEmailAdd = true;
                    V.email__c = 'DUMMY2015@ms.com.dummy';
                }

            if(requestDeatils.CC_WatcherNames__c!=null && requestDeatils.CC_WatcherNames__c != '' && requestDeatils.CC_WatcherNames__c.length()> 0){
                requestDeatils.CC_WatcherNames__c= requestDeatils.CC_WatcherNames__c+ ',' + v.name;
                requestDeatils.CC_WatchList__c=requestDeatils.CC_WatchList__c+';'+v.email__c;
                WatchersId=WatchersId+';'+v.Id;
                WatchersUserId = WatchersUserId + ';' + v.user__c;
                
            }
            else {             
                requestDeatils.CC_WatcherNames__c=  v.name;  
                requestDeatils.CC_WatchList__c=v.email__c;
                WatchersId=v.Id;
                WatchersUserId = v.user__c;
                
            } 
 
            lastwatcher='';
            
        }
        
        //Added to enable Delegates if they are inactive 
        if(WatchersUserId != null && !isBlankEmailAdd ) {
              
            Integer test=WatchersUserId.Lastindexof(';');
            if(test == -1){
              userId=WatchersUserId;
            }
            else{
              userId=WatchersUserId.substring(test+1);                  
            }
            system.debug('****userId'+userId);
            checkApproverActive();
        }
        
        
        return null;
    }
   
    Public pagereference AddSource(){
       
        //adding condition to filter based on region for building
        /*system.debug('--------------Requestor Employee------------'+RequestorEmployee);
        List<Employee__c> reqEmp = [select Job_State_Job__c from Employee__c where Name = :RequestorEmployee LIMIT 1];
        system.debug('--------------Requestor Employee------------'+reqEmp );
        buildingList = [select id,name,Address1__c,Address2__c,CITY_DESCRIPTION__c from Building_Locations__c where STATE_CODE__c = :reqEmp[0].Job_State_Job__c  and InScopeFrom__c= true order by CITY_DESCRIPTION__c asc, name asc limit 1000 ];  
        system.debug('--------------Requestor Employee------------'+buildingList );
        */
        
        buildingList = [select id,name,Address1__c,Address2__c,CITY_DESCRIPTION__c from Building_Locations__c where InScopeFrom__c= true order by CITY_DESCRIPTION__c asc, name asc limit 1000 ];  
        addsourcepopup = true;    
        return null;
    }
    
    Public pagereference selectedBuiding1(){
        addsourcepopup=false;
        return null;
    }
    
    Public pagereference OpenVendorpopup(){
        newerror=null;
        vendorList.clear();
        vendorError=null;
        VendorNameUi=null;
        vendorpopup=true;
        return null;
    }
    
    Public pagereference OpenPropOwnerVendorPopup(){
        vendorList.clear();
        vendorError=null;
        VendorName=null;    
        propOwnerVendorPopup=true;
        return null;
    }
   
    Public pagereference filterVendorData(){
        if((VendorName!=null || VendorName!='') && VendorName.length()<= 2){
            vendorError='Please use atleast 3 characters to search vendor';
        }
        vendorList.clear();
        vendorError=null;
        String Query='select id,name,Is_Active__c,Region__c,Vendor_ID__c from PP_Vendor_Details__c where'; 
                 Query+=' (name like \'%'+VendorName+'%\' OR Vendor_ID__c=\''+VendorName +'\')';
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            vendorList=null;
        } else {
            Query+='  order by name asc ';
            vendorList=(List<PP_Vendor_Details__c>)Database.Query(Query);
        }
        return null;
    }
       
    Public pagereference filterVendorData1(){
        if((vendorNameUi != null || vendorNameUi !='') && vendorNameUi.length()<=2){
            vendorError='Please use atleast 3 characters to search vendor';
        }
        vendorList.clear();
        newerror=null;
        vendorError=null;
        String Query='select id,name,Is_Active__c,Region__c,Vendor_ID__c from PP_Vendor_Details__c where'; 
        Query+=' (name like \'%'+vendorNameUi+'%\' OR Vendor_ID__c=\''+vendorNameUi +'\')';

        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            vendorList=null;
        }
        else{
            Query+='  order by name asc ';
            vendorList=(List<PP_Vendor_Details__c>)Database.Query(Query);
            if(vendorList.size() >= 25){
                vendorError='Too many search results found. Please narrow your search criteria and try again.';
            } else if(vendorList.size() == 0) {
                newerror='No search results found.';
            }        
        }       
        return null;
    }
   
    Public pagereference selectedVendor(){
        vendorpopup=false;
        propOwnerVendorPopup=false;
        return null;
   }
  
    Public pagereference cancelRequest(){

        requestDeatils.Status__c='Cancelled';
        requestDeatils.CancelledBy__c=userinfo.getUserId();
        requestDeatils.CancelledDate__c=system.now();

        if(requestDeatils.Status__c == 'Submitted'){
            recallfromapproval(ApexPages.currentPage().getParameters().get('ID'));
        }
        update requestDeatils; 
        PageReference pr = new PageReference('/apex/PP_RequestHome');
        pr.setRedirect(true);
        return pr;
    }
    
    Public pagereference deleteRequest(){
        system.debug('------------------------Delete Request----------------------'+requestDeatils);
        delete requestDeatils;
        PageReference pr = new PageReference('/apex/PP_RequestHome');
        pr.setRedirect(true);
        return pr;
    }
  
    Public Boolean doValidation(){
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
        ER_Purpose=null;
        ER_CSVUploadError=null;
        ER_AttachUploadError=null;
        boolean errorCheckonProperty=false;
        boolean propertyUploadError=false;
        ER_RequestNewPassForError = null;
        
        if(RequestorEmployee == null || RequestorEmployee.trim() == ''){
            ER_RequestorEmployee=MandatoryErrorMessage;
        }
        
        system.debug('***********requestDeatils.Requestor_Email__c'+requestDeatils.Requestor_Email__c);
        /**
        if(requestDeatils.Requestor_Email__c == null || requestDeatils.Requestor_Email__c == ''){
            ER_RequestNewPassForError = 'You do not have valid MS email address, please place a request on someone else behalf.';
        }**/
        
         
        
        if(isBlankEmailAdd  && requestDeatils.CC_WatcherNames__c != null && requestDeatils.CC_WatchList__c==null ){
          ER_watcher='Please enter Delegates using Add button.';
        }
        
        if(requestDeatils.Request_Type__c == null || requestDeatils.Request_Type__c.trim() == ''){
            ER_RequestType=MandatoryErrorMessage;
        }
        
        if(CurrentManager == null || CurrentManager.trim() == '' ){
            ER_Approver=MandatoryErrorMessage;
        }
        
        if(requestDeatils.Property_Owner__c == null || requestDeatils.Property_Owner__c.trim() == ''){
            ER_PropertyOwner = 'Please make a selection.';
        }
        
        if((showAddOthers && requestDeatils.Property_Owner__c=='Other' && other_owners =='')) {//&& (requestDeatils.Other_Owners__c == null || requestDeatils.Other_Owners__c.trim() == '') ){
            ER_OtherOwner='Please enter Property Owner.';
        }

        if((showAddFormerEmployee && requestDeatils.Property_Owner__c=='Former Employee or Contractor' && strOtherFormerEmployee == '')){
            ER_OtherOwner='Please enter Property Owner.';
        }
        
        if(CurrentManager == null || CurrentManager.trim() == ''){
            ER_CurrentManager=MandatoryErrorMessage;
        }
        
        if(requestDeatils.Removal_Type__c == null || requestDeatils.Removal_Type__c.trim() == ''){
            ER_RemovalType=MandatoryErrorMessage;
        }
        
        if(CurrentManager != NULL && requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE ){
            User you = PP_Util.getLoggedinUserRecord();
            if(CurrentManager == RequestorEmployee){
                ER_Approver = 'Error: A requestor cannot also be an approver. Please select a different approver.';
            }
        }

        Date d = Date.today();
        if(removeDateStr == null || removeDateStr.trim() == '' ) {
            ER_RemovalDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else if(removeDateStr == 'NaN/NaN/NaN') {
            removeDateStr = null; //Added by Balakumar
            ER_RemovalDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else{
            Date d2= Date.parse(removeDateStr);
            if (d2 < d){                                                
                ER_RemovalDate = 'Please select a valid date.'; // MandatoryErrorMessage1;
            }
            else{
                requestDeatils.Removal_Date__c=date.parse(removeDateStr);
            }
        }
        system.debug('---------------Return Date is--------------'+returnDateDt);
        
        if(ReturnDate==true && (returnDateDt == null || returnDateDt.trim()=='')){
            ER_ReturnDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else if(ReturnDate==false){
            requestDeatils.Expected_Return_Date__c=null;
        }
        else if(ReturnDate==true && returnDateDt == 'NaN/NaN/NaN') {
             returnDateDt = null; //Added by Balakumar
            ER_ReturnDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else{
            Date d1= Date.parse(returnDateDt);
            if (d1 < d){                                               
                ER_ReturnDate = 'Please select a valid date.'; // Added by Avinash Munaga
            } else {     
                requestDeatils.Expected_Return_Date__c=date.parse(returnDateDt);
            }
        }
        //Added by Balakumar for Validation
        if((ReturnDate==true && returnDateDt != null) && removeDateStr !=null )
        {
            Date d2= date.parse(removeDateStr);
            Date d1= date.parse(returnDateDt);
            if(d1 < d2) {
               ER_ReturnDate = 'The removal date must be before the return date. Please select a valid date.'; // Added by Avinash Munaga
            }
        }
        //End Balakumar
        if(requestDeatils.Location111__c == null){
            ER_From = 'Please make a selection.';    // Added by Avinash Munaga
        }
        
        if(requestDeatils.Destination_Details__c == null || requestDeatils.Destination_Details__c.trim() == ''){
            ER_To = 'Please make a selection.';    // Added by Avinash Munaga
        }
        
        if(AddSearchbox==true && (DestinationDetailsName == null || DestinationDetailsName.trim() == '')){
            ER_DestinationDetailsName='Please enter building.';
        }  
        
        //Start Balakumar      
         if(AddVendor==true && (vendorNameUi == null || vendorNameUi.trim() == '')){
            ER_DestinationDetailsName='Please enter vendor.';
        }  
              
         if(AddFreeText==true && (requestDeatils.Others__c == null || requestDeatils.Others__c.trim() == '')){
            ER_DestinationDetailsName='Please enter name and address.';
        }
        /********THE PURPOSE FIELD IS REMOVED FROM UI ***
        if(requestDeatils.Removal_Purpose__c == null || requestDeatils.Removal_Purpose__c.trim() == '' || requestDeatils.Removal_Purpose__c.trim() == 'Enter business purpose'){
            ER_Purpose = 'Please enter a business purpose.';        // Added by Avinash Munaga
        }
        
        
        if(requestDeatils.Removal_Purpose__c.length()>4000){
            ER_Purpose='You are not allowed to enter more than 4000 characters.';
        }
        ************/
        
        for(addmorerow X:innerlist){
            boolean first=false;
            boolean second=false;
            boolean third=false;
            boolean fourth=false;
            boolean fifth=false;
            boolean sixth=false;
            boolean seven=false;
            boolean eight=false;
            boolean nine=false;
            
            X.ErrorMessage=null;
            X.ErrorMessage1 = null;
            X.ErrorMessage2 = null;
            X.ErrorMessage3 = null;            
            
            if(X!=null){            
                if(X.ProdDetails1.Property_Name__c == null || X.ProdDetails1.Property_Name__c==''){
                    first=true;
                }
                
                if(X.ProdDetails1.Description__c==null || X.ProdDetails1.Description__c==''){
                    fourth=true;
                }
                 if ((X.ProdDetails1.Items__c == null || X.ProdDetails1.Items__c.trim() =='' || X.ProdDetails1.Items__c.isnumeric()==false)) {
                     X.ProdDetails1.Items__c = String.valueof(0);
                }
                if ((X.ProdDetails1.Boxes__c == null || X.ProdDetails1.Boxes__c.trim() =='' || X.ProdDetails1.Boxes__c.isnumeric()==false)) {
                    X.ProdDetails1.Boxes__c = String.valueof(0);
                }
                if ((X.ProdDetails1.Pallets__c== null || X.ProdDetails1.Pallets__c.trim() =='' || X.ProdDetails1.Pallets__c.isnumeric()==false)){
                    X.ProdDetails1.Pallets__c = String.valueof(0) ;
                }       
               
                Integer items = Integer.valueof(X.ProdDetails1.Items__c);
                //system.debug('----------------Items----------------'+items);
                Integer boxes = Integer.valueof(X.ProdDetails1.Boxes__c);
                //system.debug('----------------Boxes----------------'+boxes);
                Integer pallets = Integer.valueof(X.ProdDetails1.Pallets__c);
                //system.debug('----------------Pallets----------------'+pallets);
                
     
                if((items == 0 && boxes == 0 && pallets == 0) ) {
                    X.ErrorMessage='Value should be greater than 0.';
                    X.ErrorMessage3 = 'Missing Items/Boxes/Pallets: At least one quantity must be greater than 0.';
                    errorCheckonProperty=true;
                }
                 
                if(  !first  &&  !fourth ){
                    listdetails.add(X.ProdDetails1);
                }
                 else {
                    if(X.ProdDetails1.Property_Name__c == null || X.ProdDetails1.Property_Name__c == '') {
                        X.ErrorMessage1 = 'Missing Property Type: Please select a Property Type.';
                    }
                    if(X.ProdDetails1.Description__c == null  || X.ProdDetails1.Description__c == '') {
                        X.ErrorMessage2 = 'Missing Description: Please enter a valid description.';
                    }
                    
                    if((X.ProdDetails1.Items__c == null || X.ProdDetails1.Items__c == '' || items == 0)
                             && (X.ProdDetails1.Boxes__c == null || X.ProdDetails1.Boxes__c == '' || boxes == 0)
                             && (X.ProdDetails1.Pallets__c == null || X.ProdDetails1.Pallets__c == '' || pallets == 0)) {
                        
                        X.ErrorMessage3 = 'Missing Items/Boxes/Pallets: At least one quantity must be greater than 0.';
                       
                    }
                   
                    X.ErrorMessage='You must enter all the values.';
                    errorCheckonProperty=true;
                }        
            }
        }        
        if(ER_RequestorEmployee != null || ER_RequestType!=null || ER_Approver!=null || ER_PropertyOwner!=null || ER_OtherOwner!=null || ER_CurrentManager!= null || ER_RemovalType!=null || ER_RemovalDate!=null || ER_ReturnDate!=null || ER_From!=null || ER_To!=null || ER_DestinationDetailsName!=null ||  ER_Purpose!=null || ER_CSVUploadError != null || errorCheckonProperty == true || ER_watcher!=null){
            return false;
        }      
        else{
            if(listdetails.size() > 0){
                listofDetails_Manual=listdetails;
            }
            return true;
        }             
    }           

    Private string[] getCleanFields(String[] initialStringList){    
        
        String[] cleanFields = new String[]{};   
        String compositeField;
        Boolean makeCompositeField = false;
        for(String field : initialStringList) {
            field = field.trim();
            if (field.startsWith('"') && field.endsWith('"')) {                 
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
                cleanFields.add(field.replaceAll('"',''));
            }
        }
        //system.debug('******clean fields'+cleanFields);
    
        return cleanFields;
    }
   
    Public pagereference CloseConfirm() {
      List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('id'));
        if(chkStatus == null )  return null;
        if(chkStatus[0].Status__c == 'Closed' || chkStatus[0].Status__c == 'Cancelled' ) {
            showPopupMessage = true;
        }  
        else if(chkStatus[0].Status__c == 'Recalled') {
            showPopupMessage1 = true;
        }
        else { 
           ConfirmationWindow1 = true;
        }
        return null;
    }
   
    Public pagereference CancelConfirm() {
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('id'));
        if(chkStatus == null )  return null;
        if(chkStatus[0].Status__c == 'Cancelled' || chkStatus[0].Status__c == 'Closed' ) {
            showPopupMessage = true;
        }  
        else {
            
          cancelConfrm = true; 
        }
        return null;
    }
    //Added by abhijeet on 04/09/2015
   Public pagereference DeleteConfirm() {
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('id'));
        if(chkStatus == null )  return null;
        if(chkStatus[0].Status__c == 'Saved' || chkStatus[0].Status__c == 'Recalled' ) {
            deleteConfrm = true;
        }
        return null;
    }
   
  
    Public pagereference closeRequest(){
        PR_Request__c a = [select name,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                          Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                          Removal_Purpose__c  from PR_Request__c where id=:ApexPages.currentPage().getParameters().get('id')];
        if(a != null && a.Status__c == 'Closed'){
            showPopupMessage = true;
            return null;
        }
        else {
            a.Status__c = 'Closed';
            a.ClosedBy__c = userinfo.getUserId();
            a.ClosedDate__c = system.now();

            update a;
        }
        PageReference pr = new PageReference('/apex/PP_RequestHome');
        pr.setRedirect(true);
        return pr;
    }
 
    Public pagereference SearchToBuilding(){
        buildingList=null;
        newerror=null;
        msgError=null;
        msgError1=false;
       
        if(DestinationDetailsName != null && DestinationDetailsName.length() <= 2) {
            msgError='Please enter a minimum of 3 characters.';
            msgError1=true;   
        } else {
            msgError1=false;
            list<Building_Locations__c>  DummybuildingList =new list<Building_Locations__c>();
            String Query='select id,name,City_State__c,Address1__c,Address2__c,CITY_DESCRIPTION__c from Building_Locations__c where';  
            if(DestinationDetailsName!=null || DestinationDetailsName!='') {
                Query += ' name  like \'%'+DestinationDetailsName+'%\'  or Address1__c like \'%'+DestinationDetailsName+'%\'  or CITY_DESCRIPTION__c like \'%'+DestinationDetailsName+'%\' ';
            }  
    
            if(Query.endsWith('where')) {
                Query=Query.removeEnd('where');
                buildingList=null;
            } else {
                Query+=' order by CITY_DESCRIPTION__c asc, name asc limit 26 ';
                system.debug('*********FinalQuery in SearchToBuilding:'+Query);
                buildingListto=(List<Building_Locations__c>)Database.Query(Query);
                system.debug('*********buildingListto:'+buildingListto);            
            }
            
            if(buildingListto.size() >= 25){
                msgError='Too many search results found. Please narrow your search criteria and try again.';
                msgError1=true;
            } else if(buildingListto.size() == 0) {
                newerror='No search results found.';
            }
        }
        return null;
    }
    
    Public List<ProcessInstanceHistory> getApprovalProcessStatus(){
        if (ApexPages.currentPage().getParameters().get('id')!= null) {
            PR_Request__c  quote = [Select Id,createdbyid,LastModifiedBy.name,lastmodifieddate,CreatedBy.FirstName,CreatedBy.LastName,Approval_Rejection_Date__c , (Select Comments, RemindersSent, OriginalActorId, ActorId
                                   From ProcessSteps where StepStatus='Approved' or StepStatus='Rejected'
                                   order by SystemModstamp desc LIMIT 1)
                                  from PR_Request__c where id  = :ApexPages.currentPage().getParameters().get('id')];
             system.debug('-----------getApprovalProcessStatus----------'+quote.ProcessSteps);                          
             return quote.ProcessSteps;
        }
        return new List<ProcessInstanceHistory> ();
    }
       
    Public pagereference deletedocs(){
        ErroeOnDel = null;
        list<String> selectedDocsToDelete=new list<String>();
        list<sDocument> dummydoc=new list<sDocument>();
        integer h=1;
        for(sDocument V:documentList1){
            if(v.selecteddoc){
                String K=v.selectdoc.id;    
                selectedDocsToDelete.add(k.substring(0,15));
            }
            else{
                dummydoc.add(v);
                h++;
            }
        }
        documentList1=dummydoc;
        if(selectedDocsToDelete.size()<=0){
            ErroeOnDel='Please select atleast one item.';    
            return null;
        }
        list<document> todel = new list<document>();
        todel=[select id,name,body,contentType,type from document where id in:selectedDocsToDelete];
        delete todel; 
        return null;
     }
     
    Public class sDocument {
        public document selectdoc {get; set;}
        public boolean selecteddoc {get; set;}   
        
        public sDocument(document selectdoc){
            this.selectdoc=selectdoc;
            selecteddoc=false;
        }   
    } 
     
    Public pagereference RequestNoConfirmation(){
        ConfirmationWindow=false;
        ConfirmationWindow1=false;
        cancelConfrm=false;
        deleteConfrm =false;
        return null;
    }
    
    Public pagereference RequestWithBlankEmailConfirmation(){
         isBlankEmailAdd = false;
        return null;
    }
    
    //Formatting date time as per Local timezone PROPPass-19
    /*public DateTime dateTimeValue { get; set; }
    public String getTimeZoneValue() {
    String datetime_format = 'MMMM dd, yyyy  HH:mm a z';
        if( dateTimeValue != null ) {
            String localeFormatDT = dateTimeValue.format(datetime_format);
            return localeFormatDT;
        }
        return null;
    }*/
    //End
        
}