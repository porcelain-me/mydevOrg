public class RIF_UpdateSeveranceAndRelease_Test {

    public Severance_And_Release__c srRecord {get;set;}
    private string CALCULATE_AND_RETAIN_MANUAL_CHANGES = 'Calculate And Retain Manual Changes';
    
    public RIF_UpdateSeveranceAndRelease_Test (ApexPages.StandardController std){
        srRecord = RIF_DataUtil.getSeveranceAndReleaseRecord(std.getId()); 
    }
    
    public PageReference save(){
        
        //Added by kumaresan related to ststus and communication cehcklist..,
        if(srRecord != null && srRecord.Status__c !='Communicated To'){
            srRecord.Communicated__c=false;
            srRecord.Communicated_Date__c=null;
            srRecord.Communicated_Details_of_Package__c=false;
            srRecord.Package_Receipt_Date__c=null;
            srRecord.Release_Returned__c=false;
            srRecord.Release_Returned_Date__c=null;
            srRecord.Work_Requirement_for_Severance__c=false;
            srRecord.Is_termination_related_to_Project__c=false;            
        }
        
        list<ApexPages.Message> pageMessage = RIF_DataUtil.upsertResult(new list<Severance_And_Release__c>{srRecord}); 
        system.debug('errormsg: '+pageMessage);
        if(!pageMessage.isEmpty()){
            ApexPages.getMessages().clear();
            for(ApexPages.Message msg : pageMessage){
                ApexPages.addMessage(msg);
            } 
            return null;
        }
        return new PageReference('/'+srRecord.Id);
    }
    
    public pagereference StatusChangeFunction(){
        
        return null;
    }
}