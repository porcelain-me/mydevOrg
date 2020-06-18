public class CDT_RequestHomeController {

    public List<Course_Delinquents__c> requestlist {get;set;}
    public String courseDeli{get;set;}
  
	public CDT_RequestHomeController()
    {
     
    
    requestlist  = new List<Course_Delinquents__c>();
        requestData();
       
    }
    
    public void requestData()
    {
        requestlist =[Select Name,Emp_MSID__c, Days_overdue__c,Status__c, Employee__r.name,CreatedDate,ID, Course_Pending__r.name,Course_Pending__r.Course_Name__c,
                      Course_Pending__r.Is_Active__c from Course_Delinquents__c where Employee__r.User__c = :UserInfo.getUserId() or Employee__r.manager__r.user__c= :UserInfo.getUserId()];
                     
    }
    
    public PageReference addReason()
    {
        
       // throw new RecordNotFoundException('Hi--'+courseDeli);
        PageReference p = new PageReference('/apex/CDT_AddCourseReason');
        p.getParameters().put('cid',courseDeli);
        p.getParameters().put('tab','RequestDetail');
        p.getParameters().put('mode','create');
        p.setRedirect(true);
        return p;
        
    }   
    // redirect to the edit reason page
    public PageReference editReason(){
        PageReference p = new PageReference('/apex/CDT_AddCourseReason');
        p.getParameters().put('cid',courseDeli);
        p.getParameters().put('tab','RequestDetail');
        p.getParameters().put('mode','edit');
        p.setRedirect(true);
        return p;
    }
}