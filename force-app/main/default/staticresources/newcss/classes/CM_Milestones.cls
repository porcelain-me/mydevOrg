//
//   09/20/2011 UV: ADDED ORIGINAL 
//					Component class for CM_Milestones apex component.
//   11/08/2011 UV : Removed all queries to CM_CampaignDataUtil class.
public with sharing class CM_Milestones {
    List<Campaign_Milestone__c> msList = new List<Campaign_Milestone__c>();
    //public properties
    public String milestoneParentId{get;set;}   
    public boolean initializeComponent{get{ init();return true;}set;}
    public List<Campaign_Milestone__c> milestoneList{get;set;}    
    public Campaign_Milestone__c nextMilestone{get;set;}
    
    public CM_Milestones(){
        milestoneList = new List<Campaign_Milestone__c>();
        nextMilestone = null;
    }
    //This function is used to retrieve the camapign milestone records
	  public void init(){
        // This function is required to initialize with the assigned properties as constructor does not know the assigned properties
		    System.debug('_____parent_MILESTONE_______' + milestoneParentId);
		    milestoneList = new List<Campaign_Milestone__c>();
        nextMilestone = null;
		    
		    // get the short list of materials according to showCount
        milestoneList = CM_CampaignDataUtil.getCampaignMilestones(milestoneParentId); 
        // get all materials
        for(integer indx = milestoneList.size() - 1; indx > -1; indx--){
        	Campaign_Milestone__c milestone = milestoneList[indx]; 
    	  	if(milestone.Date__c <> null && milestone.Date__c > System.Today()){
    	  		nextMilestone = milestone;
    	  		break;
    	  	}
    	  }
    	        
    }  
    
}