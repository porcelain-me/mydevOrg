/*************************************************************************
* MRM - 5/7/14 Created Page
* 
*   This controller supports the employee facing Reference Letter request 
*   page.
*
*
****************************************************************************/
public without sharing class TestPage_RL_Employee {    
    List<selectOption> availableLetters = new  List<selectOption>();
    
    public String getIncludeBaseSalary() {
        return null;
    }

    Public List<String> Addmember{get;set;}
    Public Integer Count{get;set;}

    public PageReference AddMore() {
        Count += 1;
        return null;
    }    
        
    public User u {get;set;}
    public Reference_Letter_Request__c r {get;set;}
    public Boolean showEmployeeLookup {get;set;}
    public Boolean showRequestor {get;set;}
    public Boolean showRequestee {get;set;}
    public Boolean showEmpId {get;set;}
    public Boolean showInitMsg {get;set;}
    public Boolean showMain {get;set;}
    public Boolean showLetterSelection {get;set;}
    public boolean disblebutton{get;set;}
    public Boolean showPassportFlag {get;set;}
    public Boolean showRecipientNameAndAddressFlag {get;set;}
        
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
        
    public String selectedLetterId {get;set;}
        
    public Employee__c requestorEmp {get;set;}   //requestor
    public Employee__c requesteeEmp {get;set;}   //requestee
    
    //variables used only in EMEA templates - START
    public Boolean addresseTitle {get; set;}
    public Boolean addresseName {get; set;}
    public Boolean addresseSName {get; set;}
    public Boolean companyName {get; set;}
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
    public Boolean embassy {get; set;}
    public Boolean invitingOrg {get; set;}
    public Boolean includeSalary {get; set;}
    public Boolean concerned{get; set;}
    public Boolean typeOfVisa {get;set;}
    public Boolean validityPeriod {get;set;}
    public Boolean national {get;set;}
    
    public Boolean isContingent {get;set;}
    
    //variables used only in EMEA templates - END
    public String Regiondesc{get;set;}
     public boolean Button1{get;set;}   
    /*****************************************************************
    * Constructor
    *  
    ******************************************************************/
    public TestPage_RL_Employee(){
    isContingent = false;
    Count=1;
        disblebutton=true;
                       
        u = [select id, name,Emp_Id__c, firstname, lastname, ManagerID, Manager.Name, UserRole.Name, email from user where id = :UserInfo.getUserId()];
        /* find the employee id for example 59XYZ */
        try{
            requestorEmp = [select emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c, Subdept_Org__c
                , Job_Country_Job__c,Empl_Class_Dsc_Job__c, Email__c,Is_HR_Partner__c from employee__c where Emp_ID__c = :  u.Emp_Id__c];
                Regiondesc=requestorEmp.Region_Dsc_Org__c;
                if(Regiondesc=='Asia Pacific' || Regiondesc=='Europe, Middle East, Africa'){
                Button1=false;
                }
                else{
                 Button1=true;}
                 
                 //System.debug('##@@ Emp type ' + requestorEmp.Empl_Class_Dsc_Job__c);
                 if(requestorEmp.Empl_Class_Dsc_Job__c == 'Contingent'){
                     isContingent = true;
                 }else{
                     isContingent = false;
                 }
                 //System.debug('##@@ isContingent  ' + isContingent );
                
                
            if(requestorEmp.get('Region_Dsc_Org__c') == 'Asia Pacific'
               || requestorEmp.get('Region_Dsc_Org__c')== 'Japan' 
               || requestorEmp.get('Region_Dsc_Org__c') == 'Americas'
               || requestorEmp.get('Region_Dsc_Org__c')== 'North America'){
                        showAPACSLA = true;
                showEMEASLA = false;
            } else if(requestorEmp.get('Region_Dsc_Org__c')== 'Europe, Middle East, Africa') {
                showAPACSLA = false;
                showEMEASLA = true;
            }
        } catch(Exception e){
                System.debug('Exception in requesttorEmp' + e);
        }
            
        String rId = ApexPages.currentPage().getParameters().get('id');
        
        if (rId == null){
            r = new Reference_Letter_Request__c();
        }else{                    
            r = [select Id,Name, reference_letter__c,Reference_letter_name__c,requesting_employee__c ,Destination__c,Date_of_Travel__c,Return_Date__c,
                    Include_Family_Members__c,Name_of_the_Person__c, Relationship__c,Court_Date__c,Reason_for_Exemption__c,Duration_in_Day__c,
                    Duration_in_Week__c,Duration_in_Month__c,Duration_in_Year__c, requesting_employee__r.name,workflow__c,for_employee__c,
                    for_employee__r.name,Urgent_HR_Request__c from Reference_Letter_Request__c where id = :rId ];
        }
            
        r.number_of_copies__c = '1';
        r.Request_For__c = 'Myself';
        r.Address_by_Reference__c = 'Name and Address';
            
        showEmployeeLookUp = false;
        showRequestor = true;
        showRequestee = false;
        showInitMsg= true;
        showMain = true;
        requesteeEmp = requestorEmp;
        showEmpId = true;
            
        try{
            requestList = [ Select name, Reference_Letter__c, For_Employee__c, For_Employee__r.name
                , Requesting_Employee__c, Requesting_Employee__r.name, Id, CreatedDate,Empl_Class_Dsc_Job__c
                , status__c, Reference_Letter__r.name From Reference_Letter_Request__c 
                where requesting_employee__c = :requestorEmp.id order by createdDate desc LIMIT 10 ];
        } catch(Exception e){
            System.debug('Exception in requesttorEmp' + e);
        }
        
        
      
        Cont_Eork_type__c contWrkType = Cont_Eork_type__c.getValues(r.poi_type__c);
        if(contWrkType !=null){
            ContingenwrkType = contWrkType.Contigent_Work_code__c;
            //system.debug('Job_Level__c------'+r.Job_Level__c);
        } 
        
        System.debug('Request for:::' + r.request_for__c + '  ** Letter : ' + r.Reference_Letter__c);
    }
    
    public boolean showcontingent{get;set;}
    Public String ContingenwrkType{get;set;}
    
    /*****************************************************************
    * Set Flag1 Action function
    *  
    ******************************************************************/
    public void setFlag1(){
        system.debug('selected value is:' + r.request_for__c);
        showInitMsg = false;

        // for hiding the letter section and reset the page
        resetSections();
        // r.For_Employee__c = '';
        disblebutton = true;
        r.Number_of_Copies__c = ''+1;
        // for hiding the letter section and reset the page
            
        if (r.request_for__c == 'Myself'){
            
            r.Reference_Letter__c = null;
            System.debug('Request for:::' + r.request_for__c + 'Letter : ' + r.Reference_Letter__c);    
            showEmployeeLookup = false;
            showRequestor = true;
            showRequestee = false;
            showMain = true;
            showLetterSelection = true;
            requesteeEmp = requestorEmp;
            showEmpId = true;
        } else if (r.request_for__c == 'Another Employee' || r.request_for__c=='Pre Hired/Terminated'){
            System.debug('Request for:::' + r.request_for__c + 'Letter : ' + r.Reference_Letter__c);              
            //r.Reference_Letter__c= null;
            
            showRequestor = false;
            showRequestee = true;
            showEmployeeLookup = true;
            requesteeEmp = new Employee__c();
            showEmpId = false;
            availableLetters.clear();      
            availableLetters.add(new selectOption('---Choose a Letter---','---Choose a Letter---'));
            //r.Reference_Letter__c = availableLetters.get('---Choose a Letter---');
            System.debug('Request for***' + r.request_for__c + 'Letter *** ' + r.Reference_Letter__c);
        }/* else {
            showRequestor = false;
            showRequestee = false;
            showEmployeeLookup = false;
            // requestorEmp = new Employee__C();
            requesteeEmp = new Employee__c();
            showEmpId = false;
        }*/
    }
    /*****************************************************************
    * Set Flag2 Action function
    *  
    ******************************************************************/
    public void setFlag2(){
        system.debug('for employee is:' + r.for_Employee__c);
        if (r.request_for__c == 'Myself'){
            showEmployeeLookup = false;
            showRequestor = true;
            showRequestee = false;
            showInitMsg=false;
            showLetterSelection = true;
            showEmpId = false;
        } else {
            try {
                requesteeEmp = [select emp_id__c, name,First_Name__c, Last_Name__c, Manager__r.name, Job_Title_Dsc_Job__c, Job_Title__c
                                    , Country_Dsc_Home__c, Region_Dsc_Org__c, Empl_Type_Dsc_Job__c, Login_Id_Directory__c, Dept_Org__c
                                    , Subdept_Org__c,Empl_Class_Dsc_Job__c, Job_Country_Job__c, Email__C from employee__c where id = :r.For_Employee__c];
                    
                showRequestor = false;
                showRequestee = true;
                showInitMsg=false;
                showLetterSelection=false;
                    
                /* if letter type is a certaint type show that section */
                /* default for testing is letter section 1 */
                showLetterSection1 = false;
                showEmpId = true;
            } catch(DmlException e){
                system.debug('Employee not found:' + e);
            }
        }
    }
        
    public Boolean showPersonalVisaLetter {set;get;}
    public Boolean showHKExemptfromJuryDuty {set;get;}
    public Boolean showBusinessVisaLetter {set;get;}
    public Boolean showHKSMEVisaAppLetter {set;get;}
    public Boolean showMSTravelInsCoverNote {set;get;}
    public Boolean NameRelationship {set;get;}
    public Boolean BusinessVisaIsPassPortNo {set;get;}
        
        /*****************************************************************
        * Show Name & Relationship Fields based on 'Are there other family members to be included in the visa application?' checkbox - action Support to choose
        * Fields to display
        * Author : Vasu Andala
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
        /*****************************************************************
        * Show Passport Number & Nationality on Passport Fields based on 'The Employee’s Passport Number?' checkbox - action Support to choose
        * Fields to display
        * Author : Vasu Andala
        ******************************************************************/  
        public PageReference FlagToBusinessVisaIsPassPortNo(){        
            system.debug('-- FlagToBusinessVisaIsPassPortNo r.Include_Passport_Number__c --'+r.Include_Passport_Number__c);
            if(r.Include_Passport_Number__c == true){
                BusinessVisaIsPassPortNo = true;
                System.debug('This is BusinessVisaIsPassPortNo True Value - ' + BusinessVisaIsPassPortNo);
            }else{ 
                BusinessVisaIsPassPortNo = false;
                System.debug('This is BusinessVisaIsPassPortNo False Value - ' + BusinessVisaIsPassPortNo);                
            }
            return null;
        }
        public Boolean TheRecipientBelow {set;get;}
        /*****************************************************************
        * Show Name of recipient & Recipient Address Fields based on 'The recipient below' checkbox - action Support to choose
        * Fields to display
        * Author : Vasu Andala
        ******************************************************************/          
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
        public Boolean IncludedInThisCoverNote {set;get;}
        /*****************************************************************
        * Show Dependent Name Fields based on 'Are there any accompanying dependents to be included in this Cover Note?' checkbox - action Support to choose
        * Fields to display
        * Author : Vasu Andala
        ******************************************************************/           
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
        public Boolean DisableTowhomitmayconcern {set;get;}
        /*****************************************************************
        * Show Name of recipient & Recipient Address Fields based on below checkboxes -
        * 'Salary information to include: Employees Current Base Salary' checkbox - action Support to choose
        * 'The Employee's total reward for the last financial year' checkbox - action Support to choose
        * 'To whom it may concern' checkbox - action Support to choose
        * Fields to display
        * Author : Vasu Andala
        ******************************************************************/           
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
            r.Address_Letter_To__c = 'Whom it May Concern';
            TheRecipientBelow = false;
            showRecipientNameAndAddressFlag = false;
        }
    }
    public void showRecipientDetails() {
        if(r.Address_Letter_To__c == 'Specify Name/Address'){
            TheRecipientBelow = true;
        } else {
            r.Include_Current_Base_Salary__c = false;
            r.Include_Total_Compensation__c = false;
            TheRecipientBelow = false;
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
        
        // showLetterSelection = true;
        showLetterSection1 = false;
        showLetterSection2 = false;
        showLetterSection3 = false;
        showRecipientNameAndAddressFlag = false;
        
        // fields to be shown in letters for EMEA - Start
        addresseTitle = false;
        addresseName = false;
        addresseSName = false;
        companyName = false;
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
        embassy = false;
        invitingOrg = false;
        includeSalary = false;
        concerned = false;
        typeOfVisa = false;
        validityPeriod = false;
        national = false;
        // fields to be shown in letters for EMEA - End
            
        showRentalAppLetterSection = false;
        showPersonalVisaLetter = false;
        showHKExemptfromJuryDuty = false;
        showBusinessVisaLetter = false;
        showHKSMEVisaAppLetter = false;
        showMSTravelInsCoverNote = false;
    }
        
    /*****************************************************************
    * Show Letter Specific Field layouts - action function to choose
    * section to display
    *  
    ******************************************************************/
    public void setLayoutFlag(){
        System.debug('Request for:::' + r.request_for__c + 'Letter : ' + r.Reference_Letter__c);
        showHRLetterSection = false;
        showRecipientFlag = false;
        fullTerm = false;
        
        showLetterSelection = true;
        resetSections();
            
        system.debug('*----****showMSTravelInsCoverNote***************'+showMSTravelInsCoverNote);        
        try{
                Reference_Letter__c rL = [select name, reference_letter_code__c from Reference_Letter__c
                                      where id = :r.reference_letter__c];
                        system.debug('****rl.reference_letter_code__c********'+rl.reference_letter_code__c); 
                                                             
            if (rl.reference_letter_code__c == 'RL0001'){
                showLetterSection1 = true;
            } else if (rl.reference_letter_code__c == 'RL0002'){
                showBusinessVisaLetter = true;
            } else if (rl.reference_letter_code__c == 'RL0003'){
                showLetterSection3 = true;
            } else if(rl.reference_letter_code__c == 'RL0006'){
                    showRentalAppLetterSection = true;
            } else if(rl.reference_letter_code__c == 'RL0008'){
                    showHKSMEVisaAppLetter = true;
            } else if(rl.reference_letter_code__c == 'RL0010'){
                    showHKExemptfromJuryDuty = true;
            } else if(rl.reference_letter_code__c == 'RL0009'){
                    showPersonalVisaLetter = true;
            } else if(rl.reference_letter_code__c == 'RL0015'){
                    showMSTravelInsCoverNote = true;
            } else if (rl.reference_letter_code__c == 'RL0004' || rl.reference_letter_code__c == 'RL0005'){
                showHRLetterSection = true;
            } else if(rl.reference_letter_code__c == 'RL0016' || rl.reference_letter_code__c == 'RL0017'
                     || rl.reference_letter_code__c == 'RL0018' || rl.reference_letter_code__c == 'RL0019'
                     || rl.reference_letter_code__c == 'RL0020' || rl.reference_letter_code__c == 'RL0021'
                     || rl.reference_letter_code__c == 'RL0022') {
                showLetterSection2 = true;
                if(rl.reference_letter_code__c == 'RL0016' || rl.reference_letter_code__c == 'RL0018'
                    || rl.reference_letter_code__c == 'RL0021' || rl.reference_letter_code__c == 'RL0022'){
                    includeSalary = true;
                    concerned= true;
                }             
                if(rl.reference_letter_code__c == 'RL0016' || rl.reference_letter_code__c == 'RL0017'
                     || rl.reference_letter_code__c == 'RL0018' || rl.reference_letter_code__c == 'RL0021'
                     || rl.reference_letter_code__c == 'RL0022'){
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
                }
                if(rl.reference_letter_code__c == 'RL0019'){
                    nationality = true;
                    typeOfVisa = true;
                    destination = true;
                    passportNumber = true;
                }
            }
        } catch (Exception e){
            disblebutton = true;
            System.debug('Exception e : ' + e);
        }
            
        disblebutton = false;
        r.Address_Letter_To__c = 'Whom it May Concern';
    }
    
    public void showInvitingOrg(){
        if(r.Destination__c == 'Russia'){
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
    * Set recipient flag
    * Added by Avinash Munaga
    ******************************************************************/
    public void setRecipientFlag(){
        if (r.Address_Letter_To__c == 'Whom It May Concern'){           
            showRecipientNameAndAddressFlag = false;
            }
        else
            showRecipientNameAndAddressFlag = true;
    }
                
    /*****************************************************************
    * Show Letter Selection Action Function
    *  
    ***************************************************************** */
    public pageReference showLetterSelection(){
            
        showLetterSelection = true;
        return null;
    
    }
    
    /*
    * Validation for EMEA letters - Start
    * for mandatory fields
    * Created by Avinash Munaga
    */
    public Boolean validationsForEMEA(Reference_Letter__c rL){
        Boolean returnErrorMsg = false;
        //Reference_Letter__c rL = [select name, reference_letter_code__c from Reference_Letter__c where id = :r.reference_letter__c];
        if(rL.reference_letter_code__c == 'RL0016' || rL.reference_letter_code__c == 'RL0018'
           || rL.reference_letter_code__c == 'RL0021' || rL.reference_letter_code__c == 'RL0022'){
            if(r.Address_by_Reference__c == null || r.Address_by_Reference__c == ''){
                r.Address_by_Reference__c.addError('Please Select a Value to continue..');
                returnErrorMsg=true;
            }
        }             
        if(rL.reference_letter_code__c == 'RL0016' || rL.reference_letter_code__c == 'RL0017'
                     || rL.reference_letter_code__c == 'RL0018' || rL.reference_letter_code__c == 'RL0021'
                     || rL.reference_letter_code__c == 'RL0022'){
            if(r.Address_by_Reference__c == 'Name and Address' && (r.Company_Address_Title__c == null || r.Company_Address_Title__c == '')){
                r.Company_Address_Title__c.addError('Addresse Title is required.');
                returnErrorMsg=true;
            }
            if(r.Address_by_Reference__c == 'Name and Address' && (r.Company_Address_Name__c == null || r.Company_Address_Name__c == '')){
                r.Company_Address_Name__c.addError('Addresse First Name is required.');
                returnErrorMsg=true;
            }
            if(r.Address_by_Reference__c == 'Name and Address' && (r.Company_Address_SName__c == null || r.Company_Address_SName__c == '')){
                r.Company_Address_Name__c.addError('Addresse Last Name is required.');
                returnErrorMsg=true;
            }
            if(r.Company_Name__c == null || r.Company_Name__c == ''){
                r.Company_Name__c.addError('Company Name is required.');
                returnErrorMsg=true;
            }
            if(r.Company_Address_1__c == null || r.Company_Address_1__c == ''){
                r.Company_Address_1__c.addError('Address required.');
                returnErrorMsg=true;
            }
            if(r.Company_Address_3__c == null || r.Company_Address_3__c == ''){
                r.Company_Address_3__c.addError('City Name is required.');
                returnErrorMsg=true;
            }
            if(r.Company_Address_PC__c == null){
                r.Company_Address_PC__c.addError('Zip required.');
                returnErrorMsg=true;
            }
        }
        if(rL.reference_letter_code__c == 'RL0017'){
            if(r.Bank_Name__c == null || r.Bank_Name__c == ''){
                r.Bank_Name__c.addError('Please input Bank Name to continue...');
                returnErrorMsg=true;
            }
        }
        if(rL.reference_letter_code__c == 'RL0020'){
            if((r.Include_Passport_Number__c==true)&&( r.Passport_Number__c== null || r.Passport_Number__c=='')){
                r.Passport_Number__c.addError('Please Input passport number.');
                returnErrorMsg=true;
            }
            if(r.Date_of_Travel__c == null){
                r.Date_of_Travel__c.addError('Please select journey Start Date.');
                returnErrorMsg=true;
            }
            if(r.Return_Date__c == null){
                r.Return_Date__c.addError('Please select journey End Date.');
                returnErrorMsg=true;
            }
            if(r.Destination__c == null || r.Destination__c == ''){
                r.Destination__c.addError('Please select the country to travel.');
                returnErrorMsg=true;
            }
            if(r.Consulate_Name__c == null || r.Consulate_Name__c == ''){
                r.Consulate_Name__c.addError('Consulate Name is required.');
                returnErrorMsg=true;
            }
            if(r.Consulate_Address__c == null || r.Consulate_Address__c == ''){
                r.Consulate_Address__c.addError('Consulate Addrress is required.');
                returnErrorMsg=true;
            }
        }
        if(rL.reference_letter_code__c == 'RL0019'){
            if(r.Type_of_Visa__c == '--None--'){
                r.Type_of_Visa__c.addError('Please Select Visa Type');
                returnErrorMsg=true;
            }
            if(r.Passport_Number__c== null || r.Passport_Number__c=='') {
                r.Passport_Number__c.addError('Please Input passport number.');
                returnErrorMsg=true;
            }
            if((r.Type_of_Visa__c == 'Business Visa' || r.Type_of_Visa__c == 'Tourist Visa') && r.Date_of_Travel__c == null){
                r.Date_of_Travel__c.addError('Please Select journey Start Date.');
                returnErrorMsg=true;
            }
            if((r.Type_of_Visa__c == 'Double Entry Business Visa' || r.Type_of_Visa__c == 'Multiple Entry Business Visa') && r.Visa_Validity_Period__c== null){
                r.Visa_Validity_Period__c.addError('Please Select Validity Period');
                returnErrorMsg=true;
            }
            if((r.Type_of_Visa__c == 'Business Visa' || r.Type_of_Visa__c == 'Tourist Visa') && r.Return_Date__c == null){
                r.Return_Date__c.addError('Please Select journey End Date.');
                returnErrorMsg=true;
            }
            if(r.Destination__c == null || r.Destination__c == ''){
                r.Destination__c.addError('Please Select the country to travel.');
                returnErrorMsg=true;
            }
        }
        return returnErrorMsg;
    }
    // validation for EMEA letters - End
    
    /*****************************************************************
    * Save Button
    *  
    ******************************************************************/
    public pageReference save(){
        system.debug('*********SAVE METHOD*************'+r.Passport_Number__c);
        Reference_Letter__c rL = [select name, reference_letter_code__c from Reference_Letter__c
                                      where id = :r.reference_letter__c];

        // validation for EMEA
        Boolean flag = validationsForEMEA(rL);
        if(flag){
            return null;
        }
        
        // validation for Asia
        Boolean errorMsg = validationForAsiaLetters(rL);
        if(errorMsg)
            return null;
                
        /*if(requesteeEmp.id == null || requesteeEmp.id == ''){
            // r.For_Employee__c.addError = 'Requestee Name is required';
            return null;
        }*/
        
        r.for_employee__c = requesteeEmp.id;
        r.requesting_employee__c = requestorEmp.id;
            
        List<RecordType> rTypeList = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r
                                where r.SobjectType = 'Reference_Letter_Request__c'];
             
        Map<String,ID> rTypeMap = new Map<String,ID>();
        for (RecordType r:rTypeList)
            rTypeMap.put(r.developername,r.id);
                
        /* set the record types based on the letter type */
        /* this needs to change - just rigging for demo */
             
        if (rL.reference_letter_code__c  == 'RL0002')
            r.recordtypeid = rTypeMap.get('Business_Visa_Letter_MSSB');
        else if (rL.reference_letter_code__c  == 'RL0003'){
            r.recordtypeid = rTypeMap.get('APEC_Business_Travel_Card');
            if(r.For_Employee__r.Job_Country_Dsc_Job__c == 'HKG'){
                r.Consulate_Name__c='Director of Immigration';
                r.Consulate_Address__c='Immigration Department<br/>Immigration Tower7<br/>Gloucester Road<br/>Hong Kong';
            } else if(r.For_Employee__r.Job_Country_Dsc_Job__c == 'SGP'){
                r.Consulate_Name__c='Immigration & Checkpoints Authority';
                r.Consulate_Address__c='ICA Building<br/>10 Kallang Road<br/>Singapore 208718';
            }
        } else if (rL.reference_letter_code__c  == 'RL0001')
            r.recordtypeid = rTypeMap.get('Current_Employee_Reference_Letter');
        else if (rL.reference_letter_code__c  == 'RL0006')
            r.recordtypeid = rTypeMap.get('Rental_Application_Letter');
        else if (rL.reference_letter_code__c  == 'RL0008')
            r.recordtypeid = rTypeMap.get('HK_Schengen_Multiple_Entry_Visa_Application_Letter');
        else if (rL.reference_letter_code__c  == 'RL0009')
            r.recordtypeid = rTypeMap.get('Personal_Visa_Application_Letter');
        else if (rL.reference_letter_code__c  == 'RL0010')
            r.recordtypeid = rTypeMap.get('HK_Exempt_from_Jury_Duty');
        else if (rL.reference_letter_code__c  == 'RL0013')
            r.recordtypeid = rTypeMap.get('BMW_Letter');
        else if (rL.reference_letter_code__c  == 'RL0015')
            r.recordtypeid = rTypeMap.get('Travel_Insurance_Cover_Note');
        else if (rL.reference_letter_code__c  == 'RL0016')
            r.recordtypeid = rTypeMap.get('EMEA_Rental_Letter');
        else if (rL.reference_letter_code__c  == 'RL0017')
            r.recordtypeid = rTypeMap.get('EMEA_Bank_Letter');
        else if (rL.reference_letter_code__c  == 'RL0018')
            r.recordtypeid = rTypeMap.get('EMEA_Current_Employee_Letter');
        else if (rL.reference_letter_code__c  == 'RL0019')
            r.recordtypeid = rTypeMap.get('EMEA_Business_Visa_Letter');
        else if (rL.reference_letter_code__c  == 'RL0020')
            r.recordtypeid = rTypeMap.get('EMEA_Tourist_Visa_Letter');
        else if (rL.reference_letter_code__c  == 'RL0021')
            r.recordtypeid = rTypeMap.get('EMEA_Mortgage_Letter_V1');
        else if (rL.reference_letter_code__c  == 'RL0022')
            r.recordtypeid = rTypeMap.get('EMEA_Mortgage_Letter_V2');
            
        r.status__c = 'Created';
        if(r.Receipient_Name__c == null || r.Receipient_Name__c == ''){
            r.Receipient_Name__c = 'To Whom So Ever it May Concern';
        }
        
        if(r.Address_by_Reference__c == 'Address Only'){
            r.Address_by_Reference__c = 'Address_Only';
        }
        
        try{
            if (r.id == null)   
                insert r;
            else
                update r;
              
            
            Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
            request.setComments('Submitted the request for approval.');
            request.setObjectId(r.Id);
            //request.setNextApproverIds(new Id[] {'00Gf0000000aS4a'});
            Approval.ProcessResult result = Approval.process(request);
                
            String url='/apex/RL_Home';
            PageReference page = new PageReference(url);
            page.setRedirect(true);
            return page;
                
        }catch(Exception e){
            system.debug('-- Exception due to Submitting the Request -- '+e);
            return null;
        }
    
    }        

        /***************************************************************** 
        * VALIDATION RULES FOR ASIA LETTERS.
        * THROW AN ERROR FOR REQUIRED FIELDS ON VISUALFORCE PAGE.       
        * Author : Vasu Andala
        ******************************************************************/   
        public Boolean validationForAsiaLetters(Reference_Letter__c rL){
            Boolean returnErrorMsgFinally=false;
            
            // Current Employee Reference Letter -- Start
            // Added by Avinash Munaga
            if (rL.reference_letter_code__c  == 'RL0001'){
                Boolean errorMsg = false;
                if((r.Include_Passport_Number__c)&&( r.Passport_Number__c == null || r.Passport_Number__c == '')){
                    r.Passport_Number__c.addError('Please Enter Passport Number');
                    errorMsg=true;
                }
                System.debug('r.passportissuingcountry : ' + r.Passport_Issuing_Country__c);
                if((r.Include_Passport_Number__c)&&( r.Passport_Issuing_Country__c == null)){
                    r.Passport_Issuing_Country__c.addError('Please Select the issuing Country');
                    errorMsg=true;
                }
                if((r.Address_Letter_To__c == 'Specify Name/Address')&&( r.Receipient_Name__c == null || r.Receipient_Name__c == ''
                        || r.Receipient_Name__c == 'To whom it may concern')){
                    r.Receipient_Name__c.addError('Please Enter Recipient Name, To whom it may concern is not valid');
                    errorMsg= true;
                }  
                if((r.Address_Letter_To__c == 'Specify Name/Address')&&( r.Recipient_Address__c == '' || r.Recipient_Address__c == null
                        || r.Recipient_Address__c == 'n/a')){
                    r.Recipient_Address__c.addError('Please Enter Recipient Address, n/a is not valid');
                    errorMsg=true;
                }
                if(errorMsg)
                    returnErrorMsgFinally = errorMsg;
            }
            // Current Employee Reference Letter -- End

            // Business Visa Letter Validation Start ----
            if (rL.reference_letter_code__c  == 'RL0002'){  
                Boolean returnErrorMsg = false;                       
                system.debug(Logginglevel.ERROR,'****Passport_Number__c*****'+r.Passport_Number__c);
                system.debug(Logginglevel.ERROR,'****Passport_Issuing_Country__c*****'+r.Passport_Issuing_Country__c);
                system.debug(Logginglevel.ERROR,'****Destination__c*****'+r.Destination__c);
                system.debug(Logginglevel.ERROR,'****Consulate_Address__c *****'+r.Consulate_Address__c);
                system.debug(Logginglevel.ERROR,'****Commencement_date_for_visa__c*****'+r.Commencement_date_for_visa__c);
                system.debug(Logginglevel.ERROR,'****Date_of_Travel__c*****'+r.Date_of_Travel__c);
                system.debug(Logginglevel.ERROR,'****Return_Date__c*****'+r.Return_Date__c);
                if((r.Include_Passport_Number__c==true)&&( r.Passport_Number__c== null || r.Passport_Number__c=='')){
                    r.Passport_Number__c.addError('Please Enter a Value');
                    returnErrorMsg=true;
                }  
                if((r.Include_Passport_Number__c==true)&&( r.Passport_Issuing_Country__c== null || r.Passport_Issuing_Country__c=='')){
                    r.Passport_Issuing_Country__c.addError('Please Enter a Value');
                    returnErrorMsg=true;
                }
                if(r.Persons_Travelling__c== null || r.Persons_Travelling__c==''){
                    r.Persons_Travelling__c.addError('Please Enter a Value'); 
                    returnErrorMsg=true;      
                }                
                if((r.Destination__c== null || r.Destination__c=='') && r.Employee_Job_Country__c!='IND'){
                    r.Destination__c.addError('Please Enter a Value'); 
                    returnErrorMsg=true;        
                }
                if(r.Consulate_Address__c ==null || r.Consulate_Address__c==''){
                    r.Consulate_Address__c.addError('Please Enter a Value'); 
                    returnErrorMsg=true;
                }
                if(r.Commencement_date_for_visa__c ==null ){
                    r.Commencement_date_for_visa__c.addError('Please Enter a Value');
                    returnErrorMsg=true;
                }
                if((r.Duration_in_Day__c== null || r.Duration_in_Day__c=='') && r.Employee_Job_Country__c!='IND'){
                    r.Duration_in_Day__c.addError('Please Enter a Value');
                    returnErrorMsg=true;
                }
                if(r.Date_of_Travel__c==null && r.Employee_Job_Country__c =='IND'){
                    r.Date_of_Travel__c.addError('Please Enter a Value');
                    if(system.today()>r.Date_of_Travel__c || r.Date_of_Travel__c>r.Return_Date__c){
                        r.Duration_in_Day__c.addError('Duration; Start Date ig greater than today and lesser than Duration; End Date');
                    }
                    returnErrorMsg=true;
                }
                if(r.Return_Date__c==null && r.Employee_Job_Country__c =='IND'){
                    r.Return_Date__c.addError('Please Enter a Value');
                    if(system.today()>r.Return_Date__c || r.Date_of_Travel__c>r.Return_Date__c){
                        r.Duration_in_Day__c.addError('Duration; End Date ig greater than today and greater than Duration; Start Date');
                    }                    
                    returnErrorMsg=true;
                }
                
                if(returnErrorMsg)
                    returnErrorMsgFinally = returnErrorMsg;                                             
            }
             // Business Visa Letter Validation END ----   
             // Modified by Vasu on 25June2014
            // Personal Visa Letter – Asia Validation START ----
            if (rL.reference_letter_code__c  == 'RL0009'){              
                Boolean returnErrorMsgPers=false;               
                if(r.Destination__c==null || r.Destination__c==''){
                    r.Destination__c.addError('Please Enter a Value');
                    returnErrorMsgPers = true;
                }
                if(r.Date_of_Travel__c==null){
                    r.Date_of_Travel__c.addError('Please Enter a Value'); 
                    returnErrorMsgPers = true;
                }
                if(r.Return_Date__c==null){
                    r.Return_Date__c.addError('Please Enter a Value'); 
                    returnErrorMsgPers = true;
                } 
                if((r.Include_Family_Members__c==true)&&( r.Name_of_the_Person__c== null || r.Name_of_the_Person__c=='')){
                    r.Name_of_the_Person__c.addError('Please Enter a Value');
                    returnErrorMsgPers = true;
                }  
                if((r.Include_Family_Members__c==true)&&( r.Relationship__c== null || r.Relationship__c=='')){
                    r.Relationship__c.addError('Please Enter a Value');
                    returnErrorMsgPers = true;               
                }
                
                if(returnErrorMsgPers)
                    returnErrorMsgFinally = returnErrorMsgPers;
            }       
            // Personal Visa Letter – Asia Validation END ----
            // Modified by Vasu on 25June2014
            // MS Travel Insurance Cover Note - ASIA - Validation Start ---
            if(rl.reference_letter_code__c == 'RL0015'){
                if(r.Include_Family_Members__c && (r.Name_of_the_Person__c==null || r.Name_of_the_Person__c=='')){
                    r.Name_of_the_Person__c.addError('Please Enter a Value');
                    returnErrorMsgFinally = true;
                }
            }
            // MS Travel Insurance Cover Note - ASIA - Validation End ---
            
            
            //Rental Application Letter - ASIA - Validation Start --
            if(rl.reference_letter_code__c == 'RL0006'){
                Boolean returnErrorMsgRentApp = false;
                if(r.Employee_Office_Address__c== null || r.Employee_Office_Address__c==''){
                    r.Employee_Office_Address__c.addError('Please Enter a Value'); 
                    returnErrorMsgRentApp = true;
                }
                if((r.Address_Letter_To__c == 'Specify Name/Address')&&( r.Receipient_Name__c == null || r.Receipient_Name__c == ''
                        || r.Receipient_Name__c == 'To whom it may concern')){
                    r.Receipient_Name__c.addError('Please Enter Recipient Name, To whom it may concern is not valid');
                    returnErrorMsgRentApp = true;
                }  
                if((r.Address_Letter_To__c == 'Specify Name/Address')&&( r.Recipient_Address__c == '' || r.Recipient_Address__c == null
                        || r.Recipient_Address__c == 'n/a')){
                    r.Recipient_Address__c.addError('Please Enter Recipient Address, n/a is not valid');
                    returnErrorMsgRentApp = true;
                }
                
                if(returnErrorMsgRentApp)
                    returnErrorMsgFinally = returnErrorMsgRentApp;
            }
            //Rental Application Letter - ASIA - Validation End --
            
            // Modified by Vasu on 25June2014
            // HK Schengen Multiple Entry Visa Application Letter - ASIA - Validation Statr --            
            if(rl.reference_letter_code__c == 'RL0008'){
                returnErrorMsgFinally = false;
                if(r.Destination__c == null || r.Destination__c == ''){
                    r.Destination__c.addError('Please select the country to travel.');
                    returnErrorMsgFinally=true;
                }
                if(r.Commencement_date_for_visa__c ==null ){
                    r.Commencement_date_for_visa__c.addError('Please Enter a Value');
                    returnErrorMsgFinally=true;
                }
                if((r.Duration_in_Day__c== null || r.Duration_in_Day__c=='') && r.Employee_Job_Country__c!='IND'){
                    r.Duration_in_Day__c.addError('Please Enter a Value');
                    returnErrorMsgFinally=true;
                }
            }
            // HK Schengen Multiple Entry Visa Application Letter - ASIA - Validation End --
            
            //9.1.8    HK Exempt from Jury Duty - ASIA - Validation Start --
            if(rl.reference_letter_code__c == 'RL0010'){
                returnErrorMsgFinally = false;
                if(r.Hong_Kong_ID_Card_Number__c == null || r.Hong_Kong_ID_Card_Number__c == ''){
                    r.Hong_Kong_ID_Card_Number__c.addError('Please select the country to travel.');
                    returnErrorMsgFinally=true;
                }   
                if(r.Court_Date__c ==null ){
                    r.Court_Date__c.addError('Please Enter a Value');
                    returnErrorMsgFinally=true;
                }  
                if(r.Reason_for_Exemption__c == null || r.Reason_for_Exemption__c == ''){
                    r.Reason_for_Exemption__c.addError('Please select the country to travel.');
                    returnErrorMsgFinally=true;
                }                                           
                
            }
            
            //9.1.8    HK Exempt from Jury Duty - ASIA - Validation End --
            
            return returnErrorMsgFinally;
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
        //List<selectOption> availableLetters = new  List<selectOption>();
        availableLetters.add(new selectOption('','---Choose a Letter---'));
        
        List<Reference_Letter__c> refList = new List<Reference_Letter__c>();
        try{
            /*if (r.request_for__c == 'Myself' || (r.request_for__c == 'Pre Hired/Terminated' && showRequestee == true)
                 || (r.request_for__c == 'Another Employee' && showRequestee == true) ){*/
            String soql = '';
            if (r.request_for__c == 'Pre Hired/Terminated'){
                System.debug('Prehire');
                soql += 'SELECT Id, Name FROM Reference_Letter__c where Employment_Status__C = \'InActive\' ';
            } else {
                List<Employee__C> resultSet = [select Region_Dsc_Org__c, Job_Country_Job__c, Dept_Org__c, Subdept_Org__c
                         from Employee__C where Email__c = :requesteeEmp.Email__c limit 1];
                soql += 'SELECT Id, Name FROM Reference_Letter__c';
                
                for(Employee__C re: resultSet){
                if(re.get('Region_Dsc_Org__c') == 'Asia Pacific' || re.get('Region_Dsc_Org__c')== 'Japan'
                        || re.get('Region_Dsc_Org__c') == 'Americas' || re.get('Region_Dsc_Org__c')== 'North America'){
                    if(re.get('Dept_Org__c') == '81200'){
                        soql += ' WHERE ( Requestor__c includes(\'HR/HRSC\') OR Requestor__c includes(\'Employee\'))';
                    } else {
                        soql += ' WHERE Requestor__c includes(\'Employee\')';
                    }
                    soql += ' AND ( Location__c includes(\'asia\')';
                
                    if(re.get('Job_Country_Job__c') == 'HKG')
                        soql += ' OR Location__c includes(\'Hong Kong\'))';
                    else if(re.get('Job_Country_Job__c') == 'SGP')
                        soql += ' OR Location__c includes(\'Singapore\'))';
                    else if(re.get('Job_Country_Job__c') == 'AUS')
                        soql += ' OR Location__c includes(\'Australia\'))';
                    else if(re.get('Job_Country_Job__c') == 'IND')
                        soql += ' OR Location__c includes(\'India\'))';
                    else
                        soql += ')';
                } else if(re.get('Region_Dsc_Org__c')== 'Europe, Middle East, Africa') {
                    if(re.get('Dept_Org__c') == '81200'){
                        soql += ' WHERE (Requestor__c includes(\'HR/HRSC\') OR Requestor__c includes(\'Employee\'))';
                    } else {
                        soql += ' WHERE Requestor__c includes(\'Employee\')';
                    }
                        soql += ' AND Location__c includes(\'EMEA\')';
                }
            }
            }
            System.debug('Request for Letters : ' + soql);
            // refList = [select id, name from Reference_Letter__c];
            refList = Database.query(soql);
            /* add logic to check if user should see letter */
            for (Reference_Letter__c r:refList)
                availableLetters.add(new selectOption(r.id,r.name));
        } catch (Exception e) {
            System.debug('Exception in letter types : ' + e);
        }
        return availableLetters;
    }
    
    // For radio buttons in New Request Page
    public String employeeRequest {get; set;}
    public List<SelectOption> getRequestFor(){
        
        List<Employee__C> resultSet = [select Region_Dsc_Org__c, Job_Country_Job__c, Dept_Org__c, Subdept_Org__c
                         from Employee__C where emp_id__c = :u.emp_id__c];
        
        List<SelectOption> options = new List<SelectOption>();
        for(Employee__C rs:resultSet ){
            if(rs.Dept_Org__c=='81200' && rs.Region_Dsc_Org__c != 'Europe, Middle East, Africa'){
                options.add(new SelectOption('Myself','Myself'));
                options.add(new SelectOption('Another Employee','Another Employee'));
                options.add(new SelectOption('Pre Hired/Terminated','Pre Hired/Terminated'));
            } else {
                options.add(new SelectOption('Myself','Myself'));
                options.add(new SelectOption('Another Employee','Another Employee'));
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
    public void changeAddressLetterTo(){
    system.debug('calling**** : ' + r.Address_Letter_To__c);
    r.Address_Letter_To__c = 'Specify Name/Address';
    showRecipientNameAndAddressFlag= true;
   
    }
    
    
}