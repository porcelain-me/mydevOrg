@isTest
private class TestGPJSON {

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
		
		GP_JSON.price p = new GP_JSON.price ('Monthly', 'USD', '100.00'); 
		GP_JSON.price p1 = new GP_JSON.price ('Hourly', 'USD', '100.00'); 
		GP_JSON.price p2 = new GP_JSON.price ('Replace', 'USD', '100.00'); 
       
        GP_JSON.vehicle v = new GP_JSON.vehicle('', 'Car', 'Make', 'Blue', 'false','0', 'regis', 'PA','false','');
    	
    	GP_JSON.vehicleId vid = new GP_JSON.vehicleId('');
    	
    	GP_JSON.colorsAllowed ca = new GP_JSON.colorsAllowed('');
    	
    	GP_JSON.helpDocUrl hd = new GP_JSON.helpDocUrl('');
    	
    	GP_JSON.cancelReason cr = new GP_JSON.cancelReason('');
    	
    	GP_JSON.paymentRate pr = new GP_JSON.paymentRate('');
    	
    	GP_JSON.paymentMethodClass pm = new GP_JSON.paymentMethodClass('');
    			
     	GP_JSON.vehicleType vt = new GP_JSON.vehicleType('','','');
     	
     	GP_JSON.locationSetting ls = new GP_JSON.locationSetting(null,null,null,true);
    	
    	GP_JSON.location l = new GP_JSON.location(null,null,null,null
    	,null,null,null,null
    	,null,null,null,null
    	,null,null,null,null);
    	
    	//public userDetails (String name, String displayName, String employeeId, String contact, String city) 
    	GP_JSON.userDetails ud = new GP_JSON.userDetails(null,null,null,null,null);
    	
    	//delegate (String id, String msid, String name) {
    	GP_JSON.delegate d = new GP_JSON.delegate(null,null,null,null);
    	 
    	GP_JSON.delegationRequest dr = new GP_JSON.delegationRequest(null,null);
    	
    	GP_JSON.resultName rn = new GP_JSON.resultName('');
    	
    	GP_JSON.timeDetailId tdi = new GP_JSON.timeDetailId('');
    	
    	GP_JSON.age a = new GP_JSON.age('');
    	
    	GP_JSON.pass ps = new GP_JSON.pass('','','','','');  
    	
    	GP_JSON.pass ps2 = new GP_JSON.pass('','','');  
    	
    	
    	//public billingHistory(Parking_Lot_Assignment_Fees_Due__c i, List<timeDetail> timeEntryList, Map<String,String> invoicePDFMap) {
    	
    		
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
		
		Parking_Lot_Invoice_Run__c ir = new Parking_Lot_Invoice_Run__c (parking_lot_Region__c = reg.id );
		insert ir;
		
		Parking_Lot_Assignment_Fees_Due__c invoice = new Parking_Lot_Assignment_Fees_Due__c(Parking_Invoice_Run__c = ir.id, amount_billed__c = 100.00, amount_paid__c = 1.00);
   		insert invoice; 
   		
    	GP_JSON.billingHistory bh = new GP_JSON.billingHistory(invoice,null,null);
    	
    	Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :reg.id limit 1 ];
		
		
    	List<Parking_Lot_Space__c> pList = [select id, name from Parking_Lot_Space__c where parking_lot__c = :pl.id and space_type__c = 'Car' 
        	and status__c = 'Available'	];
        
        Parking_Lot_Space_Assignment__c sa = new Parking_Lot_Space_Assignment__c();
        sa.employee__c = e.id;
        sa.parking_lot_Request__c = r.id;
        sa.parking_lot_space__c = pList[0].id;
        sa.method_of_payment__c = 'Hourly';
        sa.Assignment_Start_DATE__C = date.today().addMonths(1);
        sa.Assignment_end_DATE__C = date.today().addMonths(24);
        sa.parking_pass_id__c = '100asdasdf';
        insert sa;
        
		Parking_Lot_Space_Assignment_Time_Used__c tu = new Parking_Lot_Space_Assignment_Time_Used__c();
		Date myDate = date.today().addMonths(1);
		Time myTime = Time.newInstance(3, 3, 3, 0);
		DateTime dt = DateTime.newInstance(myDate, myTime);
		tu.invoice__c = invoice.id;
		tu.parking_Lot_Space_Assignment__c= sa.id;
		
		tu.in__c = dt;
		tu.out__c = dt.addHours(8);
		tu.resolved__c = true;
		insert tu;
		
    	GP_JSON.timeDetail td = new GP_JSON.timeDetail(tu);
    	
    	GP_JSON.passes psss = new GP_JSON.passes(null,null);
    	
    	// public MyPass(Parking_Lot_Request__c r, Map<String,Map<String,String>> vehicleRequestMap, List<GP_JSON.passVehicle> passVehicles, String displayPassId, String spaceName){
        GP_JSON.myPass mp = new GP_JSON.mypass(r,null,null,null,null,null);   	
    	
    	GP_JSON.requestId rid = new GP_JSON.requestId(null);
    	
    	GP_JSON.requestIdWithName ridwn = new GP_JSON.requestIdWithName(null,null);
    	
    	GP_JSON.resultId resid = new GP_JSON.resultId(null);
    	
    	GP_JSON.searchResult srid = new GP_JSON.searchResult(null,null);
    	
    	Test.stopTest();
	}


}