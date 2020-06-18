public without sharing class FFAP_Dynamic_Docusign_Generation {
	
	public String packageType{get;set;}
	Boolean isNew;
	Boolean isExisting;
	public String commitmentEnvId;
	public List<String> errors{get;set;} 
	FFAP_DocusignAPI_AutoUtilities utilities;
	User u;
	Employee__c e; 
	
	public FFAP_Dynamic_Docusign_Generation(){
		packageType = ApexPages.currentPage().getParameters().get('packageType');
		
		Conga_General_Settings__c congaSetting = Conga_General_Settings__c.getInstance();
		
		/* get the user email address */
    	u = [select email from user where id = :UserInfo.getUserId()];
    	
    	/* find the employee id for example 59XYZ */
    	e = [select emp_id__c from employee__c where email__c = :	u.email];
		
		utilities = new FFAP_DocusignAPI_AutoUtilities(e.emp_id__c);
		
	}
	
	public pageReference generateDocument(){
	
		if(packageType == FFAP_Datautil.COMMITMENT){
			errors = validateDocumentForCommitment();
			if (isNew){
				system.debug('****************** is new ************************');
				//utilities.sendnow(); 
				commitmentEnvId = utilities.embeddedEnvId;
				return goToEmbeddedSigning_Commitment();
			}
			else{
				if (isExisting){
					system.debug('*********************** id existing *********************');
					commitmentEnvId = utilities.embeddedEnvId;
					return goToEmbeddedSigning_Commitment();
				}
			}
			
		}
		
		for (String e:errors)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e));
			
		return null;
	}
	
	public List<String> validateDocumentForCommitment(){		
		
		List<String> errors = new List<String>();
		
		isNew = false;
       	isExisting = false;
       	string resultString = utilities.dynamicCommitmentAgreementForSignatureValidation(e.emp_id__c);
        if(resultString == FFAP_DataUtil.SUCCESS ){ 
        	isNew = true;
        }
     	else{
     		if (resultString.contains('Commitment Agreement is already created')){
     			isExisting = true;
     		}else{ 
        		errors = resultString.split('\n');
        	}
     	}
     	
     	system.debug('errors:' + errors);
		return errors;       	
       	
	}
	
	public pageReference goToEmbeddedSigning_Commitment(){

		system.debug('commitmetnenvid:' + commitmentEnvId);
		String retUrl = 'http://ffap';
		String url;
		
		if (commitmentEnvId != null){
      		DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(commitmentEnvId,retUrl);
        	url = g.getDocusignURLForSigning();
       	}
        else  //default return url is in system label
        	url = System.Label.DG_EmbeddedSigningReturnUrl;
           	/* route the user to the document */
      		
      	PageReference page = new PageReference(url);
  		page.setRedirect(true);
  		return page;
	
	}
	        
	
	
}