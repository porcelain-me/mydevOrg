global class BatchEmailHandler implements Messaging.InboundEmailHandler {
    // Email Handler -- Receives incoming request for Batch Job to run & schedules
  // a job appropriately.
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();    
	    String command = email.subject; 
	    BatchManager.scheduleBatch(command);
	    return result;
    }
}