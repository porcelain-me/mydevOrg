/***************************************************************************************************************
*
*  GP MONEY SERVICE  - this is used by the global parking front end for parking pass money related calls
*
*  Changelog:
*
*  10/14/15 - MRM Created
*
****************************************************************************************************************/
public without sharing class GP_MoneyService { 

    public GP_MoneyService (GP_ApplictionDataService controller) {}
    public GP_MoneyService () { } 
        public class forceException extends Exception {}    
        
        /***************************************************************************************************************
    *
    *  GET REPLACEMENT PRICE - gets the replacement card price for the location 
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.price getReplacementPassPrice(String messageIn) {
        
          
        GP_JSON.replacementPriceRequest request = (GP_JSON.replacementPriceRequest) System.JSON.deserialize(messageIn, GP_JSON.replacementPriceRequest.class);
         
        User  u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
        Employee__c e = [Select e.Work_Phone__c, e.Name, e.Global_Parking_Level__c From Employee__c e where emp_id__c = :u.emp_id__c];
                Parking_Lot_Region__c region = [select name, currencyISOCode from Parking_Lot_Region__c where id = :request.locationId];
                
                GP_JSON.price result = GP_ServiceHelper.lookupPrice(request.requestId,request.vehicleType, e.global_parking_level__c, request.locationId, 'Replacement Card Cost');
                        
                GP_JSON.price message = new GP_JSON.price('Replacement Card Cost',result.currencyCode,result.replacementAmount);
        
          
        return message;
        
    } 
    /***************************************************************************************************************
    *
    *  GET PRICE - returns the price for a month of parking for a request
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.price getPassPrice(String messageIn) {   
                
                GP_JSON.priceRequest request;
                
                request = (GP_JSON.priceRequest) System.JSON.deserialize(messageIn, GP_JSON.priceRequest.class);

                if (!request.rateType.contains('Replacement')){
                        if (request.rateType == 'Daily')
                                request.rateType = 'Daily';
                        else{
                                if (request.rateType.contains('Consumption')){
                                        request.rateType = 'Hourly';
                                }
                                else{
                                        request.rateType = 'Monthly';
                                }
                        }
                }
                
                User  u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
        Employee__c e = [Select e.Work_Phone__c, e.Name, e.Global_Parking_Level__c From Employee__c e where emp_id__c = :u.emp_id__c];
                Parking_Lot_Region__c region = [select name, currencyISOCode from Parking_Lot_Region__c where id = :request.locationId];
        
                system.debug('hello');
                List<Parking_Lot__c> lotList = [select id from Parking_Lot__c where parking_lot_Region__c  = :request.locationId];
                
                String searchingFor;
                String searchValues;
                Decimal rate; 
                
                GP_calculateParkingFees GPCalc = new GP_calculateParkingFees('1',region.name, date.today(), date.today());
                
                for (Parking_Lot__c p:lotList){   //try a lot a time 
                        Map<String,Decimal> levelRateMap = new Map<String,Decimal>();
                
                        
                        if (region.name == 'Budapest'){         
                                levelRateMap = GPCalc.parkingLotRateScheduleByGradeBudapest.get(p.id + '-' + request.rateType);
                                if (levelRateMap == null){
                                        continue;
                                }
                        }
                        else{           
                                levelRateMap = GPCalc.parkingLotRateScheduleByGrade.get(p.ID);
                                if (levelRateMap == null){
                                        continue;
                                }
                        }
                        
                        system.debug('Level Rate Map: ' + levelRateMap);
                        system.debug('Look up is by: Looking for: rateType vehicleType requesteeGlobalParkingLevel assigned companyOwned noCharge');
                        searchingFor = 'rateType vehicleType employeeParkingLevel assigned companyOwned noCharge';
                        if (levelRateMap != null){      
                                if (region.name == 'Budapest'){ 
                                        if (request.vehicleType == 'Bicycle' || request.vehicleType == 'Motorcycle')
                                                request.companyowned = 'false';
                                                
                                        String assigned = 'true';
                                        if (request.handicapAccessRequired == null)
                                                request.handicapAccessRequired = 'false';
                                        if (request.handicapAccessRequired == 'true'){
                                                request.companyOwned = 'false';
                                                assigned = 'false';
                                        }
                                        if (request.rateType == 'Hourly'){
                                                request.companyOwned = 'false';
                                                assigned = 'false';
                                                request.handicapAccessRequired = 'false';
                                        }
                                        if (request.rateType == 'Replacement Card Cost'){
                                                request.companyOwned = 'false';
                                                assigned = 'false';
                                                request.handicapAccessRequired = 'false';
                                        }
                                        if (request.vehicleType <> 'Car')
                                                assigned = 'false';
                                                
                                        searchValues  = request.rateType + '-' + request.vehicleType + '-' + request.requesteeGlobalParkingLevel + '-' + assigned  + '-' + request.companyOwned + '-' + request.handicapAccessRequired;
                                        
                                        system.debug('Looking for: ' + request.rateType + '-' + request.vehicleType + '-' + request.requesteeGlobalParkingLevel + '-' + assigned  + '-' + request.companyOwned + '-' + request.handicapAccessRequired);
                                        rate = levelRateMap.get(request.rateType + '-' + request.vehicleType + '-' + request.requesteeGlobalParkingLevel + '-' + assigned  + '-' + request.companyOwned + '-' + request.handicapAccessRequired);
                                        if (rate == null){  //check for unasssigned 
                                                rate = levelRateMap.get(request.rateType + '-' + request.vehicleType + '-' + 'All' + '-' + assigned  + '-' + request.companyOwned + '-' + request.handicapAccessRequired);      
                                                searchValues = request.rateType + '-' + request.vehicleType + '-' + 'All' + '-' + assigned  + '-' + request.companyOwned + '-' + request.handicapAccessRequired;
                                        }
                                }   
                        else{
                                if (request.handicapAccessRequired == null)
                                                request.handicapAccessRequired = 'false';
                                system.debug('Looking for: ' + request.rateType + '-' + request.vehicleType + '-' + request.requesteeGlobalParkingLevel + '-' + request.handicapAccessRequired );
                                searchValues =  request.rateType + '-' + request.vehicleType + '-' + request.requesteeGlobalParkingLevel + '-' + request.handicapAccessRequired;
                        
                                rate = levelRateMap.get(request.rateType + '-' + request.vehicleType + '-' + request.requesteeGlobalParkingLevel + '-' + request.handicapAccessRequired );
                                system.debug('rate is:' + rate);
                                if (rate == null){
                                        searchValues =  request.rateType + '-' + request.vehicleType + '-' + 'All' + '-' + request.handicapAccessRequired ;
                                                system.debug('now looking for all');
                                                rate = levelRateMap.get(request.rateType + '-' + request.vehicleType + '-' + 'All' + '-' + request.handicapAccessRequired );
                                        system.debug('rate is:' + rate);
                                }
                        }
                }
                        
                        if (rate != null)
                                break;
                        
                }               
                 
                GP_JSON.price message;
                 
                if (rate == null)
                        throw new forceException('Fatal Error:No Rate in Rate Tables!' + ' Searching for: ' + searchingFor + ' Search values: ' + searchValues);
                else{
                        if (request.requestId != null){
                                Parking_Lot_Request__c r = [select status__c, assigned_method_of_payment__c
                                from Parking_Lot_Request__c
                                where id = :request.requestId ];  
                                if (r.status__c == 'Assigned'){
                                        Parking_Lot_Space_Assignment__c a = [select Monthly_Fee_w_Discount__c 
                                        from Parking_Lot_Space_Assignment__c 
                                        where parking_lot_request__c = :request.requestId];
                                
                                        if (a.monthly_fee_w_discount__c != null)
                                                rate= a.monthly_fee_w_discount__c;
                                        
                                        if (r.assigned_method_of_payment__c != null)
                                                if (r.assigned_method_of_payment__c.toLowerCase().contains('no charge'))
                                                        rate = 0;
                                }
                        }
                        
                                
                        message = new GP_JSON.price(request.rateType,region.currencyISOCode,string.valueOf(rate));
                }
                
                system.debug('message is: ' + message);
                
                return message;
                 
         
    } 
    
    
    /***************************************************************************************************************
    *
    *  GET INVOICE DETAILS - get billing history for a particular invoice
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    
    public static List<GP_JSON.billingHistory> getInvoiceDetails(String messageIn) {   

                GP_JSON.invoiceId request; 
                
                request = (GP_JSON.invoiceId) System.JSON.deserialize(messageIn, GP_JSON.invoiceId.class);
                
                List<Parking_Lot_Assignment_Fees_Due__c> iList = [
                                                Select p.Status__c
                                                        , p.Rate_Type__c
                                                        , p.Parking_Space__c
                                                        , p.Parking_Space_Type__c
                                                        , p.Parking_Lot__c
                                                        , p.currencyISOCode
                                                        , p.Parking_Lot_Space_Assignment__c
                                                        , p.Parking_Invoice_Run__c
                                                        , p.Note__c
                                                        , p.Name
                                                        , p.Month_Invoiced__c
                                                        , p.Method_of_Payment__c
                                                        , p.Id
                                                        , p.Employee__c
                                                        , p.Employee_ID__c
                                                        , p.Date_Paid__c
                                                        , p.Conga_URL__c
                                                        , p.Conductor_Sent__c
                                                        , p.Balance_Due__c
                                                        , p.Amount_Paid__c
                                                        , p.Amount_Billed__c 
                                                        ,hourly_fee__c
                                                        ,monthly_fee__c
                                                        ,createddate
                                                        
                                                From Parking_Lot_Assignment_Fees_Due__c p 
                                                where id = :request.invoiceId.substring(0,15)
                                                order by name 
                                                ];
       
        Set<String> invoiceIDSet = new Set<string>();
        
        for (Parking_Lot_Assignment_Fees_Due__c a:iList){
                invoiceIDSet.add(a.id);
                system.debug('Add invoice name: ' + a.name + ' id: ' + a.id);
                
        }
        
        List<Parking_Lot_Space_Assignment_Time_Used__c> timeList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        timeList = [
                Select p.Resolved__c
                , p.Resolved_Comments__c
                , p.Resolution_Out__c
                    , p.Resolution_In__c
                , p.Resolution_Duration__c
                , p.Parking_Lot_Space_Assignment__c
                , p.Parking_Lot_RegionId__c
                , p.Out__c
                , p.Minutes__c
                , p.In__c
                , p.Id
                , p.Duration_Text__c
                , p.Duration_Numeric__c
                , p.Disputed__c
                , p.Dispute_Comments__c
                , p.Days__c
             
                , p.Billed__c 
                , p.invoice__c
                ,total_hourly_rate__c
                ,total_resolved_hourly_rate__c
                ,createddate
                ,defaulted_time__c
                From Parking_Lot_Space_Assignment_Time_Used__c p
                where invoice__c in :invoiceIDSet
                order by in__c desc
                ];
        
        
        Map<String,List<GP_JSON.timeDetail>> timeMap = new Map<String,List<GP_JSON.timeDetail>>();
        for (Parking_Lot_Space_Assignment_Time_Used__c t:timeList){
                List<GP_JSON.timeDetail> temp = new List<GP_JSON.timeDetail>();
                        GP_JSON.timeDetail d = new GP_JSON.timeDetail(t);
                        
                if (timeMap.keySet().contains(t.invoice__c)){
                        temp = timeMap.get(t.invoice__c);
                }
                temp.add(d);
                timeMap.put(t.invoice__c,temp);
        }
        
        
        List<GP_JSON.billingHistory> message = new List<GP_JSON.billingHistory>();
        
        for (Parking_Lot_Assignment_Fees_Due__c i : iList)
                message.add(new GP_JSON.billingHistory(i,timeMap.get(i.id),null));
        
        return message;
          
    }  
    
    /***************************************************************************************************************
    *
    *  GET BILLING HISTORY - returns all invoices and time
    *
    ****************************************************************************************************************/
    
    @RemoteAction
    
    public static List<GP_JSON.billingHistory> getBillingHistory(String messageIn) {   

                GP_JSON.inputMSID request;
                
                request = (GP_JSON.inputMSID) System.JSON.deserialize(messageIn, GP_JSON.InputMSID.class);
        
        if (request.msid == null){
                User u;
            u = [Select  u.Emp_Id__c From User u where id = :userInfo.getUserId()];
            request.msid = u.emp_id__c;
        }
        
                List<Parking_Lot_Assignment_Fees_Due__c> iList = [
                                                Select p.Status__c
                                                        , p.Rate_Type__c
                                                        , p.Parking_Space__c
                                                        , p.Parking_Space_Type__c
                                                        , p.Parking_Lot__c
                                                        , p.currencyISOCode
                                                        , p.Parking_Lot_Space_Assignment__c
                                                        , p.Parking_Invoice_Run__c
                                                        , p.Note__c
                                                        , p.Name
                                                        , p.Month_Invoiced__c
                                                        , p.Method_of_Payment__c
                                                        , p.Id
                                                        , p.Employee__c
                                                        , p.Employee_ID__c
                                                        , p.Date_Paid__c
                                                        , p.Conga_URL__c
                                                        , p.Conductor_Sent__c
                                                        , p.Balance_Due__c
                                                        , p.Amount_Paid__c
                                                        , p.Amount_Billed__c 
                                                        , hourly_fee__c
                                                        , monthly_fee__c
                                                        , createdDate
                                                        , employee__r.global_parking_level__c
                                                        , parking_invoice_run__r.Send_Email_To__c
                                                        , Parking_Lot_Space_Assignment__r.parking_lot_space__r.parking_lot__r.parking_lot_region__r.name
                                                From Parking_Lot_Assignment_Fees_Due__c p 
                                                where employee_id__c = :request.msid
                                                and status__c != 'Voided'
                                                order by createdDate desc
                                                ];
       
        Set<String> invoiceIDSet = new Set<string>();
        
        for (Parking_Lot_Assignment_Fees_Due__c a:iList){
                if (a.parking_invoice_run__r.send_email_to__c != null){
                        if (a.parking_invoice_run__r.send_email_to__c.contains(a.employee__r.global_parking_level__c))
                                invoiceIDSet.add(a.id);
                }
                
                
                system.debug('Add invoice name: ' + a.name + ' id: ' + a.id);
                
        }
        
        List<Attachment> aLIst = [Select a.ParentId, a.Id 
                                                        From Attachment a 
                                                        where parentId in :invoiceIDSet
                                                        order by createddate desc];
                                                        
        Map<String,String> invoicePDFMap = new Map<String,String>();
        
        for (Attachment a:aList){
                system.debug('putting: ' + a.parentId + ' aid:' + a.id);
                if (invoicePDFMap.get(a.parentId) == null){
                        invoicePDFMap.put(a.parentid,a.id);
                system.debug('hi');
                }
        }
        
        List<Parking_Lot_Space_Assignment_Time_Used__c> timeList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        timeList = [
                Select p.Resolved__c
                , p.Resolved_Comments__c
                , p.Resolution_Out__c
                    , p.Resolution_In__c
                , p.Resolution_Duration__c
                , p.Parking_Lot_Space_Assignment__c
                , p.Parking_Lot_RegionId__c
                , p.Out__c
                , p.Minutes__c
                , p.In__c
                , p.Id
                , p.Duration_Text__c
                , p.Duration_Numeric__c
                , p.Disputed__c
                , p.Dispute_Comments__c
                , p.Days__c
                , p.Billed__c 
                , p.invoice__c
                , createddate
                ,total_hourly_rate__c
                ,total_resolved_hourly_rate__c
                ,defaulted_time__c
                From Parking_Lot_Space_Assignment_Time_Used__c p
                where invoice__c in :invoiceIDSet
        
                ];
        
        
        Map<String,List<GP_JSON.timeDetail>> timeMap = new Map<String,List<GP_JSON.timeDetail>>();
        for (Parking_Lot_Space_Assignment_Time_Used__c t:timeList){
                List<GP_JSON.timeDetail> temp = new List<GP_JSON.timeDetail>();
                        GP_JSON.timeDetail d = new GP_JSON.timeDetail(t);
                
                        system.debug('looking for: ' + t.invoice__c);
                        
                if (timeMap.keySet().contains(t.invoice__c)){
                        temp = timeMap.get(t.invoice__c);
                }
                temp.add(d);
                timeMap.put(t.invoice__c,temp);
        }
        
        /* get time in/out */
        /*
       
        */
       
        List<GP_JSON.billingHistory> message = new List<GP_JSON.billingHistory>();
        
        for (Parking_Lot_Assignment_Fees_Due__c i : iList){
                
                /* no pdf's shown for budapest */
                if (i.Parking_Lot_Space_Assignment__r.parking_lot_space__r.parking_lot__r.parking_lot_region__r.name == 'Budapest')
                        invoicePDFMap = new Map<String,String>();
                        
                message.add(new GP_JSON.billingHistory(i,timeMap.get(i.id),invoicePDFMap)); 
        }
        
        return message;
        
    }
    
    /***************************************************************************************************************
    *
    *  DISPUTE TIME  
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static GP_JSON.timeDetailId disputeTime(String messageIn) {   
    
        GP_JSON.disputeTime request;
                
                request = (GP_JSON.disputeTime) System.JSON.deserialize(messageIn, GP_JSON.disputeTime.class);
        
        Parking_Lot_Space_Assignment_Time_Used__c t  = [
                Select p.Resolved__c
                , p.Resolved_Comments__c
                , p.Resolution_Out__c
                    , p.Resolution_In__c
                , p.Resolution_Duration__c
                , p.Parking_Lot_Space_Assignment__c
                , p.Parking_Lot_RegionId__c
                , p.Out__c
                , p.Minutes__c
                , p.In__c
                , p.Id
                , p.Duration_Text__c
                , p.Duration_Numeric__c
                , p.Disputed__c
                , p.Dispute_Comments__c
                , p.Days__c
                 
                , p.Billed__c 
                , p.invoice__r.id
                From Parking_Lot_Space_Assignment_Time_Used__c p
                where id = :request.timeDetailId
                ];
        
        
        t.disputed__c = true; 
        t.dispute_comments__c = request.comments;
        t.billed__c = false;
        t.resolved__c = false;
        
        update t;
        
        GP_JSON.timeDetailId message = new GP_JSON.timeDetailId(t.id);
        
        return message;
    }
    /***************************************************************************************************************
    *
    *  GET PASS TIME - returns all time for a pass
    *
    ****************************************************************************************************************/
    @RemoteAction
    public static List<GP_JSON.timeDetail> getPassTime(String messageIn) {   

                GP_JSON.requestId request;
                
                request = (GP_JSON.requestId) System.JSON.deserialize(messageIn, GP_JSON.requestId.class);
        
        List<Parking_Lot_Space_Assignment_Time_Used__c> timeList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        timeList = [
                Select p.Resolved__c
                , p.Resolved_Comments__c
                , p.Resolution_Out__c
                    , p.Resolution_In__c
                , p.Resolution_Duration__c
                , p.Parking_Lot_Space_Assignment__c
                , p.Parking_Lot_RegionId__c
                , p.Out__c
                , p.Minutes__c
                , p.In__c
                , p.Id
                , p.Duration_Text__c
                , p.Duration_Numeric__c
                , p.Disputed__c
                , p.Dispute_Comments__c
                , p.Days__c
                , p.Billed__c 
                , p.invoice__c
                , p.defaulted_time__c
                , p.total_hourly_rate__c
                , p.total_resolved_hourly_rate__c
                
                From Parking_Lot_Space_Assignment_Time_Used__c p
                where parking_lot_space_assignment__r.parking_lot_Request__c = :request.requestId.substring(0,15)
                order by in__c desc
                ];
        
        List<GP_JSON.timeDetail> message = new list<GP_JSON.timeDetail>();
            
        for (Parking_Lot_Space_Assignment_Time_Used__c t:timeList){
                        GP_JSON.timeDetail d = new GP_JSON.timeDetail(t);
                message.add(d);
        }
           
        return message;
        
    }
    /***************************************************************************************************************
    *
    *  GET PASS TIME - returns all time for a pass
    *
    ****************************************************************************************************************/
     
    public static void setInvoiceTotalTime(Map<String,String> batchMap) {
        
        /* get a list of all time used for all invoices in the batch */
        
        system.debug('batch map:' + batchMap);
                List<Parking_Lot_Space_Assignment_Time_Used__c> timeInOutList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
                timeInOutList = [select
                                                 invoice__c
                                                ,invoice__r.Parking_Invoice_Run__r.name
                                                ,resolved__c
                                                ,half_hours__c
                                                ,resolved_half_hours__c
                                                ,defaulted_time__c   
                                                from Parking_Lot_Space_Assignment_Time_Used__c
                                                where invoice__r.Parking_Invoice_Run__r.id in :batchMap.keySet()
                                                ];
                        
                system.debug('timeinout ' + timeInOutList);
                Map<String,Decimal> invoiceDurationMap = new map<String,Decimal>();
                
                for (Parking_Lot_Space_Assignment_Time_Used__c t:timeInOutLIst){
                        Decimal total = 0.0;
                        
                        //used resolved if necessary
                        Decimal tempHalfHours;
                                
                        if (t.resolved__c == true)
                                tempHalfHours = t.resolved_half_hours__c;
                        else    
                                tempHalfHours = t.half_hours__c;
                                
                        if (invoiceDurationMap.get(t.invoice__c) == null)
                                total = tempHalfHours;
                        else{
                                total = invoiceDurationMap.get(t.invoice__c);
                                total = total + tempHalfHours;
                        }       
                        invoiceDurationMap.put(t.invoice__c,total);
                }
                system.debug('invoiceDurationMap: ' + invoiceDurationMap);
                
                List<Parking_Lot_Assignment_Fees_Due__c> invoiceList = new List<Parking_Lot_Assignment_Fees_Due__c>();
                invoiceList = [select id
                                           from Parking_Lot_Assignment_Fees_Due__c
                                           where id in :invoiceDurationMap.keySet()
                                          ];
                                          
                for (Parking_Lot_Assignment_Fees_Due__c i:invoiceList){
                        //i.Time_In_Out_Total__c = invoiceDurationMap.get(i.id);
                        i.total_half_hours__c = invoiceDurationMap.get(i.id);
                        
                }
                
                if (!invoiceList.isEmpty())
                        update invoiceList;
                
                        
    }  
    
}