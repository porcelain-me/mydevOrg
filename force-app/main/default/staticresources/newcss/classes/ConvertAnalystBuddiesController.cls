// copyright 2010 Appirio
//
// 12/10/2010    Chetan Garg : ORIGINAL 
// 12 Jan 2011   Kapil Choudhary For PR-07915 Strip the campaign code from cadidate's msid field if the lenght of the field is greater than 5 chars.
//
//

public with sharing class ConvertAnalystBuddiesController {
  public iiCampaign__c currentCampaign {get;set;}	
  public List<CandidateItem> listCandidateItems {get;set;}
  public ConvertAnalystBuddiesController(ApexPages.StandardController controller){  	
    currentCampaign = (iiCampaign__c)controller.getRecord();
    String campaignCode = currentCampaign.Campaign_Name__c;    
    transient List<Candidate_Information__c> listCandidates = [Select c.MSID__c, c.Id, c.Candidate_Name__c,
        ( Select Id, GPSContact__c, Status__c From Analyst_Buddies__r where (Status__c <>'Converted'))
      From Candidate_Information__c c Where iiCampaign__c = :currentCampaign.id];
           
    transient Map<String,Target_List__c> mapTargetListMapWithMsId = getAllTargetListMapWithMsId();
    listCandidateItems= new List<CandidateItem>();
    for(Candidate_Information__c candidateInf: listCandidates){
      if(candidateInf.Analyst_Buddies__r.size()>0){
      	 Target_List__c thisTargetList;
      	 if(candidateInf.MSID__c != null){
      	 	String stripedMsid = candidateInf.MSID__c;
      	 	///Check lenght of candidateInf.MSID__c if greater than 5 then remove CanidateCode from MSID
      	 	//thisTargetList = mapTargetListMapWithMsId.get(candidateInf.MSID__c);
      	 	system.debug('_____________currentCampName__'+ campaignCode);
      	 	system.debug('_____________candidateInf.MSID__c__'+ candidateInf.MSID__c);
      	 	if(candidateInf.MSID__c.length()>5 && candidateInf.MSID__c.length() > campaignCode.length()){
      	 	  	stripedMsid = candidateInf.MSID__c.substring(campaignCode.length());
      	 	  }
      	 	
      	 	system.debug('_____________stripedMsid__'+ stripedMsid);
      	 	
      	 	thisTargetList = mapTargetListMapWithMsId.get(stripedMsid);
      	 }	 
        listCandidateItems.add(new CandidateItem(candidateInf,thisTargetList) );
      }
    }
  }
	
  private Map<String,Target_List__c> getAllTargetListMapWithMsId(){
    Map<String,Target_List__c> mapTargetListMapWithMsId = new Map<String,Target_List__c>();
    for(Target_List__c targetlist : [Select id, MSID__c, User__r.Name, Preferred_User__c FROM Target_List__c Where iiCampaign__c = :currentCampaign.id]){
      mapTargetListMapWithMsId.put(targetlist.MSID__c,targetlist);
    }
    return mapTargetListMapWithMsId;
  }
  
  //Action Method : create Target List Members for selected candidate's Analyst Buddies.
  public void convertAnalystBuddies(){
  	try{
  	  List<Analyst_Buddy__c> analystBuddiesConverted = new List<Analyst_Buddy__c>();
  	  List<Target_List_Member__c> newTargetListMembers = new List<Target_List_Member__c>();
  	  
  	  for(Integer index = 0 ; index < listCandidateItems.size() ; index++ ){
  	    CandidateItem item = listCandidateItems.get(index);	
  	    if(item.isSelected == true && item.isDisabled == false){
  	    	for(Analyst_Buddy__c analystBuddy : item.candidate.Analyst_Buddies__r){
  	    	  analystBuddiesConverted.add(new Analyst_Buddy__c(id = analystBuddy.id,
  	    	  				Status__c = 'Converted'));
  	    	  
  	    	  newTargetListMembers.add( new Target_List_Member__c( Target_List__c = item.targetlist.id,
	  	     							Target_List_Status__c ='Call & Confirm vote',
	  	     							GPSContact__c = analystBuddy.GPSContact__c, Eligible_for_email__c = True));	
  	    	}
  	    	
  	    	listCandidateItems.remove(index);
  	    	index--;
  	    }
  	  }
  	  
  	  update analystBuddiesConverted;
  	  insert newTargetListMembers;
  	}catch(Exception exp){
    	System.debug('________________CAUGHT EXCEPTION IN ConvertAnalystBuddiesController convertAnalystBuddies _____________________');
		//Util.HANDLE_ERROR(exp);
    } 
    
  }
	
  public class CandidateItem{
    public boolean isSelected{get;set;}
    public boolean isDisabled {get;set;}
    public Candidate_Information__c candidate{get;set;}
    public Integer cntUnconvertedBuddies{get;set;}
    public Target_List__c targetlist{get;set;}
    
    public CandidateItem(Candidate_Information__c CandidateInf,Target_List__c targetlist){
      candidate = CandidateInf;
      this.targetlist = targetlist;
      cntUnconvertedBuddies = candidate.Analyst_Buddies__r.size();
      if(targetlist!= null){
        isSelected = true;
        isDisabled = false;
      }else{
        isSelected = false;
        isDisabled = true;	
      }	
    }
  }
}