public class EnginesRequestsExtnController {
     private Engines_Requests__c engineRequest;
     
     
     public String PageTitle {get;set;}
     public User userId {get;set;}
     public EnginesRequestsExtnController(ApexPages.StandardController stdController)
     {
         this.engineRequest = (Engines_Requests__c)stdController.getRecord();
         // singhrak, 20Apr, 2015, REQ3693157, start
         stdControllerClone =  stdController;
         // singhrak, 20Apr, 2015, REQ3693157, end
          this.engineRequest.Logged_In_User__c = userinfo.getName();
          engineRequest.Set_up_type__c = 'Engines';
          //singhrak,REQ3649018  Apr 06, 2015, Update code with following, start
           // singhrak, 20Apr, 2015, REQ3693157, start, add flow related if clause         
            String flowType = getParam('flow');
          if(engineRequest.Id == null || (flowType != null && flowType.equals('clone')))
          {
            engineRequest.Requested_By__c = UserInfo.getUserId();
            engineRequest.Status__c = 'Submitted';  
            // singhrak, 20Apr, 2015, REQ3693157, start 
            engineRequest.Comments__c = '';
            // singhrak, 20Apr, 2015, REQ3693157, end
          }
          else
          {
          PageTitle = [select name from Engines_requests__c where id=:engineRequest.Id].name;   
          system.debug(engineRequest.Priority__c+'pg:'+PageTitle);
          }
          //singhrak, Apr 06, 2015, Update code with following, end
          
     }
    

  public void calcAccount()
    {
        if(this.engineRequest.MSET_Account__c!=null)
        {
          List <MSET_Account__c> tempList = [select TNL_ID__c,Trading_Name_ID__c from MSET_Account__c where Id =: this.engineRequest.MSET_Account__c];
          MSET_Account__c acct=(MSET_Account__c)tempList.get(0);
          
           this.engineRequest.A2_TNL_Id__c = acct.TNL_ID__c;
          this.engineRequest.A2_TN_Id__c = acct.Trading_Name_ID__c;
        }
    }

        public PageReference save() {
        // singhrak, 20Apr, 2015, REQ3693157, satrt
            PageReference pageRef = ApexPages.currentPage();
        String flowType = pageRef.getParameters().get('flow');
        
        if(flowType != null && flowType.equals('clone')) {
            return this.cloneForm();
        }
        // singhrak, 20Apr, 2015, REQ3693157, end
            
              try{
              Database.upsert(engineRequest);
              }
              catch(Exception e)
              {
                return null;
              }
            sendEmailFoSetupTypeEngines();
          return (new ApexPages.StandardController(engineRequest)).view();
            
        } 
        
@TestVisible        
   private void sendEmailFoSetupTypeEngines(){
    //engines-client-requests@morganstanley.com.test.test
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        email.setTargetObjectId(engineRequest.Requested_By__c);
        List<string> cc = new List<string>();
        cc.add('engines-client-requests@morganstanley.com.test.test');
        email.setCcAddresses(cc);
        email.setWhatId(engineRequest.Id);
        Id templateId = [select id, name from EmailTemplate where developername = 'VF_notification_for_set_up_type_Engines'].Id;
        if(templateId != null)
        email.setTemplateId(templateId);
        email.saveAsActivity = false;
        Messaging.SendEmailResult [] sendmail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
   }
 
 // singhrak, 20Apr, 2015, REQ3693157, satrt
   Engines_Requests__c cloneableRequestForm = new Engines_Requests__c();
    public PageReference cloneAction() {
       PageReference editForm = new Apexpages.Standardcontroller(engineRequest).edit();
       editForm.getParameters().put('flow','clone');
       editForm.setredirect(true);
       return editForm;
   }
   ApexPages.StandardController stdControllerClone;
   public PageReference cloneForm() {
       PageReference pref = null;
                Engines_Requests__c engineFormReq = (Engines_Requests__c)this.stdControllerClone.getRecord();
     try {
          this.cloneableRequestForm.MSET_Account__c = engineFormReq.MSET_Account__c;
          this.cloneableRequestForm.TargetDate__c = engineFormReq.TargetDate__c;    
          this.cloneableRequestForm.A2_TN_Id__c = engineFormReq.A2_TN_Id__c;
          this.cloneableRequestForm.A2_TNL_Id__c = engineFormReq.A2_TNL_Id__c;
          this.cloneableRequestForm.Asia_Pacific_Flow_Details__c = engineFormReq.Asia_Pacific_Flow_Details__c;
          this.cloneableRequestForm.BD_Indicator__c = engineFormReq.BD_Indicator__c;
          this.cloneableRequestForm.Client_Contact_Details__c = engineFormReq.Client_Contact_Details__c;    
          this.cloneableRequestForm.Europe_Flow_Details__c = engineFormReq.Europe_Flow_Details__c;
          this.cloneableRequestForm.Europe_Flow_Details__c = engineFormReq.Europe_Flow_Details__c;
          this.cloneableRequestForm.North_America_Flow_Details__c   = engineFormReq.North_America_Flow_Details__c  ;
          this.cloneableRequestForm.MSET_Platinum_focus__c = engineFormReq.MSET_Platinum_focus__c;    
          this.cloneableRequestForm.Priority__c = engineFormReq.Priority__c;
          this.cloneableRequestForm.Set_up_type__c = engineFormReq.Set_up_type__c;
          this.cloneableRequestForm.Status__c = engineFormReq.Status__c;
          this.cloneableRequestForm.Vendor__c = engineFormReq.Vendor__c;
          this.cloneableRequestForm.Requested_By__c = engineFormReq.Requested_By__c;

            insert cloneableRequestForm;        
           pref = new ApexPages.StandardController(cloneableRequestForm).view();
           pref.setredirect(true);
           
     }
     catch(Exception e) {
         System.debug('General Exception : '+e.getMessage());
     }
     return pref;
   }
 
 public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }
   
   // singhrak, 20Apr, 2015, REQ3693157, end
    
}