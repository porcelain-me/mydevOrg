@isTest
private class TestCampaignArchiveDiscovery {
    
    public static Campaign__c  c;
    
    private static void createCampaign() {
  
        T1C_CustomSettingsManager.createChatterSetting();
        T1C_CustomSettingsManager.setAllTriggerOn();
      
        c = new Campaign__c ();
        c.Name = 'test Campaign' ;
        c.External_Id__c = 'test id' ;
        c.Region__c = 'Global';
        c.Status__c = 'Active';
        insert c ;
    }
    static testMethod void testCampaignCreate() {
        //TestClassUtilities.setAllTriggerOn();
        
        Test.startTest() ;
        createCampaign() ;
        test.stopTest();
        
        List<RFC2822_Archive__c> rfcList = [Select Id from RFC2822_Archive__c where sourceId__c = :c.Id] ;
        System.assertEquals(1,rfcList.size());
        
            
    }
    static testMethod void testCampaignUpdate() {
        createCampaign() ;
        Test.startTest() ;
        
        c.Campaign_Summary__c = 'test summary';
        c.Start_Date__c = date.today() ;
        c.End_Date__c = date.today().adddays(2);
        update c;
        test.stopTest();
        List<RFC2822_Archive__c> rfcList1 = [Select Id from RFC2822_Archive__c where sourceId__c = :c.Id] ;
        System.assertEquals(true,rfcList1.size()>=1);
    }
        
        
        
}