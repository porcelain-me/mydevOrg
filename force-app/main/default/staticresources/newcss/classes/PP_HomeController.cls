public class PP_HomeController {
    
 public list<PR_Request__c > requestList {get;set;} 
 public list<PR_Request__c> PendingApproverlList{get;set;}
 public String TotalRequests { get; set; }//need to remove
 public boolean IsApprover{get;set;}
 public id requestId{get;set;}
    
    //constructor
    public PP_HomeController(){
        
        requestList =new list<PR_Request__c >();
        PendingApproverlList=new list<PR_Request__c>();
        //Removal_Date__c,         
        requestList =[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Request_Type__c from PR_Request__c order by createdDate desc   limit 10];   
        TotalRequests = string.valueOf(requestList.size()); 
//Get Pending Request
//Removal_Date__c, 
        PendingApproverlList=[select name,Employee_Requestee_Name__r.name,Employee_Requestor_Name__r.name,Status__c,CreatedDate,Removal_Type__c,Removal_Date__c,Request_Type__c, Location111__c, Removal_Purpose__c from PR_Request__c where OwnerId=:userinfo.getUserId()]; 
 //TotalRequests = string.valueOf(PendingApproverlList.size());
       if(PendingApproverlList.size()>0){
        IsApprover=true;
        }
 
    }
    
    //constructor ends
    
    //method to go to new request page
    public pagereference ViewRequest(){
        
        ApexPages.currentPage().getParameters().put('ID',requestId);
        string s='/apex/testEditUpdate?ID='+requestId;
        PageReference pr = new PageReference(s);
        pr.setRedirect(true);
        
         
        
        return pr;
}

}