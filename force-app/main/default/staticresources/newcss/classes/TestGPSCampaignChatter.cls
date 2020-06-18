/******************************************************************************************************************************
 *
 *  @File           :   TestGPSCampaignChatter.cls
 *
 *  @Purpose        :  This test class cover line of code for GPSCampignChatterController & zantaz triggers. 
 *
 *  @Author         :  Sudarshan Kadam @ Capgemini 
 *
 *  @History        :  CRMGPS-4765 : Create GPS Campaign Chatter like functionality. 
 *
 *  5th Feb 2016   :   Sudarshan Kadam   :  Created
*******************************************************************************************************************************/
@isTest
public class TestGPSCampaignChatter {
    
    public static PageReference pageRef = Page.GPSCampaignChatter;
       
    static void setupData(){
      
      //T1C_CustomSettingsManager.setAllTriggerOn();
      
      Chatter_Settings__c dSwitch2 = new Chatter_Settings__c(Name='Default', Enable_Archiving__c = true, Allow_Chatter_Posts_and_Comments__c = true);
      insert dSwitch2;
      
      Campaign__c camp = new Campaign__c(Name = 'TestCampaign', Region__c = 'Global', Status__c='Active' ,Feedback_View__c = 'View1;View2', Feedback_Role__c = 'Role1;Role2', Feedback_Region__c = 'Region1;Region2', Feedback_Account_Type__c = 'AccType1;AccType2', External_Id__c = 'Test123');
      insert camp;
      
      Test.setCurrentPage(pageRef);
      ApexPages.currentPage().getParameters().put('campaignId',camp.Id);
      
      CampaignFeedItem__c firstFeed = new CampaignFeedItem__c(Type__c = 'TextPost', Title__c = 'This is Title', Body__c = 'This test post', InsertedBy__c = UserInfo.getUserId(), IsRichText__c = false, Campaign__c = camp.id);
      insert firstFeed;
           
      CampaignFeedComment__c firstFeedComment = new CampaignFeedComment__c(CampaignFeedItem__c = firstFeed.Id, CommentBody__c = 'This is my first feed comment', InsertedBy__c = UserInfo.getUserId(), CommentType__c = 'TextComment');
      insert firstFeedComment;
      
      CampaignFeedComment__c secondFeedComment = new CampaignFeedComment__c(CampaignFeedItem__c = firstFeed.Id, CommentBody__c = 'This is my second feed comment', InsertedBy__c = UserInfo.getUserId(), CommentType__c = 'TextComment2');
      insert secondFeedComment;
      delete secondFeedComment;
      
      CampaignFeedLike__c firstPostLike = new CampaignFeedLike__c(CampaignFeedItem__c = firstFeed.Id, FeedEntityId__c = firstFeed.Id, InsertedBy__c = UserInfo.getUserId());
      insert firstPostLike;
      
      CampaignFeedLike__c firstPostCommentLike = new CampaignFeedLike__c(CampaignFeedItem__c = firstFeed.Id, CampaignFeedComment__c = firstFeedComment.Id, FeedEntityId__c = firstFeedComment.Id, InsertedBy__c = UserInfo.getUserId());
      insert firstPostCommentLike;
    }
    
    
    static testmethod void CampaignChatterDiscoveryTest(){
        Test.startTest();
          
          T1C_CustomSettingsManager.setAllTriggerOn();
          
          Chatter_Settings__c dSwitch2 = new Chatter_Settings__c(Name='Default', Enable_Archiving__c = true, Allow_Chatter_Posts_and_Comments__c = true);
          insert dSwitch2;
          
          Campaign__c camp = new Campaign__c(Name = 'TestCampaign', Region__c = 'Global', Status__c='Active' ,Feedback_View__c = 'View1;View2', Feedback_Role__c = 'Role1;Role2', Feedback_Region__c = 'Region1;Region2', Feedback_Account_Type__c = 'AccType1;AccType2', External_Id__c = 'Test123');
          insert camp;
          
          CampaignFeedItem__c firstFeed = new CampaignFeedItem__c(Type__c = 'TextPost', Title__c = 'This is Title', Body__c = 'test1#test2#test3#test4 This test post', InsertedBy__c = UserInfo.getUserId(), IsRichText__c = false, Campaign__c = camp.id);
          insert firstFeed;
          
          CampaignFeedComment__c firstFeedComment = new CampaignFeedComment__c(CampaignFeedItem__c = firstFeed.Id, CommentBody__c = 'This is my first feed comment', InsertedBy__c = UserInfo.getUserId(), CommentType__c = 'TextComment');
          insert firstFeedComment;
          
          delete firstFeedComment;
          delete firstFeed;
          
          List<RFC2822_Archive__c> lstRFC = [SELECT Id FROM RFC2822_Archive__c WHERE Feed_Id__c =: firstFeed.Id];
          delete lstRFC;
          
          CampaignFeedItem__c firstFeed1 = new CampaignFeedItem__c(Type__c = 'TextPost', Title__c = 'This is Title', Body__c = 'test1#test2#test3#test4 This test post', InsertedBy__c = UserInfo.getUserId(), IsRichText__c = false, Campaign__c = camp.id);
          insert firstFeed1;
          
          CampaignFeedComment__c firstFeedComment1 = new CampaignFeedComment__c(CampaignFeedItem__c = firstFeed1.Id, CommentBody__c = 'This is my first feed comment', InsertedBy__c = UserInfo.getUserId(), CommentType__c = 'TextComment');
          insert firstFeedComment1;
          
          List<RFC2822_Archive__c> lstRFC1 = [SELECT Id FROM RFC2822_Archive__c WHERE Feed_Id__c =: firstFeed1.Id];
          delete lstRFC1;
          
          delete firstFeedComment1;
          
          List<RFC2822_Archive__c> lstRFC2 = [SELECT Id FROM RFC2822_Archive__c WHERE Feed_Id__c =: firstFeed1.Id];
          delete lstRFC2;
          
          delete firstFeed1;
          
        Test.stopTest();
    }
    
