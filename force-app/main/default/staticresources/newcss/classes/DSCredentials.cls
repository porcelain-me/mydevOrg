/*
 * DSCredentials.cls
 * Class structure for managing authentication credentials to the DocuSign REST API.
 * Optionally hard code credentials into this class or dynamically load them from
 * custom settings.
 *
 * TO CREATE DEVELOPER ACCOUNT CREDENTIALS
 * Visit http://www.docusign.com/developer-center
 */
global with sharing class DSCredentials {
	public string BaseURL		=  System.Label.DocusignURL;
	// 'https://www.docusign.net/';
	public string Username  	= '';
	public string Password  	= '';
	public string IntegratorKey = '';
	
	public DSCredentials(){	
		if(this.Settings != null){
			this.BaseURL	= System.Label.Docusign_URL;
			this.Username	= Settings.dsfs__DSProSFUsername__c;
			this.Password	= Settings.dsfs__DSProSFPassword__c;
			this.IntegratorKey = System.Label.Docusign_Integration_Key;
		}
	}
	
	public boolean areConfigured(){
		return this.Settings != null;
	}
	
	public string toXML(){
		return '<DocuSignCredentials>'+
			'<Username>' + this.Username + '</Username>'+
			'<Password>' + this.Password + '</Password>'+
			'<IntegratorKey>' + this.IntegratorKey + '</IntegratorKey>'+
			'</DocuSignCredentials>';
	}
	
	private dsfs__DocuSignAccountConfiguration__c m_settings = null;
	private dsfs__DocuSignAccountConfiguration__c Settings{
		get{
			if(m_settings == null){
				try{
					m_settings = [SELECT dsfs__EmailBody__c, dsfs__EmailSubject__c, dsfs__DSProSFPassword__c, dsfs__DSProSFUsername__c, 
                                                                dsfs__AccountId__c 
                                                                FROM dsfs__DocuSignAccountConfiguration__c limit 1];
				}
				catch(Exception ex){
					return null;
				}
			}
			return m_settings;
		}
	}
	
}