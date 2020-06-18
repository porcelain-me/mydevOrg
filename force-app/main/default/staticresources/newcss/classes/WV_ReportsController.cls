public class WV_ReportsController {

    public string schemeID {get; set;}
    public List<selectoption> EligibleSchemesList {get; set;}
    public string loggedinUserpermissionSet {get; set;}    
    public string SchemeAdmin_DetailReport_ElectionOnly {get; set;}
    public string SchemeAdmin_DetailReport_ListValueOnly {get; set;}
    public string SchemeAdmin_DetailReport_MulitListOnly  {get; set;}    
    public string BizAdmin_DetailReport_ElectionOnly {get; set;}
    public string BizAdmin_DetailReport_ListValueOnly {get; set;}
    public string BizAdmin_DetailReport_MulitListOnly  {get; set;}    
    public string Election_DetailReport_Enrol_ElectionOnly {get; set;}
    public string Election_DetailReport_Enrol_ListValueOnly {get; set;}
    public string Election_DetailReport_Enrol_MulitListOnly  {get; set;}    
    public string enrolment {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    public boolean showEnrolment {get; set;}    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    
    public WV_ReportsController(){
       try{
           EligibleSchemesList = new List<selectoption>();
           EligibleSchemesList.add(new selectoption('','-------Select-------'));
           set<Id> schemeIds=new Set<ID>();
           List<scheme__c> schemes;
           exp=null;
           set<string> reports=new set<string>();
           reports.add('Election_Detail_Report_Sheet_01');
           reports.add('Election_Detail_Report');
           reports.add('Election_Detail_Multi_list_Report');
           
           reports.add('Election_Detail_Report_Sheet_01_Biz');
           reports.add('Election_Detail_Report_Biz');
           reports.add('Election_Detail_Multi_list_Report_Biz');
           
           reports.add('Election_Detail_Report_Sheet_01_Enrol');   
           reports.add('Election_Detail_Report_Enrol');   
           reports.add('Election_Detail_Multi_list_Report_Enrol');       
           
           set<string> allowedpermissionSets=new set<string>();
           allowedpermissionSets.add('My_Elections_Biz_Admin');
           allowedpermissionSets.add('My_Elections_Scheme_Admin');
           allowedpermissionSets.add('My_Elections_HRSC_admin');
           showEnrolment=false;
           
           String urlString=URL.getSalesforceBaseUrl().toExternalForm();
           String PageURL = ApexPages.currentPage().getUrl(); 
           currentPageURL = urlString+PageURL;
           OrgName=Label.ORG_ENVIRONMENT;               
            
           List<Report> ReportList = [SELECT DeveloperName,Format,Id,Name FROM Report WHERE DeveloperName IN:reports];           
           
           if(ReportList != null && ReportList.size()>0){
               for(Report f:ReportList){
                   if(f.developername == 'Election_Detail_Report_Sheet_01'){
                       SchemeAdmin_DetailReport_ElectionOnly = f.Id;
                   }
                   if(f.developername == 'Election_Detail_Report'){
                       SchemeAdmin_DetailReport_ListValueOnly = f.Id;
                   }
                   if(f.developername == 'Election_Detail_Multi_list_Report'){
                       SchemeAdmin_DetailReport_MulitListOnly  = f.Id;
                   }
                   
                   if(f.developername == 'Election_Detail_Report_Sheet_01_Biz'){
                       BizAdmin_DetailReport_ElectionOnly= f.Id;
                   }
                   if(f.developername == 'Election_Detail_Report_Biz'){
                       BizAdmin_DetailReport_ListValueOnly = f.Id;
                   }
                   if(f.developername == 'Election_Detail_Multi_list_Report_Biz'){
                       BizAdmin_DetailReport_MulitListOnly  = f.Id;
                   }
                   
                   if(f.developername == 'Election_Detail_Report_Sheet_01_Enrol'){
                       Election_DetailReport_Enrol_ElectionOnly = f.Id;
                   }
                   if(f.developername == 'Election_Detail_Report_Enrol'){
                       Election_DetailReport_Enrol_ListValueOnly = f.Id;
                   }
                   if(f.developername == 'Election_Detail_Multi_list_Report_Enrol'){
                       Election_DetailReport_Enrol_MulitListOnly  = f.Id;
                   }
               }
           }
           
           List<PermissionSetAssignment> userPermissionSets =   [SELECT Assignee.Name, AssigneeId,PermissionSet.Id,PermissionSet.name FROM PermissionSetAssignment where AssigneeId=:Userinfo.getuserID() AND PermissionSet.name IN:allowedpermissionSets];       
           
           if(userPermissionSets != null && userPermissionSets.size()>0){
               loggedinUserpermissionSet=userPermissionSets[0].PermissionSet.name;
           }
           
           if(loggedinUserpermissionSet != null){
               if(loggedinUserpermissionSet == 'My_Elections_Scheme_Admin' || loggedinUserpermissionSet == 'My_Elections_HRSC_admin'){
                   List<Scheme__Share> SchemesList=[select UserOrGroupId,ParentId,AccessLevel ,RowCause from Scheme__Share where UserOrGroupId=:Userinfo.getuserID()]; 
                   
                   if(SchemesList != null && SchemesList.size() >0){
                       for(Scheme__Share s:SchemesList){ 
                           schemeIds.add(s.ParentId);
                       } 
                   }
                   
                   if(schemeIds != null && schemeIds.size() >0){
                       schemes=[select id,name,Createddate from scheme__c where id IN:schemeIds Order by name ASC];
                   }
               }
               else{
                   schemes=[select id,name,Createddate from scheme__c Order by name ASC];
               }
           }
    
                     
    
           if(schemes != null && schemes.size() >0){
               if(loggedinUserpermissionSet == 'My_Elections_Biz_Admin'){
                   EligibleSchemesList.add(new selectoption('All','All'));
               }
               for(scheme__c sch:schemes){
                   EligibleSchemesList.add(new selectoption(String.ValueOf(sch.Id).substring(0,15),sch.name));
               }
               
           }
       }
       Catch(Exception exp){
           system.debug('****exception in constructor of WV_ReportsController()'+exp.getmessage()+'--'+exp.getlinenumber());
           customPageMessage=PAGE_ERROR;
       }
       
    }
    
    public Pagereference UpdateSchemeinLinks(){  
        customPageMessage=null;
        try{  
            showEnrolment=false;  
            enrolment=null;
            if(schemeID != null && schemeID.trim() != '' && schemeID != 'All'){
                List<scheme__C> schemeList=[select id,term__c from scheme__c where id=:schemeID];
                if(schemeList != null && schemeList.size() >0){
                    if(schemeList[0].term__c == 'Fixed'){
                        showEnrolment=true;
                    }
                }
            } 
        }
        Catch(Exception e){
           system.debug('****exception in constructor of WV_ReportsController()'+e.getmessage()+'--'+e.getlinenumber());
           customPageMessage=PAGE_ERROR;
           WV_Utility.captureException('My Elections','Reports Tab --> UpdateSchemeinLinks()','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());      
        }
        return null;
    }
    
    public List<selectoption> getEnrolments(){
        List<selectoption> enrolments=new List<selectoption>();            
        try{
            enrolments.add(new selectoption('','-------All-------'));
            if(schemeID != null && schemeID.trim() != null && schemeID.trim() != 'All'){
                List<Enrollment_Period__c> enrolList=[select id,name,start_date__c, end_date__c,Override_Scheme__c from Enrollment_Period__c where Override_Scheme__c=:schemeID order By start_date__c ASC];
                if(enrolList != null && enrolList.size() >0){
                    for(Enrollment_Period__c e:enrolList){                        
                        enrolments.add(new selectoption(String.ValueOf(e.Id).substring(0,15),e.start_date__c.format()+' -to- '+e.end_date__c.format()));
                    }
                }
            } 
        }  
        Catch(Exception e){
            system.debug('****Exception inside getEnrolments()'+e.getmessage()+'--'+e.getlinenumber());
        }
    
        return enrolments;
    }
    
    public Pagereference UpdateEnrolmentinLinks(){ 
        return null;
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){
                WV_Utility.captureException('My Elections','Reports -->Constructor','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }    
    
}