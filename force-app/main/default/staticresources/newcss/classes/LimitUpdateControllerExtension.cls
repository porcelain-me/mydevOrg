public class LimitUpdateControllerExtension{

    private final Limit_Update__c limupdate;
    Limit_Update__c cloneableRequestForm = new Limit_Update__c();
    
    Integer AggregateLimitsFlag = 0;
    Integer SingleOrderLimitFlag1 = 0;
    Integer SingleOrderLimitFlag2 = 0;
    Integer SingleOrderLimitFlag3 = 0;
    Integer SingleOrderLimitFlag4 = 0;
    Integer SingleOrderLimitFlag5 = 0;
    Integer SingleOrderLimitFlag6 = 0;
    Integer SingleOrderLimitFlag7 = 0;
    Integer CashLimitFlag = 0;
    Integer SpeedwayLimitFlag = 0;
    Integer BIDSLimitFlag = 0;
    Integer OptionsFlag = 0;
    Integer OptionsStratFlag = 0;
    Integer FXLimitFlag = 0;
    Integer CashAggLimitFlag = 0;
    
    String PageTitle;
    
        /* Start Code For TASK3471515 by Sudarshan Kadam - 17-11-2014 */
    Integer USTreasuryFlag = 0;
    Integer USDIRSFlag = 0;
    /*---------End Code-----------------------*/
    
    
    public LimitUpdateControllerExtension(ApexPages.StandardController stdcontroller) {
        
        this.limupdate=(Limit_Update__c)stdController.getRecord();   
        this.limupdate.Logged_In_User__c = userinfo.getName();           
        
        calcLimits();
        calcCashAggLimits();
        calcSingleOrderLimits();
        calcAssetClass();
        
        if(limupdate.name == null)
        {
            PageTitle = '';
            Date myDate = system.today();
            DateTime myDateTime = (DateTime) myDate;
            String dayOfWeek = myDateTime.format('E');
            if(dayOfWeek.equalsIgnoreCase('Fri'))
                limupdate.Revert_Temporary_Update__c = system.today()+3;
            else
                limupdate.Revert_Temporary_Update__c = system.today()+1;
        }
        else
        {
            PageTitle = limupdate.name;
            retriveAccountDetails();
        }
        
        if(limupdate.reject_Mkt_Order__c == null)
            limupdate.reject_Mkt_Order__c = 'No';
        
        if(limupdate.reject_Mkt_Order_2__c == null)
            limupdate.reject_Mkt_Order_2__c = 'No';
            
        if(limupdate.reject_Mkt_Order_3__c == null)
            limupdate.reject_Mkt_Order_3__c = 'No';    
        
        if(limupdate.reject_Mkt_Order_4__c == null)
            limupdate.reject_Mkt_Order_4__c = 'No';
            
        if(limupdate.reject_Mkt_Order_5__c == null)
            limupdate.reject_Mkt_Order_5__c = 'No';
        
        if(limupdate.reject_Mkt_Order_6__c == null)
            limupdate.reject_Mkt_Order_6__c = 'No';
            
        if(limupdate.reject_Mkt_Order_7__c == null)
            limupdate.reject_Mkt_Order_7__c = 'No';
        
        if(limupdate.reject_Mkt_Order_Options__c == null)
            limupdate.reject_Mkt_Order_Options__c = 'No';
            
        if(limupdate.reject_Mkt_Order_OptionsStrat__c == null)
            limupdate.reject_Mkt_Order_OptionsStrat__c = 'No';
        
        if(limupdate.destination_ID__c == null)
            limupdate.destination_ID__c = '*';
        
        if(limupdate.destination_ID_2__c == null)
            limupdate.destination_ID_2__c = '*';
            
        if(limupdate.destination_ID_3__c == null)
            limupdate.destination_ID_3__c = '*';
        
        if(limupdate.destination_ID_4__c == null)
            limupdate.destination_ID_4__c = '*';
            
        if(limupdate.destination_ID_5__c == null)
            limupdate.destination_ID_5__c = '*';
        
        if(limupdate.destination_ID_6__c == null)
            limupdate.destination_ID_6__c = '*';
            
        if(limupdate.destination_ID_7__c == null)
            limupdate.destination_ID_7__c = '*';
            
        if(limupdate.Requested_By__c == null)
            limupdate.Requested_By__c = UserInfo.getUserId();
    }
    
        /* Start Code For TASK3471515 by Sudarshan Kadam - 17-11-2014 */
    public Integer getUSTreasuryFlag(){
        return this.USTreasuryFlag;
    }
    public Integer getUSDIRSFlag(){
        return this.USDIRSFlag;
    }
    /*-------------  End Code -------------- */

    
    public Integer getAggregateLimitsFlag()
    {
            return this.AggregateLimitsFlag;
    }
     public Integer getCashAggLimitFlag()
    {
            return this.CashAggLimitFlag;
    }
    
    public Integer getSingleOrderLimitFlag1()
    {
            return this.SingleOrderLimitFlag1;
    }
    
    public Integer getSingleOrderLimitFlag2()
    {
            return this.SingleOrderLimitFlag2;
    }
    
    public Integer getSingleOrderLimitFlag3()
    {
            return this.SingleOrderLimitFlag3;
    }
    
    public Integer getSingleOrderLimitFlag4()
    {
            return this.SingleOrderLimitFlag4;
    }
    
    public Integer getSingleOrderLimitFlag5()
    {
            return this.SingleOrderLimitFlag5;
    }
    
    public Integer getSingleOrderLimitFlag6()
    {
            return this.SingleOrderLimitFlag6;
    }
    
    public Integer getSingleOrderLimitFlag7()
    {
            return this.SingleOrderLimitFlag7;
    }
    
    public Integer getSpeedwayLimitFlag()
    {
            return this.SpeedwayLimitFlag;
    }
    
    public Integer getCashLimitFlag()
    {
            return this.CashLimitFlag;
    }
    
    public Integer getFXLimitFlag()
    {
              return this.FXLimitFlag;
    }
    
    public Integer getOptionsFlag()
    {
            return this.OptionsFlag;
    }
    
    public Integer getOptionsStratFlag()
    {
            return this.OptionsStratFlag;
    }
    
    public Integer getBIDSLimitFlag()
    {
            return this.BIDSLimitFlag;
    }
    
    public String getPageTitle()
    {
          return this.PageTitle;
    }
    
    public Limit_Update__c editRequest { get; set; }
    
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }
    
    public Limit_Update__c getRequests()
    {
        return [Select Requested_By__c from Limit_Update__c where Id=:limupdate.Id];
    }
    
    public pagereference save(){
    
        PageReference pageRef = ApexPages.currentPage();
        String flowType = pageRef.getParameters().get('flow');
        
        if(flowType != null && flowType.equals('clone')) {
            return this.cloneForm();
        } 
        retriveAccountDetails();  
    
     try {
            upsert(limupdate);
            } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
       } 
       
     if (limupdate.Send_Email_To__c != null)
       {
        sendMailto(limupdate);
       } 
        
       return (new ApexPages.StandardController(limupdate)).view();           
    }
    
    public PageReference sendMailto(Limit_Update__c ref) 
   {
    String[] toAddresses1 = new list<String>();
     if(ref.Send_Email_To__c !=null)
      {
         toAddresses1.add(limupdate.Send_Email_To__c);
      }
         Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
         email.setTargetObjectId(UserInfo.getUserId());//limupdate.RequestedBy__c);
         email.setCcAddresses(toAddresses1);
         email.setWhatId(ref.Id);
         email.setTemplateId('00X600000017JpF');//qa - 00XT0000000nPqi  prod - 00X600000017JpF
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     
     return null;
      
   }
    
    public PageReference editRequestedBy() {
        String editid = getParam('editid');
        editRequest = [SELECT Requested_By__c FROM Limit_Update__c WHERE Id=:editid];
        return null;
    }
     
    public PageReference saveEdit() {
        try {
            editRequest = null;
            save();
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    public void calcLimits(){
    
        if(limupdate.Limit_Type__c!=null)
        {
            if(limupdate.Limit_Type__c.indexOf('CFM Aggregate limit')!=-1)            
                AggregateLimitsFlag = 1;                
            else
                AggregateLimitsFlag = 0; 
                
            if(limupdate.Limit_Type__c.indexOf('CFM single order limit')!=-1)
                SingleOrderLimitFlag1 = 1;
            else                        
                SingleOrderLimitFlag1 = 0;         
            
            if(limupdate.Limit_Type__c.indexOf('Speedway limit')!=-1)  
                SpeedwayLimitFlag = 1;
            else
                SpeedwayLimitFlag = 0;    
                
            if(limupdate.Limit_Type__c.indexOf('BIDS limit')!=-1)  
                BIDSLimitFlag = 1;
            else
                BIDSLimitFlag = 0;                                                 
        }    
        else
        {
               AggregateLimitsFlag = 0; 
               SingleOrderLimitFlag1 = 0; 
               SingleOrderLimitFlag2 = 0; 
               SingleOrderLimitFlag3 = 0; 
               SingleOrderLimitFlag4 = 0; 
               SingleOrderLimitFlag5 = 0; 
               SingleOrderLimitFlag6 = 0;            
               SingleOrderLimitFlag7 = 0;
               SpeedwayLimitFlag = 0; 
               BIDSLimitFlag = 0;                                                
        }
        
        calcAssetClass();
        calcSingleOrderLimits();        
    }     
    
    public void calcCashAggLimits(){
    
      if(CashLimitFlag == 1 && AggregateLimitsFlag ==1)
      {
        if(limupdate.Add_another_exec_region_aggregate_Limit__c == true)
          CashAggLimitFlag = 1;
        else
          CashAggLimitFlag = 0;  
      }
    }
    
    public void calcSingleOrderLimits(){
    
        if(SingleOrderLimitFlag1 == 1 && CashLimitFlag == 1)
        {
            if(limupdate.Add_another_destination_ID_limit__c == true)
                SingleOrderLimitFlag2 = 1;
            else                         
                SingleOrderLimitFlag2 = 0;
                            
            if(limupdate.Add_another_destination_ID_limit__c == true && limupdate.Add_another_destination_ID_limit_2__c == true)  
                SingleOrderLimitFlag3 = 1;
            else
                SingleOrderLimitFlag3 = 0;    
            
            if(SingleOrderLimitFlag3 == 1 && limupdate.Add_another_destination_ID_limit_3__c == true)
                SingleOrderLimitFlag4 = 1;    
            else   
                SingleOrderLimitFlag4 = 0; 
                
            if(SingleOrderLimitFlag4 == 1 && limupdate.Add_another_destination_ID_limit_4__c == true)
                SingleOrderLimitFlag5 = 1;    
            else   
                SingleOrderLimitFlag5 = 0;  
                
            if(SingleOrderLimitFlag5 == 1 && limupdate.Add_another_destination_ID_limit_5__c == true)
                SingleOrderLimitFlag6 = 1;    
            else   
                SingleOrderLimitFlag6 = 0;  
            
            if(SingleOrderLimitFlag6 == 1 && limupdate.Add_another_destination_ID_limit_6__c == true)
                SingleOrderLimitFlag7 = 1;    
            else   
                SingleOrderLimitFlag7 = 0;          
        }
        else
        {
            SingleOrderLimitFlag2 = 0; 
            SingleOrderLimitFlag3 = 0;
            SingleOrderLimitFlag4 = 0; 
            SingleOrderLimitFlag5 = 0; 
            SingleOrderLimitFlag6 = 0;            
            SingleOrderLimitFlag7 = 0;   
        }
    }
    
    public void calcAssetClass() {
    
        if(limupdate.Asset_Class__c!=null)
        {
          if(limupdate.Asset_Class__c.indexOf('Options')!=-1)
              OptionsFlag = 1;  
          else
              OptionsFlag = 0;
          
          if(limupdate.Asset_Class__c.indexOf('options strat')!=-1) 
              OptionsStratFlag = 1;     
          else
              OptionsStratFlag = 0;
              
          if(limupdate.Asset_Class__c.indexOf('Cash')!=-1) 
              CashLimitFlag = 1;     
          else
              CashLimitFlag = 0; 
              
          if(limupdate.Asset_Class__c.indexOf('FX')!=-1)
              FXLimitFlag = 1;
          else
              FXLimitFlag = 0;  
              
              /* Start Code for TASK3471515 by Sudarshan Kadam - 17-11-2014*/ 
         if(limupdate.Asset_Class__c.indexOf('US Treasury')!=-1)
              USTreasuryFlag = 1;
          else
              USTreasuryFlag = 0;
              
          if(limupdate.Asset_Class__c.indexOf('USD IRS')!=-1)
              USDIRSFlag = 1;
          else
              USDIRSFlag = 0; 
          /*--------------End Code --------------------------*/         
        }
        else
        {
            OptionsFlag = 0;
            OptionsStratFlag = 0;
            CashLimitFlag = 0;
            FXLimitFlag = 0;
            
            //Following Line for TASK3471515 done by Sudrshan Kadam-17-11-2014
            USTreasuryFlag = 0;
            USDIRSFlag = 0;
        }
    }
    
    public void retriveAccountDetails() {
    
        if(limupdate.MSET_Account__c != null)  
        {  
         MSET_Account__c account = [select Short_Trading_Name__c, TNL_ID__c, Name, Trading_Name_ID__c from 
             MSET_Account__c where Id = :limupdate.MSET_Account__c limit 1];                
             limupdate.Account_Number__c = account.TNL_ID__c;
        }
        
    }
    
    public PageReference refreshPage()
    {
       calcLimits();
       calcSingleOrderLimits();
       
       return null;
    } 
    
    public PageReference cloneAction() {
        PageReference editForm = new Apexpages.Standardcontroller(limupdate).edit();
        editForm.getParameters().put('flow','clone');
        editForm.setredirect(true);
        return editForm;
    }
    
    public PageReference cloneForm() {
       PageReference pref = null;   
       
      try{
            this.cloneableRequestForm.MSET_Account__c = this.limupdate.MSET_Account__c;   
            this.cloneableRequestForm.Add_another_destination_ID_limit_2__c = this.limupdate.Add_another_destination_ID_limit_2__c;   
            this.cloneableRequestForm.Add_another_destination_ID_limit_3__c = this.limupdate.Add_another_destination_ID_limit_3__c;   
            this.cloneableRequestForm.Add_another_destination_ID_limit__c = this.limupdate.Add_another_destination_ID_limit__c;   
            this.cloneableRequestForm.Add_another_destination_ID_limit_4__c = this.limupdate.Add_another_destination_ID_limit_4__c;   
            this.cloneableRequestForm.Add_another_destination_ID_limit_5__c = this.limupdate.Add_another_destination_ID_limit_5__c;   
            this.cloneableRequestForm.Add_another_destination_ID_limit_6__c = this.limupdate.Add_another_destination_ID_limit_6__c;   
            this.cloneableRequestForm.Asset_Class__c = this.limupdate.Asset_Class__c;   
            
            this.cloneableRequestForm.Comments__c = this.limupdate.Comments__c;   
            this.cloneableRequestForm.cumNoOrders__c = this.limupdate.cumNoOrders__c; 
            this.cloneableRequestForm.cumQty__c = this.limupdate.cumQty__c;   
            this.cloneableRequestForm.cumValue__c = this.limupdate.cumValue__c;   
            
            this.cloneableRequestForm.destination_ID_3__c = this.limupdate.destination_ID_3__c;   
            this.cloneableRequestForm.destination_ID_4__c = this.limupdate.destination_ID_4__c;
            this.cloneableRequestForm.destination_ID_5__c = this.limupdate.destination_ID_5__c;   
            this.cloneableRequestForm.destination_ID_6__c = this.limupdate.destination_ID_6__c;   
            this.cloneableRequestForm.destination_ID_7__c = this.limupdate.destination_ID_7__c;   
            this.cloneableRequestForm.destination_ID_2__c = this.limupdate.destination_ID_2__c;   
            this.cloneableRequestForm.destination_ID__c = this.limupdate.destination_ID__c;   
            
            this.cloneableRequestForm.hard_aggressive_price_away_2__c = this.limupdate.hard_aggressive_price_away_2__c;   
            this.cloneableRequestForm.hard_aggressive_price_away_3__c = this.limupdate.hard_aggressive_price_away_3__c;   
            this.cloneableRequestForm.hard_aggressive_price_away__c = this.limupdate.hard_aggressive_price_away__c;
            this.cloneableRequestForm.hard_aggressive_price_away_4__c = this.limupdate.hard_aggressive_price_away_4__c;   
            this.cloneableRequestForm.hard_aggressive_price_away_5__c = this.limupdate.hard_aggressive_price_away_5__c;
            this.cloneableRequestForm.hard_aggressive_price_away_6__c = this.limupdate.hard_aggressive_price_away_6__c;   
            this.cloneableRequestForm.hard_aggressive_price_away_7__c = this.limupdate.hard_aggressive_price_away_7__c;   
            this.cloneableRequestForm.hard_liquidity_2__c = this.limupdate.hard_liquidity_2__c;   
            this.cloneableRequestForm.hard_liquidity_3__c = this.limupdate.hard_liquidity_3__c;   
            this.cloneableRequestForm.hard_liquidity__c = this.limupdate.hard_liquidity__c;   
            this.cloneableRequestForm.hard_liquidity_4__c = this.limupdate.hard_liquidity_4__c;   
            this.cloneableRequestForm.hard_liquidity_5__c = this.limupdate.hard_liquidity_5__c;
            this.cloneableRequestForm.hard_liquidity_6__c = this.limupdate.hard_liquidity_6__c;   
            this.cloneableRequestForm.hard_liquidity_7__c = this.limupdate.hard_liquidity_7__c;   
            this.cloneableRequestForm.hard_order_qty_2__c = this.limupdate.hard_order_qty_2__c;   
            this.cloneableRequestForm.hard_order_qty_3__c = this.limupdate.hard_order_qty_3__c;   
            this.cloneableRequestForm.hard_order_qty__c = this.limupdate.hard_order_qty__c;
            this.cloneableRequestForm.hard_order_qty_4__c = this.limupdate.hard_order_qty_4__c;   
            this.cloneableRequestForm.hard_order_qty_5__c = this.limupdate.hard_order_qty_5__c;
            this.cloneableRequestForm.hard_order_qty_6__c = this.limupdate.hard_order_qty_6__c;   
            this.cloneableRequestForm.hard_order_qty_7__c = this.limupdate.hard_order_qty_7__c;   
            this.cloneableRequestForm.hard_passive_price_away_2__c = this.limupdate.hard_passive_price_away_2__c;   
            this.cloneableRequestForm.hard_passive_price_away_3__c = this.limupdate.hard_passive_price_away_3__c;   
            this.cloneableRequestForm.hard_passive_price_away__c = this.limupdate.hard_passive_price_away__c;
            this.cloneableRequestForm.hard_passive_price_away_4__c = this.limupdate.hard_passive_price_away_4__c;   
            this.cloneableRequestForm.hard_passive_price_away_5__c = this.limupdate.hard_passive_price_away_5__c;
            this.cloneableRequestForm.hard_passive_price_away_6__c = this.limupdate.hard_passive_price_away_6__c;   
            this.cloneableRequestForm.hard_passive_price_away_7__c = this.limupdate.hard_passive_price_away_7__c;   
            this.cloneableRequestForm.hard_value_2__c = this.limupdate.hard_value_2__c;   
            this.cloneableRequestForm.hard_value_3__c = this.limupdate.hard_value_3__c;   
            this.cloneableRequestForm.hard_value__c = this.limupdate.hard_value__c;
            this.cloneableRequestForm.hard_value_4__c = this.limupdate.hard_value_4__c;   
            this.cloneableRequestForm.hard_value_5__c = this.limupdate.hard_value_5__c;
            this.cloneableRequestForm.hard_value_6__c = this.limupdate.hard_value_6__c;   
            this.cloneableRequestForm.hard_value_7__c = this.limupdate.hard_value_7__c;   
            
            this.cloneableRequestForm.Limit_Type__c = this.limupdate.Limit_Type__c;   
            this.cloneableRequestForm.Logged_In_User__c = this.limupdate.Logged_In_User__c;   
            
            this.cloneableRequestForm.netCumValue__c = this.limupdate.netCumValue__c;
            
            this.cloneableRequestForm.Reason_for_Change__c = this.limupdate.Reason_for_Change__c;   
            this.cloneableRequestForm.reject_Mkt_Order_2__c = this.limupdate.reject_Mkt_Order_2__c;   
            this.cloneableRequestForm.reject_Mkt_Order_3__c = this.limupdate.reject_Mkt_Order_3__c;
            this.cloneableRequestForm.reject_Mkt_Order__c = this.limupdate.reject_Mkt_Order__c;   
            this.cloneableRequestForm.reject_Mkt_Order_4__c = this.limupdate.reject_Mkt_Order_4__c;
            this.cloneableRequestForm.reject_Mkt_Order_5__c = this.limupdate.reject_Mkt_Order_5__c;   
            this.cloneableRequestForm.reject_Mkt_Order_6__c = this.limupdate.reject_Mkt_Order_6__c;   
            this.cloneableRequestForm.reject_Mkt_Order_7__c = this.limupdate.reject_Mkt_Order_7__c;   
            this.cloneableRequestForm.Requested_By__c = this.limupdate.Requested_By__c;   
            
            this.cloneableRequestForm.soft_aggressive_price_away_2__c = this.limupdate.soft_aggressive_price_away_2__c;   
            this.cloneableRequestForm.soft_aggressive_price_away_3__c = this.limupdate.soft_aggressive_price_away_3__c;   
            this.cloneableRequestForm.soft_aggressive_price_away__c = this.limupdate.soft_aggressive_price_away__c;
            this.cloneableRequestForm.soft_aggressive_price_away_4__c = this.limupdate.soft_aggressive_price_away_4__c;   
            this.cloneableRequestForm.soft_aggressive_price_away_5__c = this.limupdate.soft_aggressive_price_away_5__c;   
            this.cloneableRequestForm.soft_aggressive_price_away_6__c = this.limupdate.soft_aggressive_price_away_6__c;   
            this.cloneableRequestForm.soft_aggressive_price_away_7__c = this.limupdate.soft_aggressive_price_away_7__c;   
            this.cloneableRequestForm.soft_liquidity_2__c = this.limupdate.soft_liquidity_2__c;
            this.cloneableRequestForm.soft_liquidity_3__c = this.limupdate.soft_liquidity_3__c;   
            this.cloneableRequestForm.soft_liquidity__c = this.limupdate.soft_liquidity__c;
            this.cloneableRequestForm.soft_liquidity_4__c = this.limupdate.soft_liquidity_4__c;   
            this.cloneableRequestForm.soft_liquidity_5__c = this.limupdate.soft_liquidity_5__c;   
            this.cloneableRequestForm.soft_liquidity_6__c = this.limupdate.soft_liquidity_6__c;   
            this.cloneableRequestForm.soft_liquidity_7__c = this.limupdate.soft_liquidity_7__c;   
            this.cloneableRequestForm.soft_order_qty_2__c = this.limupdate.soft_order_qty_2__c;
            this.cloneableRequestForm.soft_order_qty_3__c = this.limupdate.soft_order_qty_3__c;   
            this.cloneableRequestForm.soft_order_qty__c = this.limupdate.soft_order_qty__c;
            this.cloneableRequestForm.soft_order_qty_4__c = this.limupdate.soft_order_qty_4__c;   
            this.cloneableRequestForm.soft_order_qty_5__c = this.limupdate.soft_order_qty_5__c;   
            this.cloneableRequestForm.soft_order_qty_6__c = this.limupdate.soft_order_qty_6__c;   
            this.cloneableRequestForm.soft_order_qty_7__c = this.limupdate.soft_order_qty_7__c;   
            this.cloneableRequestForm.soft_passive_price_away_2__c = this.limupdate.soft_passive_price_away_2__c;
            this.cloneableRequestForm.soft_passive_price_away_3__c = this.limupdate.soft_passive_price_away_3__c;   
            this.cloneableRequestForm.soft_passive_price_away__c = this.limupdate.soft_passive_price_away__c;
            this.cloneableRequestForm.soft_passive_price_away_4__c = this.limupdate.soft_passive_price_away_4__c;   
            this.cloneableRequestForm.soft_passive_price_away_5__c = this.limupdate.soft_passive_price_away_5__c;
            this.cloneableRequestForm.soft_passive_price_away_6__c = this.limupdate.soft_passive_price_away_6__c;   
            this.cloneableRequestForm.soft_passive_price_away_7__c = this.limupdate.soft_passive_price_away_7__c;   
            this.cloneableRequestForm.soft_value_2__c = this.limupdate.soft_value_2__c;   
            this.cloneableRequestForm.soft_value_3__c = this.limupdate.soft_value_3__c;   
            this.cloneableRequestForm.soft_value__c = this.limupdate.soft_value__c;   
            this.cloneableRequestForm.soft_value_4__c = this.limupdate.soft_value_4__c;   
            this.cloneableRequestForm.soft_value_5__c = this.limupdate.soft_value_5__c;   
            this.cloneableRequestForm.soft_value_6__c = this.limupdate.soft_value_6__c;   
            this.cloneableRequestForm.soft_value_7__c = this.limupdate.soft_value_7__c;   
            this.cloneableRequestForm.Supervisor_s_Approval__c = this.limupdate.Supervisor_s_Approval__c; 
            this.cloneableRequestForm.Supervisor_s_Name_approving_transaction__c = this.limupdate.Supervisor_s_Name_approving_transaction__c;               
            
            this.cloneableRequestForm.Speedway_address__c = this.limupdate.Speedway_address__c;   
            this.cloneableRequestForm.Min_qty__c = this.limupdate.Min_qty__c;   
            this.cloneableRequestForm.Max_qty_max_shres_per_order__c = this.limupdate.Max_qty_max_shres_per_order__c;
            this.cloneableRequestForm.Value__c = this.limupdate.Value__c;   
            this.cloneableRequestForm.Liquidity__c = this.limupdate.Liquidity__c;   
            this.cloneableRequestForm.Max_of_rejects__c = this.limupdate.Max_of_rejects__c;   
            this.cloneableRequestForm.of_requests_new_replace_per_second__c = this.limupdate.of_requests_new_replace_per_second__c;   
            this.cloneableRequestForm.Reject_on_open_on_close_mkt_orders__c = this.limupdate.Reject_on_open_on_close_mkt_orders__c;
            this.cloneableRequestForm.Reject_ISO_orders__c = this.limupdate.Reject_ISO_orders__c;   
            this.cloneableRequestForm.Reject_Imbalance_after_NYSE_auction__c = this.limupdate.Reject_Imbalance_after_NYSE_auction__c;
            this.cloneableRequestForm.Reject_Short_Sale_No_Locate_Source__c = this.limupdate.Reject_Short_Sale_No_Locate_Source__c;  
             
            this.cloneableRequestForm.cumQty_Options__c = this.limupdate.cumQty_Options__c;   
            this.cloneableRequestForm.cumValue_Options__c = this.limupdate.cumValue_Options__c;   
            this.cloneableRequestForm.cumExposure_Options__c = this.limupdate.cumExposure_Options__c;                          
             
            this.cloneableRequestForm.soft_value_Options__c = this.limupdate.soft_value_Options__c;
            this.cloneableRequestForm.soft_Liquidity_Options__c = this.limupdate.soft_Liquidity_Options__c;   
            this.cloneableRequestForm.soft_orderQty_Options__c = this.limupdate.soft_orderQty_Options__c;
            this.cloneableRequestForm.reject_Mkt_Order_Options__c = this.limupdate.reject_Mkt_Order_Options__c;  
             
            this.cloneableRequestForm.hard_value_Options__c = this.limupdate.hard_value_Options__c;   
            this.cloneableRequestForm.hard_liquidity_Options__c = this.limupdate.hard_liquidity_Options__c;
            this.cloneableRequestForm.hard_orderQty_Options__c = this.limupdate.hard_orderQty_Options__c;   
            
            this.cloneableRequestForm.cumQty_OptionsStrat__c = this.limupdate.cumQty_OptionsStrat__c;   
            this.cloneableRequestForm.cumValue_OptionsStrat__c = this.limupdate.cumValue_OptionsStrat__c;
            this.cloneableRequestForm.cumExposure_OptionsStrat__c = this.limupdate.cumExposure_OptionsStrat__c;   
            
            this.cloneableRequestForm.soft_value_OptionsStrat__c = this.limupdate.soft_value_OptionsStrat__c;   
            this.cloneableRequestForm.soft_liquidity_OptionsStrat__c = this.limupdate.soft_liquidity_OptionsStrat__c;   
            this.cloneableRequestForm.soft_orderQty_OptionsStrat__c = this.limupdate.soft_orderQty_OptionsStrat__c;   
            this.cloneableRequestForm.reject_Mkt_Order_OptionsStrat__c = this.limupdate.reject_Mkt_Order_OptionsStrat__c;
            
            this.cloneableRequestForm.hard_value_OptionsStrat__c = this.limupdate.hard_value_OptionsStrat__c;   
            this.cloneableRequestForm.hard_liquidity_OptionsStrat__c = this.limupdate.hard_liquidity_OptionsStrat__c;
            this.cloneableRequestForm.hard_orderQty_OptionsStrat__c = this.limupdate.hard_orderQty_OptionsStrat__c;
            
            this.cloneableRequestForm.cumValue_FX__c = this.limupdate.cumValue_FX__c;
            this.cloneableRequestForm.netValue_FX__c = this.limupdate.netValue_FX__c;
            this.cloneableRequestForm.cumNoOrders_FX__c = this.limupdate.cumNoOrders_FX__c;
            this.cloneableRequestForm.currency_FX__c = this.limupdate.currency_FX__c;
            
            this.cloneableRequestForm.Notional_Value_hard_FX__c = this.limupdate.Notional_Value_hard_FX__c;
            this.cloneableRequestForm.Price_Away_hard_FX__c = this.limupdate.Price_Away_hard_FX__c;
            
            this.cloneableRequestForm.Firm_Acronym__c = this.limupdate.Firm_Acronym__c;
            this.cloneableRequestForm.Max_order_val__c = this.limupdate.Max_order_val__c;   
            this.cloneableRequestForm.Allow_short_sell__c = this.limupdate.Allow_short_sell__c;
            this.cloneableRequestForm.Easy_to_borrow_short_sell_only__c = this.limupdate.Easy_to_borrow_short_sell_only__c;   
            this.cloneableRequestForm.Daily_max_on_sells__c = this.limupdate.Daily_max_on_sells__c;   
            this.cloneableRequestForm.Warning_level_1__c = this.limupdate.Warning_level_1__c;   
            this.cloneableRequestForm.Warning_level_2__c = this.limupdate.Warning_level_2__c;   
            this.cloneableRequestForm.Daily_max_on_buys__c = this.limupdate.Daily_max_on_buys__c;
            this.cloneableRequestForm.Warning_level_1_buys__c = this.limupdate.Warning_level_1_buys__c;   
            this.cloneableRequestForm.Warning_level_2_buys__c = this.limupdate.Warning_level_2_buys__c;
            this.cloneableRequestForm.Gross_max_val__c = this.limupdate.Gross_max_val__c;   
            this.cloneableRequestForm.Warning_level_1_gross__c = this.limupdate.Warning_level_1_gross__c;   
            this.cloneableRequestForm.Warning_level_2_gross__c = this.limupdate.Warning_level_2_gross__c;   
            this.cloneableRequestForm.Passive_price_away__c = this.limupdate.Passive_price_away__c;
            this.cloneableRequestForm.Aggressive_price_away__c = this.limupdate.Aggressive_price_away__c;
            this.cloneableRequestForm.Max_order_volume_limit__c = this.limupdate.Max_order_volume_limit__c;
            this.cloneableRequestForm.of_ADV_limit__c = this.limupdate.of_ADV_limit__c;
            this.cloneableRequestForm.Send_Email_To__c = this.limupdate.Send_Email_To__c;
 
                        /*---------------------Start Code For TASK3471515 by Sudarshan Kadam - 18/11/2014------------------*/
            this.cloneableRequestForm.US_Treasury_Single_Order_Price_Away__c = this.limupdate.US_Treasury_Single_Order_Price_Away__c;
            this.cloneableRequestForm.US_Treasury_Single_Order_UnScaled_Qty__c = this.limupdate.US_Treasury_Single_Order_UnScaled_Qty__c;
            this.cloneableRequestForm.US_Treasury_Aggregate_Gross_UnScaledQty__c = this.limupdate.US_Treasury_Aggregate_Gross_UnScaledQty__c;
            this.cloneableRequestForm.US_Treasury_Aggregate_Order_Count__c = this.limupdate.US_Treasury_Aggregate_Order_Count__c;
            this.cloneableRequestForm.USD_IRS_Single_Order_PV01__c = this.limupdate.USD_IRS_Single_Order_PV01__c;
            this.cloneableRequestForm.USD_IRS_Single_Order_UnScaled_Qty__c = this.limupdate.USD_IRS_Single_Order_UnScaled_Qty__c;
            this.cloneableRequestForm.USD_IRS_Aggregate_PV01__c = this.limupdate.USD_IRS_Aggregate_PV01__c;
            this.cloneableRequestForm.USD_IRS_Aggregate_Gross_UnScaledQty__c = this.limupdate.USD_IRS_Aggregate_Gross_UnScaledQty__c;
            this.cloneableRequestForm.USD_IRS_Aggregate_Order_Count__c =  this.limupdate.USD_IRS_Aggregate_Order_Count__c;
            
            /*----------------------End Code---------------------------*/          
 
                        // singhrak, REQ3037244,TASK3513362 02-dec-14 start
            this.cloneableRequestForm.Exec_Region_Aggregate_Limts__c =  this.limupdate.Exec_Region_Aggregate_Limts__c;
            this.cloneableRequestForm.Add_another_exec_region_aggregate_Limit__c =  this.limupdate.Add_another_exec_region_aggregate_Limit__c;
            
            this.cloneableRequestForm.cumValue2__c =  this.limupdate.cumValue2__c;
            this.cloneableRequestForm.Exec_Region_Aggregate_Limts2__c =  this.limupdate.Exec_Region_Aggregate_Limts2__c;
            this.cloneableRequestForm.cumNoOrders2__c =  this.limupdate.cumNoOrders2__c;
            this.cloneableRequestForm.netCumValue2__c =  this.limupdate.netCumValue2__c;
            this.cloneableRequestForm.cumQty2__c =  this.limupdate.cumQty2__c;
            // singhrak, REQ3037244, 02-dec-14 end
            
            
             //Cloning the latest field added as part of QC REQ2874319\
            this.cloneableRequestForm.Update_Type__c = this.limupdate.Update_Type__c;
            if(this.limupdate.Update_Type__c!= null && this.limupdate.Update_Type__c.tolowercase() == 'temporary'){
                this.cloneableRequestForm.Status__c = this.limupdate.Status__c;
                this.cloneableRequestForm.Revert_Temporary_Update__c = this.limupdate.Revert_Temporary_Update__c;
            }
            
             
           // REQ3238592,singhrak, 21Jan, 2015, satrt 
           this.cloneableRequestForm.FID_User__c =  this.limupdate.FID_User__c;
           // REQ3238592,singhrak, 21Jan, 2015, End
            
            retriveAccountDetails();
            this.cloneableRequestForm.Account_Number__c = this.limupdate.Account_Number__c;
                                     
            insert cloneableRequestForm;
            
            if (cloneableRequestForm.Send_Email_To__c != null)
            {
            sendMailto(cloneableRequestForm);
           } 
            
            pref = new ApexPages.StandardController(cloneableRequestForm).view();
            pref.setredirect(true);
          }   
          catch(Exception e) {
          System.debug('General Exception : '+e.getMessage());
      } 
       return pref;  
    }    
}