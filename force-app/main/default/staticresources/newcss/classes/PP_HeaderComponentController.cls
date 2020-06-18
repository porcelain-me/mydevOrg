Public class PP_HeaderComponentController{
    
    public string OrgName {get; set;}
    public String selectedTab{get;set;}
    public boolean isAdmin{get;set;}
    public User LoggedInUser {get;set;}
    
    Public PP_HeaderComponentController(){        
            selectedTab = 'RequestHome';
            OrgName = '';

            if(ApexPages.Currentpage().getParameters().get('tab')!=null){
                selectedTab = ApexPages.Currentpage().getParameters().get('tab');
            }
            System.debug('*********************Inside PP_HeaderComponentController:SelectedTab::'+selectedTab );
            LoggedInUser = PP_Util.getLoggedinUserRecord();
            isAdmin = PP_Util.isLoggedInUserAdmin();    
            System.debug ('***************** PROPERTY PASS ADMIN **************'+isAdmin);

            //String urlString=String.ValueOf(URL.getSalesforceBaseUrl());
            String urlString  = System.Label.ORG_ENVIRONMENT.toLowerCase();
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