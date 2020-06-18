// Modified by Avinash on 02/03/2016
// looks like a copy of another class

@isTest
public class aaPP_RequestHomeController_Bala{
//   
public String TotalRequests { get; set; }
    Public User u{get;set;} 
    public list<PR_Request__c > requestList {get;set;}
    public string strSearchReq {get; set;}
    public String strInputSearch {get;set;}
    public boolean viewReq{get;set;} 
    public String selectedTab{get;set;}
    public String ReqId{get;set;}
    public String tabName{get;set;}
    public boolean isdateEnabled {get; set;}
    public date startDate{get; set;}
    public date endDate{get; set;}
    public string startDateN {get; set;}
    public string endDateN{get; set;}
    public string errorMessage {get; set;}
    public string flagCheckStart {get; set;}
    public string flagCheckEnd {get; set;}
    public String RequestId {get;set;}
    public list<PR_Request__c > ppRequestTotalList {get;set;}
     public boolean ConfirmationWindow1{get;set;}
    public Integer ppRequestCount {get;set;}
    // For Advance search
    public String strStatusAdvSearch {get; set;}
    public String strReqTypeAdvSearch {get; set;}
    public String strFromBlndgAdvSearch {get; set;}
    public String strToBlndgAdvSearch {get; set;}
        public boolean cancelConfrm{get;set;}
    public String strDisplayCategory {get; set;}
    
    public String strCreatedStartDtAdvSearch {get; set;}
    public String strCreatedEndAdvSearch {get; set;}
    
    public String strRemovalStartDtAdvSearch {get; set;}
    public String strRemovalEndDtAdvSearch {get; set;}
    /*            
    public date dtCreatedStartAdvSearch {get; set;}
    public date dtCreatedEndAdvSearch {get; set;}
    public date dtRemovalStartAdvSearch {get; set;}
    public date dtRemovalEndAdvSearch {get; set;}
    */
    public list<Building_Locations__c> buildingList{get;set;}
    public List<SelectOption> reqTypeList{get;set;}
    //Valiables for understanding the logged in users permission
    
    public boolean isRequestor{get;set;}
    public boolean isWatcher{get;set;}
    public boolean isApprover{get;set;}
    public boolean isFloorSecurity{get;set;}
    
    public String CurrentManager{get;set;}  
    public boolean showAddOthers{get;set;}
    public string removeDateStr{get; set;}
    public string returnDateDt{get; set;}
    public date removedate{get; set;}
    Public Boolean ReturnDate{get;set;}
    public boolean AddSearchbox{get;set;}
    public boolean AddFreeText{get;set;}
    public boolean AddVendor{get;set;}
    public String DestinationDetailsName{get;set;}
    public String vendorNameUi{get;set;}
    public String VendorName{get;set;}  
    Public boolean EDCCloseOutSection{get;set;}
      
