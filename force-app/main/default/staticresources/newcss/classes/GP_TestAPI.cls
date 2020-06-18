global with sharing class GP_TestAPI {


	@RemoteAction
	global static String testAPI (String nbr){
		
		
		String test = JSON.serialize([select id, name from user  limit 1]);
		system.debug(test);
		
		
		return test;
		
	}
	
	global static String testAPINR (String nbr){
		
		
		String test = JSON.serialize([select id, name from user limit 1]);
		system.debug(test);
		
		
		return test;
		
	}
}