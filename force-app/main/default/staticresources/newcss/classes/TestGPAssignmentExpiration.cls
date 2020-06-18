@isTest()
public class TestGPAssignmentExpiration {

	static testmethod void TestGPAssignmentExpiration(){

	
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
		insert r2;
		
		 
		id batchId = Database.executeBatch(new GP_AssignmentExpiration(), 1000);
		
	}
			
}