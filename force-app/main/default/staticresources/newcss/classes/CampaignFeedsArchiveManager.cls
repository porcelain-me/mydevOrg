/******************************************************************************************************************************
 *
 *  @File           :   CampaignFeedsArchiveManager.cls
 *
 *  @Purpose        :  This is helper & manager class for CampaignFeedItemDiscovery & CampaignFeedCommentDiscovery triggers. 
 *
 *  @Author         :  Sudarshan Kadam @ Capgemini 
 *
 *  @History        :   CRMGPS-4976 :  Show the Logged-in user/Sales person when post/like in chatter
 *
 *  29th Jan 2016   :   Sudarshan Kadam : Created : CRMGPS-4774 - Zantaz Integration for custom chatter functionality.
*******************************************************************************************************************************/
public without sharing class CampaignFeedsArchiveManager {
    
   /**
     * Method:
     * create_RFC2822_Archive_For_Posts
     * 
     * Summary:
     * This method return Archive Records with all fields value assignment for given post item.
     *
     * Parameters:
     * CampaignFeedItem__c objCFI
     * 
     * Return Type: 
     *  RFC2822_Archive__c 
     **/
  	public RFC2822_Archive__c create_RFC2822_Archive_For_Posts(CampaignFeedItem__c objCFI){
  		
  			RFC2822_Archive__c rfc = new RFC2822_Archive__c();
  			
  			String plainText =  getHTMLStyleTag() + '<div id="archiveBody">\n' + getHTMLSourceDivTag(objCFI.Campaign__c) + getHTMLPrimaryMaterial() + getChatterPostDiv(objCFI, null, null, false) + '</div>';
						        
            rfc.Body_Plain_Text__c = plainText;
            rfc.Content_Transfer_Encoding__c = 'base64';
            rfc.Content_Type__c = 'text/html; charset="utf-8"';
            
            rfc.From__c = getFromAddress(objCFI.InsertedBy__r);
            
            rfc.MIME_Version__c = '1.0';
                        
            rfc.Subject__c = getArchiveSubject(objCFI.InsertedBy__r);
            
            rfc.Feed_Id__c = objCFI.Id;
            rfc.FeedObjectName__c = 'CampaignFeed';
            rfc.Index__c = 0;
            rfc.SourceID__c = objCFI.Campaign__c;
            
            rfc.OwnerId = UserInfo.getUserId();
            //rfc.To__c = getToAddress(objCFI.InsertedBy__r);
            rfc.Message_ID__c = 'Salesforce-GPS'+System.Label.sndbx +'-'+ DateTime.Now().format('yyyyMMdd') +'Z'+ DateTime.Now().format('hhmmss') + '-I-';
  			
  			return rfc;
  	}
   
   /**
     * Method:
     * getArchiveSubject
     * 
     * Summary:
     * Return archive subject details in HTML format.
     *
     * Parameters:
     * sObject createdBy
     * 
     * Return Type: 
     *  String 
     **/    
	 private String getArchiveSubject(sObject createdBy){
	     String sub='Username:' +  createdBy.get('lastname') +  (createdBy.get('preferred_name__c') <> null && createdBy.get('preferred_name__c') <> '' ? ', ' + createdBy.get('preferred_name__c'):'') + ' Chatter';
	     return sub;
	 }
       
     /**
     * Method:
     * getFromAddress
     * 
     * Summary:
     * Return archive from address details in HTML format.
     *
     * Parameters:
     * sObject createdBy
     * 
     * Return Type: 
     *  String 
     **/ 
      private String getFromAddress(sObject createdBy ){
            String strFrom  ='NA';
            strFrom =  '"' + createdBy.get('lastname') +  (createdBy.get('preferred_name__c') <> null && createdBy.get('preferred_name__c') <> '' ? ', ' + createdBy.get('preferred_name__c'):'') + '" <' + createdBy.get('email') + '>';
            return strFrom;
       }
     
     /**
     * Method:
     * getToAddress
     * 
     * Summary:
     * Return archive To address details in HTML format.
     *
     * Parameters:
     * sObject createdBy
     * 
     * Return Type: 
     *  String 
     **/   
     private String getToAddress(sObject createdBy ){
        String strTo = '';
        strTo =  '"' + createdBy.get('lastname') +  (createdBy.get('preferred_name__c') <> null && createdBy.get('preferred_name__c') <> '' ? ', ' + createdBy.get('preferred_name__c'):'') + '" <' + createdBy.get('email') + '>';
        return strTo;
     }
     
     /**
     * Method:
     * getAllUpdatedToAddress
     * 
     * Summary:
     * Return old & new to address recipient details in html format.
     *
     * Parameters:
     * String oldToAddress, sObject createdBy
     * 
     * Return Type: 
     *  String 
     **/
     public String getAllUpdatedToAddress(String oldToAddress, sObject createdBy){
     		
     		if(String.isNotEmpty(oldToAddress)){
     			set<String> setToAddress = new set<String>();
	     		for(String toAdd : oldToAddress.split(';')){
	     			setToAddress.add(toAdd);
	     		}
	     		
	     		if(!setToAddress.contains(getToAddress(createdBy))){
	     			oldToAddress += ';'+ getToAddress(createdBy);
	     		}
     		}else{
     			oldToAddress = getToAddress(createdBy);
     		}
     		
     		return oldToAddress;
     }
     
      
    /**
     * Method:
     * getExistingRFC2822_Archives
     * 
     * Summary:
     * This Method returns the List of Existing RFC2822_Archive__c for the feed
     *
     * Parameters:
     * Set<Id> postIds
     * 
     * Return Type: 
     *  List<RFC2822_Archive__c> 
     **/
       public List<RFC2822_Archive__c> getExistingRFC2822_Archives(Set<Id> postIds){
                     
          List<RFC2822_Archive__c> lstTodaysArchives= new  List<RFC2822_Archive__c> ();
           AggregateResult[] mostRecentArchiveDate   = [SELECT MAX(Archive_Date__c)maxDate  From RFC2822_Archive__c r                                                         
                                                             where Feed_Id__c in :postIds];
				
           if(mostRecentArchiveDate.size()>0){
               Date maxDate = (Date)mostRecentArchiveDate[0].get('maxDate');
               System.debug(mostRecentArchiveDate+'_______________________ getExistingRFC2822_Archives maxDate ___________________' + maxDate);
                 
               
                lstTodaysArchives  =[Select r.To__c, r.Subject__c, r.SourceID__c, r.Name, r.Message_ID__c, r.MIME_Version__c, r.Id, r.Feed_id__c,
                                        r.ContentDocumentTitle__c,r.ContentDocumentName__c,ContentDocumentType__c,
                                        r.From__c, r.Content_Type__c, r.Content_Transfer_Encoding__c, r.Body__c, r.Body_Plain_Text__c, r.Archive_Date__c,
                                        r.Index__c, r.FeedObjectName__c // 26 March 2012, Rahul A: Add FeedObjectName field in query
                                                                From RFC2822_Archive__c r
                                                                //where SourceID__c in :postIds
                                                                 where Feed_Id__c in :postIds
                                                                 and Archive_Date__c = :maxDate
                                                                 and For_Comment_with_File__c = false //RA: Zantaz File Enhancement 17 Feb 2012
                                                                 Order by Index__c DESC,CreatedDate DESC ];
                                                                
          
                return lstTodaysArchives;
           }
           return lstTodaysArchives;
       }
       
   /**
     * Method:
     * getPlainTextWithUpdatedComment
     * 
     * Summary:
     * This Method returns plain text body format after create or delete feeds.
     *
     * Parameters:
     * CampaignFeedItem__c objCFI, RFC2822_Archive__c objRFC, CampaignFeedComment__c objCFC, Boolean isDelete
     * 
     * Return Type: 
     *  String 
     **/
       public String getPlainTextWithUpdatedComment(CampaignFeedItem__c objCFI, RFC2822_Archive__c objRFC, CampaignFeedComment__c objCFC, Boolean isDelete){
       	
       		if(isDelete){
       			return getChatterPostDiv(objCFI, objRFC, objCFC, isDelete); 
       		}else{
       			return getHTMLStyleTag() + '<div id="archiveBody">\n' + getHTMLSourceDivTag(objCFI.Campaign__c) + getHTMLPrimaryMaterial() + getChatterPostDiv(objCFI, objRFC, objCFC, isDelete) + '</div>';
       		}
       }  
         
       // This method returns the style tag
       private string getHTMLStyleTag(){
           return   '<style type="text/css">\n' + '  div {padding-left:10px; padding-bottom:5px;}\n' + '  span {padding-right:5px;}\n' + '  .deleted {font-weight:bold;}\n' + '</style>\n';
       } 
       
       // This method returns the div tag for message id
       private String getHTMLSourceDivTag(String sourceId){
            return  '<div id="sourceID">Source Record ID: '+ sourceId + '</div>\n' ;
       }
       
       //This method returns primary material text in html format. 
       private String getHTMLPrimaryMaterial(){
       		return '<div id="primaryMaterial">Supplemental Material:  </div>\n';
       } 
      
    /**
     * Method:
     * getChatterPostDivForComments
     * 
     * Summary:
     * This Method generate String in html format for given post id & its related comments. 
     *
     * Parameters:
     * CampaignFeedItem__c objCFI, RFC2822_Archive__c objRFC, List<CampaignFeedComment__c> lstCFC
     * 
     * Return Type: 
     *  String 
     **/
      public String getChatterPostDivForComments(CampaignFeedItem__c objCFI, RFC2822_Archive__c objRFC, List<CampaignFeedComment__c> lstCFC){
      	
      	String chatterFeed = '<div id="chatterFeed">\n';
      	chatterFeed += '<div id="'+objCFI.Id+'" class="chatterPost">\n' +
						        objCFI.CreatedDate +' '+ objCFI.InsertedBy__r.Preferred_Name__c + ' ' + objCFI.InsertedBy__r.LastName + ' - ' + objCFI.Body__c + '\n\n';
						        
		for(CampaignFeedComment__c objCFC : lstCFC){
			chatterFeed += '<div id="'+objCFC.Id+'" class="chatterPost">\n'+
      	  	objCFC.CreatedDate +' '+ objCFI.InsertedBy__r.Preferred_Name__c + ' ' + objCFI.InsertedBy__r.LastName + ' - ' + objCFC.CommentBody__c + '\n</div>\n';
		}
		
		chatterFeed += 	'&nbsp;</div>\n'+ '&nbsp;&nbsp;</div>';
		
		return getHTMLStyleTag() + '<div id="archiveBody">\n' + getHTMLSourceDivTag(objCFI.Campaign__c) + getHTMLPrimaryMaterial() + chatterFeed + '</div>';
      	
      } 
      
    /**
     * Method:
     * getChatterPostDiv
     * 
     * Summary:
     * This Method generate String in html format for on insert & delete operation of feeds. 
     *
     * Parameters:
     * CampaignFeedItem__c objCFI, RFC2822_Archive__c objRFC, CampaignFeedComment__c objCFC, Boolean isDelete
     * 
     * Return Type: 
     *  String 
     **/
      private String getChatterPostDiv(CampaignFeedItem__c objCFI, RFC2822_Archive__c objRFC, CampaignFeedComment__c objCFC, Boolean isDelete){
      	      	
      	  
      	//Added on 11-Oct-2017
      	//to find the logged-in user and  show them in "Body Plain Text" field in  "RFC2822 Archive" Object
      	
      	
      	//User u = [select Preferred_Name__c, LastName from User where Id = :UserInfo.getUserId()]; //Code before change
      	list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	     }

		 User u = [select Preferred_Name__c, LastName from User where Id = :loggedInUserid];
		 
		 
		 // Updted code ends here
      	  
      	  
      	  String chatterFeed = '<div id="chatterFeed">\n';
      	  
      	  if(objCFI != null && objCFC == null && isDelete == false){
      	  	
			chatterFeed += '<div id="'+objCFI.Id+'" class="chatterPost">\n' +
						        objCFI.CreatedDate +' '+ u.Preferred_Name__c + ' ' + u.LastName + ' - ' + objCFI.Body__c + '\n\n' + 
						        '&nbsp;</div>\n';
			
      	  }else if(objCFI != null && objRFC != null && objCFC == null && isDelete == true){
      	  	
      	  	String tempStr = '<div id="'+objCFI.Id+'" class="chatterPost">';
      	  	
      	  	integer endInd = objRFC.Body_Plain_Text__c.indexOf(tempStr);
      	  	
      	  	String startingPlainText = objRFC.Body_Plain_Text__c.subString(0, endInd + tempStr.length());
      	  	
      	  	String endPlainText = objRFC.Body_Plain_Text__c.subString(endInd + tempStr.length(), objRFC.Body_Plain_Text__c.length());
      	  	
      	  	String strDelete = '<span class="deleted">Deleted on ' + objCFI.CreatedDate + '</span>';
      	  	
      	  	return (startingPlainText + strDelete + endPlainText);
      	  	
      	  }else if(objRFC != null && objCFI != null && objCFC != null && isDelete == false){
      	  	      	  	
      	  	integer startInd = objRFC.Body_Plain_Text__c.indexOf('<div id="' + objCFI.Id +'"');
      	  	
      	  	integer endInd = objRFC.Body_Plain_Text__c.indexOf('&nbsp;</div>');
      	  	      	  	
      	  	String updatePlainText = objRFC.Body_Plain_Text__c.subString(startInd, endInd);
      	  	
      	  	chatterFeed = updatePlainText + '<div id="'+objCFC.Id+'" class="chatterPost">\n'+
      	  	objCFC.CreatedDate +' '+ u.Preferred_Name__c + ' ' + u.LastName  + ' - ' + objCFC.CommentBody__c + '\n</div>\n' + '&nbsp;</div>\n';
      	  	
      	  }else if(objRFC != null && objCFI != null && objCFC != null && isDelete == true){
      	  	
      	  	String tempStr = '<div id="'+objCFC.Id+'" class="chatterPost">';
      	  	
      	  	integer endInd = objRFC.Body_Plain_Text__c.indexOf(tempStr);
      	  	
      	  	String startingPlainText = objRFC.Body_Plain_Text__c.subString(0, endInd + tempStr.length());
      	  	
      	  	String endPlainText = objRFC.Body_Plain_Text__c.subString(endInd + tempStr.length(), objRFC.Body_Plain_Text__c.length());
      	  	
      	  	String strDelete = '<span class="deleted">Deleted on ' + objCFC.CreatedDate + '</span>';
      	  	
      	  	return (startingPlainText + strDelete + endPlainText);
      	  }
      	  
      	  chatterFeed += '&nbsp;&nbsp;</div>'; 
      	  
          return chatterFeed;    
      }
      
     
   /**
     * Method:
     * copyRFC2822_Archive
     * 
     * Summary:
     * This Method Creates A Copy of the RFC2822_Archive
     *
     * Parameters:
     * RFC2822_Archive__c rfc2822Arch
     * 
     * Return Type: 
     *  RFC2822_Archive__c 
     **/
        public RFC2822_Archive__c copyRFC2822_Archive(RFC2822_Archive__c rfc2822Arch){
            
            RFC2822_Archive__c copy = new RFC2822_Archive__c();
            
            copy = rfc2822Arch.clone(false,false,false,false);
            copy.ContentDocument_ID__c = null;
            copy.ContentDocumentLink__c ='';
            copy.ContentDocumentTitle__c ='';
            copy.ContentDocumentName__c='';
            copy.ContentDocumentType__c ='';
            copy.Message_ID__c = 'Salesforce-GPS'+System.Label.sndbx +'-'+ DateTime.Now().format('yyyyMMdd') +'Z'+ DateTime.Now().format('hhmmss') + '-I-[objectID]' + '@' +System.URL.getSalesforceBaseUrl().getHost();
            
            return copy;    
        } 
     
      // This Method identifies the Sobject type from the parent Id and return the Sobject Name
    public String getParentSobjectTypeName(String feedParentItmId){
        Map<String, String> keyPrefixMap = new Map<String, String>{};
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        string ParentSobjectTypeName ='';
        Set<String> keyPrefixSet = gd.keySet();
        for(String sObj : keyPrefixSet){
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            String tempName = r.getName();
            String tempPrefix = r.getKeyPrefix();
            if(tempPrefix<> null && feedParentItmId.startsWith(tempPrefix)){
               ParentSobjectTypeName= tempName;
                break;
            }}
        return ParentSobjectTypeName;
    }
       
    public String getMimeType(string filename){
        string fileext ='';
        string fileType = 'UNKNOWN';
        if(filename.contains('.')) {
            fileext =  filename.substring(filename.lastIndexof('.')+1,filename.length());
            fileext=fileext.toLowerCase();
            if(Map_FileExtensions_Mime.containskey(fileext)){
                fileType= Map_FileExtensions_Mime.get(fileext);
            }
            
        }
        return fileType; 
    }
    
    private Map<string,string> Map_FileExtensions_Mime = new Map<string,string>{
                                                                                'txt'=>'text/plain',
                                                                                'jpg'=>'image/jpeg',
                                                                                'doc'=>'application/msword',
                                                                                'docx'=>'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                                                                                'dot' => 'application/msword',
                                                                                 'dotx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.template',
                                                                                 'docm' => 'application/vnd.ms-word.document.macroEnabled.12',
                                                                                 'dotm' => 'application/vnd.ms-word.template.macroEnabled.12',
                                                                                 'rtf' => 'application/rtf',
                                                                                 'bmp' => 'image/bmp',
                                                                                'csv'=>'text/csv',
                                                                                'png'=>'image/png',
                                                                                'pdf'=>'application/pdf',
                                                                                'diff'=>'binary/file',
                                                                                'xml' => 'text/xml',
                                                                                'htm' => 'text/html',
                                                                                'html' => 'text/html',
                                                                                'css' => 'text/css',
                                                                                 'gif'=>'image/gif',
                                                                                 'wav' =>'audio/vnd.wave',
                                                                                 'wmv' => 'audio/x-ms-wma',
                                                                                 'mpeg' => 'audio/mpeg',
                                                                                 'mp3' => 'audio/mpeg',
                                                                                 'zip' => 'application/zip',
                                                                                 'gz' => 'application/x-gzip',
                                                                                 'odt' => 'application/vnd.oasis.opendocument.text',
                                                                                 'odp' => 'application/vnd.oasis.opendocument.presentation',
                                                                                 'ods' => 'application/vnd.oasis.opendocument.spreadsheet',
                                                                                 'odg' =>'application/vnd.oasis.opendocument.graphics',
                                                                                 'odg' =>'application/vnd.oasis.opendocument.graphics',
                                                                                 'xls'=>'application/vnd.ms-excel',
                                                                                 'xlsx'=>'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                                                 'xlsm'=>'application/vnd.ms-excel.sheet.macroEnabled.12',
                                                                                 'xlsb'=>'application/vnd.ms-excel.sheet.binary.macroEnabled.12',
                                                                                 'ppt'=>'application/vnd.ms-powerpoint',
                                                                                 'pptx'=>'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                                                                                 'pps'=>'application/vnd.ms-powerpoint',
                                                                                 'ppsx'=>'application/vnd.openxmlformats-officedocument.presentationml.slideshow',
                                                                                 'rar' => 'application/x-rar-compressed',
                                                                                 'tar' =>'application/x-tar'
                                                                 
                                                                    };
         
}