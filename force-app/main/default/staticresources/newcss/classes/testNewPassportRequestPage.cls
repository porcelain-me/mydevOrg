public class testNewPassportRequestPage {


//Refactor as uses hardcoded ids.
    static testMethod void Page_Test_1()
    { 
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
         
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'North America';
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.NA_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
               
        test_1.Allocation_Type__c = 'Post-Trade Allocated';
       
        test_1.User_1__c = 'Test';
        test_1.User_2__c = 'User2';
        test_1.Comments__c = 'example';
        test_1.Marketdata_Entitlements__c = 'NO MARKET DATA';
        
        test_1.Limits_Required_for_Asia__c='Test';
   /*      
        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true; 
        
        test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
*/
try{
        insert test_1;
}
catch(Exception c)
{
    
}

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'North America');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);        
        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getParam('00560000000nJIg'),null);
        System.assertEquals(passportrequest_extn.saveEdit(),null);
        
        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),1);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
        
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        
          System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);  
        
        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
        ////System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);   
        
         System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),0);   

   }
   
   static testMethod void Page_Test_2()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Europe';
        test_1.Status__c = 'Draft';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test;Decommission';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'Yes';
        test_1.EU_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        test_1.Allocation_Type__c = 'Pre-Trade Allocated';

        test_1.User_1__c = 'Manish Sethi';
        test_1.User_5__c = 'test';
        test_1.User_6__c = 'test';
        test_1.CFM_Limits_EU_cash__c='Zero';

        test_1.Comments__c = 'test case';
        
        test_1.Domestic_Oasys_Booking__c = 'Example';
        test_1.Single_Options_Account_Booking__c = 'Test';
        test_1.Single_Account_Booking__c = 'Test';
        test_1.Multiple_Accounts__c = 'Test';                        
        
        test_1.EU_Destinations__c = 'PPWinEUEQ_M S Sectors,Basic EU Cash Destinations,Basic EU Options Destination';
        test_1.Marketdata_Entitlements__c = 'Basic EU Cash Trader';        
        test_1.Market_Watch_Lists__c = 'European Indices (MSETEuroIndex.msln)';


        test_1.Limits_Required_for_Asia__c='Test';      
        
        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;    
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';      

        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Europe');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),1);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),1);

        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),1);
        
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
    
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
         System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
         System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
         System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
         System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
         System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
         System.assertEquals(passportrequest_extn.getEquityFlag(),0);

          System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
        
        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
        
        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
        //System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
        
            System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),0);
         
         passportrequest_extn.checkForRequestType();  
           
   }
    
   static testMethod void Page_Test_3()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'High';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Pan-Asia';
        test_1.Status__c = 'Draft';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'New Integration';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.Asia_Pacific_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        test_1.Allocation_Type__c = 'Post-Trade Allocated';
        
        test_1.User_1__c = 'Manish Sethi';
        test_1.User_3__c = 'test';
        test_1.User_4__c = 'test';

        
        test_1.Comments__c = 'test case';
        
        test_1.Regions_required_for_Derivatives__c = 'Example';
        test_1.Regions_required_for_Equity__c = 'Test';
        test_1.Regions_required_for_Equity_Swaps__c = 'Test';
        test_1.Regions_required_for_Futures_Swaps__c = 'Test';  
        
        test_1.Asia_Pacific_Markets__c = 'Japan;Korea;India;Hongkong;HK/SG/AU;Taiwan;Broker Markets;Malaysia;Thailand;Indonesia;Singapore;Australia';  
        //test_1.Asset_Class__c = 'Equity;Options;Spreads;Futures;equity swaps;futures swaps';
        test_1.Asset_Class__c = 'Equity,Options,Spreads,Futures,equity swaps,futures swaps';
              
                              
        test_1.Drop_Down__c = 'Test';
        test_1.Dropdown_accounts_for_Taiwan_Cash__c = 'Test';
        test_1.JP_Trade_Limit_Cash__c = 'Custom';
        test_1.JP_Trade_Limit_FUT__c = 'Custom';
        test_1.JP_Trade_Limit_OPT__c = 'Default';
        test_1.JP_Trade_Limit_Spread__c = 'Default';
        test_1.JP_OMSID_For_Derivatives_only__c = 'Test';
                        
        test_1.Market_Watch_Lists__c = 'European Indices (MSETEuroIndex.msln)';
        test_1.All_Asia_Market_Limit__c = 'Custom';
        
        test_1.NJA_Trade_Limit_Cash__c = 'Custom';
        test_1.NJA_Trade_Limit_FUT__c = 'Custom';
        test_1.NJA_Trade_Limit_OPT__c = 'Default';
        test_1.NJA_Trade_Limit_Spread__c = 'Default';
        
        test_1.KR_Trade_Limit_Cash__c = 'Custom';
        test_1.KR_Trade_Limit_FUT__c = 'Custom';
        test_1.KR_Trade_Linit_OPT__c = 'Default';
        test_1.KR_Trade_Limit_Spread__c = 'Default';
        
        test_1.TW_Trade_Limit_Cash__c = 'Custom';
        test_1.Tw__c = 'Custom';
        test_1.TW_Trade_Limit_OPT__c = 'Default';
        test_1.TW_Trade_Limit_Spread__c = 'Default';
        
        test_1.IN_Trade_Limit_Cash__c = 'Custom';
        test_1.IN_Trade_Limit_FUT__c = 'Custom';
        test_1.IN_Trade_Limit_OPT__c = 'Default';
        test_1.IN_trade_Limit_Spread__c = 'Default';
        test_1.Exchange_Account_for_SIMR_SFER__c = 'MSIL-Customer-002009330'; 
        test_1.Foreign_Id_KR__c = 'sample';
        test_1.Exchange_Account_KR__c = 'sample';
        
       test_1.Spreads_Markets__c = 'Test';
       test_1.Options_Markets__c = 'Test';
       test_1.Equity_Swap_Markets__c= 'Test';
       test_1.Future_Swap_Markets__c= 'Test';
       test_1.Equity_Markets__c= 'Test';
       test_1.Futures_Markets__c= 'Test';
       
         test_1.Limits_Required_for_Asia__c='Test';
         
    /*      test_1.India_FutSwap__c = true;
          test_1.Korea_FutSwap__c = true;
          test_1.Australia_Future_Swap__c = true;
        test_1.Taiwan_Future_Swap__c = true;
              
         test_1.Japan__c = true;
        test_1.HongKong__c = true;
        test_1.Singapure__c = true;
        test_1.Korea__c = true;
        test_1.India__c = true;
        test_1.Taiwan__c = true;
        test_1.Australia__c = true;
        test_1.Indonesia__c = true;
        test_1.Malaysia__c = true;
        test_1.Thailand__c = true;     
      */  
       test_1.Spreads_Australia__c='MSCO - Customer';
        test_1.Spreads_Singapore__c='MSCO - Customer';
        test_1.Options_Australia__c='MSCO - Customer';
        test_1.Options_Singapore__c='MSCO - Customer';
        test_1.Futures_Singapore__c='MSCO - Customer';
        test_1.Futures_Australia__c='MSCO - Customer';

       

        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
        
         test_1.Japan_Options__c =true ;
                    test_1.HongKong_Options__c =true ;
                    test_1.Singapore_Options__c =true ;
                    test_1.Australia_Options__c =true ;
                    test_1.Korea_Options__c =true ;
                    test_1.Taiwan_Options__c =true ;
                    test_1.India_Options__c =true;
                    test_1.Malaysia_Options__c = true;
                    
                    test_1.Japan_Spreads__c =true; 
                    test_1.HongKong_Spreads__c =true; 
                    test_1.Singapore_Spreads__c =true;
                    test_1.Australia_Spreads__c =true; 
                    test_1.Korea_Spreads__c =true; 
                    test_1.Taiwan_Spreads__c =true;
                    test_1.India_Spreads__c =true;
                    test_1.Malaysia_Spreads__c =true;
                    test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';    
        
        insert test_1; 

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Pan-Asia');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),1);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);
        System.assertEquals(passportrequest_extn.getJapanFlag(),1);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),1);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),1);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),1);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),1);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),1);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),1);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),1);
        System.assertEquals(passportrequest_extn.getThailandFlag(),1);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),1);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),1); 
        System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),1);
        
        System.assertEquals(passportrequest_extn.getEquityFlag(),1);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),1);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),1);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),1);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),1);
        System.assertEquals(passportrequest_extn.getAssetFlag(),1);
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),1);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),1);
        
        
        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),1);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
        
          
