public class EUProductRequestControllerExtension {

    private EU_ProductRequest__c euprodrequest;
    
    public string messagedata{get;set;}

    public string accountNamedata{get;set;}/*REQ7615527 & REQ7615387;kumvina ;22sep2017 */
    public string accountIdDigits{get;set;}/*REQ7615527 & REQ7615387;kumvina ;22sep2017 */


    String currentProductRequestFormID;
    EU_ProductRequest__c currentProductRequestForm = new EU_ProductRequest__c();
    EU_ProductRequest__c cloneableRequestForm = new EU_ProductRequest__c();

    // for R09101828
    Integer BrazilAccountDisplayFlag = 0;
    
     // R09221756
//    Integer EUEquityDisplayFlagLimit = 0;
    
    Integer CommissionSectionDisplayFlag = 0;
    Integer EUEquityDisplayFlag = 0;
    Integer EUFutDisplayFlag = 0;
    Integer EUOptDisplayFlag = 0;
    Integer USEquityDisplayFlag = 0;
    Integer USFutDisplayFlag = 0;
    Integer USOptDisplayFlag = 0;
    Integer BloomberSetupDisplayFlag = 0;
    String omsvendor;
    String networkconnectivity;
    String marketslist;
    String RecId;
    public String BloombergId;
    Integer AP_Markets_Flag=0;
    Integer ASIASectionFlag = 0;
    Integer Region_JP_Flag = 0;
    Integer Region_AP_Flag = 0;
    Integer LimitsSectionDisplayFlag = 0;
    Integer NA_DMA_Flag,NA_BIDS_Trading_Flag, NA_Algos_Flag, EU_DMA_Flag, EU_Algos_Flag, AP_DMA_Flag, AP_Algos_Flag, JP_DMA_Flag, JP_Algos_Flag,AP_Algos_white_Flag;
    Integer NA_SalesDeskBI_Flag, EU_SalesDeskBI_Flag, AP_SalesDeskBI_Flag, JP_SalesDeskBI_Flag;
    Integer NA_Progs_Flag, EU_Progs_Flag, AP_Progs_Flag, JP_Progs_Flag;
    Integer NA_Passport_Flag, EU_Passport_Flag, AP_Passport_Flag, JP_Passport_Flag;
    Integer NA_IOI_Flag, EU_IOI_Flag, AP_IOI_Flag, JP_IOI_Flag;
    Integer NA_FX_Flag, EU_FX_Flag, AP_FX_Flag, NA_RETAIL_Flag;
    Integer Add_Another_Flag = 0,NA_BD_Flag = 0,EU_BD_Flag = 0, NA_LA_Flag = 0, Asia_Equity_Swaps_Flag = 0,NA_BDB_Flag=0,NA_BD_Whole_Section=0;//EU_Booking_Flag=0;
    Integer AP_MS_Port_Flag = 0, AP_Speedway_Flag = 0, AP_Sponsored_Flag = 0, AP_Pairs_Flag = 0;
    Integer NA_MS_Port_Flag = 0, NA_Speedway_Flag = 0, NA_Sponsored_Flag = 0, NA_Pairs_Flag = 0;
    Integer EU_MS_Port_Flag = 0, EU_Speedway_Flag = 0, EU_Sponsored_Flag = 0, EU_RSP_Flag = 0;
    Integer NA_GTC_GTD_Flag = 0, EU_GTC_GTD_Flag = 0;
    Integer NA_Soft_Dollar_Flag = 0, EU_Soft_Dollar_Flag = 0, AP_Soft_Dollar_Flag = 0, All_Region_Soft_Dollar_Flag = 0;
    Integer NA_CCA_CSA_Soft_Dollar_Flag = 0, EU_CCA_CSA_Soft_Dollar_Flag = 0, AP_CCA_CSA_Soft_Dollar_Flag = 0, All_Region_CCA_CSA_Soft_Dollar_Flag = 0;
    
    String NAFlow, EUFlow, APFlow, JPFlow ;

    Integer DMASectionDisplayFlag=0;
    Integer DMAEUSectionDisplayFlag=0;
    Integer JPSortDestFlag = 0; 
    Integer SalesDeskBISectionDisplayFlag=0;
    Integer ProgsSectionDisplayFlag=0;
    Integer PassportSectionDisplayFlag=0;
    Integer IOISectionDisplayFlag=0;
    Integer FXSectionDisplayFlag=0;

    Integer IndiaComm = 0, KoreaComm = 0, TaiwanComm = 0, JapanComm = 0 ,AsiaCoreComm =0, IndonesiaComm =0, MalaysiaComm =0, ThailandComm =0,IndiaAccount = 0;

    Integer JapanEquityLimitsFlag=0, AsiaEquityLimitsFlag=0, IndiaEquityLimitsFlag=0, TaiwanEquityLimitsFlag=0, KoreaEquityLimitsFlag=0, BrokerEquityLimitsFlag=0;
    Integer JapanFuturesLimitsFlag=0, AsiaFuturesLimitsFlag=0, IndiaFuturesLimitsFlag=0, TaiwanFuturesLimitsFlag=0, KoreaFuturesLimitsFlag=0, BrokerFuturesLimitsFlag=0;
    Integer JapanOptionsLimitsFlag=0, IndiaOptionsLimitsFlag=0, AsiaOptionsLimitsFlag=0, TaiwanOptionsLimitsFlag=0, KoreaOptionsLimitsFlag=0, BrokerOptionsLimitsFlag=0;
    Integer JP_DMA_FUT_OPT_Flag = 0, JP_BI_FUT_OPT_Flag = 0, NJA_DMA_FUT_OPT_Flag = 0, NJA_BI_FUT_OPT_Flag = 0, MS_Clr_Acc_SG_AX_Flag = 0;

    Integer BloombergSectionDisplayFlag = 0,Priority_Comment_Flag=0,NA_Coverage_Flag=0,EU_Coverage_Person_Flag=0,AP_Coverage_Person_Flag=0,Screen_Signed_Off_Flag=0;
    Integer cmeDirectflag=0,NA_cmeDirectflag=0,EU_cmeDirectflag=0,AP_cmeDirectflag=0; 
    Integer KRInvestorIdFlag=0, TWInvestorIdFlag=0, INInvestorIdFlag=0, AsiaDMACashSectionDisplayFlag=0;

    String PageTitle, CreatedBy, LastModifiedBy;

    Integer JPPoolCrossing = 0;
    Integer MSPoolCrossing = 0;
    Integer CloseAuction = 0;
    Integer JP_Fut_Opt_Coverage = 0, NJA_Fut_Opt_Coverage = 0;

    Integer VendorDisplayFlag = 0,MiFID2Preference=0;

    Boolean requestedBy = true;
    Integer BBFrontEndDisplayFlag = 0;
    Integer BBFrontEndDisplayViewFlag = 0;
    User_Region__c userId = null;
    public String[] toAddresses = null, integrators = null;
    
    public String fileNameMy {get; set;}
    public Integer fileSizeDP {get; set;} 
    public string pageName{get;set;} 
    
        
    public Attachment document1 {
      get {
        if (document1 == null)
          document1 = new Attachment();
        return document1;
      }
      set;
    }
    
    public Attachment document2 {
      get {
        if (document2 == null)
          document2 = new Attachment();
        return document2;
      }
      set;
    }
   
      
    public EUProductRequestControllerExtension (ApexPages.StandardController stdController) {
        
        this.euprodrequest = (EU_ProductRequest__c)stdController.getRecord();
        //this.currentProductRequestFormID = this.getParam('id');
       
        
        //for(EU_ProductRequest__c fpr : [select IntegratorSet__c from EU_ProductRequest__c where id=:euprodrequest.id]){
        
        //}    
      
        
         if(ApexPages.currentPage().getParameters().containsKey('flow') && this.getParam('flow').equals('clone')){
            
          euprodrequest.Set_up_type__c = null;
          euprodrequest.Name = null;
          euprodrequest.Id = null;
          euprodrequest.CreatedById = null;
          euprodrequest.CreatedDate = null;
          euprodrequest.LastModifiedById = null;
          euprodrequest.LastModifiedDate = null;
          //himanb REQ5291267 18-Apr-2016
          euprodrequest.IntegratorSet__c = false;
          euprodrequest.Enable_MSAL__c = false;  /*REQ7651784   Cloning Issue*/
          euprodrequest.Enable_MOCHA_US__c = false;
          euprodrequest.Enable_BIDS_Conditional__c=false;
          euprodrequest.Comments__c=null;
          euprodrequest.Client_Trading_Pref__c=null; 
          euprodrequest.SORT_Passive_Model__c=null;         
        }
        
        //setselectedOmsVendor(euprodrequest.OMS_Vendor__c); 
        calcFIXCertificationFlag();
        setselectedNetworkConnectivity(euprodrequest.Network_Connectivity__c);
        calcCommissionSectionDisplayFlag();
        calcLimitsSectionDisplayFlag();
        //assignNetworkConnectivity();        //resetSectionFlags(); //setStatus(euprodrequest.Status__c);
        assignRequestedByFieldValue();
    
        
        userId = [select MS_User_Id__c,Region__c,User__c from User_Region__c  where User__c = :UserInfo.getUserId() limit 1];
        this.euprodrequest.Logged_In_User__c = userinfo.getName();
        
          calcAccount();
         
          decomissionFlowregion();     
          
          calcMandatoryField();          
          calcshowUploadedaFileName();
          calcHksfc();
          calcCrossPointFlag();
       //   calcSORTPassiveModel();//kumvina REQ5143234 04March2016 
     //  messagedata=euprodrequest.Comments__c+'****Passive**'+euprodrequest.SORT_Passive_Model__c;
          showhideHKSFCCheckbox();
         
          calcEULimitFlag();
          calcNALimitFlag();  

          calcLimitsSectionDisplayFlagWithIntegrator();   
          statusOld = euprodrequest.Status__c;
        
          calcEstdbFlag();
          calcETSBSAction();
               calcEquitySwapsMarkets();        
            
        if (euprodrequest.name == null)
        {
            PageTitle = '';
            CreatedBy = '';
            LastModifiedBy = '';
            euprodrequest.Japan_Equity_Single__c = 'Default';
            euprodrequest.Japan_Equity_Cum__c = 'Default';
            euprodrequest.HK_SI_AU_Equity_Single__c = 'Default';
            euprodrequest.HK_SI_AU_Equity_Cum__c = 'Default';
            euprodrequest.India_Equity_Single__c = 'Default';
            euprodrequest.India_Equity_Cum__c = 'Default';
            euprodrequest.Taiwan_Equity_Single__c = 'Default';
            euprodrequest.Taiwan_Equity_Cum__c = 'Default';
            euprodrequest.Korea_Equity_Single__c = 'Default';
            euprodrequest.Korea_Equity_Cum__c = 'Default';
            euprodrequest.Korea_Onshore_Net_Limit__c = 'Default';
            euprodrequest.Broker_Markets_Single__c = 'Default';
            euprodrequest.Broker_Markets_Cum__c = 'Default';
            euprodrequest.Japan_Futures_Single__c = 'Default';
            euprodrequest.Japan_Futures_Cum__c = 'Default';
            euprodrequest.HK_SI_AU_Futures_Single__c = 'Default';
            euprodrequest.HK_SI_AU_Futures_Cum__c = 'Default';
            euprodrequest.India_Futures_Single__c = 'Default';
            euprodrequest.India_Futures_Cum__c = 'Default';
            euprodrequest.Taiwan_Futures_Single__c = 'Default';
            euprodrequest.Taiwan_Futures_Cum__c = 'Default';
            euprodrequest.Korea_Futures_Single__c = 'Default';
            euprodrequest.Korea_Futures_Cum__c = 'Default';
            
            euprodrequest.HK_SI_AU_Equity_Single__c = 'Default';
            euprodrequest.HK_SI_AU_Equity_Cum__c = 'Default';
            
            euprodrequest.HK_SI_AU_Futures_Single__c = 'Default';
            euprodrequest.HK_SI_AU_Futures_Cum__c = 'Default';
            euprodrequest.India_Futures_Single__c = 'Default';
            euprodrequest.India_Futures_Cum__c = 'Default';
            euprodrequest.Taiwan_Futures_Single__c = 'Default';
            euprodrequest.Taiwan_Futures_Cum__c = 'Default';
            euprodrequest.Korea_Futures_Single__c = 'Default';
            euprodrequest.Korea_Futures_Cum__c = 'Default';
            
            euprodrequest.HK_Futures_Cum__c = 'Default';
            
            euprodrequest.AU_Futures_Single__c = 'Default';
            euprodrequest.AU_Futures_Cum__c = 'Default';
            
            euprodrequest.SI_Futures_Single__c = 'Default';
            euprodrequest.SI_Futures_Cum__c = 'Default';
            
            euprodrequest.HK_Equity_Single__c = 'Default';
            euprodrequest.HK_Equity_Cum__c = 'Default';
            euprodrequest.AU_Equity_Single__c = 'Default';
            euprodrequest.AU_Equity_Cum__c = 'Default';
            euprodrequest.SI_Equity_Single__c = 'Default';
            euprodrequest.SI_Equity_Cum__c = 'Default';
            
            setDefaultForETSDB();
            // singhrak, 2dec, 14 TASK3503858
            euprodrequest.MSPOOL_Crossing__c = 'far peg';
            
            // singhrak, REQ3690384, 17Apr, 2015, start
             euprodrequest.Product_Repair__c = 'No';
            // singhrak, REQ3690384, 17Apr, 2015, end
            
        }
        else
        {
            PageTitle = euprodrequest.name;
            LastModifiedBy = euprodrequest.LastModifiedBy.name + ' ' + euprodrequest.LastModifiedDate;
            euprodrequest.Previous_Status__c = euprodrequest.Priority__c;
            if(euprodrequest.Priority_Comment__c!=null)
              {Priority_Comment_Flag=1;}
            String[] toIntegrators;
            if(euprodrequest.Integrator__c != null){  
              toIntegrators = euprodrequest.Integrator__c.split(';');
              toAddresses = new String[]{};
                for(Integer i=0; i< toIntegrators.size() ; i++){
                    if(toIntegrators[i] == 'Unassigned_NA' || toIntegrators[i] == 'Unassigned_EU' || toIntegrators[i] == 'Unassigned_FE')
                       continue;
                    else
                       toAddresses.add(toIntegrators[i]); 
                       }
                }
            
            //17-may-16 himanb reverting this change
        /*  String urlStringName = ApexPages.currentPage().getUrl();
            if(urlStringName.length()>100){
            editValuesOnClick();
            } 
            //REQ5555415 kumvina,15062016
            if(euprodrequest.Status__c == 'Waiting Deployment'||euprodrequest.Status__c == 'Complete'||euprodrequest.Status__c == 'Cancelled'){
              ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.warning, 'Only use Clone to add Additional info');  
              ApexPages.addMessage(errMsg);
          }*/
        
        }
        if (euprodrequest.Status__c == null && euprodrequest.Id == null) {
            euprodrequest.Status__c = 'Submitted';
            euprodrequest.NJA_Pool__c = true;
            euprodrequest.India_Commission__c = 15;
            euprodrequest.Korea_Commission__c = 8;
            euprodrequest.Taiwan_Commission__c = 8;
            euprodrequest.Japan_Commission__c = 6;
            euprodrequest.Asia_Core_Markets_Commission__c = 6;
            //euprodrequest.MSPOOL_Crossing__c = 'far peg';
            euprodrequest.Pool_Crossing__c = true;
            euprodrequest.Japan_SORT__c = true;
            euprodrequest.Default_to_SORTDMA__c = true;
            euprodrequest.Japan_TrajectoryCross__c = true;
            
            
        }
        
        String flowType = getParam('flow');
                
        if(flowType != null && flowType.equals('clone')){
          euprodrequest.Status__c = 'Submitted';
          euprodrequest.Set_up_type__c = null;
          euprodrequest.RequestedBy__c = UserInfo.getUserId();
          euprodrequest.Comments__c = '';           ////REQ5555415 kumvina,15062016
          euprodrequest.Priority__c = null;
          euprodrequest.TargetDate__c = null;
          euprodrequest.NA_Integration_Status__c = null;
          euprodrequest.EU_Integration_Status__c = null;
          euprodrequest.AP_Integration_Status__c = null;
          euprodrequest.NA_Integration_Comments__c = '';
          euprodrequest.EU_Integration_Comments__c = '';
          euprodrequest.AP_Integration_Comments__c = '';
          euprodrequest.Asia_EtsClients_Effort_Level__c = null;
          euprodrequest.Prioritized_for_EtsClients__c = false;
          euprodrequest.NA_Integration_Start_Date__c = null;
          euprodrequest.Integrator__c = null;
          euprodrequest.Dependency__c = null;
          autoIntegratorAssignment();
          Priority_Comment_Flag=0;
          Screen_Signed_Off_Flag=0;
          euprodrequest.Previous_Status__c = null;
          euprodrequest.Priority_Comment__c = null;
          
        }
        String accountSearch = ApexPages.currentPage().getParameters().get('accid'); /*REQ7615527 & REQ7615387;kumvina ;22sep2017 start*/
       
        if(accountSearch!=null && accountSearch!=''){
            searchText = accountSearch;
            doSearch();
        }/*REQ7615527 & REQ7615387;kumvina ;22sep2017 end*/
        
        //OMS_Vendor__c omv;
        List<OMS_Vendor__c > omv = [select Id,Name from OMS_Vendor__c where Name = 'Bloomberg' limit 1 ];
        
        if(omv.size()>0)
        BloombergId = omv[0].Id;
        //System.debug('Inside new:'+euprodrequest.UUID_User_Number_Name__c);
        
        //himanb REQ5291267 18-Apr-2016
         if(euprodrequest.IntegratorSet__c == false)
         {  
            integratorValueForUser();
         }
         if(this.euprodrequest.Add_Another__c==true)
            {
                Add_Another_Flag = 1;
            }
    }
    
    
    

//17-may-16 himanb reverting this change
 /* 
 //kumvina REQ5321074 11may2016    
 public void editValuesOnClick() {
       if(euprodrequest.Status__c == 'Complete'||euprodrequest.Status__c == 'Cancelled'){
        // 17-may-16 himanb commenting out Waiting Deploymen due to prod issue
       //||euprodrequest.Status__c == 'Waiting Deployment'){
            euprodrequest.Status__c = 'Submitted';
            euprodrequest.TargetDate__c =null;
            euprodrequest.Priority__c ='';
                
          }
  }   */
    
    
    // singhrak, REQ3797585, 14May, 2015, start    
public void settComment()
{
    euprodrequest.Comments__c = euprodrequest.Comments__c;
}
// singhrak, REQ3797585, 14May, 2015, end
    
    
    public Integer equitySwapsMarkets{get;set;}
    
