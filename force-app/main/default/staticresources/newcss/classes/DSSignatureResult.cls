/*
 * DSSignatureResult
 *
 */
global with sharing class DSSignatureResult {
	public String envelopeId;
	public String status;
	public DateTime statusDateTime;
	public string uri;
	
	public static DSSignatureResult deserialize(HttpResponse response){
		return (DSSignatureResult)JSON.deserialize(response.getBody(), DSSignatureResult.class); 
	}
	
}