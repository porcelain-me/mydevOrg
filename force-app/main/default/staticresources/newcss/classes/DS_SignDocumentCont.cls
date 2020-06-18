/*********************************************************************
* This class is used to perform an embedded signing ceremony.  It is called
* from the vf page using the envelope id.
*
* Change Log:
*
* 4/1/2014 - Mark Moser
***********************************************************************/
public class DS_SignDocumentCont{
    
    
    public string apiResponse {get; set;}
    public string dsURL {get; set;}
    public Boolean configured {get; set;}
    private String envId;
    private RecipientInfo ri;
    
    public DS_SignDocumentCont(){        
        //Check if credentials are set. Show setup splash pageBlock if not.     
        configured = Credentials.areConfigured();
        envId = ApexPages.currentPage().getParameters().get('envId');
        loadRecipientInfo();
        dsURL = getDocusignURLForSigning();
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
    	postData.put('email',ri.email);
    	postData.put('userName',ri.userName);
    	//postData.put('returnUrl',URL.getSalesforceBaseUrl() + '/apex/DG_ThankYouForSigning'); 
    	
    	postData.put('returnUrl','http://www.morganstanley.com/'); 
    	
    	postData.put('AuthenticationMethod','email');
    	postData.put('clientUserId',ri.embeddedId);
    	
    	String res = Client.getEmbeddedSigningURL(envId,JSON.serialize(postData));
    	
    	//now desirialize this
    	EmbeddedURLResponse urlClass= (EmbeddedURLResponse) JSON.deserialize(res,EmbeddedURLResponse.class);
    	return urlClass.url;
    }
    
    
    
    private void loadRecipientInfo(){
     	Employee__c emp = [Select Email__c, Name, Id From Employee__c Where User__c = :UserInfo.getUserId() Limit 1];
        ri = New RecipientInfo(emp);
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