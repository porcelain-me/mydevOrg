/**************************************************************************************
* GLOBAL PARKING MONHLY BILLING BATCH PROCESS
* This batch process generates invoices for each active parking lot assignment record.
* The invoice type and payment vairies by lot/schedule....
*
* Change Log:
*
*   MRM 4/7/15 - Created class
*   JMC 1/31/17 - Fixed getFeeBudapest call - query in function call loop
*   2/13/17 - Updated by Jim Carter
*           REQ6826401: The last day of the month is being excluded from billing run
*           Fix Applied: Pass the first day of next month into billing function.  Update queries to qualify only 'less than' end date.
*
****************************************************************************************/
global class GP_MonthlyBilling implements Database.Batchable<SObject>, System.Schedulable{
    
    String regionID; 
    String requestID; 
    String runId;
    Boolean terminationRun = false;
    Boolean fullRun = false;
    Boolean disputeRun = false;
    Date monthlyBillingStartDate;
    Date monthlyBillingEndDate;
    Date consumptionBillingStartDate;
    Date consumptionBillingEndDate;
    Parking_Lot_Invoice_Run__c lastBatch;
    Set <String> prevTermRunAssignmentIds;
    
    String queryStr = 'Select rate_type__c, terminated__c, apply_flat_fee__c, parking_lot_request__r.name, discount__c, discount_days_per_month__c, parking_lot_request__r.Related_Parking_Lot_Request__c, Parking_Lot_Space__r.Parking_Lot__r.id, parking_lot_request__c, parking_lot_request__r.no_charge__c, parking_lot_space__r.Parking_Lot__r.parking_lot_region__r.name, p.Parking_Pass_ID__c, p.method_of_payment__c,  p.Parking_Lot__c, p.Parking_Lot_Space__c,  p.parking_lot_space__r.space_type__c, p.Name, p.Id, p.Employee__c, p.employee__r.Global_Parking_Level__c, p.Assignment_Start_Date__c, p.Assignment_End_Date__c, p.employee__r.Level_Dsc_Job__c From Parking_Lot_Space_Assignment__c p ';
    
    global GP_MonthlyBilling(String regionID, String requestID, String runType, Date monthlyBillingStartDate, Date monthlyBillingEndDate, Date consumptionBillingStartDate, Date consumptionBillingEndDate, Boolean terminationRun) { 
        this.regionID = regionID; 
        this.requestID = requestID;
        this.monthlyBillingStartDate = monthlyBillingStartDate; 
        this.monthlyBillingEndDate = monthlyBillingEndDate;
        this.consumptionBillingStartDate = consumptionBillingStartDate; 
        this.consumptionBillingEndDate = consumptionBillingEndDate;
        this.terminationRun = terminationRun;
        this.prevTermRunAssignmentIds = new Set<String>();
        
        if (runType == null || runType == 'Full' || terminationRun){
            this.fullRun = true;
            this.disputeRun = false;
        }
        else{
            this.fullRun = false;
            this.disputeRun = true;
        }
        
        Parking_Lot_Invoice_Run__c request = [select id from Parking_Lot_Invoice_Run__c where id = :requestID];
        request.start_date_time__c = system.now();
        request.status__c = 'Running';
        runId = requestID;
        
        
        
        if (terminationRun){
            
            lastBatch = [Select p.Parking_Lot_Region__c
                , consumption_Start_Date__c 
                , consumption_end_Date__c
                From Parking_Lot_Invoice_Run__c p
                where parking_lot_region__c = :regionID
                and  (status__c = 'Complete' or status__c = 'Step 2 - Email Process Complete')  
                and consumption_end_date__c = LAST_MONTH
                limit 1
                ]; 
                
            request.consumption_start_date__c = lastBatch.consumption_end_date__c.addDays(1);
            request.consumption_end_date__c = date.today();
            
            List<Parking_Lot_Assignment_Fees_Due__c> prevProcessList = new List<Parking_Lot_Assignment_Fees_Due__c>([select id 
                        , parking_lot_space_assignment__c
                        from Parking_Lot_Assignment_Fees_Due__c
                        where termination_fees__c = true
                        and status__c <> 'Voided'
                        ]); 
            for(Parking_Lot_Assignment_Fees_Due__c a:prevProcessList)   
                prevTermRunAssignmentIds.add(a.parking_lot_space_assignment__c);
        }
        
        update request;
        
        
    } 
    
    global Database.QueryLocator start(Database.BatchableContext c) { 
        
        queryStr += ' where Parking_Lot_Space__r.Parking_Lot__r.parking_lot_region__c = ' + '\'' + regionID + '\'' + 
        ' and terminated__c = ' +  terminationRun  + ' order by name';
        return Database.getQueryLocator(queryStr); 
   
    }
    
    
    /**************************************************************************************************
    *
    *
    * EXECUTE
    *
    *
    ****************************************************************************************************/
    
    global void execute(Database.BatchableContext c, List<Parking_Lot_Space_Assignment__c> aList){
        
        
        //don't process previously billed terminations
        if (terminationRun){
            
                List<Parking_Lot_Space_Assignment__c> temp = aLIst;
                aList = new List<Parking_Lot_Space_Assignment__c>();
                
                for (Parking_Lot_Space_Assignment__c a: temp){
                    if (prevTermRunAssignmentIds.contains(a.id))
                        continue;
                    else
                        aList.add(a);
                }
    
        }
        
        system.debug('in execute');
        
        Parking_Lot_Region__c  region = [select name, currencyISOCode from Parking_Lot_Region__c where name = :aList[0].parking_lot_space__r.Parking_Lot__r.parking_lot_region__r.name];
        String mode;
        if (terminationRun)
            mode = 'Termination';
        else
            if (fullRun)
                mode = 'Full';
            else
                mode = 'Dispute';
            
        System.debug('***************** RUN.1 is for:' + region.name + '-' + mode + ' Mode');
        Map<String,Parking_lot_Request__c> rMap = new Map<String,Parking_Lot_Request__c>();
        
        /* get all the requests related to this execute batch so that we can process replacement request invoices later */
        
        for (Parking_Lot_Space_Assignment__c a:aList)
            rMap.put(a.parking_lot_request__c,null);
        /*  
        List<Parking_Lot_Request__c> requestList = [Select p.rate_type__c
                            , p.Work_Phone__c
                            , p.Vehicle_Type__c
                            , p.Type__c, p.SystemModstamp, p.Status__c, p.Start_Date__c, p.Requestee__c, p.Requestee_Global_Parking_Level__c, p.RecordTypeId, p.Parking_Lot__c, p.Parking_Lot_Region__c, p.OwnerId, p.Name, p.Method_of_Payment__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof__c, p.Handicap_Access_Required__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById, p.Cancellation_Reason__c, p.Assigned_Space_Requested__c 
                            From Parking_Lot_Request__c p where id in :rMap.keySet()];
        */
        List<Parking_Lot_Request__c> requestList = [Select p.rate_type__c
                            , p.Work_Phone__c
                            , p.Vehicle_Type__c
                            , no_charge__c 
                            , p.Type__c, p.SystemModstamp, p.Status__c, p.Start_Date__c, p.Requestee__c, p.Requestee_Global_Parking_Level__c, p.RecordTypeId, p.Parking_Lot__c, p.Parking_Lot_Region__c, p.OwnerId, p.Name, p.Method_of_Payment__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Id, p.High_Roof__c, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById, p.Cancellation_Reason__c, p.Assigned_Space_Requested__c 
                            From Parking_Lot_Request__c p where id in :rMap.keySet()];

        for (Parking_Lot_request__c r:requestList){
            system.debug('no charge: ' + r.no_charge__c);
            system.debug('jimtest' + requestList);
            rmap.put(r.id,r);
        }
            
        List<Parking_Lot_Assignment_Fees_Due__c> iList = new List<Parking_Lot_Assignment_Fees_Due__c>();
        
        /* determine the start and end date of the invoice period */
        
                
        /* find any related parking lot replacment requests for the month */
        system.debug(logginglevel.info,'******************* rmap Keyset' + rmap.keySet());
        List<Parking_Lot_Request__c> replacementRequestList = [Select related_parking_lot_request__c
                            , Replacement_Card_Fee__c
                            , p.Vehicle_Type__c
                            , replacement_Issued_date__c
                            , no_charge__c
                            , currencyIsoCode
                            ,name
                            From Parking_Lot_Request__c p where related_parking_lot_request__c in :rMap.keySet() 
                            and replacement_issued_date__c >= :consumptionBillingStartDate and replacement_issued_date__c < :consumptionBillingEndDate.addDays(1)
                            and type__c = 'Replacement Pass'
                            and status__c = 'Assigned'];
        

        Map<String,List<Parking_Lot_Request__c>> replacementRequestMap = new Map<String,List<Parking_Lot_Request__c>>();
        for (Parking_Lot_Request__c p:replacementRequestList){
            system.debug('no charge: ' + p.no_charge__c);
            if (replacementRequestMap.containsKey(p.related_parking_lot_request__c)){
                List<Parking_Lot_Request__c> temp = replacementRequestMap.get(p.related_parking_lot_request__c);
                temp.add(p);
                replacementRequestMap.put(p.related_parking_lot_request__c,temp);
            }   
            else{
                replacementRequestMap.put(p.related_parking_lot_request__c,new List<Parking_Lot_Request__c>{p});
            }
        }
                        
        System.debug('************************************************************');
        System.debug('*********** Initializing parking fee data ******************');
        System.debug('************************************************************');
    
        //if termination run then get the rates as of today
        if (terminationRun){
            consumptionBillingStartDate = lastBatch.consumption_end_date__c.addDays(1);
            consumptionBillingEndDate = date.today();
        }   
        
        GP_calculateParkingFees GPCalcMonthly = new GP_calculateParkingFees(runId,region.name, monthlyBillingStartDate, monthlyBillingEndDate);
        GP_calculateParkingFees GPCalcConsumption = new GP_calculateParkingFees(runId,region.name, consumptionBillingStartDate, consumptionBillingEndDate);
        
        System.debug('');
        System.debug('');
        System.debug(''); 
    
        
        System.debug('************************************************************');
        System.debug('*********** Voiding out data for same period - rerun mode **');
        System.debug('************************************************************');
        
        /* void all invoices from last run so that this can be run many times without issues */
        Set<ID> assignmentSet = new Set<ID>();
        for (Parking_Lot_Space_Assignment__c d:aList){
            system.debug('space assignment id:' + d.id);
            assignmentSet.add(d.id);
        }   
        
        List<Parking_Lot_Assignment_Fees_Due__c> invoiceList = new List<Parking_Lot_Assignment_Fees_Due__c>();
           
        if (fullRun){
            if (terminationRun)
                Integer doNothing;   //no voiding for terminations
            else
                invoiceList = [select id 
                        , parking_lot_space_assignment__c
                        , parking_invoice_run__c
                        from Parking_Lot_Assignment_Fees_Due__c
                        where parking_lot_space_assignment__c in :assignmentSet
                        //and termination_fees__c = false
                        and ((month_invoiced__c = :consumptionBillingStartDate  and (rate_type__c = 'Hourly' or rate_type__c = 'Daily'))
                        or  (month_invoiced__c = :monthlyBillingStartDate and rate_type__c = 'Monthly'))
                        ];
        }
        else{
            if (disputeRun){
                invoiceList = [select id 
                        , parking_lot_space_assignment__c
                        , parking_invoice_run__c
                        from Parking_Lot_Assignment_Fees_Due__c
                        where parking_lot_space_assignment__c in :assignmentSet
                        and month_invoiced__c = :consumptionBillingStartDate
                        and status__c = 'Dispute Resolved'];
            }
        }
        
        Set<ID> voidedSet = new Set<ID>();
        Set<String> assignmentVoidedSet = new Set<String>();
        
        Set<ID> batchSet = new Set<ID>();
        
        for (Parking_Lot_Assignment_Fees_Due__c v:invoiceList){
            v.amount_billed__c = null;
            v.amount_paid__c = null;
            v.date_paid__c = null;
            v.status__c = 'Voided';
            voidedSet.add(v.id);
            batchSet.add(v.parking_invoice_run__c);
            assignmentVoidedSet.add(v.parking_lot_space_assignment__c);
        }
        
        if (invoiceList.size() != 0){
            List<Parking_Lot_Invoice_Run__c> rList = [select id, status__c from Parking_Lot_Invoice_Run__c where id = :batchSet and status__c <> 'Voided'];
            for (Parking_Lot_Invoice_Run__c r:rList )
                if (r.status__c.contains('Step') && disputeRun)
                    Integer doNothing;
                else
                    r.status__c = 'Voided';
            update rList;
        }
        
        system.debug('**** voided set: ' + voidedSet);
        system.debug('**** voided assign set: ' + assignmentVoidedSet);
        
        
        System.debug('************************************************************');
        System.debug('**** End of voiding out data for same period - rerun mode **');
        System.debug('************************************************************');
        System.debug('');
        System.debug('');
        System.debug('');
        System.debug('************************************************************');
        System.debug('*********** Beginning invoice process    *******************');
        System.debug('************************************************************');       
        
        
        /* get a list of invoices for the assignments that exist for the same period */
        List<Parking_Lot_Assignment_Fees_Due__c> invoiceListForThisPeriod = new List<Parking_Lot_Assignment_Fees_Due__c>();
        invoiceListForThisPeriod = [select id
            ,parking_lot_space_assignment__c
            from Parking_Lot_Assignment_Fees_Due__c
            where parking_lot_space_assignment__c in :assignmentSet
            and id not in :voidedSet
            and status__c != 'Voided'
            ];
        Set<String> assignmentsWithValidInvoices = new Set<String>();
        for (Parking_Lot_Assignment_Fees_Due__c i:invoiceListForThisPeriod){
            assignmentsWithValidInvoices.add(i.parking_lot_space_assignment__c);
            system.debug('valid invoice: ' + i);
        }   
        
        system.debug('assignements with valid invoices:' + assignmentswithvalidinvoices +  ' count: ' + assignmentswithvalidinvoices.size());
        
        //
        /* set up the detail time used in case consumption billing required */
        //
        
        Map<String,List<Parking_Lot_Space_Assignment_Time_Used__c>> assignmentTimeMap = new Map<String,List<Parking_Lot_Space_Assignment_Time_Used__c>>();
        
        List<Parking_Lot_Space_Assignment_Time_Used__c> tList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        //system.debug('assignment set is: ' + assignmentSet);
        system.debug(logginglevel.debug,'JIMTEST intime:' + consumptionBillingStartDate  + ' outtime:' +consumptionBillingEndDate);
        system.debug(logginglevel.debug,'JIMTEST2' + assignmentSet);
        if (fullRun){  //if full run get all that are not billed
            system.debug('Confirming Full Mode');
            if (terminationRun){
                consumptionBillingStartDate = lastBatch.consumption_end_date__c.addDays(1);
                consumptionBillingEndDate = date.today();
            }   
        
            tList = [Select Duration_Numeric__c, Duration_Text__c, Parking_Lot_Space_Assignment__c
                                                                ,days__c, hours__c, minutes__c, in__c, out__c, resolved_days__c,
                                                                resolved_hours__c, resolved_minutes__c, disputed__c, resolved__c
                                                                From Parking_Lot_Space_Assignment_Time_Used__c
                                                                where out__c >= :consumptionBillingStartDate and out__c < :consumptionBillingEndDate.addDays(1)
                                                                and Ignore_Billing__c = false
                                                                and parking_lot_space_assignment__c in :assignmentSet];
        }else{
            if (disputeRun){ //if dispute run get only those resolved 
                system.debug('Confirming Dispute Mode');
                tList = [Select Duration_Numeric__c, Duration_Text__c,Parking_Lot_Space_Assignment__c
                                                                ,days__c, hours__c, minutes__c, in__c, out__c, resolved_days__c,
                                                                resolved_hours__c, resolved_minutes__c, disputed__c, resolved__c,
                                                                Resolution_In__c, Resolution_Out__c, Dispute_Comments__c, Resolved_Comments__c
                                                                From Parking_Lot_Space_Assignment_Time_Used__c
                                                                where ((resolved__c = true and resolution_out__c >= :consumptionBillingStartDate and resolution_out__c < :consumptionBillingEndDate.addDays(1))
                                                                or disputed__c = false)
                                                                and Ignore_Billing__c = false
                                                                and parking_lot_space_assignment__c in :assignmentSet];
                                                                
                                                                
                for (parking_lot_space_assignment_time_used__c temp:tlist){
                    system.debug('space assignment id : ' + temp.parking_lot_space_assignment__c + ' id : ' + temp.id + ' in :' + temp.in__c + ' out :' + temp.out__c + 'resolved_hours: ' + temp.resolved_hours__c);
                }
            }
        }
         
         
         
        //system.debug('Consumption time found: ' + tlist);
        for (Parking_lot_Space_assignment_Time_used__c t:tList){
            List<Parking_Lot_Space_Assignment_Time_Used__c> tempList = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
            
            if (assignmentTimeMap.get(t.Parking_Lot_Space_Assignment__c) == null){
                tempList.add(t);
            }
            else{
                tempList = assignmentTimeMap.get(t.Parking_Lot_Space_Assignment__c);
                tempList.add(t);
            }
            
            assignmentTimeMap.put(t.Parking_Lot_Space_Assignment__c,tempList);
            
            t.billed__c = true;
        }
        
        system.debug('*** Assignment Time Map: ' + assignmentTimeMap);
        system.debug('*** Assignment Time Map KeySet: '+ assignmentTimeMap.keyset());
        
        /* end set up of time used */
        
        Integer i=0;
        
        /*
        system.debug('alist: ' + alist);
        for (Parking_Lot_Space_Assignment__c a:aList){
            system.debug(a);
        }
        */

        /* get the request vehicles to see if company car is being used - data passed into getFeeBudapest function call*/
        Set<ID> assignmentIds = new Set<ID>();
        for (Parking_Lot_Space_Assignment__c a:aList){
            assignmentIds.add(a.Id);
        }
        List<Parking_Lot_Space_Assignment_Vehicle__c> vList = [SELECT Employee_Vehicle__r.Company_Car__c, Parking_Lot_Space_Assignment__c 
                                                    FROM Parking_Lot_Space_Assignment_Vehicle__c    
                                                    WHERE Employee_Vehicle__r.Type__c = 'Car'
                                                    and Employee_Vehicle__r.Company_Car__c = true
                                                    and Parking_Lot_Space_Assignment__c IN :assignmentIds];
        MAP<Id,List<Parking_Lot_Space_Assignment_Vehicle__c>> vehicleMap = new Map<Id,List<Parking_Lot_Space_Assignment_Vehicle__c>>();
        for(Parking_Lot_Space_Assignment_Vehicle__c v:vList){
            if(vehicleMap.containsKey(v.Parking_Lot_Space_Assignment__c)) {
                List<Parking_Lot_Space_Assignment_Vehicle__c> vehList = vehicleMap.get(v.Parking_Lot_Space_Assignment__c);
                vehList.add(v);
                vehicleMap.put(v.Parking_Lot_Space_Assignment__c, vehList);
            }
            else {
                vehicleMap.put(v.Parking_Lot_Space_Assignment__c, new List<Parking_Lot_Space_Assignment_Vehicle__c>{v});
            }
        }

        Integer rCount = 0;
        List<Parking_Lot_Space_Assignment__c> assignmentUpdateList = new LIst<Parking_Lot_Space_Assignment__c>();
        for (Parking_Lot_Space_Assignment__c a:aList){
            
            system.debug('AssignmentId: ' + a.id);
            
            if (disputeRun && !assignmentVoidedSet.contains(a.id)   ){  
                system.debug('leaving for parking pass: ' + a.parking_pass_id__c);
                continue;  //don't process valid invoices on dispute run
            }           
            
            i++;
            
            system.debug('Assignment rate type: ' + a.rate_type__c);
            
            if ((a.rate_type__c == 'Hourly' || a.rate_type__c == 'Daily') && a.assignment_end_Date__c == null){
                a.assignment_end_date__c = consumptionBillingEnddate;
                system.debug('consumption start:' + consumptionBillingStartDate + ' end: ' + consumptionBillingENdDate + 'start: '+ a.assignment_start_Date__c + ' end: ' + a.assignment_end_date__c);  
            }
            
            system.debug('s/e:' + a.assignment_start_date__c + '/' + a.assignment_end_date__c);
            system.debug('c s/e:' + consumptionBillingStartDate + '/' + consumptionBillingEndDate);
            system.debug('m s/e:' + monthlyBillingStartDate + '/' + monthlyBillingEndDate);
            
            if 
            (
            
                (
                    (
                        (a.assignment_start_date__c < monthlyBillingEndDate.addDays(1) && (a.assignment_end_date__c == null || a.assignment_end_date__c >= monthlyBillingStartDate))
            
                        || 
                    
                        (a.assignment_start_date__c >= monthlyBillingStartDate &&  a.assignment_start_date__c < monthlyBillingEndDate.addDays(1))
                    )
            
                    && a.rate_type__c == 'Monthly'
                )
            ||
            ( (a.rate_type__c == 'Hourly' || a.rate_type__c == 'Daily') && 
              (
                (a.assignment_start_date__c < consumptionBillingStartDate && (a.assignment_end_date__c == null || a.assignment_end_date__c >= consumptionBillingStartDate))
                ||
                (a.assignment_start_date__c >= consumptionBillingStartDate && a.assignment_start_date__c < consumptionBillingEndDate.addDays(1))
              )
            )
            || (terminationRun && a.terminated__c == true)
            ){
                system.debug('Creating new invoice for ' + a.parking_pass_id__c);
                /**********************************************************
                * CREATE NEW INVOICE 
                ***********************************************************/
                Parking_Lot_Assignment_Fees_Due__c invoice = new Parking_Lot_Assignment_Fees_Due__c();
                
                if (terminationRun)
                    invoice.termination_fees__c = true;
                    
                invoice.invoice_type__c = 'Parking Fees';   
                invoice.parking_lot_space_assignment__c = a.id;
                invoice.employee__c = a.employee__c;
                
                if (a.rate_type__c == 'Monthly' )
                    invoice.month_invoiced__c = monthlyBillingStartDate;
                else
                    invoice.month_invoiced__c = consumptionBillingStartDate;
                
                if (disputeRun){
                    invoice.status__c = 'Revised Invoice';
                }
                /**********************************************************
                * FEE CALC 
                ***********************************************************/
                system.debug(' ... ***');
                GP_calculateParkingFees.returnFeeInfo result;
                system.debug('Request is: ' + a.parking_lot_Request__c );
                system.debug('Assignment id: ' + a.id);
                if (region.name == 'Budapest'){ 
                    system.debug('**************** Budapest Invoice Running *********************************');
                    system.debug('request is: ' + rMap.get(a.parking_lot_request__c));
                    
                    Boolean companyOwned = false;
                    if (vehicleMap.containsKey(a.id)) {
                        companyOwned = true;
                    }
                    
                    if (a.rate_type__c == 'Monthly') {
                        result = GPCalcMonthly.getFeeBudapest(a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id), companyOwned);
                    }
                    else {
                        result = GPCalcConsumption.getFeeBudapest(a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id), companyOwned);
                    }
                    
                    invoice.amount_billed__c = result.totalFee; 
                    invoice.hourly_fee__c = result.hourlyRate;
                    invoice.monthly_fee__c = result.monthlyRate;
                    
                    /* if flat fee add another invoice */
                    if (terminationRun && a.terminated__c && a.apply_flat_fee__c){
                        GP_calculateParkingFees.returnFeeInfo flatResult;
                        flatResult = GPCalcMonthly.getFeeBudapest(a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,'Flat Fee', a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id), companyOwned);
                        Parking_Lot_Assignment_Fees_Due__c invoiceFlat = new Parking_Lot_Assignment_Fees_Due__c();   
                        invoiceFlat.amount_billed__c = flatResult.totalFee;
                        invoiceFlat.amount_paid__c = invoiceFlat.amount_billed__c;
                        invoiceFlat.date_paid__c = date.today();
                        invoiceFlat.status__c = 'Paid';
                        invoiceFlat.termination_fees__c = true;
                        invoiceFlat.parking_invoice_run__c = runId;
                        invoiceFlat.currencyISOCode = region.currencyISOCode;
                        if (a.rate_type__c == 'Monthly' )
                            invoiceFlat.month_invoiced__c = monthlyBillingStartDate;
                        else
                            invoiceFlat.month_invoiced__c = consumptionBillingStartDate;
                        invoiceFlat.invoice_type__c = 'Flat Fees';  
                        invoiceFlat.parking_lot_space_assignment__c = a.id;
                        invoiceFlat.employee__c = a.employee__c;
                        iList.add(invoiceFlat);
                        
                    }
                }   
                else{ 
                    system.debug('**************** Non Budapest Invoice Running *********************************');
                    if (a.method_of_payment__c.contains('o charge') || a.method_of_payment__c.contains('o Charge') ) 
                        invoice.amount_billed__c = 0;
                    else{ 
                        //partial billing
                        Boolean partialBilling = false;
                        if (a.assignment_end_date__c != null  && region.name != 'Tokyo'){  //GLBPARKING-402: Tokyo billing should always bill for full month
                            if (monthlyBillingStartDate.month() == a.assignment_end_date__c.month() && monthlyBillingStartDate.year() == a.assignment_end_date__c.year() && a.rate_type__c == 'Monthly') {  //ending this billing month
                                partialBilling = true;
                            
                                Date startDate, endDate;
                                
                                if(a.assignment_end_date__c < monthlyBillingEndDate.addDays(1))
                                    endDate = a.assignment_end_date__c;
                                else
                                    endDate = monthlyBillingEndDate;
                            
                                if (a.assignment_start_date__c > monthlyBillingStartDate)
                                    startDate = a.assignment_start_date__c;
                                else
                                    startDate = monthlyBillingStartDate;
                            
                                Integer nbrOfDaysToBill = daysBetweenExcludingWeekends(startDate,endDate);
                            
                                Decimal proRatedPct;
                                system.debug('monthly start:' + monthlyBillingStartDate + '  end date:' + a.assignment_end_date__c);
                                system.debug('***Nbr of Days to Bill:' + nbrOfDaysToBill);
                                system.debug('***Pro Rated Pct:' + proRatedPct);
                                system.debug('**** hc: ' + a.parking_lot_request__r.no_charge__c);
                                if (a.rate_type__c == 'Daily'){
                                    result = GPCalcMonthly.getFee(a.parking_lot_request__r.no_charge__c, a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id));
                                    invoice.amount_billed__c = (result.dailyRate * nbrOfDaysToBill).setScale(2);
                                }
                                else{
                                    if (a.rate_type__c == 'Monthly')
                                        result = GPCalcMonthly.getFee(a.parking_lot_request__r.no_charge__c, a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id));
                                    else
                                        result = GPCalcConsumption.getFee(a.parking_lot_request__r.no_charge__c, a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id));
                                }
                                if (region.name == 'London' || region.name == 'Glasgow'){
                                    //non discounted rate
                                    system.debug('******************** discount logic .....' + a.discount__c + ' days: ' + a.discount_days_per_month__c);
                                    //apply discount if indicated
                                    if (a.rate_type__c == 'Monthly'){
                                        invoice.amount_billed__c = ((result.totalFee * 12)/261 * nbrOfDaysToBill).setScale(2);  
                                        if (a.discount__c != null && !a.discount__c.contains('None')){
                                            Integer weeksToBill = weeksBetweenDates(monthlyBillingStartDate, a.assignment_end_date__c);
                                             
                                            if (a.discount__c.contains('3')){
                                                invoice.amount_billed__c = ((result.totalFee * 12)/261 * (weeksToBill * 3)).setScale(2);    //3 days a week for 4 weeks 
                                            }
                                            else{
                                                if (a.discount__c.contains('4')){
                                                    invoice.amount_billed__c = ((result.totalFee * 12)/261 * (weeksToBill * 4)).setScale(2); //4 days a week for 4 weeks
                                                }
                                                else{
                                                    if (a.discount__c.contains('N days')){
                                                    invoice.amount_billed__c = ((result.totalFee * 12)/261 * a.discount_days_per_month__c).setScale(2); //N days per month
                                                }
                                                }
                                            }       
                                        }
                                    }
                                }
                                else{
                                    proRatedPct = (nbrOfDaysToBill/30.00);
                                    invoice.amount_billed__c = result.totalFee * proRatedPct; 
                                }
                        
                            
                                invoice.hourly_fee__c = result.hourlyRate;
                                invoice.monthly_fee__c = result.monthlyRate;
                                invoice.daily_fee__c = result.dailyRate;
                            }
                        } 
                        
                        if (!partialBilling){
                            //full month rate:
                            system.debug('***** looking up full month rate');
                            system.debug('**** hc: ' + a.parking_lot_request__r.no_charge__c);
                            if (a.rate_type__c == 'Daily'){
                                result = GPCalcMonthly.getFee(a.parking_lot_request__r.no_charge__c,a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id));
                                Date startDate,endDate;
                                if (a.assignment_start_Date__c > consumptionBillingStartDate)
                                    startDate = a.assignment_Start_date__c;
                                else
                                    startDate = consumptionBillingStartDate;
                                    
                                if (a.assignment_end_date__c != null){
                                    if (a.assignment_end_Date__c < consumptionBillingEndDate.addDays(1))
                                        endDate = a.assignment_end_Date__c;
                                    else
                                        endDate = consumptionBillingEndDate;
                                }
                                else{
                                    endDate = consumptionBillingEndDate;
                                }
                                        
                                Integer nbrOfDaysToBill = daysBetweenExcludingWeekends(startDate, endDate);
                                invoice.days_billed__c = nbrOfDaysToBill;
                                invoice.amount_billed__c = (result.dailyRate * nbrOfDaysToBill).setScale(2);
                            }else{  
                                if (a.rate_type__c == 'Monthly' )   
                                    result = GPCalcMonthly.getFee(a.parking_lot_request__r.no_charge__c,a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id));
                                else
                                    result = GPCalcConsumption.getFee(a.parking_lot_request__r.no_charge__c,a.Parking_Lot_Space__r.Parking_Lot__r.id,a.employee__r.Global_Parking_Level__c,a.rate_type__c, a.parking_lot_space__r.space_type__c,requestID,rMap.get(a.parking_lot_request__c),assignmentTimeMap.get(a.id));
                            }
                            if (a.rate_type__c == 'Monthly'){
                                if (a.discount__c != null && !a.discount__c.contains('None')){
                                    if (a.discount__c.contains('3')){
                                        invoice.amount_billed__c = ((result.totalFee * 12)/261 * 12).setScale(2);   //3 days a week for 4 weeks 
                                    }
                                    else{
                                        if (a.discount__c.contains('4')){
                                            invoice.amount_billed__c = ((result.totalFee * 12)/261 * 16).setScale(2); //4 days a week for 4 weeks
                                        }
                                        else{
                                            if (a.discount__c.contains('N days')){
                                                invoice.amount_billed__c = ((result.totalFee * 12)/261 * a.discount_days_per_month__c).setScale(2); //N days per month
                                            }
                                        }
                                    }       
                                }
                                else{
                                    invoice.amount_billed__c = result.totalFee;
                                }
                            }
                            else
                                if (a.rate_type__c != 'Daily')
                                    invoice.amount_billed__c = result.totalFee;
                            
                            invoice.hourly_fee__c = result.hourlyRate;
                            invoice.monthly_fee__c = result.monthlyRate;
                            invoice.daily_fee__c = result.dailyRate; 
                        }
                        
                    }
                } 
                
                /* if this is pay by invoice set status to invoiced */
                if (a.method_of_payment__c.contains('Invoice'))
                    invoice.status__c = 'Ready to Invoice';
                else 
                if (a.method_of_payment__c.contains('Payroll') || a.method_of_payment__c.contains('Monthly') || /*Added for GLBPARKING-370*/a.method_of_payment__c.contains('Natl') || a.method_of_payment__c.contains('Salary')|| a.method_of_payment__c.contains('no charge') || a.terminated__c){
                    invoice.amount_paid__c = invoice.amount_billed__c;
                    invoice.date_paid__c = date.today();
                    invoice.status__c = 'Paid';
                }
                
                
                invoice.parking_invoice_run__c = runId;
                invoice.currencyISOCode = region.currencyISOCode;
                
                system.debug('Invoice Amount: ' + invoice.amount_billed__c);
                
                if (invoice.amount_billed__c != 0)
                    iList.add(invoice);
                
                System.debug('');
                System.debug('');
                System.debug('');
                System.debug('************************************************************');
                System.debug('*********** End invoice process          *******************');
                System.debug('************************************************************');   
                /*check for any replacment passes */
                System.debug('');
                System.debug('');
                System.debug('');
                System.debug('************************************************************');
                System.debug('*********** Replacement Invoicing      *********************');
                System.debug('************************************************************');
                 
                if (replacementRequestMap.get(a.parking_lot_Request__c) != null){
                    List<Parking_Lot_Request__c> rPasses = replacementRequestMap.get(a.parking_lot_Request__c);
                    for(Parking_Lot_Request__c r:rPasses){
                        Parking_Lot_Assignment_Fees_Due__c rInvoice = invoice.clone();
                        rInvoice.amount_billed__c = r.Replacement_Card_Fee__c;
                        rInvoice.invoice_type__c = 'Replacement Card Fees';
                        //rInvoice.currencyIsoCode = r.currencyIsoCode;
                        rInvoice.currencyIsoCode = region.currencyIsoCode;
                        if (invoice.status__c == 'Paid')
                            rInvoice.amount_paid__c = rInvoice.amount_billed__c;
                        rInvoice.note__c = 'Parking Pass Replacement Charge';
                        iList.add(rInvoice);
                        rCount++;   
                    }
                }       
            }
        } 
        System.debug('');
        System.debug('');
        System.debug('');
        System.debug('********************** BATCH SUMMARY ***********************');
        
        System.debug('************************************************************');
        System.debug('*********** Assignments Found: ' + aList.size());
        System.debug('*********** Assignments Billed: '   + iList.size());
        System.debug('*********** Replacement Passes Billed: '   + rCount);
        System.debug('************************************************************');       
        
        if (invoiceList.size() > 0)
            update invoicelist; 
        
        if (iList.size() > 0)   
            insert iList;
        
        
        //go thru the invoices now that they have a invoice id assigned
        List<Parking_Lot_Space_Assignment_Time_Used__c> disputeClones = new List<Parking_Lot_Space_Assignment_Time_Used__c>();
        for (Parking_Lot_Assignment_Fees_Due__c invoice:iList){
            for (Parking_Lot_Space_Assignment_Time_Used__c tme:tList) {
                if (((tme.out__c.month() == invoice.month_invoiced__c.month() && invoice.note__c != 'Parking Pass Replacement Charge') || invoice.termination_fees__c)
                    && invoice.parking_lot_space_assignment__c == tme.parking_lot_space_assignment__c)  
                        if (disputeRun){ //GLBPARKING-377 : Copy the existing parking data for dispute reallocation to new invoice to ensure old invoice maintains records
                            Parking_Lot_Space_Assignment_Time_Used__c clone = tme.clone(false, true, true, true);
                            clone.invoice__c = invoice.id;
                            disputeClones.add(clone);
                            tme.Ignore_Billing__c = true; //Leaving old records attached to dispute for audit history.  Setting ignore billing to prevent usage in future billing processes.
                        }
                        else {
                            tme.invoice__c = invoice.id;
                        }
                        
            
            }
        }   

        if(!disputeClones.isEmpty()) {
            insert disputeClones;
        }
            
        if (tList.size() > 0)   
            update tList;
        
        
        
        
    }
    
    global static Integer daysBetweenExcludingWeekends(Datetime startDate, Datetime endDate) {
        Integer i = 0;
        system.debug('**** Start date: ' + startDate + '    EnDate: ' + endDate);
        
        while (startDate <= endDate) {
            if (startDate.format('E') != 'Sat' && startDate.format('E') != 'Sun') {
                i++;
            }
            startDate = startDate.addDays(1);
        }
        
        return i;
    }
    
    global static Integer weeksBetweenDates(Datetime startDate, Datetime endDate) {
        Integer weeks = 0;
        Boolean weekDayFound = false;  
        Boolean weekendFound = false;       
        while (startDate < endDate) {
            if (startDate.format('E')== 'Sun' || startDate.format('E')== 'Sat') {
                weekendFound = true;    
                weekdayfound = false;
                 
            }
            if (startDate.format('E') != 'Sun' && startDate.format('E') != 'Sat' ){ 
                weekDayFound=true;
            }
            //system.debug('Weekday: ' + weekdayfound +  ' - '  + startDate.format('E') + '   ' + ' Weekend: ' + weekendFound);
            
            if (weekendFound && weekdayfound){
                    weeks++;
                    weekendFound = false;   
                    weekdayfound = false;   
                    
             }
            
            startDate = startDate.addDays(1);
        }
        
        return weeks;
    }
    

    
    
    global void finish(Database.BatchableContext c){
        
        system.debug('in finish');
        Parking_Lot_Invoice_Run__c request = [select id,status__c from Parking_Lot_Invoice_Run__c where id = :requestID];
        if (request.status__c == 'Running') {
            request.end_date_time__c = system.now();
            if (disputeRun)
                request.status__c = 'Step 4 - Bill Replacement Complete';
            else
                if (terminationRun)
                    request.status__c = 'Termination Bill Generation Complete';
                else
                    request.status__c = 'Step 1 - Bill Generation Complete';
            
            update request;
        }
    }
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            id batchId = Database.executeBatch(new GP_MonthlyBilling('tese','x','y',date.today(),date.today(),date.today(),date.today(),null), 1000);
            system.debug('\n\n==> batchId = ' + batchId);
        }
    } 
}