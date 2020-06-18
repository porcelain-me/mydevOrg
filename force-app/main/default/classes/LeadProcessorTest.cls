@isTest
private class LeadProcessorTest {
    @testSetup

    static void setup() {

        List<Lead> leads = new List<Lead>();
   for (Integer i=0;i<200;i++) {

            leads.add(new Lead(LastName='surya',
        Company='Company',
        Status='Closed-Converted'+i, 

                LeadSource='Dreamforce'));}
        insert leads;
    }
     static testmethod void test() {        
        Test.startTest();
        LeadProcessor uca = new LeadProcessor();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
 

        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Lead where LeadSource='Dreamforce']);

    }
   
    }