/*        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),1);
        System.assertEquals(passportrequest_extn.getSpreadsSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getSpreadsAustraliaFlag(),1);
        System.assertEquals(passportrequest_extn.getFuturesSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getFuturesAustraliaFlag(),1);
  */    
        
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
        
        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        
        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
         
   }
     
   static testMethod void Page_Test_4()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'High';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Europe';
        test_1.Status__c = 'Draft';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.Equity_Futures_EU__c='Zero';
        test_1.Fid_Futures_EU__c='Small';
        
        test_1.EU_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.Allocation_Type__c = 'Don\'t Know';
        
        test_1.User_1__c = 'Manish Sethi';
        test_1.User_3__c = 'test';
        test_1.User_4__c = 'test';
            
        test_1.EU_Destinations__c = 'Basic EU Futures Destinations';                              

        test_1.Comments__c = 'test case';
        
                
        test_1.Domestic_Oasys_Booking__c = 'Example';
        test_1.Single_Options_Account_Booking__c = 'Test';
        test_1.Single_Account_Booking__c = 'Test';
        test_1.Multiple_Accounts__c = 'Test';                        
        test_1.Index_Futures_EU__c = 'FUT_SMALL_INDEX_EU';
        test_1.COMMOD_Futures__c = 'FUT_SMALL_COMMOD';
        test_1.Fid_Futures_EU__c ='FUT_SMALL_FIXEDINC_EU';
        test_1.FX_Futures__c = 'FUT_SMALL_CCY';
        
        test_1.Marketdata_Entitlements__c = 'NO MARKET DATA';       
        test_1.Market_Watch_Lists__c = 'European Indices (MSETEuroIndex.msln)';
        test_1.Limits_Required_for_Asia__c='Test';   
        
  /*      
        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;    
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;     
*/
        
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Europe');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);
        
        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),1);
        
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
        
        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        
        
          System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
        
        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);

System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
//System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);

    System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),0);   
    
     
     
    
   }
   
   static testMethod void Page_Test_5()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Europe';
        test_1.Status__c = 'Draft';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'Yes';
        test_1.EU_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.Allocation_Type__c = 'Don\'t Know';

        test_1.User_1__c = 'Manish Sethi';
        test_1.User_5__c = 'test';
        test_1.User_6__c = 'test';
        test_1.Options_EU__c='Starter';
        test_1.Comments__c = 'test case';
        
        test_1.Marketdata_Entitlements__c = 'NO MARKET DATA';
        test_1.Domestic_Oasys_Booking__c = 'Example';
        test_1.Single_Options_Account_Booking__c = 'Test';
        test_1.Single_Account_Booking__c = 'Test';
        test_1.Multiple_Accounts__c = 'Test';      
        
        test_1.EU_Destinations__c = 'Basic EU Options Destination,PPWinEUEQ_M S Sectors,';
                                
        test_1.Market_Watch_Lists__c = 'European Indices (MSETEuroIndex.msln)';
            test_1.Limits_Required_for_Asia__c='Test';     
            
 /*       test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
*/
     
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Europe');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),1);

        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        
        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),1);
        
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        
        System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
              
        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
        ////System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);      
         
             System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),0);  
             
         
        passportrequest_extn.cloneForm();

   }

   static testMethod void Page_Test_6()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'North America';
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.NA_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.Allocation_Type__c = 'Post-Trade Allocated';
       
        test_1.User_1__c = 'Test';
        test_1.User_2__c = 'User2';
        test_1.Comments__c = 'example';
        test_1.Options_US__c = 'Starter';
        
        test_1.US_Destination__c = 'Basic US Options Trader,Basic Canada Cash Destination,Canada Futures';
        test_1.Marketdata_Entitlements__c = 'Basic US Cash Trader';
        
         test_1.Limits_Required_for_Asia__c='Test';
         
/*         test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
*/         
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'North America');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);

        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),1);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),1);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),1);
//        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getParam('00560000000nJIg'),null);
        System.assertEquals(passportrequest_extn.saveEdit(),null);
        
        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),1);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
        
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
         System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
         System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
         System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
         System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
         System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
         System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        
          System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
     
      System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
      //System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
     
         System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),0);               
    }
    
    static testMethod void Page_Test_7()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'North America';
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.Marketdata_Entitlements__c = 'Basic US Cash Trader';
        test_1.NA_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.US_Destination__c = 'Basic US Cash Trader,Basic US Futures Trader';

        test_1.Allocation_Type__c = 'Post-Trade Allocated';
       
        test_1.User_1__c = 'Test';
        test_1.User_2__c = 'User2';
        test_1.Comments__c = 'example';
        test_1.CFM_Limits_US_CASH__c='Starter';
        
         test_1.Limits_Required_for_Asia__c='Test';
         test_1.CFM_Limits_SA_Cash__c = 'Test';
    /*     
         test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
  */
  
  test_1.US_SA_Equity_Single__c = 'Test';
         test_1.US_Equity_Cum__c = 'Test';
         test_1.SA_Equity_Cum__c = 'Test';
         test_1.Futures_Account__c = 'Test';
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'North America');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);

        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),1);
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),1);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
//        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getParam('00560000000nJIg'),null);
        
       System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
       System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),1);
       System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
       
       System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
       System.assertEquals(passportrequest_extn.getAssetFlag(),0);
       System.assertEquals(passportrequest_extn.getFutureFlag(),0);
       System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
       System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
       System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
       System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
       System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
       System.assertEquals(passportrequest_extn.getEquityFlag(),0);
      
         System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
        
        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
        //System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
        
        
            System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),0);   
   }

    static testMethod void Page_Test_8()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'North America';
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';

        test_1.Marketdata_Entitlements__c = 'Basic US Futures Trader';
        test_1.NA_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.US_Destination__c = 'Basic US Cash Trader,Basic US Futures Trader,Canada Futures';

        test_1.Allocation_Type__c = 'Post-Trade Allocated';
        test_1.CFM_Limits_US_CASH__c='Starter';
        test_1.User_1__c = 'Test';
        test_1.User_2__c = 'User2';
        test_1.Comments__c = 'example';
        
