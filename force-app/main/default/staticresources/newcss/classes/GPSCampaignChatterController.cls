/******************************************************************************************************************************
 *
 *  @File           :   GPSCampaignChatterController.cls
 *
 *  @Purpose        :  This is controller class for GPSCampaignChatter page. This class implimented to achive custom chatter functionality for campaign. 
 *
 *  @Author         :  Sudarshan Kadam @ Capgemini 
 *
 *  @History        :  CRMGPS-4765 : Create GPS Campaign Chatter like functionality. 
 *					:  CRMGPS-4976 :  Show the Logged-in user/Sales person when post/like in chatter  

 
 *  12th Jan 2016   :   Sudarshan Kadam   :  Created
 //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.
*******************************************************************************************************************************/
public class GPSCampaignChatterController {
  
  //Below declaration used to post new feeds.
  public String newPost { get; set; }
  
  public CmpgnDetails cmpgnDetails { get; set; }
  public User currentUser { get; set; }
  public List<SelectOption> feedAccountType { get; set; }
  public List<SelectOption> feedRole { get; set; }
  public List<SelectOption> feedRegion { get; set; }
  public List<SelectOption> feedView { get; set; }
  
  
   /**
     * Method:
     * inIt
     * 
     * Summary:
     * This method used for intialize the chatter data like feeds with comments for selected campaign.
     *
     * Parameters:
     * 
     * Return Type: 
     *  
     **/
  public void inIt(){
    
    if(cmpgnDetails.campaign != null){
      Map<Id, CampaignFeedItem__c> mapFeedItems = new Map<Id, CampaignFeedItem__c>([SELECT Id, Name, Type__c, Title__c, CreatedDate, CreatedDate__c, LikeFeedCount__c, Body__c, InsertedBy__c, InsertedBy__r.Name, InsertedBy__r.Preferred_Name__c, InsertedBy__r.LastName, /*InsertedBy__r.SmallPhotoUrl,*/ IsRichText__c, Campaign__c FROM CampaignFeedItem__c WHERE Campaign__c = :cmpgnDetails.campaign.Id Order By  CreatedDate__c DESC,CreatedDate DESC]);
      
      Map<Id, CampaignFeedComment__c> mapFeedComments = new Map<Id, CampaignFeedComment__c>([SELECT Id, Name, CreatedDate, CreatedDate__c, CampaignFeedItem__c, CommentBody__c, InsertedBy__c, InsertedBy__r.Name, InsertedBy__r.Preferred_Name__c, InsertedBy__r.LastName, /*InsertedBy__r.SmallPhotoUrl,*/ CommentType__c from CampaignFeedComment__c WHERE CampaignFeedItem__c =: mapFeedItems.keySet() Order By CreatedDate__c ASC ,CreatedDate ASC]);
      
      Map<Id, List<CampaignFeedLike__c>> mapFeedLikes = new Map<Id, List<CampaignFeedLike__c>>();
      
      /////25-Oct-2017
      
      		
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
	     
	     System.Debug('loggedInUserid'+loggedInUserid);
	     //////
      
      
      
      for(CampaignFeedLike__c fLike : [SELECT Id, Name, CampaignFeedItem__c, CampaignFeedComment__c, FeedEntityId__c, InsertedBy__c FROM CampaignFeedLike__c WHERE CampaignFeedItem__c =: mapFeedItems.keySet()  Order By CreatedDate]){
        if(fLike.CampaignFeedComment__c != null){
          
          if(mapFeedLikes.containsKey(fLike.CampaignFeedComment__c) ){
            List<CampaignFeedLike__c> tempFLike = mapFeedLikes.get(fLike.CampaignFeedComment__c);
            tempFLike.add(fLike);
            mapFeedLikes.put(fLike.CampaignFeedComment__c, tempFLike);
          }else{
            mapFeedLikes.put(fLike.CampaignFeedComment__c, new List<CampaignFeedLike__c>{fLike});
          }
          
        }else{
          
          if(mapFeedLikes.containsKey(fLike.CampaignFeedItem__c)){
            List<CampaignFeedLike__c> tempFLike = mapFeedLikes.get(fLike.CampaignFeedItem__c);
            tempFLike.add(fLike);
            mapFeedLikes.put(fLike.CampaignFeedItem__c, tempFLike);
          }else{
            mapFeedLikes.put(fLike.CampaignFeedItem__c, new List<CampaignFeedLike__c>{fLike});
          }
        }
      }
      
      List<CmpgnFeedDetails> lstCFD = new List<CmpgnFeedDetails>();
      for(CampaignFeedItem__c fItem : mapFeedItems.values()){
        
        List<CmpgnFeedCommentDetails> lstCFCDetails = new List<CmpgnFeedCommentDetails>();
        for(CampaignFeedComment__c fComment : mapFeedComments.values()){
          
          if(fItem.Id == fComment.CampaignFeedItem__c ){
            
            if(mapFeedLikes.containsKey(fComment.Id))
              lstCFCDetails.add(new CmpgnFeedCommentDetails(fComment, getNotificaitonDetails(mapFeedLikes.get(fComment.Id))));
            else
              lstCFCDetails.add(new CmpgnFeedCommentDetails(fComment, new CmpgnNotificationDetails()));
          }
        }
        
        if(mapFeedLikes.containsKey(fItem.Id))
          lstCFD.add(new CmpgnFeedDetails(fItem, getNotificaitonDetails(mapFeedLikes.get(fItem.Id)), lstCFCDetails));
        else
          lstCFD.add(new CmpgnFeedDetails(fItem, new CmpgnNotificationDetails(), lstCFCDetails));  
      }
      
      if(cmpgnDetails.campaign.Structured_Feedback__c){
          feedAccountType = getOptionsValue(cmpgnDetails.campaign.Feedback_Account_Type__c);
          feedRole = getOptionsValue(cmpgnDetails.campaign.Feedback_Role__c);
          feedRegion = getOptionsValue(cmpgnDetails.campaign.Feedback_Region__c);
          feedView = getOptionsValue(cmpgnDetails.campaign.Feedback_View__c);
      }
      cmpgnDetails.feedDetails = lstCFD;
    }
  }
  
