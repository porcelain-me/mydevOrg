public class PP_EnvironmentCheck {
    public string OrgName{get; set;}
    public string test{get; set;}
    public Id test1{get; set;}
    //public string urlString{get;set;}
    
           
    public PP_EnvironmentCheck (){ 
            //String urlString=URL.getSalesforceBaseUrl().toExternalForm();
            String urlString= System.Label.ORG_ENVIRONMENT.toLowerCase();
        
            if(urlString != null && urlString.toLowercase().contains('dev')){
                OrgName='DEV';
            }
            else if(urlString != null && urlString.toLowercase().contains('qa')){
                OrgName='QA';
            }
            else if(urlString != null && urlString.toLowercase().contains('uat')){
                OrgName='UAT';
            }
            else{
                OrgName='PROD';
            }
    }                               
}