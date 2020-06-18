@isTest
private class TestGPApplicaitionParkingPassService {

	static testmethod void test1(){

		TestGPData.createData(); 
		
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
		 
		GP_ApplicationParkingPassService.getLocations('{}');
		
		GP_ApplicationParkingPassService.getAge('{"msid":"59JRB"}');
		
		GP_ApplicationParkingPassService.getRegisteredVehicles('{"msid":"59JRB"}');
		GP_ApplicationParkingPassService.getCarColors();

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
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
		
		GP_ApplicationParkingPassService.getCancelReasons('{"requestId":"' + r.id + '"}');

		GP_ApplicationParkingPassService.getHelpDocUrl();
		
		GP_ApplicationParkingPassService.updateParkingPassRequest('{"requestId":"' + r.id + '"' + ',"paymentMethod":"dog1"' + '}');
		
		
		Test.stopTest();
		
		
	}


	static testmethod void test2(){

		TestGPData.createData(); 
		
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
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
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
		
		
		GP_ApplicationParkingPassService.requestReplacementPass('{"requestId":"' + r.id + '"' + ',"startDate":"01/01/2099"' + '}');
		GP_ApplicationParkingPassService.requestOvernightPass('{"requestId":"' + r.id + '"' + ',"startDate":"01/01/2099"' + '}');
		
		Test.stopTest();
		
		
	}
	
	static testmethod void test3(){

		TestGPData.createData(); 
		
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
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
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
		
		
		GP_ApplicationParkingPassService.requestCancellation('{"requestId":"' + r.id + '"' + ',"cancelDate":"' + string.valueOf(r.start_date__c) + '"' + '}');
		GP_ApplicationParkingPassService.requestWeekendPass('{"requestId":"' + r.id + '"' + ',"startDate":"01/01/2099"' + '}');
		
		Test.stopTest();
		
		
	}
	
	static testmethod void test4(){

		TestGPData.createData(); 
		
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
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Cancellation';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		insert r;
		
		
		GP_ApplicationParkingPassService.cancelCancellationRequest('{"requestId":"' + r.id + '"' + ',"cancelDate":"' + string.valueOf(r.start_date__c) + '"' + '}');
		Test.stopTest();
		
		
	}
	
	static testmethod void test5(){

		TestGPData.createData(); 
		
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
		
		Parking_Lot__c pl = [select id from Parking_Lot__c where name = 'Cabot Square'];

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'London'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		Parking_Lot_Request__c pr = new Parking_Lot_Request__c();
		pr.requestee__c = e.id;
		pr.type__c = 'Parking Space';
		pr.vehicle_type__c = 'Car';
		pr.rate_type__c = 'Monthly';
		pr.parking_lot_Region__c = rList[0].id;
		pr.method_of_payment__c = 'Invoice (Monthly, Contractors Only)';
		pr.start_date__c = date.today().addMonths(1);
		pr.no_charge__c = false;
		pr.status__c = 'Assigned';
		pr.expectant_mother__c = false;
		pr.parking_lot__c = pr.id;
		insert pr;	
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Weekend Parking';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Invoice (Monthly, Contractors Only)';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.status__c = 'New';
		r.expectant_mother__c = false;
		r.related_parking_lot_Request__c = pr.id;
		insert r;
		
		
		
		GP_ApplicationParkingPassService.cancelWeekendPass('{"requestId":"' + r.id + '"' + ',"cancelDate":"' + string.valueOf(r.start_date__c) + '"' + '}');
		Test.stopTest();
		
		
	}
	
	static testmethod void test6(){

		TestGPData.createData(); 
		
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
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		Parking_Lot_Request__c pr = new Parking_Lot_Request__c();
		pr.requestee__c = e.id;
		pr.type__c = 'Parking Space';
		pr.vehicle_type__c = 'Car';
		pr.rate_type__c = 'Monthly';
		pr.parking_lot_Region__c = rList[0].id;
		pr.method_of_payment__c = 'Monthly';
		pr.start_date__c = date.today().addMonths(1);
		pr.no_charge__c = false;
		pr.status__c = 'Assigned';
		pr.expectant_mother__c = false;
		insert pr;	
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Overnight Parking';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.status__c = 'New';
		r.expectant_mother__c = false;
		r.related_parking_lot_Request__c = pr.id;
		insert r;
		
		
		
		GP_ApplicationParkingPassService.cancelOvernightPass('{"requestId":"' + r.id + '"' + ',"cancelDate":"' + string.valueOf(r.start_date__c) + '"' + '}');
		Test.stopTest();
		
		
	}
	
