public class WV_ManualShareRead {
   
   public List<Scheme__Share> users;
   public List<User> userName; 
   public list<id> useridlist{get;set;}      
   public String contIdChosen {get; set;}
   public String hiddenValue{get;set;}
   public Map<Id,user> usernameMap {get; set;}  
   public Map<Id,string> userpermissionsetMap {get; set;} 
   Public Boolean ShowpageBlockFlag{get;set;}       
   public List<Id> InitialList  {get;set;}
   public list<String> CurrentList  {get;set;}
   public list<Scheme__Share> userList {get;set;}  
   public Boolean refreshPage { get; set; }  
   public Id recordId;
   public List<Scheme__c> schemeRecord {get; set;}   
   public string customPageMessage {get; set;}
   public final static string PAGE_ERROR=Label.WV_Exception_Admin;
   public string typeOfMessage {get; set;}
   public string currentPageURL {get; set;}
   public string OrgName {get; set;}
   public string loggedinUser {get{String userid=Userinfo.getuserID();return userid;} set{}}
    
   public WV_ManualShareRead()
   {
       try{
        customPageMessage =null;
        contIdChosen=null;
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        String PageURL = ApexPages.currentPage().getUrl(); 
        currentPageURL = baseURL+PageURL;
        OrgName=Label.ORG_ENVIRONMENT;                     
    
        recordId= ApexPages.currentPage().getParameters().get('Id');
        if(recordId != null){
            schemeRecord = WV_Utility.getSchemeDetails(recordId);
        }
        userName = new list<User>();
        useridList = new list<id>();
         
        usernameMap = new Map<Id,user>();
        userpermissionsetMap =new Map<Id,string>();
            
        ShowpageBlockFlag = false;  
        refreshPage = false;
        InitialList = new List<Id>();
        CurrentList = new list<String>();
        userList = new list<Scheme__Share>(); 
      } 
      Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside WV_ManualShareRead constructor'+e.getlinenumber()+'-'+e.getmessage()); 
     }    
   }
   
   public void addUsers() {       
       ShowpageBlockFlag = true;
   }  
   
   public PageReference manualShareRead(){
      try{
          customPageMessage =null;
          List<Scheme__Share> ShareRecordList=new List<Scheme__Share>();
          if(CurrentList != null && CurrentList.size() > 0){
              for(String i : CurrentList){    
                  Id userOrGroupId=i;
                  Scheme__Share jobShr  = new Scheme__Share();    
                  jobShr.ParentId = recordId;         
                  jobShr.UserOrGroupId = userOrGroupId;
                  jobShr.AccessLevel = 'Edit';                    
                  jobShr.RowCause = Schema.Scheme__Share.RowCause.Manual;                   
                  ShareRecordList.add(jobShr);
              }
          }
          else{ 
              customPageMessage=Label.WV_Sharing_NoUsersSelected;
              typeOfMessage='Error';
              return null;
          }
          
          if(ShareRecordList.size() > 0){
               Database.SaveResult[] sr = Database.insert(ShareRecordList,false);
               CurrentList=new List<string>();
               if(schemeRecord != null && schemeRecord.size() >0 ){
                   schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                   schemeRecord[0].Last_updated_date__c=system.now();                
                   update  schemeRecord[0];  
               } 
          }    
          
      }
      Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside constructor'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Scheme Detail page->Scheme Sharing tab-->Constructor','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());      
      }
      PageReference p=new PageReference('/apex/WV_SchemeDetails?Id='+recordId+'&tab=shareTab');
      p.setRedirect(true);
      return p;  
      
   }
       
       
         
    public PageReference delCont()
    {     
        try{
            customPageMessage =null;  
            if(hiddenValue != null && hiddenValue.trim() != ''){ 
                Scheme__Share toDel=new Scheme__Share(id=hiddenValue);          
                delete todel;
                
                if(schemeRecord != null && schemeRecord.size() >0 ){
                    schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                    schemeRecord[0].Last_updated_date__c=system.now();                
                    update  schemeRecord[0];  
                }                
                PageReference p=new PageReference('/apex/WV_SchemeDetails?Id='+recordId+'&tab=shareTab');
                p.setRedirect(true);
                return p;   
            }
        }
        Catch(Exception e){
           customPageMessage=PAGE_ERROR;
           typeOfMessage='Error';
           system.debug('****Exception inside delCont'+e.getlinenumber()+'-'+e.getmessage()); 
           WV_Utility.captureException('My Elections','Scheme Detail page->Scheme Sharing tab-->delCont','Exception Type : '+e.getTypeName()+'; Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());  
        } 
        return null;
                     
    }

    public List<Scheme__Share> getUsers()
    {       
        try{
            List<Scheme__Share> users=new List<Scheme__Share>();
            
            if(recordId != null){
                users=WV_Utility.getSharedOwnersonSchemeObject(recordId);
                
                if(users != null && users.size() >0 ){
                    for(Scheme__Share  X:users ){
                        id value=X.UserOrGroupId;
                        useridlist.add(value);           
                    }
                    
                    if(useridlist != null && useridlist.size() >0){
                        usernameMap = new Map<Id,user>([SELECT Name FROM user WHERE id in :useridlist]);
                        List<PermissionSetAssignment> permissionsetAssign=[SELECT Assignee.Name, AssigneeId,PermissionSet.id,PermissionSet.name,PermissionSet.Label FROM PermissionSetAssignment where (AssigneeId IN:useridlist AND (PermissionSet.name='My_Elections_Scheme_Admin' OR PermissionSet.name='My_Elections_HRSC_admin' OR PermissionSet.name='My_Elections_Biz_Admin'))];
                        if(permissionsetAssign != null && permissionsetAssign.size() >0){
                            for(PermissionSetAssignment pa:permissionsetAssign ){
                                userpermissionsetMap.put(pa.AssigneeId,pa.PermissionSet.Label);
                            }                
                        }
                        
                        for(ID str:useridlist){
                            if(userpermissionsetMap != null && userpermissionsetMap.containskey(str)==false){
                                userpermissionsetMap.put(str,'ALL MS Employee');
                            }
                        }
                            
                        if(usernameMap != null && usernameMap.keyset() != null & usernameMap.keyset().size() >0){
                            InitialList=new List<Id>(usernameMap.keyset());  
                        }   
                    }              
                   
                }
            }
            return users;
            
        }
        Catch(Exception e){
           system.debug('****Exception inside getUsers()'+e.getlinenumber()+'-'+e.getmessage()); 
        } 
        return null;        
    }
   
   
}