public class WV_Utility{
    
    public static Employee__c getLoggedinEmployeeDetails(string UserId){
        List<Employee__c> LoggedinEmployee; 
         
        if(UserId != null && UserId.trim() != ''){
            LoggedinEmployee = [select emp_id__c, name,First_Name__c,Level_Dsc_Job__c, Last_Name__c,Email__c,Inactive__c,Benefit_Program__c,Job_Region_Code__c,Primary_Pay_Company_Job__c,Country_Home__c,Empl_Class_Job__c,Officer__c,Cost_Center__c,Division_Org__c,Status__c from employee__c where Status__c = 'Active' AND emp_id__c = : UserId];
            if(LoggedinEmployee != null && LoggedinEmployee.size() >0){
                return LoggedinEmployee[0];
            }
        }
        return null;    
    }

    public static set<String> getLoggedinEmployeeEligibleSchemes(Employee__c LoggedInEmployee){
        set<string> EligibleSchemes=new set<string>();
        set<string> EligibleOpenSchemes=new set<string>();
        Integer currentYear=system.today().year();
        boolean benefitProgram;
        boolean costcenter;
        boolean empClass;
        boolean homeCountry;
        boolean jobRegion;
        boolean officer;
        boolean payCompany;
        
        if(LoggedInEmployee != null && LoggedInEmployee.Emp_ID__c !=null && LoggedInEmployee.Emp_ID__c != ''){
            List<Eligible_Employees__c> EligibleSchemeListByMSID=[select id,name,Employee__r.Emp_ID__c,Eligibility__c,Eligibility__r.Scheme__c,Eligibility__r.Scheme__r.Active__c,Eligibility__r.Scheme__r.name,Eligibility__r.Scheme__r.Description__c,Eligibility__r.Scheme__r.Source__r.Source_Order__c,Eligibility__r.Scheme__r.Deferral__r.order__c,Eligibility__r.Scheme__r.Term__c,Eligibility__r.Database_Driven__c from Eligible_Employees__c where Employee__r.Emp_ID__c=:LoggedInEmployee.Emp_ID__c AND Eligibility__r.Database_Driven__c=false AND Eligibility__r.Scheme__r.Active__c=true ORDER BY Eligibility__r.Scheme__r.Source__r.Source_Order__c,Eligibility__r.Scheme__r.Deferral__r.order__c ASC];
            List<Eligibility__c> EligibleSchemeListByRules=[select id,name,Scheme__c,Benefit_Program__c,Cost_Center__c,Employee_Class__c,Home_Country__c,Job_Region__c,Officer__c,Pay_Company__c,Scheme__r.Active__c,Scheme__r.Source__r.Source_Order__c,Scheme__r.Deferral__r.order__c,Database_Driven__c,Scheme__r.Term__c from Eligibility__c where Database_Driven__c=true AND Scheme__r.Active__c=true ORDER BY Scheme__r.Source__r.Source_Order__c,Scheme__r.Deferral__r.order__c ASC];
            
            if(EligibleSchemeListByMSID != null && EligibleSchemeListByMSID.size() > 0){
                for(Eligible_Employees__c el:EligibleSchemeListByMSID){
                    if(el.Eligibility__r.Scheme__r.Term__c =='Open'){
                        EligibleOpenSchemes.add(el.Eligibility__r.Scheme__c);
                    }
                    else if(el.Eligibility__r.Scheme__r.Term__c =='Fixed'){
                        EligibleSchemes.add(el.Eligibility__r.Scheme__c); 
                    } 
                }
            }
            
            if(EligibleSchemeListByRules != null && EligibleSchemeListByRules.size() > 0){
                for(Eligibility__c eligibiltiy:EligibleSchemeListByRules){
                    benefitProgram=false;
                    costcenter=false;
                    empClass=false;
                    homeCountry=false;
                    jobRegion=false;
                    officer=false;
                    payCompany=false;
                    
                    if(eligibiltiy.Benefit_Program__c != null && eligibiltiy.Benefit_Program__c != ''){
                        if(LoggedInEmployee.Benefit_Program__c != null && LoggedInEmployee.Benefit_Program__c !=''){
                            set<string> bp=new set<string>(eligibiltiy.Benefit_Program__c.split(','));
                            if(bp != null && bp.size()>0 && bp.contains(LoggedInEmployee.Benefit_Program__c)){
                                benefitProgram=true;
                            }
                            else{
                                benefitProgram=false;
                            }
                        }
                        else{
                            benefitProgram=false;
                        }
                    } 
                    else{
                        benefitProgram=true;
                    }  
                    
                    if(eligibiltiy.Cost_Center__c != null && eligibiltiy.Cost_Center__c != ''){
                        if(LoggedInEmployee.Cost_Center__c != null && LoggedInEmployee.Cost_Center__c !=''){
                            set<string> cc=new set<string>(eligibiltiy.Cost_Center__c.split(','));
                            if(cc != null && cc.size()>0 && cc.contains(LoggedInEmployee.Cost_Center__c)){
                                costcenter=true;
                            }
                            else{
                                costcenter=false;
                            }                            
                        }
                        else{
                            costcenter=false;
                        }
                    } 
                    else{
                        costcenter=true;
                    }  
                    
                    if(eligibiltiy.Employee_Class__c != null && eligibiltiy.Employee_Class__c != ''){
                        if(LoggedInEmployee.Empl_Class_Job__c != null && LoggedInEmployee.Empl_Class_Job__c !=''){
                            set<string> ec=new set<string>(eligibiltiy.Employee_Class__c.split(','));
                            if(ec != null && ec.size()>0 && ec.contains(LoggedInEmployee.Empl_Class_Job__c)){
                                empClass=true;
                            }
                            else{
                                empClass=false;
                            }                     
                        }
                        else{
                            empClass=false;
                        }
                    } 
                    else{
                        empClass=true;
                    }  
                    
                    if(eligibiltiy.Home_Country__c != null && eligibiltiy.Home_Country__c != ''){
                        if(LoggedInEmployee.Country_Home__c != null && LoggedInEmployee.Country_Home__c !=''){
                            set<string> hc=new set<string>(eligibiltiy.Home_Country__c.split(','));
                            if(hc != null && hc.size()>0 && hc.contains(LoggedInEmployee.Country_Home__c)){
                                homeCountry=true;
                            }
                            else{
                                homeCountry=false;
                            }  
                        }
                        else{
                            homeCountry=false;
                        }
                    } 
                    else{
                        homeCountry=true;
                    }  
                    
                    if(eligibiltiy.Job_Region__c != null && eligibiltiy.Job_Region__c != ''){
                        if(LoggedInEmployee.Job_Region_Code__c != null && LoggedInEmployee.Job_Region_Code__c !=''){
                            set<string> jr=new set<string>(eligibiltiy.Job_Region__c.split(','));
                            if(jr != null && jr.size()>0 && jr.contains(LoggedInEmployee.Job_Region_Code__c)){
                                jobRegion=true;
                            }
                            else{
                                jobRegion=false;
                            }                             
                        }
                        else{
                            jobRegion=false;
                        }
                    } 
                    else{
                        jobRegion=true;
                    }  
                    
                    if(eligibiltiy.Officer__c != null && eligibiltiy.Officer__c != ''){
                        if(LoggedInEmployee.Officer__c != null && LoggedInEmployee.Officer__c !='' && eligibiltiy.Officer__c==LoggedInEmployee.Officer__c){
                            officer=true;
                        }
                        else{
                            officer=false;
                        }
                    } 
                    else{
                        officer=true;
                    }  
                    
                    if(eligibiltiy.Pay_Company__c != null && eligibiltiy.Pay_Company__c != ''){
                        if(LoggedInEmployee.Primary_Pay_Company_Job__c != null && LoggedInEmployee.Primary_Pay_Company_Job__c !=''){
                            set<string> pc=new set<string>(eligibiltiy.Pay_Company__c.split(','));
                            if(pc != null && pc.size()>0 && pc.contains(LoggedInEmployee.Primary_Pay_Company_Job__c)){
                                payCompany=true;
                            }
                            else{
                                payCompany=false;
                            }                             
                        }
                        else{
                            payCompany=false;
                        }
                    } 
                    else{
                        payCompany=true;
                    }  
                    
                    if(benefitProgram==true && costcenter==true && empClass==true && homeCountry==true && jobRegion==true && officer==true && payCompany==true){
                        if(eligibiltiy.Scheme__r.Term__c =='Fixed'){
                            EligibleSchemes.add(eligibiltiy.Scheme__c); 
                        }
                        else if(eligibiltiy.Scheme__r.Term__c =='Open'){
                            EligibleOpenSchemes.add(eligibiltiy.Scheme__c); 
                        }
                    } 
                }
            }
            
            if(EligibleSchemes.size()>0){
               List<Enrollment_Period__c> enrolvalid=[select id,name,start_date__c,Override_Scheme__c from Enrollment_Period__c where Override_Scheme__c IN:EligibleSchemes AND start_date__c <=:system.now()];
               for(Enrollment_Period__c enrol:enrolvalid){
                   EligibleOpenSchemes.add(enrol.Override_Scheme__c);
               }
            }
            
            return EligibleOpenSchemes;
        }
        else{
            return null;
        }
    }

