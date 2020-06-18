global class CampaignUserLoginAsViewController {
    
    public List<User> userList { get; set; }
    public string oboUser{get; set;}
    public boolean showHeaderTabs {get;set;}
    public String iTrakUserName { get; set; }
    
    public CampaignUserLoginAsViewController(){
        userList = new List<User>();
        userList = getActiveUsers();
        
        iTrakUserName = Userinfo.getUserName();
        
        showHeaderTabs = true;
        if(ApexPages.currentPage().getParameters().get('showheadertabs') != null){
        	if (ApexPages.currentPage().getParameters().get('showheadertabs') == 'false'){
        		showHeaderTabs = false;
        	}        	
        }
    }
    
    private List<User> getActiveUsers(){
        set<Id> uIds = filterUserByPermissionSet();
        String query = 'SELECT Id, Preferred_Name__c, LastName, UserName, Email, IsActive FROM User WHERE Id IN: uIds ORDER BY Preferred_Name__c';
        
        return Database.Query(query);
        
    }
    
    private set<Id> filterUserByPermissionSet(){
        Map<Id, PermissionSet> mapPermissionSet = new map<Id, PermissionSet>([SELECT Id, Name FROM PermissionSet WHERE Name IN ('IIFanClub_Permission_Set','IICampaign_Permission_Set', 'GPS_Campaign_Permission_Set')]);
        set<Id> userIds = new set<Id>();
        for(PermissionSetAssignment obj : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId =: mapPermissionSet.keySet()]){
            userIds.add(obj.AssigneeId);
        }
        if(userIds.contains(UserInfo.getUserId()))
            userIds.remove(UserInfo.getUserId());
        return userIds; 
    }
    
     @RemoteAction
     global static void createRecordofGPSCampaignLoggedIn(String oboUser){
        list<GPSCampaignsLoginAs__c> loggedUserList =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =:UserInfo.getUserId() limit 1];
        
        if(loggedUserList.size() > 0){
            if(loggedUserList[0].Login_As_User__c == null || loggedUserList[0].Login_As_User__c == '' ){
                
                loggedUserList[0].Login_As_User__c = oboUser;
                update loggedUserList;
            }else{
               // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'User is loggedIn as another Users');
                //Apexpages.addMessage(myMsg);
               // return null;
                loggedUserList[0].Login_As_User__c = oboUser;
                update loggedUserList;
            }
         }
       else{
        GPSCampaignsLoginAs__c logobj =   new GPSCampaignsLoginAs__c();
        logobj.Current_User__c = UserInfo.getUserId();
        logobj.Login_As_User__c = oboUser;
        
        insert logobj;
        }
        //PageReference pr = new PageReference('/apex/CamapignHomeComponentRedirect?UId='+oboUser);
        //pr.setRedirect(true);
        //return pr;
    }
    
}