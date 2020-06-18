public class DocusignAuthenticationHelper {
	//will be used to connect to Docusign API
    public String accountId;
    private String userId;
    private String password;    
    private String integratorsKey;
    public String webServiceUrl;
    public String webAccMgmtServiceUrl;
    public String emailBody;
    
    public String authString;
    public boolean isConfigured;
    public String error;
    public DocusignAuthenticationHelper(){
        dsfs__DocuSignAccountConfiguration__c accountConfig = FFAP_DataUtil.getDocuSignAccountConfigurations();        
        if(accountConfig == null){
        	isConfigured = false;            
            error = 'Docusign Account is not configured. Please ask your System Administrator to configure.';
            return;
        }else{
        	isConfigured = true;
        }
        this.accountId = accountConfig.dsfs__AccountId__c;
        this.userId = accountConfig.dsfs__DSProSFUsername__c;
        this.password = accountConfig.dsfs__DSProSFPassword__c;
        this.integratorsKey = System.Label.Docusign_Integration_Key;
        this.webServiceUrl = System.Label.Docusign_Service_API_URL;
        this.webAccMgmtServiceUrl = System.Label.Docusign_Account_Management_Service_API_URL;        
        this.emailBody = accountConfig.dsfs__EmailBody__c;
        this.authString = '<DocuSignCredentials>'//+ '<SendOnBehalfOf> hrfrce-docusign-dev@morganstanley.com </SendOnBehalfOf>' 
        + '<Username>' + this.userId +'</Username><Password>' + this.password + '</Password><IntegratorKey>' + this.integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';          
    }
    public String getBrandId(String applicationName){
    	Docusign_Branding_Setting__c brandSetting = Docusign_Branding_Setting__c.getInstance(applicationName);
    	if(brandSetting != null){
    		return brandSetting.Dcosuign_Brand_Id__c;
    	}
    	return null;
    }
}