    public static Map<String,Map<string,Map<String,List<Response__c>>>> getResponseOnSchemesOnEnrolment_New(Map<Id,Scheme__c> MyEligibleSchemes,Map<String,Map<string,Enrollment_Period__c>> activeSchemeenrolMap,Employee__c LoggedinEmployee,Integer currentYear){
        
        Map<String,Map<string,Map<String,List<Response__c>>>> schemeResponse=new Map<String,Map<string,Map<String,List<Response__c>>>>();
        Map<String,List<Response__c>> allSchemeResponse=new Map<String,List<Response__c>>();
        set<string> enrolIds=new set<string>();
        Map<string,Map<String,List<Response__c>>> innerMap;
        
        if(activeSchemeenrolMap != null && activeSchemeenrolMap.keyset() != null && activeSchemeenrolMap.keyset().size()>0){
            for(Map<string,Enrollment_Period__c> each:activeSchemeenrolMap.values()){
                if(each != null && each.keyset()!=null && each.keyset().size()>0){
                    if(each.keyset().size()==1 && each.keyset().contains('open')){
                        
                    }
                    else{
                        enrolIds.addall(each.keyset());
                    }
                }
            }
        }
        
        if(MyEligibleSchemes != null && MyEligibleSchemes.keyset() != null && MyEligibleSchemes.keyset().size() >0){
            List<Response__c> Responselist=[select id,name,MultiListName__c,IsNumberControl_Internal_Use__c,value_new__c,Show_Currency_Percentage__c,Input_Controls_Mapping__c,Input_Controls_Mapping__r.Waiver_Template__c,Input_Controls_Mapping__r.name,Input_Controls_Mapping__r.Custom_Max__c,Input_Controls_Mapping__r.Custom_Min__c,Input_Controls_Mapping__r.Custom_Data_Values__c,Input_Controls_Mapping__r.Default_Maximum_Value__c,Input_Controls_Mapping__r.Default_Minimum_Value__c,Input_Controls_Mapping__r.order__c,Input_Controls_Mapping__r.Required__c,Input_Controls_Mapping__r.Input_Control_Type__c,Input_Controls_Mapping__r.Value_Type__c,Input_Controls_Mapping__r.Scheme__c,Input_Controls_Mapping__r.Show_Currency__c,Election__c,Election__r.Employee__c,Election__r.LastModifiedDate,Election__r.LastModifiedBy.Name,LastModifiedDate,LastModifiedBy.name,Election__r.isCancelled__c,Election__r.Related_Enrolment__c,Election__r.Related_Enrolment__r.start_date__c,Election__r.Related_Enrolment__r.end_date__c,Election__r.scheme__c,Input_Controls_Mapping__r.Control_Visibility__c from Response__c where ( Election__r.scheme__c IN:MyEligibleSchemes.Keyset() AND Election__r.Employee__c=:LoggedinEmployee.Id AND Election__r.isCancelled__c=false AND (Election__r.Related_Enrolment__c = null OR Election__r.Related_Enrolment__c IN:enrolIds)) ORDER BY Input_Controls_Mapping__r.order__c ASC];
            if(Responselist != null && Responselist.size() > 0){
                for(Response__c r:Responselist){
                    if(allSchemeResponse.containsKey(r.Input_Controls_Mapping__r.Scheme__c)){
                        allSchemeResponse.get(r.Input_Controls_Mapping__r.Scheme__c).add(r);
                    }
                    else{
                        List<Response__c> res=new List<Response__c>();
                        res.add(r);
                        allSchemeResponse.put(r.Input_Controls_Mapping__r.Scheme__c,res);
                    }
                }
            }
            for(Id scheme:MyEligibleSchemes.keyset()){
                innerMap=new Map<string,Map<String,List<Response__c>>>();
                if(system.today().year()==currentYear && MyEligibleSchemes.get(scheme) != null && MyEligibleSchemes.get(scheme).term__c=='Open' && activeSchemeenrolMap != null && activeSchemeenrolMap.containsKey(scheme) && activeSchemeenrolMap.get(scheme) != null && activeSchemeenrolMap.get(scheme).keyset() != null && activeSchemeenrolMap.get(scheme).keyset().size() >0 && activeSchemeenrolMap.get(scheme).keyset().contains('open') && allSchemeResponse.containsKey(scheme) && allSchemeResponse.get(scheme) != null && allSchemeResponse.get(scheme).size() > 0){
                    Map<String,List<Response__c>> resMap=new Map<String,List<Response__c>>();
                    for(Response__c q:allSchemeResponse.get(scheme)){
                        if(!resMap.containsKey(q.Input_Controls_Mapping__c)){
                            List<Response__c> newResp=new List<Response__c>();
                            newResp.add(q);
                            resMap.put(q.Input_Controls_Mapping__c,newResp);
                        }
                        else{
                            resMap.get(q.Input_Controls_Mapping__c).add(q);
                        }
                    }
                    innerMap.put('open',resMap);
                    schemeResponse.put(scheme,innerMap);
                }
                else if(MyEligibleSchemes.get(scheme).term__c=='Fixed' && allSchemeResponse.containsKey(scheme) && allSchemeResponse.get(scheme) != null && allSchemeResponse.get(scheme).size() > 0){

                    for(Response__c s:allSchemeResponse.get(scheme)){
                        if(enrolIds.contains(s.Election__r.Related_Enrolment__c)){
                            if(innerMap.containsKey(s.Election__r.Related_Enrolment__c)){
                                if(innerMap.get(s.Election__r.Related_Enrolment__c).containsKey(s.Input_Controls_Mapping__c)){
                                    innerMap.get(s.Election__r.Related_Enrolment__c).get(s.Input_Controls_Mapping__c).add(s);                                
                                }
                                else{
                                    List<Response__c> newResp1=new List<Response__c>();
                                    newResp1.add(s);
                                    innerMap.get(s.Election__r.Related_Enrolment__c).put(s.Input_Controls_Mapping__c,newResp1);
                                }
                            }
                            else{
                                Map<String,List<Response__c>> resMapFinal=new Map<String,List<Response__c>>();
                                List<Response__c> newResp2=new List<Response__c>();
                                newResp2.add(s);
                                resMapFinal.put(s.Input_Controls_Mapping__c,newResp2);
                                innerMap.put(s.Election__r.Related_Enrolment__c,resMapFinal);
                            }
                        }
                    }                   
                }   
                if(innerMap.keyset().size() >0){
                    schemeResponse.put(scheme,innerMap);
                }
            }
        }
        return schemeResponse;
    }
    
    public static List<Input_Controls_Mapping__c> getInputControl(Set<Id> schemeSet){
        List<Input_Controls_Mapping__c> ListControls;
        if(schemeSet != null && schemeSet.size()>0){
            ListControls=[select id,name,Scheme__c,Waiver_Template__c,Description__c,Percentage_Validation__c,Custom_Min__c,Custom_Max__c,Custom_Data_Values__c,Default_Maximum_Value__c,Default_Minimum_Value__c,Required__c,Input_Control_Type__c,Value_Type__c,show_currency__c,Controlling_Field__c,Dependencies_Mapping__c,order__c from Input_Controls_Mapping__c where  Scheme__c IN:schemeSet ORDER BY order__C ASC];
        }
        else{
            return null;
        }    
        return ListControls;
    }
    
    public static boolean getEnrolmentStatusforSchemeActivation(String schemeId){
        List<Enrollment_Period__c > enrolmentList;
        boolean enrolflag=false;
        if(schemeId != null && schemeId.trim() != ''){
            enrolmentList = [select id,name,Active_Auto__c,Override_Scheme__c,start_date__c,end_date__c from Enrollment_Period__c where Override_Scheme__c=:schemeId];
            if(enrolmentList != null && enrolmentList.size() > 0){
                enrolflag=true;
            }        
        }
        return enrolflag;
    }
    
    public static boolean getEligibiltyStatusforSchemeActivation(String schemeId){
        List<Eligibility__c> enligibilityList;
        boolean eligibilityflag=false;
        if(schemeId != null && schemeId.trim() != ''){
            enligibilityList = [select id,name,Scheme__c from Eligibility__c where Scheme__c=:schemeId];
            if(enligibilityList != null && enligibilityList.size() == 1){
                eligibilityflag=true;
            }        
        }
        return eligibilityflag;
    }

    public static boolean getDescriptionContentStatusforSchemeActivation(String schemeId){
        boolean contentResult=false;
        List<Wav_Content__c> contentList;
        if(schemeId != null && schemeId.trim() != ''){
            contentList = [select id,name,Scheme__c,content_type__c from Wav_Content__c where Scheme__c=:schemeId AND content_type__c='Description'];
            if(contentList != null && contentList.size() == 1){
                contentResult=true;
            }        
        }
        return contentResult;
    }
    
    public static boolean getIntroductionContentStatusforSchemeActivation(String schemeId){
        boolean contentResult=false;
        List<Wav_Content__c> contentList;
        if(schemeId != null && schemeId.trim() != ''){
            contentList = [select id,name,Scheme__c,content_type__c from Wav_Content__c where Scheme__c=:schemeId AND content_type__c='Introduction'];
            if(contentList != null && contentList.size() == 1){
                contentResult=true;
            }        
        }
        return contentResult;
    }
    
    
    public static boolean getTermsandConditionStatusforSchemeActivation(String schemeId){
        boolean TermsResult=false;
        List<Wav_Content__c> contentList;
        if(schemeId != null && schemeId.trim() != ''){
            contentList = [select id,name,Scheme__c,content_type__c from Wav_Content__c where Scheme__c=:schemeId AND content_type__c='Terms & Conditions'];
            if(contentList != null && contentList.size() == 1){
                TermsResult=true;
            }        
        }
        return TermsResult;
    }
    
