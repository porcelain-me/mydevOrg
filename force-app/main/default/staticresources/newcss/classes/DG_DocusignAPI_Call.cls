// 
// (c) 2014 Appirio, Inc. 
//
// Description : Controller of DG_DocusignAPI_Call page, used for enable batch job for creating bulk 
//                docusign envelop and calling docsuign API.
//
// 09 Jan 2014 Jitendra Kothari Original
//

public class DG_DocusignAPI_Call {
    //public String tempType {get;set;}
    public boolean isError {get;set;}
    public boolean isCompleted {get;set;}
    public Id sourceId {get;set;}
    public String sourceName{get;set;}
    
    public DG_DocusignAPI_Call(){
        if(ApexPages.currentPage().getParameters().get('sourceId') != NULL){
            this.sourceId = ApexPages.currentPage().getParameters().get('sourceId');
        }        
        this.isError = false;
        this.isCompleted = false;
    }
    
    public void initiateBatchProcess(){
        
        this.isError = false;
        this.isCompleted = false;
        set<Id> setTemplateIds = new set<Id>();
        for(List_Template__c listTemplate : DG_DataUtil.getListTemplate(this.sourceId)){
            setTemplateIds.add(listTemplate.Template__c);
        }
        Map<String, Attachment> nameToAttachmentMap = new Map<String, Attachment>();
        for(Attachment doc : DG_DataUtil.getTemplateAttachment(setTemplateIds)){
            if(!nameToAttachmentMap.containsKey(doc.parentId)){
                nameToAttachmentMap.put(doc.parentId, doc);
            }
        }
        List__c listDetail = DG_DataUtil.getListDetails(sourceId);
        if(listDetail.Is_Sent_For_Signature__c){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Already sent for signature.'));
            this.isError = true;
        }else if(nameToAttachmentMap.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No Documents found.'));
            this.isError = true;
        }else{
            /*
            if(DG_DataUtil.checkIfBatchIsAlreadySubmitted('DG_ValidateListEmployees')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Another instance of batch is already running. Please wait till it completes.'));
                this.isError = true;
                return;
            }   
            DG_ValidateListEmployees batch = new DG_ValidateListEmployees();
            if(!Test.isRunningTest()){
                Database.executeBatch(batch, 2000);
            }
            */
            id batchId = Database.executeBatch(new DG_DocusignSentForSignature(listDetail.id), 10); 
            listDetail.Signature_Submittor__c = Userinfo.getUserId();
            listDetail.DocuSign_Status__c = 'Ready';
            listDetail.Sent_For_Signature_Date__c = system.now();
            listDetail.Is_Sent_for_Signature__c = true;
            update listDetail;
            
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Your request has been submitted. You will recieve an email once completed.'));
            this.isCompleted = true;
        }    
    }
}