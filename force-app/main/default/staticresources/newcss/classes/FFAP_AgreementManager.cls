/******************************************
10/15/2013 : MG : ORIGINAL

Description : Manager class for Trigger on FFAP_Agreement Object.

*******************************************/
public with sharing class FFAP_AgreementManager {
    
    static list<FFAP_Agreement__c> listFFAPAgreement;

    public static void handleTrigger(List<FFAP_Agreement__c> triggerNew, List<FFAP_Agreement__c> Triggerold, map<Id, FFAP_Agreement__c> triggerOldMap, boolean isInsert, boolean isUpdate,
                                                        boolean isDelete,boolean isUnDelete, boolean isBefore){    
                                                        
        map<String, String> mapEmpIdAgreementId = new map<String, String>();
        Set<Id> EmpIds = new Set<Id>();
        listFFAPAgreement = triggerNew;
        if(!(isDelete)){
            for(FFAP_Agreement__c agreement : triggerNew){
                mapEmpIdAgreementId.put(agreement.Employee__c, agreement.Id);
            }
        }
        
        if(!isBefore && isInsert){
            // check and update account association record with agreement id.
            checkAndUpdateRelatedAccountAssociationsWithAgreementId(mapEmpIdAgreementId);
        }
        
        if(isBefore && isInsert){
            // check if an agreement already created for employee
            validateAgreementCreation(mapEmpIdAgreementId.keySet());
        }
        if(isBefore && isDelete){
            // check if an FFAP Agreement record deleted for employee
            for(FFAP_Agreement__c agreement : triggerold){
                EmpIds.add(agreement.Employee__c);
            } 
            if(!EmpIds.isEmpty())
                validateFFAP_AgreementDeletion(EmpIds);
            
        }        
                                                            
        
    }
    
    private static void validateAgreementCreation(set<String> employeeIds){
        set<Id> setExistingAgreementEmpIds = new set<id>();
        for(FFAP_Agreement__c existingAgreement : FFAP_DataUtil.getFFAPAgreementOnEmpRecordIds(employeeIds)){
            setExistingAgreementEmpIds.add(existingAgreement.Employee__c);
        }
        
        for(FFAP_Agreement__c newAgreement : listFFAPAgreement){
            if(setExistingAgreementEmpIds.contains(newAgreement.Employee__c)){
                newAgreement.addError(Label.FFAP_Agreement_Already_Created_Error);
            }
        }
    }
    
    private static void checkAndUpdateRelatedAccountAssociationsWithAgreementId(map<String, String> mapEmpIdAgreementId){
        boolean isUpdated = false;
        List<FA_Account_Association__c> accAssociations = FFAP_DataUtil.getFAAccAssociationListonOnAdvisorIds(mapEmpIdAgreementId.keySet());
        
        for(FA_Account_Association__c accAssociation : accAssociations){
            isUpdated = true;
            accAssociation.FFAP_Agreement__c = mapEmpIdAgreementId.get(accAssociation.Financial_Advisor__c);
        }
        
        if(isUpdated){
            try{
                update accAssociations;
            }catch(exception ex){
                system.debug('Unable to update due to following exception ' + ex.getMessage());
            }
        }
    }
    
    private static void validateFFAP_AgreementDeletion(set<Id> employeeIds){
        boolean isDeleted = false;
        List<Employee__c> Emplist = FFAP_DataUtil.getEmployeeDetailsOnId(employeeIds);
        for(Employee__c emp : Emplist){
            isDeleted = true;
            emp.Commitment_Status__c = 'Not Signed';  
        }
        if(isDeleted){
            try{
                update Emplist;
            }catch(exception ex){
                system.debug('Unable to update due to following exception ' + ex.getMessage());
            }
        }
    
    
    }
    
    
}