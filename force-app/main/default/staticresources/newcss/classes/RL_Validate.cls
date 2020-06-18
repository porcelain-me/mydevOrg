public class RL_Validate {

    /*
    * Validation for EMEA letters - Start
    * for mandatory fields
    * Created by Avinash Munaga
    */
    
    /* Checks the status of employee and returns true or false
    * input parameter - reference letter request object and
    * status of the requestee - generally active or terminated
    * output - a boolean value 
    */ 
    
    // formating name to camel case
    public String formatName(String name){
        String str = '';
        for(String word: name.toLowerCase().split(' ')){
            str += word.substring(0,1).toUpperCase() + word.substring(1) + ' ';
        }
        // system.debug('Str: ' + str.trim() + 'asdf');
        return str.trim();
    }
    
    // validate requestee if status active or now 
    public Boolean validateRequesteeStatus(Reference_Letter_Request__c r, String status){
        
        Boolean statusFail = false;
        
        // checks if employee is active for the field which accepts only employee's who are active
        if(r.For_Employee__c != null){
            if(status == 'Active'){
                r.For_Employee__c.addError('This letter can\'t be submitted for terminated/ inactive employees');
                statusFail = true;
            }
        } else if(r.All_Employees__c != null){ // checks if employee is teminated for the field which accepts only terminated employee's
            if(status == 'Terminated'){
                r.All_Employees__c.addError('This letter can\'t be submitted for active employees');
                statusFail = true;
            }   
        }
        system.debug('statusFail : ' + statusFail);
        return statusFail;
    }
    
    public Boolean validationsForEMEA(Reference_Letter__c rL, Reference_Letter_Request__c r){
        Boolean returnErrorMsg = false;
        //Reference_Letter__c rL = [select name, reference_letter_code__c from Reference_Letter__c where id = :r.reference_letter__c];
        if(rL.reference_letter_code__c == 'RL0016' || rL.reference_letter_code__c == 'RL0018'
           || rL.reference_letter_code__c == 'RL0021' || rL.reference_letter_code__c == 'RL0022'){
            if(r.Address_by_Reference__c == null || r.Address_by_Reference__c == ''){
                r.Address_by_Reference__c.addError('Please select To whom should the reference be addressed?');
                returnErrorMsg = true;
            }   
        }             
        if(rL.reference_letter_code__c == 'RL0016' || rL.reference_letter_code__c == 'RL0017'
                     || rL.reference_letter_code__c == 'RL0018' || rL.reference_letter_code__c == 'RL0021'
                     || rL.reference_letter_code__c == 'RL0022'){
                if(r.Address_by_Reference__c == 'Name and Address' && (r.Company_Address_Title__c == null || r.Company_Address_Title__c == '')){
                r.Company_Address_Title__c.addError('Please enter Title');
                returnErrorMsg = true;
            }
            if(r.Address_by_Reference__c == 'Name and Address' && (r.Company_Address_Name__c == null || r.Company_Address_Name__c == '')){
                r.Company_Address_Name__c.addError('Please enter First Name');
                returnErrorMsg = true;
            }
            if(r.Address_by_Reference__c == 'Name and Address' && (r.Company_Address_SName__c == null || r.Company_Address_SName__c == '')){
                r.Company_Address_SName__c.addError('Please enter Surname');
                returnErrorMsg = true;
            }
            if(r.Company_Name__c == null || r.Company_Name__c == ''){
                r.Company_Name__c.addError('Please enter Company Name');
                returnErrorMsg = true;
            }
            if(r.Company_Address_1__c == null || r.Company_Address_1__c == ''){
                r.Company_Address_1__c.addError('Please enter Address Line 1');
                returnErrorMsg = true;
            }
            if(r.Company_Address_3__c == null || r.Company_Address_3__c == ''){
                r.Company_Address_3__c.addError('Please enter Town/ City');
                returnErrorMsg = true;
            }
            if(r.Company_Address_PC__c == null){
                r.Company_Address_PC__c.addError('Please enter Zip/ Post Code');
                returnErrorMsg = true;
            }
        }
        if(rL.reference_letter_code__c == 'RL0017'){
            if(r.Bank_Name__c == null || r.Bank_Name__c == ''){
                r.Bank_Name__c.addError('Please enter Bank Name');
                returnErrorMsg = true;
            }
            if(r.Address_1_Prev__c == null || r.Address_1_Prev__c == ''){
                r.Address_1_Prev__c.addError('Please enter Address Line 1');
                returnErrorMsg = true;
            }
            if(r.Address_2_Prev__c == null || r.Address_2_Prev__c == ''){
                r.Address_2_Prev__c.addError('Please enter Address Line 2');
                returnErrorMsg = true;
            }
            if(r.Address_3_Prev__c == null || r.Address_3_Prev__c == ''){
                r.Address_3_Prev__c.addError('Please enter City');
                returnErrorMsg = true;
            }
            if(r.Address_4_Prev__c == null || r.Address_4_Prev__c == ''){
                r.Address_4_Prev__c.addError('Please enter Country');
                returnErrorMsg = true;
            }
            if(r.Zip_Prev_Address__c == null || r.Zip_Prev_Address__c == ''){
                r.Zip_Prev_Address__c.addError('Please enter Post Code');
                returnErrorMsg = true;
            }
        }
        if(rL.reference_letter_code__c == 'RL0020'){
            if( r.Passport_Number__c == null || r.Passport_Number__c ==''){
                r.Passport_Number__c.addError('Please enter Passport Number');
                returnErrorMsg = true;
            }
            if(r.Passport_Issuing_Country__c == null || r.Passport_Issuing_Country__c == ''){
                r.Passport_Issuing_Country__c.addError('Please Select Citizenship Country');
                returnErrorMsg = true;
            }
            if(r.Date_of_Travel__c == null){
                r.Date_of_Travel__c.addError('Please select Date of Travel');
                returnErrorMsg = true;
            }
            if(r.Return_Date__c == null){
                r.Return_Date__c.addError('Please select Return Date');
                returnErrorMsg = true;
            }
            if(r.Destination__c == null || r.Destination__c == ''){
                r.Destination__c.addError('Please select Destination');
                returnErrorMsg = true;
            }
            if(r.Consulate_Name__c == null || r.Consulate_Name__c == ''){
                r.Consulate_Name__c.addError('Please enter Embassy Name');
                returnErrorMsg = true;
            }
            if(r.Company_Address_1__c == null || r.Company_Address_1__c == ''){
                r.Company_Address_1__c.addError('Please enter Address Line 1');
                returnErrorMsg = true;
            }
            if(r.Company_Address_2__c == null || r.Company_Address_2__c == ''){
                r.Company_Address_2__c.addError('Please enter Address Line 2');
                returnErrorMsg = true;
            }
            if(r.Company_Address_3__c == null || r.Company_Address_3__c == ''){
                r.Company_Address_3__c.addError('Please enter City');
                returnErrorMsg = true;
            }
            if(r.Company_Address_4__c == null || r.Company_Address_4__c == ''){
                r.Company_Address_4__c.addError('Please enter Country');
                returnErrorMsg = true;
            }
            if(r.Company_Address_PC__c == null){
                r.Company_Address_PC__c.addError('Please enter Post Code');
                returnErrorMsg = true;
            }
          /*   Commenting As the Field is removed from Page
          if(r.Consulate_Address__c == null || r.Consulate_Address__c == ''){
                r.Consulate_Address__c.addError('Please enter Embassy Address');
                returnErrorMsg=true;
            } */
        }
        if(rL.reference_letter_code__c == 'RL0019'){
             if(r.Nationality__c == null || r.Nationality__c==''){
                r.Nationality__c.addError('Please enter Nationality');
                returnErrorMsg = true;
            }
            if(r.Type_of_Visa__c == null){
                r.Type_of_Visa__c.addError('Please select Type of Visa');
                returnErrorMsg = true;
            }
            if(r.Passport_Number__c== null || r.Passport_Number__c=='') {
                r.Passport_Number__c.addError('Please enter Passport Number');
                returnErrorMsg = true;
            }
            if((r.Type_of_Visa__c == 'Business Visa' || r.Type_of_Visa__c == 'Tourist Visa') && r.Date_of_Travel__c == null){
                r.Date_of_Travel__c.addError('Please select Date of Travel');
                returnErrorMsg = true;
            }
            if((r.Type_of_Visa__c == 'Double Entry Business Visa' || r.Type_of_Visa__c == 'Multiple Entry Business Visa')
                     && r.Visa_Validity_Period__c== null){
                r.Visa_Validity_Period__c.addError('Please select Required Validity Period');
                returnErrorMsg = true;
            }
            if((r.Type_of_Visa__c == 'Business Visa' || r.Type_of_Visa__c == 'Tourist Visa') && r.Return_Date__c == null){
                r.Return_Date__c.addError('Please select Return Date');
                returnErrorMsg = true;
            }
            if(r.Destination__c == null || r.Destination__c == ''){
                r.Destination__c.addError('Please select Destination');
                returnErrorMsg = true;
            }
            
            if(r.Consulate_Name__c == null || r.Consulate_Name__c == ''){
                r.Consulate_Name__c.addError('Please enter Embassy Name');
                returnErrorMsg = true;
            }
            if(r.Company_Address_1__c == null || r.Company_Address_1__c == ''){
                r.Company_Address_1__c.addError('Please enter Address Line 1');
                returnErrorMsg = true;
            }
            if(r.Company_Address_2__c == null || r.Company_Address_2__c == ''){
                r.Company_Address_2__c.addError('Please enter Address Line 2');
                returnErrorMsg = true;
            }
            if(r.Company_Address_3__c == null || r.Company_Address_3__c == ''){
                r.Company_Address_3__c.addError('Please enter City');
                returnErrorMsg = true;
            }
            if(r.Company_Address_4__c == null || r.Company_Address_4__c == ''){
                r.Company_Address_4__c.addError('Please enter Country');
                returnErrorMsg = true;
            }
            if(r.Company_Address_PC__c == null){
                r.Company_Address_PC__c.addError('Please enter Post Code');
                returnErrorMsg = true;
            }
        }
        return returnErrorMsg;
    }
    // validation for EMEA letters - End
    
    /***************************************************************** 
    * VALIDATION RULES FOR ASIA LETTERS.
    * THROW AN ERROR FOR REQUIRED FIELDS ON VISUALFORCE PAGE.       
    *
    ******************************************************************/  
    
    public Boolean validationForAsiaLetters(Reference_Letter__c rL, Reference_Letter_Request__c r, Employee__c requesteeEmp){
    
        Boolean returnErrorMsgFinally=false;
        system.debug('------------------------Reference Letter is ------------------'+rL.reference_letter_code__c);
        system.debug('------------------------Reference Letter is ------------------'+r);
        //Pre hired/terminated
        //Added by Jones
        if (rL.reference_letter_code__c  == 'RL0004' || rL.reference_letter_code__c  == 'RL0005'){
            Boolean errorMsg = false;
            if((r.Address_Letter_To__c == 'Specify Name/Address') && (r.Receipient_Name__c == null || r.Receipient_Name__c == ''
                    || r.Receipient_Name__c == 'Whom It May Concern')){
                r.Receipient_Name__c.addError('Please enter Recipient Name');
                errorMsg= true;
            }  
            /*
            if((r.Address_Letter_To__c == 'Specify Name/Address') &&
                     (r.Recipient_Address__c == '' || r.Recipient_Address__c == null)){
                r.Recipient_Address__c.addError('Please enter Recipient Address');
                errorMsg=true;
            }
            */
            
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_1__c == '' || r.Recipent_Address_Line_1__c == null)){
                r.Recipent_Address_Line_1__c.addError('Please enter Address Line 1');
                errorMsg = true;
            }
            /*if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_2__c == '' || r.Recipent_Address_Line_2__c == null)){
                r.Recipent_Address_Line_2__c.addError('Please enter Address Line 2');
                errorMsg = true;
            }
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_3__c == '' || r.Recipent_Address_Line_3__c == null)){
                r.Recipent_Address_Line_3__c.addError('Please enter Address Line 3');
                errorMsg = true;
            }*/
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Country__c == '' || r.Recipent_Address_Country__c == null)){
                r.Recipent_Address_Country__c.addError('Please select the country');
                errorMsg = true;
            }
            
            if(errorMsg)
                returnErrorMsgFinally = errorMsg;
        }   
        
            
        // Current Employee Reference Letter -- Start
        // Added by Avinash Munaga
        if (rL.reference_letter_code__c  == 'RL0001'){
            Boolean errorMsg = false;
            if((r.Include_Passport_Number__c)&&( r.Passport_Number__c == null || r.Passport_Number__c == '')){
                r.Passport_Number__c.addError('Please enter Passport Number');
                errorMsg=true;
            }
            System.debug('r.passportissuingcountry : ' + r.Passport_Issuing_Country__c);
            if((r.Include_Passport_Number__c)&&( r.Passport_Issuing_Country__c == null)){
                r.Passport_Issuing_Country__c.addError('Please select Passport Issuing Country');
                errorMsg=true;
            }
            if((r.Address_Letter_To__c == 'Specify Name/Address') && (r.Receipient_Name__c == null || r.Receipient_Name__c == ''
                    || r.Receipient_Name__c == 'Whom It May Concern')){
                r.Receipient_Name__c.addError('Please enter Recipient Name, "Whom It May Concern" is not valid');
                errorMsg= true;
            }  
            /*
            if((r.Address_Letter_To__c == 'Specify Name/Address') &&
                     (r.Recipient_Address__c == '' || r.Recipient_Address__c == null)){
                r.Recipient_Address__c.addError('Please enter Recipient Address');
                errorMsg=true;
            }
            */
            
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_1__c == '' || r.Recipent_Address_Line_1__c == null)){
                r.Recipent_Address_Line_1__c.addError('Please enter Address Line 1');
                errorMsg  =true;
            }
            /*if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_2__c == '' || r.Recipent_Address_Line_2__c == null)){
                r.Recipent_Address_Line_2__c.addError('Please enter Address Line 2');
                errorMsg = true;
            }
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_3__c == '' || r.Recipent_Address_Line_3__c == null)){
                r.Recipent_Address_Line_3__c.addError('Please enter Address Line 3');
                errorMsg = true;
            }*/
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Country__c == '' || r.Recipent_Address_Country__c == null)){
                r.Recipent_Address_Country__c.addError('Please select the country');
                errorMsg = true;
            }
            
            // 06/26/2015 - Avinash Munaga
            // validation for National Id/ ARC
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c == null && r.National_Id_Value__c != null){
                r.National_ID_Type__c.addError('Please select National ID Type');
                errorMsg = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c != null && r.National_Id_Value__c == null){
                r.National_Id_Value__c.addError('Please enter National ID/ ARC');
                errorMsg = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && 
                    r.National_ID_Type__c != null && r.National_Id_Value__c != null && r.National_ID_Length__c != 10){
                r.National_Id_Value__c.addError('National ID/ ARC should be 10 characters');
                errorMsg = true;               
            }
            
            if(errorMsg)
                returnErrorMsgFinally = errorMsg;
        }
        // Current Employee Reference Letter -- End
        
        // test cureent employee reference letter--start
        if (rL.reference_letter_code__c  == 'RL0111'){
            Boolean errorMsg = false;
            if((r.Include_Passport_Number__c)&&( r.Passport_Number__c == null || r.Passport_Number__c == '')){
                r.Passport_Number__c.addError('Please enter Passport Number');
                errorMsg=true;
            }
            System.debug('r.passportissuingcountry : ' + r.Passport_Issuing_Country__c);
            if((r.Include_Passport_Number__c)&&( r.Passport_Issuing_Country__c == null)){
                r.Passport_Issuing_Country__c.addError('Please select Passport Issuing Country');
                errorMsg=true;
            }
            if((r.Address_Letter_To__c == 'Specify Name/Address') && (r.Receipient_Name__c == null || r.Receipient_Name__c == ''
                    || r.Receipient_Name__c == 'Whom It May Concern')){
                r.Receipient_Name__c.addError('Please enter Recipient Name, "Whom It May Concern" is not valid');
                errorMsg= true;
            }  
            
            
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_1__c == '' || r.Recipent_Address_Line_1__c == null)){
                r.Recipent_Address_Line_1__c.addError('Please enter Address Line 1');
                errorMsg  =true;
            }
            
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Country__c == '' || r.Recipent_Address_Country__c == null)){
                r.Recipent_Address_Country__c.addError('Please select the country');
                errorMsg = true;
            }
            
            
            // validation for National Id/ ARC
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c == null && r.National_Id_Value__c != null){
                r.National_ID_Type__c.addError('Please select National ID Type');
                errorMsg = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c != null && r.National_Id_Value__c == null){
                r.National_Id_Value__c.addError('Please enter National ID/ ARC');
                errorMsg = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && 
                    r.National_ID_Type__c != null && r.National_Id_Value__c != null && r.National_ID_Length__c != 10){
                r.National_Id_Value__c.addError('National ID/ ARC should be 10 characters');
                errorMsg = true;               
            }
            
            if(errorMsg)
                returnErrorMsgFinally = errorMsg;
        }
        // test cureent employee reference letter--end

        // Business Visa Letter Validation Start ----
        if (rL.reference_letter_code__c  == 'RL0002' && requesteeEmp.Job_Country_Job__c != 'IND'){  
            Boolean returnErrorMsg = false;                       
            system.debug(Logginglevel.ERROR,'****Passport_Number__c*****'+r.Passport_Number__c);
            
            if(r.Include_Passport_Number__c &&( r.Passport_Number__c == null || r.Passport_Number__c == '')){
                r.Passport_Number__c.addError('Please enter Passport Number');
                returnErrorMsg=true;
            }  
            if(r.Include_Passport_Number__c &&( r.Passport_Issuing_Country__c == null || r.Passport_Issuing_Country__c =='')){
                r.Passport_Issuing_Country__c.addError('Please select Nationality on Passport');
                returnErrorMsg=true;
            }
            if(r.Include_Passport_Number__c && requesteeEmp.Job_Country_Job__c == 'IND'
                     && ( r.Passport_Issuing_City__c == null || r.Passport_Issuing_City__c == '')){
                r.Passport_Issuing_City__c.addError('Please enter Issuing Authority');
                returnErrorMsg=true;
            }  
            if(r.Include_Passport_Number__c && requesteeEmp.Job_Country_Job__c == 'IND' && r.Passport_Date__c == null) {
                r.Passport_Date__c.addError('Please select Issuing Date');
                returnErrorMsg=true;
            }
            if(r.Include_Passport_Number__c && requesteeEmp.Job_Country_Job__c == 'IND' && r.Passport_Expiry_Date__c == null){
                r.Passport_Expiry_Date__c.addError('Please select Expiry Date');
                returnErrorMsg=true;
            }
            
            if(requesteeEmp.Job_Country_Job__c == 'IND' &&( r.Visa_Type__c == null || r.Visa_Type__c == '') ){
                r.Visa_Type__c.addError('Please select Visa Type');
                returnErrorMsg=true;
            }
            
            if(r.Destination__c == null || r.Destination__c ==''){
                r.Destination__c.addError('Please select Country the visa application is for'); 
                returnErrorMsg=true;        
            }
            /*if(r.Consulate_Address__c == null || r.Consulate_Address__c == ''){
                r.Consulate_Address__c.addError('Please enter Embassy Address'); 
                returnErrorMsg=true;
            }*/
            if(r.Consulate_Country__c == null || r.Consulate_Country__c == ''){
                r.Consulate_Country__c.addError('Please select Country of the Embassy'); 
                returnErrorMsg=true;
            }
           /* if(r.Commencement_date_for_visa__c == null){
                r.Commencement_date_for_visa__c.addError('Please select Commencement date for visa');
                returnErrorMsg=true;
            }*/
            if(r.Commencement_date_for_visa__c == null || system.today() > r.Commencement_date_for_visa__c ){
                r.Commencement_date_for_visa__c.addError('Please select Commencement date for visa');
                if(system.today() > r.Commencement_date_for_visa__c){
                    r.Commencement_date_for_visa__c.addError('Commencement date for visa cannot be earlier than today');
                }
                returnErrorMsg = true;
            }
            
            if(requesteeEmp.Job_Country_Job__c != 'IND' && (r.Duration_in_Day__c == null ||  r.Duration_in_Day__c == ''
                    || r.Duration_in_Month__c == null || r.Duration_in_Month__c == '') ) {
                // r.Duration_in_Day__c.addError('Please select Duration');
                returnErrorMsg = true;
            }
            
            /*if((r.Duration_in_Day__c == null || r.Duration_in_Day__c=='') && requesteeEmp.Job_Country_Job__c != 'Ind'){
                    r.Duration_in_Day__c.addError('Please select Duration');
                    returnErrorMsg=true;
            }*/
            
            if(requesteeEmp.Job_Country_Job__c == 'Ind' && (r.Date_of_Travel__c == null ||
                    system.today() > r.Date_of_Travel__c || r.Date_of_Travel__c > r.Return_Date__c)){
                r.Date_of_Travel__c.addError('Please select Start Date');
                if(system.today() > r.Date_of_Travel__c || r.Date_of_Travel__c>r.Return_Date__c){
                    r.Date_of_Travel__c.addError('Start Date cannot be after End Date and earlier to today');
                }
                returnErrorMsg=true;
            }
            if(requesteeEmp.Job_Country_Job__c == 'Ind' && (r.Return_Date__c == null || 
                    system.today() > r.Return_Date__c || r.Date_of_Travel__c > r.Return_Date__c)){
                r.Return_Date__c.addError('Please select End Date');
                if(system.today() > r.Return_Date__c || r.Date_of_Travel__c>r.Return_Date__c){
                    r.Return_Date__c.addError('Return Date cannot be earlier than Start Date and today');
                }                    
                returnErrorMsg=true;
            }
            
            // 06/26/2015 - Avinash Munaga
            // validation for National Id/ ARC
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c == null && r.National_Id_Value__c != null){
                r.National_ID_Type__c.addError('Please select National ID Type');
                returnErrorMsg = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c != null && r.National_Id_Value__c == null){
                r.National_Id_Value__c.addError('Please enter National ID/ ARC');
                returnErrorMsg = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && 
                    r.National_ID_Type__c != null && r.National_Id_Value__c != null && r.National_ID_Length__c != 10){
                r.National_Id_Value__c.addError('National ID/ ARC should be 10 characters');
                returnErrorMsg = true;               
            }
            
            system.debug('@@Business Letter!!'+returnErrorMsg);    
            if(returnErrorMsg)
                returnErrorMsgFinally = returnErrorMsg;                                             
        }
        
        // Business Visa Letter Validation END ----
            
        // Personal Visa Letter – Asia Validation START ----
        if (rL.reference_letter_code__c  == 'RL0009'){              
            Boolean returnErrorMsgPers=false;               
            if(r.Destination__c==null || r.Destination__c==''){
                r.Destination__c.addError('Please select Country the visa application is for');
                returnErrorMsgPers = true;
            }
            if(r.Date_of_Travel__c == null || (system.today() > r.Date_of_Travel__c || r.Date_of_Travel__c > r.Return_Date__c) ){
                r.Date_of_Travel__c.addError('Please select Vacation Start Date');
                if(system.today() > r.Date_of_Travel__c || r.Date_of_Travel__c>r.Return_Date__c){
                    r.Date_of_Travel__c.addError('Vacation Start Date cannot be after Vacation End Date or earlier to today');
                }
                returnErrorMsgPers = true;
            }
            if(r.Return_Date__c == null || (system.today() > r.Return_Date__c || r.Date_of_Travel__c > r.Return_Date__c)){
                r.Return_Date__c.addError('Please select Vacation End Date');
                if(system.today() > r.Return_Date__c || r.Date_of_Travel__c>r.Return_Date__c){
                    r.Return_Date__c.addError('Vacation End Date cannot be earlier than Vacation Start Date or today');
                }                    
                returnErrorMsgPers = true;
            }
            if((r.Include_Family_Members__c==true)&&( r.Name_of_the_Person__c== null || r.Name_of_the_Person__c=='')){
                r.Name_of_the_Person__c.addError('Please enter Name');
                returnErrorMsgPers = true;
            }  
            if((r.Include_Family_Members__c==true)&&( r.Relationship__c== null || r.Relationship__c=='')){
                r.Relationship__c.addError('Please select Relationship');
                returnErrorMsgPers = true;               
            }
            
            // 06/26/2015 - Avinash Munaga
            // validation for National Id/ ARC
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c == null && r.National_Id_Value__c != null){
                r.National_ID_Type__c.addError('Please select National ID Type');
                returnErrorMsgPers = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && r.National_ID_Type__c != null && r.National_Id_Value__c == null){
                r.National_Id_Value__c.addError('Please enter National ID/ ARC');
                returnErrorMsgPers = true;               
            }
            if(requesteeEmp.Job_Country_Job__C == 'TWN' && 
                    r.National_ID_Type__c != null && r.National_Id_Value__c != null && r.National_ID_Length__c != 10){
                r.National_Id_Value__c.addError('National ID/ ARC should be 10 characters');
                returnErrorMsgPers = true;               
            }
                
            if(returnErrorMsgPers)
                returnErrorMsgFinally = returnErrorMsgPers;
        }       
        // Personal Visa Letter – Asia Validation END ----
            
        // MS Travel Insurance Cover Note - ASIA - Validation Start ---
        if(rl.reference_letter_code__c == 'RL0015'){
            if(r.Include_Family_Members__c && (r.Name_of_the_Person__c==null || r.Name_of_the_Person__c=='')){
                r.Name_of_the_Person__c.addError('Please enter Dependent Name');
                returnErrorMsgFinally = true;
            }
        }
        // MS Travel Insurance Cover Note - ASIA - Validation End ---
            
        //Rental Application Letter - ASIA - Validation Start --
        if(rl.reference_letter_code__c == 'RL0006'){
            Boolean returnErrorMsgRentApp = false;
            if(r.Employee_Office_Address__c== null || r.Employee_Office_Address__c==''){
                r.Employee_Office_Address__c.addError('Please enter Address of Property'); 
                returnErrorMsgRentApp = true;
            }
            
            if((r.Address_Letter_To__c == 'Specify Name/Address') && (r.Receipient_Name__c == null || r.Receipient_Name__c == ''
                    || r.Receipient_Name__c == 'Whom It May Concern')){
                r.Receipient_Name__c.addError('Please enter Recipient Name, "Whom It May Concern" is not valid');
                returnErrorMsgRentApp= true;
            }
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_1__c == '' || r.Recipent_Address_Line_1__c == null)){
                r.Recipent_Address_Line_1__c.addError('Please enter Address Line 1');
                returnErrorMsgRentApp=true;
            }
            /*if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_2__c == '' || r.Recipent_Address_Line_2__c == null)){
                r.Recipent_Address_Line_2__c.addError('Please enter Address Line 2');
                returnErrorMsgRentApp=true;
            }
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Line_3__c == '' || r.Recipent_Address_Line_3__c == null)){
                r.Recipent_Address_Line_3__c.addError('Please enter Address Line 3');
                returnErrorMsgRentApp=true;
            }*/
            if((r.Address_Letter_To__c == 'Specify Name/Address')
                    && (r.Recipent_Address_Country__c == '' || r.Recipent_Address_Country__c == null)){
                r.Recipent_Address_Country__c.addError('Please select the country');
                returnErrorMsgRentApp=true;
            }
                
            if(returnErrorMsgRentApp)
                returnErrorMsgFinally = returnErrorMsgRentApp;
        }
        //Rental Application Letter - ASIA - Validation End --
            
        // HK Schengen Multiple Entry Visa Application Letter - ASIA - Validation Statr --            
        if(rl.reference_letter_code__c == 'RL0008'){
            returnErrorMsgFinally = false;
            if(r.Destination__c == null || r.Destination__c == ''){
                r.Destination__c.addError('Please select Country the visa application is for');
                returnErrorMsgFinally=true;
            }
            if(r.Commencement_date_for_visa__c ==null || system.today() > r.Commencement_date_for_visa__c ){
                r.Commencement_date_for_visa__c.addError('Please select Commencement date for visa');
                if(system.today() > r.Commencement_date_for_visa__c){
                    r.Commencement_date_for_visa__c.addError('Commencement date for visa cannot be earlier than today');
                }
                returnErrorMsgFinally=true;
            }
            // Commented for ALM290 and added new condition
         /*   
            if(( r.Duration_in_Day__c=='Day(s)' && r.Duration_in_Week__c =='Week(s)'&& r.Duration_in_Month__c =='Month(s)'
            && r.Duration_in_Year__c =='Year(s)') || (r.Duration_in_Day__c=='0' && r.Duration_in_Week__c =='0' 
            && r.Duration_in_Month__c =='0' && r.Duration_in_Year__c =='0') && requesteeEmp.Job_Country_Job__c != 'IND') {
                r.Duration_in_Day__c.addError('Please select Duration');
                returnErrorMsgFinally=true;
            }
        */  
           if(( r.Duration_in_Day__c=='Day(s)' && r.Duration_in_Week__c =='Week(s)'&& r.Duration_in_Month__c =='Month(s)'
            && r.Duration_in_Year__c =='Year(s)') || ((r.Duration_in_Day__c=='0' || r.Duration_in_Day__c==null) && (r.Duration_in_Week__c =='0' || r.Duration_in_Week__c ==null) 
            && (r.Duration_in_Month__c =='0' || r.Duration_in_Month__c ==null) && (r.Duration_in_Year__c =='0' || r.Duration_in_Year__c ==null)) || ((r.Duration_in_Day__c=='0' || r.Duration_in_Day__c==null) || (r.Duration_in_Month__c =='0' || r.Duration_in_Month__c==null)) && requesteeEmp.Job_Country_Job__c != 'IND') {
             //   r.Duration_in_Day__c.addError('Please select Duration');
                returnErrorMsgFinally=true;
            }
            /*if((r.Duration_in_Day__c== null || r.Duration_in_Day__c=='') && r.Employee_Job_Country__c!='IND'){
                r.Duration_in_Day__c.addError('Please select Duration');
                returnErrorMsgFinally=true;
            } */           
        }
        // HK Schengen Multiple Entry Visa Application Letter - ASIA - Validation End --
            
        //9.1.8    HK Exempt from Jury Duty - ASIA - Validation Start --
        if(rl.reference_letter_code__c == 'RL0010'){
            returnErrorMsgFinally = false;
            if(r.Hong_Kong_ID_Card_Number__c == null || r.Hong_Kong_ID_Card_Number__c == ''){
                r.Hong_Kong_ID_Card_Number__c.addError('Please enter Hong Kong ID Card Number');
                returnErrorMsgFinally=true;
            }   
            if(r.Court_Date__c == null ){
                r.Court_Date__c.addError('Please select Court Date');
                returnErrorMsgFinally=true;
            }  
            if(r.Reason_for_Exemption__c == null || r.Reason_for_Exemption__c == ''){
                r.Reason_for_Exemption__c.addError('Please enter Reason for Exemption');
                returnErrorMsgFinally=true;
            }                                           
        }
        //9.1.8    HK Exempt from Jury Duty - ASIA - Validation End --
        // Bank Account Request Letter - Validation Start --
        if(rl.reference_letter_code__c == 'RL0023'){
             returnErrorMsgFinally = false;
            if(r.Bank_Account_Name__c == null || r.Bank_Account_Name__c == ''){
                r.Bank_Account_Name__c.addError('Please enter Bank Name');
                returnErrorMsgFinally=true;
            }   
        }  
        //  Bank Account Request Letter - Validation End --
        
        system.debug('@@!!'+returnErrorMsgFinally);
        return returnErrorMsgFinally;
    }
        
    // reset fields on page
    public void resetFields(Reference_Letter_Request__c r){
        r.Include_Date_of_Birth__c = false;
        r.Include_Home_Address__c = false;
        r.Include_Passport_Number__c = false;
        r.Include_Current_Base_Salary__c = false;
        r.Include_Total_Compensation__c= false;
        r.Include_Family_Members__c = false;
        r.Require_HSBC_Endorsement__c = false;
        r.Include_Family_Members__c = false;
        r.Include_Hard_Copy__c = false;
        r.Last_Name_check__c = false;
        r.Middle_Name_Check__c = false;
        
        r.Passport_Issuing_Country__c = null;
        r.Passport_Expiry_Date__c = null;
        r.Visa_Validity_Period__c = null;
        r.Address_Letter_To__c = null;
        r.Address_by_Reference__c = null;
        r.Destination__c = null;
        r.Date_of_Travel__c = null;
        r.Return_Date__c = null;
        r.Relationship__c = null;
        r.Court_Date__c = null;
        r.Commencement_date_for_visa__c = null;
        r.Duration_in_Day__c = null;
        r.Duration_in_Week__c = null;
        r.Duration_in_Month__c = null;
        r.Duration_in_Year__c = null;
        r.Type_of_Visa__c = null;
        r.Bank_Name__c = null;
        r.National_ID_Type__c = null;
        r.Consulate_Country__c = null;
        
        r.Consulate_Name__c = '';
        r.Inviting_Organisation__c = '';
        r.Consulate_Address__c = '';
        r.Reason_for_Exemption__c = '';
        r.Passport_Number__c = '';
        r.Receipient_Name__c = '';
        r.Recipient_Address__c = '';
        
        r.Recipent_Address_Line_1__c = '';
        r.Recipent_Address_Line_2__c = '';
        r.Recipent_Address_Line_3__c = '';
        r.Recipent_Address_Country__c = null;
        
        r.Name_of_the_Person__c = '';
        r.Name_Of_The_Person2__c = '';
        r.Name_Of_The_Person3__c = '';
        r.Name_Of_The_Person4__c = '';
        r.Name_Of_The_Person5__c = '';
        r.Name_Of_The_Person6__c = '';
        r.Name_Of_The_Person7__c = '';
        r.Name_Of_The_Person8__c = '';
        r.Name_Of_The_Person9__c = '';
        r.Name_Of_The_Person10__c = '';
        r.Hong_Kong_ID_Card_Number__c = '';
        r.Employee_Office_Address__c = '';
        r.Company_Address_Title__c = '';
        r.Company_Address_Name__c = '';
        r.Company_Address_SName__c = '';
        r.Company_Name__c = '';
        r.Company_Address_1__c = '';
        r.Company_Address_2__c = '';
        r.Company_Address_3__c = '';
        r.Company_Address_4__c = '';
        r.Company_Address_PC__c = null;
        r.Address_1_Prev__c = '';
        r.Address_2_Prev__c = '';
        r.Address_3_Prev__c = '';
        r.Address_4_Prev__c = '';
        r.National_Id_Value__c = '';
    }
    
    public String buildDOBText(Reference_Letter_Request__c rlRequest){
        String returnText = '';
        
        if(rlRequest != null) {
            if(rlRequest.Include_Date_of_Birth__c == true){
                returnText += ' (Date Of Birth: ' + rlRequest.Birth_Date__c + ')';
                System.debug('**********Birth_Date__c****** : ' + rlRequest.Birth_Date__c  );
            }
        }
        
        return returnText;
    }
    
    public String buildTemplateText(Reference_Letter_Request__c rlRequest) {
        
        String returnText = '';
        
        if(rlRequest != null) {
            
            String empdetail = rlRequest.Conga_Title__c + ' ' + rlRequest.Conga_Last_Name__c;
            if(rlRequest.Last_Name_check__c == false)
                empdetail += '\'s';
            
            String baseSalary = null, 
                    previousTotalReward = null, 
                    passport = null, 
                    homeAddress = null, 
                    nationalId = null;

            if(rlRequest.CONGA_JOB_COUNTRY_JOB__c == 'JPN' 
                        && rlRequest.CONGA_LEVEL_JOB__c == '40' 
                        && rlRequest.INCLUDE_CURRENT_BASE_SALARY__c == TRUE) {
                baseSalary = empdetail + ' ' + System.Label.RL_Base_JPN_40 
                        + ' ' + rlRequest.BASE_ANNUAL_CURRENCY__c + ' ' + rlRequest.BASE_ANNUAL_AMOUNT__c + '.';
            }  else if(rlRequest.CONGA_JOB_COUNTRY_JOB__c == 'JPN' 
                        && rlRequest.CONGA_LEVEL_JOB__c != '40' 
                        && rlRequest.INCLUDE_CURRENT_BASE_SALARY__c == TRUE) {
                baseSalary = empdetail + ' ' + System.Label.RL_Base_JPN_Not40 
                        + ' ' + rlRequest.BASE_ANNUAL_CURRENCY__c + ' ' + rlRequest.BASE_ANNUAL_AMOUNT__c + '.';
            } else if(rlRequest.CONGA_JOB_COUNTRY_JOB__c != 'JPN' 
                        && rlRequest.CONGA_JOB_COUNTRY_JOB__c != 'IND' 
                        && rlRequest.INCLUDE_CURRENT_BASE_SALARY__c == TRUE) {
                baseSalary = empdetail + ' ' + System.Label.RL_Base_All 
                        + ' ' + rlRequest.BASE_ANNUAL_CURRENCY__c + ' ' + rlRequest.BASE_ANNUAL_AMOUNT__c + '.';
            }
            
            // ALM 257: Removed condition that excluded Job Country IND
            if(rlRequest.INCLUDE_TOTAL_COMPENSATION__c == TRUE  
                        && rlRequest.PREVIOUS_YEAR_TRWD_AMOUNT__c != '0'
                        && rlRequest.PREVIOUS_YEAR_TRWD_AMOUNT__c != null
                        && rlRequest.PREVIOUS_YEAR_TRWD_AMOUNT__c != '') {
                previousTotalReward = empdetail + ' ' + rlRequest.Prior_Comp_Year__c + ' '
                            + System.Label.RL_Previous_Total_Reward + ' ' + rlRequest.PREVIOUS_YEAR_TRWD_CURRENCY__c 
                            + ' ' + rlRequest.PREVIOUS_YEAR_TRWD_AMOUNT__c + '.';
            }
            
            if(rlRequest.INCLUDE_HOME_ADDRESS__c == TRUE) {
                homeAddress = 'According to our records, ' + empdetail + ' ' + System.Label.RL_Address 
                            + '<br/>' + rlRequest.Person_RelationShip_Table__c;
            }
            
            if(rlRequest.INCLUDE_PASSPORT_NUMBER__c == TRUE) {
                passport = 'According to our records, ' + empdetail + ' ' 
                            + rlRequest.PASSPORT_ISSUING_COUNTRY__c + ' ' + System.Label.RL_Passport 
                            + ' ' + rlRequest.PASSPORT_NUMBER__c;
                if(rlRequest.reference_letter_code__c  == 'RL0002' 
                                    && rlRequest.CONGA_JOB_COUNTRY_JOB__c == 'IND') {
                    passport += ', issued by' + rlRequest.PASSPORT_ISSUING_CITY__c + ' on ' 
                                + rlRequest.PASSPORT_DATE__c + ' and expiring on ' 
                                + rlRequest.PASSPORT_EXPIRY_DATE__c + '.';
                } else {
                     passport += '.';
                }
            }
            
            if(rlRequest.US_Expert__c == TRUE) {
                nationalId = 'According to our records, ' + empdetail + ' ' + rlRequest.NATIONAL_ID_TYPE__C 
                            + ' is ' + rlRequest.NATIONAL_ID_VALUE__c + '.';
            }
            
            if (rlRequest.reference_letter_code__c  == 'RL0001') {
                if(baseSalary != null) {
                    returnText += baseSalary;
                }
                
                if(previousTotalReward != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + previousTotalReward;
                    } else {
                        returnText += previousTotalReward;
                    }
                }
                if(homeAddress != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + homeAddress;
                    } else {
                        returnText += homeAddress;
                    }
                }
                if(passport != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + passport;
                    } else {
                        returnText += passport;
                    }
                }
                if(nationalId != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + nationalId;
                    } else {
                        returnText += nationalId;
                    }
                }
            } else if (rlRequest.reference_letter_code__c  == 'RL0002') {
                if(passport != null)
                    returnText += passport;
                /*
                if(nationalId != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + nationalId;
                    } else {
                        returnText += nationalId;
                    }
                }*/
            } else if (rlRequest.reference_letter_code__c  == 'RL0006') {
                if(baseSalary != null) {
                    returnText += baseSalary;
                }
                
                if(previousTotalReward != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + previousTotalReward;
                    } else {
                        returnText += previousTotalReward;
                    }
                }
            } else if (rlRequest.reference_letter_code__c  == 'RL0009') {
                if(nationalId != null) {
                    returnText += nationalId;
                }
            } else if (rlRequest.reference_letter_code__c  == 'RL0022') {
                if(passport != null)
                    returnText += passport;
                
                if(homeAddress != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + homeAddress;
                    } else {
                        returnText += homeAddress;
                    }
                }
            }
            else if (rlRequest.reference_letter_code__c  == 'RL0111') {
                if(baseSalary != null) {
                    returnText += baseSalary;
                }
                
                if(previousTotalReward != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + previousTotalReward;
                    } else {
                        returnText += previousTotalReward;
                    }
                }
                if(homeAddress != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + homeAddress;
                    } else {
                        returnText += homeAddress;
                    }
                }
                if(passport != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + passport;
                    } else {
                        returnText += passport;
                    }
                }
                if(nationalId != null) {
                    if(returnText != null && returnText != '') {
                        returnText += '<br/><br/>' + nationalId;
                    } else {
                        returnText += nationalId;
                    }
                }
            }
            
            if(returnText != null && returnText != '') {
                returnText += '<br/><br/>';
            }
            
        }
        
        return returnText;
    }
}