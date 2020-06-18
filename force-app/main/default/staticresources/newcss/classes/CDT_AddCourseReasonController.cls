public class CDT_AddCourseReasonController {
    
    public Course_Delinquents__c requestlist;
    public String empName{get;set;}
    public String empID{get;set;}
    public String courseName{get;set;}
    public String status{get;set;}
    
    public String empEmailAddress = '';
    public String empManagerEmailAddress = '';
    public String empUserId = '';
    public String mode {get;set;}
    
    public Delinquent_justification__c requestDetails {get;set;}
    public CDT_AddCourseReasonController()
    {
       
        requestDetails = new Delinquent_justification__c();
        PageReference pef= ApexPages.currentPage();
        String cid = pef.getParameters().get('cid');
        mode = pef.getParameters().get('mode');
        if(mode.equalsIgnoreCase('edit')){
            requestDetails = [SELECT Id,Course__c,Delinquent__c,Reason_Added_By__c,Reason__c FROM Delinquent_justification__c WHERE Delinquent__c =: cid LIMIT 1];
        }
        
        if(!String.isBlank(cid))
        {
            requestlist =[Select Name,Emp_MSID__c,Days_overdue__c,Status__c, Employee__r.name,CreatedDate,id,Course_Pending__c, 
                          Course_Pending__r.name,Course_Pending__r.Course_Name__c,
                          Course_Pending__r.Is_Active__c,Employee__r.User__r.Email,Employee__r.User__c,Employee__r.Manager__r.User__r.Email 
                          FROM Course_Delinquents__c 
                          where id =:cid];        
        }
        if(requestlist!=null)
        {
            empName = requestlist.Employee__r.name;
            empID = requestlist.Emp_MSID__c;
            courseName= requestlist.Course_Pending__r.Course_Name__c;
            status= requestlist.Status__c;
            empEmailAddress = requestlist.Employee__r.User__r.Email;
            empManagerEmailAddress = requestlist.Employee__r.Manager__r.User__r.Email;
            empUserId = requestlist.Employee__r.User__c;
        }
    }
    
    public PageReference submitConfirm()
        {
            try{
                requestDetails.Course__c=requestlist.Course_Pending__c;
                requestDetails.Delinquent__c=requestlist.id;
                requestDetails.Reason_Added_By__c = UserInfo.getName();
                requestDetails.Submitted__c =true;  
                // check if the manager edited this record
                if(!empUserId.equalsIgnoreCase(String.valueOf(UserInfo.getUserId()))){
                    requestDetails.Edited_by_Manger__c = true;
                }
                else{
                    requestDetails.Edited_by_Manger__c = false;
                }
                insert requestDetails;
                
                requestlist.Status__c='Completed';
                update requestlist;
            }
            catch(Exception exp){
                system.debug(' -- EXCEPTION -- ' + exp.getMessage());
            }
            finally{
                notifyByEmail();
            }
            
            PageReference p = new PageReference('/apex/CDT_RequestHome');
            return p;
        }
    
    public PageReference updateReason(){
        try{
            if(requestDetails != null){
                // check if the manager edited this record
                if(!empUserId.equalsIgnoreCase(String.valueOf(UserInfo.getUserId()))){
                    requestDetails.Edited_by_Manger__c = true;
                }
                else{
                    requestDetails.Edited_by_Manger__c = false;
                }
                update requestDetails;
            }
            
        }
        catch(Exception exp){
            system.debug(' -- EXCEPTION -- ' + exp.getMessage());
        }
        finally{
            notifyByEmail();
        }
        
        PageReference p = new PageReference('/apex/CDT_RequestHome');
        return p;
    }
    
     public PageReference CancelConfirm()
     {
          PageReference p = new PageReference('/apex/CDT_RequestHome');
            return p;
         
     }
    // send an email once the reason is filled out
    // TO : the delinquent
    // CC : delinquent's manager 
    public void notifyByEmail(){
        //get the email template id
        Id templateId = [SELECT Id FROM EmailTemplate WHERE Name = 'CDT Email Notification' LIMIT 1].Id;
        // get the FROM addresss
        Id orgEmailId = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = 'hrfrce-alerts' LIMIT 1].Id;       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(empUserId); // TO address
        mail.setOrgWideEmailAddressId(orgEmailId); // FROM address
        mail.setCcAddresses( new List<String> {empManagerEmailAddress}); // CC the manager
        mail.setTemplateId(templateId); // the template to use
        mail.saveAsActivity = false;
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}