    public static boolean getEmailSubmissionStatusforSchemeActivation(String schemeId){
        boolean EmailSubmitResult=false;
        List<Wav_Content__c> contentList;
        if(schemeId != null && schemeId.trim() != ''){
            contentList = [select id,name,Scheme__c,content_type__c from Wav_Content__c where Scheme__c=:schemeId AND content_type__c='Email Template - Election Submit/Update'];
            if(contentList != null && contentList.size() == 1){
                EmailSubmitResult=true;
            }        
        }
        return EmailSubmitResult;
    }
    
    public static boolean getEmailCancellationStatusforSchemeActivation(String schemeId){
        boolean EmailCancellationResult=false;
        List<Wav_Content__c> contentList;
        if(schemeId != null && schemeId.trim() != ''){
            contentList = [select id,name,Scheme__c,content_type__c from Wav_Content__c where Scheme__c=:schemeId AND content_type__c='Email Template - Election Cancellation'];
            if(contentList != null && contentList.size() == 1){
                EmailCancellationResult=true;
            }        
        }
        return EmailCancellationResult;
    }
    
    public static List<scheme__c> getTemplate(String SchemeId){
        List<scheme__c> scheme;
        if(SchemeId != null && SchemeId.trim() !=''){
            scheme=[select id,name,Waiver_Template__c from scheme__c where Id=:SchemeId AND Waiver_Template__c != null];
        }
        return scheme;
    }
    
    public static List<Enrollment_Period__c> getEnrolmentList(string schemeId){
        List<Enrollment_Period__c> enrolmentList;
        if(schemeId != null && schemeId.trim() != ''){
            enrolmentList=[select id,name,Override_Scheme__c,End_Date__c,Active_Auto__c,Start_Date__c,Compensation_Year__c,LastModifiedDate,CreatedDate from Enrollment_Period__c where Override_Scheme__c=:schemeId ORDER BY Start_Date__c DESC];
        }
        return enrolmentList;
    }
    
    public static List<Enrollment_Period__c> validateStartDateEnrolmentPeriod(string schemeId,String EnrolId,datetime stDate){
        List<Enrollment_Period__c> enrolmentList;
        if(schemeId != null && schemeId.trim() != '' && stDate != null){
            if(EnrolId==null){
                enrolmentList=[select id,name,Override_Scheme__c,End_Date__c,Start_Date__c,Active_Auto__c,Compensation_Year__c,LastModifiedDate,CreatedDate from Enrollment_Period__c where Override_Scheme__c=:schemeId AND End_Date__c>=:stDate AND Start_Date__c<=:stDate ORDER BY CreatedDate DESC];
                return enrolmentList;
            }
            else{
                List<Enrollment_Period__c> enrolDetail=WV_Utility.getEnrolment(EnrolId);
                if(enrolDetail != null && enrolDetail.size()>0){
                    enrolmentList=[select id,name,Override_Scheme__c,End_Date__c,Start_Date__c,Active_Auto__c,Compensation_Year__c,LastModifiedDate,CreatedDate from Enrollment_Period__c where Override_Scheme__c=:schemeId AND Id !=:EnrolId  AND End_Date__c>=:stDate AND Start_Date__c<=:stDate ORDER BY CreatedDate DESC];
                }
            }
        }
        return enrolmentList;
    }
    
     public static List<Enrollment_Period__c> validateEndDateEnrolmentPeriod(string schemeId,String EnrolId,datetime edDate){
        List<Enrollment_Period__c> enrolmentList;
        if(schemeId != null && schemeId.trim() != '' && edDate != null){
            if(EnrolId==null){
                enrolmentList=[select id,name,Override_Scheme__c,End_Date__c,Start_Date__c,Active_Auto__c,Compensation_Year__c,LastModifiedDate,CreatedDate from Enrollment_Period__c where Override_Scheme__c=:schemeId AND Start_Date__c<=:edDate AND End_Date__c>=:edDate ORDER BY CreatedDate ASC];
                return enrolmentList;
            }
            else{
                List<Enrollment_Period__c> enrolDetail=WV_Utility.getEnrolment(EnrolId);
                if(enrolDetail != null && enrolDetail.size()>0){
                    enrolmentList=[select id,name,Override_Scheme__c,End_Date__c,Start_Date__c,Active_Auto__c,Compensation_Year__c,LastModifiedDate,CreatedDate from Enrollment_Period__c where Override_Scheme__c=:schemeId AND Id !=:EnrolId AND Start_Date__c<=:edDate AND End_Date__c>=:edDate ORDER BY CreatedDate ASC];
                }
            }
        }
        return enrolmentList;
    }
    
    public static Datetime validationOnEnrolmentStartdate(string schemeId,Enrollment_Period__c Enrolment){
    
        if(schemeId != null && schemeId != '' && Enrolment != null){
            List<election__c> electionList=[select id,name,Scheme__c,LastModifiedDate,CreatedDate,Related_Enrolment__c,isCancelled__c from election__c where Scheme__c=:schemeId AND Related_Enrolment__c=:Enrolment.Id AND isCancelled__c=false ORDER BY CreatedDate ASC Limit 1];
            if(electionList != null && electionList.size() > 0 && Enrolment.start_date__c > electionList[0].CreatedDate){
                return electionList[0].CreatedDate;
            }
            else{
                return null;
            }
        }
        return null;    
    }
    
    public static List<Enrollment_Period__c> getEnrolment(string enrolId){
        List<Enrollment_Period__c> enrolment;
        if(enrolId != null && enrolId != ''){
            enrolment=[select id,name,Override_Scheme__c,End_Date__c,Active_Auto__c,Start_Date__c,Compensation_Year__c,LastModifiedDate,CreatedDate from Enrollment_Period__c where Id=:enrolId];
        }
        return enrolment;
    }
    
    public static string[] getCleanFields(String[] initialStringList){    
        
        String[] cleanFields = new String[]{};   
                  
        String compositeField;
        Boolean makeCompositeField = false;
        if(initialStringList != null && initialStringList.size() >0){
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
        }
    
        return cleanFields;
    }
    
    public static string getIntroductionContent(string scheme){
        string Intro='';
        
        if(scheme != null && scheme.trim() != ''){
            List<Wav_Content__c>  wav=[select id,name,Content__c,Content_Type__c,Scheme__c from Wav_Content__c where Content_Type__c='Introduction' AND Scheme__c=:scheme limit 1];
            if(wav != null && wav.size()==1){
                Intro=wav[0].Content__c;
            }
        }
        
        return Intro;
    }
    
    public Static Map<string,List<Wav_Custom_data__c>> getCustomDataMaps(set<string> fileSet,string empId){
        Map<string,List<Wav_Custom_data__c>> customdataMap;
        if(fileSet != null && fileSet.size() > 0 && empId != null && empId != ''){
            List<Wav_Custom_data__c> customdataList=[select id,name,File_Upload__c,MSID__c,Text1__c,Text2__c,Text3__c,Text4__c,Text5__c,Text6__c,Text7__c,Text8__c,Text9__c,Text10__c,Text11__c,Text12__c,Text13__c,Text14__c,Text15__c,Text16__c,Text17__c,Text18__c,Text19__c,Text20__c,Text21__c ,Text22__c ,Text23__c ,Text24__c,Text25__c  from Wav_Custom_data__c where File_Upload__c IN:fileSet AND MSID__c=:empId];
            if(customdataList != null && customdataList.size() >0){
                customdataMap=new Map<string,List<Wav_Custom_data__c>>();
                for(Wav_Custom_data__c wav:customdataList){
                    if(customdataMap.containsKey(wav.File_Upload__c)){
                        customdataMap.get(wav.File_Upload__c).add(wav);
                    } 
                    else{
                        List<Wav_Custom_data__c> dataList=new List<Wav_Custom_data__c>();
                        dataList.add(wav);
                        customdataMap.put(wav.File_Upload__c,dataList);
                    }       
                }
            }
        }
        return customdataMap;
    }
    
    public static List<Wav_Content__c> getAllContentManagementData(string schemeId){
        List<Wav_Content__c> Content;
        
        if(schemeId != null && schemeId.trim() != ''){
            set<string> contentTypes=new set<string>{'Description','Introduction','Terms & Conditions'};
            Content=[select id,name,Content__c,Content_Type__c,Scheme__c from Wav_Content__c where Scheme__c=:schemeId AND Content_Type__c IN:contentTypes];
        }
        return Content;
    }
    