    //calcHKSHStockConnectFlag
    public void calcEquitySwapsMarkets()
    {
    if(euprodrequest.Asia_Pacific_Flow_Details__c!=null && (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1 ||
    euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1 ||
     euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('FIX to PassportWin') != -1 ||  euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('MS Port') != -1 ||
      euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Pairs') != -1) && euprodrequest.Asset_Class__c!= null) 
      {
           String[] part;
           part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
            for(String z:part)
            {
                          if(z=='Equity Swaps')
                          {
                            equitySwapsMarkets = 1;
                            break;
                          }
                          else
                            equitySwapsMarkets = 0;
            }
              
      }
      else{
      equitySwapsMarkets = 0;
      }
      calcEquitySwapsMarketsLimitsFlag();
    }
    
    
        public Integer LimitsSectionDisplayFlagESM {get;set;}
    
    public Integer AUEquityLimitsFlagESM {get;set;}
    public Integer SIEquityLimitsFlagESM {get;set;}
    public Integer JapanEquityLimitsFlagESM {get;set;}
    public Integer AsiaEquityLimitsFlagESM {get;set;}
    public Integer IndiaEquityLimitsFlagESM {get;set;}
    public Integer TaiwanEquityLimitsFlagESM {get;set;}
    public Integer KoreaEquityLimitsFlagESM {get;set;}
    public Integer ChinaEquityLimitFlagESM {get;set;}
    public Integer HKEquityLimitsFlagESM {get;set;}
    public Integer BrokerEquityLimitsFlagESM {get;set;}
    public Integer ChinaASCEquityLimitsFlagESM {get;set;}
    
    public Integer ChinaASCEquityLimitsFlag {get;set;}
    public void calcEquitySwapsMarketsLimitsFlag()
    {
        LimitsSectionDisplayFlagESM = 0;
        if(equitySwapsMarkets == 1 && euprodrequest.Equity_Swap_Markets__c!=null)
        { 
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('AU') != -1 )
            {   AUEquityLimitsFlagESM = 1;
                LimitsSectionDisplayFlagESM = 1;
            }
            else 
                AUEquityLimitsFlagESM = 0;
               
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('SI') != -1 )
                {
                    SIEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                SIEquityLimitsFlagESM = 0;
                
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('Japan') != -1 )
                {
                    JapanEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                JapanEquityLimitsFlagESM = 0;   
                
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1 )
                {
                    AsiaEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                AsiaEquityLimitsFlagESM = 0;
                
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('India') != -1 )
                {
                    IndiaEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                IndiaEquityLimitsFlagESM = 0;
            
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('Taiwan') != -1 )
                {
                    TaiwanEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                TaiwanEquityLimitsFlagESM = 0;              
            
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('Korea') != -1 )
                {
                    KoreaEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                KoreaEquityLimitsFlagESM = 0;
        
                    String[] part;
                    part = (String.valueOf(euprodrequest.Equity_Swap_Markets__c)).split(';',0);
                       for(String z:part)
                       {
                        if(z=='China A(QFII)' || z=='China B')
                        {
                            ChinaEquityLimitFlagESM = 1;
                            LimitsSectionDisplayFlagESM = 1;
                            break;
                        }
                        else
                            ChinaEquityLimitFlagESM = 0;
                       }
/*
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('China A') != -1 || euprodrequest.Equity_Swap_Markets__c.indexOf('China B') != -1 )
                {
                    
                    ChinaEquityLimitFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                ChinaEquityLimitFlagESM = 0;
    */          
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('HK') != -1 )
                {
                    HKEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                HKEquityLimitsFlagESM = 0;      
        
            if(euprodrequest.Equity_Swap_Markets__c.indexOf('Indonesia')!= -1 || euprodrequest.Equity_Swap_Markets__c.indexOf('Philippines')!= -1 || 
            euprodrequest.Equity_Swap_Markets__c.indexOf('Malaysia')!= -1 || euprodrequest.Equity_Swap_Markets__c.indexOf('Thailand')!= -1
            || euprodrequest.Equity_Swap_Markets__c.indexOf('New Zealand')!= -1 //// singhrak, 4 Dec, 14 TASK3551306
            )
            {
                BrokerEquityLimitsFlagESM = 1;
                LimitsSectionDisplayFlagESM = 1;
            }
            else
              BrokerEquityLimitsFlagESM = 0;
              
              if(euprodrequest.Equity_Swap_Markets__c.indexOf('China A(Stock Connect)') != -1 )
                {
                    ChinaASCEquityLimitsFlagESM = 1;
                    LimitsSectionDisplayFlagESM = 1;
                }
            else
                ChinaASCEquityLimitsFlagESM = 0;    
        }
        else
        {
        LimitsSectionDisplayFlagESM = 0;
AUEquityLimitsFlagESM = 0;
SIEquityLimitsFlagESM = 0;
JapanEquityLimitsFlagESM = 0;
IndiaEquityLimitsFlagESM = 0;
AsiaEquityLimitsFlagESM = 0;
IndiaEquityLimitsFlagESM = 0;
TaiwanEquityLimitsFlagESM = 0;
KoreaEquityLimitsFlagESM = 0;
ChinaEquityLimitFlagESM = 0;
HKEquityLimitsFlagESM = 0;
BrokerEquityLimitsFlagESM = 0; 
ChinaASCEquityLimitsFlagESM = 0;

        } 
    }
    
    public Integer ippanJapanFlag {get;set;}
    public void calcIppanJapanFlag()
    {
        if(euprodrequest.Asia_Pacific_Flow_Details__c != null && euprodrequest.Asset_Class__c!=null && euprodrequest.Asia_Pacific_Markets__c!=null
        && euprodrequest.Asia_Pacific_Markets__c.indexOf('Japan') != -1)
        {
              String[] part;
             part = (String.valueOf(euprodrequest.Asset_Class__c )).split(';',0);
           for(String z:part)
           {
              if(z=='Equity')
              {
                ippanJapanFlag = 1;
                break;
              }
              else
              {
                ippanJapanFlag = 0;
                Ippan_Margin_Flag  = 0;
              }
           }
        }
        else
              {
                ippanJapanFlag = 0;
                Ippan_Margin_Flag  = 0;
              }
        
    }
    
    public void setDefaultForETSDB()
    {
        String flowType = getParam('flow');
        if(flowType == null)
        {
        euprodrequest.Priority_ETS__c = 'Medium';
        euprodrequest.EOD_Request_Type__c = 'New Setup';
        euprodrequest.Report_Type__c = 'Standard TC Giveup';
        euprodrequest.Business_Line__c = 'CLSITTRD';
        euprodrequest.Frequency_of_Report__c = 'Daily';
        euprodrequest.Commissions_fees_needed__c = 'No'; 
        euprodrequest.Need_unfilled_orders__c = 'No';
        euprodrequest.Aggregation_Level__c = 'Order';
        euprodrequest.List_of_Applications__c = 'RAZER';
        }
    }
    
    public Integer estdbFlag {get;set;}
    
    public void calcEstdbFlag()
    {
    if((euprodrequest.North_America_Flow_Details__c !=null || euprodrequest.Europe_Flow_Details__c !=null || euprodrequest.Asia_Pacific_Flow_Details__c!=null) &&
    euprodrequest.Asset_Class__c!=null)
    {
         String[] part;
         part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
         for(String z:part)
         {
           if(z=='Equity' || z=='Equity Swaps')
           {
           estdbFlag = 1;
           break; 
           }
           else
            estdbFlag = 0;
           
         }
                
    }
    else
        estdbFlag = 0;
    
    }
    
    public Integer ETSBSActionFlag{get;set;}
    public void calcETSBSAction()
    {
        if(estdbFlag == 1 && euprodrequest.Trigger_ETSDB_Report_form__c!= null && euprodrequest.Trigger_ETSDB_Report_form__c=='Yes')
        {
        ETSBSActionFlag = 1;
        } 
        else 
        ETSBSActionFlag = 0;
    }

    public void createETSDB()
    {
    
    RecordType RecTypeId=[Select Id,Name,DeveloperName from RecordType where Name='ETSDBReportsandDataRequests'];
    
    Product_Request__c  c = new Product_Request__c();
    c.Priority__c = euprodrequest.Priority_ETS__c;
    c.Request_Types__c = euprodrequest.EOD_Request_Type__c; 
    c.List_of_Applications__c = euprodrequest.List_of_Applications__c; 
    c.Report_Type__c =euprodrequest.Report_Type__c ;
    c.Regions__c = euprodrequest.Region__c;
    c.Business_Line__c = euprodrequest.Business_Line__c; 
    c.Run_Time__c = euprodrequest.Run_Time__c ;
    c.Delivery_Type__c = euprodrequest.Delivery_Type__c; 
    c.Frequency_of_Report__c =euprodrequest.Frequency_of_Report__c; 
    c.Email_recipients_OR_Client_contact__c = euprodrequest.Email_recipients_OR_Client_contact__c; 
    c.Commissions_fees_needed__c = euprodrequest.Commissions_fees_needed__c ;
    c.Need_unfilled_orders__c = euprodrequest.Need_unfilled_orders__c ;
    c.Aggregation_Level__c = euprodrequest.Aggregation_Level__c ;
    c.Fields_to_include__c = euprodrequest.Fields_to_include__c; 
    c.MSET_Account__c = euprodrequest.MSET_Account__c;
//    c.Status = ''; 
    c.RecordTypeId = RecTypeId.Id;
    c.DisableTriggerFlag__c = true;
    c.Requested_by__c = euprodrequest.RequestedBy__c;
    insert  c;
    //c.DisableTriggerFlagLU__c='disable368';
    
    }
    
    
    
    
    public Integer darkPoolCheckedFlag {get; set;}
     public Integer getdarkPoolCheckedFlag()
    {
      return darkPoolCheckedFlag;
    }
    
    public void calcDarkPoolCheckedFlag()
    {  //REQ5098984, kumvina, 02FEB , 2016
        /*if(
        euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup') &&
       euprodrequest.Status__c != null && euprodrequest.Status__c == 'Submitted' 
      && (euprodrequest.Asia_Pacific_Flow_Details__c != null && euprodrequest.Asia_Pacific_Flow_Details__c != '')
       && euprodrequest.Asia_Pacific_Markets__c != null && (euprodrequest.Asia_Pacific_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1
       || euprodrequest.Asia_Pacific_Markets__c.indexOf('HK') != -1)
        && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) ) && 
       euprodrequest.Name == null
        )
           { //REQ5098984, vinay, 02FEB , 2016
            
                    String[] part;
                    part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity')
                         {
                            euprodrequest.Enable_for_HK_MSPool__c = true;
                            euprodrequest.Enable_for_HK_Trajectory_Cross__c = true;
                            break;
                         }
                         else
                         {
                            euprodrequest.Enable_for_HK_MSPool__c = false;
                            euprodrequest.Enable_for_HK_Trajectory_Cross__c = false;
                         }
                       }
           }
           else
           {
            if(euprodrequest.Name == null)
            {
             euprodrequest.Enable_for_HK_MSPool__c = false;
             euprodrequest.Enable_for_HK_Trajectory_Cross__c = false;   
            }
            
           }*///REQ5098984, kumvina, 02FEB , 2016 
               calcDisableDarkPoolControl(); //done on 3rd march
             calcMandatoryField();  
    }
    
    public Integer MandatoryFileUpload = 0;
    public Integer getMandatoryFileUpload()
    {
      return MandatoryFileUpload;
    }
    
    public void calcMandatoryField()
    {
        if( (
        (euprodrequest.Enable_for_HK_MSPool__c != null && euprodrequest.Enable_for_HK_MSPool__c == true)  
        || 
        (euprodrequest.Enable_for_HK_Trajectory_Cross__c != null && euprodrequest.Enable_for_HK_Trajectory_Cross__c == true))
        &&(euprodrequest.Status__c != null && euprodrequest.Status__c == 'Submitted' &&
                euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup' || euprodrequest.Set_up_type__c == 'Modify Client Setup') && (euprodrequest.Asia_Pacific_Markets__c != null  &&
                (euprodrequest.Asia_Pacific_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('HK') != -1 )
                )) && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) ) ) 
          {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
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
    
        public Integer hksfcFlag;
    
    public Integer getHksfcFlag(){
        return hksfcFlag;
    }
    public void showhideHKSFCCheckbox()
    {
        String flowType = getParam('flow');
        if(euprodrequest.Name == null || (flowType != null && flowType == 'clone'))
        {
            hksfcFlag = 1;
        }
        else
            hksfcFlag = 0;
    }
    
    Integer hksfcMandatoryFlag;
    public Integer getHksfcMandatoryFlag()
    {
        return hksfcMandatoryFlag;
    }
    
    public void calcMandatoryFieldForHKSFC()
    {
        if(euprodrequest.hksfc__c == false)
        {
            hksfcMandatoryFlag = 0;
        } 
        else
        {
                    if(euprodrequest.Name == null)
            {
            if(euprodrequest.Status__c !=null && euprodrequest.Status__c == 'Submitted' && 
            euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup' || euprodrequest.Set_up_type__c == 'Modify Client Setup')
                && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) )
        ) 
                  {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if((z=='Equity' || z=='Options on Futures' || z=='Options' || z=='Futures') && euprodrequest.hksfc__c == true)
                          {
                            hksfcMandatoryFlag = 1; 
                          }
                       }
                  }
           }
        }
        
    }
    
    
    public void calcHksfc()
    {
        if(euprodrequest.Name == null)
        {
            if(euprodrequest.Status__c !=null && euprodrequest.Status__c == 'Submitted' && 
            euprodrequest.Set_up_type__c != null && euprodrequest.Set_up_type__c == 'New Client Setup'
                && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) )
        ) 
                  {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity' || z=='Options on Futures' || z=='Options' || z=='Futures')
                          {
                            //euprodrequest.hksfc__c = true ;     //REQ5098984, kumvina, 02FEB , 2016
                            hksfcMandatoryFlag = 1;     
                              break;
                          }
                          else
                          {
                            hksfcMandatoryFlag = 0;
                            euprodrequest.hksfc__c = false ;
                          }
                            
                       }
                  }
                  else
                  {
                    euprodrequest.hksfc__c = false ;
                     hksfcMandatoryFlag = 0;
                  }
                     
            
            calcAsiaTradingDesk();
        }
    }
    
        public void calcAsiaTradingDesk()
    {
        if(this.euprodrequest.MSET_Account__c != null && euprodrequest.Name == null)
        
          {
            
            MSET_Account__c account = [select Asia_Trading_Desk_Country__c from MSET_Account__c where Id = :euprodrequest.MSET_Account__c];
            String apMarkets = null;
            String asiaTrading = null;
            if(account != null && euprodrequest.MSET_Account__c!=null  && account.Asia_Trading_Desk_Country__c != null &&  
            euprodrequest.Asia_Pacific_Markets__c != null)
            {
                asiaTrading = account.Asia_Trading_Desk_Country__c;
                apMarkets = euprodrequest.Asia_Pacific_Markets__c;
                if(asiaTrading!= null &&
                (asiaTrading.equalsIgnoreCase('India') || asiaTrading.equalsIgnoreCase('Japan') || asiaTrading.equalsIgnoreCase('Australia')))
                {
                    if(asiaTrading.equalsIgnoreCase(apMarkets)) 
                    {
                        hksfcMandatoryFlag = 0;
                        euprodrequest.hksfc__c = false ;
                    }
                    else if(asiaTrading.equalsIgnoreCase('Australia') && apMarkets == 'AU')
                    {
                        euprodrequest.hksfc__c = false ;
                        hksfcMandatoryFlag = 0;
                    }
                }
            }
            
            
                
                
                asiaTrading = account.Asia_Trading_Desk_Country__c;
                apMarkets = euprodrequest.Asia_Pacific_Markets__c;
                if(asiaTrading == null || !asiaTrading.equalsIgnoreCase('HONG KONG'))
                {
                    if(apMarkets != null)
                    { 
                        if( (euprodrequest.Asia_Pacific_Markets__c.indexOf('AU') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('India') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('Japan')  != -1) && 
                         !(euprodrequest.Asia_Pacific_Markets__c.indexOf('China A') != -1   || euprodrequest.Asia_Pacific_Markets__c.indexOf('China B')  != -1||  euprodrequest.Asia_Pacific_Markets__c.indexOf('HK')  != -1|| euprodrequest.Asia_Pacific_Markets__c.indexOf('Indonesia') != -1 || 
                         euprodrequest.Asia_Pacific_Markets__c.indexOf('Korea')  != -1|| euprodrequest.Asia_Pacific_Markets__c.indexOf('Malaysia') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('New Zealand')  != -1|| euprodrequest.Asia_Pacific_Markets__c.indexOf('SI') != -1 || 
                         euprodrequest.Asia_Pacific_Markets__c.indexOf('Taiwan') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('Thailand') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('Philippines ') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1
                         )
                         )
                         {
                                euprodrequest.hksfc__c = false ;
                                hksfcMandatoryFlag = 0;
                         }
                    }
                }
            
        }
    }
    
        public Integer showUploadedaFileName;
    public Integer getshowUploadedaFileName()
    {
        return showUploadedaFileName;
    }
    
    public Integer blockFileUploadFlag;
    public Integer getBlockFileUploadFlag()
    {
        return blockFileUploadFlag;
    }
    public void calcshowUploadedaFileName()
    {
        String flowType = getParam('flow');
        if(euprodrequest.Name == null || (flowType != null && flowType == 'clone'))
        {
            blockFileUploadFlag = 1;
            showUploadedaFileName = 2; //whe 0, make it editable
        }
           
        else
        {
              if(euprodrequest.Status__c != null && euprodrequest.Status__c == 'Submitted' && 
              (euprodrequest.Asia_Pacific_Flow_Details__c != null && euprodrequest.Asia_Pacific_Flow_Details__c != '')
       && euprodrequest.Asia_Pacific_Markets__c != null && (euprodrequest.Asia_Pacific_Markets__c.indexOf('HK') != -1 ||
       euprodrequest.Asia_Pacific_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1) &&  euprodrequest.Set_up_type__c != null &&
                euprodrequest.Set_up_type__c == 'New Client Setup' && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) ))
               {
                            String[] part;
                             part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
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
    
    public void attachUploadedFileInTicket(String id,String fileName)
    {
         document1.ParentId = id;
       document1.Name=fileName;
       insert document1;
    }
    
    public void attachUploadedFileInTicketHKSFC(String id)
    {
         document2.ParentId = id;
       document2.Name= document2.Name+'(HK SFC)';
       insert document2;
    }
    
      public Boolean checkFileValidations()
  {
      // For REQ1042945 , FIle upload
       Boolean result = false;
       Integer uploadcriteria = 0;
//        if(euprodrequest.Name == null && (euprodrequest.Enable_for_HK_MSPool__c == true  || euprodrequest.Enable_for_HK_Trajectory_Cross__c == true))
        if((euprodrequest.Enable_for_HK_MSPool__c == true  || euprodrequest.Enable_for_HK_Trajectory_Cross__c == true)
                &&(euprodrequest.Status__c != null && euprodrequest.Status__c == 'Submitted' &&
                euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup' || euprodrequest.Set_up_type__c == 'Modify Client Setup') && (euprodrequest.Asia_Pacific_Markets__c != null  &&
                (euprodrequest.Asia_Pacific_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('HK') != -1 )
                )) && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) )) 
          {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0); 
                       for(String z:part)
                       {
                          if(z=='Equity') 
                          {
                            uploadcriteria = 1;
                              if((fileNameMy == '' || fileNameMy == null) && euprodrequest.name == null)
                              {
                                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: If either/both the checkbox are selected in HK \'Dark Pool\' section then it is mandatory to upload file.');
                                    ApexPages.addMessage(myMsg);
                                    result = true;
                                    break;
                              }
                
                             if(fileNameMy!=null)
                               {
                                if(fileSizeDP <=0)
                                {// blocking of empty file being uploaded
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Empty file cannot be uploaded.');
                                  ApexPages.addMessage(myMsg);
                                  fileNameMy = null;
                                  document1.body = null;
                                  result = true;
                                }
                                
                              
                               }
                          }
                       }
                       
                       if(uploadcriteria == 0 && euprodrequest.name == null && fileNameMy != null)
                       {
                       //      if(euprodrequest.Enable_for_HK_MSPool__c == false  && euprodrequest.Enable_for_HK_Trajectory_Cross__c == false)
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
                if(uploadcriteria == 0 && euprodrequest.name == null && fileNameMy != null)
                       {
                       //      if(euprodrequest.Enable_for_HK_MSPool__c == false  && euprodrequest.Enable_for_HK_Trajectory_Cross__c == false)
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
            if(euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup' || euprodrequest.Set_up_type__c == 'Modify Client Setup')
                && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) )
        && euprodrequest.Name == null
        ) 
                  {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if((z=='Equity' || z=='Options on Futures' || z=='Options' || z=='Futures') && euprodrequest.hksfc__c == true )
                          {
                            hksfc = 1;
                               if(document2.name == null)
                               {
                                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: If HKSFC checkbox is checked, its mandatory to upload file.');
                                  ApexPages.addMessage(myMsg);
                                  document2.body = null;
                                  document2.name = null;
                                  result = true;
                               }   
                                  
                          }
                       }
                  }
                   
                        
          if(hksfc == 0 && document2.name != null && euprodrequest.Name == null)
                       {
                       //      if(euprodrequest.Enable_for_HK_MSPool__c == false  && euprodrequest.Enable_for_HK_Trajectory_Cross__c == false)
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

  

 /* kumvina code for lookup*/
  
  public string searchText;
  public List<MSET_Account__c> results;
    public String getSearchText() {
        return searchText;
    }
    public void setSearchText(String s) {
    searchText = s;
    }
    public List<MSET_Account__c> getResults() {
    return results;
    }
    
    public PageReference doSearch() {/*REQ7615527 & REQ7615387;kumvina ;22sep2017 start*/
        string query='';
        if(searchText!=null && searchText!=''){
                if(srtingValidate(searchText)==1){
                    query='select id,Location__c, Name,TNL_ID__c,Trading_Name_ID__c,Short_Trading_Name__c,Trading_Name__c from MSET_Account__c where TNL_ID__c=\''+searchText+'\' and RecordType.Name =\'TNL\' limit 100';
                }
                /*if(srtingValidate(searchText)==2){
                    query='select id,Site, Name,RecordType.Name,TNL_ID__c,A2TradingName__c,A2TradingNameShort__c,Trading_Name_ID__c from MSET_Account__c where Trading_Name_ID__c=\''+searchText+'\' and RecordType.Name =\'TNL\' limit 100';
                }*/
                if(srtingValidate(searchText)==0){
                     query='select id,Location__c, Name,TNL_ID__c,Trading_Name_ID__c,Short_Trading_Name__c,Trading_Name__c from MSET_Account__c where name like \'' +searchText+'%\' and RecordType.Name =\'TNL\' limit 100';
                    }
          results = Database.query(query);
          if(results.size()==null){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'No result as found'); 
            ApexPages.addMessage(myMsg);
          }
        }
        return null;
        }
        
    public integer srtingValidate(string a){
        if(a!=null&& a!=''){
            if(a.startsWith('TNL') && a.length()==11){
                return 1;
            }/*else if(a.startsWith('TN')&& a.length()==11){
                return 2;
            }  */ 
        }
        return 0;
    }   /*REQ7615527 & REQ7615387;kumvina ;22sep2017 end*/
    
    public void setState(String n) {
        state = n;
    }
            
    public String getState() {
        return state;
    }
    public String AccountMapName{get;set;}
            
    public PageReference methodOne() {
            euprodrequest.MSET_Account__c=ID.valueOf(state);
            MSET_Account__c acmapped=[select id,name,Location__c,Short_Trading_Name__c,Trading_Name_ID__c,TNL_ID__c from MSET_Account__c where id=:ID.valueOf(state)];
            system.debug('**acmapped*'+acmapped);
            AccountMapName = acmapped.Name;
        return null;
    }
            
 private String state = 'no';
 public string rightselected{get;set;}  
 public string search1{get;set;}
 public string search2{get;set;} 
 
 public list<Selectoption> getlistCloumn(){
    List<Selectoption> listcloumn = new list<Selectoption>();
    String SobjectApiName = 'MSET_Account__c';
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset()){
                  listcloumn.add(new SelectOption(fieldName,fieldName));
                
     }
     
     return listcloumn;
 }
 

  public void sendEmailto_hksfc(String id)
  {
        try {
       
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          String[] toAddresses = new String[] {Label.EUProductRequest_email1,Label.EUProductRequest_Email2}; //jira:MSETSF-413 kumvina 06June2016 
//          hketregs@ms.com.test  and asiaonboarding@ms.com.test
          mail.setToAddresses(toAddresses);
//         mail.setTargetObjectId(UserInfo.getUserId());
          mail.setSaveAsActivity(false);
          Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[1];
          Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
          fileAttachment.setBody(document2.body);
          fileAttachment.setFileName(document2.name);
          fileAttachments[0] = fileAttachment;
          
          mail.setFileAttachments(fileAttachments);
         EU_ProductRequest__c  euprodreq = [select MSET_Account__r.TNL_ID__c from EU_ProductRequest__c  where Id = :id ];
          mail.setSubject(euprodreq.MSET_Account__r.TNL_ID__c + '  ? HK SFC Attestation received' );
          mail.setHtmlBody('Requestor: '+ UserInfo.getUserEmail()+'<br></br>'
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
          String[] toAddresses = new String[] {Label.EUProductRequest_Email6,Label.EUProductRequest_Email2};//jira:MSETSF-413 kumvina 06June2016
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
      EU_ProductRequest__c  euprodreq = [select RequestedBy__r.name, Name, MSET_Account__r.name,MSET_Account__r.TNL_ID__c from EU_ProductRequest__c  where Id = :id ];
      String str='Product Request No.: '+ euprodreq.Name + '<br></br>' +
          'Account: '+ euprodreq.MSET_Account__r.name + '<br></br>' +
          'A2 TNL ID: ' + euprodreq.MSET_Account__r.TNL_ID__c + '<br></br>' +
          'Requested by: ' + euprodreq.RequestedBy__r.name  + '<br></br><br></br>';
      
      String []emailContent= new String[]{str,euprodreq.MSET_Account__r.TNL_ID__c};
      return emailContent;
    }
    
    public Integer disableDarkPoolControlFlag;
    public Integer getdisableDarkPoolControlFlag()
    {
        return disableDarkPoolControlFlag;
        
    }
    
    public void calcDisableDarkPoolControl()
    {
        if(euprodrequest.name != null)
        {// chk for status not null
            if(euprodrequest.Status__c != null && euprodrequest.Status__c!='Submitted')
              showUploadedaFileName = 1;
              else
              {
                if(euprodrequest.Asia_Pacific_Flow_Details__c != null && 
                euprodrequest.Asia_Pacific_Flow_Details__c !='' && 
                euprodrequest.Asia_Pacific_Markets__c != null && 
                (euprodrequest.Asia_Pacific_Markets__c.indexOf('HK') != -1  || euprodrequest.Asia_Pacific_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1 )&&
                euprodrequest.Status__c != null && euprodrequest.Status__c=='Submitted' && euprodrequest.Set_up_type__c != null &&
                euprodrequest.Set_up_type__c == 'New Client Setup' && euprodrequest.Asset_Class__c != null  && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) )
                )
                {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
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
    

    public Integer SIEquityLimitsFlag = 0;
    public Integer HKEquityLimitsFlag = 0;
    public Integer AUEquityLimitsFlag = 0;
    
      public Integer getSIEquityLimitsFlag()
  {
    return SIEquityLimitsFlag;
  }
  
  public Integer getHKEquityLimitsFlag()
  {
    return HKEquityLimitsFlag;
  }
  
  
  public Integer getAUEquityLimitsFlag()
  {
    return AUEquityLimitsFlag;
  }

  public Integer AUOptionsLimitsFlag;
  public Integer getAUOptionsLimitsFlag()
  {
    return AUOptionsLimitsFlag;
  }
  
  public Integer SIOptionsLimitsFlag;
    public Integer getSIOptionsLimitsFlag()
  {
    return SIOptionsLimitsFlag;
  }
  
  public Integer HKOptionsLimitsFlag;
    public Integer getHKOptionsLimitsFlag()
  {
    return HKOptionsLimitsFlag;
  }
  
  
  public Integer AUFuturesLimitsFlag;
    public Integer getAUFuturesLimitsFlag()
  {
    return AUFuturesLimitsFlag;
  }
  public Integer SIFuturesLimitsFlag;
    public Integer getSIFuturesLimitsFlag()
  {
    return SIFuturesLimitsFlag;
  }
  public Integer HKFuturesLimitsFlag;
    public Integer getHKFuturesLimitsFlag()
  {
    return HKFuturesLimitsFlag;
  }
    
    // R09171623, start
 
    public Integer msetclientType=0;
    public Integer getmsetclientType()
    {
      return msetclientType;
    } 
   
    // R09171623, end
    
    public void calcAccount()
    {
        if(accountIdDigits!=null  && accountIdDigits!=''){/*REQ7615527 & REQ7615387;kumvina ;22sep2017 start*/
            this.euprodrequest.MSET_Account__c=Id.valueOf(accountIdDigits);
        }/*REQ7615527 & REQ7615387;kumvina ;22sep2017 end*/
        if(this.euprodrequest.MSET_Account__c!=null)
        {
          MSET_Account__c acct = [select Name,MSET_Client_Type__c,TNL_ID__c,MSET_Platinum_Focus__c,Trading_Name_ID__c from MSET_Account__c where Id =: this.euprodrequest.MSET_Account__c];
          //MSET_Account__c acct=(MSET_Account__c)tempList.get(0);
          accountIdDigits=acct.id;/*REQ7615527 & REQ7615387;kumvina ;22sep2017 */
          accountNamedata = acct.name;/*REQ7615527 & REQ7615387;kumvina ;22sep2017 */
          
           if(euprodrequest.Asia_Pacific_Flow_Details__c!=null 
           && (this.euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1 ||
          this.euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1 ||
          this.euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('MS Port') != -1|| 
          this.euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Pairs') != -1)
           && ( acct.MSET_Client_Type__c==null || acct.MSET_Client_Type__c=='') )
              msetclientType=1;       
           else
            msetclientType=0;
            
            
            this.euprodrequest.A2_TNL_Id__c = acct.TNL_ID__c;
          this.euprodrequest.MSET_Platinum_focus__c = acct.MSET_Platinum_focus__c;
          this.euprodrequest.A2_TN_Id__c = acct.Trading_Name_ID__c;
        }
        else
           msetclientType=0;
           
       //singhrak, 26Feb 2015, REQ3455449, start
        if(euprodrequest.name == null)
           calcAccountPassport();
           //singhrak, 26Feb 2015, REQ3455449, end
           
    }
    
    
    //singhrak, 26Feb 2015, REQ3455449, start
    public void calcAccountPassport()
    {
        system.debug(euprodrequest.Vendor__c+'passport::'+euprodrequest.Network_Connectivity__c);
        List<MSET_Account__c> act = [select Id,name from MSET_Account__c where name = 'PASSPORT' /*and recordtypeid = '012300000000AA5AAM'*/ ];// MSET Migration      
        
        
        if(act.size()>0 && euprodrequest.MSET_Account__c != null && act[0] !=null && euprodrequest.MSET_Account__c == act[0].Id)
        { 
            euprodrequest.Vendor__c = true;
            List<OMS_Vendor__c> obj = [select Id from OMS_Vendor__c where name='Passport'];
            if(obj.size()>0)
            euprodrequest.OMS_Vendor__c =  obj[0].Id;
            
            List<Network_Connectivity_Lookup__c> obj2 = [select id,name from Network_Connectivity_Lookup__c where name='Passport'];
            
            if(obj2.size()>0)
            euprodrequest.Network_Connectivity__c = obj2[0].Id;
        }
        else
        {
            euprodrequest.Vendor__c = false;
            List<OMS_Vendor__c> obj = [select Id from OMS_Vendor__c where name='--None--'];
            if(obj.size()>0)
            euprodrequest.OMS_Vendor__c =  obj[0].Id;
            List<Network_Connectivity_Lookup__c> obj2 = [select Id from Network_Connectivity_Lookup__c where name='--None--' Or name='Unknown']; //REQ5613760 kumvina 07June2016
            if(obj2.size()>0)
            euprodrequest.Network_Connectivity__c = obj2[0].Id;
            
        }
        system.debug(euprodrequest.Vendor__c+'passport::2'+euprodrequest.Network_Connectivity__c);
    }
    //singhrak, 26Feb 2015, REQ3455449,end
    
    
    
// REQ1309832, start    
    public Integer cmeFlag;
   public Integer getCmeFlag()
   {
    return cmeFlag;
   }
   public void calcCME()
   {
      //if(euprodrequest.Asset_Class__c !=null && euprodrequest.Asset_Class__c.indexOf('Futures') != -1)
       if(euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup' || 
      euprodrequest.Set_up_type__c == 'Client TNL Change' || euprodrequest.Set_up_type__c ==  'FIX Certification') && 
      euprodrequest.North_America_Flow_Details__c != null && (!(euprodrequest.North_America_Flow_Details__c == 'Sales Desk/BI' || 
      euprodrequest.North_America_Flow_Details__c == 'Progs' || euprodrequest.North_America_Flow_Details__c == 'Progs;Sales Desk/BI')) && 
      euprodrequest.Asset_Class__c !=null && euprodrequest.Asset_Class__c.indexOf('Futures') != -1)
      {
        cmeFlag = 1;
      }
      else
        cmeFlag = 0;
   }
// REQ1309832, start    
    //R09221937, start
     public void calcVendorFlagForMsetClientType()
    {
      if(euprodrequest.Vendor__c == true)
         msetclientType=0;
      else
         calcAccount();
      
    }
    // R09221937,end
    
      // R09171650, start
   Integer Ippan_Margin_Flag = 0;
   public Integer getIppan_Margin_Flag() {
        return Ippan_Margin_Flag;
    } 
    public void calcIppanMarginFlag(){
       if(this.euprodrequest.Ippan_Margin_Asia__c == true && this.euprodrequest.Asia_Pacific_Flow_Details__c!=null)
       {
          String[] part;
         part = (String.valueOf(euprodrequest.Asia_Pacific_Flow_Details__c)).split(';',0);
           for(String z:part)
           {
              if(z=='DMA/SORT' || z=='Algos/Strategies')
              {
                Ippan_Margin_Flag=1;
                break;
              }
              else 
                Ippan_Margin_Flag=0;
              
           }
       }
       else
        Ippan_Margin_Flag=0;
       
      
    }
 // R09171650, end   
    
    public void calcPriorityComment(){
      if(euprodrequest.Id != null)
       Priority_Comment_Flag = 1;
      else
       Priority_Comment_Flag = 0;
    }
   
    
    public Integer getPriority_Comment_Flag(){
      return this.Priority_Comment_Flag;
    }
    
    public Integer getScreen_Signed_Off_Flag(){
      return this.Screen_Signed_Off_Flag;
    }
                  
    public Integer getBBFrontEndDisplayFlag() {
      return this.BBFrontEndDisplayFlag;      }

    public void setBBFrontEndDisplayFlag(Integer BBFrontEndDisplayFlag) {
       this.BBFrontEndDisplayFlag = BBFrontEndDisplayFlag;    }
       
    public Integer getBBFrontEndDisplayViewFlag() {
      return this.BBFrontEndDisplayViewFlag;      }

    public void setBBFrontEndDisplayViewFlag(Integer BBFrontEndDisplayViewFlag) {
       this.BBFrontEndDisplayViewFlag = BBFrontEndDisplayViewFlag;    }
    
    public String getBloombergId() {
        return BloombergId;
    }

    public void setRequestedBy(Boolean request) {
        requestedBy = request;
    }

    public Boolean getRequestedBy() {
        return requestedBy;
    }


    Integer crossPointFlag;
    public Integer getCrossPointFlag()
    {
        return crossPointFlag;
    }
    public void calcCrossPointFlag()
    {
        if(euprodrequest.North_America_Flow_Details__c != null  && euprodrequest.Asset_Class__c != null)
        {
            
                String[] part;
                 part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity' || z=='Equity Swaps')
                            {
                                crossPointFlag = 1;
                                calcBDIndicatorFlag();
                                break;
                            }
                            else
                                crossPointFlag = 0; 
                       }    
        }
        else
            crossPointFlag = 0;
          
    }
    
     //himanb REQ5311922 , REQ5354316 & REQ5311942 11Apr2016  start
    Integer EnableAlfFlag;
    Integer EnableMsalFlag;
    Integer EnableMsalEUFlag;
    Integer EnableBidsFlag;
    Integer EnableMochausFlag;
    
    public Integer getEnableAlfFlag()
    {
        return EnableAlfFlag;
    }
    
     public Integer getEnableMsalFlag()
    {
        return EnableMsalFlag;
    }
    
     public Integer getEnableMsalEUFlag()
    {
        return EnableMsalEUFlag;
    }
    
    public Integer getEnableMochausFlag()
    {
        return EnableMochausFlag;
    }
    
    public Integer getEnableBidsFlag()
    {
        return EnableBidsFlag;
    }
    
     public void calcEnableAlfMsalFlag() 
    {
    calcAlfnBids();
    calcMsal();
    }
    
    public void calcAlfnBids(){
        
        if(euprodrequest.North_America_Flow_Details__c!=null && euprodrequest.North_America_Flow_Details__c!=''){           
                if((euprodrequest.North_America_Flow_Details__c.contains('Algos/Strategies')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Broker Dealer')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Broker in a Box')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('DMA/SORT')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('FIX to PassportWin')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('MS Port')) || 
                 (euprodrequest.North_America_Flow_Details__c.contains('Pairs')) ||
                  (euprodrequest.North_America_Flow_Details__c.contains('Retail'))||
                 (euprodrequest.North_America_Flow_Details__c.contains('Outsourced Trading'))
                 )
                {
                    EnableAlfFlag = 1; 
                    EnableBidsFlag = 1;                             
                }
                
                else {
                    EnableAlfFlag = 0; 
                    EnableBidsFlag = 0;
                    euprodrequest.Enable_ALF__c = false;
                    euprodrequest.Enable_BIDS_Conditional__c = false;
                    if(euprodrequest.Client_Trading_Pref__c != null){
                            string str1 = euprodrequest.Client_Trading_Pref__c.replace('Enable ALF (US), 15140=Y','');
                            string str2 = str1.replace('Enable Conditionals (US), 13555=Y','');
                            euprodrequest.Client_Trading_Pref__c = str2;                            
                    }
                }
        
        }
            
        else            
        {
                EnableAlfFlag = 0; 
                EnableBidsFlag = 0;
                euprodrequest.Enable_ALF__c = false;
                euprodrequest.Enable_BIDS_Conditional__c = false;
                if(euprodrequest.Client_Trading_Pref__c!=null){
                    string str1 = euprodrequest.Client_Trading_Pref__c.replace('Enable ALF (US), 15140=Y','');
                    string str2 = str1.replace('Enable Conditionals (US), 13555=Y','');
                    euprodrequest.Client_Trading_Pref__c= str2; 
                    }   
        }
    
    
    } // end calcAlfnBids
    
    public void calcMsal(){
        
        if(
        ((euprodrequest.North_America_Flow_Details__c!=null && euprodrequest.North_America_Flow_Details__c!='') &&
                ((euprodrequest.North_America_Flow_Details__c.contains('Algos/Strategies')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Broker Dealer')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Broker in a Box')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('DMA/SORT')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('FIX to PassportWin')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('MS Port')) || 
                 (euprodrequest.North_America_Flow_Details__c.contains('Pairs')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Retail'))
                 )
               )          
            )
        {       
                    EnableMsalFlag = 1; 
         }
        else            
        {
                EnableMsalFlag = 0;
                euprodrequest.Enable_MSAL__c = false;
                if(euprodrequest.Client_Trading_Pref__c!=null){
                    string str1 = euprodrequest.Client_Trading_Pref__c.replace('Enable MSAL US, 12433=Y','');
                    euprodrequest.Client_Trading_Pref__c= str1;
                        
                    }   
        }
        
        
        if(( (euprodrequest.Europe_Flow_Details__c!=null && euprodrequest.Europe_Flow_Details__c!='') &&
                ( (euprodrequest.Europe_Flow_Details__c.contains('Algos/Strategies')) ||
                 (euprodrequest.Europe_Flow_Details__c.contains('Broker Dealer')) ||
                 (euprodrequest.Europe_Flow_Details__c.contains('DMA/SORT')) ||
                 (euprodrequest.Europe_Flow_Details__c.contains('FIX to PassportWin')) ||
                 (euprodrequest.Europe_Flow_Details__c.contains('MS Port')) || 
                 (euprodrequest.Europe_Flow_Details__c.contains('Pairs'))
                )
          )){
        
        
            EnableMsalEUFlag = 1;   
        
        }else           
        {
                EnableMsalEUFlag = 0;
                euprodrequest.Enable_MSAL_EU__c = false;
                if(euprodrequest.Client_Trading_Pref__c!=null){
                    string str1 = euprodrequest.Client_Trading_Pref__c.replace('Enable MSAL EU, 12433=Y','');   
                    euprodrequest.Client_Trading_Pref__c= str1;
                    }   
        }
        /**REQ7025987 kumvina 27March2017 Start **/
        
        
        if(( (euprodrequest.North_America_Flow_Details__c!=null && euprodrequest.North_America_Flow_Details__c!='') &&
                ( (euprodrequest.North_America_Flow_Details__c.contains('Algos/Strategies')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Client Gateway')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('DMA/SORT')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('FIX to PassportWin')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Progs')) ||
                 (euprodrequest.North_America_Flow_Details__c.contains('Sales Desk/BI'))
                )
          )){
        
        
            EnableMochausFlag = 1;   
        
        }else           
        {
                EnableMochausFlag = 0;
                euprodrequest.Enable_MOCHA_US__c = false;
                if(euprodrequest.Client_Trading_Pref__c!=null){
                    string str1 = euprodrequest.Client_Trading_Pref__c.replace('Enable MOCHA US, 14714=Y','');   
                    euprodrequest.Client_Trading_Pref__c= str1;
                    }   
        }
        
        /**REQ7025987 kumvina 27March2017  end**/
        
    }//end calcMsal
    
    
    
    public void calcAlfFlag(){
       string SpmText='';
            if( euprodrequest.Enable_ALF__c == true){
                SpmText ='Enable ALF (US), 15140=Y';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('Enable ALF (US), 15140=Y'))){
                            euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                        else{ 
                            if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable ALF (US), 15140=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                            }
                            else{
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                            }
                        }
            }
            
            if( euprodrequest.Enable_ALF__c == false && euprodrequest.Enable_MSAL__c == false ){
                            if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable ALF (US), 15140=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                }           
            }
  
    }
    
    public void calcMsalFlag(){
       string SpmText='';
            if( euprodrequest.Enable_MSAL__c == true && euprodrequest.Enable_ALF__c != true){
                SpmText ='Enable MSAL US, 12433=Y';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('Enable MSAL US, 12433=Y'))){
                            euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                        else{ 
                            if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable MSAL US, 12433=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                            }
                            else{
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                            }
                        }
            }
            
            if( euprodrequest.Enable_MSAL__c == false && euprodrequest.Enable_ALF__c != false){
            
                if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable MSAL US, 12433=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                }           
            }
  

        
    }
    
     /** REQ7025987 Kumvina 31st March2017 start**/
    
    public void calcMochausFlag(){
       string SpmText='';
            if( euprodrequest.Enable_MOCHA_US__c == true){
                SpmText ='Enable MOCHA US, 14714=Y';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('Enable MOCHA US, 14714=Y'))){
                            euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                        else{ 
                            if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable MOCHA US, 14714=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                            }
                            else{
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                            }
                        }
            }
            
            if( euprodrequest.Enable_MOCHA_US__c == false){
            
                if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable MOCHA US, 14714=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                }           
            }
  

    
    }/** REQ7025987 Kumvina 31st March2017 end**/
    
    //kumvina REQ5405153 03May2016 start
     public void calcMsalEUFlag(){ 
       string SpmText='';
            if( euprodrequest.Enable_MSAL_EU__c == true){
                SpmText ='Enable MSAL EU, 12433=Y';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('Enable MSAL EU, 12433=Y'))){
                            euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                        else{ 
                            if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable MSAL EU, 12433=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                            }
                            else{
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                            }
                        }
            }
            
            if( euprodrequest.Enable_MSAL_EU__c == false){
            
                if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable MSAL EU, 12433=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                }           
            }
  
  
    }
    //kumvina REQ5405153 03May2016 end
    
   public void dataShare(string textData, boolean validform){
                string SpmText='';
                    if(validform){
                    SpmText =textData;//'//16051=1';
                        if(euprodrequest.Technical_CRDB__c!=null && (!euprodrequest.Technical_CRDB__c.contains(textData))){
                            euprodrequest.Technical_CRDB__c = euprodrequest.Technical_CRDB__c + '\n'+ SpmText ;
                        }
                        else{ 
                            if(euprodrequest.Technical_CRDB__c!=null && euprodrequest.Technical_CRDB__c!=textData){
                                string str = euprodrequest.Technical_CRDB__c.replace(textData,'');
                                euprodrequest.Technical_CRDB__c = str;
                            }
                            else{
                                if(euprodrequest.Technical_CRDB__c==null)
                                    euprodrequest.Technical_CRDB__c=SpmText;
                            }
                        }
                    }
                    if(!validform){
                     if(euprodrequest.Technical_CRDB__c!=null){
                                string str = euprodrequest.Technical_CRDB__c.replace(textData,'');
                                euprodrequest.Technical_CRDB__c = str;
                            }      
                    
                    }   BespokePreferenceMeth();
   }

        public void clientDerivative(){ 
                if( euprodrequest.Client_Derivative__c == true){
                    dataShare('16051=1',true);
                }
                if( euprodrequest.Client_Derivative__c == false){
                   dataShare('16051=1',false);          
                }
        }
        public void clientDerivative2(){
                if( euprodrequest.Automated_Liquidity__c == true){
                    dataShare('16051=2',true);
                }
                if( euprodrequest.Automated_Liquidity__c == false){
                   dataShare('16051=2',false);          
                }
        }
        public void clientDerivative3(){        
                if( euprodrequest.House_Inventory__c == true){
                    dataShare('16051=3',true);
                }
                if( euprodrequest.House_Inventory__c == false){
                   dataShare('16051=3',false);          
                }
        }
        public void clientDerivative4(){
                if( euprodrequest.Market_Making__c == true){
                    dataShare('16051=4',true);
                }
                if( euprodrequest.Market_Making__c == false){
                   dataShare('16051=4',false);          
                }
        }
      public void clientDerivative5(){ /* start - REQ8383201;kumvina;2017Dec07 */
                if( euprodrequest.Disable_all_Sis__c == true){
                    dataShare('2704=1',true);
                }
                if( euprodrequest.Disable_all_Sis__c == false){
                   dataShare('2704=1',false);          
                }
        }  /*end- REQ8383201;kumvina;2017Dec07 */
        
        
    //REQ8117996: Only show MIFID section if set up type is MIFID and add prefix to the sort or nv requests-->
      /*  public void clientSortAgency(){      
                if( euprodrequest.NV_Disable_Agency__c ) {
                    dataShare('NV: 16052=Y',true);
                }else if (euprodrequest.SORT_Disable_Agency__c){
                //if( euprodrequest.NV_Disable_Agency__c == false || euprodrequest.SORT_Disable_Agency__c== false){
                   dataShare('SORT: 16052=Y',true);          
                }
            else{
                //dataShare('SORT: 16052=Y',false);
            }
        }*/
        
        public void clientSortAgency(){      
                if( euprodrequest.NV_Disable_Agency__c ) {
                    //11/14/2017: Updated the value below to NV: 16052=N from NV: 16052=Y as per mail from duff
                    dataShare('16052=N',true);
                }
            //11/14/2017: Updated the value below to NV: 16052=N from NV: 16052=Y as per mail from duff
                if(!euprodrequest.NV_Disable_Agency__c ) {
                    dataShare('16052=N',false);
                }
        }
         public void clientSortAgency5(){         
                if (euprodrequest.SORT_Disable_Agency__c){
                //if( euprodrequest.NV_Disable_Agency__c == false || euprodrequest.SORT_Disable_Agency__c== false){
                   dataShare('SORT: 16052=Y',true);          
                }
                 if (!euprodrequest.SORT_Disable_Agency__c){
                    dataShare('SORT: 16052=Y',false);
                }
        }
        public void clientSortAgency7(){      
                if( euprodrequest.SORT_IOI_SIs__c ) {
                    dataShare('SORT: IOI SI: 14816=Standard',true);
                }
                if(!euprodrequest.SORT_IOI_SIs__c ) {
                    dataShare('SORT: IOI SI: 14816=Standard',false);
                }
        }
       public void clientSortAgency8(){      
                if( euprodrequest.SORT_Blind_SIs__c ) {
                    dataShare('SORT: BLIND SI:  15146=DKJPMX',true);
                }
                if(!euprodrequest.SORT_Blind_SIs__c ) {
                    dataShare('SORT: BLIND SI:  15146=DKJPMX',false);
                }
        } 
        public void clientSortAgency9(){      
                if( euprodrequest.NV_IOI_SIs__c ) {
                    dataShare('NV: IOI SI: 14816=Standard',true);
                }
                if(!euprodrequest.NV_IOI_SIs__c ) {
                    dataShare('NV: IOI SI: 14816=Standard',false);
                }
        }
        public void clientSortAgency10(){      
                if( euprodrequest.NV_Blind_SIs__c ) {
                    dataShare('NV: BLIND SI:  15146=DKJPMX',true);//NV: BLIND SI: 14816=Standard
                }
                if(!euprodrequest.NV_Blind_SIs__c ) {
                    dataShare('NV: BLIND SI:  15146=DKJPMX',false);
                }
        }
         public void BespokePreferenceMeth(){      
                if(euprodrequest.Bespoke_Preference_Setup__c != null ){  
                       if(euprodrequest.Bespoke_Preference_Setup__c==true &&
                                (euprodrequest.Client_Derivative__c==true||euprodrequest.Automated_Liquidity__c==true
                                ||euprodrequest.House_Inventory__c==true||euprodrequest.Market_Making__c==true
                                ||euprodrequest.SORT_Disable_Agency__c==true||euprodrequest.NV_Disable_Agency__c==true
                                ||euprodrequest.SORT_IOI_SIs__c==true||euprodrequest.SORT_Blind_SIs__c==true||euprodrequest.NV_IOI_SIs__c==true||euprodrequest.NV_Blind_SIs__c==true))

                        {                       
                           if(euprodrequest.Integrator__c == null){
                                euprodrequest.Integrator__c =  'Unassigned_EU';
                           }else
                            {
                                if(!euprodrequest.Integrator__c.contains('MiFID2')){
                                euprodrequest.Integrator__c='MiFID2';
                                }
                                euprodrequest.Integrator__c = euprodrequest.Integrator__c + ';Unassigned_EU';

                            }
                        }
                        else
                        {
                            String str = euprodrequest.Integrator__c;
                            if(str != null && str.indexOf('Unassigned_EU') != -1)
                            str = str.remove('Unassigned_EU');
                            euprodrequest.Integrator__c = str;
                        }
                        
                        
                        /********/
                        if(euprodrequest.Bespoke_Preference_Setup__c==true &&
                                (euprodrequest.Client_Derivative__c==false && euprodrequest.Automated_Liquidity__c==false
                                &&euprodrequest.House_Inventory__c==false && euprodrequest.Market_Making__c==false && 
                                euprodrequest.SORT_Disable_Agency__c==false && euprodrequest.NV_Disable_Agency__c==false && 
                                euprodrequest.SORT_IOI_SIs__c== false && euprodrequest.SORT_Blind_SIs__c==false && euprodrequest.NV_IOI_SIs__c==false && euprodrequest.NV_Blind_SIs__c==false))

                        {                       
                           if(euprodrequest.Integrator__c == null){
                                euprodrequest.Integrator__c =  'Unassigned_EU';
                           }else if(euprodrequest.Integrator__c !=  'Unassigned_EU'){
                           
                                euprodrequest.Integrator__c =  'Unassigned_EU';
                           }                       
                           else
                            {
                                
                            String str = euprodrequest.Integrator__c;
                            if(str != null && str.indexOf('MiFID2') != -1)
                            str = str.remove('MiFID2');
                            euprodrequest.Integrator__c = str;

                            }
                        }
                        
                        /*******/
                        
                        
                        
                        }
                        if(euprodrequest.Bespoke_Preference_Setup__c==false){
                        euprodrequest.Bespoke_setup__c='';
                        }
                        
                    
                
        }
    
         public void enableMSALWithALF(){//kumvina REQ7551905 03Aug2017 start
    
        string SpmText='';
           if((euprodrequest.Enable_MSAL__c == true && euprodrequest.Enable_ALF__c ==true) || (euprodrequest.Enable_MSAL__c == false && euprodrequest.Enable_ALF__c ==true)||(euprodrequest.Enable_MSAL__c == true && euprodrequest.Enable_ALF__c == false)){

                            
                SpmText ='Enable appropriate Liquidity Profile in CRDB for NA';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('Enable appropriate Liquidity Profile in CRDB for NA'))){
                            euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                        else{ 
                            /*if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable appropriate Liquidity Profile in CRDB for NA','');
                                euprodrequest.Client_Trading_Pref__c = str;
                            }
                            else{*/
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                            //}
                        }


                    }
                    
            if( euprodrequest.Enable_MSAL__c == false && euprodrequest.Enable_ALF__c ==false){
                if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable appropriate Liquidity Profile in CRDB for NA','');
                                euprodrequest.Client_Trading_Pref__c = str;




                        }           
                   }
                        
        }
    
    
     public void calcBidsFlag(){
        string SpmText='';
            if( euprodrequest.Enable_BIDS_Conditional__c == true){
                SpmText ='Enable Conditionals (US), 13555=Y';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('Enable Conditionals (US), 13555=Y'))){
                            euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                        else{ 
                            if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable Conditionals (US), 13555=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                            }
                            else{
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                            }
                        }
            }
            
            if( euprodrequest.Enable_BIDS_Conditional__c == false){
            
                if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('Enable Conditionals (US), 13555=Y','');
                                euprodrequest.Client_Trading_Pref__c = str;
                }           
            } 
  
    }
    
    //himanb REQ5311922, REQ5354316 & REQ5311942 11Apr2016  end
    
    
    //Swapnd REQ5973029  Start
       public void calcOutSourceFlag(){
        string SpmText='';
            if(euprodrequest.North_America_Flow_Details__c!=null){
            if(euprodrequest.North_America_Flow_Details__c.contains('Outsourced Trading')){
                SpmText ='set ClientID (109)= OT (broker dealer) MPID \nset ExtClientFundID (10355)= Buyside (fund) Trading Name \nset ClientMrgDeskID (10549)= Buyside (fund) Trading Name \nset DirectedBrokerageCLTNLID (12104)= Buyside TNL \nset BD Indicator (12166)= Y \nset FlowCategory (13928)= OT';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains(SpmText))){
                            euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                       else{ 
                            if(euprodrequest.Client_Trading_Pref__c!=null){
                                if(euprodrequest.Client_Trading_Pref__c.contains(SpmText) && (!euprodrequest.North_America_Flow_Details__c.contains('Outsourced Trading'))){
                                    string str = euprodrequest.Client_Trading_Pref__c.replace('set ClientID (109)= OT (broker dealer) MPID \nset ExtClientFundID (10355)= Buyside (fund) Trading Name \nset ClientMrgDeskID (10549)= Buyside (fund) Trading Name \nset DirectedBrokerageCLTNLID (12104)= Buyside TNL \nset BD Indicator (12166)= Y \nset FlowCategory (13928)= OT','');
                                    euprodrequest.Client_Trading_Pref__c = str;
                                }
                            }
                            else{
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                            }
                        }
            }
            
            if(!euprodrequest.North_America_Flow_Details__c.contains('Outsourced Trading')){
                if(euprodrequest.Client_Trading_Pref__c!=null){
                                string str = euprodrequest.Client_Trading_Pref__c.replace('set ClientID (109)= OT (broker dealer) MPID \nset ExtClientFundID (10355)= Buyside (fund) Trading Name \nset ClientMrgDeskID (10549)= Buyside (fund) Trading Name \nset DirectedBrokerageCLTNLID (12104)= Buyside TNL \nset BD Indicator (12166)= Y \nset FlowCategory (13928)= OT','');
                                euprodrequest.Client_Trading_Pref__c = str;
                }           
            } 
       }
    }
    //Swapnd REQ5973029  end
    
    //kumvina REQ5143234 04March2016 start
   public Integer SortPassiveModelFlag;
    public Integer getSortPassiveModelFlag()
    {
        return sortPassiveModelFlag;
    }
     public void calcSORTPassiveModel() //kumvina REQ5143234 04March2016
    {
        if(euprodrequest.North_America_Flow_Details__c!=null && euprodrequest.North_America_Flow_Details__c!=''){
                if((euprodrequest.North_America_Flow_Details__c.contains('Algos/Strategies')) || (euprodrequest.North_America_Flow_Details__c.contains('DMA/SORT')))
                {
                    SortPassiveModelFlag = 1; 
                    if(euprodrequest.SORT_Passive_Model__c==null ||euprodrequest.SORT_Passive_Model__c=='Default DLOP wide'){
                    euprodrequest.SORT_Passive_Model__c = 'Default DLOP wide';
                    }
                    
                }
                else {
                    SortPassiveModelFlag = 0;
                    if(euprodrequest.Client_Trading_Pref__c!=null && SortPassiveModelFlag == 0){
                            string str = euprodrequest.Client_Trading_Pref__c.replace('SORT Passive Model is not default. See Additional Information for details. Tag 15080.','');
                            euprodrequest.Client_Trading_Pref__c= str;
                            euprodrequest.SORT_Passive_Model__c=null;
                    }
                }
        
        }else{SortPassiveModelFlag = 0;
                    if(euprodrequest.Client_Trading_Pref__c!=null && SortPassiveModelFlag == 0){
                            string str = euprodrequest.Client_Trading_Pref__c.replace('SORT Passive Model is not default. See Additional Information for details. Tag 15080.','');
                            euprodrequest.Client_Trading_Pref__c = str;
                            euprodrequest.SORT_Passive_Model__c=null;
                        }
        }   
    }
    
    
    //kumvina REQ5143234 04March2016 end
    
    Integer auctionFlag =0;
    public Integer getAuctionFlag()
    {
        return auctionFlag;
    }
        
    //kumvina REQ5391910 26Apr20166 start
    
    public void calcNoCloseFlag(){
       string SpmText='';
       
       if(euprodrequest.North_America_Flow_Details__c!=null && euprodrequest.North_America_Flow_Details__c!=''){
                if(euprodrequest.North_America_Flow_Details__c.contains('Algos/Strategies'))
                    {
                        auctionFlag=1;
                        
                        if(euprodrequest.No_Close_Auction_for_PRIME__c == true){
                         SpmText ='Do not participate in close auction for Prime, VWAP, 10582=N';
                            if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('Do not participate in close auction for Prime, VWAP, 10582=N'))){
                                euprodrequest.Client_Trading_Pref__c = euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                            }
                        
                            else{ 
                                if(euprodrequest.Client_Trading_Pref__c==null)
                                euprodrequest.Client_Trading_Pref__c=SpmText;
                                        
                            }
                        }
                                    
                        if( euprodrequest.No_Close_Auction_for_PRIME__c == false ){
                                if(euprodrequest.Client_Trading_Pref__c!=null){
                                            string str = euprodrequest.Client_Trading_Pref__c.replace('Do not participate in close auction for Prime, VWAP, 10582=N','');
                                            euprodrequest.Client_Trading_Pref__c = str;
                                }       
                        }           
                            
              } 
               else{ auctionFlag=0;
                     euprodrequest.No_Close_Auction_for_PRIME__c = false;
                        
                        if(euprodrequest.Client_Trading_Pref__c!=null){
                            string str = euprodrequest.Client_Trading_Pref__c.replace('Do not participate in close auction for Prime, VWAP, 10582=N','');
                            euprodrequest.Client_Trading_Pref__c = str;
                            }
                    
                    }
              
       }
       else{ auctionFlag=0;
             euprodrequest.No_Close_Auction_for_PRIME__c = false;   
                        if(euprodrequest.Client_Trading_Pref__c!=null){
                            string str = euprodrequest.Client_Trading_Pref__c.replace('Do not participate in close auction for Prime, VWAP, 10582=N','');
                            euprodrequest.Client_Trading_Pref__c = str;
                            }
                    
                    }
          
    }//kumvina REQ5391910 26Apr2016 end
    
    public void calcBDIndicator()
    {
        calcCrossPointFlag();
        //calcSORTPassiveModel();//kumvina REQ5143234 04March2016 
    }
    
    //kumvina REQ5143234 04March2016 start
    //himanb updated comments field to Client trading pref 12Apr2016
    public void calcInputComents(){
       string SpmText='';
       //euprodrequest.SORT_Passive_Model__c = euprodrequest.SORT_Passive_Model__c;
        if((euprodrequest.SORT_Passive_Model__c!= null || euprodrequest.SORT_Passive_Model__c!= '') && SortPassiveModelFlag == 1){
            if(euprodrequest.SORT_Passive_Model__c!='Default DLOP wide' ){
                    SpmText ='SORT Passive Model is not default. See Additional Information for details. Tag 15080.';
                        if(euprodrequest.Client_Trading_Pref__c!=null && (!euprodrequest.Client_Trading_Pref__c.contains('SORT Passive Model is not default. See Additional Information for details. Tag 15080.'))){
                            euprodrequest.Client_Trading_Pref__c= euprodrequest.Client_Trading_Pref__c + '\n'+ SpmText ;
                        }
                        else{
                                if(euprodrequest.Client_Trading_Pref__c==null){
                                    euprodrequest.Client_Trading_Pref__c=SpmText;
                                }
                            }
            }else{ 
                        if(euprodrequest.Client_Trading_Pref__c!=null){
                            string str = euprodrequest.Client_Trading_Pref__c.replace('SORT Passive Model is not default. See Additional Information for details. Tag 15080.','');
                            euprodrequest.Client_Trading_Pref__c= str;
                        }
                    
                }
        
        }
  
    }
    //kumvina REQ5143234 04March2016 end
    
    public Integer BDIndicatorFlag;
    public  Integer getBDIndicatorFlag()
    {
        return BDIndicatorFlag;
    }
    public void calcBDIndicatorFlag()
    {
        if(euprodrequest.Name == null)
        {   
       /*   if(euprodrequest.BD_Indicator__c != null && euprodrequest.BD_Indicator__c == true)
            {
                euprodrequest.Crosspoint_All_algos__c = true;
                euprodrequest.Crosspoint_Owl__c = true; 
            }
            else
            {
                euprodrequest.Crosspoint_All_algos__c = false;
                euprodrequest.Crosspoint_Owl__c = false;
            }
        */}
    }

    public PageReference calcFIXCertificationFlag() {
        if (euprodrequest.Set_up_type__c == 'FIX Certification')
        {VendorDisplayFlag = 1;}
        else
        {VendorDisplayFlag = 0;}
       //  REQ8117996: Only show MIFID section if set up type is MIFID
        if (euprodrequest.Set_up_type__c == 'MiFID2 Preference')
        {MiFID2Preference = 1; flowDecomission = 0;}
        else
        {MiFID2Preference = 0;}
        
        if (euprodrequest.Set_up_type__c == 'FIX Certification' && (!(euprodrequest.OMS_Vendor__r.name == 'Passport') && !(euprodrequest.OMS_Vendor__r.name == 'Passport Express') && !(euprodrequest.OMS_Vendor__r.name == 'Other')))
        {Screen_Signed_Off_Flag = 1;}
        else
        {Screen_Signed_Off_Flag = 0;}

        if (euprodrequest.Set_up_type__c == 'FIX Certification' || euprodrequest.Set_up_type__c == 'Decommission')
        {resetSectionFlags();}
        else
        {calcLimitsSectionDisplayFlag();}
        
        //Start REQ6401397- Amy May Request 
         if(euprodrequest.Set_up_type__c == 'Network Change'){
            if(euprodrequest.Comments__c != null){
                euprodrequest.Comments__c = euprodrequest.Comments__c +'ETS Clients- Please submit a deco ticket for old network once new network set-up is complete.';
                
             }
            else{
                euprodrequest.Comments__c = 'ETS Clients- Please submit a deco ticket for old network once new network set-up is complete.';
            }
        }else if(euprodrequest.Set_up_type__c != 'Network Change'){
            if(euprodrequest.Comments__c != null){
                if(euprodrequest.Comments__c.contains('ETS Clients- Please submit a deco ticket for old network once new network set-up is complete.')){
                    euprodrequest.Comments__c = euprodrequest.Comments__c.replace('ETS Clients- Please submit a deco ticket for old network once new network set-up is complete.', '');
                }
            }
        }
        //End REQ6401397
        
        calcCME();
        decomissionFlowregion();
      // singhrak, 25Feb, 2015, REQ3455140,start
        calcIntegratorForSetuptypeDecommission();
        // singhrak, 25Feb, 2015, REQ3455140,end
        calcIntegratorForSetuptypeMiFID2Preference();
        
        return null;
    }
    
    public integer flowDecomission=0;
    
     public Integer getFlowDecomission()
    {
        return flowDecomission;     
    }
    
    public void decomissionFlowregion(){
        if(euprodrequest.Set_up_type__c !=null && euprodrequest.Set_up_type__c == 'Decommission'){
            flowDecomission=1;

            
        }else{
        flowDecomission=0;

        }
    
    }
    
    //kumvina,REQ7650129,10Aug2017
  /* public integer SFCattestation=0;
   public Integer getSFCattestation()
    {
        return SFCattestation;     
    }


   
   public void attestationSFD(){
     if(euprodrequest.SFC_attestation__c!=null && euprodrequest.SFC_attestation__c=='Out of Scope'){

        SFCattestation=1;
     }else{
        SFCattestation=0;
     }
    } */ //kumvina,REQ7650129,10Aug2017
    

    
   //     kumvina, REQ5084643,15feb2016, start
    public PageReference integratorValueForUser(){
    /*  system.debug('****** 1935**'+euprodrequest.RequestedBy__c);
     if(euprodrequest.integrator__c!=null){
      if(euprodrequest.RequestedBy__c =='005q0000002wuMw'){
            if(!(euprodrequest.integrator__c.contains('Unassigned_EU'))){
                euprodrequest.integrator__c = euprodrequest.integrator__c+';Unassigned_EU;';
                }
        
        }else{
        
        euprodrequest.integrator__c = 'Unassigned_EU;';
        }
     }*/
     //himanb REQ5291267 18-Apr-2016
     if(euprodrequest.IntegratorSet__c==false){
        system.debug('****** 19 apr code flag '+euprodrequest.IntegratorSet__c);
        system.debug('****** 19 apr code');
     
      Set<id> listOfUser = new set<id>();
      list<id> listFinal = new list<id>();
      listOfuser = GetUserIdsFromGroup(System.Label.FIX_product_request_groupId);
      for(id userId:listOfuser){
        if(euprodrequest.RequestedBy__c ==  String.valueOf(userId).substring(0, 15) &&(userId <> null)){
            listFinal.add(userId);
        } 
        
       
      }
       if((listFinal.size()>0) && (euprodrequest.Status__c== System.Label.FIX_product_request_status)){
        
            if(euprodrequest.integrator__c!=null){
                if(!(euprodrequest.integrator__c.contains(System.Label.FIX_product_request_integrator))){
                euprodrequest.integrator__c = euprodrequest.integrator__c+';'+System.Label.FIX_product_request_integrator;
                }
            }else{
                if((listFinal.size()>0) && (euprodrequest.Status__c== System.Label.FIX_product_request_status)){
                euprodrequest.integrator__c = System.Label.FIX_product_request_integrator;}}
        }//else{
            //euprodrequest.integrator__c ='';          
        //}
      
     }//end if
    return null;
    }
    
