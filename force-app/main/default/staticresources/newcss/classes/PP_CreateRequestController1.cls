public class PP_CreateRequestController1{
    
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
    
    private static final string MandatoryErrorMessage='Please select an Approver.';  
    // public static final string MandatoryErrorMessage1='Error: Date should be greater than current date';
    // public static final string MandatoryErrorMessage2='Error: The removal date must be before the return date. Please select a valid date.';
    
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
    public boolean showrejectionPopup{get;set;}
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


    //constructor starts here 
    Public PP_CreateRequestController1()
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
        //For Existing things..,
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
                        if(requestDeatils.Employee_Requestor_Name__c <> requestorEmp.ID && 
                                requestDeatils.Employee_Requestee_Name__c <> requestorEmp.ID){
                            if(w == NULL) {
                                isApprover1 = true;
                            } else {
                                if(!w.contains(requestorEmp.Name)) isApprover1 = true;
                            }
                            
                        /**************
                        if( w != NULL && !w.contains(requestorEmp.Name) && requestDeatils.Employee_Requestor_Name__c <> requestorEmp.ID 
                            && requestDeatils.Employee_Requestee_Name__c <> requestorEmp.ID){
                            isApprover1 = true;
                        } ****************/
                        }
                    }
                }
                system.debug('----------------isApprover------------:'+isApprover1 );
                
                //if the logged in user is a security admin or floor security
                //if(!isApprover1) 
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
            
                RequestorEmployee=requestDeatils.Employee_Requestee_Name__r.name;

                if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE && requestDeatils.Manager__c !=null){
                    CurrentManager=requestDeatils.Manager__r.name;  
                    currentManagerId =requestDeatils.Manager__c;  
                }
                else{
                    system.debug('requestDeatils.Property_Service_Approver__c:' + requestDeatils.Property_Service_Approver__c);
                    CurrentManager = requestDeatils.Property_Service_Approver__c.subString(3, requestDeatils.Property_Service_Approver__c.length());
                }
                
                DestinationDetailsName=requestDeatils.Destination__r.name;               
                To_Others = requestDeatils.Others__c;
                strStatus = PP_Util.getStatusName(requestDeatils.Status__c);
                
                changeApprover_N();
                
                ownerDeatils_N();
                
                RemovalType_N();
                
                AddDestination_N();

                List<Attachment> allAttachments = [select id,name from Attachment where parentid=: ApexPages.currentPage().getParameters().get('id') ];            
                for(Attachment att: allAttachments ) {
                    if(att.name == 'propertyfile.csv')
                        fileAttchment.add(att);
                    else {     
                        listofNotesAndAttchment.add( att);
                    }
                }   
                
                ProdDetailslist = [select id, Description__c,Asset_Tag__c,Quantity__c,Property_Name__c,Boxes__c,Serial_No__c,Items__c,Pallets__c from property_Detail__c where request_details__c=:ApexPages.currentPage().getParameters().get('id') and Asset_Tag__c=null and Serial_No__c=null];
                system.debug('**********'+ProdDetailslist);
                
                if(ProdDetailslist != NULL && ProdDetailslist.size() > 0){
                    for(integer i=0;i<ProdDetailslist.size();i++){
                        innerlist.add(new addmorerow());  
                        AddmoreRows=true; 
                    }
                        
                    for(Integer j=1;j<innerlist.size();j++){
                        innerlist[j-1].addbutton=false;
                    }
                    
                    /*********
                    if(ProdDetailslist.size()<=0){
                        innerlist.add(new addmorerow());  
                        innerlist[0].addbutton=true;
                    } 
                    ********************************/
    
                
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
                //system.debug('%%%%%%%%%%%%%%%'+requestDeatils.Removal_Date__c);
                if(requestDeatils.Removal_Date__c != null){
                    removeDateStr=requestDeatils.Removal_Date__c.month()+'/'+requestDeatils.Removal_Date__c.day()+'/'+requestDeatils.Removal_Date__c.year();
                }
                if(requestDeatils.Expected_Return_Date__c != null ){
                    //system.debug('----------------requestDeatils.Expected_Return_Date__c------------------'+requestDeatils.Expected_Return_Date__c+date.today());
                    returnDateDt=requestDeatils.Expected_Return_Date__c.month()+'/'+requestDeatils.Expected_Return_Date__c.day()+'/'+requestDeatils.Expected_Return_Date__c.year();
                }  
                
                
                //system.debug('------------Inside Approver Source----------------');
                List<ProcessInstanceHistory> x=getApprovalProcessStatus();
                            system.debug('--------Size---------'+x.size());
                 if(x.size()>0){
                   setActorname=[select name from user where id=:x[0].ActorId].name ;
                   system.debug('--------Size---------'+x.size());
                }
        
                    
            } 
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
            //defaultRows =5;
            //uplodedDocument=new Document(); 
            lastwatcher='';
            //showEditRecall=false;   
            
            innerlist=new list<addmorerow>();
            //for(integer i=0;i<1;i++){
                innerlist.add(new addmorerow());    
            //}
                    
            requestDeatils.Employee_Requestor_Name__c = requestorEmp.id; 
            requestDeatils.Employee_Requestee_Name__c = requestorEmp.id; 
            RequestorEmployee=requestorEmp.name;   
            //removeDate=date.today(); 
            
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
        
    private List<Employee__c> getApproversForStandardReqs(){
               // system.debug('****INSIDE ApproverList as 0.....requestorEmp'+requestorEmp);
               system.debug('requestorEmp.emp_id__c: ' + requestorEmp.emp_id__c);
             
              //and emp_id__c <>:requestorEmp.emp_id__c and emp_id__c <>:loggedInEmp.emp_id__c  
             ApproverList =[select id,emp_id__c, name,Dept_Dsc_Org__c, Building_Directory__c, Level_Dsc_Job__c from employee__c 
                          where Cost_Center__c=:requestorEmp.Cost_Center__c 
                          and Level_Dsc_Job__c in('Vice President','Executive Director','Managing Director') 
                          and status__c='Active' order by name asc]; 
            system.debug('****INSIDE ApproverList as 0.....ApproverList '+ApproverList );
            if(ApproverList != NULL && ApproverList.size()<=0){

            List<Employee__c> X=[select id,Cost_Center__c from Employee__c where (id=:requestorEmp.Manager__c or id=:requestorEmp.Assignment_contact_Manager__c )limit 1];  
              //system.debug('****INSIDE ApproverList as 0.....X'+X);
            if(X != null && X.size() > 0 ) {
                //and emp_id__c <>: requestorEmp.emp_id__c  and emp_id__c <>:loggedInEmp.emp_id__c 
                ApproverList = [select id,emp_id__c, name,Dept_Dsc_Org__c, Building_Directory__c, Level_Dsc_Job__c from employee__c 
                              where Cost_Center__c=:X[0].Cost_Center__c 
                              and Level_Dsc_Job__c in ('Vice President','Executive Director','Managing Director') 
                              and status__c='Active' order by name asc];
                //system.debug('****INSIDE ApproverList as 0.....ApproverList1'+ApproverList);
                }
            }
            return ApproverList;
    }

   
    Public pagereference removeRow(){
            system.debug('##############innerlist'+innerlist);
        system.debug('##############innerlist'+propertyToDel);
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
        
        
        showPopupMessage=false;
        showPopupMessage1=false;
        // Added by Avinash Munaga
        //DestinationDetailsName = null;
        //vendorNameUi=null;        
        
        return null;
    }

    public pagereference changeApprover(){
        CurrentManager = null;
        if(requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE ) {
            if(requestorEmp.CC_Region_Org__c == 'NA'){
                CurrentManager='Americas_Data_Center_Approvers';
                requestDeatils.Property_Service_Approver__c='PP_Americas_Data_Center_Approvers';
            } else if(requestorEmp.CC_Region_Org__c == 'EU'){
                CurrentManager='EMEA_Data_Center_Approvers';
                requestDeatils.Property_Service_Approver__c='PP_EMEA_Data_Center_Approvers';
            } else{
                CurrentManager='Asia_Data_Center_Approvers';
                requestDeatils.Property_Service_Approver__c='PP_Asia_Data_Center_Approvers';
            }
        } else if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE ){
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
     pagereference p=new pagereference('/apex/PP_RequestHome');//+'&tab=MyRequest'
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
        //system.debug('**++'+IsParmanent);
        if(requestDeatils.Removal_Type__c=='Temporary'){
            dummyFlagforDatePicker='loaded';
            ReturnDate=true;
        }
        else{
            ReturnDate=false;
        }
    }    
   public boolean showuploadms{get;set;}

   public pagereference UploadCSV(){
          
        string [] filelines=new string[]{};
        String contectfilecsv;  
        listofDeatisl=new list<property_Detail__c>();
        doc=new List<Document>();
       
        ER_CSVUploadError='';  
             try{ 
            if(!nameFile.contains('.csv')){
                ER_CSVUploadError='Error:  Only comma seperated file (CSV) extension is allowed. Please save the file in the correct format and retry.';
                showcsvuploadfile=true;
                showuploadms=true;
            }     
            else
            { 
                 showuploadms=false;  
                 showcsvuploadfile=false;                
                 contectfilecsv=UploadCSV.toString(); 
                 system.debug('***********contectfilecsv'+contectfilecsv+nameFile);
                          
                filelines = contectfilecsv.split('\n');        
                system.debug('***********'+filelines.size()+filelines);
                for (Integer i=1;i<filelines.size();i++){
                    String[] inputvalues = new String[]{};
                    inputvalues =getCleanFields(filelines[i].split(','));
                    system.debug('************Col1:'+inputvalues[0]);
                   system.debug('************Col2:'+inputvalues[1]);
                   //Start Balakumar - Commented as per request
                   /* if(  inputvalues[4]!='' && inputvalues[5]!=''  ){
                        property_Detail__c  a = new property_Detail__c();
                        a.Serial_No__c=inputvalues[4];
                        a.Asset_Tag__c=inputvalues[5];
                        listofDeatisl.add(a);  */    
                   //End Balakumar
                    
                    if(  inputvalues[0]!='' && inputvalues[1]!=''  ){
                        property_Detail__c  a = new property_Detail__c();
                        a.Serial_No__c=inputvalues[0];
                        a.Asset_Tag__c=inputvalues[1];
                        listofDeatisl.add(a);      
                    
                    
                    //showcsvuploadfile=false;                                  
                }   
            }
       
            if(listofDeatisl.size() ==0){
                listofDeatisl=new List<property_Detail__c>();
                contectfilecsv=null;
                UploadCSV=null;
                ER_CSVUploadError='Please select the downloded file to upload or the file not contains valid data to process.';
                 showcsvuploadfile=true;
                  showuploadms=true;
            }  
            else{             
                document docment=new document();
                docment.Body=UploadCSV;
                docment.FolderId=folderidset().substring(0,15);
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
        }  
             }              
      catch (Exception e){
         doc=new List<Document>();
           ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file first, then upload.');
           //ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please click Browse to select file to Upload.');
           ApexPages.addMessage(errormsg);
           ER_CSVUploadError='Please select a file first, then upload.';
           //ER_CSVUploadError='Please click Browse to select file to Upload.';
           showcsvuploadfile=true;
           showuploadms=true;
            contectfilecsv=null;
            UploadCSV=null;
           return null;
        } 
        
       return null;
    }   

    Public pagereference AddDestination()
    {
        
        newerror=null;
        
        //if(DestinationDetailsName != requestDeatils.Destination__r.name)
            DestinationDetailsName=null;
         //if(requestDeatils.Destination_Details__cTo_Others != requestDeatils.Others__c)
             To_Others  =null;
        //if(vendorNameUi != requestDeatils.PP_Vendor_Details__r.name)
            vendorNameUi = null;
        
        AddDestination_N();        
        Return null;
    }
    
    private Void AddDestination_N(){
       ER_To = null;
        if(requestDeatils.Destination_Details__c=='MS Data Center' || requestDeatils.Destination_Details__c=='MS Office Building'){       
            AddSearchbox=true;
            AddFreeText=false;
            AddVendor=false;
            
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
           // requestDeatils.Destination__r.name = DestinationDetailsName;
        }
        else if( (requestDeatils.Destination_Details__c=='Charitable Donation' || requestDeatils.Destination_Details__c=='Disposal'|| requestDeatils.Destination_Details__c=='Other' || requestDeatils.Destination_Details__c=='Hiring Agency') ){      
            requestDeatils.Destination__c = null;
            requestDeatils.PP_Vendor_Details__c = null;
            requestDeatils.Others__c = To_Others;
        }
        else if( requestDeatils.Destination_Details__c=='Vendor'){ 
            requestDeatils.Others__c = null;
            requestDeatils.Destination__c = null;
            //requestDeatils.PP_Vendor_Details__r.name = vendorNameUi;
            
        }
        
        
       if(requestDeatils.Property_Owner__c=='Other' ){
            requestDeatils.Other_Owners__c = Other_Owners;
        }
        else if( requestDeatils.Property_Owner__c=='Former Employee or Contractor' ){
            requestDeatils.Other_Owners__c = strOtherFormerEmployee ;
        }
    }

    Public pagereference saveRequest(){
        
        /**
        System.debug('**********SaveRequest::');
        System.debug('**********SaveRequest::requestDeatils.PP_Vendor_Details__c:'+requestDeatils.PP_Vendor_Details__c);
        System.debug('**********SaveRequest::requestDeatils.Others__c:'+requestDeatils.Others__c);
        System.debug('**********SaveRequest::requestDeatils.Destination__c :'+requestDeatils.Destination__c );
        **/
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
        System.debug('**************Saverequest: Manager::'+requestDeatils.Manager__c);
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
                Attachment att=new Attachment(name='propertyfile.csv',ParentId=requestDeatils.id,body=d.body);
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
    
        
            Id userid;
            List<Employee__c> eList;     
            cleanUpToFields();
    
            if(!doValidation()){
                return null;
            }  
            
            //Start Balakumar - For Approver Reminder
            // if(requestDeatils.Removal_Date__c != null) { requestDeatils.RemovalDateTime__c =  Datetime.newInstance(requestDeatils.Removal_Date__c,datetime.now().time()); }
            //requestDeatils.SubmittedDatetime__c= system.now(); 
            //requestDeatils.SubmittedDatetime__c= Datetime.now(); 
            //End Balakumar
            
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
                //system.debug('******************userID in Approval.PRocessresult in SubmitRequest:'+userId);
                request.setNextApproverIds(new Id[] {userid});
                result  =   Approval.process(request); 
            }
            else
            {
                 Approval.ProcessResult result = null;
                 Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                 request.setObjectId(requestDeatils.id); 
                 // request.setNextApproverIds(new Id[] {userid});
                result  =   Approval.process(request); 
            }
            
            Id workItemId;
            Boolean isSameApprover = false;
            if( requestDeatils.request_type__c == PP_Util.STANDARD_REQUEST_TYPE) {
                //if(requestorEmp.ID == requestDeatils.Manager__c ||  PP_Util.getLoggedinEmployeeDetailsbyEmpID(LoggedInUser.Emp_Id__c).ID == requestDeatils.Manager__c) {
                //AS PER LATEST REQUIREMENTS - REQUESTOR CANN'T SELF APPROVE HIS/HER OWN REQUEST
                if(PP_Util.getLoggedinEmployeeDetailsbyEmpID(LoggedInUser.Emp_Id__c).ID == requestDeatils.Manager__c) {
                    isSameApprover = true;
                }
            } 
            else {
                //system.debug('***********requestDeatils.Property_Service_Approver__c:'+requestDeatils.Property_Service_Approver__c + ' Emp User:'+loggedInEmp.user__c);
                //isSameApprover = PP_Util.getPPGrpAppoverByID(requestDeatils.Property_Service_Approver__c,loggedInEmp.user__c);
                
                system.debug('***********requestDeatils.Property_Service_Approver__c:'+requestDeatils.Property_Service_Approver__c + ' Emp User- requestorEmp:'+requestorEmp.user__c);
               // isSameApprover = PP_Util.getPPGrpAppoverByID(requestDeatils.Property_Service_Approver__c,requestorEmp.user__c);
               isSameApprover = (requestorEmp.user__c != LoggedInUser.ID && PP_Util.getApproverByEmpIDAndGrpName(requestDeatils.Property_Service_Approver__c));
            }
        
            system.debug('**************isSameApprover ::'+isSameApprover );
        
            if(isSameApprover ) {
            
                system.debug('******************INSIDE SELF APPROVAL************'+ requestDeatils.id);
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approving request using Trigger');
                req.setAction('Approve');
                // req.setNextApproverIds(new Id[] {a.Next_Approver__c});
                //Id workItemId = [Select p.Id from ProcessInstanceWorkitem p  where p.ProcessInstance.TargetObjectId =: a.id];
                for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p  where p.ProcessInstance.TargetObjectId =: requestDeatils.id] )
                {
                    workItemId =  workItem.Id;
                }
                
                
                if(workItemId == null)
                {
                    SYStem.debug('Error occured in PP_CreateRequestController SubmitRequest() while doing AutoApproval');
                }
                else
                {
                    req.setWorkitemId(workItemId);
                    Approval.ProcessResult result =  Approval.process(req);
                }
    
                //update the actor id 
                requestDeatils.ActualApprover__c=requestorEmp.user__c; //userinfo.getUserId();
                update requestDeatils;
                        
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
    
    public pagereference UploadAttachment(){
        document newattchment = new document();
       newattchment.FolderId=folderidset().substring(0,15);   
        
        newattchment.Body = notesAndAttchment;        
        system.debug('-----Body---------'+EncodingUtil.base64Encode(newattchment.Body));
        newattchment.Name=FileName1;        
        //newattchment.contentType='.csv';
        //newattchment.contentType='png';
        
        /*Integer test=FileName1.lastindexof('.');
        system.debug('-----filetype start'+test);
        newattchment.type = FileName1.substring(test+1);
        system.debug('-----newattchment.type'+newattchment.type); 
        */          
        try {
            showuploadattachment=false;
            insert newattchment;
            attachments.add(newattchment);
            documentList1.add(new sDocument(newattchment));
            newattchment.body=null;
            notesAndAttchment=null;
            
            
        } catch (DMLException e) {
          //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a file first, then upload.'));
          //ER_AttachUploadError='Please click Browse to select file to Upload.';
          ER_AttachUploadError='Please select a file first, then upload.';
          showuploadattachment=true;
          return null;
        } finally {
          
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
    public pagereference recallRequest(){
        recallfromapproval(ApexPages.currentPage().getParameters().get('ID'));
        //showEditRecall=false;
        ConfirmationWindow=false;
        
        requestDeatils.Status__c='Recalled';
        update requestDeatils;
        strStatus='In Draft';
        pagereference p=new pagereference('/apex/PP_CreateRequest?id='+requestDeatils.Id);
       return p; 
    }

    public pagereference DeleteATtachment(){
        if(AttachmentId !=null){
           system.debug('----------------------Attachment----------------'+AttachmentId);     
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
       return null;
    }
    
    
    public pagereference buildingData(){
        buildingListto.clear();        
        newerror=null;
        msgError=null;
        msgError1=false;
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
    
    public pagereference takeaction(){
    
    
    PR_Request__c chkStatus = [ Select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,
                               Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c 
                               from PR_Request__c where id =:ApexPages.currentPage().getParameters().get('id')  ];
        if(chkStatus.Status__c == 'Rejected' || chkStatus.Status__c == 'Approved')
        {
       
         showPopupMessage=true;
            return null;
            
        /*pagereference p=new pagereference('/apex/PP_CreateRequest?id='+ApexPages.currentPage().getParameters().get('id'));
        p.setRedirect(true);
        return p;*/
        }  
        else if(chkStatus.Status__c == 'Recalled' )
        {
        /*pagereference p=new pagereference('/apex/PP_RequestHome');//+'&tab=MyRequest'
        p.setRedirect(true);
        return p;*/
        showPopupMessage1=true;
            return null;
        } 
        else{
        showrejectionPopup=true;
        return null;
        }
    } 
    
    public pagereference approveRequest(){
    
    PR_Request__c chkStatus = [ Select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,
                               Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c 
                               from PR_Request__c where id =:ApexPages.currentPage().getParameters().get('id')  ];
        if(chkStatus.Status__c == 'Approved' || chkStatus.Status__c == 'Rejected' )
        {
         showPopupMessage=true;
            return null;
        //pagereference p=new pagereference('/apex/PP_CreateRequest?id='+ApexPages.currentPage().getParameters().get('id'));//+'&tab=MyRequest'
        //p.setRedirect(true);
        //return p;        
        }  
        else if(chkStatus.Status__c == 'Recalled' )
        {
        /*pagereference p=new pagereference('/apex/PP_RequestHome');//+'&tab=MyRequest'
        p.setRedirect(true);
        return p;*/
        showPopupMessage1=true;
            return null;
        } 
        else
    
        {
    
        
        
        
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
            
            pagereference p=new pagereference('/apex/PP_RequestHome');
            return p;
        }
        }
        
    public boolean showMessage{get;set;}
    
    public pagereference RejectRequest(){
    
    
       
        
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
    
    
    
    
    public pagereference ownerDeatils(){
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
    
    /*public pagereference FilterEmployee(){
    
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
        if((RequesteeEmployee!=null || RequesteeEmployee!='')&& (watcherEmployee==null || watcherEmployee=='') ){        
            if(RequesteeEmployee.length()<=2){
                msgError1=true;
               msgError='Please enter a minimum of 3 characters.';
            }else{
             Query+=' (name like \'%'+RequesteeEmployee+'%\' OR emp_id__c=\''+RequesteeEmployee +'\') and status__c=\'Active\'';
            }
        }
        else{
            if(watcherEmployee.length()<=2){
            msgError1=true;
            msgError='Please enter a minimum of 3 characters.';
            }else{               
                    Query+='( name like \'%'+watcherEmployee+'%\' OR emp_id__c=\''+watcherEmployee +'\' ) and status__c=\'Active\' ';            
                //}
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
    */

   public pagereference FilterWatcherEmployee(){
    
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
    
public pagereference FilterRequestorEmployee(){
    
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
    
    


    /*public pagereference SelectedEmployee(){
        CurrentManager=null;
        requestorEmp=null;
        showReqPopup=false;
        system.debug('----------RequestDeatils----------'+requestDeatils.Employee_Requestee_Name__c);
        
        
        requestorEmp = [select emp_id__c, name,First_Name__c,Assignment_Contact_Manager__c,CC_Region_Org__c, Last_Name__c, Manager__r.name, Manager__r.emp_id__c, Assignment_Contact_Manager__r.name, Assignment_Contact_Manager__r.Officer__c,Assignment_Contact_Manager__r.emp_id__c, Job_Title_Dsc_Job__c, Job_Title__c
                        , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                        , Job_Country_Job__c,Empl_Class_Dsc_Job__c,cost_center__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c from employee__c where id = :  requestDeatils.Employee_Requestee_Name__c And  Status__c = 'Active'];                         
        
        requestDeatils.Location111__c=null;
        if(requestorEmp.Building_Directory__c!=null || requestorEmp.Building_Directory__c!=''){  
            list<Building_Locations__c> location=PP_Util.getIndivBuildingDetail(requestorEmp.Building_Directory__c);
            if(location!= null && location.size()>0){
                requestDeatils.Location111__c=location[0].id;
                fromName=location[0].name;
            }
        }

        if(requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE || requestDeatils.Request_Type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE )  return null;
       
           
            if(requestorEmp.Manager__c != null ){
                CurrentManager = requestorEmp.Manager__r.name;
                currentManagerId = requestorEmp.Manager__r.id;
            } else {
                CurrentManager = requestorEmp.Assignment_Contact_Manager__r.Name;
                currentManagerId = requestorEmp.Assignment_Contact_Manager__c;
            } 

        
        return null;
    }*/

     public pagereference SelectedEmployee(){
        CurrentManager=null;
        requestorEmp=null;
        showReqPopup=false;
        system.debug('----------RequestDeatils----------'+requestDeatils.Employee_Requestee_Name__c);
        
        
        requestorEmp = [select emp_id__c, name,First_Name__c,Assignment_Contact_Manager__c,CC_Region_Org__c, Last_Name__c, Manager__r.name, Manager__r.emp_id__c, Assignment_Contact_Manager__r.name, Assignment_Contact_Manager__r.Officer__c,Assignment_Contact_Manager__r.emp_id__c, Job_Title_Dsc_Job__c, Job_Title__c
                        , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c,user__c
                        , Job_Country_Job__c,Empl_Class_Dsc_Job__c,cost_center__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c from employee__c where id = :  requestDeatils.Employee_Requestee_Name__c And  Status__c = 'Active'];                         
        system.debug('------------------requestDeatils.Employee_Requestee_Name__c---'+requestDeatils.Employee_Requestee_Name__c);
        requestDeatils.Location111__c=null;
        if(requestorEmp.Building_Directory__c!=null || requestorEmp.Building_Directory__c!=''){  
            list<Building_Locations__c> location=PP_Util.getIndivBuildingDetail(requestorEmp.Building_Directory__c);
            if(location!= null && location.size()>0){
                requestDeatils.Location111__c=location[0].id;
                fromName=location[0].name;
            }
            else{
                    requestDeatils.Location111__c=null;
                    fromName=null;
                    isOutofScope=true;
                    
            }
        }

       // if(requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE || requestDeatils.Request_Type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE )  return null;
        if(requestDeatils.Request_Type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE )  return null;
        
        if(requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE)
        {
         changeapprover();
        }
        
        if(requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE)  
        {
            if(requestorEmp.Manager__c != null ){
                CurrentManager = requestorEmp.Manager__r.name;
                currentManagerId = requestorEmp.Manager__r.id;
            } else {
                CurrentManager = requestorEmp.Assignment_Contact_Manager__r.Name;
                currentManagerId = requestorEmp.Assignment_Contact_Manager__c;
            } 
        }
        
        return null;
    }



  
    public pagereference SelectedEmployee1(){
        //system.debug('***********Add watcher in SelectedEmployee1:'+watcherList+requestDeatils.CC_WatcherNames__c);
        if(requestDeatils.CC_WatchList__c == null){
            requestDeatils.CC_WatchList__c='';
            requestDeatils.CC_WatcherNames__c='';
            WatchersId='';
            WatchersUserId = '';
        }
        addwatcher=false;
        //system.debug('lastwatcher'+lastwatcher+WatchersId);
        //system.debug('requestDeatils.CC_WatchList__c1'+requestDeatils.CC_WatchList__c);
        if(lastwatcher!=null || lastwatcher!=''){
        Employee__C V=[select id,name,email__c, user__c from employee__C where emp_id__C=:lastwatcher];
        if(requestDeatils.CC_WatcherNames__c!=null && requestDeatils.CC_WatcherNames__c != '' && requestDeatils.CC_WatcherNames__c.length()> 0){
            //system.debug('test watcher'+ requestDeatils.CC_WatcherNames__c);    
            
            requestDeatils.CC_WatcherNames__c= requestDeatils.CC_WatcherNames__c+ ',' + v.name;
             requestDeatils.CC_WatchList__c=requestDeatils.CC_WatchList__c+';'+v.email__c;
             WatchersId=WatchersId+';'+v.Id;
             WatchersUserId = WatchersUserId + ';' + v.user__c;
        }
        else{             
            requestDeatils.CC_WatcherNames__c=  v.name;  
            requestDeatils.CC_WatchList__c=v.email__c;
            WatchersId=v.Id;
            WatchersUserId = v.user__c;
        }     

        lastwatcher='';
        system.debug('requestDeatils.CC_WatchList__c2'+requestDeatils.CC_WatchList__c);
        }
        return null;
    }

        
    public pagereference AddSource(){
        buildingList = [select id,name,Address1__c,Address2__c,CITY_DESCRIPTION__c from Building_Locations__c where InScopeFrom__c= true order by name asc limit 1000 ];  
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
     newerror=null;
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
     vendorList.clear();
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
    vendorList.clear();
    vendorError=null;
     String Query='select id,name,Is_Active__c,Region__c,Vendor_ID__c from PP_Vendor_Details__c where'; 
     
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
            Query+='  order by name asc ';
            vendorList=(List<PP_Vendor_Details__c>)Database.Query(Query);
            
        }
    
        }
        
    return null;
   }
   
   public pagereference filterVendorData1(){
   system.debug('------------------------FilterVendorData1-----------------------');
        vendorList.clear();
        newerror=null;
        vendorError=null;
     String Query='select id,name,Is_Active__c,Region__c,Vendor_ID__c from PP_Vendor_Details__c where'; 
        if(vendorNameUi.length()<=2){
            vendorError='Please use atleast 3 characters to search vendor';
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
            Query+='  order by name asc ';
            vendorList=(List<PP_Vendor_Details__c>)Database.Query(Query);
         
         if(vendorList.size() >= 25){
                vendorError='Too many search results found. Please narrow your search criteria and try again.';
            } else if(vendorList.size() == 0) {
                newerror='No search results found.';
            }
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
  
  
    public String ER_watcher{get;set;}  
  
    public Boolean doValidation(){
    
        String i='0';    //added by Balakumar
        list<property_Detail__c> listdetails=new list<property_Detail__c>();  
        listofDetails_Manual =new list<property_Detail__c>();
        ER_watcher=null;  
        ER_RequestorEmployee=null;
        ER_RequestType=null;
        ER_Approver=null;
        //ER_Delegate = null;
        ER_PropertyOwner=null;
        ER_OtherOwner=null;
        ER_CurrentManager=null;
        ER_RemovalType=null;
        ER_RemovalDate=null;
        ER_ReturnDate=null;
        ER_From=null;
        ER_To=null;
        ER_DestinationDetailsName=null;
        //ER_EquipReceipt=null;
        ER_Purpose=null;
        ER_CSVUploadError=null;
        ER_AttachUploadError=null;
        
        //new for fulfillment manager..,        
        ER_FulFillmentManager=null;
        
        boolean errorCheckonProperty=false;
        boolean propertyUploadError=false;
        
        
        if(RequestorEmployee == null || RequestorEmployee.trim() == ''){
            ER_RequestorEmployee=MandatoryErrorMessage;
        }
        
        
           if((requestDeatils.CC_WatcherNames__c != null && requestDeatils.CC_WatchList__c==null ) ){
              system.debug(requestDeatils.CC_WatcherNames__c+requestDeatils.CC_WatchList__c);
              ER_watcher='You must enter watcher via lookup';
           }
           /*added by kumaresan
           if(WatchersId != null && WatchersId.trim() != '' && currentManagerId != null && WatchersId.contains(currentManagerId)){
              ER_watcher='Delegator cannot be an approver';                   
           }
           system.debug('************ER_watcher'+ER_watcher);*/
        
        if(requestDeatils.Request_Type__c == null || requestDeatils.Request_Type__c.trim() == ''){
            ER_RequestType=MandatoryErrorMessage;
        }
        
        if(CurrentManager == null || CurrentManager.trim() == '' ){
            ER_Approver=MandatoryErrorMessage;
        }
        
        if(requestDeatils.Property_Owner__c == null || requestDeatils.Property_Owner__c.trim() == ''){
            // ER_PropertyOwner=MandatoryErrorMessage;
            ER_PropertyOwner = 'Please make a selection.';
        }
        
        if((showAddOthers && requestDeatils.Property_Owner__c=='Other' && other_owners =='')) {//&& (requestDeatils.Other_Owners__c == null || requestDeatils.Other_Owners__c.trim() == '') ){
            ER_OtherOwner='Please enter Property Owner.';
        }

        if((showAddFormerEmployee && requestDeatils.Property_Owner__c=='Former Employee or Contractor' && strOtherFormerEmployee == '')){
                 //&& (requestDeatils.Other_Owners__c == null || requestDeatils.Other_Owners__c.trim() == '') ){
            ER_OtherOwner='Please enter Property Owner.';
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
        
        if(CurrentManager != NULL && requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE ){
            User you = PP_Util.getLoggedinUserRecord();
            if(CurrentManager == RequestorEmployee){
                ER_Approver = 'A requestor cannot also be an approver on a request. Please select an alternate approver.';    
            }
        }
        
        /********
        if(requestDeatils.Property_Service_Approver__c != NULL && (requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE || requestDeatils.Request_Type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE ) ){
            //if(PP_Util.getApproverByEmpIDAndGrpName(requestDeatils.Property_Service_Approver__c)){
            if(PP_Util.getPPGrpAppoverByID(requestDeatils.Property_Service_Approver__c,requestorEmp.user__c)){
                ER_Approver = 'Requestor cannot be an approver.';    
            }
        }
        *******/
        
        /***********Will allow requestor to be an approver of a request***********
        if(CurrentManager != NULL && requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE ){
            User you = PP_Util.getLoggedinUserRecord();
            if(CurrentManager == you.Name){
                ER_Approver = 'A Requestor cannot also be an Approver on a request. Please select an Alternate Approver.';    
            }
        }
       
        //system.debug('********WatcherIds requestDeatils.CC_WatcherNames__c'+requestDeatils.CC_WatcherNames__c);
        if(CurrentManager != NULL && requestDeatils.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE && requestDeatils.CC_WatcherNames__c != NULL) {
            String wNames = requestDeatils.CC_WatcherNames__c;
            //system.debug('********WatcherIds w1 :'+wNames );
            //system.debug('********WatcherIds w3 :'+CurrentManager);
            if(wNames.contains(CurrentManager)){
                ER_Watcher = 'A Delegate cannot also be an Approver on a request. Please select an Alternate Approver or remove the Delegate.';    
            }
        }
        **/
        
        
        /***********Will allow requestor who belongs to an approver grp to create a request***********         
        if(requestDeatils.Property_Service_Approver__c != NULL && (requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE || requestDeatils.Request_Type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE ) ){
            if(PP_Util.getApproverByEmpIDAndGrpName(requestDeatils.Property_Service_Approver__c)){
                ER_Approver = 'Requestor cannot be an approver.';    
            }
        }
        
        if(WatchersUserId != null && WatchersUserId.trim() != '' && requestDeatils.Property_Service_Approver__c != NULL && (requestDeatils.Request_Type__c == PP_Util.EDC_REQUEST_TYPE || requestDeatils.Request_Type__c == PP_Util.PROPERTY_SERVICES_REQUEST_TYPE ) ){        
            if(PP_Util.isApproverInWatchers(requestDeatils.Property_Service_Approver__c, WatchersUserId )){
                ER_Approver = 'One or more delegates belongs to the Approver group. Please remove delegates.';    
            }
        } **/
             
        //Added by Balakumar
        Date d = Date.today();
        system.debug('---------------Removal Date is--------------'+removeDateStr);
        system.debug('---------------Todays Date is--------------'+d);
        //End Balakumar
        
        if(removeDateStr == null || removeDateStr.trim() == '' ) {
            // ER_RemovalDate=MandatoryErrorMessage;
            ER_RemovalDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else if(removeDateStr == 'NaN/NaN/NaN') {
            removeDateStr = null; //Added by Balakumar
            // ER_RemovalDate=MandatoryErrorMessage;
            ER_RemovalDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else{
            system.debug('----------Todays Date is----------'+d);
            system.debug('----------Todays Date is----------'+removeDateStr);
            Date d2= Date.parse(removeDateStr);
            
            system.debug('----------Date is----------'+d2);
            if (d2 < d){                                                
                        ER_RemovalDate = 'Please select a valid date.'; // MandatoryErrorMessage1;
                }
                else{
                    requestDeatils.Removal_Date__c=date.parse(removeDateStr);
                        system.debug('*************requestDeatils.Expected_Return_Date__c'+removeDateStr+requestDeatils.Removal_Date__c);
                    }
        }
        
        system.debug('---------------Return Date is--------------'+returnDateDt);
        system.debug('---------------Todays Date is--------------'+d);
        
       
        
        if(ReturnDate==true && (returnDateDt == null || returnDateDt.trim()=='')){
            // ER_ReturnDate = MandatoryErrorMessage;
            ER_ReturnDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else if(ReturnDate==false){
            requestDeatils.Expected_Return_Date__c=null;
        }
        else if(ReturnDate==true && returnDateDt == 'NaN/NaN/NaN') {
             returnDateDt = null; //Added by Balakumar
            // ER_ReturnDate=MandatoryErrorMessage;
            ER_ReturnDate = 'Please select a valid date.'; // Added by Avinash Munaga
        }
        else{
              Date d1= Date.parse(returnDateDt);
              if (d1 < d){                                               
                        // ER_ReturnDate= MandatoryErrorMessage1;                        
                        ER_ReturnDate = 'Please select a valid date.'; // Added by Avinash Munaga
                    }
                else{     
                      requestDeatils.Expected_Return_Date__c=date.parse(returnDateDt);
                }
        }
        
        
         //Added by Balakumar for Validation
        
        if((ReturnDate==true && returnDateDt != null) && removeDateStr !=null )
        {
            system.debug('---------------Remove Date is--------------'+removeDateStr);
            system.debug('---------------Return Date is--------------'+returnDateDt);
            Date d2= date.parse(removeDateStr);
            Date d1= date.parse(returnDateDt);
            if(d1 < d2)
            {
               // ER_ReturnDate= MandatoryErrorMessage2; 
               ER_ReturnDate = 'The removal date must be before the return date. Please select a valid date.'; // Added by Avinash Munaga
               //ER_ReturnDate = 'Please select a valid date.'; // Added by Avinash Munaga
            }
        }
        //End Balakumar
        
         
        if(requestDeatils.Location111__c == null){
            // ER_From=MandatoryErrorMessage;
            ER_From = 'Please make a selection.';    // Added by Avinash Munaga
        }
        
        if(requestDeatils.Destination_Details__c == null || requestDeatils.Destination_Details__c.trim() == ''){
            // ER_To=MandatoryErrorMessage;
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
        //End Balakumar
        
                
        //Please Un-comment.
        /*if(EDCCloseOutSection==true && (requestDeatils.Equipment_Receipt_Confirm__c == null || requestDeatils.Equipment_Receipt_Confirm__c.trim() == '') ){
            ER_EquipReceipt=MandatoryErrorMessage;
        }*/
        //system.debug('---------------------------------Purpose Length--------------------------'+requestDeatils.Removal_Purpose__c.length());
        system.debug('----------Removal_Purpose__c ----------'+requestDeatils.Removal_Purpose__c);
        if(requestDeatils.Removal_Purpose__c == null || requestDeatils.Removal_Purpose__c.trim() == '' || requestDeatils.Removal_Purpose__c.trim() == 'Enter business purpose'){
            // ER_Purpose=MandatoryErrorMessage;
            ER_Purpose = 'Please enter a business purpose.';        // Added by Avinash Munaga
            //system.debug('---------------------------------Purpose Length--------------------------'+requestDeatils.Removal_Purpose__c.length());
        }
        
        //Start Balakumar
        
         if(requestDeatils.Removal_Purpose__c.length()>4000){
                ER_Purpose='You are not allowed to enter more than 4000 characters.';
            }
            
        //End Balakumar   
        
         for(addmorerow X:innerlist){
            system.debug('check the list'+X);
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
                    //seven=true;
                     X.ProdDetails1.Items__c = String.valueof(0);
                }
                if ((X.ProdDetails1.Boxes__c == null || X.ProdDetails1.Boxes__c.trim() =='' || X.ProdDetails1.Boxes__c.isnumeric()==false)) {
                    //eight=true;
                    X.ProdDetails1.Boxes__c = String.valueof(0);
                }
                if ((X.ProdDetails1.Pallets__c== null || X.ProdDetails1.Pallets__c.trim() =='' || X.ProdDetails1.Pallets__c.isnumeric()==false)){
                    //nine=true;
                    X.ProdDetails1.Pallets__c = String.valueof(0) ;
                }       
                system.debug('***Prod Details***********'+first+fourth+fifth+sixth+seven+eight+nine+X.ProdDetails1.Items__c+X.ProdDetails1.Boxes__c+X.ProdDetails1.Pallets__c);
                
                if((X.ProdDetails1.Items__c =='0' && X.ProdDetails1.Boxes__c =='0' && X.ProdDetails1.Pallets__c =='0') ) {
                  X.ErrorMessage='Value should be greater than 0.';
                  X.ErrorMessage3 = 'Missing Items/Boxes/Pallets: At least one quantity must be greater than 0.';
                 
                    errorCheckonProperty=true;
                    
                }
                //system.debug('---------Items--------'+X.ProdDetails1.Items__c);
                //system.debug('---------Boxes--------'+X.ProdDetails1.Boxes__c);
                //system.debug('---------Pallets--------'+X.ProdDetails1.Pallets__c);
                //system.debug('---------X.ProdDetails1.Property_Name__c--------'+X.ProdDetails1.Property_Name__c);

                if(  !first  &&  !fourth ){
                    listdetails.add(X.ProdDetails1);
                  //  propertyUploadError=true;
                }
                 else if(X.ProdDetails1.Items__c != null && X.ProdDetails1.Items__c.trim() != '' && X.ProdDetails1.Items__c.isnumeric()==false ){
                    X.ErrorMessage='Items should be numeric.';                   
                    errorCheckonProperty=true;
                }
                 else if(X.ProdDetails1.Boxes__c != null && X.ProdDetails1.Boxes__c.trim() != '' && X.ProdDetails1.Boxes__c.isnumeric()==false ){
                    X.ErrorMessage='Boxes should be numeric.';                    
                    errorCheckonProperty=true;
                }
                 else if(X.ProdDetails1.Pallets__c!= null && X.ProdDetails1.Pallets__c.trim() != '' && X.ProdDetails1.Pallets__c.isnumeric()==false ){
                    X.ErrorMessage='Pallets should be numeric.';                    
                    errorCheckonProperty=true;
                } else {
                system.debug('---------X.ProdDetails1.Property_Name__c--------'+X.ProdDetails1.Property_Name__c);
                    if(X.ProdDetails1.Property_Name__c == null || X.ProdDetails1.Property_Name__c == '') {
                        X.ErrorMessage1 = 'Missing Property Type: Please select a Property Type.';
                    }
                    if(X.ProdDetails1.Description__c == null  || X.ProdDetails1.Description__c == '') {
                        X.ErrorMessage2 = 'Missing Description: Please enter a valid description.';
                    }
                    system.debug('----------------Errormessage3--------------------');
                    if((X.ProdDetails1.Items__c == null || X.ProdDetails1.Items__c == '' || X.ProdDetails1.Items__c == '0')
                             && (X.ProdDetails1.Boxes__c == null || X.ProdDetails1.Boxes__c == '' || X.ProdDetails1.Boxes__c == '0')
                             && (X.ProdDetails1.Pallets__c == null || X.ProdDetails1.Pallets__c == '' || X.ProdDetails1.Pallets__c == '0')) {
                        
                        //X.ErrorMessage3 = 'Missing Items/Boxes/Pallets (default 0): Please enter a total quantity greater than 0 for this row.';
                        X.ErrorMessage3 = 'Missing Items/Boxes/Pallets: At least one quantity must be greater than 0.';
                        system.debug('---------Errormessag3-----');
                    }
                    
                    X.ErrorMessage='You must enter all the values.';
                    errorCheckonProperty=true;
                }        
            }
        }        
         system.debug('*************error'+propertyUploadError +errorCheckonProperty+listofDeatisl.size());
        //Commenting as per QC 826
        /*if( listdetails.size()<=0 ){
            ER_CSVUploadError='Error: Property details are mandatory for submission.';
            system.debug('*************ER_CSVUploadError1');
        }*/
        
        /*
        else if(!propertyUploadError && !errorCheckonProperty && (listofDeatisl.size()<1 && fileAttchment.size() ==0)){
            ER_CSVUploadError='Error: Property details are mandatory for submission.';
            system.debug('*************ER_CSVUploadError2');
        }*/
        
        //system.debug('*************ER_CSVUploadError'+ER_CSVUploadError);
        
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

    /*Private String refreshWatcherList(List<string> lstWatchers) {
           if( lstWatchers == NULL) return null; 
           
           string empIds;
           list<employee__C> H=[select id,name from employee__C where email__C in :lstWatchers and status__c='Active'];
           for(employee__C e:H){
               empIds += e.Id + ';';
           }
           return empIds;
    }*/              

    /*Private static string getTabName(String strTab){
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
    }*/
    
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
   
   Public pagereference CloseConfirm(){
       /************** DONT KNOW WHY WE HAVE THIS QUERY*******/
       PR_Request__c chkStatus = [ Select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,
                                   Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c 
                                   from PR_Request__c where id =:ApexPages.currentPage().getParameters().get('id') ];
            //if(chkStatus.Status__c == 'Approved' || chkStatus.Status__C == 'Rejected' || chkStatus.Status__C == 'Closed')
            if(chkStatus.Status__c == 'Closed' || chkStatus.Status__c == 'Cancelled')
            {
                showPopupMessage=true;
                //pagereference p=new pagereference('/apex/PP_CreateRequest?id='+ApexPages.currentPage().getParameters().get('id'));//+'&tab=MyRequest'
                //p.setRedirect(true);
                //return p;
                return null;
            }
            else if(chkStatus.Status__c == 'Recalled' )
            {
            showPopupMessage1=true;
            return null;
            }
              
            else{ 
               ConfirmationWindow=true;
               return null;
           }
   }
   
    public pagereference CancelConfirm(){
    
    PR_Request__c a = [select name,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                          Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                          Removal_Purpose__c  from PR_Request__c where id=:ApexPages.currentPage().getParameters().get('id')];
   if(a.status__c == 'Cancelled' || a.status__c == 'Closed')
   {
        showPopupMessage=true;
            return null;
       /*pagereference p=new pagereference('/apex/PP_CreateRequest?id='+ApexPages.currentPage().getParameters().get('id'));//+'&tab=MyRequest'
       p.setRedirect(true);
       return p;*/
   }
   else
   {                       
   cancelConfrm=true;
   return null;
   }
  }
  
   public boolean cancelConfrm{get;set;}
   public boolean ConfirmationWindow{get;set;}
    
   Public pagereference closeRequest(){
        //private method
       PR_Request__c a = [select name,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                          Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                          Removal_Purpose__c  from PR_Request__c where id=:ApexPages.currentPage().getParameters().get('id')];
        if(a !=null){
            a.Status__c='Closed';
            a.ClosedBy__c=userinfo.getUserId();
            a.ClosedDate__c=system.now();
        }
        update a;
        PageReference pr = new PageReference('/apex/PP_RequestHome');//?tab=MyclosedRequest
        pr.setRedirect(true);
        return pr;
    }
 
    public String setActorname{get;set;}
    public String newerror{get;set;}

    public pagereference SearchToBuilding(){
        //buildinglist.clear();
        //Start Balakumar
        buildingList=null;
        //End 
        
        newerror=null;
        msgError=null;
        msgError1=false;
       
        if(DestinationDetailsName != null && DestinationDetailsName.length() <= 2) {
            msgError='Please enter a minimum of 3 characters.';
            msgError1=true;   
        } else {
            //Start Balakumar
            msgError1=false;
            //End Balakumar
            
            list<Building_Locations__c>  DummybuildingList =new list<Building_Locations__c>();
            //String Query='select id,name,City_State__c,Address1__c,Address2__c,BUILDING_NAME__c,CITY_DESCRIPTION__c from Building_Locations__c where';
            String Query='select id,name,City_State__c,Address1__c,Address2__c,CITY_DESCRIPTION__c from Building_Locations__c where';  
            if(DestinationDetailsName!=null || DestinationDetailsName!='') {
               /********** Wrong Query******
                Query += ' name  like \'%'+DestinationDetailsName+'%\' OR Address1__c like \'%'+DestinationDetailsName
                        +'%\' OR Address2__c like \'%'+DestinationDetailsName+'%\' OR CITY_DESCRIPTION__c like \'%'
                        +DestinationDetailsName+'%\' ';
                ************/
                Query += ' name  like \'%'+DestinationDetailsName+'%\' ';
            }  
    
            if(Query.endsWith('where')) {
                Query=Query.removeEnd('where');
                //Or else Error Message to display..,
                buildingList=null;
                system.debug('*********buildingList:'+buildingList);
            } else {
                Query+=' order by createdDate desc limit 26 ';
                system.debug('*********FinalQuery1:'+Query);
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
    
    public List<ProcessInstanceHistory> getApprovalProcessStatus(){
        if (ApexPages.currentPage().getParameters().get('id')!= null) {
            PR_Request__c  quote = [Select Id,createdbyid,LastModifiedBy.name,lastmodifieddate,CreatedBy.FirstName,CreatedBy.LastName,Approval_Rejection_Date__c , (Select Comments, RemindersSent, OriginalActorId, ActorId
                                                             From ProcessSteps where StepStatus='Approved' or StepStatus='Rejected'
                                                             order by SystemModstamp desc LIMIT 1)
                                       from PR_Request__c where id  = :ApexPages.currentPage().getParameters().get('id')];
             system.debug('-----------Query----------'+quote);
             system.debug('-----------Query----------'+quote.ProcessSteps);                          
             return quote.ProcessSteps;
        }
        return new List<ProcessInstanceHistory> ();
    }
       
 public list<sDocument>documentList1{get;set;}  
 
 public String ErroeOnDel{get;set;}
 
  public pagereference deletedocs(){
    ErroeOnDel=null;
    list<String> selectedDocsToDelete=new list<String>();
    list<sDocument> dummydoc=new list<sDocument>();
    integer h=1;
    for(sDocument V:documentList1){
        if(v.selecteddoc){
            
            String K=v.selectdoc.id;    
            selectedDocsToDelete.add(k.substring(0,15));
            
        }
        else
        {
            dummydoc.add(v);
            h++;
        }
        
    }
   documentList1=dummydoc;
    if(selectedDocsToDelete.size()<=0){
       ErroeOnDel='Please select atleast one item.';    
    return null;
    }
    list<document> todel=new list<document>();
    todel=[select id,name,body,contentType,type from document where id in:selectedDocsToDelete];
  
    delete todel; 
    
    
    return null;
    
 }
 
    Public class   sDocument {
        public document selectdoc {get; set;}
        public boolean selecteddoc {get; set;}   
        
        public sDocument(document selectdoc){
            this.selectdoc=selectdoc;
            selecteddoc=false;
        }   
    } 
     
    Public pagereference RequestNoConfirmation(){
        ConfirmationWindow=false;
        cancelConfrm=false;
    return null;
    }
    Public pagereference recallrequestconfirm() {
        List <PR_Request__c> chkStatus = PP_Util.getPPSingleRecord(ApexPages.currentPage().getParameters().get('ID'));
        if(chkStatus == null )  return null;
         if(chkStatus[0].Status__c == 'Recalled' || chkStatus[0].Status__c == 'Approved' || chkStatus[0].Status__C == 'Rejected' ) {
            showPopupMessage = true;
        }
        else {
            ConfirmationWindow = true;
            system.debug('******************ConfirmationWindow ::'+ConfirmationWindow );
        }
        return null;
    }
        
}