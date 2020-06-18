public class SfdcZipSampleController {
    
    public String zipFileName {get; set;}
    public String zipContent {get; set;}
    public Integer pageNumber{get;set;}
    public Integer pageSize{get;set;}
    public Integer totalNoOfRecs{get;set;}
    public Integer noOfPages{get;set;}
    private String baseQuery ='select Id, ParentId, Name, ContentType, BodyLength from Attachment where name like \'cc_%\' order by createddate desc';
    public List<Attachment> Attachments{get;set;}
    public SfdcZipSampleController()
    {
        pageSize = 10;
        pageNumber=0;
        totalNoOfRecs =[select count() from Attachment where name like 'cc_%' ];
       getInitialAccountSet();
    }
    public PageReference getInitialAccountSet()
    {
         pageNumber = 0;
        noOfPages = totalNoOfRecs/pageSize;
        
        if (Math.mod(totalNoOfRecs, pageSize) > 0)
            noOfPages++;
        
         Attachments=  Database.query(baseQuery +' limit '+pageSize);
              
        return null;
    }
    public PageReference next(){
        pageNumber++; 
        
        queryAccounts();
        return null;
    }
    
     public PageReference previous(){
        pageNumber--;
        if (pageNumber < 0)
            return null;
        
        queryAccounts();
        return null;
    }
    
    private void queryAccounts()
    {
        Integer offset = pageNumber * pageSize;    
        String query = baseQuery + ' limit '+pageSize +' offset '+ offset;
        System.debug('Query is'+query);
       
            Attachments = Database.query(query);
        
         
    }
    
    public PageReference uploadZip() {
        if (String.isEmpty(zipFileName) ||
            String.isBlank(zipFileName)) {
                zipFileName = 'my_zip.zip';
            }
        else {
            zipFileName.replace('.', '');
            zipFileName += '.zip';
        }
        
        Document doc = new Document();
        doc.Name = zipFileName;
        doc.ContentType = 'application/zip';
        doc.FolderId = UserInfo.getUserId();
        doc.Body = EncodingUtil.base64Decode(zipContent);
        
        insert doc;
        
        this.zipFileName = null;
        this.zipContent = null;
        
        PageReference pageRef = new PageReference('/' + doc.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    /*public List<Attachment> getAttachments() {
        return [select Id, ParentId, Name, ContentType, BodyLength
                from Attachment where   name like 'cc_%'   order by createddate desc limit 100 offset 0
               ];
        //  return (List<Attachment>)con.getrecords();
    }*/
    
    @RemoteAction
    public static AttachmentWrapper getAttachment(String attId) {
        
        Attachment att = [select Id, parentId ,Name, ContentType, Body
                          from Attachment
                          where Id = :attId ];
        
        AttachmentWrapper attWrapper = new AttachmentWrapper();
        attWrapper.attEncodedBody = EncodingUtil.base64Encode(att.body);
        attWrapper.attName = att.parentId+'_'+att.Id+'_'+att.Name;
        //attWrapper.parentId1= att.ParentId;
        return attWrapper;
    }
    
    public class AttachmentWrapper {
        public String attEncodedBody {get; set;}
        public String attName {get; set;}
        //public String parentId1{get;set;}
    }
}