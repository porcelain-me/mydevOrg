public class WV_ReportsMulitipleSheets{

    public string xmlheader {get;set;}
    public string endfile{get;set;}
    public string schemeId {get; set;}
    public string enrolmentId {get; set;}
    public List<Election__c> electionsList {get; set;}
    public List<ElectionsWrapper> ElectionWrapperList {get; set;}    
    public List<Response__c> ResponsesList {get; set;}
    public List<Response__c> ResponsesMultiList {get; set;}
    public Map<string,string> nameMap {get; set;}
    public Map<string,string> MultinameMap {get; set;}
    public Map<string,List<MultiListResponsesWrapper>> MultiListMap {get; set;}    
    public List<MultiListResponsesWrapper> MutliListWrapperList {get; set;}    
    public Map<string,Map<string,string>> ResponseMap {get; set;}
    public List<string> IdList {get; set;}
    public List<string> IdMultiList {get; set;}
    public string schemeName {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}

    public WV_ReportsMulitipleSheets() {
        try{
            xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
            endfile = '</Workbook>';
            schemeId = ApexPages.Currentpage().getParameters().get('id');
            enrolmentId = ApexPages.Currentpage().getParameters().get('eid');
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;            
            OrgName=Label.ORG_ENVIRONMENT;   
            
            if(schemeId != null){
                nameMap=new Map<string,string>();
                MultinameMap=new Map<string,string>();
                ResponseMap =new Map<string,Map<string,string>>();
                ElectionWrapperList =new List<ElectionsWrapper>();
                IdList =new List<string>();
                IdMultiList =new List<string>();
                
                List<scheme__c> scheme=[select id,name from scheme__c where Id=:schemeId];
                if(scheme != null && scheme.size() >0){
                    schemeName=scheme[0].name;
                }
                
                List<Input_Controls_Mapping__c> inputcontrolList=[select id,name,scheme__c,Input_Control_Type__c,order__c from Input_Controls_Mapping__c where scheme__c=:schemeId order by order__c ASC];
                
                if(inputcontrolList != null && inputcontrolList.size() >0){
                    for(Input_Controls_Mapping__c inputs:inputcontrolList){
                        if(inputs.Input_Control_Type__c=='List Capture' || inputs.Input_Control_Type__c=='Value Capture'){
                            nameMap.put(inputs.Id,inputs.name); 
                            IdList.add(inputs.Id);
                        } 
                        else{
                            MultinameMap.put(inputs.Id,inputs.name); 
                            IdMultiList.add(inputs.Id);
                        }    
                    }
                }
                                
                if(enrolmentId == null || enrolmentId.trim() ==''){
                    electionsList=[select id,name,Employee__c,Employee__r.emp_Id__c,Employee__r.name,isCancelled__c,Last_modified_date_time__c,Related_Enrolment__c,Related_Enrolment__r.name,Related_Enrolment__r.start_date__c,Related_Enrolment__r.end_date__c,Related_Enrolment__r.compensation_year__c,Scheme__c,Scheme__r.name,Scheme__r.Term__c,Scheme__r.Source__r.name,Scheme__r.Deferral__r.name,Scheme__r.Abacus_n__r.Value__c,Scheme__r.Scheme_Currency__r.Value__c,LastModifiedBy.name,LastModifiedBy.emp_ID__c,(select Id,name,Value_New__c,Input_Controls_Mapping__r.name,Input_Controls_Mapping__r.Input_Control_Type__c from Responses__r where (Input_Controls_Mapping__r.Input_Control_Type__c='List Capture' OR Input_Controls_Mapping__r.Input_Control_Type__c='Value Capture') order by Input_Controls_Mapping__r.order__c ASC)  from Election__c where Scheme__c=:schemeId AND isCancelled__c=false Order by name,Scheme__r.name ASC];
                    ResponsesMultiList=[select id,name,Election__c,Election__r.name,Election__r.Employee__c,Election__r.Employee__r.emp_Id__c,Election__r.Employee__r.name,Election__r.isCancelled__c,MultiListName__c,Value_New__c,Input_Controls_Mapping__c,Input_Controls_Mapping__r.name,Input_Controls_Mapping__r.Input_Control_Type__c,Election__r.Scheme__c,Election__r.Scheme__r.Source__r.name from Response__c where Election__r.Scheme__c=:schemeId AND Election__r.isCancelled__c=false AND Input_Controls_Mapping__r.Input_Control_Type__c='Multi Value Option Capture' Order by Election__r.name,Election__r.Scheme__r.name ASC];
                }
                else{
                     electionsList=[select id,name,Employee__c,Employee__r.emp_Id__c,Employee__r.name,isCancelled__c,Last_modified_date_time__c,Related_Enrolment__c,Related_Enrolment__r.name,Related_Enrolment__r.start_date__c,Related_Enrolment__r.end_date__c,Related_Enrolment__r.compensation_year__c,Scheme__c,Scheme__r.name,Scheme__r.Term__c,Scheme__r.Source__r.name,Scheme__r.Deferral__r.name,Scheme__r.Abacus_n__r.Value__c,Scheme__r.Scheme_Currency__r.Value__c,LastModifiedBy.name,LastModifiedBy.emp_ID__c,(select Id,name,Value_New__c,Input_Controls_Mapping__r.name,Input_Controls_Mapping__r.Input_Control_Type__c from Responses__r where (Input_Controls_Mapping__r.Input_Control_Type__c='List Capture' OR Input_Controls_Mapping__r.Input_Control_Type__c='Value Capture') order by Input_Controls_Mapping__r.order__c ASC)  from Election__c where Scheme__c=:schemeId AND Related_Enrolment__c=:enrolmentId AND isCancelled__c=false Order by name,Scheme__r.name ASC];
                     ResponsesMultiList=[select id,name,Election__c,Election__r.name,Election__r.Employee__c,Election__r.Employee__r.emp_Id__c,Election__r.Employee__r.name,Election__r.isCancelled__c,MultiListName__c,Value_New__c,Input_Controls_Mapping__c,Input_Controls_Mapping__r.name,Input_Controls_Mapping__r.Input_Control_Type__c,Election__r.Scheme__c,Election__r.Scheme__r.Source__r.name,Election__r.Related_Enrolment__c from Response__c where Election__r.Scheme__c=:schemeId AND Election__r.Related_Enrolment__c=:enrolmentId AND Election__r.isCancelled__c=false AND Input_Controls_Mapping__r.Input_Control_Type__c='Multi Value Option Capture' Order by Election__r.name,Election__r.Scheme__r.name ASC];
                }
                
                MultiListMap=new Map<string,List<MultiListResponsesWrapper>>();        
                
                if(ResponsesMultiList != null && ResponsesMultiList.size() > 0){
                        for(Response__c r:ResponsesMultiList){                
                            if(MultiListMap.containskey(r.Input_Controls_Mapping__c)){
                                MultiListMap.get(r.Input_Controls_Mapping__c).add(BindWrapper(r));
                            }
                            else{
                                List<MultiListResponsesWrapper> res=new List<MultiListResponsesWrapper>();
                                res.add(BindWrapper(r));
                                MultiListMap.put(r.Input_Controls_Mapping__c,res);
                            }
                        }
                }
                
                if(IdMultiList != null && IdMultiList.size() > 0){
                    for(string ss:IdMultiList){
                        if(!MultiListMap.containsKey(ss)){
                            List<MultiListResponsesWrapper> res1=new List<MultiListResponsesWrapper>();
                            MultiListMap.put(ss,res1);
                        }
                   }            
               }
                
                if(electionsList != null && electionsList.size() > 0){
                    for(Election__c e1:electionsList){ 
                        ElectionsWrapper eWrap=new ElectionsWrapper();
                        eWrap.EId=e1.Id;
                        eWrap.name=e1.name;
                        eWrap.schemeName =e1.Scheme__r.name;
                        eWrap.DeferralName =e1.Scheme__r.Deferral__r.name;
                        eWrap.SourceName =e1.Scheme__r.Source__r.name;
                        eWrap.CurrencyValue =e1.Scheme__r.Scheme_Currency__r.Value__c;
                        if(e1.Scheme__r.Abacus_n__r.Value__c != null){
                            eWrap.AbacusValue =String.ValueOf(e1.Scheme__r.Abacus_n__r.Value__c);
                        }
                        else{
                            eWrap.AbacusValue ='';
                        }
                        eWrap.Term =e1.Scheme__r.Term__c;
                        eWrap.EnrolmentName =e1.Related_Enrolment__r.name;
                        eWrap.EnrolCompensationYear =e1.Related_Enrolment__r.Compensation_Year__c;
                        if(e1.Related_Enrolment__r.Start_Date__c != null){
                            eWrap.EnrolStartDate =e1.Related_Enrolment__r.Start_Date__c.format();
                        }
                        else{
                            eWrap.EnrolStartDate ='';
                        }
                        if(e1.Related_Enrolment__r.End_Date__c != null){
                            eWrap.EnrolEndDate =e1.Related_Enrolment__r.End_Date__c.format();
                        }
                        else{
                            eWrap.EnrolEndDate ='';
                        }
                        eWrap.EmployeeMSID =e1.Employee__r.Emp_ID__c;
                        eWrap.EmployeeName =e1.Employee__r.name;
                        if(e1.Last_modified_date_time__c != null){
                            eWrap.LastModifiedDate=e1.Last_modified_date_time__c.format();
                        }
                        else{
                            eWrap.LastModifiedDate='';
                        }
                        eWrap.LastModifiedByName=e1.LastModifiedBy.name;
                        eWrap.LastModifiedByMSID=e1.LastModifiedBy.Emp_Id__c;
                        ElectionWrapperList.add(eWrap);
                        
                        for(string str:IdList){
                            for(Response__c re:e1.Responses__r){
                                if(ResponseMap.containsKey(e1.Id) && str==re.Input_Controls_Mapping__r.Id){                            
                                    ResponseMap.get(e1.Id).put(str,re.Value_New__c);
                                    break;
                                }
                                else if(str==re.Input_Controls_Mapping__r.Id){
                                    Map<string,string> maps=new Map<string,string>();
                                    maps.put(str,re.Value_New__c);
                                    ResponseMap.put(e1.Id,maps);
                                    break;
                                }                        
                            }  
                            if(!ResponseMap.containskey(e1.Id)){
                                Map<string,string> maps1=new Map<string,string>();
                                maps1.put(str,'');
                                ResponseMap.put(e1.Id,maps1);
                            }   
                            else if(!ResponseMap.get(e1.Id).containskey(str)){
                                ResponseMap.get(e1.Id).put(str,'');
                            }                 
                        }                   
                    }
                }      
            }
        }
        Catch(Exception e){
            system.debug('****exception in constructor of WV_ReportsMulitipleSheets()'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
        }
     }
     
     public class ElectionsWrapper{         
         public string name {get; set;}
         public Id EId{get; set;}
         public string schemeName {get; set;}
         public string DeferralName {get; set;}
         public string SourceName {get; set;}
         public string CurrencyValue {get; set;}
         public String AbacusValue {get; set;}
         public string Term {get; set;}         
         public string EnrolmentName {get; set;}
         public string EnrolCompensationYear {get; set;}
         public String EnrolStartDate {get; set;}
         public string EnrolEndDate {get; set;}
         public string EmployeeMSID {get; set;}
         public string EmployeeName {get; set;}
         public string LastModifiedDate{get; set;}
         public string LastModifiedByName{get; set;}
         public string LastModifiedByMSID{get; set;}    
     
     }
     
     public class MultiListResponsesWrapper{         
         public string name {get; set;}
         public string EmployeeMSID {get; set;}
         public string EmployeeName {get; set;}
         public string ControlName{get; set;}
         public string Value{get; set;}
         public String Split{get; set;}    
     
     }
     
     public MultiListResponsesWrapper BindWrapper(Response__c res){
         MultiListResponsesWrapper wrap=new MultiListResponsesWrapper();
         
         if(res != null){
             wrap.name=res.Election__r.name;
             wrap.EmployeeName =res.Election__r.Employee__r.name;
             wrap.EmployeeMSID =res.Election__r.Employee__r.Emp_ID__c;
             wrap.ControlName=res.Input_Controls_Mapping__r.name;
             wrap.Value=res.MultiListName__c;
             wrap.Split=res.Value_New__c;         
         }
         
         return wrap;
     }
     
     public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureExceptionFuture('My Elections','Reports-->Multisheet report-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }  
 
}