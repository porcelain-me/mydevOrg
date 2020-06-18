/***************************************************************************************************************
*
*  GP SERVICE HELPER
*
*  Changelog:
*
*  10/14/15 - MRM Created
*
****************************************************************************************************************/
public without sharing class GP_ServiceHelper {

    public GP_ServiceHelper (GP_ApplictionDataService controller) {}
    public GP_ServiceHelper () { } 
    public class forceException extends Exception {}
    
     
    /***************************************************************************************************************
    *
    *  GET ORDER OF REQUESTS FOR REGION - returns a map by vehicle type of a map of requests and thier order
    *
    ****************************************************************************************************************/
  
    public static Map<String,Map<String,String>> getRequestOrder (String locationId, Boolean sortByOrder){ 
    
        
        Map<String,Map<String,Map<String,String>>> vehicleRequestMapByRegion = new Map<String,Map<String,Map<String,String>>>();
        
        /* populate the order of requests for the region */
        system.debug('location id is:' + locationId);
        
        List<Parking_Lot_Request__c> requestsInRegion = new List<Parking_Lot_Request__c>();
        
        List<Parking_Lot_Request__c> requestsInRegion1 = new List<Parking_Lot_Request__c>();
        List<Parking_Lot_Request__c> requestsInRegion2 = new List<Parking_Lot_Request__c>();
        
        Parking_Lot_Region__c reg = [select name from Parking_Lot_Region__c where id = :locationId];
        
        if (reg.name != 'Glasgow' && reg.name != 'Budapest'){
            requestsInRegion1 = 
                [select id
                , name
                , vehicle_type__c 
                , parking_lot_region__c
                , parking_lot_region__r.name
                , rate_type__c
                from Parking_Lot_Request__c 
                where 
                status__c = 'New'
                and related_parking_lot_request__c = null
                and rate_type__c = 'Daily'
                order by requestee__r.global_parking_sort_order__c, createddate asc, vehicle_sort_order__c asc] ;
                
            requestsInRegion2 = 
                [select id
                , name
                , vehicle_type__c 
                , parking_lot_region__c
                , parking_lot_region__r.name
                , rate_type__c
                from Parking_Lot_Request__c 
                where 
                status__c = 'New'
                and related_parking_lot_request__c = null
                and rate_type__c <> 'Daily'
                order by requestee__r.global_parking_sort_order__c, createddate asc, vehicle_sort_order__c asc ];
                
            
        }
        else{
            requestsInRegion1 = 
                [select id
                , name
                , vehicle_type__c 
                , parking_lot_region__c
                , parking_lot_region__r.name
                , rate_type__c
                from Parking_Lot_Request__c 
                where 
                status__c = 'New'
                and related_parking_lot_request__c = null
                and rate_type__c = 'Daily'
                order by createddate asc 
                ];
                
            requestsInRegion2 = 
                [select id
                , name
                , vehicle_type__c 
                , parking_lot_region__c
                , parking_lot_region__r.name
                , rate_type__c
                from Parking_Lot_Request__c 
                where 
                status__c = 'New'
                and rate_type__c <> 'Daily'
                and related_parking_lot_request__c = null
                order by createddate asc 
                ];  
        }
        
        if (!requestsInRegion1.isEmpty())
            requestsInRegion.addAll(requestsInRegion1);
        if (!requestsInRegion2.isEmpty())
            requestsInRegion.addAll(requestsInRegion2); 
        
        Map<String,String> regionMap = new Map<String,String>();
        
        for(Parking_Lot_Request__c r:requestsInRegion){
            if (r.parking_lot_region__c != null)
                regionMap.put(r.parking_lot_Region__c,r.parking_lot_region__r.name);
        }
        
        Map<String,Integer> countMap;
        
        for (String rId:regionMap.keyset()){
            Map<String,Map<String,String>> vehicleRequestMap = new Map<String,Map<String,String>>();
            system.debug('Processing region =============================> ' + regionMap.get(rid)); 
            system.debug('************ now reviewing all requests...');
            countMap = new Map<String,Integer>();
            for (Parking_Lot_Request__c r:requestsInRegion){
                if (r.parking_lot_region__c == rid){
                    system.debug('parking lot request region ' + r.parking_lot_region__c + '-' + r.parking_lot_region__r.name);
                    system.debug('adding this request to region: ' + rid + ' request: ' + r.name);
                    
                    Map<String,String> rOrderMap = new Map<String,String>();   
                    Map<String,String> rOrderMapSort = new Map<String,String>();  
                
                    if (!vehicleRequestMapByRegion.isEmpty()){
                        system.debug('Getting vehicle request map for region!');
                        if (vehicleRequestMapByRegion.get(rid) != null)
                            vehicleRequestMap = vehicleRequestMapByRegion.get(rid);
                            system.debug('Vehicle request map: ' + vehicleRequestMap);
                    }  
                                         
                    if (vehicleRequestMap.get(r.vehicle_type__c) == null){
                        
                        if (sortByOrder)
                            rOrderMapSort.put('0',r.id); 
                        else
                            rOrderMap.put(r.id,'0');
                        countMap.put(r.vehicle_type__c,1);
                    }
                    else{
                        
                        if (sortByOrder)
                            rOrderMapSort = vehicleRequestMap.get(r.vehicle_type__c);
                        else
                            rOrderMap = vehicleRequestMap.get(r.vehicle_type__c);
                            
                        if (sortByOrder)
                            rOrderMapSort.put(string.valueOf(countMap.get(r.vehicle_type__c)),r.id);
                        else
                            rOrderMap.put(r.id,string.valueOf(countMap.get(r.vehicle_type__c)));
                        countMap.put(r.vehicle_type__c, countMap.get(r.vehicle_type__c) + 1);
                    }
                    
                    if (sortByOrder)
                        system.debug('rordermapsort:' + rorderMapSort);
                    else
                        system.debug('rordermap:' + rorderMap);
                        
                    if (sortByOrder)
                        vehicleRequestMap.put(r.vehicle_type__c,rOrderMapSort);
                    else
                        vehicleRequestMap.put(r.vehicle_type__c,rOrderMap);
                                            
                    vehicleRequestMapByRegion.put(rId,vehicleRequestMap);
                    
                }
                
            }
            
        }
        system.debug('----------------Done Filling in Maps by Region----------------------------');
        
        system.debug('Vehicle Request Map By Region:    ' + vehicleRequestMapbyRegion    );
        
        if (vehicleRequestMapByRegion.get(locationId) == null)
            return null;
        else
            return vehicleRequestMapByRegion.get(locationId);
        
    }  
   
    /**************************************************************************************************************
    *
    *  GET CENTS
    *
    ****************************************************************************************************************/ 
    public Static String getCents(Decimal x){
        String y = String.valueOf(x);
        String z = '.';
        if(y.contains(',')) z = ',';
        y = y.substring(0, y.indexOf(z));
        if(x - Decimal.valueOf(y) == 0)
            return String.valueOf(x.format()) + z + '00';
        else{
            String w = String.valueOf(x.format());
            
            List<String> sList = w.split('\\.');
            
            if (sLIst[1].length() == 1)
                return String.valueOf(x.format()) + '0';
            else
                return String.valueOf(x.format());
        }   
    }
    
    /***************************************************************************************************************
    *
    *  LOOKUP PRICE - helper class
    *
    ****************************************************************************************************************/
    
    public static GP_JSON.price lookupPrice (String rId, String vehicleType, String globalParkingLevel, String locationId, String rateType){
        
        Parking_Lot_Request__c r = [select parking_lot__c from Parking_Lot_Request__c where id = :rId];
        
        
        
        system.debug('input:' + r.parking_lot__c + '-' + rId + '-' + rateType + '-' + vehicleType + '-' + globalParkingLevel + '-' + locationId);
        
        List<Parking_Lot_Fee_Schedule_Details__c> dList = new List<Parking_Lot_Fee_Schedule_Details__c>([
        Select p.Type__c
        , p.Rate_Type__c
        , p.Parking_Lot_Fee_Schedule__r.Parking_Lot__c
        , p.Parking_Lot_Fee_Schedule__r.End_Effective_Date__c
        , p.Parking_Lot_Fee_Schedule__r.Start_Effective_Date__c
        , p.Parking_Lot_Fee_Schedule__c
        , p.Level_Dsc_Job__c
        , p.Id
        , p.fee__c 
        , p.CurrencyIsoCode
         From Parking_Lot_Fee_Schedule_Details__c p   
        where rate_type__c = 'Replacement Card Cost'
        and parking_lot_Fee_schedule__r.parking_lot__c = :r.parking_lot__c
        and parking_lot_fee_schedule__r.start_effective_date__c <= :date.today()
        and parking_lot_fee_schedule__r.end_effective_date__c >= :date.today()
        and parking_lot_fee_schedule__r.parking_Lot__r.parking_lot_Region__c = :locationId
        order by fee__c desc
        ]); 
        
        Parking_Lot_Region__c reg = [select name from Parking_Lot_Region__c where id = :locationId];
        
        Map<String,Parking_Lot_Fee_Schedule_Details__c> rateMap = new Map<String,Parking_Lot_Fee_Schedule_Details__c>();
        
        for (Parking_Lot_Fee_Schedule_Details__c d :dList){
            rateMap.put(d.type__c + '-' + d.level_dsc_job__c, d);
            system.debug('building rate map: ' + d.type__c + '-' + d.level_dsc_job__c);
        } 
        system.debug('Rate map: ' + rateMap);
        
        String currencyCode;
        String amount;
        system.debug('looking for : '+  vehicleType + '-' + globalParkingLevel);
        if (rateMap.get(vehicleType + '-' + globalParkingLevel) == null){
            system.debug('*** now looking for all');
            globalParkingLevel = 'All';
            system.debug('looking for : '+ vehicleType + '-' + globalParkingLevel);
            if (rateMap.get(vehicleType + '-' + 'All') == null)
                throw new forceException('Fatal Error:No Replacement Rate found for ' + rateType + '-' + vehicleType + '-' + globalParkingLevel + '-' + r.parking_lot__c);
        } 
        
        currencyCode = rateMap.get(vehicleType + '-' + globalParkingLevel).currencyIsoCode;
        
        Decimal a = rateMap.get(vehicleType + '-' + globalParkingLevel).fee__c;
        integer i = integer.valueOf(a);
        
        GP_JSON.price message; 
        if (reg.name == 'London' || reg.name == 'Glasgow')
            message = new GP_JSON.price(rateType, currencyCode, GP_ServiceHelper.getCents(a));
        else
            message = new GP_JSON.price(rateType, currencyCode,i.format());
            
        return message;
        
    } 
    
     /***************************************************************************************************************
    *
    *  GET PRICE FOR REQUEST
    *
    ****************************************************************************************************************/
    public class feeResults {
        
        public String currencyisocode;
        public String message;
        public Decimal fee;
        public feeResults (String c, Decimal f){
            this.currencyisocode = c;
            this.fee = f;
        }
    }
    
    public static feeResults lookupPriceForRequest (String rId, String plId){
        
        
        Parking_Lot_Request__c r = [select parking_Lot_Region__c
                                    , vehicle_type__c
                                    , parking_lot__c 
                                    ,parking_lot__r.name
                                    ,Requestee_Global_Parking_Level__c
                                    ,parking_lot__r.space_assignment__c
                                    ,rate_type__c
                                    ,company_car__c
                                    from Parking_Lot_Request__c where id = :rId];
        
        Parking_Lot__c l = [select name, space_assignment__c from Parking_Lot__c where id = :plId];
        
        Decimal fee;
        
        system.debug('R is: ' + r);
        Boolean assignedSpace;
        system.debug('plsa:' + l.space_assignment__c + '*');
        
        if (l.space_assignment__c == 'Assigned Space')
            assignedSpace = true;
        else
            assignedSpace = false;
            
            
        system.debug('assigned is: ' + assignedSpace);
        system.debug('company car is: ' + r.company_car__c);
            
        List<Parking_Lot_Fee_Schedule_Details__c> feeList = new List<Parking_Lot_Fee_Schedule_Details__c>();
        string lvlDesc1 = r.requestee_global_parking_level__c;
        String lvlDesc2 = 'All';
        
        system.debug('r ratetype :' + r.rate_type__c);
        system.debug('gpl:' + r.requestee_global_parking_level__c);
        system.debug('plid: ' + plID);
        feeList = new List<Parking_Lot_Fee_Schedule_Details__c> ([
            Select  p.fee__c , currencyisocode
            From Parking_Lot_Fee_Schedule_Details__c p   
            where rate_type__c = :r.rate_type__c
            and Level_Dsc_Job__c = :r.requestee_global_parking_level__c
            and parking_lot_Fee_schedule__r.parking_lot__c = :plId
            and assigned_space__c = :assignedSpace
            and company_owned__c = :r.company_car__c
            and type__c = :r.vehicle_type__c
            and parking_lot_fee_schedule__r.start_effective_date__c <= :date.today()
            and parking_lot_fee_schedule__r.end_effective_date__c >= :date.today()
            ]); 
            
        feeResults f = new feeResults (null,null);
        
        if (!feeList.isEmpty()){    
            f.currencyisocode = feeList[0].currencyisocode;
            f.fee = feeList[0].fee__c;
        }
        else{
            
            feeList = new List<Parking_Lot_Fee_Schedule_Details__c> ([
            Select  p.fee__c, currencyisocode
            From Parking_Lot_Fee_Schedule_Details__c p   
            where rate_type__c = :r.rate_type__c
            and Level_Dsc_Job__c = 'All'
            and parking_lot_Fee_schedule__r.parking_lot__c = :plId
            and assigned_space__c = :assignedSpace
            and company_owned__c = :r.company_car__c
            and type__c = :r.vehicle_type__c
            and parking_lot_fee_schedule__r.start_effective_date__c <= :date.today()
            and parking_lot_fee_schedule__r.end_effective_date__c >= :date.today()
            ]); 
            
            if (!feeList.isEmpty()){
                f.currencyisocode = feeList[0].currencyisocode;
                f.fee = feeList[0].fee__c;
            }
        
        }
        
        if (feeList.isEmpty()){
            f.message = 'Could not find Rate Type (' + r.rate_type__c + '), Assigned Space(' + assignedSpace + ')' + 
            ', Company Car(' + r.company_car__c + '), ' + 'for ' + lvlDesc1 + ' or ' + lvlDesc2 + ' in parking lot - ' +  l.name + '!';
        }
        else
            f.message = null;
            
        system.debug('Fee: ' + f);
        return f;
        
    } 
    /***************************************************************************************************************
    *
    *  Termination Process - this is used when an employee becomes terminated
    *
    ****************************************************************************************************************/
     
    public static void terminationProcess (Map<ID,String> terminationMap){
        
        List<Employee__c> eList = [select user__c from employee__c where id in :terminationMap.keySet()];
        
            
        Map<String,List<Parking_Lot_Request__c>> employeeRequestMap = new Map<String,List<Parking_Lot_Request__c>>();
        
        List<Parking_Lot_Request__c> prList = new List<Parking_Lot_Request__c>(); 
        prList = [select id 
                    ,status__c
                    ,type__c
                    ,requestee__c
                    from Parking_Lot_Request__c
                    where requestee__c in :terminationMap.keySet()
                    and type__c = 'Parking Space'
                    and status__c in ('Assigned','New')
                    ];
        
        for (Parking_Lot_Request__c r:prList){
            List<Parking_Lot_Request__c> temp = new List<Parking_Lot_Request__c>();
            if (employeeRequestMap.get(r.requestee__c) == null){
                temp.add(r);
            }
            else{
                temp = employeeRequestMap.get(r.requestee__c);
                temp.add(r);
            }           
            employeeRequestMap.put(r.requestee__c,temp);
        }
        
        /* remove terminated employees from being delegates */
        
        List<Employee_Delegate__c> dList = new List<Employee_Delegate__c>();
        dList = [select id
                from Employee_Delegate__c
                where delegate__c  in :terminationMap.keySet()
                and application__c = 'Global Parking'
                ];
        for (Employee_Delegate__c d:dList)
            d.status__c = 'Terminated';
            
        if (!dList.isEmpty())
            update dList;
        
        /* process all the terminated employees */  
        for (Employee__c e:eList){ 
            if (employeeRequestMap.get(e.id) != null){ //found existing requests
                //create cancellation requests for each assigned request
                for (Parking_Lot_Request__c r:employeeRequestMap.get(e.id)){
                    Map<String,String> jsonMsg = new Map<String,String>();
                    jsonMsg.put('requestId',r.id);
                    jsonMsg.put('cancelDate',string.valueOf(date.today())); 
                    jsonMsg.put('cancelReason','Employee Termination');
                    GP_ApplicationParkingPassService.requestCancellation(json.serialize(jsonMsg));
                }
            }
        }
        
    }
       
}