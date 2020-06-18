public with sharing class FFAP_FA_Account_Association_Manager {

	static List<FA_Account_Association__c> listNewAccAssociations;
	
	public static void handleTrigger(List<FA_Account_Association__c> triggerNew, map<Id,FA_Account_Association__c> triggerOldMap, boolean isInsert, boolean isUpdate,
														boolean isDelete, boolean isBefore){
		listNewAccAssociations = triggerNew;
		Set<Id> agreementIds = new Set<Id>();
		Set<String> empIds = new Set<String>();
		set<Id> setAccountIds = new set<Id>();
		
		for(FA_Account_Association__c faAccAssociation : listNewAccAssociations){
			if(isBefore && isInsert){
				if(faAccAssociation.FA_Account__c <> null) {
					setAccountIds.add(faAccAssociation.FA_Account__c);
				}
				if(faAccAssociation.FFAP_Agreement__c <> null){					
					agreementIds.add(faAccAssociation.FFAP_Agreement__c);
				}else if(faAccAssociation.Financial_Advisor__c <> null){					
                    empIds.add(faAccAssociation.Financial_Advisor__c);
				}
			}			
		}	
		
		if(!agreementIds.isEmpty() || !empIds.isEmpty()){
			syncAgreementAndAdvisorField(agreementIds, empIds);
		}
		
		if(!setAccountIds.isEmpty()){
			validateFAAccountAssociation(setAccountIds);
		}
	}	
	
	private static void syncAgreementAndAdvisorField(Set<Id> agreementIds, Set<String> empIds){
		map<Id, FFAP_Agreement__c> mapAgreement = new map<Id, FFAP_Agreement__c>();
		map<Id, FFAP_Agreement__c> mapEmpRecordIdAgreement = new map<Id, FFAP_Agreement__c>();
		if(!agreementIds.isEmpty()){			
			mapAgreement = new map<Id, FFAP_Agreement__c>(FFAP_DataUtil.getAgreementDetailsOnAgreementIds(agreementIds));
		}
		if(!empIds.isEmpty()){
			mapEmpRecordIdAgreement = FFAP_DataUtil.getAgreementDetailsOnEmpRecordId(empIds);
		}
		Id agreementId;
        Id financialAdvisorId;
		for(FA_Account_Association__c faAccAssociation : listNewAccAssociations){
			agreementId = faAccAssociation.FFAP_Agreement__c;
			financialAdvisorId = faAccAssociation.Financial_Advisor__c;
			if(agreementId <> null && mapAgreement.containsKey(agreementId)){
				faAccAssociation.Financial_Advisor__c = mapAgreement.get(agreementId).Employee__c;
			}else if(financialAdvisorId <> null && mapEmpRecordIdAgreement.containsKey(financialAdvisorId)){
				faAccAssociation.FFAP_Agreement__c = mapEmpRecordIdAgreement.get(financialAdvisorId).Id;
			}
		}															
	}
	
	private static void validateFAAccountAssociation(set<Id> setAccountIds){
		map<Id, set<Id>> mapAccountIdSetAdvisorIds = new map<Id, set<Id>>();
		map<Id, set<Id>> mapAccountIdSetAgreementIds = new map<Id, set<Id>>();
		Id accountId;
		Id advisorId;
		Id agreementId;
		for(FA_Account_Association__c faAccAssociation : FFAP_DataUtil.getFAAccAssociationListOnFAAccountId(setAccountIds)){
			accountId = faAccAssociation.FA_Account__c;
			advisorId = faAccAssociation.Financial_Advisor__c;
			agreementId = faAccAssociation.FFAP_Agreement__c;
			if(accountId <> null){
				if(advisorId <> null){
			 
					if(mapAccountIdSetAdvisorIds.containsKey(accountId)){
						mapAccountIdSetAdvisorIds.get(accountId).add(advisorId);
					}else{
						mapAccountIdSetAdvisorIds.put(accountId, new set<Id>{advisorId});
					}
				}
				if(agreementId <> null){
					if(mapAccountIdSetAgreementIds.containsKey(agreementId)){
						mapAccountIdSetAgreementIds.get(accountId).add(agreementId);
					}else{
						mapAccountIdSetAgreementIds.put(accountId, new set<Id>{agreementId});
					}
				}
			}
			
		}
		
		for(FA_Account_Association__c faAccAssociation : listNewAccAssociations){
			accountId = faAccAssociation.FA_Account__c;
			advisorId = faAccAssociation.Financial_Advisor__c;
			agreementId = faAccAssociation.FFAP_Agreement__c;
			if(accountId <> null && 
					(mapAccountIdSetAdvisorIds.containsKey(accountId) && mapAccountIdSetAdvisorIds.get(accountId).contains(advisorId)) || 
					( mapAccountIdSetAgreementIds.containsKey(accountId) && mapAccountIdSetAgreementIds.get(accountId).contains(agreementId))){
				faAccAssociation.addError('This advisor is already added in this account ' + accountId + ' advisorId ' + advisorId);
			}
		}
		
	}
														
		
}