public class TestGPData {

	public static void createData(){
		
		GP_Master_Settings__c settings = new GP_Master_Settings__c(name='Settings');
		insert settings;
		
		List<Parking_Lot_Region__c> rList = new List<Parking_Lot_Region__c>();
		
		Parking_Lot_Region__c r = new Parking_Lot_Region__c();
		
		r.name = 'Budapest';
		r.Allow_Company_Car_Indicator__c = true;
		r.Allow_Consumption_Parking__c = true;
		r.Nbr_of_Vehicles_Allowed_on_Pass__c = 100;
		r.Billing_Period__c = 'Current Month';
		
		rList.add(r);
		
		r = new Parking_Lot_Region__c();
		
		r.name = 'London';
		r.Allow_Company_Car_Indicator__c = false;
		r.Allow_Consumption_Parking__c = false;
		r.Nbr_of_Vehicles_Allowed_on_Pass__c = 100;
		r.Weekend_Overnight_Parking__c = true;
		r.Billing_Period__c = 'Current Month';
		
		rList.add(r);
		
		r = new Parking_Lot_Region__c();
		
		r.name = 'Tokyo';
		r.Allow_Company_Car_Indicator__c = false;
		r.Allow_Consumption_Parking__c = false;
		r.Nbr_of_Vehicles_Allowed_on_Pass__c = 1;
		r.Weekend_Overnight_Parking__c = true;
		r.allow_no_charge_parking__c = false;
		r.allow_high_roof_indicator__c = true;
		r.Billing_Period__c = 'Next Month';
		
		rList.add(r);

		r = new Parking_Lot_Region__c();
		r.name = 'Purchase';
		r.Allow_Company_Car_Indicator__c = false;
		r.Allow_Consumption_Parking__c = false;
		r.Nbr_of_Vehicles_Allowed_on_Pass__c = 1;
		r.Weekend_Overnight_Parking__c = false;
		r.allow_no_charge_parking__c = false;
		r.allow_high_roof_indicator__c = true;
		r.Billing_Period__c = 'Next Month';
		
		rList.add(r);
		
		
		r = new Parking_Lot_Region__c();
		r.name = 'Glasgow';
		r.Allow_Company_Car_Indicator__c = false;
		r.Allow_Consumption_Parking__c = false;
		r.Nbr_of_Vehicles_Allowed_on_Pass__c = 100;
		r.Weekend_Overnight_Parking__c = true;
		r.allow_no_charge_parking__c = true;
		r.allow_high_roof_indicator__c = true;
		r.Billing_Period__c = 'Current Month';
		
		rList.add(r);
		insert rList;
		
		Map<String,ID> recTypeMap = new Map<String,ID>();
		List<RecordType> recList = [select id, developername from RecordType where sobjectType = 'Parking_Lot__c'];
		for (RecordType rt:recList)
			recTypeMap.put(rt.developername, rt.id);
			
		Map<String,Parking_Lot_Region__c> rMap = new Map<String,Parking_Lot_Region__c>();
		
		List<Parking_Lot_Region__c> tList = [select id, name from Parking_Lot_Region__c];
		for (Parking_Lot_Region__c t:tList)
			rMap.put(t.name,t);
			
		List<Parking_Lot__c> pList = new List<Parking_Lot__c>();
		
		Parking_Lot__c l = new Parking_Lot__c();
		
		
		l.Space_Assignment__c = 'Assigned Spaces';
		l.RecordTypeId = recTypeMap.get('Glasgow');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'No Charge (Bicycle Only); Salary Sacrifice (1 Yr Commit, Pre-Tax); Salary Deduction (Month-to-Month, Taxed)';
		l.Parking_Lot_Region__c = rMap.get('Glasgow').id;
		l.Name = 'Sentinel';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		pList.add(l);
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Assigned Spaces';
		l.RecordTypeId = recTypeMap.get('Glasgow');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'No Charge (Motorcycle Only); Salary Sacrifice (1 Yr Commit, Pre-Tax); Salary Deduction (Month-to-Month, Taxed)';
		l.Parking_Lot_Region__c = rMap.get('Glasgow').id;
		l.Name = 'Cerium';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		pList.add(l);
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Any Available';
		l.RecordTypeId = recTypeMap.get('USA');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'No Charge';
		l.Parking_Lot_Region__c = rMap.get('Purchase').id;
		l.Name = 'Indoor/Outdoor';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Assigned Space';
		l.RecordTypeId = recTypeMap.get('USA');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'No Charge';
		l.Parking_Lot_Region__c = rMap.get('Purchase').id;
		l.Name = 'Indoor MD Only';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Assigned Space';
		l.RecordTypeId = recTypeMap.get('USA');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'No Charge';
		l.Parking_Lot_Region__c = rMap.get('Purchase').id;
		l.Name = 'Mother';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Any Available';
		l.RecordTypeId = recTypeMap.get('Tokyo');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'Monthly';
		l.Parking_Lot_Region__c = rMap.get('Tokyo').id;
		l.Name = 'Hung Dung 1';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Assigned Space';
		l.RecordTypeId = recTypeMap.get('Tokyo');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'Monthly';
		l.Parking_Lot_Region__c = rMap.get('Tokyo').id;
		l.Name = 'Hung Dung 2';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Any Available';
		l.RecordTypeId = recTypeMap.get('London');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'No Charge (Bicycle Only)';
		l.Parking_Lot_Region__c = rMap.get('London').id;
		l.Name = 'HQ1 - Area D';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Any Available';
		l.RecordTypeId = recTypeMap.get('London');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'Invoice (Monthly, Contractors Only); Salary Sacrifice (1 Yr Commit, Pre-Tax); Salary Deduction (Month-to-Month, Taxed)';
		l.Parking_Lot_Region__c = rMap.get('London').id;
		l.Name = 'Cabot Square';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		l = new Parking_Lot__c();
		
		l.Space_Assignment__c = 'Any Available';
		l.RecordTypeId = recTypeMap.get('Budapest');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'Monthly';
		l.Parking_Lot_Region__c = rMap.get('Budapest').id;
		l.Name = 'Millenium II';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		pList.add(l);
		
		l = new Parking_Lot__c();
		l.Space_Assignment__c = 'Assigned Space';
		l.RecordTypeId = recTypeMap.get('Budapest');
		l.Rates__c = 'Monthly';
		l.Payment_Type_Accepted__c = 'Monthly; No Charge (Bicycle Only);Consumption';
		l.Parking_Lot_Region__c = rMap.get('Budapest').id;
		l.Name = 'Millenium III';
		l.Address__c = '1';
		l.City__c = '2';
		l.Zip__c = '3';
		
		
		pList.add(l);
		insert pList;
		
		Map<String,ID> recTypeMapFeeSchedule = new Map<String,ID>();
		List<RecordType> recList2 = [select id, developername from RecordType where sobjectType = 'Parking_Lot_Fee_Schedule__c'];
		for (RecordType rt:recList2){
			recTypeMapFeeSchedule.put(rt.developername, rt.id);
			if (rt.developername == 'USA'){
				recTypeMapFeeSchedule.put('Purchase',rt.id);
			}
		}
		
		Map<String,ID> recTypeMapSpace = new Map<String,ID>();
		List<RecordType> recList3 = [select id, developername from RecordType where sobjectType = 'Parking_Lot_Space__c'];
		for (RecordType rt:recList3){
			recTypeMapSpace.put(rt.developername, rt.id);
			if (rt.developername == 'USA'){
				recTypeMapSpace.put('Purchase',rt.id);
			}
		}
		List<Parking_Lot_Assignment__c> aRules = new List<Parking_Lot_Assignment__c>();
		List<Parking_Lot_Space__c> spaces = new List<Parking_Lot_Space__c>();
		List<Parking_Lot_Fee_Schedule__c> sList = new List<Parking_Lot_Fee_Schedule__c>();
		
		List<Parking_Lot__c> parkingLotList = [select id, parking_lot_region__r.name from Parking_Lot__c];
		Integer i = 0;
		
		for (Parking_Lot__c pl:parkingLotList){
			Parking_Lot_Fee_Schedule__c f = new Parking_Lot_Fee_Schedule__c();
			f.name = 'Monthly';
			f.recordtypeid = recTypeMapFeeSchedule.get(pl.parking_lot_Region__r.name);
			f.end_effective_date__c = date.parse('12/31/2020');
			f.start_effective_date__c = date.parse('1/1/1900');
			f.parking_lot__c = pl.id;
			f.rate_type__c = 'Monthly';
			sList.add(f);
			
			f = new Parking_Lot_Fee_Schedule__c();
			f.name = 'Monthly';
			f.recordtypeid = recTypeMapFeeSchedule.get(pl.parking_lot_Region__r.name);
			f.end_effective_date__c = date.parse('12/31/2020');
			f.start_effective_date__c = date.parse('1/1/1900');
			f.parking_lot__c = pl.id;
			f.rate_type__c = 'Replacement Card Cost';
			sList.add(f);
			
			f = new Parking_Lot_Fee_Schedule__c();
			f.name = 'Monthly';
			f.recordtypeid = recTypeMapFeeSchedule.get(pl.parking_lot_Region__r.name);
			f.end_effective_date__c = date.parse('12/31/2020');
			f.start_effective_date__c = date.parse('1/1/1900');
			f.parking_lot__c = pl.id;
			f.rate_type__c = 'Hourly';
			sList.add(f);
			
			
			
			Parking_Lot_Assignment__c sar;
			
			sar = new Parking_Lot_Assignment__c();
			
			sar.parking_lot__c = pl.id;
			sar.vehicle_type_level__c = 'All';
			sar.vehicle_type__c = 'Car';
			sar.vehicle_type_assignment__c = 'Assigned';
			aRules.add(sar);
			
			sar = new Parking_Lot_Assignment__c();
			sar.parking_lot__c = pl.id;
			sar.vehicle_type_level__c = 'All';
			sar.vehicle_type__c = 'Car';
			sar.vehicle_type_assignment__c = 'Unassigned';
			aRules.add(sar);
			
			
			sar = new Parking_Lot_Assignment__c();
			sar.parking_lot__c = pl.id;
			sar.vehicle_type_level__c = 'All';
			sar.vehicle_type__c = 'Bicycle';
			sar.vehicle_type_assignment__c = 'Assigned';
			aRules.add(sar);
			
			sar = new Parking_Lot_Assignment__c();
			sar.parking_lot__c = pl.id;
			sar.vehicle_type_level__c = 'All';
			sar.vehicle_type__c = 'Bicycle';
			sar.vehicle_type_assignment__c = 'Unassigned';
			aRules.add(sar);
			
			sar = new Parking_Lot_Assignment__c();
			sar.parking_lot__c = pl.id;
			sar.vehicle_type_level__c = 'All';
			sar.vehicle_type__c = 'Motorcycle';
			sar.vehicle_type_assignment__c = 'Assigned';
			aRules.add(sar);
			
			sar = new Parking_Lot_Assignment__c();
			sar.parking_lot__c = pl.id;
			sar.vehicle_type_level__c = 'All';
			sar.vehicle_type__c = 'Motorcycle';
			sar.vehicle_type_assignment__c = 'Unassigned';
			aRules.add(sar);
			
			Parking_Lot_Space__c space;
			i++;
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'Car100' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Car';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'Car101' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Car';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'Car102' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Car';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'Car103' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Car';
			space.status__c = 'Available';
			space.no_charge__c = true;
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'Car104' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Car';
			space.status__c = 'Available';
			space.expectant_mother_space__c = true;
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'Car105' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Car';
			space.status__c = 'Available';
			space.compact__c = true;
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'Car106' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Car';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'B101' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Bicycle';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'B102' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Bicycle';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'B103' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Bicycle';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);	
			space.name = 'M100' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Motorcycle';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'M101' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Motorcycle';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'M102' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Motorcycle';
			space.status__c = 'Available';
			spaces.add(space);
			
			space = New Parking_Lot_Space__c();
			space.recordtypeid =  recTypeMapSpace.get(pl.parking_lot_Region__r.name);
			space.name = 'M103' + '-' + i;
			space.parking_lot__c = pl.id;
			space.space_type__c = 'Motorcycle';
			space.status__c = 'Available';
			spaces.add(space);
			
			
		}
		
