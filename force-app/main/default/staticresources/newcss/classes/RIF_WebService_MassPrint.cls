global class RIF_WebService_MassPrint{
    //variables
    
    public RIF_WebService_MassPrint(){  
        
    }
    
    webservice static RIF_WebService_MassPrint.sf[] getEncodedAttachments(ID projectID){
        //fetch the print config record for the logged in user related to the project
        RIF_Print_Project_Config__c printConfigRecord=[select id,name,Project__c,User__c,SRIDs__c,DocNames__c,Doc_Version__c from RIF_Print_Project_Config__c where Project__c=:projectID AND User__c=:UserInfo.getUserID() order by createdDate desc limit 1];
        //fetch all the severance & release corresponding to the project ID and print config record
        //Map <id,severance_and_release__C> severanceMap=new Map <id,severance_and_release__C>([select id, name from severance_and_release__c where project__c=:projectID]);
        Set <string> srIds=new Set <string> ();
        Set <string> selectedDocs = new  Set <string>();
        for(String srID: printConfigRecord.SRIDs__c.trim().split(';',-5)){
            srIds.add(srID);    
        } 
        
        //Initialize wrapper list
        List<sf> wrappers = new List<sf>();
        if(printConfigRecord.DocNames__c.contains('All')){
                selectedDocs=new set<String>{'Separation Summary','Exec comp overview','Important Contacts','Benefits Memo','Benefits FAQ','Age Disclosure','Release Agreement','Code of Conduct','LHH','LifeWorks','Exhibit A'};
        }
        //loop over the documents selected for printing
        for(String docName: printConfigRecord.DocNames__c.trim().split(';',-5)){
            //srIds.add(srID);
            selectedDocs.add(docName);   
        }
        
        //fetch attachments associated to the severance and releases underlying to the project
        
        for(Attachment att: [select id,name,body from attachment where parentID IN:srIds]){ 
            if(printConfigRecord.Doc_Version__c=='Draft'){
                if( (att.name.contains('Draft') && ( (att.name.contains('Release Agreement') && selectedDocs.contains('Release Agreement')) || (att.name.contains('Separation Summary') && selectedDocs.contains('Separation Summary')) || (att.name.contains('Exhibit A') && selectedDocs.contains('Exhibit A')) ) )){
                    wrappers.add(new sf(att.name,att.body)); 
                }  
                if(att.name.contains('Draft') && ( (selectedDocs.contains('Exec comp overview') && att.name.contains('Exec comp overview')) || (selectedDocs.contains('Important Contacts') && att.name.contains('Important Contacts')) || (selectedDocs.contains('Benefits Memo') && att.name.contains('Benefits Memo')) || (selectedDocs.contains('Benefits FAQ') && att.name.contains('Benefits FAQ')) || (selectedDocs.contains('Age Disclosure') && att.name.contains('Age Disclosure')) || (selectedDocs.contains('Code of Conduct') && att.name.contains('Code of Conduct')) || (selectedDocs.contains('LHH') && att.name.contains('LHH')) || (selectedDocs.contains('LifeWorks') && att.name.contains('LifeWorks')) ) ){
                    wrappers.add(new sf(att.name,att.body));
                }                                                
            }
            if(printConfigRecord.Doc_Version__c=='Final'){
                if(!att.name.contains('Draft') && ( (selectedDocs.contains('Release Agreement') && att.name.contains('Release Agreement')) || (selectedDocs.contains('Separation Summary') && att.name.contains('Separation Summary'))  || (selectedDocs.contains('Exhibit A') && att.name.contains('Exhibit A')) ) ){
                    wrappers.add(new sf(att.name,att.body));
                } 
                if( !att.name.contains('Draft') && ( (selectedDocs.contains('Exec comp overview') && att.name.contains('Exec comp overview')) || (selectedDocs.contains('Important Contacts') && att.name.contains('Important Contacts')) || (selectedDocs.contains('Benefits Memo') && att.name.contains('Benefits Memo')) || (selectedDocs.contains('Benefits FAQ') && att.name.contains('Benefits FAQ')) || (selectedDocs.contains('Age Disclosure') && att.name.contains('Age Disclosure')) || (selectedDocs.contains('Code of Conduct') && att.name.contains('Code of Conduct')) || (selectedDocs.contains('LHH') && att.name.contains('LHH')) || (selectedDocs.contains('LifeWorks') && att.name.contains('LifeWorks')) ) ){
                    wrappers.add(new sf(att.name,att.body));
                }                                                   
            }
            //wrappers.add(new sf(attach));
         
         }
         //system.debug('####return wrappers####'+wrappers);        
         return wrappers;
       
    
    }
    
    
    global class sf{
       //webservice Attachment AttachmentObj;
         
        webservice string type;
        webservice string ContentType;
        webservice String Name;
        webservice String Body;
        
        //public sf(Attachment AttachmentObj){
        public sf(String name, Blob body){
            //this.AttachmentObj  = AttachmentObj;
            this.type='Attachment';
            this.ContentType='text/plain';
            this.Name=name;
            this.Body = EncodingUtil.base64Encode(body); 
            //this.AttachmentObj.Body = NULL; 
        }
    }
      

}