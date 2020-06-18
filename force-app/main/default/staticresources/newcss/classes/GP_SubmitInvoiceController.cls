/******************************************************************************************
* Global Parking Submit Invoice Controller
*
* This will submit the monthly invoice process
*
* ChangeLog:
*
*   7/8/15- Created by Mark R. Moser
*   2/13/17 - Updated by Jim Carter
*           REQ6826401: The last day of the month is being excluded from billing run
*           Fix Applied: Pass the first day of next month into billing function.  Update queries to qualify only 'less than' end date.
*   
*   
*******************************************************************************************/

public class GP_SubmitInvoiceController { 
    
    public Parking_Lot_Region__c r {get;set;} 
    public List<Parking_Lot_Invoice_Run__c> bList {get;set;}
    Parking_Lot_Invoice_Run__c b; 
    public Boolean disableStep2 {get;set;} 
    public Boolean disableStep3 {get;set;} 
    public Boolean disableStep4 {get;set;}
    public String disputeMessage {get;set;}
    public List<Parking_Lot_Invoice_Run__c> bList2 {get;set;}
    public String message{get;set;}
    public boolean showDisputeButton {get;set;}
    public Integer pendingEmails {get;set;}
    public Integer disputeCount {get;set;}
    public Integer disputeResolvedCount {get;set;}
    public String billingMonth {get;set;}
    Integer currentMonth;
    Map<Integer,String> monthMap = new Map<Integer,String>();
    public Date billingStartDate {get;set;}
    public Date billingEndDate {get;set;}
    public Date consumptionBillingStartDate {get;set;}
    public Date consumptionBillingEndDate {get;set;}
    public Boolean disableProcessDisputes {get;set;}
    
