public class WV_BatchStatusBar{
 
    public List<BatchJob> batchJobs;
    public string ClassName{get; set;}
    public Integer numberOfJobs {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    
    public WV_BatchStatusBar(){
        try{
            ClassName= ApexPages.Currentpage().getParameters().get('ClassName');
            numberOfJobs=1;
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null;            
            OrgName=Label.ORG_ENVIRONMENT;                                
        }
        Catch(Exception e){
            system.debug('****Exception in WV_BatchStatusBar()'+e.getmessage()+'--'+e.getlinenumber());
            exp=e;
        }
    }
 
    public List<BatchJob> getBatchJobs(){
        batchJobs = new List<BatchJob>(); 
        try{            
            //Query the Batch apex jobs for eligibilty file.,
            if(ClassName != null && numberOfJobs != null){
                List<AsyncApexJob> AsyncJobs=WV_Utility.getAsyncJobsOnEligibilityStatus(ClassName,numberOfJobs);
                
                if(AsyncJobs != null && AsyncJobs.size()>0){
                    for(AsyncApexJob a :AsyncJobs){
                        Double itemsProcessed = a.JobItemsProcessed;
                        Double totalItems = a.TotalJobItems;
             
                        BatchJob j = new BatchJob();
                        j.job = a;
                        j.CreatedDate = a.CreatedDate.format();
                        j.CreatedById = a.CreatedBy.Name ;
                        j.Status = a.Status ;
                        if(a.CompletedDate != null){
                            j.CompletedDate = a.CompletedDate.format();
                        }
                        else{
                            j.CompletedDate ='';
                        }
                        j.NumberOfErrors = a.NumberOfErrors ;
                        if(a.NumberOfErrors >0 && j.CompletedDate != null){
                            j.Status='Failed';
                        }
                        //Determine the pecent complete based on the number of batches complete
                        if(totalItems == 0){
                            //A little check here as we don't want to divide by 0.
                            j.percentComplete = 0;
                        }else{
                            j.percentComplete = ((itemsProcessed  / totalItems) * 100.0).intValue();
                        }
                        batchJobs.add(j);
                    }
                }
            }
        }
        Catch(Exception e){
            system.debug('****Exception in getBatchJobs()'+e.getmessage()+'--'+e.getlinenumber());            
        }
        return batchJobs;
    }
 
    //This is the wrapper class the includes the job itself and a value for the percent complete
    public Class BatchJob{
        public AsyncApexJob job {get; set;}
        public string CreatedDate {get; set;}
        public string CreatedById {get; set;}
        public string Status {get; set;}
        public string CompletedDate {get; set;}
        public Integer NumberOfErrors {get; set;}
        public Integer percentComplete {get; set;}
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){       
                WV_Utility.captureException('My Elections','Eligibility status bar page','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('***Exception inside WV_BatchStatusBar class, sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }
    
 
}