//        test_1.Singapore_Options__c=true;
        
         test_1.Limits_Required_for_Asia__c='Test';
         
         test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;

test_1.CFM_Limits_SA_Cash__c = 'Test';
         
test_1.US_SA_Equity_Single__c = 'Test';
         test_1.US_Equity_Cum__c = 'Test';
         test_1.SA_Equity_Cum__c = 'Test';        
         test_1.Futures_Account__c = 'Test'; 
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'North America');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);

        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),1);
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),1);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),1);
        //System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getParam('00560000000nJIg'),null);
        System.assertEquals(passportrequest_extn.saveEdit(),null);
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        
      System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
      System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),1);
      System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
      
        System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);     
        
        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
        //System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
        
            System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),0);   
        
        passportrequest_extn.cloneForm();
        passportrequest_extn.getPageTitle();

        passportrequest_extn.refreshPage();
        passportrequest_extn.cloneAction();
        
    }
    
     static testMethod void Page_Test_9()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'High';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Pan-Asia';
        test_1.Status__c = 'Draft';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'New Integration';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        
        test_1.Allocation_Type__c = 'Post-Trade Allocated';
        test_1.Asia_Pacific_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.User_1__c = 'Manish Sethi';
        test_1.User_3__c = 'test';
        test_1.User_4__c = 'test';

        
        test_1.Comments__c = 'test case';
        
        test_1.Regions_required_for_Derivatives__c = 'Example';
        test_1.Regions_required_for_Equity__c = 'Test';
        test_1.Regions_required_for_Equity_Swaps__c = 'Test';
        test_1.Regions_required_for_Futures_Swaps__c = 'Test';  
        
        test_1.Malaysia_Trade_Limit_Cash__c='Custom';
        
              
                              
        test_1.Drop_Down__c = 'Test';
        test_1.Dropdown_accounts_for_Taiwan_Cash__c = 'Test';
        
        test_1.JP_OMSID_For_Derivatives_only__c = 'Test';
                        
        test_1.Market_Watch_Lists__c = 'European Indices (MSETEuroIndex.msln)';
        test_1.All_Asia_Market_Limit__c = 'Custom';
                                
        test_1.Asia_Pacific_Markets__c='Test';
        
        //test_1.Asset_Class__c = 'Equity;Options;Spreads;Futures;equity swaps;futures swaps';
        test_1.Asset_Class__c = 'Test';
        
        test_1.Japan__c = true;
        test_1.HongKong__c = true;
        test_1.Singapure__c = true;
        test_1.Korea__c = true;
        
        test_1.India_FutSwap__c = true;
        test_1.Korea_FutSwap__c = true;
         test_1.Australia_Future_Swap__c = true;
        test_1.Taiwan_Future_Swap__c = true;
        

        test_1.Limits_Required_for_Asia__c='Test';
        
         test_1.Spreads_Australia__c='Test';
test_1.Spreads_Singapore__c='Test';
test_1.Options_Australia__c='Test';
test_1.Options_Singapore__c='Test';
test_1.Futures_Singapore__c='Test';
test_1.Futures_Australia__c='Test';
                 
test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;    
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =false ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';    
         insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Pan-Asia');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),1);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);
        System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0); 
        System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),1);
        
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        
        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),1);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
        
        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesAustraliaFlag(),0);
       
        
        System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
        
        System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
        System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
        
        System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
        System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
        
   }
   
   static testMethod void Page_Test_10()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'High';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Pan-Asia';
        test_1.Status__c = 'Draft';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'New Integration';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.Asia_Pacific_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.Allocation_Type__c = 'Post-Trade Allocated';
        
        test_1.User_1__c = 'Manish Sethi';
        test_1.User_3__c = 'test';
        test_1.User_4__c = 'test';

        
        test_1.Comments__c = 'test case';
        
        test_1.Regions_required_for_Derivatives__c = 'Example';
        test_1.Regions_required_for_Equity__c = 'Test';
        test_1.Regions_required_for_Equity_Swaps__c = 'Test';
        test_1.Regions_required_for_Futures_Swaps__c = 'Test';  
        
        test_1.Malaysia_Trade_Limit_Cash__c='Custom';
        
              
                             
        test_1.Drop_Down__c = 'Test';
        test_1.Dropdown_accounts_for_Taiwan_Cash__c = 'Test';
        
        test_1.JP_OMSID_For_Derivatives_only__c = 'Test';
                        
        test_1.Market_Watch_Lists__c = 'European Indices (MSETEuroIndex.msln)';
        test_1.All_Asia_Market_Limit__c = 'Custom';
                                
        
        //test_1.Asset_Class__c = 'Equity;Options;Spreads;Futures;equity swaps;futures swaps';
        test_1.Asset_Class__c = 'Test';
        
        test_1.Japan__c = true;
        test_1.HongKong__c = true;
        test_1.Singapure__c = true;
        test_1.Korea__c = true;
        
        test_1.India_FutSwap__c = true;
        test_1.Korea_FutSwap__c = true;
         test_1.Australia_Future_Swap__c = true;
        test_1.Taiwan_Future_Swap__c = true;
      

           test_1.Limits_Required_for_Asia__c='Test';  
           
        test_1.Spreads_Australia__c='Test';
