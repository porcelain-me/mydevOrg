// 09/20/2011 RJ: Added ORIGINAL
//                Controller class for CM_Metrics apex component
// 09/27/2011 RJ: Added query for responses on campaign member object instead of NumberOfResponses field in campaign object
//                Line Modified: 35,36
// 11/08/2011 UV : Removed all queries to CM_CampaignDataUtil class.
public with sharing class CM_Metrics {
  
  
  //public properties  
  public String campaignId{get;set;}
  private Campaign__c currentCampaign{get;set;}  
  public boolean initializeComponent{get{ init();return true;}set;}
  public Integer responses{get;set;}
  public Integer feedbackPosts{get;set;}
  public Integer incomingRequests{get;set;}
  public Integer pendingRequests{get;set;}
  
  
  
  public CM_Metrics(){
    // constructor
    // initialize the public properties for counts
    responses = 0;
    feedbackPosts = 0;
    incomingRequests = 0;
    pendingRequests = 0;
  }// end of constructor
  
  public void init(){
    
    // This function is required to initialize with the assigned properties as constructor does not know the assigned properties
    List<Campaign__c> currentCampaignList = CM_CampaignDataUtil.getCampaignRollUpValues(campaignId);
    if(currentCampaignList.size() > 0){
        // get current user id
        Id UserId = CM_DataUtil_WS.getCurrentUser().id;
        // set current campaing     
      currentCampaign =  currentCampaignList[0];
      // get the count of responses  
      //responses = currentCampaign.NumberOfResponses;
      List<Campaign_Member_Assignment__c> cMAList = CM_CampaignDataUtil.getContactIdsOnCMAForCampaign(userId, campaignId);
      Set<Id> contactIds = new Set<Id>();
      for(Campaign_Member_Assignment__c cMA : cMAList){
        contactIds.add(cMA.GPSContact__c);
      }                                        
      responses = CM_CampaignDataUtil.getCampaignResponsesCount(campaignId, contactIds);
      //get the count of feedback posts
      //feedbackPosts = currentCampaign.Total_Feeback_Posts__c.intValue();
      feedbackPosts = currentCampaign.Total_Feedback_Items__c.intValue();
      // get the count of incoming requests
      incomingRequests = CM_CampaignDataUtil.getIncomingRequestsCount(campaignId, UserId);
      // get the count of pending requests
      pendingRequests = CM_CampaignDataUtil.getPendingRequestsCount(campaignId, UserId);
      
      
    }
  }// end of init()
}