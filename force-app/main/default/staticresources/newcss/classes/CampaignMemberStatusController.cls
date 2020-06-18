public with sharing class CampaignMemberStatusController {
    
    public Campaign__c campaign { get; set; }
    public CampaignMemberStatus__c memberStatus { get; set; }
    public List<CampaignMemberStatus__c> editlistmemberStatus { get; set; }
    public List<CampaignMemberStatus__c> memberStatuses { get; set; }
    public boolean viewOnly { get; set; }
    public Boolean editMode{get;set;}
    public Boolean SaveMode{get;set;}
    public Boolean replaceMode{get;set;}
    public String selectedstatus {set;get;}
    public String changedValue {set;get;}
    public String campaignId {set;get;}
    
    public List<SelectOption> getStatusValues() {
    	
    	List<SelectOption> options = new List<SelectOption>();
    	Schema.DescribeFieldResult fieldResult =
 		Campaign_Member__c.Status__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
   		     options.add(new SelectOption('--Select--','--Select--')); 
   		for( Schema.PicklistEntry f : ple)
   		{
      		options.add(new SelectOption(f.getLabel(), f.getValue()));
   		}       
   		return options;
    }
     
    
    public CampaignMemberStatusController(){
        memberStatuses = new List<CampaignMemberStatus__c>();
        editlistmemberStatus = new List<CampaignMemberStatus__c>();

        viewOnly = true;
        replaceMode = false;
        campaignId = ApexPages.currentPage().getParameters().get('cid');
        
        campaign = [SELECT Id, Name, Active__c, Status__c, Type__c FROM Campaign__c WHERE Id=: campaignId LIMIT 1];
            
        memberStatuses = [SELECT Name, Campaign__c, Campaign__r.Name, Active__c, HasResponded__c, IsDefault__c, Status__c, Type__c FROM CampaignMemberStatus__c WHERE Campaign__c =: campaignId];
        
        if(!memberStatuses.isEmpty())
            memberStatus = memberStatuses[0];
        

    }
    
    public List<SelectOption> StatusList
    {
        get
        {
           
            StatusList = new List<SelectOption>();
            
            for(CampaignMemberStatus__c temp : memberStatuses)
            {
                StatusList.add(new SelectOption(temp.Name, temp.Name));
            }
            return StatusList;
        }
        set;
    }
    
    public void addRow(){
        editlistmemberStatus.add(new CampaignMemberStatus__c());
    }
    
    public void editMember() {
    editlistmemberStatus.clear();
        //editlistmemberStatus = memberStatuses;
        editlistmemberStatus.addall(memberStatuses);
        viewOnly = false;
        editMode = true;
    } 
    
    public void CanceleditMember() {
    editlistmemberStatus.clear();
        viewOnly = true;
        editMode = false;
        replaceMode = false;
        refresh();
    }
    
    public void ReplaceMember() {
        viewOnly = false;
        replaceMode = true;
    }
    public void refresh(){
       campaign = [SELECT Id, Name, Active__c, Status__c, Type__c FROM Campaign__c WHERE Id=: campaignId LIMIT 1];
            
       memberStatuses = [SELECT Name, Campaign__c, Campaign__r.Name, Active__c, HasResponded__c, IsDefault__c, Status__c, Type__c FROM CampaignMemberStatus__c WHERE Campaign__c =: campaignId];
        
       if(!memberStatuses.isEmpty())
            memberStatus = memberStatuses[0]; 
    }
    public PageReference saveAndReturn()
    {
        system.debug(memberStatuses);
        //update memberStatuses;
        Boolean IsErrorStatusFlag = false; 
        String campaignId = ApexPages.currentPage().getParameters().get('cid');
        list<Campaign_Member__c>CampaignMem = new list<Campaign_Member__c>();
        CampaignMem =[SELECT Name, Campaign__c , Status__c, HasResponded__c FROM Campaign_Member__c WHERE Campaign__c =: campaignId];
        List<Campaign_Member__c> memberToUpdate = new List<Campaign_Member__c>();
        for(CampaignMemberStatus__c checkStatus : editlistmemberStatus ){
        if(checkStatus.Name == '--Select--')
        {
        	ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a valid Status');
        	ApexPages.addMessage(errMsg);
        	IsErrorStatusFlag = true;
        	break;
        }
        
        }
        
        if(IsErrorStatusFlag == false)
        {
        for(CampaignMemberStatus__c memStatus : editlistmemberStatus ){
            for(Campaign_Member__c cm: CampaignMem){
                if(memStatus.Name == cm.Status__c && memStatus.HasResponded__c != cm.HasResponded__c){
                    cm.HasResponded__c = memStatus.HasResponded__c;
                    memberToUpdate.add(cm);
                } 
            }
            memStatus.Campaign__c = campaignId;
        }update memberToUpdate;
        
        
        system.debug('editlistmemberStatus'+editlistmemberStatus);
        try{
        	
           upsert editlistmemberStatus;
        }catch(Exception e){
            
            ApexPages.addMessages(e);
            return null;
        }
        
        system.debug('CampaignMem'+CampaignMem);
        viewOnly = true;
        editMode = false;
        replaceMode = false;
        refresh();
    }
        return null;
    } 
    
    
    public void SaveReplace()
    {
        system.debug(selectedstatus);
        //update memberStatuses;
        system.debug(changedValue);
        String campaignId = ApexPages.currentPage().getParameters().get('cid');
        list<Campaign_Member__c>CampaignMem = new list<Campaign_Member__c>();
        CampaignMem =[SELECT Name, Campaign__c , Status__c, HasResponded__c FROM Campaign_Member__c WHERE Campaign__c =: campaignId AND Status__c =:changedValue];
        List<Campaign_Member__c> memberToUpdate = new List<Campaign_Member__c>();
        for(Campaign_Member__c cm: CampaignMem){
           cm.Status__c = selectedstatus;
           memberToUpdate.add(cm);
        } 
        update memberToUpdate;
        String msg = 'You have replaced '+ changedValue +' to '+ selectedstatus+' in  record(s), possibly including records in the recycle bin.';
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, msg));
        viewOnly = true;
        editMode = false;
        replaceMode = false;
        refresh();
        //return null;
    }
}