public static Set<id> GetUserIdsFromGroup(Id groupId)
    {
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        
        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId])
        {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType))
            {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            else if (((String)m.UserOrGroupId).startsWith(groupType))
            {
                // Call this function again but pass in the group found within this group
                result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            }
        }
        
        return result;  
    }
  //     kumvina, REQ5084643,15feb2016, end
   


 // singhrak, 25Feb, 2015, REQ3455140, start
   public void calcIntegratorForSetuptypeDecommission()
   {
          if(euprodrequest.Set_up_type__c != null){  //kumvina,REQ7533753 , July 05, 2017, logic updated
                       if(euprodrequest.Set_up_type__c == 'Decommission' ||euprodrequest.Set_up_type__c == 'Vendor Migration')

                        {
                            //singhrak,REQ3649028 , Apr 06, 2015, comment below one start
                          //  euprodrequest.Integrator__c = 'mset-ven';
                            /*if(euprodrequest.Integrator__c == null)
                                euprodrequest.Integrator__c =  'mset-ven';


                            else
                            {
                                euprodrequest.Integrator__c = euprodrequest.Integrator__c + ';mset-ven';

                            } */
                            
                            
                            //singhrak,REQ3649028 , Apr 06, 2015, comment below one end
                            // euprodrequest.Integrator__c = 'mset-ven';// kumvina;REQ8527920;09Jan2018
                                if(euprodrequest.Integrator__c == null)
                                        euprodrequest.Integrator__c =  'mset-ven';
                                else{
                                    // euprodrequest.Integrator__c = euprodrequest.Integrator__c + ';mset-ven';
                                        if(euprodrequest.Integrator__c.contains('mset-ven')){
                                        euprodrequest.Integrator__c = euprodrequest.Integrator__c;
                                        }else if(!euprodrequest.Integrator__c.contains('mset-ven')){
                                
                                        euprodrequest.Integrator__c = euprodrequest.Integrator__c;
                                        }
                                        else{
                                        euprodrequest.Integrator__c = euprodrequest.Integrator__c;// + ';mset-ven';
                                        }
                                } 
                                //singhrak,REQ3649028 , Apr 06, 2015, comment below one end// kumvina;REQ8527920;09Jan2018 end
                            }
                        else
                        {// a;b;mset-ven, mset-ven;a,  a;mset-ven;b
                            system.debug('ssss11'+euprodrequest.Integrator__c);
                            String str = euprodrequest.Integrator__c;
                            if(str != null && str.indexOf('mset-ven') != -1)
                            str = str.remove('mset-ven');
                            euprodrequest.Integrator__c = str;
                            system.debug('ssss+'+euprodrequest.Integrator__c);


                        }
             }
   }
   
    public void calcIntegratorForSetuptypeMiFID2Preference ()
   {
          if(euprodrequest.Set_up_type__c != null){  
                       if(euprodrequest.Set_up_type__c == 'MiFID2 Preference')
                        {
                            //euprodrequest.Integrator__c = 'mset-ven';
                           if(euprodrequest.Integrator__c == null){
                                euprodrequest.Integrator__c =  'MiFID2';
                           }else
                            {
                                euprodrequest.Integrator__c = euprodrequest.Integrator__c + ';MiFID2';

                            }
                }
                        else
                        {
                            String str = euprodrequest.Integrator__c;
                            if(str != null && str.indexOf('MiFID2') != -1)
                            str = str.remove('MiFID2');
                            euprodrequest.Integrator__c = str;
                        }
             }
   }
   
   
