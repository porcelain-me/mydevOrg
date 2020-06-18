public with sharing class SYS_User_Notification{
    
    public Boolean waiting {get;set;}
    public Boolean submitted {get;set;}
    public String submitDateTime{get;set;}
    public Integer batchCount{get;set;}
    
    public SYS_User_Notification (ApexPages.Standardcontroller stdController) {
    	
    	batchCount = 0;
    }
   
    public void Main(){ 
        
           
        submitDateTime = ' - Hello Rajeev!';
        
        batchCount++;
        
        submitted = true;
                
        waiting = true;
            
       
    }
}