    static testmethod void testIntializeData(){
      
      Test.startTest();
      setupData();
      
      system.debug('###################'+ApexPages.currentPage().getParameters().get('campaignId'));
      
      GPSCampaignChatterController campChatter = new GPSCampaignChatterController();
      campChatter.inIt();
      
      system.assertEquals(campChatter.cmpgnDetails.feedDetails.size(), 1);
      Test.stopTest();
    }
    
   /* static testmethod void testFeedPostActivity(){
      Test.startTest();
      
      setupData();
      
      GPSCampaignChatterController campChatter = new GPSCampaignChatterController();
      
      //Create new post
      campChatter.cmpgnDetails.feedAccountType = 'AccType1';
      campChatter.cmpgnDetails.feedRole = 'Role2';
      campChatter.cmpgnDetails.feedRegion = 'Region1';
      campChatter.cmpgnDetails.feedView = 'View2';
      campChatter.newPost = 'This is new post for test';
      campChatter.createPost();
      
      List<CampaignFeedItem__c> lstFeedItems = [SELECT Id, Body__c FROM CampaignFeedItem__c Order by CreatedDate DESC];
      system.assertEquals(lstFeedItems.size(), 2);
      ApexPages.currentPage().getParameters().put('selectedPostItemId', lstFeedItems[0].Id);
      
      //Like Post
      campChatter.likePost();
      
      //Unlike Post
      campChatter.unlikePost();
      
      //Delete Post
      campChatter.deletePost();
      
      
      Test.stopTest();
    } */
    
    static testmethod void testFeedCommentActivity(){
      Test.startTest();
      
      setupData();
      List<CampaignFeedItem__c> lstFeedItems = [SELECT Id, Body__c FROM CampaignFeedItem__c Order by CreatedDate DESC];
      ApexPages.currentPage().getParameters().put('selectedFeedItemId', lstFeedItems[0].Id);
        
      GPSCampaignChatterController campChatter = new GPSCampaignChatterController();
      campChatter.createComment();
      
      List<CampaignFeedComment__c> lstFeedComment = [SELECT Id FROM CampaignFeedComment__c WHERE CampaignFeedItem__c =: lstFeedItems[0].Id];
      ApexPages.currentPage().getParameters().put('selectedPostCommentId', lstFeedComment[0].Id);
      ApexPages.currentPage().getParameters().put('selectedPostItemId', lstFeedItems[0].Id);
      system.assertEquals(lstFeedComment.size(), 1);
      campChatter.likeComment();
      
      campChatter.unlikeComment();
      
      campChatter.DeleteComment();  
        
      Test.stopTest();
    }
}