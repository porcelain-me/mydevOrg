public class testDynamicLimitUpdatePage{

    static testMethod void Page_Test_1()
    {
        PageReference pageRef = Page.Limit_Update;
        Test.setCurrentPageReference(pageRef);   
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'LimitUpdateMSET_Account__c', recordtypeid=recordtypeid.id);
        insert testacct;
        
        Limit_Update__c test_1 = new Limit_Update__c();
        ApexPages.StandardController LimitUpdate = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Asset_Class__c = 'Options; Options Strat';
        test_1.Limit_Type__c = 'CFM Aggregate limit; Speedway limit';  
        
        test_1.cumQty_Options__c = 'Testing';
        test_1.cumValue_Options__c = 'Testing';
        test_1.cumExposure_Options__c = 'Testing';
        
        test_1.cumQty_OptionsStrat__c = 'Testing';        
        test_1.cumValue_OptionsStrat__c = 'Testing';        
        test_1.cumExposure_OptionsStrat__c = 'Testing';
        
        test_1.Supervisor_s_Approval__c = 'Testing';        
        test_1.Supervisor_s_Name_approving_transaction__c = 'Testing';        
        test_1.Reason_for_Change__c = '0 = Standard starter or experienced bucket';
        
        test_1.Speedway_address__c = 'Testing';
        test_1.Min_qty__c = 'Testing';
        test_1.Max_qty_max_shres_per_order__c = 'Testing';              
        test_1.Value__c = 'Testing';        
        test_1.Liquidity__c = 'Testing';        
        test_1.Max_of_rejects__c = 'Testing';
        test_1.of_requests_new_replace_per_second__c = 'Testing';        
        test_1.Reject_on_open_on_close_mkt_orders__c = 'on';        
        test_1.Reject_ISO_orders__c = 'on';
        test_1.Reject_Imbalance_after_NYSE_auction__c = 'on';        
        test_1.Reject_Short_Sale_No_Locate_Source__c = 'on';
        test_1.Update_Type__c = 'Permanent';
        
        insert test_1;
        
        LimitUpdateControllerExtension LimitUpdate_extn = new LimitUpdateControllerExtension(LimitUpdate);
        
        System.assertEquals(LimitUpdate_extn.getAggregateLimitsFlag(),1);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag1(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag2(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag3(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag4(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag5(),0);        
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag6(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag7(),0);
        System.assertEquals(LimitUpdate_extn.getCashLimitFlag(),0);
        System.assertEquals(LimitUpdate_extn.getSpeedwayLimitFlag(),1);
        System.assertEquals(LimitUpdate_extn.getOptionsFlag(),1);
        System.assertEquals(LimitUpdate_extn.getOptionsStratFlag(),0); 
        
        LimitUpdate_extn.cloneForm();
        LimitUpdate_extn.getPageTitle();

        LimitUpdate_extn.refreshPage();
        LimitUpdate_extn.cloneAction();
    }    
    
    static testMethod void Page_Test_2()
    {
        PageReference pageRef = Page.Limit_Update;
        Test.setCurrentPageReference(pageRef);   
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'LimitUpdateMSET_Account__c', recordtypeid=recordtypeid.id);
        insert testacct;
        
        Limit_Update__c test_1 = new Limit_Update__c();
        ApexPages.StandardController LimitUpdate = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Asset_Class__c = 'Futures';
        test_1.Limit_Type__c = 'BIDS limit';  
        
        test_1.cumQty_Options__c = 'Testing';
        test_1.cumValue_Options__c = 'Testing';
        test_1.cumExposure_Options__c = 'Testing';
        
        test_1.cumQty_OptionsStrat__c = 'Testing';        
        test_1.cumValue_OptionsStrat__c = 'Testing';        
        test_1.cumExposure_OptionsStrat__c = 'Testing';
        
        test_1.Supervisor_s_Approval__c = 'Testing';        
        test_1.Supervisor_s_Name_approving_transaction__c = 'Testing';        
        test_1.Reason_for_Change__c = '0 = Standard starter or experienced bucket';
        
        test_1.Speedway_address__c = 'Testing';
        test_1.Min_qty__c = 'Testing';
        test_1.Max_qty_max_shres_per_order__c = 'Testing';              
        test_1.Value__c = 'Testing';        
        test_1.Liquidity__c = 'Testing';        
        test_1.Max_of_rejects__c = 'Testing';
        test_1.of_requests_new_replace_per_second__c = 'Testing';        
        test_1.Reject_on_open_on_close_mkt_orders__c = 'on';        
        test_1.Reject_ISO_orders__c = 'on';
        test_1.Reject_Imbalance_after_NYSE_auction__c = 'on';        
        test_1.Reject_Short_Sale_No_Locate_Source__c = 'on';
        test_1.Update_Type__c = 'Permanent';
        
        insert test_1;
        
        LimitUpdateControllerExtension LimitUpdate_extn = new LimitUpdateControllerExtension(LimitUpdate);
        
        System.assertEquals(LimitUpdate_extn.getAggregateLimitsFlag(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag1(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag2(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag3(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag4(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag5(),0);        
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag6(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag7(),0);
        System.assertEquals(LimitUpdate_extn.getCashLimitFlag(),0);
        System.assertEquals(LimitUpdate_extn.getSpeedwayLimitFlag(),0);
        System.assertEquals(LimitUpdate_extn.getOptionsFlag(),0);
        System.assertEquals(LimitUpdate_extn.getOptionsStratFlag(),0); 
        
        LimitUpdate_extn.cloneForm();
        LimitUpdate_extn.getPageTitle();

        LimitUpdate_extn.refreshPage();
        LimitUpdate_extn.cloneAction();
    }
    
    static testMethod void Page_Test_3()
    {
        PageReference pageRef = Page.Limit_Update;
        Test.setCurrentPageReference(pageRef);   
        recordtype recordtypeid=[Select Id,Developername from recordtype where DeveloperName='TNL'] ;
        MSET_Account__c testacct = new MSET_Account__c(name = 'LimitUpdateMSET_Account__c', recordtypeid=recordtypeid.id);
        insert testacct;
        
        Limit_Update__c test_1 = new Limit_Update__c();
        ApexPages.StandardController LimitUpdate = new ApexPages.StandardController(test_1);
        
        test_1.MSET_Account__c =  testacct.id;
        test_1.Requested_By__c = '00560000000nJIg';
        test_1.Asset_Class__c = 'Cash';
        test_1.Limit_Type__c = 'CFM single order limit';  
        
        test_1.Add_another_destination_ID_limit__c = true;
        test_1.Add_another_destination_ID_limit_2__c = true;
        test_1.Add_another_destination_ID_limit_3__c = true;
        
        test_1.Add_another_destination_ID_limit_4__c = true;        
        test_1.Add_another_destination_ID_limit_5__c = true;        
        test_1.Add_another_destination_ID_limit_6__c = true;
        
        test_1.Supervisor_s_Approval__c = 'Testing';        
        test_1.Supervisor_s_Name_approving_transaction__c = 'Testing';        
        test_1.Reason_for_Change__c = '0 = Standard starter or experienced bucket';
        
        test_1.Speedway_address__c = 'Testing';
        test_1.Min_qty__c = 'Testing';
        test_1.Max_qty_max_shres_per_order__c = 'Testing';              
        test_1.Value__c = 'Testing';        
        test_1.Liquidity__c = 'Testing';        
        test_1.Max_of_rejects__c = 'Testing';
        test_1.of_requests_new_replace_per_second__c = 'Testing';        
        test_1.Reject_on_open_on_close_mkt_orders__c = 'on';        
        test_1.Reject_ISO_orders__c = 'on';
        test_1.Reject_Imbalance_after_NYSE_auction__c = 'on';        
        test_1.Reject_Short_Sale_No_Locate_Source__c = 'on';
        test_1.Update_Type__c = 'Permanent';
        insert test_1;
        
        LimitUpdateControllerExtension LimitUpdate_extn = new LimitUpdateControllerExtension(LimitUpdate);
        
        System.assertEquals(LimitUpdate_extn.getAggregateLimitsFlag(),0);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag1(),1);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag2(),1);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag3(),1);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag4(),1);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag5(),1);        
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag6(),1);
        System.assertEquals(LimitUpdate_extn.getSingleOrderLimitFlag7(),1);
        System.assertEquals(LimitUpdate_extn.getCashLimitFlag(),1);
        System.assertEquals(LimitUpdate_extn.getSpeedwayLimitFlag(),0);
        System.assertEquals(LimitUpdate_extn.getOptionsFlag(),0);
        System.assertEquals(LimitUpdate_extn.getOptionsStratFlag(),0); 
        
        LimitUpdate_extn.cloneForm();
        LimitUpdate_extn.getPageTitle();

        LimitUpdate_extn.refreshPage();
        LimitUpdate_extn.cloneAction();
    }
    
      static testMethod void Page_Test_4()
    {
        PageReference pageRef = Page.Limit_Update;
        Test.setCurrentPageReference(pageRef);   
        
        
        Limit_Update__c test_1 = new Limit_Update__c();
        ApexPages.StandardController LimitUpdate = new ApexPages.StandardController(test_1);
        
       try{ 
       insert test_1;
       }
       catch(Exception e)
       {
        
       }

    }
}