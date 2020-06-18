/***************************************************************************************************************
*
*  GP JSON - this class houses all of the json message classes used to pass data back to the ng front end
*
*  Changelog:
*
*  10/7/15 - MRM Created
*
****************************************************************************************************************/
public class GP_JSON {
    
    /***************************************************************************************************************
    *
    *  JSON RETURN CLASSES
    *
    ****************************************************************************************************************/
     public class price { 
        
        public String currencyCode {get;set;}
        public String rateType {get;set;}
        public String monthlyAmount {get;set;}
        public String hourlyAmount {get;set;}
        public String annualAmount {get;set;}
        public String dailyAmount {get;set;}
        public String replacementAmount {get;set;}
         
        
        public price (String rateType, String currencyCode, String amount){
            this.currencyCode = currencyCode;
             
            if (rateType == 'Daily')
                this.dailyAmount = decimal.valueOf(amount).format();
            else
            if (rateType == 'Hourly'){
                this.hourlyAmount = decimal.valueOf(amount).format();
            }
            else{
                if (rateType == 'Monthly'){ 
                    Decimal myAmount = decimal.valueOf(amount);
                    this.annualAmount = (myAmount * 12).format();
                    this.monthlyAmount = decimal.valueOf(amount).format();
                }
                else{
                    this.replacementAmount = amount;
                }
            }
            
        }
     } 
      
     public class replacementPriceRequest {    
        public String vehicleType;
        public String locationId;  
        public String requestId;
        
     } 
       
     public class priceRequest {
        
        public String rateType;
        public String vehicleType;
        public String requesteeGlobalParkingLevel;
        public String handicapAccessRequired;
        public String companyOwned;
        public String locationId;
        public String requestId;
     }
      
     public class vehicle {
        String id {get;set;}
        String vtype {get;set;}
        String makeModel {get;set;}
        String color {get;set;}
        String companycarindicator {get;set;}
        String assignmentCount {get;set;}
        String registration {get;set;}
        String state {get;set;}
        String highRoofIndicator{get;set;}
        String blueTag {get;set;}
        
        public vehicle(String id, String vtype, String makeModel, String color,
                     String companycarindicator,String assignmentCount, String registration, String state, String highRoofIndicator, String bt){
        
            this.id = id;
            this.vtype =vtype;
            this.makeModel = makeModel;
            this.color = color;
            this.companycarindicator = companycarindicator;
            this.assignmentCount = assignmentCount;
            this.registration = registration;
            this.state = state;
            this.highRoofIndicator = highRoofIndicator;
            this.blueTag = bt; 
            
        }
        
    }
     public class parkingPassRequest{
        
        public String vehicleType;
        public String requestType;
        public String startDate;
        public String endDate; 
        public String requesteeEmployeeId;
        public String rateType;
        public String parkingLotId;
        public String locationId;
        public String methodOfPayment;
        public String handicapAccessRequired;
        public String assignedSpaceRequired;
        public String reasonForCancellation;
        public String reasonForDelay;
        public String relatedRequestId;
        public String expectantMother;
        public String currentParkingPassId;
        public String companyCar;
        public String highRoof;
        
        public List<vehicleId> selectedVehicles; 
        
    }
    
     public class replacePassVehicles{
        
        public String requestId;

        public List<vehicleId> selectedVehicles; 
        
    }
    
     public class vehicleId {
        public String vehicleId {get;set;}
        
        public vehicleId(String id){
            this.vehicleId = id;
        }
    }
    
    public class requestVehicleId {
        public String vehicleId {get;set;}
    }
   
    public class newVehicle{
    
        public string employeeId;
        public String makeModel;
        public String registration;
        public String color;
        public String type;
        public String companyCar;
        public String highRoof;
        public String state;
        
    
    }
    public class existingVehicle{
    
        public string vehicleId;
        public String makeModel;
        public String registration;
        public String color;
        public String type;
        public String companyCar;
        public String highRoofIndicator;
        public String status; 
        public String state;
        
     
    } 
    
     public class updatePassRequest{
        public string requestId;
        public String enrollmentPaymentMethod;
        public String parkingCardId;
        public String highRoof; 
    }
    public class colorsAllowed{
        public String color;
        
        public colorsAllowed(String color){
            this.color = color;
        }
     }
     
     public class helpDocUrl{
        public String url;
        
        public helpDocUrl(String url){
            this.url = url;
        }
     }
     
