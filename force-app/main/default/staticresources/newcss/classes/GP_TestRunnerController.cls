/***************************************************************************************************************
*
*
****************************************************************************************************************/
public with sharing class GP_TestRunnerController{

    public Integer currentCount {get;set;}
    public Integer initialCount {get;set;}
    public Integer soFar {get;set;}
    public Boolean enable {get;set;}
    public Boolean renderStop {get;set;}
    public Boolean renderStart {get;set;}
    public Parking_Lot_Request__c l {get;set;}
    List<Parking_Rate_Test__c> tList;
    Set<ID> idSet = new Set<ID>();
   
   
        
    public GP_TestRunnerController (ApexPages.StandardController controller) {
    	
    	
    	l = (Parking_Lot_Request__c) controller.getRecord();
    	
    	soFar = 0;
    	currentCount = 0;
    	initialCount = 0;
    	enable = false;
    	renderStart = true;
    	
    } 
    
	public PageReference start() {
		
		soFar = 0;
    	currentCount = 0;
    	initialCount = 0;
		renderStop = true;
		idSet = new Set<ID>();
		
		renderStart = false;
		tList = [select assigned__c, company_owned__c, handicap__c, location_id__c, parking_level__c, rate_type__c, vehicle_type__c from 
						Parking_Rate_Test__c where result__c like '%Fatal%' and location_id__c = :string.valueOf(l.parking_lot_region__c).substring(0,15)];
    	currentCount = tList.size();
    	initialCount = tList.size();
    	
		enable = true;
		
		system.debug('**** Parking lot region is: ' + l.parking_lot_Region__c);
		
		return null;
		
	}  
	
	public PageReference stop() {
		
		enable = false;
		renderStop = false;
		renderStart = true;
		
		return null;
		
	}  
     
	public PageReference run() {
		
		system.debug('**** Parking lot region is: ' + l.parking_lot_Region__c);
		
		tList = [select assigned__c, company_owned__c, handicap__c, location_id__c, parking_level__c, rate_type__c, vehicle_type__c from 
						Parking_Rate_Test__c where result__c like '%Fatal%'  and id not in: idSet and location_id__c = :string.valueOf(l.parking_lot_region__c).substring(0,15) limit 10];

		for (Parking_Rate_Test__c t:tList)
			idSet.add(t.id);
			
		soFar = idSet.size();
		
		system.debug('***** ID SET SIZE:' + idSet.size());
			
		List<Parking_Rate_Test__c> uList = new List<Parking_Rate_Test__c>();
 
		for (Parking_Rate_Test__c r: tList){
			Map<String,String> tempMap = new Map<String,String>();
    		tempMap.put('rateType',r.rate_type__c);
    		tempMap.put('vehicleType',r.vehicle_type__c);
    		tempMap.put('requesteeGlobalParkingLevel',r.parking_level__c);
    		tempMap.put('handicapAccessRequired',r.handicap__c.tolowercase());
    		tempMap.put('companyOwned',r.company_owned__c.tolowercase());
    		tempMap.put('locationid',r.location_id__c);
    
			GP_JSON.price result;

			try{
				result = GP_MoneyService.getPassPrice(JSON.Serialize(tempMap));
        		system.debug(result);
				r.result__c = string.valueOf(result);
				uList.add(r);
			}
			catch (exception e) {
				r.result__c = string.valueOf(e);
				uList.add(r);
				system.debug(result);
			}

		}	
		
		update uList;
		
		tList = [select assigned__c, company_owned__c, handicap__c, location_id__c, parking_level__c, rate_type__c, vehicle_type__c from 
						Parking_Rate_Test__c where result__c like '%Fatal%' and location_id__c = :string.valueOf(l.parking_lot_region__c).substring(0,15)];
    	currentCount = tList.size();
    	
    	
    	if (soFar >= initialCount)
    		stop();
    		
    	return null;

	}

 
    
}