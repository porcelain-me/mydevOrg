@isTest
private class TestGPSubmitInvoice {

	static testmethod void test1(){
		
		TestGPData.createData(); 
		
		Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'Budapest'];
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Test.startTest();
		
		
		
      	
		PageReference pageRef = Page.GP_SubmitInvoiceBatch;
		Test.setCurrentPage(pageRef);
        
		ApexPages.StandardController c = new ApexPages.StandardController(reg);
                
        GP_SubmitInvoiceController s = new GP_SubmitInvoiceController(c);
        
        s.submit();
		s.processDisputes();	  
		s.submitDisputes(); 
		s.status();    
        s.exit();
        
        Test.stopTest(); 
	}
	
	static testmethod void test2(){
		
		TestGPData.createData(); 
		
		Parking_Lot_Region__c reg = [select id from Parking_Lot_Region__c where name = 'Budapest'];
		User u = [select id, emp_id__c from User where id = :Userinfo.getUserId()];
		Employee__c e = new Employee__c(first_name__c = 'Mark'
										,last_Name__c = 'Moser'
										,name = 'Mark Moser'
										,emp_id__c = '59JRB'
										,email__c = 'mark.moser@morganstanley.com'
										,Level_Dsc_Job__c = 'Contingent'
										);
		insert e;
		
		Test.startTest();
		
		
		
      	
		PageReference pageRef = Page.GP_SubmitInvoiceBatch;
		Test.setCurrentPage(pageRef);
        
		ApexPages.StandardController c = new ApexPages.StandardController(reg);
                
        GP_SubmitInvoiceController s = new GP_SubmitInvoiceController(c);
        
        
		s.submitDisputes(); 
		s.status();    
        s.exit();
        
        Test.stopTest(); 
	}
}