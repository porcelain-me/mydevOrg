/***********************************************************************************
Name        : TargetListHelper 
Author      : Appirio Offshore (Parth Tamhaney)
Date        : Dec 06, 2010
Description : Helper Class for Target List Operations 
Related PR  : PR-07362 (To Fix Too Many DML Rows Exception)
Modified:

************************************************************************************/

global without sharing class TargetListHelper {
	
	//future method called from trigger UpdateTargetListMembersExclusion on Exclusion__c (after insert)
	//This method Updates the targetListMembers for for Exclusions
	//Parameters:
	//@CampaignIds - Set of Campaign Ids 
	//@AccountIds - Set Of AccountIds
	//@setExclusions - Set string of format: CampaignId_AccountId_ExclusionString
	@future global static void excludeTargetListMembers(Set<Id> CampaignIds, Set<Id> AccountIds, Set<string> setExclusions) {
   		
   		List<Target_List_Member__c> listMembersToUpdate = new  List<Target_List_Member__c>();
		String keyCampAcc = '';
		Set<String> set_exclusions= new Set<String>();
		
		//Map to store set of Exclusions for a Combination of Campaign and Account
		Map<string,Set<string>> mapExclusions = new Map<string,Set<string>>();
	
		for(String strExc : setExclusions){
			//Split 'CampaignId_AccountId_ExclusionString' by '_'
			String[] strSplit = strExc.split('_');
			//Create Set Of Exclusions and add to Map (Key: CampaignId_AccountId)
			keyCampAcc = strSplit[0] + '_' + strSplit[1] ;
			set_exclusions = new Set<string>{strSplit[2]};
			if(mapExclusions.ContainsKey(keyCampAcc)){
				set_exclusions = mapExclusions.get(keyCampAcc);
				set_exclusions.add(strSplit[2]);
			}
			
			mapExclusions.put(keyCampAcc,set_exclusions);
			
		}
		
		//Retrieve All TargetListMembers to be Updated
		
		for(	List<Target_List_Member__c> listMembers : [Select t.Target_List__r.iiCampaign__c, t.Target_List__c, t.GPSContact__r.GPSAccount__c, t.GPSContact__c From Target_List_Member__c t
													where Target_List__r.iiCampaign__c in :CampaignIds
													  and GPSContact__r.GPSAccount__c in :AccountIds]){
			
			System.debug('______________listMembers.size()__' + listMembers.size());
			for(Target_List_Member__c tlm : listMembers){
				keyCampAcc = tlm.Target_List__r.iiCampaign__c + '_' + tlm.GPSContact__r.GPSAccount__c ;
				set_exclusions = mapExclusions.get(keyCampAcc);
				for(string reason : set_exclusions){
					if(reason.toLowerCase() == 'contacts do not get email'){
						tlm.Eligible_for_email__c = false;
					}
					else if(reason.toLowerCase() == 'exclude from campaign'){
						tlm.Removed_Reason__c = 'Account does not vote in II Campaign';
						tlm.Eligible_for_email__c = false;
					}
				}
			}
			//Update in Batches of 200
			if(listMembersToUpdate.size()>=200){
				update listMembersToUpdate;
				listMembersToUpdate.clear();
			}
			
			listMembersToUpdate.addAll(listMembers);
				
		}
		//Update Remaining 
		System.debug('__________________listMembersToUpdate.size()__' + listMembersToUpdate.size());
		if(listMembersToUpdate.size() >0){
			update listMembersToUpdate;
		}
    }	
}