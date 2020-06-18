public class testDynamicMSWatchPage{
    
    // To be refactored as test class uses hardcoded ids.

    static testMethod void Page_Test_1()
    {
        PageReference pageRef = Page.MS_Watch;
        Test.setCurrentPageReference(pageRef);   
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ; 
        MSET_Account__c testacct = new MSET_Account__c(name = 'MSWatchRequestAccount', recordtypeid=recordtypeid.id);
        insert testacct;
         
        MS_Watch__c test_1 = new MS_Watch__c();
        ApexPages.StandardController MSWatch = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'North America';
        test_1.Status__c = 'Submitted';
        
        test_1.MSET_Contact1__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R1__c = 'Testing';
        test_1.Time_Zone_for_R1__c = '(GMT-12:00) International Date Line West';
        test_1.Condition_for_R1__c = 'Interest List (ASIA); Interest List (LN); Interest List (US); LN_FIX_BXS; NY_FIX_DMA; TK_HK_FIX_BXS;SA_FIX_BROKER';        
        test_1.Send_alerts_via_R1__c = 'Bloomberg IM; Email; IM_AOL; Passport; CFM User only';
        test_1.Add_Trador__c = True;
        test_1.SenderSubID_T1__c = 'BXS';
        
        test_1.Bloomberg_IM_address_for_R1__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R1__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R1__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R1__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R1__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R1__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R1__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R1__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R1__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R1__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R1__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R1__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R1__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R1__c='OrderAcknowledged';
        test_1.Enable_SA_alerts_for_Email_for_R1__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R1__c='IM_AOL';
        test_1.Enable_SA_alerts_for_PP_for_R1__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R1__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R1__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R1__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R1__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R1__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R1__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R1__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R1__c='IOI;Research';
        
        test_1.MSET_Contact2__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R2__c = 'Testing';
        test_1.Time_Zone_for_R2__c = '(GMT-12:00) International Date Line West';
        test_1.Condition_for_R2__c = 'Interest List (ASIA); Interest List (LN); Interest List (US); LN_FIX_BXS; NY_FIX_DMA; TK_HK_FIX_BXS;SA_FIX_BROKER';        
        test_1.Send_alerts_via_R2__c = 'Bloomberg IM; Email; IM_AOL; Passport; CFM User only';
        test_1.Add_Trador_3__c = True;
        test_1.SenderSubID_T2__c = 'test';
        
        test_1.Bloomberg_IM_address_for_R2__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R2__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R2__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R2__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R2__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R2__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R2__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R2__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R2__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R2__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R2__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R2__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R2__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R2__c='Default Package';
        test_1.Enable_SA_alerts_for_Email_for_R2__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R2__c='Above200dma';
        test_1.Enable_SA_alerts_for_PP_for_R2__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R2__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R2__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R2__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R2__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R2__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R2__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R2__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R2__c='IOI;Research';
        
       test_1.MSET_Contact3__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R3__c = 'Testing';
        test_1.Time_Zone_for_R3__c = '(GMT-13:00) International Date Line West';
        test_1.Condition_for_R3__c = 'Interest List (ASIA); Interest List (LN); Interest List (US); LN_FIX_BXS; NY_FIX_DMA; TK_HK_FIX_BXS;SA_FIX_BROKER';        
        test_1.Send_alerts_via_R3__c = 'Bloomberg IM; Email; IM_AOL; Passport; CFM User only';
        test_1.Add_Trador_4__c = True;
        test_1.SenderSubID_T3__c = 'test';
        
        test_1.Bloomberg_IM_address_for_R3__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R3__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R3__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R3__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R3__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R3__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R3__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R3__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R3__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R3__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R3__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R3__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R3__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R3__c='Default Package';
        test_1.Enable_SA_alerts_for_Email_for_R3__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R3__c='Above200dma';
        test_1.Enable_SA_alerts_for_PP_for_R3__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R3__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R3__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R3__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R3__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R3__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R3__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R3__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R3__c='IOI;Research';
        
        
        test_1.MSET_Contact4__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R4__c = 'Testing';
        test_1.Time_Zone_for_R4__c = '(GMT-14:00) International Date Line West';
        test_1.Condition_for_R4__c = 'Interest List (ASIA); Interest List (LN); Interest List (US); LN_FIX_BXS; NY_FIX_DMA; TK_HK_FIX_BXS;SA_FIX_BROKER';        
        test_1.Send_alerts_via_R4__c = 'Bloomberg IM; Email; IM_AOL; Passport; CFM User only';
        test_1.SenderSubID_T4__c = 'test';
        
        test_1.Bloomberg_IM_address_for_R4__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R4__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R4__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R4__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R4__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R4__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R4__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R4__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R4__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R4__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R4__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R4__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R4__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R4__c='Default Package';
        test_1.Enable_SA_alerts_for_Email_for_R4__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R4__c='Above200dma';
        test_1.Enable_SA_alerts_for_PP_for_R4__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R4__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R4__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R4__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R4__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R4__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R4__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R4__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R4__c='IOI;Research';
        test_1.Alerts_Required_Intraday__c = 'Test';
        insert test_1;
        
        MSWatchControllerExtension MSWatch_extn = new MSWatchControllerExtension(MSWatch);
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag1(),1);
        System.assertEquals(MSWatch_extn.getEmailAddFlag1(),1);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag1(),1);
        System.assertEquals(MSWatch_extn.getPassLogFlag1(),1);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag1(),1);
        System.assertEquals(MSWatch_extn.getCFMUserFlag1(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag1(),1);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag1(),1);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag1(),1);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag1(),1);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag1(),1);
        System.assertEquals(MSWatch_extn.getLNAlertIntListFlag1(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag1(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag1(),1);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag1(),1);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag1(),1);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag1(),1);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag1(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag1(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag1(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag1(),1);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag1(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag1(),1);
        System.assertEquals(MSWatch_extn.getTrader2DispFlag(),1);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag1(),1);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag1(),1);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag1(),1);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag1(),1);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag1(),1);
        
        
         
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag2(),1);
        System.assertEquals(MSWatch_extn.getEmailAddFlag2(),1);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag2(),1);
        System.assertEquals(MSWatch_extn.getPassLogFlag2(),1);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag2(),1);
        System.assertEquals(MSWatch_extn.getCFMUserFlag2(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag2(),1);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag2(),1);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag2(),1);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag2(),1);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag2(),1);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag2(),1);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag2(),1);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag2(),1);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag2(),1);
        System.assertEquals(MSWatch_extn.getLNAlertIntListFlag2(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag2(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag2(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag2(),1);        
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag2(),1);
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag2(),1);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag2(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag2(),1);
        System.assertEquals(MSWatch_extn.getTrader3DispFlag(),1);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag2(),1);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag2(),1);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag2(),1);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag2(),1);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag2(),1);
        
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag3(),1);
        System.assertEquals(MSWatch_extn.getEmailAddFlag3(),1);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag3(),1);
        System.assertEquals(MSWatch_extn.getPassLogFlag3(),1);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag3(),1);
        System.assertEquals(MSWatch_extn.getCFMUserFlag3(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag3(),1);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag3(),1);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag3(),1);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag3(),1);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag3(),1);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag3(),1);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag3(),1);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag3(),1);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag3(),1);
        System.assertEquals(MSWatch_extn.getLNAlertIntListFlag3(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag3(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag3(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag3(),1);        
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag3(),1);
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag3(),1);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag3(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag3(),1);
        System.assertEquals(MSWatch_extn.getTrader4DispFlag(),1);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag3(),1);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag3(),1);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag3(),1);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag3(),1);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag3(),1);
        
        
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag4(),1);
        System.assertEquals(MSWatch_extn.getEmailAddFlag4(),1);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag4(),1);
        System.assertEquals(MSWatch_extn.getPassLogFlag4(),1);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag4(),1);
        System.assertEquals(MSWatch_extn.getCFMUserFlag4(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag4(),1);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag4(),1);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag4(),1);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag4(),1);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag4(),1);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag4(),1);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag4(),1);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag4(),1);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag4(),1);
        System.assertEquals(MSWatch_extn.getLNAlertIntListFlag4(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag4(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag4(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag4(),1);        
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag4(),1);
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag4(),1);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag4(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag4(),1);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag4(),1);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag4(),1);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag4(),1);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag4(),1);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag4(),1);
             
        
        MSWatch_extn.cloneForm();
        MSWatch_extn.getPageTitle();

        MSWatch_extn.refreshPage();
        MSWatch_extn.cloneAction();
    } 
        
    static testMethod void Page_Test_2()
    {
        PageReference pageRef = Page.MS_Watch;
        Test.setCurrentPageReference(pageRef);   
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'MSWatchRequestAccount', recordtypeid=recordtypeid.id);
        insert testacct;
        
        MS_Watch__c test_1 = new MS_Watch__c();
        ApexPages.StandardController MSWatch = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Priority__c = 'Immediate';
        test_1.Target_Date__c = date.today();
        test_1.Trade_Region__c = 'North America';
        test_1.Status__c = 'Submitted';
        
        test_1.MSET_Contact1__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R1__c = 'Testing';
        test_1.Time_Zone_for_R1__c = '(GMT-12:00) International Date Line West';
        test_1.Condition_for_R1__c = 'Interest List (ASIA); Interest List (LN); Interest List (US); LN_FIX_BXS; NY_FIX_DMA; TK_HK_FIX_BXS';        
        test_1.Send_alerts_via_R1__c = 'Bloomberg IM; Email; IM_AOL; Passport; CFM User only';
        test_1.Add_Trador__c = True;
        test_1.SenderSubID_T1__c = 'BXS';
        
        test_1.Bloomberg_IM_address_for_R1__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R1__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R1__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R1__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R1__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R1__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R1__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R1__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R1__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R1__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R1__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R1__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R1__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R1__c='OrderAcknowledged';
        test_1.Enable_SA_alerts_for_Email_for_R1__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R1__c='Above200dma';
        test_1.Enable_SA_alerts_for_PP_for_R1__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R1__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R1__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R1__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R1__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R1__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R1__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R1__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R1__c='IOI;Research';
        
        test_1.MSET_Contact1__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R1__c = 'Testing';
        test_1.Time_Zone_for_R1__c = 'GMT-13:00) International Date Line West';
        test_1.Condition_for_R1__c = 'LN_PASSPORT';        
        test_1.Send_alerts_via_R1__c = 'CFM User only';
        test_1.Add_Trador__c = True;
        
        test_1.MSET_Contact2__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R2__c = 'Testing';
        test_1.Time_Zone_for_R2__c = 'GMT-13:00) International Date Line West';
        test_1.Condition_for_R2__c = 'LN_PASSPORT';        
        test_1.Send_alerts_via_R2__c = 'CFM User only';
        test_1.Add_Trador_3__c = True;
        test_1.SenderSubID_T2__c = 'test';
        
        test_1.Bloomberg_IM_address_for_R2__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R2__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R2__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R2__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R2__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R2__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R2__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R2__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R2__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R2__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R2__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R2__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R2__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R2__c='Default Package';
        test_1.Enable_SA_alerts_for_Email_for_R2__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R2__c='Above200dma';
        test_1.Enable_SA_alerts_for_PP_for_R2__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R2__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R2__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R2__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R2__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R2__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R2__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R2__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R2__c='IOI;Research';
        
        test_1.MSET_Contact3__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R3__c = 'Testing';
        test_1.Time_Zone_for_R3__c = 'GMT-13:00) International Date Line West';
        test_1.Condition_for_R3__c = 'LN_PASSPORT';        
        test_1.Send_alerts_via_R3__c = 'CFM User only';
        test_1.Add_Trador_4__c = True;
        test_1.SenderSubID_T3__c = 'test';
        
        test_1.Bloomberg_IM_address_for_R3__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R3__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R3__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R3__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R3__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R3__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R3__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R3__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R3__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R3__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R3__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R3__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R3__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R3__c='Default Package';
        test_1.Enable_SA_alerts_for_Email_for_R3__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R3__c='Above200dma';
        test_1.Enable_SA_alerts_for_PP_for_R3__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R3__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R3__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R3__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R3__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R3__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R3__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R3__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R3__c='IOI;Research';
        
        test_1.MSET_Contact4__c = '0033000000BeWRxAAN';
        test_1.Alert_Recipient_Name_R4__c = 'Testing';
        test_1.Time_Zone_for_R4__c = 'GMT-13:00) International Date Line West';
        test_1.Condition_for_R4__c = 'LN_PASSPORT';        
        test_1.Send_alerts_via_R4__c = 'CFM User only';
        test_1.SenderSubID_T4__c = 'test';
        
        test_1.Bloomberg_IM_address_for_R4__c= 'jmonaghan@bloomberg.net';
        test_1.Email_address_for_R4__c= 'bl@activebear.com';
        test_1.IM_AOL_address_for_R4__c= 'Pcovellojat@aol.com';
        test_1.Enable_NY_alerts_for_PP_for_R4__c='Above200dma';
        test_1.Enable_NY_alerts_for_Bloomberg_IM_R4__c='Default Package';
        test_1.Enable_NY_alert_for_CFM_Users_R4__c='BlockPrint';
        test_1.Enable_LN_alerts_for_AOL_IM_for_R4__c='HeavyVolume;LightVolume;BlockPrint;TradingHalt;TradingResume;5%PxMvSinceOrdStrtTm;IOI;CrossingOpportunity';
        test_1.Enable_LN_alerts_for_PP_for_R4__c='Research';
        test_1.Enable_LN_alerts_for_Bloomberg_IM_R4__c='OrderCancelled';
        test_1.Enable_LN_alert_for_CFM_Users_R4__c='HeavyVolume';
        test_1.Enable_Asia_alerts_for_Email_for_R4__c='OrderIncompletion';
        test_1.Enable_Asia_alerts_for_PP_for_R4__c='OrderBlockFilled';
        test_1.Enable_Asia_alerts_for_Bloomberg_IM_R4__c='Default Package';
        test_1.Enable_Asia_alert_for_CFM_Users_R4__c='Default Package';
        test_1.Enable_SA_alerts_for_Email_for_R4__c='OrderFilled';
        test_1.Enable_SA_alerts_for_AOL_IM_for_R4__c='Above200dma';
        test_1.Enable_SA_alerts_for_PP_for_R4__c='MktMoverDown';
        test_1.Enable_SA_alerts_for_Bloomberg_IM_R4__c='LightVolume';
        test_1.Enable_SA_alert_for_CFM_Users_R4__c='OrderRejected';
        test_1.Enable_NY_alerts_for_Email_for_R4__c='OrderFilled';
        test_1.Enable_LN_alerts_for_Interest_List_R4__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak'; 
        test_1.Enable_NY_alerts_for_Interest_List_R4__c='TradingHalt;TradingResume;10%PxMvCircuitBreak;SSRCircuitBreak';
        test_1.Enable_Asia_alert_for_Interest_List_R4__c='TOSLimitBreachIN';
        test_1.Enable_LN_alerts_for_Email_for_R4__c='MktMoverUp';
        test_1.Enable_NY_alerts_for_AOL_IM_for_R4__c='IOI;Research';
        test_1.Alerts_Required_Intraday__c = 'TEST11';
                
        insert test_1;
        
        MSWatchControllerExtension MSWatch_extn = new MSWatchControllerExtension(MSWatch);
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag1(),0);
        System.assertEquals(MSWatch_extn.getEmailAddFlag1(),0);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag1(),0);
        System.assertEquals(MSWatch_extn.getPassLogFlag1(),0);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag1(),0);
        System.assertEquals(MSWatch_extn.getCFMUserFlag1(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag1(),0);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag1(),0);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag1(),0);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag1(),0);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag1(),0);
        System.assertEquals(MSWatch_extn.getLNAlertIntListFlag1(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag1(),0);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag1(),0);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag1(),0);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag1(),0);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag1(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag1(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag1(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag1(),0);       
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag1(),0);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag1(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag1(),0);
        System.assertEquals(MSWatch_extn.getTrader2DispFlag(),1);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag1(),0);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag1(),0);
               
        
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag2(),0);
        System.assertEquals(MSWatch_extn.getEmailAddFlag2(),0);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag2(),0);
        System.assertEquals(MSWatch_extn.getPassLogFlag2(),0);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag2(),0);
        System.assertEquals(MSWatch_extn.getCFMUserFlag2(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag2(),0);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag2(),0);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag2(),0);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag2(),0);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag2(),0);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag2(),0);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag2(),0);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag2(),0);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag2(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag2(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag2(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag2(),0);        
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag2(),0);
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag2(),0);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag2(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag2(),0);
        System.assertEquals(MSWatch_extn.getTrader3DispFlag(),1);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag2(),0);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag2(),0);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag2(),0);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag2(),0);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag2(),0);
        
        
        
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag3(),0);
        System.assertEquals(MSWatch_extn.getEmailAddFlag3(),0);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag3(),0);
        System.assertEquals(MSWatch_extn.getPassLogFlag3(),0);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag3(),0);
        System.assertEquals(MSWatch_extn.getCFMUserFlag3(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag3(),0);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag3(),0);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag3(),0);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag3(),0);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag3(),0);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag3(),0);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag3(),0);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag3(),0);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag3(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag3(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag3(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag3(),0);        
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag3(),0);
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag3(),0);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag3(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag3(),0);
        System.assertEquals(MSWatch_extn.getTrader4DispFlag(),1);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag3(),0);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag3(),0);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag3(),0);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag3(),0);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag3(),0);
        
        
        
        System.assertEquals(MSWatch_extn.getCompSubIdFlag4(),0);
        System.assertEquals(MSWatch_extn.getEmailAddFlag4(),0);
        System.assertEquals(MSWatch_extn.getIMAOLAddFlag4(),0);
        System.assertEquals(MSWatch_extn.getPassLogFlag4(),0);
        System.assertEquals(MSWatch_extn.getBBIMAddFlag4(),0);
        System.assertEquals(MSWatch_extn.getCFMUserFlag4(),1);        
        System.assertEquals(MSWatch_extn.getNYAlertEmailFlag4(),0);
        System.assertEquals(MSWatch_extn.getNYAlertAOLIMFlag4(),0);
        System.assertEquals(MSWatch_extn.getNYAlertPPFlag4(),0);
        System.assertEquals(MSWatch_extn.getNYAlertBBFlag4(),0);
        System.assertEquals(MSWatch_extn.getNYAlertIntListFlag4(),0);
        System.assertEquals(MSWatch_extn.getLNAlertEmailFlag4(),0);        
        System.assertEquals(MSWatch_extn.getLNAlertAOLIMFlag4(),0);
        System.assertEquals(MSWatch_extn.getLNAlertPPFlag4(),0);
        System.assertEquals(MSWatch_extn.getLNAlertBBFlag4(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertEmailFlag4(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertPPFlag4(),0);
        System.assertEquals(MSWatch_extn.getAsiaAlertBBFlag4(),0);        
        System.assertEquals(MSWatch_extn.getAsiaAlertIntListFlag4(),0);
        System.assertEquals(MSWatch_extn.getNYAlertCFMUserFlag4(),0);
        System.assertEquals(MSWatch_extn.getLNAlertCFMUserFlag4(),1);
        System.assertEquals(MSWatch_extn.getAsiaAlertCFMUserFlag4(),0);
        System.assertEquals(MSWatch_extn.getSAAlertAOLIMFlag4(),0);
        System.assertEquals(MSWatch_extn.getSAAlertEmailFlag4(),0);
        System.assertEquals(MSWatch_extn.getSAAlertPPFlag4(),0);
        System.assertEquals(MSWatch_extn.getSAAlertBBFlag4(),0);
        System.assertEquals(MSWatch_extn.getSAAlertCFMUserFlag4(),0); 
        
    }      
 
 static testMethod void Page_Test_3()
     { 
       PageReference pageRef = Page.MS_Watch;
        Test.setCurrentPageReference(pageRef);   
        
        MS_Watch__c test_1 = new MS_Watch__c();
        ApexPages.StandardController MSWatch = new ApexPages.StandardController(test_1);
       
         try {
           
           insert test_1;
         }
         catch(Exception e)
         {
           
         }
         
         
         
          MS_Watch__c test_2 = new MS_Watch__c();
          test_2.Trade_Region__c = 'Pan-Asia';
          test_2.Add_Trador__c = true;
          test_2.Add_Trador_3__c = true;
          test_2.Add_Trador_4__c = true;
          //;TK_HK_FIX_BXS;TK_HK_FIX_DMA;TK_HK_FIX_SWAP;TK_HK_LIST;TK_HK_PASSPORT
          test_2.Send_alerts_via_R1__c = 'Bloomberg IM;Email;IM_AOL;Passport;CFM User only';
          test_2.Send_alerts_via_R2__c = 'Bloomberg IM;Email;IM_AOL;Passport;CFM User only';
          test_2.Send_alerts_via_R3__c = 'Bloomberg IM;Email;IM_AOL;Passport;CFM User only';
          test_2.Send_alerts_via_R4__c = 'Bloomberg IM;Email;IM_AOL;Passport;CFM User only';
          
          test_2.Condition_for_R1__c = 'NY_FIX_BROKER;NY_FIX_BXS;NY_FIX_DMA;NY_FIX_SWAPS;NY_PASSPORT;TK_HK_FIX_BXS;TK_HK_FIX_DMA;TK_HK_FIX_SWAP;TK_HK_LIST;TK_HK_PASSPORT;SA_FIX_BROKER;SA_FIX_BXS;SA_FIX_DMA;SA_FIX_SWAP;LN_FIX_BXS;LN_FIX_SWAPS;LN_PASSPORT;Interest List (US);Interest List (ASIA);Interest List (LN)';
          test_2.Condition_for_R2__c = 'NY_FIX_BROKER;NY_FIX_BXS;NY_FIX_DMA;NY_FIX_SWAPS;NY_PASSPORT;TK_HK_FIX_BXS;TK_HK_FIX_DMA;TK_HK_FIX_SWAP;TK_HK_LIST;TK_HK_PASSPORT;SA_FIX_BROKER;SA_FIX_BXS;SA_FIX_DMA;SA_FIX_SWAP;LN_FIX_BXS;LN_FIX_SWAPS;LN_PASSPORT;Interest List (US);Interest List (ASIA);Interest List (LN)';
          test_2.Condition_for_R3__c = 'NY_FIX_BROKER;NY_FIX_BXS;NY_FIX_DMA;NY_FIX_SWAPS;NY_PASSPORT;TK_HK_FIX_BXS;TK_HK_FIX_DMA;TK_HK_FIX_SWAP;TK_HK_LIST;TK_HK_PASSPORT;SA_FIX_BROKER;SA_FIX_BXS;SA_FIX_DMA;SA_FIX_SWAP;LN_FIX_BXS;LN_FIX_SWAPS;LN_PASSPORT;Interest List (US);Interest List (ASIA);Interest List (LN)';
          test_2.Condition_for_R4__c = 'NY_FIX_BROKER;NY_FIX_BXS;NY_FIX_DMA;NY_FIX_SWAPS;NY_PASSPORT;TK_HK_FIX_BXS;TK_HK_FIX_DMA;TK_HK_FIX_SWAP;TK_HK_LIST;TK_HK_PASSPORT;SA_FIX_BROKER;SA_FIX_BXS;SA_FIX_DMA;SA_FIX_SWAP;LN_FIX_BXS;LN_FIX_SWAPS;LN_PASSPORT;Interest List (US);Interest List (ASIA);Interest List (LN)';
          
         try{insert test_2;}
         catch(Exception e) {}
                          
           MS_Watch__c test_3 = new MS_Watch__c();
          test_3.Trade_Region__c = 'Pan-Asia';
          test_3.Add_Trador__c = true;
          test_3.Add_Trador_3__c = true;
          test_3.Add_Trador_4__c = true;
          test_3.Status__c = null;
         try{insert test_3;}
         catch(Exception e) {}
                         
         
     }
     
}