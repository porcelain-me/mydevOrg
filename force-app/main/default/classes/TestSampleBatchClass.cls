@isTest
private class TestSampleBatchClass {

static testmethod void test() {

// Create test accounts to be updated
// by the batch job.
Account[] accList = new List<Account>();
for (Integer i=0;i<200;i++) {
Account m = new Account(Name = 'Account ' + i);
accList.add(m);
}
insert accList;

Test.startTest();
SampleBatchClass bc = new SampleBatchClass();
Database.executeBatch(bc);
Test.stopTest();

// Verify accounts updated
Account[] accUpdatedList = [SELECT Id,Name FROM Account];
    
    for(Account ac:accUpdatedList){
     System.assert(ac.Name.Contains('Delhi'));   
    }

}
}