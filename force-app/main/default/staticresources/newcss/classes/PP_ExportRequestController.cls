public class PP_ExportRequestController {

    public transient List<PR_Request__c> exportlistPPRequest {get;set;}
    public transient list<Property_Detail__c> listPropDetail {get;set;}

    //variables defined to fetch the values from the url
    
    public String requestid {get;set;}
    public String requestorname {get;set;}
    public String requestorcreator{get;set;}
    public String requestorregion {get;set;}
    public String requesttype {get;set;}    
    public String createddatefrom {get;set;}
    public String createddateto {get;set;}
    public String removaldatefrom {get;set;}
    public String removaldateto{get;set;}    
    public String approvaldatefrom{get;set;}
    public String approvaldateto {get;set;}
    public String status {get;set;}
    public String servicenowortracking {get;set;}
    public String assettag {get;set;}    
    public String serialno{get;set;}
    public String closedby {get;set;}
    public String approver {get;set;}
    public String fromplace {get;set;}
    public String toplace {get;set;}
    public String documentattached {get;set;}
    public String description {get;set;}
    
    public PP_ExportRequestController()
    {
        /*
         String requestid = ApexPages.currentPage().getParameters().get('RequestId');
         String requestorname = ApexPages.currentPage().getParameters().get('RequestorName');
         String requestorcreator= ApexPages.currentPage().getParameters().get('RequestorCreator');
         String requestorregion = ApexPages.currentPage().getParameters().get('RequestorRegion');
         String requesttype = ApexPages.currentPage().getParameters().get('RequestType');
         String createddatefrom = ApexPages.currentPage().getParameters().get('CreatedDateFrom');
         String createddateto = ApexPages.currentPage().getParameters().get('CreatedDateTo');
         String removaldatefrom = ApexPages.currentPage().getParameters().get('RemovalDateFrom');
         String removaldateto= ApexPages.currentPage().getParameters().get('RemovalDateTo');
         String approvaldatefrom= ApexPages.currentPage().getParameters().get('Approvaldatefrom');
         String approvaldateto = ApexPages.currentPage().getParameters().get('ApprovaldateTo');
         String status = ApexPages.currentPage().getParameters().get('Status'); 
         String servicenowortracking = ApexPages.currentPage().getParameters().get('ServiceNoworTracking');
         String assettag = ApexPages.currentPage().getParameters().get('AssetTag');
         String serialno= ApexPages.currentPage().getParameters().get('SerialNo');
         String closedby = ApexPages.currentPage().getParameters().get('ClosedBy');
         String approver = ApexPages.currentPage().getParameters().get('Approver');    
         String fromplace = ApexPages.currentPage().getParameters().get('From');
         String toplace = ApexPages.currentPage().getParameters().get('To');
         String documentattached = ApexPages.currentPage().getParameters().get('DocumentAttached');
        */
        
        
        
        requestid = ApexPages.currentPage().getParameters().get('RequestId');
        requestorname = ApexPages.currentPage().getParameters().get('RequestorName');
        requestorcreator= ApexPages.currentPage().getParameters().get('RequestorCreator');
        requestorregion = ApexPages.currentPage().getParameters().get('RequestorRegion');
        requesttype = ApexPages.currentPage().getParameters().get('RequestType');
        createddatefrom = ApexPages.currentPage().getParameters().get('CreatedDateFrom');
        createddateto = ApexPages.currentPage().getParameters().get('CreatedDateTo');
        removaldatefrom = ApexPages.currentPage().getParameters().get('RemovalDateFrom');
        removaldateto= ApexPages.currentPage().getParameters().get('RemovalDateTo');
        approvaldatefrom= ApexPages.currentPage().getParameters().get('Approvaldatefrom');
        approvaldateto = ApexPages.currentPage().getParameters().get('ApprovaldateTo');
        status = ApexPages.currentPage().getParameters().get('Status'); 
        servicenowortracking = ApexPages.currentPage().getParameters().get('ServiceNoworTracking');
        assettag = ApexPages.currentPage().getParameters().get('AssetTag');
        serialno= ApexPages.currentPage().getParameters().get('SerialNo');
        closedby = ApexPages.currentPage().getParameters().get('ClosedBy');
        approver = ApexPages.currentPage().getParameters().get('Approver');    
        fromplace = ApexPages.currentPage().getParameters().get('From');
        toplace = ApexPages.currentPage().getParameters().get('To');
        documentattached = ApexPages.currentPage().getParameters().get('DocumentAttached');
        description = ApexPages.currentPage().getParameters().get('Description');
        
        displayrecords();
             
             

    }
    
    public PageReference displayrecords()
    {
        String errorMessage1 ='';
        String errorMessage2 = '';
        String errorMessage3 = '';
        String exportmesg=null;
        //totalCount=null;
        
        exportlistPPRequest=new List<PR_Request__c>();
        
        //showlistPPRequest.clear();
        
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
        
        
        if((description!=null && description.trim()!='') || (assettag!=null && assettag.trim()!='') || (serialno!=null && serialno.trim()!='') )
         {
            Query+=',(select id,Request_Details__c,Asset_Tag__c,Serial_No__c,Description__c from propdetails__r where';
            
            
            if(description!=null && description.trim()!='')
            {
                Query+=' Description__c like  \'%'+description+'%\' AND ';
            }
        
            if(assettag!=null && assettag.trim()!='')
            {
                //Query+=' Asset_Tag__c like  \'%'+assettag+'%\' AND ';
                Query+=' Asset_Tag__c =\''+assettag+'\' AND ';
            }
            
            if(serialno!=null && serialno.trim()!='')
            {
                //Query+=' Serial_No__c like  \'%'+serialno+'%\' AND ';
                 Query+=' Serial_No__c =\''+serialno+'\' AND ';
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
        
        
        
        //Validations
        if(createddateto != null && createddateto.trim() != ''  && createddatefrom != null && createddatefrom.trim() != '') {
            system.debug('------------CreatedDateFrom ---------------'+CreatedDateFrom );
            system.debug('------------CreatedDateTo ---------------'+CreatedDateTo );
        
            dateComponents = createddatefrom.split('/',3);
            DtStart = Datetime.newInstancegmt(Integer.ValueOf(dateComponents[2]),Integer.ValueOf(dateComponents[0]),Integer.ValueOf(dateComponents[1]));
        
            dateComponents1=createddateto.split('/',3); 
            DtEnd=Datetime.newInstancegmt(Integer.ValueOf(dateComponents1[2]),Integer.ValueOf(dateComponents1[0]),Integer.ValueOf(dateComponents1[1]));
        
            if (DtStart.getTime() > DtEnd.getTime()) {
            errorMessage1 = 'The Created start date must be before the Created end date. Please select a valid date.';
               // return null;
            }
        }
        
        if(removaldatefrom!= null && removaldatefrom.trim() != ''  && removaldateto!= null && removaldateto.trim() != '') {
        
            removalStartDate =date.parse(removaldatefrom);
            removalDtStart2=Datetime.newInstanceGMT(removalStartDate.year(),removalStartDate.month(),removalStartDate.day());
            removalDtStart2=removalDtStart2.adddays(1);
        
            removalEndDate =date.parse(removaldateto); 
            removalDtEnd2=Datetime.newInstanceGMT(removalEndDate.year(),removalEndDate.month(),removalEndDate.day());
            removalDtEnd2=removalDtEnd2.adddays(1);
        
            if (removalDtStart2.getTime() > removalDtEnd2.getTime()) {
            errorMessage2 = 'The Removal start date must be before the Removal end date. Please select a valid date.';
               // return null;
            }
        }
        
        if(approvaldatefrom!= null && approvaldatefrom.trim() != ''  && approvaldateto!= null && approvaldateto.trim() != ''){
        
            dateApproval=approvaldatefrom.split('/',3);
            DtStart2=Datetime.newInstancegmt(Integer.ValueOf(dateApproval[2]),Integer.ValueOf(dateApproval[0]),Integer.ValueOf(dateApproval[1]));
        
            dateApproval1=approvaldateto.split('/',3); 
            DtEnd2=Datetime.newInstancegmt(Integer.ValueOf(dateApproval1[2]),Integer.ValueOf(dateApproval1[0]),Integer.ValueOf(dateApproval1[1]));
        
            if (DtStart2.getTime() > DtEnd2.getTime()) {
            errorMessage3 = 'The Approval start date must be before the Approval end date. Please select a valid date.';
               // return null;
            }
        }
        
        system.debug('***Inside filterRequest::RequestId:'+requestid);
        system.debug('***requestorname :'+ requestorname );
        system.debug('***requestorname :'+ requestorcreator);
        
        if(requestid!=null && requestid.trim() !=''){
            Query+=' Name  like \'%'+requestid+'%\' AND ';
        }
        
        if(requestorname !=null && requestorcreator==null){
            string a = requestorname;
            system.debug('------------Employee Request----------------'+a);
            Query+=' Employee_Requestee_Name__c =\''+a+'\' AND ';
        } 
        else if(requestorname ==null && requestorcreator!=null){
              String b=RequestorCreator;
              system.debug('------------Employee_Requestee_Name__c ----------------'+b);
              Query+=' Employee_Requestor_Name__c =\''+b+'\' AND ';
        }
        else if(requestorname !=null && requestorcreator!=null){
             String a=requestorname ;
             String b=requestorcreator;
             system.debug('------------Employee_Requestee_Name__c----------------'+a);
             system.debug('------------Employee_Requestor_Name__c----------------'+b);
             Query+=' Employee_Requestee_Name__c =\''+a+'\' and  Employee_Requestor_Name__c =\''+b+'\'  AND ';
        }  
        
        if(status!=null && status!='--None--'&& status!='None'){
            if(status=='Pending Approval'){
            Query+=' Status__c =\'Submitted\' AND ' ;
            }
            else if(status=='In Draft'){
            Query+=' Status__c =\'Saved\' AND ';
            }
            else if(status=='Rejected'){
            Query+=' Status__c =\'Rejected\' AND ';
            }
            else if(status=='Closed'){
            Query+=' Status__c =\'Closed\' AND ';
            }
            else if(status=='Recalled'){
            Query+=' Status__c =\'Recalled\' AND ';
            }
            else if(status=='Approved'){
            Query+=' Status__c =\'Approved\' AND ';
            }
            else if(status=='Cancelled'){
            Query+=' Status__c =\'Cancelled\' AND ';
            }
        }
        
        if(requestorregion!=null && requestorregion!='--None--' && requestorregion!='None'){
            if(requestorregion=='APAC'){
            //WHY ONLY FEW REGIONS FROM APAC????
            Query+=' (Requestor_Region__c =\'NJ\' OR Requestor_Region__c =\'JA\') AND ';
            }
            else if(requestorregion=='EMEA'){
            Query+=' Requestor_Region__c =\'EU\' AND ';
            }
            else if(requestorregion=='NA'){
            Query+=' Requestor_Region__c =\'NA\' AND ';
            }
        }
        system.debug('--------------requesttype--------------'+requesttype);
        
        if(requesttype!=null && requesttype!='--None--' && requesttype!='None' ){
            if(requesttype=='MS Office (Most common)'){
            Query+=' Request_Type__c=\'MS Office (Most common)\'AND ';
            }
            else if(requesttype.containsIgnoreCase('Tech')|| requesttype=='Technology (EDC & EUS only) '){
            Query+=' Request_Type__c=\'Technology (EDC & EUS only) \' AND ';
            }
            else if(requesttype=='Facilities/Move Mgmt (Prop Svcs only)'){
            Query+=' Request_Type__c=\'Facilities/Move Mgmt (Prop Svcs only)\' AND ';
            }
        }   
        
        if(createddatefrom!=null && createddatefrom!='' ){
            dateComponents=createddatefrom.split('/',3);
            DtStart=Datetime.newInstancegmt(Integer.ValueOf(dateComponents[2]),Integer.ValueOf(dateComponents[0]),Integer.ValueOf(dateComponents[1]));
            Query+=' CreatedDate >=: DtStart AND ';
        }
        
        if(createddateto!=null && createddateto!='' ){
            dateComponents1=createddateto.split('/',3); 
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
        if(removaldatefrom!= null && removaldatefrom.trim() != '' ){
            removalStartDate =date.parse(removaldatefrom);
            removalDtStart2=Datetime.newInstanceGMT(removalStartDate.year(),removalStartDate.month(),removalStartDate.day());
            removalDtStart2=removalDtStart2.adddays(1);
            Query+=' Removal_Date__c >=:removalStartDate AND';
        }
        system.debug('------------------Removal Start Date---------------'+removalStartDate);
        system.debug('------------------Removal Start Date--------------'+removalDtStart2);
        
        if(removaldateto!= null && removaldateto.trim() !='' ){
            removalEndDate =date.parse(removaldateto); 
            removalDtEnd2=Datetime.newInstanceGMT(removalEndDate.year(),removalEndDate.month(),removalEndDate.day());
            removalDtEnd2=removalDtEnd2.adddays(1);
            Query+=' Removal_Date__c <:removalEndDate AND';
        } 
        system.debug('------------------Removal End Date--------------'+removalEndDate);
        system.debug('------------------Removal End Date--------------'+removalDtEnd2);
        
        //approval dates
        if(approvaldatefrom!=null && approvaldatefrom!=''){
            dateApproval=approvaldatefrom.split('/',3);
            DtStart2=Datetime.newInstancegmt(Integer.ValueOf(dateApproval[2]),Integer.ValueOf(dateApproval[0]),Integer.ValueOf(dateApproval[1]));
            Query+=' Approval_Rejection_Date__c >=: DtStart2 AND ';
        }
        
        if(closedby!=null){
            String b=closedby;
            Query+=' ClosedBy__c =\''+b+'\' AND ';
        }
        
        if(approver!=null){
            String b=approver;
            system.debug('--------------Actual Approver--------------'+b);
            Query+=' ActualApprover__c =\''+b+'\' AND ';
        }
        
        if(fromplace!=null){
            String b=fromplace;
            Query+=' Location111__c =\''+b+'\' AND ';
        }
        
        if(toplace!=null && toplace!='--None--'){
            if(toplace=='Charitable Donation'){
            Query+=' Destination_Details__c=\'Charitable Donation\'AND ';
            }
            else if(toplace=='Disposal'){
            Query+=' Destination_Details__c=\'Disposal\' AND ';
            }
            else if(toplace=='Hiring Agency'){
            Query+=' Destination_Details__c=\'Hiring Agency\' AND ';
            }
            else if(toplace=='Home'){
            Query+=' Destination_Details__c=\'Home\' AND ';
            }
            else if(toplace=='MS Data Center'){
            Query+=' Destination_Details__c=\'MS Data Center\' AND ';
            }
            else if(toplace=='MS Office Building'){
            Query+=' Destination_Details__c=\'MS Office Building\' AND ';
            }
            else if(toplace=='Other'){
            Query+=' Destination_Details__c=\'Other\' AND ';
            }
            else if(toplace=='Vendor'){
            Query+=' Destination_Details__c=\'Vendor\' AND ';
            }
        }    
        
        if(servicenowortracking!=null && servicenowortracking!=''){
            Query+=' Equipment_Receipt_Confirm__c=\''+servicenowortracking+'\' AND ';
        }   
        
        if(documentattached!=null && documentattached.trim()!=''){
            if(documentattached=='yes'){
            Query+=' IsAttachment__c =true AND ';
            }
        
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
                System.debug('*********FinalQuery in filterRequest:'+exportlistPPRequest);

        if((description!=null && description.trim()!='') || (assettag!=null && assettag.trim()!='') || (serialno!=null && serialno.trim()!='') )
        {
            for(PR_Request__c p:prlist)
            {
                 if(p.propdetails__r != null && p.propdetails__r.size()>0)
                 {
                 System.debug('*********FinalQuery in listPPRequest:'+exportlistPPRequest);
                 exportlistPPRequest.add(p);
                 System.debug('*********FinalQuery in listPPRequest:'+exportlistPPRequest);

                 }
             }
                 
         }
                 
         else
         {
             exportlistPPRequest.addAll(prlist);
         }
        
        
        return null;
    }
}