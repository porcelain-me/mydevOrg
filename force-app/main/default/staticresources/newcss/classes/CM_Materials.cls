// 
//  09/20/2011 UV: ADDED ORIGINAL 
//                 Component class for CM_Materials apex component.
//  11/01/2011 UV: modified name of AttachmentWrapper using lastIndexOf instead of indexOf (line #46)
//  11/08/2011 UV : Removed all queries to CM_CampaignDataUtil class.
public with sharing class CM_Materials {
    // public properties
    public String campaignId{get;set;}
    public Integer showCount{get;set;}
    public list<AttachmentWrapper> attachmentList{get;set;}
    public list<AttachmentWrapper> allAttachmentList{get;set;}    
    public boolean initializeComponent{get{ init();return true;}set;}
    public Integer ATTACHMENT_LENGTH{get{return CM_DataUtil_WS.ATTACHMENT_LENGTH;}}
    public CM_Materials() {
         // constructor
         attachmentList = new List<AttachmentWrapper>();
       allAttachmentList = new list<AttachmentWrapper>();
    }// end of constructor CampaignAttachments()
    
    public void init(){
        // This function is required to initialize with the assigned properties as constructor does not know the assigned properties
            System.debug('_____parent_________' + campaignId);
            // get the short list of materials according to showCount
        attachmentList = new List<AttachmentWrapper>();
        allAttachmentList = new list<AttachmentWrapper>();
        
        // RJ: NO NEED TO DO QUERY TWO TIMES
        List<Attachment> attachList = CM_CampaignDataUtil.getCampaignMaterials(campaignId, showCount);
        for(Attachment attach : attachList){
          attachmentList.add(new AttachmentWrapper(attach));
        }
        // get all materials 
        //Integer index = 1;
        List<Attachment> allAttachmentsList = CM_CampaignDataUtil.getCampaignMaterials(campaignId, null);
        for(Attachment attach : allAttachmentsList){
            //if(index < showCount){
            //  attachmentList.add(new AttachmentWrapper(attach));
            //}
            allAttachmentList.add(new AttachmentWrapper(attach));
            //index++;
        }
    }
    
    public class AttachmentWrapper{
        public string Name{get;set;}
        public Attachment attach{get;set;}
        public AttachmentWrapper(Attachment attach){
            this.attach = attach;
            this.Name = attach.Name.lastIndexOf('.') <> -1 ? attach.Name.substring(0, attach.Name.lastIndexOf('.')) : attach.Name;
        }
    }    
   
}