test_1.Spreads_Singapore__c='Test';
test_1.Options_Australia__c='Test';
test_1.Options_Singapore__c='Test';
test_1.Futures_Singapore__c='Test';
test_1.Futures_Australia__c='Test'; 
                
        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';                  
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Pan-Asia');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),1);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);
        System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
        System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),1);
        
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        
         System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),1);
         System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
         System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
         
        System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesAustraliaFlag(),0);
         
         System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
         
         System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
         System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
         System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
         
         
         System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
         
         
   }
   
   static testMethod void Page_Test_11()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'High';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'North America';
        test_1.Status__c = 'Complete';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'New Integration';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.NA_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.Allocation_Type__c = '';
        test_1.FX_Futures__c = 'FUT_SMALL_CCY';
        test_1.User_1__c = 'test';        
        
        test_1.EU_Destinations__c = 'Basic EU Cash Destinations;Basic EU Futures Destinations;Basic EU Futures Destinations;Basic EU Options Destination';
        test_1.CFM_Limits_EU_cash__c = 'Zero';
        test_1.Index_Futures_EU__c = 'FUT_SMALL_INDEX_EU'; 
        test_1.Fid_Futures_EU__c = 'FUT_SMALL_FIXEDINC_EU';
        test_1.Options_EU__c = 'Zero';
        
        test_1.US_Destination__c = 'Basic US Cash Trader;Basic US Options Trader;Canada Futures;Basic US Futures Trader';        
        test_1.CFM_Limits_US_CASH__c = 'Starter';
        test_1.Options_US__c = 'Starter'; 
        test_1.Futures_US__c = 'Starter';
        test_1.Index_Futures_US__c = 'FUT_SMALL_INDEX_US'; 
        test_1.FID_Futures_US__c = 'FUT_SMALL_FIXEDINC_US';
        
        test_1.Comments__c = 'Starter';
        
        test_1.Regions_required_for_Derivatives__c = 'Example';
        test_1.Regions_required_for_Equity__c = 'Test';
        test_1.Regions_required_for_Equity_Swaps__c = 'Test';
        test_1.Regions_required_for_Futures_Swaps__c = 'Test';  
        
        test_1.COMMOD_Futures__c = 'FUT_SMALL_COMMOD';
        
        test_1.Marketdata_Entitlements__c = 'NO MARKET DATA';      
                              
        test_1.Drop_Down__c = 'Test';
        test_1.Dropdown_accounts_for_Taiwan_Cash__c = 'Test';
        
        test_1.JP_OMSID_For_Derivatives_only__c = 'Test';
                        
        test_1.Market_Watch_Lists__c = 'FTSE Sectors (MSETftseSect.msln)';
        test_1.All_Asia_Market_Limit__c = 'Default';
                                
        
        
        test_1.Asset_Class__c='Equity;equity swaps,futures swaps';
        
        test_1.CFM_Limits_SA_Cash__c = 'Test';
        
        
        test_1.India_FutSwap__c = true;
        test_1.Korea_FutSwap__c = true;
        test_1.Exchange_Account_for_SIMR_SFER__c='MSCO-Customer-002009355';   
                
//        test_1.Singapore_Options__c=true;        
            test_1.Limits_Required_for_Asia__c='Test';    
        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;

test_1.Futures_Account__c = 'Test';
test_1.US_Futures__c = 'Test';      

test_1.US_SA_Equity_Single__c = 'Test';
         test_1.US_Equity_Cum__c = 'Test';
         test_1.SA_Equity_Cum__c = 'Test';
        test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';       
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'North America');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);
        System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
        System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),1);
        
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        
         
         System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);     
         System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),1);   
         System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
         
         System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),1);
         System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),1);
         System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),1);
         
         System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
         System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
         System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
         
//         System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestOptFlag(),1);
         
         System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
         //System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
   }
   static testMethod void Page_Test_12()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'High';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Pan-Asia';
        test_1.Status__c = 'Complete';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'New Integration';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.Asia_Pacific_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.Allocation_Type__c = '';
        test_1.FX_Futures__c = 'FUT_SMALL_CCY';
        test_1.User_1__c = 'test';        
        
        test_1.EU_Destinations__c = 'Basic EU Cash Destinations;Basic EU Futures Destinations;Basic EU Futures Destinations;Basic EU Options Destination';
        test_1.CFM_Limits_EU_cash__c = 'Zero';
        test_1.Index_Futures_EU__c = 'FUT_SMALL_INDEX_EU'; 
        test_1.Fid_Futures_EU__c = 'FUT_SMALL_FIXEDINC_EU';
        test_1.Options_EU__c = 'Zero';
        
        test_1.US_Destination__c = 'Basic US Cash Trader;Basic US Options Trader;Canada Futures;Basic US Futures Trader';        
        test_1.CFM_Limits_US_CASH__c = 'Starter';
        test_1.Options_US__c = 'Starter'; 
        test_1.Futures_US__c = 'Starter';
        test_1.Index_Futures_US__c = 'FUT_SMALL_INDEX_US'; 
        test_1.FID_Futures_US__c = 'FUT_SMALL_FIXEDINC_US';
        
        test_1.Comments__c = 'Starter';
        
        test_1.Regions_required_for_Derivatives__c = 'Example';
        test_1.Regions_required_for_Equity__c = 'Test';
        test_1.Regions_required_for_Equity_Swaps__c = 'Test';
        test_1.Regions_required_for_Futures_Swaps__c = 'Test';  
        
        test_1.COMMOD_Futures__c = 'FUT_SMALL_COMMOD';
        
        test_1.Marketdata_Entitlements__c = 'NO MARKET DATA';      
                              
        test_1.Drop_Down__c = 'Test';
        test_1.Dropdown_accounts_for_Taiwan_Cash__c = 'Test';
        
        test_1.JP_OMSID_For_Derivatives_only__c = 'Test';
                        
        test_1.Market_Watch_Lists__c = 'FTSE Sectors (MSETftseSect.msln)';
        test_1.All_Asia_Market_Limit__c = null;
                                
        test_1.Asia_Pacific_Markets__c='Japan;HK/SG/AU;Korea;Taiwan;India;Broker Markets;Malaysia;Thailand;Indonesia;Singapore;Hongkong;Australia';
        
        test_1.Asset_Class__c = 'Equity;Options;Spreads;Futures;equity swaps;futures swaps';
        
        test_1.JP_Trade_Limit_Cash__c='Default';
        test_1.JP_Trade_Limit_FUT__c='Default';
        test_1.JP_Trade_Limit_OPT__c='Default';
        test_1.JP_Trade_Limit_Spread__c='Default';
        
        test_1.NJA_Trade_Limit_Cash__c='Default';
        test_1.NJA_Trade_Limit_FUT__c='Default';
        test_1.NJA_Trade_Limit_OPT__c='Default';
        test_1.NJA_Trade_Limit_Spread__c='Default';
        
        test_1.KR_Trade_Limit_Cash__c='Default';
        test_1.KR_Trade_Limit_FUT__c='Default';
        test_1.KR_Trade_Linit_OPT__c='Default';
        test_1.KR_Trade_Limit_Spread__c='Default';
        
        test_1.TW_Trade_Limit_Cash__c='Default';
        test_1.TW_Trade_Limit_OPT__c='Default';
        test_1.Tw__c='Default';
        test_1.TW_Trade_Limit_Spread__c='Default';
        
        test_1.IN_Trade_Limit_Cash__c='Default';
        test_1.IN_Trade_Limit_FUT__c='Default';
        test_1.IN_Trade_Limit_OPT__c='Default';
        test_1.IN_trade_Limit_Spread__c='Default';
        
        test_1.Broker_Mkt_Trade_Limit_Cash__c='Default';
        test_1.Malaysia_Trade_Limit_Cash__c='Default';
        test_1.TH_Trade_Limit_Cash__c='Default';
        test_1.Indonesia_Trade_Limit_Cash__c='Default';
        
        test_1.SG_Trade_Limit_Cash__c='Default';
        test_1.SG_Trade_Limit_FUT__c='Default';
        test_1.SG_Trade_Limit_OPT__c='Default';
        test_1.SG_Trade_Limit_Spread__c='Default';
        
        test_1.HK_Trade_Limit_Cash__c='Default';
        test_1.HK_Trade_Limit_FUT__c='Default';
        test_1.HK_Trade_Limit_OPT__c='Default';
        test_1.HK_Trade_Limit_Spread__c='Default';
        
        test_1.AU_Trade_Limit_Cah__c='Default';
        test_1.AU_Trade_Limit_FUT__c='Default';
        test_1.AU_Trade_Limit_OPT__c='Default';
        test_1.AU_Trade_Limit_Spread__c='Default';
        
        test_1.Japan__c = true;
        test_1.HongKong__c = true;
        test_1.Singapure__c = true;
        test_1.Korea__c = true;
        test_1.India__c = true;
        test_1.Taiwan__c = true;
        test_1.Australia__c = true;
        
        test_1.AsiaEtsClients_Integrator__c='asudham';
        test_1.India_FutSwap__c = true;
        test_1.Korea_FutSwap__c = true;
         test_1.Australia_Future_Swap__c = true;
        test_1.Taiwan_Future_Swap__c = true;
        
        test_1.Exchange_Account_for_SIMR_SFER__c='MSCO-Customer-002009355';
        test_1.Foreign_Id_KR__c = 'sample';
        test_1.Exchange_Account_KR__c = 'sample';

    
        
          test_1.Limits_Required_for_Asia__c='Test';  
          
         test_1.Spreads_Australia__c='MSCO - Customer';
