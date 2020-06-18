/*

    Change Log:
    
    11/16/2015 - added logic for global parking to handle terminated employees
    
*/

public with sharing class EmployeeManager {
    public static void handleTrigger(list<Employee__c> triggerNew, map<Id, Employee__c> triggerOldMap, boolean isInsert, boolean isUpdate,
                                                        boolean isDelete, boolean isBefore){
        
        /* MRM 10/16/14 - Maintain Dual Hat Eligible Flag */
        Set<String> dhSet = new set<String>();
        Boolean isResubmission = false;
        List<Dual_Hat_Eligible_Config__c> dhList = [Select Job_Title_Dsc_Job__c
                                        , Job_Code_Job__c 
                                        From Dual_Hat_Eligible_Config__c ];
                                                            
        system.debug('dhList.size(): ' + dhList.size());
        System.debug('####################Entry');
        for (Dual_Hat_Eligible_Config__c d:dhList){
            dhSet.add(d.job_code_job__c);
            //dhSet.add(d.job_title_dsc_job__c + d.job_code_job__c);
        }
        
        Map<ID,String> terminationMap = new Map<ID,String>();
        
        if(isBefore && (isUpdate)){ 
            Integer i = 0;
            for(Employee__c emp : triggerNew){
                
                system.debug('***** testing cipher *******');
                system.debug('***** gender is:' + emp.Gender__c);
                if (emp.gender__c == 'F'     )
                    system.debug('**** Female ****');
                    
                Employee__c eOld = triggerOldMap.get(triggernew[i].id);
                if (eOld.status__c != 'Terminated' && emp.status__c == 'Terminated'){
                    terminationMap.put(emp.id,'Termination Process');
                }
                //emp.Name = convertIntoCamelCase(emp.Name);
              //  system.debug(emp.job_title_dsc_job__c + emp.Jobcode_Job__c);
                for(String value: dhSet){
                    system.debug('value:' + value);
                }
               // system.debug('dhSet.contains(emp.Jobcode_Job__c): ' + dhSet.contains(emp.Jobcode_Job__c));
                
                if (dhSet.contains(emp.Jobcode_Job__c))
                    if (emp.status__c == 'Active')
                        emp.dual_hat_eligible__c = true;
                    else
                        emp.dual_hat_eligible__c = false;
                else
                    emp.dual_hat_eligible__c = false;
                
                system.debug('dual_hat_eligible__c: ' + emp.dual_hat_eligible__c );
                /* if now dual hat eligible then set effective date */
                if (triggerNew[i].dual_hat_eligible__c == true && eOld.dual_hat_eligible__c == false){ 
                    emp.Dual_Hat_Eligible_Effective_Date__c = system.today();
                }
                
                /* if no longer dual hat eligible then turn off workday and set status to no */
                if (triggerNew[i].dual_hat_eligible__c != true && eOld.dual_hat_eligible__c == true){ 
                    emp.Dual_Hat_Eligible_Effective_Date__c = system.today();
                    emp.Dual_Hat_Out_Category__c = 'dh';
                    emp.Dual_Hat_Out_Category_Description__c = 'dualHat';
                    emp.Dual_Hat_Out_Effective_Date__c  = system.today();
                    emp.Dual_Hat_Out_Ind__c = 'n';
                    emp.Dual_Hat_Out_Ind_Description__c = 'no';
                    emp.Dual_Hat_Out_Type__c = 'dh1';   
                    emp.Dual_Hat_Out_Type_Desc__c = 'dualHatUsaMspbna';
                    /* change dual hat status */
                    emp.dual_hat_status__c = 'No'; 
                    emp.dual_hat_status_date_time__c = system.now(); 
                }
                else{
                
                // system.debug('******************* emp.Dual_Hat_Training_Complete_Date__c: ' + emp.Dual_Hat_Training_Complete_Date__c);
                 //System.debug('@@@@@@@@Inside No'+emp.dual_hat_status__c);
                 
                 if(eOld.Dual_Hat_FDIC_Status__c == null){
                 isResubmission = false;
                 //System.debug('it is not a resubmission');
                 }
                 else
                 {
                 isResubmission = true;
                 //System.debug('it is a resubmission');
                 }
    
                /* if still true and old value not true then set status; don't do anything further for non eligibles */
                    //Restricting the DET Status recalculation when there is no change in DET Related fields
                 if (triggerNew[i].dual_hat_eligible__c == true &&(emp.dual_hat_eligible__c != eold.dual_hat_eligible__c 
                                                                   || emp.Dual_Hat_GRL_CRD_Status_Date__c != eold.Dual_Hat_GRL_CRD_Status_Date__c
                                                                   || emp.Dual_Hat_GRL_CRD_Status__c != eold.Dual_Hat_GRL_CRD_Status__c
                                                                   || emp.Dual_Hat_GRL_CRD_Fingerprint_Date__c != eold.Dual_Hat_GRL_CRD_Fingerprint_Date__c
                                                                   || emp.Dual_Hat_FDIC_Status_Date__c != eold.Dual_Hat_FDIC_Status_Date__c
                                                                   || emp.Dual_Hat_FDIC_Notes__c != eold.Dual_Hat_FDIC_Notes__c
                                                                   || emp.Dual_Hat_FDIC_Status__c != eold.Dual_Hat_FDIC_Status__c
                                                                   || emp.Dual_Hat_FFIEC_Status_Date__c != eold.Dual_Hat_FFIEC_Status_Date__c
                                                                   || emp.Dual_Hat_FFIEC_Status__c != eold.Dual_Hat_FFIEC_Status__c
                                                                   || emp.Dual_Hat_FFIEC_Status_In_Date__c != eold.Dual_Hat_FFIEC_Status_In_Date__c
                                                                   || emp.Dual_Employment_CARCO_Notes__c != eold.Dual_Employment_CARCO_Notes__c
                                                                   || emp.Dual_Hat_Training_Assigned_Date__c != eold.Dual_Hat_Training_Assigned_Date__c
                                                                   || emp.Dual_Hat_Training_Complete_Date__c != eold.Dual_Hat_Training_Complete_Date__c  )){ 
                        /* if any not clear set overall dual hat status to No */
                       
                       if( emp.Dual_Hat_FDIC_Status__c == 'NOT CLER' 
                        
                        || emp.Dual_Hat_FFIEC_Status__c == 'FINALNO'
                        
                        || ((emp.Dual_Hat_FFIEC_Status__c == 'CLER' && emp.dual_hat_status__c != 'Yes') && (emp.Dual_Hat_FFIEC_Status_Date__c.addMonths(6) < emp.Dual_Hat_FFIEC_Status_In_Date__c))
                        
                        || (emp.Dual_Hat_GRL_CRD_Status__c != 'CLER' && emp.Dual_Hat_GRL_CRD_Status__c != 'COMP' 
                            && emp.Dual_Hat_GRL_CRD_Status__c != 'CMPX' &&   emp.Dual_Hat_GRL_CRD_Status__c != 'RAPP'  
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RAPX'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'CLRX'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'CDPD'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'EXCX'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'ILEG'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'LGCY'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'NMCK'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RECC'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RECD'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RECP'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RECR'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RECT'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RECV'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'RECX'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'REJT'  &&  emp.Dual_Hat_GRL_CRD_Status__c != 'TERM'
                            &&  emp.Dual_Hat_GRL_CRD_Status__c != 'XMPT'  &&  emp.Dual_Hat_GRL_CRD_Status__c != null)
                       
                        || emp.DH_Active_NL_Events__c > 0)
                        
                            emp.dual_hat_status__c = 'No'; 
                           
                        else{
                             /* if all clear and training complete set overall dual hat status to Yes */
                             /*1/6/16: For DUALHAT-8 and DUALHAT-7
                             Added condition 
                             - FFIEC cleared status date must not be greater than 6 months
                             - LMS completion status date must be within calendar year
                             */
                            //Integer noOfDays = emp.Dual_Hat_FFIEC_Status_Date__c.daysBetween(System.today());
                            //System.debug('@@@@@@@@Inside Yes'+emp.dual_hat_status__c);
                            //System.debug('FDIC stat -------'+triggerNew[i].Dual_Hat_FDIC_Status__c );
                            //System.debug('FDIC stat -------'+eOld.Dual_Hat_FDIC_Status__c );
                            
                            
                            if((emp.Dual_Hat_FDIC_Status__c == 'CLER')
                            
                            && ((emp.Dual_Hat_FFIEC_Status__c == 'CLER') && 
                            ((emp.dual_hat_status__c == 'Yes' && emp.Dual_Hat_FFIEC_Status_Date__c.addMonths(6) < emp.Dual_Hat_FFIEC_Status_In_Date__c)
                            ||(emp.dual_hat_status__c == 'Yes' && emp.Dual_Hat_FFIEC_Status_Date__c.addMonths(6) >= emp.Dual_Hat_FFIEC_Status_In_Date__c)
                            || (emp.dual_hat_status__c != 'Yes'  && emp.Dual_Hat_FFIEC_Status_Date__c.addMonths(6) >= emp.Dual_Hat_FFIEC_Status_In_Date__c))) 
                            
                            && (emp.Dual_Hat_GRL_CRD_Status__c == 'CLER' || emp.Dual_Hat_GRL_CRD_Status__c == 'COMP' 
                            ||  emp.Dual_Hat_GRL_CRD_Status__c == 'CMPX' ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RAPP'  
                            ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RAPX' ||  emp.Dual_Hat_GRL_CRD_Status__c == 'CLRX'
                            || (emp.Dual_Hat_GRL_CRD_Status__c == 'ILEG' && emp.dual_hat_status__c == 'Yes' && isResubmission == true )
                            || (emp.Dual_Hat_GRL_CRD_Status__c == 'NMCK' && emp.dual_hat_status__c == 'Yes' && isResubmission == true )
                            || (emp.Dual_Hat_GRL_CRD_Status__c == 'RECC' && emp.dual_hat_status__c == 'Yes' && isResubmission == true ))
                            
                            && (emp.Dual_Hat_Training_Complete_Date__c != null))

                                emp.dual_hat_status__c = 'Yes'; 
                            else{
                                /* if something is complete then set to Pending */
                                /* Added new GRL CRD statuses for JIRA 29 */
                               // System.debug('@@@@@@@@Inside Pending'+emp.dual_hat_status__c);
                                if ((emp.Dual_Hat_FDIC_Status__c == 'CLER')
                                
                                ||  emp.Dual_Hat_FFIEC_Status__c == 'NOT CLER'
                                
                                || ((emp.Dual_Hat_FFIEC_Status__c == 'CLER' && emp.dual_hat_status__c != 'Yes') && (emp.Dual_Hat_FFIEC_Status_Date__c.addMonths(6) >= emp.Dual_Hat_FFIEC_Status_In_Date__c))
                                
                                || ((emp.Dual_Hat_FFIEC_Status__c =='CLER') ||(emp.Dual_Hat_FFIEC_Status__c =='PENDING'  ))
                                    
                                || (emp.Dual_Hat_GRL_CRD_Status__c == 'CLER'
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'COMP'
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'CMPX'
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RAPP'
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RAPX'
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'CLRX'
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'CDPD' 
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'EXCX' 
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'LGCY' 
                                     ||  (emp.Dual_Hat_GRL_CRD_Status__c == 'ILEG' && isResubmission == false)
                                     ||  (emp.Dual_Hat_GRL_CRD_Status__c == 'NMCK' && isResubmission == false) 
                                     ||  (emp.Dual_Hat_GRL_CRD_Status__c == 'RECC' && isResubmission == false)
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RECD' ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RECP' 
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RECR' ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RECT'  
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RECV' ||  emp.Dual_Hat_GRL_CRD_Status__c == 'RECX'
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'REJT' ||  emp.Dual_Hat_GRL_CRD_Status__c == 'TERM' 
                                     ||  emp.Dual_Hat_GRL_CRD_Status__c == 'XMPT')
                                
                                || emp.Dual_Hat_Training_Complete_Date__c != null)

                                    emp.dual_hat_status__c = 'Pending'; 
                              
                            }   
                            
                        }
                           /* system.debug('old FDIC status'+triggernew[i].Dual_Hat_FDIC_Status__c);
                            system.debug('new FDIC status'+eOld.Dual_Hat_FDIC_Status__c);
                            system.debug('old overall status'+eOld.dual_hat_status__c );
                            system.debug('now overall status'+emp.dual_hat_status__c );
                            system.debug('is a resubmission'+isResubmission);  */
                           
                        if (eOld.dual_hat_status__c == 'Yes' && triggernew[i].Dual_Hat_FDIC_Status__c == 'Review Required'  && triggernew[i].dual_hat_status__c == 'Pending' )              //when FDIC status becomes Reveiw Required by GRLCRD trigger and existing overall status is Yes,
                        {                                                                                         
                            emp.Dual_Employment_Eff_Old_Date__c = eOld.dual_hat_status_date_time__c;
                        }                                                                                                                                                                   //If status changes from Yes to Pending and review required, store the eff date
                        
                        if (eOld.dual_hat_status__c == 'Pending' && eOld.Dual_Hat_FDIC_Status__c == 'Review Required' && triggernew[i].dual_hat_status__c == 'Yes')  
                        {
                            emp.dual_hat_status_date_time__c = emp.Dual_Employment_Eff_Old_Date__c ;                                                                                        // The date value when overall status was Yes is assigned here.
                        }                                                                                                                                                                   //If status changes from Pending & review required to Yes, retain old eff date
                                                
                         // except the two cases mentioned above where we are retaining the value of dual hat eff date   
                         // in all other cases we are assigning it to the current date of system. 
                         
                         
                        if((eOld.dual_hat_status__c == null && triggernew[i].dual_hat_status__c != null) 
                            || (eOld.dual_hat_status__c == 'Yes' && triggernew[i].dual_hat_status__c == 'No') 
                            || (eOld.dual_hat_status__c == 'Yes' && triggernew[i].dual_hat_status__c == 'Pending')
                            || (eOld.dual_hat_status__c == 'No' && triggernew[i].dual_hat_status__c == 'Yes' )
                            || (eOld.dual_hat_status__c == 'No' && triggernew[i].dual_hat_status__c ==  'Pending' )
                            || (eOld.dual_hat_status__c == 'Pending' && triggernew[i].dual_hat_status__c == 'Yes' && eOld.Dual_Hat_FDIC_Status__c != 'Review Required'  )
                            || (eOld.dual_hat_status__c == 'Pending'&& triggernew[i].dual_hat_status__c == 'No' ))
                            {                           
                                emp.dual_hat_status_date_time__c = system.now();    
                            }
                    
                        if (triggernew[i].dual_hat_status__c == 'Yes' && eOld.dual_hat_status__c != 'Yes'){
                            emp.Dual_Hat_Out_Category__c = 'dh';
                            emp.Dual_Hat_Out_Category_Description__c = 'dualHat';
                            emp.Dual_Hat_Out_Effective_Date__c  = system.today();
                            emp.Dual_Hat_Out_Ind__c = 'y';
                            emp.Dual_Hat_Out_Ind_Description__c = 'yes';
                            emp.Dual_Hat_Out_Type__c = 'dh1';   
                            emp.Dual_Hat_Out_Type_Desc__c = 'dualHatUsaMspbna';     
                        }
                        else if (triggernew[i].dual_hat_status__c != 'Yes' && eOld.dual_hat_status__c == 'Yes'){       // turn off dual hat status in workday
                                emp.Dual_Hat_Out_Category__c = 'dh';
                                emp.Dual_Hat_Out_Category_Description__c = 'dualHat';
                                emp.Dual_Hat_Out_Effective_Date__c  = system.today();
                                emp.Dual_Hat_Out_Ind__c = 'n';
                                emp.Dual_Hat_Out_Ind_Description__c = 'no';
                                emp.Dual_Hat_Out_Type__c = 'dh1';   
                                emp.Dual_Hat_Out_Type_Desc__c = 'dualHatUsaMspbna'; 
                           
                        }
                         else if(triggernew[i].dual_hat_status__c == 'No' && eOld.dual_hat_status__c != 'No'){  
                                emp.Dual_Hat_Out_Category__c = 'dh';
                                emp.Dual_Hat_Out_Category_Description__c = 'dualHat';
                                emp.Dual_Hat_Out_Effective_Date__c  = system.today();
                                emp.Dual_Hat_Out_Ind__c = 'n';
                                emp.Dual_Hat_Out_Ind_Description__c = 'no';
                                emp.Dual_Hat_Out_Type__c = 'dh1';   
                                emp.Dual_Hat_Out_Type_Desc__c = 'dualHatUsaMspbna'; 
                           
                        }
                        
                    }
                }
                i++;
            }
        } 
        
        /* 03/20/15 - Job Region Mapping - Start*/                                                          
        if(isBefore && (isUpdate || isInsert)){             
            for(Employee__c emp : triggerNew){
                if(emp.Job_Country_Job__c != null && emp.Job_Country_Job__c != ''){
                    Country_Region_Mapping__c mapping = Country_Region_Mapping__c.getInstance(emp.Job_Country_Job__c);
                    if(mapping != null){
                        emp.Job_Region_Code__c = mapping.Region_Code__c;
                    }
                }
            }
        }
        /* 03/20/15 - Job Region Mapping - End*/
        
        
        //MRM change -add termination process for global parking
        if (terminationMap != null) 
            GP_ServiceHelper.terminationProcess(terminationMap);
    }
     
    /*private static String convertIntoCamelCase(String name){
        if(name != null){
            name = name.normalizeSpace();
            System.debug(name);
            list<String> strList = name.split(' ');
            name = '';
            
            for(String tempStr : strList){
                if(tempStr != null && tempStr.length() > 0){
                    name += tempStr.subString(0, 1).toUpperCase();
                    if(tempStr.length() > 1) {
                        name += tempStr.subString(1).toLowerCase();
                    }
                    name += ' ';
                }
            }
            
            name = name.normalizeSpace();
            System.debug(name);
        }
        return name;
    }*/
}