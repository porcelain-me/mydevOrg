public without sharing class GP_Parking_Assignment {

	public Parking_Lot_Space_Assignment__c sa {get;set;} 
  	
  		
  	public GP_Parking_Assignment(ApexPages.StandardController controller) {
    	
    	sa = (Parking_Lot_Space_Assignment__c) controller.getRecord();
  	}
  	
  	public pageReference regenerate(){
  		
  		Map<String,String> saMap = new Map<String,String>();
    	saMap.put('sa', sa.id);
		saMap.put('session', userinfo.getSessionId());
		DG_DocUtilities.decFuture(saMap);
		
		List<dsfs__DocuSign_Status__c> docStatuses = [SELECT Id, dsfs__Envelope_Status__c, dsfs__Voided_Date_Time__c, dsfs__Voided_Reason__c FROM dsfs__DocuSign_Status__c WHERE Parking_Location_Space_Assignment__c	= :sa.Id AND dsfs__Envelope_Status__c != 'Voided'];
		for(dsfs__DocuSign_Status__c docStatus : docStatuses) {
			docStatus.dsfs__Envelope_Status__c = 'Voided';
			docStatus.dsfs__Voided_Date_Time__c = System.now();
			docStatus.dsfs__Voided_Reason__c = 'Declaration Regenerated';
		}
		update docStatuses;
  		
  		sa.Declaration_Form_Signed_New_Pass__c = false;
  		
  		update sa; 
  		
        PageReference p = new PageReference('/' + sa.id);
        p.setRedirect(true);
        return p;  
  		
  	}  
}