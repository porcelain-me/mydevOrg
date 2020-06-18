@isTest                                        //dummy class
public class WV_HomepageControllerdummy{

    public User LoggedInUser {get;set;}
    public Employee__c LoggedinEmployee {get;set;}
    public List<WV_ElectionsWrapper> ElectionsHistoryWrapperList{get; set;}
    public Map<String,List<WV_ElectionsWrapper>> ArrangedElectionsMap{get; set;}
    public boolean noElectionFlag {get; set;}
    public boolean noActiveSchemes {get; set;}
    public boolean noProxyAllowed {get; set;}
    public boolean noAccessAllowed {get; set;}
    public string proxyUserId;
    public Map<Id,Scheme__c> MyEligibleSchemes;
    public List<Scheme__c> MyEligibleSchemes_ordered {get; set;}    
    public Map<String,Map<string,Enrollment_Period__c>> CurrentSchemeenrolMap{get; set;}  
    public Map<String,Map<string,Map<String,List<Response__c>>>> currentEmployeeElectionOnScheme_New;    
    public Map<String,Map<string,Enrollment_Period__c>> pastYearSchemeenrolMap{get; set;}  
    public Map<String,Map<string,Map<String,List<Response__c>>>> pastYearEmployeeElectionOnScheme_New;  
    public List<String> orderedSourceList {get; set;}    
    public string selectedSource {get; set;}
    public string selectedSchemeId {get; set;}
    public string selectedEnrolment {get; set;}
    public boolean isAllOpenEnrolment {get; set;}     
    public Map<string,boolean> sourceListCalender {get; set;}
    public Map<string,string> sourceList {get; set;}
    public List<String> orderedSourceList1 {get; set;}
    public string CurrentSource {get; set;}
    public boolean showCalenderPick {get; set;}
    public string selectedSource_Calender {get; set;}    
    public boolean showHomePage {get; set;}
    public WV_SchemeWrapper SchemeWrapper{get; set;}
    public boolean flagCheck {get; set;}
    public boolean isTermsChecked{get; set;}    
    private final string tableCss=Label.WV_homepage_content_tabelcss;
    private final string thCss=Label.WV_homepage_content_thcss;
    private final string tdCss_Text=Label.WV_homepage_content_tdCss_Text;
    private final string tdCss_Number=Label.WV_homepage_content_tdCss_Number;    
    public string descriptionContent {get; set;}
    public string IntroductionContent {get; set;}
    public string TermsConditions {get; set;}
    public string linksContent {get;set;}
    public boolean showDescription {get; set;}
    public boolean submitErrorFlag {get; set;}
    public string TCError {get; set;}
    public Election__c election {get; set;}
    public Set<string> SchemeIds {get; set;}
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    public boolean isExpired {get; set;}
    public Map<string,Map<string,string>> parentControlsMap {get; set;}
    public Map<string,List<string>> parentChildMap {get; set;}
    public string electionId;
    public decimal totalControls {get; set;}
    public string pageIdentification  {get; set;}
    public string currencyDummy {get; set;}
    
    public string getlastYear(){
        return String.ValueOf(system.today().addyears(-1).year());
    } 
    
    public string getThisYear(){
        return String.ValueOf(system.today().year());
    }       
    
