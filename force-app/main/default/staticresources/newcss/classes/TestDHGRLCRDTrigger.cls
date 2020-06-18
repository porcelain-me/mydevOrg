/************************************************************************************
*
* 6/6/14 - MRM Create test for dual employment triggers
*
**************************************************************************************/
@isTest
private class TestDHGRLCRDTrigger {

	static testmethod void test1(){
		 
        	Test.startTest();
        	
        	String uId = userinfo.getUserId();
        	
        	User u = [select email from User where id = :uId];
        	
        	Dual_Hat_Eligible_Config__c config = new Dual_Hat_Eligible_Config__c(Job_Code_Job__c = '600585', Job_Title_Dsc_Job__c = 'test'); 
        	insert config;
        	
        	Employee__c e = new Employee__c (name = 'Test User', emp_id__c = 'Test$', email__c=u.email, jobcode_job__c = '600585',status__c = 'Active');
        	        	        	insert e;
        	
        	
        	DH_GRLCRD__c x = new DH_GRLCRD__c (employee__c = e.id, Fingerprint_Date__c = date.today(), Status_Date__c = date.today(), status__c = 'CLER');
        	insert x;
        	
        	DH_GRLCRD__c x1 = new DH_GRLCRD__c (employee__c = e.id, Fingerprint_Date__c = date.today(), Status_Date__c = date.today(), status__c = 'COMP');
        	insert x1;
        	
        	Dual_Hat_Training_Status__c y = new Dual_Hat_Training_Status__c (employee__c = e.id, assigned_Date__C = date.today(), completion_date__c = date.today()	);
        	insert y;
        	
        	Employee__c ce =[select dual_hat_eligible__c from Employee__c where id = :e.id];
        	system.debug('******************************* ' + ce);
        	
        	Dual_Hat_Carco_Exceptions__c z = new Dual_Hat_Carco_Exceptions__c (
        	 employee__c = e.id
        	,name__c = 'GREAT'
			,status__c = 'y'
			,status_date__c = date.today()
			);
			insert z;
			
			
			z.Manually_Processed__c = true;
			update z;
			
        	Test.StopTest();
     
    }
    
    
}