/*   public void calcIntegratorForVendorMigration()
   {
          if(euprodrequest.Set_up_type__c != null && euprodrequest.Set_up_type__c == 'Vendor Migration')
            {
                //kumvina,REQ7533753 , July 05, 2017, comment below one start
                euprodrequest.Integrator__c = 'mset-ven';
                
            }
            else
            {
                String str = euprodrequest.Integrator__c;
                if(str != null && str.indexOf('mset-ven') != -1)
                str = str.remove('mset-ven');
                euprodrequest.Integrator__c = str;
                
            }

   }*/
   
   
   
   // singhrak, 25Feb, 2015, REQ3455140, end

    public PageReference resetSectionFlags() {

        if (euprodrequest.Set_up_type__c == 'FIX Certification')
        {
            //LimitsSectionDisplayFlag = 0;
            DMASectionDisplayFlag = 0;
            SalesDeskBISectionDisplayFlag = 0; ProgsSectionDisplayFlag = 0;
            PassportSectionDisplayFlag=0; IOISectionDisplayFlag=0;
            //CommissionSectionDisplayFlag=0;
            AsiaCashSectionFlag=0;
            AsiaDerivSectionFlag=0;
            //ASIASectionFlag=0;
            KRInvestorIdFlag=0; // BloombergSectionDisplayFlag = 0;
            TWInvestorIdFlag=0; INInvestorIdFlag=0;
            AsiaDMACashSectionDisplayFlag=0;
            
            //Supress display of limits info and commission section under below condition being met
            if(this.euprodrequest.Vendor__c == true) {
                this.CommissionSectionDisplayFlag = 0;
                this.LimitsSectionDisplayFlag = 0;
            } 
        }
        else
        {
            LimitsSectionDisplayFlag = 0;
            CommissionSectionDisplayFlag=0;
        }
        
        return null;
    }
    
    public PageReference save() {
        PageReference pageRef = ApexPages.currentPage();
        System.debug('PageRef_Debug::'+pageRef);
        String flowType = pageRef.getParameters().get('flow');
        
       if(flowType != null && flowType.equals('clone')) {
              return this.cloneForm();
        }
        
       
        
        // if any of the options in Europe flow details is not selected
        // reset all the related values.
        //System.debug('Inside save first UUID:'+UUID); //euprodrequest.UUID_User_Number_Name__c = UUID;
        String EU_Flow = '';
        EU_Flow = euprodrequest.Europe_Flow_Details__c;

        if ((EU_Flow == null) || (EU_Flow == ''))
        {
            euprodrequest.Europe_Markets__c = null;

            euprodrequest.EU_Core_Equity_markets_Commission__c = null;
            euprodrequest.EU_Core_Derivs_markets_Commission__c = null;
            euprodrequest.Greece_DMA_Commission__c = null;
            euprodrequest.South_Africa_DMA_Commission__c = null;
            euprodrequest.Turkey_DMA_Commission__c = null;
            euprodrequest.Czech_Rep_DMA_Commission__c = null;
            euprodrequest.Ireland_DMA_Commission__c = null;
            euprodrequest.Hungary_DMA_Commission__c = null;
            euprodrequest.Poland_DMA_Commission__c = null;
            euprodrequest.Chi_X_Direct_Commission__c = null;
            euprodrequest.Turquoise_Direct_Commission__c = null;
            euprodrequest.NASDAQ_OMX_Europe_Direct_Commission__c = null;
            euprodrequest.BATS_Europe_Direct_Commission__c = null;
            euprodrequest.NYSE_Arca_Europe_Direct_Commission__c = null;
            euprodrequest.EU_Equity_Single__c = null;
            euprodrequest.EU_Equity_Cum__c = null;
            euprodrequest.EU_Futs_Single__c = null;
            euprodrequest.EU_Futs_Cum__c = null;
            euprodrequest.EU_Stock_Opt_Single__c = null;
            euprodrequest.EU_Stock_Opt_Cum__c = null;
            euprodrequest.EU_Index_Opt_Single__c = null;
            euprodrequest.EU_Index_Opt_Cum__c = null;
            euprodrequest.EU_Integration_Status__c = null;
            euprodrequest.EU_Integration_Comments__c = null;
        }
        // if any of the options in North America flow details is not selected
        // reset all the related values.

        String NA_Flow = '';
        NA_Flow = euprodrequest.North_America_Flow_Details__c;
        if ((NA_Flow == null) || (NA_Flow == ''))
        {
            euprodrequest.North_America_Markets__c = null;

            euprodrequest.US_Core_Equity_markets_commission__c = null;
            euprodrequest.US_Core_Derivs_markets_commission__c = null;
            euprodrequest.Canada_commission__c = null;
            euprodrequest.Mexico_commission__c = null;

            euprodrequest.US_Equity_Single__c = null;
            euprodrequest.US_Equity_Cum__c = null;
            euprodrequest.SA_Equity_Cum__c = null;
            euprodrequest.US_Futs_Single__c = null;
            euprodrequest.US_Futs_Cum__c = null;
            euprodrequest.US_Stock_Opt_Single__c = null;
            euprodrequest.US_Stock_Opt_Cum__c = null;
            euprodrequest.US_Index_Opt_Single__c = null;
            euprodrequest.US_Index_Opt_Cum__c = null;
            euprodrequest.NA_Integration_Status__c = null;
            euprodrequest.NA_Integration_Comments__c = null;

        }

        // if any of the options in Asia Pacific flow details is not selected
        // reset all the related values.

        String AP_Flow = '';
        AP_Flow = euprodrequest.Asia_Pacific_Flow_Details__c;
        if ((AP_Flow == null) || (AP_Flow == ''))
        {
            euprodrequest.Asia_Pacific_Markets__c = null;

            euprodrequest.India_Commission__c = null;
            euprodrequest.Korea_Commission__c = null;
            euprodrequest.Taiwan_Commission__c = null;
            euprodrequest.Japan_Commission__c = null;
            euprodrequest.Asia_Core_Markets_Commission__c = null;

            euprodrequest.Japan_Equity_Single__c = null;
            euprodrequest.Japan_Equity_Cum__c = null;
            euprodrequest.HK_SI_AU_Equity_Single__c = null;
            euprodrequest.HK_SI_AU_Equity_Cum__c = null;
            euprodrequest.India_Equity_Single__c = null;
            euprodrequest.India_Equity_Cum__c = null;
            euprodrequest.Taiwan_Equity_Single__c = null;
            euprodrequest.Taiwan_Equity_Cum__c = null;
            euprodrequest.Korea_Equity_Single__c = null;
            euprodrequest.Korea_Equity_Cum__c = null;
            euprodrequest.Korea_Onshore_Net_Limit__c = null;
            euprodrequest.Broker_Markets_Single__c = null;
            euprodrequest.Broker_Markets_Cum__c = null;
            euprodrequest.Japan_Futures_Single__c = null;
            euprodrequest.Japan_Futures_Cum__c = null;
            euprodrequest.HK_SI_AU_Futures_Single__c = null;
            euprodrequest.HK_SI_AU_Futures_Cum__c = null;
            euprodrequest.India_Futures_Single__c = null;
            euprodrequest.India_Futures_Cum__c = null;
            euprodrequest.Taiwan_Futures_Single__c = null;
            euprodrequest.Taiwan_Futures_Cum__c = null;
            euprodrequest.Korea_Futures_Single__c = null;
            euprodrequest.Korea_Futures_Cum__c = null;

            euprodrequest.KR_Trading_Approach__c = null;
            euprodrequest.KR_Investor_IDs__c = null;
            euprodrequest.TW_Trading_Approach__c = null;
            euprodrequest.TW_Investor_IDs__c = null;
            euprodrequest.India_Investor_IDs__c = null;
            euprodrequest.JP_FUT_OPT_DMA_OMS_Mnemonic__c = null;
            euprodrequest.JP_FUT_OPT_BI_OMS_Mnemonic__c = null;
            euprodrequest.JP_FUT_OPT_Coverage__c = null;
            euprodrequest.NJA_FUT_OPT_DMA_OMS_Mnemonic__c = null;
            euprodrequest.NJA_FUT_OPT_BI_OMS_Mnemonic__c = null;
            euprodrequest.NJA_FUT_OPT_Coverage__c = null;
            euprodrequest.MS_Clearing_Account_SG_AX__c = null;
            euprodrequest.PB_with_MS__c = False;
            euprodrequest.If_Giveup_then_who_and_account_no__c = null;
            euprodrequest.Allocation_Type__c = null;
            euprodrequest.Allocation_Account__c = null;
            euprodrequest.Allocation_Delivery__c = null;
            euprodrequest.Booking_Account__c = null;
            euprodrequest.Avg_Pricing__c = null;
            euprodrequest.If_Special_Pricing_Specify__c = null;
            euprodrequest.Confirmation_Template__c = null;
            euprodrequest.Recipients_for_Confirmations__c = null;
            euprodrequest.Confirmation_Method__c = null;
            euprodrequest.Other_Confirmation_Method_Details__c = null;
            euprodrequest.Need_all_mkts_on_1_conf__c = False;
            euprodrequest.JP_Client_Profile_Name__c = null;
            euprodrequest.JP_OMSMnemonic__c = null;
            euprodrequest.Correct_TNL_ID__c = null;
            euprodrequest.Company_Code__c = null;
            euprodrequest.Assigned_Person__c = null;
            euprodrequest.KR_Exch_A_c_Booking_A_c_details__c = null;
            euprodrequest.TW_Exch_A_c_Booking_A_c_details__c = null;
            euprodrequest.CSG_Status__c = null;
            euprodrequest.Sender_Comp_Id__c = null;
            euprodrequest.SenderSubID__c = null;
            euprodrequest.OnBehalfOfCompID__c = null;
            euprodrequest.OnBehalfOfSubID__c = null;
            euprodrequest.AsiaEtsClients_Effort_Type__c = null;
            euprodrequest.AsiaEtsClients_Completion__c = null;
            euprodrequest.Asia_IT_Communication_Comments__c = null;
            euprodrequest.OMW_Migration_Phase2__c = False;
            euprodrequest.AP_Integration_Status__c = null;
            euprodrequest.AP_Integration_Comments__c = null;

        }

        if (NA_Flow != null || EU_Flow != null || AP_Flow != null)
        {
            // Check if DMA flow is selected for any of the regions
            //gupankur, 28Sep 2015, REQ4441102, start - Ankur Gupta
            //himanb REQ5338630 22-apr-2016 , added speedway for AP and EU flows
            if ((NA_Flow != null && (NA_Flow.indexOf('DMA/SORT') == -1 || NA_Flow.indexOf('Broker Dealer') == -1 || NA_Flow.indexOf('Speedway') == -1)) && (EU_Flow != null && EU_Flow.indexOf('DMA/SORT') == -1 && EU_Flow.indexOf('Speedway') == -1) && (AP_Flow != null && AP_Flow.indexOf('DMA/SORT') == -1 && AP_Flow.indexOf('Speedway') == -1))
            {
            //gupankur, 28Sep 2015, REQ4441102, end - Ankur Gupta
                euprodrequest.Default_to_SORTDMA__c = False;
                //euprodrequest.ClearingMethod__c = null;
                //euprodrequest.NYSE_Member__c = null;
            }
            // Check if Sales Desk/BI flow is selected for any of the regions
            if ((NA_Flow != null && NA_Flow.indexOf('Sales Desk/BI') == -1) && (EU_Flow != null && EU_Flow.indexOf('Sales Desk/BI') == -1) && (AP_Flow != null && AP_Flow.indexOf('Sales Desk/BI') == -1))
            {
                euprodrequest.EU_Cash_Coverage__c = null;
                euprodrequest.HK_Cash_Coverage__c = null;
                euprodrequest.JPN_Cash_Coverage__c = null;
                euprodrequest.US_Cash_Coverage__c = null;
            }
            // Check if Progs flow is selected for any of the regions
            if ((NA_Flow != null && NA_Flow.indexOf('Progs') == -1) && (EU_Flow != null && EU_Flow.indexOf('Progs') == -1) && (AP_Flow != null && AP_Flow.indexOf('Progs') == -1))
            {
                euprodrequest.EU_Progs_Coverage__c = null;
                euprodrequest.HK_Progs_Coverage__c = null;
                euprodrequest.JPN_Progs_Coverage__c = null;
                euprodrequest.US_Progs_Coverage__c = null;
                euprodrequest.ClientMnemonic__c = null;
            }
            // Check if Progs flow is selected for any of the regions
            if ((NA_Flow != null && NA_Flow.indexOf('Progs') == -1) && (EU_Flow != null && EU_Flow.indexOf('Progs') == -1) && (AP_Flow != null && AP_Flow.indexOf('Progs') == -1))
            {
                euprodrequest.EU_Progs_Coverage__c = null;
                euprodrequest.HK_Progs_Coverage__c = null;
                euprodrequest.JPN_Progs_Coverage__c = null;
                euprodrequest.US_Progs_Coverage__c = null;
                euprodrequest.ClientMnemonic__c = null;
            }
            // Check if IOI flow is selected for any of the regions
            if ((NA_Flow != null && NA_Flow.indexOf('IOI') == -1) && (EU_Flow != null && EU_Flow.indexOf('IOI') == -1) && (AP_Flow != null && AP_Flow.indexOf('IOI') == -1))
            {
                euprodrequest.IOI_options__c = null;
            }
            // Check if FIX to PassportWin flow is selected for any of the regions
            if ((NA_Flow != null && NA_Flow.indexOf('FIX to PassportWin') == -1) && (EU_Flow != null && EU_Flow.indexOf('FIX to PassportWin') == -1) && (AP_Flow != null && AP_Flow.indexOf('FIX to PassportWin') == -1))
            {
                euprodrequest.Passport_User_IDs__c = null;
            }
        
        }

        if(NA_Flow != null)
        {
            String NAMktList = '';
            //NAMktList = euprodrequest.North_America_Markets__c;

            if (NAMktList != null)
            {
                if (NAMktList.indexOf('US Core Equity markets') == -1)
                {euprodrequest.US_Core_Equity_markets_commission__c = null;}
                if (NAMktList.indexOf('US Core Derivs markets') == -1)
                {euprodrequest.US_Core_Derivs_markets_commission__c = null;}
                if (NAMktList.indexOf('Canada') == -1)
                {euprodrequest.Canada_commission__c = null;}
                if (NAMktList.indexOf('Mexico') == -1)
                {euprodrequest.Mexico_commission__c = null;}
            }
            else
            {
                euprodrequest.US_Core_Equity_markets_commission__c = null;
                euprodrequest.US_Core_Derivs_markets_commission__c = null;
                euprodrequest.Canada_commission__c = null;
                euprodrequest.Mexico_commission__c = null;
            }
        }

        if(AP_Flow != null)
        {
            String APMktList = '';
            APMktList = euprodrequest.Asia_Pacific_Markets__c;

            if (APMktList != null)
            {
                if (APMktList.indexOf('India') == -1)
                {euprodrequest.India_Commission__c = null;}
                if (APMktList.indexOf('Korea') == -1)
                {euprodrequest.Korea_Commission__c = null;}
                if (APMktList.indexOf('Taiwan') == -1)
                {euprodrequest.Taiwan_Commission__c = null;}
                if (APMktList.indexOf('Japan') == -1)
                {euprodrequest.Japan_Commission__c = null;}
                if (APMktList.indexOf('HK/SI/AU') == -1)
                {euprodrequest.Asia_Core_Markets_Commission__c = null;}
            }
            else
            {
                euprodrequest.India_Commission__c = null;
                euprodrequest.Korea_Commission__c = null;
                euprodrequest.Taiwan_Commission__c = null;
                euprodrequest.Japan_Commission__c = null;
                euprodrequest.Asia_Core_Markets_Commission__c = null;
            }
        }

        //Reset the JP Sort Destination field on the basis of selection/flag
        if(this.JPSortDestFlag == 0) {
            euprodrequest.JP_SORT_Dest_List__c = null;
        }
        
        // Reset the Limit section fields for EU
        String AssetClass_list = '';
        AssetClass_list = euprodrequest.Asset_Class__c;
        if (AssetClass_list == null)
        {AssetClass_list = 'nothing';}

        // Reset Limit section field for NA
        if(NA_Flow != null && AssetClass_list != null)
        {
            if ((NA_Flow.indexOf('DMA/SORT') == -1 && NA_Flow.indexOf('Algos/Strategies') == -1 && NA_Flow.indexOf('FIX to PassportWin') == -1) && ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1)))
            {
                euprodrequest.US_Equity_Single__c = null;
                euprodrequest.US_Equity_Cum__c = null;
                euprodrequest.SA_Equity_Cum__c = null;
            }
            if ((NA_Flow.indexOf('DMA/SORT') == -1 && NA_Flow.indexOf('Algos/Strategies') == -1 && NA_Flow.indexOf('FIX to PassportWin') == -1) || (AssetClass_list.indexOf('Futures') == -1))
            {
                euprodrequest.US_Futs_Single__c = null;
                euprodrequest.US_Futs_Cum__c = null;
            }
            if ((NA_Flow.indexOf('DMA/SORT') == -1 && NA_Flow.indexOf('Algos/Strategies') == -1 && NA_Flow.indexOf('FIX to PassportWin') == -1) || (AssetClass_list.indexOf('Options') == -1))
            {
                euprodrequest.US_Stock_Opt_Single__c = null;
                euprodrequest.US_Stock_Opt_Cum__c = null;
                euprodrequest.US_Index_Opt_Single__c = null;
                euprodrequest.US_Index_Opt_Cum__c = null;
            }
        }

        // Reset Limit section field for AP

        if (AP_Flow != null)
        {
            String APMktList = '';
            APMktList = euprodrequest.Asia_Pacific_Markets__c;
            String equitySM = euprodrequest.Equity_Swap_Markets__c; //// singhrak, 2dec, 14 TASK3551306
            if (APMktList != null && equitySM !=null) // singhrak, 2dec, 14 TASK3551306, added and clause
            {
                /* singhrak, 2dec, 14 TASK3551306, added and clause
                Earlier: if ((APMktList.indexOf('Japan') == -1) || ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1)))
                Present: if ((APMktList.indexOf('Japan') == -1 && equitySM.indexOf('Japan') == -1 ) || ( ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1))  && equitySM.indexOf('Equity Swaps') == -1 )   )
                
                This id done for 6 rgion: IN,JP, HK/SI/AU, TW,KR BRoker limits 
                */
                
                if ((APMktList.indexOf('Japan') == -1 && equitySM.indexOf('Japan') == -1 ) || ( ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1))  && equitySM.indexOf('Equity Swaps') == -1 )   )
                {
                    euprodrequest.Japan_Equity_Single__c = null;
                    euprodrequest.Japan_Equity_Cum__c = null;
                }
                if ((APMktList.indexOf('Japan') == -1) || (AssetClass_list.indexOf('Futures') == -1))
                {
                    euprodrequest.Japan_Futures_Single__c = null;
                    euprodrequest.Japan_Futures_Cum__c = null;
                }
                if ((APMktList.indexOf('NJA Core(HK/SI/AU)') == -1 && equitySM.indexOf('NJA Core(HK/SI/AU)') == -1) || ( ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1))  && equitySM.indexOf('Equity Swaps') == -1 )   )
                {
                    euprodrequest.HK_SI_AU_Equity_Single__c = null;
                    euprodrequest.HK_SI_AU_Equity_Cum__c = null;
                }
                if ((APMktList.indexOf('HK/SI/AU') == -1) || (AssetClass_list.indexOf('Futures') == -1))
                {
                    euprodrequest.HK_SI_AU_Futures_Single__c = null;
                    euprodrequest.HK_SI_AU_Futures_Cum__c = null;
                }
                if ((APMktList.indexOf('India') == -1 && equitySM.indexOf('India') == -1) || ( ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1))  && equitySM.indexOf('Equity Swaps') == -1 )   )
                {
                    euprodrequest.India_Equity_Single__c = null;
                    euprodrequest.India_Equity_Cum__c = null;
                }
                if ((APMktList.indexOf('India') == -1) || (AssetClass_list.indexOf('Futures') == -1))
                {
                    euprodrequest.India_Futures_Single__c = null;
                    euprodrequest.India_Futures_Cum__c = null;
                }

                if ((APMktList.indexOf('Taiwan') == -1 && equitySM.indexOf('Taiwan') == -1) || ( ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1))  && equitySM.indexOf('Equity Swaps') == -1 )   )
                {
                    euprodrequest.Taiwan_Equity_Single__c = null;
                    euprodrequest.Taiwan_Equity_Cum__c = null;
                }
                if ((APMktList.indexOf('Taiwan') == -1) || (AssetClass_list.indexOf('Futures') == -1))
                {
                    euprodrequest.Taiwan_Futures_Single__c = null;
                    euprodrequest.Taiwan_Futures_Cum__c = null;
                }
                if ((APMktList.indexOf('Korea') == -1 && equitySM.indexOf('Korea') == -1) || ( ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1))  && equitySM.indexOf('Equity Swaps') == -1 )   )
                {
                    euprodrequest.Korea_Equity_Single__c = null;
                    euprodrequest.Korea_Equity_Cum__c = null;
                    euprodrequest.Korea_Onshore_Net_Limit__c = null;
                }
                if ((APMktList.indexOf('Korea') == -1) || (AssetClass_list.indexOf('Futures') == -1))
                {
                    euprodrequest.Korea_Futures_Single__c = null;
                    euprodrequest.Korea_Futures_Cum__c = null;
                }
                if(( (APMktList.indexOf('New Zealand')== -1) && (APMktList.indexOf('Philippines')== -1) && (APMktList.indexOf('Indonesia')== -1) && (APMktList.indexOf('Malaysia')== -1) && (APMktList.indexOf('Thailand')== -1) && (equitySM.indexOf('New Zealand')== -1) && (equitySM.indexOf('Philippines')== -1) && (equitySM.indexOf('Indonesia')== -1) && (equitySM.indexOf('Malaysia')== -1) && (equitySM.indexOf('Thailand')== -1)) || ( ((AssetClass_list.indexOf('Equity Swaps') == -1)&&(AssetClass_list.indexOf('Equity') == -1))  && equitySM.indexOf('Equity Swaps') == -1 )   )
                {
                  euprodrequest.Broker_Markets_Single__c = null;
                  euprodrequest.Broker_Markets_Cum__c = null;
                }
            }
            else
            {
               if(euprodrequest.Asia_Pacific_Markets__c == null && euprodrequest.Equity_Swap_Markets__c == null) //singhrak, 2dec, 14 TASK3551306
               {//singhrak, 2dec, 14 TASK3551306
                
                euprodrequest.Japan_Equity_Single__c = null;
                euprodrequest.Japan_Equity_Cum__c = null;
                euprodrequest.HK_SI_AU_Equity_Single__c = null;
                euprodrequest.HK_SI_AU_Equity_Cum__c = null;
                euprodrequest.India_Equity_Single__c = null;
                euprodrequest.India_Equity_Cum__c = null;
                euprodrequest.Taiwan_Equity_Single__c = null;
                euprodrequest.Taiwan_Equity_Cum__c = null;
                euprodrequest.Korea_Equity_Single__c = null;
                euprodrequest.Korea_Equity_Cum__c = null;
                euprodrequest.Broker_Markets_Single__c = null;
                euprodrequest.Broker_Markets_Cum__c = null;
                euprodrequest.Korea_Onshore_Net_Limit__c = null;
                euprodrequest.Japan_Futures_Single__c = null;
                euprodrequest.Japan_Futures_Cum__c = null;
                euprodrequest.HK_SI_AU_Futures_Single__c = null;
                euprodrequest.HK_SI_AU_Futures_Cum__c = null;
                euprodrequest.India_Futures_Single__c = null;
                euprodrequest.India_Futures_Cum__c = null;
                euprodrequest.Taiwan_Futures_Single__c = null;
                euprodrequest.Taiwan_Futures_Cum__c = null;
                euprodrequest.Korea_Futures_Single__c = null;
                euprodrequest.Korea_Futures_Cum__c = null;
               }  //singhrak, 2dec, 14 TASK3551306

            }
        }

        // for FIX Certification reset all the hidden field values.

        if (euprodrequest.Set_up_type__c == 'FIX Certification')
        {
            euprodrequest.Default_to_SORTDMA__c = false;

            euprodrequest.EU_Cash_Coverage__c = null;
            euprodrequest.HK_Cash_Coverage__c = null;
            euprodrequest.JPN_Cash_Coverage__c = null;
            euprodrequest.US_Cash_Coverage__c = null;

            euprodrequest.EU_Progs_Coverage__c = null;
            euprodrequest.HK_Progs_Coverage__c = null;
            euprodrequest.JPN_Progs_Coverage__c = null;
            euprodrequest.US_Progs_Coverage__c = null;
            euprodrequest.ClientMnemonic__c = null;

            euprodrequest.Passport_User_IDs__c = null;
            euprodrequest.IOI_options__c = null;
            //euprodrequest.CFM_Coverage__c = null;
            euprodrequest.KR_Trading_Approach__c = null;
            euprodrequest.KR_Investor_IDs__c = null;
            euprodrequest.TW_Trading_Approach__c = null;
            euprodrequest.TW_Investor_IDs__c = null;
            euprodrequest.India_Investor_IDs__c = null;

            euprodrequest.JP_FUT_OPT_DMA_OMS_Mnemonic__c = null;
            euprodrequest.JP_FUT_OPT_Coverage__c = null;
            euprodrequest.NJA_FUT_OPT_DMA_OMS_Mnemonic__c = null;
            euprodrequest.JP_FUT_OPT_BI_OMS_Mnemonic__c = null;
            euprodrequest.NJA_FUT_OPT_BI_OMS_Mnemonic__c = null;
            euprodrequest.NJA_FUT_OPT_Coverage__c = null;
            euprodrequest.MS_Clearing_Account_SG_AX__c = null;

            euprodrequest.PB_with_MS__c = false;
            euprodrequest.If_Giveup_then_who_and_account_no__c = null;
            euprodrequest.Allocation_Type__c = null;
            euprodrequest.Allocation_Account__c = null;
            euprodrequest.Allocation_Delivery__c = null;
            euprodrequest.Booking_Account__c = null;
            euprodrequest.Avg_Pricing__c = null;
            euprodrequest.If_Special_Pricing_Specify__c = null;
            euprodrequest.Confirmation_Template__c = null;
            euprodrequest.Recipients_for_Confirmations__c = null;
            euprodrequest.Confirmation_Method__c = null;
            euprodrequest.Other_Confirmation_Method_Details__c = null;
            euprodrequest.Need_all_mkts_on_1_conf__c = false;

            euprodrequest.JP_Client_Profile_Name__c = null;
            euprodrequest.JP_OMSMnemonic__c = null;
            euprodrequest.Correct_TNL_ID__c = null;
            euprodrequest.Company_Code__c = null;
            euprodrequest.Assigned_Person__c = null;
            euprodrequest.KR_Exch_A_c_Booking_A_c_details__c = null;
            euprodrequest.TW_Exch_A_c_Booking_A_c_details__c = null;
            euprodrequest.CSG_Status__c = null;

            euprodrequest.Sender_Comp_Id__c = null;
            euprodrequest.SenderSubID__c = null;
            euprodrequest.OnBehalfOfCompID__c = null;
            euprodrequest.OnBehalfOfSubID__c = null;

            euprodrequest.AsiaEtsClients_Effort_Type__c = null;
            euprodrequest.AsiaEtsClients_Completion__c = null;
            euprodrequest.Asia_IT_Communication_Comments__c = null;
            euprodrequest.OMW_Migration_Phase2__c = false;
            //System.debug('Inside save last:'+euprodrequest.UUID_User_Number_Name__c);

        }
        if(euprodrequest.Set_up_type__c == 'Decommission')
        {
            euprodrequest.US_Core_Equity_markets_commission__c = null;
            euprodrequest.US_Core_Derivs_markets_commission__c = null;
            euprodrequest.Canada_commission__c = null;
            euprodrequest.Mexico_commission__c = null;
            euprodrequest.EU_Core_Equity_markets_Commission__c = null;
            euprodrequest.EU_Core_Derivs_markets_Commission__c = null;
            euprodrequest.Greece_DMA_Commission__c = null;
            euprodrequest.South_Africa_DMA_Commission__c = null;
            euprodrequest.Turkey_DMA_Commission__c = null;
            euprodrequest.Czech_Rep_DMA_Commission__c = null;
            euprodrequest.Ireland_DMA_Commission__c = null;
            euprodrequest.Hungary_DMA_Commission__c = null;
            euprodrequest.Poland_DMA_Commission__c = null;
            euprodrequest.Chi_X_Direct_Commission__c = null;
            euprodrequest.BATS_Europe_Direct_Commission__c = null;
            euprodrequest.NASDAQ_OMX_Europe_Direct_Commission__c = null;
            euprodrequest.NYSE_Arca_Europe_Direct_Commission__c = null;
            euprodrequest.Turquoise_Direct_Commission__c = null;
            euprodrequest.India_Commission__c = null;
            euprodrequest.Korea_Commission__c = null;
            euprodrequest.Taiwan_Commission__c = null;
            euprodrequest.Japan_Commission__c = null;
            euprodrequest.Asia_Core_Markets_Commission__c = null;

            euprodrequest.EU_Equity_Single__c = null;
            euprodrequest.EU_Equity_Cum__c = null;
            euprodrequest.EU_Futs_Single__c = null;
            euprodrequest.EU_Futs_Cum__c = null;
            euprodrequest.EU_Stock_Opt_Single__c = null;
            euprodrequest.EU_Stock_Opt_Cum__c = null;
            euprodrequest.EU_Index_Opt_Single__c = null;
            euprodrequest.EU_Index_Opt_Cum__c = null;
            euprodrequest.US_Equity_Single__c = null;
            euprodrequest.US_Equity_Cum__c = null;
            euprodrequest.SA_Equity_Cum__c = null;
            euprodrequest.US_Futs_Single__c = null;
            euprodrequest.US_Futs_Cum__c = null;
            euprodrequest.US_Stock_Opt_Single__c = null;
            euprodrequest.US_Stock_Opt_Cum__c = null;
            euprodrequest.US_Index_Opt_Single__c = null;
            euprodrequest.US_Index_Opt_Cum__c = null;
            euprodrequest.Japan_Equity_Single__c = null;
            euprodrequest.Japan_Equity_Cum__c = null;
            euprodrequest.HK_SI_AU_Equity_Single__c = null;
            euprodrequest.HK_SI_AU_Equity_Cum__c = null;
            euprodrequest.India_Equity_Single__c = null;
            euprodrequest.India_Equity_Cum__c = null;
            euprodrequest.Taiwan_Equity_Single__c = null;
            euprodrequest.Taiwan_Equity_Cum__c = null;
            euprodrequest.Korea_Equity_Single__c = null;
            euprodrequest.Korea_Equity_Cum__c = null;
            euprodrequest.Broker_Markets_Single__c = null;
            euprodrequest.Broker_Markets_Cum__c = null;
            euprodrequest.Korea_Onshore_Net_Limit__c = null;
            euprodrequest.Japan_Futures_Single__c = null;
            euprodrequest.Japan_Futures_Cum__c = null;
            euprodrequest.HK_SI_AU_Futures_Single__c = null;
            euprodrequest.HK_SI_AU_Futures_Cum__c = null;
            euprodrequest.India_Futures_Single__c = null;
            euprodrequest.India_Futures_Cum__c = null;
            euprodrequest.Taiwan_Futures_Single__c = null;
            euprodrequest.Taiwan_Futures_Cum__c = null;
            euprodrequest.Korea_Futures_Single__c = null;
            euprodrequest.Korea_Futures_Cum__c = null;
        }
        

       boolean pageReferenceAction = doSave(euprodrequest);
         
         if(pageReferenceAction){
         
            return null;
         }
       //  After Save, navigate to the default view page:
       return (new ApexPages.StandardController(euprodrequest)).view();
   }
   
   public boolean doSave(EU_ProductRequest__c euprodrequestRef)
   {

        this.euprodrequest = euprodrequestRef;          
        
        if(euprodrequest.Status__c == 'Submitted'){
          autoIntegratorAssignment();
        }
        
        
         //himanb REQ5291267 18-Apr-2016
        if(euprodrequest.IntegratorSet__c ==false){
            system.debug('****** 19 apr code flag '+euprodrequest.IntegratorSet__c);
            system.debug('****** 19 apr code');
        euprodrequest.IntegratorSet__c = true;
        }
        
        Boolean fileCheckResult = checkFileValidations();
        
        
        //singhrak, 17Feb, 2015,REQ3418983, start
        if(NA_Coverage_Flag != 1)
            euprodrequest.NA_Coverage_Person__c = null;
        if(EU_Coverage_Person_Flag != 1) 
            euprodrequest.EU_Coverage_Person__c = null;
        if(AP_Coverage_Person_Flag != 1)    
            euprodrequest.Asia_Pacific_Coverage_Person__c = null;
        //singhrak, 17Feb, 2015,REQ3418983, end
        
        Database.UpsertResult upResult;

              try {
        if(fileCheckResult)
       {// file validation
          return true;
        }

          if(fileNameMy != null)
            euprodrequest.DarkPoolApprovalFile__c = fileNameMy;
          else
            euprodrequest.DarkPoolApprovalFile__c = '';
            
            String flowType = getParam('flow');
            if(flowType != null && flowType == 'clone')
            {
            euprodrequest.id = null;
            }
            
            upResult =  Database.upsert(euprodrequest);
                  System.debug('upResult_11'+upResult);
          //REQ5266683, kumvina 24May2016 commented code for US limits section   
         //   if(upResult!= null && upResult.isCreated() && euprodrequest.Comments_US_Limits_Information__c != null && euprodrequest.Comments_US_Limits_Information__c.length()>=1)
// singhrak, REQ3508647, 20March, 2015, update below method to take id as argument            
      //          createLimitRecord(upResult.Id);
             
            if(upResult != null && upResult.isCreated() && ETSBSActionFlag==1)
                createETSDB();
            
            if(document3.name != null && upResult.Id != null)
            {
                attachFileInTicketForNALimitInfo(upResult.Id,document3.name);
            }
            
            if(document4.name != null && upResult.Id != null)
            {
                attachFileInTicketForEULimitInfo(upResult.Id,document4.name);
            }
            
            
            
            if(fileNameMy != null && upResult.Id != null)
            {
                if(euprodrequest.Status__c != null && euprodrequest.Status__c == 'Submitted' &&
                euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup' || euprodrequest.Set_up_type__c == 'Modify Client Setup') && (euprodrequest.Asia_Pacific_Markets__c != null  &&
                (euprodrequest.Asia_Pacific_Markets__c.indexOf('NJA Core(HK/SI/AU)') != -1 || euprodrequest.Asia_Pacific_Markets__c.indexOf('HK') != -1 )
                ) && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) ) )
                  {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
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
              
              
     /*  try {
            upsert(euprodrequest);
            } catch(System.DMLException e) {
           ApexPages.addMessages(e);
          return null;
       } */  
        
        if(euprodrequest.Name == null)
        {
            if(euprodrequest.Status__c !=null && euprodrequest.Status__c == 'Submitted' && 
            euprodrequest.Set_up_type__c != null && (euprodrequest.Set_up_type__c == 'New Client Setup' || euprodrequest.Set_up_type__c == 'Modify Client Setup')
                && euprodrequest.Asset_Class__c != null && (euprodrequest.Asia_Pacific_Flow_Details__c != null && 
        (euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('Algos/Strategies') != -1  || euprodrequest.Asia_Pacific_Flow_Details__c.indexOf('DMA/SORT') != -1) )
        ) 
                  {
                    String[] part;
                     part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
                       for(String z:part)
                       {
                          if(z=='Equity' || z=='Options on Futures' || z=='Options' || z=='Futures')
                          {
                            if(euprodrequest.hksfc__c == true && document2.name != null)
                            {
                                attachUploadedFileInTicketHKSFC(upResult.Id);
                                sendEmailto_hksfc(upResult.Id); 
                            }
                                
                          }
                          
                       }   
                  }
        }
        

       } catch(System.DMLException e) {
           ApexPages.addMessages(e);
           system.debug('incatch'+e);
           return true;
       }
       finally
       {
              fileNameMy = null;
              document1.body = null;
              
              document2.name= null;
              document2.body = null;
       }
       
        sendMailtoIntegrator();
        
       if (euprodrequest.NA_Coverage_Person__c != null || euprodrequest.EU_Coverage_Person__c !=null || euprodrequest.Asia_Pacific_Coverage_Person__c !=null)
       {
        sendMailtoCoveragePerson();
       } 
       
        if (euprodrequest.Send_Email_to_CSG_Groups__c != null )
       {
        sendMailtoCSGGroup();
       }          
    
    sendUploadedFileForNAandEU();   
   
   return false;
   }
   
   
   // singhrak, REQ3508647, 20March, 2015, start
