/*********************************************************************
* This class is used to route a user to an embedded signing ceremony.  It is called
* from the vf page using the envelope id
*
* Change Log:
*
* 1/6/2015 - Mark Moser    
***********************************************************************/
public class DG_RouteToEmbeddedSigningEnvId{ 
    
    //test change
    public DG_RouteToEmbeddedSigningEnvId(){        
      integer i;
    }
    
    public pagereference route(){        
        /* find the document */
        String envId = ApexPages.currentPage().getParameters().get('envId');
        
        User u = [select emp_id__c, email from user where id = :userinfo.getUserId()];
        
         
        String url;
        
        String retUrl =  System.Label.DG_BaseUrl +  '/apex/DG_DocAckQ';
        system.debug('Print url'+retUrl);
        
        DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(envId,retUrl);
        url = g.getDocusignURLForSigning();
       
        if (url == null)
            url = retUrl;
            
        /* route the user to the document */
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
    }
}