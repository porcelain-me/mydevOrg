//06/18/2013 RA: Created for bulk override S&R records values for "Project Based Termination" type projects.
//
//


public without sharing class RIF_BulkUpdateSeveranceRelease {
    
    private integer defaultPageSize = 50;
    public string projectId {get;set;}
    public ApexPages.StandardSetController con{get; set;}
    public string selectedSRId {get;set;}
    public Severance_And_Release__c srTemp{get;set;}
    private string CALCULATE_AND_RETAIN_MANUAL_CHANGES = 'Calculate And Retain Manual Changes';
    public list<SeveranceAndReleaseList> srList {
        get{
           if(con != null){
               return prepareSeveranceAndReleaseList((list<Severance_And_Release__c>)con.getRecords());
           }
           else{
               return null;
           }
        }
        set;}
    
    public RIF_BulkUpdateSeveranceRelease (){
        projectId = ApexPages.currentPage().getParameters().get('projectId');
        srList = new list<SeveranceAndReleaseList>();
        srTemp = new Severance_And_Release__c(RecordTypeId = getProjectBasedTerminationRecordType());
        getSRRecords();
    }
    
    public string getProjectBasedTerminationRecordType(){
        for(RecordType rt : RIF_DataUtil.getRecordTypeForName(Label.RIF_ProjectBasedTermination)){
            if(rt.SobjectType == 'Severance_And_Release__c'){
                return rt.Id;
            }
        }
        return '';
    }
 
    //Boolean to check if there are more records after the present displaying records
    public Boolean hasNext{
        get{
            if(con != null){
                return con.getHasNext();
            }
            return false;
        }
        set;
    }
 
    //Boolean to check if there are more records before the present displaying records
    public Boolean hasPrevious{
        get{
            if(con != null){
                return con.getHasPrevious();
            }
            return false;
        }
        set;
    }
 
    //Page number of the current displaying records
    public Integer pageNumber{
        get{
            if(con != null){
                return con.getPageNumber();
            }
            return null;
        }
        set;
    }
    
    //Page size of the current displaying records
    public Integer pageSize{
        get{
            if(con != null){
                return con.getPageSize();
            }
            return null;
        }
        set;
    }
    
    //Rage size of the current displaying records
    public Integer resultSize{
        get{
            if(con != null){system.Debug('resultSize: '+ con.getResultSize());
                return con.getResultSize();
            }
            return null;
        }
        set;
    }

    //Returns the previous page of records
    public void previous(){
        con.save();
        con.previous();
    }
 
    //Returns the next page of records
    public void next(){
        con.save();
        con.next();
    }
    
    public Pagereference getSRRecords(){
        if(projectId != null && projectId != ''){
            con = null;
            con = new ApexPages.StandardSetController(Database.getQueryLocator(
            [select id, Project_Level__c, Project_Level__r.Project__c, Emp_Id__c, Name, Employee__c, WARN__c, 
                      LOS_1__c,Enhanced_Severance_Local_Override__c,Weekly_Rate__c,Daily_Rate__c,Total_Week_Of_Severance__c,
                     Cobra_One_Month__c, Base_Salary__c,Additional_Severance_Override1__c,Basic_Severance_Local_Override__c,Cobra_Override__c ,
                    Additional_Notice_Override__c, Enhanced_Severance_Local_SetB__c, First_Name__c, Last_Name__c, 
                    Cobra_SetB__c,Basic_Severance_Local_SetB__c, Additional_Severance_Local_SetB__c, Status__c
                      
                from Severance_And_Release__c 
                where Project_Level__r.Project__c = :projectId]));
             //, Notice_Days_Override2__c
            // sets the number of records in each page set  
            con.setPageSize(defaultPageSize);
        }else{
            con = null;
        }
        return null;
    }
    
    public Pagereference Save(){
            
        integer page = con.getPageNumber();
        updateSRList();
        getSRRecords();
        con.setPageNumber(page);
        return null;
    }
    
    public Pagereference saveAndReturn(){
        Save();
        if(ApexPages.hasMessages()){
            return null;
        }   
        return new PageReference('/'+projectId);
    }
    
    private void updateSRList(){
        list<Severance_And_Release__c> srUpdate = new list<Severance_And_Release__c>();
        for(SeveranceAndReleaseList srl : srList){
            srl.srRecord.Recalculation_Type__c = CALCULATE_AND_RETAIN_MANUAL_CHANGES;
            srUpdate.add(srl.srRecord);
        }
        system.debug('srUpdate: '+ srUpdate);
        //update srUpdate;
        list<ApexPages.Message> pageMessage = RIF_DataUtil.upsertResult(srUpdate); 
        system.debug('errormsg: '+pageMessage);
        if(!pageMessage.isEmpty()){
            ApexPages.getMessages().clear();
            for(ApexPages.Message msg : pageMessage){
                ApexPages.addMessage(msg);
            } 
        } 
    }
    
    public List<SeveranceAndReleaseList> prepareSeveranceAndReleaseList(List<Severance_And_Release__c> srList){
        List<SeveranceAndReleaseList> srListTemp = new List<SeveranceAndReleaseList>();
        for(Severance_And_Release__c sr :srList){
            string empName = '';
            if(sr.Emp_Id__c <> null ){
                empName = (sr.First_Name__c != null? sr.First_Name__c : '') + ' ' 
                   + (sr.Last_Name__c != null? sr.Last_Name__c : '');
            }
            
            srListTemp.Add(new SeveranceAndReleaseList(sr, empName));
            
        }
        return srListTemp;
    }
    
    
    public class SeveranceAndReleaseList{
        public Severance_And_Release__c srRecord{get;set;}
        public string empName{get;set;}
        
        public SeveranceAndReleaseList(Severance_And_Release__c sr, string employeeName){
            srRecord = sr;
            empName = employeeName;
        }   
        public SeveranceAndReleaseList(){
            srRecord = Null;
            empName = null;
        }
    }
    
}