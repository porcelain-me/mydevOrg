global class FFAP_Future {
	@future
   	public static void doFFAPUpdates(String empId, String MSID, ID ffapId, String envelopeId, String emailAddress) { 
    	 
    	FFAP_Agreement__c faAgreement;
    	
    	if (ffapId != null)
    		faAgreement = [select id from FFAP_Agreement__c where id = :ffapId];
    	else{
    		faAgreement = new FFAP_Agreement__c();
    		faAgreement.employee__c = empId;
    	}
    		
    	faAgreement.Is_Commitment_Agreement_Generated__c = true;
        if(faAgreement.Id != null){ 
        	//store the comment envelope id on the ffap record
        	faAgreement.commitment_agreement_envelope_id__c = envelopeId;           
            update faAgreement;
        }else{
        	//store the comment envelope id on the ffap record
        	faAgreement.commitment_agreement_envelope_id__c = envelopeId; 
        	insert faAgreement;
        	if(envelopeId != null){
        		List<dsfs__DocuSign_Status__c> dsList = FFAP_DataUtil.getDocusignStatus(envelopeId);
        		if(!dsList.isEmpty()){
        			dsList[0].FFAP_Record__c = faAgreement.Id;
        			update dsList;
        		}
        	}
        	
        }
        
	}
	
	
	
	
}