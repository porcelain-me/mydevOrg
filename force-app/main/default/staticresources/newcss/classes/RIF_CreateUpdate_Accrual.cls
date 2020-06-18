/*******************************************************************************************************
*
*
* Change Log:
*
*  MRM 1/26/16 Changed communication date to communicated date
*******************************************************************************************************/

public class RIF_CreateUpdate_Accrual { 
    //variables
    //Map <string,string> projIDWithStatusMap = new  Map <string,string> ();
    public RIF_CreateUpdate_Accrual (){
    
    
    }

    //create a new accrual record on updation of a s&R which is communicated and all checklist fields are populated
    public static void createUpdateAccrual(List<Severance_And_Release__c > listNewSRs,map<Id,Severance_And_Release__c> mapNewSR,map<Id,Severance_And_Release__c> mapOldSR){ 
        List <Severance_And_Release__c> reverseAccrualSRList= new List <Severance_And_Release__c> ();
              List <Severance_And_Release__c> SRList= new List <Severance_And_Release__c> ();
                Set <string> reverseAccrualSRIds= new Set <string> ();
                Set <string> AccrualSRIds= new Set <string> ();
        
        
 //       system.debug('list new srs....' + listNewSrs);

        // 13-Sept-17 : JIRA#59 : Reverse accrual is generated ONLY ONCE for the SNR --- STARTS
        Set<String> snrIDsSet = new Set<String>();
        Set<String> hasRevAccSNRSet = new Set<String>();
        if(!listNewSRs.isEmpty()){
            Integer listSize = listNewSRs.size();
            for(Integer i=0 ; i < listSize ; i++){
                // get all the SNR new ids
                snrIDsSet.add(listNewSRs[i].Id);
            }
        }
        if(!snrIDsSet.isEmpty()){
            // check if the SNRs have any reverse accrual records
            List<Accrual_Information__c> accrualList = RIF_DataUtil.getListExistingAccrualInfoForSR(snrIDsSet);
            if(accrualList != null && !accrualList.isEmpty()){
                Integer accListSize = accrualList.size();
                for(Integer i=0 ; i < accListSize ; i++){
                    // check if and Inactive accrual record exists for the SNR
                    if((accrualList[i].Accrual_Type__c).equalsIgnoreCase('Inactive')){
                        hasRevAccSNRSet.add(String.valueOf(accrualList[i].Severance_And_Release__c));
                    }
                }
            }
        }
        // 13-Sept-17 : JIRA#59 : Reverse accrual is generated ONLY ONCE for the SNR --- ENDS
        for(Severance_And_Release__c srRecord: listNewSRs){
             // 3-Jan-17 : Replacing Communicated_Details_of_Package__c with Severance_Package_Communicated__c
            //if(srRecord.Communicated__c && srRecord.Communicated_Date__c != null && srRecord.Communicated_Details_of_Package__c && srRecord.Package_Receipt_Date__c != null) {
            if(srRecord.Communicated__c && srRecord.Communicated_Date__c != null && srRecord.Severance_Package_Communicated__c && srRecord.Package_Receipt_Date__c != null) { //&& srRecord.Severance_Package_Communicated__c && srRecord.Package_Receipt_Date__c != null
                // 13-Sept-17 : JIRA#59 : Consider only those SNRs who DO NOT HAVE an INACTIVE accrual
                if(srRecord.status__c.equalsIgnoreCase('Not Selected')){  //&& (srRecord.communicated__c)//(!mapOldSR.get(srRecord.id).status__c.equalsIgnoreCase('Not Selected')) && 
                    if(!hasRevAccSNRSet.contains(srRecord.Id)){
                        reverseAccrualSRList.add(srRecord); 
                        reverseAccrualSRIds.add(srRecord.id);
                        system.debug('####reverseAccrualSRIds###'+reverseAccrualSRIds);
                    }
                } else { 
                    SRList.add(srRecord);
                    AccrualSRIds.add(srRecord.id);
                    system.debug('####AccrualSRIds###'+AccrualSRIds);   
                }
            }
        }
        if(SRList!=null && SRList.size()>0)
            createAccruals(SRList,AccrualSRIds,mapOldSR);
        if(reverseAccrualSRList!=null && reverseAccrualSRList.size()>0)
            reverseAccruals(reverseAccrualSRList,reverseAccrualSRIds);
        
        reverseAccrualSRList.clear();
        SRList.clear();
        reverseAccrualSRIds.clear();
        AccrualSRIds.clear();
        
    }
    
