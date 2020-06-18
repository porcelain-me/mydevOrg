global class ZZ_DownloadAttachmentsCONT {
    public static List<Attachment> allAttachList,finalList;
    
    public ZZ_DownloadAttachmentsCONT(){
        // CONSTRUCTOR
    }
    
    public PageReference startDownload(){
        return null;
    }
    
    @RemoteAction
    global static List<Attachment> allAttachments(){
        
        system.debug('Reached here !');
        allAttachList = [SELECT Id,Name,Body,ParentId FROM Attachment LIMIT 10];
        if(allAttachList != null && !allAttachList.isEmpty()){
            finalList = new List<Attachment>();
            for(Attachment att : allAttachList){
                String newBody = String.valueOf(att.Body);
                finalList.add(att);
            }
        }
        
        system.debug(' attachments -> ' + allAttachList);
        system.debug(' finalList -> ' + finalList);
        return finalList;
    }
}