   /**
     * Method:
     * getOptionsValue
     * 
     * Summary:
     * This method return dropdown list for Account, Region, View & Role. 
     *
     * Parameters:
     * String feedbackValue
     * 
     * Return Type: 
     * List<SelectOption>
     *  
     **/
  private List<SelectOption> getOptionsValue(String feedbackValue){
    List<SelectOption> selectList = new List<SelectOption>();
    selectList.add(new SelectOption('--None--', '--None--'));
    if(String.isNotEmpty(feedbackValue)){
      for(String str : feedbackValue.split(';')){
        if(String.isNotEmpty(str))
          selectList.add(new SelectOption(str.trim(), str.trim()));
      }
    }
    return selectList;
  }
  
  
  /**
     * Method:
     * GPSCampaignChatterController
     * 
     * Summary:
     * This constructor used to intialize selected campaign data.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public GPSCampaignChatterController(){
    
     //IE9 Visualforce hack   
    String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
    if(browserType != null && browserType.contains('MSIE')){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    }
    
    String selectedCampaignId = ApexPages.currentPage().getParameters().get('campaignId');
    
    cmpgnDetails = new CmpgnDetails();
    
    currentUser = [SELECT Id, Name/*, SmallPhotoUrl*/ FROM User WHERE Id =: UserInfo.getUserId()];
    //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.
    
    //List<Campaign> lstCampaign = [SELECT Name, Feedback_View__c, Feedback_Role__c, Feedback_Region__c, Feedback_Account_Type__c FROM Campaign Where Id =: selectedCampaignId  limit 1];
    
    List<Campaign__c> lstCampaign = [SELECT Name, Feedback_View__c, Feedback_Role__c, Feedback_Region__c, Feedback_Account_Type__c, Structured_Feedback__c FROM Campaign__c Where Id =: selectedCampaignId  limit 1];
    
    if(!lstCampaign.isEmpty())
      cmpgnDetails.campaign = lstCampaign[0];
  }
  
  /**
     * Method:
     * createPost
     * 
     * Summary:
     * This method used to sent new feed post in plain text format & also post feedback form data as well.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void createPost(){
    
    String topic = '';
    if(String.isNotEmpty(cmpgnDetails.feedAccountType) && cmpgnDetails.feedAccountType != '--None--'){
      topic += '#' + cmpgnDetails.feedAccountType + ' ';
    }
    if(String.isNotEmpty(cmpgnDetails.feedRole) && cmpgnDetails.feedRole != '--None--'){
      topic += '#' + cmpgnDetails.feedRole + ' ';
    }
    if(String.isNotEmpty(cmpgnDetails.feedRegion) && cmpgnDetails.feedRegion != '--None--'){
      topic += '#' + cmpgnDetails.feedRegion + ' ';
    }
    if(String.isNotEmpty(cmpgnDetails.feedView) && cmpgnDetails.feedView != '--None--'){
      topic += '#' + cmpgnDetails.feedView + ' ';
    }
    
    if(String.isNotEmpty(topic))
    newPost = topic + '\n' + newPost;
    
   if(String.isNotEmpty(newPost.trim())){   
    	
    //Added on 10-Oct-2017
    //Added to show the Logged-in user, if Logged-in user commented or liked the post
    
		CampaignFeedItem__c newFeedItem = new CampaignFeedItem__c();
		 list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	             newFeedItem = new CampaignFeedItem__c(Type__c = 'TextPost', Body__c = newPost, InsertedBy__c = loggedInUserid, IsRichText__c = false, Campaign__c = cmpgnDetails.campaign.Id);
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	             newFeedItem = new CampaignFeedItem__c(Type__c = 'TextPost', Body__c = newPost, InsertedBy__c = loggedInUserid, IsRichText__c = false, Campaign__c = cmpgnDetails.campaign.Id);
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	             newFeedItem = new CampaignFeedItem__c(Type__c = 'TextPost', Body__c = newPost, InsertedBy__c = loggedInUserid, IsRichText__c = false, Campaign__c = cmpgnDetails.campaign.Id);
	     }
	     
	     //		
		
		//newPost = '';
		//insert newFeedItem;
		//inIt();	
    
    	 
    //CampaignFeedItem__c newFeedItem = new CampaignFeedItem__c(Type__c = 'TextPost', Body__c = newPost, InsertedBy__c = UserInfo.getUserId(), IsRichText__c = false, Campaign__c = cmpgnDetails.campaign.Id,CreatedDate__c = system.now());
    newPost = '';
    insert newFeedItem;
    }
    inIt();
  }
  
  /**
     * Method:
     * deletePost
     * 
     * Summary:
     * This method used delete post for selected campaign.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void deletePost(){
    Id feedItemId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostItemId'));
    CampaignFeedItem__c fItem = [SELECT Id FROM CampaignFeedItem__c WHERE Id =: feedItemId];
    delete fItem;
    inIt();
  }
  
  /**
     * Method:
     * likePost
     * 
     * Summary:
     * This method used when any user liked any post.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void likePost(){
    Id feedItemId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostItemId'));
    
    
    //Added on 23-Oct-2017
    //Added to show the Logged-in user, if Logged-in user commented or liked the post
    CampaignFeedLike__c fLike = new CampaignFeedLike__c();
		//CampaignFeedItem__c newFeedItem = new CampaignFeedItem__c();
		 list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	             fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, InsertedBy__c = loggedInUserid);	            
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	             fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, InsertedBy__c = loggedInUserid);
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	            fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, InsertedBy__c = loggedInUserid);
	     }
	     
    
    //CampaignFeedLike__c fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, InsertedBy__c = UserInfo.getUserId());
    insert fLike;
    inIt();
  }
  
  /**
     * Method:
     * unlikePost
     * 
     * Summary:
     * This method used when any user unliked the any post. In this case records get deleted.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void unlikePost(){
    Id feedItemId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostItemId'));
    
    //Added on 25-Oct-2017
    //Added to show the Logged-in user, if Logged-in user commented or liked the post
    CampaignFeedLike__c fLike = new CampaignFeedLike__c();
		//CampaignFeedItem__c newFeedItem = new CampaignFeedItem__c();
		 list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	            // fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, InsertedBy__c = loggedInUserid);	            
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	            // fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, InsertedBy__c = loggedInUserid);
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	            //fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, InsertedBy__c = loggedInUserid);
	     }
    
    
    fLike = [SELECT Id FROM CampaignFeedLike__c WHERE CampaignFeedItem__c =: feedItemId AND CampaignFeedComment__c = null AND InsertedBy__c =: loggedInUserid LIMIT 1];
    //CampaignFeedLike__c fLike = [SELECT Id FROM CampaignFeedLike__c WHERE CampaignFeedItem__c =: feedItemId AND CampaignFeedComment__c = null AND InsertedBy__c =: UserInfo.getUserId() LIMIT 1];
    delete fLike;
    inIt();
  }
  
  /**
     * Method:
     * CreateComment
     * 
     * Summary:
     * This method used to add comment for selected post item.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void CreateComment(){
    Id feedItemId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedFeedItemId'));
    String postCommentValue = '';
    for(CmpgnFeedDetails CFDetails : cmpgnDetails.feedDetails){
      if(CFDetails.feedItem.Id == feedItemId){
        postCommentValue = CFDetails.tempFIComment;
        CFDetails.tempFIComment = '';
        break;
      }
    }
    
    if(String.isNotEmpty(postCommentValue.trim())){
      CampaignFeedComment__c feedComment = new CampaignFeedComment__c();
      //CampaignFeedComment__c feedComment = new CampaignFeedComment__c(CampaignFeedItem__c = feedItemId, CommentBody__c = postCommentValue, InsertedBy__c = UserInfo.getUserId(), CommentType__c = 'TextComment',CreatedDate__c = system.now());
      
      // Added on 10-Oct-2017
      //Added to show the Logged-in user, if Logged-in user commented or liked the post
		
		 list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	             feedComment = new CampaignFeedComment__c(CampaignFeedItem__c = feedItemId, CommentBody__c = postCommentValue, InsertedBy__c = loggedInUserid, CommentType__c = 'TextComment',CreatedDate__c = system.now());
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	             feedComment = new CampaignFeedComment__c(CampaignFeedItem__c = feedItemId, CommentBody__c = postCommentValue, InsertedBy__c = loggedInUserid, CommentType__c = 'TextComment',CreatedDate__c = system.now());
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	             feedComment = new CampaignFeedComment__c(CampaignFeedItem__c = feedItemId, CommentBody__c = postCommentValue, InsertedBy__c = loggedInUserid, CommentType__c = 'TextComment',CreatedDate__c = system.now());
	     }
	     
	     ////
      
      
      CampaignFeedItem__c newFeedItem = new CampaignFeedItem__c();
        newFeedItem = new CampaignFeedItem__c(Type__c = 'TextPost', Body__c = newPost, InsertedBy__c = Userinfo.getUserId(), IsRichText__c = false, Campaign__c = cmpgnDetails.campaign.Id);
      insert feedComment;
      inIt();
    }
  }
  
  /**
     * Method:
     * DeleteComment
     * 
     * Summary:
     * This method used if user want to delete any specific post comment.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void DeleteComment(){
    Id feedCommentId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostCommentId'));
    CampaignFeedComment__c fComment = [SELECT Id FROM CampaignFeedComment__c WHERE Id =: feedCommentId];
    delete fComment;
    inIt();
  }
  
  /**
     * Method:
     * likeComment
     * 
     * Summary:
     * This method used if user do like for any comment.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void likeComment(){
    Id feedItemId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostItemId'));
    Id feedCommentId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostCommentId'));
    //CampaignFeedLike__c fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, CampaignFeedComment__c = feedCommentId, InsertedBy__c = UserInfo.getUserId());
    CampaignFeedLike__c fLike = new CampaignFeedLike__c();
    
    // Added on 23-Oct-2017
      //Added to show the Logged-in user, if Logged-in user commented or liked the post
		
		 list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	            fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, CampaignFeedComment__c = feedCommentId, InsertedBy__c = loggedInUserid);
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	             fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, CampaignFeedComment__c = feedCommentId, InsertedBy__c = loggedInUserid);
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	            fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, CampaignFeedComment__c = feedCommentId, InsertedBy__c = loggedInUserid);
	     }
    
    
    
    
    //CampaignFeedLike__c fLike = new CampaignFeedLike__c(CampaignFeedItem__c = feedItemId, CampaignFeedComment__c = feedCommentId, InsertedBy__c = UserInfo.getUserId());
    insert fLike;
    inIt();
  }
  
  /**
     * Method:
     * unlikeComment
     * 
     * Summary:
     * This method used if user do unlike for any comment.
     *
     * Parameters:
     * 
     * 
     * Return Type: 
     * 
     *  
     **/
  public void unlikeComment(){
    Id feedItemId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostItemId'));
    Id feedCommentId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedPostCommentId'));
    //CampaignFeedLike__c fLike = [SELECT Id FROM CampaignFeedLike__c WHERE CampaignFeedItem__c =: feedItemId AND CampaignFeedComment__c =:feedCommentId  AND InsertedBy__c =: UserInfo.getUserId() LIMIT 1];
    CampaignFeedLike__c fLike = new CampaignFeedLike__c();
    
    // Added on 23-Oct-2017
      //Added to show the Logged-in user, if Logged-in user commented or liked the post
		
		 list<GPSCampaignsLoginAs__c> loggedin  =  [Select Current_User__c,Login_As_User__c from GPSCampaignsLoginAs__c where Current_User__c =: Userinfo.getUserId() limit 1];
        String loggedInUserid = '';
        if(!loggedin.isEmpty() && loggedin != null){
	        if(loggedin[0].Login_As_User__c != null && loggedin[0].Login_As_User__c!= '' ){
	            loggedInUserid = loggedin[0].Login_As_User__c;
	             fLike = [SELECT Id FROM CampaignFeedLike__c WHERE CampaignFeedItem__c =: feedItemId AND CampaignFeedComment__c =:feedCommentId  AND InsertedBy__c =: loggedInUserid LIMIT 1];
	        } else{
	            loggedInUserid = Userinfo.getUserId();
	            fLike = [SELECT Id FROM CampaignFeedLike__c WHERE CampaignFeedItem__c =: feedItemId AND CampaignFeedComment__c =:feedCommentId  AND InsertedBy__c =: loggedInUserid LIMIT 1];
	        }
        }else{
	            loggedInUserid = Userinfo.getUserId();
	            fLike = [SELECT Id FROM CampaignFeedLike__c WHERE CampaignFeedItem__c =: feedItemId AND CampaignFeedComment__c =:feedCommentId  AND InsertedBy__c =: loggedInUserid LIMIT 1];
	     }
    
    
    delete fLike;
    inIt();
  }
  
  /**
     * Method:
     * getNotificaitonDetails
     * 
     * Summary:
     * This method return notification details inner class by formatting notification message for comment or post item.
     *
     * Parameters:
     * List<CampaignFeedLike__c> tempListCFL
     * 
     * Return Type: 
     * CmpgnNotificationDetails
     *  
     **/
  private CmpgnNotificationDetails getNotificaitonDetails(List<CampaignFeedLike__c> tempListCFL){
    
    CmpgnNotificationDetails tempNotiDetails = new CmpgnNotificationDetails();
    
    // Added on 31-Oct-2017
      //Added to show the Logged-in user, if Logged-in user commented or liked the post
		
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
    
    
    
    
    if(!tempListCFL.isEmpty()){
      Boolean isLikeTemp = false;
      for(CampaignFeedLike__c obj : tempListCFL){
        //if(obj.InsertedBy__c == UserInfo.getUserId())
        if(obj.InsertedBy__c == loggedInUserid)
          isLikeTemp = true;
      }
      tempNotiDetails.likeCount = tempListCFL.size();
      tempNotiDetails.isCULike = isLikeTemp;
      if(isLikeTemp){
        if((tempListCFL.size()-1) == 0)
          tempNotiDetails.notificationMSG = 'You like this.';
        else  
          tempNotiDetails.notificationMSG = 'You and other '+ (tempListCFL.size()-1) + ' like this.';
      }else{
        tempNotiDetails.notificationMSG = 'Other '+ tempListCFL.size() + ' like this.';
      }
    }
    return tempNotiDetails;
  }
  
  //This is parent Campaign Details inner class which hold campaign & feedback form details
  //03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.
  public class CmpgnDetails{
    //public Campaign campaign { get; set; }
    public Campaign__c campaign { get; set; }
    public String feedAccountType { get; set; }
    public String feedRole { get; set; }
    public String feedRegion { get; set; }
    public String feedView { get; set; }
    public List<CmpgnFeedDetails> feedDetails { get; set; }
    public CmpgnDetails(){
      campaign = new Campaign__c();
      feedDetails = new List<CmpgnFeedDetails>();
    }
  }
  
  //This is Campaign Feed details inner class its hold feed items details.
  public class CmpgnFeedDetails{
    public CampaignFeedItem__c feedItem { get; set; }
    public String tempFIComment { get; set; }
    public CmpgnNotificationDetails notificationDetails { get; set; }
    public List<CmpgnFeedCommentDetails> feedCommentDetails { get; set; }
    public CmpgnFeedDetails() { }
    public CmpgnFeedDetails(CampaignFeedItem__c feedItem, CmpgnNotificationDetails notificationDetails, List<CmpgnFeedCommentDetails> feedCommentDetails){
      this.feedItem = feedItem;
      this.notificationDetails = notificationDetails;
      this.feedCommentDetails = feedCommentDetails;
    }
  }
  
  //This is Campaign Feed Comment details inner class its hold feed comments details.
  public class CmpgnFeedCommentDetails{
    public CampaignFeedComment__c feedComment { get; set; }
    public CmpgnNotificationDetails notificationDetails { get; set; }
    public CmpgnFeedCommentDetails() { }
    public CmpgnFeedCommentDetails(CampaignFeedComment__c feedComment, CmpgnNotificationDetails notificationDetails){
      this.feedComment = feedComment;
      this.notificationDetails = notificationDetails;
    }
  }
  
  //This is campaign notification details inner class its hold notification message details for post item & comments.
  public class CmpgnNotificationDetails{
    public Integer likeCount { get; set; }
    public Boolean isCULike { get; set; }
    public String notificationMSG { get; set; }
  }
}