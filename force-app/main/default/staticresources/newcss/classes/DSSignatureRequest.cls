/*
 * DSSignatureRequest.cls
 * 
 * Structured class passed to the DSClient.requestSignature() method.
 * Note: Currently does not support Tabs
 */
global with sharing class DSSignatureRequest {
    public DocumentSource docSource             = DocumentSource.TEMPLATE;
    public string emailSubject;
    public string emailBlurb;
    public string templateId;
    public boolean createDraftOnly              = false;
    public List<string> errors                  = new List<string>();
    
    public enum DocumentSource {TEMPLATE, DOCUMENT}
    
    public DSSignatureRequest(DocumentSource source){
        this.docSource = source;
    }
    
    public boolean isValid(){       
        this.errors.clear();
        if(this.emailSubject == null){
            this.errors.add('Missing emailSubject');
        }
        if(this.emailBlurb == null){
            this.errors.add('Missing emailBlurb');
        }
        
        return this.errors.size() == 0;
    }
    
    public JSONGenerator serialize(JSONGenerator gen){
        gen.writeStartObject();
        gen.writeStringField('emailSubject', this.emailSubject);
        gen.writeStringField('emailBlurb', this.emailBlurb);
        gen.writeStringField('status', (this.createDraftOnly ? 'created':'sent') );
        
        
        gen.writeEndObject();
        gen.close();
        return gen;
    }

}