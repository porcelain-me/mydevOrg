public class PPR_NewRequestTest{
 
 //public String TotalApprovals { get; set; }
 //Public list<property_Detail__c> ProdDetailslist{get;set;}
 //Public property_Detail__c ProdDetails{get;set;}
 //Public List<Employee__c> ApproverList{get;set;}   
 //public PR_Request__c requestDeatils{get;set;}
 //public list<PR_Request__c> PendingApproverlList{get;set;}
 //public String IdPlaceHolder{get;set;}
 //public string flagCheck {get; set;}
 //public boolean IsApprover{get;set;} 
    public PR_Request__c requestDeatils{get;set;}
    public boolean ConfirmationWindow1{get;set;}
    public boolean cancelConfrm{get;set;}
    
    
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
     public string strStatus {get; set;}
 
    Public PPR_NewRequestTest(){
   //group population
   ConfirmationWindow1=false;
   cancelConfrm=false;
   
    requestList=new list<PR_Request__c>();
    list<PR_Request__c> dummyReqList=new list<PR_Request__c>();
    TotalRequests='0';
    tabName = 'My Request';
    isdateEnabled =false;

    selectedTab = ApexPages.Currentpage().getParameters().get('tab');
    System.debug('*************************************PPR_NewRequestTest()****selectedTab :'+selectedTab );
    viewReq = false;
   
    String useremail = [select email from user where id=:userinfo.getUserId()].email;
    
    //MyRequest Tab
    if(selectedTab =='Myrequest' || selectedTab == null){
        // Property_Description__c,Removal_Type__c,
        requestList = [Select name,Employee_Requestee_Name__r.name,CreatedById, Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Date__c,
                        Request_Type__c,CC_WatchList__c from PR_Request__c 
                        where  Status__c in ('Saved', 'Submitted','Approved','Recalled','Pending Checked-in' ) 
                        and (CreatedById=:userinfo.getUserId() OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                        or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                        or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                        or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) )    order by createdDate desc ]; 
        selectedTab = 'Myrequest';
    }
    
    //Get My History requeuest  Property_Description__c,
    else if(selectedTab =='MyHistory'){          
        requestList =[select name,Employee_Requestee_Name__r.name,CC_WatchList__c,CreatedById,
        Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,
        Request_Type__c from PR_Request__c where  
        Status__c in ('Rejected', 'Closed', 'Collected','Cancelled') 
        
        and (CreatedById=:userinfo.getUserId() OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                        or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                        or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                        or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) ) 
        
        
         order by createdDate desc]; 
        
              
    }
    
    //Get Closed Request..,this logic need to be changed
    //,Removal_Date__cProperty_Description__c
    else if(selectedTab =='MyclosedRequest'){ 
    //,'Pending Checked-in'  
        requestList =[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,EDC_CloseOut_Approver__c,EDC_CloseOut_Approver__r.user__c,
                     CreatedDate,Removal_Type__c,CC_WatchList__c,CreatedById,
                     Request_Type__c,Location111__r.name
                     from PR_Request__c where  
                     Status__c in ('Approved') 
                     
                     and (CreatedById=:userinfo.getUserId() OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                        or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                        or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                        or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) ) 
                        
                     and IsPassGenerated__c=true   
                     
                     
                     
                     
                      order by createdDate desc];
                      
           
    }
    
    //Get Pending Approval Requests..,
    //changed the query where clause for demo purpose where sanjib 29/10
       // Manager__r.user__C=:userinfo.getUserId()
    //,Removal_Date__c    Property_Description__c,
    else if(selectedTab =='MypendingApprovals'){   
        dummyReqList =[select name,Employee_Requestee_Name__r.name,
        Employee_Requestor_Name__r.name,Status__c,CreatedDate,
        Removal_Type__c,Manager__r.user__C,Removal_Date__c,Requestor_Region__c,
        Request_Type__c,Manager__c, Location111__c, Removal_Purpose__c,Property_Service_Approver__c from PR_Request__c where
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
         }
         if(X.Request_Type__c=='Data Center' && X.Requestor_Region__c=='EU'){
         if(groupuserId('PP_EMEA_Data_Center_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
         if(X.Request_Type__c=='Data Center' && (X.Requestor_Region__c=='NJ' || X.Requestor_Region__c=='JA')){
         if(groupuserId('PP_Asia_Data_Center_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
         
         if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_1585Bway_PropSvcs_Approvers'){
         if(groupuserId('PP_1585Bway_PropSvcs_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
       
         if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_1NYP_PropSvcs_Approvers'){
         if(groupuserId('PP_1NYP_PropSvcs_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
       
        if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_1PP_PropSvcs_Approvers'){
         if(groupuserId('PP_1PP_PropSvcs_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
       
        if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_2000W_PropSvcs_Approvers'){
         if(groupuserId('PP_2000W_PropSvcs_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
       
        if(x.Request_Type__c=='Property Services' && x.Property_Service_Approver__c=='PP_522FifthAve_PropSvcs_Approvers'){
         if(groupuserId('PP_522FifthAve_PropSvcs_Approvers',userinfo.getUserId())){
         requestList.add(X);
         }
         }
       
        
        
        }
        }
    }
    
    ELSE{
        //eRROR TO dISPLAY..,
    }
    
    if(requestList != null && !requestList.isEmpty()){
        TotalRequests = string.valueOf(requestList.size()); 
    }
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
//Modified by Kumaresan on 7-10-2014
    public List<SelectOption> getSearchParams() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','---- Select ----'));
        options.add(new SelectOption('Name','ID'));
        options.add(new SelectOption('Employee_Requestor_Name__r.name','Requested For'));
        options.add(new SelectOption('Request_Type__c','Request Type'));
        options.add(new SelectOption('CreatedDate','Created Date'));
        options.add(new SelectOption('Removal_Date__c','Removal Date'));
        /*Added From in the closerequest Search SG*/
        if(selectedTab=='MyclosedRequest'){
        options.add(new SelectOption('Location111__r.name','From'));    
        }        
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

public pagereference searchOpenReqs(){
    
    //Get My request based on dynamic filters.
    system.debug('*************inside searchOpenReqs');  
    List<string> dateComponents;
    Datetime DtStart;
    Datetime DtEnd;
    date stDate;
    date etDate;
    errorMessage ='';
    String userid1=userinfo.getUserId();
    String userid=userid1.substring(0,15);
     String useremail = [select email from user where id=:userinfo.getUserId()].email;
  
    //,Removal_Date__c,Property_Description__c,
    String Query='select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where';
    
    if(strSearchReq != null && strSearchReq != ''){
        if(strInputSearch != null && strInputSearch!= ''){
            strInputSearch=strInputSearch.trim();
            if( selectedTab =='Myrequest'){
            if(strSearchReq == 'Name'){
                Query+=' Name  like \'%'+strInputSearch+'%\' And (Status__c =\'Saved\' OR Status__c =\'Approved\' OR Status__c =\'Submitted\' OR Status__c =\'Recalled\' OR Status__c =\'Pending Checked-in\') ';
            }
            else if(strSearchReq == 'Employee_Requestor_Name__r.name'){
                system.debug('requestor Name'+strInputSearch);
                Query+=' Employee_Requestee_Name__r.name like \'%'+strInputSearch+'%\' And (Status__c =\'Saved\' OR Status__c =\'Approved\' OR Status__c =\'Submitted\' OR Status__c =\'Recalled\' OR Status__c =\'Pending Checked-in\') ';
            }
            else if(strSearchReq == 'Request_Type__c'){
               // Query+=' Request_Type__c=\''+strInputSearch+'\' ';
                Query+=' Request_Type__c like \'%'+strInputSearch+'%\' And (Status__c =\'Saved\' OR Status__c =\'Approved\' OR Status__c =\'Submitted\' OR Status__c =\'Recalled\' OR Status__c =\'Pending Checked-in\') ';
            }
            
            }
            //closed tab
            if(selectedTab =='MyHistory'){
                 if(strSearchReq == 'Name'){
             Query+=' Name  like \'%'+strInputSearch+'%\' And (Status__c =\'Closed\' OR Status__c =\'Cancelled\' OR Status__c =\'Rejected\') '; 
            }
            else if(strSearchReq == 'Employee_Requestor_Name__r.name'){
                system.debug('requestor Name'+strInputSearch);
                Query+=' Employee_Requestee_Name__r.name like \'%'+strInputSearch+'%\' And (Status__c =\'Closed\' OR Status__c =\'Cancelled\' OR Status__c =\'Rejected\') ';
            }
            else if(strSearchReq == 'Request_Type__c'){
               // Query+=' Request_Type__c=\''+strInputSearch+'\' ';
                Query+=' Request_Type__c like \'%'+strInputSearch+'%\' And (Status__c =\'Closed\' OR Status__c =\'Cancelled\' OR Status__c =\'Rejected\') ';
            }
            }
            
            //close Request 
            
             if(selectedTab =='MyclosedRequest'){
                 if(strSearchReq == 'Name'){
             Query+=' Name  like \'%'+strInputSearch+'%\' And Status__c =\'Approved\'  and IsPassGenerated__c=true '; 
            }
            else if(strSearchReq == 'Employee_Requestor_Name__r.name'){
                system.debug('requestor Name'+strInputSearch);
                Query+=' Employee_Requestee_Name__r.name like \'%'+strInputSearch+'%\' Status__c =\'Approved\'  and IsPassGenerated__c=true ';
            }
            else if(strSearchReq == 'Request_Type__c'){
               // Query+=' Request_Type__c=\''+strInputSearch+'\' ';
                Query+=' Request_Type__c like \'%'+strInputSearch+'%\' Status__c =\'Approved\'  and IsPassGenerated__c=true ';
            }
            }
           
           //pending approval
           
             if(selectedTab =='MypendingApprovals'){
                 if(strSearchReq == 'Name'){
             Query+=' Name  like \'%'+strInputSearch+'%\' And Status__c =\'Submitted\' '; 
            }
            else if(strSearchReq == 'Employee_Requestor_Name__r.name'){
                system.debug('requestor Name'+strInputSearch);
                Query+=' Employee_Requestee_Name__r.name like \'%'+strInputSearch+'%\' Status__c =\'Submitted\'  ';
            }
            else if(strSearchReq == 'Request_Type__c'){
               // Query+=' Request_Type__c=\''+strInputSearch+'\' ';
                Query+=' Request_Type__c like \'%'+strInputSearch+'%\' Status__c =\'Submitted\'  ';
            }
            }
           
            
            
            /* added From in Dynamic Query SG*/
           if(strSearchReq == 'Location111__r.name'){
             Query+=' Location111__r.name like \'%'+strInputSearch+'%\' ';
            }
            
            system.debug('Check sanjib'+strInputSearch+selectedTab);
            if(strSearchReq == 'Status__c'){
                    //Error to display..,
                    if(strInputSearch.length()>=3){
                    
                  if(selectedTab=='Myrequest') { 
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
                    
                  }
                  
                  
                  If(selectedTab=='MyHistory'){
                     String C='Rejected' ;
                  String C1='Closed';
                  String C2='Cancelled';
                  
                  
                    if(c.contains(strInputSearch)){
                        Query+=' Status__c =\'Rejected\'';
                    }
                    else if(c1.contains(strInputSearch)){
                        Query+=' Status__c =\'Closed\'';
                    }
                     else if(c2.contains(strInputSearch)){
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
        }
        else if(strSearchReq != 'CreatedDate' && strSearchReq != 'Removal_Date__c'){
            errorMessage='You must input criteria';
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
                errorMessage='You must input Created dates.';
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
                errorMessage='You must input Removal dates';
            }         
        }
         
        
        system.debug('*********FinalQuery'+Query);
        
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            //Or else Error Message to display..,
            requestList=null;
        }
        else{
            if(selectedTab =='Myrequest' || selectedTab =='MyHistory' || selectedTab =='MyclosedRequest'){
                //Query=Query+' AND CreatedById=\''+userinfo.getuserId()+'\' ';
                Query=Query+' AND (CreatedById= \''+userid+'\' or Watcher1__c=\''+useremail+'\' or Watcher2__c=\''+useremail+'\' or Watcher3__c=\''+useremail+'\' or Watcher4__c=\''+useremail+'\' or Watcher5__c=\''+useremail+'\' or Watcher6__c=\''+useremail+'\' or Watcher7__c=\''+useremail+'\' or Watcher8__c=\''+useremail+'\' or Watcher9__c=\''+useremail+'\' or Watcher10__c=\''+useremail+'\' ) ';
                
              /*  
                OR (Watcher1__c=:useremail) OR (Watcher2__c=:useremail)
                        or(Watcher3__c=:useremail)or(Watcher4__c=:useremail)
                        or(Watcher5__c=:useremail)or(Watcher6__c=:useremail)or(Watcher7__c=:useremail)
                        or(Watcher8__c=:useremail)or(Watcher9__c=:useremail)or(Watcher10__c=:useremail) )
                
                
                */
                
                
                
            }
            else if(selectedTab =='MypendingApprovals'){
                Query=Query+' AND OwnerId=\''+userinfo.getuserId()+'\' ';
                //Query=Query+' AND OwnerId=\''+userid+'\'';
                //Query=Query+' AND OwnerId=\'005f0000000jioG\'';
            }
            Query+=' order by createdDate desc ';
            system.debug('*********FinalQuery1:'+Query);
            requestList=(List<PR_Request__c>)Database.Query(Query);            
        }
        system.debug('*********FinalSearchrequestList'+requestList);
        if(requestList != null && !requestList.isEmpty()){
            TotalRequests = string.valueOf(requestList.size()); 
        }
        else{
            TotalRequests='0';
            //errorMessage='Your search criteria retrun no results';
        }
    }
    else{
        errorMessage='You must select search criteria';
    }  
    return null; 
}

public boolean ConfirmationWindow{get;set;}
public String ReqIdToClose{get;set;}

public pagereference confirmclose(){
    ConfirmationWindow=true;
    return null;
}

/*public pagereference CloseWindow(){
ConfirmationWindow=false;
ConfirmationWindow1=false;
return null;    
}*/

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
        PageReference pr = new PageReference('/apex/PP_RequestTest?tab=MyclosedRequest');
                  pr.setRedirect(true);
                   return pr;
}

public pagereference ViewRequest(){
        //system.debug('the placeholder'+IdPlaceHolder);
                system.debug('the ReqID'+ReqID);
                 //PageReference pr = new PageReference('/apex/PP_RequestTest?id='+ReqID);
                 PageReference pr = new PageReference('/apex/PP_RequestPageNEW?id='+ReqID);
                  pr.setRedirect(true);
        //private method
//        PR_Request__c a=[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Property_Description__c,Removal_Type__c,Request_Type__c,Removal_Date__c,Property_Owner__c,Location111__c,Destination_Details__c,Removal_Purpose__c  from PR_Request__c where name=:ReqID];
        
        return null;
}


public pagereference clear(){
    PageReference pr = new PageReference('/apex/PP_RequestTest?tab='+selectedTab);
    pr.setRedirect(true);
    return pr;
}
public pagereference NewRequest(){
       PageReference pr = new PageReference('/apex/PP_RequestPageNEW?tab=NewRequest');
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
    pagereference a=new pagereference('/apex/PP_RequestPageNEW?id='+clickedRowId+'&tab='+selectedTab);
    return a;
 }


    public pagereference submitRequest(){
        Id userId;
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
        PageReference pr = new PageReference('/apex/PP_RequestTest');
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
    
  
    //Start Balakumar
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
    
     public pagereference recallRequest(){
        system.debug('test sanjib'+RequestId);
        recallfromapproval(RequestId);
        ConfirmationWindow1=false;
        
       PR_Request__c rPP1 = [select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where id =: RequestId];
         
        rPP1.Status__c='Recalled';
        update rPP1;
        strStatus='In Draft';
        pagereference p=new pagereference('/apex/PP_RequestPageNEW?id='+RequestId+'&tab=Myrequest');
        p.setRedirect(true);
       //pagereference p=new pagereference('/apex/PP_RequestTest?tab=Myrequest');
        return p; 
      //return null;  
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
 
 
 public boolean confrimsubmit{get;set;}
 public pagereference submitconfirm(){
 	confrimsubmit=true;
 	return null;
 }
 
 
 

 public pagereference recallrequestconfirm()
 {
  // recallRequest = true;
   ConfirmationWindow1=true;
   return null;
 }
 public pagereference CloseConfirm(){
   system.debug('------------Confirmation----------------');
     
   ConfirmationWindow1=true;
   return null;
   }
  
  public pagereference CancelConfirm(){
   cancelConfrm=true;
   return null;
   }
  public boolean isEDCRequest{get;set;}
  public boolean isPropertyservice{get;set;}   
  public boolean isStandard{get;set;}
  public boolean showattachmentpopup{get;set;} 
  public boolean showcsvuploadfile{get;set;}
  public boolean showReqPopup{get;set;} 
  public boolean addwatcher{get;set;}
  public boolean addsourcepopup{get;set;} 
  public boolean showbuildingpopup{get;set;} 
  public boolean vendorpopup{get;set;}
  public boolean propOwnerVendorPopup{get;set;} 
  public boolean isOutofScope{get;set;} 
  //public boolean cancelConfrm{get;set;}
  //public boolean ConfirmationWindow{get;set;} 
  public boolean showrejectionPopup{get;set;} 
  public boolean isEDCRequestFulfillment{get;set;} 
 
   public Pagereference CloseWindow(){
      system.debug('------------Confirmation----------------');  
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
        //new..,
        isEDCRequestFulfillment=false;
        return null;
    }
    //End Balakumar 
    
   
    


}