test_1.Spreads_Singapore__c='MSCO - Customer';
test_1.Options_Australia__c='MSCO - Customer';
test_1.Options_Singapore__c='MSCO - Customer';
test_1.Futures_Singapore__c='MSCO - Customer';
test_1.Futures_Australia__c='MSCO - Customer';
        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;
               
                test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
      
     
        test_1.Spreads_Markets__c = 'Test';
       test_1.Options_Markets__c = 'Test';
       test_1.Equity_Swap_Markets__c= 'Test';
       test_1.Future_Swap_Markets__c= 'Test';
       test_1.Equity_Markets__c= 'Test';
       test_1.Futures_Markets__c= 'Test';
test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';    

        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Pan-Asia');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),1);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),0);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);
        System.assertEquals(passportrequest_extn.getJapanFlag(),1);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),1);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),1);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),1);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),1);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),1);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),1);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),1);
        System.assertEquals(passportrequest_extn.getThailandFlag(),1);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),1);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),1);
        System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),1);
        
        System.assertEquals(passportrequest_extn.getEquityFlag(),1);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),1);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),1);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),1);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),1);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),1);
        System.assertEquals(passportrequest_extn.getFutureFlag(),1);
        System.assertEquals(passportrequest_extn.getAssetFlag(),1);
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),1);
        
        System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),1);
        System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
        System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),0);
        
/*         System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),1);
        System.assertEquals(passportrequest_extn.getSpreadsSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getSpreadsAustraliaFlag(),1);
        System.assertEquals(passportrequest_extn.getFuturesSingaporeFlag(),1);
        System.assertEquals(passportrequest_extn.getFuturesAustraliaFlag(),1);
  */       
         System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
         
         System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),0);
         System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),0);
         System.assertEquals(passportrequest_extn.getEUCashDestFlag(),0);
         
         System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
        
   }
   static testMethod void Page_Test_13()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'High';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Europe';
        test_1.Status__c = 'Complete';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'New Integration';
        test_1.Depending_On__c = 'sbar';
        test_1.Affiliate__c = 'No';
        test_1.EU_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';
        
        test_1.Allocation_Type__c = '';
        test_1.FX_Futures__c = 'FUT_SMALL_CCY';
        test_1.User_1__c = 'test';        
        
        test_1.EU_Destinations__c = 'Basic EU Cash Destinations;Basic EU Futures Destinations;Basic EU Futures Destinations;Basic EU Options Destination';
        test_1.CFM_Limits_EU_cash__c = 'Zero';
        test_1.Index_Futures_EU__c = 'FUT_SMALL_INDEX_EU'; 
        test_1.Fid_Futures_EU__c = 'FUT_SMALL_FIXEDINC_EU';
        test_1.Options_EU__c = 'Zero';
        
        test_1.US_Destination__c = 'Basic US Cash Trader;Basic US Options Trader;Canada Futures;Basic US Futures Trader';        
        test_1.CFM_Limits_US_CASH__c = 'Starter';
        test_1.Options_US__c = 'Starter'; 
        test_1.Futures_US__c = 'Starter';
        test_1.Index_Futures_US__c = 'FUT_SMALL_INDEX_US'; 
        test_1.FID_Futures_US__c = 'FUT_SMALL_FIXEDINC_US';
        
        test_1.Comments__c = 'Starter';
        
        test_1.Regions_required_for_Derivatives__c = 'Example';
        test_1.Regions_required_for_Equity__c = 'Test';
        test_1.Regions_required_for_Equity_Swaps__c = 'Test';
        test_1.Regions_required_for_Futures_Swaps__c = 'Test';  
        
        test_1.COMMOD_Futures__c = 'FUT_SMALL_COMMOD';
        
        test_1.Marketdata_Entitlements__c = 'NO MARKET DATA';      
                              
        test_1.Drop_Down__c = 'Test';
        test_1.Dropdown_accounts_for_Taiwan_Cash__c = 'Test';
        
        test_1.JP_OMSID_For_Derivatives_only__c = 'Test';
                        
        test_1.Market_Watch_Lists__c = 'FTSE Sectors (MSETftseSect.msln)';
        test_1.All_Asia_Market_Limit__c = 'Default';
                                
        test_1.Asia_Pacific_Markets__c='Japan;HK/SG/AU;Korea;Taiwan;India;Broker Markets;Malaysia;Thailand;Indonesia;Singapore;Hongkong;Australia';
        
        test_1.Asset_Class__c='Equity;equity swaps,futures swaps';
        
        test_1.JP_Trade_Limit_Cash__c='Default';
        test_1.JP_Trade_Limit_FUT__c='Default';
        test_1.JP_Trade_Limit_OPT__c='Default';
        test_1.JP_Trade_Limit_Spread__c='Default';
        
        test_1.NJA_Trade_Limit_Cash__c='Default';
        test_1.NJA_Trade_Limit_FUT__c='Default';
        test_1.NJA_Trade_Limit_OPT__c='Default';
        test_1.NJA_Trade_Limit_Spread__c='Default';
        
        test_1.KR_Trade_Limit_Cash__c='Default';
        test_1.KR_Trade_Limit_FUT__c='Default';
        test_1.KR_Trade_Linit_OPT__c='Default';
        test_1.KR_Trade_Limit_Spread__c='Default';
        
        test_1.TW_Trade_Limit_Cash__c='Default';
        test_1.TW_Trade_Limit_OPT__c='Default';
        test_1.Tw__c='Default';
        test_1.TW_Trade_Limit_Spread__c='Default';
        
        test_1.IN_Trade_Limit_Cash__c='Default';
        test_1.IN_Trade_Limit_FUT__c='Default';
        test_1.IN_Trade_Limit_OPT__c='Default';
        test_1.IN_trade_Limit_Spread__c='Default';
        
        test_1.Broker_Mkt_Trade_Limit_Cash__c='Default';
        test_1.Malaysia_Trade_Limit_Cash__c='Default';
        test_1.TH_Trade_Limit_Cash__c='Default';
        test_1.Indonesia_Trade_Limit_Cash__c='Default';
        
        test_1.SG_Trade_Limit_Cash__c='Default';
        test_1.SG_Trade_Limit_FUT__c='Default';
        test_1.SG_Trade_Limit_OPT__c='Default';
        test_1.SG_Trade_Limit_Spread__c='Default';
        
        test_1.HK_Trade_Limit_Cash__c='Default';
        test_1.HK_Trade_Limit_FUT__c='Default';
        test_1.HK_Trade_Limit_OPT__c='Default';
        test_1.HK_Trade_Limit_Spread__c='Default';
        
        test_1.AU_Trade_Limit_Cah__c='Default';
        test_1.AU_Trade_Limit_FUT__c='Default';
        test_1.AU_Trade_Limit_OPT__c='Default';
        test_1.AU_Trade_Limit_Spread__c='Default';
        
        test_1.Japan__c = true;
        test_1.HongKong__c = true;
        test_1.Singapure__c = true;
        test_1.Korea__c = true;
        test_1.India__c = true;
        test_1.Taiwan__c = true;
        test_1.Australia__c = true;
        
        test_1.AsiaEtsClients_Integrator__c='asudham';
        test_1.India_FutSwap__c = false;
        test_1.Korea_FutSwap__c = false;
        test_1.Exchange_Account_for_SIMR_SFER__c='MSCO-Customer-002009355';
        test_1.Foreign_Id_KR__c = 'sample';
        test_1.Exchange_Account_KR__c = 'sample';
