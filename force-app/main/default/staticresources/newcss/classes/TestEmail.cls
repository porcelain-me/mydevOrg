@isTest(SeeAllData=true)
private class TestEmail {
	static testMethod void test1() {
			
		User u = [select id from User where id= '005e0000001Q36r'];
		system.runas(u	){
    		Contact c = new Contact( firstname='test', email='mark_moser@morganstanley.com',lastname = 'test');
 			insert c;
 			List<Messaging.Singleemailmessage> emailList = new List<Messaging.SingleEmailMessage>();
 			Messaging.Singleemailmessage email = new Messaging.singleEmailMessage();
                
 			email.setSaveAsActivity(false);
 			email.setOrgWideEmailAddressId('0D2e0000000CbZHCA0');
 			email.setTargetObjectId(c.id);
 			email.setWhatId('a0ae0000003tBvG');
 			email.setTemplateId('00Xe0000000QoCrEAK');
 
				Messaging.Singleemailmessage email2 = new Messaging.singleEmailMessage();
                
 			email2.setSaveAsActivity(false);
 			email2.setOrgWideEmailAddressId('0D2e0000000CbZHCA0');
 			email2.setTargetObjectId(c.id);
 			email2.setWhatId('a0ae0000003tBvG');
 			email2.setTemplateId('00Xe0000000QoCrEAK');

 			emailList.add(email);
 			emailList.add(email2);
  
 
        
        	if (emailList.size() > 0) { 
           		system.debug('email size'+emailList.size());
           	 	system.debug('emailList: '+emailList);
            	Messaging.sendEmail(emailList);            
        	}

			delete c;
	}
}
}