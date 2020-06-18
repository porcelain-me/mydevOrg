public with sharing class SampleProcessor {
    
    public Boolean waiting {get;set;}
    public Boolean submitted {get;set;}
    public String submitDateTime{get;set;}
    public Integer batchCount{get;set;}
    
    public SampleProcessor () {
    	
    	batchCount = 0;
    }
    public void Main(){ 
        
           
        submitDateTime = ' - Hello Rajeev!';
        
        batchCount++;
        
        submitted = true;
                
        waiting = true;
            
       
    }
}