//          test_1.Singapore_Options__c=true;
           test_1.Limits_Required_for_Asia__c='Test';
           
        test_1.Japan_Equity__c = true ;
        test_1.HongKong_Equity__c = true ;
        test_1.Singapore_Equity__c = true ;
        test_1.Australia_Equity__c = true ;
        test_1.Korea_Equity__c = true ;
        test_1.Taiwan_Equity__c = true ;
        test_1.India_Equity__c = true ;
        test_1.Malaysia_Equity__c = true ; 
        test_1.Indonesia_Equity__c = true ;
        test_1.Thailand_Equity__c = true ;
        test_1.NewZealand_Equity__c = true ;
        
        test_1.Japan_Futures__c = true;
        test_1.HongKong_Futures__c = true;
        test_1.Singapore_Futures__c = true;
        test_1.Australia_Futures__c = true; 
        test_1.Korea_Futures__c = true; 
        test_1.Taiwan_Futures__c = true; 
        test_1.India_Futures__c = true;
        test_1.Malaysia_Futures__c = true;   
        
         test_1.Japan_Options__c =true ;
test_1.HongKong_Options__c =true ;
test_1.Singapore_Options__c =true ;
test_1.Australia_Options__c =true ;
test_1.Korea_Options__c =true ;
test_1.Taiwan_Options__c =true ;
test_1.India_Options__c =true;
test_1.Malaysia_Options__c = true;

