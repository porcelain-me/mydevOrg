trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    
    BatchApexErrorEvent btchapexErrEvent = new BatchApexErrorEvent();
    BatchLeadConvertErrors__c btchleadCverterr =new BatchLeadConvertErrors__c();
    
  
   List<BatchLeadConvertErrors__c> lstbtchleadCverterr =new List<BatchLeadConvertErrors__c>();
   btchleadCverterr.AsyncApexJobId__c= btchapexErrEvent.AsyncApexJobId;
   btchleadCverterr.Records__c =btchapexErrEvent.JobScope;
   btchleadCverterr.StackTrace__c =btchapexErrEvent.StackTrace;
   lstbtchleadCverterr.add(btchleadCverterr);
   insert lstbtchleadCverterr;
   
}