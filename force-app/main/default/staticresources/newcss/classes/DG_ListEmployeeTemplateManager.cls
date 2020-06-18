// 
// (c) 2014 Appirio, Inc. 
//
// Description : Helper class for trigger on List, List Employee and List Template.
//
// 17 Jan 2014 Rahul Agrawal Original
//
public with sharing class DG_ListEmployeeTemplateManager {
	
    public static void handleListEmployeeTrigger(List<List_Employee__c> triggerNew, boolean isInsert, boolean isUpdate,
                                                        boolean isDelete, boolean isBefore, boolean isAfter){
        map<id, list<List_Template__c>> mapListId_Template = new map<Id, list<List_Template__c>>();
		map<id, list<List_Employee__c>> mapListId_Employee = new map<Id, list<List_Employee__c>>();
        
        for(List_Employee__c emp : triggerNew){
        	if(mapListId_Employee.containsKey(emp.List__c)){
        		mapListId_Employee.get(emp.List__c).add(emp);
        	}else{
        		mapListId_Employee.put(emp.List__c, new list<List_Employee__c>{emp});
        	}
        }
        List<List_Template__c> lstTempList = DG_DataUtil.getListTemplateForAcknowledgement(mapListId_Employee.keySet());
        if(lstTempList.isEmpty()) return;
        
        for(List_Template__c lstTemplate : lstTempList){
        	if(mapListId_Template.containsKey(lstTemplate.List__c)){
                mapListId_Template.get(lstTemplate.List__c).add(lstTemplate);
            }else{
                mapListId_Template.put(lstTemplate.List__c, new list<List_Template__c>{lstTemplate});
            }
        }
        
        list<List_Employee_Template__c> lstEmployeeTemplate = new list<List_Employee_Template__c>();
        for(id listId : mapListId_Employee.keySet()){
        	for(List_Employee__c lstEmp : mapListId_Employee.get(listId)){
        		if(!mapListId_Template.isEmpty()){
	        		for(List_Template__c lstTemplate : mapListId_Template.get(listId)){
	        			lstEmployeeTemplate.add(new List_Employee_Template__c(List_Employee__c = lstEmp.Id, Template__c = lstTemplate.Template__c));
	        		}
        		}
        	}
        }
        if(!lstEmployeeTemplate.isEmpty())
            insert lstEmployeeTemplate;
    }
    
    public static void handleTemplateTrigger(List<List_Template__c> triggerNew, boolean isInsert, boolean isUpdate,
                                                        boolean isDelete, boolean isBefore, boolean isAfter){
        map<id, list<List_Template__c>> mapListId_Template = new map<Id, list<List_Template__c>>();
        map<id, list<List_Employee__c>> mapListId_Employee = new map<Id, list<List_Employee__c>>();
        set<id> listIds = new set<id>();
        for(List_Template__c lstTemplate : triggerNew){
            listIds.add(lstTemplate.Id);
        }
        
        for(List_Template__c lstTemplate : DG_DataUtil.getListTemplateForAcknowledgement(listIds)){
            if(mapListId_Template.containsKey(lstTemplate.List__c)){
                mapListId_Template.get(lstTemplate.List__c).add(lstTemplate);
            }else{
                mapListId_Template.put(lstTemplate.List__c, new list<List_Template__c>{lstTemplate});
            }
        }
        if(mapListId_Template.isEmpty()) return;
        List<List_Employee__c> lstEmpList = DG_DataUtil.getListEmployeesOnListIds(mapListId_Template.keySet());
        if(lstEmpList.isEmpty()) return;
        
        for(List_Employee__c lstEmp : lstEmpList){
            if(mapListId_Employee.containsKey(lstEmp.List__c)){
                mapListId_Employee.get(lstEmp.List__c).add(lstEmp);
            }else{
                mapListId_Employee.put(lstEmp.List__c, new list<List_Employee__c>{lstEmp});
            }
        }
        
        list<List_Employee_Template__c> lstEmployeeTemplate = new list<List_Employee_Template__c>();
        for(id listId : mapListId_Employee.keySet()){
            for(List_Employee__c lstEmp : mapListId_Employee.get(listId)){
                for(List_Template__c lstTemplate : mapListId_Template.get(listId)){
                    lstEmployeeTemplate.add(new List_Employee_Template__c(List_Employee__c = lstEmp.Id, Template__c = lstTemplate.Template__c));
                }
            }
        }
        if(!lstEmployeeTemplate.isEmpty())
            insert lstEmployeeTemplate;
    }
    
    /*public static void handleListTrigger(List<List__c> triggerNew, Map<Id, List__c> triggerOldMap, boolean isInsert, boolean isUpdate,
                                                        boolean isDelete, boolean isBefore, boolean isAfter){
        if(isBefore && (isInsert || isUpdate)){
        	Set<String> nameSet = new Set<String>();
            for(List__c listRecordNew : triggerNew){
            	if(isInsert || (isUpdate && listRecordNew.Name != triggerOldMap.get(listRecordNew.Id).Name)){
            		if(nameSet.contains(listRecordNew.Name)){
            			listRecordNew.addError('List Name already exists in current set of records.');
            		}else{
            			nameSet.add(listRecordNew.Name);
            		}
            	}
            }
        
	        List<List__c> existingLists = DG_DataUtil.getListWithNames(nameSet);
	        nameSet.clear();
	        for(List__c existingListRecord : existingLists){
	        	nameSet.add(existingListRecord.Name);
	        }
	        for(List__c listRecordNew : triggerNew){
	        	if(nameSet.contains(listRecordNew.Name)){
                    listRecordNew.addError('List Name already exists.');
                }
	        }
        }                                                   	
    } */      
}