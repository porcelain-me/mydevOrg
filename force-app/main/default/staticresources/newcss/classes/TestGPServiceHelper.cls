@isTest()
public class TestGPServiceHelper {

	static testmethod void test1(){

		TestGPData.createData(); 
		
		Parking_Lot_Region__c reg = [select id, name from Parking_Lot_Region__c where name = 'Budapest'];
		Parking_Lot_Region__c reg2 = [select id, name from Parking_Lot_Region__c where name = 'London'];
		List<Parking_Lot_Space__c> spaceList = [Select p.SystemModstamp, p.Status__c, p.Status_Notes__c, p.Space_Type__c, p.RecordTypeId, p.Parking_Lot__c, p.No_Charge__c, p.Name, p.Location__c, p.Location_Space__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof_Space__c, p.Expectant_Mother_Space__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById From Parking_Lot_Space__c p];
		system.debug('space list is: ' + spaceList);
		
		Parking_Lot__c pl = [select id from Parking_Lot__c where Parking_Lot_Region__c = :reg.id limit 1 ];
		
		
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
		r.parking_lot_Region__c = reg.id;
		r.method_of_payment__c = 'Monthly';
		r.start_date__c = date.today().addMonths(1);
		r.no_charge__c = false;
		r.expectant_mother__c = false;
		r.parking_lot__c  = pl.id;
		insert r;
		
		GP_ServiceHelper.getRequestOrder(reg.id,true);
		GP_ServiceHelper.getRequestOrder(reg.id,false);
		GP_ServiceHelper.getRequestOrder(reg2.id,true);
		
		string test = GP_ServiceHelper.getCents(100.12);
		
		// public static GP_JSON.price lookupPrice (String rId, String vehicleType, String globalParkingLevel, String locationId, String rateType){
    	GP_ServiceHelper.lookupPrice (r.id, 'Car', 'VP - Vice President', reg.id, 'Monthly');
    	
    	Map <ID,String> emap = new Map<ID,String>();
    	emap.put(e.id,'');
    	//GP_ServiceHelper.terminationProcess(emap);
	}	
	
	
}