    Integer OFFSET = 0;  //in case you want to run prior periods for some reason.
    
    
    /****************************
    *STANDARD CONTROLLER 
    *
    ****************************/
    public GP_SubmitInvoiceController(ApexPages.StandardController controller) {
        
        monthMap = new Map<Integer,String>();
        monthMap.put(1,'January');
        monthMap.put(2,'February');
        monthMap.put(3,'March');
        monthMap.put(4,'April');
        monthMap.put(5,'May');
        monthMap.put(6,'June');
        monthMap.put(7,'July');
        monthMap.put(8,'August');
        monthMap.put(9,'September');
        monthMap.put(10,'October');
        monthMap.put(11,'November');
        monthMap.put(12,'December');
        
        
       
        r = (Parking_Lot_Region__c) controller.getRecord();  
        
        message = system.currentPageReference().getParameters().get('msg');
         
        r = [select name
                , currencyisocode
                , recordType.developername
                , send_email_to__c
                , billing_period__c
                , allow_consumption_parking__c
            from Parking_Lot_Region__c where id = :r.id];
         
        Date d = Date.today();
        
        Date tempDate = d.addmonths(-1 - OFFSET);
        
        consumptionBillingStartDate = Date.newInstance(tempDate.year(),tempdate.month(),1);
        consumptionBillingEndDate = consumptionBillingStartDate.addMonths(1);
        consumptionBillingEndDate = consumptionBillingEndDate.addDays(-1);
        
        
        d = d.addmonths(0-OFFSET);
        
        billingStartDate = Date.newInstance(d.year(),d.month(),1);
        
        if (r.billing_period__c == 'Next Month'){
            billingStartDate = billingStartDate.addMonths(1);
        }
        
        billingEndDate = billingStartDate.addMonths(1);
        billingEndDate = billingEndDate.addDays(-1);
        
        List<String> rList = Label.GP_ShowRunDisputes.split(';'); 
        Set<String> showDisputeSet = new Set<String>();
        for (String s:rList)
            showDisputeSet.add(s);
             
        if (showDisputeSet.contains(r.recordtype.developername))
            showDisputeButton = true;
         
        bList = [Select p.Parking_Lot_Region__c
                , p.Name
                , start_date_time__c
                , bills_generated__c
                , end_date_time__c
                , status__c
                , message__c
                , p.LastModifiedDate
                , p.LastModifiedById
                , p.CreatedDate
                , p.CreatedById
                , monthly_start_date__c 
                , monthly_end_date__c 
                , consumption_Start_Date__c 
                , consumption_end_Date__c
                , type__c 
                From Parking_Lot_Invoice_Run__c p
                
                where parking_lot_region__c = :r.id 
                and (monthly_start_date__c = :billingStartDate
                or consumption_Start_Date__c  = :consumptionBillingStartDate)
                
                order by createddate desc];   
                
        bList2 = [Select p.Parking_Lot_Region__c
                , p.Name
                , start_date_time__c
                , bills_generated__c
                , end_date_time__c
                , status__c
                , message__c
                , p.LastModifiedDate
                , p.LastModifiedById
                , p.CreatedDate
                , p.CreatedById
                , monthly_start_date__c 
                , monthly_end_date__c 
                , consumption_Start_Date__c 
                , consumption_end_Date__c 
                , type__c
                From Parking_Lot_Invoice_Run__c p
                where parking_lot_region__c = :r.id 
                and monthly_start_date__c <> :billingStartDate
                and monthly_start_date__c > :Date.today().addMonths(-12)
                and status__c <> 'Voided'
                order by createddate desc];   
                
         List<Parking_Lot_Assignment_Fees_Due__c> tempList = [select p.Id 
                    From Parking_Lot_Assignment_Fees_Due__c p 
                    where month_invoiced__c = last_month and conductor_sent__c = false 
                    and termination_fees__c = false
                    and Parking_Lot_Space_Assignment__r.parking_lot_request__r.parking_lot_region__r.name = :r.Name 
                    and status__c <> 'Voided'
                    ];
        
        pendingEmails = tempList.size();
         
        system.debug('rid: ' + r.id);
        string region = string.valueOf(r.id).substring(0,15);
         System.debug('consumptionbillingStartDate-'+consumptionbillingStartDate);
         System.debug('consumptionBillingEnddate-'+consumptionBillingEnddate);
        List<Parking_Lot_Space_Assignment_Time_Used__c> disputeList = [Select id
                      From Parking_Lot_Space_Assignment_Time_Used__c p
                      where parking_Lot_regionId__c = :region
                      and p.disputed__c = true
                      and p.resolved__c = false
                      and In__c >= :consumptionbillingStartDate and in__c < :consumptionBillingEnddate.addDays(1)
                      and invoice__r.status__c <> 'Voided'
                      ];
        disputeCount = disputeList.size();
        System.debug('disbuteList--'+disputeList);
        disputeList = [Select id
                      From Parking_Lot_Space_Assignment_Time_Used__c p
                      where parking_Lot_regionId__c = :region
                      and p.disputed__c = true
                      and p.resolved__c = true
                      and in__c >= :consumptionbillingStartDate and in__c < :consumptionBillingEnddate.addDays(1)
                      and invoice__r.status__c = 'Dispute Resolved'
                      ];
        disputeResolvedCount = disputeList.size();
        
        if (disputeCount > disputeResolvedCount)
            disputeMessage='Dispute resolution is required to proceed to Step 4!';
        else
            disputeMessage = null;
            
        /* if there are any out there with conductor sent = false and status__c = null then allow step 2 send emails */
        List<Parking_Lot_Assignment_Fees_Due__c> conductorList = new List<Parking_Lot_Assignment_Fees_Due__c>();
        conductorList = [
            select p.Id From Parking_Lot_Assignment_Fees_Due__c p 
            where ( (month_invoiced__c = this_month and rate_type__c = 'Monthly') or (month_invoiced__c = next_month and rate_type__c = 'Monthly')
             or (month_invoiced__c = last_month and (rate_type__c = 'Hourly' or rate_type__c = 'Daily'))) 
             and conductor_sent__c = false and (status__c <> 'Paid' and status__c <> 'Voided')
            and Parking_Lot_Space_Assignment__r.parking_lot_request__r.parking_lot_region__c = :r.id 
            ];

        disableStep3 = true;
                    
        if (conductorList.size() == 0){
            disableStep2 = true;
        }
        else{
            disableStep2 = false;
        }
        
        if (disputeResolvedCount >= disputeCount ){
            disableStep3 = false;
            disableStep4 = false;
        }
        else{
            disableStep4 = true;
                
        }
        
        if (disputeCount == 0){
            if (disputeResolvedCount > 0){
                disableStep3 = false;
                disableStep4 =false;
            }
            else{
                disableStep3 = true;
                disableStep4 = true;
            }
        }
        
        if (disableStep3 == false)
            disableStep2 = true;
        
        conductorList = [
            select p.Id From Parking_Lot_Assignment_Fees_Due__c p 
            where ( (month_invoiced__c = this_month and rate_type__c = 'Monthly')
             or (month_invoiced__c = last_month and rate_type__c = 'Hourly')) 
             and conductor_sent__c = false and status__c = 'Revised Invoice'
            and Parking_Lot_Space_Assignment__r.parking_lot_request__r.parking_lot_region__c = :r.id 
            ];
        if (conductorList.size() > 0)
            disableStep4 = false;
        else
            disableStep4 = true;

        if (disputeCount > 0)
            disableProcessDisputes = false;
        else
            disableProcessDisputes = true;
        
        
            
    }
    /******************************************************************************************
    * PROCESS DISPUTES   
    *
    *******************************************************************************************/
    public PageReference processDisputes(){
        
        PageReference p = new PageReference('/apex/gp_dispute?id=' + r.id);
        p.setRedirect(true);
        return p;  
               
        
    }
    
    
    
