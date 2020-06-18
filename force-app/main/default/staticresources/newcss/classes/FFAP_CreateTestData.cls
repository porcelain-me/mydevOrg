global class FFAP_CreateTestData {
	webservice static string deleteTestData(string recordId){
	   Employee__c emp = FFAP_DataUtil.getEmployeeDetailsOnId(new Set<Id>{recordId})[0];
       System.debug(emp);
       Map<Id, FA_Account__c> faAcccounts = new Map<Id, FA_Account__c>();
       for(FA_Account_Association__c faTemp : FFAP_DataUtil.getFAAccAssociationListonOnEmpId(emp.Emp_Id__c)){            
            faAcccounts.put(faTemp.FA_Account__c, faTemp.FA_Account__r);
        }
        if(!faAcccounts.isEmpty()){
            delete faAcccounts.values();
        }
        return 'Test Data deleted.';
	}
	webservice static string createTestData(string recordId){
	   Employee__c emp = FFAP_DataUtil.getEmployeeDetailsOnId(new Set<Id>{recordId})[0];
	   System.debug(emp);
	   if(emp.DOH_Recent__c == null){
	   	emp.DOH_Recent__c = System.today().addYears(-5);
	   }
	   update emp;
	   FFAP_Agreement__c agreement = createAgreementIfNotExists(emp.Emp_Id__c, emp.Id);
	   Employee__c empTemp = createNewEmployeeIfNotExists();
	   
	   List<FA_Account__c> faList = new List<FA_Account__c>();
	   FA_Account__c fa;
	   Id activeRecordTypeId = FFAP_DataUtil.getFAAccountRecordTypeId(FFAP_DataUtil.ACTIVE_RECORDTYPE);
	   for(Integer counter = 1; counter < 11; counter ++){
	   	   fa = new FA_Account__c(Name = emp.Emp_ID__c + '100' + counter, RecordTypeId = activeRecordTypeId);
	   	   if(counter > 5){
	   	       fa.Type__c = FFAP_DataUtil.FA_JPN_TYPE;
	   	   }else{
	   	       fa.Type__c = FFAP_DataUtil.FA_Primary_TYPE;	
	   	   }	   	   
	   	   faList.add(fa);
	   }
	   insert faList;
	   List<FA_Account_Association__c> faAssocationList = new List<FA_Account_Association__c>();
       FA_Account_Association__c faAssocation;
	   for(FA_Account__c faTemp : faList){
	   	   faAssocation = new FA_Account_Association__c(Financial_Advisor__c = emp.Id, FA_Account__c = faTemp.Id);
	   	   if(faTemp.Type__c == FFAP_DataUtil.FA_Primary_TYPE){	  
	   	   	faAssocation.FA_Split_Percent__c = 100;     	
            faAssocationList.add(faAssocation);	       	
	   	   }else if(faTemp.Type__c == FFAP_DataUtil.FA_JPN_TYPE){
	   	   	faAssocation.FA_Split_Percent__c = 50;
            faAssocationList.add(faAssocation);
            faAssocationList.add(new FA_Account_Association__c(Financial_Advisor__c = empTemp.Id, FA_Split_Percent__c = 100 - faAssocation.FA_Split_Percent__c, FA_Account__c = faTemp.Id));            
	   	   }
	   }
	   insert faAssocationList;
	   return 'Test Data created.';
	}
	private static FFAP_Agreement__c createAgreementIfNotExists(string empId, Id recordId){
	   List<FFAP_Agreement__c> ffapAgreementList = FFAP_DataUtil.getAgreementDetailsOnAdvisorId(empId);
	   if(ffapAgreementList.isEmpty()){
	       	FFAP_Agreement__c agreement = new FFAP_Agreement__c(Employee__c = recordId);
	       	try{
	       		insert agreement;
	       	}catch(Exception ex){
	       		
	       	}
	       	return agreement;
	   }else{
           return ffapAgreementList.get(0);
	   }
	}
	private static Employee__c createNewEmployeeIfNotExists(){
		Employee__c emp = FFAP_DataUtil.getEmployeeDetailsOnEmpId('TSTWS001');
        if(emp == null){
         emp = new Employee__c(Name = 'Employee Created For testing', 
                                          emp_Id__c = 'TSTWS001', 
                                          Status__c = 'Active',
                                          First_Name__c = 'Employee',
                                          Last_Name__c = 'Created For testing',
                                          Financial_Advisor_Number__c = 'TSTWS001', 
                                          DOH_Recent__c = System.today().addYears(-5));
            insert emp;
            createAgreementIfNotExists(emp.Emp_Id__c, emp.Id);
        }
        return emp;
    }
}