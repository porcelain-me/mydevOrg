public with sharing class RIF_TemplateManagementController {
    
    private string TempId;
    private Map<String,String> srFields;
    private Map<String,Conga_Content_Management__c> actualContentMap;
    public List<congaContentWrapper> contentWrapper {get; set;}
    public string selectedTag {get; set;}
    public string tempName {get; set;}
    public string selectedTemplate {get; set;}
    public string selectedContent {get; set;}
    public Map<string,Schema.SobjectField> fieldResults;
    public string otherTags {get; set;}
    
    public string latestlink {get; set;}
    public List<selectoption> tempList {get; set;}
    Map<String,boolean> tempContentMap;
    public attachment NewAttachment {get; set;}
    
    public boolean showContentSection {get; set;}
    
    public pageReference attach(){        
        
        If(selectedTemplate != null && selectedTemplate.trim() != ''
                && NewAttachment != null && NewAttachment.body != null){
            NewAttachment.parentID = selectedTemplate;
            insert NewAttachment;
            NewAttachment = new Attachment();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                    'Template has been uploaded/replaced successfully.');
            ApexPages.addMessage(myMsg);
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please attach a template/document.');
            ApexPages.addMessage(myMsg);
        }
        return null;
        
    }
    
    public RIF_TemplateManagementController (){
        TempId = ApexPages.currentPage().getParameters().get('Id'); 
        fieldResults = Severance_And_Release__c.getSObjectType().getDescribe().fields.getMap();   
        showContentSection = false;  
        tempContentMap = new Map<String,boolean>();
        latestlink = '';
        tempList = new List<selectoption>();
        tempList.add(new selectoption('','---Select Template---'));
        NewAttachment = new Attachment();
        
        List<APXTConga4__Conga_Template__c> templates = [select id,name,Document_Name__c,
                        Is_this_having_content_management__c,Conga_Query__c,APXTConga4__Description__c,
                        APXTConga4__Name__c,APXTConga4__Template_Group__c,APXTConga4__Template_Type__c
                         from APXTConga4__Conga_Template__c where APXTConga4__Template_Group__c = 'RIF Template' AND 
                         (Is_this_having_content_management__c = true OR Is_Static_Document__c=true) order by APXTConga4__Name__c
                         //name
                          ];   
        if(templates != null && templates.size() >0){
            for(APXTConga4__Conga_Template__c t:templates){
                tempList.add(new selectoption(t.Id,t.APXTConga4__Name__c));
                tempContentMap.put(t.Id,t.Is_this_having_content_management__c);
            }
            //tempList.sort();
        }   
    }
    
    public class congaContentWrapper{      
        public Conga_Content_Management__c contentRecord {get; set;}
        
        public congaContentWrapper (){
            this.contentRecord=new Conga_Content_Management__c();
        }
    }
    
    public pageREference refreshtags(){
        return null;
    }
    
    public pagereference savecontent(){
        List<Conga_Content_Management__c> contents = new List<Conga_Content_Management__c>();
        
        if((selectedTemplate == null || selectedTemplate.trim() == '')
                     || (selectedContent == null || selectedContent.trim() == '') ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                            'Template, Contents are mandatory to save a content.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        if(contentWrapper != null && contentWrapper.size() >0){
            for(congaContentWrapper c:contentWrapper ){
                if(c.contentRecord != null && c.contentRecord.Conga_Content__c != null 
                                && c.contentRecord.Conga_Content__c != ''){
                    //c.contentRecord.Conga_Content__c=c.contentRecord.Conga_Content__c.replaceALL('"','\'\'');
                    //c.contentRecord.Conga_Content__c=c.contentRecord.Conga_Content__c.replaceALL('“','\'\'');
                    //c.contentRecord.Conga_Content__c=c.contentRecord.Conga_Content__c.replaceALL('”','\'\'');
                }
                contents.add(c.contentRecord);
            }
            upsert contents;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Content saved successfully.');
            ApexPages.addMessage(myMsg);
        }
        else{
            //No fields have been added to SR object..,
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'No custom fields have been created at SR object level associated for this Template Name.');
            ApexPages.addMessage(myMsg);
        }
        
        return null;
    }
    
    public pageReference refreshContents(){
        showContentSection = false;
        latestlink = '';
        //selectedContent=null;
        //selectedTag=null;
        
        if(selectedTemplate != null && selectedTemplate.trim() != ''){
            if(tempContentMap.containsKey(selectedTemplate) && tempContentMap.get(selectedTemplate)==true){
                showContentSection=true; 
            } 
            
        }
        return null;
    }
    
    public List<Attachment> getLatestLinkURL (){
        List<Attachment> attachList;
        if(selectedTemplate != null && selectedTemplate.trim() != ''){
            attachList = [select id,name,parentId,body,contentType,CreatedById,
                            CreatedDate,LastmodifiedDate,LastmodifiedBy.Name from attachment
                             where parentId = :selectedTemplate order By CreatedDate DESC Limit 10];    
        }
        return attachList;
    }
    
    public List<selectoption> getContents(){
        List<selectoption> contents = new List<selectoption>();
        contents.add(new selectoption('','----Select content---'));
        
        if(selectedTemplate != null && selectedTemplate.trim() != ''){
            List<APXTConga4__Conga_Template__c> temp = [select id,name,Conga_Query__c,Is_Static_Document__c,
                                Document_Name__c,Is_this_having_content_management__c,APXTConga4__Description__c,
                                APXTConga4__Name__c,APXTConga4__Template_Group__c,APXTConga4__Template_Type__c 
                                from APXTConga4__Conga_Template__c where Id=:selectedTemplate];
            if(temp != null && temp.size() ==1){  
                for(string f:FieldResults.keySet()){
                    String actualName = FieldResults.get(f).getDescribe().getName();
                    if(actualName != null && actualName.startsWithignoreCase(temp[0].Document_Name__c)
                                     && actualName.endsWith('__c')){
                        contents.add(new selectoption(FieldResults.get(f).getDescribe().getName(),
                        FieldResults.get(f).getDescribe().getLabel().replaceFirst(temp[0].Document_Name__c,
                                temp[0].APXTConga4__Name__c)));
                    }
                }
                if(contents.size() >0){
                    //contents.sort();
                }
            }           
        }
        
        return contents;
    }
    
    public List<selectoption> getsrTags(){
        List<selectoption> srTags = new List<selectoption>();
        srTags.add(new selectoption('','----Select Severance tags---'));
        for(string f:FieldResults.keySet()){
            srTags.add(new selectoption('{'+FieldResults.get(f).getDescribe().getName()+'}',
                    FieldResults.get(f).getDescribe().getLabel()));
        } 
        srTags.sort();
        return srTags;
    }
    
    public pageReference displayContent(){
        actualContentMap = new MAp<String,Conga_Content_Management__c>();
        contentWrapper = new List<congaContentWrapper>();
        
        if(selectedTemplate != null && selectedTemplate.trim() !='' && selectedContent != null && selectedContent.trim() != ''){
            List<Conga_Content_Management__c> CongaContentsRecords = [select id,name,Conga_Content__c,Conga_Template__c,
                        Content_Criteria__c,Conga_Template__r.Conga_Query__c,Conga_Template__r.APXTConga4__Name__c,
                        Conga_Template__r.APXTConga4__Template_Group__c,Conga_Template__r.APXTConga4__Template_Type__c
                         from Conga_Content_Management__c where Conga_Template__c = :selectedTemplate AND
                          name = :selectedContent.removeEnd('__c')]; 
            
            if(CongaContentsRecords != null && CongaContentsRecords.size() > 0){
                for(Conga_Content_Management__c c:CongaContentsRecords ){
                    actualContentMap.put(c.name,c);
                }
            }  
            
            system.debug('************actualContentMap'+actualContentMap);
            
            congaContentWrapper conga=new congaContentWrapper();
            conga.contentRecord.name = FieldResults.get(selectedContent).getDescribe().getName().removeEnd('__c');
            conga.contentRecord.Content_Criteria__c = FieldResults.get(selectedContent).getDescribe().getInlineHelpText();
            if(actualContentMap.containsKey(conga.contentRecord.name)){
                conga.contentRecord.Conga_Content__c = actualContentMap.get(conga.contentRecord.name).Conga_Content__c;
                conga.contentRecord.ID = actualContentMap.get(conga.contentRecord.name).Id;
            }
            conga.contentRecord.Conga_Template__c = selectedTemplate ;
            contentWrapper.add(conga);
            
            if(contentWrapper.size() == 0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                        'No custom fields have been created at SR object level associated for this Template Name.');
                ApexPages.addMessage(myMsg);
            }
        }
        
        
        return null;
    }
    
    public List<selectoption> getotherTagsList(){
        List<selectoption> otherTags = new List<selectoption>();
        otherTags.add(new selectoption('','----Select Other tags---'));
        otherTags.add(new selectoption('{TODAY}','Date-TODAY'));
        otherTags.add(new selectoption('{NOW}','Datetime-TODAY')); 
        //otherTags.add(new selectoption('{CLAUSE}','Clause'));     
        
        return otherTags;
    }
}