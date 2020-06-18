public class PassportRequestControllerExtension{
    
    private  Passport_Request__c passrequest;
    
    
    Passport_Request__c cloneableRequestForm = new Passport_Request__c();
    
    Integer AccountAllocationUSFlag = 0;
    Integer AccountAllocationEUFlag = 0;
    Integer AccountAllocationASIAFlag = 0;
    Integer CashRegionFlag = 0;
    Integer EUDestMSSectorsFlag = 0; 
    Integer EUDestEUOptFlag = 0;
    Integer EUDestFUDestFlag = 0;
    Integer EUCashDestFlag = 0;
    Integer USDestUsCashFlag = 0;
    Integer USDestBasicCanadaFlag = 0;
    Integer USDestOptFlag = 0;
    Integer USDestUSFutFlag = 0;
    Integer USDestCanFutFlag = 0;
    Integer CashOptFlag = 0;
    Integer EquitySwapFlag = 0;
    Integer FuturesSwapFlag = 0;
    Integer FutureFlag = 0;
    Integer EquityFlag = 0;
    Integer OptionsFlag = 0;
    Integer SpreadsFlag = 0; 
    Integer JapanFlag = 0;
    Integer HKSGAUFlag = 0;
    Integer AustraliaFLag = 0;
    Integer KoreaFlag = 0;
    Integer TaiwanFlag = 0;
    Integer IndiaFlag = 0;
    Integer BrokerMareketFlag = 0;
    Integer MalaysiaFlag = 0;
    Integer ThailandFlag = 0;
    Integer IndonesiaFlag = 0;
    Integer SingaporeFlag = 0;
    Integer HongkongFlag = 0;
    Integer AssetFlag = 0;
    Integer AllAsiaMarketFlag = 0;
    Integer SIMRSFERFlag = 0;    
    Integer NewIntegrationFlag = 0;
    Integer AP_Coverage_Person_Flag =0;
    Integer EU_Coverage_Person_Flag =0;
    Integer NA_Coverage_Person_Flag =0;
    Integer marketFlag=0;
   
    String User1 = '';
    String User2 = '';
    String User3 = '';
    String User4 = '';
    String User5 = '';
    String User6 = '';
    
    String TradeRegion = '';       
    String MSSector = '';
    String PageTitle;
    
    public boolean isGothamAccount = false;
    
     ApexPages.StandardController stdController; 
    public PassportRequestControllerExtension (ApexPages.StandardController stdController){
      this.passrequest=(Passport_Request__c)stdController.getRecord();
      this.passrequest.Logged_In_User__c = userinfo.getName();
      this.stdController = stdController;
      
      // singhrak, REQ3118951 , 26 Dec, 2014, Moved this block up to here, start
      String flowType = getParam('flow');
      if(flowType != null && flowType.equals('clone')){
      
          passrequest.Status__c = 'Submitted';          
          passrequest.Requested_By__c = UserInfo.getUserId();
          passrequest.Target_Date__c=null;
          passrequest.Request_Type__c=null;
          // singhrak, REQ2981632, 22 Nov, 2014
          passrequest.GothamAccountApproval__c = null;
          passrequest.Priority__c =null;
      }
      // singhrak, REQ3118951 , 26 Dec, 2014, Moved this block up to here, End
      
      calcTradeRegionValue();
      calcEUDestMSSector();
      calcUSDest();     
      calcEquitySwap();
      calcAsiaMarkets();
      calcAllAsiaMarket();
      calcRequestType();
      calcSingaporeAustralia();      
      
      calcCloneSetup();    
      checkMandatoryFuturesAccount();
      
      calcMandatoryField();
      calcshowUploadedaFileName();
      
      calcHKSFCChecked();
      showhideHKSFCCheckbox();
            calcetsDB();
            calcETSBSAction();
       calcAccount();
       
      if(passrequest.name == null)
      {
        PageTitle = '';
        passrequest.Algo__c = true;
        passrequest.DMA__C = true;
        passrequest.Market_Data_chkb__c = true;
        setDefaultForETSDB();
      }
      else
        PageTitle = passrequest.name;
        
      if(passrequest.Affiliate__c == null)                
          passrequest.Affiliate__c = 'No';      
      if(passrequest.Status__c == null)
          passrequest.Status__c = 'Submitted';
      if(passrequest.Requested_By__c == null)  
          passrequest.Requested_By__c = UserInfo.getUserId();       
            
          
      
      
      passrequest.EU_Equity_Single__c = 'Limits set by MSET';
        passrequest.EU_Equity_Cum__c = 'Limits set by MSET';
        calcEULimits();
        
        // singhrak, REQ3118951 , 26 Dec, 2014
        calcMandatoryFieldForHKSFC();        
        
        //25-may-16 REQ5529884 himanb (for all regions)         
        String urlStringName = ApexPages.currentPage().getUrl();
            if(urlStringName.length()>100){
            editValuesOnClick();
            }  
  }
    
    
    //25-may-16 REQ5529884 himanb (for all regions)       
    public void editValuesOnClick(){
    
     if(passrequest.Status__c == 'Complete'||passrequest.Status__c == 'Cancelled'){
                passrequest.Status__c = 'Submitted';
                passrequest.Target_Date__c=null;
                passrequest.Priority__c ='';
            
            }
    }
   
   public boolean otherUserList{get;set;} 
    
    /* singhrak,29Apr, 2015, REQ3724309, start */
  public void calcUserBBGUUID()
  {
    passrequest.User1_BBG_UUID1__c = passrequest.User1_BBG_UUID1__c; 
    passrequest.User2_BBG_UUID2__c = passrequest.User2_BBG_UUID2__c;
    passrequest.User3_BBG_UUID3__c = passrequest.User3_BBG_UUID3__c;
    passrequest.User4_BBG_UUID4__c = passrequest.User4_BBG_UUID4__c;
    passrequest.User5_BBG_UUID5__c = passrequest.User5_BBG_UUID5__c;
    passrequest.User6_BBG_UUID6__c = passrequest.User6_BBG_UUID6__c;
    passrequest.User7_BBG_UUID7__c = passrequest.User7_BBG_UUID7__c;
    passrequest.User8_BBG_UUID8__c = passrequest.User8_BBG_UUID8__c;
    passrequest.User9_BBG_UUID9__c = passrequest.User9_BBG_UUID9__c;
    passrequest.User10_BBG_UUID10__c = passrequest.User10_BBG_UUID10__c;
    if(passrequest.User_10__c!=null){
    
        otherUserList=true;
    }
  }
  /* singhrak,29Apr, 2015, REQ3724309, end */
    
    
    public void setDefaultForETSDB()
    {
        String flowType = getParam('flow');
        if(flowType == null)
        {
        passrequest.Priority_ETS__c = 'Medium';
        passrequest.EOD_Request_Type__c = 'New Setup';
        passrequest.Report_Type__c = 'Standard TC Giveup';
        passrequest.Business_Line__c = 'CLSITTRD';
        passrequest.Frequency_of_Report__c = 'Daily';
        passrequest.Commissions_fees_needed__c = 'No'; 
        passrequest.Need_unfilled_orders__c = 'No';
        passrequest.Aggregation_Level__c = 'Order';
        passrequest.List_of_Applications__c = 'RAZER';
        }
    }
    
    public void setCoveragePerson()
    {
        if(passrequest.Trade_Region__c!=null)
        {
         if(passrequest.Trade_Region__c.indexOf('North America') !=-1)
            passrequest.NA_Coverage_Person__c = passrequest.NA_Coverage_Person__c;
            
        if(passrequest.Trade_Region__c.indexOf('Pan-Asia') !=-1)
            passrequest.Asia_Pacific_Coverage_Person__c = passrequest.Asia_Pacific_Coverage_Person__c;
        
        if(passrequest.Trade_Region__c.indexOf('Europe') !=-1)
            passrequest.EU_Coverage_Person__c = passrequest.EU_Coverage_Person__c;      
        }
    
    }
    
    public Integer etsdbFlag {get;set;}
    
    public void calcetsDB()
    {
        etsdbFlag = 0;
    if(passrequest.Trade_Region__c!=null)
    {
        if(passrequest.Trade_Region__c == 'Pan-Asia' && passrequest.Asset_Class__c!=null)
        {
            String[] part;
            part = (String.valueOf(passrequest.Asset_Class__c)).split(';',0);
            for(String z:part)
            {
              if(z=='Equity' || z=='equity swaps')
                {
                etsdbFlag = 1;
                break;
                }
            }
                
        } 

           
           if(passrequest.Trade_Region__c.indexOf('North America')!=-1 && passrequest.US_Destination__c!= null && passrequest.US_Destination__c.indexOf('Basic US Cash Trader') !=-1)
               etsdbFlag = 1;
           
           if(passrequest.Trade_Region__c.indexOf('Europe')!=-1 && passrequest.EU_Destinations__c!=null && passrequest.EU_Destinations__c.indexOf('Basic EU Cash Destinations')!=-1)
               etsdbFlag = 1;
    }
     else
     etsdbFlag = 0;
    } 
    
    public Integer ETSBSActionFlag{get;set;}
    public void calcETSBSAction()
    {
        if(etsdbFlag == 1 && passrequest.Trigger_ETSDB_Report_form__c!= null && passrequest.Trigger_ETSDB_Report_form__c=='Yes')
        {
        ETSBSActionFlag = 1;
        } 
        else 
        ETSBSActionFlag = 0;
    }
    
    
    public void createETSDB()
    {
    Product_Request__c c = new Product_Request__c();
    c.Priority__c = passrequest.Priority_ETS__c;
    c.Request_Types__c = passrequest.EOD_Request_Type__c; 
    c.List_of_Applications__c = passrequest.List_of_Applications__c; 
    c.Report_Type__c =passrequest.Report_Type__c ;
    c.Regions__c = passrequest.Region__c;
    c.Business_Line__c = passrequest.Business_Line__c; 
    c.Run_Time__c = passrequest.Run_Time__c ;
    c.Delivery_Type__c = passrequest.Delivery_Type__c; 
    c.Frequency_of_Report__c =passrequest.Frequency_of_Report__c; 
    c.Email_recipients_OR_Client_contact__c = passrequest.Email_recipients_OR_Client_contact__c; 
    c.Commissions_fees_needed__c = passrequest.Commissions_fees_needed__c ;
    c.Need_unfilled_orders__c = passrequest.Need_unfilled_orders__c ;
    c.Aggregation_Level__c = passrequest.Aggregation_Level__c ;
    c.Requested_by__c =  passrequest.Requested_By__c;
    c.Fields_to_include__c = passrequest.Fields_to_include__c;
    c.MSET_Account__c = passrequest.MSET_Account__c;
//    c.Status = '';
    c.RecordTypeId = '01260000000LvYr';
    c.DisableTriggerFlag__c = true;
    insert  c;
    //c.DisableTriggerFlagLU__c='disable368';
    
    }
    
    
        public void calcDarkPoolCheckedFlag()
    {   
        if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Asset_Class__c !=null &&
        passrequest.Equity_Markets__c != null && passrequest.Equity_Markets__c.indexOf('Hong Kong') != -1 &&
        passrequest.Request_Type__c != null && passrequest.Request_Type__c.indexOf('New Integration') != -1 && passrequest.Name == null && passrequest.Status__c != null &&
        passrequest.Status__c == 'Submitted')
        {
                    
                    String[] part;
                    part = (String.valueOf(passrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity')
                         {
                            passrequest.Enable_for_HK_MSPool__c = true;
                            passrequest.Enable_for_HK_Trajectory_Cross__c = true;
                            break;
                         }
                         else
                         {
                            passrequest.Enable_for_HK_MSPool__c = false;
                            passrequest.Enable_for_HK_Trajectory_Cross__c = false;
                         }
                       }
           }
           else
           {
            if(passrequest.Name == null)
            {
             passrequest.Enable_for_HK_MSPool__c = false;
             passrequest.Enable_for_HK_Trajectory_Cross__c = false; 
            }
            
           }
               calcDisableDarkPoolControl(); //done on 3rd march
             calcMandatoryField();  
             
             if(passrequest.Equity_Markets__c!=null){   /*REQ5321074;kumvina;18Oct2016*/
                if(passrequest.Equity_Markets__c.indexOf('China A(Stock Connect)')!=1){
        
                    marketFlag=1;
                }else{
                    marketFlag=0;
                }
             }  /*REQ5321074;kumvina;18Oct2016 ;end*/
    }
    
    public void calcDisableDarkPoolControl()
    {
        if(passrequest.name != null)
        {// chk for status not null
            if(passrequest.Status__c != null && passrequest.Status__c!='Submitted')
              showUploadedaFileName = 1;
              else
              {
                          if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Asset_Class__c !=null &&
        passrequest.Equity_Markets__c != null && passrequest.Equity_Markets__c.indexOf('Hong Kong') != -1 &&
        passrequest.Request_Type__c != null && passrequest.Request_Type__c.indexOf('New Integration') != -1
        )
                {
                    String[] part;
                     part = (String.valueOf(passrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity')
                          {
                            showUploadedaFileName = 2;
                            break;
                          }
                          else
                            showUploadedaFileName = 1;
                       }    
                    
                }
                else
                   showUploadedaFileName = 1;
              }
        blockFileUploadFlag = 0;
        }
    }
    
    public Integer EULimitsFlag;
    public Integer getEULimitsFlag()
    {
        return EULimitsFlag;
    }
    
    public void calcEULimits()
    {
        if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Europe') != -1 &&
        passrequest.EU_Destinations__c != null && passrequest.EU_Destinations__c.indexOf('Basic EU Cash Destinations') != -1)
        {
            EULimitsFlag = 1;
        }
        else
           EULimitsFlag = 0;
    }    
    
    public Integer hksfcCheckedFlag;
    public void hksfcCheckedFlag()
    {
        
    }
    
    public Integer blockFileUploadFlag;
    public Integer getBlockFileUploadFlag()
    {
        return blockFileUploadFlag;
    }
    public Integer showUploadedaFileName;
    public Integer getshowUploadedaFileName()
    {
        return showUploadedaFileName;
    }
    public void calcshowUploadedaFileName()
    {
        String flowType = getParam('flow');
        if(passrequest.Name == null || (flowType != null && flowType == 'clone'))
        {
            blockFileUploadFlag = 1;
            showUploadedaFileName = 2; //whe 0, make it editable
        }
           
        else
        {
              if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Asset_Class__c !=null &&
        passrequest.Equity_Markets__c != null && passrequest.Equity_Markets__c.indexOf('Hong Kong') != -1 &&
        passrequest.Request_Type__c != null && passrequest.Request_Type__c.indexOf('New Integration') != -1
        )
        {
                            String[] part;
                             part = (String.valueOf(passrequest.Asset_Class__c)).split(';',0);
                               for(String z:part)
                               {
                                  if(z=='Equity')
                                  {
                                      showUploadedaFileName = 2;
                                      
                                      break;
                                  }
                                  else
                                    showUploadedaFileName = 1;
                               }
                                      
               } 
               else
               {
                showUploadedaFileName = 1; //read only
               } 
        blockFileUploadFlag = 0;     
        }
          
    }
    
    public Integer MandatoryFileUpload = 0;
    public Integer getMandatoryFileUpload()
    {
      return MandatoryFileUpload;
    }
    public void calcMandatoryField()
    {
        if(
          ((passrequest.Enable_for_HK_MSPool__c != null && passrequest.Enable_for_HK_MSPool__c == true)  
        || 
        (passrequest.Enable_for_HK_Trajectory_Cross__c != null && passrequest.Enable_for_HK_Trajectory_Cross__c == true))
        &&      
        (passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Asset_Class__c !=null &&
        passrequest.Equity_Markets__c != null && passrequest.Equity_Markets__c.indexOf('Hong Kong') != -1 &&
        passrequest.Request_Type__c != null && passrequest.Request_Type__c.indexOf('New Integration') != -1
        ) && passrequest.Name == null && passrequest.Status__c != null &&
        passrequest.Status__c == 'Submitted')
        {
                    String[] part;
                     part = (String.valueOf(passrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity')
                          {
                             MandatoryFileUpload = 1;
                             break;
                          }
                          else
                            MandatoryFileUpload = 0;
                          
                       }
        
        }
        else 
        MandatoryFileUpload = 0;
        
    }
    
    public String fileNameMy {get; set;}
    public Integer fileSizeDP {get; set;}  
    
    public Attachment document1 {
      get {
        if (document1 == null)
          document1 = new Attachment();
        return document1;
      }
      set;
    }
    
    
    public void attachUploadedFileInTicket(String id,String fileName)
    {
         document1.ParentId = id;
       document1.Name=fileName+ '(HK Dark Pool)';
       insert document1;
    }
    
    
    public void calcEquitymarkets()
    {
        calcDarkPoolCheckedFlag();
        calcHKSFCChecked();
    }
        
    public void calcHKSFCChecked()
    {  
        if(this.passrequest.MSET_Account__c!= null && passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Asset_Class__c != null && 
         passrequest.Request_Type__c != null && passrequest.Request_Type__c == 'New Integration' 
            && passrequest.Status__c != null && passrequest.Status__c == 'Submitted' && passrequest.Name == null)
        {   
                
                MSET_Account__c account = [select Asia_Trading_Desk_Country__c from MSET_Account__c where Id =: this.passrequest.MSET_Account__c];
                String asiaTrading  =  null;
                asiaTrading = account.Asia_Trading_Desk_Country__c;
                if(asiaTrading !=null )
                {  
                    if(asiaTrading == 'HONG KONG')
                    {
                            passrequest.Submit_Now__c = true;
                            hksfcMandatoryFlag = 1;
                    }
                    else
                    {   
                            calcWhenAsiaTradingNotHK();                
                    }
                }
                else if(asiaTrading == null)
                    {
                        calcWhenAsiaTradingNotHK();
                    }
                    else
                    {
                        setHKSFCCheckFalse();
                    }
        }
        else
        {
            if(passrequest.Name == null)
                setHKSFCCheckFalse();
        }
        
    }
    
    public void calcWhenAsiaTradingNotHK()
    {
        setHKSFCCheckFalse();
        if(passrequest.Asset_Class__c.indexOf('Equity') != -1)
                {    
                    if(passrequest.Equity_Markets__c != null && (passrequest.Equity_Markets__c.indexOf('Hong Kong') != -1   || passrequest.Equity_Markets__c.indexOf('Singapore')  != -1||  passrequest.Equity_Markets__c.indexOf('Korea')  != -1|| passrequest.Equity_Markets__c.indexOf('Taiwan') != -1 || 
                         passrequest.Equity_Markets__c.indexOf('Malaysia')  != -1|| passrequest.Equity_Markets__c.indexOf('Indonesia') != -1 || passrequest.Equity_Markets__c.indexOf('New Zealand')  != -1|| passrequest.Equity_Markets__c.indexOf('SI') != -1 || 
                          passrequest.Equity_Markets__c.indexOf('Thailand') != -1 ))
                        {
                            setHKSFCCheckTrue();    
                                     
                        }
                        
                }
                if(passrequest.Asset_Class__c.indexOf('Futures') != -1)
                {
                    if(passrequest.Futures_Markets__c != null && (passrequest.Futures_Markets__c.indexOf('Hong Kong') != -1 || passrequest.Futures_Markets__c.indexOf('Singapore')  != -1||  passrequest.Futures_Markets__c.indexOf('Korea')  != -1|| passrequest.Futures_Markets__c.indexOf('Taiwan') != -1 || 
                         passrequest.Futures_Markets__c.indexOf('Malaysia')  != -1|| passrequest.Futures_Markets__c.indexOf('Indonesia') != -1 || passrequest.Futures_Markets__c.indexOf('New Zealand')  != -1|| passrequest.Futures_Markets__c.indexOf('SI') != -1 || 
                          passrequest.Futures_Markets__c.indexOf('Thailand') != -1 ))
                        {
                            setHKSFCCheckTrue();    
                             
                        }
                       
                }
                if(passrequest.Asset_Class__c.indexOf('Options') != -1)
                {
                
                    if(passrequest.Options_Markets__c != null && (passrequest.Options_Markets__c.indexOf('Hong Kong') != -1 || passrequest.Options_Markets__c.indexOf('Singapore')  != -1||  passrequest.Options_Markets__c.indexOf('Korea')  != -1|| passrequest.Options_Markets__c.indexOf('Taiwan') != -1 || 
                         passrequest.Options_Markets__c.indexOf('Malaysia')  != -1|| passrequest.Options_Markets__c.indexOf('Indonesia') != -1 || passrequest.Options_Markets__c.indexOf('New Zealand')  != -1|| passrequest.Options_Markets__c.indexOf('SI') != -1 || 
                          passrequest.Options_Markets__c.indexOf('Thailand') != -1 ))
                        {
                            setHKSFCCheckTrue();             
                        }
                    
                }
                if(passrequest.Asset_Class__c.indexOf('Spreads') != -1)
                {
                    if(passrequest.Spreads_Markets__c != null && (passrequest.Spreads_Markets__c.indexOf('Hong Kong') != -1 || passrequest.Spreads_Markets__c.indexOf('Singapore')  != -1||  passrequest.Spreads_Markets__c.indexOf('Korea')  != -1|| passrequest.Spreads_Markets__c.indexOf('Taiwan') != -1 || 
                         passrequest.Spreads_Markets__c.indexOf('Malaysia')  != -1|| passrequest.Spreads_Markets__c.indexOf('Indonesia') != -1 || passrequest.Spreads_Markets__c.indexOf('New Zealand')  != -1|| passrequest.Spreads_Markets__c.indexOf('SI') != -1 || 
                          passrequest.Spreads_Markets__c.indexOf('Thailand') != -1 ))
                        {
                            setHKSFCCheckTrue();             
                        }
                    
                }
                
       }
    
    
    public void setHKSFCCheckTrue()
    {
        passrequest.Submit_Now__c = true ;
        hksfcMandatoryFlag = 1;
    }
    
    public void setHKSFCCheckFalse()
    {
        passrequest.Submit_Now__c = false ;
        hksfcMandatoryFlag = 0;
    }
    
    
    Integer hksfcMandatoryFlag;
    public Integer getHksfcMandatoryFlag()
    {
        return hksfcMandatoryFlag;
    }
    
    public void calcStatus()
    {
        calcHKSFCChecked();
    }
    
    public Integer hksfcFlag;
    
    public Integer getHksfcFlag(){
        return hksfcFlag;
    }
    public void showhideHKSFCCheckbox()
    {
        String flowType = getParam('flow');
        if(passrequest.Name == null || (flowType != null && flowType == 'clone'))
        {
            hksfcFlag = 1;
        }
        else
            hksfcFlag = 0;
    }
    
    public void calcMandatoryFieldForHKSFC()
    {
        //calcHKSFCChecked();
        if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Request_Type__c!= null && passrequest.Request_Type__c=='New Integration'
        && passrequest.Asset_Class__c!= null && (passrequest.Asset_Class__c.indexOf('Equity') != -1 || passrequest.Asset_Class__c.indexOf('Futures') != -1 || 
        passrequest.Asset_Class__c.indexOf('Spreads') != -1 || passrequest.Asset_Class__c.indexOf('Options') != -1) && passrequest.Name==null &&
        passrequest.Submit_Now__c == true)
        {
            hksfcMandatoryFlag = 1;
        }
        else
        {
            hksfcMandatoryFlag = 0;
        }
        
    }
    
        public Attachment document2 {
      get {
        
        if (document2 == null)
          document2 = new Attachment();
        return document2;
      }
      set;
    }
    
        public void attachUploadedFileInTicketHKSFC(String id)
    {
       document2.ParentId = id;
       document2.Name= document2.Name+'(HK SFC)';
       insert document2;
    }
    
    
    public boolean getIsGothamAccount()
    {
    return this.isGothamAccount;
    }
    public void calcAccount()
    {  
        /* Start Code Changes For REQ2981632 by Sudarshan Kadam - 13/11/2014 */  
        isGothamAccount = false;
        if(passrequest.MSET_Account__c != null){
            List<MSET_Account__c> lstAcc = [SELECT Name FROM MSET_Account__c WHERE Name = 'GOTHAM ASSET MANAGEMENT (NEW YORK)' LIMIT 1];
            String accountId = passrequest.MSET_Account__c;
            if(!lstAcc.isEmpty()){
                if(accountId.equalsIgnoreCase(lstAcc[0].Id))
                isGothamAccount = true; 
            }
        }
        /* End Code */
        
        calcHKSFCChecked();
    }
    
    
      public Boolean checkFileValidations()
  {
      // For REQ1042945 , FIle upload
       Boolean result = false;
       
       Integer uploadcriteria = 0;
        if( (passrequest.Enable_for_HK_MSPool__c == true  || passrequest.Enable_for_HK_Trajectory_Cross__c == true)
                && passrequest.Status__c != null && passrequest.Status__c == 'Submitted' && passrequest.Asset_Class__c != null &&
                 passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Equity_Markets__c != null && 
                 passrequest.Equity_Markets__c.indexOf('Hong Kong') != -1 &&
        passrequest.Request_Type__c != null && passrequest.Request_Type__c.indexOf('New Integration') != -1) 
          {
                    String[] part;
                     part = (String.valueOf(passrequest.Asset_Class__c)).split(';',0); 
                       for(String z:part)
                       {
                          if(z=='Equity') 
                          {
                            uploadcriteria = 1;
                              if((fileNameMy == '' || fileNameMy == null) && passrequest.name == null)
                              {
                                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: If either/both the checkbox are selected in HK \'Dark Pool\' section then it is mandatory to upload file.');
                                    ApexPages.addMessage(myMsg);
                                    result = true;
                                    break;
                              }
                
                          }
                       }
                       
                       if(uploadcriteria == 0 && passrequest.name == null && fileNameMy != null)
                       {
                       //      if(passrequest.Enable_for_HK_MSPool__c == false  && passrequest.Enable_for_HK_Trajectory_Cross__c == false)
                                 {// 
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: The criteria needed to upload the file in HK Dark Pool section are not met.');
                                  ApexPages.addMessage(myMsg);
                                  fileNameMy = null;
                                  document1.body = null;
                                  result = true;
                                 }
                       }
          
        }
        else
        {
                if(uploadcriteria == 0 && passrequest.name == null && fileNameMy != null)
                       {
                       //      if(passrequest.Enable_for_HK_MSPool__c == false  && passrequest.Enable_for_HK_Trajectory_Cross__c == false)
                                 {// 
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: The criteria needed to upload the file are not met.');
                                  ApexPages.addMessage(myMsg);
                                  fileNameMy = null;
                                  document1.body = null;
                                  result = true;
                                 }
                       }
        }
        
        
        Integer hksfc = 0;
        if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Request_Type__c!= null && passrequest.Request_Type__c=='New Integration'
        && passrequest.Asset_Class__c!= null && (passrequest.Asset_Class__c.indexOf('Equity') != -1 || passrequest.Asset_Class__c.indexOf('Futures') != -1 || 
        passrequest.Asset_Class__c.indexOf('Spreads') != -1 || passrequest.Asset_Class__c.indexOf('Options') != -1) && passrequest.Name==null &&
        passrequest.Submit_Now__c == true)
