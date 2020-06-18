@isTest(SeeAllData=true)
private class RIF_AccrualInformationtest
{

    
    static testMethod void myTest() {
        test.startTest();
        
        /********Insert Accrual Information********/
            Accrual_Information__c ai = RIF_TestClassUtilities.createTestAccrualInfo('123#1','Abhijeet');
            
        test.stopTest();
        
      
    }
    
}