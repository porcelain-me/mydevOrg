// 07/12/2013 RJ: Original 
//    A scheduled batch job which scans all of employee records and collects distinct code value based on each of org department fields 
//    (Super Division, Division, Super Department, Department, Sub Department, Sub Department 2, Cost Center). 
//    Map distinct value to Org_Codes__c.Code__c and org department label to Org_Codes__c.Code_Type__c 
//    (eg Super Division, Division, Super Department, Department, Sub Department, Sub Department 2, Cost Center). 
//
//    NOTE: This batch job should be scheduled to run daily.   
//
//
//

  global class RIF_BatchClassForOrgCodesCreation implements Database.Batchable<SObject>, System.Schedulable {
  public static final string QUERY = 'Select Super_Division__c, Super_Division_Dsc_Org__c, Super_Depart_Org__c, Super_Depart_Dsc_Org__c, Subdept_Org__c, Subdept_Dsc_Org__c, Sub_Depart2_Org__c, Sub_Depart2_Dsc_Org__c, Division_Org__c, Division_Dsc_Org__c, Dept_Org__c, Dept_Dsc_Org__c, Cost_Center__c, Cost_Center_Desc__c From Employee__c';
  public static final Map<String, String> FIELDNAME_CODETYPE_MAP = new Map<String,String>{
																			  	     'Super_Division__c'=> 'Super Division'
																			  	    ,'Super_Depart_Org__c' =>'Super Department'
																			  	    ,'Subdept_Org__c' => 'Sub Department'
																			  	    ,'Division_Org__c' => 'Division'
																			  	    ,'Dept_Org__c' => 'Department'
																			  	    ,'Sub_Depart2_Org__c' => 'Sub Department 2'
																			  	    ,'Cost_Center__c' => 'Cost Center'
																			  	    }; 
  public static final map<String, String> FIELDNAME_DESCRIPTIONFIELDNAME_MAP = new Map<String, String>{
  																					'Super_Division__c'=> 'Super_Division_Dsc_Org__c'
																			  	    ,'Super_Depart_Org__c' =>'Super_Depart_Dsc_Org__c'
																			  	    ,'Subdept_Org__c' => 'Subdept_Dsc_Org__c'
																			  	    ,'Division_Org__c' => 'Division_Dsc_Org__c'
																			  	    ,'Dept_Org__c' => 'Dept_Dsc_Org__c'
																			  	    ,'Sub_Depart2_Org__c' => 'Sub_Depart2_Dsc_Org__c'
																			  	    ,'Cost_Center__c' => 'Cost_Center_Desc__c'
																			  	    }; 
  
  public static final string ORG_CODENAME_TEMPLATE = '{Code} - {Description}'; 
																			  	    
  	
  global Database.QueryLocator start(Database.BatchableContext c) {    
    return Database.getQueryLocator(QUERY);        
  }
  
  global void execute(Database.BatchableContext c, List<Sobject> objects) {
  	Map<String, Org_Codes__c> orgCodesMap = new Map<String, Org_Codes__c>();
  	
  	
  	// create a map of unique org codes
    for (SObject s : objects) {
      for(String field : FIELDNAME_CODETYPE_MAP.keyset()){
      	String code = (s.get(field) <> null ? (String)s.get(field) : '');
      	String description = s.get(FIELDNAME_DESCRIPTIONFIELDNAME_MAP.get(field)) <> null ? (String)s.get(FIELDNAME_DESCRIPTIONFIELDNAME_MAP.get(field)) : '';
      	if(code <> '' && description <> ''){
      		String codeType = FIELDNAME_CODETYPE_MAP.get(field);
	        String key = ORG_CODENAME_TEMPLATE.replace('{Code}', code).replace('{Description}', description);
	        if(!orgCodesMap.containsKey(key)){
	           orgCodesMap.put(key, new Org_Codes__c(Code__c = code, Code_Type__c = codeType, Description__c = description));
	        }
      	}
      }
    }
    
    // check if these org codes already exists or not, if exist then leave those, if not then create ones.
    if(!orgCodesMap.isEmpty()){
    	List<Org_Codes__c> existingOrgCodes = [Select name from Org_Codes__c where name in : orgCodesMap.keyset()];    	
    	for(Org_Codes__c orgCode : existingOrgCodes){
    		if(orgCodesMap.containsKey(orgCode.name)){orgCodesMap.remove(orgCode.name);}
    	}
    	
    	if(orgCodesMap.size() > 0){
    		insert orgCodesMap.values();
    	}
    }
    
    
  }
  
  global void finish(Database.BatchableContext c) {
  }
   /*** SCHEDULEABLE INTERFACE Methods ***/
  
  global void execute(SchedulableContext sc) {
        id batchId = Database.executeBatch(new RIF_BatchClassForOrgCodesCreation(), 2000);
        System.debug('\n\n==> batchId = ' + batchId); 
  }
  
}