    //reverse accrual logic
    public static void reverseAccruals(List<Severance_And_Release__c > reverseAccrualSRList,Set <string> reverseAccrualSRIds){ 
        system.debug('####entered into reverseAccruals()###');
        //List <Accrual_Information__c> updatedAccrualList = new List <Accrual_Information__c> ();
        List <Accrual_Information__c> createReverseAccrualList = new List <Accrual_Information__c> ();
        // create set of emp Ids corrersponding to S&R list
        // 1-Feb-2017 : ALM1882 : Changes to create new reverse accruals each time, rather than updating the old accrual record --- STARTS 
        /*Set <String> empIdsForSR = new Set <String> ();
        for(Severance_And_Release__c sevRecord : reverseAccrualSRList){
        empIdsForSR.add(sevRecord.emp_id__c);
        }
        */
        for(Severance_And_Release__c snrRec : reverseAccrualSRList){
            // get all the data from SNR and preserve it on accrual delta fields
            Accrual_Information__c createAccInfo = new Accrual_Information__c();
            /*
            accInfo.Delta_Additional_Severance__c = (snrRec.Additional_Severance_Override1__c!=null) ? snrRec.Additional_Severance_Override1__c:snrRec.Additional_Severance1__c;
            accInfo.Delta_Basic_Severance__c = (snrRec.Basic_Severance_Local_Override__c!=null) ? snrRec.Basic_Severance_Local_Override__c:snrRec.Basic_Severance_Local__c;
            accInfo.Delta_Benefits__c = (snrRec.Cobra_Override__c!=null) ? snrRec.Cobra_Override__c:snrRec.Cobra__c;
            accInfo.Delta_Buy_Out_Of_Termination__c = snrRec.Buy_Out_of_Termination__c;
            accInfo.Delta_Enhanced_Severance_Lcl__c = (snrRec.Enhanced_Severance_Local_Override__c!=null) ? snrRec.Enhanced_Severance_Local_Override__c:snrRec.Enhanced_Severance_Local__c;
            accInfo.Delta_Ex_Gracia_Cash_Payment__c = snrRec.Ex_Gracia_Cash_Payment__c;
            accInfo.Delta_Notice_Amount__c = (snrRec.Notice_Amount_Override__c!=null) ?snrRec.Notice_Amount_Override__c: snrRec.Notice_Amount__c;
            accInfo.Delta_Additional_Notice__c = (String.valueOf(snrRec.Additional_Notice_Override__c)!=null) ? String.valueOf(snrRec.Additional_Notice_Override__c):String.valueOf(snrRec.Additional_Notice__c);
            accInfo.Delta_pay_in_lieu_of_ben_lcl__c = snrRec.Pay_in_Lieu_of_Benefits_Local__c;
            accInfo.Delta_Pension_Contribution__c = snrRec.Pension_Contribution__c;
            accInfo.Delta_Social_Insurance__c = snrRec.Social_Insurance__c;
            accInfo.Delta_Statutory_Redundancy_Pay__c = snrRec.Statutory_Redundancy_Pay__c;
            accInfo.Delta_Termination_Bonus__c = snrRec.Termination_Bonus__c;
            accInfo.Delta_Notice_Days__c = Decimal.ValueOf((snrRec.Notice_Days_Override__c!=null) ?snrRec.Notice_Days_Override__c:snrRec.Notice_Days_1__c);
            accInfo.Delta_Buy_Out_of_Notice_Period_Lcl__c = String.valueOf(snrRec.Buy_Out_of_Notice_Period_Lcl__c);
            */
            Accrual_Information__c accInfo = RIF_CreateUpdate_Accrual.copyValuesToAccrualFields(createAccInfo,snrRec);
            
            accInfo.Accrual_Type__c = 'Inactive';
            // reset the following fields to 0 or blank
            
            // 19-July-17 : Skyhigh changes : replaced the hard coded values with an encrypted field's value
            //accInfo.Reverse_accrual_default__c = '0'; // set the value to this field first, then assign this value to other fields
            accInfo.Notice_Days__c = 0;//String.valueOf(snrRec.Reverse_accrual_default__c); // = 0;
            accInfo.Notice_Amount__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            system.debug('accInfo.Reverse_accrual_default__c'+snrRec.Reverse_accrual_default__c);
            system.debug('accInfo.Reverse_accrual_default__c1'+String.valueOf(snrRec.Reverse_accrual_default__c));
            accInfo.Additional_Notice__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Additional_Notice_Amount__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Basic_Severance__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Additional_Severance__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Benefits__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Buy_Out_Of_Termination__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Enhanced_Severance_Lcl__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Ex_Gracia_Cash_Payment__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.pay_in_lieu_of_ben_lcl__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Pension_Contribution__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            accInfo.Social_Insurance__c = String.valueOf(snrRec.Reverse_accrual_default__c); // = '0';
            /*MSN:RIF#135 Commented this code and added below 3 lines 30th Mar 18
            accInfo.Statutory_Redundancy_Pay__c = String.valueOf(snrRec.Basic_Severance_Local__c);// = '0';
            accInfo.Termination_Bonus__c = String.valueOf(snrRec.Basic_Severance_Local__c);// = '0';
            accInfo.Buy_Out_of_Notice_Per_Lcl__c = String.valueOf(snrRec.Basic_Severance_Local__c) ;// = '0'; */
            accInfo.Statutory_Redundancy_Pay__c =String.valueOf(snrRec.Reverse_accrual_default__c);
            accInfo.Termination_Bonus__c = String.valueOf(snrRec.Reverse_accrual_default__c);
            accInfo.Buy_Out_of_Notice_Per_Lcl__c = String.valueOf(snrRec.Reverse_accrual_default__c);
            
/**
            
            accInfo.Additional_Severance__c = '';
            accInfo.Basic_Severance__c = '';
            accInfo.Benefits__c = '';
            accInfo.Buy_Out_Of_Termination__c = '';
            accInfo.Enhanced_Severance_Lcl__c = '';
            accInfo.Ex_Gracia_Cash_Payment__c = '';
            accInfo.Notice_Amount__c = '';
            accInfo.Additional_Notice__c = '';
            accInfo.pay_in_lieu_of_ben_lcl__c = '';
            accInfo.Pension_Contribution__c = '';
            accInfo.Social_Insurance__c = '';
            accInfo.Statutory_Redundancy_Pay__c = '';
            accInfo.Termination_Bonus__c = '';
            accInfo.Notice_Days__c = 0;
            accInfo.Buy_Out_of_Notice_Per_Lcl__c = ''; 
            accInfo.Additional_Notice_Amount__c = '';
   ***/         
            createReverseAccrualList.add(accInfo);
        } 
        if(!createReverseAccrualList.isEmpty()){
            insert createReverseAccrualList;
        }    
        // 1-Feb-2017 : ALM1882 : Changes to create new reverse accruals each time, rather than updating the old accrual record --- ENDS 
    }
    //create a new accrual record on updation of a s&R which is communicated and all checklist fields are populated
    public static void createAccruals(List<Severance_And_Release__c > SRList,Set <string> AccrualSRIds,map<Id,Severance_And_Release__c> mapOldSR){ 
        system.debug('####entered into createAccruals()###');
        List <Accrual_Information__c > newAccrualsList= new List <Accrual_Information__c > ();
        Set <id> projIDs= new  Set <id> ();
        for(Severance_And_Release__c sr: SRList){
            projIDs.add(sr.project__c);
        }
        Map <string,string> projIDWithStatusMap = new  Map <string,string> ();
        system.debug('projIDWithStatusMap'+projIDWithStatusMap);
        for(project__c projObj:[select id,status__c from project__c where id IN:projIDs]){
            projIDWithStatusMap.put(projObj.id,projObj.status__c);
        }
       
       // system.debug('in here');
      
       // system.debug('mapoldsr' + mapOldSr);
        // 1-Feb-2017 : ALM1882 : Changes to create new reverse accruals each time, rather than updating the old accrual record
        // removed null checks from the below 'if' check
        for(Severance_And_Release__c srRecord: SRList){  
            //&& (SRList[0].historical_Data_Load__c!= null) && (!SRList[0].historical_Data_Load__c)
            // 12-Apr-17 : Added the criteria for Closed projects, the accruals will ONLY be triggered for Active and Closed projects
            // 24-Apr-17 : Added flag to check if the override field's value has changed
            if( ((projIDWithStatusMap.get(srRecord.project__c)=='Active' || projIDWithStatusMap.get(srRecord.project__c) == 'Closed') && (srRecord.Communicated__c) ) && 
                ( 
                    
                    // MRM 1/26/16 Changed communication date to communicated date
                    ((mapOldSR.get(srRecord.id).Communicated_Date__c)!=(srRecord.Communicated_Date__c) ) ||
                    ((mapOldSR.get(srRecord.id).Communication_Date__c)!=(srRecord.Communication_Date__c)) ||     /*MSN:RIF#141 Added on 26th Feb 2018 */
                    ((mapOldSR.get(srRecord.id).Pay_in_Lieu_of_Benefits_Local__c)!=(srRecord.Pay_in_Lieu_of_Benefits_Local__c)) ||     /*MSN:RIF#149 Added on 21st Mar 2018 */
                    ((mapOldSR.get(srRecord.id).Termination_Date__c)!=(srRecord.Termination_Date__c) ) ||
                    ((mapOldSR.get(srRecord.id).Last_Day_On_Premises__c)!=(srRecord.Last_Day_On_Premises__c) ) ||
                    ((mapOldSR.get(srRecord.id).DOH_Recent__c)!=(srRecord.DOH_Recent__c) ) ||
                    (((mapOldSR.get(srRecord.id).Base_Salary_Override__c)!=(srRecord.Base_Salary_Override__c)) && srRecord.Is_Changed_Base_Salary_Override__c) ||
                    (((mapOldSR.get(srRecord.id).Notice_Amount_Override__c)!=(srRecord.Notice_Amount_Override__c)) && srRecord.Is_Changed_Notice_Amt_Override__c) ||
                    (((mapOldSR.get(srRecord.id).Basic_Severance_Local_Override__c)!=(srRecord.Basic_Severance_Local_Override__c)) && srRecord.Is_Changed_Basic_Sev_Override__c) ||
                    (((mapOldSR.get(srRecord.id).Additional_Notice_Override__c)!=(srRecord.Additional_Notice_Override__c)) && srRecord.Is_Changed_Add_Notice_Override__c) ||
                    (((mapOldSR.get(srRecord.id).Additional_Severance_Override1__c)!=(srRecord.Additional_Severance_Override1__c)) && srRecord.Is_Changed_Add_Sev_Override__c) ||
                    (((mapOldSR.get(srRecord.id).Enhanced_Severance_Local_Override__c)!=(srRecord.Enhanced_Severance_Local_Override__c)) && srRecord.Is_Changed_Enhan_Sev_Override__c) ||
                    (((mapOldSR.get(srRecord.id).Cobra_Override__c)!=(srRecord.Cobra_Override__c)) && srRecord.Is_Changed_Cobra_Override__c)||
                    // 3-Jan-17 : Replacing Communicated_Details_of_Package__c with Severance_Package_Communicated__c
                    //( (mapOldSR.get(srRecord.id).Communicated_Details_of_Package__c != null) && (mapOldSR.get(srRecord.id).Communicated_Details_of_Package__c)!=(srRecord.Communicated_Details_of_Package__c) )||
                    ((mapOldSR.get(srRecord.id).Severance_Package_Communicated__c)!=(srRecord.Severance_Package_Communicated__c) )||
                    ((mapOldSR.get(srRecord.id).Release_Returned__c)!=(srRecord.Release_Returned__c) )||
                    ((mapOldSR.get(srRecord.id).Work_Requirement_for_Severance__c)!=(srRecord.Work_Requirement_for_Severance__c) )
                )
            
            ){
                //( (mapOldSR.get(srRecord.id).Additional_Notice_Amount_Override__c)!=(srRecord.Additional_Notice_Amount_Override__c) ) ||
                system.debug('made it here');
                Accrual_Information__c newAccInfo = new Accrual_Information__c();
                Accrual_Information__c newAccrualRecord=RIF_CreateUpdate_Accrual.copyValuesToAccrualFields(newAccInfo,srRecord);
                newAccrualsList.add(newAccrualRecord);
            }
           //Removing the below elseif condition as Historical loads are completed as we dont need sepearte logic to handle Historical Loads. 
            /**
            else if(srRecord.Communicated__c && SRList[0].historical_Data_Load__c ){ //TO BE USED ONLY FOR HISTORICAL LOAD ONLY
                system.debug('INSIDE ELSE IF WITH HISTORICAL DATA LOAD.......');
                Accrual_Information__c newAccInfo = new Accrual_Information__c();
                Accrual_Information__c newAccrualRecord=RIF_CreateUpdate_Accrual.copyValuesToAccrualFields(newAccInfo,srRecord);
                newAccrualsList.add(newAccrualRecord);
            
            }**/
            
            system.debug('ugh');
                
        }
       
        
        if(newAccrualsList!=null && newAccrualsList.size()>0)
            insert newAccrualsList; 
    }
    
