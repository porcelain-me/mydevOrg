global class FFAP_Email_Handler implements Messaging.InboundEmailHandler {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {      	
  		return sentCommitmentAgreementForSignature(email.subject);
	} 
	public Messaging.InboundEmailResult sentCommitmentAgreementForSignature(String subject){
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		if(subject != null && subject.startsWith(FFAP_DataUtil.EMAIL_SUBJECT_START)){           
            system.debug('------------------' + subject);
            String empId = subject.trim().replaceAll(FFAP_DataUtil.EMAIL_SUBJECT_START, '');
            system.debug('------------------' + empId);
            FFAP_DocusignAPI_AutoUtilities utilities = new FFAP_DocusignAPI_AutoUtilities(empId);
            String resultString = utilities.sentCommitmentAgreementForSignature(empid);
            if(resultString == FFAP_DataUtil.SUCCESS){
                result.success = true;
                result.message = 'Commitment Agreement Sent successfully.';
            }else{
                result.success = false;
                result.message = resultString;
            } 
        }else{
            result.success = false;
            result.message = 'Email Subject is not correct.';
        }
        return result;
	}
}