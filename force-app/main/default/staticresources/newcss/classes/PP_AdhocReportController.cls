public class PP_AdhocReportController{

    Public String RequestId{get;set;}
    public string closedbyuser{get;set;}
    public list<employee__c> showclosedUser{get;set;}
    //Public String RequestedFor{get;set;}
    //Public date createdDate{get;set;}
    //Public date RemovalDate{get;set;}
    Public String Status{get;set;}
    public String RequestType{get;set;}
    public boolean showTable{get;set;}
    public boolean Showtext{get;set;}
    public boolean Showdesclimit{get;set;}
    public transient list<PR_Request__c> listPPRequest{get;set;}
    public list<PR_Request__c> showlistPPRequest{get;set;}    
    public String RequestorRegion{get;set;}
    public String CreatedDateFrom{get;set;}
    public String CreatedDateTo{get;set;}
    public String RemovalDateFrom{get;set;}
    public String RemovalDateTo{get;set;}
    public String Approvaldatefrom{get;set;}
    public String ApprovaldateTo{get;set;}
    public String approvalStatus{get;set;}
    public String DocumentAttached{get;set;}
    public String AssesttagSearch{get;set;}
    public String SerialtagSearch{get;set;}
    public String descSearch{get;set;}
    //public list<PR_Request__c> testrequest{get;set;}
    public list<SelectOption> requestType1{get;set;}
    public PR_Request__c inputSearchrequest{get;set;}
    public PR_Request__c inputSearchrequestclosedbyemp{get;set;}
    public PR_Request__c inputSearchrequestclosedbyappr{get;set;}
    public String exportmesg{get;set;}
    public String totalCount{get;set;}
    public string errorMessage1 {get; set;}
    public string errorMessage2 {get; set;}
    public string errorMessage3 {get; set;}
    
    public string RequesteeEmployee{get;set;}
    public boolean showReqPopup{get;set;}
    public list<Employee__c> EmployeeList{get;set;}
    public list<Property_Detail__c> listPropDetail{get;set;}
    public list<Employee__c> closedbyemp{get;set;}
    public list<Employee__c> closedbyappr{get;set;}
    
    //constructor
    
    public PP_AdhocReportController(){
        
        InputSearchrequest = new PR_Request__c();
        inputSearchrequestclosedbyemp = new PR_Request__c();
        inputSearchrequestclosedbyappr = new PR_Request__c();
        //testrequest=new list<PR_Request__c>();
        EmployeeList=new list<Employee__c>();
        listPPRequest=new list<PR_Request__c>();
        
        showlistPPRequest=new list<PR_Request__c>();
        showclosedUser=new list<employee__c>();
        showTable=false;
        requestType1=new list<SelectOption>();
        errorMessage1 ='';
        errorMessage2 = '';
        
        closedbyemp = new list<employee__c>();
        closedbyappr = new list<employee__c>();
        
        Schema.DescribeFieldResult statusFieldDescription3 = PR_Request__c.Destination_Details__c.getDescribe();
        requestType1.add(new selectOption('--None--', '--None--'));
        for (Schema.Picklistentry picklistEntry3:statusFieldDescription3.getPicklistValues())
        {
            requestType1.add(new SelectOption(pickListEntry3.getValue(),pickListEntry3.getLabel()));
            // obtain and assign default value
            if (picklistEntry3.defaultValue){
                inputSearchrequest.Destination_Details__c= pickListEntry3.getValue();
            }  
        }
    }
    
    public String TotalRequests{get;set;}


    public PageReference goBackToAdminPage(){
        PageReference pr2 = new PageReference('/apex/PP_AdminScreens?tab=Admin');
        pr2.setRedirect(true);
        return pr2;
    }
    
    public pagereference searchAssest(){
    
        list<String> X=new list<String>();  
        List<List<SObject>> searchList = [FIND :AssesttagSearch IN ALL FIELDS RETURNING Property_Detail__c (Id, Name,Request_Details__c)];
        Property_Detail__c [] accounts = ((List<Property_Detail__c>)searchList[0]);
        for(Property_Detail__c V1:accounts){
            x.add(v1.Request_Details__c);
        }

        system.debug('test c'+x);
        showlistPPRequest=[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,
                  Status__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c,
                  Removal_Date__c,ActualApprover__c,Approval_Rejection_Date__c,ClosedBy__c,ClosedDate__c,IsApprover__c,
                  IsAutoCancelled__c,IsAutoColsed__c,IsPassGenerated__c,IsRejected__c,PassGeneratedBy__c,PassGeneratedDate__c  from PR_Request__c where id in :x];

        system.debug('test sosl'+showlistPPRequest);    
        showTable=true; 
        
        return null;    
    }

  
    
    public pagereference filterRequest(){
        errorMessage1 ='';
        errorMessage2 = '';
        errorMessage3 = '';
        exportmesg=null;
        totalCount=null;
        
        
        
        listPPRequest=new list<PR_Request__c>();
        showlistPPRequest.clear();
        String Query = 'select name,Equipment_Receipt_Confirm__c,IsAttachment__c,lastmodifiedbyid,LastModifieddate,lastmodifiedby.name ,createddate,Watcher1__c,Watcher2__c,Watcher3__c,Watcher4__c,Watcher5__c,Watcher6__c,Watcher7__c,Watcher8__c,Watcher9__c,Watcher10__c,Property_Owner__c,Other_Owners__c,Employee_Requestee_Name__r.name,Employee_Requestee_Name__r.emp_id__c,Employee_Requestor_Name__r.name,Employee_Requestor_Name__r.emp_id__C,Employee_Requestor_Name__r.Region_Dsc_Org__c,Employee_Requestee_Name__r.Region_Dsc_Org__c,Status__c,Requestor_Region__c,Expected_Return_Date__c,Others__c,Destination_Details__c,Location111__r.name,Removal_Type__c,Request_Type__c,Removal_Purpose__c,Removal_Date__c,ActualApprover__c,ActualApprover__r.name,ActualApprover__r.emp_id__c,Approval_Rejection_Date__c,ClosedBy__c,ClosedBy__r.name,ClosedBy__r.emp_id__c,ClosedDate__c,IsApprover__c,IsAutoCancelled__c,IsAutoColsed__c,IsPassGenerated__c,IsRejected__c,CC_WatcherNames__c,PassGeneratedBy__c,PassGeneratedBy__r.name,PassGeneratedDate__c ';
    
        //Code for Seraching the Request
        List<string> dateComponents;
        list<String> dateComponents1;
        Datetime DtStart;
        Datetime DtEnd;
        date removalStartDate;
        date removalEndDate;
        List<string> dateComponentsrem;
        list<String> dateComponents1rem;
        Date DtStart1=system.today();
        Date DtEnd1=system.today();
        Datetime removalDtStart2;
        Datetime removalDtEnd2;
        List<string> dateApproval;
        list<String> dateApproval1;
        Datetime DtStart2;
        Datetime DtEnd2;
        
        //if(asset tag || serial ||descri != null){
            //Query +=',(select id,name,des,asset,serial from pdetail where asset' limit 1)';
        //}
        
        
        //Validations
         if((descSearch!=null && descSearch.trim()!='') || (AssesttagSearch!=null && AssesttagSearch.trim()!='') || (SerialtagSearch!=null && SerialtagSearch.trim()!='') )
         {
            Query+=',(select id,Request_Details__c,Asset_Tag__c,Serial_No__c,Description__c from propdetails__r where';
            
            
            if(descSearch!=null && descSearch.trim()!='')
            {
                Integer descLength = descSearch.length();
                system.debug('---------------DescLength------------------'+descLength);
                if(descLength < 20)
                {
                Query+=' Description__c like \'%'+String.escapeSingleQuotes(descSearch)+'%\' AND ';
                }
                else
                {
                  Showdesclimit=true;
                  return null;
                }
            }
        
            if(AssesttagSearch!=null && AssesttagSearch.trim()!='')
            {
                //Query+=' Asset_Tag__c =\'%'+AssesttagSearch+'%\' AND ';
                Query+=' Asset_Tag__c =\''+String.escapeSingleQuotes(AssesttagSearch)+'\' AND ';
            }
            
            if(SerialtagSearch!=null && SerialtagSearch.trim()!='')
            {
                //Query+=' Serial_No__c =\'%'+SerialtagSearch+'%\' AND ';
                Query+=' Serial_No__c =\''+String.escapeSingleQuotes(SerialtagSearch)+'\' AND ';
            }
            
            Query= Query.trim();
            if(Query.endsWith('where')){
                Query=Query.removeEnd('where');
            }
            else if(Query.endsWith('AND')){
                Query=Query.removeEnd('AND');
            }
            
            Query+=' limit 1 )';            
              
            
        } 
        
        Query+= ' from PR_Request__c where';
        
        
        if(CreatedDateTo!= null && CreatedDateTo.trim() != ''  && CreatedDateFrom!= null && CreatedDateFrom.trim() != '') {
            system.debug('------------CreatedDateFrom ---------------'+CreatedDateFrom );
            system.debug('------------CreatedDateTo ---------------'+CreatedDateTo );

            dateComponents = CreatedDateFrom.split('/',3);
            DtStart = Datetime.newInstancegmt(Integer.ValueOf(dateComponents[2]),Integer.ValueOf(dateComponents[0]),Integer.ValueOf(dateComponents[1]));
            
            dateComponents1=CreatedDateTo.split('/',3); 
            DtEnd=Datetime.newInstancegmt(Integer.ValueOf(dateComponents1[2]),Integer.ValueOf(dateComponents1[0]),Integer.ValueOf(dateComponents1[1]));
            
            if (DtStart.getTime() > DtEnd.getTime()) {
                errorMessage1 = 'The Created start date must be before the Created end date. Please select a valid date.';
                return null;
            }
        }
        
        if(RemovalDateFrom!= null && RemovalDateFrom.trim() != ''  && RemovalDateTo!= null && RemovalDateTo.trim() != '') {

            removalStartDate =date.parse(RemovalDateFrom);
            removalDtStart2=Datetime.newInstanceGMT(removalStartDate.year(),removalStartDate.month(),removalStartDate.day());
            removalDtStart2=removalDtStart2.adddays(1);

            removalEndDate =date.parse(RemovalDateTo); 
            removalDtEnd2=Datetime.newInstanceGMT(removalEndDate.year(),removalEndDate.month(),removalEndDate.day());
            removalDtEnd2=removalDtEnd2.adddays(1);

            if (removalDtStart2.getTime() > removalDtEnd2.getTime()) {
                errorMessage2 = 'The Removal start date must be before the Removal end date. Please select a valid date.';
                return null;
            }
        }

        if(Approvaldatefrom!= null && Approvaldatefrom.trim() != ''  && ApprovaldateTo!= null && ApprovaldateTo.trim() != ''){
            
            dateApproval=Approvaldatefrom.split('/',3);
            DtStart2=Datetime.newInstancegmt(Integer.ValueOf(dateApproval[2]),Integer.ValueOf(dateApproval[0]),Integer.ValueOf(dateApproval[1]));

            dateApproval1=ApprovaldateTo.split('/',3); 
            DtEnd2=Datetime.newInstancegmt(Integer.ValueOf(dateApproval1[2]),Integer.ValueOf(dateApproval1[0]),Integer.ValueOf(dateApproval1[1]));
            
            if (DtStart2.getTime() > DtEnd2.getTime()) {
                errorMessage3 = 'The Approval start date must be before the Approval end date. Please select a valid date.';
                return null;
            }
        }

        system.debug('***Inside filterRequest::RequestId:'+RequestId);
    
        if(RequestId !=null && RequestId.trim() !=''){
            Query+=' Name  like \'%'+String.escapeSingleQuotes(RequestId)+'%\' AND ';
        }
        
        if(inputSearchrequest.Employee_Requestee_Name__c !=null && inputSearchrequest.Employee_Requestor_Name__c==null){
            string a = inputSearchrequest.Employee_Requestee_Name__c;
            system.debug('------------Employee Request----------------'+a);
            Query+=' Employee_Requestee_Name__c =\''+a+'\' AND ';
        } else if(inputSearchrequest.Employee_Requestee_Name__c==null && inputSearchrequest.Employee_Requestor_Name__c!=null){
              String b=inputSearchrequest.Employee_Requestor_Name__c;
              system.debug('------------Employee_Requestee_Name__c ----------------'+b);
              Query+=' Employee_Requestor_Name__c =\''+b+'\' AND ';
        } else if(inputSearchrequest.Employee_Requestee_Name__c!=null && inputSearchrequest.Employee_Requestor_Name__c!=null){
             String a=inputSearchrequest.Employee_Requestee_Name__c;
             String b=inputSearchrequest.Employee_Requestor_Name__c;
             system.debug('------------Employee_Requestee_Name__c----------------'+a);
             system.debug('------------Employee_Requestor_Name__c----------------'+b);
             Query+=' Employee_Requestee_Name__c =\''+a+'\' and  Employee_Requestor_Name__c =\''+b+'\'  AND ';
        }  
        
        if(Status!=null && Status!='--None--'){
            if(Status=='Pending Approval'){
                Query+=' Status__c =\'Submitted\' AND ' ;
            }
            else if(Status=='In Draft'){
                Query+=' Status__c =\'Saved\' AND ';
            }
            else if(Status=='Rejected'){
                Query+=' Status__c =\'Rejected\' AND ';
            }
            else if(Status=='Closed'){
                Query+=' Status__c =\'Closed\' AND ';
            }
            /*** Not used
            else if(Status=='Collected'){
                Query+=' Status__c =\'Collected\' AND ';
            }
            ********/
            else if(Status=='Recalled'){
                Query+=' Status__c =\'Recalled\' AND ';
            }
            else if(Status=='Approved'){
                Query+=' Status__c =\'Approved\' AND ';
            }
            else if(Status=='Cancelled'){
                Query+=' Status__c =\'Cancelled\' AND ';
            }
        }
            
        if(RequestorRegion!=null && RequestorRegion!='--None--'){
            if(RequestorRegion=='APAC'){
                //WHY ONLY FEW REGIONS FROM APAC????
                Query+=' (Requestor_Region__c =\'NJ\' OR Requestor_Region__c =\'JA\') AND ';
            }
            else if(RequestorRegion=='EMEA'){
                Query+=' Requestor_Region__c =\'EU\' AND ';
            }
            else if(RequestorRegion=='NA'){
                Query+=' Requestor_Region__c =\'NA\' AND ';
            }
        }
        
        if(RequestType!=null && RequestType!='--None--'){
            if(RequestType=='MS Office (Most common)'){
                Query+=' Request_Type__c=\'MS Office (Most common)\'AND ';
            }
            else if(RequestType=='Technology (EDC & EUS only)'){
                Query+=' Request_Type__c=\'Technology (EDC & EUS only)\' AND ';
            }
            else if(RequestType=='Facilities/Move Mgmt (Prop Svcs only)'){
                Query+=' Request_Type__c=\'Facilities/Move Mgmt (Prop Svcs only)\' AND ';
            }
        }   
            
        if(CreatedDateFrom!=null && CreatedDateFrom!='' ){
            dateComponents=CreatedDateFrom.split('/',3);
            DtStart=Datetime.newInstancegmt(Integer.ValueOf(dateComponents[2]),Integer.ValueOf(dateComponents[0]),Integer.ValueOf(dateComponents[1]));
            Query+=' CreatedDate >=: DtStart AND ';
        }
        
        if(CreatedDateTo!=null && CreatedDateTo!='' ){
            dateComponents1=CreatedDateTo.split('/',3); 
            DtEnd=Datetime.newInstancegmt(Integer.ValueOf(dateComponents1[2]),Integer.ValueOf(dateComponents1[0]),Integer.ValueOf(dateComponents1[1]));
            Query+=' CreatedDate <=: DtEnd AND ';
        }
        
        /********** Not required
        else if(CreatedDateFrom!=null && CreatedDateFrom != '' && CreatedDateTo!=null  && CreatedDateTo!='' ){
            system.debug('*********CreatedDateFrom:'+CreatedDateFrom);
            dateComponents=CreatedDateFrom.split('/',3);
            dateComponents1=CreatedDateTo.split('/',3); 
            DtStart=Datetime.newInstancegmt(Integer.ValueOf(dateComponents[2]),Integer.ValueOf(dateComponents[0]),Integer.ValueOf(dateComponents[1]));
            DtEnd=Datetime.newInstancegmt(Integer.ValueOf(dateComponents1[2]),Integer.ValueOf(dateComponents1[0]),Integer.ValueOf(dateComponents1[1]));
            Query+=' CreatedDate >=: DtStart AND CreatedDate <=: DtEnd  AND ';
        }
        ****/
        system.debug('--------------CreatedDate Start --------------'+DtStart);
        system.debug('--------------CreatedDate End--------------'+DtEnd);
       
        //removal dates
        if(RemovalDateFrom != null && RemovalDateFrom.trim() != '' ){
            removalStartDate =date.parse(RemovalDateFrom);
            removalDtStart2=Datetime.newInstanceGMT(removalStartDate.year(),removalStartDate.month(),removalStartDate.day());
            removalDtStart2=removalDtStart2.adddays(1);
            Query+=' Removal_Date__c >=:removalStartDate AND';
        }
        system.debug('------------------Removal Start Date---------------'+removalStartDate);
        system.debug('------------------Removal Start Date--------------'+removalDtStart2);
        
        if(RemovalDateTo!= null && RemovalDateTo.trim() !='' ){
            removalEndDate =date.parse(RemovalDateTo); 
            removalDtEnd2=Datetime.newInstanceGMT(removalEndDate.year(),removalEndDate.month(),removalEndDate.day());
            removalDtEnd2=removalDtEnd2.adddays(1);
            Query+=' Removal_Date__c <:removalEndDate AND';
        } 
        system.debug('------------------Removal End Date--------------'+removalEndDate);
        system.debug('------------------Removal End Date--------------'+removalDtEnd2);
       
        //approval dates
        if(Approvaldatefrom!=null && Approvaldatefrom!=''){
            dateApproval=Approvaldatefrom.split('/',3);
            DtStart2=Datetime.newInstancegmt(Integer.ValueOf(dateApproval[2]),Integer.ValueOf(dateApproval[0]),Integer.ValueOf(dateApproval[1]));
            Query+=' Approval_Rejection_Date__c >=: DtStart2 AND ';
        }
   
        //if(inputSearchrequest.ClosedBy__c!=null){
        if(inputSearchrequestclosedbyemp.Employee_Requestee_Name__c!=null)  {  
            
            closedbyemp = [select id,user__c from employee__c where id=:inputSearchrequestclosedbyemp.Employee_Requestee_Name__c LIMIT 1]; 
            //system.debug('---------------Closedbyemp-----------------'+closedbyemp);             
            If(closedbyemp[0].user__c != null && closedbyemp.size() > 0){
                Query+=' ClosedBy__c =\''+closedbyemp[0].user__c+'\' AND ';
                //String b=inputSearchrequest.ClosedBy__c;
                //Query+=' ClosedBy__c =\''+b+'\' AND ';
            }
            
                        
        }
    
        if(inputSearchrequestclosedbyappr.Employee_Requestee_Name__c!=null){
        
         closedbyappr = [select id,user__c from employee__c where id=:inputSearchrequestclosedbyappr.Employee_Requestee_Name__c LIMIT 1];            
           //system.debug('---------------ClosedbyApprover-----------------'+closedbyappr );  
            If(closedbyappr[0].user__c != null && closedbyappr.size() > 0){
            //String b=inputSearchrequest.ActualApprover__c;
            //system.debug('--------------Actual Approver--------------'+b);
            Query+=' ActualApprover__c =\''+closedbyappr[0].user__c+'\' AND ';
        }
       } 
        
        if(inputSearchrequest.Location111__c!=null){
            String b=inputSearchrequest.Location111__c;
            Query+=' Location111__c =\''+b+'\' AND ';
        }

        if(inputSearchrequest.Destination_Details__c!=null && inputSearchrequest.Destination_Details__c!='--None--'){
            if(inputSearchrequest.Destination_Details__c=='Charitable Donation'){
                Query+=' Destination_Details__c=\'Charitable Donation\'AND ';
            }
            else if(inputSearchrequest.Destination_Details__c=='Disposal'){
                Query+=' Destination_Details__c=\'Disposal\' AND ';
            }
            else if(inputSearchrequest.Destination_Details__c=='Hiring Agency'){
                Query+=' Destination_Details__c=\'Hiring Agency\' AND ';
            }
            else if(inputSearchrequest.Destination_Details__c=='Home'){
                Query+=' Destination_Details__c=\'Home\' AND ';
            }
            else if(inputSearchrequest.Destination_Details__c=='MS Data Center'){
                Query+=' Destination_Details__c=\'MS Data Center\' AND ';
            }
            else if(inputSearchrequest.Destination_Details__c=='MS Office Building'){
                Query+=' Destination_Details__c=\'MS Office Building\' AND ';
            }
            else if(inputSearchrequest.Destination_Details__c=='Other'){
                Query+=' Destination_Details__c=\'Other\' AND ';
            }
            else if(inputSearchrequest.Destination_Details__c=='Vendor'){
                Query+=' Destination_Details__c=\'Vendor\' AND ';
            }
        }    
        
        if(inputSearchrequest.Equipment_Receipt_Confirm__c!=null && inputSearchrequest.Equipment_Receipt_Confirm__c!=''){
            Query+=' Equipment_Receipt_Confirm__c=\''+String.escapeSingleQuotes(inputSearchrequest.Equipment_Receipt_Confirm__c)+'\' AND ';
        }   
        
        if(DocumentAttached!=null && DocumentAttached.trim()!='' && DocumentAttached=='yes'){
            Query+=' IsAttachment__c =true AND ';
        }   
        
        
        Query = query.trim();
        if(Query.endsWith('where')){
        Query=Query.removeEnd('where');
        }
        else if(Query.endsWith('AND')){
        Query=Query.removeEnd('AND');
        }
        Query+=' order by createdDate desc ';
        system.debug('*********FinalQuery in filterRequest::'+Query);
                 
        list<PR_Request__c> prlist=(List<PR_Request__c>)Database.Query(Query);       
        System.debug('*********FinalQuery in filterRequest:'+prlist);
                System.debug('*********FinalQuery in filterRequest:'+listPPRequest);

         if((descSearch!=null && descSearch.trim()!='') || (AssesttagSearch!=null && AssesttagSearch.trim()!='') || (SerialtagSearch!=null && SerialtagSearch.trim()!='') )
         {
            for(PR_Request__c p:prlist)
            {
                
                 if(p.propdetails__r != null && p.propdetails__r.size()>0)
                 {
                 System.debug('*********PDetails:'+p.propdetails__r);
                 listPPRequest.add(p);


                 }
             }
                 
         }
                 
         else
         {
              System.debug('*********PDetails NEXT:'+prlist);
             listPPRequest.addAll(prlist);
         }
        
         
        //adding this for PROPPASS-54 for Description related search
        system.debug('--------------------Description Text--------------------'+descSearch);
       
        /*
        if(descSearch!=null && descSearch.trim()!=''){
        if(RequestId==null || RequestId.trim()==''){
                listPPRequest.clear();
                system.debug('inside asset'+listPPRequest.size());
                list<String> X=new list<String>();
                List<Property_Detail__c> searchList = [select Request_Details__c,Description__c from Property_Detail__c where Description__c like :descSearch];
                
                
                
                for(Property_Detail__c V1:searchList ){
                      x.add(v1.Request_Details__c);
                }
                
                
                system.debug('------------------X-------------------'+x);
                
                list<PR_Request__c> testdummy = [select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,
                        Status__c,CreatedDate,Location111__r.name,Removal_Type__c,Request_Type__c,
                        Removal_Date__c,ActualApprover__c,Approval_Rejection_Date__c,ClosedBy__c,ClosedDate__c,IsApprover__c,
                        IsAutoCancelled__c,IsAutoColsed__c,IsPassGenerated__c,IsRejected__c,PassGeneratedBy__c,PassGeneratedDate__c,Other_Owners__c,Others__c,
                        Employee_Requestee_Name__r.emp_id__c,Employee_Requestor_Name__r.emp_id__C,ActualApprover__r.emp_id__c,ClosedBy__r.emp_id__c,
                        Employee_Requestor_Name__r.Region_Dsc_Org__c,Employee_Requestee_Name__r.Region_Dsc_Org__c,Requestor_Region__c,Property_Owner__c,
                        Expected_Return_Date__c,Destination_Details__c,Removal_Purpose__c,ActualApprover__r.name,ClosedBy__r.name,CC_WatcherNames__c,
                        PassGeneratedBy__r.name,lastmodifiedby.name,Equipment_Receipt_Confirm__c,IsAttachment__c,lastmodifiedbyid,LastModifieddate 
                    from PR_Request__c where id in :x];
          
                for(PR_Request__c s:testdummy){
                    listPPRequest.add(s);
                }
            }
        }
        
       
        */
        
        if(listPPRequest!=null) {
            system.debug('-------------Total Count-----------'+listPPRequest.size());
            totalCount = string.valueof(listPPRequest.size());
        }
        
        if(listPPRequest!=null && listPPRequest.size()>25){
            for(Integer i=0;i<25;i++){
                showlistPPRequest.add(listPPRequest[i]);
                exportmesg = 'ATTENTION: Page can only display 25 records. Please click Export to view complete report details.';
            }
            Showdesclimit=false;
            showTable=true;
            Showtext=false;
        }
        else if(listPPRequest!=null && listPPRequest.size()==0) {
            Showdesclimit=false;
            showTable=false;
            Showtext=true;
        }
        else {
            for(Integer i=0;i<listPPRequest.size();i++){
                showlistPPRequest.add(listPPRequest[i]);
            }
            Showdesclimit=false;
            showTable=true;
            Showtext=false;
        }
            
        system.debug('*********FinalSearchrequestList'+listPPRequest);
        
        if(listPPRequest != null && !listPPRequest.isEmpty()){
            TotalRequests = string.valueOf(listPPRequest.size()); 
            //System.debug('******* Record Count in Adhoc page ******' + listPPRequest.size());

        }
        else{
            TotalRequests='0';
        }
    return null;   
    }

 

    public pagereference exportrequest(){
    
        System.debug('*****RequestorName*******'+ inputSearchrequest.Employee_Requestee_Name__c);
        System.debug('*****RequestorCreator*******'+ inputSearchrequest.Employee_Requestor_Name__c);
        String urlquery = '/apex/PP_exportRequest?' ;
        
        if(RequestId != '' && RequestId != null)
            urlquery+= 'RequestId='+RequestId +'&';
                        
        if(inputSearchrequest.Employee_Requestee_Name__c != null )
        {
            String a = inputSearchrequest.Employee_Requestee_Name__c;
            urlquery+= 'RequestorName=' + a +'&';
        }    
        
        System.debug('*****RequestorName*******'+ inputSearchrequest.Employee_Requestee_Name__c);
            
        if(inputSearchrequest.Employee_Requestor_Name__c != null )
        {
            String a = inputSearchrequest.Employee_Requestor_Name__c;
            urlquery+= 'RequestorCreator=' + a +'&';
        }
        
        if(RequestorRegion  != '' && RequestorRegion  != null)
            urlquery+= 'RequestorRegion=' + RequestorRegion +'&';
            
        if(RequestType != '' && RequestType != null)
            urlquery+= 'RequestType=' + RequestType +'&';
            
        if(CreatedDateFrom != '' && CreatedDateFrom != null)
            urlquery+= 'CreatedDateFrom=' + CreatedDateFrom +'&';
            
        if(CreatedDateTo != '' && CreatedDateTo != null)
            urlquery+= 'CreatedDateTo=' + CreatedDateTo +'&';
            
        if(RemovalDateFrom != '' && RemovalDateFrom != null)
            urlquery+= 'RemovalDateFrom=' + RemovalDateFrom+'&';
        
        if(RemovalDateTo != '' && RemovalDateTo != null)
            urlquery+= 'RemovalDateTo=' + RemovalDateTo +'&';
            
        if(Approvaldatefrom != '' && Approvaldatefrom != null)
            urlquery+= 'Approvaldatefrom=' + Approvaldatefrom +'&';
            
        if(ApprovaldateTo!= '' && ApprovaldateTo!= null)
            urlquery+= 'ApprovaldateTo=' + ApprovaldateTo+'&';
            
        if(Status != '' && Status != null)
            urlquery+= 'Status=' + Status +'&';
                
        if(inputSearchrequest.Equipment_Receipt_Confirm__c != '' && inputSearchrequest.Equipment_Receipt_Confirm__c != null)
            urlquery+= 'ServiceNoworTracking=' + inputSearchrequest.Equipment_Receipt_Confirm__c +'&';
            
        if(AssesttagSearch != '' &&  AssesttagSearch != null)
            urlquery+= 'AssetTag=' + AssesttagSearch +'&';

        if(SerialtagSearch != '' && SerialtagSearch != null)
            urlquery+= 'SerialNo=' + SerialtagSearch +'&';
        
        //System.debug('*****Closed Emp*******'+ inputSearchrequestclosedbyemp.Employee_Requestee_Name__c+'****'+closedbyemp[0].user__c);    
          if(inputSearchrequestclosedbyemp.Employee_Requestee_Name__c!=null )
        {
             If(closedbyemp[0].user__c != null && closedbyemp.size() > 0){
            String closedemp = closedbyemp[0].user__c;
            system.debug('*****closed emp***'+closedemp);           
            urlquery+= 'ClosedBy=' + closedemp +'&';
            }        
        }
        
        //System.debug('*****approver emp*******'+ inputSearchrequestclosedbyappr.Employee_Requestee_Name__c+'****'+closedbyappr[0].user__c);    
          if(inputSearchrequestclosedbyappr.Employee_Requestee_Name__c!=null )
        {
             If(closedbyappr[0].user__c != null && closedbyappr.size() > 0){
            String approveremp = closedbyappr[0].user__c;
            system.debug('*****approver emp***'+approveremp);           
            urlquery+= 'Approver=' + approveremp +'&';
            }
        }
        
        
        if(inputSearchrequest.Location111__c != null)
            urlquery+= 'From=' + inputSearchrequest.Location111__c +'&';
            
        if(inputSearchrequest.Destination_Details__c != '' && inputSearchrequest.Destination_Details__c != null)
            urlquery+= 'To=' + inputSearchrequest.Destination_Details__c +'&';
            
        if(DocumentAttached  != '' && DocumentAttached  != null)
            urlquery+= 'DocumentAttached=' + DocumentAttached +'&';
        
        if(descSearch != '' && descSearch != null)
            urlquery+= 'Description=' + descSearch;    
        
        System.debug('*****urlquery*******'+ urlquery);
        
        PageReference pr = new PageReference(urlquery);
                                  
        
        /*PageReference pr = new PageReference('/apex/PP_exportRequest_ashu?RequestId='+ RequestId +'&'+'RequestorName='+ inputSearchrequest.Employee_Requestee_Name__c+ '&'+'RequestorCreator='+ inputSearchrequest.Employee_Requestor_Name__c+
                                          '&'+'RequestorRegion='+ RequestorRegion + '&' + 'RequestType=' + RequestType + '&'+ 'CreatedDateFrom=' + CreatedDateFrom + '&' + 'CreatedDateTo=' + CreatedDateTo + 
                                          '&'+'RemovalDateFrom='+ RemovalDateFrom + '&'+ 'RemovalDateTo='+ RemovalDateTo + '&'+'Approvaldatefrom='+ Approvaldatefrom + '&'+'ApprovaldateTo='+ ApprovaldateTo+ '&'+'Status='+ Status +
                                          '&'+'ServiceNoworTracking='+ inputSearchrequest.Equipment_Receipt_Confirm__c+ '&'+ 'AssetTag='+ AssesttagSearch+ '&'+'SerialNo='+ SerialtagSearch + '&' + 'ClosedBy=' + inputSearchrequest.ClosedBy__c+
                                          '&'+'Approver='+ inputSearchrequest.ActualApprover__c+ '&'+ 'From='+ inputSearchrequest.Location111__c + '&'+'To='+ inputSearchrequest.Destination_Details__c + '&' + 'DocumentAttached='+ DocumentAttached 
                                           ); 
        */                                  
        
        pr.setredirect(true);       
        return pr ;
    }
     
   
   
    
    
    public pagereference SearchEmployee(){
        showReqPopup=true;
        return null;
    }
    
    
    public pagereference SelectedEmployee(){
        showReqPopup=false;
        return null;
    }

    public pagereference FilterEmployee(){
        EmployeeList=null;
        system.debug('*****Inside FilterEmployee::id & Name:'+RequesteeEmployee);
        String Query='select id,emp_id__c,Division_Dsc_Org__c,CC_City_Dsc_Org__c,Floor_Directory__c, name,First_Name__c, Last_Name__c,Dept_Dsc_Org__c,Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c,Building_Directory__c, Subdept_Org__c , Job_Country_Job__c,Empl_Class_Dsc_Job__c,Cost_Center_Code__c,Level_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where'; 
        if((RequesteeEmployee!=null || RequesteeEmployee!='')){
             Query+=' (name like \'%'+RequesteeEmployee+'%\' OR emp_id__c=\''+RequesteeEmployee +'\') and status__c=\'Active\'';
        }
       
        if(Query.endsWith('where')){
            Query=Query.removeEnd('where');
            EmployeeList=null;
        }
        else{
            //Query+='  order by createdDate desc ';
            Query+='  order by name asc ';
            EmployeeList=(List<Employee__C>)Database.Query(Query);
            //EmployeeList=PP_Util.sortList(EmployeeList, 'name', 'asc');
            system.debug('**************Employeelist'+EmployeeList);           
        }
    
    return null;
    }

    public pagereference closewindow() {
        
        showReqPopup=false;
        return null;
    }


}