/***************************************************************************************
*  This class does a rest call to docusign with an envelope id and returns an embedded
*  signing session url
*
*  Change Log:
*
*  4/2/2014 - MRM Created Class
*****************************************************************************************/


public class DS_GetEnvelopeURL {
 
	public string apiResponse {get; set;}
    public string dsURL {get; set;}
    public Boolean configured {get; set;}
    private String envId;
    private RecipientInfo ri;
    private String retUrl;
    
     
    public DS_GetEnvelopeURL(String idIn, String retUrlIn){        
        //Check if credentials are set. Show setup splash pageBlock if not.     
        configured = Credentials.areConfigured();
        envId = idIn; 
        retUrl = retUrlIn;
        loadRecipientInfo();
        system.debug('******** url is: ' + getDocusignURLForSigning());
    }
    
    private DSCredentials m_credentials = null;
    public DSCredentials Credentials{
        get{
            if(m_credentials == null){
                m_credentials = new DSCredentials();
            }
            return m_credentials;
        }
        set{ m_credentials = value; }
    }
    
    private DSClient m_client = null;
    public DSClient Client{
        get{
            if(this.m_client == null){
                m_client = new DSClient(this.Credentials);
            }
            return m_client;
        }
    }
      
    public PageReference getLoginInformation(){
        HttpResponse httpResponse = Client.Get(Client.BaseEndpointURL + '/login_information');
        this.apiResponse = httpResponse.getBody();
        return null;
    }
    
    //method that fetch url for embedded signing
    public String getDocusignURLForSigning(){
    	
    	//post body
    	Map<String,String> postData= new Map<String,String>();
    	
    	/* original code */
    	postData.put('authenticationMethod','email');
    	postData.put('email',ri.email);
    	postData.put('userName',ri.userName);
    	postData.put('clientUserId',ri.embeddedId);
    	/* end original code */
    	
    	
    	/* test code */
    	//postData.put('authenticationMethod','email');
    	//postData.put('email','mark.moser@morganstanley.com');
    	//postData.put('userName','mark.msoer@morganstanley.com');
    	
    	/* end test code */
    	
    	if (retUrl == null && retUrl != '')
    		postData.put('returnUrl',System.Label.DG_EmbeddedSigningReturnUrl); 
    	else
    		postData.put('returnUrl',retUrl); 
    		
    	system.debug('Post Data:' + postData);
    	
    	String res = Client.getEmbeddedSigningURL(envId,JSON.serialize(postData));
    	
    	//now desirialize this
    	EmbeddedURLResponse urlClass= (EmbeddedURLResponse) JSON.deserialize(res,EmbeddedURLResponse.class);
    	return urlClass.url;
    }
    
    
    
    private void loadRecipientInfo(){
    	system.debug('userid is:' + UserInfo.getUserId());
     	Employee__c emp = [Select Email__c, Name, Id From Employee__c Where User__c = :UserInfo.getUserId() Limit 1];
        system.debug('emp++++++'+emp);
        ri = New RecipientInfo(emp);
        system.debug('ri*****'+ri);
    }
    
    private class EmbeddedURLResponse{
    	public String url;
    }
    
    private class RecipientInfo{
     	public String embeddedId;
        public String userName;
        public string email;
        
        public RecipientInfo(Employee__c e){
         	embeddedId = e.id;
            email = e.Email__c;
            userName = e.Name;
        }
    }
}