public String getEUProdName(String id)
   {
    EU_ProductRequest__c eu = [select name from EU_ProductRequest__c where id=:id];
    return eu.name;
   }
// singhrak, REQ3508647, 20March, 2015, end
   
   // singhrak, REQ3508647, 20March, 2015, add (String id) as parameter
   /*public void createLimitRecord(String id)
    {
    Limit_Update__c lu=new Limit_Update__c();
    lu.Account__c = euprodrequest.MSET_Account__c;
    lu.Comments__c = euprodrequest.Comments_US_Limits_Information__c;
    lu.Reason_for_Change__c = euprodrequest.Reason_for_Change__c;
    lu.Requested_By__c = euprodrequest.RequestedBy__c;
    lu.DisableTriggerFlagLU__c='disable368';
//  lu.Send_Email_To__c = 'Email to logged In User';
    // singhrak, REQ3508647, 20March, 2015, start
    lu.FIX_prod_req_no__c = getEUProdName(id);
    // singhrak, REQ3508647, 20March, 2015, end
    Database.Upsertresult ur =Database.upsert(lu);
     
     if (ur.id!= null)
       {
        sendMailto(ur.id);
       }
    }*/
    
     
   /* public void sendMailto(String whatId) 
   {
         Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
         email.setTargetObjectId(euprodrequest.RequestedBy__c);
        //email.setCcAddresses(new String[]{'mset-limitcontrol@morganstanley.com.test',euprodrequest.NA_Coverage_Person__c});
        
         //REQ3774592,singhrak,3May, 2015, satrt, update cc address as per below
         List<String> ccAddr = new List<String>();
         ccAddr.add(Label.EUProductRequest_Email3);
         if(euprodrequest.NA_Coverage_Person__c != null && euprodrequest.NA_Coverage_Person__c != '')
            ccAddr.add(euprodrequest.NA_Coverage_Person__c);
         email.setCcAddresses(ccAddr);
         //REQ3774592,singhrak,3May, 2015, end
         email.setWhatId(whatId);
         email.setTemplateId('00X600000017JpF');
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
   }
    */
   
   public void attachFileInTicketForNALimitInfo(String id,String fileName)
    {
       document3.ParentId = id;
       document3.Name= fileName+'(NA Region Limits Information)';
       insert document3;
    }
    
    public void attachFileInTicketForEULimitInfo(String id,String fileName)
    {
       document4.ParentId = id;
       document4.Name= fileName+'(EU Region Limits Information)';
       insert document4;
    }
    
        public Attachment document3 {
      get {
        if (document3 == null)
          document3 = new Attachment();
        return document3;
      }
      set;
    }
    
    
    public Attachment document4 {
      get {
        if (document4 == null)
          document4 = new Attachment();
        return document4;
      }
      set;
    }
    
        public Integer EULimitFlag;
    public Integer getEULimitFlag()
    {
        return EULimitFlag;     
    }
    
    public void calcEULimitFlag()
    {
        if(euprodrequest.Europe_Flow_Details__c != null && euprodrequest.Asset_Class__c!= null )
        {
            String[] part = euprodrequest.Asset_Class__c.split(';');
              for(String value:part)
              {
                if(value=='Futures' || value=='Options' || value=='Options Complex' || value=='Options on Futures')
                {
                    EULimitFlag = 1;
                    break;
                }
                 else
                    EULimitFlag = 0;
              }
        }
        else
            EULimitFlag = 0;
            
            System.debug('EULimitFlagXXX::'+EULimitFlag);
        
    }
    
    public Integer NALimitFlag;
    public Integer getNALimitFlag()
    {
        return NALimitFlag;     
    }
    
    public void calcNALimitFlag()
    {
        if(euprodrequest.North_America_Flow_Details__c != null && euprodrequest.Asset_Class__c!= null )
        {
            String[] part = euprodrequest.Asset_Class__c.split(';');
              for(String value:part)
              {
                if(value=='Futures' || value=='Options' || value=='Options Complex' || value=='Options on Futures')
                {
                    NALimitFlag = 1;
                    break;
                }
                 else
                    NALimitFlag = 0;
              }
        }
        else
            NALimitFlag = 0;
            
            System.debug('NALimitFlag::'+NALimitFlag);
        
    }
    

     public void sendUploadedFileForNAandEU()
    {
       try {
        
        List<EmailTemplate> template= [Select Id, DeveloperName, Name from EmailTemplate where DeveloperName='VF_template_to_confirm_that_FIX_setup_is'];
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          //String[] toAddresses = new String[] {'rakesh.singh1@morganstanley.com.test'};
          //mail.setToAddresses(toAddresses);
          
         //List<GPSContact__c> futurecontact=[Select Id,Email__c from GPSContact__c where Email__c= 'mset-futures@morganstanley.com' ] 
         //mail.setTargetObjectId('0036000001lK5uG');
          mail.setToAddresses(new string []{'mset-futures@morganstanley.com'});
          mail.setSaveAsActivity(false);
            Integer numOfAtatchments = 0;
            
            if(document3.Name != null)
            {
                numOfAtatchments++;
            }
            
            if(document4.Name != null)
            {
                numOfAtatchments++;
            }
          Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[numOfAtatchments];
          
          Integer index=0;
          if(document3.Name != null)
          {
          Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
          fileAttachment.setBody(document3.body);
          fileAttachment.setFileName(document3.name);
          fileAttachments[index] = fileAttachment;
          index++;
          }
          
          if(document4.Name != null)
          {
          Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
          fileAttachment.setBody(document4.body);
          fileAttachment.setFileName(document4.name);
          fileAttachments[index] = fileAttachment;
          index++;
          }
          
          mail.setFileAttachments(fileAttachments);
          
          mail.setWhatId(euprodrequest.Id);
          
          if(template.size()>0)
          mail.setTemplateId(template[0].Id);//qa - 00XT0000000n9uP  prod - 00X600000011DWc
          
          if(document3.Name != null || document4.Name != null)
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          System.debug('15A');
       
     } catch (DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
        System.debug('Exceptionmykljj::'+e);
      } finally {
        document3.body = null; // clears the viewstate
        document3 = new Attachment();
        
        document4.body = null; // clears the viewstate
        document4 = new Attachment();
      }
    
    }
    
   /*
   
   public PageReference emailToASGCASH()
    {
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                      
         email.setTargetObjectId('0036000001kbspx');
         email.setTemplateId('00X600000017HVS');
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         return null;
    }
    
    public PageReference sendMailtoIntegrator1(String[] alias){
     //String[] address = new String[]{'venkat.nalam@morganstanley.com.test.test'};
     //String subject = 'Fix Product Request '+  euprodrequest.Name + ' for ' +  euprodrequest.GPS_Account__r.Name + ' has been updated by ' + euprodrequest.Logged_In_User__c;   
     
     List<User> userIds = [select Id,Email from User where Alias in :alias];
     String[] toAddresses2 = new list<String>();
     
        for (User u : userIds) {
          toAddresses2.add(u.Email);
          System.debug('iamgreat113334'+u.Email);
        }
     if(toAddresses2 != null && toAddresses2.size()>0){
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                      
         email.setTargetObjectId(userId.Id);//euprodrequest.RequestedBy__c);
         email.setCcAddresses(toAddresses2);
         email.setTemplateId('00X600000017HVS');//qa - 00XT0000000nOY4  prod - 00X600000017HVS
         email.saveAsActivity = false;
         email.setWhatId(euprodrequest.Id);
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     }
     return null;
   }
    */

   public PageReference sendMailtoCoveragePerson() 
   {
    
    List<EmailTemplate> template= [Select Id, DeveloperName, Name from EmailTemplate where DeveloperName='VF_template_to_confirm_that_FIX_setup_is'];
    String[] toAddresses1 = new list<String>();
     if(euprodrequest.NA_Coverage_Person__c !=null)
      {
         toAddresses1.add(euprodrequest.NA_Coverage_Person__c);
      }
      if(euprodrequest.EU_Coverage_Person__c != null)
      {
        toAddresses1.add(euprodrequest.EU_Coverage_Person__c);
      }
      if(euprodrequest.Asia_Pacific_Coverage_Person__c != null)
      {
        toAddresses1.add(euprodrequest.Asia_Pacific_Coverage_Person__c);
      }
         Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
         email.setTargetObjectId(UserInfo.getUserId());//euprodrequest.RequestedBy__c);
         email.setCcAddresses(toAddresses1);
         email.setWhatId(euprodrequest.Id);
         if(template.size()>0)
         email.setTemplateId(template[0].id);//qa - 00XT0000000n9uP  prod - 00X600000011DWc
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     
     return null;
      
   }
   
   public PageReference sendMailtoCSGGroup() 
   {
    List<EmailTemplate> template= [Select Id, DeveloperName, Name from EmailTemplate where DeveloperName='VF_template_for_booking_Section'];
    
    String[] toAddresses3 = new list<String>();
     if(euprodrequest.Send_Email_to_CSG_Groups__c !=null)
      {
         toAddresses3.add(euprodrequest.Send_Email_to_CSG_Groups__c);
      }
         Messaging.SingleEmailMessage email = new Messaging.Singleemailmessage();
         email.setTargetObjectId(UserInfo.getUserId());//euprodrequest.RequestedBy__c);
         email.setCcAddresses(toAddresses3);
         email.setWhatId(euprodrequest.Id);
         if(template.size()>0)
         email.setTemplateId(template[0].id);//prod - 00X60000000p8kt QA - 00XT0000000nZd5
         email.saveAsActivity = false;
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     
     return null;
      
   }
   
   public PageReference sendMailtoIntegrator(){
     //String[] address = new String[]{'venkat.nalam@morganstanley.com.test.test'};
     //String subject = 'Fix Product Request '+  euprodrequest.Name + ' for ' +  euprodrequest.GPS_Account__r.Name + ' has been updated by ' + euprodrequest.Logged_In_User__c;   
    if(euprodrequest.Integrator__c != null){  
       String[]  toIntegrators = euprodrequest.Integrator__c.split(';');
        String[] toAddresses  = new String[]{};
     for(Integer i=0; i< toIntegrators.size() ; i++){
     if(toIntegrators[i] == 'Unassigned_NA' || toIntegrators[i] == 'Unassigned_EU' || toIntegrators[i] == 'Unassigned_FE'||
         toIntegrators[i] == 'ASG-NA' || toIntegrators[i] == 'TCS_AGENCY' || toIntegrators[i] == 'TCS ETSCLIENTS' || 
         toIntegrators[i] == 'ASGAMHT'     
        )
             continue;
      else
           {
                toAddresses.add(toIntegrators[i]);
           }  
     
     }
     
     String[] toAddresses2 = new list<String>();
     
     if(toAddresses.size()>0)
     {
        List<User_Region__c> userIds = [select User__c,EMail__c from User_Region__c where MS_User_Id__c in :toAddresses];
        for (User_Region__c u : userIds) {
          toAddresses2.add(u.EMail__c);
        }   
     }
     
        
      if(euprodrequest.Integrator__c.indexOf('ASGCASH') != -1)
      {
        toAddresses2.add('asgcash@morganstanley.com.test');//jira:MSETSF-413 kumvina 06June2016
      }

      if(euprodrequest.Integrator__c.indexOf('blretsclients') != -1)
      {
        toAddresses2.add(Label.EUProductRequest_Email5);//jira:MSETSF-413 kumvina 06June2016
        /*
        toAddresses2.add('April.Ambroise@morganstanley.com.test.test');
        toAddresses2.add('Snigdha.Arora@morganstanley.com.test.test');
        toAddresses2.add('Namgyun.Kim@morganstanley.com.test.test');
        toAddresses2.add('Nipun.Sharma@morganstanley.com.test.test');
        toAddresses2.add('Chaitanya.Kumar.Vutla@morganstanley.com.test.test');
        */
      }

               
     if(toAddresses2 != null && toAddresses2.size()>0){
        List<EmailTemplate> template= [Select Id, DeveloperName, Name from EmailTemplate where DeveloperName='VF_template_for_Fix_form_to_Integrator'];
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                      
         email.setTargetObjectId(userId.Id);//euprodrequest.RequestedBy__c);
         email.setCcAddresses(toAddresses2);
         if(template.size()>0)
         email.setTemplateId(template[0].id);//qa - 00XT0000000nOY4  prod - 00X600000017HVS
         email.saveAsActivity = false;
         email.setWhatId(euprodrequest.Id);
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     }
     }
    
     return null;
   }
   
   