     public class cancelReason{
        public String reason;
        
        public cancelReason(String reason){
            this.reason = reason;
        }
     }
     
     public class passVehicle{
    
        public string employeeVehicleId;
        public string passVehicleId;
        public String makeModel;
        public String registration;
        public String color;
        public String type;
        public String companyCar;
        public String highRoof;
        
        
        public passVehicle (Parking_Lot_Request_Vehicles__c v){
            
            this.employeeVehicleId = v.Employee_Vehicle__c;
            this.passVehicleId = v.id;
            this.makeModel = v.employee_vehicle_make_model__c;
            this.registration = v.employee_vehicle_registration__c;
            this.color = v.employee_vehicle_color__c;
            this.type = v.vehicle_type__c;
            if (v.company_Car__c)
                this.companyCar = 'true';
            else
                this.companyCar = 'false';
            if (v.employee_vehicle__r.high_roof__c)
                this.highRoof = 'true';
            else
                this.highRoof = 'false';
        }
    
    }
    public class vehicleType {
        String availableVehicleTypeId {get;set;}
        String assignmentType {get;set;}
        String employeeGPLevel {get;set;}
        
        public vehicleType (String availableVehicleTypeId, String assignmentType, String employeeGPLevel){
            this.availableVehicleTypeId = availableVehicleTypeId;
            this.assignmentType = assignmentType;
            this.employeeGPLevel = employeeGPLevel;
            
        }
     }
     public class paymentRate {
        public String rateType {get;set;}
        
        public paymentRate (String rateType){
            this.rateType = rateType;
        }
     }
     public class paymentMethodClass {
        public String paymentMethod {get;set;}
        
        public paymentMethodClass(String paymentMethod){
            this.paymentMethod = paymentMethod;
        }
     } 
     public class locationSetting {
    
        public List<vehicleType> assignmentTypeList { get; set; }
        public List<PaymentRate> paymentRates {get;set;}
        public List<paymentMethodClass> paymentMethods {get;set;}
        public List<String> states {get;set;}
        
        public locationSetting (List<vehicleType> assignmentTypeList, List<PaymentRate> paymentRates, List<paymentMethodClass> paymentMethods, boolean allowStates ) {
            this.assignmentTypeList = assignmentTypeList;
            this.paymentRates = paymentRates;
            this.paymentMethods = paymentMethods;
            
            this.states = new List<String>();
            if (allowStates){
                Schema.DescribeFieldResult res = Employee_Vehicle__c.state__c.getDescribe();
                for(Schema.PicklistEntry x  :  res.getPicklistValues() ){
                    this.states.add(x.getValue());
                }
            } 
        } 
    }     
    public class location {
        public String id {get;set;} 
        public String location {get;set;}
        public String allowhighroof {get;set;}
        public String allowcompanycar {get;set;}
        public String termsandconditions {get;set;}
        public String weekendOvernight {get;set;}
        public String nbrOfVehiclesAllowedOnPass {get;set;}
        public String allowStates {get;set;}
        public String allowExpectantMother {get;set;}
        public String allowCurrentParkingPassId {get;set;}
        public String sendDeclaration {get;set;}
        public String currentDate {get;set;}
        public String enrollmentStartDate {get;set;}
        public String enrollmentEnddate {get;set;}
        public String allowDelayStart {get;set;}
        
        public List<locationSetting> locationSettings {get;set;}
        
        public location (String id, String location, String allowhighroof, String allowcompanycar
        , String termsandconditions, String weekendOvernight, List<locationSetting> locationSettings, String nbrOfVehiclesAllowedOnPass
        , String hc, String st, String em, String ac
        , String dec, String start, String eend, String ad){
            this.id = id;
            this.location = location;
            this.allowhighroof = allowhighroof;
            this.allowcompanycar = allowcompanycar;
            this.termsandconditions = termsandconditions;
            this.locationSettings = locationSettings;
            this.weekendOvernight = weekendOvernight;
            this.nbrOfVehiclesAllowedOnPass = nbrOfVehiclesAllowedOnPass;
            this.allowStates = st; 
            this.allowExpectantMother = em;
            this.allowCurrentParkingPassId = ac;
            this.sendDeclaration = dec;
            this.currentDate = Date.Today().format();
            this.enrollmentStartDate = start;
            this.enrollmentEndDate = eend;
            this.allowDelayStart = ad;
        }
    } 
     
