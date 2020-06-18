/******************************************************************************************
* Global Parking Queue Display
*
* This will help show the order of requests in a queue
*
* ChangeLog:
*
*  12/15/15 - Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public without sharing class GP_Queue_Display { 
    
    public Parking_Lot_Region__c r {get;set;} 
    public List<requestWrapper> requests {get;set;}
   
    
    /****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
    public GP_Queue_Display(ApexPages.StandardController controller) {
    	
    	r = (Parking_Lot_Region__c) controller.getRecord();  
    	
    	requests = new List<requestWrapper>();
   	
    	Map<String,Map<String,String>> vehicleRequestMap = new Map<String,Map<String,String>>();
    	 
    	
    	vehicleRequestMap = GP_ServiceHelper.getRequestOrder(r.id,true); 
    	
    	system.debug('vehicle request map' + vehicleRequestMap);
    	
    	if (vehicleRequestMap != null){
    		
    	 
    		Set<ID> requestIdSet = new Set<ID>();
    	 
    	
    		Map<String,String> tempOrderMap = new Map<String,String>(); 
    		if (vehicleRequestMap.get('Car') != null){
    		
	    		tempOrderMap = vehicleRequestMap.get('Car');
    	 
    			for (String t:tempOrderMap.keySet()){
    				requestIdSet.add(tempOrderMap.get(t));
    			}
    		}
    		
    		if (vehicleRequestMap.get('Motorcycle') != null){
    			tempOrderMap = vehicleRequestMap.get('Motorcycle');
    	 
    			for (String t:tempOrderMap.keySet()){
	    			requestIdSet.add(tempOrderMap.get(t));
    			}
    		}
    	
    		if (vehicleRequestMap.get('Bicycle') != null){ 
    			tempOrderMap = vehicleRequestMap.get('Bicycle');
    	 
    			for (String t:tempOrderMap.keySet()){
    				requestIdSet.add(tempOrderMap.get(t));
    			}
    		}
    	
    		Map<String,Parking_Lot_Request__c> requestMap = new Map<String,Parking_Lot_Request__c>([select 
    			name
    			,  vehicle_type__c
    			, requestee__r.name
    			, requestee__r.global_parking_level__c
    			, rate_type__c
    			, createddate  
    			from Parking_Lot_Request__c where id in:requestIdSet ]);
    			
    		system.debug('requestId set:' + requestIdSet);
    	 
    	 
    		system.debug('Vehicle Request Map: ' + vehicleRequestMap);
    	
    		for (String s:vehicleRequestMap.keySet()){
    			Map<String,String> rOrderMap = new Map<String,String>(); 
    			if (s == 'Car'){
    				rOrderMap = vehicleRequestMap.get('Car');
    		
    				for (String t:rOrderMap.keySet()){
    					system.debug('t is: ' + t);
    					requests.add(new requestWrapper(t,requestMap.get(rOrderMap.get(t))));
    				}
    			}
    			else{
    				if (s == 'Motorcycle'){
    					rOrderMap = vehicleRequestMap.get('Motorcycle');
    					for (String t:rOrderMap.keySet()){
    						system.debug('t is: ' + t);
    						requests.add(new requestWrapper(t,requestMap.get(rOrderMap.get(t))));
    					}
    				}
    				else{
    					if (s == 'Bicycle'){
    						rOrderMap = vehicleRequestMap.get('Bicycle');
    						for (String t:rOrderMap.keySet()){
    							system.debug('t is: ' + t);
    							requests.add(new requestWrapper(t,requestMap.get(rOrderMap.get(t))));
    						}		
    					}
    				}
    			}
    		}
    	}
    	 
    	
    	
   }
   /****************************
   * REQUEST WRAPPER 
   *****************************/
   public class requestWrapper {
   		public String seq {get;set;}
   		public Parking_Lot_Request__c r {get;set;}
   		 
   		public requestWrapper(String seq, Parking_Lot_Request__c r){
   			this.seq = seq;
   			this.r = r;
   		 
   			
   		}
   }
   
   	
}