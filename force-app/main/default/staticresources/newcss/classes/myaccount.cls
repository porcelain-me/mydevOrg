/******************************************************************************************
* Sample xss demo
*   
*******************************************************************************************/

public without sharing class myaccount { 
     
   public String myTextField {get;set;}
   public String name  {get;set;} 
   public String urlName {get;set;}
   
   
   //user supplied: name = test%') or (Name like '
   public myaccount (ApexPages.StandardController stdController) {
    	
   		urlName = ApexPages.Currentpage().getParameters().get('urlName');
        system.debug('****** URL NAME IS: ' + urlName);
   }
     	
	public PageReference query() {
		
		//String name = string.escapeSingleQuotes(name);
		System.debug(name);
		
		String q = 'SELECT Id FROM Contact WHERE ' + 
			'(IsDeleted = false and Name like \'%' + name + '%\')';
		List<Contact> queryResult = Database.query(q);
		return null;
	}
}