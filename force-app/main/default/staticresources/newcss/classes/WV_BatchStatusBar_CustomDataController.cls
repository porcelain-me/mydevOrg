public class WV_BatchStatusBar_CustomDataController{
 
    public List<BatchJob> batchJobs;
    public datetime Dt;
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;} 
    public exception exp{get; set;} 
    public string OrgName {get; set;}
    
    public WV_BatchStatusBar_CustomDataController(){
        try{
            dt=System.now().addseconds(-30);
            String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = urlString+PageURL;
            exp=null;            
            OrgName=Label.ORG_ENVIRONMENT;                               
        }
        Catch(Exception ex){
            system.debug('****exception inside WV_BatchStatusBar_CustomDataController()'+ex.getMessage()+'--'+ex.getLineNumber());
            exp=ex;  
        }
    }
 
    public List<BatchJob> getBatchJobs(){
        try{
            batchJobs = new List<BatchJob>();
            Integer itemsProcessed=0; 
            Integer totalItems=0;
            Integer NumberOfErrors=0;
            Double NumberOfNormalBatches=0;
            Double NumberOfOpenScheduledBatches=0;
            Double PercentageSplit;           
            set<string> statusList=new set<string>();
            Integer ints=1;
            string completedDate=null;
            
            if(Dt != null){
                //Query the Batch apex jobs
                List<AsyncApexJob> AsyncList=WV_Utility.getAsyncJobsOnCustomDataFileStatus(Dt);
                
                if(AsyncList != null && AsyncList.size() > 0){
                    BatchJob j = new BatchJob();
                    
                    for(AsyncApexJob a : AsyncList){
                        if(a.JobItemsProcessed != 0){
                            itemsProcessed = itemsProcessed + a.JobItemsProcessed;
                        }
                        if(a.TotalJobItems != 0){
                            totalItems = totalItems +a.TotalJobItems;
                        }
                        if(a.NumberOfErrors != 0){
                            NumberOfErrors = NumberOfErrors +a.NumberOfErrors ;
                        }
                        
                        if(a.ApexClass.Name=='ReadAndPopulateBatch'){
                            NumberOfNormalBatches=NumberOfNormalBatches+1;
                        }
                        if(a.ApexClass.Name=='WV_ReadAndPopulateBatch' && a.Status != 'Completed'){
                            NumberOfOpenScheduledBatches=NumberOfOpenScheduledBatches+1;
                        }
                        
                        statusList.add(a.Status); 
                        
                        if(Ints==AsyncList.size()){
                            j.CreatedDate = a.CreatedDate.format();
                            j.CreatedById = a.CreatedBy.Name ;
                        }
                        
                        if(Ints ==1 && a.CompletedDate != null){
                            completedDate=a.CompletedDate.format();
                        }
                        Ints++;
                    }
                    
                    if(j != null && statusList != null && statusList.size() > 0){
                        if(statusList.contains('Failed')){
                            j.Status = 'Failed' ;
                        }
                        else if(statusList.contains('Aborted')){
                            j.Status = 'Aborted' ;
                        }
                        else if(statusList.contains('Processing')){
                            j.Status = 'Processing' ;
                        }
                        else if(statusList.contains('Preparing')){
                            j.Status = 'Preparing' ;
                        }
                        else if(statusList.contains('Queued')){
                            j.Status = 'Queued' ;
                        }            
                        else if( statusList.contains('Completed') && statusList.size() ==1 ){
                            if(NumberOfErrors==0){
                                j.Status = 'Completed' ; 
                                j.CompletedDate=completedDate;                                  
                            }       
                            else if(NumberOfErrors>0){
                                j.Status = 'Failed' ;             
                            } 
                        }
                        else{
                            j.Status = '' ;
                        }   
        
                        j.itemsProcessed = itemsProcessed;
                        j.totalItems = totalItems;
                        j.NumberOfErrors = NumberOfErrors;
                        
                        if(NumberOfOpenScheduledBatches > 0){
                            PercentageSplit=(NumberOfNormalBatches / (NumberOfNormalBatches+NumberOfOpenScheduledBatches));
                        }
                        else{
                            PercentageSplit=1;
                        }
                        
                        if(j.itemsProcessed > 0 && j.totalItems > 0){
                            j.percentComplete = ( ((j.itemsProcessed / j.totalItems)* PercentageSplit) * 100.0).intValue() ;
                        }
                        else{
                            j.percentComplete=0;
                        }                                          
                        batchJobs.add(j);    
                    }
                } 
            
            }       

        }
        Catch(Exception ex){
            system.debug('****exception inside getBatchJobs()'+ex.getMessage()+'--'+ex.getLineNumber()); 
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
        public Double itemsProcessed {get; set;}
        public Double totalItems {get; set;}
        public Integer NumberOfErrors {get; set;}
        public Integer percentComplete {get; set;}
    }
    
    public pageReference sendErrorEmail(){
        try{
            if(exp != null){         
                WV_Utility.captureException('My Elections','Customdata status bar page','Exception Type : '+exp.getTypeName()+'; Exception message: '+exp.getmessage()+'; Line number :'+exp.getlinenumber(),exp.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
            }
        }
        Catch(Exception e){
           system.debug('****Exception inside sendErrorEmail()'+e.getlinenumber()+'-'+e.getmessage());                  
        }
        return null;
    }
}