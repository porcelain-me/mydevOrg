@isTest(SeeAllData=false)                                     
private class FIXUpdateStatusForOldTicketsTest {    
	static testmethod void test() {
		Test.startTest();
		FIXUpdateStatusForOldTickets c = new FIXUpdateStatusForOldTickets();
		Database.executeBatch(c);
		Test.stopTest();           
		}
	}