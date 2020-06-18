global class SYS_Future {
	@future
   	public static void deleteAll (map<ID,String> deleteMap) { 
    	 
    	List<User_Registration__c> deleteList = new List<User_Registration__c>();
    	
    	deleteList = [select id from User_Registration__c where id in :deleteMap.keySet() ];
    	
    	delete deleteList;
        
	}
	
	
	
	
}