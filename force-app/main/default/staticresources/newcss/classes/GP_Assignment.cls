/******************************************************************************************
* Global Parking Assignment Controller   
*
* Requests are by Region but the assignments are by parking lot within a region
*
* ChangeLog:
*
*   4/2/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/

public without sharing class GP_Assignment { 
    
    public Parking_Lot_Region__c reg {get;set;} 
    public List< Parking_Lot_Request__History> hList {get;set;}
    public Parking_Lot__c l {get;set;}  
    public Parking_Lot_Request__c r {get;set;}
    public Parking_Lot_Request__c relatedRequest {get;set;}
    public List<Parking_Lot_Request_Vehicles__c> vList {get;set;}
    public List<Parking_Lot_Space__c> sList {get;set;}
    public List<Parking_Lot_Space_Assignment__c> caList {get;set;}
    public Parking_Lot_Space_Assignment__c sa {get;set;}
    public Parking_Lot_Space_Assignment__c currentAssignment {get;set;}
    public Parking_Lot_Space_Assignment__c newAssignment {get;set;}
    public List<wrapResults> gridList {get;set;}
    public String selectedSpace {get;set;}
    public String statusMessage {get;set;}
    public String selectedParkingLot {get;set;}
    public String selectedMethodOfPayment {get;set;}
    public String selectedRateType {get;set;}
    public List<selectOption> parkingLots{get;set;}
    public List<selectOption> parkingLotPaymentMethods{get;set;}
    public List<selectOption> parkingLotRateTypes{get;set;}
    public Boolean renderPaymentMethod{get;set;} 
    public Boolean renderSpaces {get;set;}
    public boolean required {get;set;}
    public boolean showAutoAssign {get;set;}
    public boolean renderNext {get;set;}
    public boolean renderBack {get;set;}
    public Integer requestsInQueue {get;set;}
    String rid;
    List<Parking_Lot_Request__c> rList = new List<Parking_Lot_Request__c>();
    public Integer requestNbr {get;set;} 
    public integer totalRequests {get;set;}     
    String status;
    String id;
    
    /****************************
    *CUSTOM CONTROLLER
    *
    ****************************/
    public GP_Assignment() {
        
         renderNext = false;
         renderBack = false;
         
         statusMessage = '';
         
         requestNbr = 0;
         totalRequests = 0;
        
         List<Parking_Lot_Space_Assignment__c> temp = [select id, rate_type__c, method_of_payment__c, assignment_start_date__c from Parking_Lot_Space_Assignment__c];
         system.debug('sa' + temp);
         
         rid = system.currentPageReference().getParameters().get('rid');
         id = system.currentPageReference().getParameters().get('id');
         status = system.currentPageReference().getParameters().get('status');
         
         if (status == '1')
            statusMessage = 'Save successfull. Next request is now displayed!';
          
            
         reg = [select name, Send_Declaration__c,billing_period__c from Parking_lot_region__c where id = :rid];
         
        
        
         system.debug('created sa');
         
         showAutoAssign = false;
         
         if (id == null){
            /* get all in the correct order for processing */
            if (reg.name != 'Glasgow'){
                rList = [select id
                        ,name
                        ,type__c
                        ,start_date__c
                        ,method_of_payment__c
                        ,work_phone__c
                        ,no_charge__c
                        ,vehicle_type__c
                        ,parking_lot__c 
                        ,status__c
                        ,Requestee__r.Global_Parking_Level__c
                        ,Requestee__r.Email__c
                        ,Requestee__r.Super_Depart_Dsc_Org__c
                        ,Requestee__r.Phone_Number_Home__c
                        ,Requestee__r.Phone_Area_Code_Home__c
                        ,Requestee__r.Gender_Dsc__c
                        ,Requestee__r.Emp_ID__c
                        ,Requestee__r.Division_Dsc_Org__c
                        ,Requestee__r.Dept_Dsc_Org__c
                        ,Requestee__r.Building_Address_2_Directory__c
                        ,Requestee__r.Building_Address_1_Directory__c   
                        ,Requestee__r.Building_City_Directory__c    
                        ,Requestee__r.Name
                        ,Requestee__c 
                        ,company_car__c
                        ,reason_for_cancellation__c
                        ,high_roof__c
                        ,rate_type__c
                        ,reject_reason_Desc__c
                        ,assigned_space_requested__c
                        ,parking_lot_region__r.name
                        ,parking_lot_region__c
                        ,parking_lot_region__r.send_declaration__c
                        ,requestee_global_parking_level__c
                        ,related_parking_lot_Request__c
                        ,createdDate
                        ,replacement_card_fee__c
                        ,expectant_mother__c
                        ,end_date__c
                        ,current_parking_pass_id__c
                        ,reason_for_delay__c
                        ,LastModifiedDate
                        ,actual_cancellation_date__c
                        ,Request_Approved_by__c
                        ,Request_Approved_On__c
                        ,Expectant_Mother_Email__c    //Added for Jira GLBPARKING-353 by Mayur 3rd April
                        from Parking_Lot_Request__c
                        where parking_lot_region__c = :rid
                        and status__c in ('New','Waitlist')
                        order by requestee__r.global_parking_sort_order__c, createddate
                        limit 50];
            }
            else{
                rList = [select id
                        ,name
                        ,type__c
                        ,start_date__c
                        ,method_of_payment__c
                        ,work_phone__c
                        ,no_charge__c
                        ,vehicle_type__c
                        ,parking_lot__c 
                        ,status__c
                        ,company_car__c
                        ,Requestee__r.Global_Parking_Level__c
                        ,Requestee__r.Email__c
                        ,Requestee__r.Super_Depart_Dsc_Org__c
                        ,Requestee__r.Phone_Number_Home__c
                        ,Requestee__r.Phone_Area_Code_Home__c
                        ,Requestee__r.Gender_Dsc__c
                        ,Requestee__r.Emp_ID__c
                        ,Requestee__r.Division_Dsc_Org__c
                        ,Requestee__r.Dept_Dsc_Org__c
                        ,Requestee__r.Building_Address_2_Directory__c
                        ,Requestee__r.Building_Address_1_Directory__c
                        ,Requestee__r.Building_City_Directory__c        
                        ,reject_reason_Desc__c
                        ,Requestee__r.Name
                        ,Requestee__c 
                        ,reason_for_cancellation__c
                        ,high_roof__c
                        ,rate_type__c
                        ,assigned_space_requested__c
                        ,parking_lot_region__r.name
                        ,parking_lot_region__c
                        ,requestee_global_parking_level__c
                        ,parking_lot_region__r.send_declaration__c
                        ,related_parking_lot_Request__c
                        ,createdDate
                        ,replacement_card_fee__c
                        ,expectant_mother__c
                        ,end_date__c
                        ,actual_cancellation_date__c
                        ,current_parking_pass_id__c
                        ,reason_for_delay__c
                        ,LastModifiedDate
                        ,Request_Approved_by__c
                        ,Request_Approved_On__c
                        ,Expectant_Mother_Email__c   //Added for Jira GLBPARKING-353 by Mayur 3rd April
                        from Parking_Lot_Request__c
                        where parking_lot_region__c = :rid
                        and status__c in ('New','Waitlist')
                        order by createddate
                        limit 50];
            }
            requestsInQueue = rList.size();
            system.debug('requests in queue: ' + requestsInQueue);
            
            if (requestsInQueue == 0)
                statusMessage = 'No requests in queue!';
                
            if (requestsInQueue == 1)
                statusMessage = 'Last request in queue!';       
            
            /* set the first one to display */
            if (rlist.size() > 0){
                if (rList.size() > 1)
                    renderNext = true;
                    
                r = rlist[requestNbr];
                totalRequests = rList.size();
                
            }
         }
         else{
            /* now show the one selected to edit/view */     
            List<Parking_Lot_Request__c> rNewList =  [select id
                        ,name
                        ,type__c
                        ,start_date__c
                        ,method_of_payment__c
                        ,work_phone__c
                        ,parking_lot_region__r.name
                        ,no_charge__c
                        ,vehicle_type__c
                        ,parking_lot__c
                        ,status__c
                        ,reason_for_cancellation__c
                        ,Requestee__r.Global_Parking_Level__c
                        ,Requestee__r.Email__c
                        ,Requestee__r.Super_Depart_Dsc_Org__c
                        ,Requestee__r.Phone_Number_Home__c
                        ,Requestee__r.Phone_Area_Code_Home__c
                        ,Requestee__r.Gender_Dsc__c
                        ,Requestee__r.Emp_ID__c
                        ,Requestee__r.Division_Dsc_Org__c
                        ,Requestee__r.Dept_Dsc_Org__c
                        ,Requestee__r.Building_Address_2_Directory__c
                        ,reject_reason_Desc__c
                        ,Requestee__r.Building_Address_1_Directory__c       
                        ,Requestee__r.Building_City_Directory__c
                        ,Requestee__r.Name
                        ,high_roof__c
                        ,company_car__c
                        ,rate_type__c
                        ,parking_lot_region__r.send_declaration__c
                        ,assigned_space_requested__c
                        ,parking_lot_region__c
                        ,requestee_global_parking_level__c
                        ,related_parking_lot_Request__c
                        ,createdDate
                        ,replacement_card_fee__c
                        ,expectant_mother__c
                        ,end_date__c
                        ,actual_cancellation_date__c
                        ,current_parking_pass_id__c
                        ,reason_for_delay__c
                        ,LastModifiedDate
                        ,Request_Approved_by__c
                        ,Request_Approved_On__c
                        ,Expectant_Mother_Email__c    //Added for Jira GLBPARKING-353 by Mayur 3rd April
                        from Parking_Lot_Request__c
                        where id = :id];    
            for(Parking_Lot_Request__c r: rNewList)
                rList.add(r);           
            
            hlist = [Select ID
                            ,createddate
                            ,parentid
                            ,CreatedById
                            ,CreatedBy.Name
                            ,Field
                            , OldValue
                            , NewValue 
                            from  Parking_Lot_Request__History 
                            where parentid=:id ORDER BY CreatedDate DESC];
                            
            if (!rList.isEmpty()){
                r = rList[0];
            
                reg = [select id
                        , name
                        , billing_period__c
                        , allow_consumption_parking__c
                        , Send_Declaration__c
                    from Parking_Lot_Region__c where id = :r.Parking_Lot_Region__c];
            
            }
            
            
            requestsInQueue = 1;
            statusMessage = '';
                
         }
         
         //get related   
         if (r != null)
             getRelated();
        
         renderPaymentMethod=false;
         renderSpaces=false;
         
         if (reg != null && r != null)
            if (reg.name <> r.requestee__r.Building_City_Directory__c)
                statusMessage = statusMessage + ' Requestor\'s Primary Office location does not match parking request location!';
          
            
    }
    /******************************************************************************************
    * AssignSpace 
    *
    *******************************************************************************************/
    
    public void assignSpace() {
        
        sa.parking_lot_space__c = selectedSpace;
        
        
        
        
    }
    
    /******************************************************************************************
    * GET RELATED INFO  
    *
    *******************************************************************************************/
    public void getRelated(){
        
         newAssignment = new Parking_Lot_Space_Assignment__c();
         vList = new List<Parking_Lot_Request_Vehicles__c>();
         sList = new List<Parking_Lot_Space__c>();
         sa = new Parking_Lot_Space_Assignment__c();
         
         
        sa.method_of_payment__c = r.method_of_payment__c;
        //sa.assignment_start_date__c = r.start_date__c;
        
        if (r.start_date__c < date.today())
            sa.assignment_start_date__c = null;
       
        if (r.current_parking_pass_ID__c != null)
            sa.parking_pass_id__c = r.current_parking_pass_id__c;
            
        if (r.related_parking_lot_request__c != null)
            getRequestVehicles(r.related_parking_lot_request__c);
         else
            getRequestVehicles(r.id);
         
        populateParkingLots();
            
            
        if (r.type__c.contains('Weekend') || r.type__c.contains('Overnight') || r.type__c.contains('Cancel')){
                relatedRequest = [select id, parking_lot__c, name from Parking_Lot_Request__c where id = :r.related_parking_lot_request__c];
                if (relatedRequest.parking_lot__c != null) {
                    List<Parking_Lot_Space_Assignment__c> relatedAssignmentList = [select name, rate_type__c, method_of_payment__c, assignment_start_date__c, parking_Lot_space__r.name, assignment_end_Date__c, Parking_Pass_ID__c, parking_lot__c from Parking_Lot_Space_Assignment__c where parking_lot_request__c = :r.related_parking_lot_Request__c];
                    if(!relatedAssignmentList.isEmpty()) {
                        currentAssignment = relatedAssignmentList[0];
                    }
                }
        }
         
        if (r.type__c == 'Cancellation'){
            r.actual_cancellation_date__c = r.start_Date__c;
            relatedRequest.actual_cancellation_date__c = r.actual_cancellation_date__c;
        }
         
        if (r.type__c == 'Parking Space' && r.status__c != 'New'){
            List<Parking_Lot_Space_Assignment__c> cList = new List<Parking_Lot_Space_Assignment__c>();
            
            cList = [select name
                            , rate_type__c
                            , method_of_payment__c
                            , parking_lot__c
                            , parking_Lot_space__r.name
                            , assignment_start_date__c
                            , assignment_end_Date__c
                            , Parking_Pass_ID__c
                             from Parking_Lot_Space_Assignment__c 
                             where parking_lot_request__c = :r.id];
            if (!cList.isEmpty())
                currentAssignment = cList[0];
                
            system.debug('Currrent assignment:' + currentAssignment);
        }
       
        if (rlist.size() > 0){
         
             if (r.type__c.contains('Replacement')){
         
                //get current space and parking pass id
             
                system.debug('related parking request id:' + r.related_parking_lot_Request__c);
            
                if (r.related_parking_lot_Request__c != null){
                    relatedRequest = [select id, parking_lot__c from Parking_Lot_Request__c where id = :r.related_parking_lot_request__c];
                    currentAssignment = [select method_of_payment__c, Parking_Pass_ID__c, assignment_end_date__c, parking_Lot_space__r.name from Parking_Lot_Space_Assignment__c where parking_lot_request__c = :r.related_parking_lot_Request__c];
                }
                newAssignment = new Parking_Lot_Space_Assignment__c();
         
                List<Parking_Lot_Fee_Schedule__c> fsList = new List<Parking_Lot_Fee_Schedule__c>();
        
                //get all the active parking fee schedules  
                fsList = [select id
                     ,(select fee__c
                        ,currencyisocode
                        ,type__c
                        from Parking_Lot_Fee_Schedule_Details__r)
                from Parking_Lot_Fee_Schedule__c
                where (end_effective_date__c = null 
                or (start_effective_date__c <= :date.today()and end_effective_daTe__c >= :date.today()))
                and parking_lot__c = :relatedRequest.parking_lot__c
                and rate_type__c = 'Replacement Card Cost'];
            
                List<Parking_Lot_Fee_Schedule_Details__c> detailList = new List<Parking_Lot_Fee_Schedule_Details__c>();
            
                detailList = fsList[0].parking_lot_fee_schedule_details__r;
            
                system.debug('DetaiList' + detailList);
            
                Map<String,Decimal> feeMap = new Map<String,Decimal>();
                Map<String,String> currencyMap = new Map<String,String>();
            
                for (Parking_Lot_Fee_Schedule_Details__c d:detailList){
                    feeMap.put(d.type__c,d.fee__c);
                    currencyMap.put(d.type__c,d.currencyIsoCode);
                }
            
                if (feeMap.get(r.vehicle_type__c) == null){
                    r.replacement_card_fee__c = 0;
                    r.currencyIsoCode = 'USD';
                }
                else{
                    r.replacement_card_fee__c = feeMap.get(r.vehicle_type__c);
                    r.currencyIsoCode = currencyMap.get(r.vehicle_type__c);
                } 
         
            }
       }    
    }
    /******************************************************************************************
    * GET REQUEST VEHICLES  
    *
    *******************************************************************************************/
    
    public void getRequestVehicles(String rID){
        
        caList = new List<Parking_Lot_Space_Assignment__c>();
        
        caList = [Select p.Parking_Pass_ID__c
                , p.Parking_Lot__c
                , p.Parking_Lot_Request__r.Name
                , p.Parking_Lot_Request__c
                , p.Assignment_Start_Date__c
                , p.Assignment_End_Date__c
                , parking_pass_isActive__c
                , method_of_payment__c
                From Parking_Lot_Space_Assignment__c p
                where Employee__r.Id = :r.requestee__c
                order by parking_lot__c];
                
        vList = [  
                    Select 
                          p.Parking_Lot_Request__c
                        , p.Name
                        , p.Id
                        , p.Employee_Vehicle__c
                        , p.Employee_Vehicle_Registration__c
                        , p.Employee_Vehicle_Make_Model__c
                        , p.Employee_Vehicle_Color__c
                    From Parking_Lot_Request_Vehicles__c p
                    where parking_lot_request__c = :rID
                     
                ];
        
    }
    
    /**********************************************************************
    * Populate Parking Lots - determine which lots can satisfy the request
    * and display them for selection
    **********************************************************************/

    public void populateParkingLots() {
                  
        parkingLots = new list<selectoption>(); 
        
        //get the lots in the region
        list<Parking_Lot__c> lotList = [Select Name
                                        from Parking_Lot__c 
                                        where parking_lot_region__c = :r.parking_lot_region__c  
                                       ];
                                       
        Set<String> lotSet = new Set<String>();
        for(Parking_Lot__c p:lotList)
            lotSet.add(p.id);
       
        //get the list of types accepted by the lots
        List<Parking_Lot_Assignment__c> aList = [Select p.Vehicle_Type__c
                                                , p.Vehicle_Type_Level__c
                                                , p.Vehicle_Type_Assignment__c
                                                , p.parking_lot__r.name
                                                , p.Id 
                                                From Parking_Lot_Assignment__c p
                                                where parking_lot__c in:lotSet
                                               ];
        
        
        Map<String,String> parkingLotIdMap = new Map<String,String>();
        String eligibleLots = '';
        Set<String> selectedLots = new Set<String>();
        Integer i=0;
        for (Parking_Lot_Assignment__c a:aList){
            
            system.debug('************Request:');
            System.debug(r.vehicle_type__c);
            system.debug(r.requestee_global_parking_level__c);
            system.debug('Lot:');
            system.debug(a.vehicle_type__c);
            system.debug(a.vehicle_type_level__c);
            
            if (a.vehicle_type__c == r.vehicle_type__c && (r.requestee_global_parking_level__c == a.vehicle_type_level__c || a.vehicle_type_level__c == 'All')){
                if (!selectedLots.contains(a.parking_lot__r.name)){
                    selectedLots.add(a.parking_lot__r.name);
                    parkingLotIdMap.put(a.parking_lot__r.name,a.parking_lot__c);
                    eligibleLots += a.parking_lot__r.name; 
                    eligibleLots += ';';
                }
            }       
        }        
         
        if (eligibleLots == '')
            parkingLots.add(new SelectOption('No lots found','No lots found'));
        else{   
            parkingLots.add(new SelectOption('Choose Lot','Choose Lot'));
            list<String> stringList = eligibleLots.split(';');
            for (String s:stringList)
                parkingLots.add(new SelectOption(parkingLotIdMap.get(s),s)); 
            system.debug('eligble lots =' + eligibleLots);
        }  
        
        //populateMethodOfPayment();
                
    } 
    
    /*******************************************************************************************
    * Populate Method of Payment for Selected Lot
    **********************************************************************************************/
    public pageReference populateMethodOfPayment() {
        
        sa.assignment_end_Date__c = null;
        if (sa.assignment_start_date__c == null)
            sa.assignment_start_date__c = r.start_date__c;
        //if (r.expectant_mother__c == false)
            sa.assignment_end_date__c = r.end_Date__c;
        sa.employee__c = r.requestee__c;
        
        Parking_Lot_Region__c myRegion = [select allow_no_charge_parking__c from Parking_Lot_Region__c where id = :r.parking_lot_region__c];
        
        
        parkingLotPaymentMethods = new List<SelectOption>();
        parkingLotRateTypes = new List<SelectOption>();
        
        
        system.debug('***************** Selected parking lot:' + selectedParkingLot);
        
        List<Parking_Lot__c> pList = new List<Parking_Lot__c>();
        
        if (selectedParkingLot != null)
            pList = [select rates__c, Payment_Type_Accepted__c from Parking_Lot__c where id = :selectedParkingLot];
        
        if (pList.size() == 0){
            sa.parking_lot_space__c = null;
            return null;
        }
        
        
        getSpaces(selectedParkingLot,r.vehicle_type__c,r.no_charge__c,r.expectant_mother__c,r.rate_type__c,r.high_roof__c); 
        
        /****** PAYMENT METHODS ********/
        List<String> sList = pList[0].Payment_Type_Accepted__c.split(';');
        if (pList[0].payment_type_accepted__c.contains(r.method_of_payment__c)){
            /* we have a match, make it first one in the list*/
            parkingLotPaymentMethods.add(new SelectOption(r.method_of_payment__c,r.method_of_payment__c));
            selectedMethodOfPayment = r.method_of_payment__c;
        }
        
        
        for (String s:sList){
            if ( (r.no_charge__c == false && s.contains('Disabled')) 
            || ((r.vehicle_type__c == 'Car' || r.vehicle_type__c == 'Motorcycle') && s.contains('Bicycle'))
            )  
                continue;
            else{
                if (pList[0].payment_type_accepted__c.contains(r.method_of_payment__c) && s == r.method_of_payment__c){
                    continue;
                }
                else{
                    if (r.vehicle_type__c == 'Car' && (s.contains('Motorcycle') || s.contains('Bicycle')))
                        continue;
                    else
                    {
                        //Added by Mayur for Parking Jira GLBPARKING-370- Starts
                        Date todaydate = date.today();
                        Date activeDate = Date.valueOf(Label.GP_NatlDate);
                        if(s.contains('Natl'))
                        {
                            if(todaydate > =activeDate)
                                parkingLotPaymentMethods.add(new SelectOption(s,s));
                        }
                        else if(s.contains('Salary Sacrifice'))
                        {
                            if(todaydate < activeDate)
                                parkingLotPaymentMethods.add(new SelectOption(s,s));
                        }
                        //Added by Mayur for Parking Jira GLBPARKING-370- Ends
                        else
                        {
                            parkingLotPaymentMethods.add(new SelectOption(s,s));
                        }
                        
                    }
                    
                    if (parkingLotPaymentMethods.size() == 1 )
                        selectedMethodOfPayment = s;
                }
                 
            }
        }
        
        if (myRegion.allow_no_charge_parking__c == true && r.vehicle_type__c == 'Car' ){
            parkingLotPaymentMethods.add(new SelectOption('No Charge','No Charge'));
        }
        
        populateRateType(); 
        
        return null;
        
    }
    
    /*******************************************************************************************
    * Populate Spaces
    **********************************************************************************************/
    public pageReference populateRateType() {
        
        
        parkingLotRateTypes = new List<SelectOption>();
        
        List<Parking_Lot__c> pList = new List<Parking_Lot__c>();
        
        if (selectedParkingLot != null)
            pList = [select rates__c, Payment_Type_Accepted__c from Parking_Lot__c where id = :selectedParkingLot];
        
        /****** RATES ********/
        List<String> sListR = pList[0].Rates__c.split(';');
        /*
        if (pList[0].rates__c.contains(r.rate_type__c)){
             
            parkingLotRateTypes.add(new SelectOption(r.rate_type__c,r.rate_type__c));
            selectedRateType = r.rate_type__c;
        }
        */
        
        for (String s:sListR){
            
            if (s == 'Daily'){
                if (selectedMethodOfPayment.contains('Invoice') || selectedMethodOfPayment.contains('Taxed'))
                    parkingLotRateTypes.add(new SelectOption(s,s));
                else
                    continue;
            }
            else{
                if (s == 'Monthly'){
                    if (selectedMethodOfPayment.contains('Consumption'))
                        continue;
                    else
                        parkingLotRateTypes.add(new SelectOption(s,s));
                }
                else{
                    if (s == 'Hourly'){
                        if (selectedMethodOfPayment.contains('Monthly') || selectedMethodOfPayment.contains('No Charge'))
                            continue;
                        else
                            parkingLotRateTypes.add(new SelectOption(s,s));
                    }
                }
            }   
        }
        
        populateSpaces();
        
        return null;
    }
    
    /*******************************************************************************************
    * Populate Spaces
    **********************************************************************************************/
    public pageReference populateSpaces() {
        
        system.debug('selected method of payment' + selectedMethodOfPayment);
        system.debug('populating spaces now' + selectedRateType );
        sa.parking_lot_space__c = null;
        Boolean noCharge;
        If (selectedMethodOfPayment.toLowerCase().contains('o charg'))
            noCharge = true;
        else    
            noCharge = false;
        getSpaces(selectedParkingLot,r.vehicle_type__c,noCharge,r.expectant_mother__c,r.rate_type__c,r.high_roof__c ); 
        
        return null;
        
    }
    
    
    /******************************************************************************************
    * GET SPACES  
    *
    *******************************************************************************************/
    
    public void getSpaces(String lID, String stype,Boolean noCharge,Boolean expectantMother, String rateType, Boolean highRoof){
        String firstSpotAvailable;
        Boolean Space;
        Boolean expectantMotherSpace;
        Boolean daily;
        
        if (rateType == 'Daily')
            daily = true;
        else
            daily = false;
            
        expectantMotherSpace = expectantMother;
        
        if (stype == 'Bicycle' || sType == 'Motorcycle') 
            nocharge = false;
    
        system.debug(lId + '-' + noCharge + '-' + expectantMotherSpace + '-' + daily );
        
        system.debug('space type: ' + stype);
              
        sList = [  
                      Select 
                        Status__c
                      , p.Status_Notes__c
                      , p.Space_Type__c
                      , p.Parking_Lot__c
                      , p.Name
                      , p.Id 
                      , p.location__c
                      , p.location_space__c
                      , p.no_charge__c
                      From Parking_Lot_Space__c p
                      where parking_lot__c = :lID
                      and no_charge__c = :noCharge
                      and expectant_mother_space__c = :expectantMotherSpace
                      and space_type__c = :stype
                      and status__c = 'Available'
                      and daily__c = :daily
                      and High_Roof_Space__c = :highRoof
                      order by name
                      
                ];
        
        
            
        if (sList.size() > 0){
            renderSpaces=true;
            firstSpotAvailable = sList[0].id;
        }else{
            renderspaces = false;
            showAutoAssign=false;
            firstSpotAvailable = null;
            sa.Parking_Lot_Space__c = null;
        }
        
        

        gridList = new List<wrapResults>();
        
        
        //find the assignment rule for this lot/vehicle/level 
        //if it is unassigned then automatically pick a space
        List<Parking_Lot_Assignment__c> checkList = [Select p.Vehicle_Type__c
                                                , p.Vehicle_Type_Level__c
                                                , p.Vehicle_Type_Assignment__c
                                                , p.parking_lot__r.name
                                                , p.Id 
                                                From Parking_Lot_Assignment__c p
                                                where parking_lot__c = :selectedParkingLot
                                               ];
        
        for (Parking_Lot_Assignment__c check:checkList){
            if (check.vehicle_type__c == r.vehicle_type__c && (r.requestee_global_parking_level__c == check.vehicle_type_level__c || check.vehicle_type_level__c == 'All')){
                if (check.Vehicle_Type_Assignment__c == 'Unassigned' && firstSpotAvailable != null){
                    system.debug('**************** system is picking a spot for you *********************');
                    sa.Parking_Lot_Space__c = firstSpotAvailable;
                    showAutoAssign=true;
                    break;
                }
            }
        }
        
    
        Integer MAX = 10;   
        Integer count=0;
        List<Parking_Lot_Space__c> tempList = new List<Parking_Lot_Space__c>();
        
        for (Parking_Lot_Space__c ps: sList){
             
            tempList.add(ps);
            count++;
            
            if (count == MAX){
                count = 0;
                gridList.add(new wrapResults(tempList));
                tempList = new List<Parking_Lot_Space__c>();
            }
                        
        }
        if (count < MAX)
            gridList.add(new wrapResults(tempList));
            
        
    }
    /******************************************************************************************
    * CONFIRM   
    *
    *******************************************************************************************/
    
    public PageReference confirm(){
       
        if (r.type__c == 'Cancellation'){
            
            
            if (r.actual_cancellation_date__c == null){
                r.actual_cancellation_Date__c.addError('End date is required!' );
                return null;
            }
            else{
                if (r.actual_cancellation_date__c < currentAssignment.assignment_start_date__c){
                    r.actual_cancellation_Date__c.addError('Actual cancellation date must be >= start date (' + currentAssignment.assignment_start_date__c.format() + ')!' );
                    return null;
                }
                else{
                    if (r.actual_cancellation_date__c <= system.today()){
                        currentAssignment.assignment_end_Date__c = r.actual_cancellation_date__c;
                        relatedRequest.status__c = 'Cancelled';     
                        r.status__c = 'Complete';
                        //Added by Mayur - For Jira - GLBPARKING-361.  - Starts
                        r.Request_Approved_On__c = system.now();
                        r.Request_Approved_by__c = UserInfo.getName();
                        //Added by Mayur - For Jira - GLBPARKING-361.  - Ends
                        relatedRequest.actual_cancellation_date__c = r.actual_cancellation_date__c;
                        List<Parking_Lot_Request__c> rList = new List<Parking_Lot_Request__c>();
                        rList.add(r);
                        rList.add(relatedRequest);
                        update rList;
                        
                        update currentassignment;
                         
                    }
                    else{
                        currentAssignment.assignment_end_Date__c = r.actual_cancellation_date__c;
                        r.status__c = 'Complete';
                        //Added by Mayur - For Jira - GLBPARKING-361.  - Starts
                        r.Request_Approved_On__c = system.now();
                        r.Request_Approved_by__c = UserInfo.getName();
                        //Added by Mayur - For Jira - GLBPARKING-361.  - Ends
                        relatedRequest.status__c = 'Pending Cancellation';
                        relatedRequest.actual_cancellation_date__c = r.actual_cancellation_date__c;
                        List<Parking_Lot_Request__c> rList = new List<Parking_Lot_Request__c>();
                        rList.add(r);
                        rList.add(relatedRequest);
                        update rList;
                        
                        update currentassignment;
                        
                    } 
                    
                    PageReference p = new PageReference('/apex/gp_assignment?rid=' + r.parking_lot_region__c + '&status=1');
                    p.setRedirect(true);
                    return p;
                } 
            }
        }
        else{
            r.Status__c = 'Confirmed';
            //Added by Mayur - For Jira - GLBPARKING-361.  - Starts
            r.Request_Approved_On__c = system.now();
            r.Request_Approved_by__c = UserInfo.getName();
            //Added by Mayur - For Jira - GLBPARKING-361.  - Ends
            update r;
        }
        
        PageReference p = new PageReference('/apex/gp_assignment?rid=' + r.parking_lot_region__c + '&status=1');
        p.setRedirect(true);
        return p; 
      
    }
    
    /******************************************************************************************
    * REJECT    
    *
    *******************************************************************************************/
    
    public PageReference reject(){
       
        r.Status__c = 'Rejected';
        update r;
      
        PageReference p = new PageReference('/apex/gp_assignment?status=1' + '&rid=' + rid);
        p.setRedirect(true);
        return p; 
      
    }
   
    /******************************************************************************************
    * REJECT    
    *
    *******************************************************************************************/
    
    public PageReference SaveReject(){
        
        if (r.reject_reason_desc__c == null || r.reject_reason_desc__c == ''){
            r.reject_reason_desc__c.addError('Reject reason required when a request is rejected!');
            return null;
        }
        
        r.Status__c = 'Rejected';
        update r;
      
        PageReference p = new PageReference('/apex/gp_assignment?status=1' + '&rid=' + rid);
        p.setRedirect(true);
        return p; 
      
    }
   
    /******************************************************************************************
    * SAVE   
    *
    *******************************************************************************************/
    
    public PageReference save(){
       
        system.debug('in save');
        Parking_Lot_Request__c checkR = [select LastModifiedDate from Parking_Lot_Request__c where id = :r.id];
        
        /* this checks to see if something about the request changed since it was displayed on the page */
        if (checkR.LastModifiedDate != r.LastModifiedDate){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The request has been updated since it was displayed for your review.  Please refresh the page to continue!');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        
        
       
        List<Parking_Lot_Space_Assignment__c> checkPassList = new List<Parking_Lot_Space_Assignment__c>();
       
                                
        if (r.type__c.contains('Replacement')){
        
            if (newAssignment.Parking_Pass_ID__c == null){
                newAssignment.Parking_Pass_ID__c.addError('Pass is required!');
                return null;
            }  
            //Added by Mayur for Jira Item - GLBPARKING-362 - On 06/02/2017
            if (newAssignment.Parking_Pass_ID__c != null && r.parking_lot_region__r.name == 'Budapest' && newAssignment.Parking_Pass_ID__c.length()!=10){
                newAssignment.Parking_Pass_ID__c.addError('Pass id length should be 10 digits!');
                return null;
            }   
            
            checkPassList = [select id 
                            ,parking_lot_request__r.name
                        from Parking_Lot_Space_Assignment__c 
                        where parking_pass_id__c = :newAssignment.parking_Pass_id__c
                        and parking_lot_request__r.parking_lot_region__c = :r.parking_lot_region__c
                        and parking_pass_isActive__c = true
                        limit 1];
            if (!checkPassList.isEmpty()){
                newAssignment.parking_Pass_id__c.addError('Pass is already active on request: ' + checkPassList[0].parking_lot_request__r.name);
                return null; 
            }
                        
        
            r.Status__c = 'Assigned';
            system.debug('newassignment:' + newassignment);
            system.debug('newassignmentpp:' + newassignment.parking_pass_id__c);
            
            currentAssignment.Parking_Pass_ID__c = newAssignment.Parking_Pass_ID__c;
            update currentAssignment;
            r.replacement_issued_date__c = date.today();
            //Added by Mayur - For Jira - GLBPARKING-361.  - Starts
            r.Request_Approved_On__c = system.now();
            r.Request_Approved_by__c = UserInfo.getName();
            //Added by Mayur - For Jira - GLBPARKING-361.  - Ends
            update r;
            PageReference p = new PageReference('/apex/gp_assignment?rid=' + r.parking_lot_region__c + '&status=1');
            p.setRedirect(true);
            return p;  
        }
        
        
       
        Boolean error=false;
        required=false;
        
        
        if (sa.assignment_start_date__c == null){
            sa.assignment_start_Date__c.addError('Start date is required!'); 
        }
    
        if (sa.parking_lot_space__c == null){
            sa.parking_lot_space__c.addError('Space is required!');
             
            error=true;
        } 
        if (sa.parking_pass_id__c == null && (r.rate_type__c <> 'Daily' && r.parking_lot_region__r.name != 'London' && r.parking_lot_region__r.name != 'Glasgow')){
            sa.parking_pass_id__c.addError('Pass id is required!');
             
            error=true;
        }  
        //Added by Mayur for Jira Item - GLBPARKING-362  - On 06/02/2017
        if (sa.parking_pass_id__c != null &&  r.parking_lot_region__r.name == 'Budapest'){
            if(sa.parking_pass_id__c.length()!=10)
            {
                sa.parking_pass_id__c.addError('Pass id length should be 10 digits!');
                error=true;
            }
        }  
        
        if (!error){
            checkPassList = [select id 
                            ,parking_lot_request__r.name
                        from Parking_Lot_Space_Assignment__c 
                        where parking_pass_id__c = :sa.parking_pass_id__c
                        and parking_lot_request__r.parking_lot_region__c = :r.parking_lot_region__c
                        and parking_pass_isActive__c = true
                        limit 1];
            if (!checkPassList.isEmpty()){
                sa.parking_pass_id__c.addError('Pass is already active on request: ' + checkPassList[0].parking_lot_request__r.name);
                return null; 
            } 
        }
          
        if (selectedParkingLot == null || selectedParkingLot == 'Choose a Lot' || selectedParkingLot == ''){
            sa.parking_lot__c.addError('Parking Lot is required to save an assignment!');
            error=true;
        }
            
        if (selectedMethodOfPayment== null || selectedMethodOfPayment == '---None---'){
        
            error=true;
        }
        
        system.debug('Error is : ' + error);
        
        if (sa.parking_lot_space__c != null){
            List<Parking_Lot_Space__c> sList = new List<Parking_Lot_Space__c>();
            sList = [select id from Parking_Lot_Space__c where id = :sa.parking_lot_space__c
                and parking_lot__c = :selectedParkingLot ];
            if (slist.size()== 0){
                sa.parking_lot_space__c.addError('Space not in this lot!') ;
                error=true;
            }
        }
    
        system.debug('Error is : ' + error);
        if (error)
            return null;
        
        List<RecordType> rTypeList = new List<RecordType>();
        rTypeList = [Select  r.Id, r.DeveloperName 
                    From RecordType r
                    where sobjectType = 'Parking_lot_space_assignment__c'
                    and isActive = true];
        Map<String,String> rTypeMap = new Map<String,String>();
        for (RecordType r:rTypeList)
            rTypeMap.put(r.developername,r.id);
        
        
         
        if (r.type__c == 'Parking Space'){
             
            
            r.reject_reason_desc__c = null;
        
            if (selectedMethodOfPayment == 'Daily')
                sa.method_of_payment__c = 'Consumption';
            else
                sa.Method_of_Payment__c = selectedMethodOfPayment;
             
            r.assigned_method_of_payment__c = selectedMethodOfPayment;
            sa.parking_lot_Request__c = r.id;
            sa.employee__c = r.requestee__c;
            
            if (selectedMethodOfPayment == 'Daily'){
                sa.rate_type__c = 'Daily';
                r.rate_type__c = 'Daily';
            }
            else{
                if (selectedMethodOfPayment == 'Consumption'){
                    sa.rate_type__c = 'Hourly';
                    r.rate_type__c = 'Hourly';
                }
                else{
                    r.rate_type__c = 'Monthly';
                    sa.rate_type__c = 'Monthly';
                }
            }
            System.debug('Rate type--'+r.rate_type__c);
            if (reg.billing_period__c == 'Current Month' && sa.rate_Type__c == 'Monthly' && r.no_charge__c == false &&  !selectedMethodOfPayment.contains('No Charge')){
                Date d = system.today();
                Date compareDate = Date.newInstance(d.year(),d.month(),1);
                compareDate = compareDate.addMonths(1);
                compareDate = compareDate.addDays(-1);
                if (sa.assignment_start_date__c < compareDate){
                    sa.assignment_start_date__c.addError('This location requires the start date to be in the following month!');
                    error=true;
                    return null;
                }
            }
            
            //create a docusign envelope if declaration form is required
            system.debug('selected lot:' + selectedParkingLot + '......' + 'salot:' + sa.parking_lot__c);
            
            
            GP_ServiceHelper.feeResults f = GP_ServiceHelper.lookupPriceForRequest(r.id, selectedParkingLot);  
            if (f.message != null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, f.message);
                ApexPages.addMessage(myMsg);
                error=true;
                return null;
            }       
            if (sa.rate_type__c == 'Daily')
                sa.daily_fee__c = f.fee;
            else{
                if (sa.rate_Type__c == 'Monthly')
                    sa.monthly_Fee__c = f.fee;
                else
                    sa.hourly_fee__c = f.fee;
            }
            
            if (sa.method_of_payment__c == 'No Charge'){
                if (sa.rate_type__c == 'Daily')
                    sa.daily_fee__c = 0;
                else
                if (sa.rate_Type__c == 'Monthly')
                    sa.monthly_fee__c = 0;
                else
                    sa.hourly_fee__c = 0;
            }
                
            sa.currencyisocode = f.currencyisocode;
            
            
            
            /*  REMOVE THIS ALM 240
            if (reg.billing_period__c == 'Next Month' && sa.rate_Type__c == 'Monthly' && r.no_charge__c == false &&  !selectedMethodOfPayment.contains('No Charge')){
                Date d = system.today();
                Date compareDate = Date.newInstance(d.year(),d.month(),1);
                compareDate = compareDate.addMonths(2);
                compareDate = compareDate.addDays(-1);
                if (sa.assignment_start_date__c < compareDate){
                    sa.assignment_start_date__c.addError('This location requires the start date to be in the month after next!');
                    error=true;
                    return null;
                }
            }
            */
         
            if (reg.billing_period__c == 'None'){
                Date d = system.today();
                
                if (sa.assignment_start_date__c < d){
                    sa.assignment_start_date__c.addError('This location requires the start date to be >= today!');
                    error=true;
                    return null;
                }
            }
            
            List<Parking_Lot_Space__c> spaceList = new List<Parking_Lot_Space__c>();
            system.debug('**** right here');
            if (sa.parking_lot_space__c != null){
                
                spaceList = [select id from Parking_Lot_Space__c where id = :sa.parking_lot_space__c
                    and parking_lot__c = :selectedParkingLot and status__c = 'Available' ];
                if (spacelist.size()== 0){
                    sa.parking_lot_space__c.addError('Space no longer available!') ;
                    error=true;
                    return null;
                }
            }
                
            if (!error && sa.assignment_end_date__c != null && sa.assignment_start_date__c != null){
                if (sa.assignment_end_date__c <= sa.assignment_start_date__c){
                    sa.assignment_end_Date__c.addError('End date must be greater than Start date!');
                    error=true;
                    return null;
                }
            }
            //Added for Jira GLBPARKING-353 by Mayur - Starts 3rd April
            if(sa.assignment_end_date__c != r.End_Date__c && r.Expectant_Mother__c)
            {
                r.Expectant_Mother_Email__c=true;
            }
           //Added for Jira GLBPARKING-353 by Mayur - Ends 3rd April
            if (sa.assignment_start_date__c > system.today())   
                r.status__c = 'Pending';
            
            else
                r.Status__c = 'Assigned';
            r.parking_lot__c = selectedParkingLot;
            
            r.actual_start_date__c = sa.assignment_start_date__c;
            
            if (r.method_of_payment__c == 'No Charge')
                r.no_charge__c = true;
                
            if (r.Parking_lot_region__r.name == 'Purchase')
                r.parking_lot_region__r.name = 'USA';
                
            sa.recordtypeid = rTypeMap.get(r.parking_lot_region__r.name);
            
            //r.method_of_payment__c = selectedMethodOfPayment;
            
            insert sa;
            system.debug('inserted sa:' + sa);
        
            
            Parking_Lot_Space__c space = spaceList[0];
                
            space.Status__c  = 'Assigned';
        
            update space;
        
            List<Parking_Lot_Space_Assignment_Vehicle__c> vaList = new List<Parking_Lot_Space_Assignment_Vehicle__c>();
        
            for (Parking_Lot_Request_Vehicles__c v:vList){
                Parking_Lot_Space_Assignment_Vehicle__c va = new Parking_Lot_Space_Assignment_Vehicle__c();
                va.Employee_Vehicle__c = v.employee_vehicle__c;
                va.Parking_Lot_Space_Assignment__c = sa.id;
            
                vaList.add(va);
            }
        
            if (!vaList.isEmpty())
                insert vaList;
            
            /* if expectant mother, create a pending cancel request for the future */
            if (r.expectant_mother__c == true){
                Parking_Lot_Request__c er = new Parking_Lot_Request__c();
                er.Related_Parking_Lot_Request__c = r.id;
                system.debug('reqeuest end date:' + r.end_date__c);
                er.start_date__c = r.end_date__c;
                er.expectant_mother__c = true;
                er.vehicle_type__c = r.vehicle_type__c;
                er.type__c = 'Cancellation';
                er.parking_lot__c = r.parking_lot__c;
                er.Method_of_Payment__c = r.Method_of_Payment__c;
                er.status__c = 'New';
                er.recordTypeId = r.recordTypeId;
                er.rate_type__c = r.rate_type__c;
                er.cancellation_reason__c = 'Birth or adoption of child';
                er.Reason_for_Cancellation__c = 'Auto cancellation created for expectant mother';
                er.parking_lot_Region__c = r.parking_lot_Region__c;
                er.requestee__c = r.requestee__c;
                insert er;
            }
            
            //Added by Mayur - For Jira - GLBPARKING-361.  - Starts
            r.Request_Approved_On__c = system.now();
            r.Request_Approved_by__c = UserInfo.getName();
            //Added by Mayur - For Jira - GLBPARKING-361.  - Ends
            System.debug('Rate type--'+r.rate_type__c);
            update r;
        
            //DG_DocUtilities doc = new DG_DocUtilities();
            Map<String,String> saMap = new Map<String,String>();
            saMap.put('sa',sa.id);
            saMap.put('session', userinfo.getSessionId());
            
            if (!test.isRunningTest()){
                if (reg.Send_Declaration__c)
                    DG_DocUtilities.decFuture(saMap);
            }
            //DG_DocUtilities.genCongaDocument(System.Label.GP_DeclarationCongaTemplateId,System.Label.GP_CongaQueryId1,System.Label.GP_CongaQueryId2,sa.Parking_Lot_Request__c,sa.Parking_Lot_Request__c,'TempDec',sa.id); 
            
        
        }   
        
        PageReference p = new PageReference('/apex/gp_assignment?rid=' + r.parking_lot_region__c + '&status=1');
        p.setRedirect(true);
        return p;  
                
                 
    }     
    /******************************************************************************************
    * GET NEXT REQUEST   
    *
    *******************************************************************************************/
    
    public PageReference back(){ 
        
         statusMessage = '';
         requestNbr--;
         
         if (requestNbr >= 0)   {
            
            if (requestNbr > 0)
                renderBack = true;
            
            if (requestNbr < totalRequests - 1)
                renderNext = true;
                    
            r =  rlist[requestNbr];
            if (r.related_parking_lot_request__c != null)
                getRequestVehicles(r.related_parking_lot_request__c);
            else
                getRequestVehicles(r.id);       

            sa = new Parking_Lot_Space_Assignment__c(); 
            gridList = new List<wrapResults>();
            getRelated();
            
         }
         else
            renderBack = false;
         
         return null;
         
    }
        
    /******************************************************************************************
    * GET NEXT REQUEST   
    *
    *******************************************************************************************/
    
    public PageReference getNext(){
        
         statusMessage = '';
         
         requestNbr++;
         
        
         if (requestNbr > totalRequests) {
            
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'No more requests to display!'));
            r = new Parking_lot_request__c();
            rList = new List<Parking_Lot_Request__c>();
            vList = new List<Parking_Lot_Request_Vehicles__c>();
            sList = new List<Parking_Lot_Space__c>();
            sa = new Parking_Lot_Space_Assignment__c();
            gridList = new List<wrapResults>();
            return null;
         }
         else{
            if (requestNbr == totalRequests - 1){
                renderNext = false;
                statusMessage = 'Last request in queue!';
            }
            else
                renderNext = true;
            
            if (requestNbr > 0)
                renderBack = true;
            
            r =  rlist[requestNbr];
            if (r.related_parking_lot_request__c != null)
                getRequestVehicles(r.related_parking_lot_request__c);
            else
                getRequestVehicles(r.id);   

            sa = new Parking_Lot_Space_Assignment__c(); 
            gridList = new List<wrapResults>();
            getRelated();
            
            return null;
         }
         
         
    
    }
    
    
    /******************************************************************************************
    * GRID  
    *
    *******************************************************************************************/
    
    public class wrapResults {
        
        public Parking_Lot_Space__c s1 {get;set;}
        public Parking_Lot_Space__c s2 {get;set;}
        public Parking_Lot_Space__c s3 {get;set;}
        public Parking_Lot_Space__c s4 {get;set;}
        public Parking_Lot_Space__c s5 {get;set;}
        public Parking_Lot_Space__c s6 {get;set;}
        public Parking_Lot_Space__c s7 {get;set;}
        public Parking_Lot_Space__c s8 {get;set;}
        public Parking_Lot_Space__c s9 {get;set;}
        public Parking_Lot_Space__c s10 {get;set;}
        
     
        public wrapResults(List<Parking_Lot_Space__c> sList){
            system.debug('slist size:' + slist.size() + 'list:' + slist);
             
            for (Integer i=0;i < 10 ;i++){
                if (i==0 && slist.size() >=1)   
                    s1=sList[i];
                else
                if (i==1 && slist.size() >=2)   
                    s2=sList[i];
                else
                if (i==2 && slist.size() >=3)   
                    s3=sList[i];
                else
                if (i==3 && slist.size() >=4)   
                    s4=sList[i];
                else
                if (i==4 && slist.size() >= 5)  
                    s5=sList[i];
                else
                if (i==5 && slist.size() >=6)   
                    s6=sList[i];
                else
                if (i==6 && slist.size() >=7)   
                    s7=sList[i];
                else
                if (i==7 && slist.size() >=8)   
                    s8=sList[i];
                else
                if (i==8 && slist.size() >=9)   
                    s9=sList[i];
                else
                if (i==9 && slist.size() >= 10) 
                    s10=sList[i];
                
            }
        } 
       
    }
    
    /******************************************************************************************
    * EXIT   
    *
    *******************************************************************************************/
    
    public PageReference exit(){
        
         
        PageReference p;
        
        if (id == null)
            p = new PageReference('/' + reg.id);
        else
            p = new PageReference('/' + System.Label.GP_ParkingRequestList);

        p.setRedirect(true);
        return p;  
       
    }
    
   
    
    
}