    Public aaPP_RequestHomeController_Bala(){
   //group population
    requestList=new list<PR_Request__c>();
    list<PR_Request__c> dummyReqList=new list<PR_Request__c>();
    TotalRequests='0';
    tabName = 'My Request';
    isdateEnabled =false;
//    ppRequestCount = 0;
    strDisplayCategory = 'All';
        buildingList=[select id,name,City_State__c,Address1__c,Address2__c,CITY_DESCRIPTION__c  from Building_Locations__c limit 500 ]; //where InScopeFrom__c=true Not sure why InScopeFrom__c is not made true in building object
         system.debug('Check the building'+buildingList);
        reqTypeList = new List<SelectOption>();
    reqTypeList.add(new SelectOption('Standard','Standard')); 
    reqTypeList.add(new SelectOption('DataCenter','Data Center')); 
    reqTypeList.add(new SelectOption('PropertyServices','Property Services'));    
   
    
         
    selectedTab = ApexPages.Currentpage().getParameters().get('tab');
    System.debug('*************************************PPR_NewRequestTest_bootstrap()****selectedTab :'+selectedTab );
    viewReq = false;
   
    String useremail = [select email from user where id=:userinfo.getUserId()].email;
    
  employee__C loggedInEmp = [select emp_id__c,Officer__c, cost_center__c,name,First_Name__c,CC_Region_Org__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                            , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                            , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c,Building_Directory__c 
                            from employee__c where email__C = : useremail];  
                                                   
  if(loggedInEmp.Officer__c=='Y'){
    isApprover=true;
  }  
  else
  {
    isApprover=false;
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
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   /*
    //MyRequest Tab
    if(selectedTab =='Myrequest' || selectedTab == null){
        // Property_Description__c,Removal_Type__c,
        dummyReqList = [Select name,Employee_Requestee_Name__r.name,CreatedById, Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Date__c,
                        Request_Type__c,CC_WatchList__c from PR_Request__c 
                        where  Status__c in ('Saved', 'Submitted','Approved','Recalled') order by createdDate desc ]; 
        for(PR_Request__c X:dummyReqList){
            if(x.CC_WatchList__c!=null){
                if(x.CreatedById==userinfo.getUserId() || x.CC_WatchList__c.contains(useremail)){
                    requestList.add(X);
                }
            } else {
                if(x.CreatedById==userinfo.getUserId()){
                    requestList.add(X);
                }       
            }
        }
        selectedTab = 'Myrequest';
    }
    
    //Get My History requeuest  Property_Description__c,
    else if(selectedTab =='MyHistory'){          
        dummyReqList =[select name,Employee_Requestee_Name__r.name,CC_WatchList__c,CreatedById,
        Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
        Request_Type__c from PR_Request__c where  
        Status__c in ('Rejected', 'Closed', 'Collected','Cancelled' ) order by createdDate desc]; 
        
         for(PR_Request__c X:dummyReqList){
                if(x.CC_WatchList__c!=null){
                if(x.CreatedById==userinfo.getUserId() || x.CC_WatchList__c.contains(useremail)){
                        requestList.add(X);
                }
                        
                }
                else
                {
                if(x.CreatedById==userinfo.getUserId()){
                        requestList.add(X);
                }       
                }
         }
          
    }
    
    //Get Closed Request..,this logic need to be changed
    //,Removal_Date__cProperty_Description__c
    else if(selectedTab =='MyclosedRequest'){ 
    //,'Pending Checked-in'  
        dummyReqList =[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.user__c,
                     CreatedDate,Removal_Type__c,CC_WatchList__c,CreatedById,
                     Request_Type__c,Location111__r.name
                     from PR_Request__c where  
                     Status__c in ('Approved') order by createdDate desc];
                      for(PR_Request__c X:dummyReqList){
                if(x.status__c=='Approved'){
                        requestList.add(X);
                }
                        
                
                if(x.EDC_CloseOut_Approver__r.user__c==userinfo.getUserId() && x.status__c=='Pending Checked-in'){
                        requestList.add(X);
                }       
                
         }
           
    }
    
    //Get Pending Approval Requests..,
    //changed the query where clause for demo purpose where sanjib 29/10
       // Manager__r.user__C=:userinfo.getUserId()
    //,Removal_Date__c    Property_Description__c,
    else if(selectedTab =='MypendingApprovals'){   
        dummyReqList =[select name,Employee_Requestee_Name__r.name,
        Employee_Requestor_Name__r.name,Status__c,CreatedDate,
        Removal_Type__c,Manager__r.user__C,Removal_Date__c,Requestor_Region__c,
        Request_Type__c,Manager__c, Location111__c, Removal_Purpose__c from PR_Request__c where
         status__c='Submitted' order by createdDate desc]; 
        for(PR_Request__c X:dummyReqList){
        if(X.Manager__c!=null){
        if(X.Manager__r.user__C==userinfo.getUserId())
        requestList.add(X);
        }
        else{
         if(X.Request_Type__c=='Data Center' && X.Requestor_Region__c=='NA'){
         if(groupuserId('PP_Americas_Data_Center_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_1585Bway_PropSvcs_Approvers'){
         if(groupuserId('PP_1585Bway_PropSvcs_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
         }
        
        
        
        }
        }
    }
    
    ELSE{
        //eRROR TO dISPLAY..,
    }
    */
    
 
    
    //EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.user__c,
     
     requestList = [ Select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,
                     CreatedDate,Removal_Type__c,CC_WatchList__c,CreatedById, Request_Type__c,Location111__r.name
                     from PR_Request__c 
                     where CreatedById=:userinfo.getuserId() AND  OwnerId=:userinfo.getuserId()
                     order by createdDate desc,Status__c asc];
                     
       
    if(requestList != null && !requestList.isEmpty()){
        TotalRequests = string.valueOf(requestList.size()); 
    }
    total_size=requestList.size();
    

requestList =     getPageResults();
}

 private integer counter=0;  //keeps track of the offset
   private integer list_size=20; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   
   
   
   
   private list<PR_Request__c> getPageResults() {
    
    Datetime DtStart;
    Datetime DtEnd;
    date stDate;
    date etDate;
    errorMessage ='';
    String userid1=userinfo.getUserId();
    String userid=userid1.substring(0,15);
     String useremail = [select email from user where id=:userinfo.getUserId()].email;
   
    list<PR_Request__c> pageRecords;
    list<PR_Request__c> DummypageRecords=new list<PR_Request__c>();
    
    if(isApprover!=null && isApprover==false && isFloorSecurity==false  ){
    String Query='select name,CreatedById ,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Manager__c,Manager__r.user__C,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where';
              //  Query += ' CreatedById= \''+userid+'\'  ';
                
                 Query += ' ((CreatedById= \''+userid+'\' ) OR (Watcher1__c=\''+useremail+'\') OR (Watcher2__c=\''+useremail+'\') or(Watcher3__c=\''+useremail+'\')or(Watcher4__c=\''+useremail+'\') or(Watcher5__c=\''+useremail+'\')or(Watcher6__c=\''+useremail+'\')or(Watcher7__c=\''+useremail+'\')or(Watcher8__c=\''+useremail+'\')or(Watcher9__c=\''+useremail+'\')or(Watcher10__c=\''+useremail+'\'))'  ;
    
    
  
                
                
                
                
                
                
                
                
                
                
                
                
     Query += 'AND';           
    if(strSearchReq != null && strSearchReq != ''){
        if(strInputSearch != null && strInputSearch!= ''){
            strInputSearch=strInputSearch.trim();
            if(strSearchReq == 'Name'){
                Query+=' Name  like \'%'+strInputSearch+'%\' ';
            }
            if(strSearchReq == 'Employee_Requestor_Name__r.name'){
                system.debug('requestor Name'+strInputSearch);
                Query+=' Employee_Requestee_Name__r.name like \'%'+strInputSearch+'%\' ';
            }
            if(strSearchReq == 'Request_Type__c'){

                Query+=' Request_Type__c like \'%'+strInputSearch+'%\' ';
            }
            if(strSearchReq == 'Status__c'){
                    //Error to display..,
                    if(strInputSearch.length()>=3){
                    
              
                   String C='Pending Approval' ;
                    String C1='In Draft';
                   String C2='Approved';
                  if(c.contains(strInputSearch)){
                    if ('Pending'.contains(strInputSearch)){
                        Query+=' Status__c =\'Submitted\'';
                    }
                    else if(('Approv').contains(strInputSearch)){
                        Query+='( Status__c =\'Submitted\' or Status__c =\'Approved\')';
                    }
                    else if(('Pending Approval').contains(strInputSearch)){
                        Query+='( Status__c =\'Submitted\')';
                    }
                    
                    
                   }
                    else if(c1.contains(strInputSearch)){
                        Query+=' (Status__c =\'Saved\' OR Status__c =\'Recalled\') ';
                    }
                      
                    else if(c2.contains(strInputSearch)){
                        
                        Query+=' Status__c =\'Approved\'';
                        
                    }
                    
                  
                  
                  
                 
                     String C3='Rejected' ;
                  String C4='Closed';
                  String C5='Cancelled';
                  
                  
                    if(c3.contains(strInputSearch)){
                        Query+=' Status__c =\'Rejected\'';
                    }
                    else if(c4.contains(strInputSearch)){
                        Query+=' Status__c =\'Closed\'';
                    }
                     else if(c5.contains(strInputSearch)){
                        Query+=' Status__c =\'Cancelled\'';
                    }
                   
                 
                  }
                  
                    }
                    else
                    {
                         errorMessage='Please enter more than 3 characters.';
                    }
                  
                  
                    
                /*
                 if( selectedTab =='MyHistory' && (strInputSearch!='Rejected' && strInputSearch!='Cancelled'  && strInputSearch!='Closed' && strInputSearch!='Collected' && strInputSearch!='Recalled') ){
                    //Error to display..,
                     errorMessage='Invalid Search';
                    system.debug('*********MyHistory'+strInputSearch);
                }
                if( selectedTab =='MyclosedRequest' && (strInputSearch!='Approved') ){
                    //Error to display..,
                     errorMessage='Invalid Search';
                    system.debug('*********MyclosedRequest'+strInputSearch);
                }
                
                else{                
                    if(strInputSearch.contains('Pending Approval')){
                        Query+=' Status__c =\'Submitted\'';
                    }
                    else if(strInputSearch.contains('In Draft')){
                        Query+=' Status__c =\'Saved\' OR Status__c =\'Recalled\' ';
                    }
                    else if(strInputSearch.contains('Rejected')){
                        Query+=' Status__c =\'Rejected\'';
                    }
                    else if(strInputSearch.contains('Closed')){
                        Query+=' Status__c =\'Closed\'';
                    }
                     else if(strInputSearch.contains('Cancelled')){
                        Query+=' Status__c =\'Cancelled\'';
                    }
                   
                }*/
            
        }
        else if(strSearchReq != 'CreatedDate' && strSearchReq != 'Removal_Date__c'){
            errorMessage='You must input this.';
        }
        
        if(strSearchReq == 'CreatedDate'){
            system.debug('*********start & end dates inside created date search'+startDateN+endDateN);         
            
            if(startDateN != null && startDateN.trim() != ''){
                system.debug('**********going inside'+startDateN);   
                stDate=date.parse(startDateN);               
                DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
                system.debug('*********DtStart'+DtStart);             
                Query+=' CreatedDate >=:DtStart ';
            }
            if(startDateN != null && startDateN.trim() != '' && endDateN != null && endDateN.trim() !='' ){
                etDate=date.parse(endDateN); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' AND CreatedDate <=:DtEnd ';
            } 
            if((startDateN == null || startDateN.trim() =='') && endDateN != null && endDateN.trim() !='' ){
                etDate=date.parse(endDateN); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' CreatedDate <=:DtEnd ';
            } 
            if((startDateN == null || startDateN.trim() =='') && (endDateN ==null || endDateN.trim() =='')){
                errorMessage='You must input this.';
            }  
        }
        if(strSearchReq == 'Removal_Date__c'){
            system.debug('*********start & end dates inside removal date search'+startDateN+endDateN );    
            if(startDateN != null && startDateN.trim() != ''){
                stDate=date.parse(startDateN);               
                Query+=' Removal_Date__c >=:stDate ';
            }
            if(startDateN != null && startDateN.trim() != '' && endDateN != null && endDateN.trim() != ''){
                etDate=date.parse(endDateN);  
                Query+=' AND Removal_Date__c <=:etDate ';
            } 
            if((startDateN == null || startDateN.trim()=='') && endDateN != null && endDateN.trim() != ''){
                etDate=date.parse(endDateN); 
                Query+=' Removal_Date__c <=:etDate ';
            }
             if((startDateN == null || startDateN.trim() =='') && (endDateN ==null || endDateN.trim() =='')){
                errorMessage='You must input this.';
            }         
        }
         
        
      
    }
    
    

    //,Removal_Date__c,Property_Description__c,
    //String Query='select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where';
    
    //Status
    if(strStatusAdvSearch != null && strStatusAdvSearch != '' && strStatusAdvSearch != 'All' ){
         Query += ' Status__c  = \''+strStatusAdvSearch  +'\' '; 
    }
    //Request Type
    if(strReqTypeAdvSearch != null && strReqTypeAdvSearch != '' ){
        if(strStatusAdvSearch != 'All') {
             Query+=' AND Request_Type__c  = \''+strReqTypeAdvSearch+'\' ';
         }
         else {
             Query+=' Request_Type__c  = \''+strReqTypeAdvSearch+'\' ';
         }
    }
    
    
    //advance search created date sanjib ghosh
    
     if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch.trim() != ''){
                system.debug('**********going inside'+startDateN);   
                stDate=date.parse(strCreatedStartDtAdvSearch);               
                DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
                system.debug('*********DtStart'+DtStart);             
                Query+='AND CreatedDate >=:DtStart ';
            }
            if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch.trim() != '' && strCreatedEndAdvSearch != null && strCreatedEndAdvSearch.trim() !='' ){
                etDate=date.parse(strCreatedEndAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' AND CreatedDate <:DtEnd ';
            } 
            if((strCreatedStartDtAdvSearch == null || strCreatedStartDtAdvSearch.trim() =='') && strCreatedEndAdvSearch != null && strCreatedEndAdvSearch.trim() !='' ){
                etDate=date.parse(strCreatedEndAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+='AND CreatedDate <:DtEnd ';
            } 
         
    
    //advance search for removal date
    
      if(strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch.trim() != ''){
                system.debug('**********going inside'+startDateN);   
                stDate=date.parse(strRemovalStartDtAdvSearch);               
                DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
                system.debug('*********DtStart'+DtStart);             
                Query+='AND CreatedDate >=:DtStart ';
            }
            if(strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch.trim() != '' && strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch.trim() !='' ){
                etDate=date.parse(strRemovalEndDtAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' AND CreatedDate <:DtEnd ';
            } 
            if((strRemovalStartDtAdvSearch == null || strRemovalStartDtAdvSearch.trim() =='') && strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch.trim() !='' ){
                etDate=date.parse(strRemovalEndDtAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+='AND CreatedDate <:DtEnd ';
            } 
         
    
   
    
    

    //Created Start Date    
    /*
    if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch != '' ){
        stDate=date.parse(strCreatedStartDtAdvSearch);               
        DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day(), 0, 0, 0);
        system.debug('*********DtStart'+DtStart);             
        Query+=' AND CreatedDate >='+DtStart ;
    }
    
    //Created End Date   
    if(strCreatedEndAdvSearch != null && strCreatedEndAdvSearch != '' ){
      etDate=date.parse(strCreatedEndAdvSearch); 
        DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day(), 0, 0, 0);
        DtEnd=DtEnd.adddays(1);
        system.debug('*********DtEnd'+DtEnd);
        Query+=' AND CreatedDate <='+DtEnd ;
    }
    
    
    if(strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch != '' ){
         stDate = date.parse(strRemovalStartDtAdvSearch );
         DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
         Query+=' AND Removal_Date__c >='+DtStart;
    }
    
    
    if(strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch != '' ){
       etDate = date.parse(strRemovalEndDtAdvSearch );
       DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
          DtEnd=DtEnd.adddays(1);
       Query+=' AND Removal_Date__c <='+DtEnd;
    }
    */
    
    if(strFromBlndgAdvSearch != null && strFromBlndgAdvSearch != '' ){
         Query+=' AND Location111__r.ID = \''+strFromBlndgAdvSearch +'\' ';
    }
    
    if(strToBlndgAdvSearch != null && strToBlndgAdvSearch != '' ){
         Query+=' AND Destination_Details__c = \''+strToBlndgAdvSearch +'\' ';
    }
    
    
    
      system.debug('*********FinalQuery'+Query);
        
        if(Query.endsWith('AND')){
        system.debug('*********FinalQuery0:'+Query);
        Query = Query.substring(0, Query.Length()-3);
        system.debug('*********FinalQuery00:'+Query);
        
            //Query=Query.removeEnd('AND');
            //Or else Error Message to display..,
            //pageRecords =null;
        }
        //else{
                Query +=' order by createdDate desc ';
                Query +=' limit '+list_size+ '  offset '+counter+ '';
                system.debug('*********FinalQuery1:'+Query);
                pageRecords = (List<PR_Request__c>)Database.Query(Query);            
        //}
        system.debug('*********pageResults: '+pageRecords );
        system.debug('*********pageResults:Total:'+TotalRequests );
        system.debug('*********pageRecords:Total Size: '+total_size);
        
    }
    
   else if(isApprover==true)
   {
    pageRecords=new list<PR_Request__c>();
    
     //assign the request to the approvers
  DummypageRecords=[select name,Employee_Requestee_Name__r.name,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,
        Employee_Requestor_Name__r.name,Status__c,CreatedDate,
        Removal_Type__c,Manager__r.user__C,Removal_Date__c,Requestor_Region__c,CreatedById,
        Request_Type__c,Manager__c, Location111__c, Removal_Purpose__c,Property_Service_Approver__c from PR_Request__c where
        CreatedById=:userid OR status__c='Submitted' order by createdDate desc];
        
         for(PR_Request__c X:DummypageRecords){
             System.debug('Test data'+x.Manager__r.user__C);
             
        if(x.CreatedById==userid){
            pageRecords.add(X);
        
        } 
             
             
        if(X.Manager__c!=null){
        if(userinfo.getUserId()!=null)
        System.debug('Test data'+x.Manager__c);
        pageRecords.add(X);
        }
        else{
         if(X.Request_Type__c=='Data Center' && X.Requestor_Region__c=='NA'){
         if(groupuserId('PP_Americas_Data_Center_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
         if(X.Request_Type__c=='Data Center' && X.Requestor_Region__c=='EU'){
         if(groupuserId('PP_EMEA_Data_Center_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
         if(X.Request_Type__c=='Data Center' && (X.Requestor_Region__c=='NJ' || X.Requestor_Region__c=='JA')){
         if(groupuserId('PP_Asia_Data_Center_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
         
         if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_1585Bway_PropSvcs_Approvers'){
         if(groupuserId('PP_1585Bway_PropSvcs_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
       
         if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_1NYP_PropSvcs_Approvers'){
         if(groupuserId('PP_1NYP_PropSvcs_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
       
        if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_1PP_PropSvcs_Approvers'){
         if(groupuserId('PP_1PP_PropSvcs_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
       
        if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_2000W_PropSvcs_Approvers'){
         if(groupuserId('PP_2000W_PropSvcs_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
       
        if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_522FifthAve_PropSvcs_Approvers'){
         if(groupuserId('PP_522FifthAve_PropSvcs_Approvers',userinfo.getUserId())){
         pageRecords.add(X);
         }
         }
       
        
        
        }
        }
          
        
   }
   
   else if(isFloorSecurity==true){
    
    
     pageRecords=[select name,Employee_Requestee_Name__r.name,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,
        Employee_Requestor_Name__r.name,Status__c,CreatedDate,
        Removal_Type__c,Manager__r.user__C,Removal_Date__c,Requestor_Region__c,CreatedById,
        Request_Type__c,Manager__c, Location111__c, Removal_Purpose__c,Property_Service_Approver__c from PR_Request__c where
        CreatedById=:userid OR (status__c='Approved' AND IsPassGenerated__c=true)    order by createdDate desc];
 
    
   }
        
        
        
        
        //if(pageRecords != null && !pageRecords.isEmpty()){
        //    TotalRequests = string.valueOf(pageRecords.size()); 
        //     total_size = pageRecords.size();
       // }
       // else{
       //     TotalRequests='0';
       // }
   
   // list<PR_Request__c> numbers = [ Select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,
   //                  CreatedDate,Removal_Type__c,CC_WatchList__c,CreatedById, Request_Type__c,Location111__r.name
   //                  from PR_Request__c 
   //                  where CreatedById=:userinfo.getuserId() AND  OwnerId=:userinfo.getuserId()
   //                  order by createdDate desc,Status__c asc limit :list_size offset :counter];
    
    return pageRecords;
 }
 
 
 
 
  private boolean groupuserId(String X,String Y){
    Map<String,String> gMap = new Map<String,String>();
    Map<string,String> gIdMap = new Map<string,String>();
    Map<string,List<GroupMember>> groupMemberMap = new Map<string,List<GroupMember>>();
    List<Group> gList = new List<Group>();
    gList = [Select g.Id, g.DeveloperName, (Select UserOrGroupId From GroupMembers) From Group g];
    for (Group g:gList){
        String V=g.id;
        gMap.put(g.developername,v.substring(0,15));
        gIdMap.put(v.substring(0,15),g.developername);
        groupMemberMap.put(g.id,g.GroupMembers);
    }
    
     ID gId = gMap.get(X);
     List<GroupMember> gmList = groupMemberMap.get(gId);
     Set<ID> userIdSet = new Set<ID>();
                for (GroupMember g:gmList){
                    if (string.valueOf(g.UserOrGroupId).startswith('005')){
                        userIdSet.add(g.UserOrGroupId);
                    }   
                }
                
       if (userIdSet.size() > 0){
                    List<User> uList = [select email from User where id in :userIdSet];
                    
                     for(user V:uList ){
                     if(v.id==Y){
                     return true;
                     }
                       }
        }
                    
                 return  false;        
  
   
   }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
        requestList =  getPageResults();
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
     requestList =  getPageResults();
      return null;
   }
 
   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
        requestList =  getPageResults();
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
 
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }

 public Integer getRowsCount() {
      return list_size;
   }

public Integer getCounterValue() {
      return counter;
   }
































    
   
//Modified by Kumaresan on 7-10-2014
    public List<SelectOption> getSearchParams() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('','---- Select ----'));
        options.add(new SelectOption('','Select...'));
        options.add(new SelectOption('Name','ID'));
        options.add(new SelectOption('Employee_Requestor_Name__r.name','Requested For'));
        options.add(new SelectOption('Request_Type__c','Request Type'));
        options.add(new SelectOption('CreatedDate','Created Date'));
        options.add(new SelectOption('Removal_Date__c','Removal Date'));
        /*Added From in the closerequest Search SG*/
        //if(selectedTab=='MyclosedRequest'){
        //options.add(new SelectOption('Location111__r.name','From'));    
       // }        
        options.add(new SelectOption('Status__c','Status'));
       
        return options;
    }

public pageReference findDateField(){
system.debug('****************strSearchReq:'+strSearchReq); 
    if(strSearchReq == 'CreatedDate' || strSearchReq == 'Removal_Date__c'){
        isdateEnabled=true;

        startDate=system.today();
        endDate=system.today().adddays(1);
        flagCheckStart ='not loaded';
        flagCheckEnd ='not loaded';
    }
    else{
        isdateEnabled=false;

        startDate=null;
        endDate=null;
    }
    system.debug('****************isdateEnabled:'+isdateEnabled); 

    errormessage='';
    return null;
}


//recall request confirm window and logic
            public pagereference recallrequestconfirm()
             {
              // recallRequest = true;
               ConfirmationWindow1=true;
               return null;
             }
             public pagereference recallRequest(){
                  //  system.debug('test sanjib'+RequestId);
                    recallfromapproval(RequestId);
                    ConfirmationWindow1=false;
                    
                     PR_Request__c rPP1 = [select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where id =: RequestId];
                     
                    rPP1.Status__c='Recalled';
                    update rPP1;
                  //  strStatus='In Draft';
                    pagereference p=new pagereference('/apex/pp_createrequest?id='+RequestId+'&tab=Myrequest');
                    p.setRedirect(true);
                   //pagereference p=new pagereference('/apex/PP_RequestTest?tab=Myrequest');
                    return p; 
                  //return null;  
                }
    
//

          private void recallfromapproval(String Id){
                
                 ProcessInstance piFSA = [Select ID, Status From ProcessInstance Where TargetObjectID = :id AND Status = 'Pending'];
                       
                if(piFSA !=Null){
                    ProcessInstanceWorkitem piwiFSA = [select Id,OriginalActorId from ProcessInstanceWorkitem where ProcessInstanceId= :piFSA.Id LIMIT 1];
                    Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
                    prWkItem.setWorkItemID(piwiFSA.id);
                    prWkItem.setComments('Auto Approve FSA upon manager assignment of a partner member in .......');
                    prWkItem.setAction('Removed');
                    Approval.ProcessResult appResult = Approval.process(prWkItem);
                }        
               
                
            }
        
 
   public pagereference RequestNoConfirmation(){
    ConfirmationWindow1=false;
    cancelConfrm=false;
    return null;
 }
 
 public pagereference requestnosubmit(){
     confrimsubmit=false;
     return null;
 }


public pagereference searchOpenReqs(){
    
    //Get My request based on dynamic filters.
    system.debug('*************inside searchOpenReqs');  

    Datetime DtStart;
    Datetime DtEnd;
    date stDate;
    date etDate;
    errorMessage ='';
    String userid1=userinfo.getUserId();
    String userid=userid1.substring(0,15);
    //,Removal_Date__c,Property_Description__c,
    String Query='select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where';
    
    if(strSearchReq != null && strSearchReq != ''){
        if(strInputSearch != null && strInputSearch!= ''){
            strInputSearch=strInputSearch.trim();
            if(strSearchReq == 'Name'){
                Query+=' Name  like \'%'+strInputSearch+'%\' ';
            }
            if(strSearchReq == 'Employee_Requestor_Name__r.name'){
                system.debug('requestor Name'+strInputSearch);
                Query+=' Employee_Requestee_Name__r.name like \'%'+strInputSearch+'%\' ';
            }
            if(strSearchReq == 'Request_Type__c'){
               // Query+=' Request_Type__c=\''+strInputSearch+'\' ';
                Query+=' Request_Type__c like \'%'+strInputSearch+'%\' ';
            }
            
            
            /* added From in Dynamic Query SG*/
          // if(strSearchReq == 'Location111__r.name'){
           //  Query+=' Location111__r.name like \'%'+strInputSearch+'%\' ';
            //}
            
            
            if(strSearchReq == 'Status__c'){
             /*   if( selectedTab =='Myrequest' && (strInputSearch!='Pending Approval' && strInputSearch!='In Draft' && strInputSearch!='Approved') ){
                    //Error to display..,
                    errorMessage='Invalid Search';
                    system.debug('*********Myrequest'+strInputSearch);
                }
                else if( selectedTab =='MyHistory' && (strInputSearch!='Rejected' && strInputSearch!='Cancelled'  && strInputSearch!='Closed' && strInputSearch!='Collected' && strInputSearch!='Recalled') ){
                    //Error to display..,
                     errorMessage='Invalid Search';
                    system.debug('*********MyHistory'+strInputSearch);
                }
                else if( selectedTab =='MyclosedRequest' && (strInputSearch!='Approved') ){
                    //Error to display..,
                     errorMessage='Invalid Search';
                    system.debug('*********MyclosedRequest'+strInputSearch);
                }
                else{
                */                
                    if(strInputSearch=='Pending Approval'){
                        Query+=' Status__c =\'Submitted\'';
                    }
                    else if(strInputSearch=='In Draft'){
                        Query+=' Status__c =\'Saved\'';
                    }
                    else if(strInputSearch=='Rejected'){
                        Query+=' Status__c =\'Rejected\'';
                    }
                    else if(strInputSearch=='Closed'){
                        Query+=' Status__c =\'Closed\'';
                    }
                    else if(strInputSearch=='Collected'){
                        Query+=' Status__c =\'Collected\'';
                    }
                    else if(strInputSearch=='Recalled'){
                        Query+=' Status__c =\'Recalled\'';
                    }
                    else if(strInputSearch=='Approved'){
                        Query+=' Status__c =\'Approved\'';
                    }
                     else if(strInputSearch=='Cancelled'){
                        Query+=' Status__c =\'Cancelled\'';
                    }
                   
                //}
            }
        }
        else if(strSearchReq != 'CreatedDate' && strSearchReq != 'Removal_Date__c'){
            errorMessage='You must input this.';
        }
        
        if(strSearchReq == 'CreatedDate'){
            system.debug('*********start & end dates inside created date search'+startDateN+endDateN);         
            
            if(startDateN != null && startDateN.trim() != ''){
                system.debug('**********going inside'+startDateN);   
                stDate=date.parse(startDateN);               
                DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
                system.debug('*********DtStart'+DtStart);             
                Query+=' CreatedDate >=:DtStart ';
            }
            if(startDateN != null && startDateN.trim() != '' && endDateN != null && endDateN.trim() !='' ){
                etDate=date.parse(endDateN); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' AND CreatedDate <=:DtEnd ';
            } 
            if((startDateN == null || startDateN.trim() =='') && endDateN != null && endDateN.trim() !='' ){
                etDate=date.parse(endDateN); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' CreatedDate <=:DtEnd ';
            } 
            if((startDateN == null || startDateN.trim() =='') && (endDateN ==null || endDateN.trim() =='')){
                errorMessage='You must input this.';
            }  
        }
        if(strSearchReq == 'Removal_Date__c'){
            system.debug('*********start & end dates inside removal date search'+startDateN+endDateN );    
            if(startDateN != null && startDateN.trim() != ''){
                stDate=date.parse(startDateN);               
                Query+=' Removal_Date__c >=:stDate ';
            }
            if(startDateN != null && startDateN.trim() != '' && endDateN != null && endDateN.trim() != ''){
                etDate=date.parse(endDateN);  
                Query+=' AND Removal_Date__c <=:etDate ';
            } 
            if((startDateN == null || startDateN.trim()=='') && endDateN != null && endDateN.trim() != ''){
                etDate=date.parse(endDateN); 
                Query+=' Removal_Date__c <=:etDate ';
            }
             if((startDateN == null || startDateN.trim() =='') && (endDateN ==null || endDateN.trim() =='')){
                errorMessage='You must input this.';
            }         
        }
         
        
        system.debug('*********FinalQuery'+Query);
        
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            //Or else Error Message to display..,
            requestList=null;
        }
        else{
           // if(selectedTab =='Myrequest' || selectedTab =='MyHistory' || selectedTab =='MyclosedRequest'){
                //Query=Query+' AND CreatedById=\''+userinfo.getuserId()+'\' ';
                Query=Query+' AND CreatedById= \''+userid+'\'';
           // }
           // else if(selectedTab =='MypendingApprovals'){
                Query=Query+' AND OwnerId=\''+userinfo.getuserId()+'\' ';
                //Query=Query+' AND OwnerId=\''+userid+'\'';
                //Query=Query+' AND OwnerId=\'005f0000000jioG\'';
           // }
            Query+=' order by createdDate desc ';
            system.debug('*********FinalQuery1:'+Query);
            requestList=(List<PR_Request__c>)Database.Query(Query);            
        }
        system.debug('*********FinalSearchrequestList'+requestList);
        if(requestList != null && !requestList.isEmpty()){
            TotalRequests = string.valueOf(requestList.size()); 
             total_size=requestList.size();
             system.debug('*********Quick Serach Search Total:'+TotalRequests );
             system.debug('*********Quick Serach Search Total SIZE:'+total_size);
               requestList = getPageResults();
        }
        else{
            TotalRequests='0';
        }
    }
    else{
        errorMessage='You must input this.';
    }  
  
    return null; 
}


/*
public pagereference searchOpenReqs(){
    
  requestList = getPageResults();
      
    return null; 
}*/


   
    
public boolean ConfirmationWindow{get;set;}
public String ReqIdToClose{get;set;}

public pagereference confirmclose(){
    ConfirmationWindow=true;
    return null;
}


public boolean confrimsubmit{get;set;}
 public pagereference submitconfirm(){
    confrimsubmit=true;
    return null;
 }
 













public pagereference CloseWindow1(){
ConfirmationWindow=false;
return null;    
}

public pagereference CloseWindow2(){
ConfirmationWindow1=false;
return null;    
}


public pagereference CloseWindow3(){
confrimsubmit=false;
return null;    
}


public String reqnameToClose{get;set;}
public pagereference closeRequest(){
//Removal_Date__c,
ConfirmationWindow=false;
        system.debug('the placeholder'+ReqIdToClose);
        //private methodProperty_Description__c,
        PR_Request__c a=[select name,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                        Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                        Removal_Purpose__c  from PR_Request__c where id=:ReqIdToClose];
                        
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
        
        update a;
        PageReference pr = new PageReference('/apex/pp_requesthome?tab=MyclosedRequest');
                  pr.setRedirect(true);
                   return pr;
}

public pagereference ViewRequest(){
        //system.debug('the placeholder'+IdPlaceHolder);
                system.debug('the ReqID'+ReqID);
                 //PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap?id='+ReqID);
                 PageReference pr = new PageReference('/apex/PP_createrequest?id='+ReqID);
                  pr.setRedirect(true);
        //private method
//        PR_Request__c a=[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Property_Description__c,Removal_Type__c,Request_Type__c,Removal_Date__c,Property_Owner__c,Location111__c,Destination_Details__c,Removal_Purpose__c  from PR_Request__c where name=:ReqID];
        
        return null;
}


public pagereference clear(){
    PageReference pr = new PageReference('/apex/PP_RequestHome');
    pr.setRedirect(true);
    return pr;
}
public pagereference NewRequest(){
       PageReference pr = new PageReference('/apex/PP_createRequest?tab=NewRequest');
    pr.setRedirect(true);
    return pr;
}

public String getSelectedTabName(){

System.debug('*************************************getSelectedTabName()****selectedTab :'+selectedTab );
if(selectedTab =='Myrequest')
    tabName = 'My Requests';
else if(selectedTab =='MyHistory')
    tabName = 'History';
else if(selectedTab =='MyclosedRequest')
    tabName = 'Close Requests';
else if(selectedTab =='MypendingApprovals')
    tabName = 'My Approvals';
else
    tabName = 'New Requests';
 return tabName;

}





 public string clickedRowId{get;set;}
 
 public pagereference readCellMethod(){
    pagereference a=new pagereference('/apex/PP_createRequest?id='+clickedRowId+'&tab='+selectedTab);
    return a;
 }
 
 public class addmorerow{    
        Public property_Detail__c ProdDetails1{get;set;}
        public string ErrorMessage {get; set;}
        public boolean addbutton{get;set;}
        public addmorerow(){
            ProdDetails1=new property_Detail__c();
            ErrorMessage =null;
            addbutton=true;
        }
    }
    public PR_Request__c requestDeatils{get;set;}
    public list<property_Detail__c> listofDetails_Manual{get;set;}
    public String ER_watcher{get;set;}
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
    public string ER_FulFillmentManager{get; set;}
   public static final string MandatoryErrorMessage='Error: You must enter this value.';  
    public static final string MandatoryErrorMessage1='Error: Date should be greater than current date';
    public String RequestorEmployee{get;set;}
    public String currentManagerId{get;set;}
       

      
     public pagereference submitRequest(){
        Id userId;
        /*boolean flag=false;
        flag=doValidation();
        system.debug('**************ss'+listofDeatisl);
        if(flag == false){
            return null;
        }  */
        
        confrimsubmit=false;
        System.debug('*******Submit Request....'+RequestId );
        PR_Request__c rPP = [select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where id =: RequestId];
        
        if(rPP.Request_Type__c=='Standard'){
            
        
        if(approverid(rPP.Request_Type__c,rPP.Manager__c)!=null){
       // requestDeatils.Manager__c=approverid(requestDeatils.Request_Type__c,currentManagerId);
        userid=approverUserid(rpp.Request_Type__c,rPP.Manager__c);
        }
        }
        else
        {
            rpp.Manager__c=null;
            rpp.Escalate_to_Admin__c=true;
        }
        
        
        
        
        
        
        
        
        
        if(rPP != null && rPP.Manager__c!=null){
       // userId = rPP.Manager__c; 
        Approval.ProcessResult result = null;
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setObjectId(rPP.id); 
        //request.nextApproverIds = a;
        request.setNextApproverIds(new Id[] {userid});
        result  =   Approval.process(request); 
        }
        else
        {
             Approval.ProcessResult result = null;
             Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
             request.setObjectId(rPP.id); 
        //request.nextApproverIds = a;
             // request.setNextApproverIds(new Id[] {userid});
            result  =   Approval.process(request); 
       
        } 
        PageReference pr = new PageReference('/apex/pp_requesthome');
        pr.setRedirect(true);
        
        return pr;

        //pagereference a=new pagereference('/apex/PP_RequestPageNEW?id='+clickedRowId+'&tab='+selectedTab);
        //return a;
 }

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
    


public List<SelectOption> getFromBuildingPicklist() {
        List<SelectOption> options = new List<SelectOption>();
        //String Query='select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where';
        //options.add(new SelectOption('','---- Select ----'));
        options.add(new SelectOption('','Select...'));
        for(Building_Locations__c buildingFrom : buildingList ) {
            options.add(new SelectOption(buildingFrom.ID,buildingFrom.name));
        }
        return options;
    }



 public List<SelectOption> getToBuildingPicklist() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('','---- Select ----'));
        options.add(new SelectOption('','Select...'));
        options.add(new SelectOption('Charitable Donation','Charitable Donation'));
        options.add(new SelectOption('Disposal','Disposal'));
        options.add(new SelectOption('Home','Home'));
        options.add(new SelectOption('MS Data Center','MS Data Center'));
        options.add(new SelectOption('MS Office Building','MS Office Building'));
    
        options.add(new SelectOption('Other','Other'));    
        options.add(new SelectOption('Return to Vendor','Return to Vendor'));
       options.add(new SelectOption('Return to Hiring Agency','Return to Hiring Agency'));
        return options;
    }



public boolean advancesearchtrue{get;set;}





public pagereference advancedSearch(){
    
    advancesearchtrue=true;
    system.debug('*************inside advancedSearch'+strStatusAdvSearch ); 
    system.debug('*************inside advancedSearch'+strReqTypeAdvSearch ); 
    
    system.debug('*************inside strCreatedStartDtAdvSearch'+strCreatedStartDtAdvSearch); 
    system.debug('*************inside strCreatedEndAdvSearch '+strCreatedEndAdvSearch ); 
    
    system.debug('*************inside strRemovalStartDtAdvSearch '+strRemovalStartDtAdvSearch ); 
    system.debug('*************inside strRemovalEndDtAdvSearch '+strRemovalEndDtAdvSearch ); 
    
    system.debug('*************inside strFromBlndgAdvSearch '+strFromBlndgAdvSearch ); 
    system.debug('*************inside strToBlndgAdvSearch '+strToBlndgAdvSearch );            

    Datetime DtStart;
    Datetime DtEnd;
    date stDate;
    date etDate;
    errorMessage ='';

    //,Removal_Date__c,Property_Description__c,
    String Query='select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where';
    
    //Status
    strDisplayCategory = 'All';
    if(strStatusAdvSearch != null && strStatusAdvSearch != '' && strStatusAdvSearch != 'All' ){
         Query += ' Status__c  = \''+strStatusAdvSearch  +'\' '; 
          strDisplayCategory = strStatusAdvSearch  ;
          if(strStatusAdvSearch  =='Submitted'){
          strDisplayCategory = 'Pending Approval';

                    }
                    else if(strStatusAdvSearch  == 'Saved'){
                     strDisplayCategory =    'Draft';

                    }
         
    }
    //Request Type
    if(strReqTypeAdvSearch != null && strReqTypeAdvSearch != '' ){
        if(strStatusAdvSearch != 'All') {
             Query+=' AND Request_Type__c  = \''+strReqTypeAdvSearch+'\' ';
         }
         else {
             Query+=' Request_Type__c  = \''+strReqTypeAdvSearch+'\' ';
         }
    }
    
  
    
    if(strFromBlndgAdvSearch != null && strFromBlndgAdvSearch != '' ){
         Query+=' AND Location111__r.ID = \''+strFromBlndgAdvSearch +'\' ';
    }
    
    if(strToBlndgAdvSearch != null && strToBlndgAdvSearch != '' ){
         Query+=' AND Destination_Details__c = \''+strToBlndgAdvSearch +'\' ';
    }
    
    
     //advance search created date sanjib ghosh
    
     if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch.trim() != ''){
                system.debug('**********going inside'+startDateN);   
                stDate=date.parse(strCreatedStartDtAdvSearch);               
                DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
                system.debug('*********DtStart'+DtStart);             
                Query+='AND CreatedDate >=:DtStart ';
            }
            if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch.trim() != '' && strCreatedEndAdvSearch != null && strCreatedEndAdvSearch.trim() !='' ){
                etDate=date.parse(strCreatedEndAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' AND CreatedDate <:DtEnd ';
            } 
            if((strCreatedStartDtAdvSearch == null || strCreatedStartDtAdvSearch.trim() =='') && strCreatedEndAdvSearch != null && strCreatedEndAdvSearch.trim() !='' ){
                etDate=date.parse(strCreatedEndAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+='AND CreatedDate <:DtEnd ';
            } 
         
    
    //advance search for removal date
    
      if(strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch.trim() != ''){
                system.debug('**********going inside'+startDateN);   
                stDate=date.parse(strRemovalStartDtAdvSearch);               
                DtStart=Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
                system.debug('*********DtStart'+DtStart);             
                Query+='AND CreatedDate >=:DtStart ';
            }
            if(strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch.trim() != '' && strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch.trim() !='' ){
                etDate=date.parse(strRemovalEndDtAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+=' AND CreatedDate <:DtEnd ';
            } 
            if((strRemovalStartDtAdvSearch == null || strRemovalStartDtAdvSearch.trim() =='') && strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch.trim() !='' ){
                etDate=date.parse(strRemovalEndDtAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                system.debug('*********DtEnd'+DtEnd);
                Query+='AND CreatedDate <:DtEnd ';
            } 
         
    
   
    
      
 
     Query=Query+' AND CreatedById= \''+userinfo.getuserId()+'\'';
     Query=Query+' AND OwnerId=\''+userinfo.getuserId()+'\' ';
   
     Query+=' order by createdDate desc ';
     system.debug('*********AdvancedSearch Query'+Query);
     system.debug('*********AdvancedSearch strDisplayCategory '+strDisplayCategory );
     requestList=(List<PR_Request__c>)Database.Query(Query);
     ppRequestCount = requestList.size(); 
     if(requestList != null && !requestList.isEmpty()){
            TotalRequests = string.valueOf(requestList.size()); 
            system.debug('*********TotalRequests :advancedSearch'+TotalRequests );
            total_size=requestList.size();
        }
        else{
        TotalRequests = string.valueOf(0); 
            system.debug('*********TotalRequests :advancedSearch'+TotalRequests );
            total_size=0;
            
            }
       
    requestList  = getPageResults();
     return null;
    }

}