@isTest
private class TestGPQueueDisplay {

	static testmethod void test1(){
		
		TestGPData.createData(); 
		
		Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'Budapest'];
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Test.startTest();
		
			
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = reg.id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Motorcycle';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = reg.id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Bicycle';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = reg.id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		
		
		
      	
		PageReference pageRef = Page.GP_Queue_Display;
		Test.setCurrentPage(pageRef);
        
		ApexPages.StandardController c = new ApexPages.StandardController(reg);
                
        GP_Queue_Display t = new GP_Queue_Display(c);
        
      
        
        Test.stopTest(); 
	}


}