    public static Accrual_Information__c copyValuesToAccrualFields(Accrual_Information__c accrualObj, Severance_And_Release__c srRecord){
        //Accrual_Information__c newAccInfo = new Accrual_Information__c();
        
                system.debug('copying fields daily rate is: ' + srRecord.daily_rate__c);
                
                //accrualObj.Accrual_Type__c=srRecord.;
                accrualObj.Additional_Notice__c=(String.valueOf(srRecord.Additional_Notice_Override__c)!=null) ? String.valueOf(srRecord.Additional_Notice_Override__c):String.valueOf(srRecord.Additional_Notice__c);
                accrualObj.Additional_Severance__c  =(srRecord.Additional_Severance_Override1__c!=null) ? srRecord.Additional_Severance_Override1__c:srRecord.Additional_Severance1__c;//srRecord.Sep_Summary_Additional_Severance__c;//
                
                accrualObj.Basic_Severance__c=(srRecord.Basic_Severance_Local_Override__c!=null) ? srRecord.Basic_Severance_Local_Override__c:srRecord.Basic_Severance_Local__c;//srRecord.Sep_Summary_Basic_Severance__c;
                accrualObj.Benefits__c=(srRecord.Cobra_Override__c!=null) ? srRecord.Cobra_Override__c:srRecord.Cobra__c;//srRecord.Sep_Summary_Benefits__c;
                //accrualObj.Business_Unit__c=String.valueOf(srRecord.);
                accrualObj.Buy_Out_of_Notice_Per_Lcl__c=String.valueOf(srRecord.Buy_Out_of_Notice_Period_Lcl__c);
                accrualObj.Buy_Out_Of_Termination__c=srRecord.Buy_Out_of_Termination__c;
                accrualObj.Communicated__c=srRecord.Communicated__c;
                accrualObj.Communicated_Date__c=srRecord.Communicated_Date__c;
                accrualObj.Consultation_End_Date__c=srRecord.Consultation_End_Date__c;
                accrualObj.Consultation_Start_Date__c=srRecord.Consultation_Start_Date__c;
                accrualObj.Cost_Center__c=srRecord.Cost_Center__c;
                accrualObj.Cost_Center_Desc__c=srRecord.Cost_Center_Desc__c;
                //accrualObj.Enhanced_Severance_Lcl__c   = srRecord.Sep_Summary_Enhanced_Severance__c;
               // accrualObj.Additional_Notice_Amount__c = srRecord.Sep_Summary_Additional_Notice_Amount__c;
                 accrualObj.Additional_Notice_Amount__c = (srRecord.Additional_Notice_Amount_Override__c!=null) ? srRecord.Additional_Notice_Amount_Override__c:srRecord.Additional_Notice_Amount__c;//srRecord.Sep_Summary_Basic_Severance__c;
                // Query:doubt in the validity of the input from S&R(there are so many fields have prefix 'Curr'  and already exist without prefix 'Curr' as well)
                //accrualObj.CreatedById__c=UserInfo.getuserID();
                
                
                accrualObj.Daily_Rate__c=srRecord.Daily_Rate__c;
                accrualObj.Department__c=srRecord.Department__c;
                accrualObj.Department_Desc__c=srRecord.Department_Desc__c;
                accrualObj.Division__c=srRecord.Division__c;
                accrualObj.Division_Desc__c=srRecord.Division_Desc__c;
                accrualObj.Emp_Id__c= srRecord.Emp_Id__c;  
                accrualObj.Enhanced_Severance_Lcl__c=(srRecord.Enhanced_Severance_Local_Override__c!=null) ? srRecord.Enhanced_Severance_Local_Override__c:srRecord.Enhanced_Severance_Local__c;
                //ETL_Status__c
                //ETL_Status_Note__c
                //Event_Related_Term__c
                accrualObj.Ex_Gracia_Cash_Payment__c=srRecord.Ex_Gracia_Cash_Payment__c; 
                accrualObj.Last_Day_on_Premises__c=srRecord.Last_Day_on_Premises__c;
                
                if(srRecord.Last_Edited_Date__c == null)
                    accrualObj.Last_Edited_Date__c=system.now();//srRecord.Last_Day_on_Premises__c;
                else
                    accrualObj.Last_Edited_Date__c=srRecord.Last_Edited_Date__c;
                                    
                if(srRecord.Accrual_Type__c != null)
                    accrualObj.Accrual_Type__c= srRecord.Accrual_Type__c; 
                                                        
                //LastModifiedBy__c
                //Latest_Payroll_Sent_Date__c
                accrualObj.Notice_Amount__c= (srRecord.Notice_Amount_Override__c!=null) ?srRecord.Notice_Amount_Override__c: srRecord.Notice_Amount__c;//srRecord.Sep_Summary_Notice_Amount__c;
                accrualObj.Notice_Days__c=Decimal.ValueOF((srRecord.Notice_Days_Override__c!=null) ?srRecord.Notice_Days_Override__c:srRecord.Notice_Days_1__c);
                accrualObj.pay_in_lieu_of_ben_lcl__c=srRecord.Pay_in_Lieu_of_Benefits_Local__c;
                accrualObj.Pension_Contribution__c=srRecord.Pension_Contribution__c;
                //Newly added filed for storing s&R sf id into Accrual for lookup(because there can be multiple accruals for same employee if rehired but s&r will be different)
                accrualObj.Severance_And_Release__c=srrecord.id;
                //Doubt whether communicated__c should be used from S&R OR Severance_Package_Communicated__c
                accrualObj.Severance_Package_Communicated__c=srRecord.Severance_Package_Communicated__c;
                //accrualObj.Severance_Package_Communicated__c=srRecord.Communicated_Details_of_Package__c; 
                //accrualObj.Severance_Package_Communicated__c=srRecord.Communicated__c; 
                
                // Query:doubt in the validity of the input from S&R
                accrualObj.Signed_Release_Returned__c=srRecord.Release_Returned__c;
                accrualObj.Social_Insurance__c=srRecord.Social_Insurance__c;
                accrualObj.Statutory_Redundancy_Pay__c=srRecord.Statutory_Redundancy_Pay__c;
                accrualObj.Super_Department__c=srRecord.Super_Department__c;
                accrualObj.Super_Department_Desc__c=srRecord.Super_Department_Desc__c;
                accrualObj.Super_Division__c=srRecord.Super_Division__c;
                accrualObj.Super_Division_Desc__c=srRecord.Super_Division_Desc__c;
                accrualObj.Termination_Bonus__c=srRecord.Termination_Bonus__c;
                accrualObj.Termination_Date__c=srRecord.Termination_Date__c;
                accrualObj.Voluntary_Involuntary_Flg__c=srRecord.Voluntary_Involuntary_Flg__c;
                accrualObj.Work_Requirement_for_Severance__c=srRecord.Work_Requirement_for_Severance__c;
                // 26-Oct-2016 : ALM#1743 : Org Hierarchy changes, added 4 new fields to Accruals Information --- STARTS
                // copy the values from SNR to the new fields, Sub Dept,Sub Dept 2,Sub Dept 2,Sub Dept 2 Desc
                accrualObj.Sub_Department__c = srRecord.Sub_Department__c;
                accrualObj.Sub_Department_Desc__c = srRecord.Sub_Department_Desc__c;
                accrualObj.Sub_Department_2__c = srRecord.Sub_Department_2__c;
                accrualObj.Sub_Department_2_Desc__c = srRecord.Sub_Department_2_Desc__c;
                // 26-Oct-2016 : ALM#1743 : Org Hierarchy changes, added 4 new fields to Accruals Information --- ENDS
                if(srRecord.Is_termination_related_to_Project__c )
                    accrualObj.Event_Related_Term__c = 'Y'; 
                else
                    accrualObj.Event_Related_Term__c ='N';  
                
                accrualObj.CreatedById__c=userInfo.getuserID();
                
                accrualObj.LastModifiedBy__c=userInfo.getuserID();
                //Default Currency set to USD
                accrualObj.Currency_Buy_Out_of_Notice_Per__c = srRecord.Currency_Buy_Out_of_Notice_Period__c;
                // 31-July-17 : Replace the below field with the currency field from SNR 
                accrualObj.Base_Currency__c = srRecord.Base_currency_default__c;
                accrualObj.Cur_Basic_Severance__c='USD';
                accrualObj.Curr_Additional_Severance__c='USD';
                accrualObj.Curr_Benefits__c='USD';
                accrualObj.Curr_Buyout_of_Notice_Pd__c='USD';
                accrualObj.Curr_Buyout_of_Term__c='USD';
                accrualObj.Curr_Enh__c='USD';
                accrualObj.Curr_ExGCsh__c='USD';
                accrualObj.Curr_PIL__c='USD';
                accrualObj.Curr_PenCont__c='USD';
                accrualObj.Curr_SocialIns__c='USD';
                accrualObj.Curr_StatRed__c='USD';
                accrualObj.Curr_TermBon__c='USD';
                
                return  accrualObj;
    }
    
}