/*        
            if(passrequest.Set_up_type__c != null && (passrequest.Set_up_type__c == 'New Client Setup' || passrequest.Set_up_type__c == 'Modify Client Setup')
                && passrequest.Asset_Class__c != null && (passrequest.Asia_Pacific_Flow_Details__c != null && 
        (passrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || passrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) )
        && passrequest.Name == null
        ) 
  */    {           hksfc = 1;
                               if(document2.name == null)
                               {
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: If HKSFC checkbox is checked, its mandatory to upload file.');
                                  ApexPages.addMessage(myMsg);
                                  document2.body = null;
                                  document2.name = null;
                                  result = true;
                               }   
                                  
                  }
                   
                        
          if(hksfc == 0 && document2.name != null && passrequest.Name == null)
                       {
                       //      if(passrequest.Enable_for_HK_MSPool__c == false  && passrequest.Enable_for_HK_Trajectory_Cross__c == false)
                                 {// 
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: The criteria needed to upload the HK SFC file are not met.');
                                  ApexPages.addMessage(myMsg);
                                  document2.body = null;
                                  document2.name = null;
                                  result = true;
                                 }
                       }
                       
      return result;
     
  }
  
  public void sendEmailto_hksfc(String id)
  {
        try {
       
       
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          String[] toAddresses = new String[] {'hketregs@morganstanley.com.test','asiaonboarding@morganstanley.com.test'};
          mail.setToAddresses(toAddresses);
         //mail.setTargetObjectId(UserInfo.getUserId());
          mail.setSaveAsActivity(false);
          
          Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[1];
          Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
          fileAttachment.setBody(document2.body);
          fileAttachment.setFileName(document2.name);
          //fileAttachment.setFileName('AA');
//          fileattachment.setContentType(document.ContentType);
          fileAttachments[0] = fileAttachment;
       
          
          mail.setFileAttachments(fileAttachments);
         Passport_Request__c  passreq = [select Name,Requested_By__r.name,MSET_Account__r.name,MSET_Account__r.TNL_ID__c from Passport_Request__c  where Id = :id ];
          mail.setSubject(passreq.MSET_Account__r.TNL_ID__c + '  ? HK SFC Attestation received' );
          mail.setHtmlBody('Passport request No.'+passreq.Name+'<br></br>'+
          //'Requestor: '+ UserInfo.getUserEmail()+'<br></br>'
          'Requestor: '+ passreq.Requested_By__r.name+'<br></br>'
          + 'Date/Time: '+System.now()   );
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       
     } catch (DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
        System.debug('Exceptionmykljj::'+e);
      } finally {
        document2.body = null; // clears the viewstate
        document2 = new Attachment();
      }
  }
  
  public void sendEmailto_mshkats(String id)
  {
        try {
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {'mshkats@morganstanley.com.test','asiaonboarding@morganstanley.com.test'};
          mail.setToAddresses(toAddresses);
     //     mail.setTargetObjectId(UserInfo.getUserId());
          mail.setSaveAsActivity(false);
          
          Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[1];
          Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
          fileAttachment.setBody(document1.body);
          fileAttachment.setFileName(fileNameMy);
          //fileAttachment.setFileName('AA');
//          fileattachment.setContentType(document.ContentType);
          fileAttachments[0] = fileAttachment;
          
          mail.setFileAttachments(fileAttachments);
          String[] emailContent = getEmailBodyFor_mshkats(id);
          mail.setHtmlBody(emailContent[0]);
          mail.setSubject('MSHK Type 7 consent ? '+emailContent[1]);
          //mail.setSubject('Testing ..plz ignore');
          //mail.setPlainTextBody('Hi <br></br> Testing please ignore');
          
          //mail.setDocumentAttachments(document);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       
     } catch (DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
        System.debug('Exceptionmykljj::'+e);
   //    return null;
      } finally {
        document1.body = null; // clears the viewstate
        document1 = new Attachment();
      }
//      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
   //   return null;
  }
    
    public String[] getEmailBodyFor_mshkats(String id)
    {
      Passport_Request__c  passprodreq = [select Requested_By__r.name, Name, MSET_Account__r.name,MSET_Account__r.TNL_ID__c from Passport_Request__c  where Id = :id ];
      String str='Passport Request No.: '+ passprodreq.Name + '<br></br>' +
          'Account: '+ passprodreq.MSET_Account__r.name + '<br></br>' +
          'A2 TNL ID: ' + passprodreq.MSET_Account__r.TNL_ID__c + '<br></br>' +
          'Requested by: ' + passprodreq.Requested_By__r.name  + '<br></br><br></br>';
      
      String []emailContent= new String[]{str,passprodreq.MSET_Account__r.TNL_ID__c};
      return emailContent;
    }
    
    
    
     public Integer getMarketFlag(){ /*REQ5321074;kumvina;18Oct2016*/
    
        return this.MarketFlag;
    }
    
    public Integer getEUDestMSSectorsFlag()
    {
            return this.EUDestMSSectorsFlag;
    }
    
    public Integer getAccountAllocationUSFlag()
    {
            return this.AccountAllocationUSFlag;
    }
    
    public Integer getAccountAllocationEUFlag()
    {
            return this.AccountAllocationEUFlag;
    }
           
    
    public Integer getAccountAllocationASIAFlag()
    {
            return this.AccountAllocationASIAFlag;
    }
    
    public Integer getCashRegionFlag()
    {
            return this.CashRegionFlag;
    }
    
    public Integer getEUDestEUOptFlag()
    {
            return this.EUDestEUOptFlag;
    }
    
    public Integer getEUDestFUDestFlag()
    {
            return this.EUDestFUDestFlag;
    }
    
    public Integer getEUCashDestFlag()
    {
            return this.EUCashDestFlag;
    }
    
    public Integer getUSDestUsCashFlag()
    {
           return this.USDestUsCashFlag;
    }
    
    public Integer getUSDestBasicCanadaFlag()
    {
           return this.USDestBasicCanadaFlag;
    }    
    
    public Integer getUSDestOptFlag()
    {
           return this.USDestOptFlag;
    }
    
    public Integer getUSDestUSFutFlag()
    {
           return this.USDestUSFutFlag;
    }
    
    public Integer getUSDestCanFutFlag()
    {
           return this.USDestCanFutFlag;
    }
     
    public Integer getCashOptFlag()
    {
            return this.CashOptFlag;
    } 
    
    public Integer getEquityFlag()
    {
            return this.EquityFlag;
    }
    
    public Integer getOptionsFlag()
    {
            return this.OptionsFlag;
    }
    
    public Integer getSpreadsFlag()
    {
            return this.SpreadsFlag;
    }
        
    public Integer getEquitySwapFlag()
    {
            return this.EquitySwapFlag;
    }
    
    public Integer getFuturesSwapFlag()
    {
            return this.FuturesSwapFlag;
    }    
    
    public Integer getFutureFlag()
    {
            return this.FutureFlag;
    }
    
    public Integer getKoreaFlag()
    {
            return this.KoreaFlag;
    }
    
    public Integer getTaiwanFlag()
    {
            return this.TaiwanFlag;
    }
    
    public Integer getIndiaFlag()
    {
            return this.IndiaFlag;
    }
    
    public Integer getAssetFlag()
    {
            return this.AssetFlag;
    }
    
    public Integer getJapanFlag()
    {
            return this.JapanFlag;
    }
    
    public Integer getHKSGAUFlag()
    {
            return this.HKSGAUFlag;
    }
    
    public Integer getAustraliaFLag()
    {
            return this.AustraliaFLag;
    }
    
    public Integer getBrokerMareketFlag()
    {
            return this.BrokerMareketFlag;
    }
    
    public Integer getMalaysiaFlag()
    {
            return this.MalaysiaFlag;
    }
    
    public Integer getThailandFlag()
    {
            return this.ThailandFlag;
    }
    
    public Integer getIndonesiaFlag()
    {
            return this.IndonesiaFlag;
    }
    
    public Integer getSingaporeFlag()
    {
            return this.SingaporeFlag;
    }
    
    public Integer getHongkongFlag()
    {
            return this.HongkongFlag;
    }
    
    public Integer getAllAsiaMarketFlag()
    {
            return this.AllAsiaMarketFlag;
    }
    
    public Integer getSIMRSFERFlag()
    {
            return this.SIMRSFERFlag;
    }    
    
    public Integer getNewIntegrationFlag()
    {
            return this.NewIntegrationFlag;
    }
                
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }
    
    public String getTradeRegion()
    {
            return this.TradeRegion;
    }
    
    public String getPageTitle()
    {
          return this.PageTitle;
    }
    
    public Integer getNA_Coverage_Person_Flag() {
        return NA_Coverage_Person_Flag;
    }
    
    public Integer getEU_Coverage_Person_Flag() {
        return EU_Coverage_Person_Flag;
    }
 
    public Integer getAP_Coverage_Person_Flag() {
        return AP_Coverage_Person_Flag;
    }

    
    public Passport_Request__c editRequest { get; set; }
    
    public Passport_Request__c getRequests()
    {
        return [Select Requested_By__c from Passport_Request__c where Id=:passrequest.Id];
    }
    
    public pagereference save() {
    
        PageReference pageRef = ApexPages.currentPage();
        String flowType = pageRef.getParameters().get('flow');
        
        if(flowType != null && flowType.equals('clone')) {
            return this.cloneForm();
        }
        
        /*REQ4028716, gupankur,3July,2015, start */
        if((passrequest.FID__c || passrequest.IED_FID__c) && passrequest.Passport_Bloomberg_Setup__c=='Yes' && passrequest.Trade_Region__c.contains('North America')){
            passrequest.Marketdata_Entitlements__c= passrequest.Market_Data_Entitlement__c;
            system.debug('*** passrequest.Marketdata_Entitlements__c '+ passrequest.Marketdata_Entitlements__c);    
        }
        
        /*REQ4028716, gupankur,3July,2015, end */
       
        if(AccountAllocationUSFlag != 1)
        {
            passrequest.Domestic_Oasys_Booking__c=null;
            passrequest.Single_Options_Account_Booking__c='';
            passrequest.Single_Account_Booking__c='';
            passrequest.Multiple_Accounts__c='';
            passrequest.Futures_Account__c='';
            passrequest.Allocation_Button__c=false;
            
            passrequest.US_Destination__c=null;
            passrequest.Trade_US_as_SWAP__c=null;
            passrequest.CFM_Limits_US_CASH__c=null;
            passrequest.CFM_Limits_SA_CASH__c=null;
            passrequest.Futures_US__c=null;
            passrequest.Options_US__c=null;            
        }
        
        if(AccountAllocationEUFlag != 1)
        {
            passrequest.Auto_Allocation_EUR__c='';
            passrequest.Auto_Allocation_UKM__c='';
            passrequest.Auto_Allocation_USD__c='';
            passrequest.Futures_Acct__c='';
            passrequest.Options_Acct__c='';

            passrequest.EU_Destinations__c=null;
            passrequest.Enable_Index_Swaps_EU_Only__c=null;
            passrequest.Trade_UK_as_Swap__c=null;
            passrequest.Trade_EUROPE_as_Swap__c=null;
            passrequest.CFM_Limits_EU_cash__c=null;
            passrequest.Equity_Futures_EU__c=null;
            passrequest.Fid_Futures_EU__c=null;
            passrequest.Options_EU__c=null;
            passrequest.Market_Watch_Lists__c=null;
            passrequest.Watchlists__c='';
            passrequest.Mailing_Lists__c=null;
        }
        
        if(AccountAllocationASIAFlag != 1)
        {
            passrequest.Depending_On__c=null;
            
            passrequest.Asia_Pacific_Markets__c=null;
                                    
            passrequest.Asset_Class__c=null;
            passrequest.Market_Data_chkb__c=false;
            passrequest.Japan__c=false;
            passrequest.India__c=false;
            passrequest.HongKong__c=false;
            passrequest.Korea__c=false;
            passrequest.Singapure__c=false;
            passrequest.Taiwan__c=false;
            passrequest.Australia__c=false;                                    
                                               
            passrequest.Algo__c=false;
            passrequest.DMA__c=false;
                        
            passrequest.Drop_Down__c='';
            passrequest.Dropdown_accounts_for_Taiwan_Cash__c='';
            passrequest.JP_Trade_Limit_Cash__c=null;
            passrequest.JP_Trade_Limit_FUT__c=null;
            passrequest.JP_Trade_Limit_OPT__c=null;
            passrequest.JP_Trade_Limit_Spread__c=null;
            passrequest.NJA_Trade_Limit_Cash__c=null;
            passrequest.NJA_Trade_Limit_FUT__c=null;
            passrequest.NJA_Trade_Limit_OPT__c=null;
            passrequest.NJA_Trade_Limit_Spread__c=null;          
            passrequest.Additional_Market_Limits_Requirements__c='';
            
                        
            passrequest.GUI_dropdown_Accounts_for_SIMR_SFER__c='';
                        
            passrequest.AsiaEtsClients_Integrator__c=null;            
            passrequest.Email_mset_fe__c=false;
            
        }
        
          if(passrequest.Mset_Futures__c == true)
            passrequest.Mirror_Id_msetfutemail__c = 'mset-futures-user1@morganstanley.com.test' ;
          else
            passrequest.Mirror_Id_msetfutemail__c = '' ;
            
            
         boolean pageReferenceAction = processRequest(passrequest);
         System.debug('Validation result:'+pageReferenceAction);
         if(pageReferenceAction){
            return null;
         }

       return (new ApexPages.StandardController(passrequest)).view();  
    }
    
    public boolean processRequest(Passport_Request__c passrequestRef){
        this.passrequest = passrequestRef;
        
        Boolean fileCheckResult = checkFileValidations();
        
        Database.UpsertResult upResult;
        if(fileCheckResult)
        {// file validation
          return true;
        }
        
        try{
            upResult =  Database.upsert(passrequest);
            //REQ5266683, kumvina 24May2016 Start
                // if(upResult!=null && upResult.isCreated() && passrequest.Comments_US_Limits_Information__c != null && passrequest.Comments_US_Limits_Information__c.length()>=1)
                //  createLimitRecord();
            //REQ5266683, kumvina 24May2016 end
                
           if(upResult!=null && upResult.isCreated() && ETSBSActionFlag==1)
                createETSDB();  
            
            if(fileNameMy != null && upResult.Id != null)
            {
                if(passrequest.Status__c != null && passrequest.Status__c == 'Submitted' &&
                 passrequest.Asset_Class__c != null &&  passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Asset_Class__c !=null &&
        passrequest.Equity_Markets__c != null && passrequest.Equity_Markets__c.indexOf('Hong Kong') != -1 &&
        passrequest.Request_Type__c != null && passrequest.Request_Type__c.indexOf('New Integration') != -1)
                  {
                    String[] part;
                     part = (String.valueOf(passrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity')
                          {
                            attachUploadedFileInTicket(upResult.Id,fileNameMy);
                            sendEmailto_mshkats(upResult.Id);
                              break;
                            }
                       }
                  }
            } 

        if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('Pan-Asia') != -1 && passrequest.Request_Type__c!= null && passrequest.Request_Type__c=='New Integration'
        && passrequest.Asset_Class__c!= null && (passrequest.Asset_Class__c.indexOf('Equity') != -1 || passrequest.Asset_Class__c.indexOf('Futures') != -1 || 
        passrequest.Asset_Class__c.indexOf('Spreads') != -1 || passrequest.Asset_Class__c.indexOf('Options') != -1) && passrequest.Name==null &&
        passrequest.Submit_Now__c == true)                  {
                  {
                            if(document2.name != null)
                            {
                                attachUploadedFileInTicketHKSFC(upResult.Id);
                                sendEmailto_hksfc(upResult.Id); 
                            }
                  }
        }

        if(document4.name != null && (USDestUSFutFlag==1 || USDestOptFlag==1 || USDestCanFutFlag==1) && upResult.Id != null)
            attachUploadedFileInTicketNALimit(upResult.Id);
        
        if(document5.name != null && (USDestUSFutFlag==1 || USDestOptFlag==1 || USDestCanFutFlag==1) && upResult.Id != null)
            attachUploadedFileInTicketEULimit(upResult.Id);
        
        }
        catch(System.DMLException e) {
           ApexPages.addMessages(e);
          return true;
       }  
        
        if (passrequest.NA_Coverage_Person__c != null || passrequest.EU_Coverage_Person__c !=null || passrequest.Asia_Pacific_Coverage_Person__c !=null)
       {
        sendMailtoCoveragePerson();
       }
       
        /* REQ3754284, singhrak, 4may, 2015 start*/
       if(passrequest.Passport_Bloomberg_Setup__c == 'Yes')
       {
        sendEmailToPassportProducts();
       }
       
       /* REQ3754284, singhrak, 4may, 2015 end*/
       
        return false;
    }
    
      /* REQ3754284, singhrak, 4may, 2015 start*/
    public void sendEmailToPassportProducts()
    {
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
         /* REQ4187866, gupankur, 04 Aug, 2015 start*/
         //email.setTargetObjectId('00560000002ST5T');// '00560000002ST5T' Anthony Colangelo Prod
         email.setTargetObjectId('00530000000emPp'); // '00530000000emPp' SFDC Admin user 
         /* REQ4187866, gupankur, 04 Aug, 2015 end*/
         String [] to = new String[] {'scott.barry@morganstanley.com.test','owain.stone@morganstanley.com.test','shawn.lobo@morganstanley.com.test'};
         email.setToAddresses(to);
         email.setWhatId(passrequest.Id);
         Id templateId = [select id, name from EmailTemplate where developername = 'VF_template_leap_desk_new_passport'].Id;
         email.setTemplateId(templateId);
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    } 
    
    /* REQ3754284, singhrak, end*/
    
    public void createLimitRecord()
    {
    Limit_Update__c lu=new Limit_Update__c();
    lu.MSET_Account__c = passrequest.MSET_Account__c;
    lu.Comments__c = passrequest.Comments_US_Limits_Information__c;
    lu.Reason_for_Change__c = passrequest.Reason_for_Change__c;
    lu.Requested_By__c = passrequest.Requested_By__c;
    lu.DisableTriggerFlagLU__c='disable368';
//  lu.Send_Email_To__c = 'Email to logged In User';
    Database.Upsertresult ur =Database.upsert(lu);
    
     if (ur.id!= null)
       {
        sendMailto(ur.id);
       }
    }
     
    public void sendMailto(String whatId) 
   {
         Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
         EmailTemplate template=[Select Id, Name, DeveloperName from EmailTemplate where DeveloperName='VF_Template_for_Dynamic_Limit_Update'];
         email.setTargetObjectId(passrequest.Requested_By__c);
         email.setCcAddresses(new String[]{'mset-limitcontrol@morganstanley.com.test',passrequest.NA_Coverage_Person__c});
         email.setWhatId(whatId);
         email.setTemplateId(template.id);//qa - 00XT0000000nPqi  prod - 00X600000017JpF
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
   }
    
    
    
   public PageReference sendMailtoCoveragePerson() 
   {
    String[] toAddresses1 = new list<String>();
     if(passrequest.NA_Coverage_Person__c != null)
      {
         toAddresses1.add(passrequest.NA_Coverage_Person__c);
      }
      if(passrequest.EU_Coverage_Person__c != null)
      {
        toAddresses1.add(passrequest.EU_Coverage_Person__c);
      }
      if(passrequest.Asia_Pacific_Coverage_Person__c != null)
      {
        toAddresses1.add(passrequest.Asia_Pacific_Coverage_Person__c);
      }
      if(passrequest.Requested_By__c == null)  
       {
        passrequest.Requested_By__c = UserInfo.getUserId();
       }
          
          if(
(document4.name != null && (USDestUSFutFlag==1 || USDestOptFlag==1 || USDestCanFutFlag==1))
||
(document5.name != null && (USDestUSFutFlag==1 || USDestOptFlag==1 || USDestCanFutFlag==1))
){
    toAddresses1.add('mset-futures@morganstanley.com.test');

}
    // Added for TASK5754536
    /*if(EquityFlag == 1 || EquitySwapFlag == 1 || OptionsFlag == 1 || SpreadsFlag == 1 || FutureFlag == 1 || FuturesSwapFlag == 1){
      toAddresses1.add('Mandy.Zhang1@ms.com.test');
      toAddresses1.add('Jennifer.Wu@ms.com.test');  
    }*/

        if(isGothamAccount)
            toAddresses1.add('rtquant-ext@morganstanley.com.test');
          
          
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
         email.setTargetObjectId(passrequest.Requested_By__c);//passrequest.RequestedBy__c);
         email.setCcAddresses(toAddresses1);
         email.setWhatId(passrequest.Id);
         email.setTemplateId('00X600000017Brp');//qa - 00XT0000000nJ2Z prod - 00X600000017Brp
         email.saveAsActivity = false;
         
         Integer numOfAtatchments = 0;
            
            if(document4.Name != null)
            {
                numOfAtatchments++;
            }
            
            if(document5.Name != null)
            {
                numOfAtatchments++;
            }
          Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[numOfAtatchments];
          
          Integer index=0;
          if(document4.Name != null)
          {
          Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
          fileAttachment.setBody(document4.body);
          fileAttachment.setFileName(document4.name);
          fileAttachments[index] = fileAttachment;
          index++;
          }
          
          if(document5.Name != null)
          {
          Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
          fileAttachment.setBody(document5.body);
          fileAttachment.setFileName(document5.name);
          fileAttachments[index] = fileAttachment;
          index++;
          }
          
          if(document4.Name != null || document5.Name != null)
          email.setFileAttachments(fileAttachments);
         
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     
     return null;
      
   }
    
   public PageReference editRequestedBy() {
        String editid = getParam('editid');
        editRequest = [SELECT Requested_By__c FROM Passport_Request__c WHERE Id=:editid];
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
       calcTradeRegionValue();
       calcEUDestMSSector();
       calcUSDest();
       calcEquitySwap();
       calcAsiaMarkets();
       calcAllAsiaMarket();
       calcRequestType();
       calcHKSFCChecked();
       calcetsDB();
       return null;
   }                  
   public void calcTradeRegionValue(){
    
        TradeRegion=passrequest.Trade_Region__c;
                        
        if(TradeRegion!=null)
        {
            if(TradeRegion.indexOf('North America')!=-1)
                 {
                    AccountAllocationUSFlag = 1;
                    NA_Coverage_Person_Flag = 1;
                 }
            else
            {
                 AccountAllocationUSFlag = 0;
                 USDestBasicCanadaFlag = 0;
                 USDestUsCashFlag = 0;
                 USDestOptFlag = 0;
                 USDestUSFutFlag=0;
                 USDestCanFutFlag=0;
                 NA_Coverage_Person_Flag = 0;
            }
            if(TradeRegion.indexOf('Europe')!=-1)
                 {
                    AccountAllocationEUFlag = 1;
                    EU_Coverage_Person_Flag = 1;
                 }
            else
            {    
                 AccountAllocationEUFlag = 0; 
                 EU_Coverage_Person_Flag = 0; 
                 EUDestMSSectorsFlag = 0;
                 EUDestEUOptFlag = 0;
                 EUDestFUDestFlag = 0;
                 EUCashDestFlag = 0;
            }
            if(TradeRegion.indexOf('Pan-Asia')!=-1)
                {
                     AccountAllocationASIAFlag = 1;
                     AP_Coverage_Person_Flag = 1;
                }
            else
            {
                 AP_Coverage_Person_Flag = 0;
                 AccountAllocationASIAFlag = 0;  
                 EquitySwapFlag = 0;
                 FuturesSwapFlag = 0;
                 FutureFlag = 0;
                 KoreaFlag = 0;
                 TaiwanFlag = 0;
                 IndiaFlag = 0;
                 AssetFlag = 0;
                 SIMRSFERFlag=0;
                 JapanFlag = 0;
                 HKSGAUFlag = 0;
                 AustraliaFlag = 0;
                 EquityFlag = 0;
                 OptionsFlag = 0;
                 SpreadsFlag = 0;
                 BrokerMareketFlag = 0;
                 MalaysiaFlag = 0;
                 ThailandFlag = 0;
                 IndonesiaFlag = 0;
                 SingaporeFlag = 0;
                 HongkongFlag = 0;
                 AllAsiaMarketFlag = 0;
                 
            } 
            if(TradeRegion.indexOf('North America')!=-1 || TradeRegion.indexOf('Europe')!=-1)       
            {
                 CashRegionFlag = 1;
            }  
            else
            {
                 CashRegionFlag = 0;
                 CashOptFlag = 0;
            }
        }
        
        else
       {
               AccountAllocationUSFlag = 0;
               AccountAllocationEUFlag = 0;
               AccountAllocationASIAFlag = 0;
               CashRegionFlag = 0;
               EUDestMSSectorsFlag = 0;
               EUDestEUOptFlag = 0;
               EUDestFUDestFlag = 0;
               EUCashDestFlag = 0;
               USDestBasicCanadaFlag = 0;
               USDestUsCashFlag = 0;
               USDestOptFlag = 0;
               USDestUSFutFlag=0;
               USDestCanFutFlag=0;
               CashOptFlag = 0;
               EquitySwapFlag = 0;
               FuturesSwapFlag = 0;
               FutureFlag = 0;
               KoreaFlag = 0;
               TaiwanFlag = 0;
               IndiaFlag = 0;
               AssetFlag = 0;
               JapanFlag = 0;
               HKSGAUFlag = 0;
               AustraliaFlag = 0;
               EquityFlag = 0;
               OptionsFlag = 0;
               SpreadsFlag = 0;
               BrokerMareketFlag = 0;
               MalaysiaFlag = 0;
               ThailandFlag = 0;
               IndonesiaFlag = 0;
               SingaporeFlag = 0;
               HongkongFlag = 0;
               AllAsiaMarketFlag = 0;
               AP_Coverage_Person_Flag = 0;
               EU_Coverage_Person_Flag = 0;
               NA_Coverage_Person_Flag = 0;
               
               
               Clone_Setup_Flag = 0;
               passrequest.Clone_Setup__c = '';
       }
       
        if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c == 'Pan-Asia')
           {
            Clone_Setup_Flag = 0;
            passrequest.Clone_Setup__c = '';
           }
               
       calcRequestType();
      checkForRequestType();   
   //   if(Clone_Setup_Flag==1 || AccountAllocationUSFlag ==1 || AccountAllocationEUFlag == 1)
     //   calcCloneSetup();   
      
        
