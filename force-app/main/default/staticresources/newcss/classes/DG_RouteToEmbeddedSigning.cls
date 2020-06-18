/*********************************************************************
* This class is used to route a user to an embedded signing ceremony.  It is called
* from the vf page using the document name and return url
*
* Note: Tried to prevent salesforce from showing up even if error, routes to ms today as default
*
* Change Log:
*
* 4/1/2014 - Mark Moser    
* 1/5/15 - Mark Moser - route for doc ack signature
***********************************************************************/
public class DG_RouteToEmbeddedSigning{ 
    
    //test change
    public DG_RouteToEmbeddedSigning(){        
      
    }
    /* 
    * If the template name is sent, then dynamically
    * generate the document and open embedded signing ceremony
    *
    */
    public pagereference route(){         
    	
 		/*get the template title and return url */
    	String retUrl = ApexPages.currentPage().getParameters().get('retUrl');
    	String templateName = ApexPages.currentPage().getParameters().get('templateName');
    	String envelopeId;
    	
    	/* get the user email address */
    	User u = [select email, emp_id__c from user where id = :UserInfo.getUserId()];
    	
    	/* find the employee id for example 59XYZ */
    	Employee__c e = [select emp_id__c from employee__c where emp_id__c = :	u.emp_id__c];
        
        if (templateName == null){ 
        }
        else if (templateName == 'Doc Acknowledgement'){	
        	DG_DocuSignAPI_Utilities du = new DG_DocuSignAPI_Utilities();
 			/* call dynamic embedded signature create process */
 			envelopeId = du.checkDocumentsAndSendForSignatureToEmployee(templateName,e.emp_id__c);
        }
        else if (templateName == 'Commitment Agreement'){
        	 FFAP_DocusignAPI_AutoUtilities ca = new  FFAP_DocusignAPI_AutoUtilities(e.emp_id__c);
        	 envelopeId = ca.sentCommitmentAgreementForSignature(e.emp_id__c);
        }
        
        String url;
        
        if (envelopeId != null){
      		DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(envelopeId,retUrl);
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