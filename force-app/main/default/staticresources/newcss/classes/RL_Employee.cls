/*************************************************************************
* MRM - 5/7/14 Created Page
* 
*   This controller supports the employee facing Reference Letter request 
*   page.
*
* Change log:
* 04/27/2015 - changed requestorEmp and requesteeEmp fields to have value of
*      region_dsc contain value from Custom setting, but not of Cost Center
* 
* 05/14/2015 - Avinash-In setLayoutFlag method, lettersection1 added
*         "showRecipientNameAndAddressFlag = true;"
* 06/19/2015 - Avinash Munaga - Change in all excpetion blocks to redirect
*                       to Sys_Excpetion page.
* 
*04/25/2018 -Saurabh Pandey Added new instruction for APEC Business visa letter 
*ALM 318 "showAPECBusinesstravel"
****************************************************************************/
public without sharing class RL_Employee { 
    
    public String getIncludeBaseSalary() {
        return null;
    }
/******************Added by Abhijeet on 30/08/2016 to display options in the radio button Visa Type ******/
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Single','Single'));
        options.add(new SelectOption('Multiple','Multiple'));
        return options;
    }

    
    Public List<String> Addmember{get;set;}
    Public Integer Count{get;set;}
    public String success{get;set;}
    public Boolean successLoad{get;set;}
    public Boolean bodySection{get;set;}
    Public string BusinessVisaInstruction{get;set;}
    
    public PageReference AddMore() {
        Count += 1;
        
        if(Count > 9){
            addMoreCount = true;
        }
        return null;
        
    }    
    public PageReference AddMore1() {
        Count += 1;
        
        if(Count > 9){
            addMoreCount1 = true;
        }
        return null;
        
    } 
    
    public User u {get;set;}
    public Reference_Letter_Request__c r {get;set;}
    public Boolean addMoreCount {get;set;}
    public Boolean addMoreCount1 {get;set;}
    public Boolean showEmployeeLookup {get;set;}      // Employee Lookup for Internal Letters - Only Active Employees
    public Boolean forExternalLetter {get; set;}      // Employee Lookup for External Letters - All Employees
    public Boolean showRequestor {get;set;}
    public Boolean showRequestee {get;set;}
    public Boolean showEmpId {get;set;}
    public Boolean showInitMsg {get;set;}
    public Boolean showMain {get;set;}
    public Boolean showLetterSelection {get;set;}
    public boolean disblebutton{get;set;}
    public Boolean showPassportFlag {get;set;}
    public Boolean showRecipientNameAndAddressFlag {get;set;}
    public Boolean showAPECBusinesstravel{get;set;}
    public Boolean showAPACSLA {get;set;}
    public Boolean showEMEASLA {get;set;}
    
    public List<Reference_Letter_Request__c> requestList {get;set;}
    
    /* one for each pagelayout */
    public Boolean showLetterSection1 {get;set;}
    public Boolean showLetterSection2 {get;set;}
    public Boolean showLetterSection3 {get;set;}
    public Boolean showLetterSection4 {get;set;}
    public Boolean showLetterSection5 {get;set;}
    public Boolean showLetterSection6 {get;set;}
    public Boolean showLetterSection7 {get;set;}
    public Boolean showLetterSection8 {get;set;}
    public Boolean showLetterSection9 {get;set;}
    public Boolean showLetterSection10 {get;set;}
    public Boolean showRentalAppLetterSection {get;set;}
    public Boolean showHRLetterSection{get; set;}
    public Boolean showIndiaMobileLetterSection {get; set;}
        public Boolean showBankAccountLetterSection {get; set;}    
    
    public String selectedLetterId {get;set;}
    
    public Employee__c requestorEmp {get;set;}   //requestor
    public Employee__c requesteeEmp {get;set;}   //requestee
    
    //variables used only in EMEA templates - START
    public Boolean addresseTitle {get; set;}
    public Boolean addresseName {get; set;}
    public Boolean addresseSName {get; set;}
    public Boolean companyName {get; set;}
    public Boolean compensationInfo {get; set;}
    public Boolean bankName {get; set;}
    public Boolean addressLine1 {get; set;}
    public Boolean addressLine2 {get; set;}
    public Boolean addressLine3 {get; set;}
    public Boolean addressLine4 {get; set;}
    public Boolean postalCode {get; set;}
    public Boolean prevAddressLine1 {get; set;}
    public Boolean prevAddressLine2 {get; set;}
    public Boolean prevAddressLine3 {get; set;}
    public Boolean prevAddressLine4 {get; set;}
    public Boolean prevPostalCode {get; set;}
    public Boolean destination {get; set;}
    public Boolean dateOfTravel {get; set;}
    public Boolean returnData {get; set;}
    public Boolean nationality {get; set;}
    public Boolean passportNumber {get; set;}
    public Boolean passportCountry {get; set;}
    public Boolean passportExpiryDate {get; set;}
    public Boolean embassy {get; set;}
    public Boolean invitingOrg {get; set;}
    public Boolean includeSalary {get; set;}
    public Boolean concerned{get; set;}
    public Boolean typeOfVisa {get;set;}
    public Boolean validityPeriod {get;set;}
    public Boolean national {get;set;}
    
    public Boolean isContingent {get;set;}
    public Boolean isNA {get;set;}
    public Boolean urgentValidation {get; set;}
    public Boolean urgentHRRequest {get; set;}
    
    //variables used only in EMEA templates - END
    
    public String regiondesc{get;set;}
    public boolean Button1{get;set;}
    public Boolean duration {get;set;}
    public Boolean start_Date {get;set;}
    public Boolean end_Date {get;set;}
    
    // Asia-HR and EMEA-HR variables
    // used to check if the person logged in in part of HR groups
    public boolean asiaHR{get;set;}
    public Boolean emeaHR {get; set;}
    
    public Boolean businessLetterIND {get; set;}
    public Boolean visaLetterAsia {get; set;}
    
    //Variables used for Duration Validation
    public List<SelectOption> durationDayOptions {get;set;}  
    public List<SelectOption> durationMonthOptions {get;set;}  
    public List<SelectOption> durationWeekOptions {get;set;}
    public List<SelectOption> durationYearOptions {get;set;}
    public List<SelectOption> compensationInfoOptions {get;set;}
    public Boolean showDurationErrMsg {get;set;}
    public String showInstance{get;set;}
    public Boolean errorMsg{get;set;}
    
    public String requestStatus {get; set;}
    
    public List<RL_QuickLinks__c> quickLinks{get; set;}
    
    public Boolean exeption {get; set;}
    public String exceptionValue {get; set;}
    
    // use for encrypted fields
    public String baseSalary {get;set;}
    public String indBasicSalary {get;set;}
    
    // added by Avinash Munaga
    public String empRegionDesc {get; set;}
    public Boolean current_showNationalID {get; set;}
    public Boolean business_showNationalID {get; set;}
    public Boolean personal_showNationalID {get; set;}
    
    /*****************************************************************
    * Constructor
    *
    ******************************************************************/
    public RL_Employee(){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=11,9');
        
        bodySection = true;
        
        successLoad = false;
        exeption = false;
        exceptionValue = '';
        businessLetterIND = false;
        visaLetterAsia = false;
        
        asiaHR = false;
        emeaHR = false;
        
        //for success message 
        if(ApexPages.currentPage().getParameters().get('successLoad') != NULL){
            successLoad = true;
        } else if(ApexPages.currentPage().getParameters().get('exception') != NULL) {
            // added to catch and display exception details on page
            exceptionValue = ApexPages.currentPage().getParameters().get('value');
            
            if(exceptionValue != 'ValidationError'){
                exeption = true;
            }
        }
        System.debug('HR Vlaue ' +System.Label.RL_HR_VALUE);
        
        // get values from 'PreHired Terminated HR' Custom Setting and put in list - start
        // added by Avinash
        Map<String, Perhired_Terminated_HR__c> PerhiredHR = Perhired_Terminated_HR__c.getAll(); 
        List<String> perHiredHrList=new List<String>();
        for(Perhired_Terminated_HR__c r:PerhiredHR.values()) {
            perHiredHrList.add(r.name);
        }
        // get values from 'PreHired Terminated HR' Custom Setting and put in list - end
        
        //added by sanjib for group
        List<Group> userinGroup = getGroups();
        
        // per-hired/terminated hr
        for (Group g : userinGroup){
            for(String s : perHiredHrList){
                if(s == g.DeveloperName){
                    asiaHR = true;
                    break;
                }
            }
        }
        
        // get values from 'RL EMEA HR Groups' Custom Setting and put in list - start
        // added by Avinash
        emeaHR = validateEMEAHR();
        // get values from 'RL EMEA HR Groups' Custom Setting and put in list - end
        
        
        String urlVal = System.Label.ORG_ENVIRONMENT;
        // System.debug('Page URL: ' + urlVal);
        //if(!urlVal.contains('PROD') && !urlVal.contains('prod')){
            // showInstance = 'DEV';
        showInstance = urlVal;
        /*} else if(urlVal.contains('qa')) {
            showInstance = 'QA';
        } else if(urlVal.contains('uat')) {
            showInstance = 'UAT';
        }*/
        
        Count=1;
        disblebutton=true;
        
        u = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
        system.debug('-------------u---------------'+u);
        system.debug('----------------u----------'+u.Emp_Id__c);
        /* find the employee id for example 59XYZ */
        try{
            requestorEmp = [select id,emp_id__c, gender_dsc__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c, Status__c
                            , Country_Dsc_Home__c, CC_Region_Org__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c, Birth_Date__c
                            , Job_Country_Job__c,Empl_Class_Job__c,Empl_Class_Dsc_Job__c,Employee_Sub_Class__c, Email__c,Is_HR_Partner__c, Job_Region_Code__c
                            , Base_Annual_Amount__c, IND_Basic_Salary_Amount__c from employee__c where emp_id__c = :u.Emp_id__c];
            
            system.debug('--------request-------'+requestorEmp);
            system.debug('--------request-------'+u.Emp_id__c);
            
            // to show/ hide I Agree button
            // Regiondesc = requestorEmp.CC_Region_Org__c;
            if(requestorEmp != null) {
                regiondesc = requestorEmp.Job_Region_Code__c;
                        
                if(regiondesc == 'NA'){
                    Button1 = false;
                } else {
                    Button1 = true;
                }
                
                //added by Avinash Munaga
                // Emp Region Desc updated based on the value from Job_region_Code__C from Employee object
                Region_Code_Desc_Mapping__c code = Region_Code_Desc_Mapping__c.getValues(regiondesc);
                if(code != null) {
                    empRegionDesc = code.Region_Description__c;
                    requestorEmp.Region_Dsc_Org__c = empRegionDesc;
                }
                
                // Checking whether employee is contingent
                //added by sanjib
                if(requestorEmp.Empl_Class_Job__c=='A' || requestorEmp.Empl_Class_Job__c=='I' || requestorEmp.Empl_Class_Job__c=='U'
                   || (requestorEmp.Empl_Class_Job__c=='C' && requestorEmp.Employee_Sub_Class__c=='R')) {
                       isContingent=false;
                   } else {
                       system.debug('****************'+isContingent);
                       isContingent=true;
                   }
                
                // to show NA user Disclaimer for the user
                isNA = false;
                if(requestorEmp.get('Job_Region_Code__c') == 'NJ' || requestorEmp.get('Job_Region_Code__c')== 'JA'){
                    showAPACSLA = true;
                    showEMEASLA = false;
                } else if(requestorEmp.get('Job_Region_Code__c')== 'EU') {
                    showAPACSLA = false;
                    showEMEASLA = true;
                } else {
                    showAPACSLA = false;
                    showEMEASLA = false;
                    isNA = true;
                    isContingent = false;
                }
            }
        } catch(Exception e){
            System.debug('Exception in requestorEmp' + e);
        }
        
        String rId = ApexPages.currentPage().getParameters().get('id');
        String success = ApexPages.currentPage().getParameters().get('success');
        
        
        if (rId == null){
            r = new Reference_Letter_Request__c();
        }else{                    
            r = [select Id,Name, reference_letter__c,Reference_letter_name__c,requesting_employee__c ,Destination__c,Date_of_Travel__c,Return_Date__c,
                 Include_Family_Members__c,Name_of_the_Person__c, Relationship__c,Court_Date__c,Reason_for_Exemption__c,Duration_in_Day__c,
                 Duration_in_Week__c,Duration_in_Month__c,Duration_in_Year__c, requesting_employee__r.name,workflow__c,for_employee__c,
                 for_employee__r.name,Urgent_HR_Request__c,Compensation_Information__c,Nationality__c from Reference_Letter_Request__c where id = :rId ];
        }
        system.debug('-----------Refernece letter---------'+r.Reference_Letter__c); 
                
        r.number_of_copies__c = '1';
        r.Address_by_Reference__c = 'Name and Address';
        
        showEmployeeLookUp = false;
        forExternalLetter = false;
        showInitMsg= true;
        showMain = true;
        requesteeEmp = requestorEmp;
        showEmpId = true;
        addMoreCount = false;
        showRequestor = true;
        showRequestee = false;
        
        //urgent request population
        Map<String, Urgent_Request__c> UrgentApprovers = Urgent_Request__c.getAll(); 
        list<String> urgentapproverList=new list<String>();
        for(Urgent_Request__c r:UrgentApprovers.values()) {
            urgentapproverList.add(r.name);
        }
        
        //check if the user in the urgent group
        for (Group g : userinGroup){
            for(String S:urgentapproverList){
                if(s==g.DeveloperName){
                    system.debug('in side if');
                    urgentValidation = true;
                }
            }
        }
        System.debug('@@@@@@'+requestorEmp);
        String query = 'Select name, Reference_Letter__c, For_Employee__c, For_Employee__r.name , Requesting_Employee__c,'
            + ' Requesting_Employee__r.name, Id, CreatedDate,Empl_Class_Dsc_Job__c, status__c, Reference_Letter__r.name,'
            + ' All_Employees__r.name From Reference_Letter_Request__c where (requesting_employee__c = \'' + requestorEmp.id
            + '\' OR (For_Employee__c=\'' + requestorEmp.id
            + '\' and HR_Request__c = false)) AND Status__C!=\'Created\' order by createdDate desc LIMIT 20';
        try{
            requestList = Database.query(query);
        } catch(Exception e){
            System.debug('Exception in requestList ' + e);
        }
        
        // for showing only Another Employee to Contingent worker/ North America Employee in Request Letter for
        if(isContingent || requestorEmp.get('Job_Region_Code__c') == 'NA'){
            r.Request_For__c = 'Another Employee';
            r.Reference_Letter__c= null;
            
            showRequestor = false;
            showRequestee = true;
            showEmployeeLookup = true;
            forExternalLetter = false;
            requesteeEmp = new Employee__c();
            showEmpId = false;
            disblebutton = true;
        } else {
            r.Request_For__c = 'Myself';
        }
         
        Cont_Eork_type__c contWrkType = Cont_Eork_type__c.getValues(r.poi_type__c);
        if(contWrkType !=null){
            ContingenwrkType = contWrkType.Contigent_Work_code__c;
        } 
        
        System.debug('Request for:::' + r.request_for__c + '  ** Letter : ' + r.Reference_Letter__c);
        
        //To remove None for Duration Fields
        durationDayOptions = new List<SelectOption>();
        durationMonthOptions = new List<SelectOption>();
        durationWeekOptions  = new List<SelectOption>();
        durationYearOptions = new List<SelectOption>();
        compensationInfoOptions = new List<SelectOption>();
        
        // Use DescribeFieldResult object to retrieve Duration Day field.
        Schema.DescribeFieldResult durationDayFieldDescription = Reference_Letter_Request__c.Duration_in_Day__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry : durationDayFieldDescription.getPicklistValues()){
            durationDayOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }   
        // Use DescribeFieldResult object to retrieve Duration Month field.
        Schema.DescribeFieldResult durationMonthFieldDescription = Reference_Letter_Request__c.Duration_in_Month__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry : durationMonthFieldDescription.getPicklistValues()){
            durationMonthOptions.add(new SelectOption(pickListEntry.getLabel(),pickListEntry.getLabel()));
        }  
        // Use DescribeFieldResult object to retrieve Duration Week field. 
        Schema.DescribeFieldResult durationWeekFieldDescription = Reference_Letter_Request__c.Duration_in_Week__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry : durationWeekFieldDescription.getPicklistValues()){
            durationWeekOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }  
        // Use DescribeFieldResult object to retrieve Duration Year field.
        Schema.DescribeFieldResult durationYearFieldDescription = Reference_Letter_Request__c.Duration_in_Year__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry : durationYearFieldDescription.getPicklistValues()){
            durationYearOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }    
        
        // Use DescribeFieldResult object to retrieve Compensation Info field.
        Schema.DescribeFieldResult compensationInfoFieldDesc = Reference_Letter_Request__c.Compensation_Information__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry : compensationInfoFieldDesc.getPicklistValues()){
            compensationInfoOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        
        // to display Quick Links
        Map<String, RL_QuickLinks__c> links = RL_QuickLinks__c.getAll();
        quickLinks = links.values();
    }
    
    public boolean showcontingent{get;set;}
    Public String ContingenwrkType{get;set;}
    
    /*****************************************************************
    * Set Flag1 Action function
    *  
    ******************************************************************/
    public void setFlag1(){
        // system.debug('selected value is:' + r.request_for__c);
        showInitMsg = false;
        
        businessLetterIND = false;
        successLoad = false;
        exeption = false;
        exceptionValue = '';
        
        // to hide the letter section and reset the page
        resetSections();
        
        disblebutton = true;
        r.Number_of_Copies__c = '' + 1;
        
        r.For_Employee__c = null;
        r.All_Employees__c = null;
        r.Reference_Letter__c = null;
        // for hiding the letter section and reset the page
        
        if (r.request_for__c == 'Myself'){
            System.debug('Request for:::' + r.request_for__c + 'Letter : ' + r.Reference_Letter__c);    
            showEmployeeLookup = false;
            forExternalLetter = false;
            showRequestor = true;
            showRequestee = false;
            showMain = true;
            showLetterSelection = true;
            requesteeEmp = requestorEmp;
            showEmpId = true;
            
            // for urgent HR request
            if(showEmpId && urgentValidation){
                urgentHRRequest = true;
            } else {
                urgentHRRequest = false;
            }
        } else if (r.request_for__c == 'Another Employee'){
            System.debug('Request for:::' + r.request_for__c + 'Letter : ' + r.Reference_Letter__c);   
            
            showRequestor = false;
            showRequestee = true;
            
            requesteeEmp = new Employee__c();
            showEmpId = false;
            
            // will show employee lookup which is satisfying the condition for all the employees
            system.debug('requestorEmp.Job_Region_Code__c: ' + requestorEmp.get('Job_Region_Code__c'));
            system.debug('emeaHR: ' + emeaHR);
            system.debug('requestorEmp.Dept_Org__c: ' + requestorEmp.Dept_Org__c);
            /*if(requestorEmp.get('CC_Region_Org__c') == 'EU' && emeaHR && requestorEmp.Dept_Org__c == System.Label.RL_HR_VALUE) {
                showEmployeeLookup = false;
                forExternalLetter = true;
            } else {*/
                showEmployeeLookup = true;
                forExternalLetter = false;
            //}
            
        } else if(r.request_for__c=='Terminated') {
            showRequestor = false;
            showRequestee = true;
            showEmployeeLookup = false;
            forExternalLetter = true;
            requesteeEmp = new Employee__c();
            showEmpId = false;
        }
    }
    
    /*****************************************************************
    * Set Flag2 Action function
    *  
    ******************************************************************/
    public PageReference setFlag2(){
        system.debug('for employee is:' + r.for_Employee__c);
        if(r.for_Employee__c != null || r.All_Employees__c != null){
            resetSections();
            disblebutton = true;
            successLoad=false;
            exeption = false;
            exceptionValue = '';
            r.Reference_Letter__c = null;
            
            if (r.request_for__c == 'Myself'){
                showEmployeeLookup = false;
                forExternalLetter = false;
                showRequestor = true;
                showRequestee = false;
                showInitMsg=false;
                showLetterSelection = true;
                showEmpId = false;
            } else {
                try {
                    /*if ((requestorEmp.CC_Region_Org__c == 'EU' && emeaHR && requestorEmp.Dept_Org__c == System.Label.RL_HR_VALUE
                         && r.request_for__c == 'Another Employee') || r.request_for__c == 'Pre Hired/Terminated') {*/
                    if (r.request_for__c == 'Terminated'){
                        system.debug('all_employees__c : ' + r.All_Employees__c);
                        requesteeEmp = [select emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c
                                , Job_Title__c, Gender_Dsc__c, Division_Org__c, Super_Division__c, Country_Dsc_Home__c
                                , CC_Region_Org__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c
                                , Birth_Date__c, Subdept_Org__c,Empl_Class_Dsc_Job__c, Job_Country_Job__c, Email__C,Is_HR_Partner__c
                                , Status__c, Job_Region_Code__c, Base_Annual_Amount__c, IND_Basic_Salary_Amount__c from employee__c 
                                where id = :r.All_Employees__c];
                    } else if (r.request_for__c == 'Another Employee') {
                        requesteeEmp = [select emp_id__c,name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c
                                , Job_Title__c, Gender_Dsc__c, Division_Org__c, Super_Division__c, Country_Dsc_Home__c
                                , CC_Region_Org__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c
                                , Birth_Date__c, Subdept_Org__c,Empl_Class_Dsc_Job__c, Job_Country_Job__c, Email__C,Is_HR_Partner__c
                                , Status__c, Job_Region_Code__c, Base_Annual_Amount__c, IND_Basic_Salary_Amount__c from employee__c 
                                where id = :r.For_Employee__c];
                    }
                    system.debug('**** Base Amount' + requesteeEmp.base_annual_amount__c);
                } catch(DmlException e){
                    system.debug('Employee not found:' + e);
            
                    // Date: 06/19/2015
                    string devInfo = 'RL_Home Page: Error in the requestee details';
                    String url = '/apex/RL_Sys_Exception' + '?e=' + e + '&devInfo=' + devInfo + '&lineNum=' + e.getLineNumber();
                    PageReference p = new PageReference(url);
                    p.setRedirect(true);
                    return p;
                }
                
                //added by Avinash Munaga
                // Emp Region Desc updated based on the value from Job_region_Code__C from Employee object
                if(requesteeEmp != null) {
                    Region_Code_Desc_Mapping__c code = Region_Code_Desc_Mapping__c.getValues(requesteeEmp.Job_Region_Code__c);
                    if(code != null) {
                        empRegionDesc = code.Region_Description__c;
                        requesteeEmp.Region_Dsc_Org__c = empRegionDesc;
                    }
                }
                
                showRequestor = false;
                showRequestee = true;
                showInitMsg = false;
                showLetterSelection = false;
                
                /* if letter type is a certaint type show that section
                    default for testing is letter section 1 */
                showLetterSection1 = false;
                showEmpId = true;
                
                // for urgent HR request
                if(showEmpId && urgentValidation){
                    urgentHRRequest = true;
                } else {
                    urgentHRRequest = false;
                }
                system.debug('urgentHRRequest: ' + urgentHRRequest);
            }
        }
        return null;
    }
    
    public Boolean showPersonalVisaLetter {set;get;}
    public Boolean showHKExemptfromJuryDuty {set;get;}
    public Boolean showBusinessVisaLetter {set;get;}
    public Boolean showHKSMEVisaAppLetter {set;get;}
    public Boolean showMSTravelInsCoverNote {set;get;}
    public Boolean NameRelationship {set;get;}
    public Boolean BusinessVisaIsPassPortNo {set;get;}
    
    /*****************************************************************
    * Show Name & Relationship Fields based on 'Are there other family members to be included in the visa application?'
    * checkbox - action Support to choose Fields to display
    * 
    ******************************************************************/        
    public PageReference setFlagToNameRelationship(){
        if(r.Include_Family_Members__c == true){
            NameRelationship = true;
            System.debug('This is NameRelationship True Value - ' + NameRelationship);
        }else{ 
            NameRelationship = false;
            System.debug('This is NameRelationship False Value - ' + NameRelationship);                
        }
        return null;
    }       
    
    public Boolean businessPassportInd {get; set;}
    public PageReference FlagToBusinessVisaIsPassPortNo(){
        system.debug('---------------------'+r.Include_Passport_Number__c);        
        if(r.Include_Passport_Number__c){
            BusinessVisaIsPassPortNo = true;
            if(requesteeEmp.Job_Country_Job__c == 'IND') {
                businessPassportInd = true;
            } else {
                businessPassportInd = false;
            }
        }else{ 
            BusinessVisaIsPassPortNo = false;
        }
        return null;
    }
    
    /*****************************************************************
    * Show Name of recipient & Recipient Address Fields based on 'The recipient below' checkbox - action Support to choose
    * Fields to display
    *
    ******************************************************************/
    public Boolean TheRecipientBelow {set;get;}
    public PageReference FlagToTheRecipientBelow(){
        if(r.The_recipient_below__c == true){
            TheRecipientBelow  = true;
            r.To_whom_it_may_concern__c = false;
            System.debug('This is BusinessVisaIsPassPortNo True Value - ' + TheRecipientBelow );
        }else{ 
            TheRecipientBelow  = false;
            System.debug('This is TheRecipientBelow False Value - ' + TheRecipientBelow );                
        }
        return null;
    } 
    
    /*****************************************************************
    * Show Dependent Name Fields based on 'Are there any accompanying dependents to be included in this Cover Note?'
    * checkbox - action Support to choose Fields to display
    * 
    ******************************************************************/
    public Boolean IncludedInThisCoverNote {set;get;}
    public PageReference FlagToIncludedInThisCoverNote(){
        if(r.Include_Family_Members__c == true){
            IncludedInThisCoverNote  = true;
            System.debug('This is BusinessVisaIsPassPortNo True Value - ' + IncludedInThisCoverNote );
        }else{ 
            IncludedInThisCoverNote = false;
            System.debug('This is IncludedInThisCoverNote False Value - ' + IncludedInThisCoverNote );                
        }
        return null;
    } 
    
    /*****************************************************************
    * Show Name of recipient & Recipient Address Fields based on below checkboxes -
    * 'Salary information to include: Employees Current Base Salary' checkbox - action Support to choose
    * 'The Employee's total reward for the last financial year' checkbox - action Support to choose
    * 'To whom it may concern' checkbox - action Support to choose
    * Fields to display
    * 
    ******************************************************************/
    public Boolean DisableTowhomitmayconcern {set;get;}
    public PageReference FlagToIncludedBasSalaryRentApp(){
            if(r.Include_Current_Base_Salary__c==true || r.Include_Total_Compensation__c==true){
            TheRecipientBelow = true;
            r.The_recipient_below__c = true;
            DisableTowhomitmayconcern= true;
            r.To_whom_it_may_concern__c = false;
        }else{
            TheRecipientBelow = false;
            r.The_recipient_below__c = false;   
            DisableTowhomitmayconcern= false;
        } 
        if(r.To_whom_it_may_concern__c==true){
            r.The_recipient_below__c = false;
            TheRecipientBelow = false;
            DisableTowhomitmayconcern= false;
            r.Receipient_Name__c=null;
            r.Recipient_Address__c =null;
        }
        
        return null;
    }
    
    /******************************************************
    *
    * to show recipiet Name and Address in rental letter
    * added by Avinash Munaga
    *
    ******************************************************/    
    public void includeBaseSalary(){
        if(r.Include_Current_Base_Salary__c == true || r.Include_Total_Compensation__c == true){
            r.Address_Letter_To__c = 'Specify Name/Address';
            TheRecipientBelow = true;
            showRecipientNameAndAddressFlag = true;
        } else {
            r.Address_Letter_To__c = 'Whom It May Concern';
            TheRecipientBelow = false;
            showRecipientNameAndAddressFlag = false;
        }
    }
    public void showRecipientDetails() {
        if(r.Address_Letter_To__c == 'Specify Name/Address'){
            showRecipientNameAndAddressFlag = true;
        } else {
            showRecipientNameAndAddressFlag = false;
        }
    }
    
    public Boolean showRecipientFlag{get; set;}
    public Boolean fullTerm {get; set;}
    public void showRecipient(){
        if(r.Address_Letter_To__c == 'Specify Name/Address'){
            showRecipientFlag = true;
        } else {
            showRecipientFlag =false;
        }
    }
    
    private void resetSections(){
        
        // fields to be shown in letters for EMEA - Start
        successLoad=false;
        exeption = false;
        exceptionValue = '';
        addresseTitle = false;
        addresseName = false;
        addresseSName = false;
        companyName = false;
        compensationInfo = false;
        bankName = false;
        addressLine1 = false;
        addressLine2 = false;
        addressLine3 = false;
        addressLine4 = false;
        postalCode = false;
        prevAddressLine1 = false;
        prevAddressLine2 = false;
        prevAddressLine3 = false;
        prevAddressLine4 = false;
        prevPostalCode = false;
        destination = false;
        dateOfTravel = false;
        returnData = false;
        nationality = false;
        passportNumber = false;
        passportCountry = false;
        passportExpiryDate = false;
        embassy = false;
        invitingOrg = false;
        includeSalary = false;
        concerned = false;
        typeOfVisa = false;
        validityPeriod = false;
        national = false;
        fullTerm = false;
        // fields to be shown in letters for EMEA - End
        
        // showLetterSelection = true;
        showLetterSection1 = false;
        showLetterSection2 = false;
        showLetterSection3 = false;
        showRecipientNameAndAddressFlag = false;
        showHRLetterSection = false;
        showRentalAppLetterSection = false;
        showPersonalVisaLetter = false;
        showHKExemptfromJuryDuty = false;
        showBusinessVisaLetter = false;
        showAPECBusinesstravel = false;
        showHKSMEVisaAppLetter = false;
        showMSTravelInsCoverNote = false;
        showIndiaMobileLetterSection = false;
        showBankAccountLetterSection = false;
        
        resetFields();
    }
    
    private void resetFields(){
        // fields to hide : rerender on selecting checkbox/ picklist - start
        NameRelationship = false;
        BusinessVisaIsPassPortNo = false;
        TheRecipientBelow  = false;
        IncludedInThisCoverNote = false;
        TheRecipientBelow = false;
        DisableTowhomitmayconcern= false;
        showRecipientNameAndAddressFlag = false;
        showRecipientFlag = false;
        showPassportFlag = false;
        invitingOrg = false;
        dateOfTravel = false;
        returnData = false;
        validityPeriod = false;
        national = false;
        addresseTitle = false;
        addresseName = false;
        addresseSName = false;
        fullTerm = false;
        urgentHRRequest = false;
        showEmpId = false;
        businessPassportInd = false;
        // fields to hide : rerender on selecting checkbox/ picklist - start
        
        // used in business visa application - asia
        duration = false;
        start_Date = false;
        end_Date = false;
        
        businessLetterIND = false;
        successLoad = false;
        exeption = false;
        exceptionValue = '';
        
        current_showNationalID = false;
        business_showNationalID = false;
        personal_showNationalID = false;
        
        RL_Validate validate = new RL_Validate();
        validate.resetFields(r);
    }
    
    public void setDurationFlag(){
        duration = false;
        start_Date = false;
        end_Date = false;
        
        if(requestorEmp.Job_Country_Job__c != 'IND') {
            duration = true;
            start_Date = false;
            end_Date = false;
        } else if(requestorEmp.Job_Country_Job__c == 'IND') {
            duration = false;
            start_Date = true;
            end_Date = true;
        }
    }
    
    /*****************************************************************
    * Show Letter Specific Field layouts - action function to choose
    * section to display
    *  
    ******************************************************************/
    public PageReference setLayoutFlag(){
        
        System.debug('Request for:::' + r.request_for__c + 'Letter : ' + r.Reference_Letter__c);
        showHRLetterSection = false;
        showLetterSelection = true;
        successLoad=false;
        exeption = false;
        exceptionValue = '';
        errorMsg = false;
        
        String temp;
        /*if(r.Request_For__c == 'Pre Hired/Terminated' || (requestorEmp.CC_Region_Org__c == 'EU' && emeaHR
                    && requestorEmp.Dept_Org__c == System.Label.RL_HR_VALUE && r.request_for__c == 'Another Employee')) {*/
        if(r.Request_For__c == 'Terminated'){
            temp = r.All_Employees__c;
        } else if(r.Request_For__c == 'Another Employee') {
            temp = r.For_Employee__c;
        }
        
        // reset fields and sections in letters
        resetSections();
        
        baseSalary = requesteeEmp.base_annual_amount__c;
        indBasicSalary = requesteeEmp.ind_basic_Salary_amount__c;
        
        if(showRequestee == true && temp == null){
            disblebutton = true;
        } else {
            disblebutton = false;
        }
        
        system.debug('*----****showMSTravelInsCoverNote***************'+showMSTravelInsCoverNote);        
        try{
           system.debug('----------------------'+r.reference_letter__c) ;
            Reference_Letter__c rl = [select name, reference_letter_code__c from Reference_Letter__c
                                      where id = :r.reference_letter__c];
            system.debug('****rl.reference_letter_code__c********'+rl.reference_letter_code__c); 
            
            if (rl.reference_letter_code__c == 'RL0001'){
                showLetterSection1 = true;
                if(requesteeEmp.Job_Country_Job__C == 'TWN'){
                    current_showNationalID = true;
                }
                
               
                
                
                //showRecipientNameAndAddressFlag = true;
            }           
            else if (rl.reference_letter_code__c == 'RL0002'){
                /*r.Duration_in_Day__c = 'Day(s)';
                r.Duration_in_Week__c = 'Week(s)';
                r.Duration_in_Year__c = 'Year(s)';*/
                
                if(requesteeEmp.Job_Country_Job__c == 'IND') {
                    businessLetterIND = true;
                    disblebutton = true;
                } else {
                    r.Duration_in_Month__c = 'Day(s)';
                    
                    showBusinessVisaLetter = true;
                    system.debug('Country: ' + requestorEmp.Job_Country_Job__c);
                    if(requesteeEmp.Job_Country_Job__c != 'IND') {
                        system.debug('1');
                        duration = true;
                        start_Date = false;
                        end_Date = false;
                    } else if(requesteeEmp.Job_Country_Job__c == 'IND') {
                        system.debug('2');
                        duration = false;
                        start_Date = true;
                        end_Date = true;
                    }
                }
                
                if(requesteeEmp.Job_Country_Job__C == 'TWN'){
                    business_showNationalID = true;
                }
                
                r.Visa_Type__c = 'Single';
            } else if (rl.reference_letter_code__c == 'RL0003'){
                showLetterSection3 = true;
                showAPECBusinesstravel = true;
                string BusinessVisaInstruction = System.label.RL_APEC_BVI;
            } else if(rl.reference_letter_code__c == 'RL0004'){
                showHRLetterSection = true;
                fullTerm = true;
            } else if(rl.reference_letter_code__c == 'RL0005'){
                showHRLetterSection = true;
            } else if(rl.reference_letter_code__c == 'RL0006'){
                showRentalAppLetterSection = true;
                //showRecipientNameAndAddressFlag = true;
            } else if(rl.reference_letter_code__c == 'RL0008'){
                r.Duration_in_Month__c = 'Day(s)';
                showHKSMEVisaAppLetter = true;
            } else if(rl.reference_letter_code__c == 'RL0009'){
                showPersonalVisaLetter = true;
                if(requesteeEmp.Job_Country_Job__C == 'TWN'){
                    personal_showNationalID = true;
                }
            } else if(rl.reference_letter_code__c == 'RL0010'){
                showHKExemptfromJuryDuty = true;
            } else if(rl.reference_letter_code__c == 'RL0015'){
                showMSTravelInsCoverNote = true;
            } else if(rl.reference_letter_code__c == 'RL0014') {
                showIndiaMobileLetterSection = true;
            } else if(rl.reference_letter_code__c == 'RL0016' || rl.reference_letter_code__c == 'RL0017'
                      || rl.reference_letter_code__c == 'RL0018' || rl.reference_letter_code__c == 'RL0019'
                      || rl.reference_letter_code__c == 'RL0020' || rl.reference_letter_code__c == 'RL0021') {
                          showLetterSection2 = true;
                          if(rl.reference_letter_code__c == 'RL0016' || rl.reference_letter_code__c == 'RL0018'){
                              includeSalary = true;
                              concerned= true;
                          }   
                          if(rl.reference_letter_code__c == 'RL0021'){
                              concerned= true;
                              compensationInfo = true;
                          }
                          if(rl.reference_letter_code__c == 'RL0016' || rl.reference_letter_code__c == 'RL0017'
                             || rl.reference_letter_code__c == 'RL0018' || rl.reference_letter_code__c == 'RL0021'){
                                 addresseTitle = true;
                                 addresseName = true;
                                 addresseSName = true;
                                 companyName = true;
                                 addressLine1 = true;
                                 addressLine2 = true;
                                 addressLine3 = true;
                                 addressLine4 = true;
                                 postalCode = true;
                             }
                          if(rl.reference_letter_code__c == 'RL0017'){
                              prevAddressLine1 = true;
                              prevAddressLine2 = true;
                              prevAddressLine3 = true;
                              prevAddressLine4 = true;
                              prevPostalCode = true;
                              bankName = true;
                              r.Company_Name__c = 'Morgan Stanley';
                          }
                          if(rl.reference_letter_code__c == 'RL0020'){
                              destination = true;
                              dateOfTravel = true;
                              returnData = true;
                              passportNumber = true;
                              embassy = true;
                              passportCountry = true;
                              /*addressLine1 = true;
                              addressLine2 = true;
                              addressLine3 = true;
                              addressLine4 = true;
                              postalCode = true;*/
                          }
                          if(rl.reference_letter_code__c == 'RL0019'){
                              nationality = true;
                              typeOfVisa = true;
                              destination = true;
                              passportNumber = true;
                              passportExpiryDate = true;
                              embassy = true;
                              /*addressLine1 = true;
                              addressLine2 = true;
                              addressLine3 = true;
                              addressLine4 = true;
                              postalCode = true;*/
                          }
                      }
                      else if(rl.reference_letter_code__c == 'RL0023') {
                showBankAccountLetterSection = true;
            }
        } catch (Exception e){
            disblebutton = true;
            System.debug('Exception e : ' + e);
            
            // Date: 06/19/2015
            string devInfo = 'RL_Home Page: Error in displaying letter input';
            PageReference p = new PageReference('/apex/RL_Sys_Exception' + '?e=' + e + '&devInfo=' + devInfo + '&lineNum=' + e.getLineNumber());
            p.setRedirect(true);
            return p;
        }
        r.Address_Letter_To__c = 'Whom it May Concern';
        r.Address_by_Reference__c = 'Name and Address';
        
        return null;
    }
    
    public void showInvitingOrg(){
            System.debug('letter code: ' + r.reference_letter__c);
        Reference_Letter__c rL = [select name, reference_letter_code__c from Reference_Letter__c
                                  where id = :r.reference_letter__c];
        if(rl.reference_letter_code__c == 'RL0019' && r.Destination__c == 'Russian Federation'){
            invitingOrg = true;
        } else {
            invitingOrg = false;
        }
    }
    
    /*****************************************************************
    * set Travel related information to true/ false
    *
    *****************************************************************/
    public void setJourneyFLag(){
        if(r.Type_of_Visa__c == 'Business Visa' || r.Type_of_Visa__c == 'Tourist Visa'){
            dateOfTravel = true;
            returnData = true;
            validityPeriod = false;
        } else if(r.Type_of_Visa__c == 'Double Entry Business Visa' || r.Type_of_Visa__c == 'Multiple Entry Business Visa'){
            dateOfTravel = false;
            returnData = false;
            validityPeriod = true;
        } else {
            dateOfTravel = false;
            returnData = false;
            validityPeriod = false;
        }
    }
    
    /*****************************************************************
    * Nationality Flag
    * Added by Avinash Munaga
    *
    *****************************************************************/
    public void setNationalityFlag(){
        if(r.Bank_Name__c == 'Barclays Bank Plc'){
            national = true;
        } else {
            national = false;
        }
    }
    
    // Added by Avinash Munaga
    // for hiding Title, Name depending on Address Referenced
    public void setAddresseFlag(){
        if(r.Address_by_Reference__c == 'Address Only'){
            addresseTitle = false;
            addresseName = false;
            addresseSName = false;
        } else {
            addresseTitle = true;
            addresseName = true;
            addresseSName = true;
        }
    }
    
    /*****************************************************************
    * Set the passport render flag
    * Added by Avinash Munaga
    *
    ******************************************************************/
    public void setPassportFlag(){
        showPassportFlag = r.include_passport_number__c;
    }
    
    /*****************************************************************
    * Show Letter Selection Action Function
    *  
    ***************************************************************** */
    public pageReference showLetterSelection(){
        
        showLetterSelection = true;
        return null;
        
    }
    
    /*****************************************************************
    * Save Button
    *  
    ******************************************************************/
    public pageReference save(){
        map<string,id> queuepopulation=new map<string,id>();
        string queueSObjectType='Reference_Letter_Request__c';   
        for (QueueSobject  q : [Select Id, q.Queue.Name,q.Queue.ID from QueueSobject q where q.SobjectType=:queueSObjectType ]) {
            queuepopulation.put(q.Queue.Name,q.Queue.ID);
        }
        if((r.Include_Current_Base_Salary__c == true || r.Include_Total_Compensation__c == true) && r.Address_Letter_To__c == ' Whom It May Concern'){
            return null;
        }
        
        Reference_Letter__c rL = [select name, reference_letter_code__c from Reference_Letter__c where id = :r.reference_letter__c];
        
        RL_Validate validate = new RL_Validate();
        
        // validate employee status - active/ terminated and returns true or false
        /*if(validate.validateRequesteeStatus(r, requesteeEmp.Status__c)){
            return null;
        }*/
        
        // validation for EMEA
        Boolean flag = validate.validationsForEMEA(rL, r);
        
        // validation for Asia
        errorMsg = validate.validationForAsiaLetters(rL, r, requesteeEmp);
        if(flag || errorMsg){
            /*String url='/apex/RL_Home?exception=ValidationError';
            
            PageReference page = new PageReference(url);
            page.setRedirect(true); 
            return page;*/
            return null;
        }
        
        /*if(r.Request_For__c == 'Pre Hired/Terminated' || (requestorEmp.CC_Region_Org__c == 'EU' && emeaHR
                    && requestorEmp.Dept_Org__c == System.Label.RL_HR_VALUE && r.request_for__c == 'Another Employee')) {*/
        if(r.Request_For__c == 'Terminated') {
            r.All_Employees__c = requesteeEmp.id;
        } else {
            r.for_employee__c = requesteeEmp.id;
        }
        r.requesting_employee__c = requestorEmp.id;
        
        List<RecordType> rTypeList = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Reference_Letter_Request__c'];
        
        Map<String,ID> rTypeMap = new Map<String,ID>();
        for (RecordType r:rTypeList)
            rTypeMap.put(r.developername,r.id);
        
        /* set the record types based on the letter type */
        /* this needs to change - just rigging for demo */
        if (rL.reference_letter_code__c  == 'RL0001') {
            r.recordtypeid = rTypeMap.get('Current_Employee_Reference_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0002') {
            if(requesteeEmp.Job_Country_Job__c == 'IND') {
                r.recordtypeid = rTypeMap.get('Business_Visa_Letter_IND');
            } else {
                r.recordtypeid = rTypeMap.get('Business_Visa_Letter_MSSB');
            }
            
            if(r.Destination__c == 'India')
                r.Destination_Flag__c = 'true';
            else 
                r.Destination_Flag__c = 'false';
        } else if (rL.reference_letter_code__c  == 'RL0003') {
            r.recordtypeid = rTypeMap.get('APEC_Business_Travel_Card');
            if(requesteeEmp.Job_Country_Job__c == 'HKG'){
                r.Consulate_Name__c='Director of Immigration';
                r.Company_Address_1__c = 'Immigration Department';
                r.Company_Address_2__c = 'Immigration Tower';
                r.Company_Address_3__c = '7 Gloucester Road';
                r.Company_Address_4__c = 'Hong Kong';
                r.Consulate_Address__c='Immigration Department<br/>Immigration Tower<br/>7 Gloucester Road<br/>Hong Kong';
            } else {
                r.Consulate_Name__c='Officer-In-Charge, APEC Business Travel Card (ABTC), Immigration & Checkpoints Authority';
                r.Company_Address_1__c = 'ICA Building';
                r.Company_Address_2__c = '10 Kallang Road';
                r.Company_Address_3__c = '#03-00, Singapore 208718 (Fax: 6293 6991)';
                r.Consulate_Address__c='ICA Building<br/>10 Kallang Road<br/>Singapore 208718';
            }
        } else if (rL.reference_letter_code__c  == 'RL0004') {
            r.recordtypeid = rTypeMap.get('Terminated_Employee_ReferenceLetter');
        } else if (rL.reference_letter_code__c  == 'RL0005') {
            r.recordtypeid = rTypeMap.get('Pre_hire_Employee_Reference_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0006') {
            r.Employee_Office_Address__c = r.Employee_Office_Address__c.replaceAll(',\r\n', ', ').replaceAll('\r\n', ', ');
            r.recordtypeid = rTypeMap.get('Rental_Application_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0007') {
            r.Consulate_Name__c='Director of Immigration';
            r.Company_Address_1__c = 'Immigration Department';
            r.Company_Address_2__c = 'Immigration Tower';
            r.Company_Address_3__c = '7 Gloucester Road';
            r.Company_Address_4__c = 'Hong Kong';
            r.Consulate_Address__c='Immigration Department<br/>Immigration Tower<br/>7 Gloucester Road<br/>Hong Kong';
            r.recordtypeid = rTypeMap.get('Sponsorship_of_Foreign_Domestic_Help_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0008') {
            r.recordtypeid = rTypeMap.get('HK_Schengen_Multiple_Entry_Visa_Application_Letter');
            
            if(r.Destination__c == 'India')
                r.Destination_Flag__c = 'true';
            else 
                r.Destination_Flag__c = 'false';
        } else if (rL.reference_letter_code__c  == 'RL0009') {
            r.recordtypeid = rTypeMap.get('Personal_Visa_Application_Letter');
            String temp = '';
            if(r.Include_Family_Members__c){
                temp = '<table style="width:65%">';
                temp += '<tr><td style="width:20%"></td><td style="width:40%"><b>Name</b></td>';
                temp += '<td style="width:40%"><b>Relationship</b></td></tr>';
                temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person__c
                            + '</td><td style="width:40%">' + r.Relationship__c + '</td></tr>';
                if(r.Name_of_the_Person2__c != null && r.Name_of_the_Person2__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person2__c
                            + '</td><td style="width:40%">' + r.Relationship_1__c + '</td></tr>';
                }
                if(r.Name_of_the_Person3__c != null && r.Name_of_the_Person3__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person3__c
                            + '</td><td style="width:40%">' + r.Relationship_2__c + '</td></tr>';
                }
                if(r.Name_of_the_Person4__c != null && r.Name_of_the_Person4__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person4__c
                            + '</td><td style="width:40%">' + r.Relationship_3__c + '</td></tr>'; 
                }
                if(r.Name_of_the_Person5__c != null && r.Name_of_the_Person5__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person5__c
                            + '</td><td style="width:40%">' + r.Relationship_4__c + '</td></tr>';
                }
                if(r.Name_of_the_Person6__c != null && r.Name_of_the_Person6__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person6__c
                            + '</td><td style="width:40%">' + r.Relationship_5__c + '</td></tr>';
                }
                if(r.Name_of_the_Person7__c != null && r.Name_of_the_Person7__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person7__c
                            + '</td><td style="width:40%">' + r.Relationship_6__c + '</td></tr>';
                }
                if(r.Name_of_the_Person8__c != null && r.Name_of_the_Person8__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person8__c
                            + '</td><td style="width:40%">' + r.Relationship_7__c + '</td></tr>';
                }
                if(r.Name_of_the_Person9__c != null && r.Name_of_the_Person9__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person9__c
                            + '</td><td style="width:40%">' + r.Relationship_8__c + '</td></tr>';
                }
                if(r.Name_of_the_Person10__c != null && r.Name_of_the_Person10__c != '') {
                    temp += '<tr><td style="width:20%"><td style="width:40%">' + r.Name_of_the_Person10__c
                            + '</td><td style="width:40%">' + r.Relationship_9__c + '</td></tr>';
                }
                temp += '</table>';
            }
            r.Person_RelationShip_Table__c = temp;
        } else if (rL.reference_letter_code__c  == 'RL0010') {
            r.recordtypeid = rTypeMap.get('HK_Exempt_from_Jury_Duty');
        } else if (rL.reference_letter_code__c  == 'RL0011') {
            r.recordtypeid = rTypeMap.get('Completed_Probation_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0012') {
            r.recordtypeid = rTypeMap.get('Novated_Lease_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0013') {
            r.recordtypeid = rTypeMap.get('BMW_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0014') {
            r.recordtypeid = rTypeMap.get('Mobile_Phone_Connection_Request_Letter');
            if(r.Phone_Company__c == null || r.Phone_Company__c == ''){
                r.Phone_Company__c = 'Whom Ever It May Concern';
            }
        } else if (rL.reference_letter_code__c  == 'RL0015') {
            r.recordtypeid = rTypeMap.get('Travel_Insurance_Cover_Note');
            if(r.Include_Family_Members__c){
                r.Person_RelationShip_Table__c = r.Name_of_the_Person__c;
                if(r.Name_of_the_Person2__c != null && r.Name_of_the_Person2__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person2__c; 
                }
                if(r.Name_of_the_Person3__c != null && r.Name_of_the_Person3__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person3__c; 
                }
                if(r.Name_of_the_Person4__c != null && r.Name_of_the_Person4__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person4__c; 
                }
                if(r.Name_of_the_Person5__c != null && r.Name_of_the_Person5__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person5__c; 
                }
                if(r.Name_of_the_Person6__c != null && r.Name_of_the_Person6__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person6__c; 
                }
                if(r.Name_of_the_Person7__c != null && r.Name_of_the_Person7__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person7__c; 
                }
                if(r.Name_of_the_Person8__c != null && r.Name_of_the_Person8__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person8__c; 
                }
                if(r.Name_of_the_Person9__c != null && r.Name_of_the_Person9__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person9__c; 
                }
                if(r.Name_of_the_Person10__c != null && r.Name_of_the_Person10__c != '') {
                    r.Person_RelationShip_Table__c += ', ' + r.Name_of_the_Person10__c; 
                }
            }
        } else if (rL.reference_letter_code__c  == 'RL0016') {
            r.recordtypeid = rTypeMap.get('EMEA_Rental_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0017') {
            r.recordtypeid = rTypeMap.get('EMEA_Bank_Letter');
            r.Bank_Name_dup__c = r.Bank_Name__c.replaceAll(' ', '_');
        } else if (rL.reference_letter_code__c  == 'RL0018') {
            r.recordtypeid = rTypeMap.get('EMEA_Current_Employee_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0019') {
            r.recordtypeid = rTypeMap.get('EMEA_Business_Visa_Letter');
            r.Bank_Name_dup__c = r.Destination__c.replaceAll(' ', '_');
            r.Type_of_Visa__c = r.Type_of_Visa__c.replaceAll(' ', '_');
        } else if (rL.reference_letter_code__c  == 'RL0020') {
            r.recordtypeid = rTypeMap.get('EMEA_Tourist_Visa_Letter');
        } else if (rL.reference_letter_code__c  == 'RL0021') {
            r.recordtypeid = rTypeMap.get('EMEA_Mortgage_Letter');
        }
          else if (rL.reference_letter_code__c  == 'RL0023') {
            r.recordtypeid = rTypeMap.get('Bank_Account_Request_Letter');
        }
        
        r.status__c = 'Created';
        if(requesteeEmp.Status__c != null && requesteeEmp.Status__c != '') {
            r.Conga_Status__c = requesteeEmp.Status__c;
        }
        
        /* assigning values of first name, last name and emp id to be shown in the console list views
        *  done for consistency because of 2 different filters to be applied on the existing employees while submitting request
        *
        *  Added by Avinash Munaga
        *
        */
        // r.Requestee_Name__c = requesteeEmp.First_Name__c + ' ' + requesteeEmp.Last_Name__c;
        // r.Requestee_MSID__c = requesteeEmp.emp_id__c;
        /* END */
        
        
        /*  these values are modified as to be used with Conga composer which doesn't allow spaces
         *  and special characters in the validation to show content - START
         *
         *  Added by Avinash Munaga
         *
         */
        if(r.Receipient_Name__c == null || r.Receipient_Name__c == ''){
            r.Receipient_Name__c = 'To Whom It May Concern';
        }
        if(r.Address_by_Reference__c == 'Address Only'){
            r.Address_by_Reference__c = 'Address_Only';
        } else if(r.Address_by_Reference__c == 'Name and Address'){
            r.Address_by_Reference__c = 'Name_and_Address';
        }
        
        if(r.Compensation_Information__c == 'Current Compensation Info') {
            r.Compensation_Information__c = 'Current_Compensation_Info';
        } else if(r.Compensation_Information__c == 'Prior 3 years Compensation Info') {
            r.Compensation_Information__c = 'Prior_3_years_Compensation_Info';
        }
        
            if(r.Conga_Employee_Gender__c == 'Male'){
            r.Conga_Title__c = 'Mr.';
            r.Conga_Title_type__c = 'He';
            r.His_Her__c = 'His';
        } else if(r.Conga_Employee_Gender__c == 'Female'){
            r.Conga_Title__c = 'Ms.';
            r.Conga_Title_type__c = 'She';
            r.His_Her__c = 'Her';
        }
        
        if(r.Duration_in_Day__c == '1'){
            if(r.Duration_in_Month__c == 'Day(s)')
                r.Duration_in_Month__c = 'day';
            else if(r.Duration_in_Month__c == 'Week(s)')
                r.Duration_in_Month__c = 'week';
            else if(r.Duration_in_Month__c == 'Month(s)')
                r.Duration_in_Month__c = 'month';
            else if(r.Duration_in_Month__c == 'Year(s)')
                r.Duration_in_Month__c = 'year';
        } else {
            if(r.Duration_in_Month__c == 'Day(s)')
                r.Duration_in_Month__c = 'days';
            else if(r.Duration_in_Month__c == 'Week(s)')
                r.Duration_in_Month__c = 'weeks';
            else if(r.Duration_in_Month__c == 'Month(s)')
                r.Duration_in_Month__c = 'months';
            else if(r.Duration_in_Month__c == 'Year(s)')
                r.Duration_in_Month__c = 'years';
        }
        
        if((rL.reference_letter_code__c  == 'RL0001' || rL.reference_letter_code__c  == 'RL0002'
                            ||rL.reference_letter_code__c  == 'RL0009') && r.National_ID_Type__C != null){
            r.US_Expert__c = true;
        } else {
            r.US_Expert__c = false;
        }
        /* END */
        
        if(r.Urgent_HR_Request__c == true && r.Employee_Job_Country__c == 'AUS'){
            r.OwnerId = queuepopulation.get('Australia_Coverage_Approvers');
        }
        if(r.Urgent_HR_Request__c == true && r.Employee_Job_Country__c == 'IND'){
            r.OwnerId = queuepopulation.get('India_Coverage_Approvers');
        }
        
        if(requestorEmp.dept_org__c == System.Label.RL_HR_VALUE){
            r.HR_Request__c = true;
        } else {
            r.HR_Request__c = false;
        }
        System.debug('HR Request: ' + r.HR_Request__c);
        
        try{ 
            if (r.id == null){  
                insert r;
                system.debug('inserted request'+r.id );
            } else {
                update r;
            }
        } catch(DMLException e){
            // Date: 06/19/2015
            string devInfo = 'RL_Home Page: Error in displaying letter input';
            String url='/apex/RL_Sys_Exception' + '?e=' + e + '&devInfo=' + devInfo + '&lineNum=' + e.getLineNumber();
            
            PageReference p = new PageReference(url);
            p.setRedirect(true);
            return p;
        }
        successLoad = true;
        
        try{    
            Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
            request.setComments('Submitted the request for approval.');
            request.setObjectId(r.Id);
            //request.setNextApproverIds(new Id[] {'00Gf0000000aS4a'});
            Approval.ProcessResult result = Approval.process(request);
            
            String url='/apex/RL_Home?successLoad=true';
            
            PageReference page = new PageReference(url);
            page.setRedirect(true); 
            return page;
            // bodySection = false;
        }catch(Exception e){
            system.debug('-- Exception in Approval Process -- ' + e);
            string devInfo = 'RL_Home Page: Error while assigning approvers';
            String url='/apex/RL_Sys_Exception' + '?e=' + e + '&devInfo=' + devInfo + '&lineNum=' + e.getLineNumber();
            
            PageReference page = new PageReference(url);
            page.setRedirect(true); 
            return page;
        }
    }
    
    public pageReference reDirect(){
        String url='/apex/RL_Home?';
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
    }
    
    
    /*****************************************************************
    * New Request
    *  
    ******************************************************************/
    public pageReference newRequest(){
        
        String url = '/apex/RL_Employee_NewRequest'; 
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
        
    }
    /*****************************************************************
    * Cancel
    * Return to employee page
    ******************************************************************/
    public pageReference exit(){
        
        String url = 'http://iwmstoday.webfarm.ms.com/MsToday/Home.page'; 
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
        
    }
    
    /*****************************************************************
    * Cancel
    * Return to employee page
    ******************************************************************/
    public pageReference cancel(){
        
        String url='/apex/RL_Employee_NewRequest';
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
        
    }
    
    /*****************************************************************
    * Get Available Letters
    * Depending on the user info only certain letters should be shown
    ******************************************************************/
    public List<SelectOption> getAvailableLetters(){
        system.debug('looking for available letters');
        List<selectOption> availableLetters = new  List<selectOption>();
        availableLetters.add(new selectOption('','---Choose a Letter---'));
        
        List<Reference_Letter__c> refList = new List<Reference_Letter__c>();
        try{
            /*if (r.request_for__c == 'Myself' || (r.request_for__c == 'Pre Hired/Terminated' && showRequestee == true)
                        || (r.request_for__c == 'Another Employee' && showRequestee == true) ){*/
            String soql = '';
            if (r.request_for__c == 'Terminated' && r.All_Employees__c != null){
                System.debug('Prehire');
                soql += 'SELECT Id, Name FROM Reference_Letter__c where Employment_Status__C = \'InActive\' ORDER BY Name';
                
                refList = Database.query(soql);
                for (Reference_Letter__c r:refList)
                    availableLetters.add(new selectOption(r.id,r.name));
            } else {
                system.debug('showRequestee: ' + showRequestee + ', r.For_Employee__c: ' + r.For_Employee__c);
                if(!showRequestee || ( showRequestee && (r.For_Employee__c != null || 
                        (requestorEmp.Job_Region_Code__c == 'EU' && emeaHR && requestorEmp.Dept_Org__c == System.Label.RL_HR_VALUE
                             && r.All_Employees__c != null)))) {
                                                             
                    /* logic to check if user should see letter */
                    /* mrm 3/26/15 can not use email in where clause changed to emplid */
                    List<Employee__C> resultSet = [select CC_Region_Org__c, Region_Dsc_Org__c,
                                                                                 Job_Country_Job__c, Dept_Org__c, Subdept_Org__c,
                                                                                 Job_Region_Code__c from Employee__C 
                                                                                 where emp_id__c = :requesteeEmp.emp_id__c limit 1];
                    for(Employee__C re: resultSet) {
                        if((re.get('Job_Region_Code__c') == 'NJ' || re.get('Job_Region_Code__c') == 'JA') && 
                                !(requesteeEmp.Job_Country_Job__c == 'CHN' && requesteeEmp.Division_Org__c == '94150' 
                                && requesteeEmp.Super_Division__c == '10100')){
                            soql = 'SELECT Id, Name FROM Reference_Letter__c';
                            /*if(requestorEmp.get('Dept_Org__c') == System.Label.RL_HR_VALUE){
                                soql += ' WHERE ( Requestor__c includes(\'HR/HRSC\') OR Requestor__c includes(\'Employee\'))';
                            } else {*/
                            soql += ' WHERE Employment_Status__C = \'Active\' AND Requestor__c includes(\'Employee\')';
                            //}
                            soql += ' AND ( Location__c includes(\'asia\')';
                                                                     
                            if(re.get('Job_Country_Job__c') == 'HKG')
                                soql += ' OR Location__c includes(\'Hong Kong\'))';
                            else if(re.get('Job_Country_Job__c') == 'SGP')
                                soql += ' OR Location__c includes(\'Singapore\'))';
                            else if(re.get('Job_Country_Job__c') == 'AUS')
                                soql += ' OR Location__c includes(\'Australia\'))';
                            else if(re.get('Job_Country_Job__c') == 'IND')
                                soql += ' OR Location__c includes(\'India\'))';
                            else if(re.get('Job_Country_Job__c') == 'IDN')
                                soql += ' OR Location__c includes(\'Indonesia\'))';
                            else if(re.get('Job_Country_Job__c') == 'THA')
                                soql += ' OR Location__c includes(\'Thailand\'))';
                            else if(re.get('Job_Country_Job__c') == 'VNM')
                                soql += ' OR Location__c includes(\'Vietnam\'))';
                            else if(re.get('Job_Country_Job__c') == 'PHL')
                                soql += ' OR Location__c includes(\'Philippines\'))';
                            else
                                soql += ')';
                        } else if(re.get('Job_Region_Code__c')== 'EU') {
                            soql += 'SELECT Id, Name FROM Reference_Letter__c';
                            /*if(re.get('Dept_Org__c') == System.Label.RL_HR_VALUE){
                                soql += ' WHERE (Requestor__c includes(\'HR/HRSC\') OR Requestor__c includes(\'Employee\'))';
                            } else {*/
                            soql += ' WHERE Requestor__c includes(\'Employee\')';
                            //}
                            soql += ' AND Location__c includes(\'EMEA\')';
                            /*if(re.get('Job_Country_Job__c') == 'UK')
                                soql += ' OR Location__c includes(\'England\'))';*/
                        }
                        soql += ' ORDER BY Name';
                    }
                    System.debug('Request for Letters : ' + soql);
                                                             
                    refList = Database.query(soql);
                    for (Reference_Letter__c r:refList)
                        availableLetters.add(new selectOption(r.id,r.name));
                                                             
                    if(requestorEmp.Dept_Org__c == System.Label.RL_HR_VALUE && r.Request_For__c == 'Another Employee'
                            && requestorEmp.Email__c != requesteeEmp.Email__c) {
                        soql = 'SELECT Id, Name FROM Reference_Letter__c WHERE ( Requestor__c includes(\'HR/HRSC\')';
                        for(Employee__C re: resultSet) {
                            if(re.Job_Country_Job__c == 'HKG')
                                soql += ' AND Location__c includes(\'Hong Kong\'))';
                            else if(re.Job_Country_Job__c == 'SGP')
                                soql += ' AND Location__c includes(\'Singapore\'))';
                            else if(re.Job_Country_Job__c == 'AUS')
                                soql += ' AND Location__c includes(\'Australia\'))';
                            else if(re.Job_Country_Job__c == 'IND')
                                soql += ' AND Location__c includes(\'India\'))';
                            else if(re.Job_Country_Job__c == 'IDN')
                                soql += ' AND Location__c includes(\'Indonesia\'))';
                            else if(re.Job_Country_Job__c == 'THA')
                                soql += ' AND Location__c includes(\'Thailand\'))';
                            else if(re.Job_Country_Job__c == 'VNM')
                                soql += ' AND Location__c includes(\'Vietnam\'))';
                            else if(re.Job_Country_Job__c == 'PHL')
                                soql += ' AND Location__c includes(\'Philippines\'))';
                            else
                                soql += 'AND Location__c includes(\'\'))';
                        }
                        soql += ' ORDER BY Name';
                        System.debug('Request for Letters : ' + soql);
                                                                    
                        refList = Database.query(soql);
                        for (Reference_Letter__c r:refList)
                            availableLetters.add(new selectOption(r.id,r.name));
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Exception in letter types : ' + e);
        }
        return availableLetters;
    }
    
    // For radio buttons in New Request Page
    public String employeeRequest {get; set;}
    public List<SelectOption> getRequestFor(){
        
        List<Employee__C> resultSet = [select CC_Region_Org__c, Region_Dsc_Org__c, Job_Country_Job__c, Dept_Org__c, Subdept_Org__c, 
                                       Job_Region_Code__c from Employee__C where emp_id__c = :u.Emp_id__c];
        
        List<SelectOption> options = new List<SelectOption>();
        system.debug('********+++' + asiaHR);
        
        for(Employee__C rs:resultSet ){
            if(rs.get('Job_Region_Code__c') != 'NA') {
                if(isContingent){
                    options.add(new SelectOption('Another Employee','Another Employee'));
                    if(rs.Dept_Org__c == System.Label.RL_HR_VALUE  && asiaHR) {
                        // options.add(new SelectOption('Pre Hired/Terminated','Pre Hired/Terminated'));
                        options.add(new SelectOption('Terminated','Terminated'));
                    }
                    // setFlag1();
                } else if(rs.Dept_Org__c == System.Label.RL_HR_VALUE  && asiaHR){
                    options.add(new SelectOption('Myself','Myself'));
                    options.add(new SelectOption('Another Employee','Another Employee'));
                    // options.add(new SelectOption('Pre Hired/Terminated','Pre Hired/Terminated'));
                    options.add(new SelectOption('Terminated','Terminated'));
                } else {
                    options.add(new SelectOption('Myself','Myself'));
                    options.add(new SelectOption('Another Employee','Another Employee'));
                }
            }
        }
        return options;
    }
    public void setEmployeeRequest(){
        this.employeeRequest = 'Myself';
    }
    // For employee list in RL_Employee Page
    public String employee {get; set;}
    public List<SelectOption> getEmployees(){
        List<SelectOption> employeeList = new List<SelectOption>();
        employeeList.add(new selectOption('','All'));
        
        List<Employee__c> empList = new List<Employee__c>();
        empList = [select id, Name from Employee__c LIMIT 50];
        for (Employee__c r:empList)
            employeeList.add(new selectOption(r.id,r.name));
        
        return employeeList;
    }
    public List<Reference_Letter_Request__c> getReferenceLetterList(){
        List<Reference_Letter_Request__c> requestList =
            [ Select Reference_Letter__c, For_Employee__c,
             Requesting_Employee__c, Id, CreatedDate, status__c,
             Reference_Letter__r.name From Reference_Letter_Request__c
             order by createdDate desc];
        return requestList;
    }
    
    public static List<Group> getGroups(){
        List<Group> userinGroup = new List<Group>();
        userinGroup=[SELECT id, DeveloperName, RelatedId, name, Type FROM Group where RelatedId= :UserInfo.getUserRoleId()];
        
        return userinGroup;
    }
    
    public static Boolean validateEMEAHR(){
        
        Boolean emeaHRValue = false;
        
        Map<String, RL_EMEAHRGroups__c> emeaHRGroup = RL_EMEAHRGroups__c.getAll(); 
        List<String> emeaHRList = new List<String>();
        for(RL_EMEAHRGroups__c r : emeaHRGroup.values()) {
            emeaHRList.add(r.name);
        }
        
        
        
        // emea HR
        List<Group> userinGroup = getGroups();
        for (Group g : userinGroup){
            for(String s : emeaHRList){
                // system.debug('emeaHRKist.size: ' + emeaHRList.size());
                if(s == g.DeveloperName){
                    emeaHRValue = true;
                    break;
                }
            }
        }
        // system.debug('emeaHRValue: ' + emeaHRValue);
        return emeaHRValue;
    }
    
}