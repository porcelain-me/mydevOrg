public class RIF_RegionalAccrualsUploadController {
    
    //Getter-Setters
    public Blob csvFileBody{get;set;}
    public string fileNameCSV{get;set;}
    public transient List<Accrual_Information__c > accrualsList{get;set;}
    public transient List <wrapperError> wrapperErrorList    {get;set;}
    public transient List<RIF_File_Upload_History__c> lstHistoryLoad {get;set;} 
    public transient List<string> faultyEmpIDs{get;set;}
    public string errorMessageString {get;set;}
    
    //Variables 
    private static final string FILETYPE='Accrual';  
    private string csvAsString;
    private transient String[] csvFileLines;
    private Map <string,string> msIDWithErrorMessageMap;
    
    //Controller
    public RIF_RegionalAccrualsUploadController (){
        csvFileLines = new String[]{};
            //errorMessageString='';
            accrualsList= New List<Accrual_Information__c >(); 
        faultyEmpIDs=new List<string> ();
        wrapperErrorList    = new List <wrapperError> () ;
        msIDWithErrorMessageMap= new Map <string,string>();
        lstHistoryLoad = new List<RIF_File_Upload_History__c> (RIF_DataUtil.getFileUploadHistories(FILETYPE)); 
    }
    
    //method invoked while uploading csv file on page
    public pageReference importCSVFile(){ 
        
        try{
            accrualsList= New List<Accrual_Information__c >(); 
            faultyEmpIDs=new List<string> ();
            wrapperErrorList    = new List <wrapperError> () ;
            msIDWithErrorMessageMap= new Map <string,string>();
            //accrualsList.clear();
            // faultyEmpIDs.clear();
            //wrapperErrorList   .clear();
            system.debug('#####importCSVFile() called#####');
            if(csvFileBody == null && (errorMessageString=='' || errorMessageString==null)) {
                //ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please Upload a CSV file.');
                //ApexPages.addMessage(errorMessage);
                errorMessageString='Please Upload a CSV file.';
                return null;
            }
            else if(csvFileBody != null && (errorMessageString!=Null || errorMessageString!='')){
                errorMessageString=null;
                //return null; 
            }  
            system.debug('#####csvFileBody #####'+csvFileBody );
            csvAsString = csvFileBody.toString();
            system.debug('#####csvAsString #####'+csvAsString );
            csvFileLines = csvAsString.split('\n'); 
            System.debug('####csvFileLines[1].split###'+csvFileLines[1].split(','));
            
            for(Integer i=1;i<csvFileLines.size();i++) {
                string[] csvRecordData = csvFileLines[i].split(','); 
                system.debug('csvRecord'+csvRecordData);
                integer tempCount=i+1;
                Accrual_Information__c accrualObj= new Accrual_Information__c();
                //String csvRecordData[0].trim()='';
                //system.debug('*****************0'+csvRecordData[0] );  
                //csvRecordData[0].trim()=Rif_DataUtil.getSingleEmployeeRecord(csvRecordData[0].trim()).Emp_ID__c;
                //system.debug( );  
                //accrualObj.Emp_Id__c =csvRecordData[0].trim() ;
                if((csvRecordData[0]==''))
                    createErrorMessageWithMSID('Row '+tempCount , 'Emp_Id__c', 'Error:Emp_Id__c shouldn\'t be blank');     
                else
                    accrualObj.Emp_Id__c =  csvRecordData[0].trim();
                system.debug('*********accrualObj.Emp_Id__c ********'+accrualObj.Emp_Id__c ); 
                accrualObj.Base_Currency__c= csvRecordData[1].trim();
                
                if((csvRecordData[2]==''))
                    //createErrorMessageWithMSID('Row '+tempCount , 'Benefits__c', 'Error:Benefits__c shouldn\'t be blank');    
                    accrualObj.Benefits__c = '0';
                else
                    accrualObj.Benefits__c =  csvRecordData[2].trim();
                        
                if(csvRecordData[3]== '')
                    accrualObj.Curr_Benefits__c =  accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_Benefits__c =  csvRecordData[3].trim(); 
                
                if((csvRecordData[4]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Buy_Out_of_Notice_Per_Lcl__c', 'Error:Buy_Out_of_Notice_Per_Lcl__c shouldn\'t be blank');    
                    accrualObj.Buy_Out_of_Notice_Per_Lcl__c = '0';
                else
                    accrualObj.Buy_Out_of_Notice_Per_Lcl__c =  csvRecordData[4].trim();
                    
                if( csvRecordData[5]=='')
                    accrualObj.Curr_Buyout_of_Notice_Pd__c =  accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_Buyout_of_Notice_Pd__c =  csvRecordData[5].trim();
                
                system.debug('*****************1'+csvRecordData[6]);
                if(csvRecordData[6] != '') {//&& csvRecordData[6] != null
                    try{
                        // 10-Oct-17 : Corrected below logic to show errors for invalid boolean values
                        if( (csvRecordData[6]!='') && (!((String.valueOf(csvRecordData[6]).equalsIgnoreCase('true')) || (String.valueOf(csvRecordData[6]).equalsIgnoreCase('false'))
                                                         ||(String.valueOf(csvRecordData[6]).equalsIgnoreCase('t')) || (String.valueOf(csvRecordData[6]).equalsIgnoreCase('f'))
                                                         ||(String.valueOf(csvRecordData[6]).equalsIgnoreCase('yes')) || (String.valueOf(csvRecordData[6]).equalsIgnoreCase('no'))
                                                         ||(String.valueOf(csvRecordData[6]).equalsIgnoreCase('y')) || (String.valueOf(csvRecordData[6]).equalsIgnoreCase('n'))
                                                         ||(String.valueOf(csvRecordData[6]).equalsIgnoreCase('1')) || (String.valueOf(csvRecordData[6]).equalsIgnoreCase('0'))
                                                        ) )){
                        	               						createErrorMessageWithMSID('Row '+tempCount, 'Communicated__c', 'Error:Communicated__c should have a boolean value');                                
                        }
                        else{
                            accrualObj.Communicated__c =   getBooleanValue(csvRecordData[6].trim());
                        }
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'COMMUNICATED__C ' , e.getMessage());
                    }
                    
                }
                
                system.debug('*****************2');
                if(csvRecordData[7] != '' ) { //&& csvRecordData[7] != null
                    try{
                        accrualObj.Communicated_Date__c =  Date.parse(csvRecordData[7].trim());
                        if(accrualObj.Communicated_Date__c > Date.today())
                            createErrorMessageWithMSID('Row '+tempCount, 'Communicated_Date__c', 'Error:Communicated_Date__c shouldn\'t be future date');                                
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'COMMUNICATED_DATE__C', e.getMessage());
                    }
                }
              
                accrualObj.Cost_Center__c =  csvRecordData[8].trim();
            if((csvRecordData[8]==''))
                    createErrorMessageWithMSID('Row '+tempCount, 'Cost_Center__c', 'Error:Cost_Center__c shouldn\'t be blank');
            else{
                   accrualObj.Cost_Center__c =  csvRecordData[8].trim();
            }
                  system.debug('csvRecordData[9].trim()--'+csvRecordData[9].trim()+'--csvRecordData[10].trim()--'+csvRecordData[10].trim());                    
                
           accrualObj.Cost_Center_Desc__c =  csvRecordData[9].trim();
               
              if((csvRecordData[10]==''))
                    createErrorMessageWithMSID('Row '+tempCount, 'Daily_Rate__c', 'Error:Daily_Rate__c shouldn\'t be blank');
              else{
                   accrualObj.Daily_Rate__c =  csvRecordData[10].trim().trim();
                   System.debug('@@@@@@@@'+accrualObj.Daily_Rate__c);
               }
               

                /*if((csvRecordData[11]==''))
                    createErrorMessageWithMSID('Row '+tempCount, 'Department__c', 'Error:Department__c shouldn\'t be blank');   
                else*/
                    accrualObj.Department__c =  csvRecordData[11].trim();
                accrualObj.Department_Desc__c =  csvRecordData[12].trim();
            
                /*if((csvRecordData[13]==''))
                    createErrorMessageWithMSID('Row '+tempCount, 'Division__c', 'Error:Division__c shouldn\'t be blank');    
                else*/
                    accrualObj.Division__c =  csvRecordData[13].trim();
                    
                accrualObj.Division_Desc__c =  csvRecordData[14].trim();
                
                if((csvRecordData[15]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Enhanced_Severance_Lcl__c', 'Error:Enhanced_Severance_Lcl__c shouldn\'t be blank');   
                    accrualObj.Enhanced_Severance_Lcl__c= '0';
                else
                	accrualObj.Enhanced_Severance_Lcl__c=  csvRecordData[15].trim();
                
                if(csvRecordData[16]=='')
                    accrualObj.Curr_Enh__c= accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_Enh__c =  csvRecordData[16].trim();
                
                if(csvRecordData[17] != '' ){ //&& csvRecordData[17] != null
                    try{
                        accrualObj.Last_Day_on_Premises__c =  Date.parse(csvRecordData[17].trim());
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Last_Day_on_Premises__c', e.getMessage());
                    }
                }
                system.debug('*****************4');                    
                if(csvRecordData[18] != '') { // && csvRecordData[18] != null
                    try{
                        // 10-Oct-17 : Corrected below logic to show errors for invalid boolean values
                        if( (csvRecordData[18]!='') && (!((String.valueOf(csvRecordData[18]).equalsIgnoreCase('true')) || (String.valueOf(csvRecordData[18]).equalsIgnoreCase('false'))
                                                          ||(String.valueOf(csvRecordData[18]).equalsIgnoreCase('t')) || (String.valueOf(csvRecordData[18]).equalsIgnoreCase('f'))
                                                          ||(String.valueOf(csvRecordData[18]).equalsIgnoreCase('yes')) || (String.valueOf(csvRecordData[18]).equalsIgnoreCase('no'))
                                                          ||(String.valueOf(csvRecordData[18]).equalsIgnoreCase('y')) || (String.valueOf(csvRecordData[18]).equalsIgnoreCase('n'))
                                                            ||(String.valueOf(csvRecordData[18]).equalsIgnoreCase('1')) || (String.valueOf(csvRecordData[18]).equalsIgnoreCase('0'))
                                                         ) )){
                                                             	createErrorMessageWithMSID('Row '+tempCount, 'Severance_Package_Communicated__c ', 'Error:Severance_Package_Communicated__c should have a boolean value');
                        }
                        else{
                            accrualObj.Severance_Package_Communicated__c =  getBooleanValue(csvRecordData[18].trim());
                        }
                            
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Severance_Package_Communicated__c ' , e.getMessage());
                    }
                }
                
                system.debug('*****************5');
                accrualObj.Super_Department__c =  csvRecordData[19].trim();
                /*if((csvRecordData[19]==''))
                    createErrorMessageWithMSID('Row '+tempCount, 'Super_Department__c', 'Error:Super_Department__c shouldn\'t be blank');    
                else{
                accrualObj.Super_Department__c =  csvRecordData[19].trim();
                }*/
                
                accrualObj.Super_Department_Desc__c =  csvRecordData[20].trim();
               
                /*if((csvRecordData[21]==''))
                   createErrorMessageWithMSID('Row '+tempCount, 'Super_Division__c', 'Error:Super_Division__c shouldn\'t be blank'); 
                else*/
                 accrualObj.Super_Division__c =  csvRecordData[21].trim();
                 
                 accrualObj.Super_Division_Desc__c =  csvRecordData[22].trim();
                if(csvRecordData[23] != '' ) {//&& csvRecordData[23] != null
                    try{
                        accrualObj.Termination_Date__c =  Date.parse(csvRecordData[23].trim());
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Termination_Date__c', e.getMessage());
                    }
                }
                system.debug('*****************6');                    
                if(csvRecordData[24] != '' ) { //&& csvRecordData[24] != null
                    try{
                        // 10-Oct-17 : Corrected below logic to show errors for invalid boolean values
                        if( (csvRecordData[24]!='') && (!((String.valueOf(csvRecordData[24]).equalsIgnoreCase('true')) || (String.valueOf(csvRecordData[24]).equalsIgnoreCase('false'))
                                                          ||(String.valueOf(csvRecordData[24]).equalsIgnoreCase('t')) || (String.valueOf(csvRecordData[24]).equalsIgnoreCase('f'))
                                                          ||(String.valueOf(csvRecordData[24]).equalsIgnoreCase('yes')) || (String.valueOf(csvRecordData[24]).equalsIgnoreCase('no'))
                                                          ||(String.valueOf(csvRecordData[24]).equalsIgnoreCase('y')) || (String.valueOf(csvRecordData[24]).equalsIgnoreCase('n'))
                                                           ||(String.valueOf(csvRecordData[24]).equalsIgnoreCase('1')) || (String.valueOf(csvRecordData[24]).equalsIgnoreCase('0'))
                                                         ) )){
                                                             	createErrorMessageWithMSID('Row '+tempCount, 'Voluntary_Involuntary_Flg__c ', 'Error:Voluntary_Involuntary_Flg__c should have a boolean value');
                                                         }
                        else{
                            accrualObj.Voluntary_Involuntary_Flg__c =  getBooleanValue(csvRecordData[24].trim());
                        }
                    } catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Voluntary_Involuntary_Flg__c ', e.getMessage());
                    }
                }        
                
                //system.debug('*****************7'+csvRecordData[25]);
                if(csvRecordData[25] != '') { // && csvRecordData[25] != null
                    try{
                        // 10-Oct-17 : Corrected below logic to show errors for invalid boolean values
                        if( (csvRecordData[25]!='') && (!((String.valueOf(csvRecordData[25]).equalsIgnoreCase('true')) || (String.valueOf(csvRecordData[25]).equalsIgnoreCase('false'))
                                                          ||(String.valueOf(csvRecordData[25]).equalsIgnoreCase('t')) || (String.valueOf(csvRecordData[25]).equalsIgnoreCase('f'))
                                                          ||(String.valueOf(csvRecordData[25]).equalsIgnoreCase('yes')) || (String.valueOf(csvRecordData[25]).equalsIgnoreCase('no'))
                                                          ||(String.valueOf(csvRecordData[25]).equalsIgnoreCase('y')) || (String.valueOf(csvRecordData[25]).equalsIgnoreCase('n'))
                                                           ||(String.valueOf(csvRecordData[25]).equalsIgnoreCase('1')) || (String.valueOf(csvRecordData[25]).equalsIgnoreCase('0'))
                                                         ) )){
                                                             	createErrorMessageWithMSID('Row '+tempCount, 'Work_Requirement_for_Severance__c ', 'Error:Work_Requirement_for_Severance__c should have a boolean value');
                        }
                        else{
                            accrualObj.Work_Requirement_for_Severance__c =  getBooleanValue(csvRecordData[25].trim());
                        }
                    } catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Work_Requirement_for_Severance__c ', e.getMessage());
                    }
                }        
                //system.debug('*****************8');
                
                if((csvRecordData[26]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Pay_In_Lieu_of_Ben_Lcl__c', 'Error:Pay_In_Lieu_of_Ben_Lcl__c shouldn\'t be blank');    
                 	accrualObj.Pay_In_Lieu_of_Ben_Lcl__c=  '0';
                else
                	accrualObj.Pay_In_Lieu_of_Ben_Lcl__c=  csvRecordData[26].trim();
                
                if( csvRecordData[27] =='')
                    accrualObj.Curr_PIL__c = accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_PIL__c =  csvRecordData[27].trim();
                
                accrualObj.CreatedById__c =  userInfo.getUserId();
                accrualObj.LastModifiedBy__c =  userInfo.getUserId();
                accrualObj.Last_Edited_Date__c = System.now();
                
                if((csvRecordData[28]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Buy_Out_of_Termination__c', 'Error:Buy_Out_of_Termination__c shouldn\'t be blank');    
                 	accrualObj.Buy_Out_of_Termination__c =  '0'; 
                else
                   accrualObj.Buy_Out_of_Termination__c =  csvRecordData[28].trim();
                
                if(csvRecordData[29]=='')
                    accrualObj.Curr_Buyout_of_Term__c= accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_Buyout_of_Term__c =  csvRecordData[29].trim();
                
                if((csvRecordData[30]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Ex_Gracia_Cash_Payment__c', 'Error:Ex_Gracia_Cash_Payment__c shouldn\'t be blank');    
                  	accrualObj.Ex_Gracia_Cash_Payment__c =  '0';
                else
                    accrualObj.Ex_Gracia_Cash_Payment__c =  csvRecordData[30].trim();
                
                if( csvRecordData[31] =='')
                    accrualObj.Curr_ExGCsh__c = accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_ExGCsh__c =  csvRecordData[31].trim();
                
                if((csvRecordData[32]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Pension_Contribution__c', 'Error:Pension_Contribution__c shouldn\'t be blank');    
                 	accrualObj.Pension_Contribution__c = '0';    
                else
                    accrualObj.Pension_Contribution__c =  csvRecordData[32].trim(); 
                
                if(csvRecordData[33] =='')
                	accrualObj.Curr_PenCont__c = accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_PenCont__c =  csvRecordData[33].trim();
                
                if((csvRecordData[34]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Social_Insurance__c', 'Error:Social_Insurance__c shouldn\'t be blank');   
					  accrualObj.Social_Insurance__c =  '0';                    
                else
                    accrualObj.Social_Insurance__c =  csvRecordData[34].trim();    
                 
                if(  csvRecordData[35] == '')
                    accrualObj.Curr_SocialIns__c = accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_SocialIns__c =  csvRecordData[35].trim();
                    
                if((csvRecordData[36]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Statutory_Redundancy_Pay__c', 'Error:Statutory_Redundancy_Pay__c shouldn\'t be blank');    
                   accrualObj.Statutory_Redundancy_Pay__c =  '0';
                else
                    accrualObj.Statutory_Redundancy_Pay__c =  csvRecordData[36].trim();    
                
                if( csvRecordData[37] =='')
                    accrualObj.Curr_StatRed__c = accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_StatRed__c =  csvRecordData[37].trim();
                
                if((csvRecordData[38]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Termination_Bonus__c', 'Error:Termination_Bonus__c shouldn\'t be blank');    
                     accrualObj.Termination_Bonus__c =  '0';   
                else
                    accrualObj.Termination_Bonus__c =  csvRecordData[38].trim(); 
                
                if(csvRecordData[39] =='')
                    accrualObj.Curr_TermBon__c = accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_TermBon__c =  csvRecordData[39].trim();
                
                //system.debug('*****************9'+csvRecordData[40]);
                if(csvRecordData[40] != '' ) { //&& csvRecordData[40] != null
                    try{
                        accrualObj.Consultation_Start_Date__c =  Date.parse(csvRecordData[40].trim());
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Consultation_Start_Date__c', e.getMessage());
                    }
                }
                system.debug('*****************10');
                if(csvRecordData[41] != '' ) {//&& csvRecordData[41] != null
                    try{
                        accrualObj.Consultation_End_Date__c =  Date.parse(csvRecordData[41].trim());
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Consultation_End_Date__c', e.getMessage());
                    }
                }
                system.debug('*****************11');                  
                //if(csvRecordData[42] != '' )//&& csvRecordData[42] != null
                    
               if((csvRecordData[42]==''))
                {
                    //createErrorMessageWithMSID('Row '+tempCount+1, 'Notice_Days__c ', 'Error:Notice_Days__c shouldn\'t be blank');    
                    if(accrualObj.Termination_Date__c!=null &&   accrualObj.Communicated_Date__c!=null)
                      accrualObj.Notice_Days__c =  Decimal.valueOf(accrualObj.Communicated_Date__c.daysBetween(accrualObj.Termination_Date__c) +1);
                }
               else
                    accrualObj.Notice_Days__c =  Decimal.valueOf(csvRecordData[42].trim());
               //system.debug('*****************12'+csvRecordData[42]);
                
                if((csvRecordData[43]==''))
                    createErrorMessageWithMSID('Row '+tempCount, 'Notice_Amount__c ', 'Error:Notice_Amount__c shouldn\'t be blank');
                else
                    accrualObj.Notice_Amount__c =  csvRecordData[43].trim();
                    
                if(csvRecordData[44] == '' )
                     //createErrorMessageWithMSID('Row '+tempCount, 'Basic_Severance__c ', 'Error:Basic_Severance__c shouldn\'t be blank'); 
                     accrualObj.Basic_Severance__c ='0';
                else   
                    accrualObj.Basic_Severance__c =  csvRecordData[44].trim(); 
                
                if(csvRecordData[45] == '')   
                    accrualObj.Cur_Basic_Severance__c =   accrualObj.Base_Currency__c;
                else
                    accrualObj.Cur_Basic_Severance__c =  csvRecordData[45].trim();
                
                if((csvRecordData[46]==''))
                    //createErrorMessageWithMSID('Row '+tempCount, 'Additional_Severance__c ', 'Error:Additional_Severance__c shouldn\'t be blank');     
                    accrualObj.Additional_Severance__c =  '0';
                else
                    accrualObj.Additional_Severance__c =  csvRecordData[46].trim();
                    
                if(csvRecordData[47] == '')   
                    accrualObj.Curr_Additional_Severance__c   =accrualObj.Base_Currency__c;
                else
                    accrualObj.Curr_Additional_Severance__c =  csvRecordData[47].trim();
                
                if(csvRecordData[48] != '' ) {
                    try{
                        // 10-Oct-17 : Corrected below logic to show errors for invalid boolean values
                        if( (csvRecordData[48]!='') && (!((String.valueOf(csvRecordData[48]).equalsIgnoreCase('true')) || (String.valueOf(csvRecordData[48]).equalsIgnoreCase('false'))
                                                          ||(String.valueOf(csvRecordData[48]).equalsIgnoreCase('t')) || (String.valueOf(csvRecordData[48]).equalsIgnoreCase('f'))
                                                          ||(String.valueOf(csvRecordData[48]).equalsIgnoreCase('yes')) || (String.valueOf(csvRecordData[48]).equalsIgnoreCase('no'))
                                                          ||(String.valueOf(csvRecordData[48]).equalsIgnoreCase('y')) || (String.valueOf(csvRecordData[48]).equalsIgnoreCase('n'))
                                                            ||(String.valueOf(csvRecordData[48]).equalsIgnoreCase('1')) || (String.valueOf(csvRecordData[48]).equalsIgnoreCase('0'))
                                                         ) )){
                                                             	createErrorMessageWithMSID('Row '+tempCount, 'Signed_Release_Returned__c ', 'Error:Signed_Release_Returned__c should have a boolean value');
                        }
                        else{
                            accrualObj.Signed_Release_Returned__c =  getBooleanValue(csvRecordData[48].trim());
                        }
                    } catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Signed_Release_Returned__c ', e.getMessage());
                    }
                }        
                //system.debug('*****************13'+csvRecordData[48]);
                // 10-Oct-17 : Corrected below logic to show errors for invalid boolean values
                if( (csvRecordData[49]!='') && (!((String.valueOf(csvRecordData[49]).equalsIgnoreCase('true')) || (String.valueOf(csvRecordData[49]).equalsIgnoreCase('false'))
                                                  ||(String.valueOf(csvRecordData[49]).equalsIgnoreCase('t')) || (String.valueOf(csvRecordData[49]).equalsIgnoreCase('f'))
                                                  ||(String.valueOf(csvRecordData[49]).equalsIgnoreCase('yes')) || (String.valueOf(csvRecordData[49]).equalsIgnoreCase('no'))
                                                  ||(String.valueOf(csvRecordData[49]).equalsIgnoreCase('y')) || (String.valueOf(csvRecordData[49]).equalsIgnoreCase('n'))
                                                    ||(String.valueOf(csvRecordData[49]).equalsIgnoreCase('1')) || (String.valueOf(csvRecordData[49]).equalsIgnoreCase('0'))
                                                 ) )){
                                                     	createErrorMessageWithMSID('Row '+tempCount, 'Event_Related_Term__c ', 'Error:Event_Related_Term__c should have a boolean value'); 
                }
                else{
                    accrualObj.Event_Related_Term__c =csvRecordData[49].trim();
                }
                //system.debug('*****************14'+csvRecordData[50]);
                if(csvRecordData[50] != '' ) {//&& csvRecordData[50] != null
                    try{
                        accrualObj.Latest_Payroll_Sent_Date__c =  Date.parse(csvRecordData[50].trim());
                    }
                    catch(Exception e){
                        createErrorMessageWithMSID('Row '+tempCount, 'Latest_Payroll_Sent_Date__c ', e.getMessage());
                    }
                }
                
                accrualObj.Accrual_Type__c =  csvRecordData[51].trim();
                if( (csvRecordData[51]!='') && (!((accrualObj.Accrual_Type__c.equalsIgnoreCase('Active')) || (accrualObj.Accrual_Type__c.equalsIgnoreCase('Inactive') )))   )
                    createErrorMessageWithMSID('Row '+tempCount, 'Accrual_Type__c', 'Error:Accrual Type should be either \'Active\' or \'Inactive\''); 
                
                System.debug('***********Read alll Accrual Information');
                if( (msIDWithErrorMessageMap==null) || (!msIDWithErrorMessageMap.containsKey('Row '+tempCount)))  
                    accrualsList.add(accrualObj);
                else if(msIDWithErrorMessageMap!=null && msIDWithErrorMessageMap.containsKey('Row '+tempCount)){
                   System.debug('####msIDWithErrorMessageMap On line no 363####'+ msIDWithErrorMessageMap); 
                    // 10-Oct-17 : JIRA#RIF-119 : Corrected the value in the column
                    wrapperErrorList.add(new wrapperError('Row '+ Integer.valueOf(tempCount - 1),msIDWithErrorMessageMap.get('Row '+tempCount), csvRecordData[0]));      
                }        
                System.debug('**********Finishaefd *Read alll Accrual Information');
                
            } 
            String errorMessageString='';
            try{
                System.debug('**********Starting Insert Accrual Information'+accrualsList);
                
                Database.SaveResult[] SR = Database.insert(accrualsList, False);
                System.debug('SaveResult: ' + SR.size());
                //System.debug('SaveResult: ' + SR.isSuccess());
                //Create entry for the custom object 'RIF Regional File Upload History object'
                System.debug('Inserting historyObj: ' );
                RIF_File_Upload_History__c historyObj= new RIF_File_Upload_History__c(File_Name__c=fileNameCSV,File_type__c=FILETYPE,Total_Records__c=csvFileLines.size()-1,Total_Success_Records__c=(csvFileLines.size()-1)-(wrapperErrorList.size()),Total_Failed_Records__c=wrapperErrorList.size());
                insert historyObj;
                System.debug('Isert Happened: ' + historyObj);
                lstHistoryLoad = RIF_DataUtil.getFileUploadHistories(FILETYPE);
                csvFileBody = null;
                fileNameCSV = null;
                for(Integer i=0;i<=SR.size();i++){
                    if(!SR[i].isSuccess()){//only look at failures, or NOT Successes
                        errorMessageString+='['+accrualsList[i].id+',ERROR:'+SR[i].getErrors()+']'+'\n';
                        system.debug('*******Following Error has occurred in Importing AI:'+SR[i].getErrors());
                        //system.debug(accrualsList[i]); //instead of debug, you could have an email processor something else that looks at that record and the error message
                    }
                    else
                        system.debug('*******No Error has occurred in Importing AI:'+SR[i].isSuccess());
                }
            }
            catch(Exception e){
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,errorMessageString);
                ApexPages.addMessage(errorMessage);
            }
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occurred while Uploading the file. Please make sure input file (CSV) is correct.' +e.getMessage());//+e.getMessage()
            ApexPages.addMessage(errorMessage );
        }
       
        return null;  
    }
    
    //cancel method refreshes the page and clear the success and error values
    
    public pageReference refreshPage(){
        accrualsList = null;
        faultyEmpIDs = null;
        wrapperErrorList= null;
        csvFileBody=null;
        //accrualsList.clear();
        //faultyEmpIDs.clear();
        //wrapperErrorList.clear();
        errorMessageString=null;
        
        return null;
    }
    
    //this method converts string value into boolean
    private boolean getBooleanValue(String stringVal){
        boolean booleanval;
        if(stringVal.equalsIgnoreCase('1')||stringVal.equalsIgnoreCase('Y')||stringVal.equalsIgnoreCase('Yes')||stringVal.equalsIgnoreCase('true')||stringVal.equalsIgnoreCase('t'))
            booleanval=true;
        if(stringVal.equalsIgnoreCase('0')||stringVal.equalsIgnoreCase('N')||stringVal.equalsIgnoreCase('No')||stringVal.equalsIgnoreCase('false')||stringVal.equalsIgnoreCase('f'))
            booleanval=false;
        return booleanval;
    }
    
    //this method create a error message corresponding to MSID as per the one row in csv file
    public void createErrorMessageWithMSID(String msID, String fieldName, String exceptionMessage){
        if(!msIDWithErrorMessageMap.containsKey(msID)){
            msIDWithErrorMessageMap.put(msID,'[Invalid '+fieldName+':'+exceptionMessage.split(':',-2)[1]+']');  
        }
        else{
            String errorMessage=msIDWithErrorMessageMap.get(msID);
            errorMessage+=' ; '+'[Invalid '+ fieldName + ':'+ exceptionMessage.split(':',-2)[1]+']';
            msIDWithErrorMessageMap.put(msID,errorMessage);     
            
            
        }
        
    }
    
    /**
** Class used for Displaying errors related to the employees loaded via csv file
** Errors are associated with the emp id's using this class
**/
    public class wrapperError{
        public string empID{get;set;}
        public string errorMessage{get;set;}
        // 10-Oct-17 : JIRA#RIF-119 : Corrected the value in the column
        public String rowNumber {get;set;}
        
        public wrapperError(string rowNumber, string errorMessage, String empID){
            this.rowNumber=rowNumber;
            this.errorMessage=errorMessage;
            this.empID = empID;
                
        }
    }
    
            // IGNORE THIS METHOD
   /* public void test_method(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        for(Integer j = 0 ; j <= 1000 ; j++){
            i++;
        }
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }*/

}