    public static List<AsyncApexJob> getPendingBatchJobs(String className){
        List<AsyncApexJob> pendingBacthJobs;
        if(className != null && className != ''){        
            pendingBacthJobs=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where ( CreatedById=:Userinfo.getUserID() AND ApexClass.Name=:className AND ( Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued'))];
        }
        else{
            pendingBacthJobs=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where ( JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued' ))];
        }
        return pendingBacthJobs;
    }
    
    public static List<AsyncApexJob> getPendingBatchJobsCustomData(string type){
        List<AsyncApexJob> pendingBacthJobs;
        if(type != null){        
            pendingBacthJobs=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where ( CreatedById=:Userinfo.getUserID() AND ( ApexClass.Name='ReadAndPopulateBatch' OR ApexClass.Name='WV_ReadAndPopulateBatch' ) AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued'))];
            //pendingBacthJobs=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where ( CreatedById=:Userinfo.getUserID() AND ( ApexClass.Name='ReadAndPopulateBatch' OR ApexClass.Name='WV_ReadAndPopulateBatch' ) AND (Status = 'Processing' OR Status = 'Preparing'))];
        }
        else{
            pendingBacthJobs=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where ( JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued' ))];
        }
        return pendingBacthJobs;
    }
    
     public static List<AsyncApexJob> getAsyncJobsOnEligibilityStatus(string classname,integer numberOfJobs){
        List<AsyncApexJob> jobList;
        
        if(ClassName != null && numberOfJobs != null){
            jobList=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate,CreatedById,CreatedBy.name, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where ApexClass.Name=:ClassName AND CreatedById=:Userinfo.getUserID() order by CreatedDate desc limit :numberOfJobs];
        }
        return jobList;
    }
    
    public static List<AsyncApexJob> getAsyncJobsOnCustomDataFileStatus(Datetime Dt){
        List<AsyncApexJob> jobList;
        
        if(Dt != null){
            jobList=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate,CreatedById,CreatedBy.name, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where ( ApexClass.Name='ReadAndPopulateBatch' OR ApexClass.Name='WV_ReadAndPopulateBatch' ) AND CreatedById=:Userinfo.getuserId() AND createddate >: Dt order by CreatedDate desc];
        }
        return jobList;
    }
    
    public static Map<string,SobjectField> getSObjectFieldsMap(String ObjectName){
        if(ObjectName != null && ObjectName != ''){
            Map<string,SobjectField> fieldMap=Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();
            return fieldMap;
        }
        return null;
    }
    
    public static List<Schema.PicklistEntry> getPickListValues(string ObjectName,string fieldName){
        if(ObjectName != null && ObjectName != '' && fieldName != null && fieldName != ''){
            Schema.DisplayType fieldType=Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType();
            List<Schema.PicklistEntry> pick_list_values=Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPickListValues();
            return pick_list_values; 
        }
        return null;
    }
    
    public static string getEmployeeStaticTags(){
        String EmployeeObjectStaticTags='';
        List<Waiver_Employeetag__c> empTags=Waiver_Employeetag__c.getall().values();
        if(empTags != null && empTags.size() >0){
            for(Waiver_Employeetag__c ColumnMap:empTags){
                  EmployeeObjectStaticTags=EmployeeObjectStaticTags+ColumnMap.Name+' &nbsp; ';
            } 
        }      
        return EmployeeObjectStaticTags;
    }
    
    public static string getCustomDataFileTags(string SchemeId){
        string CustomDataTableTags='';
        string CustomDataTextTags='';
        string CustomTags='';
        
        if(SchemeId != null && SchemeId.trim() != ''){
            List<Custom_Data_upload_file__c> CustomFileList=WV_Utility.getCustomFileUploads(SchemeId);
            
            if(CustomFileList != null && CustomFileList.size() > 0){
                for(Custom_Data_upload_file__c c:CustomFileList){
                    if(c.File_Type__c=='Text'){
                        CustomDataTextTags=CustomDataTextTags+c.Name+'<br/>';
                        Integer i=1;                        
                        if(c.columns__c != null && c.columns__c.trim() != ''){
                            for(string s:c.columns__c.split(',')){
                                if(s != null && s.split('->') != null && s.split('->').size() >0){
                                    CustomDataTextTags=CustomDataTextTags+'@'+c.Name+'.'+s.split('->')[0].replaceAll(' ','_')+' &nbsp; ';
                                    if(math.mod(i,9)==0){
                                        CustomDataTextTags=CustomDataTextTags+'<br/>';
                                    }
                                    i++;
                                }
                            }  
                        }         
                        CustomDataTextTags=CustomDataTextTags+'<br/><br/>'; 
                    }
                    if(c.File_Type__c=='Table'){
                        CustomDataTableTags=CustomDataTableTags+'@'+c.Name+'.table<br/>';
                    }            
                }
                if(CustomDataTableTags != '' && CustomDataTextTags !=''){
                    CustomTags=CustomDataTableTags+'<br/>'+CustomDataTextTags;
                }
                else if(CustomDataTableTags!=''){
                    CustomTags=CustomDataTableTags;
                }
                else if(CustomDataTextTags != ''){
                    CustomTags=CustomDataTextTags;
                }
            }    
        }   
        return CustomTags;
    }
    
    public static List<scheme__c> getSchemeDetails(string schemeId){
        List<scheme__c> schemeDetails;
        if(schemeId != null && schemeId != ''){
            schemeDetails=[select id,name,Deferral__c,Deferral__r.name,Scheme_Currency__c,Scheme_Currency__r.name,Description__c,Term__c,Source__c,Source__r.name,Waiver_Template__c,Active__c,Abacus_n__c,Abacus_n__r.name,Abacus__c,Last_updated_date__c,Last_updated_by__c,Last_updated_by__r.name   from scheme__c where Id=:schemeId];
        }
        return schemeDetails;
    }
    
    //This method is same replica of the above method , it will not have Template reference which is necessary for scheme detail page. (As template tab is rerendered in scheme detail page)
    public static List<scheme__c> getSchemeDetails_New(string schemeId){
        List<scheme__c> schemeDetails;
        if(schemeId != null && schemeId != ''){
            schemeDetails=[select id,name,Deferral__c,Deferral__r.name,Scheme_Currency__c,Scheme_Currency__r.name,Description__c,Term__c,Source__c,Source__r.name,Active__c,Abacus_n__c,Abacus_n__r.name,Abacus__c,Last_updated_date__c,Last_updated_by__c,Last_updated_by__r.name   from scheme__c where Id=:schemeId];
        }
        return schemeDetails;
    }
    
    public static Map<Id,Scheme__c> getSchemeDetails(set<string> schemeList){
    
        if(schemeList != null && schemeList.size() > 0){
            Map<Id,Scheme__c> SchemeDetailsMap=new Map<Id,Scheme__c>([select id,name,Active__c,term__c,Abacus_n__c,Abacus__c,Abacus_n__r.Value__c,Scheme_Currency__c,Scheme_Currency__r.Value__c,Scheme_Currency__r.Active__c,Description__c,Source__r.Source_Order__c,Source__r.Active__c,Source__r.Name,Deferral__c,Deferral__r.Name,Deferral__r.Order__c,Deferral__r.Active__c,Waiver_Template__c,Waiver_Template__r.Name from Scheme__c where Id IN:schemeList ORDER BY Source__r.Source_Order__c,Deferral__r.Order__c ASC]); 
            return SchemeDetailsMap;
        }
        else{
            return null;
        }
    }
    
    public static List<Scheme__c> getSchemeDetail(set<string> schemeList){
        
        if(schemeList != null && schemeList.size() > 0){
            List<Scheme__c> SchemeDetails=[select id,name,Active__c,term__c,Abacus_n__c,Abacus__c,Abacus_n__r.Value__c,Scheme_Currency__c,Scheme_Currency__r.Value__c,Scheme_Currency__r.Active__c,Description__c,Source__r.Source_Order__c,Source__r.Active__c,Source__r.Name,Deferral__c,Deferral__r.Name,Deferral__r.Active__c,Deferral__r.Order__c,Waiver_Template__c,Waiver_Template__r.Name from Scheme__c where Id IN:schemeList ORDER BY Source__r.Source_Order__c,Deferral__r.Order__c ASC]; 
            return SchemeDetails;
        }
        else{
            return null;
        }
    }
    
    public static List<Wav_Content__c> getContentManagementData(string schemeId,String contentType){
        List<Wav_Content__c> Content;
        set<String> contentTypes;
        
        if(schemeId != null && schemeId != '' && contentType != null && contentType != ''){
            Content=[select id,name,Content__c,Content_Type__c,Scheme__c from Wav_Content__c where Scheme__c=:schemeId AND Content_Type__c=:contentType];
            return Content;
        }
        return null;
    }
    
    public static List<Custom_Data_upload_file__c> getFileLoad(string Scheme){
        
        List<Custom_Data_upload_file__c> FileList;
        if(Scheme != null && Scheme != ''){
            FileList=[select id,name,Columns__c,File_Type__c,Scheme__c,CreatedBy.Name,CreatedDate from Custom_Data_upload_file__c where Scheme__c=:Scheme Order by CreatedDate DESC];
        }
        return FileList;
    }
    
    public static Map<Integer,String> getFileFieldMappings(){
        Map<Integer,String> fieldMap=new Map<Integer,String>{0=>'MSID__c',1=>'Text1__c',2=>'Text2__c',3=>'Text3__c',4=>'Text4__c',5=>'Text5__c',6=>'Text6__c',7=>'Text7__c',8=>'Text8__c',9=>'Text9__c',10=>'Text10__c',11=>'Text11__c',12=>'Text12__c',13=>'Text13__c',14=>'Text14__c',15=>'Text15__c',16=>'Text16__c',17=>'Text17__c',18=>'Text18__c',19=>'Text19__c',20=>'Text20__c',21=>'Text21__c',22=>'Text22__c',23=>'Text23__c',24=>'Text24__c',25=>'Text25__c'};
        return fieldMap;
    }

    public static List<Input_Controls_Mapping__c> getReferredInputControls(String customFileId){
        List<Input_Controls_Mapping__c> referredControls;
        if(customFileId != null && customFileId.trim() != ''){
           referredControls=[select id,name,Custom_Max__c,Custom_Min__c from  Input_Controls_Mapping__c where Custom_Max__c Like:customFileId+'%' OR Custom_Min__c Like:customFileId+'%'];
        }
        return referredControls;
    } 
    
    public static List<Custom_Data_upload_file__c> checkUniquenessInFileLoad(string Scheme,string fileName){
    
        List<Custom_Data_upload_file__c> FileList;
        if(Scheme != null && Scheme != '' && fileName != null && fileName != ''){
            FileList=[select id,name,Columns__c,File_Type__c,Scheme__c,CreatedBy.Name,CreatedDate from Custom_Data_upload_file__c where Scheme__c=:Scheme AND name=:fileName];
        }
        return FileList;
    }
    
    public static User getLoggedinUserDetails(String UserId){
        List<User> LoggedInUser;
        
        if(UserId != null && UserId !=''){
            LoggedInUser = [select id, name, firstname, lastname, email,Emp_Id__c,isactive  from user where id = :UserId];
            if(LoggedInUser != null && LoggedInUser.size() > 0){
                return LoggedInUser[0];
            }
        }
        return null;    
    }

    public static List<Eligibility__c> getEligibilityforScheme(string selectedScheme){
        
        if(selectedScheme != null && selectedScheme != ''){
            List<Eligibility__c> EligiblityRecords=[select id,name,Scheme__c,Database_Driven__c,Benefit_Program__c,Employee_Class__c,Job_Region__c,Home_Country__c,Cost_Center__c,Officer__c,Pay_Company__c from Eligibility__c where Scheme__c=:selectedScheme limit 1];
            return EligiblityRecords;
        }
        else{
            return null;
        }
    }
    
    public static List<Report> getReports(String ReportAPIName){
        List<Report> ReportList;
        if(ReportAPIName != null && ReportAPIName.trim() != ''){
            ReportList=[select id,DeveloperName,name from report where DeveloperName=:ReportAPIName];
        }
        return ReportList;
    }
    
    //Have to check whether its gets referred somewhere or not used method.
    public static List<Eligible_Employees__c> getCurrentEligibleEmployeesList(string selectedScheme){
        if(selectedScheme != null && selectedScheme != ''){
            List<Eligible_Employees__c> EligibleSchemeList=[select id,name,Eligibility__c,Employee__r.Emp_ID__c,Eligibility__r.Scheme__c from Eligible_Employees__c where Eligibility__r.Scheme__c=:selectedScheme];
            return EligibleSchemeList;
        }
        else{
            return null;
        }
    }

    //Have to check whether its gets referred somewhere or not used method.
    public static boolean getEligibileEmployeesCheck(string selectedScheme){
        Boolean Eligibilitycheckflag;
        if(selectedScheme != null && selectedScheme != ''){
            List<Eligible_Employees__c> EligibleSchemeList=[select id,name,Eligibility__c,Employee__r.Emp_ID__c,Eligibility__r.Scheme__c from Eligible_Employees__c where Eligibility__r.Scheme__c=:selectedScheme Limit 2];
            if(EligibleSchemeList != null && EligibleSchemeList.size() >1){
                return true;
            }        
        }
        return false;
    }
    
    
    public static List<Employee__c> getEmployeeListonMSID(set<string> MSIDSet){
    
        if(MSIDSet != null && MSIDSet.size()>0){
            List<Employee__c> EmployeeLst=[select id,name,Emp_ID__c,Status__c  from Employee__c where Status__c = 'Active' AND Emp_ID__c IN:MSIDset];
            return EmployeeLst;
        }
        else{
            return null;
        }    
    }
    
    public static Map<String,Map<string,String>> getCustomDataFiles(set<string> fileIds){
        Map<String,Map<string,String>> fileMap;
        
        if(fileIds != null && fileIds.size() >0){
            List<Custom_Data_upload_file__c> CustomFileList=[select id,name,Columns__c,File_Type__c,Scheme__c from Custom_Data_upload_file__c where Id IN:fileIds AND File_Type__c='Text'];
            
            if(CustomFileList != null && CustomFileList.size() > 0){
                fileMap=new Map<String,Map<string,String>>(); 
                for(Custom_Data_upload_file__c c:CustomFileList){
                    Map<string,String> file=new Map<string,String>();
                    if(c.columns__c != null && c.columns__c.trim() != ''){
                        for(string s:c.columns__c.split(',')){
                            if(c.File_Type__c=='Text' && s.split('->') != null && s.split('->').size()==2){                    
                                file.put(s.split('->')[1],s.split('->')[0]);
                            }
                        } 
                        fileMap.put(c.Id,file);
                    }
                }
            }
        }
        return fileMap;
    }

    public static Map<string,Wav_Content__c > getTermsnConditions(set<string> schemeSet){
        Map<string,Wav_Content__c > TnCMap=new Map<string,Wav_Content__c >();
        
        if(schemeSet != null && schemeSet.size() >0){
            for(Wav_Content__c  wav:[select id,name,Content__c,Content_Type__c,Scheme__c from Wav_Content__c where Content_Type__c='Terms & Conditions' AND Scheme__c IN:schemeSet]){
                TnCMap.put(wav.Scheme__c,wav);
            }
        }
        return TnCMap;
    }
    
    public static List<Wav_Content__c> getPageContentManagementData(string schemeId){
        List<Wav_Content__c> Content;
        
        if(schemeId != null && schemeId != ''){
            set<string> contentTypes=WV_Utility.getSchemeContentTypeList();
            Content=[select id,name,Content__c,Content_Type__c,Scheme__c from Wav_Content__c where Scheme__c=:schemeId AND Content_Type__c IN:contentTypes];
        }
        return Content;
    }
    
    public static Map<String,Map<string,String>> getCustomDataFileMaps(string SchemeId){
        Map<String,Map<string,String>> fileMap;
        
        if(SchemeId != null && SchemeId.trim() != ''){
            List<Custom_Data_upload_file__c> CustomFileList=WV_Utility.getCustomFileUploads(SchemeId);
            
            if(CustomFileList != null && CustomFileList.size() > 0){
                fileMap=new Map<String,Map<string,String>>(); 
                for(Custom_Data_upload_file__c c:CustomFileList){
                    Map<string,String> file=new Map<string,String>();
                    
                    if(c.columns__c != null && c.columns__c.trim() != ''){
                        for(string s:c.columns__c.split(',')){
                            if(s.split('->') != null && s.split('->').size()==2){
                                if(c.File_Type__c=='Text'){                    
                                    file.put('@'+c.Name+'.'+s.split('->')[0].replaceAll(' ','_'),s.split('->')[1]);
                                }
                                else{
                                    file.put(s.split('->')[0].replaceAll(' ','_'),s.split('->')[1]);
                                }
                            }
                        }                     
                        fileMap.put(c.Id,file);
                    }
                }
            }
        }
        return fileMap;
    }
    
    public static Map<String,Map<string,List<String>>> getCustomDataFileMapsNew(string SchemeId){
        Map<String,Map<string,List<String>>> fileMap;
        
        if(SchemeId != null && SchemeId.trim() != ''){
            List<Custom_Data_upload_file__c> CustomFileList=WV_Utility.getCustomFileUploads(SchemeId);
            
            if(CustomFileList != null && CustomFileList.size() > 0){
                fileMap=new Map<String,Map<string,List<String>>>();
                for(Custom_Data_upload_file__c c:CustomFileList){
                    Map<String,List<string>> fileMapTemp=new Map<String,List<string>>();
                    List<String> file=new List<String>();
                    List<String> fileUnOrdered=new List<String>();
                    List<String> fileDESC=new List<String>();
                    
                    if(c.columns__c != null && c.columns__c.trim() != ''){
                        for(string s:c.columns__c.split(',')){
                            if(s != null && s.split('->') != null && s.split('->').size() >0){
                                if(c.File_Type__c=='Text'){                    
                                    file.add('@'+c.Name+'.'+s.split('->')[0].replaceAll(' ','_'));
                                }
                                else{
                                    file.add(s.split('->')[0].replaceAll(' ','_'));
                                }
                            }
                        } 
                        system.debug('*************fileunordered'+file);
                        
                        if(file != null && file.size()>0){  
                            fileUnOrdered=file.clone();                          
                            file.sort();
                            for(Integer k=file.size()-1;k>=0;k--){
                                fileDESC.add(file.get(k));
                            }
                            system.debug('*************fileordered'+fileDESC);                         
                            fileMapTemp.put('unordered',fileUnOrdered);   
                            fileMapTemp.put('ordered',fileDESC);                            
                            fileMap.put(c.Id,fileMapTemp);
                        }  
                        
                    }
                }
            }
        }
        return fileMap;
    }
    
    public Static Map<string,string> getCustomFileUploadType(string SchemeId){
        List<Custom_Data_upload_file__c> customfileList;
        Map<string,string> fileTypeMap;
        if(SchemeId != null && SchemeId != ''){            
            customfileList=[select id,name,Columns__c,File_Type__c,Scheme__c from Custom_Data_upload_file__c where Scheme__c=:SchemeId];
            if(customfileList != null && customfileList.size() > 0){
                fileTypeMap=new Map<string,string>();
                for(Custom_Data_upload_file__c c:customfileList){
                    if(c.File_Type__c=='Table'){
                        fileTypeMap.put(c.Id,c.File_Type__c+','+'@'+c.Name+'.table');
                    }
                    else{
                        fileTypeMap.put(c.Id,c.File_Type__c+','+'@'+c.Name+'.text');
                    }
                }
            } 
        }
        return fileTypeMap;
    }
    
    public static string getFullQueryFromSobject(Sobject SobjectName,string SobjectId){
        string queryString='';
        if(SobjectName != null){
            Map<string,Schema.SobjectField> fieldResults = SobjectName.getSObjectType().getDescribe().fields.getMap(); 
            queryString=queryString+'select ';
            for(string f:fieldResults.keySet()){
                queryString=queryString+fieldResults.get(f).getDescribe().getName()+', ';
            }  
            if(queryString.endsWith(', ')){
                queryString=queryString.removeEnd(', ');
            }
            queryString=queryString+' from '+SobjectName.getSobjectType();
            if(SobjectId != null && SobjectId != '' ){
                queryString=queryString+' where id=\''+SobjectId+'\'';
            }
        }
        return queryString;
    }

    public static List<Sobject> getQueryResults(String SobjectQuery){
        List<Sobject> results;
        if(SobjectQuery != null && SobjectQuery != ''){
           results = Database.query(SobjectQuery);
        }
        return results;
    }    
    
    public static List<election__c> getSchemeOpenStatus(string SchemeId){
        List<election__c> elections;
        
        if(SchemeId != null && SchemeId != ''){
            elections=[select id,name,scheme__c,isCancelled__c from election__c where Scheme__c=:SchemeId AND isCancelled__c=false];
        }
        return elections;
    }
    
    public static Map<string,string> getValidTemplates(){
        Map<string,string> tempMap=new Map<string,string>();
        List<Input_Controls_Mapping__c> inputControls =[select id,name,Scheme__c,Waiver_Template__c,Waiver_Template__r.name,Waiver_Template__r.CreatedDate,Value_Type__c,Required__c,Show_Currency__c,Input_control_type__c,order__c,Control_Visibility__c,CreatedDate from Input_Controls_Mapping__c where Waiver_Template__c != null AND Scheme__c=null AND Control_Visibility__c='Primary' AND (Input_control_type__c='List Capture' OR Input_control_type__c='Value Capture') Order by Waiver_Template__r.CreatedDate ASC];
        for(Input_Controls_Mapping__c I:inputControls ){
            if(!tempMap.containsKey(I.Waiver_Template__c)){
                tempMap.put(I.Waiver_Template__c,I.Waiver_Template__r.name);
            }
        }
        return tempMap;
    }
    
    public static List<Input_Controls_Mapping__c> getInputControls(string templateId,string schemeId){
        List<Input_Controls_Mapping__c> inputControls;
        
        if(templateId != null && templateId != '' && schemeId != null && schemeId != ''){
            inputControls =[select id,name,Scheme__c,Waiver_Template__c,Value_Type__c,Required__c,Show_Currency__c,Description__c,Percentage_validation__c,Input_control_type__c,Default_Minimum_Value__c,Default_Maximum_Value__c,Custom_Data_Values__c,Custom_Min__c,Custom_Max__c,Controlling_Field__c,Dependencies_Mapping__c,order__c,Control_Visibility__c from Input_Controls_Mapping__c where Waiver_Template__c=:templateId AND Scheme__c=:schemeId Order By order__c ASC];
            if(inputControls == null || inputControls.size() == 0){
                inputControls =[select id,name,Scheme__c,Waiver_Template__c,Value_Type__c,Required__c,Show_Currency__c,Description__c,Percentage_validation__c,Input_control_type__c,Default_Minimum_Value__c,Default_Maximum_Value__c,Custom_Data_Values__c,Custom_Min__c,Custom_Max__c,Controlling_Field__c,Dependencies_Mapping__c,order__c,Control_Visibility__c from Input_Controls_Mapping__c where Waiver_Template__c=:templateId AND Scheme__c=null  Order By order__c ASC];
                if(inputControls != null && inputControls.size() > 0){
                    inputControls=inputControls.clone();
                    for(Input_Controls_Mapping__c I:inputControls){
                        I.Id=null;
                    }
                }
            }
        }
        return inputControls;
    }
    
    
    public static Map<String,Custom_Data_upload_file__c> getFileRecords(string SchemeId){
        Map<String,Custom_Data_upload_file__c> files;
        
        if(SchemeId != null && SchemeId != ''){            
            files=new Map<String,Custom_Data_upload_file__c>([select id,name,Columns__c,File_Type__c,Scheme__c from Custom_Data_upload_file__c where Scheme__c=:SchemeId AND File_Type__c='Text']);
        }
        return files;
    }

    public Static List<Custom_Data_upload_file__c> getCustomFileUploads(string SchemeId){
        List<Custom_Data_upload_file__c> customfileList;
        
        if(SchemeId != null && SchemeId != ''){
            customfileList=[select id,name,Columns__c,File_Type__c,Scheme__c from Custom_Data_upload_file__c where Scheme__c=:SchemeId];
        }
        return customfileList;
    }
    
    public static List<OrgWideEmailAddress> getOrgWideAddressExceptions(){
        List<OrgWideEmailAddress> org=[select id,DisplayName, Address from OrgWideEmailAddress where DisplayName=:Label.WV_Exception_Email_Org_wide_Address];
        return org;
    }
    
    public static List<OrgWideEmailAddress> getOrgWideAddressDEVElectionEmails(){
        List<OrgWideEmailAddress> org=[select id,DisplayName, Address from OrgWideEmailAddress where DisplayName=:Label.WV_My_Elections_Dev_Team_OWD];
        return org;
    }
    
     public static List<Scheme__Share> getSharedOwnersonSchemeObject(Id recordId){
        List<Scheme__Share> usersList;
        if(recordId != null){
            usersList=[select UserOrGroupId,ParentId ,AccessLevel ,RowCause from Scheme__Share where ParentId=: recordId];     
        }
        return usersList;
    }
    
    public static List<wav_source__c > getActiveSources(){
        List<wav_source__c> activeSourceList=[select id,name,active__c from wav_source__c where active__c=true order by createddate ASC];
        return activeSourceList;
    }
    
    public static List<deferral__c> getActiveDeferrals(){
        List<deferral__c> activedeferrals=[select id,name,active__c from deferral__c where active__c=true order by createddate ASC];
        return activedeferrals;
    }
    
    public static List<wav_currency__c> getActiveCurrencies(){
        List<wav_currency__c > activedcurrencies=[select id,name,active__c from wav_currency__c where active__c=true order by createddate ASC];
        return activedcurrencies;
    }
    
    public static List<Abacus__c> getAbacusValues(){
        List<Abacus__c> AbacusValues=[select id,name from Abacus__c];
        return AbacusValues;
    }
    
    public static boolean geteligibleForDownloadEmployees(Eligibility__c e){
        if(e != null && (e.Benefit_Program__c != null || e.Job_Region__c != null || e.Home_Country__c != null || e.Cost_Center__c != null || e.Pay_Company__c != null)){
            return true;
        } 
        return false;
    }   
    
    public static set<string> getSchemeContentTypeList(){
        set<string> contentTypeSet=new set<string>{'Description','Introduction','Terms & Conditions','Links','Email Template - Election Submit/Update','Email Template - Election Cancellation'};
        return contentTypeSet;
    }
    
    public static Map<Id,List<Response__c>> getPrimaryResponseDetails(set<string> ElectionList){
    
        if(ElectionList != null && ElectionList.size() > 0){
            List<Response__c> Responselist=[select id,name,value_New__c,IsNumberControl_Internal_Use__c,MultiListName__c,Show_Currency_Percentage__c,Input_Controls_Mapping__c,Input_Controls_Mapping__r.Control_Visibility__c,Input_Controls_Mapping__r.Input_Control_Type__c,Input_Controls_Mapping__r.show_currency__c,Election__c,Election__r.Related_Enrolment__c,Election__r.Related_Enrolment__r.Active_Auto__c,Election__r.Related_Enrolment__r.End_Date__c,Input_Controls_Mapping__r.name from Response__c where Election__c IN:ElectionList AND Input_Controls_Mapping__r.Control_Visibility__c='Primary'];
            Map<Id,List<Response__c>> ElectionResponseMap=new Map<Id,List<Response__c>>();
            if(Responselist != null && Responselist.size()>0){
                for(Response__c r:Responselist){
                    if(ElectionResponseMap.containsKey(r.Election__c)){
                        ElectionResponseMap.get(r.Election__c).add(r);
                    }
                    else{
                        List<Response__c> res=new List<Response__c>();
                        res.add(r);
                        ElectionResponseMap.put(r.Election__c,res);           
                    }        
                }
            }
            return ElectionResponseMap;
        }
        return null;
    }
    
    public static Map<Id,List<Response__c>> getAllResponseDetails(set<string> ElectionList){
    
        if(ElectionList != null && ElectionList.size() > 0){
            List<Response__c> Responselist=[select id,name,value_New__c,IsNumberControl_Internal_Use__c,MultiListName__c,Show_Currency_Percentage__c,Input_Controls_Mapping__c,Input_Controls_Mapping__r.Input_Control_Type__c,Input_Controls_Mapping__r.show_currency__c,Input_Controls_Mapping__r.Custom_Data_Values__c,Input_Controls_Mapping__r.order__c,Election__c,Election__r.Related_Enrolment__c,Election__r.Related_Enrolment__r.Active_Auto__c,Election__r.Related_Enrolment__r.End_Date__c,Input_Controls_Mapping__r.Control_Visibility__c,Input_Controls_Mapping__r.name from Response__c where Election__c IN:ElectionList ORDER BY Input_Controls_Mapping__r.order__c ASC];
            Map<Id,List<Response__c>> ElectionResponseMap=new Map<Id,List<Response__c>>();
            if(Responselist != null && Responselist.size()>0){
                for(Response__c r:Responselist){
                    if(ElectionResponseMap.containsKey(r.Election__c)){
                        ElectionResponseMap.get(r.Election__c).add(r);
                    }
                    else{
                        List<Response__c> res=new List<Response__c>();
                        res.add(r);
                        ElectionResponseMap.put(r.Election__c,res);           
                    }        
                }
            }
            return ElectionResponseMap;
        }
        return null;
    }
    
    public static List<Election__c> getLoggedinEmployeeElections(Employee__c LoggedInEmployee){
    
        if(LoggedInEmployee != null &&  LoggedInEmployee.Emp_ID__c != null && LoggedInEmployee.Emp_ID__c != ''){
            List<Election__c> EmployeeElections=[select id,name,Employee__c,Scheme__c,Scheme__r.Name,Scheme__r.Source__c,Scheme__r.Source__r.name,Scheme__r.Source__r.Source_Order__c,Scheme__r.Source__r.Active__c,Scheme__r.Deferral__c,Scheme__r.Deferral__r.name,Scheme__r.Deferral__r.Active__c,Scheme__r.Waiver_Template__c,Scheme__r.Waiver_Template__r.Name,Scheme__r.Scheme_Currency__c,Scheme__r.Scheme_Currency__r.value__C,CreatedDate,LastModifiedDate,isCancelled__c,Related_Enrolment__c,Related_Enrolment__r.Active_Auto__c,Related_Enrolment__r.end_date__c from Election__c where (Scheme__c != null AND Employee__c=: LoggedInEmployee.Id AND isCancelled__c=false ) ORDER BY CreatedDate DESC ]; 
            return EmployeeElections;
        }
        else{
            return null;
        }
    }     
    
    public static List<Election__c> getElectionDetails(String electionId){
    
        if(electionId != null && electionId != ''){
            List<Election__c> EmployeeElections=[select id,name,Employee__c,Scheme__c,Scheme__r.Name,Scheme__r.Source__c,Scheme__r.Source__r.name,Scheme__r.Source__r.Source_Order__c,Scheme__r.active__c,Scheme__r.Source__r.Active__c,Scheme__r.Term__c,Scheme__r.Deferral__c,Scheme__r.Deferral__r.name,Scheme__r.Deferral__r.Active__c,Scheme__r.Waiver_Template__c,Scheme__r.Waiver_Template__r.Name,Scheme__r.Scheme_Currency__c,Scheme__r.Scheme_Currency__r.Value__c,CreatedDate,LastModifiedDate,isCancelled__c,Related_Enrolment__c,Related_Enrolment__r.Active_Auto__c,Related_Enrolment__r.end_date__c from Election__c where Id=:electionId]; 
            return EmployeeElections;
        }
        else{
            return null;
        }
    }
    
     public static Map<String,Integer> getLastEnrolment(set<string> schemeSet){
        Map<String,Integer> SchemeEnrolMap=new Map<String,Integer>();
        
        if(schemeSet != null && schemeSet.size() >0){
            List<Enrollment_Period__c> eligibleEnrolments=[select id,name,Override_Scheme__c,Override_Scheme__r.Term__c,Override_Scheme__r.Active__c,Active_auto__c,Start_Date__c,End_Date__c from Enrollment_Period__c where (Override_Scheme__c IN:schemeSet AND Start_Date__c <=:system.now() )order by Start_Date__c DESC];
            
            for(Enrollment_Period__c enrol:eligibleEnrolments){
                if(!SchemeEnrolMap.containsKey(enrol.Override_Scheme__c)){
                    SchemeEnrolMap.put(enrol.Override_Scheme__c,enrol.start_date__c.year());
                }
            } 
        }  
        return SchemeEnrolMap;
    }    
    
    public static Map<String,Map<string,Enrollment_Period__c>> getCurrentSchemeEnrolment(set<string> schemeSet,Map<string,Integer> relatedYearMap){
        Map<String,Map<string,Enrollment_Period__c>> SchemeEnrolMap=new Map<String,Map<string,Enrollment_Period__c>>();
        
        if(schemeSet != null && schemeSet.size() >0 && relatedYearMap != null){        
            set<Integer> Allyears=new set<integer>(relatedYearMap.values());            
            List<Enrollment_Period__c> eligibleEnrolments=[select id,name,Override_Scheme__c,Override_Scheme__r.Term__c,Override_Scheme__r.Active__c,Active_auto__c,Start_Date__c,End_Date__c from Enrollment_Period__c where ( Override_Scheme__c IN:schemeSet AND (CALENDAR_YEAR(Start_Date__c) IN:Allyears))];
            List<scheme__c> schemes=[select id,name,term__c from scheme__c where id IN:schemeSet AND term__c='open'];
            
            if(eligibleEnrolments != null && eligibleEnrolments.size() >0){
                for(Enrollment_Period__c enrol:eligibleEnrolments){
                    if(relatedYearMap.containsKey(enrol.Override_Scheme__c) && relatedYearMap.get(enrol.Override_Scheme__c)==enrol.Start_Date__c.year()){
                        if(SchemeEnrolMap.containskey(enrol.Override_Scheme__c)){
                            SchemeEnrolMap.get(enrol.Override_Scheme__c).put(enrol.Id,enrol);
                        }
                        else{
                            Map<string,Enrollment_Period__c> newenrolMap=new Map<string,Enrollment_Period__c>();
                            newenrolMap.put(enrol.Id,enrol);
                            SchemeEnrolMap.put(enrol.Override_Scheme__c,newenrolMap);
                        }
                    }        
                }
            }
            
            if(schemes !=null && schemes.size() >0){
                for(scheme__c s:schemes){
                    if(!SchemeEnrolMap.containsKey(s.Id)){
                        Map<string,Enrollment_Period__c> newenrol=new Map<string,Enrollment_Period__c>();
                        newenrol.put('open',null);
                        SchemeEnrolMap.put(s.Id,newenrol);
                    }
                }
            }        
        }
        
        return SchemeEnrolMap;
    }
    
    public static Map<String,Integer> getPASTEnrolment(Map<String,Map<string,Enrollment_Period__c>> CurrentSchemeenrolMap){
        set<string> allenrols=new set<string>();
        Map<String,Integer> SchemeEnrolMap=new Map<String,Integer>();
        
        if(CurrentSchemeenrolMap != null && CurrentSchemeenrolMap.keyset() != null && CurrentSchemeenrolMap.keyset().size() >0){
            for(Map<string,Enrollment_Period__c> each:CurrentSchemeenrolMap.values()){
                if(each != null && each.keyset()!=null && each.keyset().size()>0){
                        if(each.keyset().size()==1 && each.keyset().contains('open')){
                            
                        }
                        else{
                            allenrols.addall(each.keyset());
                        }
                }
            }
            
            List<Enrollment_Period__c> pastEnrolments=[select id,name,Override_Scheme__c,Override_Scheme__r.Term__c,Override_Scheme__r.Active__c,Active_auto__c,Start_Date__c,End_Date__c from Enrollment_Period__c where Id not IN:allenrols AND Override_Scheme__c IN:CurrentSchemeenrolMap.keyset() AND Start_Date__c <=:system.now() order by Start_Date__c DESC];
            
            if(pastEnrolments != null && pastEnrolments.size() >0){
                for(Enrollment_Period__c enrol:pastEnrolments){
                    if(!SchemeEnrolMap.containsKey(enrol.Override_Scheme__c)){
                        SchemeEnrolMap.put(enrol.Override_Scheme__c,enrol.start_date__c.year());
                    }
                } 
            }
        }   
        return SchemeEnrolMap;
    }   
    
    @future(callout=false)
    public static void captureExceptionFuture(string appName,string location,string description,string stackTrace,string URL,string Environment,List<string> emailIdList,string affectedUser){
        Try{
            if(appName != null && appName.trim() != '' && location != null && location.trim() != '' && description != null && description.trim() != '' && affectedUser!= null && affectedUser.trim() != ''){
                List<user> users=[select id,emp_ID__c from user where id=:affectedUser.trim()];
                if(users != null && users.size() >0){
                    if(URL.length() >255){
                        URL=URL.substring(0,255);
                    }
                    Exception_Logs__c Ex=new Exception_Logs__c(Application_Name__c=appName,Error_Description__c=description,Exception_Location__c=location,Who_got_this__c=affectedUser,Stack_Trace__c=stackTrace,Page_URL__c=URL,Environment__c=Environment,Affected_User_MSID__c=users[0].emp_Id__c);
                    insert Ex;
                }
            } 
        }
        Catch(Exception e){
            system.debug('****Exception in sending exception log emails inside captureExceptionFuture'+e.getmessage()+'-'+e.getlinenumber());
        }
    }     
    
    public static void captureException(string appName,string location,string description,string stackTrace,string URL,string Environment,List<string> emailIdList,string affectedUser){
        Try{
            if(appName != null && appName.trim() != '' && location != null && location.trim() != '' && description != null && description.trim() != '' && affectedUser!= null && affectedUser.trim() != ''){
                List<user> users=[select id,emp_ID__c from user where id=:affectedUser.trim()];
                if(users != null && users.size() >0){
                    if(URL.length() >255){
                        URL=URL.substring(0,255);
                    }
                    Exception_Logs__c Ex=new Exception_Logs__c(Application_Name__c=appName,Error_Description__c=description,Exception_Location__c=location,Who_got_this__c=affectedUser,Stack_Trace__c=stackTrace,Page_URL__c=URL,Environment__c=Environment,Affected_User_MSID__c=users[0].emp_Id__c);
                    insert Ex;
                }
            } 
        }
        Catch(Exception e){
            system.debug('****Exception in sending exception log emails inside captureException'+e.getmessage()+'-'+e.getlinenumber());
        }
    } 
    
    public static void doActivateUsers(List<String> CurrentList){
        if(CurrentList != null && CurrentList.size() >0){
            set<string> setIds=new set<string>(CurrentList);
            List<user> inactiveusers=[select id,isactive from user where Id IN:setIds and isactive=false];
            if(inactiveusers != null && inactiveusers.size() >0){
                for(user u:inactiveusers){
                    u.isactive=true;
                }  
                update  inactiveusers;
            }
        }
    }
    
    @future(Callout=true)
    public static void doActivateUsers(Id userId){
        try{
            if(userId != null){
                User u=new User(Id=userId,isactive=true);
                update u;
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside WV_Utility.doActivateUsers()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
    }
    
    
    public static string getEmailTemplate(){
        String temp='';
        
        temp+='<body style="width: 100% !important;background-color: #f2f2f2; margin: 0px; margin-top:20px;padding: 0px; width: 100%; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; height: 100%; border: 0; font-size: 100%; line-height: 1;" leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" yahoofix="">'+
               '<div style="display:@recipient">'+
                    'Recipients: <br/>TO:&nbsp;@EmployeeEmail'+
                    '<p style="line-height:115%">'+
                       '<span style="font-size:12px;line-height:115%;font-family:Arial,Helvetica,sans-serif;"></span>'+
                    '</p>'+
               '</div>'+
                '<table align="center" bgcolor="#f2f2f2" height="100%" width="100%" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
                    '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                        '<td align="center" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">'+
            
                            '<table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
            
                                '<tr style="margin: 0; border: 0; font-size: 100%;">'+
            
                                    '<td class="container" align="center" valign="top" width="800" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%; width: 800px;">'+
            
                                        '<table border="0" cellpadding="0" cellspacing="0" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
                        
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td colspan="3" align="left" bgcolor="#002B51" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">'+
                                                    '<table cellspacing="0" cellpadding="0" border="0" style="-webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%; border-collapse: collapse;">'+
                                                        '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                            '<td style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"><img src="@mslogourl" alt="" border="0" style="display: block; -ms-interpolation-mode: bicubic; line-height: 100%; outline: 0; text-decoration: none; margin: 0; border: 0; font-size: 100%;" align="top" />'+
                                                             '<td width="5" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                                              '<td style="font-family: Arial; color: #009AD9; padding-bottom: 2px; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">My Elections</td>'+
                                                        '</tr>'+





                                                    '</table>'+
                                                '</td>'+
                                            '</tr>'+
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td colspan="3" height="32" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                            '</tr>'+
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td width="33" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                                '<td style="background-color: #ffffff; border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;">'+
                                                    '<table style="border-collapse: collapse; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; mso-table-lspace: 0; mso-table-rspace: 0; margin: 0; border: 0; font-size: 100%;font-family: Arial;font-size: 14px;color: #555555;" cellspacing="0" cellpadding="0" border="0">'+
                                                        '@MyEmailBody'+
                                                    '</table>'+
                                                '</td>'+
                                                '<td width="33" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                            '</tr>'+
                                            '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                                                '<td colspan="3" height="32" bgcolor="#ffffff" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                                            '</tr>'+
                                        '</table>'+
                                    '</td>'+
                                '</tr>'+
                            '</table>'+
                        '</td>'+
                    '</tr>'+
                    '<tr style="margin: 0; border: 0; font-size: 100%;">'+
                        '<td height="50" style="border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; margin: 0; border: 0; font-size: 100%;"></td>'+
                    '</tr>'+
                '</table>'+
            '</body>';
            
            return temp;
    }
    
    public static string getActualEmailBody(election__C election,String content){
        
        if(content != null && election != null && election.Id != null){
            if(content.contains('@FirstName') && election.Employee__r.First_Name__c!= null){
                content=content.replaceALL('@FirstName',election.Employee__r.First_Name__c);
            }
            if(content.contains('@LastName') && election.Employee__r.Last_Name__c!= null){
                content=content.replaceALL('@LastName',election.Employee__r.Last_Name__c);
            }
            if(content.contains('@ElectionName') && election.Scheme_name_dummy__c != null){
                content=content.replaceALL('@ElectionName',election.Scheme_name_dummy__c);
            }
            if(content.contains('@DateTime') && election.LastModifiedDate != null){
                content=content.replaceALL('@DateTime',election.LastModifiedDate.format(Label.WV_EmailTemplate_DatetimeFormat));
            }
            /*if(content.contains('@Url')){
                content=content.replaceALL('@Url','<a href="'+Label.DG_BaseUrl+'/apex/WV_Homepage" target="_blank">here</a>');
            }*/
        }
        
        return content ;
    
    }
    
    public static string getMergedEmailContent(election__C election,String temp,string contentBody){
        String logoURL='';
        List<Document> mslogo=[select id,developername from document where developername='MS_Logos'];
        if(mslogo != null && mslogo.size() ==1){
            logoURL=Label.DG_BaseUrl+'/servlet/servlet.ImageServer?id='+mslogo[0].Id+'&oid='+UserInfo.getOrganizationId();
        }
        
        if(temp != null && contentBody != null){
            
            if(contentBody.contains('@Url')){
                if(Label.ORG_ENVIRONMENT.tolowercase() == 'prod'){
                    contentBody=contentBody.replaceALL('@Url','<a href="http://myelections" target="_blank">here</a>');                    
                }
                else if(Label.ORG_ENVIRONMENT.tolowercase() == 'uat'){
                    contentBody=contentBody.replaceALL('@Url','<a href="http://myelectionsuat" target="_blank">here</a>');
                }
                else{
                    contentBody=contentBody.replaceALL('@Url','<a href="'+Label.DG_BaseUrl+'/apex/WV_Homepage" target="_blank">here</a>');
                }
            }
            
            if(temp.contains('@MyEmailBody')){
                temp=temp.replaceAll('@MyEmailBody',contentBody);
            }
            
            if(temp.contains('@EmployeeEmail') && election.Employee__r.Email__c!= null){
                temp=temp.replaceAll('@EmployeeEmail',election.Employee__r.Email__c);
            }
            
            if(temp.contains('@mslogourl') && logoURL != null){
                temp=temp.replaceAll('@mslogourl',logoURL);
            }
            
            if(Label.ORG_ENVIRONMENT.tolowercase() != 'prod' && temp.contains('@recipient')){
                temp=temp.replaceAll('@recipient','block');
            }
            else if(temp.contains('@recipient')){
                temp=temp.replaceAll('@recipient','none');
            }
        }  
        
        return temp;  
    }    
    
    /* Date: 7/12/2017
     * Changes done to remove the use of Dev Team mail group 
     * and use the ORG wide email for ToAddress in the NON-PROD environments.
    */
    public static void sendElectionEmails(election__c e,string emailid,string body,string type){ 
        List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
        
        String orgname=Label.ORG_ENVIRONMENT;
        List<OrgWideEmailAddress> org=WV_Utility.getOrgWideAddressExceptions();
        List<String> toAddresses=new List<String>();
        
        if (e != null && e.Id != null && emailid != null && emailid.trim() != '' && org !=null && org.size() >0 && body != null){
            if(orgname.tolowercase()!='prod'){  //if its non-production environment then send email mail group specific for environment.
                toAddresses.add(org[0].address);
            }
            else{//if its production then send email to actual employees with no users in CC addresses.                 
                 toAddresses.add(emailid);
            }
              
            email.setOrgWideEmailAddressId(org[0].Id);
            email.setHtmlBody(Body);
            if(type != null && type =='Cancellation'){
              email.setSubject('My Elections: Election Cancellation');
            }
            else if(type != null && type =='Submission'){
              email.setSubject('My Elections: Election Confirmation');
            }
            
            if(toAddresses.size() >0){
                email.setToAddresses(toAddresses);
            }                                             
            emailList.add(email);
        }
        
        if (emailList.size() > 0) { 
            List<Messaging.SendEmailResult> result=Messaging.sendEmail(emailList);
        }
    }
          
}