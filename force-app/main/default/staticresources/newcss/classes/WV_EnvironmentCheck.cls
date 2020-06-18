public class WV_EnvironmentCheck {
    public string OrgName{get; set;}
    public string variable{get; set;}
    public string EmailId {get; set;}
    public string mslogourl {get; set;}
    public datetime submittedTimes {get; set;}
    public string baseurl {get; set;}
    
    public string getSubmittime(){ 
        try{      
            if (submittedTimes != null) {
                return submittedTimes.format(Label.WV_EmailTemplate_DatetimeFormat);
            }
            else{
                return '';
            }
        }
        Catch(Exception e){
            system.debug('****Exception inside getSubmittime()'+e.getlinenumber()+'-'+e.getmessage()); 
        }
        return '';
    }

    public WV_EnvironmentCheck (){ 
        try{    
            variable=null;
            EmailId=null;
            baseurl=Label.DG_BaseUrl;            
            List<Document> mslogo=[select id,developername from document where developername='MS_Logos'];
            OrgName=Label.ORG_ENVIRONMENT.tolowercase();
            if(mslogo != null && mslogo.size()==1){ 
                mslogourl=Label.DG_BaseUrl+'/servlet/servlet.ImageServer?id='+mslogo[0].Id+'&oid='+UserInfo.getOrganizationId(); 
            }
        }
        Catch(Exception e){
            system.debug('****Exception inside WV_EnvironmentCheck() constructor'+e.getlinenumber()+'-'+e.getmessage()); 
        }
            
    }                               
}