    /******************************************************************************************
    * SUBMIT TERMINATION BATCH   
    *
    *******************************************************************************************/
    public PageReference submitTerminations(){
        
        List<Parking_Lot_Invoice_Run__c> checkList = [select status__c from Parking_Lot_Invoice_Run__c where status__c = 'Running' and parking_lot_region__c = :r.id and termination_Batch__c = true];
        if (checkList.size() > 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There is a pending job that has not completed, can not request a new run at this time!');
            ApexPages.addMessage(myMsg);
            message = '';
            return null;
        }
        
        List<Parking_Lot_Invoice_Run__c> termBatchList 
             = [Select p.Parking_Lot_Region__c
                , consumption_Start_Date__c 
                , consumption_end_Date__c
                From Parking_Lot_Invoice_Run__c p
                where parking_lot_region__c = :r.id
                and  (status__c = 'Complete' or status__c = 'Step 2 - Email Process Complete')  
                and consumption_end_date__c = LAST_MONTH
                limit 1
                ]; 
                
        
        if (termBatchList.size() == 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'You must first run billing for the month. Once billing is complete, then the termination batch can be run!');
            ApexPages.addMessage(myMsg);
            message = '';
            return null;
        }
        
        message = 'Termination invoice run has been scheduled!';
        
        b = new Parking_Lot_Invoice_Run__c(
              Parking_Lot_Region__c = r.id
            , type__c = 'Termination'
            , status__c = 'Submitted'
            , termination_batch__c = true
            , consumption_billing_month__c = monthMap.get(consumptionBillingStartDate.month())
            , billing_month__c = monthMap.get(billingStartDate.month())
            , currencyIsoCode = r.currencyIsoCode
            , monthly_start_date__c = billingStartDate
            , monthly_end_date__c = billingEndDate
            , consumption_Start_Date__c = consumptionBillingStartDate
            , consumption_end_Date__c = consumptionBillingEndDate
            , send_email_to__c = r.send_email_to__c
            
           ); 
           
       
        insert b;
        
        Boolean terminationRun = true;
        
        id batchId = Database.executeBatch(new GP_MonthlyBilling(r.id,b.id,'Full',billingStartDate,billingEndDate,consumptionBillingStartDate,consumptionBillingEndDate,terminationRun), 1000);  
       