    public class userDetails {
        public String name { get; set; }
        public String displayName { get; set; }
        public String employeeId {get;set;}
        public String location {get;set;}
        public String contact {get;set;}
        public String city {get;set;}
           
        public userDetails (String name, String displayName, String employeeId, String contact, String city) {
            this.name = name;
            this.displayName = displayName;
            this.contact = contact;
            this.employeeId = employeeId;  
            this.city = city;     
        }
    }
     
    public class delegate {
        public String id { get; set; }
        public String msid { get; set; }
        public String name {get;set;}
        public String status {get;set;}
        
        public delegate (String id, String msid, String name, String status) {
            this.id = id;
            this.msid = msid;
            this.name = name;
            this.status = status;
        }
    }
    
    public class delegationRequest {
        public String delegationRequestId { get; set; }
        public String name {get;set;}
        
        public delegationRequest (String delegationRequestId, String name) {
            this.delegationRequestId = delegationRequestId;
            this.name = name;
        }
    }
     public class resultName {
        public String name {get;set;}
        
        public resultName (String name) {
            this.name = name;
        }
    }
    
    public class inputId{
        public string id;
    }
    
    public class invoiceId{
        public string invoiceId;
    }
    
    public class disputeTime{
        public string timeDetailId;
        public string comments;
    }
    
    public class timeDetailId{ 
        public string timeDetailId;
        
        public timeDetailId(String timeDetailId){
            this.timeDetailId = timeDetailId;
        }
    }
    
    public class age{ 
        public string age;
        
        public age(String age){
            this.age = age;
        }
    }
    
   public class cancelRequest{
        public String requestId;
        public String cancelDate;
        public String cancelReason;
    }
    
    public class overnightRequest{
        public String requestId;
        public String startDate;
    }
    
     public class Pass {
        public string id {get;set;}
        public string location {get;set;}
        public string state {get;set;}
        public string passId {get; set;}
        public string vehicle { get; set; }
       
        public Pass(string id, string location, string state) {
            this.id = id;
            this.location = location;
            this.state = state;

        }
        
        public Pass(string id, string location, string state, string passId, string vehicle) {
            this.id = id;
            this.location = location;
            this.state = state;
            this.passId = passId;
            this.vehicle = vehicle;
        }
    }
    
  
    
    public class billingHistory {
        public String invoiceId {get;set;}
        public String name {get;set;}
        public String rateType {get;set;}
        public String parkingSpace {get;set;}
        public String parkingSpaceType {get;set;}
        public String parkingLot {get;set;}
        public String note {get;set;}
        public String monthInvoiced {get;set;}
        public String methodOfPayment {get;set;}
        public String msid {get;set;}
        public String datePaid {get;set;}
        public String balanceDue {get;set;}
        public String amountPaid{get;set;}
        public String amountBilled {get;set;}
        public String status {get;set;}
        public String currencyCode{get;set;}
        public List<timeDetail> timeEntryList {get;set;}
        public String invoiceURL {get;set;}
        public String hourlyRate {get;set;}
        public String monthlyRate {get;set;}
        
      
        public billingHistory(Parking_Lot_Assignment_Fees_Due__c i, List<timeDetail> timeEntryList, Map<String,String> invoicePDFMap) {
            
            this.invoiceId = i.id; 
            this.name = i.name;
            this.rateType = i.rate_type__c;
            this.parkingSpace = i.parking_space__c;
            this.parkingSpaceType = i.parking_space_type__c;
            this.parkingLot = i.parking_lot__c;
            this.note = i.note__c;
            if (i.createddate != null)
                this.monthInvoiced = string.valueOf(i.createddate.format());
            this.methodOfPayment = i.method_of_payment__c;
            this.msid = i.employee_id__c;
            if (i.date_paid__c != null)
                this.datepaid = string.valueOf(i.date_paid__c.format());
            if (i.amount_paid__c != null)
                this.amountPaid = i.amount_paid__c.format();
            this.currencyCode = i.currencyISOCode;
            if (i.amount_billed__c != null)
                this.amountBilled = i.amount_billed__c.format();
            this.status = i.status__c;
            this.timeEntryList = timeEntryList;
            
            if (i.balance_due__c != null)
                this.balanceDue = i.balance_due__c.format();
            if (invoicePDFMap != null){
                system.debug('looking for invoice ' + i.id);
                system.debug(invoicePDFmap);    
                if (invoicePDFMap.get(i.id) != null)
                    invoiceURL = System.Label.DG_BaseURL + '/servlet/servlet.FileDownload?file=' + invoicePDFMap.get(i.id);
                system.debug('invoice url:' + invoiceUrl);
            }
            if (i.hourly_fee__c != null)
                this.hourlyRate = i.hourly_fee__c.format();
            if (i.monthly_fee__c != null)
                this.monthlyRate = i.monthly_fee__c.format();
            
        }
    }
    
