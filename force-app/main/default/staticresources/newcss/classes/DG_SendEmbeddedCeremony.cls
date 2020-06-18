/***********************************************************************
*  This class is used to start up the batch process to send emails for 
*  embedded signatures to all members of this list.
*
*  Change log:
*
*  4/1/2014 - MRM Created class
*
************************************************************************/
public class DG_SendEmbeddedCeremony {
    //public String tempType {get;set;}
    public boolean isError {get;set;}
    public boolean isCompleted {get;set;}
    public Id sourceId {get;set;}
    public String sourceName{get;set;}
    
    public DG_SendEmbeddedCeremony(){
        if(ApexPages.currentPage().getParameters().get('sourceId') != NULL){
            this.sourceId = ApexPages.currentPage().getParameters().get('sourceId');
        }        
        this.isError = false;
        this.isCompleted = false;
    }
    
    public void initiateBatchProcess(){
        
        this.isError = false;
        this.isCompleted = false;
       
        List__c listDetail = DG_DataUtil.getListDetails(sourceId);
        if(listDetail.DocuSign_Status__c != 'Complete'){
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Envelopes have not been created. Please create envelopes first!'));
        	this.isError = true;
        }else{ 
            if(DG_DataUtil.checkIfBatchIsAlreadySubmitted('DG_DocusignEmailEmbeddedCeremony')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Another instance of batch is already running. Please wait till it completes.'));
                this.isError = true; 
                return;
            }   
            //DG_DocusignEmailEmbeddedCeremony batch = new DG_DocusignEmailEmbeddedCeremony();
            // if(!Test.isRunningTest()){
            //     Database.executeBatch(batch, 1);
            //}
            listDetail.embedded_email_status__c = 'Ready';
          
            update listDetail;
            
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Your request has been submitted. You will recieve an email once completed.'));
            this.isCompleted = true; 
        }    
    }
}