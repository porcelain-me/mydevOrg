public class RIF_CustomEmpPageController{
   //variables
   private Employee__c empRecord;
   
   //Getter-Setters
   public Unvested_Equity__c unvestedObject{get;set;}
   public Boolean iscompDataVisible {
   
      get;
          //if(iscompDataVisible==null )
              //return RIF_Datautil.checkEmpCompDataVisibility(UserInfo.getUserId());
          //else
              //return iscompDataVisible;
      
      set;
   }
   public Boolean isdualhatProfile{get;set;}
   public Boolean isFFIECStatus{get;set;}
   public Boolean istrainingtatus{get;set;}
   public Boolean isRIFUser {get; set;}
   public Boolean isDETUser {get; set;}
   public Boolean isFFAPUser {get; set;}
    
   //controller
   public RIF_CustomEmpPageController(ApexPages.StandardController controller) {
       //recordId = controller.getId();
       if(!Test.isRunningTest()){
           controller.addFields(new List<String>{'Agreement_count__c'});
       }
       
       empRecord=(Employee__c)controller.getRecord();
       try{
           unvestedObject= [SELECT Date_as_of__c,   Unvested_total_balance__c from Unvested_Equity__c where Employee_temp__c=:empRecord.id];
       }
       catch(Exception e){
         
       }
       
       System.debug('####iscompDataVisible ####'+iscompDataVisible );
       System.debug('######## isdualhatProfile '+isdualhatProfile);
       System.debug('####isFFIECStatus####'+isFFIECStatus);
       
       
   }
    
    public PageReference createAgreement()
    {
        PageReference p;
        if(empRecord.Agreement_count__c>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Label.FFAP_Agreement_Already_Created_Error));
        }
        else
        {
            Schema.DescribeSObjectResult r = FFAP_Agreement__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            String pageUrl ='/'+keyPrefix+'/e?retURL=%2F'+empRecord.Id+'&'+Label.FFAP_EmployeeLookUpIdOnFFAPAgreement+'_lkid' +'='+empRecord.Id+'&'+Label.FFAP_EmployeeLookUpIdOnFFAPAgreement+'='+empRecord.Name; 
            p =new PageReference(pageUrl);
        }
        
        
        return p;
        
    }
    
    public PageReference ViewJPN()
    {
        
        String url = '/apex/FFAP_FA_AccountAssociations?empId='+empRecord.Emp_ID__c;
        
        PageReference  p = new PageReference(url);
        p.setRedirect(true);
        return p;
    }
   
     public PageReference StartJPN()
    {
        
        String url = '/apex/FFAP_JPNChangeProcess?empId='+empRecord.ID;
        
        PageReference  p1 = new PageReference(url);
        p1.setRedirect(true);
        return p1;
    }
    
    
     public PageReference customEdit()
     {
         PageReference pageRef = Page.RIF_CustomEmpEditPage;
         pageRef.setRedirect(true);
         pageRef.getParameters().put('id',empRecord.Id);
                              
         return pageRef;
     }
     
     public void ShowDET(){
      isRIFUser = false;
        isDETUser = false;
        isFFAPUser =false;
        System.debug('**********Inside Redirect*************');

        try{
 
            
            // below block will check if the user has any DET permission set and will then accordingly show the DET section on the employee layout
            // get the users permission sets
            List<PermissionSetAssignment> permSetAssignList = [SELECT Id,AssigneeId,PermissionSetId,PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() ];
            if(permSetAssignList != null && !permSetAssignList.isEmpty()){
                Set<String> userPermSet = new Set<String>();
                for(PermissionSetAssignment per : permSetAssignList){
                    userPermSet.add(per.PermissionSet.Label);
                }
                if(!userPermSet.isEmpty()){
                    if(userPermSet.contains('Dual Hat Comp BankGrp') || userPermSet.contains('Dual Hat HR Operations') || userPermSet.contains('Dual Hat Read Only') 
                       || userPermSet.contains('Dual Hat Comp Reg - GRL') || userPermSet.contains('Dual Hat QA SU') || userPermSet.contains('Dual Hat Super User')){ 
                        isdualhatProfile = true;
                        isDETUser = true;
                    }
                    if(userPermSet.contains('Dual Hat Comp BankGrp') ||userPermSet.contains('Dual Hat HR Operations') || userPermSet.contains('Dual Hat Read Only') 
                       || userPermSet.contains('Dual Hat QA SU') || userPermSet.contains('Dual Hat Super User')){
                        isFFIECStatus = true;
                        isDETUser = true;
                    }
                    if (userPermSet.contains('Dual Hat QA SU') || userPermSet.contains('Dual Hat Super User')){
                         isdualhatProfile = true;
                         isFFIECStatus = true;
                        istrainingtatus = true;
                        isDETUser = true;
                    }    
                    
                    if (userPermSet.contains('FFAP User Permissions')){
                         isFFAPUser=true;
                     }
                    
                }
            }
            
            System.debug('#### Inside Try isdualhatProfile####'+isdualhatProfile);
            System.debug('#### Inside Try isFFIECStatus####'+isFFIECStatus); 
             System.debug('#### Inside Try istrainingtatus####'+istrainingtatus); 
        
            isRIFUser=RIF_DataUtil.checkRIFUser(UserInfo.getUserId());
             System.debug('#### Inside Try isRIFUser####'+isRIFUser);
            // show confidential information only to RIF users
            if(isRIFUser){
                iscompDataVisible =RIF_Datautil.checkEmpCompDataVisibility(UserInfo.getUserId(),empRecord);
            }
            System.debug('#### Inside Try iscompDataVisible ####'+iscompDataVisible );  
            
        }
        catch(Exception e){
            //ApexPages.addMessages(e); 
            System.debug(e); 
        }
     
     
     }
     
     
     
     
     
     
     
     
   //redirect() (called from the page action method)
   public PageReference redirect() {
                isRIFUser = false;
        isDETUser = false;
        isFFAPUser =false;
        System.debug('**********Inside Redirect*************');

        try{
        // 31-Aug-17 : JIRA#29 : Changed all DET profiles to permision sets
        // commented the below code that worked with DET profiles
            /*
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            system.debug('ProfileName'+profileName);
            if (ProfileName == 'Dual Hat Comp BankGrp' || ProfileName == 'Dual Hat HR Operations' || ProfileName == 'Dual Hat Read Only' || ProfileName ==  'Dual Hat Comp Reg - GRL' || ProfileName ==  'Dual Hat QA SU'){
                isdualhatProfile = true;
            }
            
            if (ProfileName == 'Dual Hat Comp BankGrp' || ProfileName == 'Dual Hat HR Operations' || ProfileName == 'Dual Hat Read Only' || ProfileName ==  'Dual Hat QA SU'){
                isFFIECStatus = true;
            } 
            
            if (ProfileName ==  'Dual Hat QA SU'){
                istrainingtatus = true;
            } 
            */
            
            // below block will check if the user has any DET permission set and will then accordingly show the DET section on the employee layout
            // get the users permission sets
            List<PermissionSetAssignment> permSetAssignList = [SELECT Id,AssigneeId,PermissionSetId,PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() ];
            if(permSetAssignList != null && !permSetAssignList.isEmpty()){
                Set<String> userPermSet = new Set<String>();
                for(PermissionSetAssignment per : permSetAssignList){
                    userPermSet.add(per.PermissionSet.Label);
                }
                if(!userPermSet.isEmpty()){
                    if(userPermSet.contains('Dual Hat Comp BankGrp') || userPermSet.contains('Dual Hat HR Operations') || userPermSet.contains('Dual Hat Read Only') 
                       || userPermSet.contains('Dual Hat Comp Reg - GRL') || userPermSet.contains('Dual Hat QA SU') || userPermSet.contains('Dual Hat Super User')){
                        isdualhatProfile = true;
                        isDETUser = true;
                    }
                    if(userPermSet.contains('Dual Hat Comp BankGrp') ||userPermSet.contains('Dual Hat HR Operations') || userPermSet.contains('Dual Hat Read Only') 
                       || userPermSet.contains('Dual Hat QA SU') || userPermSet.contains('Dual Hat Super User')){
                        isFFIECStatus = true;
                        isDETUser = true;
                    }
                    if (userPermSet.contains('Dual Hat QA SU') || userPermSet.contains('Dual Hat Super User')){
                        istrainingtatus = true;
                        isDETUser = true;
                    }  
                     if (userPermSet.contains('FFAP User Permissions')){
                         isFFAPUser=true;
                     }
                }
            }
            
            System.debug('#### Inside Try isdualhatProfile####'+isdualhatProfile);
            System.debug('#### Inside Try isFFIECStatus####'+isFFIECStatus); 
             System.debug('#### Inside Try istrainingtatus####'+istrainingtatus); 
        
            isRIFUser=RIF_DataUtil.checkRIFUser(UserInfo.getUserId());
             System.debug('#### Inside Try isRIFUser####'+isRIFUser);
            // show confidential information only to RIF users
            if(isRIFUser){
                iscompDataVisible =RIF_Datautil.checkEmpCompDataVisibility(UserInfo.getUserId(),empRecord);
            }
            System.debug('#### Inside Try iscompDataVisible ####'+iscompDataVisible );  
            
        }
        catch(Exception e){
            //ApexPages.addMessages(e); 
            System.debug(e); 
        }
       
       //return null;
       // 31-Aug-17 : JIRA#29 : Changed all DET profiles to permision sets
       // we will no longer be directing the users
       // 11-Sept-17 : redirect to standard emp page only when its a non RIF and non DET user
        
        if(!isRIFUser && !isDETUser && !isFFAPUser) {
               PageReference standardEMPPage =  Page.RIF_StandardEmpPage;
               standardEMPPage.setRedirect(true);
               standardEMPPage.getParameters().put('id', empRecord.id);
               System.debug('#### Not a RIF USer'); 

               return standardEMPPage ;
               //return new pagereference('/'+empRecord.id); //otherwise stay on the same page 
               
               
        } else {
              //iscompDataVisible=RIF_Datautil.checkEmpCompDataVisibility(UserInfo.getUserId());
              return null;
        
        }
        
   }
}