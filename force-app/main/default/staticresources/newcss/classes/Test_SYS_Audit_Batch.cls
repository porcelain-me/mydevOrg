@istest 
private class Test_SYS_Audit_Batch {

	static testMethod void test1(){	
		
		Test.startTest(); 
        SYS_Audit_Batch b = new SYS_Audit_Batch();
            
   	    ID batchprocessid = Database.executeBatch(b,200);
            
        Test.stopTest();
    } 
    
}