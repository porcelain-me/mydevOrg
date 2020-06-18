/***************************************************************************************************************
*  RL SHARING CLASS - 	this class inserts a sharing record to share a request with the requestor since it is off 
*					 	to a queue.
*
* MRM 10/10/14 - Created Class
* MRM 12/8/14 - Modified class to return the sharing rules list
****************************************************************************************************************/
public without sharing class RL_Sharing {

	public static List<Reference_Letter_Request__Share> shareReadWrite (Reference_Letter_Request__c r){
		
		// Create a new list of sharing objects for Reference_Letter_Request
        List<Reference_Letter_Request__Share> Reference_Letter_RequestShrs  = new List<Reference_Letter_Request__Share>();
        
        // Declare variables for recruiting and hiring manager sharing
        Reference_Letter_Request__Share refletterShr;
   			   
     
        // Instantiate the sharing objects
        refletterShr = new Reference_Letter_Request__Share();
            
        // Set the ID of record being shared
        refletterShr.ParentId = r.Id;
        system.debug('---------------Parent Id is---------'+r.id) ;   
        // Set the ID of user or group being granted access
        refletterShr.UserOrGroupId = userInfo.getUserId();
        system.debug('---------------User Id is---------'+userInfo.getUserId()) ; 
        
        /* check if already shared */
        List<Reference_Letter_Request__Share> shareList = [
        			Select Id
          			From Reference_Letter_Request__Share
         			where parentid = :r.id and userorgroupid = :userInfo.getUserId()]; 
        
        /* if not shared then share */
        if (shareList.size() == 0){ 
        	ID shareID = r.Requesting_Employee__r.User__c;
           
       	 	// Set the access level
       		refletterShr.AccessLevel = 'edit';
           
        	// Set the Apex sharing reason for requestor
        	//recruiterShr.RowCause = Schema.Job__Share.RowCause.Recruiter__c;
        	//refletterShr.RowCause = Schema.Reference_Letter_Request__Share.RowCause.Owner;
          
        	// Add objects to list for insert
        	Reference_Letter_RequestShrs.add(refletterShr);
            
        
        	//system.debug('Ref letter share:'  + Reference_Letter_RequestShrs);
        
        	// Insert sharing records and capture save result 
        	// The false parameter allows for partial processing if multiple records are passed 
        	// into the operation; so we use true instead
       	 	Database.SaveResult[] lsr = Database.insert(Reference_Letter_RequestShrs,true);
       	 	
       	 	system.debug('lsr: ' + lsr); 
       	 	
       	 	return Reference_Letter_RequestShrs;
        }
        
		return null;

	}
	
}