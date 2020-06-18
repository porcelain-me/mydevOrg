/******************************************************************************************
* User Registration -	This is the controller to handle activation of a new user since there
*						are license limitations 
*								 
*
*
* ChangeLog:
*
*	2/27/15 - Created by Mark R. Moser
*
*******************************************************************************************/

public with sharing class User_RegController{ 
		 
	
	public User_Registration__c u {get;set;}
	
	public User_RegController() {
		
		u = new User_Registration__c();
	
	}
	/******************************************************************************************
	* Exception	 
	*
	*******************************************************************************************/
	public class forceException extends Exception {}
	
	/******************************************************************************************
	* Grab and Go	 
	*
	*******************************************************************************************/
	
	public PageReference grabAndGo(){
		
		try{
			String shortname = ApexPages.currentPage().getParameters().get('shortname');
			String urlId = ApexPages.currentPage().getParameters().get('urlId');
			String encodedUrl;
			
			if (urlId == null)
				throw new forceException('Ugh - urlId is null');	
			
			if (shortname == null)
				throw new forceException('Ugh - shortname is null');	
			
			u.shortname__c = shortname;
		
			insert u;
		
			/*load a map of the custom settings.  an env-id maps to an encoded url */
			Map<String,String> urlMap = new Map<String,String>();
			List<Force_Activation__c> forceActList = new List<Force_Activation__c>();
			forceActList = [select name, encoded_url__c from Force_Activation__c];
			for(Force_Activation__c f:ForceActList){
				urlMap.put(f.name,f.encoded_url__c);
			}
			
			String s;
			if (test.isRunningTest())
				s = 'dev';
			else
				/* determine where we came from */
				s = string.valueOf(URL.getCurrentRequestUrl().toExternalForm());
				
			/* populate the encoded url */
			
			if (System.Label.ORG_ENVIRONMENT == 'DEV'){
				encodedUrl= urlMap.get('dev-'+ urlId);
			}
			else
			if (System.Label.ORG_ENVIRONMENT == 'QA'){
				encodedUrl= urlMap.get('qa-'+ urlId);
			}
			else
			if (System.Label.ORG_ENVIRONMENT == 'UAT'){
				encodedUrl= urlMap.get('uat-'+ urlId);
			}
			else {
				encodedUrl= urlMap.get('prod-'+ urlId);
			}
			
			if (encodedUrl == null)
				throw new forceException('Ugh - can not find forceact custom setting');	
			
			
			
			/* route to the proper page */
			PageReference pageRef;
			if (encodedUrl.contains('hrforcedev') || encodedUrl.contains('hrforceqa') || encodedUrl.contains('hrforceuat') ||encodedUrl.contains('hrforceprod'))
				pageRef = new PageReference('http://' + encodedUrl);
			else
				pageRef = new PageReference('https://' + encodedUrl);
		
			return pageRef;
		}
		catch (Exception e) {
			throw new forceException('Ugh - a failure occured: ' + e);
		}
		
    }
    
    
   
}