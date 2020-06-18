@isTest()
private class TestGPAssignment {

	/* assign a car request in budapest */
	static testmethod void test1(){

		TestGPData.createData();  
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
		
		
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		system.debug('rlist is: ' + rList);
		
		PageReference pageRef = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        
        GP_Assignment c = new GP_Assignment();
        
        Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        c.sa.parking_lot_space__c = pList[0].id;
        
        c.selectedParkingLot = g.id;
        c.selectedMethodOfPayment = 'Monthly';
        
        c.sa.parking_pass_id__c = string.valueOf(system.now());
        
        c.populateMethodOfPayment();
        
        c.save();
        
        c.exit();
              

		
				 
	}
	/* assign a car request in budapest baby  mom*/
	static testmethod void test2(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
		
		
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		List<Parking_Lot_Request__c> reqList = new List<parking_lot_Request__C>();
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		
		reqList.add(r);
		
		r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		
		reqList.add(r);
		
		insert reqList;
		
		system.debug('rlist is: ' + rList);
		
		PageReference pageRef = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        
        GP_Assignment c = new GP_Assignment();
	
		c.getNext();
		
		c.back();
				 
	}
	/* get exceptions errors for car in budapest */
	
	static testmethod void test3(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		system.debug('rlist is: ' + rList);
		
		PageReference pageRef = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        
        GP_Assignment c = new GP_Assignment();
        
        Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
       
        
        c.selectedParkingLot = g.id;
         c.sa.parking_lot_space__c = pList[0].id;
        c.selectedMethodOfPayment = 'Monthly';
        
        c.sa.parking_pass_id__c = string.valueOf(system.now());
        
        
        c.save();
        
   
      
            

		
				 
	}
	
	static testmethod void test4(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		system.debug('rlist is: ' + rList);
		
		PageReference pageRef = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        
        GP_Assignment c = new GP_Assignment();
        
        Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        c.sa.parking_lot_space__c = pList[0].id;
        
        c.selectedParkingLot = g.id;
        c.selectedMethodOfPayment = 'Monthly';
        
        c.sa.parking_pass_id__c = string.valueOf(system.now());
        
        c.saveReject();
		c.r.reject_reason_desc__c = 'ys';
		c.saveReject();
		
        c.reject();
        
        
        
      
            

		
				 
	}
	/* get exceptions errors for car in budapest */
	
	static testmethod void test5(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Employee_Vehicle__c v = new Employee_Vehicle__c();
		v.color__c = 'Blue';
		v.employee__c = e.id;
		v.make_model__c = 'Ford Escort';
		v.state__c = 'PA';
		v.status__c  = 'Active';
		v.type__c = 'Car';
		insert v;
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		Parking_Lot_Request_Vehicles__c rv = new Parking_Lot_Request_Vehicles__c();
		rv.employee_vehicle__c = v.id;
		rv.parking_lot_Request__c = r.id;
		insert rv;
		
		system.debug('rlist is: ' + rList);
		
		PageReference pageRef = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        
        GP_Assignment c = new GP_Assignment();
        
        Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        c.sa.parking_lot_space__c = pList[0].id;
        
        c.selectedParkingLot = g.id;
        c.selectedMethodOfPayment = 'Monthly';
        
        c.sa.parking_pass_id__c = string.valueOf(system.now());
        
        
        c.save();
        
   
      
            

		
				 
	}
	
	/* get exceptions errors for car in budapest */
	
	static testmethod void test6(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
	
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Employee_Vehicle__c v = new Employee_Vehicle__c();
		v.color__c = 'Blue';
		v.employee__c = e.id;
		v.make_model__c = 'Ford Escort';
		v.state__c = 'PA';
		v.status__c  = 'Active';
		v.type__c = 'Car';
		insert v;
		
		Map<String,ID> recTypeMap = new Map<String,ID>();
		List<RecordType> recList = [select id, developername from RecordType where sobjectType = 'Parking_Lot_Request__c'];
		for (RecordType rt:recList)
			recTypeMap.put(rt.developername, rt.id);
			
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.end_date__c = date.today().addMonths(3);
		r.expectant_mother__c = false;
		r.recordtypeid =  recTypeMap.get('Budapest');
		insert r;
		
		Parking_Lot_Request_Vehicles__c rv = new Parking_Lot_Request_Vehicles__c();
		rv.employee_vehicle__c = v.id;
		rv.parking_lot_Request__c = r.id;
		insert rv;
		
		system.debug('rlist is: ' + rList);
		
		PageReference pageRef = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        ApexPages.currentPage().getParameters().put('id', r.id);
        
        GP_Assignment c = new GP_Assignment();
        
        Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        c.sa.parking_lot_space__c = pList[0].id;
        
        c.selectedParkingLot = g.id;
        c.selectedMethodOfPayment = 'Monthly';
        
        c.sa.parking_pass_id__c = string.valueOf(system.now());
       
        c.save();
       				 
	}
		
		/* get exceptions errors for car in budapest */
	
