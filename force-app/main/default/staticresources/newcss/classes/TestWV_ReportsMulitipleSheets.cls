@isTest
private class TestWV_ReportsMulitipleSheets
{
    static testMethod void myTest() {
        scheme__c schemeObject= new scheme__c(name='phone bill');
        insert schemeObject;
        Input_Controls_Mapping__c ipControlMappingObject= new Input_Controls_Mapping__c(name='test 1',scheme__c=schemeObject.id,Input_Control_Type__c='List Capture',order__c=5);
        insert ipControlMappingObject;
        Input_Controls_Mapping__c ipControlMappingObject2= new Input_Controls_Mapping__c(name='test 1',scheme__c=schemeObject.id,Input_Control_Type__c='Multi Value Option Capture',order__c=5);
        insert ipControlMappingObject2;
        PageReference WVElConsPage = Page.WV_ElectionConsolidatedReport;
        Test.setCurrentPage(WVElConsPage);

         // Put schemeId and enrolmentId into the current page Parameters
         ApexPages.currentPage().getParameters().put('id',schemeObject.Id);
        //ApexPages.currentPage().getParameters().put('eid',Opp.Id);
        
         WV_ReportsMulitipleSheets reportMSObj= new WV_ReportsMulitipleSheets();
        
        // Creating Enrollment period record for covering the multirespponses inputs
         Enrollment_Period__c enrollObject= new Enrollment_Period__c(Compensation_Year__c='this',Start_Date__c=Datetime.now(),End_Date__c=Datetime.now().addDays(2),Override_Scheme__c=schemeObject.Id);
        insert enrollObject; 
        ApexPages.currentPage().getParameters().put('id',schemeObject.Id);
        ApexPages.currentPage().getParameters().put('eid',enrollObject.Id);
        WV_ReportsMulitipleSheets reportMSObj2= new WV_ReportsMulitipleSheets();
                
        // Start the test, this changes governor limit context to 
        // that of trigger rather than test. 
        test.startTest();
        
        // Insert the Deadlines records that cause the trigger to execute.
        //insert deadlines; 
        
       // Stop the test, this changes limit context back to test from trigger.
       test.stopTest();
        
       // Query the database for the newly inserted records.
       //List<Deadlines__c> insertedDeadlines = [SELECT id FROM Deadlines__c where name like 'testingDln%'];
        
    // Assert that the Description fields contains the proper value now.
    //for(Deadlines__c dl : insertedDeadlines )
      //System.assertEquals(37,insertedDeadlines.size());
  }
}