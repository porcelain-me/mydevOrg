@isTest                                                //dummy class
public class PP_RequestHomeController1{

    public String TotalRequests { get; set; }
    Public User u{get;set;}
    public list<PR_Request__c> requestList {get;set;}
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
    public string errorMessage1 {get; set;}
    public string errorMessage2 {get; set;}
    public string flagCheckStart {get; set;}
    public string flagCheckEnd {get; set;}
    public String RequestId {get;set;}
    public list<PR_Request__c> ppRequestTotalList {get;set;}
    public boolean ConfirmationWindow1{get;set;}
    public boolean isQuickSearch {get;set;}
    public String userEmail {get;set;}
    public String userID {get;set;}
    public String logedInEmpID {get;set;}

    // For Advance search
    public boolean isAdvancedSearch {get;set;}
    public boolean showNoDataFound {get;set;}
    public list<String> strUserBelongsToGrp{get;set;}
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
    public list<Building_Locations__c> buildingList{get;set;}
    public List<SelectOption> reqTypeList{get;set;}
    //Variables for understanding the logged in users permission
    
    public boolean isRequestor{get;set;}
    public boolean isWatcher{get;set;}
    public boolean isApprover{get;set;}
    public boolean isFloorSecurity{get;set;}
    
    private integer counter = 0;  //keeps track of the offset
    private integer list_size = 20; //sets the page size or number of rows
    public integer total_size ; //used to show user the total size of the list
    
    Public PP_RequestHomeController1(){

        requestList = new list<PR_Request__c>();
        list<PR_Request__c> dummyReqList = new list<PR_Request__c>();
        userEmail = '';
        TotalRequests = '0';
        total_size = 0;
        showNoDataFound = false;
        tabName = 'My Request';
        isdateEnabled = false;
        strDisplayCategory = 'All';
        viewReq = false;
        isAdvancedSearch = false;    
        isQuickSearch = false;    
        selectedTab='RequestHome';
        isApprover = false;
        isFloorSecurity = false;
 
        reqTypeList = new List<SelectOption>();
        reqTypeList.add(new SelectOption('All','All')); 
        reqTypeList.add(new SelectOption( PP_Util.STANDARD_REQUEST_TYPE, PP_Util.STANDARD_REQUEST_TYPE )); 
        reqTypeList.add(new SelectOption(PP_Util.EDC_REQUEST_TYPE, PP_Util.EDC_REQUEST_TYPE )); 
        reqTypeList.add(new SelectOption(PP_Util.PROPERTY_SERVICES_REQUEST_TYPE, PP_Util.PROPERTY_SERVICES_REQUEST_TYPE ));   
     
        selectedTab = ApexPages.Currentpage().getParameters().get('tab');
        buildingList = PP_Util.getInScopeBuildings();

        /*************** Junk Code**************
      
        //buildingList = [ select id,name,City_State__c,Address1__c,Address2__c,CITY_DESCRIPTION__c  
     //                    from Building_Locations__c where InScopeFrom__c = true limit 1000]; 
        //system.debug('Check the building List Size::'+buildingList.size());

        User me = [select email, Emp_ID__c from user where id=:userinfo.getUserId() limit 1];
        if( me != null )
        {
            userID = me.Emp_ID__c;
            userEmail = me.Email;
        }
        //userEmail = [select Emp_ID__c from user where id=:userinfo.getUserId() limit 1].Emp_ID__c;
        ***************/
        
        User me = PP_Util.getLoggedinUserRecord();
        userEmail = me.Email;
        //userID = me.Emp_ID__c;

        Employee__C loggedInEmp = PP_Util.getLoggedinEmployeeDetailsbyEmpID(me.Emp_ID__c);
        if(loggedInEmp != NULL){
            logedInEmpID = loggedInEmp.id;
        }    
        /****************************
        if(loggedInEmp != null && loggedInEmp.Officer__c =='Y') {
            isApprover = true;
        }  
        
        list<groupmember> userBelongsToGrp = new list<groupmember>();
        
        userBelongsToGrp = [  SELECT group.DeveloperName FROM  GroupMember WHERE UserOrGroupId =:userinfo.getuserid() AND Group.Type = 'Queue'];
        ****************/

        strUserBelongsToGrp = new list<String>();  
        for(groupmember C: PP_Util.getAllGrpsForUserForEdcORPropSrvcsReq() ){
            strUserBelongsToGrp.add(c.group.DeveloperName);
        } 
    
        if(PP_Util.isApproverForStandardReq(me.Emp_ID__c) || PP_Util.isApproverForEdcORPropSrvcsReq())  isApprover = true;
        
        system.debug('*************isApprover:'+isApprover );
        clearSearch();

    }
   
