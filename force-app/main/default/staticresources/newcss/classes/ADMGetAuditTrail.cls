public class ADMGetAuditTrail {
 /*
 Don't forget!!
 Add your org as it's own endpoint so it can call itself!
 Setup->Security->Remote site settings
 EX: https://na15.salesforce.com
  
 */
 
  	public static void getTrail() {
		//get a session Id for all the API requests
		String sessionId = userInfo.getSessionId();   
		
		//===================================================================
		//Step 1: get the URL for the Setup Audit Trail .CSV file.  This is just because we need the CONFIRMATIONTOKEN (screen scrape!)
		Http http = new Http();
		HttpRequest req = new HttpRequest();
		
		req.getCompressed();
		String  endPoint = 'https://cs16.salesforce.com';
		
		req.setEndpoint(endPoint+'/setup/org/orgsetupaudit.jsp');
		req.setMethod('GET');	 
		 
		req.setHeader('Cookie','sid='+sessionId);
		HTTPResponse res = new HTTPResponse(); 
		
		String viewAuditPage;
		//if (Test.isRunningTest()) {
		//	viewAuditPage = getDummyPage();
		//} else {			
			res = http.send(req);
			viewAuditPage = res.getBody();
		//}
		
		//parse out just the URL we want from the full HTML source
		List<String> auditPageList = viewAuditPage.split('href="/servlet/servlet.SetupAuditTrail', 2);
		String csvURL = '/servlet/servlet.SetupAuditTrail' + auditPageList[1].split('"', 2)[0];
		csvURL = csvURL.replace('&amp;', '&');
		
		
		
		//===================================================================
		//Step 2: get the csv file		
		http = new Http();
		req = new HttpRequest();
		req.setEndpoint(endpoint+csvURL);
		req.setMethod('GET');
		req.setHeader('Cookie','sid='+sessionId); 
		req.setCompressed(true);
		req.setTimeout(120000);

		String csvContent; 
		Boolean limitHit = false;
		//if (Test.isRunningTest()) {
		//	csvContent = getDummyCSV();
		//} else {
			try{
				res = http.send(req);
			}
			catch (Exception e){
				system.debug('**** in catch ****');
				csvContent = res.getBody();
				system.debug('csvContent' + csvContent);
				limitHit = true;
			}
		//}
		
		//trim off the existing header row, and replace it with one that has the correct fieldnames.		
		csvContent = csvContent.removeStart('Date,User,Action,Section,Delegate User\n');
		csvContent = 'Date_String__c,Username__c,Action__c,Section__c,Delegate_User__c\n' + csvContent; 
		
		while (limitHit){
			try{
				res = http.send(req);
				limitHit = false;
			}
			catch (Exception e){
				csvContent += res.getBody();
				limitHit = true;
				system.debug('Size is:' + csvContent.length());
			}
		}
		
		Blob csvBlob = Blob.valueOf(csvContent);
		
		
		
	}
	
		
	//===================================================================
	//dummy http responses for testing
	public static String getDummyPage() {
		return
		'<a href="/servlet/servlet.SetupAuditTrail?id=00Di00000001111&amp;_CONFIRMATIONTOKEN=28907nr89nd2589.2895724758d8937nd9wfushffsdfjk.skjfhsjkfhskdfh8937nxtr389nu.248907n528947n589347n5c9">';		
	}	

	public static String getDummyCSV() {
		return
		'Date,User,Action,Section,Delegate User\n'+
		'"10/5/2013 10:11:56 AM PDT","usergroup@danpeter.com","Changed AuditTrailImporter Apex Class code","Apex Class",""\n'+
		'"10/5/2013 10:11:26 AM PDT","usergroup@danpeter.com","Changed AuditTrailImporter Apex Class code","Apex Class",""\n';
	}

	


}