    public WV_HomepageControllerdummy(){        
        try{
            ArrangedElectionsMap=new Map<string,List<WV_ElectionsWrapper>>();     
            orderedSourceList=new List<String>();
            sourceListCalender =new map<string,boolean>();
            sourceList =new Map<String,String>();
            orderedSourceList1=new List<String>();  
            SchemeIds=new set<string>();  
            set<string> monthset;
            set<string> monthset1;
            Set<String> currentEnrolmentResponseIdSet=new Set<String>();
            Set<String> pastEnrolmentResponseIdSet=new Set<String>();
            Map<string,List<response__c>> currentElectionMap=new Map<string,List<response__c>>();
            Map<string,List<response__c>> pastElectionMap=new Map<string,List<response__c>>();
            List<Response__c> currentResponselist;
            List<Response__c> pastResponselist; 
            
            
            noElectionFlag=false;
            noActiveSchemes=false;
            noProxyAllowed =false;
            noAccessAllowed = false;            
            selectedSource='';
            selectedSchemeId ='';
            isAllOpenEnrolment=true;                    
            showCalenderPick=false;
            CurrentSource='All';           
            showHomePage = true;
            showDescription=false;
            TCError='';            
            customPageMessage =null;
            exp=null;        
            electionId =null;              
            pageIdentification='home';
            currencyDummy=null;            
            IntroductionContent='';
            descriptionContent='';
            TermsConditions='';
            linksContent ='';            
            
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;            
            OrgName=Label.ORG_ENVIRONMENT;                             
            LoggedInUser = WV_Utility.getLoggedinUserDetails(UserInfo.getUserId());
            proxyUserId= ApexPages.Currentpage().getParameters().get('uid');
                        
            if(proxyUserId != null && proxyUserId != '' && proxyUserId.trim() != ''){
                Map<Id,Permissionset> adminPermissionSets=new Map<Id,Permissionset>([select id,name,label from permissionset where name='My_Elections_Biz_Admin' OR name='My_Elections_Scheme_Admin' OR name='My_Elections_HRSC_admin']);    
                if(adminPermissionSets != null && adminPermissionSets.keyset() != null && adminPermissionSets.keyset().size() > 0){
                    List<permissionsetAssignment> adminUsersList=[select id,assigneeid,permissionsetid from permissionsetAssignment where permissionsetid IN:adminPermissionSets.keyset() AND assigneeid=:LoggedInUser.Id];
                    if((adminUsersList == null || adminUsersList.size() == 0) && Test.isRunningtest()==false){
                        noProxyAllowed=true;   
                    }
                    else{
                        LoggedInUser = WV_Utility.getLoggedinUserDetails(proxyUserId);
                    }
                    adminUsersList=null;
                }
                adminPermissionSets=null; 
            }                       
            
            if(LoggedInUser !=null){
                LoggedinEmployee = WV_Utility.getLoggedinEmployeeDetails(LoggedInUser.Emp_Id__c);
            }
            if(LoggedinEmployee != null){
                if(noProxyAllowed==false){
                    SchemeIds=WV_Utility.getLoggedinEmployeeEligibleSchemes(LoggedinEmployee); 
                    if(SchemeIds == null || SchemeIds.size() == 0){
                        noActiveSchemes=true;
                    }
                }
            } 
            else{
                noAccessAllowed = true;
            }
            
           
            if(SchemeIds != null && SchemeIds.size() > 0  && noProxyAllowed==false && noAccessAllowed==false){
                MyEligibleSchemes=WV_Utility.getSchemeDetails(SchemeIds);                
                MyEligibleSchemes_ordered=WV_Utility.getSchemeDetail(SchemeIds); 
                
                Map<string,Integer> recentyearMap=WV_Utility.getLastEnrolment(SchemeIds);
                CurrentSchemeenrolMap=WV_Utility.getCurrentSchemeEnrolment(SchemeIds,recentyearMap);
                currentEmployeeElectionOnScheme_New=WV_Utility.getResponseOnSchemesOnEnrolment_New(MyEligibleSchemes,CurrentSchemeenrolMap,LoggedinEmployee,system.today().year());

                Map<string,Integer> pastYearMap=WV_Utility.getPASTEnrolment(CurrentSchemeenrolMap);
                pastYearSchemeenrolMap=WV_Utility.getCurrentSchemeEnrolment(SchemeIds,pastYearMap);
                pastYearEmployeeElectionOnScheme_New=WV_Utility.getResponseOnSchemesOnEnrolment_New(MyEligibleSchemes,pastYearSchemeenrolMap,LoggedinEmployee,system.today().addyears(-1).year());         
                
            }
         
            if(MyEligibleSchemes_ordered != null && MyEligibleSchemes_ordered.size() > 0  && noProxyAllowed==false && noAccessAllowed==false){             
                for(Scheme__c q:MyEligibleSchemes_ordered){                    
                    WV_ElectionsWrapper history=new WV_ElectionsWrapper(); 
                    history.currentYearEnrolments =new List<WV_EnrolmentResponses>();
                    history.pastYearEnrolments =new List<WV_EnrolmentResponses>();
                    history.SchemeId=q.Id;
                    history.SchemeName=q.Name;
                    history.SourceId=q.Source__c;
                    history.SchemeDescription=q.Description__c;
                    history.SchemeDescriptionWithoutEnrolment=history.SchemeDescription;
                    history.SchemeDescriptionWithEnrolment=history.SchemeDescription;
                    if(history.SchemeDescription != null && history.SchemeDescription.length() > 125){
                        history.SchemeDescriptionWithoutEnrolment=history.SchemeDescription.substring(0,125);
                        history.SchemeDescriptionWithoutEnrolment=history.SchemeDescriptionWithoutEnrolment+'..';
                        history.showmoreLinkWithoutEnrolment=true;
                    }
                    if(history.SchemeDescription != null && history.SchemeDescription.length() > 50){
                        history.SchemeDescriptionWithEnrolment=history.SchemeDescription.substring(0,50);
                        history.SchemeDescriptionWithEnrolment=history.SchemeDescriptionWithEnrolment+'..';
                        history.showmoreLinkWithEnrolment=true;
                    }
                    history.SourceName=q.Source__r.Name;
                    history.SourceOrder=q.Source__r.Source_Order__c;
                    history.DeferralId=q.Deferral__c;
                    history.DeferralName=q.Deferral__r.name;
                    history.TemplateId=q.Waiver_Template__c;
                    history.TemplateName=q.Waiver_Template__r.Name;
                    history.schemeCurrency=q.Scheme_Currency__c;
                    history.schemeCurrency_Code=q.Scheme_Currency__r.Value__c;
                    
                    if(CurrentSchemeenrolMap != null && CurrentSchemeenrolMap.keyset() != null && CurrentSchemeenrolMap.keyset().size() > 0 && CurrentSchemeenrolMap.containsKey(q.Id)){
                        boolean flagActive=false;
                        monthset=new set<string>();
                        monthset1=new set<string>();
                        integer k=0; 
                        for(string s:CurrentSchemeenrolMap.get(q.Id).keyset()){                            
                            WV_EnrolmentResponses res=new WV_EnrolmentResponses();
                            res.SchemeId=q.Id;
                            res.SchemeName=q.Name;
                            if(s=='open'){
                                res.EnrolmentEndDate=null;
                                res.isActive=true;
                            }
                            else{
                                Enrollment_Period__c enrol=CurrentSchemeenrolMap.get(q.Id).get(s);
                                res.EnrolmentEndDate=enrol.end_date__c;
                                res.EnrolmentStartDate=enrol.start_date__c;
                                res.EnrolmentEndDate_Str = enrol.end_date__c.format('MMM dd, yyyy');
                                res.EnrolmentEndDate_Str_CalenderFormat = enrol.end_date__c.format('MMM');
                                res.EnrolmentEndDateDay_Str_CalenderFormat = enrol.end_date__c.format('dd');
                                res.EnrolmentName=enrol.start_date__c.format('MMM');
                                if(monthset.contains(res.EnrolmentName)){
                                    monthset1.add(res.EnrolmentName);
                                }
                                else{
                                    monthset.add(res.EnrolmentName);
                                }
                                res.enrolmentId=enrol.Id;
                                if(enrol.start_date__c <= system.now() && enrol.end_date__c >= system.now()){
                                    isAllOpenEnrolment=false;
                                    history.isAllOpenEnrolment=false;
                                    res.isActive=true;
                                    k++;
                                }
                                else if(enrol.start_date__c > system.now()){
                                    res.isFutureOne=true;
                                }
                                else{
                                    res.isPast=true;
                                    k++;
                                }
                            }
                            if(res.isActive==true){
                                res.isOnFocus=true;
                                flagActive=true;
                            }
                            else{
                                res.isOnFocus=false;
                            }
                            
                            if(currentEmployeeElectionOnScheme_New != null && currentEmployeeElectionOnScheme_New.keyset() != null && currentEmployeeElectionOnScheme_New.keyset().size() > 0 && currentEmployeeElectionOnScheme_New.containsKey(q.Id) && currentEmployeeElectionOnScheme_New.get(q.Id) != null && currentEmployeeElectionOnScheme_New.get(q.Id).containsKey(s)){
                                for(List<Response__c> newResp:currentEmployeeElectionOnScheme_New.get(q.Id).get(s).values()){
                                    res.Responses_New.addAll(newResp);
                                    for(Response__c r:newResp){
                                        currentEnrolmentResponseIdSet.add(r.Id);
                                        if(r.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture' && r.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && !res.MulilistValueOrder.containsKey(r.Input_Controls_Mapping__c)){
                                            if(r.Input_Controls_Mapping__r.Custom_Data_Values__c != null){
                                                string dummy=r.Input_Controls_Mapping__r.Custom_Data_Values__c.replaceAll('\r\n','\n');
                                                List<string> allListNew=dummy.split('\n');
                                                List<string> allList=new List<string>();
                                                if(allListNew != null && allListNew.size() >0){
                                                    for(string str:allListNew){
                                                        allList.add(str.trim());
                                                    }
                                                    allListNew.clear();
                                                }
                                                res.MulilistValueOrder.put(r.Input_Controls_Mapping__c,allList);    
                                            }        
                                        }
                                    }
                                }  
                                
                                if(res.Responses_New != null && res.Responses_New.size() >0){   
                                    res.ElectionId=res.Responses_New[0].Election__c;   
                                    res.LastModifiedDateDt=res.Responses_New[0].Election__r.LastModifiedDate; 
                                     
                                    res.LastModifiedDate=res.Responses_New[0].Election__r.LastModifiedDate.format('MMM dd, yyyy');  
                                    res.LastModifiedDate_calender=res.Responses_New[0].Election__r.LastModifiedDate.format('MMM d,yyyy');  
                                    
                                    res.LastModifiedBy=res.Responses_New[0].Election__r.LastModifiedBy.name;  
                                    
                                    history.isElected=true;
                                    for(Response__c resp:res.Responses_New){
                                        if(resp.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary'){
                                            res.isSecondaryControlsPresent=true;
                                            break;
                                        }
                                    }
                                }
                            }
                            else{
                                res.Responses_New=null;
                                res.ElectionId=null;
                            }  
                            history.currentYearEnrolments.add(res);                                       
                        }     
                        history.currentYearEnrolments.sort();                 
                        
                        Integer i=1;
                        for(WV_EnrolmentResponses Response:history.currentYearEnrolments){                            
                            if(Response.EnrolmentStartDate != null && monthset1.contains(Response.EnrolmentName)){
                                Response.EnrolmentName=Response.EnrolmentStartDate.format('dd-')+Response.EnrolmentName;
                            }
                            if(Response.isFutureOne==false && k==i){                                
                                if(flagActive==false){
                                    Response.isOnFocus=true;
                                }
                                if(Response.EnrolmentStartDate != null){
                                    history.RecentYear=string.ValueOf(Response.EnrolmentStartDate.year());
                                }
                                else{
                                    history.RecentYear=string.ValueOf(system.now().year());
                                }                                
                           }     
                           i++;                       
                        }                                                                    
                    }
                    
                    if(pastYearSchemeenrolMap != null && pastYearSchemeenrolMap.keyset() != null && pastYearSchemeenrolMap.keyset().size() > 0 && pastYearSchemeenrolMap.containsKey(q.Id)){
                        monthset=new set<string>();
                        monthset1=new set<string>(); 
                        for(string s1:pastYearSchemeenrolMap.get(q.Id).keyset()){
                            if(s1!='open'){
                                WV_EnrolmentResponses res1=new WV_EnrolmentResponses();
                                res1.SchemeId=q.Id;
                                res1.SchemeName=q.Name;
                                Enrollment_Period__c enrol1=pastYearSchemeenrolMap.get(q.Id).get(s1);
                                res1.EnrolmentStartDate=enrol1.start_date__c;
                                res1.EnrolmentEndDate=enrol1.end_date__c;
                                res1.EnrolmentEndDate_Str = enrol1.end_date__c.format('MMM dd, yyyy');  
                                res1.EnrolmentEndDate_Str_CalenderFormat = enrol1.end_date__c.format('MMM');
                                res1.EnrolmentEndDateDay_Str_CalenderFormat = enrol1.end_date__c.format('dd');
                                res1.isActive=enrol1.Active_auto__c;
                                res1.EnrolmentName=enrol1.start_date__c.format('MMM');
                                if(monthset.contains(res1.EnrolmentName)){
                                    monthset1.add(res1.EnrolmentName);
                                }
                                else{
                                    monthset.add(res1.EnrolmentName);
                                }
                                
                                if(pastYearEmployeeElectionOnScheme_New != null && pastYearEmployeeElectionOnScheme_New.keyset() != null && pastYearEmployeeElectionOnScheme_New.keyset().size() > 0 && pastYearEmployeeElectionOnScheme_New.containsKey(q.Id) && pastYearEmployeeElectionOnScheme_New.get(q.Id) != null && pastYearEmployeeElectionOnScheme_New.get(q.Id).containsKey(s1)){
                                    for(List<Response__c> newResp:pastYearEmployeeElectionOnScheme_New.get(q.Id).get(s1).values()){
                                        res1.Responses_New.addAll(newResp);
                                        for(Response__c r:newResp){
                                            pastEnrolmentResponseIdSet.add(r.Id);
                                            if(r.Input_Controls_Mapping__r.Input_Control_Type__c=='Multi Value Option Capture'  && r.Input_Controls_Mapping__r.Control_Visibility__c=='Secondary' && !res1.MulilistValueOrder.containsKey(r.Input_Controls_Mapping__c)){
                                                if(r.Input_Controls_Mapping__r.Custom_Data_Values__c != null){
                                                    string dummy1=r.Input_Controls_Mapping__r.Custom_Data_Values__c.replaceAll('\r\n','\n');
                                                    List<string> allList1New=dummy1.split('\n');
                                                    List<string> allList1=new List<string>();
                                                    if(allList1New != null && allList1New.size() >0){
                                                        for(string str:allList1New){
                                                            allList1.add(str.trim());
                                                        }
                                                        allList1New.clear();
                                                    }
                                                    res1.MulilistValueOrder.put(r.Input_Controls_Mapping__c,allList1);    
                                                }        
                                            }
                                        }
                                    }   
                                    
                                    if(res1.Responses_New != null && res1.Responses_New.size() >0){     
                                        res1.ElectionId=res1.Responses_New[0].Election__c;   
                                        res1.LastModifiedDateDt=res1.Responses_New[0].Election__r.LastModifiedDate;                                      
                                        res1.LastModifiedDate=res1.Responses_New[0].Election__r.LastModifiedDate.format('MMM dd, yyyy');  
                                        res1.LastModifiedDate_calender=res1.Responses_New[0].Election__r.LastModifiedDate.format('MMM d,yyyy');                                 
                                        res1.LastModifiedBy=res1.Responses_New[0].Election__r.LastModifiedBy.name;  
                                    }
                                    history.pastYearEnrolments.add(res1); 
                                }
                                else{
                                    res1.Responses_New=null;
                                    res1.ElectionId=null;
                                }  
                            }                    
                        } 
                        
                        history.pastYearEnrolments.sort(); 
                        for(WV_EnrolmentResponses Response1:history.pastYearEnrolments){
                            if(Response1.EnrolmentStartDate != null && monthset1.contains(Response1.EnrolmentName)){
                                Response1.EnrolmentName=Response1.EnrolmentStartDate.format('dd-')+Response1.EnrolmentName;
                            }
                            if(Response1.EnrolmentStartDate != null){
                                history.PastYear=string.ValueOf(Response1.EnrolmentStartDate.year());
                            }
                        }                                       
                    }        
                    
                    
                    if(currentEmployeeElectionOnScheme_New != null && pastYearEmployeeElectionOnScheme_New != null && !currentEmployeeElectionOnScheme_New.containskey(q.Id) && !pastYearEmployeeElectionOnScheme_New.containskey(q.Id)){  
                        history.isNew=true;
                    }
                    else{
                        history.isNew=false;
                    }
                    
                    if(ArrangedElectionsMap.containsKey(q.Source__c)){
                        ArrangedElectionsMap.get(q.Source__c).add(history);
                    }                 
                    else{
                        List<WV_ElectionsWrapper> ElectionsHistoryWrapperList=new List<WV_ElectionsWrapper>();
                        ElectionsHistoryWrapperList.add(history);
                        ArrangedElectionsMap.put(q.Source__c,ElectionsHistoryWrapperList);
                        orderedSourceList.add(q.Source__c);     
                    }
                }
                
                orderedSourceList1.add('All');  
                
                if(currentEnrolmentResponseIdSet.size()>0){
                    currentResponselist=[select id,name,IsNumberControl_Internal_Use__c,MultiListName__c,value_new__c,Show_Currency_Percentage__c,Input_Controls_Mapping__c,Input_Controls_Mapping__r.Waiver_Template__c,Input_Controls_Mapping__r.name,Input_Controls_Mapping__r.Custom_Max__c,Input_Controls_Mapping__r.Custom_Min__c,Input_Controls_Mapping__r.Custom_Data_Values__c,Input_Controls_Mapping__r.Default_Maximum_Value__c,Input_Controls_Mapping__r.Default_Minimum_Value__c,Input_Controls_Mapping__r.order__c,Input_Controls_Mapping__r.Required__c,Input_Controls_Mapping__r.Input_Control_Type__c,Input_Controls_Mapping__r.Value_Type__c,Input_Controls_Mapping__r.Scheme__c,Input_Controls_Mapping__r.Show_Currency__c,Election__c,Election__r.Employee__c,Election__r.LastModifiedDate,Election__r.LastModifiedBy.Name,LastModifiedDate,LastModifiedBy.name,Election__r.isCancelled__c,Election__r.Related_Enrolment__c,Election__r.Related_Enrolment__r.start_date__c,Election__r.Related_Enrolment__r.end_date__c,Election__r.scheme__c,Input_Controls_Mapping__r.Control_Visibility__c from Response__c where Id IN:currentEnrolmentResponseIdSet ORDER BY Election__c,Input_Controls_Mapping__r.order__c ASC];
                }
                if(pastEnrolmentResponseIdSet.size()>0){
                    pastResponselist=[select id,name,IsNumberControl_Internal_Use__c,MultiListName__c,value_new__c,Show_Currency_Percentage__c,Input_Controls_Mapping__c,Input_Controls_Mapping__r.Waiver_Template__c,Input_Controls_Mapping__r.name,Input_Controls_Mapping__r.Custom_Max__c,Input_Controls_Mapping__r.Custom_Min__c,Input_Controls_Mapping__r.Custom_Data_Values__c,Input_Controls_Mapping__r.Default_Maximum_Value__c,Input_Controls_Mapping__r.Default_Minimum_Value__c,Input_Controls_Mapping__r.order__c,Input_Controls_Mapping__r.Required__c,Input_Controls_Mapping__r.Input_Control_Type__c,Input_Controls_Mapping__r.Value_Type__c,Input_Controls_Mapping__r.Scheme__c,Input_Controls_Mapping__r.Show_Currency__c,Election__c,Election__r.Employee__c,Election__r.LastModifiedDate,Election__r.LastModifiedBy.Name,LastModifiedDate,LastModifiedBy.name,Election__r.isCancelled__c,Election__r.Related_Enrolment__c,Election__r.Related_Enrolment__r.start_date__c,Election__r.Related_Enrolment__r.end_date__c,Election__r.scheme__c,Input_Controls_Mapping__r.Control_Visibility__c from Response__c where Id IN:pastEnrolmentResponseIdSet ORDER BY Election__c,Input_Controls_Mapping__r.order__c ASC];
                }
                
                if(currentResponselist != null && currentResponselist.size()>0){
                    for(Response__c cRes:currentResponselist){
                        if(currentElectionMap.containsKey(cRes.Election__c)){
                            currentElectionMap.get(cRes.Election__c).add(cRes);
                        }
                        else{
                            List<Response__c> resp=new List<Response__c>();
                            resp.add(cRes);
                            currentElectionMap.put(cRes.Election__c,resp);
                        }                    
                    }
                }
                
                if(pastResponselist != null && pastResponselist.size()>0){
                    for(Response__c pRes:pastResponselist){
                        if(pastElectionMap.containsKey(pRes.Election__c)){
                            pastElectionMap.get(pRes.Election__c).add(pRes);
                        }
                        else{
                            List<Response__c> resp1=new List<Response__c>();
                            resp1.add(pRes);
                            pastElectionMap.put(pRes.Election__c,resp1);
                        }                    
                    }
                }  
                        
                for(string d:ArrangedElectionsMap.keyset()){  
                    orderedSourceList1.add(d);              
                    for(WV_ElectionsWrapper w:ArrangedElectionsMap.get(d)){
                        if(w.isAllOpenEnrolment==false){
                            sourceListCalender.put(w.SourceId,true);
                        }
                        else if(sourceListCalender.containskey(w.SourceId)){
                        
                        }
                        else{
                            sourceListCalender.put(w.SourceId,false);
                        }
                        sourceList.put(w.SourceId,w.SourceName);
                        
                        if(w.currentYearEnrolments != null && w.currentYearEnrolments.size()>0){
                            for(WV_EnrolmentResponses Enrolres:w.currentYearEnrolments){
                                if(Enrolres.Responses_New != null && Enrolres.Responses_New.size()>0 && currentElectionMap.containsKey(Enrolres.ElectionId)){
                                    Enrolres.Responses_New= currentElectionMap.get(Enrolres.ElectionId);    
                                }                            
                            }
                        }
                        if(w.pastYearEnrolments != null && w.pastYearEnrolments.size()>0){
                            for(WV_EnrolmentResponses EnrolresP:w.pastYearEnrolments){
                                if(EnrolresP.Responses_New != null && EnrolresP.Responses_New.size()>0 && pastElectionMap.containsKey(EnrolresP.ElectionId)){
                                    EnrolresP.Responses_New= pastElectionMap.get(EnrolresP.ElectionId);     
                                }                            
                            }
                        }
                        
                    }
                }
                if(sourceList.size()>0){
                    sourceListCalender.put('All',true);
                    sourceList.put('All','All');
                }                
            }            
            
            if(ArrangedElectionsMap != null && ArrangedElectionsMap.keyset().size() == 0  && noProxyAllowed==false && noAccessAllowed==false){
                noElectionFlag=true;         
            }
            currentElectionMap=null;
            pastElectionMap=null;
            currentResponselist=null;
            pastResponselist=null;   
        }
        catch(Exception e){
            system.debug('*****Exception in constructor of Home page WV_HomepageController()'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';    
        }
    }
    
    public void getSchemeDetails(List<Scheme__c> Schemes){
                    
        List<WV_SchemeWrapper> selectedSchemeWrapper=new List<WV_SchemeWrapper>();
        Map<String,List<Input_Controls_Mapping__c>> InputcontrolMap=new Map<String,List<Input_Controls_Mapping__c>>();
        Map<string,List<WV_InputControl>> InputcontrolSchemeMap=new Map<string,List<WV_InputControl>>();
        List<Input_Controls_Mapping__c> InputControlList;
        Set<string> applicablefileList=new Set<string>();
        Map<String,Map<string,string>> fileMap;
        Map<String,List<Wav_Custom_data__c>> customdataMap;
        List<string> tempList;
        set<Id> schemeIdset=new set<Id>();

        boolean flagCheck_dummy;
        flagCheck=false;
        TCError='';
        isTermsChecked=false;                        
        electionId=null;
        totalControls=0;
        pageIdentification='detail';
        currencyDummy=null;
        
        if(Schemes != null && Schemes.size () >0){
            for(Scheme__c e:Schemes){
                if(e.Id==selectedSchemeId){
                    schemeIdset.add(e.Id);
                    WV_SchemeWrapper w=new WV_SchemeWrapper();
                    w.name=e.name;
                    w.Description=e.Description__c;  
                    w.SchemeId=e.Id; 
                    w.Source=e.Source__r.name; 
                    w.SourceId=e.Source__r.Id;
                    w.Source_Status=e.Source__r.Active__c; 
                    w.Deferral=e.Deferral__r.name; 
                    w.Deferral_Status=e.Deferral__r.Active__c; 
                    w.TemplateId=e.Waiver_Template__c;
                    w.schemeCurrency=e.Scheme_Currency__c;
                    w.schemeCurrency_Status=e.Scheme_Currency__r.Active__c;
                    w.schemeCurrency_Code=e.Scheme_Currency__r.Value__c;
                    currencyDummy=e.Scheme_Currency__r.Value__c;
                    w.Abacus=e.Abacus_n__c;
                    w.Abacus_Value =e.Abacus_n__r.Value__c;
                    w.ErrorMessage='';
                    w.relatedYear=string.ValueOf(system.today().year());
                    
                    if(currentEmployeeElectionOnScheme_New != null && currentEmployeeElectionOnScheme_New.keyset() != null && currentEmployeeElectionOnScheme_New.keyset().size() > 0 && currentEmployeeElectionOnScheme_New.containsKey(e.Id) && currentEmployeeElectionOnScheme_New.get(e.Id) != null && currentEmployeeElectionOnScheme_New.get(e.Id).containsKey(selectedEnrolment) && currentEmployeeElectionOnScheme_New.get(e.Id).get(selectedEnrolment) != null && currentEmployeeElectionOnScheme_New.get(e.Id).get(selectedEnrolment).keyset() != null && currentEmployeeElectionOnScheme_New.get(e.Id).get(selectedEnrolment).keyset().size() >0 && currentEmployeeElectionOnScheme_New.get(e.Id).get(selectedEnrolment).values() != null && currentEmployeeElectionOnScheme_New.get(e.Id).get(selectedEnrolment).values().size() >0){
                            List<Response__c> res=currentEmployeeElectionOnScheme_New.get(e.Id).get(selectedEnrolment).values()[0];    
                            w.lastmodifiedBy=res[0].Election__r.LastModifiedBy.name;
                            w.lastmodifiedDate=res[0].Election__r.LastModifiedDate; 
                            electionId=res[0].Election__c;
                    }
                    else{
                        w.lastmodifiedBy=null;
                        w.lastmodifiedDate=null;
                        electionId=null;
                    }   
                    
                    if(selectedEnrolment=='open'){
                        w.enrolmentLastdate=null;  
                        w.enrolmentId=null;                         
                    }
                    else if(CurrentSchemeenrolMap.containsKey(e.Id) && CurrentSchemeenrolMap.get(e.Id) != null && CurrentSchemeenrolMap.get(e.Id).containsKey(selectedEnrolment) && CurrentSchemeenrolMap.get(e.Id).get(selectedEnrolment) != null){
                        Enrollment_Period__c enrol=CurrentSchemeenrolMap.get(e.Id).get(selectedEnrolment);
                        w.enrolmentLastdate=enrol.end_date__c;                    
                        w.enrolmentLastdate_Month=enrol.end_date__c.format('MMMM');
                        w.enrolmentLastdate_Day=enrol.end_date__c.format('d');
                        w.enrolmentLastdate_TimeandZone=enrol.end_date__c.format('hh a z');                        
                        w.enrolmentId=enrol.Id;
                        w.relatedYear=string.ValueOf(enrol.start_date__c.year());
                    }
                    
                    if(currentEmployeeElectionOnScheme_New != null && pastYearEmployeeElectionOnScheme_New != null && !currentEmployeeElectionOnScheme_New.containskey(e.Id) && !pastYearEmployeeElectionOnScheme_New.containskey(e.Id)){  
                        w.isNew=true;
                        showDescription =true;
                    }
                    else{
                        w.isNew=false;
                        showDescription =false;
                    }
                            
                    selectedSchemeWrapper.add(w);                     
                    break;
                }
            }
        }
                  
        if(schemeIdset.size() > 0){
            InputControlList=WV_Utility.getInputControl(schemeIdset);
        }            
        
        if(InputControlList != null && InputControlList.size() > 0){
            for(Input_Controls_Mapping__c I:InputControlList){
                
                if(I.Custom_Min__c != null && I.Custom_Min__c != '' && I.Custom_Min__c.split(',',2) != null && I.Custom_Min__c.split(',',2).size() ==2){
                    applicablefileList.add(I.Custom_Min__c.split(',',2)[0]);
                }
                if(I.Custom_Max__c != null && I.Custom_Max__c != '' && I.Custom_Max__c.split(',',2) != null && I.Custom_Max__c.split(',',2).size() ==2){
                    applicablefileList.add(I.Custom_Max__c.split(',',2)[0]);
                }
                
                if(InputcontrolMap.containsKey(I.Scheme__c)){
                    InputcontrolMap.get(I.Scheme__c).add(I);
                }
                else{
                    List<Input_Controls_Mapping__c> Each=new List<Input_Controls_Mapping__c>();
                    Each.add(I);
                    InputcontrolMap.put(I.Scheme__c,Each);
                }
            }
        } 
        
        if(applicablefileList != null && applicablefileList.size() >0){
            fileMap=WV_Utility.getCustomDataFiles(applicablefileList);
            if(fileMap != null && fileMap.keyset() != null){
                customdataMap=WV_Utility.getCustomDataMaps(fileMap.keyset(),LoggedinEmployee.emp_Id__c);  
            }
        }          
        
        if(InputcontrolMap != null && InputcontrolMap.keyset() != null && InputcontrolMap.keyset().size() > 0){   
            parentControlsMap=new Map<string,Map<string,string>>();
            parentChildMap =new Map<string,List<string>>();
            
            for(String d:InputcontrolMap.keyset()){            
                List<WV_InputControl> ControlList=new List<WV_InputControl>();
                Integer j=1;
                totalControls=InputcontrolMap.get(d).size();
                for(Input_Controls_Mapping__c e:InputcontrolMap.get(d)){
                    WV_InputControl eachinput=new WV_InputControl();
                    eachinput.recordtype=e.Input_Control_Type__c;
                    eachinput.RecordId=e.Id;
                    eachinput.name=e.name;
                    eachinput.IsMandatory=e.Required__c;
                    eachinput.ValueType=e.Value_Type__c;
                    eachinput.DefaultValueType=e.Value_Type__c;
                    eachinput.showCurrency=e.Show_Currency__c;
                    
                    if(eachinput.recordtype!='Multi Value Option Capture'){
                        eachinput.orderNumber=String.ValueOf(math.mod(j,2));
                        j++;   
                    }
                    else{
                        eachinput.orderNumber='none';
                    }
                    
                    if(e.Default_Maximum_Value__c !=null){
                        eachinput.maxlimit=e.Default_Maximum_Value__c ;
                    }
                    else{
                        eachinput.maxlimit=null;
                    }
                    
                    if(e.Default_Minimum_Value__c !=null){
                        eachinput.minlimit=e.Default_Minimum_Value__c ;
                    }
                    else{
                        eachinput.minlimit=null;
                    }
                    
                    if(e.Custom_Max__c != null && e.Custom_Max__c != ''){                              
                        tempList=e.Custom_Max__c.split(',',2);
                        if(tempList != null && tempList.size()==2 && tempList[0] != null && tempList[1] != null){
                            tempList[0]=tempList[0].trim();
                            tempList[1]=tempList[1].trim();
                            if(customdataMap != null && customdataMap.keyset() != null && customdataMap.containsKey(tempList[0]) ){
                                if(customdataMap.get( tempList[0] ) != null && customdataMap.get( tempList[0] ).size()>0 ){
                                    String max_val=String.ValueOf( customdataMap.get( tempList[0] )[0].get( tempList[1] ) );                                        
                                    if(max_val != null && max_val.trim() != '' && max_val.contains(',')){
                                        max_val=max_val.replaceAll(',','').trim();
                                    }
                                    
                                    if(max_val != null && max_val.trim() != ''){ 
                                        try{                                            
                                            eachinput.Custom_maxlimit = Decimal.Valueof(Decimal.ValueOf(max_val).intValue());                                                
                                        }
                                        Catch(Exception ex){
                                            eachinput.Custom_maxlimit =null;                                                 
                                        }
                                    }
                                    else{
                                        eachinput.Custom_maxlimit = null;
                                    }
                                }
                                else{
                                    eachinput.Custom_maxlimit = null;
                                }
                            }
                            else{
                                eachinput.Custom_maxlimit = null;
                            }
                        }
                        else{
                            eachinput.Custom_maxlimit = null;
                        }
                    }
                    else{
                            eachinput.Custom_maxlimit = null;
                    }
                    
                    if(e.Custom_Min__c != null && e.Custom_Min__c != ''){                                
                        tempList=e.Custom_Min__c.split(',',2);
                        if(tempList != null && tempList.size()==2 && tempList[0] != null && tempList[1] != null){
                            tempList[0]=tempList[0].trim();
                            tempList[1]=tempList[1].trim();                                
                        
                            if(customdataMap != null && customdataMap.keyset() != null && customdataMap.containsKey(tempList[0]) ){
                                if(customdataMap.get( tempList[0] ) != null && customdataMap.get( tempList[0] ).size()>0){
                                    String min_val=String.ValueOf( customdataMap.get( tempList[0] )[0].get( tempList[1] ) );
                                    if(min_val != null && min_val.trim() != '' && min_val.contains(',')){
                                        min_val=min_val.replaceAll(',','').trim();
                                    }
                                    if(min_val != null && min_val.trim() != ''){
                                        try{  
                                            eachinput.Custom_minlimit = Decimal.Valueof(Decimal.ValueOf(min_val).intValue()); 
                                        }
                                        Catch(Exception ex1){
                                            eachinput.Custom_minlimit = null;
                                        }
                                    }
                                    else{
                                        eachinput.Custom_minlimit = null;
                                    }
                                }
                                else{
                                    eachinput.Custom_minlimit = null;
                                }
                            }
                            else{
                                eachinput.Custom_minlimit = null;
                            }
                        }
                        else{
                            eachinput.Custom_minlimit = null;
                        }
                    }
                    else{
                        eachinput.Custom_minlimit = null;
                    }
                    
                    if(eachinput.Custom_minlimit != null){  
                        eachinput.minlimit_Validation=eachinput.Custom_minlimit;
                    }
                    else{
                        eachinput.minlimit_Validation=eachinput.minlimit;
                    }
                                            
                    if(eachinput.Custom_maxlimit != null){
                        eachinput.maxlimit_Validation=eachinput.Custom_maxlimit;
                    }
                    else{
                        eachinput.maxlimit_Validation=eachinput.maxlimit;
                    }                        
                    
                    if((eachinput.maxlimit_Validation <= eachinput.minlimit_Validation) || (eachinput.maxlimit_Validation <=0) || (eachinput.minlimit_Validation<=0)){
                        eachinput.minlimit_Validation=eachinput.minlimit;
                        eachinput.maxlimit_Validation=eachinput.maxlimit;
                        eachinput.Custom_maxlimit=null;
                        eachinput.Custom_minlimit=null;
                    }
                    
                    if(e.Input_Control_Type__c=='Value Capture'){
                        eachinput.controllingField=e.Controlling_Field__c;
                        eachinput.mappedParentChildFields =e.Dependencies_Mapping__c;
                        if(eachinput.IsMandatory==true){
                            eachinput.IsMandatory_Validation='true';
                        }
                        else{
                            eachinput.IsMandatory_Validation='false';
                        }
                        eachinput.listType=eachinput.ValueType;
                        if( eachinput.listType=='Percentage'){
                            eachinput.Code='%';
                        }
                        else if(eachinput.showCurrency && eachinput.listType=='Number' && currencyDummy != null){
                            eachinput.Code=currencyDummy;
                        }
                        else{
                            eachinput.Code='';
                        }
                        
                        if(eachinput.mappedParentChildFields != null && eachinput.controllingField != null){
                            Map<string,string> myinnermaps=new Map<string,string>();
                            for(String s2:eachinput.mappedParentChildFields.split(';')){
                                myinnermaps.put(s2.substring(0,s2.indexof('-')),s2.substring(s2.indexof('-')+1));
                            }
                            parentControlsMap.put(eachinput.controllingField+'-'+eachinput.RecordId,myinnermaps);
                            if(parentChildMap.containsKey(eachinput.controllingField)){
                                parentChildMap.get(eachinput.controllingField).add(eachinput.RecordId);                                
                            }
                            else{
                                List<string> childList=new List<String>();
                                childList.add(eachinput.RecordId);
                                parentChildMap.put(eachinput.controllingField,childList);                                
                            }
                        }                            
                    }                   
                    
                    if(e.Custom_Data_Values__c !=null && e.Custom_Data_Values__c.trim() !='' && e.Input_Control_Type__c=='List Capture'){
                        eachinput.AvailableList=new list<selectoption>();
                        eachinput.AvailableList.add(new selectoption('','---select---'));
                        for(string s:e.Custom_Data_Values__c.replaceAll('\r\n','\n').split('\n')){
                            eachinput.AvailableList.add(new selectoption(s.trim(),s.trim()));
                        }    
                        
                        if(eachinput.IsMandatory==true){
                            eachinput.IsMandatory_Validation='true';
                        }
                        else{
                            eachinput.IsMandatory_Validation='false';
                        } 
                        if(eachinput.showCurrency && currencyDummy != null){
                            eachinput.Code=currencyDummy;
                        }
                        else{
                            eachinput.Code='';
                        }
                    }  
                    
                    if(e.Custom_Data_Values__c  !=null && e.Custom_Data_Values__c.trim() !='' && e.Input_Control_Type__c=='Multi Value Option Capture'){                        

                        eachinput.multilistWrapper=new WV_MultiListPopupWrapper();
                        eachinput.multilistWrapper.error='';
                        eachinput.multilistWrapper.name=e.name;
                        
                        eachinput.multilistWrapper.multiListDescription=e.Description__c;
                        eachinput.multilistWrapper.multiListPercentageValidation=e.Percentage_Validation__c;                            
                        eachinput.sum='0';
                        
                        List<WV_multiListWrapper> multiList=new List<WV_multiListWrapper>();  
                                             
                        for(string s:e.Custom_Data_Values__c.replaceAll('\r\n','\n').split('\n')){
                            if(s.trim()!=''){
                                WV_multiListWrapper multieach=new WV_multiListWrapper();
                                multieach.name=s.trim();
                                multieach.value='';
                                multiList.add(multieach);
                            }
                        }
                        
                        if(multiList.size() > 0){
                            eachinput.multilistWrapper.MultiListWrapperList=multiList;
                            eachinput.multilistWrapper.listsize=string.ValueOf(multiList.size());
                        }
                        if(eachinput.IsMandatory==true){
                            eachinput.IsMandatory_Validation='true';
                        }
                        else{
                            eachinput.IsMandatory_Validation='false';
                        }                                                       
                    }                       
                     
                    
                    if(currentEmployeeElectionOnScheme_New != null && currentEmployeeElectionOnScheme_New.keyset() != null && currentEmployeeElectionOnScheme_New.keyset().size() > 0 && currentEmployeeElectionOnScheme_New.containsKey(d) && currentEmployeeElectionOnScheme_New.get(d) != null && currentEmployeeElectionOnScheme_New.get(d).containsKey(selectedEnrolment) && currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment) != null && currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).containsKey(e.Id)){   
                        if(eachinput.recordtype=='List Capture'){
                            if(currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id) != null & currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id).size()>0){
                                eachinput.SelectedList=currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id)[0].value_New__c; 
                            }                               
                        }
                        else if(eachinput.recordtype=='Multi Value Option Capture'){
                            
                            if(currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id) != null & currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id).size()>0){
                                Decimal k=0;
                                for(Response__c myResp:currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id)){
                                    flagCheck_dummy=false;
                                    for(WV_multiListWrapper Wr:eachinput.multilistWrapper.MultiListWrapperList){
                                        if(Wr.name ==myResp.MultiListName__c){
                                            flagCheck_dummy=true;
                                            if(myResp.value_New__c != null){
                                                Wr.value=myResp.value_New__c;
                                                if(Wr.value != null){
                                                    k=k+Decimal.ValueOf(Wr.value);
                                                }
                                            }       
                                        }                                          
                                    }
                                    if(flagCheck_dummy==false){
                                        eachinput.flagCheck=true;
                                    }                                   
                                }
                                eachinput.sum=String.ValueOf(k);
                            }
                        }
                        else if(eachinput.recordtype=='Value Capture'){
                            if(currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id) != null & currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id).size()>0){
                                eachinput.enteredValue=currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id)[0].value_New__c;
                            }                                
                            if(eachinput.controllingField != null && eachinput.controllingField.trim() !=''){
                                if(eachinput.mappedParentChildFields != null){
                                    string parentSelectedValue='';
                                    if(currentEmployeeElectionOnScheme_New != null && currentEmployeeElectionOnScheme_New.keyset().size() > 0 && currentEmployeeElectionOnScheme_New.containsKey(d) && currentEmployeeElectionOnScheme_New.get(d).containsKey(selectedEnrolment) && currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).containsKey(eachinput.controllingField) && currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(eachinput.controllingField) != null && currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(eachinput.controllingField).size()>0){
                                        parentSelectedValue=currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(eachinput.controllingField)[0].value_New__c;
                                    }
                                    
                                    if(parentSelectedValue != null && parentSelectedValue.trim()!=''){
                                        for(String s1:eachinput.mappedParentChildFields.split(';')){
                                            if(parentSelectedValue ==s1.substring(0,s1.indexof('-'))){
                                                eachinput.listType=s1.substring(s1.indexof('-')+1);                                                    
                                                if( eachinput.listType=='Percentage'){
                                                    eachinput.Code='%';
                                                }
                                                else if(eachinput.showCurrency && eachinput.listType=='Number' && currencyDummy != null){
                                                    eachinput.Code=currencyDummy;
                                                }
                                                else{
                                                    eachinput.Code='';
                                                }
                                                
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        eachinput.Response_New=currentEmployeeElectionOnScheme_New.get(d).get(selectedEnrolment).get(e.Id);
                        eachinput.isCreated=true;  
                    }                
                                     
                    ControlList.add(eachinput);  
                                                             
                }
                InputcontrolSchemeMap.put(d,ControlList);       
            }
        }
        
        if(selectedSchemeWrapper != null && selectedSchemeWrapper.size() > 0){              
            for(WV_SchemeWrapper s:selectedSchemeWrapper){
                if(InputcontrolSchemeMap != null && InputcontrolSchemeMap.containsKey(s.SchemeId)){
                    s.InputControlsList=InputcontrolSchemeMap.get(s.SchemeId); 
                    for(WV_InputControl q:InputcontrolSchemeMap.get(s.SchemeId)){
                        if(q.isCreated==true){
                            s.isCreated=true;
                            break;
                        }                        
                    }   
                    SchemeWrapper=s; 
                }        
            }              
       }
       
       getDescription();
    }


    
    public pagereference goToElection(){
        string pgString='';
        try{
            customPageMessage=null;
            if(selectedSchemeId != null && selectedSchemeId.trim() != ''){
                List<scheme__c> currenctSchemeStatus=WV_Utility.getSchemeDetails(selectedSchemeId);
                if(selectedEnrolment == null || selectedEnrolment.trim()==''){
                    selectedEnrolment='open';
                }  
                if(currenctSchemeStatus != null && currenctSchemeStatus.size()==1 && currenctSchemeStatus[0].Active__c==false){
                    customPageMessage=Label.WV_Homepage_SchemrInActive;
                    typeOfMessage='Error';
                    isExpired=true;
                    return null;
                }   
                else if(selectedEnrolment != null && selectedEnrolment != 'open'){
                    List<Enrollment_Period__c> enrolCurrentStatus=[select id,end_date__c,active_auto__c,Override_Scheme__c,Override_Scheme__r.active__c from Enrollment_Period__c where id=:selectedEnrolment];
                    if(enrolCurrentStatus != null && enrolCurrentStatus.size()>0){
                        if(enrolCurrentStatus[0].active_auto__c==false){
                            customPageMessage=Label.WV_Homepage_EnrolmentExpired;
                            typeOfMessage='Error';
                            isExpired=true;
                            return null;
                        }
                    }
                }       
                getSchemeDetails(MyEligibleSchemes_ordered);
                showHomePage=false;
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside goToElection()'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Employee facing UI Home page-->goToElection()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());      
        } 
        return null;        
    }
    
    
    public PageReference filterCalender(){
    
        try{       
            customPageMessage = null; 
            if(selectedSource_Calender != null && selectedSource_Calender.trim() != ''){
                if(ArrangedElectionsMap != null && ArrangedElectionsMap.keyset() !=null && ArrangedElectionsMap.keyset().size() >0){
                    for(String ss:ArrangedElectionsMap.keyset()){
                        for(WV_ElectionsWrapper Wrap:ArrangedElectionsMap.get(ss)){
                            if(ss==selectedSource_Calender || selectedSource_Calender=='All'){
                                Wrap.showInCalender=true;
                            }
                            else{
                                Wrap.showInCalender=false;
                            }
                        }
                    }
                }
                CurrentSource=sourceList.get(selectedSource_Calender);
                shownhideCalender();            
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside filterCalender()'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Employee facing UI Home page-->filterCalender()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());       
        }         
        return null;
    }
    
    public void shownhideCalender(){
        if(showCalenderPick==false){
            showCalenderPick=true;
        }
        else{
            showCalenderPick=false;
        } 
    }
    
    public Void getDescription(){
        
        IntroductionContent='';
        descriptionContent='';
        TermsConditions='';  
        linksContent='';      
        Map<String,List<Wav_Custom_data__c>> customdataMap;
        Map<String,Map<string,String>> fileMap;
        Map<String,Map<string,List<String>>> fileMapTemp;
        Map<String,String> fileTypeMap;
        List<String> argsDecimal = new String[]{'0','number',Label.WV_Homepage_NumberFormat};
        List<employee__c> employeeList;
        String employeeObjectQuery;
        Sobject employee;
        String StrVal;
        String ActualValue;
        List<Wav_Content__c> wavPreviewContent;
        
        if(LoggedinEmployee != null && LoggedinEmployee.Id!= null){
            employee=new employee__c();
            employeeObjectQuery=WV_Utility.getFullQueryFromSobject(employee,LoggedinEmployee.Id);
            if(employeeObjectQuery != null && employeeObjectQuery.trim() != ''){
                employeeList=(List<employee__c>)WV_Utility.getQueryResults(employeeObjectQuery);
            }
        }
        
        Map<string,string> employeeTagsMap=new  Map<string,string>();
        List<Waiver_Employeetag__c> empTags=Waiver_Employeetag__c.getall().values();
        if(empTags != null && empTags.size() >0){
            for(Waiver_Employeetag__c ColumnMap:empTags){
                employeeTagsMap.put(ColumnMap.Name,ColumnMap.Field_API_Name__c);
            } 
        }                            
        
        if(selectedSchemeId != null && selectedSchemeId.trim() != ''){  
            wavPreviewContent = WV_Utility1.getPageContentManagementData(selectedSchemeId);
        }
        
        if(wavPreviewContent != null && wavPreviewContent.size() > 0 && wavPreviewContent.size() > 0){
                for(Wav_Content__c w:wavPreviewContent){
                    if(w.Content_Type__c == 'Description'){
                        descriptionContent=w.Content__c;
                    }
                    else if(w.Content_Type__c == 'Introduction'){
                        IntroductionContent=w.Content__c;
                    }
                    else if(w.Content_Type__c == 'Terms & Conditions'){
                        TermsConditions=w.Content__c;
                    }
                    else if(w.Content_Type__c == 'Links'){
                        linksContent = w.Content__c;
                    }
                }
                
                fileMap=WV_Utility.getCustomDataFileMaps(selectedSchemeId);
                fileMapTemp=WV_Utility.getCustomDataFileMapsNew(selectedSchemeId);
                fileTypeMap=WV_Utility.getCustomFileUploadType(selectedSchemeId);
                if(fileMap != null && fileMap.keyset() != null && fileMap.keyset().size() >0){ 
                    if(LoggedinEmployee.emp_Id__c != null){
                        customdataMap=WV_Utility.getCustomDataMaps(fileMap.keyset(),LoggedinEmployee.emp_Id__c);  
                    } 
                }
                      
                if(LoggedinEmployee != null && LoggedinEmployee.emp_Id__c != null && employeeList != null && employeeList.size() ==1 ){                    
                    if(employeeTagsMap != null && employeeTagsMap.keySet() != null && employeeTagsMap.keySet().size() >0 ){
                        for(string empStr:employeeTagsMap.keySet()){
                            StrVal=null;
                            if(employeeTagsMap.containsKey(empStr)){
                                if(employeeList[0].get(employeeTagsMap.get(empStr)) != null){
                                    StrVal=String.ValueOf( employeeList[0].get(employeeTagsMap.get(empStr)) );
                                }
                                if(descriptionContent != null && descriptionContent.trim() != '' && descriptionContent.contains(empStr)){
                                    if(StrVal != null){
                                        descriptionContent=descriptionContent.replaceAll(empStr,StrVal);
                                    }
                                    else{
                                        descriptionContent=descriptionContent.replaceAll(empStr,'');
                                    }
                                }
                                if(IntroductionContent != null && IntroductionContent.trim() != '' && IntroductionContent.contains(empStr)){
                                    if(StrVal != null){
                                        IntroductionContent=IntroductionContent.replaceAll(empStr,StrVal);
                                    }
                                    else{
                                        IntroductionContent=IntroductionContent.replaceAll(empStr,'');
                                    }
                                }
                                if(TermsConditions != null && TermsConditions.trim() != '' && TermsConditions.contains(empStr)){
                                    if(StrVal != null){
                                        TermsConditions=TermsConditions.replaceAll(empStr,StrVal);
                                    }
                                    else{
                                        TermsConditions=TermsConditions.replaceAll(empStr,'');
                                    }
                                
                                }
                            }
                        }
                    }        
                }
                                        
                if(fileMap != null && fileMapTemp != null && fileTypeMap != null){
                    for(String s:fileMap.keyset()){
                        if(fileTypeMap.containsKey(s) && fileTypeMap.get(s) != null && fileTypeMap.get(s).split(',') != null && fileTypeMap.get(s).split(',').size() >0 && fileTypeMap.get(s).split(',')[0] =='Text' && fileMapTemp.containsKey(s) && fileMapTemp.get(s) != null && fileMapTemp.get(s).containsKey('ordered') && fileMapTemp.get(s).get('ordered') != null){
                            for(string s1:fileMapTemp.get(s).get('ordered')){
                                ActualValue=null;
                                If(fileMap.containsKey(s) && fileMap.get(s) != null && fileMap.get(s).containsKey(s1) && fileMap.get(s).get(s1) != null){
                                    if(customdataMap != null && customdataMap.containsKey(s) && customdataMap.get(s) != null && customdataMap.get(s).size() >0 && customdataMap.get(s)[0].get(fileMap.get(s).get(s1)) != null){
                                        ActualValue=String.ValueOf(customdataMap.get(s)[0].get(fileMap.get(s).get(s1)));
                                    }
                                    if(descriptionContent != null && descriptionContent.trim() != '' && descriptionContent.contains(s1)){
                                        if(ActualValue != null){
                                            descriptionContent = descriptionContent.replaceAll(s1,ActualValue);
                                        }
                                        else{
                                            descriptionContent = descriptionContent.replaceAll(s1,'');
                                        }
                                    }
                                    if(IntroductionContent != null && IntroductionContent.trim() != '' && IntroductionContent.contains(s1)){
                                        if(ActualValue != null){
                                            IntroductionContent= IntroductionContent.replaceAll(s1,ActualValue);
                                        }
                                        else{
                                            IntroductionContent= IntroductionContent.replaceAll(s1,'');
                                        }
                                    }
                                    if(TermsConditions != null && TermsConditions.trim() != '' && TermsConditions.contains(s1)){
                                        if(ActualValue != null){
                                            TermsConditions= TermsConditions.replaceAll(s1,ActualValue);
                                        }
                                        else{
                                            TermsConditions= TermsConditions.replaceAll(s1,'');
                                        }
                                    }
                                }
                            }
                        }
                        
                        string outputtext='';
                        if(fileTypeMap.containsKey(s) && fileTypeMap.get(s) != null && fileTypeMap.get(s).split(',') != null && fileTypeMap.get(s).split(',').size() >0 && fileTypeMap.get(s).split(',')[0] =='Table'){
                            if(customdataMap != null && customdataMap.containsKey(s) && customdataMap.get(s) != null && customdataMap.get(s).size() >0 && fileMapTemp.containsKey(s) && fileMapTemp.get(s) != null && fileMapTemp.get(s).size() > 0 && fileMapTemp.get(s).containsKey('unordered') && fileMapTemp.get(s).get('unordered') != null ){
                                outputtext=outputtext+'<table style="'+tableCss+'"><thead><tr>';
                                Integer i=0;
                                List<String> dummyFileMap=fileMapTemp.get(s).get('unordered');
                                if(dummyFileMap != null && dummyFileMap.size()>0){
                                    for(string s3:dummyFileMap){
                                        if(s3 != 'MSID'){
                                            outputtext=outputtext+'<th style="'+thCss+'">'+s3.replaceAll('_',' ')+'</th>';
                                        } 
                                        i++;
                                    }
                                    outputtext=outputtext+'</thead></tr>';                                
                                    for(Wav_Custom_data__c data:customdataMap.get(s)){
                                        outputtext=outputtext+'<tr>';  
                                        for(string s4:dummyFileMap){ 
                                            if(fileMap.containsKey(s) && fileMap.get(s) != null && fileMap.get(s).containsKey(s4) && fileMap.get(s).get(s4) != 'MSID__c'){ 
                                                if(data.get(fileMap.get(s).get(s4)) != null){   
                                                    string mystr=String.ValueOf(data.get(fileMap.get(s).get(s4)));
                                                    string mystrDummy=mystr;
                                                    try{                                                             
                                                        if(mystr != null && mystr.trim() != ''){
                                                            mystr=mystr.replaceAll(',','').trim();
                                                            try{ 
                                                                outputtext=outputtext+'<td style="'+tdCss_Number+'">'+String.format(Integer.Valueof(mystr).format(),argsDecimal)+'</td>'; 
                                                            }
                                                            Catch(Exception e1){
                                                                outputtext=outputtext+'<td style="'+tdCss_Number+'">'+String.format(Decimal.ValueOf(mystr).format(),argsDecimal)+'</td>';
                                                            }             
                                                        } 
                                                        else{
                                                            outputtext=outputtext+'<td style="'+tdCss_Text+'"></td>';   
                                                        }                                       
                                                    }
                                                    Catch(Exception e1){
                                                        outputtext=outputtext+'<td style="'+tdCss_Text+'">'+mystrDummy+'</td>';
                                                    }
                                                }
                                                else{
                                                    outputtext=outputtext+'<td style="'+tdCss_Text+'"> </td>';
                                                }   
                                            } 
                                        }  
                                        outputtext=outputtext+'</tr>';   
                                    } 
                                    outputtext=outputtext+'</table>';
                                }                               
                            }
                            
                            if(fileTypeMap.get(s).split(',') != null && fileTypeMap.get(s).split(',').size() >1){
                                string ActualTableContent=fileTypeMap.get(s).split(',')[1];
                                if(descriptionContent != null && descriptionContent != '' && descriptionContent.contains(ActualTableContent)){
                                    if(outputtext != ''){
                                        descriptionContent =descriptionContent.replaceAll(ActualTableContent,outputtext);
                                    }
                                    else{
                                        descriptionContent =descriptionContent.replaceAll(ActualTableContent,'');
                                    }
                                } 
                                if(IntroductionContent != null && IntroductionContent != '' && IntroductionContent.contains(ActualTableContent)){
                                    if(outputtext != ''){
                                        IntroductionContent=IntroductionContent.replaceAll(ActualTableContent,outputtext);
                                    }
                                    else{
                                        IntroductionContent=IntroductionContent.replaceAll(ActualTableContent,'');
                                    }
                                } 
                                if(TermsConditions != null && TermsConditions != '' && TermsConditions.contains(ActualTableContent)){
                                    if(outputtext != ''){
                                        TermsConditions=TermsConditions.replaceAll(ActualTableContent,outputtext);
                                    }
                                    else{
                                        TermsConditions=TermsConditions.replaceAll(ActualTableContent,'');
                                    }
                                }  
                            }                         
                        }
                    }
                }
                             
            }
            else{
                
            } 
            employeeList=null; 
            wavPreviewContent=null;    
            fileMap=null;
            fileMapTemp=null;
            fileTypeMap=null;
            customdataMap=null;      
    }
    
    
    public pageReference submitMyCancellation(){
        try{
            customPageMessage = null;        
            election =new Election__c();  
            if(selectedSchemeId != null && selectedSchemeId.trim() != ''){
                List<scheme__c> currenctSchemeStatus=WV_Utility.getSchemeDetails(selectedSchemeId);
                if(currenctSchemeStatus != null && currenctSchemeStatus.size()==1 && currenctSchemeStatus[0].Active__c==false){
                    customPageMessage=Label.WV_Homepage_SchemrInActive;
                    typeOfMessage='Error';
                    isExpired=true;
                    return null;
                }   
                else if(selectedEnrolment != null && selectedEnrolment != 'open'){
                    List<Enrollment_Period__c> enrolCurrentStatus=[select id,end_date__c,active_auto__c,Override_Scheme__c,Override_Scheme__r.active__c from Enrollment_Period__c where id=:selectedEnrolment];
                    if(enrolCurrentStatus != null && enrolCurrentStatus.size()>0){
                        if(enrolCurrentStatus[0].active_auto__c==false){
                            customPageMessage=Label.WV_Homepage_EnrolmentExpired;
                            typeOfMessage='Error';
                            isExpired=true;
                            return null;
                        }
                    }
                }          
                
            }
            
            If(electionId != null){
               election.Id=electionId;
            } 
            if(election.Id != null){
                election.isCancelled__c=true;
                update election;  
                List<EmailTemplate> electionCancellationEmailTemplate=[select id,DeveloperName from EmailTemplate where DeveloperName='WV_ElectionCancellationEmail'];
                if(electionCancellationEmailTemplate!= null && electionCancellationEmailTemplate.size() >0){
               //     WV_Utility.sendElectionEmails(election,LoggedinEmployee.email__c,electionCancellationEmailTemplate[0].Id);
                }
                string pageStr='/apex/WV_Homepage';
                if(proxyUserId != null && proxyUserId.trim() !=''){
                    pageStr=pageStr+'?uid='+proxyUserId.trim();
                }
                PageReference homepage=new PageReference(pageStr);
                homepage.setRedirect(true);
                electionId=null;
                return homepage;
            }
        }
        Catch(Exception e){
           if(e.getmessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
               customPageMessage=Label.WV_HomepageInvalidElectionUpdate;
               typeOfMessage='Error';
               system.debug('****FIELD_CUSTOM_VALIDATION_EXCEPTION inside Cancel()'+e.getlinenumber()+'-'+e.getmessage()); 
           }
           else{
               customPageMessage=PAGE_ERROR;
               typeOfMessage='Error';
               system.debug('****Exception inside submitMyCancellation()'+e.getlinenumber()+'-'+e.getmessage()); 
               WV_Utility.captureException('My Elections','Employee facing UI Home page-->submitMyCancellation()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());      
           }
        }  
                          
        return null;
    }
    
     public pageReference Submit(){
        
        try{            
            Map<String,List<Response__c>> SubmittedResponses=new Map<String,List<Response__c>>();
            set<string> schemeNameList=new set<string>();
            List<Response__c> FinalResponses=new List<Response__c>();
            List<Response__c> UnwantedResponses=new List<Response__c>();
            List<Election__c> ElectionList=new List<Election__c>();
            List<Response__c> ResponseList=new List<Response__c>();
            
            boolean submitFlag;
            Boolean IsElectionsLoaded;
            Boolean isElectedAlready=false;            
            submitErrorFlag=false;
            TCError='';
            customPageMessage=null;
            isExpired=false;            
            
            if(selectedSchemeId != null && selectedSchemeId.trim() != ''){
                List<scheme__c> currenctSchemeStatus=WV_Utility.getSchemeDetails(selectedSchemeId);
                if(currenctSchemeStatus != null && currenctSchemeStatus.size()==1 && currenctSchemeStatus[0].Active__c==false){
                    customPageMessage=Label.WV_Homepage_SchemrInActive;
                    typeOfMessage='Error';
                    isExpired=true;
                    return null;
                }   
                else if(selectedEnrolment != null && selectedEnrolment != 'open'){
                    List<Enrollment_Period__c> enrolCurrentStatus=[select id,end_date__c,active_auto__c,Override_Scheme__c,Override_Scheme__r.active__c from Enrollment_Period__c where id=:selectedEnrolment];
                    if(enrolCurrentStatus != null && enrolCurrentStatus.size()>0){
                        if(enrolCurrentStatus[0].active_auto__c==false){
                            customPageMessage=Label.WV_Homepage_EnrolmentExpired;
                            typeOfMessage='Error';
                            isExpired=true;
                            return null;
                        }
                    }
                }                   
            }                
            
            if(SchemeWrapper != null && SchemeWrapper.InputControlsList != null){
                for(WV_InputControl I:SchemeWrapper.InputControlsList){  
                    I.Error=null; 
                                                  
                    if(I.recordtype =='List Capture'){                                                                        
                        if(I.SelectedList=='' || I.SelectedList==null){
                            if(I.IsMandatory ==true){ 
                                I.Error=Label.WV_Homepage_Error_MandatoryList; 
                            } 
                            I.UserInputStatus=false;                                   
                        }  
                        else{
                            if(I.Response_New.size()==0){
                                I.Response_New.add(new Response__c());
                            }
                            if(currencyDummy != null && currencyDummy.trim() != ''){
                                I.Response_New[0].Show_Currency_Percentage__c='Currency';
                            }
                            
                            I.Response_New[0].Input_Controls_Mapping__c=I.RecordId;
                            I.Response_New[0].Value_New__c=I.SelectedList;
                            I.UserInputStatus=true; 
                        }                
                    } 
                    else if(I.recordtype =='Value Capture'){
                        If(I.enteredValue != null && I.enteredValue.trim() !=''){
                            I.enteredValue=I.enteredValue.replaceAll(',','');        
                        }
                             
                        I.ValueType=I.DefaultValueType;
                        
                        if(I.controllingField != null && I.controllingField.trim() !='' && I.mappedParentChildFields != null){
                            string parentSelectedValue='';
                            for(WV_InputControl I1:SchemeWrapper.InputControlsList){ 
                                if(I1.RecordId == I.controllingField){
                                    parentSelectedValue=I1.SelectedList;
                                    break;
                                }
                            }
                            if(parentSelectedValue != null && parentSelectedValue.trim()!=''){
                                for(String s1:I.mappedParentChildFields.split(';')){
                                    if(parentSelectedValue ==s1.substring(0,s1.indexof('-'))){
                                        I.ValueType=s1.substring(s1.indexof('-')+1);
                                        break;
                                    }
                                }
                            }
                        }
                           
                                                 
                        if( I.enteredValue==null || I.enteredValue== ''){
                            if(I.IsMandatory ==true){ 
                                I.Error=Label.WV_Homepage_Error_MandatoryItemInput;   
                            }  
                            I.UserInputStatus=false;       
                        }
                        else if( I.ValueType =='Text' && I.enteredValue.isAlphanumericSpace()==false){
                            I.Error=Label.WV_Homepage_Validation_AlphaNumeric;
                            I.UserInputStatus=true; 
                        }                        
                        else if( I.ValueType =='Percentage' && I.enteredValue.isnumeric()==false){
                            I.Error=Label.WV_Homepage_Validation_Numeric;
                            I.UserInputStatus=true; 
                        }
                        else if( I.ValueType =='Percentage' && I.enteredValue.isnumeric()==true && (Integer.Valueof(I.enteredValue) >100 || Integer.Valueof(I.enteredValue) <0)){
                            I.Error=Label.WV_Homepage_ValidationPercentageExceed;
                            I.UserInputStatus=true; 
                        }
                        else if( I.ValueType =='Number'){
                            decimal max_limit=null;
                            decimal min_limit=null;
                            
                            try{
                                if(I.maxlimit_Validation != null && (Decimal.ValueOf(I.enteredValue) > I.maxlimit_Validation)){
                                    max_limit=I.maxlimit_Validation;
                                } 
                                                                   
                                if(I.minlimit_Validation != null && (Decimal.ValueOf(I.enteredValue) < I.minlimit_Validation)){
                                    min_limit=I.minlimit_Validation;
                                }
                            }
                            Catch(Exception exp){
                                I.Error=Label.WV_Homepage_Validation_Numeric;
                                I.UserInputStatus=true;
                            }
                                                                
                            if(max_limit != null){ 
                                I.Error=Label.WV_Homepage_MaxLimit+' '+max_limit+'. ';  
                            } 
                            if(min_limit != null){ 
                                I.Error=Label.WV_Homepage_MinLimit+' '+min_limit+'. ';  
                            }
                            
                            if(I.Error == null && min_limit == null && max_limit == null){
                                if(I.Response_New.size()==0){
                                    I.Response_New.add(new Response__c());
                                }
                                
                                if(I.Code != null && I.Code.trim()!=''){
                                    if(I.Code.trim()=='%'){
                                        I.Response_New[0].Show_Currency_Percentage__c='Percentage';
                                    }
                                    else if(I.Code.trim() != '%'){
                                        I.Response_New[0].Show_Currency_Percentage__c='Currency';
                                    }
                                    else{
                                        I.Response_New[0].Show_Currency_Percentage__c=null;
                                    }
                                }
                                else{
                                    I.Response_New[0].Show_Currency_Percentage__c=null;
                                }
                                I.Response_New[0].IsNumberControl_Internal_Use__c=true;
                                I.Response_New[0].Input_Controls_Mapping__c=I.RecordId;
                                I.Response_New[0].Value_New__c=String.ValueOf(I.enteredValue);
                            }    
                            I.UserInputStatus=true;                  
                        }                              
                        else{
                            if(I.Response_New.size()==0){
                                I.Response_New.add(new Response__c());
                            } 
                            
                            if(I.Code != null && I.Code.trim()!=''){
                                if(I.Code.trim()=='%'){
                                    I.Response_New[0].Show_Currency_Percentage__c='Percentage';
                                }
                                else if(I.Code.trim() != '%'){
                                    I.Response_New[0].Show_Currency_Percentage__c='Currency';
                                }
                                else{
                                    I.Response_New[0].Show_Currency_Percentage__c=null;
                                }
                            }
                            else{
                                I.Response_New[0].Show_Currency_Percentage__c=null;
                            }
                            I.Response_New[0].IsNumberControl_Internal_Use__c=false;
                            I.Response_New[0].Input_Controls_Mapping__c=I.RecordId;
                            I.Response_New[0].Value_New__c=String.ValueOf(I.enteredValue);
                            I.UserInputStatus=true;   
                        }                        
                      
                    }
                    else if(I.recordtype =='Multi Value Option Capture'){
                         boolean nullCheck=true;
                         boolean isNonNumeric=false;
                         Map<string,string> responsesMap=new Map<string,string>();
                         Map<string,string> UnwantedresponsesMap=new Map<string,string>();
                         Decimal sum=0;
                         
                         if(I.multilistWrapper != null && I.multilistWrapper.MultiListWrapperList != null){
                             for(WV_multiListWrapper M:I.multilistWrapper.MultiListWrapperList){
                                 if(M.value != null && M.value.trim() != '' && M.value.trim() != '0'){
                                     nullCheck=false;
                                     responsesMap.put(M.name,M.value.trim());
                                     sum=sum+Decimal.ValueOf(M.value.trim());
                                 }
                                 else{
                                     UnwantedresponsesMap.put(M.name,M.value);
                                 }
                             }
                         }
                         
                         if(nullCheck==false && responsesMap.keyset()!= null && responsesMap.keyset().size()>0){
                             if(sum > 100){
                                 I.Error=Label.WV_Homepage_Limit_Percentage;
                             }
                             if(I.multilistWrapper.multiListPercentageValidation==true && sum != 100){
                                 I.Error=Label.WV_Homepage_Validation100;
                             }
                             else{
                                 for(string str:responsesMap.keyset()){
                                     boolean myflagcheck=false;
                                     if(I.Response_New != null && I.Response_New.size()>0){
                                         for(Response__c respns:I.Response_New){
                                             if(respns.MultiListName__c==str){ 
                                                 respns.value_New__c=responsesMap.get(str);
                                                 myflagcheck=true;
                                                 break;
                                             }              
                                         }                                 
                                     } 
                                     if(myflagcheck==false){                                                                 
                                         I.Response_New.add(new Response__c(Input_Controls_Mapping__c=I.RecordId,MultiListName__c=str,value_New__c=responsesMap.get(str)));
                                     }
                                 } 
                                 if(I.Response_New != null && I.Response_New.size()>0){
                                     for(Response__c respns1:I.Response_New){
                                         if(UnwantedresponsesMap.containsKey(respns1.MultiListName__c) && respns1.Id != null){ 
                                             UnwantedResponses.add(respns1);
                                         }   
                                         if(!responsesMap.containsKey(respns1.MultiListName__c) && !UnwantedresponsesMap.containsKey(respns1.MultiListName__c) && respns1.Id != null){
                                             UnwantedResponses.add(respns1);                                    
                                         }           
                                     }                                 
                                 }                              
                             }  
                             I.UserInputStatus=true;                                    
                         }  
                         else if(nullCheck==true && I.IsMandatory ==true){
                             I.Error=Label.WV_Homepage_Error_MandatoryItemInput;
                             I.UserInputStatus=false;  
                         }
                         else if(isNonNumeric==true){
                             I.Error=Label.WV_Homepage_Validation_Numeric;
                             I.UserInputStatus=true;  
                         } 
                         else{
                              I.UserInputStatus=false;  
                         }                                 
                    }     
                    if(I.Error != null){
                        submitErrorFlag=true;
                    }               
                }   
            }
                     
            if(isTermsChecked==false){
                TCError=Label.WV_Homepage_MandatoryTermsConditions;
            }
            
            if(isTermsChecked && submitErrorFlag==false){
                for(WV_InputControl s:SchemeWrapper.InputControlsList){
                    if(s.UserInputStatus==true){
                        if(s.Response_New != null && s.Response_New.size()>0){
                            ResponseList.addAll(s.Response_New); 
                            if(electionId != null){
                                isElectedAlready = true;                           
                            } 
                        }          
                    }
                    else if(s.Response_New != null && s.Response_New.size() >0){
                        for(Response__C resps:s.Response_New){
                            if(resps.Id != null){
                                UnwantedResponses.add(resps);
                            }
                        }
                    }
                }
                
                if(ResponseList.size() > 0){
                    SubmittedResponses.put(SchemeWrapper.schemeId,ResponseList);
                }
                
                if(isElectedAlready=true && ElectionId != null){
                    ElectionList=[select id,Scheme__c,Employee__c,Related_Enrolment__c from Election__c where Id=:ElectionId FOR UPDATE];
                }
                else{
                    if(selectedEnrolment != null && selectedEnrolment != 'open'){                        
                        ElectionList.add(new Election__c(Scheme__c=SchemeWrapper.schemeId,Employee__c=LoggedinEmployee.Id,Related_Enrolment__c=selectedEnrolment));
                    }
                    else{
                        ElectionList.add(new Election__c(Scheme__c=SchemeWrapper.schemeId,Employee__c=LoggedinEmployee.Id));
                    }
                }
                
                if(ElectionList.size() > 0){ 
                    upsert ElectionList;                             
                    for(Election__c q:ElectionList){
                        if(SubmittedResponses != null && SubmittedResponses.containsKey(q.Scheme__c)){
                            for(Response__c response:SubmittedResponses.get(q.Scheme__c)){
                                response.Election__c=q.Id;  
                                FinalResponses.add(response);                
                            }  
                        }               
                    }
                    if(FinalResponses.size()>0){
                        Upsert FinalResponses;
                    }
                    if(UnwantedResponses.size()>0){
                        delete UnwantedResponses;
                    }
                    List<EmailTemplate> electionConfirmationEmailTemplate=[select id,DeveloperName from EmailTemplate where DeveloperName='WV_ConfirmationEmail'];
                    if(electionConfirmationEmailTemplate != null && electionConfirmationEmailTemplate.size() >0){
                    //    WV_Utility.sendElectionEmails(ElectionList[0],LoggedinEmployee.email__c,electionConfirmationEmailTemplate[0].Id);
                    }
                }
                
                string pageStr='/apex/WV_Homepage';
                if(proxyUserId != null && proxyUserId.trim() !=''){
                    pageStr=pageStr+'?uid='+proxyUserId.trim();
                }
                
                PageReference homepage=new PageReference(pageStr);
                homepage.setRedirect(true);
                return homepage;                
            }  
            
            return null;
                 
        }        
        Catch(Exception e){
           if(e.getmessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
               customPageMessage=Label.WV_HomepageInvalidElectionUpdate;
               typeOfMessage='Error';
               system.debug('****FIELD_CUSTOM_VALIDATION_EXCEPTION inside Submit()'+e.getlinenumber()+'-'+e.getmessage()); 
           }
           else{
               customPageMessage=PAGE_ERROR;
               typeOfMessage='Error';
               system.debug('****Exception inside Submit'+e.getlinenumber()+'-'+e.getmessage()); 
               WV_Utility.captureException('My Elections','Employee facing UI Home page-->Submit()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId()); 
           }     
        } 
        return null;
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(noproxyAllowed==false && proxyUserId != null && proxyUserId.trim() != '' && LoggedInUser != null && LoggedInUser.isactive==false){
                User u=new User(Id=LoggedInUser.Id,isactive=true);
                try{
                    update u;
                }
                Catch(Exception e1){
                    customPageMessage=Label.WV_HomepageUserActivationFailedMessage;
                    typeOfMessage='Error';   
                }
            }
            
            if(exp != null){
                WV_Utility.captureExceptionFuture('My Elections','Employee facing UI Home page-->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                
        }
        return null;
    } 
    
    public pageReference Back(){        
        try{
            string pageStr='/apex/WV_Homepage';
            if(proxyUserId != null && proxyUserId.trim() !=''){
                pageStr=pageStr+'?uid='+proxyUserId.trim();
            }
            
            PageReference homepage=new PageReference(pageStr);
            homepage.setRedirect(true);
            return homepage;  
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside Back()'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Employee facing UI Home page-->Back()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());      
        }     
        return null;
    }
    
    public pageReference Gohomepage(){    
        try{
            string pageStr='/apex/WV_Homepage';
            if(proxyUserId != null && proxyUserId.trim() !=''){
                pageStr=pageStr+'?uid='+proxyUserId.trim();
            }
            
            PageReference homepage=new PageReference(pageStr);
            homepage.setRedirect(true);
            return homepage;   
        }  
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside Gohomepage'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Employee facing UI Home page-->Gohomepage()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());      
        }     
        return null; 
    }
    
   
}