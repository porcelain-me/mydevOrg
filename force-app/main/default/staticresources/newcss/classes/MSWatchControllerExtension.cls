public class MSWatchControllerExtension{

   private final MS_Watch__c mswatch;
   MS_Watch__c cloneableRequestForm = new MS_Watch__c();
      
   Integer CompSubIdFlag1 = 0;
   Integer EmailAddFlag1 = 0;
   Integer IMAOLAddFlag1 = 0;
   Integer PassLogFlag1 = 0;
   Integer BBIMAddFlag1 = 0;
   Integer IntListFlag1 = 0;
   Integer CFMUserFlag1 = 0;
   Integer NYAlertEmailFlag1 = 0;
   Integer NYAlertAOLIMFlag1 = 0;
   Integer NYAlertPPFlag1 = 0;
   Integer NYAlertBBFlag1 = 0;
   Integer NYAlertIntListFlag1 = 0;
   Integer NYAlertCFMUserFlag1 = 0;
   Integer LNAlertEmailFlag1 = 0;
   Integer LNAlertAOLIMFlag1 = 0;
   Integer LNAlertPPFlag1 = 0;
   Integer LNAlertBBFlag1 = 0;
   Integer LNAlertIntListFlag1 = 0;
   Integer LNAlertCFMUserFlag1 = 0;
   Integer AsiaAlertEmailFlag1 = 0;
   Integer AsiaAlertPPFlag1 = 0;
   Integer AsiaAlertBBFlag1 = 0;
   Integer AsiaAlertIntListFlag1 = 0;
   Integer AsiaAlertCFMUserFlag1 = 0;
     //REQ4954035, vinay, 25NOV , 2015,
   Integer AsiaAlertIListFlag1 = 0;             
   Integer AsiaAlertEmail2Flag1 = 0;            
   Integer AsiaAlertPP2Flag1 = 0;           
   Integer AsiaAlertBB2Flag1 = 0;           
   Integer AsiaAlertCFM2UserFlag1 = 0;          
   //REQ4954035, vinay, 25NOV , 2015,
   
   Integer SAAlertEmailFlag1 = 0;
   Integer SAAlertAOLIMFlag1 = 0;
   Integer SAAlertPPFlag1 = 0;
   Integer SAAlertBBFlag1 = 0;
   Integer SAAlertCFMUserFlag1 = 0;
   Integer Trader2DispFlag = 0;
   
   Integer CompSubIdFlag2 = 0;
   Integer EmailAddFlag2 = 0;
   Integer IMAOLAddFlag2 = 0;
   Integer PassLogFlag2 = 0;
   Integer BBIMAddFlag2 = 0;
   Integer IntListFlag2 = 0;
   Integer CFMUserFlag2 = 0;
   Integer NYAlertEmailFlag2 = 0;
   Integer NYAlertAOLIMFlag2 = 0;
   Integer NYAlertPPFlag2 = 0;
   Integer NYAlertBBFlag2 = 0;
   Integer NYAlertIntListFlag2 = 0;
   Integer NYAlertCFMUserFlag2 = 0;
   Integer LNAlertEmailFlag2 = 0;
   Integer LNAlertAOLIMFlag2 = 0;
   Integer LNAlertPPFlag2 = 0;
   Integer LNAlertBBFlag2 = 0;
   Integer LNAlertIntListFlag2 = 0;
   Integer LNAlertCFMUserFlag2 = 0;
   Integer AsiaAlertEmailFlag2 = 0;
   Integer AsiaAlertPPFlag2 = 0;
   Integer AsiaAlertBBFlag2 = 0;
   Integer AsiaAlertIntListFlag2 = 0; 
   Integer AsiaAlertCFMUserFlag2 = 0;
    //REQ4954035, vinay, 25NOV , 2015,
   Integer AsiaAlertIListFlag2 = 0;             
   Integer AsiaAlertEmail2Flag2 = 0;                
   Integer AsiaAlertPP2Flag2 = 0;               
   Integer AsiaAlertBB2Flag2 = 0;               
   Integer AsiaAlertCFM2UserFlag2 = 0;          
   //REQ4954035, vinay, 25NOV , 2015,
   Integer SAAlertEmailFlag2 = 0;
   Integer SAAlertAOLIMFlag2 = 0;
   Integer SAAlertPPFlag2 = 0;
   Integer SAAlertBBFlag2 = 0;
   Integer SAAlertCFMUserFlag2 = 0;
   Integer Trader3DispFlag = 0;
   
   Integer CompSubIdFlag3 = 0;
   Integer EmailAddFlag3 = 0;
   Integer IMAOLAddFlag3 = 0;
   Integer PassLogFlag3 = 0;
   Integer BBIMAddFlag3 = 0;
   Integer IntListFlag3 = 0;
   Integer CFMUserFlag3 = 0;
   Integer NYAlertEmailFlag3 = 0;
   Integer NYAlertAOLIMFlag3 = 0;
   Integer NYAlertPPFlag3 = 0;
   Integer NYAlertBBFlag3 = 0;
   Integer NYAlertIntListFlag3 = 0;
   Integer NYAlertCFMUserFlag3 = 0;
   Integer LNAlertEmailFlag3 = 0;
   Integer LNAlertAOLIMFlag3 = 0;
   Integer LNAlertPPFlag3 = 0;
   Integer LNAlertBBFlag3 = 0;
   Integer LNAlertIntListFlag3 = 0;
   Integer LNAlertCFMUserFlag3 = 0; 
   Integer AsiaAlertEmailFlag3 = 0;
   Integer AsiaAlertPPFlag3 = 0;
   Integer AsiaAlertBBFlag3 = 0;
   Integer AsiaAlertIntListFlag3 = 0;
   Integer AsiaAlertCFMUserFlag3 = 0;
   //REQ4954035, vinay, 25NOV , 2015,
   Integer AsiaAlertIListFlag3 = 0;             
   Integer AsiaAlertEmail2Flag3 = 0;                
   Integer AsiaAlertPP2Flag3 = 0;               
   Integer AsiaAlertBB2Flag3 = 0;               
   Integer AsiaAlertCFM2UserFlag3 = 0;          
   //REQ4954035, vinay, 25NOV , 2015,
   Integer SAAlertEmailFlag3 = 0;
   Integer SAAlertAOLIMFlag3 = 0;
   Integer SAAlertPPFlag3 = 0;
   Integer SAAlertBBFlag3 = 0;
   Integer SAAlertCFMUserFlag3 = 0;
   Integer Trader4DispFlag = 0;
   
   Integer CompSubIdFlag4 = 0;
   Integer EmailAddFlag4 = 0;
   Integer IMAOLAddFlag4 = 0;
   Integer PassLogFlag4 = 0;
   Integer BBIMAddFlag4 = 0;
   Integer IntListFlag4 = 0;
   Integer CFMUserFlag4 = 0;
   Integer NYAlertEmailFlag4 = 0;
   Integer NYAlertAOLIMFlag4 = 0;
   Integer NYAlertPPFlag4 = 0;
   Integer NYAlertBBFlag4 = 0;
   Integer NYAlertIntListFlag4 = 0;
   Integer NYAlertCFMUserFlag4 = 0;
   Integer LNAlertEmailFlag4 = 0;
   Integer LNAlertAOLIMFlag4 = 0;
   Integer LNAlertPPFlag4 = 0;
   Integer LNAlertBBFlag4 = 0;
   Integer LNAlertIntListFlag4 = 0;
   Integer LNAlertCFMUserFlag4 = 0; 
   Integer AsiaAlertEmailFlag4 = 0;
   Integer AsiaAlertPPFlag4 = 0;
   Integer AsiaAlertBBFlag4 = 0;
   Integer AsiaAlertIntListFlag4 = 0;
   Integer AsiaAlertCFMUserFlag4 = 0;
   //REQ4954035, vinay, 25NOV , 2015,
   Integer AsiaAlertIListFlag4 = 0; 
   Integer AsiaAlertEmail2Flag4 = 0;    
   Integer AsiaAlertPP2Flag4 = 0;   
   Integer AsiaAlertBB2Flag4 = 0;   
   Integer AsiaAlertCFM2UserFlag4 = 0;
   //REQ4954035, vinay, 25NOV , 2015,
   Integer SAAlertEmailFlag4 = 0;
   Integer SAAlertAOLIMFlag4 = 0;
   Integer SAAlertPPFlag4 = 0;
   Integer SAAlertBBFlag4 = 0;
   Integer SAAlertCFMUserFlag4 = 0;
   String PageTitle;
   
    public MSWatchControllerExtension(ApexPages.StandardController stdcontroller) {
        this.mswatch=(MS_Watch__c)stdController.getRecord();   
        this.mswatch.Logged_In_User__c = userinfo.getName();
        
        calcConditionValue();
        calcSendAlertValue();
        calcNextTraderValue(); 
        
        if(mswatch.name == null)
            PageTitle = '';              
        else
            PageTitle = mswatch.name; 
        
        if(mswatch.Requested_By__c==null)
            mswatch.Requested_By__c = UserInfo.getUserId();         
     
     //REQ3228940, singhrak, 12Jan , 2015,
      NoNoneForAlertsRequiredIntraday();
      
          //singhrak, REQ3604048, 3Apr, 2015, start  
      calcTraderAgreedOpt();
      calcTraderAgreedOpt2();
      calcTraderAgreedOpt3();
      calcTraderAgreedOpt4();
   //singhrak, REQ3604048, 3Apr, 2015, end
   
   //25-may-16 REQ5529884 himanb  (for all regions)    
        String urlStringName = ApexPages.currentPage().getUrl();
            if(urlStringName.length()>100){
            editValuesOnClick();
            }
   
    
    }
    
   //25-may-16 REQ5529884 himanb (for all regions) 
     public void editValuesOnClick(){
    
     if(mswatch.Status__c == 'Complete' || mswatch.Status__c == 'Cancelled'){
                mswatch.Status__c = 'Submitted';
                mswatch.Target_Date__c=null;
                mswatch.Priority__c ='';
            
            }
    }
    
    public List<SelectOption> Options {get;set;}//swapna REQ5321074 06june2016 
    public List<SelectOption> getStatustype(){
        
    Options = new List<SelectOption>();
    Schema.DescribeFieldResult Setuptype = MS_Watch__c.Setup_Type__c.getDescribe();
    Options.add(new SelectOption('','None'));
    for (Schema.Picklistentry picklistEntry : Setuptype.getPicklistValues())
    {
    Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
    }

     return Options;
    }
    
         //REQ3228940, singhrak, 12Jan , 2015, Start
    public List<SelectOption> statusOptions {get;set;}
    public void NoNoneForAlertsRequiredIntraday() {
        statusOptions = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription =  MS_Watch__c.Alerts_Required_Intraday__c.getDescribe();
        
        for (Schema.Picklistentry picklistEntry: statusFieldDescription.getPicklistValues()){
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }   
    }
    //REQ3228940, singhrak, 12Jan , 2015, End
    
     //singhrak, REQ3604048, 3Apr, 2015, start
    public Integer TraderAFlag {
      get;  set;
      }
    public void calcTraderAgreedOpt()
    {
      system.debug(mswatch.Condition_for_R1__c+'TraderAFlag123:'+mswatch.Send_alerts_via_R1__c+'ss'+mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c);
    if(mswatch.Condition_for_R1__c != null && (mswatch.Condition_for_R1__c.indexOf('LN_FIX_BXS') != -1 || mswatch.Condition_for_R1__c.indexOf('LN_FIX_SWAPS') != -1  || 
      mswatch.Condition_for_R1__c.indexOf('LN_PASSPORT') != -1) 
      && 
      mswatch.Send_alerts_via_R1__c != null && (mswatch.Send_alerts_via_R1__c.indexOf('Bloomberg IM') != -1  || mswatch.Send_alerts_via_R1__c.indexOf('CFM User only') != -1 || 
      mswatch.Send_alerts_via_R1__c.indexOf('Email') != -1 || mswatch.Send_alerts_via_R1__c.indexOf('IM_AOL') != -1 ||mswatch.Send_alerts_via_R1__c.indexOf('Passport') != -1  ) 
       &&
      (LNAlertEmailR1() ||  LNAlertPPR1() || LNAlertAOL_IMR1() ||
      LNAlertBBGR1() || LNAlertCRMUserR1() )   
      )
      {
          TraderAFlag = 1;
      }
      else
          TraderAFlag = 0;
          
      system.debug('TraderAFlag123:'+TraderAFlag);
      
    } 
    
    public boolean LNAlertEmailR1()
    {
      if(mswatch.Enable_LN_alerts_for_Email_for_R1__c != null && (mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('CDOrderAck25%ADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('CDOrderCxl25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('CDOrderFill25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInAck (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInAck (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInAckNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInCancelNoADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInCxl (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInCxl (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInFill ((SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInFill (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInFillNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInReplaceNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R1__c.indexOf('OptInRpl (SymOnly)') != -1 
)  
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertPPR1()
    {
      if( mswatch.Enable_LN_alerts_for_PP_for_R1__c != null && (
        mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R1__c.indexOf('OptInRpl (SymOnly)') != -1 
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertBBGR1()
    {
      if(  mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c != null && (
      mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c.indexOf('OptInRpl (SymOnly)') != -1

        )
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertAOL_IMR1()
    {
      if(  mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c != null && (
      mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c.indexOf('OptInRpl (SymOnly)')  != -1
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertCRMUserR1()
    {
      if(mswatch.Enable_LN_alert_for_CFM_Users_R1__c != null && (
      mswatch.Enable_LN_alert_for_CFM_Users_R1__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R1__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R1__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R1__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R1__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R1__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R1__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1  
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
     public Integer TraderAFlag2 {
      get;  set;
      }
    public void calcTraderAgreedOpt2()
    {
      system.debug(mswatch.Condition_for_R2__c+'TraderAFlag123:'+mswatch.Send_alerts_via_R2__c+'ss'+mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c);
    if(mswatch.Add_Trador__c == true &&  mswatch.Condition_for_R2__c != null && (mswatch.Condition_for_R2__c.indexOf('LN_FIX_BXS') != -1 || mswatch.Condition_for_R2__c.indexOf('LN_FIX_SWAPS') != -1  || 
      mswatch.Condition_for_R2__c.indexOf('LN_PASSPORT') != -1) 
      && 
      mswatch.Send_alerts_via_R2__c != null && (mswatch.Send_alerts_via_R2__c.indexOf('Bloomberg IM') != -1  || mswatch.Send_alerts_via_R2__c.indexOf('CFM User only') != -1 || 
      mswatch.Send_alerts_via_R2__c.indexOf('Email') != -1 || mswatch.Send_alerts_via_R2__c.indexOf('IM_AOL') != -1 ||mswatch.Send_alerts_via_R2__c.indexOf('Passport') != -1  ) 
       &&
      (LNAlertEmailR2() ||  LNAlertPPR2() || LNAlertAOL_IMR2() ||
      LNAlertBBGR2() || LNAlertCRMUserR2()  )   
      )
      {
          TraderAFlag2 = 1;
      }
      else
      {
         TraderAFlag2 = 0;
         
      }
          
      system.debug('trader2::'+TraderAFlag2);
      
    }
      public boolean LNAlertEmailR2()
    {
      if(mswatch.Enable_LN_alerts_for_Email_for_R2__c != null && (mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('CDOrderAck25%ADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('CDOrderCxl25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('CDOrderFill25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInAck (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInAck (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInAckNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInCancelNoADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInCxl (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInCxl (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInFill ((SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInFill (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInFillNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInReplaceNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R2__c.indexOf('OptInRpl (SymOnly)') != -1 
)  
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertPPR2()
    {
      if( mswatch.Enable_LN_alerts_for_PP_for_R2__c != null && (
        mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R2__c.indexOf('OptInRpl (SymOnly)') != -1 
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertBBGR2()
    {
      if(  mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c != null && (
      mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c.indexOf('OptInRpl (SymOnly)') != -1

        )
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertAOL_IMR2()
    {
      if(  mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c != null && (
      mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c.indexOf('OptInRpl (SymOnly)')  != -1
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertCRMUserR2()
    {
      if(mswatch.Enable_LN_alert_for_CFM_Users_R2__c != null && (
      mswatch.Enable_LN_alert_for_CFM_Users_R2__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R2__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R2__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R2__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R2__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R2__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R2__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1  
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public Integer TraderAFlag3 {   get;  set;     }
    public void calcTraderAgreedOpt3()
    {
      system.debug(mswatch.Condition_for_R3__c+'TraderAFlag123:'+mswatch.Send_alerts_via_R3__c+'ss'+mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c);
    if(mswatch.Add_Trador__c == true && mswatch.Add_Trador_3__c == true &&  mswatch.Condition_for_R3__c != null && (mswatch.Condition_for_R3__c.indexOf('LN_FIX_BXS') != -1 || mswatch.Condition_for_R3__c.indexOf('LN_FIX_SWAPS') != -1  || 
      mswatch.Condition_for_R3__c.indexOf('LN_PASSPORT') != -1) 
      && 
      mswatch.Send_alerts_via_R3__c != null && (mswatch.Send_alerts_via_R3__c.indexOf('Bloomberg IM') != -1  || mswatch.Send_alerts_via_R3__c.indexOf('CFM User only') != -1 || 
      mswatch.Send_alerts_via_R3__c.indexOf('Email') != -1 || mswatch.Send_alerts_via_R3__c.indexOf('IM_AOL') != -1 ||mswatch.Send_alerts_via_R3__c.indexOf('Passport') != -1  ) 
       &&
      (LNAlertEmailR3() ||  LNAlertPPR3() || LNAlertAOL_IMR3() ||
      LNAlertBBGR3() || LNAlertCRMUserR3()  )   
      )
      {
          TraderAFlag3 = 1;
      }
      else
      {
         TraderAFlag3 = 0;
         
      }
           
    }
      public boolean LNAlertEmailR3()
    {
      if(mswatch.Enable_LN_alerts_for_Email_for_R3__c != null && (mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('CDOrderAck25%ADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('CDOrderCxl25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('CDOrderFill25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInAck (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInAck (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInAckNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInCancelNoADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInCxl (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInCxl (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInFill ((SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInFill (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInFillNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInReplaceNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R3__c.indexOf('OptInRpl (SymOnly)') != -1 
)  
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertPPR3()
    {
      if( mswatch.Enable_LN_alerts_for_PP_for_R3__c != null && (
        mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R3__c.indexOf('OptInRpl (SymOnly)') != -1 
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertBBGR3()
    {
      if(  mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c != null && (
      mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c.indexOf('OptInRpl (SymOnly)') != -1

        )
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertAOL_IMR3()
    {
      if(  mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c != null && (
      mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c.indexOf('OptInRpl (SymOnly)')  != -1
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertCRMUserR3()
    {
      if(mswatch.Enable_LN_alert_for_CFM_Users_R3__c != null && (
      mswatch.Enable_LN_alert_for_CFM_Users_R3__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R3__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R3__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R3__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R3__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R3__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R3__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1  
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public Integer TraderAFlag4 {   get;  set;     }
    public void calcTraderAgreedOpt4()
    {
      system.debug(mswatch.Condition_for_R4__c+'TraderAFlag123:'+mswatch.Send_alerts_via_R4__c+'ss'+mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c);
    if(mswatch.Add_Trador__c == true && mswatch.Add_Trador_3__c && mswatch.Add_Trador_4__c && mswatch.Condition_for_R4__c != null && (mswatch.Condition_for_R4__c.indexOf('LN_FIX_BXS') != -1 || mswatch.Condition_for_R4__c.indexOf('LN_FIX_SWAPS') != -1  || 
      mswatch.Condition_for_R4__c.indexOf('LN_PASSPORT') != -1) 
      && 
      mswatch.Send_alerts_via_R4__c != null && (mswatch.Send_alerts_via_R4__c.indexOf('Bloomberg IM') != -1  || mswatch.Send_alerts_via_R4__c.indexOf('CFM User only') != -1 || 
      mswatch.Send_alerts_via_R4__c.indexOf('Email') != -1 || mswatch.Send_alerts_via_R4__c.indexOf('IM_AOL') != -1 ||mswatch.Send_alerts_via_R4__c.indexOf('Passport') != -1  ) 
       &&
      (LNAlertEmailR4() ||  LNAlertPPR4() || LNAlertAOL_IMR4() ||
      LNAlertBBGR4() || LNAlertCRMUserR4()  )   
      )
      {
          TraderAFlag4 = 1;
      }
      else
      {
         TraderAFlag4 = 0;
         
      }
          
      
    }
      public boolean LNAlertEmailR4()
    {
      if(mswatch.Enable_LN_alerts_for_Email_for_R4__c != null && (mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('CDOrderAck25%ADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('CDOrderCxl25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('CDOrderFill25%ADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInAck (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInAck (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInAckNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInCancelNoADV') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInCxl (SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInCxl (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInFill ((SideSym)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')!= -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInFill (SymOnly)') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInFillNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)') != -1 || 
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInReplaceNoADV') != -1 ||
mswatch.Enable_LN_alerts_for_Email_for_R4__c.indexOf('OptInRpl (SymOnly)') != -1 
)  
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertPPR4()
    {
      if( mswatch.Enable_LN_alerts_for_PP_for_R4__c != null && (
        mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_PP_for_R4__c.indexOf('OptInRpl (SymOnly)') != -1 
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertBBGR4()
    {
      if(  mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c != null && (
      mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c.indexOf('OptInRpl (SymOnly)') != -1

        )
       )
      {
        return true;
      }
      else
      return false;
    }
    public boolean LNAlertAOL_IMR4()
    {
      if(  mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c != null && (
      mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInAck (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInAck (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInAckNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInCancelNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInCxl (SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInCxl (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInFill ((SideSym)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInFill (SymOnly)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInFillNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInReplaceNoADV')  != -1 || 
mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c.indexOf('OptInRpl (SymOnly)')  != -1
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    public boolean LNAlertCRMUserR4()
    {
      if(mswatch.Enable_LN_alert_for_CFM_Users_R4__c != null && (
      mswatch.Enable_LN_alert_for_CFM_Users_R4__c.indexOf('CDOrderAck25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R4__c.indexOf('CDOrderCxl25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R4__c.indexOf('CDOrderFill25%ADV')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R4__c.indexOf('Opt-In-Ack(CDOrderAck2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R4__c.indexOf('Opt-In-Cxl(CDOrderCxl2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R4__c.indexOf('Opt-In-Fill(CDOrderFill2%ADV)')  != -1 || 
mswatch.Enable_LN_alert_for_CFM_Users_R4__c.indexOf('Opt-In-Replaced(CDOrderReplaced2%ADV)')  != -1  
        )
       )
      {
        return true;
      }
      else
      return false;
    }
    
    //singhrak, REQ3604048, 3Apr, 2015, end
    
     public Integer getCompSubIdFlag1()
    {
            return this.CompSubIdFlag1;
    }
    
    public Integer getEmailAddFlag1()
    {
            return this.EmailAddFlag1;
    }
    
    public Integer getIMAOLAddFlag1()
    {
            return this.IMAOLAddFlag1;
    }
    
    public Integer getPassLogFlag1()
    {
            return this.PassLogFlag1;
    }
    
    public Integer getBBIMAddFlag1()
    {
            return this.BBIMAddFlag1;
    }
    
    public Integer getCFMUserFlag1()
    {
            return this.CFMUserFlag1;
    }
    
    public Integer getNYAlertEmailFlag1()
    {
            return this.NYAlertEmailFlag1;
    }
    
    public Integer getNYAlertAOLIMFlag1()
    {
            return this.NYAlertAOLIMFlag1;
    }
    
    public Integer getNYAlertPPFlag1()
    {
            return this.NYAlertPPFlag1;
    }
    
    public Integer getNYAlertBBFlag1()
    {
            return this.NYAlertBBFlag1;
    }
           
    public Integer getNYAlertIntListFlag1()
    {
            return this.NYAlertIntListFlag1;
    }
    
    public Integer getLNAlertEmailFlag1()
    {
            return this.LNAlertEmailFlag1;
    }
    
    public Integer getLNAlertAOLIMFlag1()
    {
            return this.LNAlertAOLIMFlag1;
    }
    
    public Integer getLNAlertPPFlag1()
    {
            return this.LNAlertPPFlag1;
    }
    
    public Integer getLNAlertBBFlag1()
    {
            return this.LNAlertBBFlag1;
    }
    
    public Integer getLNAlertIntListFlag1()
    {
            return this.LNAlertIntListFlag1;
    }
    
    public Integer getAsiaAlertEmailFlag1()
    {
            return this.AsiaAlertEmailFlag1;
    }
    
    public Integer getAsiaAlertPPFlag1()
    {
            return this.AsiaAlertPPFlag1;
    }
    
    public Integer getAsiaAlertBBFlag1()
    {
            return this.AsiaAlertBBFlag1;
    }
    
    public Integer getAsiaAlertIntListFlag1()
    {
            return this.AsiaAlertIntListFlag1;
    }
     //REQ4954035, vinay, 26NOV , 2015,
    public Integer getAsiaAlertIListFlag1() 
    {
            return this.AsiaAlertIListFlag1;
    }
    public Integer getAsiaAlertEmail2Flag1()
    {
            return this.AsiaAlertEmail2Flag1;
    }
    public Integer getAsiaAlertPP2Flag1()
    {
            return this.AsiaAlertPP2Flag1;
    }
     public Integer getAsiaAlertCFM2UserFlag1()
    {
            return this.AsiaAlertCFM2UserFlag1;
    }
    public Integer getAsiaAlertBB2Flag1()
    {
            return this.AsiaAlertBB2Flag1;  
    }   //REQ4954035, vinay, 26NOV , 2015,
    
    public Integer getSAAlertEmailFlag1()
    {
            return this.SAAlertEmailFlag1;
    }
    
    public Integer getSAAlertAOLIMFlag1()
    {
            return this.SAAlertAOLIMFlag1;
    }
    
    public Integer getSAAlertPPFlag1()
    {
            return this.SAAlertPPFlag1;
    }
    
    public Integer getSAAlertBBFlag1()
    {
            return this.SAAlertBBFlag1;
    }

    public Integer getSAAlertCFMUserFlag1()
    {
            return this.SAAlertCFMUserFlag1;
    }
    
    public Integer getNYAlertCFMUserFlag1()
    {
            return this.NYAlertCFMUserFlag1;
    }

    public Integer getLNAlertCFMUserFlag1()
    {
            return this.LNAlertCFMUserFlag1;
    }

    public Integer getAsiaAlertCFMUserFlag1()
    {
            return this.AsiaAlertCFMUserFlag1;
    }
    
    public Integer getTrader2DispFlag()
    {
            return this.Trader2DispFlag;
    }
    
    // Trader-2
    
    public Integer getCompSubIdFlag2()
    {
            return this.CompSubIdFlag2;
    }
    
    public Integer getEmailAddFlag2()
    {
            return this.EmailAddFlag2;
    }
    
    public Integer getIMAOLAddFlag2()
    {
            return this.IMAOLAddFlag2;
    }
    
    public Integer getPassLogFlag2()
    {
            return this.PassLogFlag2;
    }
    
    public Integer getBBIMAddFlag2()
    {
            return this.BBIMAddFlag2;
    }
    
    public Integer getCFMUserFlag2()
    {
            return this.CFMUserFlag2;
    }
    
    public Integer getNYAlertEmailFlag2()
    {
            return this.NYAlertEmailFlag2;
    }
    
    public Integer getNYAlertAOLIMFlag2()
    {
            return this.NYAlertAOLIMFlag2;
    }
    
    public Integer getNYAlertPPFlag2()
    {
            return this.NYAlertPPFlag2;
    }
    
    public Integer getNYAlertBBFlag2()
    {
            return this.NYAlertBBFlag2;
    }
    
    
    public Integer getNYAlertIntListFlag2()
    {
            return this.NYAlertIntListFlag2;
    }
    
     public Integer getLNAlertEmailFlag2()
    {
            return this.LNAlertEmailFlag2;
    }
    
    public Integer getLNAlertAOLIMFlag2()
    {
            return this.LNAlertAOLIMFlag2;
    }
    
    public Integer getLNAlertPPFlag2()
    {
            return this.LNAlertPPFlag2;
    }
    
    public Integer getLNAlertBBFlag2()
    {
            return this.LNAlertBBFlag2;
    }
    
    public Integer getLNAlertIntListFlag2()
    {
            return this.LNAlertIntListFlag2;
    }
    
    public Integer getAsiaAlertEmailFlag2()
    {
            return this.AsiaAlertEmailFlag2;
    }
    
    public Integer getAsiaAlertPPFlag2()
    {
            return this.AsiaAlertPPFlag2;
    }
    
    public Integer getAsiaAlertBBFlag2()
    {
            return this.AsiaAlertBBFlag2;
    }
    
    public Integer getAsiaAlertIntListFlag2()
    {
            return this.AsiaAlertIntListFlag2;
    }
    //REQ4954035, vinay, 26NOV , 2015,
    public Integer getAsiaAlertIListFlag2() 
    {
            return this.AsiaAlertIListFlag2;
    }
    public Integer getAsiaAlertEmail2Flag2()
    {
            return this.AsiaAlertEmail2Flag2;
    }
    public Integer getAsiaAlertPP2Flag2()
    {
            return this.AsiaAlertPP2Flag2;
    }
      public Integer getAsiaAlertCFM2UserFlag2()
    {
            return this.AsiaAlertCFM2UserFlag2;
    }
    public Integer getAsiaAlertBB2Flag2()
    {
            return this.AsiaAlertBB2Flag2; 
    }    //REQ4954035, vinay, 26NOV , 2015,
    
    public Integer getTrader3DispFlag()
    {
            return this.Trader3DispFlag;
    }
    
    public Integer getSAAlertEmailFlag2()
    {
            return this.SAAlertEmailFlag2;
    }
    
    public Integer getSAAlertAOLIMFlag2()
    {
            return this.SAAlertAOLIMFlag2;
    }
    
    public Integer getSAAlertPPFlag2()
    {
            return this.SAAlertPPFlag2;
    }
    
    public Integer getSAAlertBBFlag2()
    {
            return this.SAAlertBBFlag2;
    }

    public Integer getSAAlertCFMUserFlag2()
    {
            return this.SAAlertCFMUserFlag2;
    }
    
    public Integer getNYAlertCFMUserFlag2()
    {
            return this.NYAlertCFMUserFlag2;
    }

    public Integer getLNAlertCFMUserFlag2()
    {
            return this.LNAlertCFMUserFlag2;
    }

    public Integer getAsiaAlertCFMUserFlag2()
    {
            return this.AsiaAlertCFMUserFlag2;
    }
    
    //Trader-3
    
    public Integer getCompSubIdFlag3()
    {
            return this.CompSubIdFlag3;
    }
    
    public Integer getEmailAddFlag3()
    {
            return this.EmailAddFlag3;
    }
    
    public Integer getIMAOLAddFlag3()
    {
            return this.IMAOLAddFlag3;
    }
    
    public Integer getPassLogFlag3()
    {
            return this.PassLogFlag3;
    }
    
    public Integer getBBIMAddFlag3()
    {
            return this.BBIMAddFlag3;
    }
    
    public Integer getCFMUserFlag3()
    {
            return this.CFMUserFlag3;
    }
    
    public Integer getNYAlertEmailFlag3()
    {
            return this.NYAlertEmailFlag3;
    }
    
    public Integer getNYAlertAOLIMFlag3()
    {
            return this.NYAlertAOLIMFlag3;
    }
    
    public Integer getNYAlertPPFlag3()
    {
            return this.NYAlertPPFlag3;
    }
    
    public Integer getNYAlertBBFlag3()
    {
            return this.NYAlertBBFlag3;
    }
        
    
    public Integer getNYAlertIntListFlag3()
    {
            return this.NYAlertIntListFlag3;
    }
    
     public Integer getLNAlertEmailFlag3()
    {
            return this.LNAlertEmailFlag3;
    }
    
    public Integer getLNAlertAOLIMFlag3()
    {
            return this.LNAlertAOLIMFlag3;
    }
    
    public Integer getLNAlertPPFlag3()
    {
            return this.LNAlertPPFlag3;
    }
    
    public Integer getLNAlertBBFlag3()
    {
            return this.LNAlertBBFlag3;
    }
    
    public Integer getLNAlertIntListFlag3()
    {
            return this.LNAlertIntListFlag3;
    }
    
    public Integer getAsiaAlertEmailFlag3()
    {
            return this.AsiaAlertEmailFlag3;
    }
    
    public Integer getAsiaAlertPPFlag3()
    {
            return this.AsiaAlertPPFlag3;
    }
    
    public Integer getAsiaAlertBBFlag3()
    {
            return this.AsiaAlertBBFlag3;
    }
    
    public Integer getAsiaAlertIntListFlag3()
    {
            return this.AsiaAlertIntListFlag3;
    }
    //REQ4954035, vinay, 26NOV , 2015,
    public Integer getAsiaAlertIListFlag3()
    {
            return this.AsiaAlertIListFlag3;
    }
    public Integer getAsiaAlertEmail2Flag3()
    {
            return this.AsiaAlertEmail2Flag3;
    }
    public Integer getAsiaAlertPP2Flag3()
    {
            return this.AsiaAlertPP2Flag3;
    }
      public Integer getAsiaAlertCFM2UserFlag3()
    {
            return this.AsiaAlertCFM2UserFlag3;
    }
    public Integer getAsiaAlertBB2Flag3()
    {
            return this.AsiaAlertBB2Flag3;
    }   //REQ4954035, vinay, 26NOV , 2015,
    
    
    public Integer getTrader4DispFlag()
    {
            return this.Trader4DispFlag;
    } 
    
    public Integer getSAAlertEmailFlag3()
    {
            return this.SAAlertEmailFlag3;
    }
    
    public Integer getSAAlertAOLIMFlag3()
    {
            return this.SAAlertAOLIMFlag3;
    }
    
    public Integer getSAAlertPPFlag3()
    {
            return this.SAAlertPPFlag3;
    }
    
    public Integer getSAAlertBBFlag3()
    {
            return this.SAAlertBBFlag3;
    }

    public Integer getSAAlertCFMUserFlag3()
    {
            return this.SAAlertCFMUserFlag3;
    }
    
    public Integer getNYAlertCFMUserFlag3()
    {
            return this.NYAlertCFMUserFlag3;
    }

    public Integer getLNAlertCFMUserFlag3()
    {
            return this.LNAlertCFMUserFlag3;
    }

    public Integer getAsiaAlertCFMUserFlag3()
    {
            return this.AsiaAlertCFMUserFlag3;
    }
    
    // Trader - 4
    
    public Integer getCompSubIdFlag4()
    {
            return this.CompSubIdFlag4;
    }
    
    public Integer getEmailAddFlag4()
    {
            return this.EmailAddFlag4;
    }
    
    public Integer getIMAOLAddFlag4()
    {
            return this.IMAOLAddFlag4;
    }
    
    public Integer getPassLogFlag4()
    {
            return this.PassLogFlag4;
    }
    
    public Integer getBBIMAddFlag4()
    {
            return this.BBIMAddFlag4;
    }
    
    public Integer getCFMUserFlag4()
    {
            return this.CFMUserFlag4;
    }
    
    public Integer getNYAlertEmailFlag4()
    {
            return this.NYAlertEmailFlag4;
    }
    
    public Integer getNYAlertAOLIMFlag4()
    {
            return this.NYAlertAOLIMFlag4;
    }
    
    public Integer getNYAlertPPFlag4()
    {
            return this.NYAlertPPFlag4;
    }
    
    public Integer getNYAlertBBFlag4()
    {
            return this.NYAlertBBFlag4;
    }
        
    public Integer getNYAlertIntListFlag4()
    {
            return this.NYAlertIntListFlag4;
    }
    
     public Integer getLNAlertEmailFlag4()
    {
            return this.LNAlertEmailFlag4;
    }
    
    public Integer getLNAlertAOLIMFlag4()
    {
            return this.LNAlertAOLIMFlag4;
    }
    
    public Integer getLNAlertPPFlag4()
    {
            return this.LNAlertPPFlag4;
    }
    
    public Integer getLNAlertBBFlag4()
    {
            return this.LNAlertBBFlag4;
    }
    
    public Integer getLNAlertIntListFlag4()
    {
            return this.LNAlertIntListFlag4;
    }
    
    public Integer getAsiaAlertEmailFlag4()
    {
            return this.AsiaAlertEmailFlag4;
    }
    
    public Integer getAsiaAlertPPFlag4()
    {
            return this.AsiaAlertPPFlag4;
    }
    
    public Integer getAsiaAlertBBFlag4()
    {
            return this.AsiaAlertBBFlag4;
    }
    
    public Integer getAsiaAlertIntListFlag4()
    {
            return this.AsiaAlertIntListFlag4;
    }
    //REQ4954035, vinay, 26NOV , 2015,
    public Integer getAsiaAlertIListFlag4()
    {
            return this.AsiaAlertIListFlag4;
    }
    public Integer getAsiaAlertEmail2Flag4()
    {
            return this.AsiaAlertEmail2Flag4;
    }
    public Integer getAsiaAlertPP2Flag4()
    {
            return this.AsiaAlertPP2Flag4;
    }
      public Integer getAsiaAlertCFM2UserFlag4()
    {
            return this.AsiaAlertCFM2UserFlag4;
    }
    public Integer getAsiaAlertBB2Flag4()
    {
            return this.AsiaAlertBB2Flag4; 
    }   
    //REQ4954035, vinay, 26NOV , 2015,
    
    public Integer getSAAlertEmailFlag4()
    {
            return this.SAAlertEmailFlag4;
    }
    
    public Integer getSAAlertAOLIMFlag4()
    {
            return this.SAAlertAOLIMFlag4;
    }
    
    public Integer getSAAlertPPFlag4()
    {
            return this.SAAlertPPFlag4;
    }
    
    public Integer getSAAlertBBFlag4()
    {
            return this.SAAlertBBFlag4;
    }

    public Integer getSAAlertCFMUserFlag4()
    {
            return this.SAAlertCFMUserFlag4;
    }
    
    public Integer getNYAlertCFMUserFlag4()
    {
            return this.NYAlertCFMUserFlag4;
    }

    public Integer getLNAlertCFMUserFlag4()
    {
            return this.LNAlertCFMUserFlag4;
    }

    public Integer getAsiaAlertCFMUserFlag4()
    {
            return this.AsiaAlertCFMUserFlag4;
    }
    
    public String getPageTitle()
    {
          return this.PageTitle;
    }
    
    public MS_Watch__c editRequest { get; set; }
    
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }
    
    public MS_Watch__c getRequests()
    {
        return [Select Requested_By__c from MS_Watch__c where Id=:mswatch.Id];
    }
    
    public pagereference save(){
    
        PageReference pageRef = ApexPages.currentPage();
        String flowType = pageRef.getParameters().get('flow');
        
        if(mswatch.Priority__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Priority'));
                return null;
            }
       if(mswatch.Add_Trador__c == true){
        
            if(mswatch.MSET_Contact2__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Trader Name T2 for R2'));
                return null;
            }
            if(mswatch.Time_Zone_for_R2__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Time Zone for R2'));
                return null;
            }
            if(mswatch.Condition_for_R2__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Conditions for R2'));
                return null;
            }
            if(mswatch.Send_alerts_via_R2__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Alert Value via for R2'));
                return null;
            }
        }
        
        if(mswatch.Add_Trador_3__c == true){
           if(mswatch.MSET_Contact3__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Trader Name T3 for R3'));
                return null;
            }
            if(mswatch.Time_Zone_for_R3__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Time Zone for R3'));
                return null;
            }
            if(mswatch.Condition_for_R3__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Conditions for R3'));
                return null;
            }
            if(mswatch.Send_alerts_via_R3__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Alert Value via for R3'));
                return null;
            }
        }
        
        if(mswatch.Add_Trador_4__c == true){
            if(mswatch.MSET_Contact4__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Trader Name T4 for R4'));
                return null;
            }
            if(mswatch.Time_Zone_for_R4__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Time Zone for R4'));
                return null;
            }
            if(mswatch.Condition_for_R4__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Conditions for R4'));
                return null;
            }
            if(mswatch.Send_alerts_via_R4__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Specify the Alert Value via for R4'));
                return null;
            }
        }
        
        if(flowType != null && flowType.equals('clone')) {
            return this.cloneForm();
        }   
    
     try {
            upsert(mswatch);
            } catch(System.DMLException e) {
           ApexPages.addMessages(e);
          return null;
       }  
       return (new ApexPages.StandardController(mswatch)).view();
       
    
    }
    
    public PageReference editRequestedBy() {
        String editid = getParam('editid');
        editRequest = [SELECT Requested_By__c FROM MS_Watch__c WHERE Id=:editid];
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
     
    public PageReference refreshPage()
    {
       calcConditionValue();
       calcSendAlertValue();
       calcNextTraderValue();
       additionalMapping();
       return null;
    }   
      public void additionalMapping(){ //REQ4954035, vinay, 25NOV , 2015,
      
      }
      
    public void calcConditionValue(){
                    
        if(mswatch.Condition_for_R1__c != null)
        {
           if(mswatch.Condition_for_R1__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_FIX_SWAPS')!= -1
               || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_SWAP')!= -1) 
             CompSubIdFlag1 = 1;
           else
             CompSubIdFlag1 = 0; 
                       
           if( mswatch.Condition_for_R1__c.indexOF('Interest List (US)')!= -1)
              NYAlertIntListFlag1 = 1;
           else
              NYAlertIntListFlag1 = 0; 
              
           if( mswatch.Condition_for_R1__c.indexOF('Interest List (LN)')!= -1)
              LNAlertIntListFlag1 = 1;
           else
              LNAlertIntListFlag1 = 0; 
           
        /*   if( mswatch.Condition_for_R1__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag1 = 1;
           else
              AsiaAlertIntListFlag1 = 0;             */
              //REQ4954035, vinay, 25NOV , 2015,
            if((mswatch.Trade_Region__c!= null)&& (mswatch.Trade_Region__c!= null)&&(!mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R1__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag1 = 1;
           else
              AsiaAlertIntListFlag1 = 0;     
           
           if((mswatch.Trade_Region__c!= null)&&(mswatch.Trade_Region__c!= null)&&(mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R1__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIListFlag1 = 1;
           else
              AsiaAlertIListFlag1 = 0;   
        }//REQ4954035, vinay, 25NOV , 2015,
        
        else
        {
          CompSubIdFlag1 = 0; 
          NYAlertIntListFlag1 = 0;
          LNAlertIntListFlag1 = 0;
          AsiaAlertIntListFlag1 = 0;
          AsiaAlertIListFlag1 = 0;
        }  
        
//singhrak, REQ3604048, 3Apr, 2015, start
           calcTraderAgreedOpt();         
 //singhrak, REQ3604048, 3Apr, 2015, end
         
        if(mswatch.Condition_for_R2__c != null)
        {
           if(mswatch.Condition_for_R2__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_FIX_SWAPS')!= -1
               || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_SWAP')!= -1) 
             CompSubIdFlag2 = 1;
           else
             CompSubIdFlag2 = 0; 
 
           if( mswatch.Condition_for_R2__c.indexOF('Interest List (US)')!= -1)
              NYAlertIntListFlag2 = 1;
           else
              NYAlertIntListFlag2 = 0;
              
           if( mswatch.Condition_for_R2__c.indexOF('Interest List (LN)')!= -1)
              LNAlertIntListFlag2 = 1;
           else
              LNAlertIntListFlag2 = 0; 
           
           //REQ4954035, vinay, 25NOV , 2015,
           if( (mswatch.Trade_Region__c!= null)&&(!mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R2__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag2 = 1;
           else
              AsiaAlertIntListFlag2 = 0;     
           
           if((mswatch.Trade_Region__c!= null)&&(mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R2__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIListFlag2 = 1;
           else
              AsiaAlertIListFlag2 = 0; //REQ4954035, vinay, 25NOV , 2015, 
       /*    if( mswatch.Condition_for_R2__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag2 = 1;
           else
              AsiaAlertIntListFlag2 = 0;   */
        }
        else
        {
          CompSubIdFlag2 = 0;
          NYAlertIntListFlag2 = 0;
          LNAlertIntListFlag2 = 0;
          AsiaAlertIntListFlag2 = 0;
          AsiaAlertIListFlag2 = 0; 
        }  
        
//      singhrak, REQ3604048, 3Apr, 2015, start
           calcTraderAgreedOpt2();         
 //singhrak, REQ3604048, 3Apr, 2015, end
        
        
        if(mswatch.Condition_for_R3__c != null)
        {
           if(mswatch.Condition_for_R3__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_FIX_SWAPS')!= -1
               || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_SWAP')!= -1) 
             CompSubIdFlag3 = 1;
           else
             CompSubIdFlag3 = 0;
             
          if( mswatch.Condition_for_R3__c.indexOF('Interest List (US)')!= -1)
              NYAlertIntListFlag3 = 1;
          else
              NYAlertIntListFlag3 = 0;
              
           if( mswatch.Condition_for_R3__c.indexOF('Interest List (LN)')!= -1)
              LNAlertIntListFlag3 = 1;
           else
              LNAlertIntListFlag3 = 0; 
              
         /* if( mswatch.Condition_for_R3__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag3 = 1;
          else
              AsiaAlertIntListFlag3 = 0;            */
                        //REQ4954035, vinay, 25NOV , 2015,
            if( (mswatch.Trade_Region__c!= null)&&(!mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R3__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag3 = 1;
           else
              AsiaAlertIntListFlag3 = 0;     
           
           if((mswatch.Trade_Region__c!= null)&&(mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R3__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIListFlag3 = 1;
           else
              AsiaAlertIListFlag3 = 0;      //REQ4954035, vinay, 25NOV , 2015,     
        }
        else
        {
          CompSubIdFlag3 = 0;
          NYAlertIntListFlag3 = 0;
          LNAlertIntListFlag3 = 0; 
          AsiaAlertIntListFlag3 = 0;
          AsiaAlertIListFlag3 = 0; 
        }
        
                //singhrak, REQ3604048, 3Apr, 2015, start
        calcTraderAgreedOpt3();
        //singhrak, REQ3604048, 3Apr, 2015, end
        
        if(mswatch.Condition_for_R4__c != null)
        {
           if(mswatch.Condition_for_R4__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_FIX_SWAPS')!= -1
               || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_SWAP')!= -1) 
             CompSubIdFlag4 = 1;
           else
             CompSubIdFlag4 = 0;
                       
           if( mswatch.Condition_for_R4__c.indexOF('Interest List (US)')!= -1)
              NYAlertIntListFlag4 = 1;
           else
              NYAlertIntListFlag4 = 0; 
              
           if( mswatch.Condition_for_R4__c.indexOF('Interest List (LN)')!= -1)
              LNAlertIntListFlag4 = 1;
           else
              LNAlertIntListFlag4 = 0; 
           
          /* if( mswatch.Condition_for_R4__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag4 = 1;
           else
              AsiaAlertIntListFlag4 = 0;           */
             //REQ4954035, vinay, 25NOV , 2015,
            if( (mswatch.Trade_Region__c!= null)&&(!mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R4__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIntListFlag4 = 1;
           else
              AsiaAlertIntListFlag4 = 0;     
           
           if((mswatch.Trade_Region__c!= null)&&(mswatch.Trade_Region__c.contains('Pan-Asia')) && mswatch.Condition_for_R4__c.indexOF('Interest List (ASIA)')!= -1)
              AsiaAlertIListFlag4 = 1;
           else
              AsiaAlertIListFlag4 = 0;            //REQ4954035, vinay, 25NOV , 2015,   
        }
        else
        {
          CompSubIdFlag4 = 0;
          NYAlertIntListFlag4 = 0;
          LNAlertIntListFlag4 = 0;
          AsiaAlertIntListFlag4 = 0;
          AsiaAlertIListFlag4 = 0;
        }  

        //singhrak, REQ3604048, 3Apr, 2015, start
        calcTraderAgreedOpt4();
        //singhrak, REQ3604048, 3Apr, 2015, end
        
        calcSendAlertValue();   
       
    }
    
    public void calcSendAlertValue(){
    
        if(mswatch.Send_alerts_via_R1__c != null)
        {
            if(mswatch.Send_alerts_via_R1__c.indexOF('Bloomberg IM')!= -1)
                BBIMAddFlag1 = 1;
            else
                BBIMAddFlag1 = 0;
                
            if(mswatch.Send_alerts_via_R1__c.indexOF('Email')!= -1)
                EmailAddFlag1 = 1;
            else
                EmailAddFlag1 = 0;
                
            if(mswatch.Send_alerts_via_R1__c.indexOF('IM_AOL')!= -1)
                IMAOLAddFlag1 = 1;
            else
                IMAOLAddFlag1 = 0;
                
            if(mswatch.Send_alerts_via_R1__c.indexOF('Passport')!= -1)
                PassLogFlag1 = 1;
            else
                PassLogFlag1 = 0;
            
            if(mswatch.Send_alerts_via_R1__c.indexOF('CFM User only')!= -1)
                CFMUserFlag1 = 1;
            else
                CFMUserFlag1 = 0;    
                
        }         
        else
        {
            EmailAddFlag1 = 0;
            IMAOLAddFlag1 = 0;
            PassLogFlag1 = 0;
            BBIMAddFlag1 = 0;
            CFMUserFlag1 = 0;            
        }
        if(mswatch.Condition_for_R1__c != null && mswatch.Send_alerts_via_R1__c != null)
        {

          if( EmailAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertEmailFlag1 = 1;
          else
              NYAlertEmailFlag1 = 0;
              
          if( IMAOLAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertAOLIMFlag1 = 1;
          else
              NYAlertAOLIMFlag1 = 0;                
              
          if( PassLogFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertPPFlag1 = 1;
          else
              NYAlertPPFlag1 = 0;                
              
          if( BBIMAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertBBFlag1 = 1;
          else
              NYAlertBBFlag1 = 0;                
          
          if( CFMUserFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertCFMUserFlag1 = 1;
          else
              NYAlertCFMUserFlag1 = 0;
                 
          if( EmailAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertEmailFlag1 = 1;
          else
              //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertEmailFlag1 = 0;
              mswatch.Enable_LN_alerts_for_Email_for_R1__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
          if( IMAOLAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertAOLIMFlag1 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertAOLIMFlag1 = 0;
              mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
          if( PassLogFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertPPFlag1 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertPPFlag1 = 0;
              mswatch.Enable_LN_alerts_for_PP_for_R1__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

              
          if( BBIMAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertBBFlag1 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertBBFlag1 = 0;
              mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end  
  
          
          if( CFMUserFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R1__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertCFMUserFlag1 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
                LNAlertCFMUserFlag1 = 0;
                mswatch.Enable_LN_alert_for_CFM_Users_R1__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
         /* if( EmailAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag1 = 1;
          else
              AsiaAlertEmailFlag1 = 0;
          
          if( PassLogFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag1 = 1;
          else
              AsiaAlertPPFlag1 = 0;
          
          if( BBIMAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag1 = 1;
          else
              AsiaAlertBBFlag1 = 0; 
          
          if( CFMUserFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag1 = 1;
          else
              AsiaAlertCFMUserFlag1 = 0;
          */
           // REQ4954035, vinay, 25NOV , 2015,
          if((mswatch.Trade_Region__c!= null)&&(!mswatch.Trade_Region__c.contains('Pan-Asia')) &&  EmailAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag1 = 1;
          else
              AsiaAlertEmailFlag1 = 0;
              
          if((mswatch.Trade_Region__c!= null)&& ( !mswatch.Trade_Region__c.contains('Pan-Asia')) &&  PassLogFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag1 = 1;
          else
              AsiaAlertPPFlag1 = 0;
          
          if((mswatch.Trade_Region__c!= null)&& ( !mswatch.Trade_Region__c.contains('Pan-Asia')) &&  BBIMAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag1 = 1;
          else
              AsiaAlertBBFlag1 = 0; 
          
          if((mswatch.Trade_Region__c!= null)&& ( !mswatch.Trade_Region__c.contains('Pan-Asia')) &&  CFMUserFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag1 = 1;
          else
              AsiaAlertCFMUserFlag1 = 0;
              
          if( (mswatch.Trade_Region__c!= null)&& (mswatch.Trade_Region__c.contains('Pan-Asia')) &&  EmailAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmail2Flag1 = 1;
          else
              AsiaAlertEmail2Flag1 = 0;      
          
           if( (mswatch.Trade_Region__c!= null)&&( mswatch.Trade_Region__c.contains('Pan-Asia')) &&  PassLogFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPP2Flag1 = 1;
          else
              AsiaAlertPP2Flag1 = 0;     
          
          if( (mswatch.Trade_Region__c!= null)&&( mswatch.Trade_Region__c.contains('Pan-Asia')) &&  BBIMAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBB2Flag1 = 1;
          else
              AsiaAlertBB2Flag1 = 0;     
          
          if((mswatch.Trade_Region__c!= null)&&  (mswatch.Trade_Region__c.contains('Pan-Asia') )&&  CFMUserFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R1__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFM2UserFlag1 = 1;
          else
              AsiaAlertCFM2UserFlag1 = 0;     
                 //REQ4954035, vinay, 26NOV , 2015,
         
         
         
         
         
          if( EmailAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertEmailFlag1 = 1;
          else
              SAAlertEmailFlag1 = 0;
              
          if( IMAOLAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertAOLIMFlag1 = 1;
          else
              SAAlertAOLIMFlag1 = 0;                
              
          if( PassLogFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertPPFlag1 = 1;
          else
              SAAlertPPFlag1 = 0;                
              
          if( BBIMAddFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertBBFlag1 = 1;
          else
              SAAlertBBFlag1 = 0;                
          
          if( CFMUserFlag1 == 1 && (mswatch.Condition_for_R1__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R1__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertCFMUserFlag1 = 1;
          else
              SAAlertCFMUserFlag1 = 0;
                                                                                                        
        }
        else
        {
           NYAlertEmailFlag1 = 0;
           NYAlertAOLIMFlag1 = 0;
           NYAlertPPFlag1 = 0;
           NYAlertBBFlag1 = 0;
           NYAlertCFMUserFlag1 = 0;
           LNAlertEmailFlag1 = 0;
           LNAlertAOLIMFlag1 = 0;
           LNAlertPPFlag1 = 0;
           LNAlertBBFlag1 = 0;
           LNAlertCFMUserFlag1 = 0;
           AsiaAlertEmailFlag1 = 0; 
           AsiaAlertPPFlag1 = 0;
           AsiaAlertBBFlag1 = 0;
           AsiaAlertCFMUserFlag1 = 0; 
           AsiaAlertEmail2Flag1 = 0; 
           AsiaAlertPP2Flag1 = 0;
           AsiaAlertBB2Flag1 = 0;
           AsiaAlertCFM2UserFlag1 = 0; 
        }
        
//singhrak, REQ3604048, 3Apr, 2015, start
           calcTraderAgreedOpt();         
 //singhrak, REQ3604048, 3Apr, 2015, end     

        //Trader-2
        
        if(mswatch.Send_alerts_via_R2__c != null)
        {
            if(mswatch.Send_alerts_via_R2__c.indexOF('Bloomberg IM')!= -1)
                BBIMAddFlag2 = 1;
            else
                BBIMAddFlag2 = 0;
                
            if(mswatch.Send_alerts_via_R2__c.indexOF('Email')!= -1)
                EmailAddFlag2 = 1;
            else
                EmailAddFlag2 = 0;
                
            if(mswatch.Send_alerts_via_R2__c.indexOF('IM_AOL')!= -1)
                IMAOLAddFlag2 = 1;
            else
                IMAOLAddFlag2 = 0;
                
            if(mswatch.Send_alerts_via_R2__c.indexOF('Passport')!= -1)
                PassLogFlag2 = 1;
            else
                PassLogFlag2 = 0;
            
            if(mswatch.Send_alerts_via_R2__c.indexOF('CFM User only')!= -1)
                CFMUserFlag2 = 1;
            else
                CFMUserFlag2 = 0;    
                   
        }         
        else
        {
            EmailAddFlag2 = 0;
            IMAOLAddFlag2 = 0;
            PassLogFlag2 = 0;
            BBIMAddFlag2 = 0;
            CFMUserFlag2 = 0;           
        }
        
        if(mswatch.Condition_for_R2__c != null && mswatch.Send_alerts_via_R2__c != null)
        {

          if( EmailAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertEmailFlag2 = 1;
          else
              NYAlertEmailFlag2 = 0;
                       
          if( IMAOLAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertAOLIMFlag2 = 1;
          else
              NYAlertAOLIMFlag2 = 0;                
              
          if( PassLogFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertPPFlag2 = 1;
          else
              NYAlertPPFlag2 = 0;                
              
          if( BBIMAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertBBFlag2 = 1;
          else
              NYAlertBBFlag2 = 0;                
          
          if( CFMUserFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertCFMUserFlag2 = 1;
          else
              NYAlertCFMUserFlag2 = 0;
                  
          if( EmailAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertEmailFlag2 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
             {
                LNAlertEmailFlag2 = 0;
                mswatch.Enable_LN_alerts_for_Email_for_R2__c = null;
             }
             //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
          if( IMAOLAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertAOLIMFlag2 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertAOLIMFlag2 = 0;
              mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
          if( PassLogFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertPPFlag2 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertPPFlag2 = 0;
              mswatch.Enable_LN_alerts_for_PP_for_R2__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end    

              
          if( BBIMAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertBBFlag2 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertBBFlag2 = 0;
              mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c = null;
          }  
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end
  
          
          if( CFMUserFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R2__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertCFMUserFlag2 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertCFMUserFlag2 = 0;
              mswatch.Enable_LN_alert_for_CFM_Users_R2__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
     /*     if( EmailAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag2 = 1;
          else
              AsiaAlertEmailFlag2 = 0;
          
          if( PassLogFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag2 = 1;
          else
              AsiaAlertPPFlag2 = 0;
          
          if( BBIMAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag2 = 1;
          else
              AsiaAlertBBFlag2 = 0;
              
          if( CFMUserFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag2 = 1;
          else
              AsiaAlertCFMUserFlag2 = 0; */
          if((mswatch.Trade_Region__c!= null)&&( !mswatch.Trade_Region__c.contains('Pan-Asia')) && EmailAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag2 = 1;
          else
              AsiaAlertEmailFlag2 = 0;
          
          if((mswatch.Trade_Region__c!= null)&& (!mswatch.Trade_Region__c.contains('Pan-Asia')) && PassLogFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag2 = 1;
          else
              AsiaAlertPPFlag2 = 0;
          
          if((mswatch.Trade_Region__c!= null)&& (!mswatch.Trade_Region__c.contains('Pan-Asia')) && BBIMAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag2 = 1;
          else
              AsiaAlertBBFlag2 = 0;
              
          if( (mswatch.Trade_Region__c!= null)&&(!mswatch.Trade_Region__c.contains('Pan-Asia')) && CFMUserFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag2 = 1;
          else
              AsiaAlertCFMUserFlag2 = 0; 
              
             //REQ4954035, vinay, 25NOV , 2015,
              
          if( (mswatch.Trade_Region__c!= null)&&(mswatch.Trade_Region__c.contains('Pan-Asia')) && EmailAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmail2Flag2 = 1;
          else
              AsiaAlertEmail2Flag2 = 0; 
          
          if( (mswatch.Trade_Region__c!= null)&& (mswatch.Trade_Region__c.contains('Pan-Asia')) &&  PassLogFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPP2Flag2 = 1;
          else
              AsiaAlertPP2Flag2 = 0; 
          
          if((mswatch.Trade_Region__c!= null)&& (mswatch.Trade_Region__c.contains('Pan-Asia')) &&  BBIMAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBB2Flag2 = 1;
          else
              AsiaAlertBB2Flag2 = 0;  
              
          if( (mswatch.Trade_Region__c!= null)&&(mswatch.Trade_Region__c.contains('Pan-Asia')) &&  CFMUserFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R2__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFM2UserFlag2 = 1;
          else
              AsiaAlertCFM2UserFlag2 = 0;
           //REQ4954035, vinay, 25NOV , 2015,    

          if( EmailAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertEmailFlag2 = 1;
          else
              SAAlertEmailFlag2 = 0;
              
          if( IMAOLAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertAOLIMFlag2 = 1;
          else
              SAAlertAOLIMFlag2 = 0;                
              
          if( PassLogFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertPPFlag2 = 1;
          else
              SAAlertPPFlag2 = 0;                
              
          if( BBIMAddFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertBBFlag2 = 1;
          else
              SAAlertBBFlag2 = 0;                
          
          if( CFMUserFlag2 == 1 && (mswatch.Condition_for_R2__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R2__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertCFMUserFlag2 = 1;
          else
              SAAlertCFMUserFlag2 = 0;
                                                                                                    
        }
        else
        {
           NYAlertEmailFlag2 = 0;
           NYAlertAOLIMFlag2 = 0;
           NYAlertPPFlag2 = 0;
           NYAlertBBFlag2 = 0;
           NYAlertCFMUserFlag2 = 0;
           LNAlertEmailFlag2 = 0;
           LNAlertAOLIMFlag2 = 0;
           LNAlertPPFlag2 = 0;
           LNAlertBBFlag2 = 0;
           LNAlertCFMUserFlag2 = 0;
           AsiaAlertEmailFlag2 = 0; 
           AsiaAlertPPFlag2 = 0;
           AsiaAlertBBFlag2 = 0;
           AsiaAlertCFMUserFlag2 = 0; 
            AsiaAlertEmail2Flag2 = 0; 
           AsiaAlertPP2Flag2 = 0;
           AsiaAlertBB2Flag2 = 0;
           AsiaAlertCFM2UserFlag2 = 0; 
        }

        //singhrak, REQ3604048, 3Apr, 2015, start
           calcTraderAgreedOpt2();         
 //singhrak, REQ3604048, 3Apr, 2015, end                

        
        // Trader-3
        
        if(mswatch.Send_alerts_via_R3__c != null)
        {
            if(mswatch.Send_alerts_via_R3__c.indexOF('Bloomberg IM')!= -1)
                BBIMAddFlag3 = 1;
            else
                BBIMAddFlag3 = 0;
                
            if(mswatch.Send_alerts_via_R3__c.indexOF('Email')!= -1)
                EmailAddFlag3 = 1;
            else
                EmailAddFlag3 = 0;
                
            if(mswatch.Send_alerts_via_R3__c.indexOF('IM_AOL')!= -1)
                IMAOLAddFlag3 = 1;
            else
                IMAOLAddFlag3 = 0;
                
            if(mswatch.Send_alerts_via_R3__c.indexOF('Passport')!= -1)
                PassLogFlag3 = 1;
            else
                PassLogFlag3 = 0;
            
            if(mswatch.Send_alerts_via_R3__c.indexOF('CFM User only')!= -1)
                CFMUserFlag3 = 1;
            else
                CFMUserFlag3 = 0;    
                   
        }         
        else
        {
            EmailAddFlag3 = 0;
            IMAOLAddFlag3 = 0;
            PassLogFlag3 = 0;
            BBIMAddFlag3 = 0;
            CFMUserFlag3 = 0;            
        }
        
        if(mswatch.Condition_for_R3__c != null && mswatch.Send_alerts_via_R3__c != null)
        {

          if( EmailAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertEmailFlag3 = 1;
          else
              NYAlertEmailFlag3 = 0;
              
          if( IMAOLAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertAOLIMFlag3 = 1;
          else
              NYAlertAOLIMFlag3 = 0;                
              
          if( PassLogFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertPPFlag3 = 1;
          else
              NYAlertPPFlag3 = 0;                
              
          if( BBIMAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertBBFlag3 = 1;
          else
              NYAlertBBFlag3 = 0;                
          
          if( CFMUserFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertCFMUserFlag3 = 1;
          else
              NYAlertCFMUserFlag3 = 0;
                  
          if( EmailAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertEmailFlag3 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertEmailFlag3 = 0;
              mswatch.Enable_LN_alerts_for_Email_for_R3__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end 

          
          if( IMAOLAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertAOLIMFlag3 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertAOLIMFlag3 = 0;
              mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end 

          
          if( PassLogFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertPPFlag3 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertPPFlag3 = 0;
              mswatch.Enable_LN_alerts_for_PP_for_R3__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end 

              
          if( BBIMAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertBBFlag3 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertBBFlag3 = 0;
              mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c = null;
          } 
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end 
 
          
          if( CFMUserFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R3__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertCFMUserFlag3 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertCFMUserFlag3 = 0;
              mswatch.Enable_LN_alert_for_CFM_Users_R3__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end 
 
          
      /*    if( EmailAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag3 = 1;
          else
              AsiaAlertEmailFlag3 = 0;
          
          if( PassLogFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag3 = 1;
          else
              AsiaAlertPPFlag3 = 0;
          
          if( BBIMAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag3 = 1;
          else
              AsiaAlertBBFlag3 = 0;
          
          if( CFMUserFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag3 = 1;
          else
              AsiaAlertCFMUserFlag3 = 0; */
              if(mswatch.Trade_Region__c!= null){
           if(!mswatch.Trade_Region__c.contains('Pan-Asia') &&  EmailAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag3 = 1;
          else
              AsiaAlertEmailFlag3 = 0;
          
          if(!mswatch.Trade_Region__c.contains('Pan-Asia') && PassLogFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag3 = 1;
          else
              AsiaAlertPPFlag3 = 0;
          
          if(!mswatch.Trade_Region__c.contains('Pan-Asia') && BBIMAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag3 = 1;
          else
              AsiaAlertBBFlag3 = 0;
          
          if(!mswatch.Trade_Region__c.contains('Pan-Asia') && CFMUserFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag3 = 1;
          else
              AsiaAlertCFMUserFlag3 = 0;
              
           //REQ4954035, vinay, 25NOV , 2015,
           if(mswatch.Trade_Region__c.contains('Pan-Asia') && EmailAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmail2Flag3 = 1;
          else
              AsiaAlertEmail2Flag3 = 0;
          
          if(mswatch.Trade_Region__c.contains('Pan-Asia') && PassLogFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPP2Flag3 = 1;
          else
              AsiaAlertPP2Flag3 = 0;
          
          if(mswatch.Trade_Region__c.contains('Pan-Asia') && BBIMAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBB2Flag3 = 1;
          else
              AsiaAlertBB2Flag3 = 0;
          
          if(mswatch.Trade_Region__c.contains('Pan-Asia') && CFMUserFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R3__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFM2UserFlag3 = 1;
          else
              AsiaAlertCFM2UserFlag3 = 0;
        
              }
         //REQ4954035, vinay, 25NOV , 2015,     
              
          if( EmailAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertEmailFlag3 = 1;
          else
              SAAlertEmailFlag3 = 0;
              
          if( IMAOLAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertAOLIMFlag3 = 1;
          else
              SAAlertAOLIMFlag3 = 0;                
              
          if( PassLogFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertPPFlag3 = 1;
          else
              SAAlertPPFlag3 = 0;                
              
          if( BBIMAddFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertBBFlag3 = 1;
          else
              SAAlertBBFlag3 = 0;                
          
          if( CFMUserFlag3 == 1 && (mswatch.Condition_for_R3__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R3__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertCFMUserFlag3 = 1;
          else
              SAAlertCFMUserFlag3 = 0;
                                                                                                      
        }
        else
        {
           NYAlertEmailFlag3 = 0;
           NYAlertAOLIMFlag3 = 0;
           NYAlertPPFlag3 = 0;
           NYAlertBBFlag3 = 0;
           NYAlertCFMUserFlag3 = 0;
           LNAlertEmailFlag3 = 0;
           LNAlertAOLIMFlag3 = 0;
           LNAlertPPFlag3 = 0;
           LNAlertBBFlag3 = 0;
           LNAlertCFMUserFlag3 = 0;
           AsiaAlertEmailFlag3 = 0; 
           AsiaAlertPPFlag3 = 0;
           AsiaAlertBBFlag3 = 0;
           AsiaAlertCFMUserFlag3 = 0; 
        }

                //singhrak, REQ3604048, 3Apr, 2015, start
        calcTraderAgreedOpt3();
        //singhrak, REQ3604048, 3Apr, 2015, end
        
        // Trader - 4
        
        if(mswatch.Send_alerts_via_R4__c != null)
        {
            if(mswatch.Send_alerts_via_R4__c.indexOF('Bloomberg IM')!= -1)
                BBIMAddFlag4 = 1;
            else
                BBIMAddFlag4 = 0;
                
            if(mswatch.Send_alerts_via_R4__c.indexOF('Email')!= -1)
                EmailAddFlag4 = 1;
            else
                EmailAddFlag4 = 0;
                
            if(mswatch.Send_alerts_via_R4__c.indexOF('IM_AOL')!= -1)
                IMAOLAddFlag4 = 1;
            else
                IMAOLAddFlag4 = 0;
                
            if(mswatch.Send_alerts_via_R4__c.indexOF('Passport')!= -1)
                PassLogFlag4 = 1;
            else
                PassLogFlag4 = 0;
            
            if(mswatch.Send_alerts_via_R4__c.indexOF('CFM User only')!= -1)
                CFMUserFlag4 = 1;
            else
                CFMUserFlag4 = 0;    
                  
        }         
        else
        {
            EmailAddFlag4 = 0;
            IMAOLAddFlag4 = 0;
            PassLogFlag4 = 0;
            BBIMAddFlag4 = 0;
            CFMUserFlag4 = 0;
        }
        
        if(mswatch.Condition_for_R4__c != null && mswatch.Send_alerts_via_R4__c != null)
        {

          if( EmailAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertEmailFlag4 = 1;
          else
              NYAlertEmailFlag4 = 0;
              
          if( IMAOLAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertAOLIMFlag4 = 1;
          else
              NYAlertAOLIMFlag4 = 0;                
              
          if( PassLogFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertPPFlag4 = 1;
          else
              NYAlertPPFlag4 = 0;                
              
          if( BBIMAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertBBFlag4 = 1;
          else
              NYAlertBBFlag4 = 0;                
              
          if( CFMUserFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('NY_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('NY_PASSPORT')!= -1))
              NYAlertCFMUserFlag4 = 1;
          else
              NYAlertCFMUserFlag4 = 0;
  
              
          if( EmailAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertEmailFlag4 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertEmailFlag4 = 0;
              mswatch.Enable_LN_alerts_for_Email_for_R4__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
          if( IMAOLAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertAOLIMFlag4 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertAOLIMFlag4 = 0;
              mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end
          
          if( PassLogFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertPPFlag4 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertPPFlag4 = 0;
              mswatch.Enable_LN_alerts_for_PP_for_R4__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

              
          if( BBIMAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertBBFlag4 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertBBFlag4 = 0;
              mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end 
 
          
          if( CFMUserFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('LN_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_FIX_SWAPS')!= -1 || mswatch.Condition_for_R4__c.indexOF('LN_PASSPORT')!= -1))
              LNAlertCFMUserFlag4 = 1;
          else
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, start
          {
              LNAlertCFMUserFlag4 = 0;
              mswatch.Enable_LN_alert_for_CFM_Users_R4__c = null;
          }
          //singhrak, REQ3604048, 3Apr, 2015, replace single line with below block, end

          
       /*   if( EmailAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag4 = 1;
          else
              AsiaAlertEmailFlag4 = 0;
          
          if( PassLogFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag4 = 1;
          else
              AsiaAlertPPFlag4 = 0;
          
          if( BBIMAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag4 = 1;
          else
              AsiaAlertBBFlag4 = 0;
          
          if( CFMUserFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag4 = 1;
          else
              AsiaAlertCFMUserFlag4 = 0;*/
          if(mswatch.Trade_Region__c!= null){
           if(!mswatch.Trade_Region__c.contains('Pan-Asia') &&  EmailAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmailFlag4 = 1;
          else
              AsiaAlertEmailFlag4 = 0;
          
          if(!mswatch.Trade_Region__c.contains('Pan-Asia') && PassLogFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPPFlag4 = 1;
          else
              AsiaAlertPPFlag4 = 0;
          
          if(!mswatch.Trade_Region__c.contains('Pan-Asia') && BBIMAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBBFlag4 = 1;
          else
              AsiaAlertBBFlag4 = 0;
          
          if(!mswatch.Trade_Region__c.contains('Pan-Asia') && CFMUserFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFMUserFlag4 = 1;
          else
              AsiaAlertCFMUserFlag4 = 0;
              
          //REQ4954035, vinay, 25NOV , 2015,
           if( mswatch.Trade_Region__c.contains('Pan-Asia') &&  EmailAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertEmail2Flag4 = 1;
          else
              AsiaAlertEmail2Flag4 = 0;
          
          if( mswatch.Trade_Region__c.contains('Pan-Asia') &&  PassLogFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertPP2Flag4 = 1;
          else
              AsiaAlertPP2Flag4 = 0;
          
          if( mswatch.Trade_Region__c.contains('Pan-Asia') &&  BBIMAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertBB2Flag4 = 1;
          else
              AsiaAlertBB2Flag4 = 0;
          
          if(mswatch.Trade_Region__c.contains('Pan-Asia') &&  CFMUserFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_FIX_SWAP')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_LIST')!= -1 || mswatch.Condition_for_R4__c.indexOF('TK_HK_PASSPORT')!= -1))
              AsiaAlertCFM2UserFlag4 = 1;
          else
              AsiaAlertCFM2UserFlag4 = 0;
         //REQ4954035, vinay, 25NOV , 2015,    
          }                                                                             
          if( EmailAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertEmailFlag4 = 1;
          else
              SAAlertEmailFlag4 = 0;
              
          if( IMAOLAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertAOLIMFlag4 = 1;
          else
              SAAlertAOLIMFlag4 = 0;                
              
          if( PassLogFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertPPFlag4 = 1;
          else
              SAAlertPPFlag4 = 0;                
              
          if( BBIMAddFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertBBFlag4 = 1;
          else
              SAAlertBBFlag4 = 0;                
          
          if( CFMUserFlag4 == 1 && (mswatch.Condition_for_R4__c.indexOF('SA_FIX_BROKER')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_BXS')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_DMA')!= -1 || mswatch.Condition_for_R4__c.indexOF('SA_FIX_SWAP')!= -1))
              SAAlertCFMUserFlag4 = 1;
          else
              SAAlertCFMUserFlag4 = 0;
              
        }
        else
        {
           NYAlertEmailFlag4 = 0;
           NYAlertAOLIMFlag4 = 0;
           NYAlertPPFlag4 = 0;
           NYAlertBBFlag4 = 0;
           NYAlertCFMUserFlag4 = 0;
           LNAlertEmailFlag4 = 0;
           LNAlertAOLIMFlag4 = 0;
           LNAlertPPFlag4 = 0;
           LNAlertBBFlag4 = 0;
           LNAlertCFMUserFlag4 = 0; 
           AsiaAlertEmailFlag4 = 0; 
           AsiaAlertPPFlag4 = 0;
           AsiaAlertBBFlag4 = 0;
           AsiaAlertCFMUserFlag4 = 0;
            AsiaAlertEmail2Flag4 = 0; 
           AsiaAlertPP2Flag4 = 0;
           AsiaAlertBB2Flag4 = 0;
           AsiaAlertCFM2UserFlag4 = 0;
        }
        
        //singhrak, REQ3604048, 3Apr, 2015, start
        calcTraderAgreedOpt4();
        //singhrak, REQ3604048, 3Apr, 2015, end
        
    }
    
     public void calcNextTraderValue() {
        
        if(mswatch.Add_Trador__c == true)
            Trader2DispFlag = 1;
        else
            Trader2DispFlag = 0;     
        
        if(mswatch.Add_Trador_3__c == true)
            Trader3DispFlag = 1;
        else
            Trader3DispFlag = 0;
        
        if(mswatch.Add_Trador_4__c == true)
            Trader4DispFlag = 1;
        else
            Trader4DispFlag = 0;    
    }    
    
//       REQ884082, Start
 public void calcTradeRegion()
    {
      if( this.mswatch.Trade_Region__c!=null && this.mswatch.Trade_Region__c.indexOf('Pan-Asia') != -1)
      {
        tradeRegionType = 1;
      }
      else 
        tradeRegionType = 0;
    }
    
    public Integer tradeRegionType=0;
    public Integer gettradeRegionType()
    {
      return tradeRegionType;
    } 
//       REQ884082, End

   public PageReference cloneAction() {
       PageReference editForm = new Apexpages.Standardcontroller(mswatch).edit();
       
       editForm.getParameters().put('flow','clone');
       editForm.setredirect(true);
       this.mswatch.Status__c='Submitted';
       return editForm;
   } 
   
    public PageReference cloneForm() {
       PageReference pref = null;
       
     try {
     
           this.cloneableRequestForm.MSET_Account__c = this.mswatch.MSET_Account__c;  
           //this.cloneableRequestForm.Account_Number_IN__c = this.mswatch.Account_Number_IN__c;
           this.cloneableRequestForm.Add_Trador__c = this.mswatch.Add_Trador__c;
           this.cloneableRequestForm.Add_Trador_3__c = this.mswatch.Add_Trador_3__c;
           this.cloneableRequestForm.Add_Trador_4__c = this.mswatch.Add_Trador_4__c;
           this.cloneableRequestForm.Alert_Recipient_Name_R1__c = this.mswatch.Alert_Recipient_Name_R1__c;
           this.cloneableRequestForm.Alert_Recipient_Name_R2__c = this.mswatch.Alert_Recipient_Name_R2__c;
           this.cloneableRequestForm.Alert_Recipient_Name_R3__c = this.mswatch.Alert_Recipient_Name_R3__c;
           this.cloneableRequestForm.Alert_Recipient_Name_R4__c = this.mswatch.Alert_Recipient_Name_R4__c;
           
           this.cloneableRequestForm.Bloomberg_IM_address_for_R1__c = this.mswatch.Bloomberg_IM_address_for_R1__c;
           this.cloneableRequestForm.Bloomberg_IM_address_for_R2__c = this.mswatch.Bloomberg_IM_address_for_R2__c;
           this.cloneableRequestForm.Bloomberg_IM_address_for_R3__c = this.mswatch.Bloomberg_IM_address_for_R3__c;
           this.cloneableRequestForm.Bloomberg_IM_address_for_R4__c = this.mswatch.Bloomberg_IM_address_for_R4__c;
           
           this.cloneableRequestForm.Comments__c = this.mswatch.Comments__c;
           this.cloneableRequestForm.Condition_for_R1__c = this.mswatch.Condition_for_R1__c;
           this.cloneableRequestForm.Condition_for_R2__c = this.mswatch.Condition_for_R2__c;
           this.cloneableRequestForm.Condition_for_R3__c = this.mswatch.Condition_for_R3__c;
           this.cloneableRequestForm.Condition_for_R4__c = this.mswatch.Condition_for_R4__c;
           
           this.cloneableRequestForm.Email_address_for_R1__c = this.mswatch.Email_address_for_R1__c;  
           this.cloneableRequestForm.Email_address_for_R2__c = this.mswatch.Email_address_for_R2__c;
           this.cloneableRequestForm.Email_address_for_R3__c = this.mswatch.Email_address_for_R3__c;
           this.cloneableRequestForm.Email_address_for_R4__c = this.mswatch.Email_address_for_R4__c;
           this.cloneableRequestForm.Enable_Asia_alert_for_CFM_Users_R1__c = this.mswatch.Enable_Asia_alert_for_CFM_Users_R1__c;  
           this.cloneableRequestForm.Enable_Asia_alert_for_CFM_Users_R2__c = this.mswatch.Enable_Asia_alert_for_CFM_Users_R2__c;
           this.cloneableRequestForm.Enable_Asia_alert_for_CFM_Users_R3__c = this.mswatch.Enable_Asia_alert_for_CFM_Users_R3__c;
           this.cloneableRequestForm.Enable_Asia_alert_for_CFM_Users_R4__c = this.mswatch.Enable_Asia_alert_for_CFM_Users_R4__c;                      
           this.cloneableRequestForm.Enable_Asia_alert_for_Interest_List_R1__c = this.mswatch.Enable_Asia_alert_for_Interest_List_R1__c;  
           this.cloneableRequestForm.Enable_Asia_alert_for_Interest_List_R2__c = this.mswatch.Enable_Asia_alert_for_Interest_List_R2__c;
           this.cloneableRequestForm.Enable_Asia_alert_for_Interest_List_R3__c = this.mswatch.Enable_Asia_alert_for_Interest_List_R3__c;
           this.cloneableRequestForm.Enable_Asia_alert_for_Interest_List_R4__c = this.mswatch.Enable_Asia_alert_for_Interest_List_R4__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg_IM_R1__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg_IM_R1__c;  
           this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg_IM_R2__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg_IM_R2__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg_IM_R3__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg_IM_R3__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg_IM_R4__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg_IM_R4__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_Email_for_R1__c = this.mswatch.Enable_Asia_alerts_for_Email_for_R1__c;  
           this.cloneableRequestForm.Enable_Asia_alerts_for_Email_for_R2__c = this.mswatch.Enable_Asia_alerts_for_Email_for_R2__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_Email_for_R3__c = this.mswatch.Enable_Asia_alerts_for_Email_for_R3__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_Email_for_R4__c = this.mswatch.Enable_Asia_alerts_for_Email_for_R4__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_PP_for_R1__c = this.mswatch.Enable_Asia_alerts_for_PP_for_R1__c;  
           this.cloneableRequestForm.Enable_Asia_alerts_for_PP_for_R2__c = this.mswatch.Enable_Asia_alerts_for_PP_for_R2__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_PP_for_R3__c = this.mswatch.Enable_Asia_alerts_for_PP_for_R3__c;
           this.cloneableRequestForm.Enable_Asia_alerts_for_PP_for_R4__c = this.mswatch.Enable_Asia_alerts_for_PP_for_R4__c;           
           //REQ4954035, vinay, 26NOV , 2015,
            this.cloneableRequestForm.Enable_Asia_alert_for_CFM2_Users_R1__c = this.mswatch.Enable_Asia_alert_for_CFM2_Users_R1__c;  
            this.cloneableRequestForm.Enable_Asia_alert_for_CFM2_Users_R2__c = this.mswatch.Enable_Asia_alert_for_CFM2_Users_R2__c;
            this.cloneableRequestForm.Enable_Asia_alert_for_CFM2_Users_R3__c = this.mswatch.Enable_Asia_alert_for_CFM2_Users_R3__c;
            this.cloneableRequestForm.Enable_Asia_alert_for_CFM2_Users_R4__c = this.mswatch.Enable_Asia_alert_for_CFM2_Users_R4__c;                      
            this.cloneableRequestForm.Enable_Asia_alert_for_IList_R1__c = this.mswatch.Enable_Asia_alert_for_IList_R1__c;  
            this.cloneableRequestForm.Enable_Asia_alert_for_IList_R2__c = this.mswatch.Enable_Asia_alert_for_IList_R2__c;
            this.cloneableRequestForm.Enable_Asia_alert_for_IList_R3__c = this.mswatch.Enable_Asia_alert_for_IList_R3__c;
            this.cloneableRequestForm.Enable_Asia_alert_for_IList_R4__c = this.mswatch.Enable_Asia_alert_for_IList_R4__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg2_IM_R1__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg2_IM_R1__c;  
            this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg2_IM_R2__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg2_IM_R2__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg2_IM_R3__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg2_IM_R3__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_Bloomberg2_IM_R4__c = this.mswatch.Enable_Asia_alerts_for_Bloomberg2_IM_R4__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_Email2_for_R1__c = this.mswatch.Enable_Asia_alerts_for_Email2_for_R1__c;  
            this.cloneableRequestForm.Enable_Asia_alerts_for_Email2_for_R2__c = this.mswatch.Enable_Asia_alerts_for_Email2_for_R2__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_Email2_for_R3__c = this.mswatch.Enable_Asia_alerts_for_Email2_for_R3__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_Email2_for_R4__c = this.mswatch.Enable_Asia_alerts_for_Email2_for_R4__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_PP2_for_R1__c = this.mswatch.Enable_Asia_alerts_for_PP2_for_R1__c;  
            this.cloneableRequestForm.Enable_Asia_alerts_for_PP2_for_R2__c = this.mswatch.Enable_Asia_alerts_for_PP2_for_R2__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_PP2_for_R3__c = this.mswatch.Enable_Asia_alerts_for_PP2_for_R3__c;
            this.cloneableRequestForm.Enable_Asia_alerts_for_PP2_for_R4__c = this.mswatch.Enable_Asia_alerts_for_PP2_for_R4__c;
           //REQ4954035, vinay, 26NOV , 2015,
           this.cloneableRequestForm.Enable_LN_alert_for_CFM_Users_R1__c = this.mswatch.Enable_LN_alert_for_CFM_Users_R1__c;  
           this.cloneableRequestForm.Enable_LN_alert_for_CFM_Users_R2__c = this.mswatch.Enable_LN_alert_for_CFM_Users_R2__c;
           this.cloneableRequestForm.Enable_LN_alert_for_CFM_Users_R3__c = this.mswatch.Enable_LN_alert_for_CFM_Users_R3__c;
           this.cloneableRequestForm.Enable_LN_alert_for_CFM_Users_R4__c = this.mswatch.Enable_LN_alert_for_CFM_Users_R4__c;         
           this.cloneableRequestForm.Enable_LN_alerts_for_AOL_IM_for_R1__c = this.mswatch.Enable_LN_alerts_for_AOL_IM_for_R1__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_AOL_IM_for_R2__c = this.mswatch.Enable_LN_alerts_for_AOL_IM_for_R2__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_AOL_IM_for_R3__c = this.mswatch.Enable_LN_alerts_for_AOL_IM_for_R3__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_AOL_IM_for_R4__c = this.mswatch.Enable_LN_alerts_for_AOL_IM_for_R4__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_Bloomberg_IM_R1__c = this.mswatch.Enable_LN_alerts_for_Bloomberg_IM_R1__c;           
           this.cloneableRequestForm.Enable_LN_alerts_for_Bloomberg_IM_R2__c = this.mswatch.Enable_LN_alerts_for_Bloomberg_IM_R2__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_Bloomberg_IM_R3__c = this.mswatch.Enable_LN_alerts_for_Bloomberg_IM_R3__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_Bloomberg_IM_R4__c = this.mswatch.Enable_LN_alerts_for_Bloomberg_IM_R4__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_Email_for_R1__c = this.mswatch.Enable_LN_alerts_for_Email_for_R1__c;           
           this.cloneableRequestForm.Enable_LN_alerts_for_Email_for_R2__c = this.mswatch.Enable_LN_alerts_for_Email_for_R2__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_Email_for_R3__c = this.mswatch.Enable_LN_alerts_for_Email_for_R3__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_Email_for_R4__c = this.mswatch.Enable_LN_alerts_for_Email_for_R4__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_PP_for_R1__c = this.mswatch.Enable_LN_alerts_for_PP_for_R1__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_PP_for_R2__c = this.mswatch.Enable_LN_alerts_for_PP_for_R2__c;
           this.cloneableRequestForm.Enable_LN_alerts_for_PP_for_R3__c = this.mswatch.Enable_LN_alerts_for_PP_for_R3__c;  
           this.cloneableRequestForm.Enable_LN_alerts_for_PP_for_R4__c = this.mswatch.Enable_LN_alerts_for_PP_for_R4__c;           
           this.cloneableRequestForm.Enable_NY_alert_for_CFM_Users_R1__c = this.mswatch.Enable_NY_alert_for_CFM_Users_R1__c;
           this.cloneableRequestForm.Enable_NY_alert_for_CFM_Users_R2__c = this.mswatch.Enable_NY_alert_for_CFM_Users_R2__c;
           this.cloneableRequestForm.Enable_NY_alert_for_CFM_Users_R3__c = this.mswatch.Enable_NY_alert_for_CFM_Users_R3__c;  
           this.cloneableRequestForm.Enable_NY_alert_for_CFM_Users_R4__c = this.mswatch.Enable_NY_alert_for_CFM_Users_R4__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_AOL_IM_for_R1__c = this.mswatch.Enable_NY_alerts_for_AOL_IM_for_R1__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_AOL_IM_for_R2__c = this.mswatch.Enable_NY_alerts_for_AOL_IM_for_R2__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_AOL_IM_for_R3__c = this.mswatch.Enable_NY_alerts_for_AOL_IM_for_R3__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_AOL_IM_for_R4__c = this.mswatch.Enable_NY_alerts_for_AOL_IM_for_R4__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Bloomberg_IM_R1__c = this.mswatch.Enable_NY_alerts_for_Bloomberg_IM_R1__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Bloomberg_IM_R2__c = this.mswatch.Enable_NY_alerts_for_Bloomberg_IM_R2__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Bloomberg_IM_R3__c = this.mswatch.Enable_NY_alerts_for_Bloomberg_IM_R3__c;           
           this.cloneableRequestForm.Enable_NY_alerts_for_Bloomberg_IM_R4__c = this.mswatch.Enable_NY_alerts_for_Bloomberg_IM_R4__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Email_for_R1__c = this.mswatch.Enable_NY_alerts_for_Email_for_R1__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Email_for_R2__c = this.mswatch.Enable_NY_alerts_for_Email_for_R2__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Email_for_R3__c = this.mswatch.Enable_NY_alerts_for_Email_for_R3__c;           
           this.cloneableRequestForm.Enable_NY_alerts_for_Email_for_R4__c = this.mswatch.Enable_NY_alerts_for_Email_for_R4__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Interest_List_R1__c = this.mswatch.Enable_NY_alerts_for_Interest_List_R1__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Interest_List_R2__c = this.mswatch.Enable_NY_alerts_for_Interest_List_R2__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Interest_List_R3__c = this.mswatch.Enable_NY_alerts_for_Interest_List_R3__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_Interest_List_R4__c = this.mswatch.Enable_NY_alerts_for_Interest_List_R4__c;           
           this.cloneableRequestForm.Enable_NY_alerts_for_PP_for_R1__c = this.mswatch.Enable_NY_alerts_for_PP_for_R1__c;  
           this.cloneableRequestForm.Enable_NY_alerts_for_PP_for_R2__c = this.mswatch.Enable_NY_alerts_for_PP_for_R2__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_PP_for_R3__c = this.mswatch.Enable_NY_alerts_for_PP_for_R3__c;
           this.cloneableRequestForm.Enable_NY_alerts_for_PP_for_R4__c = this.mswatch.Enable_NY_alerts_for_PP_for_R4__c;
           
           this.cloneableRequestForm.IM_AOL_address_for_R1__c = this.mswatch.IM_AOL_address_for_R1__c;
           this.cloneableRequestForm.IM_AOL_address_for_R2__c = this.mswatch.IM_AOL_address_for_R2__c;
           this.cloneableRequestForm.IM_AOL_address_for_R3__c = this.mswatch.IM_AOL_address_for_R3__c;
           this.cloneableRequestForm.IM_AOL_address_for_R4__c = this.mswatch.IM_AOL_address_for_R4__c;
           
           this.cloneableRequestForm.Logged_In_User__c = this.mswatch.Logged_In_User__c;           
           
           this.cloneableRequestForm.OnBehalfOfCompID_T1__c = this.mswatch.OnBehalfOfCompID_T1__c;
           this.cloneableRequestForm.OnBehalfOfCompID_T2__c = this.mswatch.OnBehalfOfCompID_T2__c;
           this.cloneableRequestForm.OnBehalfOfCompID_T3__c = this.mswatch.OnBehalfOfCompID_T3__c;
           this.cloneableRequestForm.OnBehalfOfCompID_T4__c = this.mswatch.OnBehalfOfCompID_T4__c;           
           this.cloneableRequestForm.OnBehalfOfSubID_T1__c = this.mswatch.OnBehalfOfSubID_T1__c;
           this.cloneableRequestForm.OnBehalfOfSubID_T2__c = this.mswatch.OnBehalfOfSubID_T2__c;
           this.cloneableRequestForm.OnBehalfOfSubID_T3__c = this.mswatch.OnBehalfOfSubID_T3__c;
           this.cloneableRequestForm.OnBehalfOfSubID_T4__c = this.mswatch.OnBehalfOfSubID_T4__c;
           
           this.cloneableRequestForm.Passport_Login_for_R1__c = this.mswatch.Passport_Login_for_R1__c;
           this.cloneableRequestForm.Passport_Login_for_R2__c = this.mswatch.Passport_Login_for_R2__c;
           this.cloneableRequestForm.Passport_Login_for_R3__c = this.mswatch.Passport_Login_for_R3__c;
           this.cloneableRequestForm.Passport_Login_for_R4__c = this.mswatch.Passport_Login_for_R4__c;
           this.cloneableRequestForm.Priority__c = this.mswatch.Priority__c;
           
           this.cloneableRequestForm.Requested_By__c = this.mswatch.Requested_By__c;                                 
           
           this.cloneableRequestForm.Send_alerts_via_R1__c = this.mswatch.Send_alerts_via_R1__c;
           this.cloneableRequestForm.Send_alerts_via_R2__c = this.mswatch.Send_alerts_via_R2__c;
           this.cloneableRequestForm.Send_alerts_via_R3__c = this.mswatch.Send_alerts_via_R3__c;           
           this.cloneableRequestForm.Send_alerts_via_R4__c = this.mswatch.Send_alerts_via_R4__c;
           this.cloneableRequestForm.SenderCompID_T1__c = this.mswatch.SenderCompID_T1__c;
           this.cloneableRequestForm.SenderCompID_T2__c = this.mswatch.SenderCompID_T2__c;
           this.cloneableRequestForm.SenderCompID_T3__c = this.mswatch.SenderCompID_T3__c;
           this.cloneableRequestForm.SenderCompID_T4__c = this.mswatch.SenderCompID_T4__c;
           this.cloneableRequestForm.SenderSubID_T1__c = this.mswatch.SenderSubID_T1__c;
           this.cloneableRequestForm.SenderSubID_T2__c = this.mswatch.SenderSubID_T2__c;
           this.cloneableRequestForm.SenderSubID_T3__c = this.mswatch.SenderSubID_T3__c;
           this.cloneableRequestForm.SenderSubID_T4__c = this.mswatch.SenderSubID_T4__c;           
           this.cloneableRequestForm.Status__c = this.mswatch.Status__c;                      
           
           this.cloneableRequestForm.Target_Date__c = this.mswatch.Target_Date__c;           
           this.cloneableRequestForm.Time_Zone_for_R1__c = this.mswatch.Time_Zone_for_R1__c;
           this.cloneableRequestForm.Time_Zone_for_R2__c = this.mswatch.Time_Zone_for_R2__c;
           this.cloneableRequestForm.Time_Zone_for_R3__c = this.mswatch.Time_Zone_for_R3__c;           
           this.cloneableRequestForm.Time_Zone_for_R4__c = this.mswatch.Time_Zone_for_R4__c;
           this.cloneableRequestForm.Trade_Region__c = this.mswatch.Trade_Region__c;
          this.cloneableRequestForm.MSET_Contact1__c = this.mswatch.MSET_Contact1__c;
           this.cloneableRequestForm.MSET_Contact2__c = this.mswatch.MSET_Contact2__c;
           this.cloneableRequestForm.MSET_Contact3__c = this.mswatch.MSET_Contact3__c;
           this.cloneableRequestForm.MSET_Contact4__c = this.mswatch.MSET_Contact4__c;
           this.cloneableRequestForm.Alerts_Required_Intraday__c = this.mswatch.Alerts_Required_Intraday__c;
 
           this.cloneableRequestForm.Request_Type__c=this.mswatch.Request_Type__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_PP_for_R4__c=this.mswatch.Enable_SA_alerts_for_PP_for_R4__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_PP_for_R3__c=this.mswatch.Enable_SA_alerts_for_PP_for_R3__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_PP_for_R2__c=this.mswatch.Enable_SA_alerts_for_PP_for_R2__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_PP_for_R1__c=this.mswatch.Enable_SA_alerts_for_PP_for_R1__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Email_for_R4__c=this.mswatch.Enable_SA_alerts_for_Email_for_R4__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Email_for_R3__c=this.mswatch.Enable_SA_alerts_for_Email_for_R3__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Email_for_R2__c=this.mswatch.Enable_SA_alerts_for_Email_for_R2__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Email_for_R1__c=this.mswatch.Enable_SA_alerts_for_Email_for_R1__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Bloomberg_IM_R4__c=this.mswatch.Enable_SA_alerts_for_Bloomberg_IM_R4__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Bloomberg_IM_R3__c=this.mswatch.Enable_SA_alerts_for_Bloomberg_IM_R3__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Bloomberg_IM_R2__c=this.mswatch.Enable_SA_alerts_for_Bloomberg_IM_R2__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_Bloomberg_IM_R1__c=this.mswatch.Enable_SA_alerts_for_Bloomberg_IM_R1__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_AOL_IM_for_R4__c=this.mswatch.Enable_SA_alerts_for_AOL_IM_for_R4__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_AOL_IM_for_R3__c=this.mswatch.Enable_SA_alerts_for_AOL_IM_for_R3__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_AOL_IM_for_R2__c=this.mswatch.Enable_SA_alerts_for_AOL_IM_for_R2__c;
          this.cloneableRequestForm.Enable_SA_alerts_for_AOL_IM_for_R1__c=this.mswatch.Enable_SA_alerts_for_AOL_IM_for_R1__c;
          this.cloneableRequestForm.Enable_SA_alert_for_CFM_Users_R4__c=this.mswatch.Enable_SA_alert_for_CFM_Users_R4__c;
          this.cloneableRequestForm.Enable_SA_alert_for_CFM_Users_R3__c=this.mswatch.Enable_SA_alert_for_CFM_Users_R3__c;
          this.cloneableRequestForm.Enable_SA_alert_for_CFM_Users_R2__c=this.mswatch.Enable_SA_alert_for_CFM_Users_R2__c;
          this.cloneableRequestForm.Enable_SA_alert_for_CFM_Users_R1__c=this.mswatch.Enable_SA_alert_for_CFM_Users_R1__c;
          this.cloneableRequestForm.Enable_LN_alerts_for_Interest_List_R4__c=this.mswatch.Enable_LN_alerts_for_Interest_List_R4__c;
          this.cloneableRequestForm.Enable_LN_alerts_for_Interest_List_R3__c=this.mswatch.Enable_LN_alerts_for_Interest_List_R3__c;
          this.cloneableRequestForm.Enable_LN_alerts_for_Interest_List_R2__c=this.mswatch.Enable_LN_alerts_for_Interest_List_R2__c;
          this.cloneableRequestForm.Enable_LN_alerts_for_Interest_List_R1__c=this.mswatch.Enable_LN_alerts_for_Interest_List_R1__c;
          this.cloneableRequestForm.Enable_Client_Interest_List_for_R4__c=this.mswatch.Enable_Client_Interest_List_for_R4__c;
          this.cloneableRequestForm.Enable_Client_Interest_List_for_R3__c=this.mswatch.Enable_Client_Interest_List_for_R3__c;
          this.cloneableRequestForm.Enable_Client_Interest_List_for_R2__c=this.mswatch.Enable_Client_Interest_List_for_R2__c;
          this.cloneableRequestForm.Enable_Client_Interest_List_for_R1__c=this.mswatch.Enable_Client_Interest_List_for_R1__c;

           // singhrak, 31dec, 2014, REQ3179875, Start 
          //this.cloneableRequestForm.Is_this_for_an_Internal_User_email_R1__c = this.mswatch.Is_this_for_an_Internal_User_email_R1__c;
          //this.cloneableRequestForm.Is_this_for_an_Internal_User_email_R2__c = this.mswatch.Is_this_for_an_Internal_User_email_R2__c;      
                 //  this.cloneableRequestForm.Is_this_for_an_Internal_User_email_R3__c = this.mswatch.Is_this_for_an_Internal_User_email_R3__c;             
                 //   this.cloneableRequestForm.Is_this_for_an_Internal_User_email_R4__c = this.mswatch.Is_this_for_an_Internal_User_email_R4__c;   
                 // singhrak, 31dec, 2014, REQ3179875, Start
 
           
           insert cloneableRequestForm;
           pref = new ApexPages.StandardController(cloneableRequestForm).view();
           pref.setredirect(true);
     }
     catch(Exception e) {
         System.debug('General Exception : '+e.getMessage());
     }
     return pref;
   }  
   
}