@isTest                                                //dummy class
public class PPR_NewRequestTest_bootstrap{
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

    Public PPR_NewRequestTest_bootstrap(){
   //group population
    requestList=new list<PR_Request__c>();
    list<PR_Request__c> dummyReqList=new list<PR_Request__c>();
    TotalRequests='0';
    tabName = 'My Request';
    isdateEnabled =false;

    selectedTab = ApexPages.Currentpage().getParameters().get('tab');
    System.debug('*************************************PPR_NewRequestTest_bootstrap()****selectedTab :'+selectedTab );
    viewReq = false;
   
    String useremail = [select email from user where id=:userinfo.getUserId()].email;
    
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
           if(strSearchReq == 'Location111__r.name'){
             Query+=' Location111__r.name like \'%'+strInputSearch+'%\' ';
            }
            
            
            if(strSearchReq == 'Status__c'){
                if( selectedTab =='Myrequest' && (strInputSearch!='Pending Approval' && strInputSearch!='In Draft' && strInputSearch!='Approved') ){
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
                   
                }
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
            if(selectedTab =='Myrequest' || selectedTab =='MyHistory' || selectedTab =='MyclosedRequest'){
                //Query=Query+' AND CreatedById=\''+userinfo.getuserId()+'\' ';
                Query=Query+' AND CreatedById= \''+userid+'\'';
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
        }
    }
    else{
        errorMessage='You must input this.';
    }  
    return null; 
}

public boolean ConfirmationWindow{get;set;}
public String ReqIdToClose{get;set;}

public pagereference confirmclose(){
    ConfirmationWindow=true;
    return null;
}

public pagereference CloseWindow(){
ConfirmationWindow=false;
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
        PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap?tab=MyclosedRequest');
                  pr.setRedirect(true);
                   return pr;
}

public pagereference ViewRequest(){
        //system.debug('the placeholder'+IdPlaceHolder);
                system.debug('the ReqID'+ReqID);
                 //PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap?id='+ReqID);
                 PageReference pr = new PageReference('/apex/PP_RequestPageNEW_bootstrap?id='+ReqID);
                  pr.setRedirect(true);
        //private method
//        PR_Request__c a=[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Property_Description__c,Removal_Type__c,Request_Type__c,Removal_Date__c,Property_Owner__c,Location111__c,Destination_Details__c,Removal_Purpose__c  from PR_Request__c where name=:ReqID];
        
        return null;
}


public pagereference clear(){
    PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap?tab='+selectedTab);
    pr.setRedirect(true);
    return pr;
}
public pagereference NewRequest(){
       PageReference pr = new PageReference('/apex/PP_RequestPageNEW_bootstrap?tab=NewRequest');
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
    pagereference a=new pagereference('/apex/PP_RequestPageNEW_bootstrap?id='+clickedRowId+'&tab='+selectedTab);
    return a;
 }


    public pagereference submitRequest(){
        Id userId;
        System.debug('*******Submit Request....'+RequestId );
        PR_Request__c rPP = [select name,Employee_Requestee_Name__r.name,Manager__c,Employee_Requestor_Name__r.name,Status__c,Removal_Date__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c from PR_Request__c where id =: RequestId];
        if(rPP != null && rPP.Manager__c!=null){
        userId = rPP.Manager__c; 
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
        PageReference pr = new PageReference('/apex/PP_RequestTest_bootstrap');
        pr.setRedirect(true);
        
        return pr;

        //pagereference a=new pagereference('/apex/PP_RequestPageNEW_bootstrap?id='+clickedRowId+'&tab='+selectedTab);
        //return a;
 }






}