        PageReference p = new PageReference('/apex/gp_submitinvoicebatch?id=' + r.id + '&msg=' + message);
        p.setRedirect(true);
        return p;  
                
    }
    
    /******************************************************************************************
    * SUBMIT   
    *
    *******************************************************************************************/
    public PageReference submit(){
        
        List<Parking_Lot_Invoice_Run__c> checkList = [select status__c from Parking_Lot_Invoice_Run__c where status__c = 'Running' and parking_lot_region__c = :r.id];
        if (checkList.size() > 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There is a pending job that has not completed, can not request a new run at this time!');
            ApexPages.addMessage(myMsg);
            message = '';
            return null;
        }
        
        /* Check for outstanding disputes */
        String regId = string.valueOf(r.id).substring(0,15);
        List<Parking_Lot_Space_Assignment_Time_Used__c> disputeList = new List<Parking_Lot_Space_Assignment_Time_Used__c>(
                    [Select Id
                      From Parking_Lot_Space_Assignment_Time_Used__c p
                      where parking_Lot_regionId__c = :regId
                      and p.disputed__c = true
                      and p.resolved__c = false
                      and In__c >= :consumptionbillingStartDate and in__c < :consumptionBillingEnddate.addDays(1)
                      and invoice__r.status__c <> 'Voided'
                      ]);
        if (!disputeList.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There are ' + disputeList.size() + ' disputes outstanding.  Resolve all disputes before submitting invoice process!');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        /* Check for bad data */
        
        List<Parking_Lot_Space_Assignment_Time_Used__c> badDataList = new List<Parking_Lot_Space_Assignment_Time_Used__c>(
                    [Select Id
                      From Parking_Lot_Space_Assignment_Time_Used__c p
                      where parking_Lot_regionId__c = :regId
                      and (in__c = null 
                      or out__c = null)
                      ]);
        if (!badDataList.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There are ' + badDataList.size() + ' invalid time rows.  Correct all invalid data before submitting invoice process!');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        List<Parking_Lot_Invoice_Run__c> checkListF = [select status__c from Parking_Lot_Invoice_Run__c 
        where monthly_start_date__c = :billingStartDate 
        and parking_lot_region__c = :r.id];
        
        //delete checkListF;
        
        message = 'Full invoice run has been scheduled!';
        
        b = new Parking_Lot_Invoice_Run__c(
              Parking_Lot_Region__c = r.id
            , type__c = 'Full'
            , status__c = 'Submitted'
            , consumption_billing_month__c = monthMap.get(consumptionBillingStartDate.month())
            , billing_month__c = monthMap.get(billingStartDate.month())
            , currencyIsoCode = r.currencyIsoCode
            , monthly_start_date__c = billingStartDate
            , monthly_end_date__c = billingEndDate
            , consumption_Start_Date__c = consumptionBillingStartDate
            , consumption_end_Date__c = consumptionBillingEndDate
            , send_email_to__c = r.send_email_to__c
            , termination_batch__c = false 
           ); 
           
       
        insert b;
        
        disableStep2 = true;
        disableStep3 = true;
        disableStep4 = true;
        Boolean terminationRun = false;
        
        id batchId = Database.executeBatch(new GP_MonthlyBilling(r.id,b.id,'Full',billingStartDate,billingEndDate,consumptionBillingStartDate,consumptionBillingEndDate,terminationRun), 1000);  
       
        PageReference p = new PageReference('/apex/gp_submitinvoicebatch?id=' + r.id + '&msg=' + message);
        p.setRedirect(true);
        return p;  
                
    }
    
    /******************************************************************************************
    * SUBMIT   
    *
    *******************************************************************************************/
    public PageReference submitDisputes(){
        
        system.debug('***********************  submitting disputes');
        
        List<Parking_Lot_Invoice_Run__c> checkList = [select status__c from Parking_Lot_Invoice_Run__c where status__c = 'Running' and parking_lot_region__c = :r.id];
        if (checkList.size() > 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There is a pending job that has not completed, can not request a new run at this time!');
            ApexPages.addMessage(myMsg);
            message = '';
            return null;
        }
        
        /* Check for outstanding disputes */
        String regId = string.valueOf(r.id).substring(0,15);
        List<Parking_Lot_Space_Assignment_Time_Used__c> disputeList = new List<Parking_Lot_Space_Assignment_Time_Used__c>(
                    [Select Id, resolved__c
                      From Parking_Lot_Space_Assignment_Time_Used__c p
                      where parking_Lot_regionId__c = :regId
                      and p.disputed__c = true
                      ]);
        Boolean allResolved = true;
        for (Parking_Lot_Space_Assignment_Time_Used__c d:disputeList)
            if (d.resolved__c == false)
                allResolved = false;
                
        if (!allResolved){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There are ' + disputeList.size() + ' disputes that have not been resolved.  Resolve oustanding disputes and then submit dispute run!');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        List<Parking_Lot_Invoice_Run__c> checkListF = [select status__c from Parking_Lot_Invoice_Run__c where status__c = 'Failed' and parking_lot_region__c = :r.id];
        
        //delete checkListF;
        
        message = 'Dispute invoice generation has been scheduled!';
        
        b = new Parking_Lot_Invoice_Run__c(
            Parking_Lot_Region__c = r.id
            , type__c = 'Dispute'
            , status__c = 'Submitted'
            , consumption_billing_month__c = monthMap.get(consumptionBillingStartDate.month())
            , billing_month__c = monthMap.get(billingStartDate.month())
            , monthly_start_date__c = billingStartDate
            , monthly_end_date__c = billingEndDate
            , consumption_Start_Date__c = consumptionBillingStartDate
            , consumption_end_Date__c = consumptionBillingEndDate
            , currencyIsoCode = r.currencyIsoCode
            , send_email_to__c = r.send_email_to__c  
            , termination_batch__c = false 
            ); 
       
        insert b;
        
        Boolean terminationRun=false;
        id batchId = Database.executeBatch(new GP_MonthlyBilling(r.id,b.id,'Disputes',billingStartDate,billingEndDate,consumptionBillingStartDate,consumptionBillingEndDate,terminationRun), 1000);  
      
        PageReference p = new PageReference('/apex/gp_submitinvoicebatch?id=' + r.id + '&msg=' + message);
        p.setRedirect(true);
        return p;  
                
    }
     /******************************************************************************************
    * STATUS   
    *
    *******************************************************************************************/
    public PageReference status(){
        
        message = 'Refresh complete!';
        
        PageReference p = new PageReference('/apex/gp_submitinvoicebatch?id=' + r.id + '&msg=' + message);
        p.setRedirect(true);
        return p;  
               
    }
    /******************************************************************************************
    * EXIT   
    *
    *******************************************************************************************/
    public PageReference exit(){
   
        PageReference p = new PageReference('/' + r.id);
        p.setRedirect(true);
        return p;  
       
    }
    
    
}