	static testmethod void test7(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
	
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.end_date__c = date.today().addMonths(3);
		r.expectant_mother__c = true;
		r.parking_lot__c = g.id;
		insert r;
		
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        Parking_Lot_Space_Assignment__c sa = new Parking_Lot_Space_Assignment__c();
        sa.employee__c = e.id;
        sa.parking_lot_Request__c = r.id;
        sa.parking_lot_space__c = pList[0].id;
        sa.method_of_payment__c = 'Monthly';
        sa.Assignment_Start_DATE__C = date.today().addMonths(1);
        sa.Assignment_end_DATE__C = date.today().addMonths(24);
        sa.parking_pass_id__c = '100asdasdf';
        insert sa;
        
        Parking_Lot_Request__c r2 = new Parking_Lot_Request__c();
		r2.requestee__c = e.id;
		r2.type__c = 'Replacement Pass';
		r2.vehicle_type__c = 'Car';
		r2.rate_type__c = 'Monthly';
		r2.parking_lot_Region__c = rList[0].id;
		r2.method_of_payment__c = 'Monthly';
		r2.start_date__c = date.today();
		r2.related_parking_lot_Request__c = r.id;
		//insert r2;
        
        PageReference pageRef2 = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef2);
        
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        ApexPages.currentPage().getParameters().put('id', r.id);//sa.id); Too many soql error, to be fixed and code reverted
        
        GP_Assignment c2 = new GP_Assignment();
 		
 		c2.confirm();  		
      
            

		
				 
	}
	
			
		/* get exceptions errors for car in budapest */
	
	static testmethod void test8(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
	
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.end_date__c = date.today().addMonths(3);
		r.expectant_mother__c = true;
		r.parking_lot__c = g.id;
		r.status__c = 'Assigned';
		insert r;
		
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        Parking_Lot_Space_Assignment__c sa = new Parking_Lot_Space_Assignment__c();
        sa.employee__c = e.id;
        sa.parking_lot_Request__c = r.id;
        sa.parking_lot_space__c = pList[0].id;
        sa.method_of_payment__c = 'Monthly';
        sa.Assignment_Start_DATE__C = date.today().addMonths(1);
        sa.Assignment_end_DATE__C = date.today().addMonths(24);
        sa.parking_pass_id__c = '100asdasdf';
        insert sa;
        
        Parking_Lot_Request__c r2 = new Parking_Lot_Request__c();
		r2.requestee__c = e.id;
		r2.type__c = 'Cancellation';
		r2.vehicle_type__c = 'Car';
		r2.rate_type__c = 'Monthly';
		r2.parking_lot_Region__c = rList[0].id;
		r2.method_of_payment__c = 'Monthly';
		r2.start_date__c = date.today();
		r2.related_parking_lot_Request__c = r.id;
		r2.status__c = 'New';
		insert r2;
        
        PageReference pageRef2 = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef2);
        
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        ApexPages.currentPage().getParameters().put('id', r2.id);
        
        GP_Assignment c2 = new GP_Assignment();
 		
 		c2.confirm();  
 		
 		c2.r.actual_cancellation_date__c = null;
 		c2.confirm();
 		
 		c2.r.actual_cancellation_date__c = date.today();
 		c2.confirm();
 		
 		 
	}
	
	static testmethod void test9(){
		/*
		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
	
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.end_date__c = date.today().addMonths(3);
		r.expectant_mother__c = true;
		r.parking_lot__c = g.id;
		r.status__c = 'Assigned';
		insert r;
		
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        Parking_Lot_Space_Assignment__c sa = new Parking_Lot_Space_Assignment__c();
        sa.employee__c = e.id;
        sa.parking_lot_Request__c = r.id;
        sa.parking_lot_space__c = pList[0].id;
        sa.method_of_payment__c = 'Monthly';
        sa.Assignment_Start_DATE__C = date.today().addMonths(1);
        sa.Assignment_end_DATE__C = date.today().addMonths(24);
        sa.parking_pass_id__c = '100asdasdf';
        insert sa;
        
        Parking_Lot_Request__c r2 = new Parking_Lot_Request__c();
		r2.requestee__c = e.id;
		r2.type__c = 'Replacement Pass';
		r2.vehicle_type__c = 'Car';
		r2.rate_type__c = 'Monthly';
		r2.parking_lot_Region__c = rList[0].id;
		r2.method_of_payment__c = 'Monthly';
		r2.start_date__c = date.today();
		r2.related_parking_lot_Request__c = r.id;
		r2.status__c = 'New';
		 
		insert r2;
        
        PageReference pageRef2 = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef2);
        
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        ApexPages.currentPage().getParameters().put('id', r2.id);
        
        GP_Assignment c2 = new GP_Assignment();
        
        c2.newAssignment.parking_pass_id__c = 'zxcfasdfasdfasd';
        
        c2.save();
 	
		*/
		
				 
	}
	
	static testmethod void test10(){

		TestGPData.createData(); 
		
		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
	
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Parking_Lot__c g = [select id from Parking_Lot__c where name = 'Millenium III']; 
        
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Parking Space';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.end_date__c = date.today().addMonths(3);
		r.expectant_mother__c = true;
		r.parking_lot__c = g.id;
		r.expectant_mother__c = true;
		r.status__c = 'New';
		insert r;
		
        List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :g.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        Parking_Lot_Space_Assignment__c sa = new Parking_Lot_Space_Assignment__c();
        sa.employee__c = e.id;
        sa.parking_lot_Request__c = r.id;
        sa.parking_lot_space__c = pList[0].id;
        sa.method_of_payment__c = 'Monthly';
        sa.Assignment_Start_DATE__C = date.today().addMonths(1);
        sa.Assignment_end_DATE__C = date.today().addMonths(24);
        sa.parking_pass_id__c = '100asdasdf';
        insert sa;
        
        
        PageReference pageRef2 = Page.GP_Assignment;
              
        Test.setCurrentPage(pageRef2);
        
        ApexPages.currentPage().getParameters().put('rid', rList[0].id);
        ApexPages.currentPage().getParameters().put('id', r.id);
        
        GP_Assignment c2 = new GP_Assignment();
        
        c2.selectedParkingLot = g.id;
        c2.selectedMethodOfpayment = 'Monthly';
        c2.save();
 	

		
				 
	}
}