/*
   public PageReference sendMailtoIntegrator(){
     //String[] address = new String[]{'venkat.nalam@morganstanley.com.test.test'};
     //String subject = 'Fix Product Request '+  euprodrequest.Name + ' for ' +  euprodrequest.GPS_Account__r.Name + ' has been updated by ' + euprodrequest.Logged_In_User__c;   
     
     List<User> userIds = [select Id,Email from User where Alias in :toAddresses];
     String[] toAddresses2 = new list<String>();
     
        for (User u : userIds) {
          toAddresses2.add(u.Email);
        }
     if(toAddresses2 != null && toAddresses2.size()>0){
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                      
         email.setTargetObjectId(userId.Id);//euprodrequest.RequestedBy__c);
         email.setCcAddresses(toAddresses2);
         email.setTemplateId('00X600000017HVS');//qa - 00XT0000000nOY4  prod - 00X600000017HVS
         email.saveAsActivity = false;
         email.setWhatId(euprodrequest.Id);
         Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
     }
     return null;
   }
  */ 
   // For REQ1042945 start
   /*
   public String fileNameMy {get; set;}
   public Integer fileSizeDP {get; set;}

    public Document document {
      get {
        if (document == null)
          document = new Document();
        return Document;
      }
      set;
    }

    public Integer MandatoryFileUpload = 0;
    public Integer getMandatoryFileUpload()
    {
      return MandatoryFileUpload;
    }
    
    public void calcMandatoryField()
    {
      if(euprodrequest.Enable_for_HK_MSPool__c == true  || euprodrequest.Enable_for_HK_Trajectory_Cross__c == true)
      {
       MandatoryFileUpload = 1;
      }
      else 
      MandatoryFileUpload = 0;
    }


*/


    // For REQ1042945 end
   

    public PageReference calcLimitsSectionDisplayFlag() {

        NAFlow = euprodrequest.North_America_Flow_Details__c;
        EUFlow = euprodrequest.Europe_Flow_Details__c;
        APFlow = euprodrequest.Asia_Pacific_Flow_Details__c;
        //JPFlow = euprodrequest.Japan_Flow_Details__c;

        if (NAFlow != null)
        {system.debug('***3255****');
           
            if (NAFlow.indexOf('Algos/Strategies') != -1)
            {NA_Algos_Flag = 1;}
            else
            {NA_Algos_Flag = 0;}

            if (NAFlow.indexOf('Broker Dealer') != -1)
            {NA_BD_Flag = 1;}
            else
            {NA_BD_Flag = 0;}
            
            if (NAFlow.indexOf('Broker in a Box') != -1)
            {NA_BDB_Flag = 1;}
            else
            {NA_BDB_Flag = 0;}
            
            if (NAFlow.indexOf('CME Direct') != -1)
            {NA_cmeDirectflag = 1;}
            else
            {NA_cmeDirectflag = 0;}
            if (NAFlow.indexOf('Retail') != -1)
            {NA_RETAIL_Flag = 1;}
            else
            {NA_RETAIL_Flag = 0;}
            
            if(NA_BD_Flag == 1 || NA_BDB_Flag == 1 || EU_BD_Flag == 1 || NA_RETAIL_Flag == 1)
            {NA_BD_Whole_Section = 1;}
            else
            {NA_BD_Whole_Section = 0;}
            
            if (NAFlow.indexOf('DMA/SORT') != -1)
            {NA_DMA_Flag = 1;}
            else
            {NA_DMA_Flag = 0;}
            
            if (NAFlow.indexOf('BIDS Trading') != -1)
            {NA_BIDS_Trading_Flag = 1;}
            else
            {NA_BIDS_Trading_Flag = 0;}
            
            if (NAFlow.indexOf('FIX to FX') != -1)
            {NA_FX_Flag = 1;}
            else
            {NA_FX_Flag = 0;}

            if (NAFlow.indexOf('FIX to PassportWin') != -1)
            {NA_Passport_Flag = 1;}
            else
            {NA_Passport_Flag = 0;}

            if (NAFlow.indexOf('GTC/GTD') != -1)
            {NA_GTC_GTD_Flag  = 1;}
            else
            {NA_GTC_GTD_Flag  = 0;}

            if (NAFlow.indexOf('IOI') != -1)
            {NA_IOI_Flag = 1;}
            else
            {NA_IOI_Flag = 0;}

            if (NAFlow.indexOf('Latam') != -1)
            {NA_LA_Flag = 1;}
            else
            {NA_LA_Flag = 0;}

            if(NAFlow.indexOf('MS Port') != -1)
            {NA_MS_Port_Flag = 1;}
            else
            {NA_MS_Port_Flag = 0;}

            if (NAFlow.indexOf('Pairs') != -1)
            {NA_Pairs_Flag = 1;}
            else
            {NA_Pairs_Flag = 0;}

            if (NAFlow.indexOf('Progs') != -1)
            {NA_Progs_Flag = 1;}
            else
            {NA_Progs_Flag = 0;}
            
           
            
            if (NAFlow.indexOf('Sales Desk/BI') != -1)
            {NA_SalesDeskBI_Flag = 1;}
            else
            {NA_SalesDeskBI_Flag = 0;}
                        
            if (NAFlow.indexOf('Speedway') != -1)
            {NA_Speedway_Flag = 1;}
            else
            {NA_Speedway_Flag =0;}
            
            if(NAFlow.indexOf('Sponsored') != -1)
            {NA_Sponsored_Flag =1;}
            else
            {NA_Sponsored_Flag =0;}
            
            if(NAFlow.indexOf('Soft Dollar') != -1)
            {NA_Soft_Dollar_Flag = 1;}
            else
            {NA_Soft_Dollar_Flag = 0;}

            if(NAFlow.indexOf('Migration for CCA/CSA') != -1)
            {NA_CCA_CSA_Soft_Dollar_Flag = 1;}
            else
            {NA_CCA_CSA_Soft_Dollar_Flag = 0;}
            
        }
        else
        {
            NA_DMA_Flag = 0; NA_BIDS_Trading_Flag=0; NA_Algos_Flag = 0;
            NA_SalesDeskBI_Flag = 0; NA_Progs_Flag = 0;
            NA_Passport_Flag = 0; NA_IOI_Flag = 0;
            NA_FX_Flag = 0; NA_RETAIL_Flag = 0; 
            NA_BD_Flag = 0; NA_LA_Flag = 0;NA_BDB_Flag = 0;NA_BD_Whole_Section = 0;
            NA_Speedway_Flag = 0; NA_Sponsored_Flag = 0;
            NA_MS_Port_Flag = 0; NA_Pairs_Flag = 0;
            NA_GTC_GTD_Flag = 0; NA_Soft_Dollar_Flag = 0;
            NA_CCA_CSA_Soft_Dollar_Flag = 0;NA_cmeDirectflag=0;
        }

        if (EUFlow != null)
        {
            //EU_Booking_Flag=1;
            
            if (EUFlow.indexOf('Algos/Strategies') != -1)
            {EU_Algos_Flag = 1;}
            else
            {EU_Algos_Flag = 0;}
            
            if (EUFlow.indexOf('Broker Dealer') != -1)
            {EU_BD_Flag = 1;}
            else
            {EU_BD_Flag = 0;}
            
             if (EUFlow.indexOf('CME Direct') != -1)
            {EU_cmeDirectflag = 1;}
            else
            {EU_cmeDirectflag = 0;}
            
            if(NA_BD_Flag == 1 || NA_BDB_Flag == 1 || EU_BD_Flag == 1)
            {NA_BD_Whole_Section = 1;}
            else
            {NA_BD_Whole_Section = 0;}
            
            /*if (EUFlow.indexOf('Booking') != -1)
            {EU_Booking_Flag=1;}
            else
            {EU_Booking_Flag=0;}*/

            if (EUFlow.indexOf('DMA/SORT') != -1)
            {EU_DMA_Flag = 1;}
            else
            {EU_DMA_Flag = 0;}

            if (EUFlow.indexOf('FIX to FX') != -1)
            {EU_FX_Flag = 1;}
            else
            {EU_FX_Flag = 0;}

            if (EUFlow.indexOf('FIX to PassportWin') != -1)
            {EU_Passport_Flag = 1;}
            else
            {EU_Passport_Flag = 0;}

            if (EUFlow.indexOf('FIX to RSP') != -1)
            {EU_RSP_Flag = 1;}
            else
            {EU_RSP_Flag = 0;}

            if (EUFlow.indexOf('GTC/GTD') != -1)
            {EU_GTC_GTD_Flag  = 1;}
            else
            {EU_GTC_GTD_Flag  = 0;}
            
            if (EUFlow.indexOf('IOI') != -1)
            {EU_IOI_Flag = 1;}
            else
            {EU_IOI_Flag = 0;}

            if(EUFlow.indexOf('MS Port') != -1)
            {EU_MS_Port_Flag = 1;}
            else
            {EU_MS_Port_Flag = 0;}
           
            if (EUFlow.indexOf('Progs') != -1)
            {EU_Progs_Flag = 1;}
            else
            {EU_Progs_Flag = 0;}

            if (EUFlow.indexOf('Sales Desk/BI') != -1)
            {EU_SalesDeskBI_Flag = 1;}
            else
            {EU_SalesDeskBI_Flag = 0;}
                        
            if (EUFlow.indexOf('Speedway') != -1)
            {EU_Speedway_Flag = 1;}
            else
            {EU_Speedway_Flag =0;}
            
            if(EUFlow.indexOf('Sponsored') != -1)
            {EU_Sponsored_Flag =1;}
            else
            {EU_Sponsored_Flag =0;}
            
            if(EUFlow.indexOf('Soft Dollar') != -1)
            {EU_Soft_Dollar_Flag = 1;}
            else
            {EU_Soft_Dollar_Flag = 0;}

            if(EUFlow.indexOf('Migration for CCA/CSA') != -1)
            {EU_CCA_CSA_Soft_Dollar_Flag = 1;}
            else
            {EU_CCA_CSA_Soft_Dollar_Flag = 0;}
            
        }
        else
        {
            EU_DMA_Flag = 0; EU_Algos_Flag = 0;EU_BD_Flag = 0;
            EU_SalesDeskBI_Flag = 0; EU_Progs_Flag = 0;
            EU_Passport_Flag = 0; EU_IOI_Flag = 0;
            EU_FX_Flag = 0; EU_Speedway_Flag = 0;
            EU_Sponsored_Flag = 0; EU_MS_Port_Flag = 0;
            EU_RSP_Flag = 0; EU_GTC_GTD_Flag = 0;
            EU_Soft_Dollar_Flag = 0; EU_CCA_CSA_Soft_Dollar_Flag = 0;EU_cmeDirectflag=0;
            //EU_Booking_Flag=0;
        }

        if (APFlow != null)
        {
            
            if (APFlow.indexOf('Algo White Label') != -1)
            {AP_Algos_white_Flag = 1;}
            else
            {AP_Algos_white_Flag = 0;}
            
             if (APFlow.indexOf('CME Direct') != -1)
            {AP_cmeDirectflag = 1;}
            else
            {AP_cmeDirectflag = 0;}
            
            if (APFlow.indexOf('Algos/Strategies') != -1)
            {AP_Algos_Flag = 1;}
            else
            {AP_Algos_Flag = 0;}

            if (APFlow.indexOf('DMA/SORT') != -1)
            {AP_DMA_Flag = 1;}
            else
            {AP_DMA_Flag = 0;}

            if (APFlow.indexOf('FIX to FX') != -1)
            {AP_FX_Flag = 1;}
            else
            {AP_FX_Flag = 0;}

            if (APFlow.indexOf('FIX to PassportWin') != -1)
            {AP_Passport_Flag = 1;}
            else
            {AP_Passport_Flag = 0;}

            if (APFlow.indexOf('IOI') != -1)
            {AP_IOI_Flag = 1;}
            else
            {AP_IOI_Flag = 0;}

            if(APFlow.indexOf('MS Port') != -1)
            {AP_MS_Port_Flag = 1;}
            else
            {AP_MS_Port_Flag = 0;}

            if (APFlow.indexOf('Pairs') != -1)
            {AP_Pairs_Flag = 1;}
            else
            {AP_Pairs_Flag = 0;}

            if (APFlow.indexOf('Progs') != -1)
            {AP_Progs_Flag = 1;}
            else
            {AP_Progs_Flag = 0;}

            if (APFlow.indexOf('Sales Desk/BI') != -1)
            {AP_SalesDeskBI_Flag = 1;}
            else
            {AP_SalesDeskBI_Flag = 0;}
            
            if (APFlow.indexOf('Speedway') != -1)
            {AP_Speedway_Flag = 1;}
            else
            {AP_Speedway_Flag =0;}
            
            if(APFlow.indexOf('Sponsored') != -1)
            {AP_Sponsored_Flag =1;}
            else
            {AP_Sponsored_Flag =0;}
            
            if(APFlow.indexOf('Soft Dollar') != -1)
            {AP_Soft_Dollar_Flag = 1;}
            else
            {AP_Soft_Dollar_Flag = 0;}

            if(APFlow.indexOf('Migration for CCA/CSA') != -1)
            {AP_CCA_CSA_Soft_Dollar_Flag = 1;}
            else
            {AP_CCA_CSA_Soft_Dollar_Flag = 0;}

        }
        else
        {
            AP_DMA_Flag = 0; AP_Algos_Flag = 0;
            AP_SalesDeskBI_Flag = 0; AP_Progs_Flag = 0;
            AP_Pairs_Flag = 0; AP_Speedway_Flag =0;
            AP_Passport_Flag = 0; AP_IOI_Flag = 0;
            AP_FX_Flag = 0; AP_Sponsored_Flag = 0;
            AP_MS_Port_Flag = 0; AP_MS_Port_Flag = 0;
            AP_Soft_Dollar_Flag = 0; AP_CCA_CSA_Soft_Dollar_Flag = 0;AP_cmeDirectflag=0;
        }

        calcMarketsSectionDisplayFlags();
        calcLimitsSectionFlags();
        calcCommissionSectionDisplayFlag();
        
        if(NA_cmeDirectflag == 1||EU_cmeDirectflag == 1||AP_cmeDirectflag == 1){
            cmeDirectflag=1;
        }else{cmeDirectflag=0;}

        if(USOptDisplayFlag == 1||USFutDisplayFlag == 1||
        JapanEquityLimitsFlag == 1||IndiaEquityLimitsFlag == 1||AsiaEquityLimitsFlag == 1||TaiwanEquityLimitsFlag == 1||KoreaEquityLimitsFlag == 1||BrokerEquityLimitsFlag == 1||
        JapanFuturesLimitsFlag == 1||IndiaFuturesLimitsFlag == 1||AsiaFuturesLimitsFlag == 1||TaiwanFuturesLimitsFlag == 1||KoreaFuturesLimitsFlag == 1||BrokerFuturesLimitsFlag == 1||
        JapanOptionsLimitsFlag == 1||IndiaOptionsLimitsFlag == 1||AsiaOptionsLimitsFlag == 1||TaiwanOptionsLimitsFlag == 1||KoreaOptionsLimitsFlag == 1||BrokerOptionsLimitsFlag == 1
        || ChinaEquityLimitFlag==1  || SIEquityLimitsFlag == 1 || AUEquityLimitsFlag == 1
        || HKEquityLimitsFlag == 1  || SIOptionsLimitsFlag == 1 || AUOptionsLimitsFlag == 1 || HKOptionsLimitsFlag == 1
        || SIFuturesLimitsFlag == 1 || HKFuturesLimitsFlag == 1 || AUFuturesLimitsFlag == 1 || AP_Algos_white_Flag == 1 || 
        ChinaASCEquityLimitsFlag == 1
        )
        
        {LimitsSectionDisplayFlag=1;}
        else
        {LimitsSectionDisplayFlag=0;}

        calcDMASectionDisplayFlag();
        calcSalesDeskBIDisplayFlag();
        calcProgsSectionDisplayFlag();
        calcPassportSectionDisplayFlag();
        calcIOISectionDisplayFlag();
        //calcAsiaDerivSectionFlags();  //calcAsiaIndividualSectionFlags();
        calcFXDisplayFlags();
        assignNetworkConnectivityWhilePageLoad();
        
        if (euprodrequest.Set_up_type__c == 'FIX Certification' || euprodrequest.Set_up_type__c == 'Decommission')
        {resetSectionFlags();}
        if((AP_DMA_Flag == 1 || AP_Algos_Flag == 1) && euprodrequest.Asset_Class__c != null && euprodrequest.Asset_Class__c.indexOf('Equity Swaps') != -1)
        {Asia_Equity_Swaps_Flag = 1;}
        else{Asia_Equity_Swaps_Flag = 0;}
        
        // for R09101828
        calcBrazilSection();
        
        //  REQ1309832
        calcCME(); 
        
        calcCrossPointFlag();
       // calcSORTPassiveModel();//kumvina REQ5143234 04March2016 
        
        calcDarkPoolCheckedFlag();  
        calcHksfc();
        
        calcEULimitFlag();
        calcNALimitFlag();  
        calcEstdbFlag();
        
        calcEquitySwapsMarkets();

       calcIppanJapanFlag();
       // calcOutSourceFlag();
        return null;
    }
    
    public Integer getNA_RETAIL_Flag()
    {
      return NA_RETAIL_Flag;
    }
    
    // start, for R09101828    
    public Pagereference calcBrazilSection(){
      if(euprodrequest.Asset_Class__c != null && 
      euprodrequest.Asset_Class__c.indexOf('Equity') != -1 &&
      //euprodrequest.Asset_Class__c == 'Equity' &&
      euprodrequest.Latin_America_Markets__c !=null && 
      euprodrequest.Latin_America_Markets__c.indexOf('Brazil') != -1 &&
      euprodrequest.North_America_Flow_Details__c !=null &&
      euprodrequest.North_America_Flow_Details__c.indexOf('Latam') != -1
      )
        {
         String[] part;
         part = (String.valueOf(euprodrequest.Asset_Class__c)).split(';',0);
           for(String z:part)
           {
              if(z=='Equity')
              {
                  BrazilAccountDisplayFlag = 1;
                  break;
                }
           }
        }
        else
            {
              BrazilAccountDisplayFlag = 0;
            }
      
        return null;
    }
