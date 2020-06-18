public with sharing class WV_UserMultiSelectComponentController {

  public static final String USERTYPE_STD = 'Standard';
  public list<Id> InitialRightList {get;set;}
  public list<String> CurrentRightList {get;set;}
  public list<String> LeftSelectedList {get;set;}
  public list<String> RightSelectedList {get;set;}  
  map<String, User> LeftOptionMap = new map<String, User>();
  map<String, User> RightOptionMap = new map<String, User>();
  public string currentPageURL {get; set;}
  public string OrgName {get; set;}

  public WV_UserMultiSelectComponentController() {
    LeftSelectedList = new list<String>();
    RightSelectedList = new list<String>();
    list<User> UserList; 
    list<PermissionSetAssignment> userpermission;
    map<id,PermissionSetAssignment> s = new map<id,PermissionSetAssignment>();
    
    try{
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        String PageURL = ApexPages.currentPage().getUrl(); 
        currentPageURL = baseURL+PageURL;
        OrgName=Label.ORG_ENVIRONMENT;
        
        Map<Id,permissionset> allowedPermissionSets=new Map<Id,permissionset>([select id,name from permissionset where name='My_Elections_Scheme_Admin' OR name='My_Elections_HRSC_admin']);
        if(allowedPermissionSets != null && allowedPermissionSets.keyset() != null && allowedPermissionSets.keyset().size() > 0){
            userPermission =   [SELECT Assignee.Name, AssigneeId FROM PermissionSetAssignment where PermissionSet.id in:allowedPermissionSets.keyset()];
        }
        if(userPermission != null && userPermission.size() > 0){
            for(PermissionSetAssignment p : userPermission)
            {
               s.put(p.AssigneeId,p); 
            }
        }
         
        if (s!= null) {
             UserList = [Select Name, Id, IsActive, UserType From User where IsActive=true AND UserType = :USERTYPE_STD and Id IN :s.KeySet()];
             for (User u : UserList) {
                 LeftOptionMap.put(u.Id, u); 
             }    
        }     
    }
    Catch (Exception e){
        system.debug('****Exception inside WV_UserMultiSelectComponentController constructor'+e.getlinenumber()+'-'+e.getmessage()); 
    }
  }
 

  public PageReference ClickRight(){
    try{
        List<string> UsersList=new List<String>();
        RightSelectedList.clear();
        for(String s : LeftSelectedList){
          if (LeftOptionMap.containsKey(s)) {
               RightOptionMap.put(s, LeftOptionMap.get(s));  
               UsersList.add(s);                
          }
          LeftOptionMap.remove(s);     
        }
        //WV_Utility.doActivateUsers(UsersList);
    }
    Catch (Exception e){
        system.debug('****Exception inside WV_UserMultiSelectComponentController ClickRight()'+e.getlinenumber()+'-'+e.getmessage()); 
        WV_Utility.captureExceptionFuture('My Elections','Scheme Detail page->Scheme Sharing --> WV_UserMultiSelectComponentController -->ClickRight()','Exception Type : '+e.getTypeName()+'; <b>Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,Label.WV_Exception_Admin);
        apexpages.addmessage(msg);
    }
    return null;   
  }
  
  public PageReference ClickLeft(){
    try{
        LeftSelectedList.clear();
        for(String s : RightSelectedList){
          if (RightOptionMap.containsKey(s)) {
            LeftOptionMap.put(s, RightOptionMap.get(s));        
          }
          RightOptionMap.remove(s);
          
        }
    }
    Catch (Exception e){
        system.debug('****Exception inside WV_UserMultiSelectComponentController ClickLeft()'+e.getlinenumber()+'-'+e.getmessage()); 
        WV_Utility.captureException('My Elections','Scheme Detail page->Scheme Sharing --> WV_UserMultiSelectComponentController -->ClickLeft()','Exception Type : '+e.getTypeName()+'; <b>Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,Label.WV_Exception_Admin);
        apexpages.addmessage(msg);
    }
    return null;
  }
 
     
  public list<SelectOption> getLeftOptionList(){
    list<SelectOption> TempOptionList = new list<SelectOption>();
    list<User> TempValueList;
    set<Id> preIdSet;
    try{
        if(InitialRightList != null && InitialRightList.size() >0){
            preIdSet=new set<Id>(InitialRightList); 
        }
        TempValueList = LeftOptionMap.values();
        TempValueList.sort();  // sort by name
        for (User u : TempValueList) { 
          if(!preIdSet.contains(u.Id)){
              TempOptionList.add(new SelectOption(u.Id, u.Name));
          }
        }
        return TempOptionList;
    }
    Catch (Exception e){
        system.debug('****Exception inside WV_UserMultiSelectComponentController getLeftOptionList()'+e.getlinenumber()+'-'+e.getmessage()); 
    }
    return null;    
  }
 

  public list<SelectOption> getRightOptionList(){
        list<SelectOption> TempOptionList = new list<SelectOption>();
        list<User> TempValueList;
        try{
            TempValueList = RightOptionMap.values();
            TempValueList.sort();  // sort by name
            for (User u : TempValueList) { 
              TempOptionList.add(new SelectOption(u.Id, U.Name));
              CurrentRightList.add(u.Id);
            }   
            return TempOptionList;
        }
        Catch (Exception e){
            system.debug('****Exception inside WV_UserMultiSelectComponentController getRightOptionList()'+e.getlinenumber()+'-'+e.getmessage()); 
        }
        return null;
  }
  
}