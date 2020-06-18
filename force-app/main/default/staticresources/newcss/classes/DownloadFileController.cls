public class DownloadFileController {
    public Integer randomInt{get;set;}
    public List<attachment> cs{get; set;}
    public DownloadFileController(){
        randomInt = getRandomNumber(10000);
        cs = new List<attachment>();
       for (attachment a : [SELECT Id, ParentId, Name, IsPrivate, ContentType, BodyLength,  OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Description from Attachment])
       {       
           cs.add(a);
       }
    }
    
    @RemoteAction
    public static List<AttachmentWrapper> getAttachments(String attachmentIdCSV){
        return wrapAttachments([SELECT Id,Name,Body FROM Attachment where id = '00Pf0000002Ylej']);
    }
    
    
    private static List<AttachmentWrapper> wrapAttachments(List<Attachment> attachments){
        List<AttachmentWrapper> wrappers = new List<AttachmentWrapper>();
        for(Attachment att : attachments){
            wrappers.add(new AttachmentWrapper(att));
        }
        
        return wrappers;
    }
    
    public class AttachmentWrapper{
        public Attachment AttachmentObj;
        public String base64Body;
        
        public AttachmentWrapper(Attachment AttachmentObj){
            this.AttachmentObj  = AttachmentObj;
            this.base64Body = EncodingUtil.base64Encode(AttachmentObj.Body);
            this.AttachmentObj.Body = NULL;
        }
    }
    
    /*
    *Random number generator to change the js function name if multiple components us
    ***/
    private Integer getRandomNumber(Integer size){
        Double d = Math.random() * size;
        return d.intValue();
    }
    
    
}