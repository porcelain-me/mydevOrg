public class MCA_RequestHomeController {
  public list<MCARequest__c> requestList {get;set;}
    public String selectedTab{get;set;}
    public String strDisplayCategory {get; set;}
    public String TotalRequests { get; set; }
    public boolean viewReq{get;set;} 
    public MCA_RequestHomeController()
    {
        requestList = new list<MCARequest__c>();
          strDisplayCategory = 'All';
          TotalRequests = '0';
        viewReq = false;
        clearSearch();
    }
    Public void clearSearch () {  
        list<MCARequest__c> dummyReqList = new list<MCARequest__c>();
        TotalRequests = '0';
        strDisplayCategory = 'All';
        requestList.clear();
        dummyReqList =[Select ID, Name, Employee_Requestee_Name__r.name,Createddate, Status__c, Additional_access_timing__c from 
                       MCARequest__c where Status__c='Submitted'];
        requestList = dummyReqList ;
        if(dummyReqList != null && !dummyReqList.isEmpty()){
            TotalRequests = string.valueOf(dummyReqList.size()); 
        }
    }
    
    public pagereference NewRequest(){
        PageReference pr = new PageReference('/apex/MCAPortal_NewAreaRequest?tab=NewRequest');
        pr.setRedirect(true);
        return pr;
    }
    
}