   Public void clearSearch () {  
    list<PR_Request__c> dummyReqList = new list<PR_Request__c>();
    strDisplayCategory = 'All';
    requestList.clear();
    isAdvancedSearch = false; 
    showNoDataFound = false; 
    TotalRequests = '0';
    total_size = 0;
    counter = 0;
       
    errorMessage1=null;
    errorMessage2=null;
    
    
    if(  isApprover ) { // For Approvers  
           system.debug('***isApprover:useremail::'+useremail);
            system.debug('***Employee_Requestee_Name__c =:'+logedInEmpID);
            system.debug('***Property_Service_Approver__c in : '+strUserBelongsToGrp);
            system.debug('***PCreatedById=:'+userinfo.getUserId());
           if(strUserBelongsToGrp != null && strUserBelongsToGrp.size() > 0 ) {
               
             dummyReqList = [ Select name,Employee_Requestee_Name__r.name,CreatedById, Employee_Requestor_Name__r.name,
                       Status__c,CreatedDate,Removal_Date__c,Request_Type__c,CC_WatchList__c,
                       Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c                       
                       from PR_Request__c 
                       where 
                       (Status__c='Submitted' AND (Manager_Email__c=:useremail OR Property_Service_Approver__c in : strUserBelongsToGrp)) OR
                       (CreatedById=:userinfo.getUserId() OR (Employee_Requestee_Name__c =:logedInEmpID ) OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                       or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                       or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                       or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) ) 
                       order by createdDate desc ]; 
                       system.debug('-----------------------------Query---------------'+dummyReqList);  
                       
        }                       
                       
        else {               
           dummyReqList = [select name,createdbyid,Estimated_Property_Value__c,Manager__r.name,Employee_Requestee_Name__r.name,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,PP_Vendor_Details__c,PP_Vendor_Details__r.name,Requestor_Region__c ,
                Employee_Requestor_Name__r.name,ClosedBy__r.name,ClosedDate__c,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Property_Service_Approver__c,
                Request_Type__c,Property_Owner__c,Other_Owners__c,Others__c,Location111__r.name,CC_WatchList__c,Approval_Rejection_Date__c ,
                Destination_Details__c,Destination__r.name,Removal_Purpose__c ,Expected_Return_Date__c ,Equipment_Receipt_Confirm__c,CC_WatcherNames__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.name  from PR_Request__c 
               
                       where 
                       //OR OwnerId=:userinfo.getUserId()
                       (Status__c='Submitted' AND Manager_Email__c=:useremail ) OR
                       (CreatedById=:userinfo.getUserId()  OR (Employee_Requestee_Name__c =:logedInEmpID )  OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                       or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                       or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                       or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) ) 
                       order by createdDate desc ]; 
                     system.debug('-----------------------------Query---------------'+dummyReqList);  
           }

       }        
       else if ( PP_Util.isSecurityAdmin() ){
           isFloorSecurity = true; // Floor Security
               dummyReqList = [ select name,createdbyid,Estimated_Property_Value__c,Manager__r.name,Employee_Requestee_Name__r.name,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,PP_Vendor_Details__c,PP_Vendor_Details__r.name,Requestor_Region__c ,
                Employee_Requestor_Name__r.name,ClosedBy__r.name,ClosedDate__c,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Property_Service_Approver__c,
                Request_Type__c,Property_Owner__c,Other_Owners__c,Others__c,Location111__r.name,CC_WatchList__c,Approval_Rejection_Date__c ,
                Destination_Details__c,Destination__r.name,Removal_Purpose__c ,Expected_Return_Date__c ,Equipment_Receipt_Confirm__c,CC_WatcherNames__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.name  from PR_Request__c 
                where
                       (status__c='Approved' AND IsPassGenerated__c=true)  OR 
                       //OR OwnerId=:userinfo.getUserId()
                       (CreatedById=:userinfo.getUserId()  OR (Employee_Requestee_Name__c =:logedInEmpID ) OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                       or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                       or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                       or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) ) 
                       order by createdDate desc ]; 
                       system.debug('-----------------------------Query---------------'+dummyReqList);  
       
       } else { // Normal User 
               dummyReqList = [ Select name,Employee_Requestee_Name__r.name,CreatedById, Employee_Requestor_Name__r.name,
                       Status__c,CreatedDate,Removal_Date__c,Request_Type__c,CC_WatchList__c,
                       Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c                       
                       from PR_Request__c 
                       where 
                       //OR OwnerId=:userinfo.getUserId()
                       (CreatedById=:userinfo.getUserId()  OR (Employee_Requestee_Name__c =:logedInEmpID ) OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                       or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                       or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                       or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) ) 
                       order by createdDate desc ]; 
                       system.debug('-----------------------------Query---------------'+dummyReqList);  
            }

       if(dummyReqList != null && !dummyReqList.isEmpty()){
           TotalRequests = string.valueOf(dummyReqList.size()); 
           total_size = dummyReqList.size();
           if(dummyReqList.size() > list_size){
               for(Integer i = 0; i< list_size;i++){
                   requestList.add(dummyReqList[i]);
               }
           }
           else {
               requestList = dummyReqList ;
           }
       }

   }
    
   /* THIS METHOD IS USED FOR PAGINATION */
   Private list<PR_Request__c> getPageResults() {

        requestList.clear();
        Datetime DtStart;
        Datetime DtEnd;
        
        date stDate;
        date etDate;
        errorMessage ='';
        errorMessage1 = '';
        errorMessage2 = '';
        Datetime removalStartDt;
        Datetime removalEndDt;
        date removalStartDate;
        date removalEndDate;
        list<PR_Request__c> pageRecords;
        list<PR_Request__c> DummypageRecords=new list<PR_Request__c>();
         String subQ = '';
        String Query='select name,CreatedById ,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Request_Type__c from PR_Request__c where';
        //system.debug('*********isAdvancedSearch::'+isAdvancedSearch);

       if( isAdvancedSearch){
           if(strStatusAdvSearch != null && strStatusAdvSearch != '' && strStatusAdvSearch != 'All' ){
               Query += ' Status__c  = \''+strStatusAdvSearch  +'\' AND '; 
           }
            
            if(strReqTypeAdvSearch != null && strReqTypeAdvSearch != '' && strReqTypeAdvSearch != 'All'){
                Query+=' Request_Type__c  = \''+strReqTypeAdvSearch+'\' AND ';
            }
            if(strInputSearch!=null && strInputSearch!='' && strInputSearch != 'Search ID'){
                  Query += ' Name  like \'%'+strInputSearch+'%\' AND ';
            }
            if(strFromBlndgAdvSearch != null && strFromBlndgAdvSearch != '' && strFromBlndgAdvSearch != 'Select' ){
                Query+=' Location111__r.ID = \''+strFromBlndgAdvSearch +'\' AND';
            }
            
            if(strToBlndgAdvSearch != null && strToBlndgAdvSearch != '' && strToBlndgAdvSearch != 'Select' ){
                 Query+=' Destination_Details__c = \''+strToBlndgAdvSearch +'\' AND';
            }
            if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch.trim() != '' && strCreatedStartDtAdvSearch != 'From'){
                stDate = date.parse(strCreatedStartDtAdvSearch);               
                DtStart = Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
                Query += ' CreatedDate >=:DtStart  AND';
            }
            if(strCreatedEndAdvSearch != null && strCreatedEndAdvSearch.trim() !='' && strCreatedEndAdvSearch != 'To'){
                etDate=date.parse(strCreatedEndAdvSearch); 
                DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
                DtEnd=DtEnd.adddays(1);
                Query+=' CreatedDate <:DtEnd AND';
            }
                                     
               //advance search for removal date
        if(strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch.trim() != '' && strRemovalStartDtAdvSearch != 'From'){
            removalStartDate =date.parse(strRemovalStartDtAdvSearch);               
            Query+=' Removal_Date__c >=:removalStartDate AND';
        }
        if(strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch.trim() !='' && strRemovalEndDtAdvSearch != 'To'){
            removalEndDate =date.parse(strRemovalEndDtAdvSearch); 
            removalEndDate = removalEndDate.adddays(1);
            Query+=' Removal_Date__c <:removalEndDate AND';
        } 
       
    
            Query += ' (';
            if( isApprover) {
                Query += ' (';
                if(strUserBelongsToGrp != null && strUserBelongsToGrp.size() > 0 ) {
                    //Query += ' Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' OR Property_Service_Approver__c in \''+strUserBelongsToGrp+'\' )  ';
                    for(String usrGrpName: strUserBelongsToGrp){
                        subQ += 'OR Property_Service_Approver__c = \''+usrGrpName+'\'';
                    }
                    Query += ' Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' ';
                    Query += subQ + ')'; 
                    //Query += ' Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' OR Property_Service_Approver__c in \''+strUserBelongsToGrp+'\' )  ';
                }
                else {
                     Query += ' Status__c=\'Submitted\' AND  Manager_Email__c= \''+useremail +'\' '; 
                }
                Query += ') OR ';
            }        
            else if ( isFloorSecurity ) {
                Query += ' (';
                Query += ' Status__c=\'Approved\' AND IsPassGenerated__c = true ';
                Query += ') OR ';
            }
     
            Query += ' (CreatedById= \''+userinfo.getuserId()+'\'  OR Employee_Requestee_Name__c =\''+logedInEmpID+'\' or Watcher1__c=\''+useremail+'\' or Watcher2__c=\''+useremail+'\' or Watcher3__c=\''+useremail+'\' or Watcher4__c=\''+useremail+'\' or Watcher5__c=\''+useremail+'\' or Watcher6__c=\''+useremail+'\' or Watcher7__c=\''+useremail+'\' or Watcher8__c=\''+useremail+'\' or Watcher9__c=\''+useremail+'\' or Watcher10__c=\''+useremail+'\' )) ';
    
        }//isAdvancedSearch
        else 
        {
            if(isApprover){
                if(strUserBelongsToGrp != null && strUserBelongsToGrp.size() > 0 ) {
                    //Query += '(Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' OR Property_Service_Approver__c in \''+strUserBelongsToGrp+'\' )) OR';
//                    Query += '(Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' OR Property_Service_Approver__c in \''+strUserBelongsToGrp+'\' )) OR';
                      for(String usrGrpName: strUserBelongsToGrp){
                        subQ += 'OR Property_Service_Approver__c = \''+usrGrpName+'\'';
                    }
                    Query += ' (Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' ';
                    Query += subQ + ')) OR '; 

                }
                else {
                     Query += '(Status__c=\'Submitted\' AND  Manager_Email__c= \''+useremail +'\') OR'; 
                }
            }
            else if (isFloorSecurity) {
                 Query+=' (Status__c =\'Approved\' AND  IsPassGenerated__c = true ) OR';
            }
            Query += ' (CreatedById= \''+userinfo.getuserId()+'\' OR Employee_Requestee_Name__c =\''+logedInEmpID+'\' or Watcher1__c=\''+useremail+'\' or Watcher2__c=\''+useremail+'\' or Watcher3__c=\''+useremail+'\' or Watcher4__c=\''+useremail+'\' or Watcher5__c=\''+useremail+'\' or Watcher6__c=\''+useremail+'\' or Watcher7__c=\''+useremail+'\' or Watcher8__c=\''+useremail+'\' or Watcher9__c=\''+useremail+'\' or Watcher10__c=\''+useremail+'\' ) ';
        }

        //system.debug('*********GetPagination Query'+Query);
        Query +=' order by createdDate desc ';
        Query +=' limit ' + list_size + '  offset ' + counter + '';
        system.debug('*********FinalQuery1:'+Query);
        pageRecords = (List<PR_Request__c>)Database.Query(Query);            
        
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
        requestList =  getPageResults();
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

   
    public List<SelectOption> getSearchParams() {
        List<SelectOption> options = new List<SelectOption>();
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

    Public pageReference findDateField() {
        //system.debug('****************strSearchReq:'+strSearchReq); 
        if(strSearchReq == 'CreatedDate' || strSearchReq == 'Removal_Date__c'){
            isdateEnabled=true;
            startDate=system.today();
            endDate=system.today().adddays(1);
            flagCheckStart ='not loaded';
            flagCheckEnd ='not loaded';
        }
        else {
            isdateEnabled=false;
            startDate=null;
            endDate=null;
        }
        errormessage='';
        return null;
    }


    //recall request confirm window and logic
    Public pagereference recallrequestconfirm() {
        PR_Request__c chkStatus = [ Select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,
                               Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c 
                               from PR_Request__c where id =: RequestId ];
        if(chkStatus.Status__c == 'Approved' || chkStatus.Status__C == 'Rejected')
        {
        pagereference p=new pagereference('/apex/PP_CreateRequest?id='+RequestId+'&tab=MyRequest');
        p.setRedirect(true);
        return p;
        }  
        else
        {
        ConfirmationWindow1 = true;
        return null;
        }
    }
    
    Public pagereference recallRequest() {
    
        
                            
        recallfromapproval(RequestId);
        ConfirmationWindow1 = false;
    
        
        PR_Request__c rPP1 = [ Select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,
                               Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c 
                               from PR_Request__c where id =: RequestId];
    
        rPP1.Status__c='Recalled';
        update rPP1;
        pagereference p=new pagereference('/apex/PP_CreateRequest?id='+RequestId+'&tab=MyRequest');
        p.setRedirect(true);
        return p;
         
    }
    
    Private void recallfromapproval(String Id) {
    
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
    
    Public pagereference RequestNoConfirmation() {
        ConfirmationWindow1=false;
        cancelConfrm=false;
        return null;
    }
 
    Public pagereference requestnosubmit() {
        confrimsubmit=false;
        return null;
    }
  
  
  Public pageReference searchOpenReqs(){
    return null;
    }

 
    /**************** QUICK SEARCH FEATURE IS DESCOPED FROM UI; HENCE COMMENTING THE CODE, IN FUTURE IF THIS IS NEEDED, PLEASE MAP THIS LOGIC WITH ADVANCE SEARCH ******************
    Public pageReference quickSearch(){
        if(strSearchReq == null ){
             errorMessage='You must select search criteria';
             return null;
        }
        else if(strSearchReq != null && strSearchReq != 'CreatedDate' && strSearchReq != 'Removal_Date__c'){
            if(strInputSearch == null || strInputSearch == '' ){
                errorMessage='You must enter some value';
                return null;
            }
            else if(strInputSearch != null ){
                strInputSearch = strInputSearch.trim();
                if(strInputSearch.length() < 3) {
                    errorMessage='Please enter a minimum of 3 characters.';
                    return null;
                }
            }
        }
    
        list<PR_Request__c> dummyReqList = new list<PR_Request__c>();
        List<string> dateComponents;
        Datetime DtStart;
        Datetime DtEnd;
        date stDate;
        date etDate;
        errorMessage ='';
        isQuickSearch = true;
        isAdvancedSearch = false;
      
        String Query='select name,CreatedById,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c from PR_Request__c where';
        strInputSearch=strInputSearch.trim();
    
        if(strSearchReq == 'Name'){
            Query += ' Name  like \'%'+strInputSearch+'%\' ';
        } else if(strSearchReq == 'Employee_Requestor_Name__r.name'){
            Query+=' Employee_Requestee_Name__r.name like \'%'+strInputSearch+'%\' ';
        }  else if(strSearchReq == 'Request_Type__c'){
            Query+=' Request_Type__c like \'%'+strInputSearch+'%\' ';
        } else if(strSearchReq == 'Location111__r.name'){
            Query+=' Location111__r.name like \'%'+strInputSearch+'%\' ';
        } else if(strSearchReq == 'Status__c'){
            String strInputSearchlCase = strInputSearch.toLowerCase();
            if(('approv').contains(strInputSearchlCase )){
                Query+='( Status__c =\'Submitted\' or Status__c =\'Approved\')';
            }
            else if('pending approval'.contains(strInputSearchlCase )){
                Query+=' Status__c =\'Submitted\'';
            }
            else if('in draft'.contains(strInputSearchlCase )){
                Query+=' (Status__c =\'Saved\' OR Status__c =\'Recalled\') ';
            }
            else if('approved'.contains(strInputSearchlCase )){
                Query+=' Status__c =\'Approved\'';
            }
            else if('closed'.contains(strInputSearchlCase )){
                Query+=' Status__c =\'Closed\'';
            }
            else if('cancelled'.contains(strInputSearchlCase )){
                Query+=' Status__c =\'Cancelled\'';
            }
            else if('rejected'.contains(strInputSearchlCase )){
                Query+=' Status__c =\'Rejected\'';
            }
            else {
                Query+=' Status__c like \'%'+strInputSearch+'%\' ';
            }
        }
        else if(strSearchReq == 'CreatedDate'){
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
                errorMessage='You must input Created dates.';
                return null;
            }
            if(startDateN != null && startDateN.trim() != '' && endDateN != null && endDateN.trim() != '')
                {
                    if(startDateN > endDateN){
                        errorMessage = 'The start date must be before the end date. Please select a valid date.';
                        startDateN = null;
                        endDateN = null; 
                        flagCheckStart ='not loaded';
                        flagCheckEnd ='not loaded';
                        return null;
                    }
               }  
              
        }
        else if(strSearchReq == 'Removal_Date__c'){
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
                errorMessage='You must input Removal dates';
                return null;
            }  
            if(startDateN != null && startDateN.trim() != '' && endDateN != null && endDateN.trim() != '')
            {
                if (startDateN > endDateN) {
                errorMessage = 'The start date must be before the end date. Please select a valid date.';
                startDateN = null;
                endDateN = null;
                flagCheckStart ='not loaded';
                flagCheckEnd ='not loaded';
                return null;
                }
            }
        }
    
        Query += ' AND (CreatedById= \''+userinfo.getUserId()+'\' OR OwnerId= \''+userinfo.getUserId()+'\' or Watcher1__c=\''+useremail+'\' or Watcher2__c=\''+useremail+'\' or Watcher3__c=\''+useremail+'\' or Watcher4__c=\''+useremail+'\' or Watcher5__c=\''+useremail+'\' or Watcher6__c=\''+useremail+'\' or Watcher7__c=\''+useremail+'\' or Watcher8__c=\''+useremail+'\' or Watcher9__c=\''+useremail+'\' or Watcher10__c=\''+useremail+'\' ) ';
        Query += ' order by createdDate desc ';
        //system.debug('*********FinalQuery QuickSearch:'+Query);
        dummyReqList = (List<PR_Request__c>)Database.Query(Query);            
        //system.debug('*********FinalSearchrequestList'+requestList);
        requestList.clear();
        if(dummyReqList != null && !dummyReqList.isEmpty()){
    
            TotalRequests = string.valueOf(dummyReqList.size()); 
            total_size = dummyReqList.size();
            if(dummyReqList.size() > list_size){
                   for(Integer i = 0; i< list_size;i++){
                       requestList.add(dummyReqList[i]);
                   }
               }
               else {
                   requestList = dummyReqList ;
               }
        }
        else {
            TotalRequests = '0';
            total_size = 0;
        }
        return null; 
    }
    ******************END QUICK SEARCH************************/

    public boolean confrimsubmit{get;set;}
    public boolean ConfirmationWindow{get;set;}
    public String ReqIdToClose{get;set;}
    
    public pagereference confirmclose(){
        ConfirmationWindow=true;
        return null;
    }
    

    public pagereference closewindow4(){
        showValidation=false;
    return null;
    }


 public pagereference submitconfirm(){
 
   boolean cond1=false;
   boolean cond2=false;
   boolean cond3=false;
   boolean cond4=false;
   boolean cond5=false;
   boolean cond6=false;
   boolean cond7=false;
   boolean cond8=false;
   boolean cond9=false;
   boolean cond10=false;
    boolean cond11=false;
    boolean cond12=false;
         
     PR_Request__c rPP = [select name,createdbyid,Manager__r.name,Employee_Requestee_Name__r.name,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,PP_Vendor_Details__c,PP_Vendor_Details__r.name,Requestor_Region__c ,
                Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Property_Service_Approver__c,
                Request_Type__c,Property_Owner__c,Other_Owners__c,Others__c,Location111__r.name,CC_WatchList__c,Approval_Rejection_Date__c ,
                Destination_Details__c,Destination__r.name,Removal_Purpose__c ,Expected_Return_Date__c ,Equipment_Receipt_Confirm__c,CC_WatcherNames__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.name  from PR_Request__c 
                where id =: RequestId];
                
     List<property_Detail__c> ProdDetailslist = new List<property_Detail__c> ();
     ProdDetailslist=[select id,name,Property_Name__c,Description__c,Quantity__c,Boxes__c,Items__c,Pallets__c,UOM__c,Serial_No__c, Asset_Tag__c from property_Detail__c where request_details__c=: RequestId and Asset_Tag__c=null and Serial_No__c=null];
     //End Balakumar
     
     //property_Detail__c ProdDetailslist2=[select id,name,Property_Name__c,Description__c,Quantity__c,Boxes__c,Items__c,Pallets__c,UOM__c,Serial_No__c, Asset_Tag__c from property_Detail__c where request_details__c=: RequestId and Asset_Tag__c=null and Serial_No__c=null];
     system.debug('---------------ProdDetailsList------------'+ProdDetailslist.size());
     //system.debug('-----------ProdDetailslist.Description__c-------'+ProdDetailslist.Description__c);  
      
     
      if(rPP.Property_Owner__c == null || rPP.Property_Owner__c.trim() == '' ||  rPP.Removal_Date__c==null 
           || rPP.Location111__c == null || rPP.Destination_Details__c == null || rPP.Destination_Details__c.trim() == '' ||
     rPP.Removal_Purpose__c == null || rPP.Removal_Purpose__c.trim() == '' || rPP.Removal_Purpose__c.trim() == 'Enter business purpose')
        {
            cond1=true;
        }
        
       else if((rPP.Property_Owner__c == 'Other'&& rPP.Other_Owners__c==null)||(rPP.Property_Owner__c == 'Former Employee or Contractor'&& rPP.Other_Owners__c==null))
       {
        cond2=true;
        }
       else if(rPP.Removal_Type__c=='Temporary' && rPP.Expected_Return_Date__c==null)
       {
       system.debug('---------Inside Temporaray---------------');
        cond3=true;
        }
        else if((rPP.Destination_Details__c=='Charitable Donation' && rPP.Others__c==null)||(rPP.Destination_Details__c=='Disposal' && rPP.Others__c==null)||(rPP.Destination_Details__c=='Hiring Agency' && rPP.Others__c==null)|| (rPP.Destination_Details__c=='Other' && rPP.Others__c==null))
       {
       
        cond4=true;
        }
        else if((rPP.Destination_Details__c=='MS Data Center' && rPP.Destination__c ==null)||(rPP.Destination_Details__c=='MS Office Building ' && rPP.Destination__c ==null))
       {
       
       cond5=true; 
        }
        else if(rPP.Destination_Details__c=='Vendor' && rPP.PP_Vendor_Details__c==null)
       {
       
       cond6=true;
        
        }
        
        
        
        
        if(ProdDetailslist==null || ProdDetailslist.size()<=0){
               cond10=true;

        }
        
        //Added by Balakumar
        if(ProdDetailslist!= null && ProdDetailslist.size() > 0)
        {
        for(property_Detail__c ProdDetailslist1 : ProdDetailslist)
        {
            system.debug('--------------'+ProdDetailslist1.Property_Name__c);
            system.debug('--------------'+ProdDetailslist1.Description__c );
            system.debug('--------------'+ProdDetailslist1.Items__c );
            if (ProdDetailslist1.Property_Name__c == null || ProdDetailslist1.Property_Name__c.trim() == '' ) 
                 {
                 
                  cond7=true;
                }
               
                
                
                
                if (ProdDetailslist1.Description__c == null || ProdDetailslist1.Description__c.trim() == '')
                 {
                 
                  cond8=true;
                }
                if  ((ProdDetailslist1.Items__c == null || ProdDetailslist1.Items__c == '' || ProdDetailslist1.Items__c == '0')
                                     && (ProdDetailslist1.Boxes__c == null || ProdDetailslist1.Boxes__c == '' || ProdDetailslist1.Boxes__c == '0')
                                     && (ProdDetailslist1.Pallets__c == null || ProdDetailslist1.Pallets__c == '' || ProdDetailslist1.Pallets__c == '0')) 
                {
                
                cond9=true;
                }
                
                // Checks for: A Requestor cannot also be an Approver on a request. Please select an Alternate Approver.
                if(rPP.Manager__r != NULL && rPP.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE && rPP.Manager__c == logedInEmpID ) {
                    cond12 = true;  
                }
                //Checks for: A Delegate cannot also be an Approver on a request. Please select an Alternate Approver or remove the Delegate.
                if(rPP.Manager__r.name != NULL && rPP.Request_Type__c == PP_Util.STANDARD_REQUEST_TYPE && rPP.CC_WatcherNames__c != NULL) {
                    String wNames = rPP.CC_WatcherNames__c;
                    if(wNames.contains(rPP.Manager__r.name)){
                        cond11 = true;  
                    }
                }

         }
        }  
        if(cond1 || cond2 || cond3 || cond4 || cond5 || cond6 || cond7 || cond8 || cond9 || cond10 || cond11 || cond12 ){
            showValidation=true;
            confrimsubmit=false;
        }
        else
        {
            showValidation=false;
            confrimsubmit=true;
        }      
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
    Public pagereference closeRequest(){
        ConfirmationWindow=false;
        system.debug('the placeholder'+ReqIdToClose);
        //private methodProperty_Description__c,
        PR_Request__c a=[select name,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                        Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                        Removal_Purpose__c  from PR_Request__c where id=:ReqIdToClose];
                        
        if(a!=null){
            a.Status__c='Closed';
            a.ClosedBy__c=userinfo.getUserId();
            a.ClosedDate__c=system.now();
        }
 
        update a;
        
        
        Integer i=0;
        for(PR_request__c b :requestlist)
        {
         //system.debug('-------ReqIdToClose--------'+ReqIdToClose);
         //system.debug('--------b id--------'+b.id);   
            if(b.id == ReqIdToClose)
            {
                break;
                
            }
            i++;
        }        
         
        requestlist.remove(i);
               
        //PageReference pr = new PageReference('/apex/PP_RequestHome?tab=MyRequest');        
        //pr.setRedirect(true);
        //return pr;
        return null;
        
        
    }
    private void LoadData() {
       PR_Request__c b = [select name,Employee_Requestee_Name__r.name,EDC_CloseOut_Approver__c,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
                        Request_Type__c,Property_Owner__c,Location111__c,Destination_Details__c,
                        Removal_Purpose__c  from PR_Request__c where Status__c='Approved'];
   }
   

    Public pagereference ViewRequest(){
        //system.debug('the placeholder'+IdPlaceHolder);
        system.debug('the ReqID'+ReqID);
         PageReference pr = new PageReference('/apex/PP_CreateRequest?id='+ReqID);
         pr.setRedirect(true);
         return null;
    }


public pagereference clear(){
    isAdvancedSearch = false;
    isQuickSearch = false;
    
    PageReference pr = new PageReference('/apex/PP_RequestHome');
    pr.setRedirect(true);
    return pr;
}

public pagereference NewRequest(){
       PageReference pr = new PageReference('/apex/PP_createRequest?tab=NewRequest');
    pr.setRedirect(true);
    return pr;
}

    Public String getSelectedTabName(){
        //System.debug('*************************************getSelectedTabName()****selectedTab :'+selectedTab );
        if(selectedTab =='MyRequest')
            tabName = 'My Requests';
        else if(selectedTab =='Admin')
            tabName = 'Admin';
        else
            tabName = 'New Requests';
         return tabName;
    }
    

    public string clickedRowId{get;set;}
 
    Public pagereference readCellMethod(){
        pagereference a=new pagereference('/apex/PP_CreateRequest?id='+clickedRowId+'&tab='+selectedTab);
        return a;
    }
 
    public boolean showValidation{get;set;}

    Public pagereference submitRequest(){
        Id userId;
        confrimsubmit=false;
        //System.debug('*******Submit Request....'+RequestId );
        PR_Request__c rPP = [select name,createdbyid,Manager__r.name,Employee_Requestee_Name__r.name,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,PP_Vendor_Details__c,PP_Vendor_Details__r.name,Requestor_Region__c ,
                Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Property_Service_Approver__c,
                Request_Type__c,Property_Owner__c,Other_Owners__c,Others__c,Location111__r.name,CC_WatchList__c,Approval_Rejection_Date__c ,
                Destination_Details__c,Destination__r.name,Removal_Purpose__c ,Expected_Return_Date__c ,Equipment_Receipt_Confirm__c,CC_WatcherNames__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.name  from PR_Request__c 
                where id =: RequestId];
        
        //if(rPP != null && rPP.Request_Type__c=='Standard (MS Office)'){
        if(rPP != null && rPP.Request_Type__c=='MS Office (Most common)'){
            if(approverid(rPP.Request_Type__c,rPP.Manager__c)!=null){
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
        PageReference pr = new PageReference('/apex/PP_RequestHome');
        pr.setRedirect(true);
        
        return pr;
    }

 Private id approverid(String a,String b){
        system.debug('test sanjib'+b);
        List<employee__C> empList;
        id deligatedApprover;
        
        //if(a=='Standard (MS Office)'){
        if(a=='MS Office (Most common)'){
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
        
        if(a=='Standard (MS Office)'){
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
    


    Public List<SelectOption> getFromBuildingPicklist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select...'));
        for(Building_Locations__c buildingFrom : buildingList ) {
            options.add(new SelectOption(buildingFrom.ID,buildingFrom.name));
        }
        return options;
    }



    Public List<SelectOption> getToBuildingPicklist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select...'));
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



    /* THIS METHOD IS USED FOR ADVANCED SEARCH*/
    Public pagereference advancedSearch() {
    
        Datetime DtStart;
        Datetime DtEnd;
        Datetime DtStart1;
        Datetime DtEnd1;
        date stDate;
        date etDate;
        
        //Datetime removalStartDt;
        //Datetime removalEndDt;
        date removalStartDate;
        date removalEndDate;
        
        errorMessage ='';
        errorMessage1 ='';
        errorMessage2 ='';
        isQuickSearch = false;
        isAdvancedSearch = true; 
        strDisplayCategory='Search Results'; 
        showNoDataFound = false;  
        requestList.clear();
        list<PR_Request__c> dummyReqList = new list<PR_Request__c>();
        TotalRequests = string.valueOf(0); 
        total_size = 0;
        
        boolean first=false;
        boolean second=false;
        
        String subQ = '';
            
        String Query='select name,CreatedById ,Watcher1__c ,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Request_Type__c from PR_Request__c where';

        if(strStatusAdvSearch != null && strStatusAdvSearch != '' && strStatusAdvSearch != 'All' ){
            Query += ' Status__c  = \''+strStatusAdvSearch  +'\' AND '; 
        }
        
        if(strReqTypeAdvSearch != null && strReqTypeAdvSearch != '' && strReqTypeAdvSearch != 'All'){
            Query+=' Request_Type__c  = \''+strReqTypeAdvSearch+'\' AND ';
        }
        if(strInputSearch!=null && strInputSearch!='' && strInputSearch != 'Search ID'){
              strInputSearch = String.escapeSingleQuotes(strInputSearch);
              Query += ' Name  like \'%'+strInputSearch+'%\' AND ';
        }
        if(strFromBlndgAdvSearch != null && strFromBlndgAdvSearch != '' && strFromBlndgAdvSearch != 'Select' ){
            Query+=' Location111__r.ID = \''+strFromBlndgAdvSearch +'\' AND';
        }
        
        if(strToBlndgAdvSearch != null && strToBlndgAdvSearch != '' && strToBlndgAdvSearch != 'Select' ){
             Query+=' Destination_Details__c = \''+strToBlndgAdvSearch +'\' AND';
        }
        if(strCreatedStartDtAdvSearch != null && strCreatedStartDtAdvSearch.trim() != '' && strCreatedStartDtAdvSearch != 'From'){
            stDate = date.parse(strCreatedStartDtAdvSearch);               
            DtStart = Datetime.newInstanceGMT(stDate.year(),stDate.month(),stDate.day());
            system.debug('--------------DtStart----------------'+DtStart);
            Query += ' CreatedDate >=:DtStart  AND';
        }
         
        if(strCreatedEndAdvSearch != null && strCreatedEndAdvSearch.trim() !='' && strCreatedEndAdvSearch != 'To'){
            etDate=date.parse(strCreatedEndAdvSearch); 
            DtEnd=Datetime.newInstanceGMT(etDate.year(),etDate.month(),etDate.day());
            system.debug('--------------DtEnd----------------'+DtEnd);
            DtEnd=DtEnd.adddays(1);
            system.debug('--------------DtEnd----------------'+DtEnd);
            //system.debug('*********DtEnd'+DtEnd);
            Query+=' CreatedDate <:DtEnd AND';
        } 
        if(strCreatedStartDtAdvSearch!= null && strCreatedStartDtAdvSearch.trim() != '' && strCreatedStartDtAdvSearch != 'From' && strCreatedEndAdvSearch!= null && strCreatedEndAdvSearch.trim() != '' && strCreatedEndAdvSearch != 'To')
        {
            if (DtStart.getTime()> (DtEnd.getTime()-1)) {
            system.debug('--------------DtStart----------------'+DtStart);
            system.debug('--------------DtStart----------------'+DtStart.getTime());
             system.debug('--------------DtStart----------------'+DtEnd);
            system.debug('--------------DtStart----------------'+DtEnd.getTime());
            //errorMessage1='End Date cannot be greater than Start Date';
            errorMessage1 = 'The start date must be before the end date. Please select a valid date.';
            strCreatedStartDtAdvSearch = null;
           strCreatedEndAdvSearch= null;
            flagCheckStart ='not loaded';
            flagCheckEnd ='not loaded';
            
            //return null;
            first = true;
            }
        }
        //advance search for removal date
        if(strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch.trim() != '' && strRemovalStartDtAdvSearch != 'From'){
            removalStartDate =date.parse(strRemovalStartDtAdvSearch);               
            Query+=' Removal_Date__c >=:removalStartDate AND';
        }
        if(strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch.trim() !='' && strRemovalEndDtAdvSearch != 'To'){
            removalEndDate =date.parse(strRemovalEndDtAdvSearch); 
            removalEndDate = removalEndDate.adddays(1);
            Query+=' Removal_Date__c <:removalEndDate AND';
        } 
        if((strRemovalStartDtAdvSearch != null && strRemovalStartDtAdvSearch.trim() != '' && strRemovalStartDtAdvSearch != 'From') && (strRemovalEndDtAdvSearch != null && strRemovalEndDtAdvSearch.trim() != '' && strRemovalEndDtAdvSearch != 'To'))
        {
         
            if (removalStartDate > (removalEndDate-1) ) {
            
            system.debug('--------------DtStart----------------'+removalStartDate);           
             system.debug('--------------DtStart----------------'+removalEndDate);
            
            
                errorMessage2 = 'The start date must be before the end date. Please select a valid date.';
                strRemovalStartDtAdvSearch = null;
                strRemovalEndDtAdvSearch = null;
                flagCheckStart ='not loaded';
                flagCheckEnd ='not loaded';
                
                //return null;
                second=true;            
            }
        }
        
        system.debug('----------------First-----------------'+first);
        system.debug('----------------Second-----------------'+second);
        if(  first == true  ||  second == true){
            system.debug('----------------Enter Inside-----------------');
            return null;
        }
        
        Query += ' (';
        if( isApprover) {
            Query += ' (';
            if(strUserBelongsToGrp != null && strUserBelongsToGrp.size() > 0 ) {
                //Query += ' Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' OR Property_Service_Approver__c in \''+strUserBelongsToGrp+'\' )  ';              
                //Query += ' Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' OR Property_Service_Approver__c = \''+strUserBelongsToGrp+'\')  ';
            
                for(String usrGrpName: strUserBelongsToGrp){
                    subQ += 'OR Property_Service_Approver__c = \''+usrGrpName+'\'';
                }
                Query += ' Status__c=\'Submitted\' AND  (Manager_Email__c = \''+useremail +'\' ';
                Query += subQ + ')'; 

            }
            else {
                 Query += ' Status__c=\'Submitted\' AND  Manager_Email__c= \''+useremail +'\' '; 
            }
            Query += ') OR ';
        }        
        else if ( isFloorSecurity ) {
            Query += ' (';
            Query += ' Status__c=\'Approved\' AND IsPassGenerated__c = true ';
            Query += ') OR ';
        }
 
        Query += ' (CreatedById= \''+userinfo.getuserId()+'\'  OR Employee_Requestee_Name__c =\''+logedInEmpID+'\' or Watcher1__c=\''+useremail+'\' or Watcher2__c=\''+useremail+'\' or Watcher3__c=\''+useremail+'\' or Watcher4__c=\''+useremail+'\' or Watcher5__c=\''+useremail+'\' or Watcher6__c=\''+useremail+'\' or Watcher7__c=\''+useremail+'\' or Watcher8__c=\''+useremail+'\' or Watcher9__c=\''+useremail+'\' or Watcher10__c=\''+useremail+'\' )) ';
        Query+=' order by createdDate desc ';

        system.debug('*********AdvancedSearch Query'+Query);

        dummyReqList = (List<PR_Request__c>)Database.Query(Query);
        if(dummyReqList != null && !dummyReqList.isEmpty()){
            TotalRequests = string.valueOf(dummyReqList.size()); 
            total_size = dummyReqList.size();
            if(dummyReqList.size() > list_size){
               for(Integer i = 0; i < list_size;i++){
                   requestList.add(dummyReqList[i]);
               }
           }
           else {
               requestList = dummyReqList ;
           }
        }
        else {
           
            showNoDataFound = true;
            
        }
        return null;
    }
    
}