test_1.Japan_Spreads__c =true; 
test_1.HongKong_Spreads__c =true; 
test_1.Singapore_Spreads__c =true;
test_1.Australia_Spreads__c =true; 
test_1.Korea_Spreads__c =true; 
test_1.Taiwan_Spreads__c =true;
test_1.India_Spreads__c =true;
test_1.Malaysia_Spreads__c =true;
test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';             
            
        insert test_1;

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        System.assertEquals(passportrequest_extn.getTradeRegion(),'Europe');
        System.assertEquals(passportrequest_extn.getAccountAllocationUSFlag(),0);
        System.assertEquals(passportrequest_extn.getAccountAllocationEUFlag(),1);
        System.assertEquals(passportrequest_extn.getAccountAllocationASIAFlag(),0);
        System.assertEquals(passportrequest_extn.getCashRegionFlag(),1);
        System.assertEquals(passportrequest_extn.getEUDestMSSectorsFlag(),0);
        System.assertEquals(passportrequest_extn.getJapanFlag(),0);
        System.assertEquals(passportrequest_extn.getKoreaFlag(),0);
        System.assertEquals(passportrequest_extn.getIndiaFlag(),0);
        System.assertEquals(passportrequest_extn.getHKSGAUFlag(),0);
        System.assertEquals(passportrequest_extn.getAustraliaFlag(),0);
        System.assertEquals(passportrequest_extn.getTaiwanFlag(),0);        
        System.assertEquals(passportrequest_extn.getBrokerMareketFlag(),0);
        System.assertEquals(passportrequest_extn.getMalaysiaFlag(),0);
        System.assertEquals(passportrequest_extn.getThailandFlag(),0);
        System.assertEquals(passportrequest_extn.getIndonesiaFlag(),0);
        System.assertEquals(passportrequest_extn.getSingaporeFlag(),0);
        System.assertEquals(passportrequest_extn.getHongkongFlag(),0);
        System.assertEquals(passportrequest_extn.getNewIntegrationFlag(),1);
        
        System.assertEquals(passportrequest_extn.getEquityFlag(),0);
        System.assertEquals(passportrequest_extn.getOptionsFlag(),0);
        System.assertEquals(passportrequest_extn.getSpreadsFlag(),0);
        System.assertEquals(passportrequest_extn.getEquitySwapFlag(),0);
        System.assertEquals(passportrequest_extn.getFuturesSwapFlag(),0);
        System.assertEquals(passportrequest_extn.getAllAsiaMarketFlag(),0);
        System.assertEquals(passportrequest_extn.getFutureFlag(),0);
        System.assertEquals(passportrequest_extn.getAssetFlag(),0);
        System.assertEquals(passportrequest_extn.getSIMRSFERFlag(),0);
        
         System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),0);
         //System.assertEquals(passportrequest_extn.getOptionsAustraliaFlag(),0);
         
         System.assertEquals(passportrequest_extn.getAP_Coverage_Person_Flag(),0);
         System.assertEquals(passportrequest_extn.getNA_Coverage_Person_Flag(),0);
         System.assertEquals(passportrequest_extn.getEU_Coverage_Person_Flag(),1);
         
         
         System.assertEquals(passportrequest_extn.getUSDestBasicCanadaFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestUsCashFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestUSFutFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestCanFutFlag(),0);
         
         System.assertEquals(passportrequest_extn.getEUDestEUOptFlag(),1);
         System.assertEquals(passportrequest_extn.getEUDestFUDestFlag(),1);
         System.assertEquals(passportrequest_extn.getEUCashDestFlag(),1);
         
         System.assertEquals(passportrequest_extn.getCashOptFlag(),0);
         System.assertEquals(passportrequest_extn.getUSDestOptFlag(),0);
         
    
   }
   
   
    static testMethod void Page_Test_14()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Pan-Asia';
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Asset_Class__c = 'Options';
        test_1.Singapore_Options__c =true ;
        test_1.User_1__c = 'Test';
        test_1.Options_Singapore__c='Test';     
    //    test_1.name = 'test' ;
        test_1.Affiliate__c = null;
        test_1.Trade_Region__c = 'test';  
        test_1.Mset_Futures__c = true ;
        test_1.EU_Coverage_Person__c = 'rakesh.singh1@morganstanley.com.test.test';
        test_1.Asia_Pacific_Coverage_Person__c = 'rakesh.singh1@morganstanley.com.test.test';
          
        insert test_1;
        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.getRequests();       
        //passportrequest_extn.editRequestedBy();
        passportrequest_extn.getClone_Setup_Flag();
        passportrequest_extn.getEUDestinationPermissionsMandatory();
        passportrequest_extn.getCloneUserFlag();
        passportrequest_extn.hideLimitSection();
        passportrequest_extn.getCloneCheckboxFlag();
        passportrequest_extn.getCloneSetupNoFlag();
        passportrequest_extn.getFuturesAccountMandatory();
        passportrequest_extn.getCloneUserMandatoryEUFlag();
        passportrequest_extn.cloneUserMandatoryEU();
        passportrequest_extn.save();
      //  System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),1); 
    }
    
     static testMethod void Page_Test_15()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Trade_Region__c = null;      
        test_1.User_1__c= 'test';
        test_1.MSET_Account__c = null;
        test_1.Requested_By__c = null;
        test_1.Target_Date__c = null;
        test_1.Client_Approver__c=null;
        test_1.Status__c = null;
        test_1.User_1__c = null;
      //  insert test_1;
        
        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcTradeRegionValue();
        passportrequest_extn.save();
      //  System.assertEquals(passportrequest_extn.getOptionsSingaporeFlag(),1); 
    }
    
    static testMethod void Page_Test_16()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Trade_Region__c = 'Europe;Pan-Asia';      
        test_1.EU_Destinations__c = null;
        test_1.Asset_Class__c =null;
        test_1.Request_Type__c = 'New User';
        test_1.Clone_Setup__c = 'Yes';
        
        
        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcEUDestMSSector();
        passportrequest_extn.calcEquitySwap();
        passportrequest_extn.calcCloneSetup();
        
        test_1.Request_Type__c = 'Test';
        
        passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcCloneSetup();
        
    }
    
    static testMethod void Page_Test_16_a()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Trade_Region__c = 'Europe;Pan-Asia';      
        test_1.Clone_Setup__c = 'No';

        PassportRequestControllerExtension  passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcCloneSetup();
    }
    
    static testMethod void Page_Test_17()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.Request_Type__c='Decommission';
        test_1.Trade_Region__c = 'Europe';

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcRequestType();
    }
    
        static testMethod void Page_Test_18()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        
        Passport_Request__c test_1 = new Passport_Request__c();
     
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        
        test_1.Trade_Region__c = 'Pan-Asia';
        test_1.Asset_Class__c = 'Equity';
        test_1.Equity_Markets__c = 'Hong Kong';
        test_1.Request_Type__c = 'New Integration';
        
        test_1.Status__c = 'Submitted';

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcDarkPoolCheckedFlag();
        
    }
    
            static testMethod void Page_Test_18_a()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        
        test_1.Trade_Region__c = 'Pan-Asia';
        test_1.Asset_Class__c = 'Test';
        test_1.Equity_Markets__c = 'Hong Kong';
        test_1.Request_Type__c = 'New Integration';
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';

        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcDarkPoolCheckedFlag();
        passportrequest_extn.hksfcCheckedFlag();
        
    }
    
    
     static testMethod void Page_Test_19()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
  //      test_1.Name= 'Test';
        test_1.Status__c= 'Test';
        
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Target_Date__c = date.today();
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Asia_Pacific_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';              
        test_1.User_1__c = 'Test';
        
        test_1.Trade_Region__c='Pan-Asia';
        
        test_1.Request_Type__c = 'New Integration';
        test_1.Asset_Class__c = 'Test'; 
        test_1.Limits_Required_for_Asia__c = 'test';
        test_1.MSET_Account__c =  testacct.id;
        test_1.Priority__c = 'High';
test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';               
        
        insert test_1;
        String id='a0a60000002E8rC';
        
        System.debug('Name1:::'+test_1.Name);
        
    
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        //controller.attachment.body=bodyBlob;
        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        
        passportrequest_extn.document1 =  new Attachment();
        passportrequest_extn.document1.body=bodyBlob;
        passportrequest_extn.fileNameMy='test';
        passportrequest_extn.document1.name=passportrequest_extn.fileNameMy;
                
        
        passportrequest_extn.document2 =  new Attachment();
        passportrequest_extn.document2.body=bodyBlob;
        passportrequest_extn.document2.name='test';
          
        passportrequest_extn.calcDisableDarkPoolControl();
        passportrequest_extn.getBlockFileUploadFlag();
        passportrequest_extn.getshowUploadedaFileName();
        passportrequest_extn.getMandatoryFileUpload();
        passportrequest_extn.attachUploadedFileInTicket(id,'a.txt');
        passportrequest_extn.calcEquitymarkets();
        passportrequest_extn.setHKSFCCheckTrue();
        passportrequest_extn.getHksfcMandatoryFlag();
        passportrequest_extn.calcStatus();
        passportrequest_extn.getHksfcFlag();
        passportrequest_extn.attachUploadedFileInTicketHKSFC(id);
        passportrequest_extn.calcAccount();
        passportrequest_extn.sendEmailto_hksfc(id);
        passportrequest_extn.sendEmailto_mshkats(id);
    }
    
    static testMethod void Page_Test_19_a()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        
        test_1.Status__c= 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Trade_Region__c='Pan-Asia';
        test_1.Equity_Markets__c = 'Hong Kong';
        test_1.Request_Type__c = 'New Integration';
        test_1.Asset_Class__c = 'Equity';
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Target_Date__c = date.today();
        
               test_1.Limits_Required_for_Asia__c = 'test';
        test_1.Asia_Pacific_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';              
        test_1.User_1__c = 'Test';
        test_1.Priority__c = 'High';
                test_1.MSET_Account__c =  testacct.id;
              test_1.ETA_Signed_and_Returned__c=true;
