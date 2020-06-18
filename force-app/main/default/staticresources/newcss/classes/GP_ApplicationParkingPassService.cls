/***************************************************************************************************************
*
*  GP APPLICATION PARKING PASS SERVICE - this is used by the global parking front end for parking pass related calls
*
*  Changelog:
*
*  9/25/15 - MRM Created
*
****************************************************************************************************************/
public without sharing class GP_ApplicationParkingPassService {

    public GP_ApplicationParkingPassService (GP_ApplictionDataService controller) {

    }
    public GP_ApplicationParkingPassService () { } 
       
     
    
    
    /***************************************************************************************************************
    *
    *  GET LOCATIONS - returns the parking lot regions
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static List<GP_JSON.location> getLocations(String messageIn) {    

        GP_JSON.inputmsid input;
        
        
        system.debug('*** message in:' + messageIn);
        
        if (messageIn != '')
            input = (GP_JSON.inputmsId) System.JSON.deserialize(messageIn, GP_JSON.Inputmsid.class);
        
        Employee__c e;
        String globalParkingLevel = null;
        
        List<GP_JSON.location> message = new List<GP_JSON.location>();
        
        if (input != null){
            if (input.msid != null){
                e = [select global_parking_level__c
                            from Employee__c
                            where emp_id__c = :input.msid];
                globalParkingLevel = e.global_parking_level__c;
            }                   
        }
        
        
        List<Parking_Lot_Region__c> locList = new List<Parking_Lot_Region__c>();
        locList = [Select p.Name
                , p.Id
                , p.Allow_High_Roof_Indicator__c
                , p.Allow_Company_Car_Indicator__c
                , terms_and_conditions__c
                , weekend_overnight_parking__c
                , nbr_of_vehicles_allowed_on_pass__c
                , allow_no_charge_parking__c
                , allow_states__c
                , allow_Expectant_Mother__c
                , allow_current_parking_pass_id__c
                , send_declaration__c
                , enrollment_period_start_date__c
                , enrollment_period_end_date__c
                , allow_delayed_start__C
                From Parking_Lot_Region__c p]; 
         
        
        for (Parking_Lot_Region__c r:locList){   
         
            String hr = string.valueOf(r.allow_high_roof_indicator__c);
            String cc = string.valueOf(r.allow_company_car_indicator__c);
            String wo = string.valueOf(r.weekend_overnight_parking__c);
            String nbr = string.valueOf(r.nbr_of_Vehicles_allowed_on_pass__c);
            String hc = string.valueOf(r.allow_no_charge_parking__c);
            String st = string.valueOf(r.allow_states__c);
            String em = string.valueOf(r.allow_Expectant_Mother__c);
            String ac = string.valueOf(r.allow_current_parking_pass_id__c);
            String dec = string.valueOf(r.send_declaration__c);
            String ad = string.valueOf(r.allow_delayed_start__c);
            String start ;
            if (r.enrollment_period_start_Date__c != null)
                        start = string.valueOf(r.enrollment_period_start_date__c.format());
            String eend;
            if (r.enrollment_period_start_Date__c != null)
                
                eend = string.valueOf(r.enrollment_period_end_date__c.format());
            
            List<GP_JSON.locationSetting> locationSettings = new List<GP_JSON.locationSetting>();
            
            Map<String,String> locationMap = new Map<String,String>();
            locationMap.put('locationId',r.id);
            
            locationSettings.add(getLocationSettings(JSON.Serialize(locationMap),globalParkingLevel));
            
            message.add(new GP_JSON.Location(string.valueOf(r.id), r.name, hr, cc, r.terms_and_conditions__c,wo,locationSettings,nbr,hc,st,em,ac,dec,start,eend,ad));  
             
         }
        
        return message;
        
    }
    
    
    /***************************************************************************************************************
    *
    *  GET LOCATION SETTINGS - returns the parking lot region's payment types and rate types
    *
    ****************************************************************************************************************/
     
    @RemoteAction
    public static GP_JSON.locationSetting getLocationSettings(String messageIn,String globalParkingLevel) {
    
        
        
        GP_JSON.inputLocationId request;
        
        request = (GP_JSON.inputLocationId) System.JSON.deserialize(messageIn, GP_JSON.InputLocationId.class);
        
        Parking_Lot_Region__c r = [select allow_states__c from parking_lot_Region__c where id = :request.locationId];
        
        List<Parking_Lot_Assignment__c> plaList = new List<Parking_Lot_Assignment__c>(
                    [Select p.Vehicle_Type__c
                    , p.Vehicle_Type_Level__c
                    , p.Vehicle_Type_Assignment__c
                    , p.Parking_Lot_RegionId__c
                    
                    , p.Id From Parking_Lot_Assignment__c p
                    where parking_Lot_RegionId__c = :request.locationId.substring(0,15)]);
        
        
        List<Parking_Lot__c> plist = new List<Parking_Lot__c>([Select 
                                  p.Rates__c
                                , p.Payment_Type_Accepted__c
                                , p.Parking_Lot_Region__c
                                , p.Id 
                                From Parking_Lot__c p
                                where parking_lot_region__c = :request.locationId.substring(0,15)]);
        
       
        List<GP_JSON.vehicleType> vTypeList = new List<GP_JSON.vehicleType>();
        
        for (Parking_Lot_Assignment__c a:plaList){
            vTypeList.add(new GP_JSON.vehicleType(a.vehicle_type__c, a.vehicle_type_assignment__c, a.vehicle_type_level__c));
        }
        
        List<GP_JSON.paymentRate> rateList = new List<GP_JSON.PaymentRate>();
        List<GP_JSON.paymentMethodClass> methodList = new List<GP_JSON.paymentMethodClass>();
        
        Set<String> dupSet = new Set<String>();
        Set<String> dupSet2 = new Set<String>();
        
        for (Parking_Lot__c l:pList){
            
            if (l.rates__c != null){
                List<String> rateTypeList = l.rates__c.split(';');
           
                for (String s:rateTypeList){
                 if (!dupSet.contains(s)){
                        ratelist.add(new GP_JSON.paymentRate(s));
                        dupSet.add(s); 
                        }
                }
                
            }
            
            if (l.payment_type_accepted__c != null){
                List<String> paymentList = l.payment_type_accepted__c.split(';');
            
                 for (String s2:paymentList){
                if (!dupSet2.contains(s2)){
                    if (globalParkingLevel != null){
                        if (globalParkingLevel.contains('Contractor')){
                            //GLBPARKING-367: Adding Consumption/Monthly options for contractors
                            if (s2.contains('Invoice')  || s2.contains('No Charge') || s2.contains('Consumption') || s2.contains('Monthly')) {
                                methodList.add(new GP_JSON.paymentMethodClass(s2));
                                dupSet2.add(s2);
                                //break;
                            }
                        }
                        else{
                            if (!s2.contains('Invoice')){
                                //Added by Mayur for Parking Jira GLBPARKING-370- Starts
                                Date todaydate = date.today();
                                Date activeDate = Date.valueOf(Label.GP_NatlDate);
                                if(s2.contains('Natl'))
                                {
                                    if(todaydate > =activeDate)
                                        methodList.add(new GP_JSON.paymentMethodClass(s2));
                                }
                                else if(s2.contains('Salary Sacrifice'))
                                {
                                    if(todaydate < activeDate)
                                        methodList.add(new GP_JSON.paymentMethodClass(s2));
                                }
                                //Added by Mayur for Parking Jira GLBPARKING-370- Ends
                                else
                                {
                                    methodList.add(new GP_JSON.paymentMethodClass(s2));
                                }
                                dupSet2.add(s2);
                            }                           
                        }
                    }
                    else{
                        //Added by Mayur for Parking Jira GLBPARKING-370- Starts
                        Date todaydate = date.today();
                        Date activeDate = Date.valueOf(Label.GP_NatlDate);
                        if(s2.contains('Natl'))
                        {
                            if(todaydate > =activeDate)
                                methodList.add(new GP_JSON.paymentMethodClass(s2));
                        }
                        else if(s2.contains('Salary Sacrifice'))
                        {
                            if(todaydate < activeDate)
                                methodList.add(new GP_JSON.paymentMethodClass(s2));
                        }
                        //Added by Mayur for Parking Jira GLBPARKING-370- Ends
                        else
                        {
                            methodList.add(new GP_JSON.paymentMethodClass(s2));
                        }
                        dupSet2.add(s2);
                    }
                }
            }
            }
        }
        
        GP_JSON.locationSetting message= new GP_JSON.locationSetting(vTypeList, rateList, methodList, r.allow_states__c);
        
        return message;
        
    }
    
     /***************************************************************************************************************
    *
    *  GET REGISTERED VEHICLES - gets the vehicles of an employee
    *
    ****************************************************************************************************************/
   
    @RemoteAction
    public static GP_JSON.age getAge(String messageIn) {

        GP_JSON.inputmsid request;
        
        system.debug('message in:' + messageIN);
        
        request = (GP_JSON.inputmsid) System.JSON.deserialize(messageIn, GP_JSON.Inputmsid.class);
    
        Employee__c e = [select age__c from employee__c where emp_id__c = :request.msid];
        
        GP_JSON.age message = new GP_JSON.age(e.age__c);
        
        return message;
        
   
    }
    
    /***************************************************************************************************************
    *
    *  GET REGISTERED VEHICLES - gets the vehicles of an employee
    *
    ****************************************************************************************************************/
   
    @RemoteAction
    public static List<GP_JSON.vehicle> getRegisteredVehicles(String messageIn) {

        GP_JSON.requestIdWithMSID request;
        
        request = (GP_JSON.requestIdWithMSID) System.JSON.deserialize(messageIn, GP_JSON.requestIdWithMSID.class);
        
        List<GP_JSON.vehicle> message = new List<GP_JSON.vehicle>();
        
        List<Employee_Vehicle__c> vList = [ Select 
              e.Type__c
            , e.Status__c
            , e.Registration_Number__c
            , e.Make_Model__c
            , e.Id
            , e.High_Roof__c
            , e.Employee__c
            , e.Company_Car__c
            , e.Color__c 
            , e.state__c
            , e.blue_tag__c
           
            From Employee_Vehicle__c e
            where employee__r.emp_id__c = :request.msid
            and status__c = 'Active'];
        
        System.debug('************************** request msid:' + request.msid);
            
        Set<ID> vehicleIdSet = new Set<ID>();
        for (Employee_Vehicle__c v:vList)
            vehicleIdSet.add(v.id);
            
        List<Parking_Lot_Request_Vehicles__c> vehiclesOnRequests = new List<Parking_Lot_Request_Vehicles__c>();
        vehiclesOnRequests = [select employee_vehicle__c
                        , parking_lot_request__r.status__c
                        , parking_lot_request__c
                        from Parking_Lot_Request_Vehicles__c
                        where employee_vehicle__c in :vehicleIdSet
                        and employee_vehicle__r.status__c = 'Active'
            //and parking_lot_Request__r.status__c in ('New','Assigned')
                        and parking_lot_Request__r.type__c = 'Parking Space'];
        
        Map<String,Integer> assignedCountMap = new Map<String,Integer>();
        Integer assignedCount = 0;
        Id requestId;
        if(request.requestId != null) {
             requestId = Id.valueOf(request.requestId);
        }
        for (Parking_Lot_Request_Vehicles__c v:vehiclesOnRequests){
            if (v.parking_lot_request__r.status__c == 'New' || v.parking_lot_request__r.status__c == 'Assigned'){
                if (assignedCountMap.keySet().contains(v.employee_vehicle__c)){
                    assignedCount = assignedCountMap.get(v.employee_vehicle__c);
                    if(requestId == null || v.parking_lot_request__c != requestId) {
                        assignedCount++;
                    }
                }
                else if(requestId == null || v.parking_lot_request__c != requestId) {
                    assignedCount = 1;
                }
                else {
                    assignedCount = 0;
                }
                assignedCountMap.put(v.employee_vehicle__c,assignedCount);
            }
        }
             
        for (Employee_Vehicle__c v:vList){
    
            String ind = string.valueOf(v.company_car__c);
            String aCount;
          
            if (assignedCountMap.get(v.id) == null)
                aCount = '0';
            else
                aCount = string.valueOf(assignedCountMap.get(v.id));
            
            String hr = string.valueOf(v.high_roof__c);

            message.add( new GP_JSON.vehicle(string.valueOf(v.id)
                        ,v.type__c
                        ,v.make_model__c
                        ,v.color__c
                        , ind
                        , aCount
                        , v.registration_number__c
                        , v.state__c
                        , hr
                        , v.blue_tag__c)); 
        
        }
        
        return message;
        
    }
    
    /***************************************************************************************************************
    *
    *  GET CAR COLORS - returns list of valid car colors
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static List<GP_JSON.colorsAllowed> getCarColors (){
        
         
        List<GP_JSON.colorsAllowed> message = new List<GP_JSON.colorsAllowed>();
    
        List<String> colorList = System.Label.GP_Car_Colors.split(';');
        
        for (String s:colorList){
            GP_JSON.colorsAllowed c = new GP_JSON.colorsAllowed(s);
            message.add(c);
            
        }
    
        
        return message; 
        
    } 
    
    /***************************************************************************************************************
    *
    * GET HELP DOC URL - returns url of help doc
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.helpDocUrl getHelpDocUrl (){
        
         
        
        GP_JSON.helpDocUrl message = new GP_JSON.helpDocURL(System.Label.GP_HelpDoc);
        
        return message; 
        
    } 
   
     /***************************************************************************************************************
    *
    *  GET CANCEL REASONS - returns list of cancellation reasons
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static List<GP_JSON.cancelReason> getCancelReasons (String messageIn){
        
        GP_JSON.inputRequestId request; 
        
        request = (GP_JSON.inputRequestId) System.JSON.deserialize(messageIn, GP_JSON.inputRequestId.class);
        
        Parking_Lot_Request__c req = [Select parking_lot_Region__r.enrollment_period_start_date__c,
                        parking_lot_Region__r.enrollment_period_end_date__c, parking_lot_Region__r.Name,
                method_of_payment__c 
                from parking_lot_Request__c 
                where id = :request.requestId ];
         
        List<GP_JSON.cancelReason> message = new List<GP_JSON.cancelReason>();
        
        //duplicate prevention
        Set<String> reasonSet = new Set<String>();
        
        //GLBPARKING-403
        List<GP_Cancellation_Reasons__c> canReasonList = GP_Cancellation_Reasons__c.getAll().values();
        for(GP_Cancellation_Reasons__c reason : canReasonList) {
            if(!reasonSet.contains(reason.Cancellation_Reason__c)) {
                //If no parameter definition, add to list
                if(reason.Region__c == null && reason.Payment_Method__c == null) {
                    GP_JSON.cancelReason r = new GP_JSON.cancelReason(reason.Cancellation_Reason__c);
                    message.add(r);
                    reasonSet.add(reason.Cancellation_Reason__c);
                }
                else if(reason.Region__c == null && reason.Payment_Method__c == req.method_of_payment__c) {
                    GP_JSON.cancelReason r = new GP_JSON.cancelReason(reason.Cancellation_Reason__c);
                    message.add(r);
                    reasonSet.add(reason.Cancellation_Reason__c);
                }
                else if(reason.Region__c == req.parking_lot_Region__r.Name && reason.Payment_Method__c == null) {
                    GP_JSON.cancelReason r = new GP_JSON.cancelReason(reason.Cancellation_Reason__c);
                    message.add(r);
                    reasonSet.add(reason.Cancellation_Reason__c);
                }
                else if(reason.Region__c == req.parking_lot_Region__r.Name && reason.Payment_Method__c == req.method_of_payment__c) {
                    GP_JSON.cancelReason r = new GP_JSON.cancelReason(reason.Cancellation_Reason__c);
                    message.add(r);
                    reasonSet.add(reason.Cancellation_Reason__c);
                }
            }
        }

        //Added by Mayur for Parking Jira GLBPARKING-370- Ends
        if (req.parking_lot_Region__r.enrollment_period_start_date__c != null && req.parking_lot_Region__r.enrollment_period_end_date__c != null){
                if (Date.today() >= req.parking_lot_Region__r.enrollment_period_start_date__c && Date.today() <= req.parking_lot_Region__r.enrollment_period_end_date__c){
                        GP_JSON.cancelReason r = new GP_JSON.cancelReason('Annual Enrollment Cancellation');
                        message.add(r);
                }
        }       

        return message; 
        
    } 
   
    /***************************************************************************************************************
    *
    *  UPDATE PASS REQUEST - updates the payment method....
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.requestId updateParkingPassRequest (String jsonMsg){    
        
        GP_JSON.updatePassRequest request = (GP_JSON.updatePassRequest)System.JSON.deserialize(jsonMsg, GP_JSON.updatePassRequest.class);
        
        EmailTemplate templateId = [SELECT id FROM EmailTemplate WHERE developerName = 'GP_Email_1_Request_Submitted'];
         
        Parking_Lot_Request__c r = [select id, requestee__r.email__c from Parking_Lot_Request__c where id = :request.requestId];
        
        r.Enrollment_Period_Payment_Method__c = request.enrollmentPaymentMethod;
                r.parking_card_id__c = request.parkingCardId;
                if (request.highRoof == 'true') 
                        r.high_roof__c = true;
                else
                        r.high_roof__c = false;
                
        if (r.Enrollment_period_payment_method__c != null){
                Map<String,String> emailToAddressMap = new Map<String,String>();
                
                        emailToAddressMap.put(r.requestee__r.email__c,r.requestee__r.email__c);
                        Boolean ccDelegates = true;
                
                        Gp_SendEmail.sendGPEmail(string.valueOf(templateId.id), emailToAddressMap, r.id, ccDelegates); 
                
        }
                                
        update r;
        
        GP_JSON.requestId message = new GP_JSON.requestId(request.requestId);
        
        return message;  
    }   
    /***************************************************************************************************************
    *
    *  CREATE PARKING PASSS REQUEST - creates a new request
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.requestIdWithName createParkingPassRequest (String jsonMsg){
        
        GP_JSON.parkingPassRequest r = (GP_JSON.parkingPassRequest)System.JSON.deserialize(jsonMsg, GP_JSON.parkingPassRequest.class);
        
        Map<String,String> jsonMap = new Map<String,String>();
        Map<String,String> rTypeMap = new Map<String,String>();
        
        List<RecordType> rList = [select id, developername from RecordType where SobjectType = 'Parking_Lot_Request__c'];
        for (RecordType t:rList)
            rTypeMap.put(t.developername,t.id);
         
        List<Parking_Lot_Region__c> locList = new List<Parking_Lot_Region__c>();
        locList = [Select p.Name
                , p.Id
                , p.Allow_High_Roof_Indicator__c
                , p.Allow_Company_Car_Indicator__c
                , p.allow_expectant_mother__c
                , terms_and_conditions__c
                From Parking_Lot_Region__c p];
        
        
        Map<String,String> locationRecordTypeMap = new Map<String,String>();
        for (Parking_Lot_Region__c reg:locList){
            String recordTypeId;
            if (reg.name == 'Budapest')
                recordTypeId = rTypeMap.get('Budapest');
            else
            if (reg.name == 'Tokyo')
                recordTypeId = rTypeMap.get('Tokyo');   
            else
            if (reg.name == 'Glasgow')
                recordTypeId = rTypeMap.get('Glasgow');
            else
            if (reg.name == 'London')
                recordTypeId = rTypeMap.get('London');  
            else
            if (reg.name == 'Purchase')
                recordTypeId = rTypeMap.get('USA');
            else
                recordTypeId = rTypeMap.get('USA');
                
            locationRecordTypeMap.put(string.valueOf(reg.id),recordTypeId);
        }       
        
        Employee__c e = [select global_parking_level__c from Employee__c where emp_id__c = :r.requesteeEmployeeId];
        
            
        Parking_Lot_Request__c plr = new Parking_Lot_Request__c();
        plr.recordtypeId = locationRecordTypeMap.get(r.locationId);
        plr.vehicle_type__c = r.vehicleType;
        plr.type__c = r.requestType;
        plr.current_parking_pass_id__c = r.currentParkingPassId;
        if (r.companyCar == 'true')
                plr.company_car__c = true;
        else
                plr.company_car__c = false;
                 
        
        if (r.expectantMother == 'true')
            plr.expectant_mother__c = true;
        else
            plr.expectant_mother__c = false;
       
        if (r.startDate == null){
            Date myDate = system.today();
            r.startDate = myDate.year() + '-' + myDate.month() + '-' + myDate.day();
        }
       
            
        Date tempDate;
        
        system.debug('********************** Start date is: ' + r.startDate);
        tempDate = date.valueOf(r.startDate);
        plr.start_date__c = tempDate;
        if (r.enddate != '' && r.endDate != null)
            plr.end_date__c = date.valueof(r.enddate);
        plr.requestee__c = e.id;
        plr.Parking_Lot_Region__c = r.locationId;
        plr.method_of_payment__c = r.methodOfPayment;
        if (plr.method_of_payment__c == 'Daily')
                plr.rate_type__c = 'Daily';
        else{
                if (plr.method_of_payment__c.contains('Consumption'))
                        plr.rate_type__c = 'Hourly';
                else
                plr.rate_type__c = 'Monthly'; 
        }
        
        plr.no_charge__c = false;
         
        if (r.assignedSpaceRequired == 'true')
            plr.assigned_space_requested__c = true;
        else
            plr.assigned_space_requested__c = false;
                
        plr.Reason_for_Cancellation__c = r.reasonForCancellation;
        plr.Reason_for_delay__c = r.reasonForDelay;
        
        if (r.relatedRequestId != null)
            plr.related_parking_lot_Request__c = r.relatedRequestId;    
        
        
        if (r.highRoof == 'true')
                plr.high_roof__c = true;
        else
                plr.high_roof__c = false;
        
        
        List<Parking_Lot_Request_Vehicles__c> vList = new List<Parking_Lot_Request_Vehicles__c>();
                Set<String> vehicleIdSet = new Set<String>();
        if (r.selectedVehicles != null){ 
                for (GP_JSON.vehicleId v : r.selectedVehicles){
                        vehicleIdSet.add(v.vehicleId);
                        system.debug(vehicleIdSet);
                }
                List<Employee_Vehicle__c> eVList = new List<Employee_Vehicle__c>([select high_roof__c from Employee_Vehicle__c where id in :vehicleIdSet and high_roof__c = true]);
                if (!eVlist.isEmpty())
                        plr.high_roof__c = true;
                
        }     
        /* no vehicles no request */
        
        if (r.selectedVehicles != null){   
                system.debug('plr is: ' + plr); 
            insert plr;
            for (GP_JSON.vehicleId v : r.selectedVehicles){
                Parking_Lot_Request_Vehicles__c temp = new Parking_Lot_Request_Vehicles__c();
                temp.parking_lot_request__c = plr.id;
                system.debug('v is: ' + v);
                temp.employee_vehicle__c = string.valueOf(v.vehicleId);
                vList.add(temp);
                
            }
        
            if (!vlist.isEmpty())
                insert vList;
        
        }
        
        
        plr = [Select name from Parking_Lot_Request__c where id = :plr.id];
    
        GP_JSON.requestIdWithName message = new GP_JSON.requestIdWithName(plr.id, plr.name);
        
        return message;
        
        
    }
     
    /***************************************************************************************************************
    *
    *  REPLACE PASS VEHICLES - will remove all vehicles and add new ones
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.requestId replacePassVehicles(String messageIn) {
    
        
        GP_JSON.replacePassVehicles request = (GP_JSON.replacePassVehicles)System.JSON.deserialize(messageIn, GP_JSON.replacePassVehicles.class);
        
        List<Parking_Lot_Space_Assignment__c > aList = [select id from Parking_Lot_Space_Assignment__c where Parking_Lot_Request__c = :request.requestId];
        
        Parking_Lot_Space_Assignment__c a = null; 
        
        if (!aList.isEmpty())
                a = aList[0];
                
                
        List<Parking_Lot_Request_Vehicles__c> oldVList = [select id,Employee_vehicle__c
                from Parking_Lot_Request_Vehicles__c
                where parking_lot_request__c = :request.requestId
                ];
        
        List<Parking_Lot_Space_Assignment_Vehicle__c> oldAVList = new List<Parking_Lot_Space_Assignment_Vehicle__c>();
        
        if (a != null){
                oldAVList = [select id,Employee_vehicle__c
                from Parking_Lot_Space_Assignment_Vehicle__c
                where parking_lot_space_assignment__c = :a.id
                ];
        }
                
        List<Parking_Lot_Request_Vehicles__c> newVList = new List<Parking_Lot_Request_Vehicles__c>();
        if (request.selectedVehicles != null){
            
            system.debug('Selected vehicles:  ' + request.selectedVehicles);
            
            for (GP_JSON.vehicleId v : request.selectedVehicles){
                Parking_Lot_Request_Vehicles__c temp = new Parking_Lot_Request_Vehicles__c();
                temp.parking_lot_request__c = request.requestId;
                temp.employee_vehicle__c = v.vehicleId;
                newVList.add(temp);
            }
          
            if (!newVlist.isEmpty()){
                insert newVList;
            }
            
            List<Parking_Lot_Space_Assignment_Vehicle__c> newAVList = new List<Parking_Lot_Space_Assignment_Vehicle__c>();
            
            if (a != null){
                for (Parking_Lot_Request_Vehicles__c tv: newVList){
                        Parking_Lot_Space_Assignment_Vehicle__c t = new Parking_Lot_Space_Assignment_Vehicle__c();
                        t.employee_vehicle__c = tv.employee_vehicle__c;
                        t.parking_lot_space_assignment__c = a.id;
                        newAVList.add(t);       
                }
            }
            
            if (!newAVList.isEmpty())
                insert newAVList;
                       
        }
        
        /********Added by Abhijeet for Email to be sent when a vehicle is added to a pass*************/ 
            SET<ID> insertedvehicle = new SET<ID>();
            SET<ID> oldvehicles = new SET<ID>();
            SET<ID> newvehicles = new SET<ID>();
            
            if (!oldVList.isEmpty()){
                for(Parking_Lot_Request_Vehicles__c obj : oldVList){
                    oldvehicles.add(obj.Employee_vehicle__c);
                    
                }
            }
            
            System.debug('****************Old Vehicles***********'+oldvehicles);
            
                    
            if (!newVList.isEmpty()){
                for(Parking_Lot_Request_Vehicles__c obj : newVList){
                    insertedvehicle.add(obj.Employee_vehicle__c);
                    
                }
                
                System.debug('****************Vehicles After Insert***********'+insertedvehicle);
                
                for(ID id :insertedvehicle){
                    if(!oldvehicles.contains(id)){
                        newvehicles.add(id);
                    }
                }
                System.debug('****************Added vehicles **********'+newvehicles);
                
            }
        
        
        if (!oldVList.isEmpty())
            delete oldVList;
         
        if (!oldAVList.isEmpty())
            delete oldAVList;
            
            
        if(newvehicles.size()>0){
            System.debug('****************Added vehicles **********'+newvehicles); 
            Gp_EmailUtility.mailforvehicleaddition(newvehicles);
        }    
    /**************************************************************/    
        GP_JSON.requestId message = new GP_JSON.requestId(request.requestId);
        
        return message;
    
    }
   
    
    /***************************************************************************************************************
    *
    *  ADD VEHICLE - adds a vehicle to an employee
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.vehicleId addVehicle(String messageIn) {

        GP_JSON.vehicleId message;
        
        GP_JSON.newVehicle v = (GP_JSON.newVehicle)System.JSON.deserialize(messageIn, GP_JSON.newVehicle.class);
        
        Employee__c e = [select id from Employee__c where emp_id__c = :v.employeeId];
        
        Employee_Vehicle__c ev = new Employee_Vehicle__c(employee__c = e.id
                    ,make_model__c = v.makeModel
                    ,registration_number__c = v.registration
                    ,type__c=v.type 
                    ,color__c = v.color
                    ,status__c = 'Active'
                    ,state__c = v.state);
        
        if (v.highRoof != null)
                if (v.highRoof.toLowerCase() == 'yes')
                        v.highRoof = 'true';
                        
        if (v.highRoof == 'true'){
            ev.high_roof__c = true;
        }
        else{
            ev.high_roof__c = false;
        }   
        
        if (v.companyCar == 'true'){
            ev.company_car__c = true;    
        }
        else{
            ev.company_car__c = false;
        }
    
        insert ev;
        
        message = new GP_JSON.vehicleId(ev.id);
        
        return message;
        
    }
      /***************************************************************************************************************
    *
    *  REQUEST CANCELLATION
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.requestIdWithName requestCancellation(String messageIn) {
    
        GP_JSON.cancelRequest request;
        
        request = (GP_JSON.cancelRequest) System.JSON.deserialize(messageIn, GP_JSON.cancelRequest.class);
        
        Parking_Lot_Request__c old =   [Select 
              p.Vehicle_Type__c
            , p.Type__c
            , p.Status__c
            , p.Start_Date__c
            , p.Requestee__c
            , p.Requestee_Global_Parking_Level__c
            , p.Replacement_Issued_Date__c
            , p.Replacement_Card_Fee__c
            , p.Related_Parking_Lot_Request__c
            , p.RecordTypeId
            , p.Reason_for_Delay__c
            , p.Reason_for_Cancellation__c
            , p.Rate_Type__c
            , p.Parking_Lot__c
            , p.Parking_Lot_Region__r.name
            , p.OwnerId
            , p.Name
            , p.Method_of_Payment__c
            , p.Id
            , p.High_Roof__c
            , p.Handicap_Access_Required__c
            , p.CreatedDate
            , p.CreatedById
            , p.Cancellation_Reason__c
            , p.Assigned_Space_Requested__c
             From Parking_Lot_Request__c p
             where id = :request.requestId];
  
        // is there an existing cancellation request?
        
        List<Parking_Lot_Request__c> cList = [select 
                                                                                        id
                                                                                        ,name 
                                                                                        from Parking_Lot_Request__c
                                                                                        where related_parking_lot_Request__c = :request.requestId
                                                                                        and type__c = 'Cancellation'
                                                                                        and status__c = 'New'
                                                                                        ];
        Parking_Lot_Request__c r;
        
        //if existing cancellation request then update the date and reason
        if (!cList.isEmpty()){
                r = cList[0];
                r.start_date__c = date.valueOf(request.cancelDate);
                r.Reason_for_Cancellation__c = request.cancelReason;
                update r;
        }       
        else{                                                                   
                r = new Parking_Lot_Request__c(
             Parking_lot_region__c = old.parking_lot_region__c
            ,recordtypeid = old.recordtypeid
            ,Type__c = 'Cancellation'
            ,Status__c = 'New'
            ,start_date__c = date.valueOf(request.cancelDate)
            ,method_of_payment__c = old.method_of_payment__c
            ,requestee__c = old.requestee__c
            ,related_parking_lot_Request__c = old.id
            ,vehicle_type__c = old.vehicle_type__c
            );
        
                r.Reason_for_Cancellation__c = request.cancelReason;
        
        
       
                if (old.status__c == 'New'){
                old.Status__c = 'Cancelled';
                r.status__c = 'Complete';
                update old;
                }
        
                insert r;
        
                r = [Select name from Parking_Lot_Request__c where id = :r.id];
        }
            
        GP_JSON.requestIdWithName message = new GP_JSON.requestIdWithName(r.id, r.name);
        
        return message;  
      
    }
    /***************************************************************************************************************
    *
    *  REQUEST REPLACEMENT PASS
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.requestIdWithName requestReplacementPass(String messageIn) {
    
        GP_JSON.requestId request;
        
        request = (GP_JSON.requestId) System.JSON.deserialize(messageIn, GP_JSON.requestId.class);
        
        Parking_Lot_Request__c old =   [Select 
              p.Vehicle_Type__c
            , p.Type__c
            , p.Status__c
            , p.Start_Date__c
            , p.Requestee__c
            , p.Requestee_Global_Parking_Level__c
            , p.Replacement_Issued_Date__c
            , p.Replacement_Card_Fee__c
            , p.Related_Parking_Lot_Request__c
            , p.RecordTypeId
            , p.Reason_for_Delay__c
            , p.Reason_for_Cancellation__c
            , p.Rate_Type__c
            , p.Parking_Lot__c
            , p.Parking_Lot_Region__r.name
            , p.OwnerId
            , p.Name
            , p.Method_of_Payment__c
            , p.Id
            , p.High_Roof__c
            , p.no_charge__c
            , p.CreatedDate
            , p.CreatedById
            , p.Cancellation_Reason__c
            , p.Assigned_Space_Requested__c
             From Parking_Lot_Request__c p
             where id = :request.requestId];
    

        Date myDate = system.today();
        String startDate = myDate.year() + '-' + myDate.month() + '-' + myDate.day();
       
        Parking_Lot_Request__c r = new Parking_Lot_Request__c(
             Parking_lot_region__c = old.parking_lot_region__c
            ,recordtypeid = old.recordtypeid
            ,Type__c = 'Replacement Pass'
            ,Status__c = 'New'
            ,rate_type__c = 'Replacement Card Cost'
            ,start_date__c = date.valueOf(startDate)
            ,method_of_payment__c = old.method_of_payment__c
            ,requestee__c = old.requestee__c
            ,related_parking_lot_Request__c = old.id
            ,vehicle_type__c = old.vehicle_type__c
        );
        
        
        insert r;
    
        r = [Select name from Parking_Lot_Request__c where id = :r.id];
    
        GP_JSON.requestIdWithName message = new GP_JSON.requestIdWithName(r.id, r.name);
        
        return message;  
      
    }
    
    
    /***************************************************************************************************************
    *
    *  REQUEST OVERNNIGHT
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.requestIdWithName requestOvernightPass(String messageIn) {
    
        system.debug(logginglevel.warn, 'requestOvernightPass input string: ' + messageIn);
                
        GP_JSON.overnightRequest request = (GP_JSON.overnightRequest) System.JSON.deserialize(messageIn, GP_JSON.overnightRequest.class);
        
        Parking_Lot_Request__c old =   [Select 
              p.Vehicle_Type__c
            , p.Type__c
            , p.Status__c
            , p.Start_Date__c
            , p.Requestee__c
            , p.Requestee_Global_Parking_Level__c
            , p.Replacement_Issued_Date__c
            , p.Replacement_Card_Fee__c
            , p.Related_Parking_Lot_Request__c
            , p.RecordTypeId
            , p.Reason_for_Delay__c
            , p.Reason_for_Cancellation__c
            , p.Rate_Type__c
            , p.Parking_Lot__c
            , p.Parking_Lot_Region__r.name
            , p.OwnerId
            , p.Name
            , p.Method_of_Payment__c
            , p.Id
            , p.High_Roof__c
            , p.Handicap_Access_Required__c
            , p.CreatedDate
            , p.CreatedById
            , p.Cancellation_Reason__c
            , p.Assigned_Space_Requested__c
             From Parking_Lot_Request__c p
             where id = :request.requestId];
    

        Integer month = Integer.valueOf(request.startDate.substring(0,2));
        Integer day = Integer.valueOf(request.startDate.substring(3,5));
        Integer year = Integer.valueOf(request.startDate.substring(6,10));
       
        Parking_Lot_Request__c r = new Parking_Lot_Request__c(
             Parking_lot_region__c = old.parking_lot_region__c
            ,recordtypeid = old.recordtypeid
            ,Type__c = 'Overnight Parking'
            ,Status__c = 'New'
            ,start_date__c = Date.newInstance(year, month, day)
            ,method_of_payment__c = old.method_of_payment__c
            ,requestee__c = old.requestee__c
            ,related_parking_lot_Request__c = old.id
            ,vehicle_type__c = old.vehicle_type__c
        );
        
        
        insert r;
        
        r = [Select name from Parking_Lot_Request__c where id = :r.id];
    
        GP_JSON.requestIdWithName message = new GP_JSON.requestIdWithName(r.id, r.name);
        
        return message;  
      
    }
    
        
    /***************************************************************************************************************
    *
    *  REQUEST WEEKEND PASS
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.requestIdWithName requestWeekendPass(String messageIn) {
    
        GP_JSON.overnightRequest request;
        
        request = (GP_JSON.overnightRequest) System.JSON.deserialize(messageIn, GP_JSON.overnightRequest.class);
        
        Parking_Lot_Request__c old =   [Select 
              p.Vehicle_Type__c
            , p.Type__c
            , p.Status__c
            , p.Start_Date__c
            , p.Requestee__c
            , p.Requestee_Global_Parking_Level__c
            , p.Replacement_Issued_Date__c
            , p.Replacement_Card_Fee__c
            , p.Related_Parking_Lot_Request__c
            , p.RecordTypeId
            , p.Reason_for_Delay__c
            , p.Reason_for_Cancellation__c
            , p.Rate_Type__c
            , p.Parking_Lot__c
            , p.Parking_Lot_Region__r.name
            , p.OwnerId
            , p.Name
            , p.Method_of_Payment__c
            , p.Id
            , p.High_Roof__c
            , p.no_charge__c
            , p.CreatedDate
            , p.CreatedById
            , p.Cancellation_Reason__c
            , p.Assigned_Space_Requested__c
             From Parking_Lot_Request__c p
             where id = :request.requestId];

        Integer month = Integer.valueOf(request.startDate.substring(0,2));
        Integer day = Integer.valueOf(request.startDate.substring(3,5));
        Integer year = Integer.valueOf(request.startDate.substring(6,10));

        Parking_Lot_Request__c r = new Parking_Lot_Request__c(
             Parking_lot_region__c = old.parking_lot_region__c
            ,recordtypeid = old.recordtypeid
            ,Type__c = 'Weekend Parking'
            ,Status__c = 'New'
            ,start_date__c = Date.newInstance(year, month, day)
            ,method_of_payment__c = old.method_of_payment__c
            ,requestee__c = old.requestee__c
            ,related_parking_lot_Request__c = old.id
            ,vehicle_type__c = old.vehicle_type__c
        );
        
        
        insert r;
    
        r = [Select name from Parking_Lot_Request__c where id = :r.id];
    
        GP_JSON.requestIdWithName message = new GP_JSON.requestIdWithName(r.id, r.name);
        
        return message;  
      
    }
    /***************************************************************************************************************
    *
    *  GET PARKING PASSES - get all the passes and the related passes for an msid
    *
    ****************************************************************************************************************/
    
   
    /***************************************************************************************************************
    *
    *  CANCEL REPLACEMENT PASS
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static GP_JSON.requestId cancelReplacement(String messageIn) {
        
        GP_JSON.inputRequestId request; 
        
        request = (GP_JSON.inputRequestId) System.JSON.deserialize(messageIn, GP_JSON.inputRequestId.class);
        
        Parking_Lot_Request__c r = [select requestee__r.emp_id__c 
                    from Parking_Lot_Request__c 
                    where id = :request.requestId 
                    and type__c = 'Replacement Pass' 
                    and status__c = 'New'];
        
        r.status__c = 'Cancelled';
        
        update r;
        
        
        GP_JSON.requestId message = new GP_JSON.requestId(r.id);
    
        return message;    
   
    }
    /***************************************************************************************************************
    *
    *  CANCEL OVERNIGHT REQUEST
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static GP_JSON.requestId cancelOvernightPass(String messageIn) {
        
        GP_JSON.inputRequestId request; 
        
        request = (GP_JSON.inputRequestId) System.JSON.deserialize(messageIn, GP_JSON.inputRequestId.class);
        
        system.debug('*********************************** hello *****************************');
        Parking_Lot_Request__c r = [select requestee__r.emp_id__c 
                    from Parking_Lot_Request__c 
                    where id = :request.requestId 
                    and type__c = 'Overnight Parking' 
                    and status__c in ('New','Confirmed','Rejected')];
        
        r.status__c = 'Cancelled';
        
        update r;
        
        
        GP_JSON.requestId message = new GP_JSON.requestId(r.id);
    
        return message;    
   
    }
    /***************************************************************************************************************
    *
    *  CANCEL WEEK END REQUEST
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static GP_JSON.requestId cancelWeekendPass(String messageIn) {
        
        GP_JSON.inputRequestId request; 
        
        request = (GP_JSON.inputRequestId) System.JSON.deserialize(messageIn, GP_JSON.inputRequestId.class);
        
        Parking_Lot_Request__c r = [select requestee__r.emp_id__c 
                    from Parking_Lot_Request__c 
                    where id = :request.requestId 
                    and type__c = 'Weekend Parking' 
                    and status__c in  ('New','Confirmed','Rejected')];
        
        r.status__c = 'Cancelled';
        
        update r;
        
        
        GP_JSON.requestId message = new GP_JSON.requestId(r.id);
    
        return message;    
   
    }
    /***************************************************************************************************************
    *
    *  CANCEL CANCELLATION REQUEST
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static GP_JSON.requestId cancelCancellationRequest(String messageIn) {
        
        GP_JSON.inputRequestId request; 
        
        request = (GP_JSON.inputRequestId) System.JSON.deserialize(messageIn, GP_JSON.inputRequestId.class);
        
        Parking_Lot_Request__c r = [select requestee__r.emp_id__c 
                    from Parking_Lot_Request__c 
                    where id = :request.requestId 
                    and type__c = 'Cancellation' 
                    ];
        
        r.status__c = 'Cancelled';
        
        update r;
        
        
        GP_JSON.requestId message = new GP_JSON.requestId(r.id);
    
        return message;    
   
    }
    
    /***************************************************************************************************************
    *
    *  DELETE PASS VEHICLE - deletes a selected vehicle 
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static GP_JSON.vehicleId deletePassVehicle(String messageIn) {
    
          GP_JSON.requestVehicleId request = (GP_JSON.requestVehicleId) System.JSON.deserialize(messageIn, GP_JSON.requestVehicleId.class);
          
          Parking_Lot_Request_Vehicles__c v = [select id from Parking_Lot_Request_Vehicles__c where id = :request.vehicleId];
          
          delete v;
          
          GP_JSON.vehicleId message = new GP_JSON.vehicleID(v.id);
          
          return message;
    
    } 
    
    
    /***************************************************************************************************************
    *
    *  PASS Declaration Link
    *
    ****************************************************************************************************************/
    @remoteAction
    public static GP_JSON.docSignURL getDeclarationURL(String messageIn){

                GP_JSON.passes message;
        
        GP_JSON.inputRequestId request; 
        
        request = (GP_JSON.inputRequestId) System.JSON.deserialize(messageIn, GP_JSON.inputRequestId.class);
        
        system.debug('Request is: ' + request);
        
        Parking_Lot_Space_Assignment__c sa = [select Declaration_Envelope_Id__c
        , Declaration_Form_Signed_New_Pass__c from Parking_Lot_Space_Assignment__c 
                        where parking_lot_request__c = :request.requestId]; 
       
        String retUrl; 
        
        if (request.referrerUrl == null || request.referrerUrl == '')
                retUrl = System.Label.GP_Application;
        else
                retUrl =  request.referrerUrl;  
                String url;
                
                if (sa.declaration_envelope_id__c != null){
                DS_GetEnvelopeURL g = new DS_GetEnvelopeURL(sa.declaration_envelope_id__c,retUrl);
                url = g.getDocusignURLForSigning();
        }
        else  //default return url is in system label
                url = System.Label.GP_Application;
        
        GP_JSON.docSignURL returnURL = new GP_JSON.docSignURL(url,sa.Declaration_Form_Signed_New_Pass__c); 
        
                return returnURL;
                        
        }
    
    /***************************************************************************************************************
    *
    *  GET PASS - returns a single pass
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static GP_JSON.passes getPass(String messageIn) {
        
        GP_JSON.passes message;
        
        GP_JSON.inputRequestId request; 
        
        request = (GP_JSON.inputRequestId) System.JSON.deserialize(messageIn, GP_JSON.inputRequestId.class);
        
        Parking_Lot_Request__c r = [select requestee__r.emp_id__c from Parking_Lot_Request__c where id = :request.requestId];
        
        String lookingFor = request.requestId;
        
        Map<String,String> tempMap = new Map<String,String>();
        tempMap.put('msid',r.requestee__r.emp_id__c);
       
        
        List<GP_JSON.passes> tempList = getPasses(JSON.Serialize(tempMap));
         
        for (GP_JSON.passes p:tempList){
            GP_JSON.myPass m = p.parkingPass; 
        
            system.debug('**************** m is: '  + string.valueOf(m.id).substring(0,15) + 'looking for: ' + lookingFor.substring(0,15)); 
            system.debug('request is: ' + request.requestId);
            system.debug('p is: ' + p.parkingpass);
            if (string.valueOf(m.id).substring(0,15) == lookingFor.subString(0,15))
                message = p;
        }
        
        return message;
        
    }
    /***************************************************************************************************************
    *
    *  GET PASSSES - returns a list of passes
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    public static List<GP_JSON.passes> getPasses(String messageIn) {
        
        List<GP_JSON.passes> message = new List<GP_JSON.passes>();
        
        List<GP_JSON.MyPass> passes = new List<GP_JSON.MyPass>();
        List<GP_JSON.MyPass> relatedPasses = new List<GP_JSON.MyPass>();
        
        GP_JSON.inputmsid request = (GP_JSON.inputmsid)System.JSON.deserialize(messageIn, GP_JSON.inputmsid.class);
       
        Employee__c e = [select id from employee__c where emp_id__c = :request.msid];
        
        List<Parking_Lot_Request__c> rList = [Select 
              p.Vehicle_Type__c
            , p.Type__c
            , p.Status__c
            , p.Start_Date__c
            , p.actual_start_Date__c
            , p.end_date__c  
            , p.Requestee__c
            , p.Requestee_Global_Parking_Level__c
            , p.Replacement_Issued_Date__c
            , p.Replacement_Card_Fee__c 
            , p.Related_Parking_Lot_Request__c
            , p.RecordTypeId
            , p.Reason_for_Delay__c
            , p.Reason_for_Cancellation__c
            , p.Rate_Type__c
            , p.requestee__r.global_parking_sort_order__c
            , p.Parking_Lot__c
            , p.Parking_Lot_Region__r.name
            , p.parking_lot_region__c
            , p.OwnerId
            , p.Name
            , p.Method_of_Payment__c
            , p.Id
            , p.High_Roof__c
            , p.Handicap_Access_Required__c
            , p.CreatedDate
            , p.CreatedById
            , p.Cancellation_Reason__c
            , p.Assigned_Space_Requested__c
            , p.expectant_mother__c 
            , p.parking_lot__r.Space_Assignment__c
            , p.current_parking_pass_id__c
            , p.parking_lot__r.name
            , p.company_car__c
            , reject_reason_desc__C
            , Actual_Cancellation_Date__c
            , Enrollment_Period_Payment_Method__c
            , parking_card_id__c
             From Parking_Lot_Request__c p
             
             where related_parking_lot_request__c = null
             and requestee__c = :e.id
             and type__c = 'Parking Space'
             //only show requests that are new, assigned and cancelled that have been previously assigned
             and (
                (status__c in ('New','Assigned','Pending', 'Pending Cancellation')) 
                or
                (status__c in ('Cancelled') and parking_lot__c != null and LastModifiedDate = LAST_N_DAYS:90)
                or
                (status__c in ('Rejected') and lastModifiedDate = LAST_N_DAYS:3)
             )
            
             order by parking_lot_region__c, createddate
             ];
        
        Set<ID> requestIdSet = new Set<ID>();

        Map<String,Map<String,String>> vehicleRequestMap = new Map<String,Map<String,String>>();
             
        /* populate the order of requests for the region */
        
        if (!rList.isEmpty()){
            vehicleRequestMap = GP_ServiceHelper.getRequestOrder(rList[0].parking_lot_region__c,false);
            system.debug('Vehicle Request Map:  ' + vehicleRequestMap    );
        }   
        
        for (Parking_lot_request__c r:rList){
            requestIdSet.add(r.id);
        }            
  
        List<Parking_Lot_Request__c> relatedRList = new List<Parking_Lot_Request__c>();
        relatedRList = [Select 
              p.Vehicle_Type__c
            , p.Type__c
            , p.Status__c
            , p.Start_Date__c
            , p.end_date__c
            , p.actual_start_Date__c
            , p.Requestee__c
            , p.Requestee_Global_Parking_Level__c
            , p.Replacement_Issued_Date__c
            , p.Replacement_Card_Fee__c
            , p.Related_Parking_Lot_Request__c
            , p.RecordTypeId
            , p.Reason_for_Delay__c
            , p.Reason_for_Cancellation__c
            , p.Rate_Type__c
            , p.Parking_Lot__c
            , p.Parking_Lot_Region__r.name
            , p.OwnerId
            , p.Name 
            , p.Method_of_Payment__c
            , p.Id
            , p.High_Roof__c
            , p.Handicap_Access_Required__c
            , p.CreatedDate
            , p.CreatedById
            , p.Cancellation_Reason__c
            , p.Assigned_Space_Requested__c
            , p.expectant_mother__c
            , p.parking_lot__r.Space_Assignment__c
            , p.current_parking_pass_id__c
            , p.parking_lot__r.name
            , p.company_car__c 
            , reject_reason_desc__c
            , Actual_Cancellation_Date__c
            , Enrollment_Period_Payment_Method__c
            , parking_card_id__c 
             From Parking_Lot_Request__c p
             where related_parking_lot_request__c in :requestIdSet
             and (
             (status__c in ('New','Confirmed','Rejected')
             and (start_date__c = LAST_N_DAYS:5 or expectant_mother__c = true or start_date__c = NEXT_N_DAYS:90) )
             or 
             (status__c = 'Cancelled' 
             and createdDate = LAST_N_DAYS:3)
             )
             
             ]; 
  
        /* get a list of space assignments */       
        List<Parking_Lot_Space_Assignment__c> spaceList = new List<Parking_Lot_Space_Assignment__c>();
        spacelist = [Select p.Parking_Pass_ID__c, Parking_Lot_Space__c, p.Parking_Lot_Request__c, parking_lot_space__r.name
                    ,Declaration_Form_Generated_New_Pass__c, Declaration_Form_Signed_New_Pass__c 
                    From Parking_Lot_Space_Assignment__c p 
                    where parking_lot_Request__c in :requestIdSet]; 
        
        
        Map<String,String> aMap = new Map<String,String>();
        Map<String,String> a1Map = new Map<String,String>();
        Map<String,Parking_Lot_Space_Assignment__c> a2Map = new Map<String,Parking_Lot_Space_Assignment__c>();
        
        for (Parking_Lot_Space_Assignment__c a:spaceList){
            aMap.put(a.parking_lot_Request__c, a.parking_pass_id__c);
            a1Map.put(a.parking_lot_Request__c, a.Parking_Lot_Space__r.name);
            a2Map.put(a.parking_lot_Request__c,a);
        }
            
        
        Map<ID,List<GP_JSON.MyPass>> relatedMap = new Map<ID,List<GP_JSON.MyPass>>();
     
        for (Parking_lot_request__c r:relatedRList){
            
            GP_JSON.myPass t = new GP_JSON.MyPass(r,null,null,null,a1Map.get(r.id),a2Map.get(r.id));
            
            List<GP_JSON.MyPass> temp = new List<GP_JSON.MyPass>();
            if(relatedMap.keySet().contains(r.related_parking_lot_request__c)){
                temp = relatedMap.get(r.related_parking_lot_request__c);
                temp.add(t);
            }
            else{
                temp.add(t);
            }   
            relatedMap.put(r.related_parking_lot_request__c,temp);
        }
         
        /* get vehicles on request */
        List<Parking_Lot_Request_Vehicles__c> vList = new LIst<Parking_Lot_Request_Vehicles__c>();
        vLIst = [Select 
                  p.Vehicle_Type__c
                 , p.Parking_Lot_Request__c
                 , p.Id
                 , p.Employee_Vehicle__c
                 , p.Employee_Vehicle_Registration__c
                 , p.Employee_Vehicle_Make_Model__c
                 , p.Employee_Vehicle_Color__c
                 , p.Company_Car__c 
                 , p.employee_vehicle__r.high_roof__c
                From Parking_Lot_Request_Vehicles__c p
                where parking_lot_request__c  in :requestIdSet];
        
        Map<String,List<GP_JSON.passVehicle>> pv = new  Map<String,List<GP_JSON.passVehicle>>();
            
        for (Parking_Lot_Request_Vehicles__c rv:vlist){
            system.debug('should be adding vehicle: ' + rv);
            system.debug('type:' + rv.vehicle_type__c);
            List<GP_JSON.passvehicle> temp = new LIst<GP_JSON.passvehicle>();
            GP_JSON.passvehicle p = new GP_JSON.passvehicle(rv);
            system.debug('************* p is: '+ p);
            if (pv.keyset().contains(rv.parking_lot_Request__c)){
                temp = pv.get(rv.parking_lot_request__c);
            }   
            system.debug('request:' + rv.parking_lot_Request__c);
            temp.add(p);
            pv.put(rv.parking_lot_Request__c,temp);
        }
         
        String currentRegion = null;  
        /* go thru pass list and add related requests */
        for (Parking_lot_request__c r:rList){ 
            system.debug('looking for:' + r.id);
            system.debug('vehicle request map 2:' + vehicleRequestMap);  
            if (currentRegion <> r.parking_lot_region__c){
                vehicleRequestMap = GP_ServiceHelper.getRequestOrder(r.parking_lot_region__c,false);
                currentRegion = r.parking_lot_Region__c;
            }
            message.add(new GP_JSON.passes(new GP_JSON.MyPass(r,vehicleRequestMap,pv.get(r.id),aMap.get(r.id),a1Map.get(r.id),a2Map.get(r.id)),relatedMap.get(r.id)));
        } 
        
        return message; 
        
    }
    

    /***************************************************************************************************************
    *
    *  UPDATE VEHICLE DETAILS - updates information on an existing vehicle
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.vehicleId updateVehicleDetails(String jsonMsg) {

        
        GP_JSON.existingVehicle v = (GP_JSON.existingVehicle)System.JSON.deserialize(jsonMsg, GP_JSON.existingVehicle.class);
        
        Map<String,String> jsonMap = new Map<String,String>();
        
        Employee_Vehicle__c ev = [select 
                make_model__c
                ,registration_number__c
                ,type__c
                ,color__c
                ,status__c
                ,high_roof__c
                ,company_car__c
                ,state__c
                from Employee_Vehicle__c where id = :v.vehicleId
        ];
        
        if (v.state != null)
            ev.state__c = v.state;
            
        if (v.makeModel != null)
            ev.make_model__c = v.makeModel;
            
        if (v.registration != null)
            ev.Registration_Number__c = v.registration;
            
        if (v.type != null)
            ev.Type__c = v.type;
            
        if (v.color != null) 
            ev.color__c = v.color;
            
        if (v.status != null)
            ev.status__c = v.status;
         
        if (v.highRoofIndicator == 'true'){
            ev.high_roof__c = true;
        }
        else{
            if (v.highRoofIndicator != null)
                ev.high_roof__c = false;
        } 
          
        
        if (v.companyCar == 'true'){
            ev.company_car__c = true;    
        }
        else{
            if (v.companycar != null)
                ev.company_car__c = false;
        }
    
        update ev;
        
        GP_JSON.vehicleId message = new GP_JSON.vehicleId(ev.id);
        
        return message;
        
    }
        
      
    
}