     public class timeDetail {
        
        public String resolved {get;set;}
        public String resolutionOutTime {get;set;}
        public String resolutionInTime {get;set;}
        public String resolutionDuration {get;set;}
        public String inTIme {get;set;}
        public String outTime {get;set;}
        public String duration {get;set;}
        public String disputed {get;set;}
        public String disputeComments {get;set;}
        public String resolutionComments {get;set;}
        public String defaultedTime {get;set;}
        public String invoiceId {get;set;}
        public String timeDetailId {get;set;}
        public String totalHourlyRate {get;set;}
        public String totalResolvedHourlyRate {get;set;}
        
        public timeDetail (Parking_Lot_Space_Assignment_Time_Used__c t){
            
            if (t.resolved__c)
                this.resolved = 'true';
            else
                this.resolved = 'false'; 
            
            this.defaultedTime = t.defaulted_time__c;
            
            this.timeDetailId = t.id;
            if (t.resolution_Out__c != null)
                this.resolutionOutTime = string.valueOf(t.resolution_Out__c.format());
            if (t.resolution_in__c != null)
                this.resolutionInTime = string.valueOf(t.resolution_in__c.format());
            
            this.resolutionDuration = t.resolution_duration__c;
            this.inTIme = string.valueOf(t.in__c.format());
            this.outTime = string.valueOf(t.out__c.format());
            this.duration = t.duration_text__c;
            if (t.disputed__c)
                this.disputed = 'true';
            else
                this.disputed = 'false';
                 
            this.disputeComments = t.dispute_comments__c; 
            this.resolutionComments = t.resolved_comments__c;
            
            if (t.total_hourly_rate__c != null)
                this.totalHourlyRate = t.total_hourly_rate__c.format();
                
            if (t.total_resolved_hourly_rate__c != null)
                this.totalResolvedHourlyRate = t.total_resolved_hourly_rate__c.format();
        }
     }
        
      public class passes {
        public myPass parkingPass {get;set;}
        public List<myPass> relatedPasses {get;set;}
        
        
        public passes(myPass p, List<myPass> relatedPasses){
            this.parkingPass = p;
            this.relatedPasses = relatedPasses;
        }
    }
    
    public class MyPass {
        public string id {get;set;}
        public string name {get;set;}
        public string location {get;set;}
        public string locationId {get;Set;}
        public String rtype {get;set;}
        public String status {get;set;}
        public String rateType {get;set;}
        public String paymentMethod {get;set;}
        public String highRoof {get;set;}
        public String companyCar {get;set;}
        public String disabled {get;set;}
        public String assignedSpace {get;set;}
        public String displayPassId {get;set;}
        public String reasonForDelay {get;set;}
        public List<GP_JSON.passVehicle> passVehicles {get;set;}
        public String startDate {get;set;}
        public String spaceName {get;set;}
        public String replacementCurrencyCode {get;set;}
        public String replacementAmount {get;set;}
        public String type {get;set;}
        public String nbrOfPassesAhead {get;set;}
        public String expectantMother {get;set;} 
        public String endDate {get;set;}
        public String currentParkingPassId {get;set;}
        public String garageName {get;set;}
        public String rejectReasonDesc {get;set;}
        public String actualCancellationDate {get;set;}
        public String declFormGenerated {get;set;}
        public String declFormSigned {get;set;}
        public String enrollmentPaymentMethod {get;set;}
        public String parkingCardId {get;set;}
        