	static testmethod void test7(){

		TestGPData.createData(); 
		
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
		
	
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		
		Parking_Lot_Request__c pr = new Parking_Lot_Request__c();
		pr.requestee__c = e.id;
		pr.type__c = 'Parking Space';
		pr.vehicle_type__c = 'Car';
		pr.rate_type__c = 'Monthly';
		pr.parking_lot_Region__c = rList[0].id;
		pr.method_of_payment__c = 'Monthly';
		pr.start_date__c = date.today().addMonths(1);
		pr.no_charge__c = false;
		pr.status__c = 'Assigned';
		pr.expectant_mother__c = false;
		insert pr;	
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Replacement Pass';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.status__c = 'New';
		r.expectant_mother__c = false;
		r.related_parking_lot_Request__c = pr.id;
		insert r;
		
		
		GP_ApplicationParkingPassService.cancelReplacement('{"requestId":"' + r.id + '"' + ',"cancelDate":"' + string.valueOf(r.start_date__c) + '"' + '}');
		Test.stopTest();
		
		
	}
	
	static testmethod void test8(){

		TestGPData.createData(); 
		
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
		
		
		Test.startTest();
		
	
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		
		Parking_Lot_Request__c pr = new Parking_Lot_Request__c();
		pr.requestee__c = e.id;
		pr.type__c = 'Parking Space';
		pr.vehicle_type__c = 'Car';
		pr.rate_type__c = 'Monthly';
		pr.parking_lot_Region__c = rList[0].id;
		pr.method_of_payment__c = 'Monthly';
		pr.start_date__c = date.today().addMonths(1);
		pr.no_charge__c = false;
		pr.status__c = 'Assigned';
		pr.expectant_mother__c = false;
		insert pr;	
		
		/*
	 	public String vehicleType;
        public String requestType;
        public String startDate;
        public String endDate; 
        public String requesteeEmployeeId;
        public String rateType;
        public String parkingLotId;
        public String locationId;
        public String methodOfPayment;
        public String handicapAccessRequired;
        public String assignedSpaceRequired;
        public String reasonForCancellation;
        public String reasonForDelay;
        public String relatedRequestId;
        public String expectantMother;
        public String currentParkingPassId;
        public String companyCar;
		
		
		*/
		
		String json = '{"requestType":"Parking Space"'+
						',"vehicleType":"Car"'+
						',"startDate":"2018-09-28"'+
						',"requesteeEmployeeId":"59JRB"'+
						',"rateType":"Monthly"'+
						',"parkingLotId":""'+
						',"locationId":"' + rList[0].id + '"'+
						',"methodOfPayment":"Monthly"'+
						',"handicapAccessRequired":"false"'+
						',"assignedSpaceRequired":"true"'+
						',"reasonForCancellation":""'+
						',"reasonForDelay":""'+
						//',"relatedRequestId":""'+
						', "selectedVehicles" : [{"vehicleId":"' + v.id + '"}]'+
						'}';	
						
		GP_ApplicationParkingPassService.createParkingPassRequest(json);
		
		
		Test.stopTest();
		
		
	}
	
	/*
	
	*/
	
	static testmethod void test9(){

		TestGPData.createData(); 
		
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
		
	
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		
		Parking_Lot_Request__c pr = new Parking_Lot_Request__c();
		pr.requestee__c = e.id;
		pr.type__c = 'Parking Space';
		pr.vehicle_type__c = 'Car';
		pr.rate_type__c = 'Monthly';
		pr.parking_lot_Region__c = rList[0].id;
		pr.method_of_payment__c = 'Monthly';
		pr.start_date__c = date.today().addMonths(1);
		pr.no_charge__c = false;
		pr.status__c = 'Assigned';
		pr.expectant_mother__c = false;
		insert pr;	
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Replacement Pass';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.status__c = 'New';
		r.expectant_mother__c = false;
		r.related_parking_lot_Request__c = pr.id;
		insert r;
		
		string json = '{"employeeId":"' + '59JRB' + '","makeModel":"test2","registration":"reg","color":"Blue","type":"Car","companyCar":"false"}';
		
		
		GP_ApplicationParkingPassService.addvehicle(json);
		
		
		Employee_Vehicle__c v = new Employee_Vehicle__c();
		v.color__c = 'Blue';
		v.employee__c = e.id;
		v.make_model__c = 'Ford Escort';
		v.state__c = 'PA';
		v.status__c  = 'Active';
		v.type__c = 'Car';
		insert v;
		
		
		Parking_Lot_Request_Vehicles__c rv = new Parking_Lot_Request_Vehicles__c();
		rv.employee_vehicle__c = v.id;
		rv.parking_lot_Request__c = r.id;
		insert rv;
	 
		
		json = '{"vehicleId":"' + v.id + '","makeModel":"test2","registration":"reg","color":"Blue","type":"Car","companyCar":"false"}';
		
		GP_ApplicationParkingPassService.updateVehicleDetails(json);
		
		json = '{"vehicleId":"' + rv.id + '","makeModel":"test2","registration":"reg","color":"Blue","type":"Car","companyCar":"false"}';
		
		GP_ApplicationParkingPassService.deletePassVehicle(json);
		Test.stopTest();
		
		
	}
	