// end, for R09101828  
    
    public Pagereference calcLimitsSectionDisplayFlagWithIntegrator(){

        
        if((euprodrequest.North_America_Flow_Details__c!=null)&&(euprodrequest.North_America_Flow_Details__c.indexOf('CME Direct')!= -1 )){

        
        euprodrequest.deliverToCompIDs__c='TZZ';
        euprodrequest.targetCompIDs__c='OGBGKDN';
        euprodrequest.SenderCompID__c='CME';


        }
        
      calcLimitsSectionDisplayFlag();
      changeintegratorvalue(); ////REQ5739138; kumvina 04July2016
      autoIntegratorAssignment();
      autoCoverageAssignment();
      calcAccount();// R09171623      
       calcIppanMarginFlag(); // R09171650
       calcCME();
       
       calcCrossPointFlag();
       calcEnableAlfMsalFlag();//himanb REQ5311922, REQ5354316 & REQ5311942 11Apr2016
       calcSORTPassiveModel();//kumvina REQ5143234 04March2016 
       calcNoCloseFlag(); // kumvina REQ5391910 29Apr2016
       
       calcDarkPoolCheckedFlag();
       calcHksfc();
       
        calcEULimitFlag();
        calcNALimitFlag();  
       calcEstdbFlag();
       
       calcEquitySwapsMarkets();
       
       calcIppanJapanFlag();
         calcOutSourceFlag();
         enableBIDS();
         
      return null;
    }
    
    public integer bidsflag=0;
    
    public integer getBidsflag(){
    
        return bidsflag;
    }
    
    public void enableBIDS(){
    
        if((euprodrequest.North_America_Flow_Details__c!=null)&&(euprodrequest.North_America_Flow_Details__c.indexOf('Algos/Strategies')!= -1 )){

        
            bidsflag=1;
        }else{

        
            bidsflag=0;


        }
        
    }
    
    
    public void changeintegratorvalue(){
    
            if((euprodrequest.North_America_Flow_Details__c!=null)&&(euprodrequest.North_America_Flow_Details__c.indexOf('Modify Default Price Band')!= -1 )){
                        if(euprodrequest.integrator__c!=null){
                            if(!(euprodrequest.integrator__c.contains('mset-risk'))){
                            euprodrequest.integrator__c = euprodrequest.integrator__c+';'+'mset-risk';
                              // euprodrequest.integrator__c = euprodrequest.integrator__c;
                               system.debug('***mset-risk****'+euprodrequest.integrator__c);
                            }
                        }else{
                            if((euprodrequest.North_America_Flow_Details__c!=null)&&(euprodrequest.North_America_Flow_Details__c.indexOf('Modify Default Price Band')!= -1 )){
                            euprodrequest.integrator__c = 'mset-risk';}}
                            
                     /* if(euprodrequest.Integrator__c.contains('Unassigned_NA')|| euprodrequest.Integrator__c.contains('Unassigned_EU')|| euprodrequest.Integrator__c.contains('Unassigned_FE')){
                        String str = euprodrequest.Integrator__c;
                        if(str != null)
                                if(str.indexOf('Unassigned_NA') != -1 ){    
                                    str = str.remove('Unassigned_NA');}
                                if(str.indexOf('Unassigned_EU') != -1 ){    
                                    str = str.remove('Unassigned_EU');}
                                if(str.indexOf('Unassigned_FE') != -1 ){    
                                    str = str.remove('Unassigned_FE');}
                        //euprodrequest.Integrator__c = str;
                      }     */     
                            
            }else{
                    String str = euprodrequest.Integrator__c;
                    if(str != null && str.indexOf('mset-risk') != -1)
                    str = str.remove('mset-risk');
                    euprodrequest.Integrator__c = str;
                }
    
    }
    
    public void autoCoverageAssignment() {
      string AP_Flow = '', NA_Flow = '', EU_Flow = '';
         AP_Flow = euprodrequest.Asia_Pacific_Flow_Details__c;
         NA_Flow = euprodrequest.North_America_Flow_Details__c;
         EU_Flow = euprodrequest.Europe_Flow_Details__c;
      
      system.debug('**3720***'+NA_Flow);
      if(NA_Flow != null && NA_Flow != ''){
         //gupankur, 28Sep 2015, REQ4441102, start - Ankur Gupta
         if(NA_Flow.indexOf('Algos/Strategies')!= -1 || NA_Flow.indexOf('BIDS/Trading')!= -1 || NA_Flow.indexOf('CME Direct')!=-1 || NA_Flow.indexOf('Broker Dealer')!= -1 || NA_Flow.indexOf('Speedway')!= -1 || NA_Flow.indexOf('DMA/SORT')!= -1 || NA_Flow.indexOf('FIX to PassportWin')!= -1 || NA_Flow.indexOf('GTC/GTD')!= -1 || NA_Flow.indexOf('MS Port')!= -1 || NA_Flow.indexOf('Pairs')!= -1 || NA_Flow.indexOf('Network Change Only')!= -1 || NA_Flow.indexOf('Retail')!= -1 || NA_Flow.indexOf('Latam')!= -1 || NA_Flow.indexOf('Sponsered Futures')!= -1)
         //gupankur, 28Sep 2015, REQ4441102, end - Ankur Gupta
         {NA_Coverage_Flag = 1;}
         else{ 
                NA_Coverage_Flag = 0;


            }
        
      }
      else
      { 
          NA_Coverage_Flag = 0;
         
      }

      if(EU_Flow != null && EU_Flow != ''){
        //himanb REQ5338630 2-apr-2016 , added speedway to show coverage person
         if(EU_Flow.indexOf('Algos/Strategies')!= -1 || EU_Flow.indexOf('BIDS/Trading')!= -1 || EU_Flow.indexOf('CME Direct')!=-1 || EU_Flow.indexOf('Broker Dealer')!= -1 || EU_Flow.indexOf('DMA/SORT')!= -1 || EU_Flow.indexOf('FIX to PassportWin')!= -1 || EU_Flow.indexOf('GTC/GTD')!= -1 || EU_Flow.indexOf('MS Port')!= -1 || EU_Flow.indexOf('Pairs')!= -1 || EU_Flow.indexOf('Network Change Only')!= -1 || EU_Flow.indexOf('Retail')!= -1 || EU_Flow.indexOf('Latam')!= -1 || EU_Flow.indexOf('Sponsered Futures')!= -1 || EU_Flow.indexOf('Speedway')!= -1)
         {EU_Coverage_Person_Flag = 1;}
         else { 
          EU_Coverage_Person_Flag = 0;}
          
      }
      else
      { 
          EU_Coverage_Person_Flag = 0;
         
      }

      if(AP_Flow != null && AP_Flow != ''){
        //himanb REQ5338630 2-apr-2016 , added speedway to show coverage person
         if(AP_Flow.indexOf('Algo White Label')!= -1 || AP_Flow.indexOf('Algos/Strategies')!= -1 || AP_Flow.indexOf('CME Direct')!=-1 ||AP_Flow.indexOf('BIDS/Trading')!= -1 || AP_Flow.indexOf('Broker Dealer')!= -1 || AP_Flow.indexOf('DMA/SORT')!= -1 || AP_Flow.indexOf('FIX to PassportWin')!= -1 || AP_Flow.indexOf('GTC/GTD')!= -1 || AP_Flow.indexOf('MS Port')!= -1 || AP_Flow.indexOf('Pairs')!= -1 || AP_Flow.indexOf('Network Change Only')!= -1 || AP_Flow.indexOf('Retail')!= -1 || AP_Flow.indexOf('Latam')!= -1 || AP_Flow.indexOf('Sponsered Futures')!= -1 || AP_Flow.indexOf('Speedway')!= -1)
         {AP_Coverage_Person_Flag = 1;}
         else{ 
            AP_Coverage_Person_Flag = 0;

             }
      }
      else
      { 
          AP_Coverage_Person_Flag = 0;
         
      }
      
    } 
    public void autoIntegratorforEu(){
    
    
    
    }   
    public void autoIntegratorAssignment() {
         String clnflg = getParam('clnflg');
         
         
        
      if((euprodrequest.name == null || euprodrequest.name == '' || clnflg=='1')&& (euprodrequest.Integrator__c == null || euprodrequest.Integrator__c == '' || euprodrequest.Integrator__c == 'Unassigned_NA' || euprodrequest.Integrator__c == 'Unassigned_EU'
       || euprodrequest.Integrator__c == 'Unassigned_FE' || euprodrequest.Integrator__c == 'Unassigned_FE;Unassigned_NA' || euprodrequest.Integrator__c == 'Unassigned_EU;Unassigned_FE' ||euprodrequest.Integrator__c == 'Unassigned_EU;Unassigned_XX')){
       string AP_Flow = '', NA_Flow = '', EU_Flow = '';
         AP_Flow = euprodrequest.Asia_Pacific_Flow_Details__c;
         NA_Flow = euprodrequest.North_America_Flow_Details__c;
         EU_Flow = euprodrequest.Europe_Flow_Details__c;
        Integer AP_Flow_Flag = 0, NA_Flow_Flag = 0, EU_Flow_Flag = 0;
          if(AP_Flow != null && AP_Flow != ''){AP_Flow_Flag = 1;}
          if(NA_Flow != null && NA_Flow != ''){NA_Flow_Flag = 1;}
          if(EU_Flow != null && EU_Flow != ''){EU_Flow_Flag = 1;}
           
       if(NA_Progs_Flag == 1 || EU_Progs_Flag == 1 || AP_Progs_Flag == 1){
          if(userId.Region__c == 'North America'){euprodrequest.Integrator__c = 'Unassigned_NA';}
          else if (userId.Region__c == 'Europe'){euprodrequest.Integrator__c = 'Unassigned_EU';}
          else if (userId.Region__c == 'Asia'){euprodrequest.Integrator__c = 'Unassigned_FE';}
         
       }
       else{
          if(AP_Flow_Flag == 1){
           if(NA_Flow_Flag == 1 || EU_Flow_Flag == 1){
              if(userId.Region__c == 'North America'){euprodrequest.Integrator__c = 'Unassigned_NA;Unassigned_FE';}
              else if (userId.Region__c == 'Europe'){euprodrequest.Integrator__c = 'Unassigned_EU;Unassigned_FE';}
              else if (userId.Region__c == 'Asia'){
                if(NA_Flow_Flag == 1 && EU_Flow_Flag == 0){euprodrequest.Integrator__c = 'Unassigned_NA;Unassigned_FE';}
                else if(EU_Flow_Flag == 1){euprodrequest.Integrator__c = 'Unassigned_EU;Unassigned_FE';}
              }
           }
           else{euprodrequest.Integrator__c = 'Unassigned_FE';}
           
            }
          else{
             if(euprodrequest.Asia_Pacific_Flow_Details__c ==null && euprodrequest.Asia_Pacific_Flow_Details__c==''){String str = euprodrequest.Integrator__c;
                                 if(str != null && str.contains('Unassigned_FE')){
                                    str = str.remove('Unassigned_FE');}
                               euprodrequest.Integrator__c = str;}
           if(NA_Flow_Flag == 1 || EU_Flow_Flag == 1){
              if(userId.Region__c == 'North America'){euprodrequest.Integrator__c = 'Unassigned_NA';}
              else if (userId.Region__c == 'Europe'){euprodrequest.Integrator__c = 'Unassigned_EU';}
              else if (userId.Region__c == 'Asia'){
               if(NA_Flow_Flag == 1 && EU_Flow_Flag == 0){euprodrequest.Integrator__c = 'Unassigned_NA';}
               else if (EU_Flow_Flag == 1){euprodrequest.Integrator__c = 'Unassigned_EU';}
              }
           }
          }
          if(euprodrequest.Asia_Pacific_Flow_Details__c ==null || euprodrequest.Asia_Pacific_Flow_Details__c==''){
            String str = euprodrequest.Integrator__c;
                                 if(str != null && str.contains('Unassigned_FE')){
                                    str = str.remove('Unassigned_FE');}
                               euprodrequest.Integrator__c = str;}
          
         }
        
         
        // start REQ5901564 kumvin 6Nov2016
                system.debug('xxxxxxxx:'+euprodrequest.Integrator__c);
               if(euprodrequest.EU_Coverage_Person__c!=null && euprodrequest.EU_Coverage_Person__c!=''){
                        if(euprodrequest.EU_Coverage_Person__c.contains(Label.EUProductRequest_email7)){
                            if(euprodrequest.Integrator__c!=null){
                                if(!euprodrequest.Integrator__c.contains('Unassigned_XX')){
                                    euprodrequest.Integrator__c = euprodrequest.Integrator__c+';Unassigned_XX;';

                                }
                                else if(!euprodrequest.Integrator__c.contains('Unassigned_EU')){
                                    euprodrequest.Integrator__c = euprodrequest.Integrator__c+';Unassigned_EU;';

                                }/*else {
                                    euprodrequest.Integrator__c = euprodrequest.Integrator__c+'Unassigned_EU;Unassigned_XX;';

                                }*/
                                system.debug('xxxxxxxx:'+euprodrequest.Integrator__c);


                                
                            }else{
                                    euprodrequest.Integrator__c = 'Unassigned_EU;Unassigned_XX';

                            }
                        }else{
                            String str = euprodrequest.Integrator__c;
                                 if(str != null && str.indexOf('Unassigned_XX') != -1)
                                    str = str.remove('Unassigned_XX');
                               euprodrequest.Integrator__c = str;
                            }
                        } 
               //end  REQ5901564 kumvin 6Nov2016
      }
        /*08-mar-2018 code comment start--MSET-675
      if(euprodrequest.Asia_Pacific_Flow_Details__c ==null || euprodrequest.Asia_Pacific_Flow_Details__c==''){
            String str = euprodrequest.Integrator__c;
                                 if(str != null && str.contains('Unassigned_FE')){
                                    str = str.remove('Unassigned_FE');}
                               euprodrequest.Integrator__c = str;}
      //08-mar-2018 comment close */
     
      //himanb REQ5291267 18-Apr-2016
         if(euprodrequest.IntegratorSet__c == false)
         {
         integratorValueForUser();
         }
    }
    
    public PageReference assignBBFrontEnd() {
       if (euprodrequest.OMS_Vendor__c != null && euprodrequest.Status__c != null) {
           Oms_Vendor__c omsvendor = [select name from OMS_Vendor__c where Id = :euprodrequest.OMS_Vendor__c limit 1 ];
           if ((omsvendor.name == 'Bloomberg' || omsvendor.name == 'Bloomberg EMSX') && (euprodrequest.Status__c == 'Waiting Deployment' || euprodrequest.Status__c == 'Complete')) {
              BBFrontEndDisplayFlag = 1;
           }
           else {
               BBFrontEndDisplayFlag = 0;
           }
           if(euprodrequest.BB_ON_BEHALF_OF__c != null){
              BBFrontEndDisplayViewFlag = 1;
           }else{
              BBFrontEndDisplayViewFlag = 0;
           }
       }
       return null;
    }
    
    public Integer getNA_BD_Flag() {
        return NA_BD_Flag;
    }
    
     public Integer getEU_BD_Flag() {
        return EU_BD_Flag;
    }
    
    /*
    public Integer getEUEquityDisplayFlagLimit() {
        return EUEquityDisplayFlagLimit;
    }
    */
    
     //public Integer getEU_Booking_Flag() {
      //  return EU_Booking_Flag;
    //}
    
    public Integer getNA_BDB_Flag() {
        return NA_BDB_Flag;
    }
    
    public Integer getNA_BD_Whole_Section() {
        return NA_BD_Whole_Section;
    }
    
    public Integer getAll_Region_CCA_CSA_Soft_Dollar_Flag(){
        return All_Region_CCA_CSA_Soft_Dollar_Flag;
    }
    
    public Integer getAll_Region_Soft_Dollar_Flag(){
        return All_Region_Soft_Dollar_Flag;
    }
    
    public Integer getAsia_Equity_Swaps_Flag() {
        return Asia_Equity_Swaps_Flag;
    }
    
     // start, // for R09101828 
    public Integer getBrazilAccountDisplayFlag() {
        return BrazilAccountDisplayFlag;
    }
    //  end
    
    public Integer getNA_LA_Flag() {
        return NA_LA_Flag;
    }

    public Integer getLimitsSectionDisplayFlag() {
        return LimitsSectionDisplayFlag;
    }

    Integer Market_Section_Flag = 0;
    public PageReference calcMarketsSectionDisplayFlags() {

        if (APFlow != null && APFlow != '')
        {AP_Markets_Flag = 1;
            if(APFlow == 'FIX to FX')
            {
                AP_Markets_Flag = 0;    
            }   
        ASIASectionFlag = 1;
        }
        else
        {AP_Markets_Flag = 0;
        ASIASectionFlag = 0;}
        
        if((NA_Soft_Dollar_Flag ==1 || EU_Soft_Dollar_Flag == 1 || AP_Soft_Dollar_Flag == 1))
        {All_Region_Soft_Dollar_Flag = 1;}
        else
        {All_Region_Soft_Dollar_Flag = 0;}
        
        if((NA_CCA_CSA_Soft_Dollar_Flag ==1 || EU_CCA_CSA_Soft_Dollar_Flag == 1 || AP_CCA_CSA_Soft_Dollar_Flag == 1))
        {All_Region_CCA_CSA_Soft_Dollar_Flag = 1;}
        else
        {All_Region_CCA_CSA_Soft_Dollar_Flag = 0;}
        
        if((APFlow != null && APFlow != '') || (NA_LA_Flag == 1))
        { Market_Section_Flag = 1; 
            if(APFlow == 'FIX to FX' && NA_LA_Flag == 0)
            {
                Market_Section_Flag = 0;    
            }
        
        }
        else
        { Market_Section_Flag = 0; }
        
        //Start: Added patch for JPA flag when Japan is selected in Asia Market Section
        String APMktList = euprodrequest.Asia_Pacific_Markets__c;
        if (AP_Markets_Flag == 1 && Market_Section_Flag == 1 &&  ASIASectionFlag == 1) {
            if (APMktList != null && APMktList.indexOf('Japan') != -1)
            {JPPoolCrossing = 1; //euprodrequest.Pool_Crossing__c = true;
            }
          else
            {JPPoolCrossing = 0;}
        }
        //End: Added patch for JPA flag when Japan is selected
        //if (ASIASectionFlag == 1 && JapanComm == 1)
        //{JPPoolCrossing = 1;}
        return null;
    }

    public Integer getAP_Markets_Flag() {
        return AP_Markets_Flag;
    }

    public Integer getMarket_Section_Flag() {
        return Market_Section_Flag;
    }

    public PageReference calcCommissionSectionDisplayFlag() {
        string regions;

         string AP_Flow = '';
         AP_Flow = euprodrequest.Asia_Pacific_Flow_Details__c;

         string APMktList = '';
         APMktList = euprodrequest.Asia_Pacific_Markets__c;

         if (AP_Flow == null) {APMktList = null;}
         if ((APMktList != null) && (AP_Flow != null))
         {
            if (APMktList.indexOf('India') != -1)
            {IndiaComm = 1;IndiaAccount=1;}
            else
            {IndiaComm = 0;IndiaAccount=0;}

            if (APMktList.indexOf('Korea') != -1)
            {KoreaComm = 1;}
            else
            {KoreaComm = 0;}

            if (APMktList.indexOf('Taiwan') != -1)
            {TaiwanComm = 1;}
            else
            {TaiwanComm = 0;}

            if (APMktList.indexOf('Japan') != -1)
            {JapanComm = 1;}
            else
            {JapanComm = 0;}

            if (APMktList.indexOf('HK/SI/AU') != -1)
            {AsiaCoreComm = 1;}
            else
            {AsiaCoreComm = 0;}
            
            if (APMktList.indexOf('Indonesia') != -1)
            {IndonesiaComm = 1;}
            else
            {IndonesiaComm = 0;}
            
            if (APMktList.indexOf('Malaysia') != -1)
            {MalaysiaComm = 1;}
            else
            {MalaysiaComm = 0;}
            
            if (APMktList.indexOf('Thailand') != -1)
            {ThailandComm = 1;}
            else
            {ThailandComm = 0;}
         }
         else
         {
             IndiaComm = 0;KoreaComm = 0;
             TaiwanComm = 0;JapanComm = 0;
             AsiaCoreComm = 0;IndonesiaComm = 0;
             MalaysiaComm = 0;ThailandComm = 0;
             IndiaAccount=0;
         }
         //MktList = '';
         if ((IndiaComm == 1)||(KoreaComm == 1)||(JapanComm == 1)||(TaiwanComm == 1)||(AsiaCoreComm == 1))
         {CommissionSectionDisplayFlag = 1;}
         else
         {CommissionSectionDisplayFlag = 0;}
         
        calcAsiaDerivSectionFlags();
        return null;
    }

    public Integer getFXSectionDisplayFlag() {
        return FXSectionDisplayFlag;
    }

    public Integer getCommissionSectionDisplayFlag() {
        return CommissionSectionDisplayFlag;
    }

    public Integer getASIASectionFlag() {
        return ASIASectionFlag;
    }

    public Integer getRegion_JP_Flag() {
        return Region_JP_Flag;
    }

    public Integer getRegion_AP_Flag() {
        return Region_AP_Flag;
    }

    public Integer getEUEquityDisplayFlag() {
        return EUEquityDisplayFlag;
    }

    public Integer getEUFutDisplayFlag() {
        return EUFutDisplayFlag;
    }

    public Integer getEUOptDisplayFlag() {
        return EUOptDisplayFlag;
    }

    public Integer getUSEquityDisplayFlag() {
        return USEquityDisplayFlag;
    }
    
    public Integer getCmeDirectflag() {
        return cmeDirectflag;
    }
    
    public Integer getNA_Coverage_Flag() {
        return NA_Coverage_Flag;
    }
    
    public Integer getEU_Coverage_Person_Flag() {
        return EU_Coverage_Person_Flag;
    }
 
    public Integer getAP_Coverage_Person_Flag() {
        return AP_Coverage_Person_Flag;
    }
    public Integer getUSFutDisplayFlag() {
        return USFutDisplayFlag;
    }

    public Integer getUSOptDisplayFlag() {
        return USOptDisplayFlag;
    }

    public Integer getIndiaComm() {
        return IndiaComm;
    }
    public Integer getIndiaAccount() {
        return IndiaAccount;
    }
    public Integer getKoreaComm() {
        return KoreaComm;
    }

    public Integer getTaiwanComm() {
        return TaiwanComm;
    }

    public Integer getJapanComm() {
        return JapanComm;
    }

    public Integer getAsiaCoreComm() {
        return AsiaCoreComm;
    }
    
    public Integer getIndonesiaComm() {
        return IndonesiaComm;
    }
    
    public Integer getMalaysiaComm() {
        return MalaysiaComm;
    }
    
    public Integer getThailandComm() {
        return ThailandComm;
    }

    public PageReference calcBloomberSetupDisplayFlag() {
     //   system.debug('THIS IS BEING EXECUTED');
        euprodrequest.OMS_Vendor__c=selectedOmsVendor;
 
        if (BloomberSetupDisplayFlag == 0){
            BloomberSetupDisplayFlag = 1;
        } else {
            BloomberSetupDisplayFlag = 0;
        }
        return null;
    }

//String NetworkConnSectionLabel = 'Bloomberg User IDs';
String NetworkFieldLabel = 'UUID/UserNumber/Name';

    public PageReference assignNetworkConnectivity() {
      assignBBFrontEnd();
    //  calcAddAnotherFlag();
        //if (euprodrequest.OMS_Vendor__c == 'a0cT00000009YjaIAE')
        //euprodrequest.Network_Connectivity__c = 'a0bT0000000G9BZIA0';
       Oms_Vendor__c lomsvendor;
       Oms_Vendor__c lomsvendor_Lookup;
       if (euprodrequest.OMS_Vendor__c != null)
       {
           lomsvendor = [select Network_Connectivity_Lookup__c, name from OMS_Vendor__c where Id = :euprodrequest.OMS_Vendor__c limit 1 ];
           if (lomsvendor.Network_Connectivity_Lookup__c != null) {
               euprodrequest.Network_Connectivity__c = lomsvendor.Network_Connectivity_Lookup__c;
           }else{
                if((lomsvendor.name !='Passport') && (lomsvendor.name !='Fidelity Service Bureau') && (lomsvendor.name !='Citadel Tech (CTECH)')){
                    List<Network_Connectivity_Lookup__c> obj3 = [select id,name from Network_Connectivity_Lookup__c where name='Unknown'];
                    euprodrequest.Network_Connectivity__c = obj3[0].id;
                }
           }
          //NetworkConnSectionLabel =  lomsvendor.name + ' User IDs';
           if (lomsvendor.name == 'Bloomberg')
           {NetworkFieldLabel = 'UUID/UserNumber/Name';
           }
           else
           {NetworkFieldLabel = 'Sender Sub ID/On behalf of Sub ID';
           }

           if (lomsvendor.name == '--None--')
           {BloombergSectionDisplayFlag = 0;}
           else
           {BloombergSectionDisplayFlag = 1;}
           
           if (euprodrequest.Set_up_type__c == 'FIX Certification' && (!(lomsvendor.name == 'Passport') && !(lomsvendor.name == 'Passport Express') && !(lomsvendor.name == 'Other')))
           {Screen_Signed_Off_Flag = 1;}
           else
           {Screen_Signed_Off_Flag = 0;}
           
           //singhrak, 9March 2015, REQ3455449, start
           OMS_Vendor__c obj = [select name from OMS_Vendor__c where Id = :euprodrequest.OMS_Vendor__c];
           if(obj.name == 'Passport')
           {
            Network_Connectivity_Lookup__c obj2 = [select id,name from Network_Connectivity_Lookup__c where name='Passport'];
            euprodrequest.Network_Connectivity__c = obj2.Id;
           }
            //singhrak, 9March 2015, REQ3455449, end
           
           //singhrak, 29Apr2015, REQ3744837, start
           if(obj.name == 'Fidelity Service Bureau')
           {
            Network_Connectivity_Lookup__c obj2 = [select id,name from Network_Connectivity_Lookup__c where name='Fidelity Service Bureau'];
            euprodrequest.Network_Connectivity__c = obj2.Id;
            
            if(euprodrequest.name == null)
                euprodrequest.Comments__c = 'Please set up drop copy session and enable cancel on disconnect functionality.';
           }
            //singhrak, 29Apr2015, REQ3744837, end 
           
            //singhrak, 19June2015, REQ3978024, start
           if(obj.name == 'Citadel Tech (CTECH)')
           {
            Network_Connectivity_Lookup__c obj2 = [select id,name from Network_Connectivity_Lookup__c where name='Citadel Tech (CTECH)'];
            euprodrequest.Network_Connectivity__c = obj2.Id;
           }
           //singhrak, 19June2015, REQ3978024, End
           
           
       }
       //euprodrequest.Network_Connectivity__c = euprodrequest.OMS_Vendor__r.Network_Connectivity_Lookup__r.Id;
       if (euprodrequest.OMS_Vendor_Lookup__c != null){ //REQ5613760 kumvina 07June2016 start
       
            lomsvendor_Lookup = [select Network_Connectivity_Lookup__c, name from OMS_Vendor__c where Id = :euprodrequest.OMS_Vendor_Lookup__c limit 1 ];
           if (lomsvendor_Lookup.Network_Connectivity_Lookup__c != null) {
                    euprodrequest.Network_Connectivity_Lookup__c = lomsvendor_Lookup.Network_Connectivity_Lookup__c;
            }else{
                if((lomsvendor_Lookup.name !='Passport') && (lomsvendor_Lookup.name !='Fidelity Service Bureau') && (lomsvendor_Lookup.name !='Citadel Tech (CTECH)')){
                    Network_Connectivity_Lookup__c obj3 = [select id,name from Network_Connectivity_Lookup__c where name='Unknown'or name='--None--'];
                    euprodrequest.Network_Connectivity_Lookup__c = obj3.id;
                }
           }
            if(lomsvendor_Lookup.name == 'Passport')
           {
            Network_Connectivity_Lookup__c obj2 = [select id,name from Network_Connectivity_Lookup__c where name='Passport'];
            euprodrequest.Network_Connectivity_Lookup__c = obj2.Id;
           }
           
           if(lomsvendor_Lookup.name == 'Citadel Tech (CTECH)')
           {
            Network_Connectivity_Lookup__c obj3 = [select id,name from Network_Connectivity_Lookup__c where name='Citadel Tech (CTECH)'];
            euprodrequest.Network_Connectivity_Lookup__c = obj3.Id;
           }
           if(lomsvendor_Lookup.name == 'Fidelity Service Bureau')
           {
            Network_Connectivity_Lookup__c obj4 = [select id,name from Network_Connectivity_Lookup__c where name='Fidelity Service Bureau'];
            euprodrequest.Network_Connectivity_Lookup__c = obj4.Id;
           }
       }//REQ5613760 kumvina 07June2016 end

     return null;
    }
    
    public PageReference assignNetworkConnectivityWhilePageLoad() {
      assignBBFrontEnd();
    
       List<Oms_Vendor__c> lomsvendor;
       if (euprodrequest.OMS_Vendor__c != null)
       {
           lomsvendor = [select Network_Connectivity_Lookup__c, name from OMS_Vendor__c where Id = :euprodrequest.OMS_Vendor__c limit 1 ];
           
           //NetworkConnSectionLabel =  lomsvendor.name + ' User IDs';
           if (lomsvendor.size()>0 && lomsvendor[0].name == 'Bloomberg')
           {NetworkFieldLabel = 'UUID/UserNumber/Name';
           }
           else
           {NetworkFieldLabel = 'Sender Sub ID/On behalf of Sub ID';
           }

           if (lomsvendor.size()>0 && lomsvendor[0].name == '--None--')
           {BloombergSectionDisplayFlag = 0;}
           else
           {BloombergSectionDisplayFlag = 1;}
           
           if (lomsvendor.size()>0 && euprodrequest.Set_up_type__c == 'FIX Certification' && (!(lomsvendor[0].name == 'Passport') && !(lomsvendor[0].name == 'Passport Express') && !(lomsvendor[0].name == 'Other')))
           {Screen_Signed_Off_Flag = 1;}
           else
           {Screen_Signed_Off_Flag = 0;}
           
       }
     return null;
    }

    public Integer getBloomberSetupDisplayFlag() {
        return BloomberSetupDisplayFlag;
    }

    public String getNetworkFieldLabel() {
        return NetworkFieldLabel;
    }

    public String getomsvendor() {
        return omsvendor;
    }

    public String selectedOmsVendor;

    public String getselectedOmsVendor(){
        //selectedOmsVendor=eupd.OMS_Vendor__c;
        return selectedOmsVendor;
    }

    public void setselectedOmsVendor(string selectedOmsVendor){
        this.selectedOmsVendor=selectedOmsVendor;
    }

    public List<SelectOption> OmsVendorList;
    public List<SelectOption> getOmsVendors() {
     if (OmsVendorList == null) {
          List<OMS_Vendor__c> omsvends = [select id,name from OMS_Vendor__c order by name];
              OmsVendorList = new List<SelectOption>();
              OmsVendorList.add(new SelectOption('--None--','--None--'));
              for (OMS_Vendor__c u : omsvends) {

                
                if((u.name!='Citadel Tech (CTECH)')&&(u.name!='ESP')&&(u.name!='Mixit')&&(u.name!='Pipeline')&&(u.name!='Radical'))
                        OmsVendorList.add(new SelectOption(u.id, u.name));
           }
    }
     return OmsVendorList;
    }

