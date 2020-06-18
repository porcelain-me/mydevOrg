/*
 * DSLoginInformation.cls
 *
 */
global class DSLoginInformation {
	public string accountId;
	public string baseUrl;
	public string email;
	public string isDefault;
	public string name;
	public string siteDescription;
	public string userId;
	public string userName;
	public boolean hasError = true;
	public string errorMessage = '';
	
	public static DSLoginInformation deserialize(HttpResponse httpResponse){
		DSLoginInformation loginInfoResult = new DSLoginInformation();
		
		try{
			LoginInformationResult result = (LoginInformationResult) JSON.deserialize(httpResponse.getBody(), 
									LoginInformationResult.class);
			if( result == null || 
				result.loginAccounts == null ||
				result.loginAccounts.size() == 0){
					loginInfoResult.hasError = true;
					loginInfoResult.errorMessage = 'Failed to deserialize JSON response from call to login_information';
					return loginInfoResult;
			}
			
			for(DSLoginInformation loginInfo : result.loginAccounts){
				if(loginInfo.isDefault.toLowerCase() == 'true'){
					loginInfoResult = loginInfo;
					loginInfoResult.hasError = false;
					break;
				}
			}
			
			if(loginInfoResult.hasError){
				loginInfoResult.errorMessage = 'At least 1 login account must be flagged as isDefault';
			}
		}
		catch(System.JSONException ex){
			loginInfoResult.hasError = true;
			loginInfoResult.errorMessage = 'JSON Parsing error deserializing Login Information: ' + ex.getMessage();
			return loginInfoResult;
		}
		return loginInfoResult;
	}
	
	private class LoginInformationResult{
		public string apiPassword;
		public List<DSLoginInformation> loginAccounts;
	}
	
	
	public static string TEST_DATA = '{' + 
	  '"apiPassword": "super-secret-password",' +
	  '"loginAccounts": [' +
	    '{' +
	      '"accountId": "654321",' +
	      '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/654321",' +
	      '"email": "user@domain.com",' +
	      '"isDefault": "false",' +
	      '"name": "DocuSign",' +
	      '"siteDescription": "",' +
	      '"userId": "12345678-82a2-4d6c-891c-f2f667654321",' +
	      '"userName": "First Last"' +
	    '},' +
	    '{' +
	      '"accountId": "123456",' +
	      '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/123456",' +
	      '"email": "user@domain.com",' +
	      '"isDefault": "true",' +
	      '"name": "DocuSign",' +
	      '"siteDescription": "",' +
	      '"userId": "12345678-82a2-4d6c-891c-f2f661234567",' +
	      '"userName": "First Last"' +
	    '}' +
	  ']' +
	'}';
	
	private static string TEST_DATA_NO_DEFAULT = '{' + 
	  '"apiPassword": "super-secret-password",' +
	  '"loginAccounts": [' +
	    '{' +
	      '"accountId": "654321",' +
	      '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/654321",' +
	      '"email": "user@domain.com",' +
	      '"isDefault": "false",' +
	      '"name": "DocuSign",' +
	      '"siteDescription": "",' +
	      '"userId": "12345678-82a2-4d6c-891c-f2f667654321",' +
	      '"userName": "First Last"' +
	    '}' +
	  ']' +
	'}';
}