public class Foods_HomeComponentController {
    
    public string OrgName {get; set;}
    public String selectedTab{get;set;}
    public boolean isAdmin{get;set;}
    public User LoggedInUser {get;set;}
    public Boolean isSuperUser{get;set;}
    public PermissionSetAssignment PSASuperUser;
    public list<PermissionSetAssignment> PSASuperUserList;

                
    
    public Foods_HomeComponentController(){
        
        selectedTab='';
        orgName='';
        
        if(ApexPages.Currentpage().getParameters().get('tab')!=null){
            
            selectedTab = ApexPages.Currentpage().getParameters().get('tab');
        }
        if(ApexPages.Currentpage().getParameters().get('setupid')!=null){
            
            selectedTab = ApexPages.Currentpage().getParameters().get('setupid');
        }
         if(ApexPages.Currentpage().getParameters().get('tab')==null){
            
            selectedTab = 'Home';
        }
                        Id loggedInUserId = UserInfo.getUserId();
                        Id loggedInProfileId = UserInfo.getProfileId();

         isSuperUser = false;
            list<PermissionSet> PSSuperUserList = [select Id from PermissionSet where name = 'XS_Super_User'];
            
            if(PSSuperUserList.size() > 0)
            {
                PSASuperUserList = [select Id from PermissionSetAssignment where
                                            AssigneeId = :loggedInUserId and PermissionSetId = :PSSuperUserList.get(0).Id]; 
            }
            if(PSASuperUserList.size() > 0)
                PSASuperUser = PSASuperUserList.get(0);
            
            Profile loggedInProfile = [select Name from Profile where id =:loggedInProfileId];
            
            
            if(PSASuperUser != null || loggedInProfile.Name == 'System Administrator') {
                isSuperUser = true;
              }


        
        LoggedInUser = PP_Util.getLoggedinUserRecord();
        String urlString  = System.Label.ORG_ENVIRONMENT.toLowerCase();
        System.debug('*************'+urlString);
        
        if(urlString != null && urlString.toLowercase().contains('dev')){
                OrgName='DEV';
        }
        else if(urlString != null && urlString.toLowercase().contains('qa')){
                OrgName='QA';
        }
        else if(urlString != null && urlString.toLowercase().contains('uat')){
                OrgName='UAT';
        }
        
    }

}