// The below code is the populate network connectivity select list

    public String getnetworkconnectivity() {
        return networkconnectivity;
    }

    public String selectedNetworkConnectivity;

    public String getselectedNetworkConnectivity(){
        //selectedOmsVendor=eupd.OMS_Vendor__c;
        return selectedNetworkConnectivity;
    }

    public void setselectedNetworkConnectivity(string selectedNetworkConnectivity){
        this.selectedNetworkConnectivity=selectedNetworkConnectivity;
    }
    
    //public String select
    public List<SelectOption> NetworkConnectivityList;
    public List<SelectOption> getNetworkConnectivities() {  /*REQ5613760 kumvina 07June2016 start*/
     if (NetworkConnectivityList == null) {
          List<Network_Connectivity_Lookup__c> netconnect = [select id,name from Network_Connectivity_Lookup__c where id<>'a0W60000000DpE5'order by name];
         String noneId,noneName;
            for(Network_Connectivity_Lookup__c nConnect:netconnect){
                    if(nConnect.name=='--None--'||nConnect.name=='Unknown'){
                        noneId=nConnect.id;
                        noneName=nConnect.Name;
                    }   
            }
               NetworkConnectivityList = new List<SelectOption>();
               if(noneId!=null)
               NetworkConnectivityList.add(new SelectOption(noneId,'Unknown'));//REQ5613760 kumvina 07June2016
              for (Network_Connectivity_Lookup__c u : netconnect) {
                     if(u.name!='Unknown' && u.name!='--None--'){            //REQ5613760 kumvina 07June2016
                            if((u.name!='Citadel Tech (CTECH)')&&(u.name!='ESP')&&(u.name!='Bridge IOE')&&(u.name!='ULLink'))
                                NetworkConnectivityList.add(new SelectOption(u.id, u.name));
                     }
           }
    }
    
     return NetworkConnectivityList;

    }

    /* public string nameChange(string strNetwork){
     
     if(strNetwork=='NYFIX'){
        strNetwork='NYFIX / ULLink';
     }
     if(strNetwork=='REUTERS'){
        strNetwork='Autex / Reuters';
     }
     
        return strNetwork;
     }*/
    public PageReference calcLimitsSectionFlags()
    {

        string AssetClass_list = '';
        AssetClass_list = euprodrequest.Asset_Class__c;
        if (AssetClass_list != null && AssetClass_list.length() <= 0)
        { AssetClass_list = 'nothing';}

        if (AssetClass_list == null)
        { AssetClass_list = 'nothing';}

        string NA_Flow = '';
        NA_Flow = euprodrequest.North_America_Flow_Details__c;

        string EU_Flow = '';
        EU_Flow = euprodrequest.Europe_Flow_Details__c;

//These flags are for showing limits section.

        if ((AssetClass_list != 'nothing') && (EU_Flow != null))
        {
            if ((EU_DMA_Flag == 1 || EU_Algos_Flag == 1 || EU_Speedway_Flag == 1 || EU_Sponsored_Flag == 1) && ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
            {
              EUEquityDisplayFlag = 1;
            } else {
              EUEquityDisplayFlag = 0;
            }

            if ((EU_DMA_Flag == 1 || EU_Algos_Flag == 1 || EU_Speedway_Flag == 1 || EU_Sponsored_Flag == 1) && ((AssetClass_list.indexOf('Options')!= -1)))
            {
              EUOptDisplayFlag = 1;
            } else {
              EUOptDisplayFlag = 0;
            }

            if ((EU_DMA_Flag == 1 || EU_Algos_Flag == 1 || EU_Speedway_Flag == 1 || EU_Sponsored_Flag == 1) && ((AssetClass_list.indexOf('Futures')!= -1)))
            {
              EUFutDisplayFlag = 1;
            } else {
              EUFutDisplayFlag = 0;
            }
            /*
             if ( euprodrequest.Europe_Flow_Details__c !=null  && ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1) || 
             AssetClass_list.indexOf('Index/Sector Swaps')!= -1))            
            {
              EUEquityDisplayFlagLimit = 1;
            } else {
              EUEquityDisplayFlagLimit = 0;
            }
            */
        }
        else
        {
             EUEquityDisplayFlag = 0;EUOptDisplayFlag = 0;
             EUFutDisplayFlag = 0; 
             //EUEquityDisplayFlagLimit = 0;
        }

        if ((AssetClass_list != 'nothing') && (NA_Flow != null))
        {
            // Set Flags for US
            if ((NA_DMA_Flag == 1 || NA_BIDS_Trading_Flag == 1 || NA_Algos_Flag == 1 || NA_Passport_Flag == 1 || NA_RETAIL_Flag == 1 || NA_BD_Flag == 1 || NA_BDB_Flag == 1 || NA_Speedway_Flag == 1 || NA_Sponsored_Flag == 1) && ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)||(AssetClass_list.indexOf('Index/Sector Swaps')!= -1)))
            {
              USEquityDisplayFlag = 1;
            } else {
              USEquityDisplayFlag = 0;
            }

            if ((NA_DMA_Flag == 1 || NA_BIDS_Trading_Flag == 1 || NA_Algos_Flag == 1 || NA_Passport_Flag == 1 || NA_RETAIL_Flag == 1 || NA_BD_Flag == 1 || NA_BDB_Flag == 1 || NA_Speedway_Flag == 1 || NA_Sponsored_Flag == 1) && ((AssetClass_list.indexOf('Options')!= -1)))
            {
              USOptDisplayFlag = 1;
            } else {
              USOptDisplayFlag = 0;
            }

            if ((NA_DMA_Flag == 1 || NA_BIDS_Trading_Flag == 1 || NA_Algos_Flag == 1 || NA_Passport_Flag == 1 || NA_RETAIL_Flag == 1 || NA_BD_Flag == 1 || NA_BDB_Flag == 1 || NA_Speedway_Flag == 1 || NA_Sponsored_Flag == 1) && ((AssetClass_list.indexOf('Futures')!= -1)))
            {
              USFutDisplayFlag = 1;
            } else {
              USFutDisplayFlag = 0;
            }
            
            if ((NA_DMA_Flag == 1 )&& (AssetClass_list.indexOf('Equity')!= -1))
            {
              MSPoolCrossing = 1;
            } else {
              MSPoolCrossing = 0;
            }
            
            if ((NA_Algos_Flag == 1 )&& (AssetClass_list.indexOf('Equity')!= -1))
            {
              CloseAuction = 1;
            } else {
              CloseAuction = 0;
            }
            
         }
         else
         {
             USEquityDisplayFlag = 0; USOptDisplayFlag = 0;
             USFutDisplayFlag = 0; MSPoolCrossing = 0; CloseAuction = 0;
         }
            calcAsiaLimitsSectionFlags();
        //resetSectionFlags();
    return null;
    }

    public PageReference calcAsiaLimitsSectionFlags()
    {
        string AssetClass_list = '';
        AssetClass_list = euprodrequest.Asset_Class__c;
        if (AssetClass_list != null && AssetClass_list.length() <= 0)
        { AssetClass_list = 'nothing';}

        if (AssetClass_list == null)
        { AssetClass_list = 'nothing';}

         string APMkts ='';
         APMkts =  euprodrequest.Asia_Pacific_Markets__c;

         if (APMkts == null)
         {
             APMkts='nothing';
         }

         string AP_Flow = '';
         AP_Flow = euprodrequest.Asia_Pacific_Flow_Details__c;

         if ((APMkts != 'nothing') && (AssetClass_list != 'nothing') && (AP_Flow != null) && (AP_DMA_Flag == 1 || AP_Algos_Flag == 1 || AP_Passport_Flag == 1 || AP_Algos_white_Flag == 1))
         {
             if((APMkts.indexOf('Japan')!= -1) &&  ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
             {JapanEquityLimitsFlag = 1;}
             else
             {JapanEquityLimitsFlag = 0;}

             if((APMkts.indexOf('India')!= -1) &&  ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
             {IndiaEquityLimitsFlag = 1;}
             else
             {IndiaEquityLimitsFlag = 0;}

             if((APMkts.indexOf('NJA Core(HK/SI/AU)')!= -1) &&  ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
             {AsiaEquityLimitsFlag = 1;}
             else
             {AsiaEquityLimitsFlag = 0;}
        
            HKEquityLimitsFlag = 0;
             SIEquityLimitsFlag = 0;
             AUEquityLimitsFlag = 0;
             
             AUFuturesLimitsFlag = 0;
             SIFuturesLimitsFlag = 0;
             HKFuturesLimitsFlag = 0;
             
             HKOptionsLimitsFlag = 0;
             SIOptionsLimitsFlag = 0;
             AUOptionsLimitsFlag = 0;
             ChinaASCEquityLimitsFlag = 0;             
             
              String[] part = APMkts.split(';');
              for(String value:part)
              {
      // Equity
      
                if(value=='China A(Stock Connect)')
                {
                 if(value=='China A(Stock Connect)' && (AssetClass_list.indexOf('Equity Swaps')!= -1 || AssetClass_list.indexOf('Equity')!= -1))
                 {ChinaASCEquityLimitsFlag = 1;}
                }
      
      
                if(value=='HK')
                {
                 if(value=='HK' && (AssetClass_list.indexOf('Equity Swaps')!= -1 || AssetClass_list.indexOf('Equity')!= -1))
                 {HKEquityLimitsFlag = 1;}
                }
             
                 if(value == 'SI')
                  {
                  if(value == 'SI' &&  (AssetClass_list.indexOf('Equity Swaps')!= -1 || AssetClass_list.indexOf('Equity')!= -1))
                 {SIEquityLimitsFlag = 1;}
                  }
                  
                    if(value=='AU')
                  {
                if(value=='AU' &&  (AssetClass_list.indexOf('Equity Swaps')!= -1 ||AssetClass_list.indexOf('Equity')!= -1))
                 {AUEquityLimitsFlag = 1;}
                  }
        // Futures
                if(value=='HK')
                {
                 if(value=='HK' && (AssetClass_list.indexOf('Futures')!= -1))
                 {HKFuturesLimitsFlag = 1;}
                }
             
                 if(value == 'SI')
                  {
                  if(value == 'SI' &&  (AssetClass_list.indexOf('Futures')!= -1))
                 {SIFuturesLimitsFlag = 1;}
                  }
                  
                    if(value=='AU')
                  {
                if(value=='AU' &&  (AssetClass_list.indexOf('Futures')!= -1))
                 {AUFuturesLimitsFlag = 1;}
                  }                  
             
         // Options    
               if(value=='HK')
                {
                 if(value=='HK' && (AssetClass_list.indexOf('Options')!= -1))
                 {HKOptionsLimitsFlag = 1;}
                }
             
                 if(value == 'SI')
                  {
                  if(value == 'SI' &&  (AssetClass_list.indexOf('Options')!= -1))
                 {SIOptionsLimitsFlag = 1;}
                  }
                  
                    if(value=='AU')
                  {
                if(value=='AU' &&  (AssetClass_list.indexOf('Options')!= -1))
                 {AUOptionsLimitsFlag = 1;}
                  }
             
            
            if(value=='China A(QFII)' || value=='China B')
                  {
                if((value=='China A(QFII)' || value=='China B') &&  (AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1))
                 {ChinaEquityLimitFlag  = 1;}
                  }
             
              }
              
              
                      

/*
             if((APMkts.indexOf('China A')!= -1 || APMkts.indexOf('China B')!= -1) &&  ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
             {ChinaEquityLimitFlag = 1;}
             else
             {ChinaEquityLimitFlag = 0;}
  */           

             if((APMkts.indexOf('Taiwan')!= -1) &&  ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
             {TaiwanEquityLimitsFlag = 1;}
             else
             {TaiwanEquityLimitsFlag = 0;}

             if((APMkts.indexOf('Korea')!= -1) &&  ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
             {KoreaEquityLimitsFlag = 1;}
             else
             {KoreaEquityLimitsFlag = 0;}
             
             if(((APMkts.indexOf('Indonesia')!= -1) || APMkts.indexOf('New Zealand')!= -1 || (APMkts.indexOf('Philippines')!= -1) || (APMkts.indexOf('Malaysia')!= -1) || (APMkts.indexOf('Thailand')!= -1)) &&  ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
             {BrokerEquityLimitsFlag = 1;}
             else
             {BrokerEquityLimitsFlag = 0;}

    // Futures Flags

             if((APMkts.indexOf('Japan')!= -1) &&  ((AssetClass_list.indexOf('Futures')!= -1)))
             {JapanFuturesLimitsFlag = 1;}
             else
             {JapanFuturesLimitsFlag = 0;}

             if((APMkts.indexOf('India')!= -1) &&  ((AssetClass_list.indexOf('Futures')!= -1)))
             {IndiaFuturesLimitsFlag = 1;}
             else
             {IndiaFuturesLimitsFlag = 0;}

             if((APMkts.indexOf('NJA Core(HK/SI/AU)')!= -1) &&  ((AssetClass_list.indexOf('Futures')!= -1)))
             {AsiaFuturesLimitsFlag = 1;}
             else
             {AsiaFuturesLimitsFlag = 0;}

             if((APMkts.indexOf('Taiwan')!= -1) &&  ((AssetClass_list.indexOf('Futures')!= -1)))
             {TaiwanFuturesLimitsFlag = 1;}
             else
             {TaiwanFuturesLimitsFlag = 0;}

             if((APMkts.indexOf('Korea')!= -1) &&  ((AssetClass_list.indexOf('Futures')!= -1)))
             {KoreaFuturesLimitsFlag = 1;}
             else
             {KoreaFuturesLimitsFlag = 0;}
             
             if(((APMkts.indexOf('Indonesia')!= -1) || (APMkts.indexOf('Malaysia')!= -1) || (APMkts.indexOf('Thailand')!= -1)) && ((AssetClass_list.indexOf('Futures')!= -1)))
             {BrokerFuturesLimitsFlag = 1;}
             else
             {BrokerFuturesLimitsFlag = 0;}
             
    // Options Flags

             if((APMkts.indexOf('Japan')!= -1) &&  ((AssetClass_list.indexOf('Options')!= -1)))
             {JapanOptionsLimitsFlag = 1;}
             else
             {JapanOptionsLimitsFlag = 0;}

             if((APMkts.indexOf('India')!= -1) &&  ((AssetClass_list.indexOf('Options')!= -1)))
             {IndiaOptionsLimitsFlag = 1;}
             else
             {IndiaOptionsLimitsFlag = 0;}

             if((APMkts.indexOf('NJA Core(HK/SI/AU)')!= -1) &&  ((AssetClass_list.indexOf('Options')!= -1)))
             {AsiaOptionsLimitsFlag = 1;}
             else
             {AsiaOptionsLimitsFlag = 0;}

             if((APMkts.indexOf('Taiwan')!= -1) &&  ((AssetClass_list.indexOf('Options')!= -1)))
             {TaiwanOptionsLimitsFlag = 1;}
             else
             {TaiwanOptionsLimitsFlag = 0;}

             if((APMkts.indexOf('Korea')!= -1) &&  ((AssetClass_list.indexOf('Options')!= -1)))
             {KoreaOptionsLimitsFlag = 1;}
             else
             {KoreaOptionsLimitsFlag = 0;}
             
             if(((APMkts.indexOf('Indonesia')!= -1) || (APMkts.indexOf('Malaysia')!= -1) || (APMkts.indexOf('Thailand')!= -1)) && ((AssetClass_list.indexOf('Options')!= -1)))
             {BrokerOptionsLimitsFlag = 1;}
             else
             {BrokerOptionsLimitsFlag = 0;}

         }
         else
         {
            KoreaFuturesLimitsFlag = 0;TaiwanFuturesLimitsFlag = 0;
            AsiaFuturesLimitsFlag = 0;IndiaFuturesLimitsFlag = 0;
            JapanFuturesLimitsFlag = 0;KoreaEquityLimitsFlag = 0;
            TaiwanEquityLimitsFlag = 0;AsiaEquityLimitsFlag = 0;
            IndiaEquityLimitsFlag = 0;JapanEquityLimitsFlag = 0;
            BrokerEquityLimitsFlag = 0;BrokerFuturesLimitsFlag = 0;
            JapanOptionsLimitsFlag =0; IndiaOptionsLimitsFlag =0; 
            AsiaOptionsLimitsFlag =0;TaiwanOptionsLimitsFlag =0;
            KoreaOptionsLimitsFlag =0; BrokerOptionsLimitsFlag =0;
            ChinaEquityLimitFlag = 0;
            
            SIEquityLimitsFlag = 0;
            AUEquityLimitsFlag = 0; HKEquityLimitsFlag =0;
            SIOptionsLimitsFlag = 0;
            AUOptionsLimitsFlag = 0 ; HKOptionsLimitsFlag = 0;
            SIFuturesLimitsFlag = 0 ; HKFuturesLimitsFlag = 0;
            AUFuturesLimitsFlag = 0;ChinaASCEquityLimitsFlag = 0;
         }

        //resetSectionFlags();

         return null;
    }

    public PageReference calcDMASectionDisplayFlag()
    {
          if(this.AP_DMA_Flag == 1 || this.EU_DMA_Flag == 1) {
          this.DMASectionDisplayFlag = 1;
        } else {
          this.DMASectionDisplayFlag = 0;}
        
          if(this.AP_DMA_Flag == 1 && this.JPPoolCrossing == 1) {
            this.JPSortDestFlag = 1;
          } else {
            this.JPSortDestFlag = 0;}

        if (EU_DMA_Flag == 1) {
            DMAEUSectionDisplayFlag=1;
        } else {
            DMAEUSectionDisplayFlag=0;}
        
        if(this.JPSortDestFlag == 0 && this.DMAEUSectionDisplayFlag == 0) {
            this.DMASectionDisplayFlag = 0;
        }
        return null;
    }

    public Integer getDMASectionDisplayFlag() {
        return DMASectionDisplayFlag;
    }

    public Integer getDMAEUSectionDisplayFlag() {
        return DMAEUSectionDisplayFlag;
    }

    public Integer getJPSortDestFlag() {
          return JPSortDestFlag;
    } 
    
    public PageReference calcSalesDeskBIDisplayFlag()
    {
        if (NA_SalesDeskBI_Flag == 1 || EU_SalesDeskBI_Flag == 1 || AP_SalesDeskBI_Flag == 1)
        {SalesDeskBISectionDisplayFlag=1;}
        else
        {SalesDeskBISectionDisplayFlag=0;}
        
        
        
        return null;
    }

    public Integer getSalesDeskBISectionDisplayFlag() {
        return SalesDeskBISectionDisplayFlag;
    }
    
     public Integer getEU_SalesDeskBI_Flag() {
        return EU_SalesDeskBI_Flag;
    }

    public PageReference calcProgsSectionDisplayFlag()
    {
        if (NA_Progs_Flag == 1 || EU_Progs_Flag == 1 || AP_Progs_Flag == 1)
        {ProgsSectionDisplayFlag=1;}
        else
        {ProgsSectionDisplayFlag=0;}
        return null;
    }

    public PageReference calcFXDisplayFlags()
    {
        if (NA_FX_Flag == 1 || EU_FX_Flag == 1 || AP_FX_Flag == 1)
        {FXSectionDisplayFlag=1;}
        else
        {FXSectionDisplayFlag=0;}
        return null;
    }

    public Integer getProgsSectionDisplayFlag() {
        return ProgsSectionDisplayFlag;
    }

    public PageReference calcPassportSectionDisplayFlag()
    {
        if (NA_Passport_Flag == 1 || EU_Passport_Flag == 1 || AP_Passport_Flag == 1 )
        {PassportSectionDisplayFlag=1;}
        else
        {PassportSectionDisplayFlag=0;}
        return null;
    }

    public Integer getPassportSectionDisplayFlag() {
        return PassportSectionDisplayFlag;
    }

    public PageReference calcIOISectionDisplayFlag()
    {
        if (NA_IOI_Flag == 1 || EU_IOI_Flag == 1 || AP_IOI_Flag == 1)
        {IOISectionDisplayFlag=1;}
        else
        {IOISectionDisplayFlag=0;}
        return null;
    }

    Integer AsiaDerivSectionFlag = 0, AsiaCashSectionFlag = 0;

    public PageReference calcAsiaDerivSectionFlags()
    {
        string APMkts ='';
        APMkts =  euprodrequest.Asia_Pacific_Markets__c;

        if (APMkts == null)
        {APMkts='nothing';}

        string AssetClass_list = '';
        AssetClass_list = euprodrequest.Asset_Class__c;
        if (AssetClass_list != null && AssetClass_list.length() <= 0)
        { AssetClass_list = 'nothing';}

        if (AssetClass_list == null)
        { AssetClass_list = 'nothing';}

        String AP_Flow = euprodrequest.Asia_Pacific_Flow_details__c;

        if (AP_Flow != null)
        {

            if (AP_DMA_Flag == 1 && APMkts.indexOf('Japan')!= -1 && (AssetClass_list.indexOf('Futures')!= -1 || AssetClass_list.indexOf('Options')!= -1))
            {JP_DMA_FUT_OPT_Flag = 1;}
            else
            {JP_DMA_FUT_OPT_Flag = 0;}

            if (AP_SalesDeskBI_Flag == 1 && APMkts.indexOf('Japan')!= -1 && (AssetClass_list.indexOf('Futures')!= -1 || AssetClass_list.indexOf('Options')!= -1))
            {JP_BI_FUT_OPT_Flag = 1;}
            else
            {JP_BI_FUT_OPT_Flag = 0;}

            if (AP_DMA_Flag == 1 && APMkts.indexOf('HK/SI/AU')!= -1 && (AssetClass_list.indexOf('Futures')!= -1 || AssetClass_list.indexOf('Options')!= -1))
            {NJA_DMA_FUT_OPT_Flag = 1;}
            else
            {NJA_DMA_FUT_OPT_Flag = 0;}

            if (AP_SalesDeskBI_Flag == 1 && APMkts.indexOf('HK/SI/AU')!= -1 && (AssetClass_list.indexOf('Futures')!= -1 || AssetClass_list.indexOf('Options')!= -1))
            {NJA_BI_FUT_OPT_Flag = 1;}
            else
            {NJA_BI_FUT_OPT_Flag = 0;}

            if (APMkts.indexOf('HK/SI/AU')!= -1 && (AssetClass_list.indexOf('Futures')!= -1 || AssetClass_list.indexOf('Options')!= -1))
            {MS_Clr_Acc_SG_AX_Flag = 1;
                if(euprodrequest.MS_Clearing_Account_SG_AX__c == null || euprodrequest.MS_Clearing_Account_SG_AX__c == '') {
                    //euprodrequest.MS_Clearing_Account_SG_AX__c = 'MSIL Agency/Customer-002009330/902';
                }
            }
            else
            {MS_Clr_Acc_SG_AX_Flag = 0;}

            if (ASIASectionFlag == 1 && (AssetClass_list.indexOf('Futures')!= -1 || AssetClass_list.indexOf('Options')!= -1))
            {AsiaDerivSectionFlag = 1;}
            else
            {AsiaDerivSectionFlag = 0;}

            if (ASIASectionFlag == 1 && ((AssetClass_list.indexOf('Equity Swaps')!= -1)||(AssetClass_list.indexOf('Equity')!= -1)))
            {AsiaCashSectionFlag = 1;}
            else
            {AsiaCashSectionFlag = 0;}

            if ((APMkts.indexOf('Korea')!= -1))
            {KRInvestorIdFlag = 1;}
            else
            {KRInvestorIdFlag = 0;}

            if (APMkts.indexOf('India')!= -1)
            {INInvestorIdFlag = 1;}
            else
            {INInvestorIdFlag = 0;}

            if (APMkts.indexOf('Taiwan')!= -1)
            {TWInvestorIdFlag = 1;}
            else
            {TWInvestorIdFlag = 0;}

            if ((AsiaCashSectionFlag == 1) && (KRInvestorIdFlag == 1 || INInvestorIdFlag == 1 || TWInvestorIdFlag == 1)) {
              AsiaDMACashSectionDisplayFlag = 1;
              if(euprodrequest.KR_Trading_Approach__c == null || euprodrequest.KR_Trading_Approach__c == '') {
                 euprodrequest.KR_Trading_Approach__c = 'Non-Omnibus';
              }
              if(euprodrequest.TW_Trading_Approach__c == null || euprodrequest.TW_Trading_Approach__c == '') {
                 euprodrequest.TW_Trading_Approach__c = 'Non-Omnibus';
              }
            }
            else
            {AsiaDMACashSectionDisplayFlag = 0;}
        }
        else
        {
            JP_DMA_FUT_OPT_Flag = 0; JP_BI_FUT_OPT_Flag = 0;
            NJA_DMA_FUT_OPT_Flag = 0; NJA_BI_FUT_OPT_Flag = 0;
            MS_Clr_Acc_SG_AX_Flag = 0;AsiaDerivSectionFlag = 0;
            AsiaCashSectionFlag = 0;KRInvestorIdFlag = 0;
            TWInvestorIdFlag = 0; INInvestorIdFlag = 0;
            AsiaDMACashSectionDisplayFlag = 0;
        }
        //calcAsiaIndividualSectionFlags();
        return null;
    }

    public Integer getIOISectionDisplayFlag() {
        return IOISectionDisplayFlag;
    }

    public Integer getJapanEquityLimitsFlag() {
        return JapanEquityLimitsFlag;
    }

    public Integer getIndiaEquityLimitsFlag() {
        return IndiaEquityLimitsFlag;
    }

    public Integer getAsiaEquityLimitsFlag() {
        return AsiaEquityLimitsFlag;
    }

    public Integer getTaiwanEquityLimitsFlag() {
        return TaiwanEquityLimitsFlag;
    }

    public Integer getKoreaEquityLimitsFlag() {
        return KoreaEquityLimitsFlag;
    }
    
    public Integer getBrokerEquityLimitsFlag() {
        return BrokerEquityLimitsFlag;
    }

    public Integer getJapanFuturesLimitsFlag() {
        return JapanFuturesLimitsFlag;
    }

    public Integer getIndiaFuturesLimitsFlag() {
        return IndiaFuturesLimitsFlag;
    }

    public Integer getAsiaFuturesLimitsFlag() {
        return AsiaFuturesLimitsFlag;
    }

    public Integer getTaiwanFuturesLimitsFlag() {
        return TaiwanFuturesLimitsFlag;
    }

    public Integer getKoreaFuturesLimitsFlag() {
        return KoreaFuturesLimitsFlag;
    }
    
    public Integer getBrokerFuturesLimitsFlag() {
        return BrokerFuturesLimitsFlag;
    }
    
    public Integer getJapanOptionsLimitsFlag() {
        return JapanOptionsLimitsFlag;
    }

    public Integer getIndiaOptionsLimitsFlag() {
        return IndiaOptionsLimitsFlag;
    }

    public Integer getAsiaOptionsLimitsFlag() {
        return AsiaOptionsLimitsFlag;
    }

    public Integer getTaiwanOptionsLimitsFlag() {
        return TaiwanOptionsLimitsFlag;
    }

    public Integer getKoreaOptionsLimitsFlag() {
        return KoreaOptionsLimitsFlag;
    }

    public Integer getBrokerOptionsLimitsFlag() {
        return BrokerOptionsLimitsFlag;
    }

    public Integer getJP_DMA_FUT_OPT_Flag() {
        return JP_DMA_FUT_OPT_Flag;
    }

    public Integer getJP_BI_FUT_OPT_Flag() {
        return JP_BI_FUT_OPT_Flag;
    }

    public Integer getNJA_DMA_FUT_OPT_Flag() {
        return NJA_DMA_FUT_OPT_Flag;
    }

    public Integer getNJA_BI_FUT_OPT_Flag() {
        return NJA_BI_FUT_OPT_Flag;
    }

    public Integer getMS_Clr_Acc_SG_AX_Flag() {
        return MS_Clr_Acc_SG_AX_Flag;
    }

    public Integer getAsiaCashSectionFlag() {
        return AsiaCashSectionFlag;
    }

    public Integer getAsiaDerivSectionFlag () {
        return AsiaDerivSectionFlag;
    }

    public Integer getBloombergSectionDisplayFlag () {
        return BloombergSectionDisplayFlag;
    }

    public Integer getTWInvestorIdFlag () {
        return TWInvestorIdFlag;
    }

    public Integer getKRInvestorIdFlag () {
        return KRInvestorIdFlag;
    }

    public Integer getINInvestorIdFlag () {
        return INInvestorIdFlag;
    }

    public Pagereference refreshpagesections() {
        calcLimitsSectionDisplayFlag();
        assignBBFrontEnd();
        return null;
    }
    
    public String statusOld;
    public String getStatusOld()
    {
    return statusOld;
    }
    
    public Pagereference refreshpagesectionsWithTargetDate() {
     
       refreshpagesections();
      integratorValueForUser();//     kumvina, REQ5084643,15feb2016
      
      return null;
    }
        
    public Integer getAsiaDMACashSectionDisplayFlag() {
        return AsiaDMACashSectionDisplayFlag;
    }

    public String getPageTitle() {
        return PageTitle;
    }

    public String getCreatedBy() {
        return CreatedBy;
    }

    public String getLastModifiedBy() {
        return LastModifiedBy;
    }

    public Integer getJPPoolCrossing() {
        return JPPoolCrossing;
    }
    
    public Integer getMSPoolCrossing() {
        return MSPoolCrossing;
    }
    
    public Integer getCloseAuction() {
        return CloseAuction;
    }

    public Integer getAP_SalesDeskBI_Flag() {
        return AP_SalesDeskBI_Flag;
    }

    public Integer getVendorDisplayFlag() {
        return VendorDisplayFlag;
    }
    
    public Integer getMiFID2Preference(){
        return MiFID2Preference;
    }

    public Integer ChinaEquityLimitFlag = 0;
    public Integer getChinaEquityLimitFlag()
    {
      return ChinaEquityLimitFlag;
    }
    
    
    public Boolean getRequired(){
        if(euprodrequest.Set_up_type__c == 'New Client Setup' || euprodrequest.Set_up_type__c == 'Client TNL Change')
         return TRUE;
        else
         return FALSE;
    }

 /*   public EU_ProductRequest__c getRequests()
    {
        list<EU_ProductRequest__c> ed = new list<EU_ProductRequest__c>(0);
        if(euprodrequest.Id!=null){
            
            ed = [Select RequestedBy__c from EU_ProductRequest__c where Id=:euprodrequest.Id];
        }
        return ed[0]; 
    }*/
    
    
    public EU_ProductRequest__c getRequests()
    {
        EU_ProductRequest__c elist= new EU_ProductRequest__c();

        try{
            list<EU_ProductRequest__c> ed = new list<EU_ProductRequest__c>(0);
            if(euprodrequest.Id!=null){


                ed = [Select RequestedBy__c from EU_ProductRequest__c where Id=:euprodrequest.Id];

            }
            if(ed.size() > 0){
                elist=ed[0];
            }else{elist=null;}
        }catch(exception e){
         system.debug(e);


        }
        return elist; 
    }
    

    public EU_ProductRequest__c editRequest { get; set; }
    
    public String UUID { get; set; }

    public PageReference saveEdit() {
        try {
            editRequest = null;
            save();
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }

    public PageReference editRequestedBy() {
        String editid = getParam('editid');
        editRequest = [SELECT RequestedBy__c FROM EU_ProductRequest__c WHERE Id=:editid];
        return null;
    }

    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }


    public void assignRequestedByFieldValue() {
         String newTicketFlag = getParam('save_new');
       String TNLRouteNewProductRequestFlag = getParam('scontrolCaching');
         //New Ticket
         if(newTicketFlag == '1' || TNLRouteNewProductRequestFlag== '1') {
                this.euprodrequest.RequestedBy__c = UserInfo.getUserId();
         }
         //Old ticket for editing
         else {
               if(this.euprodrequest.RequestedBy__c == null) {
             //User u = [select Id from User where Username = :this.euprodrequest.OwnerId];
             //this.euprodrequest.RequestedBy__c = this.euprodrequest.OwnerId;
               }
         }
    }
    
        public Integer getAdd_Another_Flag() {
        return Add_Another_Flag;
    }
    
    public void calcAddAnotherFlag(){
      if(this.euprodrequest.Add_Another__c == true){
        Add_another_Flag=1;
      }
      else{
        Add_another_Flag=0;
      }
    }
        
    public PageReference cloneAction() {
      euprodrequest.Name = null;
      
      
      
      PageReference editForm = new Apexpages.Standardcontroller(euprodrequest).edit();
      
      editForm.getParameters().put('flow', 'clone');
      editForm.getParameters().put('clnflg', '1');
      editForm.setredirect(true); 
      this.euprodrequest.Status__c = 'Submitted';
      //himanb REQ5291267 18-Apr-2016
      system.debug('***** 19 apr code clone flag'+euprodrequest.IntegratorSet__c);
      if(this.euprodrequest.IntegratorSet__c==true)
      {
        this.euprodrequest.IntegratorSet__c = false;
      }
      
      return editForm;    } 
     
     
    public PageReference cloneForm() {
        PageReference pref = null;
        try {
  
                
              this.cloneableRequestForm = this.euprodrequest;

                
             boolean pageReferenceAction = doSave(cloneableRequestForm);
            if(pageReferenceAction){
             return null;
             }
                                        
                pref = new ApexPages.StandardController(cloneableRequestForm).view();
                pref.setredirect(true);
            
        }
        catch(Exception e) {
            System.debug('General exception:'+ e.getMessage());
        }
        return pref;
    }
}