//   Suppose we have selected EU,NA region, US Destination it will show limits,buit when remove NA limit section heading is still visible.
        calcUSDest();    
        calcHKSFCChecked();
               calcEULimits();
      calcetsDB();         
    }

        

    public Attachment document4 {
      get {
        if (document4 == null)
          document4 = new Attachment();
        return document4;
      }
      set;
    }
    
    public Attachment document5 {
      get {
        if (document5 == null)
          document5 = new Attachment();
        return document5;
      }
      set;
    }

    public void attachUploadedFileInTicketNALimit(String id)
    {
       document4.ParentId = id;
       document4.Name= document4.Name+'(NA Limits)';
       insert document4;
    }
    
    public void attachUploadedFileInTicketEULimit(String id)
    {
       document5.ParentId = id;
       document5.Name= document5.Name+'(EU Limits)';
       insert document5;
    }

    public void checkForRequestType() 
    {
        
         if(TradeRegion!=null && passrequest.Request_Type__c!=null)
         {
             if((TradeRegion.indexOf('North America')!=-1 || TradeRegion.indexOf('Europe')!=-1) && passrequest.Request_Type__c=='Decommission' || passrequest.Request_Type__c=='Delete User')   
              {
                  AccountAllocationEUFlag = 0;
                  AccountAllocationUSFlag = 0;
                  CashRegionFlag = 0;
              }
             
              if(TradeRegion.indexOf('Europe')!=-1 && (passrequest.Request_Type__c=='New Integration' || 
              passrequest.Request_Type__c=='Modify Integration' || passrequest.Request_Type__c=='Modify User'
               ))
              {
                EUDestinationPermissionsMandatory = 1;
       }        
              else
                EUDestinationPermissionsMandatory = 0;
         }
        
    }

       


   public void calcEUDestMSSector(){
   
     MSSector=passrequest.EU_Destinations__c;    
    
    if(AccountAllocationEUFlag==1)
    {
       if(MSSector != null)
       {          
         if(passrequest.EU_Destinations__c.indexOf('PPWinEUEQ_M S Sectors')!=-1)
               EUDestMSSectorsFlag = 1;
         else
               EUDestMSSectorsFlag = 0; 
        
         if(passrequest.EU_Destinations__c.indexOf('Basic EU Options Destination')!=-1) 
               EUDestEUOptFlag = 1;
         else
               EUDestEUOptFlag = 0;           
               
         if(passrequest.EU_Destinations__c.indexOf('Basic EU Futures Destinations')!=-1)
               EUDestFUDestFlag = 1;
         else
               EUDestFUDestFlag = 0;
        
         if(passrequest.EU_Destinations__c.indexOf('Basic EU Cash Destinations')!=-1)
               EUCashDestFlag = 1; 
         else      
               EUCashDestFlag = 0;
        
      //    CashOptFlag = 1; 
      //This will show limit section for EU region  but now we dont need limit section for eu region, so commenting it
       }  
       else
       {
           EUDestMSSectorsFlag = 0;
           EUDestEUOptFlag = 0;
           EUDestFUDestFlag = 0;
           EUCashDestFlag = 0;
           CashOptFlag = 0;
      }
    }
    else
    {
        EUDestMSSectorsFlag = 0;  
        EUDestEUOptFlag = 0;
        EUDestFUDestFlag = 0;
        EUCashDestFlag = 0;
        CashOptFlag = 0;
    }
    
    calcEULimits();
    calcetsDB();
  }  
  
  public boolean futureValue{get;set;}
  public void validateFutureAccAddress(){
    
    if(passrequest.Futures_Account__c=='TBD'){
    
        futureValue=true;
    }else{
    
        futureValue=false;
    }
  
  }
   
  public void calcUSDest()
  {
      if(AccountAllocationUSFlag == 1)
      {
        if(passrequest.US_Destination__c != null)
        {
             if(passrequest.US_Destination__c.indexOf('Basic US Cash Trader')!=-1)
               USDestUsCashFlag = 1;
             else
               USDestUsCashFlag = 0;
               
             if(passrequest.US_Destination__c.indexOf('Basic Canada Cash Destination')!=-1)
               USDestBasicCanadaFlag = 1;
             else
               USDestBasicCanadaFlag = 0;
               
             if(passrequest.US_Destination__c.indexOf('Basic US Options Trader')!=-1)
               USDestOptFlag = 1;
             else      
               USDestOptFlag = 0;
            
             if(passrequest.US_Destination__c.indexOf('Basic US Futures Trader')!=-1)
               USDestUSFutFlag = 1;
             else      
               USDestUSFutFlag = 0;
             
             if(passrequest.US_Destination__c.indexOf('Canada Futures')!=-1)
               USDestCanFutFlag = 1;
             else      
               USDestCanFutFlag = 0;  
 
/*             if(passrequest.US_Destination__c == 'No Destinations' )
               CashOptFlag = 0;
             else
             {
                String val= passrequest.US_Destination__c;
                if(val.length()>1)
               CashOptFlag = 1;
        }
  */            
        }
        else
        {
               USDestBasicCanadaFlag = 0;
               USDestUsCashFlag = 0;
               USDestOptFlag = 0;
               USDestUSFutFlag=0;
               USDestCanFutFlag=0;
               CashOptFlag = 0;
        }
      }
      else
      {
         USDestUsCashFlag = 0;
         USDestBasicCanadaFlag = 0;
         USDestOptFlag = 0;
         USDestUSFutFlag=0;
         USDestCanFutFlag=0;
         CashOptFlag = 0;
       }
       checkMandatoryFuturesAccount();
       calcetsDB(); 
  } 
   
      public void calcAllAsiaMarket(){
       if(AccountAllocationASIAFlag == 1)
       {
           if(passrequest.All_Asia_Market_Limit__c == null)
               AllAsiaMarketFlag = 1;
           else               
               AllAsiaMarketFlag = 0;
       }
       else
           AllAsiaMarketFlag = 0;
   }
    
    public void calcEquitySwap()
    {
       if(AccountAllocationASIAFlag == 1)
       {    
           if(passrequest.Asset_Class__c!=null)
           {
                if(passrequest.Asset_Class__c.indexOf('Equity')!=-1)
                    EquityFlag = 1;
                else
                    EquityFlag = 0;
                
                if(passrequest.Asset_Class__c.indexOf('Options')!=-1)
                    OptionsFlag = 1;
                else
                    OptionsFlag = 0;
                
                if(passrequest.Asset_Class__c.indexOf('Spreads')!=-1)
                    SpreadsFlag = 1;
                else
                    SpreadsFlag = 0;
                
                if(passrequest.Asset_Class__c.indexOf('equity swaps')!=-1)
                    EquitySwapFlag = 1;
                else
                    EquitySwapFlag = 0;
                
                if(passrequest.Asset_Class__c.indexOf('futures swaps')!=-1)
                    FuturesSwapFlag = 1;
                else
                    FuturesSwapFlag = 0;
                
                if(passrequest.Asset_Class__c.indexOf('Futures')!=-1)
                    FutureFlag = 1;
                else
                    FutureFlag = 0;  
                    
                if(passrequest.Asset_Class__c.indexOf('Equity')!=-1 || passrequest.Asset_Class__c.indexOf('Futures')!=-1 )                          
                    AssetFlag = 1;
                else
                    AssetFlag = 0; 
                
                if(passrequest.Asset_Class__c.indexOf('Options')!=-1 || passrequest.Asset_Class__c.indexOf('Futures')!=-1 || passrequest.Asset_Class__c.indexOf('Spreads')!=-1)                          
                    SIMRSFERFlag = 1;
                else
                    SIMRSFERFlag = 0;       
            }
            else
            {
              EquityFlag = 0;
              OptionsFlag = 0;
              SpreadsFlag = 0;
              EquitySwapFlag = 0;
              FuturesSwapFlag = 0;
              FutureFlag = 0;
              AssetFlag = 0;
              SIMRSFERFlag=0;
            }  
       }
       else
       {
          EquityFlag = 0;
          OptionsFlag = 0;
          SpreadsFlag = 0;
          EquitySwapFlag = 0;
          FuturesSwapFlag = 0;
          FutureFlag = 0;
          AssetFlag = 0;
          SIMRSFERFlag=0;
       }   
    }    
    
   public void calcAsiaMarkets(){
       if(AccountAllocationASIAFlag == 1)
       {
           if(passrequest.Asia_Pacific_Markets__c!=null)
           {
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Japan')!=-1)
                   JapanFlag = 1;
               else
                   JapanFlag = 0;
                   
               if(passrequest.Asia_Pacific_Markets__c.indexOf('HK/SG/AU')!=-1)
                   HKSGAUFlag = 1;
               else
                   HKSGAUFlag = 0;
               
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Australia')!=-1)
                   AustraliaFlag = 1;
               else
                   AustraliaFlag = 0;
                           
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Korea')!=-1)
                   KoreaFlag = 1;
               else
                   KoreaFlag = 0;
               
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Taiwan')!=-1)
                   TaiwanFlag = 1;
               else
                   TaiwanFlag = 0;
                   
               if(passrequest.Asia_Pacific_Markets__c.indexOf('India')!=-1)
                   IndiaFlag = 1;
               else
                   IndiaFlag = 0;
                   
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Broker Markets')!=-1)
                   BrokerMareketFlag = 1;
               else
                   BrokerMareketFlag = 0;
               
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Malaysia')!=-1)
                   MalaysiaFlag = 1;
               else
                   MalaysiaFlag = 0;  
                   
              if(passrequest.Asia_Pacific_Markets__c.indexOf('Thailand')!=-1)
                   ThailandFlag = 1;
               else
                   ThailandFlag = 0;
                   
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Indonesia')!=-1)
                   IndonesiaFlag = 1;
               else
                   IndonesiaFlag = 0;
                   
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Singapore')!=-1)
                   SingaporeFlag = 1;
               else
                   SingaporeFlag = 0;
               
               if(passrequest.Asia_Pacific_Markets__c.indexOf('Hongkong')!=-1)
                   HongkongFlag = 1;
               else
                   HongkongFlag = 0;  
                   
                           
           }
           else
           {
               KoreaFlag = 0;
               TaiwanFlag = 0;
               IndiaFlag = 0;
               JapanFlag = 0;
               HKSGAUFlag = 0;
               AustraliaFlag = 0;
               BrokerMareketFlag = 0;
               MalaysiaFlag = 0;
               ThailandFlag = 0;
               IndonesiaFlag = 0;
               SingaporeFlag = 0;
               HongkongFlag = 0;               
           }
       }
       else
       {
           KoreaFlag = 0;
           TaiwanFlag = 0;
           IndiaFlag = 0;
           JapanFlag = 0;
           HKSGAUFlag = 0;
           AustraliaFlag = 0;
           BrokerMareketFlag = 0;
           MalaysiaFlag = 0;
           ThailandFlag = 0;
           IndonesiaFlag = 0;
           SingaporeFlag = 0;
           HongkongFlag = 0;
       }
   } 
   
    // singhrak, REQ3118951 , 26 Dec, 2014, Start
   public void setRequestPP()
   {
    this.passrequest = (Passport_Request__c)stdController.getRecord();
   }
   // singhrak, REQ3118951 , 26 Dec, 2014, End
   
   public void calcRequestType()
   {
        setRequestPP(); //  // singhrak, REQ3118951 , 26 Dec, 2014
       if(passrequest.Request_Type__c != null)
       {
           if(passrequest.Request_Type__c=='New Integration')
               NewIntegrationFlag = 1;
           else
               NewIntegrationFlag = 0;    
               
           if(passrequest.Trade_Region__c != null && (passrequest.Trade_Region__c.indexOf('Europe')!=-1  || passrequest.Trade_Region__c.indexOf('North America')!=-1 ))
           {
              if(passrequest.Request_Type__c=='Decommission' || passrequest.Request_Type__c=='Delete User')
              {
                AccountAllocationEUFlag = 0;
                AccountAllocationUSFlag = 0;
                CashRegionFlag = 0;
       }
              // added 5dec13,8pm. start
              else
              { 
                if(passrequest.Trade_Region__c != null && (passrequest.Trade_Region__c.indexOf('Europe')!=-1 ))
                   AccountAllocationEUFlag = 1;
                
                if(passrequest.Trade_Region__c != null && passrequest.Trade_Region__c.indexOf('North America')!=-1 )
                  AccountAllocationUSFlag = 1;
              }
                  // added 5dec13,8pm. end
                  
            if(passrequest.Request_Type__c=='New User')
             {
              Clone_Setup_Flag = 1;
            }
            else
            {
              Clone_Setup_Flag = 0;
              CloneUserFlag = 0;
              EUDestinationPermissionsMandatory = 0;
              cloneCheckboxFlag = 0;
              passrequest.Clone_Setup__c = '';
            }
           }       
       }
       else
       {
           NewIntegrationFlag = 0;
           Clone_Setup_Flag = 0;
              CloneUserFlag = 0;
              EUDestinationPermissionsMandatory = 0;
              cloneCheckboxFlag = 0;
              passrequest.Clone_Setup__c = '';
       }
        
      calcCloneSetup();

      calcDarkPoolCheckedFlag();    
      calcHKSFCChecked();
   } 
    
     public Integer Clone_Setup_Flag=0;
     public Integer getClone_Setup_Flag()
      {
        return Clone_Setup_Flag;
      }
    
     public Integer EUDestinationPermissionsMandatory =0;
     public Integer getEUDestinationPermissionsMandatory()
      {
        return EUDestinationPermissionsMandatory;
      }
     public Integer CloneUserFlag =0;
      public Integer getCloneUserFlag()
      {
        return CloneUserFlag;
      }
    public void calcCloneSetup()
    {
        setRequestPP(); //  // singhrak, REQ3118951 , 26 Dec, 2014
        if(passrequest.Clone_Setup__c !=null && passrequest.Clone_Setup__c == 'Yes' )
        {
            if(passrequest.Trade_Region__c != null && (passrequest.Trade_Region__c.indexOf('Europe')!=-1  || passrequest.Trade_Region__c.indexOf('North America')!=-1 ) &&
            passrequest.Request_Type__c !=null && passrequest.Request_Type__c=='New User'
            )
            {
                cloneCheckboxFlag = 1;
                cloneUserMandatoryEU();
            }
            else 
              cloneCheckboxFlag = 0;
            
            CashRegionFlag = 0;
            passrequest.US_Destination__c = '';
            calcUSDest();
            hideLimitSection();
        }
        else
         CloneUserFlag = 0;
           
        if(passrequest.Clone_Setup__c == 'No')
        {
            if(passrequest.Trade_Region__c!=null)
            {
             if(passrequest.Trade_Region__c.indexOf('North America')!=-1 || passrequest.Trade_Region__c.indexOf('Europe')!=-1)
             {
               CashRegionFlag = 1;
             EUDestinationPermissionsMandatory = 1; 
            
            passrequest.Mset_Futures__c = false;
            passrequest.Mirror__c = false;
            passrequest.Mirror_Id__c = '';
            cloneCheckboxFlag = 0;
             }
            }       
        }
        else 
             EUDestinationPermissionsMandatory = 0;   
             
        if(passrequest.Trade_Region__c == null || passrequest.Trade_Region__c == 'Pan-Asia')
          cloneCheckboxFlag = 0;
    }
    
    public void hideLimitSection(){
        USDestUsCashFlag = 0;
        USDestBasicCanadaFlag = 0 ;
        CashOptFlag = 0;
        USDestCanFutFlag = 0;
        USDestUSFutFlag = 0;
    }
    
    public Integer cloneCheckboxFlag = 0;
    public Integer getCloneCheckboxFlag()
    {
        return cloneCheckboxFlag;
    }
    
      public Integer CloneSetupNoFlag=0;
      public Integer getCloneSetupNoFlag()
      {
        return CloneSetupNoFlag;
   } 
   
   /* public integer SFCattestation=0; // kumvina,REQ7650129;10Aug2017
      public Integer getSFCattestation()
    {
        return SFCattestation;     
    }
    
    
    public void attestationSFD(){
     if(passrequest.SFC_attestation__c!=null && passrequest.SFC_attestation__c=='Out of Scope')
     {
        SFCattestation=1;
     }else{
        SFCattestation=0;
     }
    
    } */ // kumvina,REQ7650129;10Aug2017
  // R09175551, start
    
    public void calcSingaporeAustralia()
    {
      calcOptionsSingaporeFlag();
      calcOptionsAustraliaFlag();
      calcSpreadsSingaporeFlag();
      calcSpreadsAustraliaFlag();
      
      calcSingaporeFuturesFlag();
      calcAustraliaFuturesFlag();
    }
    
    public Integer FuturesAccountMandatory=0;
    public Integer getFuturesAccountMandatory()
    {
      return FuturesAccountMandatory;
    }
    
    public void checkMandatoryFuturesAccount()
    {
      if(AccountAllocationUSFlag == 1 && passrequest.US_Destination__c !=null  && 
      (passrequest.US_Destination__c.indexOf('Basic US Futures Trader')!=-1))
      {
        FuturesAccountMandatory = 1;
      }
      else
        FuturesAccountMandatory = 0;
   
    }
    
    
   // OptionsSingapore 
    public Integer OptionsSingaporeFlag=0;
    public Integer getOptionsSingaporeFlag()
    {
      return OptionsSingaporeFlag;
    }
    public void calcOptionsSingaporeFlag()
    {
      if(passrequest.Trade_Region__c!=null && passrequest.Trade_Region__c.indexOf('Pan-Asia')!=-1)
       {
         if(passrequest.Asset_Class__c != null && passrequest.Asset_Class__c.indexOf('Options')!=-1 )
         {
             if(passrequest.Options_Markets__c != null && passrequest.Options_Markets__c.indexOf('Singapore') != -1)
                 OptionsSingaporeFlag=1;
             else
                 OptionsSingaporeFlag=0;
         }
         else
           OptionsSingaporeFlag=0;
       }
       else
         OptionsSingaporeFlag=0;
         
         calcOptionsAustraliaFlag();
         
         calcHKSFCChecked();
    }

    //public void call      
    public Integer OptionsAustraliaFlag=0;
    public Integer getOptionsAustraliaFlag()
    {
      return OptionsAustraliaFlag;
    }
    public void calcOptionsAustraliaFlag()
    {
        if(passrequest.Trade_Region__c!=null && passrequest.Trade_Region__c.indexOf('Pan-Asia')!=-1)
       {
         if(passrequest.Asset_Class__c != null && passrequest.Asset_Class__c.indexOf('Options')!=-1 )
         {
                  if(passrequest.Options_Markets__c != null && passrequest.Options_Markets__c.indexOf('Australia') != -1)
                OptionsAustraliaFlag=1;
            else
                OptionsAustraliaFlag=0;
         }
         else
           OptionsAustraliaFlag=0;
       }
       else
         OptionsAustraliaFlag=0;
    }
    
    public Integer SpreadsSingaporeFlag=0;
    public Integer getSpreadsSingaporeFlag()
    {
      return SpreadsSingaporeFlag;
    }
    public void calcSpreadsSingaporeFlag()
    {
        if(passrequest.Trade_Region__c!=null && passrequest.Trade_Region__c.indexOf('Pan-Asia')!=-1)
       {
         if(passrequest.Asset_Class__c != null && passrequest.Asset_Class__c.indexOf('Spreads')!=-1 )
         {
                  if(this.passrequest.Spreads_Markets__c != null && this.passrequest.Spreads_Markets__c.indexOf('Singapore') != -1)
                SpreadsSingaporeFlag=1;
            else
                SpreadsSingaporeFlag=0;
         }
         else
           SpreadsSingaporeFlag=0;
       }
       else
          SpreadsSingaporeFlag=0;
          
           calcSpreadsAustraliaFlag();
           
           calcHKSFCChecked();
    }
    
    public Integer SpreadsAustraliaFlag=0;
    public Integer getSpreadsAustraliaFlag()
    {
      return SpreadsAustraliaFlag;
    }
    public void calcSpreadsAustraliaFlag()
    {
        if(passrequest.Trade_Region__c!=null && passrequest.Trade_Region__c.indexOf('Pan-Asia')!=-1)
       {
         if(passrequest.Asset_Class__c != null && passrequest.Asset_Class__c.indexOf('Spreads')!=-1 )
         {
                      if(this.passrequest.Spreads_Markets__c != null && this.passrequest.Spreads_Markets__c.indexOf('Australia') != -1)
                          SpreadsAustraliaFlag=1;
                      else
                          SpreadsAustraliaFlag=0;
         }
         else
           SpreadsAustraliaFlag=0;
       }
       else
         SpreadsAustraliaFlag=0;
    }
 
  public Integer FuturesSingaporeFlag=0;
    public Integer getFuturesSingaporeFlag()
    {
      return FuturesSingaporeFlag;
    }
    public void calcSingaporeFuturesFlag()
    {
        if(passrequest.Trade_Region__c!=null && passrequest.Trade_Region__c.indexOf('Pan-Asia')!=-1)
       {
         if(passrequest.Asset_Class__c != null && passrequest.Asset_Class__c.indexOf('Futures')!=-1 )
         {
                  if(this.passrequest.Futures_Markets__c != null && this.passrequest.Futures_Markets__c.indexOf('Singapore') != -1)
                FuturesSingaporeFlag=1;
            else
                FuturesSingaporeFlag=0;
         }
         else
           FuturesSingaporeFlag=0;
       }
       else
          FuturesSingaporeFlag=0;
          
           calcAustraliaFuturesFlag();
           
           calcHKSFCChecked();
    }
    
    public Integer FuturesAustraliaFlag=0;
    public Integer getFuturesAustraliaFlag()
    {
      return FuturesAustraliaFlag;
    }
    public void calcAustraliaFuturesFlag()
    {
        if(passrequest.Trade_Region__c!=null && passrequest.Trade_Region__c.indexOf('Pan-Asia')!=-1)
       {
         if(passrequest.Asset_Class__c != null && passrequest.Asset_Class__c.indexOf('Futures')!=-1 )
         {
                      if(this.passrequest.Futures_Markets__c != null && this.passrequest.Futures_Markets__c.indexOf('Australia') != -1)
                          FuturesAustraliaFlag=1;
                      else
                          FuturesAustraliaFlag=0;
         }
         else
           FuturesAustraliaFlag=0;
       }
       else
          FuturesAustraliaFlag=0;
    }   
 
    // R09175551, end    
    
    public Integer cloneUserMandatoryEUFlag = 0;
    public Integer getCloneUserMandatoryEUFlag()
    {
        return cloneUserMandatoryEUFlag;
    }
    public void cloneUserMandatoryEU()
    {
        if(this.passrequest.Mirror__c == true)
         cloneUserMandatoryEUFlag = 1;
         else
         {
           cloneUserMandatoryEUFlag = 0;
           passrequest.Mirror_Id__c = '';   
         }
         
    }
    
    
   public PageReference cloneAction() {
       PageReference editForm = new Apexpages.Standardcontroller(passrequest).edit();
       
       editForm.getParameters().put('flow','clone');
       editForm.setredirect(true);
       this.passrequest.Status__c='Submitted';
       return editForm;
   }  
   
   public PageReference cloneForm() {
       PageReference pref = null;
                Passport_Request__c ppFormReq = (Passport_Request__c)stdController.getRecord();
     try {
          this.cloneableRequestForm.MSET_Account__c = ppFormReq.MSET_Account__c;  
           this.cloneableRequestForm.Account_Number_IN__c = ppFormReq.Account_Number_IN__c;
           this.cloneableRequestForm.Affiliate__c = ppFormReq.Affiliate__c;
           this.cloneableRequestForm.Algo__c = ppFormReq.Algo__c;
           this.cloneableRequestForm.All_Asia_Market_Limit__c = ppFormReq.All_Asia_Market_Limit__c;
           this.cloneableRequestForm.Allocation_Button__c = ppFormReq.Allocation_Button__c;
           this.cloneableRequestForm.AsiaEtsClients_Integrator__c = ppFormReq.AsiaEtsClients_Integrator__c;
           this.cloneableRequestForm.Asia_Pacific_Markets__c = ppFormReq.Asia_Pacific_Markets__c;
           this.cloneableRequestForm.Asset_Class__c = ppFormReq.Asset_Class__c;
           this.cloneableRequestForm.AU_Trade_Limit_Cah__c = ppFormReq.AU_Trade_Limit_Cah__c;
           this.cloneableRequestForm.AU_Trade_Limit_FUT__c = ppFormReq.AU_Trade_Limit_FUT__c;
           this.cloneableRequestForm.AU_Trade_Limit_OPT__c = ppFormReq.AU_Trade_Limit_OPT__c;
           this.cloneableRequestForm.AU_Trade_Limit_Spread__c = ppFormReq.AU_Trade_Limit_Spread__c;
           this.cloneableRequestForm.Australia__c = ppFormReq.Australia__c;
           this.cloneableRequestForm.Client_Approver__c = ppFormReq.Client_Approver__c;  /// REQ6273880 kumvina oct2016 
           
           this.cloneableRequestForm.Australia_Future__c = ppFormReq.Australia_Future__c;
           this.cloneableRequestForm.Auto_Allocation_EUR__c = ppFormReq.Auto_Allocation_EUR__c;
           this.cloneableRequestForm.Auto_Allocation_UKM__c = ppFormReq.Auto_Allocation_UKM__c;
           this.cloneableRequestForm.Auto_Allocation_USD__c = ppFormReq.Auto_Allocation_USD__c;
           
           this.cloneableRequestForm.Broker_Mkt_Trade_Limit_Cash__c = ppFormReq.Broker_Mkt_Trade_Limit_Cash__c;
           this.cloneableRequestForm.BSEOrderType__c = ppFormReq.BSEOrderType__c;
           
           this.cloneableRequestForm.CFM_Limits_EU_cash__c = ppFormReq.CFM_Limits_EU_cash__c;
           this.cloneableRequestForm.CFM_Limits_US_CASH__c = ppFormReq.CFM_Limits_US_CASH__c;
           this.cloneableRequestForm.CFM_Limits_SA_CASH__c = ppFormReq.CFM_Limits_SA_CASH__c;
           //singhrak, REQ3955079, 22June, 2015, start
           if(ppFormReq.Passport_Bloomberg_Setup__c == 'Yes')
                this.cloneableRequestForm.Comments__c = '';
           else     
           //singhrak, REQ3955079, 22June, 2015, end
           this.cloneableRequestForm.Comments__c = ppFormReq.Comments__c;
           this.cloneableRequestForm.COMMOD_Futures__c = ppFormReq.COMMOD_Futures__c;
           
           this.cloneableRequestForm.Depending_On__c = ppFormReq.Depending_On__c;
           this.cloneableRequestForm.DMA__c = ppFormReq.DMA__c;
           this.cloneableRequestForm.Domestic_Oasys_Booking__c = ppFormReq.Domestic_Oasys_Booking__c;
                                 
           this.cloneableRequestForm.Email_mset_fe__c = ppFormReq.Email_mset_fe__c;
           this.cloneableRequestForm.Enable_DFD_Button__c = ppFormReq.Enable_DFD_Button__c;
           this.cloneableRequestForm.Enable_Futures__c = ppFormReq.Enable_Futures__c;
           this.cloneableRequestForm.Enable_GTC_for_Futures__c = ppFormReq.Enable_GTC_for_Futures__c;
           this.cloneableRequestForm.Enable_Index_Swaps_EU_Only__c = ppFormReq.Enable_Index_Swaps_EU_Only__c;
           this.cloneableRequestForm.Enable__c = ppFormReq.Enable__c;
           this.cloneableRequestForm.Enable_Net__c = ppFormReq.Enable_Net__c;
           this.cloneableRequestForm.Enable_Options__c = ppFormReq.Enable_Options__c;
           this.cloneableRequestForm.Enable_PNL_Blotter__c = ppFormReq.Enable_PNL_Blotter__c;
           this.cloneableRequestForm.Equity_Futures_EU__c = ppFormReq.Equity_Futures_EU__c;
           this.cloneableRequestForm.EU_Destinations__c = ppFormReq.EU_Destinations__c;
           this.cloneableRequestForm.Exchange_Account_IN__c = ppFormReq.Exchange_Account_IN__c;
           this.cloneableRequestForm.Exchange_Account_KR__c = ppFormReq.Exchange_Account_KR__c;
           this.cloneableRequestForm.Exchange_Account_TW__c = ppFormReq.Exchange_Account_TW__c;
           this.cloneableRequestForm.Exchange_Account_for_SIMR_SFER__c = ppFormReq.Exchange_Account_for_SIMR_SFER__c;
           
           this.cloneableRequestForm.Fid_Futures_EU__c = ppFormReq.Fid_Futures_EU__c;
           this.cloneableRequestForm.FID_Futures_US__c = ppFormReq.FID_Futures_US__c;
           this.cloneableRequestForm.FINI_ID_TW__c = ppFormReq.FINI_ID_TW__c;
           this.cloneableRequestForm.Foreign_Id_KR__c = ppFormReq.Foreign_Id_KR__c;                      
           this.cloneableRequestForm.Futures_Account__c = ppFormReq.Futures_Account__c;
           this.cloneableRequestForm.Futures_Acct__c = ppFormReq.Futures_Acct__c;
           this.cloneableRequestForm.Futures_US__c = ppFormReq.Futures_US__c;
           this.cloneableRequestForm.FX_Futures__c = ppFormReq.FX_Futures__c;
           
           
           this.cloneableRequestForm.GUI_dropdown_Accounts_for_SIMR_SFER__c = ppFormReq.GUI_dropdown_Accounts_for_SIMR_SFER__c;
           
           this.cloneableRequestForm.HongKong__c = ppFormReq.HongKong__c;
           this.cloneableRequestForm.HK_Trade_Limit_Cash__c = ppFormReq.HK_Trade_Limit_Cash__c;
           this.cloneableRequestForm.HK_Trade_Limit_FUT__c = ppFormReq.HK_Trade_Limit_FUT__c;
           this.cloneableRequestForm.HK_Trade_Limit_OPT__c = ppFormReq.HK_Trade_Limit_OPT__c;
           this.cloneableRequestForm.HK_Trade_Limit_Spread__c = ppFormReq.HK_Trade_Limit_Spread__c;
           this.cloneableRequestForm.Hongkong_Future__c = ppFormReq.Hongkong_Future__c;
           this.cloneableRequestForm.HongKong__c = ppFormReq.HongKong__c;
           
           this.cloneableRequestForm.India__c = ppFormReq.India__c; 
           this.cloneableRequestForm.IN_Trade_Limit_Cash__c = ppFormReq.IN_Trade_Limit_Cash__c;
           this.cloneableRequestForm.IN_Trade_Limit_FUT__c = ppFormReq.IN_Trade_Limit_FUT__c;
           this.cloneableRequestForm.IN_Trade_Limit_OPT__c = ppFormReq.IN_Trade_Limit_OPT__c;
           this.cloneableRequestForm.IN_trade_Limit_Spread__c = ppFormReq.IN_trade_Limit_Spread__c;
           this.cloneableRequestForm.Index_Futures_EU__c = ppFormReq.Index_Futures_EU__c;
           this.cloneableRequestForm.Index_Futures_US__c = ppFormReq.Index_Futures_US__c;
           this.cloneableRequestForm.India_FutSwap__c = ppFormReq.India_FutSwap__c;
           this.cloneableRequestForm.IndiaCPCode__c = ppFormReq.IndiaCPCode__c;
           this.cloneableRequestForm.Indonesia_Trade_Limit_Cash__c = ppFormReq.Indonesia_Trade_Limit_Cash__c;
           
           this.cloneableRequestForm.Japan__c = ppFormReq.Japan__c;
           this.cloneableRequestForm.Japan_Future__c = ppFormReq.Japan_Future__c;
           this.cloneableRequestForm.JP_Trade_Limit_Cash__c = ppFormReq.JP_Trade_Limit_Cash__c;
           this.cloneableRequestForm.JP_Trade_Limit_FUT__c = ppFormReq.JP_Trade_Limit_FUT__c;
           this.cloneableRequestForm.JP_Trade_Limit_OPT__c = ppFormReq.JP_Trade_Limit_OPT__c;
           this.cloneableRequestForm.JP_Trade_Limit_Spread__c = ppFormReq.JP_Trade_Limit_Spread__c;
           
           this.cloneableRequestForm.Korea__c = ppFormReq.Korea__c;
           this.cloneableRequestForm.Korea_FutSwap__c = ppFormReq.Korea_FutSwap__c;
           this.cloneableRequestForm.KR_Trade_Limit_Cash__c = ppFormReq.KR_Trade_Limit_Cash__c;
           this.cloneableRequestForm.KR_Trade_Limit_FUT__c = ppFormReq.KR_Trade_Limit_FUT__c;
           this.cloneableRequestForm.KR_Trade_Linit_OPT__c = ppFormReq.KR_Trade_Linit_OPT__c;
           this.cloneableRequestForm.KR_Trade_Limit_Spread__c = ppFormReq.KR_Trade_Limit_Spread__c;
           
           this.cloneableRequestForm.Logged_In_User__c = ppFormReq.Logged_In_User__c;
           
           this.cloneableRequestForm.Malaysia_Trade_Limit_Cash__c = ppFormReq.Malaysia_Trade_Limit_Cash__c;
           this.cloneableRequestForm.Marketdata_Entitlements__c = ppFormReq.Marketdata_Entitlements__c;
           this.cloneableRequestForm.Market_Data_chkb__c = ppFormReq.Market_Data_chkb__c;
           this.cloneableRequestForm.Market_Watch_Lists__c = ppFormReq.Market_Watch_Lists__c;
           this.cloneableRequestForm.Multiple_Accounts__c = ppFormReq.Multiple_Accounts__c;
           
           this.cloneableRequestForm.NJA_Trade_Limit_Cash__c = ppFormReq.NJA_Trade_Limit_Cash__c;
           this.cloneableRequestForm.NJA_Trade_Limit_FUT__c = ppFormReq.NJA_Trade_Limit_FUT__c;
           this.cloneableRequestForm.NJA_Trade_Limit_OPT__c = ppFormReq.NJA_Trade_Limit_OPT__c;
           this.cloneableRequestForm.NJA_Trade_Limit_Spread__c = ppFormReq.NJA_Trade_Limit_Spread__c;
           
           this.cloneableRequestForm.Options_Acct__c = ppFormReq.Options_Acct__c;
           this.cloneableRequestForm.Options_EU__c = ppFormReq.Options_EU__c;
           this.cloneableRequestForm.Options_US__c = ppFormReq.Options_US__c; 
           this.cloneableRequestForm.Other_Users__c = ppFormReq.Other_Users__c;
                     
           this.cloneableRequestForm.Priority__c = ppFormReq.Priority__c;
           
            //for ticket REQ1650682
           this.cloneableRequestForm.User_based_in__c = ppFormReq.User_based_in__c;
           
           
           this.cloneableRequestForm.Request_Type__c = ppFormReq.Request_Type__c;           
           this.cloneableRequestForm.Requested_By__c = ppFormReq.Requested_By__c;
           
           this.cloneableRequestForm.SG_Trade_Limit_Cash__c = ppFormReq.SG_Trade_Limit_Cash__c;
           this.cloneableRequestForm.SG_Trade_Limit_FUT__c = ppFormReq.SG_Trade_Limit_FUT__c;
           this.cloneableRequestForm.SG_Trade_Limit_OPT__c = ppFormReq.SG_Trade_Limit_OPT__c;
           this.cloneableRequestForm.SG_Trade_Limit_Spread__c = ppFormReq.SG_Trade_Limit_Spread__c; 
           this.cloneableRequestForm.Singapore_Future__c = ppFormReq.Singapore_Future__c;
           this.cloneableRequestForm.Singapure__c = ppFormReq.Singapure__c;
           this.cloneableRequestForm.Single_Account_Booking__c = ppFormReq.Single_Account_Booking__c;
           this.cloneableRequestForm.Single_Options_Account_Booking__c = ppFormReq.Single_Options_Account_Booking__c;
           this.cloneableRequestForm.Status__c = ppFormReq.Status__c;
           
           this.cloneableRequestForm.Taiwan__c = ppFormReq.Taiwan__c;
           this.cloneableRequestForm.Target_Date__c = ppFormReq.Target_Date__c;
           this.cloneableRequestForm.TH_Trade_Limit_Cash__c = ppFormReq.TH_Trade_Limit_Cash__c;
           this.cloneableRequestForm.Trade_EUROPE_as_Swap__c = ppFormReq.Trade_EUROPE_as_Swap__c;
           this.cloneableRequestForm.Trade_Region__c = ppFormReq.Trade_Region__c;
           //For falcon ticket R09114847, Start
           this.cloneableRequestForm.Clone_user__c = ppFormReq.Clone_user__c;
           //For falcon ticket R09114847, End
           this.cloneableRequestForm.NA_Coverage_Person__c = ppFormReq.NA_Coverage_Person__c;
           this.cloneableRequestForm.EU_Coverage_Person__c = ppFormReq.EU_Coverage_Person__c;
           this.cloneableRequestForm.Asia_Pacific_Coverage_Person__c = ppFormReq.Asia_Pacific_Coverage_Person__c;
           this.cloneableRequestForm.Trade_UK_as_Swap__c = ppFormReq.Trade_UK_as_Swap__c;
           this.cloneableRequestForm.Trade_US_as_SWAP__c = ppFormReq.Trade_US_as_SWAP__c;
           this.cloneableRequestForm.TW_Trade_Limit_Cash__c = ppFormReq.TW_Trade_Limit_Cash__c;
           this.cloneableRequestForm.Tw__c = ppFormReq.Tw__c;
           this.cloneableRequestForm.TW_Trade_Limit_OPT__c = ppFormReq.TW_Trade_Limit_OPT__c;
           this.cloneableRequestForm.TW_Trade_Limit_Spread__c = ppFormReq.TW_Trade_Limit_Spread__c;
           
           this.cloneableRequestForm.US_Destination__c = ppFormReq.US_Destination__c;           
           this.cloneableRequestForm.User_1__c = ppFormReq.User_1__c;
           this.cloneableRequestForm.User_2__c = ppFormReq.User_2__c;
           this.cloneableRequestForm.User_3__c = ppFormReq.User_3__c;
           this.cloneableRequestForm.User_4__c = ppFormReq.User_4__c;
           this.cloneableRequestForm.User_5__c = ppFormReq.User_5__c; 
           this.cloneableRequestForm.User_6__c = ppFormReq.User_6__c;
           this.cloneableRequestForm.User_7__c = ppFormReq.User_7__c;
           this.cloneableRequestForm.User_8__c = ppFormReq.User_8__c;
           this.cloneableRequestForm.User_9__c = ppFormReq.User_9__c;
           this.cloneableRequestForm.User_10__c = ppFormReq.User_10__c;            
           
           this.cloneableRequestForm.Watchlists__c = ppFormReq.Watchlists__c; 
           
            this.cloneableRequestForm.Limits_Required_for_Asia__c = ppFormReq.Limits_Required_for_Asia__c;
           this.cloneableRequestForm.Japan_Equity__c = ppFormReq.Japan_Equity__c;
           
           this.cloneableRequestForm.Australia_Equity__c = ppFormReq.Australia_Equity__c;
           this.cloneableRequestForm.Australia_Futures__c = ppFormReq.Australia_Futures__c;
            this.cloneableRequestForm.Australia_Future_Swap__c = ppFormReq.Australia_Future_Swap__c;
            this.cloneableRequestForm.Australia_Options__c = ppFormReq.Australia_Options__c;
            this.cloneableRequestForm.Australia_Spreads__c = ppFormReq.Australia_Spreads__c;
            this.cloneableRequestForm.Spreads_Australia__c = ppFormReq.Spreads_Australia__c;
            this.cloneableRequestForm.Options_Australia__c = ppFormReq.Options_Australia__c;
            this.cloneableRequestForm.Futures_Australia__c = ppFormReq.Futures_Australia__c;
            this.cloneableRequestForm.Spreads_Singapore__c = ppFormReq.Spreads_Singapore__c;
            this.cloneableRequestForm.Options_Singapore__c = ppFormReq.Options_Singapore__c;
            this.cloneableRequestForm.Futures_Singapore__c = ppFormReq.Futures_Singapore__c;
            this.cloneableRequestForm.FX_Futures__c = ppFormReq.FX_Futures__c;
            this.cloneableRequestForm.HongKong_Equity__c = ppFormReq.HongKong_Equity__c;
            this.cloneableRequestForm.HongKong_Futures__c = ppFormReq.HongKong_Futures__c;
            this.cloneableRequestForm.HongKong_Options__c = ppFormReq.HongKong_Options__c;
            this.cloneableRequestForm.HongKong_Spreads__c = ppFormReq.HongKong_Spreads__c;
            this.cloneableRequestForm.India_Equity__c = ppFormReq.India_Equity__c;
            this.cloneableRequestForm.India_Futures__c = ppFormReq.India_Futures__c;
            this.cloneableRequestForm.India_Options__c = ppFormReq.India_Options__c;
            this.cloneableRequestForm.India_Spreads__c = ppFormReq.India_Spreads__c;
            this.cloneableRequestForm.Indonesia__c = ppFormReq.Indonesia__c;
            this.cloneableRequestForm.Japan_Futures__c = ppFormReq.Japan_Futures__c;
            this.cloneableRequestForm.Japan_Options__c = ppFormReq.Japan_Options__c;
            this.cloneableRequestForm.Japan_Spreads__c = ppFormReq.Japan_Spreads__c;
            this.cloneableRequestForm.Korea_Equity__c = ppFormReq.Korea_Equity__c;
            this.cloneableRequestForm.Korea_Futures__c = ppFormReq.Korea_Futures__c;
            this.cloneableRequestForm.Korea_Options__c = ppFormReq.Korea_Options__c;
            this.cloneableRequestForm.Korea_Spreads__c = ppFormReq.Korea_Spreads__c;
            this.cloneableRequestForm.Malaysia_Equity__c = ppFormReq.Malaysia_Equity__c;
            this.cloneableRequestForm.Malaysia_Futures__c = ppFormReq.Malaysia_Futures__c;
            this.cloneableRequestForm.Malaysia_Options__c = ppFormReq.Malaysia_Options__c;
            this.cloneableRequestForm.Malaysia_Spreads__c = ppFormReq.Malaysia_Spreads__c;
            this.cloneableRequestForm.NewZealand_Equity__c = ppFormReq.NewZealand_Equity__c;
            this.cloneableRequestForm.Singapore_Equity__c = ppFormReq.Singapore_Equity__c;
            this.cloneableRequestForm.Singapore_Futures__c = ppFormReq.Singapore_Futures__c;
            this.cloneableRequestForm.Singapore_Options__c = ppFormReq.Singapore_Options__c;
            this.cloneableRequestForm.Singapore_Spreads__c = ppFormReq.Singapore_Spreads__c;
            this.cloneableRequestForm.Taiwan_Equity__c = ppFormReq.Taiwan_Equity__c;
            this.cloneableRequestForm.Taiwan_Futures__c = ppFormReq.Taiwan_Futures__c;
            this.cloneableRequestForm.Taiwan_Future_Swap__c = ppFormReq.Taiwan_Future_Swap__c;
            this.cloneableRequestForm.Taiwan_Options__c = ppFormReq.Taiwan_Options__c;
            this.cloneableRequestForm.Taiwan_Spreads__c = ppFormReq.Taiwan_Spreads__c;
            this.cloneableRequestForm.Thailand__c = ppFormReq.Thailand__c;
            this.cloneableRequestForm.Thailand_Equity__c = ppFormReq.Thailand_Equity__c;
  
            this.cloneableRequestForm.Malaysia__c = ppFormReq.Malaysia__c;
            this.cloneableRequestForm.Indonesia_Equity__c = ppFormReq.Indonesia_Equity__c;
            
            this.cloneableRequestForm.Equity_Markets__c = ppFormReq.Equity_Markets__c;
            this.cloneableRequestForm.Equity_Swap_Markets__c = ppFormReq.Equity_Swap_Markets__c;
            this.cloneableRequestForm.Futures_Markets__c = ppFormReq.Futures_Markets__c;
            this.cloneableRequestForm.Future_Swap_Markets__c = ppFormReq.Future_Swap_Markets__c;
            this.cloneableRequestForm.Spreads_Markets__c = ppFormReq.Spreads_Markets__c;
            this.cloneableRequestForm.Options_Markets__c = ppFormReq.Options_Markets__c;

              this.cloneableRequestForm.Clone_Setup__c = ppFormReq.Clone_Setup__c;
            this.cloneableRequestForm.Mset_Futures__c = ppFormReq.Mset_Futures__c;
            this.cloneableRequestForm.Mirror__c = ppFormReq.Mirror__c;
            this.cloneableRequestForm.Mirror_Id__c = ppFormReq.Mirror_Id__c;
            this.cloneableRequestForm.US_Futures__c = ppFormReq.US_Futures__c;
            this.cloneableRequestForm.Mirror_Id_msetfutemail__c = ppFormReq.Mirror_Id_msetfutemail__c;
            this.cloneableRequestForm.Clone_User_NEW__c = ppFormReq.Clone_User_NEW__c;
            
            this.cloneableRequestForm.US_SA_Equity_Single__c = ppFormReq.US_SA_Equity_Single__c;
            this.cloneableRequestForm.US_Equity_Cum__c = ppFormReq.US_Equity_Cum__c;
            this.cloneableRequestForm.SA_Equity_Cum__c = ppFormReq.SA_Equity_Cum__c;
            
            this.cloneableRequestForm.EU_Equity_Cum__c = ppFormReq.EU_Equity_Cum__c;
            this.cloneableRequestForm.EU_Equity_Single__c = ppFormReq.EU_Equity_Single__c;
            this.cloneableRequestForm.Comments_EU__c = ppFormReq.Comments_EU__c;
            this.cloneableRequestForm.Comments_NA__c = ppFormReq.Comments_NA__c;  
 
            this.cloneableRequestForm.Priority_ETS__c= ppFormReq.Priority_ETS__c;
this.cloneableRequestForm.EOD_Request_Type__c= ppFormReq.EOD_Request_Type__c;
this.cloneableRequestForm.List_of_Applications__c= ppFormReq.List_of_Applications__c;
this.cloneableRequestForm.Report_Type__c= ppFormReq.Report_Type__c;
this.cloneableRequestForm.Region__c= ppFormReq.Region__c;
this.cloneableRequestForm.Business_Line__c= ppFormReq.Business_Line__c;
this.cloneableRequestForm.Run_Time__c= ppFormReq.Run_Time__c;
this.cloneableRequestForm.Delivery_Type__c= ppFormReq.Delivery_Type__c;
this.cloneableRequestForm.Frequency_of_Report__c= ppFormReq.Frequency_of_Report__c;
this.cloneableRequestForm.Email_recipients_OR_Client_contact__c= ppFormReq.Email_recipients_OR_Client_contact__c;
this.cloneableRequestForm.Commissions_fees_needed__c= ppFormReq.Commissions_fees_needed__c;
this.cloneableRequestForm.Need_unfilled_orders__c= ppFormReq.Need_unfilled_orders__c;
this.cloneableRequestForm.Aggregation_Level__c= ppFormReq.Aggregation_Level__c;
this.cloneableRequestForm.Trigger_ETSDB_Report_form__c= ppFormReq.Trigger_ETSDB_Report_form__c;
                     
this.cloneableRequestForm.PWM__c = ppFormReq.PWM__c;
this.cloneableRequestForm.X24x6_environment__c = ppFormReq.X24x6_environment__c;
//this.cloneableRequestForm.Comments_US_Limits_Information__c = ppFormReq.Comments_US_Limits_Information__c;////REQ5266683, kumvina 24May2016 end
this.cloneableRequestForm.Reason_for_Change__c = ppFormReq.Reason_for_Change__c;
this.cloneableRequestForm.Fields_to_include__c = ppFormReq.Fields_to_include__c;
this.cloneableRequestForm.Algo_White_Label__c  =  ppFormReq.Algo_White_Label__c;
 
 // singhrak, REQ2981632, 22 Nov, 2014
 this.cloneableRequestForm.GothamAccountApproval__c= ppFormReq.GothamAccountApproval__c;  
 
 
  // singhrak, REQ3238592, 21Jan, 2015 start
this.cloneableRequestForm.Enable_FID_User__c = ppFormReq.Enable_FID_User__c;

this.cloneableRequestForm.FID_Selection_1__c = ppFormReq.FID_Selection_1__c;
this.cloneableRequestForm.FID_Selection_2__c = ppFormReq.FID_Selection_2__c;
this.cloneableRequestForm.FID_Selection_3__c = ppFormReq.FID_Selection_3__c;
this.cloneableRequestForm.FID_Selection_4__c = ppFormReq.FID_Selection_4__c;
this.cloneableRequestForm.FID_Selection_5__c = ppFormReq.FID_Selection_5__c;
this.cloneableRequestForm.FID_Selection_6__c = ppFormReq.FID_Selection_6__c;
this.cloneableRequestForm.FID_Selection_7__c = ppFormReq.FID_Selection_7__c;
this.cloneableRequestForm.FID_Selection_8__c = ppFormReq.FID_Selection_8__c;
this.cloneableRequestForm.FID_Selection_9__c = ppFormReq.FID_Selection_9__c;
this.cloneableRequestForm.FID_Selection_10__c = ppFormReq.FID_Selection_10__c;

this.cloneableRequestForm.Fund_Alias_1__c = ppFormReq.Fund_Alias_1__c;
this.cloneableRequestForm.Fund_Alias_2__c = ppFormReq.Fund_Alias_2__c;
this.cloneableRequestForm.Fund_Alias_3__c = ppFormReq.Fund_Alias_3__c;
this.cloneableRequestForm.Fund_Alias_4__c = ppFormReq.Fund_Alias_4__c;
this.cloneableRequestForm.Fund_Alias_5__c = ppFormReq.Fund_Alias_5__c;
this.cloneableRequestForm.Fund_Alias_6__c = ppFormReq.Fund_Alias_6__c;
this.cloneableRequestForm.Fund_Alias_7__c = ppFormReq.Fund_Alias_7__c;
this.cloneableRequestForm.Fund_Alias_8__c = ppFormReq.Fund_Alias_8__c;
this.cloneableRequestForm.Fund_Alias_9__c = ppFormReq.Fund_Alias_9__c;
this.cloneableRequestForm.Fund_Alias_10__c = ppFormReq.Fund_Alias_10__c;

this.cloneableRequestForm.Clearing_Firm_1__c = ppFormReq.Clearing_Firm_1__c;
this.cloneableRequestForm.Clearing_Firm_2__c = ppFormReq.Clearing_Firm_2__c;
this.cloneableRequestForm.Clearing_Firm_3__c = ppFormReq.Clearing_Firm_3__c;
this.cloneableRequestForm.Clearing_Firm_4__c = ppFormReq.Clearing_Firm_4__c;
this.cloneableRequestForm.Clearing_Firm_5__c = ppFormReq.Clearing_Firm_5__c;
this.cloneableRequestForm.Clearing_Firm_6__c = ppFormReq.Clearing_Firm_6__c;
this.cloneableRequestForm.Clearing_Firm_7__c = ppFormReq.Clearing_Firm_7__c;
this.cloneableRequestForm.Clearing_Firm_8__c = ppFormReq.Clearing_Firm_8__c;
this.cloneableRequestForm.Clearing_Firm_9__c = ppFormReq.Clearing_Firm_9__c;
this.cloneableRequestForm.Clearing_Firm_10__c = ppFormReq.Clearing_Firm_10__c;

this.cloneableRequestForm.Iswap_Account_1__c = ppFormReq.Iswap_Account_1__c;
this.cloneableRequestForm.Iswap_Account_2__c = ppFormReq.Iswap_Account_2__c;
this.cloneableRequestForm.Iswap_Account_3__c = ppFormReq.Iswap_Account_3__c;
this.cloneableRequestForm.Iswap_Account_4__c = ppFormReq.Iswap_Account_4__c;
this.cloneableRequestForm.Iswap_Account_5__c = ppFormReq.Iswap_Account_5__c;
this.cloneableRequestForm.Iswap_Account_6__c = ppFormReq.Iswap_Account_6__c;
this.cloneableRequestForm.Iswap_Account_7__c = ppFormReq.Iswap_Account_7__c;
this.cloneableRequestForm.Iswap_Account_8__c = ppFormReq.Iswap_Account_8__c;
this.cloneableRequestForm.Iswap_Account_9__c = ppFormReq.Iswap_Account_9__c;
this.cloneableRequestForm.Iswap_Account_10__c = ppFormReq.Iswap_Account_10__c;

this.cloneableRequestForm.Client_LEI_1__c = ppFormReq.Client_LEI_1__c;
this.cloneableRequestForm.Client_LEI_2__c = ppFormReq.Client_LEI_2__c;
this.cloneableRequestForm.Client_LEI_3__c = ppFormReq.Client_LEI_3__c;
this.cloneableRequestForm.Client_LEI_4__c = ppFormReq.Client_LEI_4__c;
this.cloneableRequestForm.Client_LEI_5__c = ppFormReq.Client_LEI_5__c;
this.cloneableRequestForm.Client_LEI_6__c = ppFormReq.Client_LEI_6__c;
this.cloneableRequestForm.Client_LEI_7__c = ppFormReq.Client_LEI_7__c;
this.cloneableRequestForm.Client_LEI_8__c = ppFormReq.Client_LEI_8__c;
this.cloneableRequestForm.Client_LEI_9__c = ppFormReq.Client_LEI_9__c;
this.cloneableRequestForm.Client_LEI_10__c = ppFormReq.Client_LEI_10__c;

// singhrak, REQ3238592, 21Jan, 2015 end                  
         
         
//singhrak, REQ3419095, 11march, 2015, start 
this.cloneableRequestForm.PWM__c = ppFormReq.PWM__c;
this.cloneableRequestForm.FID__c = ppFormReq.FID__c;
this.cloneableRequestForm.IED_FID__c = ppFormReq.IED_FID__c;
//singhrak, REQ3419095, 11march, 2015, end                             
         
//singhrak, REQ3954921, 9June, 2015, start
this.cloneableRequestForm.Passport_Bloomberg_Setup__c = ppFormReq.Passport_Bloomberg_Setup__c;
this.cloneableRequestForm.User1_BBG_UUID1__c = ppFormReq.User1_BBG_UUID1__c;
this.cloneableRequestForm.User2_BBG_UUID2__c = ppFormReq.User2_BBG_UUID2__c;
this.cloneableRequestForm.User3_BBG_UUID3__c = ppFormReq.User3_BBG_UUID3__c;
this.cloneableRequestForm.User4_BBG_UUID4__c = ppFormReq.User4_BBG_UUID4__c;
this.cloneableRequestForm.User5_BBG_UUID5__c = ppFormReq.User5_BBG_UUID5__c;
this.cloneableRequestForm.User6_BBG_UUID6__c = ppFormReq.User6_BBG_UUID6__c;
this.cloneableRequestForm.User7_BBG_UUID7__c = ppFormReq.User7_BBG_UUID7__c;
this.cloneableRequestForm.User8_BBG_UUID8__c = ppFormReq.User8_BBG_UUID8__c;
this.cloneableRequestForm.User9_BBG_UUID9__c = ppFormReq.User9_BBG_UUID9__c;
this.cloneableRequestForm.User10_BBG_UUID10__c = ppFormReq.User10_BBG_UUID10__c;
//singhrak, REQ3954921, 9June, 2015, end         
         
        boolean pageReferenceAction = processRequest(cloneableRequestForm);
         System.debug('Validation result:'+pageReferenceAction);
         if(pageReferenceAction){
            return null;
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