        /*
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
           // , p.Handicap_Access_Required__c
            , p.CreatedDate
            , p.CreatedById
            , p.Cancellation_Reason__c
            , p.Assigned_Space_Requested__c 
        */ 
        public MyPass(Parking_Lot_Request__c r, Map<String,Map<String,String>> vehicleRequestMap
        , List<GP_JSON.passVehicle> passVehicles, String displayPassId
        , String spaceName, Parking_Lot_Space_Assignment__c sa){
            this.id = r.id; 
            
            system.debug('***** vehicle request Map is:         ' + vehicleRequestMap   );
            
            if (vehicleRequestMap != null)
                if (vehicleRequestMap.get(r.vehicle_type__c) != null)
                    if (vehicleRequestMap.get(r.vehicle_type__c).get(r.id) != null)
                        this.nbrOfPassesAhead = string.valueOf(vehicleRequestMap.get(r.vehicle_type__c).get(r.id));

            this.garageName = r.parking_lot__r.name;
            this.name = r.name;
            this.locationId = r.parking_lot_region__c;
            this.location = r.Parking_Lot_Region__r.name;
            this.rejectReasonDesc = r.reject_reason_desc__c;
            this.rtype = r.type__c; 
            if (r.end_date__c != null)
                this.endDate = string.valueOf(r.end_date__c.format());
             
            this.status = r.status__c;
            this.rateType = r.rate_type__c;
            this.paymentMethod = r.method_of_payment__c;
            this.reasonForDelay = r.reason_for_delay__c;
            this.parkingCardId = r.parking_card_id__c;

            if (r.actual_start_date__c == null)
                this.startDate = string.valueOf(r.start_date__c.format());
            else
                this.startDate = string.valueOf(r.actual_start_date__c.format());
                
            if (r.actual_cancellation_date__c != null)
                this.actualCancellationDate = string.valueOf(r.actual_cancellation_date__c.format());
            this.displayPassId = displayPassId;
            this.spaceName = spaceName;
            if (r.expectant_mother__c)
                this.expectantMother = 'true';
            else
                this.expectantMother = 'false';  
            
            if (sa <> null){
                if (sa.declaration_form_generated_new_pass__c)
                    this.declFormGenerated = 'true';
                else
                    this.declFormGenerated = 'false';
            
                if (sa.declaration_form_signed_new_pass__c)
                    this.declFormSigned = 'true';
                else
                    this.declFormSigned = 'false';
            }
            
            this.enrollmentPaymentMethod = r.Enrollment_Period_Payment_Method__c;
             
            if (r.company_car__c)
                this.companyCar = 'true';
            else
                this.companyCar = 'false';
                
            if (r.type__c == 'Replacement Pass' && r.vehicle_type__c == 'Car' && r.status__c == 'Assigned') {
                GP_JSON.price result = GP_ServiceHelper.lookupPrice(r.id,r.vehicle_type__c, r.requestee_global_parking_level__c, r.parking_lot_region__c, r.rate_type__c);
                this.replacementCurrencyCode = result.currencyCode; 
                this.replacementAmount = result.replacementAmount;
            }  
        
            if (r.high_roof__c)
                this.highRoof = 'true';
            else
                this.highRoof = 'false';
            /*
            if (r.handicap_access_required__c == 'true')
                this.disabled = 'true';
            else
                this.disabled  = 'false'; 
            */
            if (r.parking_lot__r.Space_Assignment__c == 'Assigned Space')
                this.assignedSpace = 'true';
            else
                this.assignedSpace  = 'false'; 
                
            this.passVehicles = passVehicles;
            this.type = r.vehicle_type__c;
            
            this.currentParkingPassId = r.current_parking_pass_id__c;
        }
    }
    
    public class inputRequestId{
        public string requestId;
        public string referrerUrl; 
    }
    
    public class docSignURL{
        public string docSignURL; 
        public string signed;
        public docSignURL (String url, Boolean signed){
            this.docSignURL = url;
            if (signed)
                this.signed = 'true';
            else
                this.signed = 'false'; 
            
        }
    }
  
    public class inputmsid{
        public string msid;
    }
    
    public class requestId{
        public string requestId;
        
        public requestId (String id){
            this.requestId = id;
        }
    }
    
    public class requestIdWithName{
        public string requestId;
        public string name;
        
        public requestIdWithName (String id, String name){
            this.requestId = id;
            this.name = name;
        }
    }
  
  
    public class inputLocationId{
        public string locationId;
    }
  
    public class resultId {
        public String id {get;set;}
        
        public resultId (String id) {
            this.id = id;
        }
    }
    
    
 
  
    public class SearchTermWrapper{
        public string searchTerm;
    }
    
    public class searchResult {
        public String msid { get; set; }
        public String displayName {get;set;}
        
        public searchResult (String msid, String name) {
            this.msid = msid;
            this.displayName = name;
        }
    }
    
    public class requestIdWithMSID {
        public string msid;
        public string requestId;
    }
}