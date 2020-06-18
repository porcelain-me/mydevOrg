trigger AccountTrigger on Account (before insert, before update, after insert, after delete) {
   /* if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            for (Account acc : Trigger.new)
            {
                acc.description = 'Test';
                acc.Website ='www.google.com';
              
            }
        } else if (Trigger.isAfter) {
            // Process after insert
        }        
    }
    else if (Trigger.isDelete) {
        // Process after delete
    }
}
	  
      //For loop to iterate through all the incoming Account records
      for(Account a: Trigger.new){
      	  /*
      	    THIS FOLLOWING QUERY IS INEFFICIENT AND DOESN'T SCALE
      	    Since the SOQL Query for related Contacts is within the FOR loop, if this trigger is initiated 
      	    with more than 20 records, the trigger will exceed the trigger governor limit
            of maximum 20 SOQL Queries.
      	  */
      	 /* List<Contact> contacts = [select id, salutation, firstname, lastname, email 
                        from Contact where accountId = :a.Id];
 		  
 	  for(Contact c: contacts){
 	  	  System.debug('Contact Id[' + c.Id + '], FirstName[' + c.firstname + '],LastName[' + c.lastname +']');
 	  	  c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
 	  	   /*
      	             THIS FOLLOWING DML STATEMENT IS INEFFICIENT AND DOESN'T SCALE
      	             Since the UPDATE dml operation is within the FOR loop, if this trigger is initiated 
      	             with more than 20 records, the trigger will exceed the trigger governor limit 
                     of maximum 20 DML Operations.
      	            */
      	      
 		 // update c;
 	 /* }    	  
      }*/
}