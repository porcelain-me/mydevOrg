public with sharing class FFAP_DocusignRest_Call {
	public String accountId;
	
	public FFAP_DocusignRest_Call(){
		
		JSONGenerator gen = JSON.createGenerator(true);
 
		gen.writeStartObject();
		gen.writeStringField('Username','mmoser@redtailconsulting.biz');
   		gen.writeStringField('Password','mrm564700');
		gen.writeStringField('IntegratorKey','REDT-c0e9f412-549c-476f-9538-9d2fa070d24f');
		
	    gen.writeEndObject();
		
		// Get the JSON string.
		String jsonString = gen.getAsString();
		jsonString = jsonString.replace('\n','');
		
		system.debug('json is ============>' + jsonString);
		
		
        Http h = new Http();
        String endpoint = 'https://demo.docusign.net/restapi/v2/login_information';
        HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setEndpoint(endpoint);
		
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept', 'application/json');
	    req.setHeader('X-DocuSign-Authentication',jsonString);
		
		system.debug('Request is=====>' + req);

		HttpResponse response =h.send(req);

        System.debug('response header =>'+response.getStatus()+', Body=> '+response.getBody());


		/* Get the account id */
		JSONParser parser = JSON.createParser(response.getBody());

		while (parser.nextToken() != null) {

		    	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){

        			String fieldName = parser.getText();
	    			parser.nextToken();
	        	    String Value  = parser.getText();
					system.debug('field name =' + fieldName + ' value='+value);
				 }  
		}
	      


		 
         
	}

}