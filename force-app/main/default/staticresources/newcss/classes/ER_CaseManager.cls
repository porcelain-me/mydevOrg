// Description : Manager class for ER_Case Trigger on Case__c Object.
// Updates :
//
// 10/23/2013 : MG : No need to do category validation as heading categories have been removed. Now there will be only plain text values in picklist. HRFORCE-311
/* Change Log */
/* 12/26/14 - MRM Added fast add option to create parties invovled automatically */

public with sharing class ER_CaseManager {

    public static void handleTrigger(List<Case__c> newCases, map<Id,Case__c> mapOldCases, boolean isInsert, boolean isUpdate,
                                                        boolean isDelete, boolean isBefore){
        // check when creating a case status Open
        map<id, RecordType> mapRT = new map<id, RecordType>([Select r.Name, r.Id From RecordType r where SobjectType = 'Case__c']); 
        if(isBefore && isInsert){
            for (Case__c c : newCases){    
                if (c.Status__c != 'Open' && mapRT.containsKey(c.RecordTypeId) && mapRT.get(c.RecordTypeId).Name == 'HR')
                    c.addError(Label.ER_CaseStatusOpenForHR);
           }                                                     
        }
        /* MRM fast add logic */
        if (!isBefore && isInsert){
            Map<String,ID> rIPTypeMap = new Map<String,ID>();
            Map<String,ID> rCaseTypeMap = new Map<String,ID>();
            Map<ID,String> rCaseTypeMapById = new Map<ID,String>();
            List<RecordType> rList = [Select r.SobjectType, r.Id, r.DeveloperName From RecordType r where SobjectType in ('Parties_Involved__c','Case__c')];
            for (RecordType r:rList)
                if (r.sObjectType == 'Parties_Involved__c')
                    rIPTypeMap.put(r.developername,r.id);
                else{
                    rCaseTypeMap.put(r.developername,r.id);
                    rCaseTypeMapById.put(r.id,r.developername);
                }
    
            List<Parties_Involved__c> iList = new List<Parties_Involved__c>();
            Set <ID> empSet = new Set<ID>();
            Map <ID,Employee__c> empMap;
            
            for (Case__c c: newCases){
                empSet.add(c.fast_add_person__c);
            }
            empMap = new Map<ID,Employee__c>([select id, name, emp_id__c, login_id_directory__c from Employee__c where id in:empSet]);
                    
            for (Case__c c: newCases){
                ID recordtypeid;
                if (rCaseTypeMapById.get(c.recordtypeid) == 'HR')
                    recordTypeId = rIPTypeMap.get('HR_Parties_Involved');
                else
                    recordTypeId = rIPTypeMap.get('Compliance_Parties_Involved');
                    
                if (c.fast_add_person__c != null){
                
                    Parties_Involved__c pi = new Parties_Involved__c(case__c = c.id
                                , recordtypeid = recordTypeid
                                , role__c = 'Subject of Complaint/Issue'
                                , person__c = c.fast_add_person__c
                                , party_full_name__c = empMap.get(c.fast_add_person__c).name
                                , emp_id__c = empMap.get(c.fast_add_person__c).emp_id__c
                                , Is_a_trigger_record__c = true
                                , party_name__c = empMap.get(c.fast_add_person__c).name + '|' + empMap.get(c.fast_add_person__c).emp_id__c + '|' + empMap.get(c.fast_add_person__c).login_id_directory__c);
                    iList.add(pi);
                }
            }
            if (iList.size() > 0){
                insert iList;
                
            }  
           
        }
        
         
    }
    
    // 4-Nov-2016 : ALM# : Changes for 
    // method to update the Parties Involved record with the updated Employee name
    public static void updateExistingParties(Map<Id,Case__c> caseOldMap, Map<Id,Case__c> caseNewMap){
        Set<Id> allCaseIds = caseNewMap.keySet(); // get all Case Ids
        List<Parties_Involved__c> partyInvUpdateList = new List<Parties_Involved__c>();
        Map<Id,Employee__c> empMap;
        Set<Id> empSet = new Set<Id>();
        for(Case__c c: caseNewMap.values()){
            empSet.add(c.fast_add_person__c);
        }
        empMap = new Map<ID,Employee__c>([select id, name, emp_id__c, login_id_directory__c from Employee__c where id in:empSet]);
        // get all the existing parties involved details
        List<Parties_Involved__c> partiesInvDetails = [SELECT Id, Case__c, recordtypeid, role__c, person__c, party_full_name__c, emp_id__c, party_name__c FROM Parties_Involved__c WHERE Case__c IN : allCaseIds AND Is_a_trigger_record__c= true];
        if(!partiesInvDetails.isEmpty()){
            for(Case__c newCase: caseNewMap.values()){ // each new Case
                for(Parties_Involved__c parInv : partiesInvDetails){ // each queried party involved
                    if(newCase.Id == parInv.Case__c){ // the case's corresponding party inv. record
                        if(caseOldMap.get(newCase.Id).fast_add_person__c != newCase.fast_add_person__c){
                        parInv.person__c = newCase.fast_add_person__c;
                        parInv.party_full_name__c = empMap.get(newCase.fast_add_person__c).name;
                        parInv.emp_id__c = empMap.get(newCase.fast_add_person__c).emp_id__c;
                        parInv.party_name__c = empMap.get(newCase.fast_add_person__c).name + '|' + empMap.get(newCase.fast_add_person__c).emp_id__c + '|' + empMap.get(newCase.fast_add_person__c).login_id_directory__c;
            
                        partyInvUpdateList.add(parInv);
                        system.debug('@@@@@@@@'+partyInvUpdateList);
                        }
                    }
                }
            }
        }
        if(!partyInvUpdateList.isEmpty()){
            update partyInvUpdateList;
        }
    }
    
}