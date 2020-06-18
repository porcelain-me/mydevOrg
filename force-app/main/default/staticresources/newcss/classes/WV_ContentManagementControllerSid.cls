public class WV_ContentManagementControllerSid {

    public string selectedSchemeId {get; set;}
    public string selectedContentType {get; set;}
    public string contentArea {get; set;}
    public string archivedContentArea {get; set;}
    public string employeeTags {get; set;}
    public Wav_Content__c content {get; set;}
    public boolean isCreated{get; set;}
    public boolean isNumberFieldDisabled{get; set;}
    public boolean IsDeleteButtonDisabled {get; set;}
    public boolean isDataNotSaved {get; set;}
    public string preContentType {get; set;}
    public boolean recentType {get; set;}
    public List<Wav_Content__c> wavPreviewContent;
    public List<Scheme__c> schemeRecord {get; set;}
    public boolean showTags {get; set;}    
    public string customPageMessage {get; set;}
    public final static string PAGE_ERROR=Label.WV_Exception_Admin;
    public string typeOfMessage {get; set;}
    public string currentPageURL {get; set;}
    public string OrgName {get; set;}    
    
    public List<selectoption> getContentTypes(){
        List<selectoption> Lst=new List<selectoption>();
        try{
            Lst.add(new selectoption('','---Select---'));
            List<Schema.PicklistEntry> pickListValues=WV_Utility1.getPickListValues('Wav_Content__c','Content_Type__c');
            if(pickListValues != null){
                for(Schema.PicklistEntry s:pickListValues){
                    Lst.add(new selectoption(s.getLabel(),s.getValue()));
                }
            }
        }
        Catch(Exception e){        
            system.debug('****Exception inside getContentTypes()'+e.getlinenumber()+'-'+e.getmessage()); 
        }        
        return Lst;    
    }
    
    public WV_ContentManagementControllerSid() {
        String Tags='';
        isCreated=false;
        isNumberFieldDisabled=false;
        IsDeleteButtonDisabled =true;
        preContentType='';
        string CustomTags='';
        showTags=false;        
        customPageMessage=null;
        
        try{
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String PageURL = ApexPages.currentPage().getUrl(); 
            currentPageURL = baseURL+PageURL;            
            OrgName=Label.ORG_ENVIRONMENT;  
            
            selectedSchemeId = ApexPages.Currentpage().getParameters().get('Id');
            if(selectedSchemeId != null && selectedSchemeId != ''){ 
                Tags='<b> Employee Tags:</b><br/><br/>';
                Tags=Tags+WV_Utility1.getEmployeeStaticTags();
                Tags=Tags+'<br/><br/>';
                CustomTags=WV_Utility1.getCustomDataFileTags(selectedSchemeId);
                if(CustomTags != null && CustomTags != ''){
                    Tags=Tags+'<b>More Tags:</b><br/><br/>';
                    Tags=Tags+CustomTags; 
                }       
                employeeTags=Tags;    
                recentType=false;
                schemeRecord = WV_Utility1.getSchemeDetails(selectedSchemeId);
            } 
        }
        Catch(Exception e){        
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside content management constructor'+e.getlinenumber()+'-'+e.getmessage()); 
        }
    }
    
    public PageReference recoveryStatus(){
        List<Wav_Content__c> Wavcontent;
        isDataNotSaved=false;
        recentType=false;
        showTags=false;
        customPageMessage=null;
        IsDeleteButtonDisabled=true;
        
        try{
            if(selectedSchemeId != null && selectedSchemeId != '' && selectedContentType != null && selectedContentType != ''){
                preContentType=selectedContentType;
                Wavcontent = WV_Utility1.getContentManagementData(selectedSchemeId,selectedContentType);
                if(selectedContentType=='Terms & Conditions' || selectedContentType=='Description' || selectedContentType=='Introduction' || selectedContentType == 'Links'){
                    if(Wavcontent != null && Wavcontent.size()==1){
                        contentArea=Wavcontent[0].Content__c;
                        archivedContentArea=Wavcontent[0].Content__c;
                        content=Wavcontent[0];
                        isCreated=true;
                        IsDeleteButtonDisabled=false;
                    }     
                    else{
                        content=new Wav_Content__c();
                        contentArea='';
                        archivedContentArea='';
                        isCreated=false;
                        IsDeleteButtonDisabled =true;
                    }
                    showTags=true;
                }
                else{
                    showTags=false;
                }   
                           
            }
            else{
                 preContentType='';
                 showTags=false;
                 contentArea='';
            }        
        }
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            showTags=false; 
            preContentType='';
            contentArea='';
            system.debug('****Exception inside recovery status'+e.getlinenumber()+'-'+e.getmessage());
            WV_Utility1.captureException('My Elections','Scheme Detail page->Content management tab-->recoveryStatus()','Exception Type : '+e.getTypeName()+'; <b>Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }
        return null;    
    }
    
    public PageReference Submit(){
        
        try{
            IsDeleteButtonDisabled=true;
            recentType=false;
            customPageMessage=null;            
           
            if( ( (selectedSchemeId == null || selectedSchemeId =='') && selectedContentType != null && selectedContentType != '') ){
                customPageMessage=Label.WV_Content_No_Scheme;
                typeOfMessage='Error';
                
                return null;         
            }
            else if(( selectedSchemeId != null && selectedSchemeId !='' && (selectedContentType == null || selectedContentType ==''))){
                customPageMessage=Label.WV_Content_No_ContentType;
                typeOfMessage='Error';
                return null;         
            }
            else if((selectedSchemeId == null || selectedSchemeId =='') && (selectedContentType == null || selectedContentType =='')){
                customPageMessage=Label.WV_Content_No_Scheme_ContentType;
                typeOfMessage='Error';
                return null;         
            }
            
            if(contentArea != null && contentArea.trim() !=''){
                //contentArea= contentArea.replaceAll('<p>&nbsp;</p>','');
                //contentArea= contentArea.replaceAll('<p><br></p>','');
                contentArea= contentArea.replaceAll(' &nbsp; ',' <SomeTextHere> ');
                contentArea= contentArea.replaceAll('<p>&nbsp;</p>',' <SomeTextHere1> ');
                contentArea= contentArea.replaceAll('&nbsp;',' ');
                contentArea= contentArea.replaceAll(' <SomeTextHere> ',' &nbsp; ');
                contentArea= contentArea.replaceAll('<SomeTextHere1>','<p>&nbsp;</p>');
            }
            
            if(contentArea == null || contentArea.trim() ==''){
                customPageMessage=Label.WV_Content_No_Content;
                typeOfMessage='Error';
                return null; 
            }
            else if(selectedContentType=='Introduction' && contentArea != null && contentArea.length() > 1000){
                customPageMessage=Label.WV_Content_more_Content;
                typeOfMessage='Error';
                return null;        
            }
            
            if(isCreated==true && content != null){
                Content.Content__c=contentArea;
                update Content;
                IsDeleteButtonDisabled=false;
                recentType=true;
                customPageMessage=selectedContentType+' '+Label.WV_Content_Succss_Updation;
                typeOfMessage='Info';
            }
            else if(isCreated==false && content != null){
                content.Content__c=contentArea;
                content.Content_Type__c=selectedContentType;
                content.Scheme__c=selectedSchemeId;  
                insert  content;  
                isCreated=true;
                IsDeleteButtonDisabled=false;
                recentType=true;
                customPageMessage=selectedContentType+' '+Label.WV_Content_Success_Creation;
                typeOfMessage='Info';
            } 
            if(schemeRecord != null && schemeRecord.size() >0 ){
                schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                schemeRecord[0].Last_updated_date__c=system.now();                
                update  schemeRecord[0];  
            }             
        }   
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside sumit'+e.getlinenumber()+'-'+e.getmessage());
            WV_Utility1.captureException('My Elections','Scheme Detail page->Content management tab-->submit()','Exception Type : '+e.getTypeName()+'; <b>Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }   
        return null;
    }
    
    public PageReference DeleteRecord(){
        try{
            customPageMessage=null;
            if(selectedContentType=='' || selectedContentType==null){
                customPageMessage=Label.WV_Content_No_ContentType;
                typeOfMessage='Error';
                return null;
            }
            List<Wav_Content__c> currentContentList;
            delete content;
            customPageMessage=selectedContentType+' '+Label.WV_Content_Success_Delete;
            typeOfMessage='Info';
            
            if(schemeRecord != null && schemeRecord.size() >0 ){
                schemeRecord[0].Last_updated_by__c=Userinfo.getuserId();
                schemeRecord[0].Last_updated_date__c=system.now();                
                update  schemeRecord[0];  
            } 
            
            selectedContentType='';
            showTags =false;
            contentArea =null;
            isCreated=false;
            IsDeleteButtonDisabled=true;            
        }   
        Catch(Exception e){
            customPageMessage=PAGE_ERROR;
            typeOfMessage='Error';
            system.debug('****Exception inside DeleteRecord'+e.getlinenumber()+'-'+e.getmessage());
            WV_Utility1.captureException('My Elections','Scheme Detail page->Content management tab-->delete()','Exception Type : '+e.getTypeName()+'; <b>Exception message: '+e.getmessage()+'; Line number :'+e.getlinenumber(),e.getStackTraceString(),currentPageURL,OrgName,null,userinfo.getuserId());
        }
        return null;
    }
 
}