		insert sList;
		insert aRules;
		insert spaces;
		
		List<Parking_Lot_Fee_Schedule_Details__c> details = new List<Parking_Lot_Fee_Schedule_Details__c>();
		
		List<Parking_Lot_Fee_Schedule__c> sList1 = [select id, parking_lot__r.parking_lot_region__r.name from Parking_Lot_Fee_Schedule__c];
		for (Parking_Lot_Fee_Schedule__c s:sList1){
			Parking_Lot_Fee_Schedule_Details__c fs = new Parking_Lot_Fee_Schedule_Details__c();
			fs.parking_lot_fee_schedule__c = s.id;
			fs.Level_Dsc_Job__c= 'All';
			fs.type__c = 'Car';
			fs.fee__c = 100;
			fs.assigned_space__c = true;
			details.add(fs);
			
			fs = new Parking_Lot_Fee_Schedule_Details__c();
			fs.parking_lot_fee_schedule__c = s.id;
			fs.Level_Dsc_Job__c= 'All';
			fs.type__c = 'Car';
			fs.fee__c = 100;
			fs.assigned_space__c = true;
			fs.company_owned__c = true;
			details.add(fs);
			
			
			fs = new Parking_Lot_Fee_Schedule_Details__c();
			fs.parking_lot_fee_schedule__c = s.id;
			fs.Level_Dsc_Job__c= 'All';
			fs.type__c = 'Car';
			fs.fee__c = 100;
			details.add(fs);
			
			
			fs = new Parking_Lot_Fee_Schedule_Details__c();
			fs.parking_lot_fee_schedule__c = s.id;
			fs.Level_Dsc_Job__c= 'All';
			fs.type__c = 'Bicycle';
			fs.fee__c = 10;
			details.add(fs);
			
			fs = new Parking_Lot_Fee_Schedule_Details__c();
			fs.parking_lot_fee_schedule__c = s.id;
			fs.Level_Dsc_Job__c= 'All';
			fs.type__c = 'Motorcycle';
			fs.fee__c = 100;
			details.add(fs);
			
		}
		
		insert details;
		
		
	}
}