public class FFAP_DocusignAPI_Call {
    public String docType {get;set;}
    public boolean isError {get;set;}
    public Id sourceId {get;set;}
    public boolean isCompleted{get;set;}
    
    public FFAP_DocusignAPI_Call(){
        if(ApexPages.currentPage().getParameters().get('sourceId') != NULL){
            this.sourceId = ApexPages.currentPage().getParameters().get('sourceId');
        }       
        
        if(ApexPages.currentPage().getParameters().get('docType') != NULL){
            this.docType = ApexPages.currentPage().getParameters().get('docType');
        }        
        this.isError = false;
        this.isCompleted = false;
    }
     
    public void updateRecords(){
    	this.isError = false;
        this.isCompleted = false;
    	FFAP_DocusignAPI_Utilities utilities = new FFAP_DocusignAPI_Utilities(this.sourceId, this.docType);
        String resultString = utilities.checkDocumentsAndSendForSignature();
        if(resultString != DG_DataUtil.SUCCESS){
        	List<String> errors = resultString.split('\n');
            for(String error : errors){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            this.isError = true;
            this.isCompleted = true;
            return;
        }else{
            this.isCompleted = utilities.isCompleted;            
        }
        if(isCompleted){
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'All Documents are sent for Signature.'));
        }       
    }
}