	static testmethod void test10(){

		TestGPData.createData(); 
		
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
		
	
		
		

		List<Parking_Lot_Region__c> rList = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		
		Parking_Lot_Request__c pr = new Parking_Lot_Request__c();
		pr.requestee__c = e.id;
		pr.type__c = 'Parking Space';
		pr.vehicle_type__c = 'Car';
		pr.rate_type__c = 'Monthly';
		pr.parking_lot_Region__c = rList[0].id;
		pr.method_of_payment__c = 'Monthly';
		pr.start_date__c = date.today().addMonths(1);
		pr.no_charge__c = false;
		pr.status__c = 'Assigned';
		pr.expectant_mother__c = false;
		insert pr;	
		
		Parking_Lot_Request__c r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Replacement Pass';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.status__c = 'New';
		r.expectant_mother__c = false;
		r.related_parking_lot_Request__c = pr.id;
		insert r;
		
		string json = '{"requestId":"' + r.id + '","makeModel":"test2","registration":"reg","color":"blue","type":"Car","companyCar":"false"}';
		
		
		GP_ApplicationParkingPassService.getPass(json);
		
		Test.stopTest();
		
		
	}
	static testmethod void test11(){

		TestGPData.createData(); 
		
		Test.startTest();
		
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
		
		
		Employee_Vehicle__c v = new Employee_Vehicle__c();
		v.color__c = 'Blue';
		v.employee__c = e.id;
		v.make_model__c = 'Ford Escort';
		v.state__c = 'PA';
		v.status__c  = 'Active';
		v.type__c = 'Car';
		insert v;
		
		
		Parking_Lot_Request_Vehicles__c rv = new Parking_Lot_Request_Vehicles__c();
		rv.employee_vehicle__c = v.id;
		rv.parking_lot_Request__c = r.id;
		insert rv;
	 
	 	String json = '{"requestId":"' + r.id + '"'+
						', "selectedVehicles" : [{"vehicleId":"' + v.id + '"}]'+
						'}';	
						
		
		GP_ApplicationParkingPassService.replacePassVehicles(json);
		
		
        
		json = '{"employeeId":"' + '59JRB' + '"'+
						', "makeModel":"abc"' + 
						', "registration":"abc"' + 
						', "color":"Blue"' + 
						', "type":"Car"' + 
						', "companyCar":"true"' + 
						', "highRoof":"true"' + 
						', "state":"abc"' + 
						'}';	
						
		GP_ApplicationParkingPassService.addVehicle(json);
		
		json = '{"employeeId":"' + '59JRB' + '"'+
						', "makeModel":"abc"' + 
						', "registration":"abc"' + 
						', "color":"Blue"' + 
						', "type":"Car"' + 
						', "companyCar":"false"' + 
						', "highRoof":"false"' + 
						', "state":"abc"' + 
						'}';	
		
		GP_ApplicationParkingPassService.addVehicle(json);
		
		Test.stopTest();
		
		
	}
	
	static testmethod void test12(){

		TestGPData.createData(); 
		
		Test.startTest();
		
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
		
		
		Employee_Vehicle__c v = new Employee_Vehicle__c();
		v.color__c = 'Blue';
		v.employee__c = e.id;
		v.make_model__c = 'Ford Escort';
		v.state__c = 'PA';
		v.status__c  = 'Active';
		v.type__c = 'Car';
		insert v;
		
		
		Parking_Lot_Request_Vehicles__c rv = new Parking_Lot_Request_Vehicles__c();
		rv.employee_vehicle__c = v.id;
		rv.parking_lot_Request__c = r.id;
		insert rv;
	 
	 	String json = '{"requestId":"' + r.id + '"'+
						 ',"cancelDate":' + '"' + string.valueOf(r.start_date__c) + '"'+
						 ',"cancelReason":"' + 'zyx' + '"'+
						'}';	
						
		
		GP_ApplicationParkingPassService.requestCancellation(json);
		
		
		Test.stopTest();
		
		
	}
	
	static testmethod void test13(){

		TestGPData.createData(); 
		
		Test.startTest();
		
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
		
		
		Employee_Vehicle__c v = new Employee_Vehicle__c();
		v.color__c = 'Blue';
		v.employee__c = e.id;
		v.make_model__c = 'Ford Escort';
		v.state__c = 'PA';
		v.status__c  = 'Active';
		v.type__c = 'Car';
		insert v;
		
		
		
		
		r = new Parking_Lot_Request__c();
		r.requestee__c = e.id;
		r.type__c = 'Cancellation';
		r.vehicle_type__c = 'Car';
		r.rate_type__c = 'Monthly';
		r.status__c = 'New';
		r.parking_lot_Region__c = rList[0].id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today();
		r.no_charge__c = false;
		r.end_date__c = date.today().addMonths(3);
		r.parking_lot__c = g.id;
		insert r;
		
		String json = '{"requestId":"' + r.id + '"'+
						 ',"cancelDate":' + '"' + string.valueOf(r.start_date__c) + '"'+
						 ',"cancelReason":"' + 'zyx' + '"'+
						'}';	
        
		//GP_ApplicationParkingPassService.requestCancellation(json);
		
		Test.stopTest();
		
		
	}
}