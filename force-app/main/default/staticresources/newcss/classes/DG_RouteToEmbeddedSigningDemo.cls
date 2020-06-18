/*********************************************************************
* This class is used to route a user to an embedded signing ceremony.  It is called
* from the vf page using the list id & employee id
*
* Tried to prevent salesforce from showing up even if error
*
* Change Log:
*
* 4/1/2014 - Mark Moser    
***********************************************************************/
public class DG_RouteToEmbeddedSigningDemo{ 
    
    //test change
    public DG_RouteToEmbeddedSigningDemo(){        
      integer i;
    }
    
    public pagereference route(){        
    	/* find the document */
    	String listId = ApexPages.currentPage().getParameters().get('list');
    	String retUrl = ApexPages.currentPage().getParameters().get('retUrl');
    	/* get the user email address */
    	
    	User u = [select emp_id__c, email from user where id = :userinfo.getUserId()];
    	
    	       
        /* get the url for the envelope */
       
        List<dsfs__DocuSign_Status__c> docList = new List<dsfs__DocuSign_Status__c>();
        docList = [select dsfs__DocuSign_Envelope_ID__c
            		 	from dsfs__DocuSign_Status__c
            			where List_Employee__r.Employee__r.Emp_ID__c = :u.emp_id__c
            			and List_Employee__r.list__c = :listId
            			limit 1
        ];
         
        String url;
        if (docList.size() > 0){
      		DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(docList[0].dsfs__DocuSign_Envelope_ID__c,retUrl);
        	url = g.getDocusignURLForSigning();
        }
        else
        	url = System.Label.DG_EmbeddedSigningReturnUrl;
       
        if (url == null)
        	url = System.Label.DG_EmbeddedSigningReturnUrl;
        	
      	/* route the user to the document */
      	PageReference page = new PageReference(url);
  		page.setRedirect(true);
  		return page;
    }
}