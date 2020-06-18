public with sharing class ExamplePageController {
  
    public list<String> InitialList  {get;set;}
    public list<String> CurrentList  {get;set;}
    public list<Scheme__Share> userList {get;set;}
    
    public ExamplePageController() { 
    InitialList = new list<String>();
    InitialList.add(UserInfo.getUserId());
    CurrentList = new list<String>();
    userList = new list<Scheme__Share>();
    
  }
    
  public PageReference manualShareRead(){
   
    for(String i : CurrentList)
    {
    
      Id recordId= ApexPages.currentPage().getParameters().get('parentid');
      system.debug('-----------Current List values--------'+CurrentList);
     
      //Id userOrGroupId='005f0000000jioGAAQ';
       Id userOrGroupId=i;
       system.debug('-----------Current List Value --------'+userOrGroupId);
      // Create new sharing object for the custom object Job.
      Scheme__Share jobShr  = new Scheme__Share();
      
      // Set the ID of record being shared.
      jobShr.ParentId = recordId;   
      
      system.debug('-------------------Record Id----------'+recordId);  
      // Set the ID of user or group being granted access.
      
      
      jobShr.UserOrGroupId = userOrGroupId;
      
      system.debug('-------------------User Id----------'+userOrGroupId);
      // Set the access level.
      jobShr.AccessLevel = 'Edit';
        
      // Set rowCause to 'manual' for manual sharing.
      // This line can be omitted as 'manual' is the default value for sharing objects.
      jobShr.RowCause = Schema.Scheme__Share.RowCause.Manual;
        
      // Insert the sharing record and capture the save result. 
      // The false parameter allows for partial processing if multiple records passed 
      // into the operation.
      Database.SaveResult sr = Database.insert(jobShr,false);
    }
    
    system.debug('#################################');
      // Process the save results.
    
     // return null;
      return new PageReference('javascript:window.close();');    
       }
      
      
}