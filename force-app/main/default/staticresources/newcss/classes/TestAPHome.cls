@isTest 
private class TestAPHome {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	Charity__c c = new Charity__c (active__c = true
        		, name = 'test'
        		, country__c = 'CAN'
        		,Address__c = '85 milford road'
        		,contact_name__c = 'my contact'
        		,mission__c = 'to test app'
        		,website__c = 'www.salesforce.com'
        		,minimum_donation__c = 1
        		,donation_increment__c = 1
        		,tax__c = 'PostTax'
        		);
        	insert c;
        	
        	Charity__c c2 = new Charity__c (active__c = true
        		, name = 'test2'
        		, country__c = 'CAN'
        		,Address__c = '85 milford road'
        		,contact_name__c = 'my contact'
        		,mission__c = 'to test app'
        		,website__c = 'www.salesforce.com'
        		,minimum_donation__c = 1
        		,donation_increment__c = 1
        		,tax__c = 'PostTax'
        		);
        	insert c2;
        	
        	User u = [select emp_id__c from user where id = :userinfo.getUserid()];
        	
       		Employee__c e = new Employee__c(name='Test AP Home', first_name__c = 'Test', last_name__c = 'AP Home', emp_id__c = u.emp_id__c
       			,job_country_job__c = 'CAN');
       			
       		insert e;
       		
       		Employee_giving__c g = new Employee_Giving__c(
       		
       		amount__c = 100
       		,charity__c = c.id
       		,employee__c = e.id
       		,currencyIsoCode = 'CAD'
       		,year__c = '2015'
       		
       		);
       		
       		insert g;
       		
       		
       		
        	AP_HomeController h = new AP_HomeController();
        	/*
        	h.wList[0].g.amount__c = 500;
        	h.save();
        	
        	h.wList[0].g.amount_text__c = 'x500';
        	h.save();
        	
        	h.wList[0].g.amount_text__c = '2000000001';
        	h.save();
        	h.closePopup();
        	h.datachanged();
        	*/
        	
        	Test.StopTest();
     
    }
}