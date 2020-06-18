//  
//  10/11/2011 UV: ORIGINAL 
//                 Manager class for CampaignMemberResponseManagement.trigger    
//
//03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.
public without sharing class CM_CampaignMemberResponseManager {
    
    public static void updateCampaignMemberAssignments(List<Campaign_Member_Assignment__c> insertedCMAs) {
        Set<Id> campaignIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        String separator = '|';
        ////03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.
        //List<CampaignMember> cmList = new List<CampaignMember>();
        
        List<Campaign_Member__c> cmList = new List<Campaign_Member__c>();
        
        ////03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.
        //Map<String, CampaignMember> cmMap = new Map<String, CampaignMember>();
        
        Map<String, Campaign_Member__c> cmMap = new Map<String, Campaign_Member__c>();
        
        for(Campaign_Member_Assignment__c cma : insertedCMAs) {
             campaignIds.add(cma.Campaign__c);
            contactIds.add(cma.GPSContact__c);
        }
       cmList = CM_CampaignDataUtil.getAllCampaignMemberList(contactIds, CampaignIds);   
       for(Campaign_Member__c cm : cmList) {
       	//03/04/2016 AT: Moving to Platform Licenses, replacing Campaign, CampaignMember standard object with custom objects.
       	//String key = cm.Campaignid + separator + cm.Contactid;
            String key = cm.Campaign__c + separator + cm.GPSContact__c;
            cmMap.put(key,cm);
       }
       for(Campaign_Member_Assignment__c cma : insertedCMAs) {
            String key =  cma.Campaign__c + separator + cma.GPSContact__c;
            Campaign_Member__c cm;
            if(cmMap.containsKey(key)) {
                cm = cmMap.get(key);
                CM_CampaignDataUtil.copyCampaignMemberFieldsToCMA(cma, cm);    
            }
        }
    }
}