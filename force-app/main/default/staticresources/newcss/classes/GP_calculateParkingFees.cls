/***********************************************************************************************
*   GLOBAL PARKING CALCULATE PARKING FEES
*
*   This class provides methods for the global parking billing process
*
*
*
*   Change Log:
*
*   MRM 4/13/15 - Created Class
*   JMC 1/31/17 - Fixed getFeeBudapest call - query in function call loop (from GP_MonthlyBilling)
*
*************************************************************************************************/
public without sharing class GP_calculateParkingFees {
    
    
    public Map<String,Map<String,Decimal>> parkingLotRateScheduleByGrade = new Map<String,Map<String,Decimal>>();
    public Map<String,Map<String,Decimal>> parkingLotRateScheduleByGradeBudapest = new Map<String,Map<String,Decimal>>();
    
    
    public GP_calculateParkingFees(String requestId, String regionName, Date invoiceStartDate, Date invoiceEnddate){
        
        system.debug('building rate map!');
        /* Constructor - Get relevant parking rate information and make available for calculations */
        try {
            List<Parking_Lot_Fee_Schedule__c> fsList = new List<Parking_Lot_Fee_Schedule__c>();
            system.debug('region name:' + regionName);
            //get all the active parking schedules for the world and the details for each active schedule
            fsList = [Select p.Start_Effective_Date__c
                , p.Parking_Lot__c
                , p.Parking_Lot__r.name
                , p.Name
                ,p.Id
                ,p.End_Effective_Date__c
                ,rate_type__c 
                ,(Select Name, Fee__c, currencyISOCode, Parking_Lot_Fee_Schedule__c, Type__c, rate_type__c, Level_Dsc_Job__c, no_charge__c, Company_Owned__c, Assigned_Space__c
                 From Parking_Lot_Fee_Schedule_Details__r) 
                From Parking_Lot_Fee_Schedule__c p
                where (end_effective_date__c = null 
                or (start_effective_date__c <= :invoiceStartDate and end_effective_daTe__c >= :invoiceEndDate ))
                and parking_lot__r.parking_lot_region__r.name = :regionName];
    
            //system.debug('fsList:' + fsList + 'size:' + fsList.size());
            //system.debug('fslist size:' + fslist.size());
            //system.debug('start' + invoiceStartDate);
            //system.debug('end' + invoiceEndDate);
            
            
            Map<String,Decimal> levelRateMap = new Map<String,Decimal>();   
            Map<String,Decimal> levelRateMapBudapest = new Map<String,Decimal>();
            system.debug('**************  Populating custom budapest rate tables *****************');
            
            for (Parking_Lot_Fee_Schedule__c s:fsList)  {
        
                system.debug('Parking Lot:' + s.parking_lot__r.name +  ' Sched: ' + s.name); 
                
                List<Parking_Lot_Fee_Schedule_Details__c> dList = new List<Parking_Lot_Fee_Schedule_Details__c>();
            
                dList = s.Parking_Lot_Fee_Schedule_Details__r;
                system.debug('dlist:' + dlist);
                system.debug('dlist:' + dlist.size());
                
                //system.debug('in fslist loop');
                /****************** non budapest process *******************************/
                
                if (regionName != 'Budapest'){
                    
                    for (Parking_Lot_Fee_Schedule_Details__c d:dList){
                        
                        system.debug('rate type: ' + s.rate_type__c);
                        
                        levelRateMap.put(s.rate_type__c + '-' + d.type__c + '-' + d.level_dsc_job__c + '-' + d.no_charge__c, d.fee__c);
                        
                    }    
                    parkingLotRateScheduleByGrade.put(s.parking_lot__c,levelRateMap);
                    
                    system.debug('Parking Lot Rate Schedule by Grade is:' + parkingLotRateScheduleByGrade);
                }
                else{
                
                    for (Parking_Lot_Fee_Schedule_Details__c d:dList){
                        levelRateMapBudapest.put(d.rate_type__c + '-' + d.type__c + '-' + d.level_dsc_job__c + '-' + d.assigned_space__c + '-' + d.company_owned__c + '-' + d.no_charge__c, d.fee__c);
                        system.debug('Adding :' + d.rate_type__c + '-' + d.type__c + '-' + d.level_dsc_job__c + '-' + d.assigned_space__c + '-' + d.company_owned__c + '-' + d.no_charge__c + '-' +  d.fee__c);
                    }   
            
                    parkingLotRateScheduleByGradeBudapest.put(s.parking_lot__c + '-' + s.rate_type__c,levelRateMapBudapest);
                
                    system.debug('************** Budapest Rate Schedule: ' + parkingLotRateScheduleByGradeBudapest);
                }       
            }
        }
        catch (Exception e){
            Parking_Lot_Invoice_Run__c request = [select id from Parking_Lot_Invoice_Run__c where id = :requestID];
            request.status__c = 'Failed';
            request.message__c= 'Raise CSIT request for assistance. Provide the following error message on ticket: Exception location 1 ' + string.valueOf(e);
            update request;
        }
         
    }
    
    /******************************************************************************************
    * Exception  
    *
    *******************************************************************************************/
    public class forceException extends Exception {}
    /******************************************************************************************
    * Return Fee Info
    *
    *******************************************************************************************/
    public class returnFeeInfo {
        
        public Decimal hourlyRate {get;set;}
        public Decimal monthlyRate {get;set;}
        public Decimal dailyRate {get;set;}
        public Decimal totalFee {get;set;}
        
        public returnFeeInfo (Decimal hourly, Decimal monthly, Decimal daily, Decimal total){
            this.hourlyRate = hourly;
            this.monthlyRate = monthly;
            this.dailyRate = daily;
            this.totalFee = total;
        }
    }
    
    /******************************************************************************************
    * GET FEE    
    *
    *******************************************************************************************/

    public returnFeeInfo getFee (Boolean disabled, String pID, String levelDscJob, String rateType, String spaceType, String requestID, Parking_Lot_Request__c r,List<Parking_Lot_Space_Assignment_Time_Used__c> assignmentList){
        
        returnFeeInfo returnInfo = new returnFeeInfo(null,null,null,null);
        
        try{ 
            
            Decimal rate;
            
            Map<String,Decimal> levelRateMap = new Map<String,Decimal>();
        
            system.debug('pid:' + pid);
            
            levelRateMap = parkingLotRateScheduleByGrade.get(pID);
        
            if (levelRateMap == null){ 
                throw new forceException('There is no fee schedule for parking lot: ' + pID);
            }
            
            system.debug('*** levelRateMap: ' + levelRateMap);
            system.debug(rateType);
            
            system.debug('inital search for : ' + rateType + '-' + spaceType + '-' + levelDscJob + '-' + disabled);
             
            rate = levelRateMap.get(rateType+ '-' + spaceType + '-' + levelDscJob + '-' + disabled);
            
            if (rate == null){
                system.debug('*** now looking for all...');
                levelDscJob = 'All';
                rate = levelRateMap.get(rateType + '-' + spaceType + '-' + levelDscJob + '-' + disabled);
            }
            
            if (rate == null){
                throw new forceException('There is no fee specified for: ' + rateType + '-' +spaceType + '-' + levelDscJob + '-' + disabled +  ' in parking lot: ' + pID);
            }
            
            system.debug('Request Nbr: ' + r.name + ' fee is: ' + rate);
            
            system.debug('*** time assigned list size is: ' + assignmentList);
            
            Decimal tempRate = 0;
            Decimal tempDays;
            Decimal tempHours;
            Decimal tempMinutes;
            
            if (rateType == 'Daily')
                returnInfo.dailyRate = rate; 
                
            if (rateType == 'Monthly')
                returnInfo.monthlyRate = rate; 
                
            if (rateType == 'Hourly'){
                returnInfo.hourlyRate = rate;
                system.debug('****** hourly calculation in progress.....');
                for (Parking_Lot_Space_Assignment_Time_Used__c a:assignmentList){
                    if (a.disputed__c && a.resolved__c){
                        tempDays = a.resolved_days__c;
                        tempHours = a.resolved_hours__c;
                        tempMinutes = a.resolved_minutes__c;
                    }
                    else{
                        tempDays = a.days__c;
                        tempHours = a.hours__c;
                        tempMinutes = a.minutes__c;
                    }
                    tempRate = tempRate + (rate * 24 * tempDays);
                    tempRate = tempRate + (rate * tempHours);
                    if (tempMinutes != null)
                        if (tempMinutes != 0)
                            if (tempMinutes >= 30)
                                tempRate = tempRate + (1 * rate);
                            else
                                tempRate = tempRate + (.5 * rate);
                            
                    system.debug('temp rate is: ' + tempRate);
                                
                }
                rate = tempRate;
            }
            
            system.debug('Request Nbr: ' + r.name + ' fee is: ' + rate);
            
            returnInfo.totalFee = rate;
            
            return returnInfo;
        
        }
        catch (Exception e){
            Parking_Lot_Invoice_Run__c request = [select id from Parking_Lot_Invoice_Run__c where id = :requestID];
            request.status__c = 'Failed';
            request.message__c= 'Raise CSIT request for assistance. Provide the following error message on ticket:  Exception Location 2 ' +  string.valueOf(e);
            update request;
        }
         
        return returnInfo;
        
        
    }
    
    /******************************************************************************************
    * GET FEE BUDAPEST
    *
    *******************************************************************************************/

    public returnFeeInfo getFeeBudapest (String pID, String levelDscJob, String rateType, String spaceType, String requestID, Parking_Lot_Request__c r,List<Parking_Lot_Space_Assignment_Time_Used__c> assignmentList, Boolean companyOwned){
        
        returnFeeInfo returnInfo = new returnFeeInfo(0.0,0.0,0.0,0.0);
        
        try{
            
            system.debug('**** start location 3 try ********');
            
            Decimal rate;
            
            Map<String,Decimal> levelRateMap = new Map<String,Decimal>();
        
            system.debug('payment type is : ' + r.Method_of_Payment__c);
            
            String period;
            
            
            system.debug('pid:' + pid);
            
            system.debug('looking for lotratemap: ' + pid + '-' + rateType);        
            levelRateMap = parkingLotRateScheduleByGradeBudapest.get(pID + '-' + rateType); 
        
            if (levelRateMap == null){
                throw new forceException('There is no fee schedule for parking lot: ' + pID + '-' + rateType);
            }
                                                                        
            system.debug('Level rate map: ' + levelRateMap);
            /*
            //Map lookup key: type__c + '-' + level_dsc_job__c + '-' + assigned_space__c + '-' + company_owned__c + '-' + no_charge__c
            */  
            //if budapest all spaces are assigned
            if (rateType == 'Monthly' && spaceType == 'Car')
                r.assigned_space_requested__c = true;
            
            if (rateType == 'Hourly')
                companyOwned = false;
                
            system.debug('request: ' + r);
            
            rate = levelRateMap.get(rateType + '-' + spaceType + '-' + levelDscJob + '-' + r.Assigned_Space_Requested__c + '-' + companyOwned + '-' + r.no_charge__c);
            system.debug('Rate found:' + rate);
            
            if (rate == null) {
                System.debug('Rate for level not found.  Expanding search to All.');
                rate = levelRateMap.get(rateType + '-' + spaceType + '-' + 'All' + '-' + r.Assigned_Space_Requested__c + '-' + companyOwned + '-' + r.no_charge__c);
                System.debug('Rate found: ' + rate);
            }
            
            if (rate == null){
                throw new forceException('There is no fee specified for: ' + spaceType + '-' + levelDscJob + '-' + r.assigned_space_Requested__c + '-' + companyOwned + '-' + r.no_charge__c + '-' + ' in parking lot: ' + pID + ' Request Id: ' + r.id);
            }
            
            if (rateType == 'Monthly') 
                returninfo.monthlyRate = rate;
                        
                
            system.debug('Rate type is: '+ rateType);
            Decimal tempRate = 0;
            if (rateType == 'Hourly'){
                returninfo.hourlyRate = rate;
                Decimal tempDays;
                Decimal tempHours;
                Decimal tempMinutes;
                
                system.debug('****** hourly calculation in progress.....');
                system.debug('assignment list' + assignmentList);
                if (assignmentList != null) {
                    for (Parking_Lot_Space_Assignment_Time_Used__c a:assignmentList){
                        /*
                        if (a.in__c == null)
                            a.in__c = a.out__c.addDays(-1);
                        */
                        
                        if (a.in__c != null && a.out__c != null){
                            system.debug('Hours:' + a.hours__c);
                            system.debug('***** resolved is: ' + a.resolved__c);
                            if (a.resolved__c){
                            
                                
                                tempHours = a.resolved_hours__c;
                                tempDays = a.resolved_days__c;
                                tempMinutes = a.Resolved_minutes__c;
                            }
                            else{
                                
                                tempHours = a.hours__c;
                                tempDays = a.days__c;
                                tempMinutes = a.minutes__c; 
                            }   
                            if (rate == null)
                                rate = 0;
                            tempRate = tempRate + (rate * 24 * tempDays);
                            tempRate = tempRate + (rate * tempHours);
                            if (tempMinutes != null && tempMinutes != 0)
                                if (tempMinutes > 30)
                                    tempRate = tempRate + (1 * rate);
                                else
                                    tempRate = tempRate + (.5 * rate);
                                
                            system.debug('temp rate is: ' + tempRate);
                        }
                        else{
                            system.debug('in or out is null for ' + a.in__c + ' --- ' + a.out__c);
                        }
                    }
                    
                    if (tempRate == null)
                        rate = 0;
                    else
                        rate = tempRate;
                }
                else
                    rate = 0;
            }
            
            returnInfo.totalFee = rate;
            
            system.debug('*** made it to end of location 3 ******');
            return returnInfo;
        
        }
        catch (Exception e){
            Parking_Lot_Invoice_Run__c request = [select id from Parking_Lot_Invoice_Run__c where id = :requestID];
            request.status__c = 'Failed';
            request.message__c= 'Raise CSIT request for assistance. Provide the following error message on ticket:  Exception Location 3 ' + string.valueOf(e);
            update request;
        }
        
        return returnInfo;
        
        
    }
}