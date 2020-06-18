public class RIF_AddAttachmentstoSNR {
    public  attachment newAttachment {get; set;}
    public string selectedTemplate {get; set;}
    public List<selectoption> tempList {get; set;}
    public Severance_and_Release__c snrRec {get;set;}   
    public string URLForPage{get;set;}
    public string delId {get;set;}
    public String delNoteId{get;set;}
 
    public RIF_AddAttachmentstoSNR(ApexPages.StandardController std)
    {
        newAttachment = new Attachment();
        tempList = new List<selectoption>();
        tempList.add(new selectoption('','---Select Attachment---'));
        tempList.add(new SelectOption('Release Agreement','Release Agreement'));
        tempList.add(new SelectOption('Separation Summary','Separation Summary'));
        snrRec = (Severance_and_Release__c)std.getRecord();
        URLForPage = ApexPages.currentPage().getHeaders().get('Host');
    }
    
    public List<WrapperAttNot> getlistWrapper() 
    {
        List<WrapperAttNot> listWrapper = new   List<WrapperAttNot> ();
        List<Note> noteList = [select Id,parentId,Title,LastmodifiedDate,
                               LastmodifiedBy.Name from note
                               where parentId = :snrRec.Id order By CreatedDate DESC];  
        if(noteList!=null && !noteList.isEmpty())
        {
            for(Note  usrnote :noteList )
            {
                listWrapper.add(new WrapperAttNot(null,usrnote,'Note'));
            }
        }
        List<Attachment> attachList= [select Id,name,parentId,
                                      CreatedDate,LastmodifiedDate,LastmodifiedBy.Name from attachment
                                      where parentId = :snrRec.Id order By CreatedDate DESC]; 
        if(attachList!=null && !attachList.isEmpty())
        {
            for(Attachment att : attachList)
            {
                listWrapper.add(new WrapperAttNot(att,null,'Attachment'));
            }
        }
        return listWrapper;
    }
    
    public PageReference attach()
    {
        
        if(selectedTemplate == null || selectedTemplate.trim() == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please select Attachment type');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if( newAttachment != null && newAttachment.body != null)
        {
            newAttachment.parentID = snrRec.Id;
            newAttachment.Description = selectedTemplate;
            insert newAttachment;
            newAttachment = new Attachment();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                            'Attachment has been uploaded successfully.');
            ApexPages.addMessage(myMsg);
            //PageReference pageRef = new PageReference('');
            //pageRef.setRedirect(true);
            return null;
            
        }
        
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please attach a document.');
            ApexPages.addMessage(myMsg);
            return null;    
        } 
    }
    
    
    public PageReference deleteRecord() {
        if(String.isNotBlank(delId))
        {
            List<Attachment> attList = [select id from Attachment where id =: delId];
            if(attList!=null && !attList.isEmpty()){
                delete attList[0];
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                'Attachment has been deleted successfully.');
                ApexPages.addMessage(myMsg);
            }
        }
        return null;
    }
    
    
    public PageReference deleteNote() {
        if(String.isNotBlank(delNoteId))
        {
            List<Note> noteList = [select id from note where id =: delNoteId];
            if(noteList!=null && !noteList.isEmpty()){
                delete noteList[0];
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                'Note has been deleted successfully.');
                ApexPages.addMessage(myMsg);
            }
        }
        return null;
    }
    
    public List<Note> getExstNotes (){
        List<Note> noteList;
        noteList = [select Id,parentId,Title,LastmodifiedDate,
                      LastmodifiedBy.Name from note
                      where parentId = :snrRec.Id order By CreatedDate DESC];  
        return noteList;
    }
    
    public List<Attachment> getExstAttachments (){
        List<Attachment> attachList;
        attachList = [select Id,name,parentId,
                      CreatedDate,LastmodifiedDate,LastmodifiedBy.Name from attachment
                      where parentId = :snrRec.Id order By CreatedDate DESC];  
        return attachList;
    }
    
    public class WrapperAttNot{
        public Attachment att {set;get;}
        public Note userNote {get;set;}
        public String type {get;set;}
        public WrapperAttNot(Attachment att,Note userNote,String type)
        {
            this.att= att;
            this.userNote = userNote;
            this.type = type;
        }
    }
    
}