test_1.CSC_Date__c=date.today();
test_1.SFC_attestation__c='Out of Scope';
test_1.Reason__c='test';    
        insert test_1;
        
        System.debug('Name:::'+test_1.Name);
        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcDisableDarkPoolControl();
        
    }
    
    static testMethod void Page_Test_19_b()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Target_Date__c = date.today();
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = 'Test';
        test_1.Asia_Pacific_Coverage_Person__c='mohit.d.jain@morganstanley.com.test.test';              
        test_1.User_1__c = 'Test';
        
        test_1.Trade_Region__c='Pan-Asia';
         test_1.MSET_Account__c =  testacct.id;       
        test_1.Priority__c = 'High';
        test_1.Asset_Class__c = 'Test'; 
        test_1.Limits_Required_for_Asia__c = 'test';
        insert test_1;
        
        
        System.debug('Name:2::'+test_1.Name);
        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);
        passportrequest_extn.calcDisableDarkPoolControl();
        
    }
    
     static testMethod void Page_Test_20()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        ApexPages.StandardController passreq = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'Pan-Asia;Europe;North America';
        test_1.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_1.Request_Type__c = '';
        test_1.Asset_Class__c = 'Options;Equity';
        test_1.US_Destination__c='Basic US Cash Trader';
        test_1.EU_Destinations__c='Basic EU Cash Destinations';
        test_1.Singapore_Options__c =true ;
        test_1.User_1__c = 'Test';
        test_1.Options_Singapore__c='Test';  
        test_1.NA_Coverage_Person__c = 'mohit.d.jain@morganstanley.com.test.test';      
   //     insert test_1;
        PassportRequestControllerExtension passportrequest_extn = new PassportRequestControllerExtension(passreq);       
        passportrequest_extn.calcetsDB();
        passportrequest_extn.calcETSBSAction();
        try{
        passportrequest_extn.createETSDB();
        }
        catch(Exception c)
        {}
        passportrequest_extn.createLimitRecord(); 
         
    }
 static testMethod void Page_Test_21()
    {
        PageReference pageRef = Page.Passport_Request;
        Test.setCurrentPageReference(pageRef);
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'PassportRequestAccount', recordtypeid = recordtypeid.id);
        insert testacct;
        
        Passport_Request__c test_1 = new Passport_Request__c();
        test_1.Requested_By__c = null;
        test_1.Status__c = null;
        try{
        insert test_1;
        }
        catch(Exception e)
        {}
        
        Passport_Request__c test_2 = new Passport_Request__c();
        test_2.MSET_Account__c =  testacct.id;
        test_2.Requested_By__c = '00560000000nJIg';
        test_2.Priority__c = 'Immediate';
        test_2.Target_Date__c = date.today();
        test_2.Trade_Region__c = 'Pan-Asia;Europe;North America';
        test_2.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_2.Request_Type__c = 'New User';
        test_2.Clone_Setup__c = 'No';
        test_2.Asset_Class__c = 'Options;Equity;equity swaps;futures swaps;Futures;Spreads';
        test_2.Asia_Pacific_Markets__c = 'Japan;Korea;India;Hongkong;HK/SG/AU;Taiwan;Broker Markets;Malaysia;Thailand;Indonesia;Singapore;Australia';
        test_2.Futures_Markets__c = 'Australia;Singapore';     
   try{
        insert test_2;
        }
        catch(Exception e)
        {}
        test_2.Clone_Setup__c = 'Yes';
        test_2.Mirror__c = true;
        test_2.Mset_Futures__c = true;
        try{insert test_2;}
        catch(Exception e)
        {}
        
        
        
        MSET_Account__c acnt = new MSET_Account__c(Name='GOTHAM ASSET MANAGEMENT (NEW YORK)'); 
        Database.SaveResult sr = database.insert(acnt);
        Passport_Request__c test_3 = new Passport_Request__c();
        test_3.MSET_Account__c =  sr.getId();
        test_3.Requested_By__c = '00560000000nJIg';
        test_3.Priority__c = 'Immediate';
        test_3.Target_Date__c = date.today();
        test_3.Trade_Region__c = 'Pan-Asia;Europe;North America';
        test_3.Status__c = 'Submitted';
        test_1.Client_Approver__c='test';
        test_3.Request_Type__c = 'New Integration';
        test_3.Clone_Setup__c = 'Yes';
        test_3.Asset_Class__c = 'Options;Equity;equity swaps;futures swaps;Futures;Spreads';
        test_3.US_Destination__c='Basic US Cash Trader';
        test_3.EU_Destinations__c='Basic EU Cash Destinations';
        test_3.Asia_Pacific_Markets__c = 'Japan;Korea;India;Hongkong;HK/SG/AU;Taiwan;Broker Markets;Malaysia;Thailand;Indonesia;Singapore;Australia';
        test_3.Futures_Markets__c = null;
        test_3.Trigger_ETSDB_Report_form__c = 'Yes';
        
   try{
        insert test_3;
        }
        catch(Exception e)
        {}
        
        Passport_Request__c test_4 = new Passport_Request__c();
        test_4.MSET_Account__c =  testacct.id;
        test_4.Status__c = 'Complete';
        test_1.Client_Approver__c='test';
        test_4.Asset_Class__c = null;
        test_4.EU_Destinations__c = null;
        test_4.US_Destination__c = null;
        
        test_4.Requested_By__c = '00560000000nJIg';
        test_4.Priority__c = 'Immediate';
        test_4.Target_Date__c = date.today();
        test_4.Trade_Region__c = 'Pan-Asia;Europe;North America';
        
        test_4.Request_Type__c = 'New User';
        test_4.Clone_Setup__c = 'No';
        
        
        
        test_4.Asia_Pacific_Markets__c = 'Japan;Korea;India;Hongkong;HK/SG/AU;Taiwan;Broker Markets;Malaysia;Thailand;Indonesia;Singapore;Australia';
        test_4.Futures_Markets__c = 'Australia;Singapore';     
   try{
        insert test_4;
        }
        catch(Exception e)
        {}
        
    }
    
}