/*
09/18/2013 : MG : ORIGINAL
Description : Controller class for ER_CaseRelatedCases Page.
*/
public without sharing class ER_CaseRelatedCases {
	
	private final String caseId;
	public String newRelatedCasePageURL{get;set;}
	public string relatedCaseIdToDelete {get;set;}
	private static final String NEW_RELATED_CASE_PAGE_URL = '/' + Related_Cases__c.SObjectType.getDescribe().getKeyPrefix() + '/e?' + 
															Label.ER_RelatedCase_CaseLookupId + '=<CASENAME>&' + 
															Label.ER_RelatedCase_CaseLookupId + '_lkid=<CASEID>'+
															'&retURL=%2F<CASEID>';
	
	public ER_CaseRelatedCases(ApexPages.StandardController caseStdController){
		this.caseId = caseStdController.getId();
		Case__c caseRecord = ER_DataUtil.getCaseDetails(caseId);
		
		relatedCaseIdToDelete = '';
		
		newRelatedCasePageURL = NEW_RELATED_CASE_PAGE_URL.replaceAll('<CASEID>', caseId).replace('<CASENAME>', caseRecord.Name);
	}
	// get list of related cases
	public list<CaseRelatedCaseWrapper> getRelatedCasesList(){
		list<CaseRelatedCaseWrapper> listRelatedCases = new list<CaseRelatedCaseWrapper>();
		set<Id> setRelatedCaseIds = new set<Id>();
		for(Related_Cases__c rc : ER_DataUtil.getRelatedCasesOnCaseId(caseId)){
				if(rc.Related_Case__c <> caseId && !setRelatedCaseIds.contains(rc.Related_Case__c)){
					listRelatedCases.add(new CaseRelatedCaseWrapper(rc, rc.Related_Case__c, rc.Related_Case__r.Name));
					setRelatedCaseIds.add(rc.Related_Case__c);
				}else if(rc.Case__c <> caseId && !setRelatedCaseIds.contains(rc.Case__c)){
					listRelatedCases.add(new CaseRelatedCaseWrapper(rc, rc.Case__c, rc.Case__r.Name));
					setRelatedCaseIds.add(rc.Case__c);
				}
			
		}
		return listRelatedCases;
	}
	
	public void deleteRelatedCase(){
		if(relatedCaseIdToDelete != Null && relatedCaseIdToDelete != ''){
			try{
                Related_Cases__c relatedCase = new Related_Cases__c(id=relatedCaseIdToDelete);
                delete relatedCase;
			}
			catch(DMlException ex){
				ApexPages.addMessages(ex);
			}
		}
	}
	
	public class CaseRelatedCaseWrapper{
		public Id relatedCaseId{get;set;}
		public String relatedCaseName{get;set;}
		public Related_Cases__c relatedCaseRecord{get;set;}
		
		public CaseRelatedCaseWrapper(Related_Cases__c relatedCaseRecord, Id relatedCaseId, String relatedCaseName){
			this.relatedCaseId = relatedCaseId;
			this.relatedCaseRecord = relatedCaseRecord;
			this.relatedCaseName = relatedCaseName;
		}
	}
	
}